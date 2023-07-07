defmodule CotacoesETL.Integrations do
  alias CotacoesETL.Integrations.PesagroAPI

  def pesagro_api do
    Application.get_env(:cotacoes_etl, :pesagro_api, PesagroAPI)
  end
end
