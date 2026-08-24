FROM node:22-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install --omit=dev --no-audit --no-fund
COPY index.js world_seed.js ./
COPY public ./public
ENV NODE_ENV=production
EXPOSE 8080
CMD ["npm", "start"]
