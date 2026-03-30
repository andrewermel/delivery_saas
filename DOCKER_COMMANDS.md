# 🐳 Comandos Docker - Guia Seguro

## ✅ COMANDOS SEGUROS (Preservam dados):

```bash
# Iniciar a aplicação
docker compose up

# Iniciar em background
docker compose up -d

# Parar containers (SEM apagar dados)
docker compose down

# Reiniciar tudo
docker compose restart

# Ver logs em tempo real
docker compose logs -f

# Acessar console da aplicação
docker compose exec app bundle exec rails console

# Rodar migrations
docker compose exec app bundle exec rails db:migrate
```

---

## ❌ NUNCA USE (Apaga dados):

```bash
docker compose down -v              # APAGA BANCO DE DADOS!
docker compose down --volumes       # APAGA BANCO DE DADOS!
docker system prune -a --volumes    # APAGA TUDO!
```

---

## 🔧 Se Precisar Limpar Completamente (AVISO: Perde dados):

```bash
# 1. Fazer backup primeiro
docker compose exec db pg_dump -U appuser ermeltech_saas_development > backup.sql

# 2. Depois apagar tudo
docker compose down -v --remove-orphans

# 3. Reconstruir
docker compose up
```

---

## 📋 Workflow Recomendado:

```bash
# Dia a dia
docker compose up -d          # Iniciar
docker compose logs -f        # Ver logs
docker compose down           # Parar (dados ficam salvos!)

# Próximo dia
docker compose up             # Dados ainda estão lá!
```
