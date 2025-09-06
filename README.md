# Rails API Backend

This project is a **Ruby on Rails API with Postman** that provides authentication, password reset, account delete, Association, article management, file uploads, comments, and likes functionality.  
It uses **Devise + JWT** for authentication and **ActiveStorage** for file handling.

Please use Postman to test the functionality as it is developed as pure --API

## Authentication & Security
- Integrated **Devise** for authentication.
- Configured **JWT (JSON Web Token)** with Devise for API token-based authentication.
- Protected API endpoints with `authenticate_user!`.
- Features:
  - User **registration & login**
  - **Password reset** via email
    - But must use Authorization token and password reset token to change password.
  - **Logout / JWT revocation**
  - **Account deletion**

## Articles
- Full **CRUD** (create, read, update, delete).
- Each article belongs to a **User**.
- To POST article use Postman form-data instead of JSON raw, select file for file upload.
- **File uploads** supported with **ActiveStorage**:
  - Multiple file uploads per article.
  - Returns `file_urls` in JSON response
- **Likes** system:
  - Returns `likes_count` in JSON.
- **Comments** system:
  - Each article can have multiple comments.

## Comments
- Each comment belongs to a **User** and an **Article**.
- Endpoints to **list, create, and delete** comments.
- JSON response includes:
  - Comment `id`, `body`, `created_at`
  - Commenter info (`id`, `email`)

## Likes
- Users can **like articles**.
- Each user can like Article only one time. 
- User can unlike Article.
- `likes_count` is returned in article responses.

## File Uploads
- Implemented with **ActiveStorage**.
- To handle file, DB Bolb and Attachment table and stores actual file in local storage.
- Returns file url in Postman to verify file upload.
- Files stored on local disk by default.
- JSON response includes **direct URLs** for uploaded files.


## Mailer 
- Configured **ActionMailer** for password reset.
- Configure mail send to reset password.
- Used password reset token, new password and confirmation password with Authorization token.
- Default development host:  
  config.action_mailer.default_url_options = { host: "localhost", port: 3000 }
- Try ti login again using new password. 
