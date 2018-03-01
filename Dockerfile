FROM elixir:1.6-alpine

MAINTAINER rudydydy <phang.rudy94@gmail.com>

RUN apk update \
    && apk add --no-cache --update \
    nodejs \
    make \
    g++ \
    erlang-dev \
    inotify-tools \
    && rm -rf /var/cache/apk/*

WORKDIR /app

COPY mix.exs mix.lock ./

RUN mix local.hex --force \
    && mix local.rebar --force \
    && mix archive.install https://github.com/phoenixframework/archives/raw/master/phx_new.ez --force \
    && mix deps.get \
    && mix deps.compile

WORKDIR /app/deps/argon2_elixir

RUN make clean && make

WORKDIR /app/assets

COPY ./assets/package.json ./assets/package-lock.json ./

RUN npm i && npm cache clean

WORKDIR /app

COPY . .

EXPOSE 4000

CMD ["mix", "phx.server"]