FROM node:18-alpine AS dependencies
RUN apk add --no-cache libc6-compat
WORKDIR /home/app
COPY ./<PATH>/package.json ./
COPY ./<PATH>/package-lock.json ./
COPY ./<PATH>/ormconfig.js ./
COPY ./<PATH>/tsconfig.json ./

# RUN npm install
RUN npm i

FROM node:18-alpine AS builder

RUN apk add curl bash
# install node-prune (https://github.com/tj/node-prune)
RUN curl -sfL https://gobinaries.com/tj/node-prune | bash -s -- -b /usr/local/bin

WORKDIR /home/app
COPY --from=dependencies /home/app/node_modules ./node_modules
COPY ./<PATH> .
COPY ./<PATH>k/tsconfig.json ./
COPY ./<PATH>/tsconfig.build.json ./
COPY ./<PATH>/ormconfig.js ./
COPY ./<PATH>/schema.gql ./
ENV NODE_ENV production
RUN npm run build

# run node prune
RUN /usr/local/bin/node-prune

# remove unused dependencies
RUN rm -rf node_modules/rxjs/src/
RUN rm -rf node_modules/rxjs/bundles/
RUN rm -rf node_modules/rxjs/_esm5/
RUN rm -rf node_modules/rxjs/_esm2015/
RUN rm -rf node_modules/swagger-ui-dist/*.map


FROM mhart/alpine-node:slim-16 AS runner
WORKDIR /home/app

COPY --from=builder /home/app/node_modules ./node_modules
COPY --from=builder /home/app/dist ./dist
COPY --from=builder /home/app/ormconfig.js ./

EXPOSE 5050
ENV PORT 5050
CMD ["node", "dist/main.js" ]