defmodule PentoWeb.SurveyLive do
  use PentoWeb, :live_view

  alias Pento.Survey
  alias PentoWeb.SurveyLive.Component
  alias PentoWeb.DemographicLive

  def mount(_params, _session, socket) do
    {:ok, assign_demographic(socket)}
  end

  defp assign_demographic(socket) do
    %{assigns: %{current_user: current_user}} = socket

    assign(socket, :demographic, Survey.get_demographic_by_user(current_user))
  end
end
