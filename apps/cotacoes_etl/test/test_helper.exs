alias CotacoesETL.Integrations.IManagePesagroIntegration
Mox.defmock(IManagePesagroIntegrationMock, for: IManagePesagroIntegration)
Application.put_env(:cotacoes_etl, :pesagro_api, IManagePesagroIntegrationMock)

alias CotacoesETL.Handlers.IManagePesagroHandler
Mox.defmock(IManagePesagroHandlerMock, for: IManagePesagroHandler)
Application.put_env(:cotacoes_etl, :pesagro_handler, IManagePesagroHandlerMock)

alias CotacoesETL.Handlers.IManagePDFConverterHandler
Mox.defmock(IManagePDFConverterHandlerMock, for: IManagePDFConverterHandler)
Application.put_env(:cotacoes_etl, :pdf_converter_handler, IManagePDFConverterHandlerMock)

alias CotacoesETL.Handlers.IManageZIPExtractorHandler
Mox.defmock(IManageZIPExtractorHandlerMock, for: IManageZIPExtractorHandler)
Application.put_env(:cotacoes_etl, :zip_extractor_handler, IManageZIPExtractorHandlerMock)

ExUnit.start()
