FROM ruby:3.4-alpine

WORKDIR /app

# Install dependencies
RUN apk add --no-cache git build-base openssh-client

# Copy Gemfile
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install

# Copy app
COPY . .

EXPOSE 9292

CMD ["ruby", "server.rb"]
