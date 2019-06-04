FROM node:10.15.1

# Install packages.
RUN apt-get update && \
    apt-get install -y wget && \
    rm -rf /var/lib/apt/lists/*

# Install xml-to-json
WORKDIR /bin
RUN wget "http://stedolan.github.io/jq/download/linux64/jq" && chmod 755 jq

WORKDIR ~/

LABEL version="1.1.0"
LABEL repository="https://github.com/Knotel/actions/yarn"
LABEL homepage="https://github.com/Knotel/actions/yarn"
LABEL maintainer="Knotel, @HoughIO"

LABEL com.github.actions.name="GitHub Action for Yarn"
LABEL com.github.actions.description="Wraps the yarn CLI to enable common yarn commands."
LABEL com.github.actions.icon="package"
LABEL com.github.actions.color="black"
COPY LICENSE README.md /

COPY "entrypoint.sh" "/entrypoint.sh"
ENTRYPOINT ["/entrypoint.sh"]
CMD ["help"]
