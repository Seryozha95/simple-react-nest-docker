# Name the node stage "dependencies"
FROM node:16-alpine AS dependencies

# Set working directory
WORKDIR /app

# Copy our node module specification
COPY ./<PATH>/package.json ./
COPY ./<PATH>/package-lock.json ./

# install node modules and build assets
RUN npm i

FROM node:16-alpine AS builder
WORKDIR /app
COPY --from=dependencies /app/node_modules ./node_modules
COPY ./<PATH> .
ENV NODE_ENV production

# Create production build of React App
RUN npm run build

# Choose NGINX as our base Docker image
FROM mhart/alpine-node:slim-16 AS runner
WORKDIR /app/public


# Copy static assets from builder stage
COPY --from=builder /app/build .
