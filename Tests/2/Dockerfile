FROM node:16-alpine

WORKDIR /app

COPY ./package.json .
COPY ./getBalanceLoop.js . 

RUN yarn install

#COPY . .

#CMD ["node", "getBalanceLoop.js"]
