defmodule PescarteWeb.GraphQL.Middlewares.EnsureAuthentication do
  @behaviour Absinthe.Middleware

  def call(%{context: %{current_user: _}} = resolution, _) do
    resolution
  end

  def call(%{context: %{}} = resolution, _) do
    path_names = Enum.map(resolution.path, & &1.name)

    if "login" in path_names do
      resolution
    else
      %{resolution | errors: ["Usuário não autenticado"]}
    end
  end

  def call(resolution, _), do: resolution
end
