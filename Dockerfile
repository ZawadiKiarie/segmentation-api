FROM node:alpine
RUN apt-get update && apt-get install -y python3 python3-pip
WORKDIR /app
COPY . .
EXPOSE 5000
CMD ["node", "index.js"]

