package main

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"log"
	"net/http"

	"github.com/google/uuid"
	"github.com/hashicorp/terraform-plugin-sdk/v2/diag"
	"github.com/hashicorp/terraform-plugin-sdk/v2/helper/schema"
	"github.com/hashicorp/terraform-plugin-sdk/v2/plugin"
)

func main() {
	plugin.Serve(&plugin.ServeOpts{
		ProviderFunc: Provider,
	})

	// Format.Printline
	fmt.Println("Hello, world!")
}

type Config struct {
	Endpoint string
	Token    string
	UserUuid string
}

func Provider() *schema.Provider {
	var p *schema.Provider
	p = &schema.Provider{
		ResourcesMap: map[string]*schema.Resource{
			"terratowns_home": Resource(),
		},
		DataSourcesMap: map[string]*schema.Resource{},
		Schema: map[string]*schema.Schema{
			"endpoint": {
				Type:        schema.TypeString,
				Required:    true,
				Description: "The endpoint for the external service",
			},
			"token": {
				Type:        schema.TypeString,
				Sensitive:   true,
				Required:    true,
				Description: "Bearer token for authorization",
			},
			"user_uuid": {
				Type:         schema.TypeString,
				Required:     true,
				Description:  "UUID for configuration",
				ValidateFunc: validateUUID,
			},
		},
	}
	p.ConfigureContextFunc = providerConfigure(p)
	return p
}

func validateUUID(v interface{}, k string) (ws []string, errors []error) {
	log.Print("validateUUID:start")
	value := v.(string)
	if _, err := uuid.Parse(value); err != nil {
		errors = append(errors, fmt.Errorf("invalid UUID format"))
	}
	log.Print("validateUUID:end")
	return
}

func providerConfigure(p *schema.Provider) schema.ConfigureContextFunc {
	return func(ctx context.Context, d *schema.ResourceData) (interface{}, diag.Diagnostics) {
		log.Print("providerConfigure:start")
		config := Config{
			Endpoint: d.Get("endpoint").(string),
			Token:    d.Get("token").(string),
			UserUuid: d.Get("user_uuid").(string),
		}
		log.Print("providerConfigure:end")
		return &config, nil
	}
}

func Resource() *schema.Resource {
	log.Print("Resource:start")
	resource := &schema.Resource{
		CreateContext: resourceHouseCreate,
		ReadContext:   resourceHouseRead,
		UpdateContext: resourceHouseUpdate,
		DeleteContext: resourceHouseDelete,
		Schema: map[string]*schema.Schema{
			"name": {
				Type:        schema.TypeString,
				Required:    true,
				Description: "Name of Home",
			},
			"description": {
				Type:        schema.TypeString,
				Required:    true,
				Description: "Description of Home",
			},
			"domain_name": {
				Type:        schema.TypeString,
				Required:    true,
				Description: "Domain name of Home eg. *.cloudfront.net",
			},
			"town": {
				Type:        schema.TypeString,
				Required:    true,
				Description: "The town to which the Home will belong to",
			},
			"content_version": {
				Type:        schema.TypeInt,
				Required:    true,
				Description: "Content Version of the Home",
			},
		},
	}
	log.Print("Resource:end")
	return resource
}

func resourceHouseCreate(ctx context.Context, d *schema.ResourceData, m interface{}) diag.Diagnostics {
	log.Print("resourceHouseCreate:start")
	var diags diag.Diagnostics
	config := m.(*Config)

	payload := map[string]interface{}{
		"name":            d.Get("name").(string),
		"description":     d.Get("description").(string),
		"town":            d.Get("town").(string),
		"domain_name":     d.Get("domain_name").(string),
		"content_version": d.Get("content_version").(int),
	}

	payloadBytes, err := json.Marshal(payload)

	if err != nil {
		return diag.FromErr(err)
	}

	// Contruct the HTTP request
	url := config.Endpoint + "/api/u/" + config.UserUuid + "/homes"
	log.Print("URL:" + url)

	req, err := http.NewRequest("POST", url, bytes.NewBuffer(payloadBytes))
	if err != nil {
		return diag.FromErr(err)

	}

	// Set Headers
	req.Header.Set("Authorization", "Bearer "+config.Token)
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Accept", "application/json")

	client := http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		return diag.FromErr(err)
	}
	defer resp.Body.Close()

	// Parse response JSON
	var responseData map[string]interface{}
	if err := json.NewDecoder(resp.Body).Decode(&responseData); err != nil {
		return diag.FromErr(err)
	}

	// StatusOK = 200 HTTP Response Code
	if resp.StatusCode != http.StatusOK {
		return diag.FromErr(fmt.Errorf("failed to create house resource, status_code: %d, status: %s, body %s", resp.StatusCode, resp.Status, responseData))
	}
	// Handle response status

	homeUUID := responseData["uuid"].(string)
	d.SetId(homeUUID)

	log.Print("resourceHouseCreate:end")

	return diags
}

func resourceHouseRead(ctx context.Context, d *schema.ResourceData, m interface{}) diag.Diagnostics {
	log.Print("resourceHouseRead:start")
	var diags diag.Diagnostics
	config := m.(*Config)
	homeUUID := d.Id()
	// Contruct the HTTP request
	url := config.Endpoint + "/api/u/" + config.UserUuid + "/homes/" + homeUUID
	log.Print("URL:" + url)

	req, err := http.NewRequest("GET", url, nil)
	if err != nil {
		return diag.FromErr(err)

	}

	// Set Headers
	req.Header.Set("Authorization", "Bearer "+config.Token)
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Accept", "application/json")

	client := http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		return diag.FromErr(err)
	}
	defer resp.Body.Close()

	var responseData map[string]interface{}

	// StatusOK = 200 HTTP Response Code
	if resp.StatusCode == http.StatusOK {
		// Parse response JSON
		if err := json.NewDecoder(resp.Body).Decode(&responseData); err != nil {
			return diag.FromErr(err)
		}
		d.Set("name", responseData["name"].(string))
		d.Set("description", responseData["description"].(string))
		d.Set("domain_name", responseData["domain_name"].(string))
		d.Set("content_version", responseData["content_version"].(float64))
	} else if resp.StatusCode == http.StatusNotFound {
		d.SetId("")
	} else if resp.StatusCode != http.StatusOK {
		return diag.FromErr(fmt.Errorf("failed to read home resource, status_code: %d, status: %s, body %s", resp.StatusCode, resp.Status, responseData))
	}

	log.Print("resourceHouseRead:end")

	return diags
}

func resourceHouseUpdate(ctx context.Context, d *schema.ResourceData, m interface{}) diag.Diagnostics {
	log.Print("resourceHouseUpdate:start")
	var diags diag.Diagnostics
	config := m.(*Config)
	homeUUID := d.Id()
	payload := map[string]interface{}{
		"name":            d.Get("name").(string),
		"description":     d.Get("description").(string),
		"content_version": d.Get("content_version").(int),
	}
	payloadBytes, err := json.Marshal(payload)
	if err != nil {
		return diag.FromErr(err)
	}
	// Contruct the HTTP request
	url := config.Endpoint + "/api/u/" + config.UserUuid + "/homes/" + homeUUID
	log.Print("URL:" + url)

	req, err := http.NewRequest("PUT", url, bytes.NewBuffer(payloadBytes))
	if err != nil {
		return diag.FromErr(err)

	}

	// Set Headers
	req.Header.Set("Authorization", "Bearer "+config.Token)
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Accept", "application/json")

	client := http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		return diag.FromErr(err)
	}
	defer resp.Body.Close()

	// Parse response JSON
	var responseData map[string]interface{}
	if err := json.NewDecoder(resp.Body).Decode(&responseData); err != nil {
		return diag.FromErr(err)
	}

	// StatusOK = 200 HTTP Response Code
	if resp.StatusCode != http.StatusOK {
		return diag.FromErr(fmt.Errorf("failed to read home resource, status_code: %d, status: %s, body %s", resp.StatusCode, resp.Status, responseData))
	}

	d.Set("name", payload["name"])
	d.Set("description", payload["description"])
	d.Set("content_version", payload["content_version"])

	log.Print("resourceHouseUpdate:end")
	return diags
}

func resourceHouseDelete(ctx context.Context, d *schema.ResourceData, m interface{}) diag.Diagnostics {
	log.Print("resourceHouseDelete:start")
	var diags diag.Diagnostics
	config := m.(*Config)
	homeUUID := d.Id()

	// Contruct the HTTP request
	url := config.Endpoint + "/api/u/" + config.UserUuid + "/homes/" + homeUUID
	log.Print("URL:" + url)
	req, err := http.NewRequest("DELETE", url, nil)
	if err != nil {
		return diag.FromErr(err)

	}

	// Set Headers
	req.Header.Set("Authorization", "Bearer "+config.Token)
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Accept", "application/json")

	client := http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		return diag.FromErr(err)
	}
	defer resp.Body.Close()

	// StatusOK = 200 HTTP Response Code
	if resp.StatusCode != http.StatusOK {
		return diag.FromErr(fmt.Errorf("failed to delete home resource, status_code: %d, status: %s", resp.StatusCode, resp.Status))
	}

	d.SetId("")

	log.Print("resourceHouseDelete:end")
	return diags
}
