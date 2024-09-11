defmodule PentoWeb.Admin.SurveyResultsLive do
  @moduledoc false
  use PentoWeb, :live_component

  alias Pento.Catalog
  alias Contex.Plot

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_products_with_average_ratings()
     |> assign_dataset()
     |> assign_chart()
     |> assign_chat_svg()}
  end

  defp assign_products_with_average_ratings(socket) do
    socket
    |> assign(:products_with_average_ratings, Catalog.products_with_average_ratings())
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

  defp assign_chat_svg(socket) do
    %{assigns: %{chart: chart}} = socket

    socket
    |> assign(:chart_svg, render_bar_chart(chart))
  end

  defp make_bar_chart_dataset(data) do
    Contex.Dataset.new(data)
  end

  defp make_bar_chart(dataset) do
    Contex.BarChart.new(dataset)
  end

  defp render_bar_chart(chart) do
    Plot.new(500, 400, chart)
    |> Plot.titles(title(), subtitle())
    |> Plot.axis_labels(x_axis(), y_axis())
    |> Plot.to_svg()
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
