###########
# FreeHub #
###########
# Password is test for greeter, sfbk, mechanic, scbc, cbi, admin

# Community-maintained Ruby 1.9.3 image with Schema 2 manifest
# https://hub.docker.com/r/corgibytes/ruby-1.9.3
FROM corgibytes/ruby-1.9.3:1.1.0

LABEL maintainer="Alon Salant <alon@salant.org>"

# Downgrade RubyGems to 1.8.25 for Rails 2.3 compatibility
# (Gem.source_index was removed in RubyGems 2.0)
RUN gem update --system 1.8.25

# Update apt sources to use archive since Jessie is EOL
RUN echo "deb http://archive.debian.org/debian jessie main" > /etc/apt/sources.list && \
    echo "deb http://archive.debian.org/debian-security jessie/updates main" >> /etc/apt/sources.list

RUN apt-get update && apt-get install -y --force-yes \
    mysql-client \
    libmysqlclient-dev \
    && rm -rf /var/lib/apt/lists/*

# Configure the main working directory. This is the base
# directory used in any further RUN, COPY, and ENTRYPOINT
# commands.
RUN mkdir -p /app
WORKDIR /app

# Copy the Gemfile as well as the Gemfile.lock and install
# the RubyGems. This is a separate step so the dependencies
# will be cached unless changes to one of those two files
# are made.
COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 20 --retry 5

# Copy the main application.
COPY . ./

# Expose port 3000 to the Docker host, so we can access it
# from the outside.
EXPOSE 3000

# Production: run Unicorn (override in docker-compose for development)
CMD ["bundle", "exec", "unicorn", "-c", "config/unicorn.rb", "-p", "3000"]
