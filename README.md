# 🌟 NovoAlento

**Respire novamente, cresça sempre.**

Plataforma SaaS de recuperação e gestão de negócios projetada para empreendedores que enfrentam desafios. NovoAlento oferece controle total sobre finanças, inventário e operações comerciais através de um dashboard intuitivo com métricas em tempo real.

**Para negócios que precisam se reinventar. Para vidas que precisam continuar.**

Construída com **Ruby on Rails 8** e **PostgreSQL**, com autenticação segura, gestão multi-tenant, análise financeira avançada e relatórios de inventário.

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

## 📊 Funcionalidades Principais

- **Dashboard Financeiro** — Visualização em tempo real de receitas, despesas, margens e lucro líquido
- **Gestão de Inventário** — Controle de produtos, estoque e histórico de transações
- **Relatórios** — Análise de vendas e compras por período (mês/ano)
- **Multi-tenant** — Suporte a múltiplas empresas por usuário
- **Autenticação Segura** — Integração com Devise
- **Interface Responsiva** — Design profissional optimizado para desktop e mobile
- **Internacionalização** — 100% em português

## 🏗️ Estrutura do Banco

| Modelo     | Descrição                                           |
| ---------- | --------------------------------------------------- |
| `User`     | Usuário autenticado via Devise                      |
| `Company`  | Negócio/empreendimento do usuário                   |
| `Item`     | Produto ou serviço comercializado                   |
| `Purchase` | Transação de compra ou venda com impacto financeiro |

## 🗺️ Rotas Principais

| Rota             | Funcionalidade                    |
| ---------------- | --------------------------------- |
| `/`              | Home e landing page               |
| `/dashboard`     | Painel financeiro em tempo real   |
| `/companies`     | Gerenciamento de negócios         |
| `/items`         | Catálogo de produtos/serviços     |
| `/purchases`     | Histórico e gestão de transações  |
| `/users/sign_in` | Login (Devise)                    |
| `/users/sign_up` | Cadastro de novo usuário (Devise) |
