defmodule PescarteWeb.GraphQL.Types.Midia do
  use Absinthe.Schema.Notation

  alias PescarteWeb.GraphQL.Resolvers

  @desc "Tipos possíveis de Midias"
  enum :midia_type do
    value(:imagem)
    value(:documento)
    value(:video)
  end

  @desc "Representa uma Mídia genérica da plataforma"
  object :midia do
    field :filename, :string
    field :filedate, :date
    field :link, :string
    field :sensible?, :boolean, name: "sensible"
    field :type, :midia_type
    field :observation, :string
    field :alt_text, :string
    field :public_id, :string, name: "id"

    field :tags, list_of(:tag) do
      resolve(&Resolvers.Tag.list_midias/3)
    end
  end
end
