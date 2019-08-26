FROM mikefarah/yq 

# Install xml-to-json
WORKDIR /bin
RUN apk update && apk add --no-cache --virtual ca-certificates
RUN apk add jq bash curl

WORKDIR /github/workspace

LABEL version="1.1.0"
LABEL repository="https://github.com/Knotel/actions/environment"
LABEL homepage="https://github.com/Knotel/actions/environment"
LABEL maintainer="Knotel, @HoughIO"

LABEL com.github.actions.name="GitHub Action for Yarn"
LABEL com.github.actions.description="Wraps the yarn CLI to enable common yarn commands."
LABEL com.github.actions.icon="package"
LABEL com.github.actions.color="black"
COPY LICENSE README.md /

COPY "entrypoint.sh" "/entrypoint.sh"
ENTRYPOINT ["/entrypoint.sh"]

CMD ["help"]
