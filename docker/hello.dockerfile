FROM node:12

RUN mkdir /current
WORKDIR /current

# Copy before `npm ci`, so that changing files other than package* doesn't force a re-npm-install
COPY package.json .
COPY package-lock.json .

RUN npm ci

ARG CACHE_REFRESH=1
COPY . .

RUN echo ${CACHE_REFRESH}
