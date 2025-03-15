FROM python:3.9-slim
WORKDIR /app
COPY package*.json ./
COPY . .
EXPOSE 5000
CMD ["node", "index.js"]
