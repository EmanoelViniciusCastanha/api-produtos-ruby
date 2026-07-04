# Produtos de exemplo. Rode com: rails db:seed
Movimentacao.delete_all
Produto.delete_all

# Cada item vira um produto e uma entrada inicial; o Feijão ainda leva uma
# saída pra sobrar saldo zero e aparecer como "SEM ESTOQUE" no relatório.
itens = [
  { nome: "Notebook Dell",   categoria: "Eletrônicos", preco: 3500.00, estoque_minimo: 5,  entrada: 12 },
  { nome: "Mouse sem fio",   categoria: "Eletrônicos", preco: 89.90,   estoque_minimo: 10, entrada: 3 },
  { nome: "Arroz 5kg",       categoria: "Alimentos",   preco: 24.50,   estoque_minimo: 15, entrada: 40 },
  { nome: "Feijão 1kg",      categoria: "Alimentos",   preco: 8.90,    estoque_minimo: 8,  entrada: 8, saida: 8 },
  { nome: "Detergente",      categoria: "Limpeza",     preco: 2.99,    estoque_minimo: 20, entrada: 25 },
  { nome: "Camiseta básica", categoria: "Vestuário",   preco: 39.90,   estoque_minimo: 10, entrada: 7 }
]

itens.each do |dados|
  produto = Produto.create!(dados.slice(:nome, :categoria, :preco, :estoque_minimo))
  RegistrarMovimentacao.call(produto: produto, tipo: "entrada", quantidade: dados[:entrada], observacao: "Estoque inicial")
  RegistrarMovimentacao.call(produto: produto, tipo: "saida", quantidade: dados[:saida], observacao: "Venda") if dados[:saida]
end

puts "#{Produto.count} produtos e #{Movimentacao.count} movimentações cadastrados com sucesso!"
