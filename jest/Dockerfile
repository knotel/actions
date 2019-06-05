FROM rkusa/jest-action:latest as builder

FROM node:10.15.1

RUN apt-get update && \
    apt-get install -y wget ca-certificates && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/bin/jest-action /usr/bin/jest-action 

WORKDIR /bin
RUN wget "http://stedolan.github.io/jq/download/linux64/jq" && chmod 755 jq

WORKDIR ~/

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
