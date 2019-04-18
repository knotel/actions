FROM node:lts

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
