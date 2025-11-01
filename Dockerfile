FROM ruby:3.4-alpine

WORKDIR /app

# Install dependencies including Node.js for supergateway
RUN apk add --no-cache git build-base openssh-client nodejs npm

# Copy Gemfile
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install

# Install supergateway globally
RUN npm install -g supergateway

# Copy app files
COPY . .

# Make start script executable
RUN chmod +x /app/start.sh

# Expose port (for reference, though not needed for stdio mode)
EXPOSE 9292

CMD ["/app/start.sh"]
