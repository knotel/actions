FROM node:11

RUN apt-get update && \
    apt-get install -y wget ca-certificates && \
    rm -rf /var/lib/apt/lists/*


WORKDIR /bin
RUN wget "http://stedolan.github.io/jq/download/linux64/jq" && chmod 755 jq

WORKDIR ~/

LABEL version="1.0.0"
LABEL repository="https://github.com/knotel/actions/eslint"
LABEL homepage="https://github.com/knotel/actions/eslint"
LABEL maintainer="Knotel, @HoughIO"

LABEL com.github.actions.name="Eslint-Mono"
LABEL com.github.actions.description="Execute ESLint and add linting error annotations in a mono-repo"
LABEL com.github.actions.icon="octagon"
LABEL com.github.actions.color="black"

ENV NODE_PATH node
COPY . /action
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD [""]
