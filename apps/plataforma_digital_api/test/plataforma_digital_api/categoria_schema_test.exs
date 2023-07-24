defmodule PlataformaDigitalAPI.CategoriaSchemaTest do
  use PlataformaDigitalAPI.ConnCase, async: true

  import ModuloPesquisa.Factory

  @moduletag :integration

  describe "listar categorias query" do
    setup :register_and_generate_jwt_token

    @list_categorias_query """
    query ListarCategorias {
      listarCategorias {
        id
        nome
        tags {
          id
          etiqueta
          categoria {
            id
          }
        }
      }
    }
    """

    test "quando não há nenhuma categoria", %{conn: conn} do
      conn = post(conn, "/", %{"query" => @list_categorias_query})

      assert %{"data" => %{"listarCategorias" => []}} = json_response(conn, 200)
    end

    test "quando há categoria", %{conn: conn} do
      categoria = insert(:categoria)
      conn = post(conn, "/", %{"query" => @list_categorias_query})

      assert %{"data" => %{"listarCategorias" => [listed]}} = json_response(conn, 200)
      assert listed["id"] == categoria.id_publico
      assert listed["nome"] == categoria.nome
    end

    test "quando há categoria e nenhuma tag, recuperar tags vazia", %{conn: conn} do
      categoria = insert(:categoria)
      conn = post(conn, "/", %{"query" => @list_categorias_query})

      assert %{"data" => %{"listarCategorias" => [listed]}} = json_response(conn, 200)
      assert listed["id"] == categoria.id_publico
      assert listed["nome"] == categoria.nome
      assert Enum.empty?(listed["tags"])
    end
  end
end
