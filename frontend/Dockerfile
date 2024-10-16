FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm install

COPY .env .env

COPY . .
RUN npm run build

# Stage 2: Serve static files with Nginx
FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
# Copy static assets from public or other folder
COPY --from=build /app/public /usr/share/nginx/html/public

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
