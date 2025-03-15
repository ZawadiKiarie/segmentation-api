FROM python:3.9-slim
WORKDIR /app
COPY package*.json ./
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
EXPOSE 5000
CMD ["node", "index.js"]
