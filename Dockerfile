# Use a lightweight base image
ARG NODE_VERSION=node:current-alpine3.17
FROM $NODE_VERSION AS builder

# Set working directory
WORKDIR /app

# Install dependencies and build the app in a single step
COPY package*.json ./
RUN npm ci && npm run build

# Production image
FROM $NODE_VERSION AS production

# Set working directory
WORKDIR /app

# Copy only necessary files from the builder stage
COPY --from=builder /app/.output /app/.output

ARG NUXT_APP_VERSION
# Set environment variables
ENV NUXT_HOST=0.0.0.0 \
    NODE_ENV=production \
    DATABASE_URL=file:./db.sqlite \
    NUXT_APP_VERSION=${NUXT_APP_VERSION}

# Start the app
CMD ["node", "/app/.output/server/index.mjs"]
