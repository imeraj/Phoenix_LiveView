defmodule PentoWeb.SurveyLive do
  use PentoWeb, :live_view

  alias Pento.Catalog
  alias Pento.Survey
  alias PentoWeb.SurveyLive.Component
  alias PentoWeb.{DemographicLive, RatingLive, Endpoint}

  @survey_results_topic "survey_results"

  def handle_params(_params, _url, socket) do
    {:noreply,
     socket
     |> assign_demographic()
     |> assign_products()}
  end

  defp assign_demographic(socket) do
    %{assigns: %{current_user: current_user}} = socket
    assign(socket, :demographic, Survey.get_demographic_by_user(current_user))
  end

  defp assign_products(socket) do
    %{assigns: %{current_user: current_user}} = socket
    assign(socket, :products, list_products(current_user))
  end

  defp list_products(user) do
    Catalog.list_products_with_user_rating(user)
  end

  def handle_info({:created_rating, updated_product, product_index}, socket) do
    {:noreply, handle_rating_created(socket, updated_product, product_index)}
  end

  def handle_rating_created(
        %{assigns: %{products: products}} = socket,
        updated_product,
        product_index
      ) do
    Endpoint.broadcast(@survey_results_topic, "rating_created", %{})

    socket
    |> put_flash(:info, "Rating submitted successfully")
    |> assign(
      :products,
      List.replace_at(products, product_index, updated_product)
    )
  end
end
