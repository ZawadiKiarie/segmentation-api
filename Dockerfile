FROM node:alpine
RUN apk update && apk add --no-cache python3 py3-pip
WORKDIR /app
COPY . .
EXPOSE 5000
CMD ["node", "index.js"]

