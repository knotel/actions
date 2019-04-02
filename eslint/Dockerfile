FROM golang:alpine3.8 as builder

RUN apk --update upgrade
RUN apk --no-cache --no-progress add make git gcc musl-dev

WORKDIR /build
COPY . .
RUN go build .

FROM node:10-alpine
RUN apt-get update && \
    apt-get install -y wget && \
    rm -rf /var/lib/apt/lists/*
WORKDIR /bin
RUN wget "http://stedolan.github.io/jq/download/linux64/jq" && chmod 755 jq

WORKDIR /build
COPY --from=builder /build/eslint-action /usr/bin/eslint-action

LABEL version="1.0.0"
LABEL repository="https://github.com/knotel/actions/eslint"
LABEL homepage="https://github.com/knotel/actions/eslint"
LABEL maintainer="Knotel, @HoughIO"

LABEL com.github.actions.name="Eslint-Mono"
LABEL com.github.actions.description="Execute ESLint and add linting error annotations in a mono-repo"
LABEL com.github.actions.icon="octagon"
LABEL com.github.actions.color="black"

ENV ESLINT_CMD ./node_modules/.bin/eslint
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD [""]
