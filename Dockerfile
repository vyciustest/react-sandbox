FROM node:alpine AS builder
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --immutable --immutable-cache --check-cache --inline-builds

COPY . .

RUN yarn build

FROM nginx:stable-alpine
ENV NODE_ENV=production
WORKDIR /usr/share/nginx/html
COPY --from=builder /app/build .
EXPOSE 80
# run nginx with global directives and daemon off
ENTRYPOINT ["nginx", "-g", "daemon off;"]