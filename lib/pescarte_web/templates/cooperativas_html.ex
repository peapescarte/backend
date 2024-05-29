defmodule PescarteWeb.CooperativasHTML do
  use PescarteWeb, :html

  embed_templates("cooperativas_html/*")

  def handle_event("dialog", _value, socket) do
    {:noreply, socket}
  end
end
