# Base Ruby image
FROM ruby:3.2.2

# Install system dependencies
RUN apt-get update -qq && \
    apt-get install -y build-essential sqlite3 libsqlite3-dev nodejs yarn && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy project Gemfiles and install gems
COPY Gemfile Gemfile.lock ./
RUN gem install bundler -v 2.4.15 && bundle install

# Copy all project files or codes
COPY . .

# Expose Rails default port
EXPOSE 3000

# Environment variables
ENV RAILS_ENV=development

# Create database and run migrations, then start Rails server
CMD ["bash", "-c", "bundle exec rails db:create db:migrate && bundle exec rails server -b 0.0.0.0 -p 3000"]
