FROM elixir:1.15.4-alpine as deps

RUN apk add --no-cache ca-certificates

ENV MIX_ENV=prod
COPY mix.lock mix.exs /src/

WORKDIR /src

RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.get
RUN mix deps.compile

COPY config /src/config
RUN mix esbuild.install
RUN mix tailwind.install

FROM elixir:1.15.4-alpine as builder

ENV MIX_ENV=prod
ENV PHX_SERVER=true

COPY . /app
COPY --from=deps /src/deps /app/deps
COPY --from=deps /src/_build /app/_build
RUN mix local.hex --force
RUN mix local.rebar --force

WORKDIR /app

RUN mix compile
RUN mix assets.deploy

COPY ./bin/start.sh /app/start.sh

CMD [ "/app/start.sh" ]
