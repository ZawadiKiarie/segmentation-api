FROM node:alpine

# Install Python and pip
RUN apk update && apk add --no-cache python3 py3-pip

# Install required system dependencies for ultralytics
RUN apk add --no-cache ffmpeg cmake build-base python3-dev

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