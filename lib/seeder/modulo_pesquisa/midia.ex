defmodule Seeder.ModuloPesquisa.Midia do
  alias Pescarte.Database.Repo.Replica, as: Repo
  alias Pescarte.Identidades.Models.Usuario
  alias Pescarte.ModuloPesquisa.Models.Midia
  alias Pescarte.ModuloPesquisa.Models.Midia.Tag
  @behaviour Seeder.Entry

  defp autor_id do
    usuario = Repo.get_by!(Usuario, primeiro_nome: "Zoey")
    usuario.id
  end

  defp tags do
    Repo.all(Tag)
  end

  @impl true
  def entries do
    [
      %Midia{
        tags: tags(),
        nome_arquivo: "IMG20230126.png",
        tipo: :imagem,
        data_arquivo: Date.utc_today(),
        autor_id: autor_id(),
        link: "https://drive.google.com/uc?export=view&id=1YqVklE01-XPX-6iAO0iYie5acOCk0rhk"
      },
      %Midia{
        tags: tags(),
        nome_arquivo: "IMG2023014.png",
        tipo: :imagem,
        data_arquivo: Date.utc_today(),
        autor_id: autor_id(),
        link: "https://drive.google.com/uc?export=view&id=1SqVklE01-XPX-6iAO0iYie5acOCk0rhk"
      }
    ]
  end
end
