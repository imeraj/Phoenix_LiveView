defmodule PentoWeb.Admin.DashboardLive do
  @moduledoc false

  use PentoWeb, :live_view
  alias PentoWeb.Endpoint
  alias PentoWeb.Admin.SurveyResultsLive

  @survey_results_topic "survey_results"
  def mount(_params, _session, socket) do
    if connected?(socket), do: Endpoint.subscribe(@survey_results_topic)

    {:ok,
     socket
     |> assign(:survey_results_component_id, "survey-results")}
  end

  def handle_info(%{event: "rating_created"}, socket) do
    send_update(
      SurveyResultsLive,
      id: socket.assigns.survey_results_component_id
    )

    {:noreply, socket}
  end
end
