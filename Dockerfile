

FROM elixir:1.6-alpine

LABEL maintainer="Rudy Pangestu <phang.rudy94@gmail.com>"

WORKDIR /app

COPY . .

RUN apk update \
    && apk add --no-cache --update \
    nodejs \
    make \
    g++ \
    erlang-dev \
    inotify-tools \
    && rm -rf /var/cache/apk/* \
    && mix local.hex --force \
    && mix local.rebar --force \
    && mix archive.install https://github.com/phoenixframework/archives/raw/master/phx_new.ez --force \
    && mix deps.get \
    && mix deps.compile \
    && cd /app/deps/argon2_elixir \
    && make clean && make \
    && cd /app/assets \
    && npm i && npm cache clean --force \
    && npm run deploy \
    && cd /app \
    && mix phx.digest

EXPOSE 4000

CMD ["mix", "phx.server"]