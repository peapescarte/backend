defmodule Pescarte.ModuloPesquisa.Handlers.MidiasHandler do
  @moduledoc false

  alias Ecto.Multi
  alias Pescarte.Database.Repo
  alias Pescarte.Identidades.Handlers.UsuarioHandler
  alias Pescarte.ModuloPesquisa.Handlers.IManageMidiasHandler
  alias Pescarte.ModuloPesquisa.Repository

  @behaviour IManageMidiasHandler

  @impl true
  def add_tags_to_midia(midia_id, tags_id) do
    with {:ok, midia} <- Repository.fetch_midia(midia_id),
         tags <- Repository.fetch_tags_from_ids(tags_id),
         {:ok, midia} <- Repository.upsert_midia(midia, %{tags: midia.tags ++ tags}) do
      {:ok, midia.tags}
    end
  end

  @impl true
  defdelegate create_categoria(attrs), to: Repository, as: :upsert_categoria

  @impl true
  defdelegate create_midia(attrs), to: Repository, as: :upsert_midia

  @impl true
  def create_midia_and_tags(attrs, tags_attrs) do
    with {:ok, user} <- UsuarioHandler.fetch_usuario(attrs.autor_id),
         {:ok, raw_tags} <- put_categorias_ids(tags_attrs) do
      attrs
      |> Map.update!(:autor_id, fn _ -> user.id end)
      |> Repository.create_midia_and_tags_multi(raw_tags)
    end
  end

  defp put_categorias_ids(tags) do
    state = %{success: [], errors: []}

    tags
    |> Enum.reduce(state, fn %{categoria_id: id} = tag, state ->
      case Repository.fetch_categoria(id) do
        {:ok, categoria} ->
          success = [Map.put(tag, :categoria_nome, categoria.nome) | state[:success]]

          %{state | success: success}

        {:error, :not_found} ->
          error = "Categoria id #{id} é inválida"
          errors = [error | state[:errors]]

          %{state | errors: errors}
      end
    end)
    |> case do
      %{errors: [], success: tags} -> {:ok, tags}
      %{errors: errors} -> {:error, errors}
    end
  end

  @impl true
  def create_tag(%{categoria_id: cat_id} = attrs) do
    case Repository.fetch_categoria(cat_id) do
      {:ok, categoria} ->
        case Repository.fetch_tag_by_etiqueta(attrs.etiqueta) do
          {:error, :not_found} ->
            attrs
            |> Map.put(:categoria_nome, categoria.nome)
            |> Repository.upsert_tag()

          {:ok, tag} ->
            {:ok, tag}
        end

      error ->
        error
    end
  end

  @impl true
  def create_multiple_tags(attrs_list) do
    attrs_list
    |> Enum.with_index()
    |> Enum.reduce(Ecto.Multi.new(), fn {attrs, idx}, multi ->
      Multi.run(multi, :"tag-#{idx}", fn _, _ ->
        __MODULE__.create_tag(attrs)
      end)
    end)
    |> Repo.transaction()
    |> case do
      {:ok, changes} -> {:ok, Map.values(changes)}
      {:error, _, changeset, _} -> {:error, changeset}
    end
  end

  @impl true
  defdelegate fetch_categoria(categoria_nome), to: Repository

  @impl true
  defdelegate fetch_midia(midia_link), to: Repository, as: :fetch_midia

  @impl true
  defdelegate list_categoria, to: Repository

  @impl true
  defdelegate list_midia, to: Repository

  @impl true
  defdelegate list_midias_from_tag(tag_etiqueta), to: Repository

  @impl true
  defdelegate list_tag, to: Repository

  @impl true
  defdelegate list_tags_from_categoria(categoria_id), to: Repository

  @impl true
  defdelegate list_tags_from_midia(midia_id), to: Repository

  @impl true
  def remove_tags_from_midia(midia_id, []) do
    with {:ok, _} <- Repository.fetch_midia(midia_id) do
      {:ok, []}
    end
  end

  def remove_tags_from_midia(midia_id, tags_ids) do
    with {:ok, midia} <- Repository.fetch_midia(midia_id),
         tags_ids = Enum.map(midia.tags, & &1.id) -- tags_ids,
         new_tags = Enum.filter(midia.tags, &(&1.id in tags_ids)),
         {:ok, midia} <- Repository.upsert_midia(midia, %{tags: new_tags}) do
      {:ok, midia.tags}
    end
  end

  @impl true
  def update_midia(attrs) do
    with {:ok, midia} <- Repository.fetch_midia(attrs.id) do
      Repository.upsert_midia(midia, attrs)
    end
  end

  @impl true
  def update_tag(attrs) do
    with {:ok, tag} <- Repository.fetch_tag(attrs.id) do
      Repository.upsert_tag(tag, attrs)
    end
  end
end
