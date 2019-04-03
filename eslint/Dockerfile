FROM golang:alpine3.8 as builder

RUN apk --update upgrade
RUN apk --no-cache --no-progress add make git gcc musl-dev jq

WORKDIR /build
COPY . .
RUN go build .

FROM node:10-alpine
RUN apk update && apk add --no-cache --virtual ca-certificates
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
