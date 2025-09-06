VISIT THIS LILK TO SETUP DEVISE JWT: https://sdrmike.medium.com/rails-7-api-only-app-with-devise-and-jwt-for-authentication-1397211fb97c


## Quick Rails Commands
```bash
rails new my_api --api
cd my_api
bundle add devise
bundle add devise-jwt
rails generate devise:install
rails generate devise User
rails generate controller post/articles
rails generate controller post/comments
rails generate controller post/likes
rails generate controller users/sessions
rails generate controller users/registrations
rails generate scaffold Article title:string description:text user:references
rails generate scaffold Comment body:text user:references article:references
rails generate scaffold Like user:references article:references
rails db:migrate


## Quick Rails Commands
```bash
added password reset via Postman or letter_operator.
check how to implement controller with custom password reset.



