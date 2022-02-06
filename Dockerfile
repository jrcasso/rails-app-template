FROM ruby:3.1.0-buster

WORKDIR /app

# Allow us to use the same Dockerfile for production and development
# environments. Development packages and gems are conditionally installed.
ARG DEVELOPMENT=false
ENV DEVELOPMENT=${DEVELOPMENT}

RUN apt-get update && \
    apt-get install -yq \
        make && \
    if ${DEVELOPMENT}; then apt-get install -yq \
        postgresql-client \
        ; fi && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY Gemfile Gemfile.lock ./

RUN gem install bundler && \
    bundle install --without development test && \
    if ${DEVELOPMENT}; then bundle install; fi;

COPY . ./

CMD [ "bundle", "exec", "rails", "serve" ]
