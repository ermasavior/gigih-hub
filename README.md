# GigihHub Social Media BE

Backend of a simple social media app. Built in Ruby with TDD practice.

## Functional Requirements

- [x] Saves user details (username, email, bio)
- [x] Lets user make a new post
- [ ] Lets user comment in a post
- [ ] Lets user attach media (jpg, png, mp4) in a post or comment
- [x] Lets user put hashtags in a post or comment
- [x] Shows 5 trending hashtags

## Database Schema
![ER Diagram](ERD.png)

There are four tables created in the database, representing five entities in our app.

The five entities:

1. **User**, represents our social media user which contains user informations.
2. **Post**, represents user's post.
3. **Comment**, represents user's post as a form of comment to another post. Comment is a form of Post which contains `post_parent_id`.
3. **Hashtag**, represents hashtag embedded in a post.

## Prerequisites
1. Ruby v3.0.1
2. MySQL

### Library Dependencies
These libraries are bundled in a `Gemfile`.

1. Sinatra, for simple web server
2. Mysql2, for database connector
3. RSpec, for unit test
4. SimpleCov, for test coverage
5. Rubocop, for code linter, based on Ruby Guide Style

## How to Run
(TBD)
