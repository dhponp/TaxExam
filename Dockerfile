FROM node:latest

# Create app directory
WORKDIR /src

# Install app dependencies
#COPY package*.json ./src

#RUN npm install
# RUN npm ci

COPY . .

EXPOSE 8080
CMD [ "node", "server.js" ]