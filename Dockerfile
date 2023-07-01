FROM elixir:1.15.4-slim as deps

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

FROM elixir:1.15.4-slim as builder

ENV MIX_ENV=prod

COPY . /src
COPY --from=deps /src/deps /src/deps
COPY --from=deps /src/_build /src/_build
RUN mix local.hex --force
RUN mix local.rebar --force

WORKDIR /src

RUN mix compile
RUN mix assets.deploy
RUN mix release

FROM elixir:1.15.4-slim

ENV MIX_ENV=prod
ENV PHX_SERVER=true
COPY --from=builder /src/_build/prod/rel/simple_budget /app

CMD [ "/app/bin/simple_budget", "start" ]
