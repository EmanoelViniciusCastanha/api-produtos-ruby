# Monta o relatório consolidado do estoque a partir da lista de produtos.
class RelatorioEstoque
  TAXA_IMPOSTO = 0.10

  def self.gerar(produtos)
    valor_total        = 0.0
    unidades_totais    = 0
    itens_criticos     = []
    contagem_categoria = Hash.new(0)

    produtos.each do |produto|
      valor_total     += produto.valor_em_estoque
      unidades_totais += produto.saldo
      contagem_categoria[produto.categoria] += produto.saldo
      itens_criticos << produto.resumo if produto.estoque_baixo?
    end

    {
      total_de_produtos:      produtos.size,
      unidades_totais:        unidades_totais,
      valor_total_estoque:    valor_total.to_f.round(2),
      custo_reposicao:        custo_reposicao(itens_criticos.size),
      itens_criticos:         itens_criticos,
      categoria_mais_estoque: categoria_lider(contagem_categoria),
      niveis_de_estoque:      escala_visual(produtos)
    }
  end

  def self.custo_reposicao(qtd_itens_criticos)
    custo_base = qtd_itens_criticos * 50.0
    (custo_base + custo_base * TAXA_IMPOSTO).round(2)
  end

  def self.categoria_lider(contagem_categoria)
    lider = nil
    maior = -1

    contagem_categoria.each do |categoria, quantidade|
      if quantidade > maior
        maior = quantidade
        lider = categoria
      end
    end

    lider || "Nenhuma"
  end

  # Desenha uma barrinha por produto pra visualizar o nível de estoque num relance.
  def self.escala_visual(produtos)
    linhas = []

    produtos.each do |produto|
      barra = ""
      contador = 0
      blocos = produto.saldo > 20 ? 20 : produto.saldo

      while contador < blocos
        barra += "█"
        contador += 1
      end

      icone = case produto.situacao
      when "SEM ESTOQUE" then "⛔"
      when "ESTOQUE BAIXO" then "⚠️"
      else "✅"
      end

      linhas << "#{icone} #{produto.nome}: #{barra} (#{produto.saldo})"
    end
    linhas
  end
end
