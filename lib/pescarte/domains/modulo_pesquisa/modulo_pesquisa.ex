defmodule Pescarte.Domains.ModuloPesquisa do
  @moduledoc """
  Módulo com funções públicas que realizam ações
  do contexto.
  """

  alias Pescarte.Domains.ModuloPesquisa.IO.RelatorioMensalRepo
  alias Pescarte.Domains.ModuloPesquisa.Services.CreateCampus
  alias Pescarte.Domains.ModuloPesquisa.Services.CreateCidade
  alias Pescarte.Domains.ModuloPesquisa.Services.CreateMidia
  alias Pescarte.Domains.ModuloPesquisa.Services.CreateRelatorioMensal
  alias Pescarte.Domains.ModuloPesquisa.Services.CreateNucleoPesquisa
  alias Pescarte.Domains.ModuloPesquisa.Services.CreatePesquisador
  alias Pescarte.Domains.ModuloPesquisa.Services.CreateLinhaPesquisa
  alias Pescarte.Domains.ModuloPesquisa.Services.GetCampus
  alias Pescarte.Domains.ModuloPesquisa.Services.GetCidade
  alias Pescarte.Domains.ModuloPesquisa.Services.GetMidia
  alias Pescarte.Domains.ModuloPesquisa.Services.GetRelatorioMensal
  alias Pescarte.Domains.ModuloPesquisa.Services.GetNucleoPesquisa
  alias Pescarte.Domains.ModuloPesquisa.Services.GetPesquisador
  alias Pescarte.Domains.ModuloPesquisa.Services.GetLinhaPesquisa
  alias Pescarte.Domains.ModuloPesquisa.Services.UpdateMidia
  alias Pescarte.Domains.ModuloPesquisa.Services.UpdateNucleoPesquisa

  defdelegate create_campus(params), to: CreateCampus, as: :process

  defdelegate get_campus(id), to: GetCampus, as: :process

  defdelegate list_campus, to: GetCampus, as: :process

  defdelegate create_cidade(params), to: CreateCidade, as: :process

  defdelegate get_cidade(id), to: GetCidade, as: :process

  defdelegate create_linha_pesquisa(params), to: CreateLinhaPesquisa, as: :process

  defdelegate get_linha_pesquisa(id), to: GetLinhaPesquisa, as: :process

  defdelegate list_linha_pesquisa, to: GetLinhaPesquisa, as: :process

  defdelegate create_midia(params), to: CreateMidia, as: :process

  defdelegate get_midia(id), to: GetMidia, as: :process

  defdelegate list_midia, to: GetMidia, as: :process

  defdelegate update_midia(params), to: UpdateMidia, as: :process

  defdelegate create_nucleo_pesquisa(params), to: CreateNucleoPesquisa, as: :process

  defdelegate get_nucleo_pesquisa(id), to: GetNucleoPesquisa, as: :process

  defdelegate list_nucleo_pesquisa, to: GetNucleoPesquisa, as: :process

  defdelegate update_nucleo_pesquisa(params), to: UpdateNucleoPesquisa, as: :process

  defdelegate create_pesquisador(params), to: CreatePesquisador, as: :process

  defdelegate get_pesquisador(id), to: GetPesquisador, as: :process

  defdelegate list_pesquisador, to: GetPesquisador, as: :process

  defdelegate create_relatorio_mensal(params), to: CreateRelatorioMensal, as: :process

  defdelegate get_relatorio_mensal(id), to: GetRelatorioMensal, as: :process

  defdelegate list_relatorio_mensal, to: GetRelatorioMensal, as: :process

  def change_relatorio_mensal(report, attrs \\ %{}) do
    RelatorioMensalRepo.changeset(report, attrs)
  end

  def list_campus_by_county(id) do
    GetCampus.process(municipio: id)
  end

  def list_linha_pesquisa_by_nucleo_pesquisa(nucleo_pesquisa_id) do
    GetLinhaPesquisa.process(nucleo: nucleo_pesquisa_id)
  end

  ## Generic

  defdelegate delete(source), to: Pescarte.Database
end
