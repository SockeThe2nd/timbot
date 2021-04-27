# BUILD-CONTAINER contains full build libs for native node_modules
FROM node:14-stretch as build-env
WORKDIR /srv/lyon_i_nator

# only copy package.json and package-lock.json and install
COPY package*.json ./
# make clean install of npm-modules
RUN npm ci --only=production

# RUNTIME-CONTAINER
FROM node:14-stretch-slim
WORKDIR /srv/lyon_i_nator

# COPY runtime-files, ignores TS-files
COPY ./ .
# COPY build node_modules from build-container
COPY  --from=build-env /srv/lyon_i_nator/node_modules ./node_modules

CMD [ "node", "release/index.js" ]