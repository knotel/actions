FROM golang:alpine3.8 as builder

RUN apk --update upgrade
RUN apk --no-cache --no-progress add make git gcc musl-dev jq

WORKDIR /build
COPY . .
RUN go build .

FROM node:10-alpine
RUN apk update && apk add --no-cache --virtual ca-certificates
COPY --from=builder /build/jest /usr/bin/jest-action

LABEL version="1.0.0"
LABEL repository="https://github.com/knotel/actions/jest"
LABEL homepage="https://github.com/knotel/actions/jest"
LABEL maintainer="Knotel, @HoughIO"

LABEL com.github.actions.name="Jest-Mono"
LABEL com.github.actions.description="Execute jest tests and test failure annotations in a mono-repo"
LABEL com.github.actions.icon="check"
LABEL com.github.actions.color="black"

ENV JEST_CMD ./node_modules/.bin/jest
COPY entrypoint.sh /entrypoint.sh

WORKDIR ~/
ENTRYPOINT ["/entrypoint.sh"]
CMD [""]
