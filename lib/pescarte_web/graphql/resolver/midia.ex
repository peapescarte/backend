defmodule PescarteWeb.GraphQL.Resolver.Midia do
  alias Pescarte.Domains.ModuloPesquisa.Handlers
  alias Pescarte.Domains.ModuloPesquisa.Models.Midia.Tag

  def create(%{input: %{tags: tags} = args}, _resolution) do
    Handlers.Midias.create_midia_and_tags(args, tags)
  end

  def create(%{input: args}, _resolution) do
    Handlers.Midias.create_midia(args)
  end

  def get(%{id: midia_id}, _resolution) do
    Handlers.Midias.fetch_midia(midia_id)
  end

  def list(_args, _resolution) do
    {:ok, Handlers.Midias.list_midia()}
  end

  def list_tags(%Tag{} = tag, _args, _resolution) do
    {:ok, Handlers.Midias.list_midias_from_tag(tag.etiqueta)}
  end

  def remove_tags(%{input: args}, _resolution) do
    Handlers.Midias.remove_tags_from_midia(args.midia_id, args.tags_id)
  end

  def update(%{input: args}, _resolution) do
    Handlers.Midias.update_midia(args)
  end
end
