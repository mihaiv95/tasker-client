# Development stage
FROM node:18-alpine AS development
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm ci

# Copy source code
COPY . .

EXPOSE 5173

# Start development server with hot reloading
CMD ["npm", "run", "dev", "--", "--host", "0.0.0.0"]

# Build stage
FROM node:18-alpine AS build
WORKDIR /app

# Build argument for API URL
ARG VITE_API_URL=http://localhost:8080

# Copy package files and install dependencies
COPY package*.json ./
RUN npm ci --only=production

# Copy source code and build
COPY . .
ENV VITE_API_URL=$VITE_API_URL
RUN npm run build

# Production stage
FROM nginx:alpine AS production

# Copy custom nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Copy built application
COPY --from=build /app/dist /usr/share/nginx/html

# Add healthcheck
RUN apk add --no-cache curl
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost/health || exit 1

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
