defmodule Pescarte.Catalogo.Models.NomeComumPeixe do
  use Pescarte, :model

  @type t :: %NomeComumPeixe{
          nome_comum: binary,
          nome_cientifico: binary,
          comunidade_nome: binary,
          validado?: boolean
        }

  @required_fields ~w(nome_comum nome_cientifico comunidade_nome)a
  @optional_fields ~w(validado?)a

  @primary_key false
  schema "nome_comum_peixe" do
    field :nome_comum, :string, primary_key: true
    field :nome_cientifico, :string, primary_key: true
    field :comunidade_nome, :string, primary_key: true
    field :validado?, :boolean, default: false

    timestamps()
  end

  @spec changeset(NomeComumPeixe.t(), map) :: changeset
  def changeset(nome_comum_peixe, attrs) do
    nome_comum_peixe
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end

  def create(params) do
    %__MODULE__{}
    |> changeset(params)
    |> Repo.insert()
  end
end
