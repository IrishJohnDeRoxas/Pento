defmodule PentoWeb.SurveyLive do
  use PentoWeb, :live_view

  alias PentoWeb.SurveyLive.Component
  alias PentoWeb.SurveyLive.TitleAndHeader
  alias Pento.Survey
  alias PentoWeb.DemographicLive.Show

  def mount(_params, _session, socket) do
    {:ok, socket |> assign_demographic}
  end

  defp assign_demographic(%{assigns: %{current_user: current_user}} = socket) do
    assign(socket, :demographic, Survey.get_demographic_by_user(current_user))
  end
end
