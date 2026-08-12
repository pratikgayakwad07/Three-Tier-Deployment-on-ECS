# This is a Dockerfile for the backend application.
FROM node:24
# Set the working directory inside the container
WORKDIR /backend
# Copy package.json and package-lock.json to the working directory
COPY package*.json ./
# Install dependencies using npm ci for a clean install
RUN npm ci
# Copy the rest of the application code to the working directory
COPY . .
# Expose the port that the backend application will run on
EXPOSE 5003
# Start the backend application using npm start
CMD ["npm", "start"]
