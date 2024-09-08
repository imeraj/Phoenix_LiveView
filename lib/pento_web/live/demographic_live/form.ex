defmodule PentoWeb.DemographicLive.Form do
  @moduledoc false

  use PentoWeb, :live_component
  alias Pento.Survey
  alias Pento.Survey.Demographic

  def update(assigns, socket) do
    {
      :ok,
      socket
      |> assign(assigns)
      |> clear_form()
    }
  end

  def clear_form(socket) do
    socket = assign_demographic(socket)
    changeset = Survey.change_demographic(socket.assigns.demographic)
    assign(socket, form: to_form(changeset))
  end

  defp assign_demographic(socket) do
    %{assigns: %{current_user: current_user}} = socket
    assign(socket, :demographic, %Demographic{user_id: current_user.id})
  end

  def handle_event("validate", %{"demographic" => demographic_params}, socket) do
    changeset = Survey.change_demographic(socket.assigns.demographic, demographic_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"demographic" => demographic_params}, socket) do
    save_demographic(socket, demographic_params)
  end

  defp save_demographic(socket, demographic_params) do
    demographic_params = params_with_user_id(demographic_params, socket)

    case Survey.create_demographic(demographic_params) do
      {:ok, demographic} ->
        {:noreply,
         socket
         |> put_flash(:info, "Demographic created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  def params_with_user_id(params, %{assigns: %{current_user: current_user}}) do
    Map.put(params, "user_id", current_user.id)
  end
end
