require "rails_helper"

RSpec.describe RelatorioEstoque, type: :service do
  def produto(attrs)
    Produto.create!({ nome: "P", categoria: "Geral", preco: 10.0, estoque_minimo: 5 }.merge(attrs))
  end

  let(:produtos) do
    [
      produto(nome: "Cheio",  categoria: "Alimentos", saldo: 40, preco: 5.0,  estoque_minimo: 10),
      produto(nome: "Baixo",  categoria: "Limpeza",   saldo: 3,  preco: 2.0,  estoque_minimo: 10),
      produto(nome: "Zerado", categoria: "Alimentos", saldo: 0,  preco: 8.0,  estoque_minimo: 5)
    ]
  end

  subject(:relatorio) { RelatorioEstoque.gerar(produtos) }

  it "conta o total de produtos" do
    expect(relatorio[:total_de_produtos]).to eq(3)
  end

  it "soma as unidades em estoque" do
    expect(relatorio[:unidades_totais]).to eq(43)
  end

  it "soma o valor total imobilizado" do
    expect(relatorio[:valor_total_estoque]).to eq(40 * 5.0 + 3 * 2.0 + 0 * 8.0)
  end

  it "lista os itens que estão no limite ou zerados" do
    nomes = relatorio[:itens_criticos].map { |i| i[:nome] }
    expect(nomes).to contain_exactly("Baixo", "Zerado")
  end

  it "aponta a categoria com mais unidades" do
    expect(relatorio[:categoria_mais_estoque]).to eq("Alimentos")
  end

  it "devolve uma barra visual por produto" do
    expect(relatorio[:niveis_de_estoque].size).to eq(3)
  end
end
