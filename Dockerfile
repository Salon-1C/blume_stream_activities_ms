# syntax=docker/dockerfile:1
FROM hexpm/elixir:1.16.3-erlang-26.2.5-debian-bookworm-20240612 AS build

RUN apt-get update && apt-get install -y --no-install-recommends build-essential git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
ENV MIX_ENV=prod

COPY mix.exs mix.lock ./
RUN mix deps.get --only prod

COPY config config
RUN mix deps.compile

COPY lib lib
COPY priv priv

RUN mix compile
RUN mix release

FROM debian:bookworm-slim AS app

RUN apt-get update && apt-get install -y --no-install-recommends libstdc++6 openssl ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
RUN groupadd --gid 1000 blume && useradd --uid 1000 --gid blume --shell /bin/bash --create-home blume

COPY --from=build --chown=blume:blume /app/_build/prod/rel/stream_activities ./

USER root
# Dotenvy loads `.env` at runtime; empty file so OS env (Compose) still applies.
RUN touch /app/.env && chown blume:blume /app/.env
COPY docker-entrypoint.sh /app/docker-entrypoint.sh
RUN chmod +x /app/docker-entrypoint.sh && chown blume:blume /app/docker-entrypoint.sh

USER blume
ENV PHX_SERVER=true
ENV MIX_ENV=prod

ENTRYPOINT ["/app/docker-entrypoint.sh"]
