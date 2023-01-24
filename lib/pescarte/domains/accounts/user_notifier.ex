defmodule Pescarte.Domains.Accounts.UserNotifier do
  @moduledoc """
  Define funções públicas para o envio de emails transacionais.
  """

  require Logger

  alias Pescarte.Jobs.MailerJob

  # Entrega o email por meio de um Job no banco de dados
  defp deliver(subject, template, assigns) do
    email = %{
      to: Map.get(assigns, :email),
      subject: subject,
      assigns: assigns,
      layout: "notification",
      template: template
    }

    email
    |> MailerJob.new()
    |> Oban.insert()
    |> case do
      {:ok, %Oban.Job{}} ->
        {:ok, email |> Map.merge(assigns) |> Map.delete(:email)}

      err ->
        Logger.error(Exception.format(:error, err))
        {:error, err}
    end
  end

  def deliver_confirmation_instructions(user, url) do
    deliver("Instruções para confirmação da conta", "email_confirmation", %{
      name: user.nome_completo,
      email: user.contato.email,
      url: url
    })
  end

  def deliver_reset_password_instructions(user, url) do
    deliver("Instruções para recuperar senha", "reset_password", %{
      name: user.nome_completo,
      email: user.contato.email,
      url: url
    })
  end

  def deliver_update_email_instructions(user, url) do
    deliver("Instruções para atualizar email", "update_email", %{
      name: user.nome_completo,
      email: user.contato.email,
      url: url
    })
  end
end
