FROM python:3.9-slim AS python-base

# Install Python dependencies
WORKDIR /app-python
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

FROM node:18-slim

# Copy Python from the previous stage
COPY --from=python-base /usr/local/lib/python3.9 /usr/local/lib/python3.9
COPY --from=python-base /usr/local/bin/python3.9 /usr/local/bin/python
COPY --from=python-base /usr/local/bin/pip /usr/local/bin/pip

# Install required system dependencies
RUN apt-get update && \
    apt-get install -y ffmpeg libsm6 libxext6 python3-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Ensure uploads directory exists
RUN mkdir -p uploads

# Copy package.json and install Node.js dependencies
COPY package*.json ./
RUN npm install

# Copy the rest of the application
COPY . .

# Expose port
EXPOSE 5000

# Start the application
CMD ["node", "index.js"]