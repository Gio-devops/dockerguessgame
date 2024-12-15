# Dockerfile para Backend (Flask)
FROM python:3.10-slim

# Definir diretório de trabalho
WORKDIR /venv

# Copiar o arquivo de dependências
COPY requirements.txt /venv/

# Instalar as dependências
RUN pip install --no-cache-dir -r requirements.txt

# Copiar o código fonte
COPY . /venv/

# Definir variável de ambiente
ENV FLASK_APP=run.py
ENV FLASK_ENV=production

# Expor a porta que o Flask usará
EXPOSE 5000

# Comando para rodar o backend
CMD ["flask", "run", "--host=0.0.0.0", "--port=5000"]
