# Implantação da Aplicação Guess Game

## Visão Geral

Este projeto implanta a aplicação **Guess Game** usando Docker Compose. A configuração inclui:

1. Um **backend Flask** que fornece a API do jogo.
2. Um **banco de dados Postgres** para persistir os dados do jogo.
3. Um **container NGINX** que atua como proxy reverso, balanceador de carga para o backend e hospeda o frontend React.

Essa configuração fornece um ambiente modular, escalável e de fácil manutenção para implantar a aplicação Guess Game. Usando Docker Compose, os serviços podem ser gerenciados, atualizados e depurados de forma eficiente.

---

## Escolhas de Design

### **Serviços**

- **Backend (Flask):**

  - Executa a aplicação Python Flask para gerenciar a lógica do jogo e requisições da API.
  - Exposto na porta 5000 para comunicação com o proxy NGINX.

- **Frontend (React):**

  - Construído e servido pelo NGINX a partir do diretório `/usr/share/nginx/html`.
  - O frontend React interage com o backend através do NGINX.

- **Banco de Dados Postgres:**

  - Armazena os dados relacionados ao jogo de forma persistente.
  - Configurado com um volume para garantir a preservação dos dados entre reinicializações dos containers.

- **NGINX:**

  - Atua como proxy reverso para redirecionar requisições para o backend.
  - Realiza balanceamento de carga entre múltiplas instâncias do backend.
  - Serve arquivos estáticos (build do frontend).

### **Volumes**

- Os dados do banco de dados são armazenados em um volume persistente para garantir durabilidade e resiliência contra reinicializações.
- A configuração do NGINX e o build do frontend são mapeados como volumes para facilitar atualizações.

### **Redes**

- Todos os serviços estão conectados por meio de uma única rede bridge (`guessgame-network`) para comunicação segura e eficiente.

### **Estratégia de Balanceamento de Carga**

- O NGINX utiliza a estratégia round-robin por padrão para distribuir o tráfego de forma uniforme entre as instâncias do backend.

---

## Pré-requisitos

1. Docker e Docker Compose instalados na máquina host.
2. Clone o repositório:
   ```bash
   git clone https://github.com/Gio-devops/dockerguessgame.git
   cd dockerguessgame
   ```
3. Instale o `nvm` (Node Version Manager) para garantir compatibilidade com a versão necessária do Node.js. Se não tiver o nvm instalado, siga o [tutorial](https://github.com/nvm-sh/nvm?tab=readme-ov-file#installing-and-updating)

---

## Instalação e Configuração

### 1. Construir e Executar os Serviços

Use o seguinte comando para construir e executar todos os serviços:

```bash
docker compose up --build -d
```

Isso irá:

- Construir e iniciar os containers para backend, frontend, NGINX e Postgres.
- Criar as redes e volumes necessários.

### 2. Acessar a Aplicação

- Abra o navegador e acesse http://localhost:3000.

### 3. Variáveis de Ambiente

Caso seja necessário, defina as variáveis de ambiente no arquivo `docker-compose.yml` para configurar os serviços. Alguns exemplos das principais variáveis incluem:

- **Postgres:** `POSTGRES_USER`, `POSTGRES_PASSWORD`, `POSTGRES_DB`
- **Backend:** `FLASK_ENV`, `FLASK_DB_*`

---

## Atualizando os Serviços

### Backend

Para atualizar a aplicação backend:

1. Modifique o código no diretório `backend/`.
2. Reconstrua a imagem do backend:
   ```bash
   docker-compose build backend
   ```
3. Reinicie o serviço:
   ```bash
   docker-compose up -d backend
   ```

### Frontend

Para atualizar a aplicação frontend:

1. Modifique o código React no diretório `frontend/`.
2. Construa o app React:
   ```bash
   cd frontend
   yarn start #dev
   or
   yarn build #prod
   ```
3. Copie o build para o container NGINX e reinicie-o:
   ```bash
   docker-compose up -d nginx
   ```

### Postgres

Para atualizar o serviço de banco de dados:

1. Atualize a versão da imagem `postgres` no arquivo `docker-compose.yml`.
2. Reinicie o serviço do banco de dados:
   ```bash
   docker-compose up -d postgres
   ```

---

## Solução de Problemas

### Problemas Comuns

1. **NGINX Retorna 502 Bad Gateway:**

   - Verifique se os containers do backend estão em execução e acessíveis na porta 5000.
   - Confira os logs:
     ```bash
     docker logs nginx
     ```

2. **Problemas de Conexão com o Banco de Dados:**

   - Confirme se as credenciais do banco de dados correspondem às variáveis de ambiente no arquivo `start-backend.sh`.
   - Verifique se o container Postgres está em execução e acessível:
     ```bash
     docker exec -it guessgame-db psql -U postgres
     ```

### Ferramentas de Depuração

- Use `docker exec` para acessar os containers e depurar:
  ```bash
  docker exec -it <container-name> sh
  ```
- Verifique os logs de cada serviço:
  ```bash
  docker logs <container-name>
  ```
