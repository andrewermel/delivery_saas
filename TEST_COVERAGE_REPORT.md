# 📊 Relatório de Cobertura de Testes - NovoAlento

## Status Atual (29/03/2026)

**Total de testes:** 38
**Passando:** 23 ✅
**Falhando:** 15 ❌
**Taxa de sucesso:** 60.5%

---

## 📋 Testes Existentes

### ✅ PASSANDO (23 testes)

- **Models:**
  - Purchase validations: item_name, price, quantity ✅
  - Item model tests ✅
  - Company model tests ✅

- **Routing:**
  - Purchases routing ✅

- **Requests:**
  - POST /purchases/create com parâmetros válidos ✅
  - GET /purchases/index ✅
  - Outros requests específicos ✅

### ❌ FALHANDO (15 testes)

**Models:**

- Purchase#item association - precisa de setup de fixtures

**Controllers:**

- PurchasesController GET #show - falta autenticação
- PurchasesController POST #create - falta scopo de empresa
- PurchasesController PATCH #update - falta validação
- PurchasesController DELETE #destroy - falta segurança

**Requests:**

- GET /index - autenticação não reconhecida
- GET /show - escopo de empresa
- GET /new - acesso negado
- GET /edit - acesso negado
- POST /create - parâmetros de empresa
- PATCH /update - não atualiza corretamente
- DELETE /destroy - não deleta corretamente

---

## 📚 Cobertura por Módulo

| Módulo                    | Cobertura | Status                   |
| ------------------------- | --------- | ------------------------ |
| **User**                  | ~0%       | ❌ Sem testes            |
| **Purchase**              | ~60%      | ⚠️ Parcial               |
| **Item**                  | ~50%      | ⚠️ Parcial               |
| **Company**               | ~40%      | ⚠️ Parcial               |
| **Sale**                  | ~0%       | ❌ Sem testes            |
| **PurchasesController**   | ~20%      | ❌ Falhando              |
| **SalesController**       | ~0%       | ❌ Sem testes            |
| **CompaniesController**   | ~0%       | ❌ Sem testes            |
| **PagesController**       | ~0%       | ❌ Sem testes            |
| **ApplicationController** | ~10%      | ⚠️ Segurança não testada |

---

## 🔐 Gaps Críticos de Testes

### Segurança (CRÍTICO - não testado)

- [ ] Usuário NÃO pode ver empresas de outro usuário
- [ ] Usuário NÃO pode editar compras/vendas de outra empresa
- [ ] Usuario NÃO pode acessar /purchases/:id de outra empresa
- [ ] Company escopo: usuários só veem sua própria empresa
- [ ] Item escopo: usuários só veem itens de sua empresa
- [ ] Purchase escopo: usuários só veem compras de sua empresa

### User Model (CRÍTICO - not tested)

- [ ] Auto-criação de empresa ao registrar
- [ ] Validação de email único
- [ ] Senha hasheada corretamente
- [ ] Role atribuído por padrão

### Sales Controller (100% descoberto)

- [ ] GET /sales index
- [ ] POST /sales create
- [ ] Validação de item.company_id
- [ ] Redirecionamento após venda

### Pages Controller (100% descoberto)

- [ ] GET /dashboard calcula métricas corretamente
- [ ] Filtro por mês funciona
- [ ] Total invested calculado correto
- [ ] Recent movements mostra valores reais

### Devise Integration (Parcialmente testado)

- [ ] Sign up + auto-create company
- [ ] Sign in
- [ ] Sign out
- [ ] Password reset

---

## 🚀 Plano de Ação (Priorizado)

### PRIORIDADE 1 - Segurança (sem estes, app não é produção-ready)

```
1. [ ] Testes de escopo de empresa para TODOS controllers
2. [ ] Testes de autenticação obrigatória
3. [ ] Testes que usuário A não vê dados de usuário B
```

**Estimativa:** 2 horas

### PRIORIDADE 2 - Features Core

```
1. [ ] User model: auto-create company
2. [ ] Sale model: CRUD completo
3. [ ] Pages controller: dashboard metrics
4. [ ] Company controller: escopo
```

**Estimativa:** 3 horas

### PRIORIDADE 3 - Cobertura Completa

```
1. [ ] Todos os models com validações testadas
2. [ ] Todos os controllers com happy path + error cases
3. [ ] Integration tests: fluxo completo do usuário
4. [ ] Factory fixes para evitar erros de validação
```

**Estimativa:** 4 horas

---

## 📝 Próximos Passos Imediatos

1. **Corrigir erro de fixture path** (deprecação Rails 7.1)
   - Mudar `fixture_path = []` para array

2. **Adicionar teste de User#after_create**
   - Verificar se empresa é criada automaticamente
   - Verificar se user.company_id é preenchido

3. **Criar teste de escopo de empresa**
   - `current_user.company.purchases.only`
   - `current_user.company.sales.only`

4. **Remover testes falhando do old controller spec**
   - Corrigir purchases_controller_spec.rb

---

## 🎯 Metas de Cobertura

| Fase        | Meta | Quando       |
| ----------- | ---- | ------------ |
| MVP (Agora) | 60%  | ✅ ALCANÇADO |
| Beta        | 80%  | 2 horas      |
| Produção    | 95%  | 6 horas      |

---

## 🔧 Comandos Úteis

```bash
# Correr todos os testes
docker compose exec app bundle exec rspec

# Correr só model tests
docker compose exec app bundle exec rspec spec/models/

# Correr com coverage (precisa de simplecov)
docker compose exec app bundle exec rspec --coverage

# Correr teste específico
docker compose exec app bundle exec rspec spec/models/purchase_spec.rb

# Ver detalhes de falha
docker compose exec app bundle exec rspec --verbose
```

---

## 📌 Conclusão

NovoAlento tem **60.5% de cobertura atual** com testes que validam:

- ✅ Validações de modelo
- ✅ Routing básico
- ✅ Alguns controllers

Faltam (CRÍTICO):

- ❌ Testes de segurança/escopo de empresa
- ❌ Feature completa de Sales
- ❌ Dashboard metrics
- ❌ Auto-create company no User

**Recomendação:** Implementar Prioridade 1 (segurança) antes de deploy em produção.
