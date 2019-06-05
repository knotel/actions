FROM rkusa/jest-action:1.0.0 as builder

FROM node:10-alpine

#possibly remove this
RUN apk update && apk add --no-cache --virtual ca-certificates
RUN apk add bash

COPY --from=builder /usr/bin/jest-action /usr/bin/jest-action

RUN wget "http://stedolan.github.io/jq/download/linux64/jq" -P /bin/ && chmod 755 /bin/jq

LABEL version="1.0.0"
LABEL repository="https://github.com/knotel/actions/jest"
LABEL homepage="https://github.com/knotel/actions/jest"
LABEL maintainer="Knotel, @HoughIO"

LABEL com.github.actions.name="Jest-Mono"
LABEL com.github.actions.description="Execute jest tests and test failure annotations in a mono-repo"
LABEL com.github.actions.icon="check"
LABEL com.github.actions.color="black"

ENV JEST_CMD ./node_modules/.bin/jest
RUN chmod +x /usr/bin/jest-action
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD [""]
