FROM node:20 AS build 

WORKDIR /app

COPY package*.json ./

RUN npm install

# Copy the rest of the application code
COPY . .

# Build the application for production
RUN npm run build

# Install only production dependencies
RUN npm prune --production

######## Multi Stage Your App 

# Use a smaller image for running the app
FROM node:18-alpine AS runner

# Set the working directory in the container
WORKDIR /app

# Copy the built application from the builder stage
COPY --from=build /app ./

# Expose the port Next.js will run on
EXPOSE 3000

# Command to run the application
CMD ["npm", "start"]
