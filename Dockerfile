FROM elixir:1.15.0-slim as deps

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

FROM elixir:1.15.0-slim as builder

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

FROM elixir:1.15.0-slim

ENV MIX_ENV=prod

COPY --from=builder /src/_build/prod/rel/simple_budget /app

COPY bin/start.sh /app/start.sh

CMD [ "/app/start.sh" ]
