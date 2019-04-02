FROM snyk/snyk-cli:npm

# Install packages.
RUN apt-get update && \
    apt-get install -y wget && \
    rm -rf /var/lib/apt/lists/*

# Install xml-to-json
WORKDIR /bin
RUN wget "http://stedolan.github.io/jq/download/linux64/jq" && chmod 755 jq

WORKDIR ~/

LABEL version="1.0.0"
LABEL repository="https://github.com/knotel/actions"
LABEL maintainer="Knote, @HoughIO"

LABEL com.github.actions.name="Snyk-Mono"
LABEL com.github.actions.description="Run the Snyk CLI in a mono-repo"
LABEL com.github.actions.icon="shield"
LABEL com.github.actions.color="black"

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
