# Use uma imagem oficial do Node.js como base
FROM node:18.17.0

# Configure o diretório de trabalho dentro do contêiner
WORKDIR /app

# Copie os arquivos do projeto para o contêiner
COPY . .

# Instale o corepack para habilitar o Yarn
RUN corepack enable

# Instale as dependências do projeto usando npm
RUN npm install

# Configure a variável de ambiente para o backend
ENV REACT_APP_BACKEND_URL=http://localhost:5000

# Exponha a porta em que o frontend será executado
EXPOSE 3000

# Comando para iniciar o frontend
CMD ["yarn", "start"]
