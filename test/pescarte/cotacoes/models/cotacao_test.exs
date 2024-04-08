defmodule Cotacoes.Models.CotacaoTest do
  use Pescarte.DataCase, async: true

  import Pescarte.Fixtures

  alias Pescarte.Cotacoes.Models.Cotacao

  @moduletag :unit

  test "changeset valido com campos obrigatorios" do
    fonte = insert(:fonte)

    attrs = %{
      data: Date.utc_today(),
      fonte_id: fonte.id,
      link: "https://example.com",
      tipo: :pdf
    }

    changeset = Cotacao.changeset(%Cotacao{}, attrs)

    assert changeset.valid?
    assert get_change(changeset, :data) == Date.utc_today()
    assert get_change(changeset, :fonte_id) == fonte.id
    assert get_change(changeset, :link) == "https://example.com"
  end

  test "changeset valido com campos opcionais" do
    fonte = insert(:fonte)

    attrs = %{
      data: Date.utc_today(),
      fonte_id: fonte.id,
      link: "https://example.com",
      tipo: :pdf,
      importada?: true
    }

    changeset = Cotacao.changeset(%Cotacao{}, attrs)

    assert changeset.valid?
    assert get_change(changeset, :data) == Date.utc_today()
    assert get_change(changeset, :fonte_id) == fonte.id
    assert get_change(changeset, :link) == "https://example.com"
  end

  test "changeset invalido sem campos obrigatorios" do
    changeset = Cotacao.changeset(%Cotacao{}, %{})

    refute changeset.valid?
    assert Keyword.get(changeset.errors, :data)
    assert Keyword.get(changeset.errors, :link)
    assert Keyword.get(changeset.errors, :fonte_id)
  end
end
