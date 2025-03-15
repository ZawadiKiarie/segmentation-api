FROM node:18

# Install Python and pip
RUN apt-get update && \
    apt-get install -y python3 python3-pip python3-dev

# Install required system dependencies for ultralytics
RUN apt-get install -y ffmpeg libsm6 libxext6 cmake build-essential

# Set working directory
WORKDIR /app

# Ensure uploads directory exists
RUN mkdir -p uploads

# Copy package.json and package-lock.json first to leverage Docker cache
COPY package*.json ./
RUN npm install

# Copy Python requirements file and install dependencies
COPY requirements.txt ./
RUN pip3 install --no-cache-dir -r requirements.txt

# Copy the rest of the application
COPY . .

# Expose port for the application
EXPOSE 5000

# Start the application
CMD ["node", "index.js"]