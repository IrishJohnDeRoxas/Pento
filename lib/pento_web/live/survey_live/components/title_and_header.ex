defmodule PentoWeb.SurveyLive.TitleAndHeader do
  use Phoenix.Component

  attr :heading, :string, required: true
  slot :inner_block, required: true

  def asdf(assigns) do
    ~H"""
    <h1 class="font-heavy text-3xl">
      {@heading}
    </h1>
    <h3>
      {render_slot(@inner_block)}
    </h3>
    """
  end
end
