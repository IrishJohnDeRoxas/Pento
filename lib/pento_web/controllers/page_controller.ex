defmodule PentoWeb.PageController do
  use PentoWeb, :controller

  def home(conn, _params) when is_nil(conn.assigns.current_user) do
    # render(conn, :home, layout: false)
    redirect(conn, to: ~p"/users/log_in")
  end

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    redirect(conn, to: ~p"/guess")
  end
end
