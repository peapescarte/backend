VERSION 0.7

deps:
  ARG ELIXIR=1.15.4
  ARG OTP=25.3.2.5
  ARG DEBIAN_VERSION=buster-20230612
  FROM hexpm/elixir:${ELIXIR}-erlang-${OTP}-debian-${DEBIAN_VERSION}
  RUN apt update -y && apt install -y build-essential
  WORKDIR /src
  COPY mix.exs mix.lock ./
  COPY --dir lib . # check .earthlyignore
  RUN mix local.rebar --force
  RUN mix local.hex --force
  RUN mix deps.get
  SAVE ARTIFACT /src/deps AS LOCAL deps

ci:
  FROM +deps
  COPY .credo.exs .
  COPY .formatter.exs .
  RUN mix clean
  RUN mix compile --warning-as-errors
  RUN mix format --check-formatted
  RUN mix credo --strict

test:
  FROM +deps
  RUN apt install -y google-chrome-stable
  RUN apt install -y postgresql-client
  RUN MIX_ENV=test mix deps.compile
  COPY docker-compose.ci.yml ./docker-compose.yml
  COPY mix.exs mix.lock ./
  COPY .env-sample ./
  COPY --dir config lib priv test ./

  WITH DOCKER --compose docker-compose.yml
    RUN while ! pg_isready --host=localhost --port=5432 --quiet; do sleep 1; done; \
        DATABASE_USER="peapescarte" DATABASE_PASSWORD="peapescarte" mix test
  END

frontend-deps:
  FROM node:18.3.0-alpine3.14
  WORKDIR /frontend
  COPY --dir +deps/deps .
  COPY ./assets ./assets/
  RUN rm ./assets/package-lock.json
  RUN npm i --prefix ./assets
  SAVE ARTIFACT /frontend/assets AS LOCAL assets

frontend-build:
  FROM +test
  COPY --dir +frontend-deps/assets ./
  RUN mix assets.deploy
  SAVE ARTIFACT ./priv AS LOCAL priv

release:
  FROM +test
  COPY --dir +frontend-build/priv ./
  COPY rel rel
  RUN MIX_ENV=prod mix do compile, release
  SAVE ARTIFACT /src/_build/prod/rel/pescarte /app/_build/prod/rel/pescarte AS LOCAL release

docker-prod:
  FROM DOCKERFILE .
  ARG GITHUB_REPO
  SAVE IMAGE --push ghcr.io/$GITHUB_REPO:prod

docker-dev:
  FROM +deps
  RUN apt update -y && apt install -y inotify-tools
  ENV MIX_ENV=dev
  RUN mix deps.compile
  COPY --dir config ./
  COPY --dir lib ./
  RUN mix compile
  CMD ["mix", "dev"]
  ARG GITHUB_REPO=peapescarte/pescarte-plataforma
  SAVE IMAGE --push ghcr.io/$GITHUB_REPO:dev

docker:
  BUILD +docker-dev
  BUILD +docker-prod
