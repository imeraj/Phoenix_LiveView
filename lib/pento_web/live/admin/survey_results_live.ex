defmodule PentoWeb.Admin.SurveyResultsLive do
  @moduledoc false
  use PentoWeb, :live_component
  use PentoWeb, :chart_live

  alias Pento.Catalog

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_age_group_filter()
     |> assign_products_with_average_ratings()
     |> assign_dataset()
     |> assign_chart()
     |> assign_chart_svg()}
  end

  def handle_event("age_group_filter", %{"age_group_filter" => age_group_filter}, socket) do
    {:noreply,
     socket
     |> assign_age_group_filter(age_group_filter)
     |> assign_products_with_average_ratings()
     |> assign_dataset()
     |> assign_chart()
     |> assign_chart_svg()}
  end

  def assign_age_group_filter(socket, age_group_filter \\ "all") do
    socket
    |> assign(:age_group_filter, age_group_filter)
  end

  defp assign_products_with_average_ratings(socket) do
    %{assigns: %{age_group_filter: age_group_filter}} = socket

    socket
    |> assign(
      :products_with_average_ratings,
      get_products_with_average_ratings(%{age_group_filter: age_group_filter})
    )
  end

  defp get_products_with_average_ratings(%{age_group_filter: age_group_filter}) do
    case Catalog.products_with_average_ratings(%{age_group_filter: age_group_filter}) do
      [] ->
        Catalog.products_with_zero_ratings()

      products ->
        products
    end
  end

  defp assign_dataset(socket) do
    %{assigns: %{products_with_average_ratings: products_with_average_ratings}} = socket

    socket
    |> assign(:dataset, make_bar_chart_dataset(products_with_average_ratings))
  end

  defp assign_chart(socket) do
    %{assigns: %{dataset: dataset}} = socket

    socket
    |> assign(:chart, make_bar_chart(dataset))
  end

  defp assign_chart_svg(socket) do
    %{assigns: %{chart: chart}} = socket

    socket
    |> assign(:chart_svg, render_bar_chart(chart, title(), subtitle(), x_axis(), y_axis()))
  end

  defp title do
    "Product Ratings"
  end

  defp subtitle do
    "average star ratings per product"
  end

  defp x_axis do
    "products"
  end

  defp y_axis do
    "stars"
  end
end
