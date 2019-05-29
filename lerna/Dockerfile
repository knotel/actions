FROM golang:1.9.2 as builder
RUN set -xe && \
    go get -u -d github.com/github/hub && \
    cd /go/src/github.com/github/hub && \
    git remote add jsternberg git://github.com/jsternberg/hub && \
    git pull jsternberg master && \
    go install github.com/github/hub


FROM node:lts

COPY --from=builder /go/bin/hub /usr/bin/hub
COPY hub.sh /etc/profile.d/hub.sh

ENV LERNA_VERSION 3.13.2

# Install packages.
RUN apt-get update && \
    apt-get install -y wget && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /bin
RUN wget "http://stedolan.github.io/jq/download/linux64/jq" && chmod 755 jq
RUN wget "https://raw.githubusercontent.com/rockymadden/slack-cli/master/src/slack" && chmod +x slack

RUN npm i -g lerna@${LERNA_VERSION}
WORKDIR /github/workspace

LABEL com.github.actions.name="lerna-action"
LABEL com.github.actions.description="github action to run lerna commands, post messages to slack, etc"
LABEL com.github.actions.icon="check"
LABEL com.github.actions.color="blue"
ADD entrypoint.sh /entrypoint.sh

CMD ["node"]
ENTRYPOINT ["/entrypoint.sh"]
