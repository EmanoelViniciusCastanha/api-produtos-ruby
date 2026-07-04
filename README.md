# API de Produtos 📦

API REST de **controle de estoque** feita em Ruby on Rails 8. Cada produto tem um
saldo que só muda através de **movimentações** (entradas e saídas) — assim o
histórico fica registrado e o estoque nunca fica negativo.

## Requisitos

- Ruby 3.3+
- Rails 8+
- (o banco é SQLite, já vem embutido)

## Como rodar

```bash
bundle install        # instala as dependências
rails db:migrate      # cria as tabelas
rails db:seed         # cadastra produtos de exemplo
rails server -p 8080  # sobe a API em http://localhost:8080
```

## Documentação das rotas (Swagger)

Com o servidor rodando, abra no navegador:

```
http://localhost:8080/api-docs
```

Lá dá pra ver todas as rotas e testar direto pela tela.

## Rodar os testes

```bash
bundle exec rspec
```

## Rotas principais

| Método | Rota | O que faz |
|---|---|---|
| GET | `/produtos` | Lista os produtos (filtro: `?categoria=Alimentos`) |
| POST | `/produtos` | Cadastra um produto |
| GET | `/produtos/:id` | Detalha um produto |
| PATCH | `/produtos/:id` | Atualiza um produto |
| DELETE | `/produtos/:id` | Remove um produto |
| GET | `/produtos/relatorio` | Relatório do estoque |
| GET | `/produtos/:id/movimentacoes` | Histórico de entradas/saídas |
| POST | `/produtos/:id/movimentacoes` | Registra uma entrada ou saída |

### Exemplo: dar entrada de 20 unidades

```bash
curl -X POST http://localhost:8080/produtos/1/movimentacoes \
  -H "Content-Type: application/json" \
  -d '{"movimentacao":{"tipo":"entrada","quantidade":20}}'
```

---

Projeto feito para praticar a base da lógica de programação (variáveis e
constantes, operadores, condicionais, repetição, arrays e funções) dentro de uma
API real.
