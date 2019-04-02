FROM node:lts

COPY . .

RUN yarn

ENTRYPOINT ["node", "/entrypoint.js"]

LABEL maintainer="Knotel, @HoughIO"
LABEL repository=https://github.com/knotel/actions/changes
LABEL com.github.actions.name="Get Changed Files In A Mono Repo Style"
LABEL com.github.actions.description="Saves changed files as JSON for use by other actions."
LABEL com.github.actions.icon=file
LABEL com.github.actions.color=gray-dark
