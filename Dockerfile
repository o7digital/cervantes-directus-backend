# Usa Node 22 (Directus 11.12 lo requiere)
FROM node:22-alpine

# Define carpeta de trabajo
WORKDIR /app

# Copia package.json y package-lock.json
COPY package*.json ./

# Instala dependencias
RUN npm ci --omit=dev

# Copia el resto del proyecto
COPY . .

# Expone el puerto (Railway usará $PORT)
EXPOSE 8055

# Arranca Directus
CMD ["npx", "directus", "start"]
