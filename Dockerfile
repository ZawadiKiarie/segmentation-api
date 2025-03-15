FROM node:alpine
RUN apk update && apk add --no-cache python3 py3-pip
RUN apk add --no-cache ffmpeg libsm6 libxext6 cmake build-base python3-dev
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY requirements.txt ./
RUN pip3 install --no-cache-dir -r requirements.txt
COPY . .
EXPOSE 5000
CMD ["node", "index.js"]