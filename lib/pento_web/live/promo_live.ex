defmodule PentoWeb.PromoLive do
  @moduledoc false

  use PentoWeb, :live_view
  alias Pento.Promo
  alias Pento.Promo.Recipient

  def mount(_params, _session, socket) do
    {:ok, clear_form(socket)}
  end

  def assign_recipient(socket) do
    assign(socket, :recipient, %Recipient{})
  end

  def clear_form(socket) do
    socket = assign_recipient(socket)
    changeset = Promo.change_recipient(socket.assigns.recipient)
    assign(socket, form: to_form(changeset))
  end

  def handle_event("validate", %{"recipient" => recipient_params}, socket) do
    %{assigns: %{recipient: recipient}} = socket
    changeset = Promo.change_recipient(recipient, recipient_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"recipient" => recipient_params}, socket) do
    case Promo.send_promo(socket.assigns.recipient, recipient_params) do
      {:ok, _recipient} ->
        {:noreply,
         socket
         |> put_flash(:info, "Sent promo!")
         |> clear_form()}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  def render(assigns) do
    ~H"""
    <.header>
      Send Your Promo Code to a Friend
      <:subtitle>promo code for 10% off their first game purchase!</:subtitle>
    </.header>

    <div>
      <.simple_form for={@form} id="promo-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:first_name]} type="text" label="First Name" />
        <.input field={@form[:email]} type="email" label="Email" phx-debounce="blur" />

        <:actions>
          <.button phx-disable-with="Sending...">Send Promo</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end
end
