defmodule Pento.Promo do
  alias Pento.Promo.Recipient
  alias Pento.Accounts.UserNotifier

  def change_recipient(%Recipient{} = recipient, attrs \\ %{}) do
    Recipient.changeset(recipient, attrs)
  end

  def send_promo(recipient, attrs) do
    # send email to promo recipient
    # exercise for the reader
    changeset = Recipient.changeset(recipient, attrs)

    case changeset.valid? do
      true ->
        recipient = struct(Pento.Promo.Recipient, changeset.changes)
        UserNotifier.deliver_promotion(recipient, "http://localhost:4000/promo")
        {:ok, %Recipient{}}

      false ->
        {:error, Map.put(changeset, :action, :validate)}
    end
  end
end
