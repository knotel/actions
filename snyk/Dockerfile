FROM snyk/snyk-cli:npm

LABEL version="1.0.0"
LABEL repository="https://github.com/knotel/actions"
LABEL maintainer="Knote, @HoughIO"

LABEL com.github.actions.name="Snyk Test"
LABEL com.github.actions.description="Run the Snyk CLI in a mono-repo"
LABEL com.github.actions.icon="shield"
LABEL com.github.actions.color="black"

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
