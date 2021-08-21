# GigihHub Social Media API

GigihHub is a simple social media to share information with other people in the same community. This repository contains GigihHub APIs, built in Ruby without any frameworks 🤓🚀. This project is intended for learning purposes in Model-View-Controller (MVC) design pattern, practicing Test Driven Development (TDD), and Clean Code.

## Functional Requirements

The Gigih Hub Social Media contains six functional requirements.

- [x] Saves user details (username, email, bio)
- [x] Lets user make a new post with hashtag
- [x] Lets user comment in a post with hashtag
- [x] Lets user attach media (jpg, png, mp4) in a post or comment
- [x] Lets user get posts with a hashtag
- [x] Shows 5 trending hashtags

## Database Schema
![ER Diagram](/docs/ERD.png)

There are four tables created in the database.

1. **User**, represents our social media user which contains user informations.
2. **Post**, represents user's post. A post with `parent_post_id` is a comment to the parent post, meanwhile a parent without `parent_post_id` is the parent post.
3. **PostHashtag**, represents the pivot entity of Post and Hashtag.
3. **Hashtag**, represents hashtag (text initialized with `#`) in a post.

## Prerequisites
1. Ruby v3.0.1 (recommended to install using [rbenv](https://github.com/rbenv/rbenv#installation))
2. MySQL ([installation reference](https://www.digitalocean.com/community/tutorials/how-to-install-mysql-on-ubuntu-20-04))

### Dependency Libraries
These libraries are bundled in a `Gemfile`.

1. Sinatra, for simple web server
2. Mysql2, for database connector
3. RSpec, for unit test
4. SimpleCov, for test coverage
5. Rubocop, for code linter, based on Ruby Guide Style

## How to Run
### Installation

1. Clone this project on your machine.
2. Setup database by creating a new database for this project

        mysql -u <your-mysql-username> -p
        mysql> CREATE DATABASE gigih_hub_db;
        mysql> exit
    
    Then, import our database dump file in the `/db` directory

        mysql -u <your-mysql-username> -p gigih_hub_db < /db/gigih_hub_db_dump.sql

3. Setup environment variable by creating a `.env` file. The example file is available in `.env.example`.

        cp .env.example .env

    Initialize the variables in the file with your environment setup.

4. Install dependency libraries by executing the command below.

        bundle install --path vendor/bundle

   This command will locally install the libraries in the root project directory.

### Run Linter and Test Suites

1. To run linter, execute rubocop.

        bundle exec rubocop

2. To run test suites, execute rspec.

        bundle exec rspec

### Run the Application

1. To run the application, execute using ruby, with personallized host binding below.

        bundle exec ruby main.rb

2. Our app will be listening in `localhost:4567`.

## API Documentation

This application contains APIs to run the functionalities defined above. It is run with base path `localhost:4567/api`. To see the documentation, check out [the Postman Collection](docs/GigihHub-API.postman_collection.json)

## Deployment

Check the live version of this app in http://34.101.85.67:4567/ (for a period of time).

## Author

Erma Safira Nurmasyita