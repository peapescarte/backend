defmodule PescarteWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use PescarteWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  alias Ecto.Adapters.SQL.Sandbox
  alias Pescarte.Factory

  using do
    quote do
      use PescarteWeb, :verified_routes
      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import PescarteWeb.ConnCase

      alias PescarteWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint PescarteWeb.Endpoint
    end
  end

  setup tags do
    pid = Sandbox.start_owner!(Pescarte.Repo, shared: not tags[:async])

    on_exit(fn -> Sandbox.stop_owner(pid) end)

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end

  @doc """
  Assistente de configuração que registra e efetua login do usuário.

      setup :register_and_log_in_user

  Armazena uma conexão atualizada e um usuário cadastrado no
  contexto de teste.
  """
  def register_and_log_in_user(%{conn: conn}) do
    user = Factory.insert(:user)
    %{conn: log_in_user(conn, user), user: user}
  end

  @doc """
  Registra o `usuário` fornecido no `conn`.

  Ele retorna um `conn` atualizado.
  """
  def log_in_user(conn, user) do
    token = Pescarte.Accounts.generate_user_session_token(user)

    conn
    |> Phoenix.ConnTest.init_test_session(%{})
    |> Plug.Conn.put_session(:user_token, token)
  end
end
