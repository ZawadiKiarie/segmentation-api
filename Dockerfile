FROM python:3.9

# Install Node.js
RUN apt-get update && \
    apt-get install -y curl && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs

# Install required system dependencies
RUN apt-get install -y ffmpeg libsm6 libxext6 cmake build-essential

# Set working directory
WORKDIR /app

# Ensure uploads directory exists
RUN mkdir -p uploads

# Install Python dependencies first
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Copy package.json and install Node.js dependencies
COPY package*.json ./
RUN npm install

# Copy the rest of the application
COPY . .

# Expose port
EXPOSE 5000

# Start the application
CMD ["node", "index.js"]