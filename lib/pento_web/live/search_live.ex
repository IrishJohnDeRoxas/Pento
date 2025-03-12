defmodule PentoWeb.SearchLive do
  use PentoWeb, :live_view

  alias Pento.Search
  alias Pento.Search.EmbedSearch

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_embed_search()
     |> clear_form()}
  end

  def assign_embed_search(socket) do
    socket
    |> assign(:embed_search, %EmbedSearch{})
  end

  def clear_form(socket) do
    form =
      socket.assigns.embed_search
      |> Search.change_embed_search()
      |> to_form()

    assign(socket, :form, form)
  end

  def assign_form(socket, changeset) do
    assign(socket, :form, to_form(changeset))
  end

  @impl true
  def handle_event("validate", %{"embed_search" => embed_search_params}, socket) do
    changeset = Search.change_embed_search(socket.assigns.embed_search, embed_search_params)
    {:noreply, socket |> assign(:form, to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"embed_search" => embed_search_params}, socket) do
    changeset = Search.change_embed_search(socket.assigns.embed_search, embed_search_params)

    case changeset.valid? do
      true ->
        {:noreply,
         socket
         |> put_flash(:info, "Embed search complete")
         |> assign_embed_search()
         |> clear_form()}

      false ->
        {:noreply,
         socket
         |> assign(:form, to_form(changeset, action: :validate))}
    end
  end
end
