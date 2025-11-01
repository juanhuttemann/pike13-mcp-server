FROM ruby:3.4-alpine

WORKDIR /app

# Install dependencies
RUN apk add --no-cache git build-base

# Copy Gemfile
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install

# Copy app files
COPY . .

# Expose port (for reference, though not needed for stdio mode)
EXPOSE 9292

CMD ["ruby", "server.rb"]