FROM python:3.9-slim

WORKDIR /app

# If you need dependencies, e.g.:
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .  # Make sure segment.py is copied into /app

EXPOSE 5000
CMD ["node", "index.js"]
