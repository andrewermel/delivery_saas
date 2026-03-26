# Delivery SaaS

Aplicação web multi-tenant para gestão de delivery, construída com **Ruby on Rails 8** e **PostgreSQL**. Inclui autenticação de usuários, gerenciamento de empresas, itens e pedidos.

## Tecnologias

- **Ruby** 3.3.9
- **Rails** 8.0.2
- **PostgreSQL** 15
- **Devise** — autenticação de usuários
- **Puma** — servidor web
- **Docker** — ambiente de desenvolvimento isolado

## Como rodar (com Docker)

> Pré-requisito: ter o [Docker Desktop](https://www.docker.com/products/docker-desktop/) instalado. Funciona em **Windows, Linux e Mac**.

```bash
# 1. Clone o repositório
git clone <url-do-repositorio>
cd delivery_Saas

# 2. Suba a aplicação
docker compose up
```

Na primeira execução o Docker vai:

1. Construir a imagem da aplicação
2. Subir o banco PostgreSQL
3. Criar e migrar o banco automaticamente
4. Iniciar o servidor Rails

Acesse em: **http://localhost:3000**

Para parar: `Ctrl+C` ou `docker compose down`

## Comandos úteis

```bash
# Subir sem rebuild (uso diário, mais rápido)
docker compose up

# Subir com rebuild da imagem (após mudar Gemfile ou Dockerfile.dev)
docker compose up --build

# Rodar em background
docker compose up -d

# Parar e remover containers
docker compose down

# Ver logs em tempo real
docker compose logs -f app

# Rails console
docker compose exec app bundle exec rails console

# Rodar migrations
docker compose exec app bundle exec rails db:migrate

# Rodar testes (RSpec)
docker compose exec app bundle exec rspec
```

## Estrutura do banco

| Modelo     | Descrição                        |
| ---------- | -------------------------------- |
| `User`     | Usuário autenticado via Devise   |
| `Company`  | Empresa cadastrada na plataforma |
| `Item`     | Produto/item do cardápio         |
| `Purchase` | Pedido realizado                 |

## Rotas principais

| Rota             | Controller        |
| ---------------- | ----------------- |
| `/`              | `companies#index` |
| `/companies`     | CRUD de empresas  |
| `/items`         | CRUD de itens     |
| `/purchases`     | CRUD de pedidos   |
| `/users/sign_in` | Login (Devise)    |
| `/users/sign_up` | Cadastro (Devise) |
