FROM node:alpine
RUN apk update && apk add --no-cache python3 py3-pip
WORKDIR /app
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt
COPY . .
EXPOSE 5000
CMD ["node", "index.js"]

