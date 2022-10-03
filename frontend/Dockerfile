FROM node:18

EXPOSE 3000

ADD entrypoint.sh entrypoint.sh
RUN chmod -c +x entrypoint.sh

COPY package.json package.json
COPY package-lock.json package-lock.json

RUN npm ci

COPY .nuxt/dist .nuxt/dist

ENTRYPOINT "/entrypoint.sh"
