defmodule PescarteWeb.ErrorViewTest do
  use PescarteWeb.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  @moduletag :integration

  test "renders 404.json" do
    assert render(PescarteWeb.ErrorView, "404.json", []) == %{error: %{details: "Not Found"}}
  end

  test "renders 500.json" do
    assert render(PescarteWeb.ErrorView, "500.json", []) ==
             %{error: %{details: "Internal Server Error"}}
  end

  test "renders error with details" do
    assert render(PescarteWeb.ErrorView, "error.json", reason: "Error test", resource_id: 1) ==
             %{error: %{details: "Error test", resourceId: 1}}
  end
end
