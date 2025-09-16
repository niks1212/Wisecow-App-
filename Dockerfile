FROM node:18-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm install --omit=dev
COPY . .

FROM node:18-alpine
WORKDIR /app
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
COPY --from=build /app ./
RUN if [ ! -d node_modules ]; then npm install --omit=dev; fi
USER appuser
ENV NODE_ENV=production
EXPOSE 3000
CMD ["node", "index.js"]
