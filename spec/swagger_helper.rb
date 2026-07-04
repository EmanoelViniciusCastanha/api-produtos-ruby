# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.openapi_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under openapi_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a openapi_spec tag to the
  # the root example_group in your specs, e.g. describe '...', openapi_spec: 'v2/swagger.json'
  config.openapi_specs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'API de Estoque de Produtos',
        version: 'v1',
        description: 'Controle de estoque com produtos e movimentações (entradas/saídas). ' \
                     'O saldo é derivado das movimentações e nunca fica negativo.'
      },
      paths: {},
      servers: [
        { url: 'http://localhost:{port}', variables: { port: { default: '8080' } } }
      ],
      components: {
        schemas: {
          Produto: {
            type: :object,
            properties: {
              id: { type: :integer, example: 1 },
              nome: { type: :string, example: 'Notebook Dell' },
              categoria: { type: :string, enum: Produto::CATEGORIAS_VALIDAS, example: 'Eletrônicos' },
              saldo: { type: :integer, example: 12 },
              preco: { type: :number, format: :float, example: 3500.0 },
              estoque_minimo: { type: :integer, example: 5 },
              situacao: { type: :string, enum: [ 'OK', 'ESTOQUE BAIXO', 'SEM ESTOQUE' ], example: 'OK' },
              valor_em_estoque: { type: :number, format: :float, example: 42000.0 }
            }
          },
          ProdutoInput: {
            type: :object,
            properties: {
              produto: {
                type: :object,
                properties: {
                  nome: { type: :string, example: 'Cadeira Gamer' },
                  categoria: { type: :string, enum: Produto::CATEGORIAS_VALIDAS, example: 'Geral' },
                  preco: { type: :number, format: :float, example: 899.9 },
                  estoque_minimo: { type: :integer, example: 3 }
                },
                required: %w[nome categoria preco estoque_minimo]
              }
            },
            required: %w[produto]
          },
          Movimentacao: {
            type: :object,
            properties: {
              id: { type: :integer, example: 1 },
              produto_id: { type: :integer, example: 1 },
              tipo: { type: :string, enum: %w[entrada saida], example: 'entrada' },
              quantidade: { type: :integer, example: 20 },
              observacao: { type: :string, nullable: true, example: 'Compra' },
              data: { type: :string, format: :'date-time' }
            }
          },
          MovimentacaoInput: {
            type: :object,
            properties: {
              movimentacao: {
                type: :object,
                properties: {
                  tipo: { type: :string, enum: %w[entrada saida], example: 'entrada' },
                  quantidade: { type: :integer, example: 20 },
                  observacao: { type: :string, example: 'Compra' }
                },
                required: %w[tipo quantidade]
              }
            },
            required: %w[movimentacao]
          },
          Erros: {
            type: :object,
            properties: {
              erros: { type: :array, items: { type: :string }, example: [ "Nome can't be blank" ] }
            }
          }
        }
      }
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The openapi_specs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.openapi_format = :yaml
end
