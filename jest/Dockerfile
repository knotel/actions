FROM rkusa/jest-action:1.0.0 as builder

FROM node:10.15.1-alpine

#possibly remove this
RUN apk update && apk add --no-cache --virtual ca-certificates
RUN apk add bash jq make curl openssh git
RUN echo "**** install Python ****" && \
    apk add --no-cache python3 && \
    if [ ! -e /usr/bin/python ]; then ln -sf python3 /usr/bin/python ; fi && \
    \
    echo "**** install pip ****" && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --no-cache --upgrade pip setuptools wheel awscli && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi

RUN apk update && apk upgrade && \
    echo @3.10 http://nl.alpinelinux.org/alpine/v3.10/community >> /etc/apk/repositories && \
    echo @3.10 http://nl.alpinelinux.org/alpine/v3.10/main >> /etc/apk/repositories && \
    apk add --no-cache \
    chromium@3.10=~73.0.3683.103 \
    nss@3.10 \
    freetype@3.10 \
    freetype-dev@3.10 \
    harfbuzz@3.10 \
    ttf-freefont@3.10

WORKDIR /bin
RUN wget "http://stedolan.github.io/jq/download/linux64/jq" && chmod 755 jq
RUN wget "https://raw.githubusercontent.com/rockymadden/slack-cli/master/src/slack" && chmod +x slack

# Tell Puppeteer to skip installing Chrome. We'll be using the installed package.
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true

# Add user so we don't need --no-sandbox.

COPY --from=builder /usr/bin/jest-action /usr/bin/jest-action

LABEL version="1.0.0"
LABEL repository="https://github.com/knotel/actions/jest"
LABEL homepage="https://github.com/knotel/actions/jest"
LABEL maintainer="Knotel, @HoughIO"

LABEL com.github.actions.name="Jest-Mono"
LABEL com.github.actions.description="Execute jest tests and test failure annotations in a mono-repo"
LABEL com.github.actions.icon="check"
LABEL com.github.actions.color="black"

WORKDIR /github/workspace
ENV JEST_CMD ./node_modules/.bin/jest
RUN chmod +x /usr/bin/jest-action
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD [""]
