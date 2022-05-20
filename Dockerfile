# --------------------------------------------------------------------------------
# Builder image
# --------------------------------------------------------------------------------

FROM ruby:3.1-alpine AS builder
LABEL maintainer="shahni@bokobo.space"

RUN apk add --no-cache \
      build-base \
      curl-dev \
      postgresql-dev \
      git \
      tzdata \
      file

WORKDIR /app

COPY Gemfile* /app/
RUN bundle config --local without 'development test' && \
    bundle install -j4 --retry 3 && \
    bundle clean --force && \
    rm -rf /usr/local/bundle/cache/*.gem && \
    find /usr/local/bundle/gems/ -name "*.c" -delete && \
    find /usr/local/bundle/gems/ -name "*.o" -delete

ONBUILD ARG COMMIT_SHA
ONBUILD ARG COMMIT_TIME

ONBUILD ENV COMMIT_SHA ${COMMIT_SHA}
ONBUILD ENV COMMIT_TIME ${COMMIT_TIME}

# --------------------------------------------------------------------------------
# Deployment image
# --------------------------------------------------------------------------------

FROM ruby:3.1-alpine AS deploy

LABEL maintainer="shahni@bokobo.space"

ARG COMMIT_SHA
ARG COMMIT_TIME

ENV COMMIT_SHA ${COMMIT_SHA}
ENV COMMIT_TIME ${COMMIT_TIME}
ENV RAILS_ENV production
ENV RAILS_LOG_TO_STDOUT true
ENV RAILS_SERVE_STATIC_FILES true

RUN apk add --no-cache \
      file \
      libc6-compat \
      libcurl \
      libpq \
      tzdata

RUN addgroup -g 1000 -S app && \
    adduser -u 1000 -S app -G app

WORKDIR /app

USER app

COPY --from=builder --chown=app:app /usr/local/bundle/ /usr/local/bundle/
COPY --chown=app:app . /app

RUN RAILS_ENV=production \
    ASSET_PRECOMPILE=true \
    ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY=assets \
    ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY=assets \
    ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT=assets \
    JOVE_SITE_URL=http://assets.host \
    SECRET_KEY_BASE=assets \
    bundle exec rails assets:precompile

RUN rm -rf tmp/cache app/javascript

EXPOSE 3000

CMD ["bundle", "exec", "rails", "console"]
