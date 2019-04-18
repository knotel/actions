FROM node:lts

WORKDIR /bin

RUN wget "http://stedolan.github.io/jq/download/linux64/jq" && chmod 755 jq
RUN wget "https://raw.githubusercontent.com/rockymadden/slack-cli/master/src/slack" && chmod +x slack

WORKDIR /github/workspace

LABEL maintainer="Knotel, @HoughIO"
LABEL repository=https://github.com/knotel/actions/notify-changes
LABEL com.github.actions.name="File change notification"
LABEL com.github.actions.description="Notify upon detection of specific file changes."
LABEL com.github.actions.icon=file
LABEL com.github.actions.color=gray-dark

ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
