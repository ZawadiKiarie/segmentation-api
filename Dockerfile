FROM node:18-slim
RUN apt-get update && apt-get install -y \
    python3 python3-pip python3-dev build-essential \
    libglib2.0-0 libsm6 libxext6 libxrender-dev
WORKDIR /app
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt
COPY . .
EXPOSE 5000
CMD ["node", "index.js"]

