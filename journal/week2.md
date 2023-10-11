# Terraform Beginner Bootcamp 2023 - Week 2

## Table of Contents
- [Working with Ruby](#working-with-ruby)
  * [Bundler](#bundler)
    + [Installing Gems](#installing-gems)
    + [Executing ruby scripts in the context of bundler](#executing-ruby-scripts-in-the-context-of-bundler)
    + [Sinatra](#sinatra)
- [Terratowns Mock Server](#terratowns-mock-server)
  * [Running web server](#running-web-server)
- [CRUD](#crud)

## Working with Ruby

### Bundler

Bundler is a package manager for ruby. It is the primary way to install ruby packages (known as gems) for ruby. 


#### Installing Gems

You need to create a GemFile and define your gems in that file.

```rb
source "https://rubygems.org"

gem 'sinatra'
gem 'rake'
gem 'pry'
gem 'puma'
gem 'activerecord'
```

Then you need to run the `bundle install` command

This will install the gems on the system globally (unlike node.js which installs packages in place in a folder called node_modules). 

A Gemfile.lock will be created to lock the gem versions used in this project.

#### Executing ruby scripts in the context of bundler

We have to use `bundle exec` to tell future ruby scripts to use the gems we installed. This is the way we set context. 

#### Sinatra

Sinatra is micro web-framework for ruby for build web-aps.

Its great for mock or development servers or for very simple projects. 

You can create a web-server in a single file. 

[Sinatra Documentation](https://sinatrarb.com/)

## Terratowns Mock Server

### Running web server

We can run the web server by executing the following commands:

```rb
bundle install
bundle exec ruby server.rb
```

All of the code for our server is stored in the `server.rb` file.

## CRUD

Terraform provider resources utilize CRUD.

CRUD stands for Create, Read, Update and Delete.

[Wiki documentation](https://en.wikipedia.org/wiki/Create,_read,_update_and_delete)
