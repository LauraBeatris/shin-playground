defmodule ShinPlaygroundWeb.HomeLive do
  use ShinPlaygroundWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket = socket |> assign(live_action: :saml)

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :oidc, _params) do
    socket
    |> assign(:page_title, "OIDC")
  end

  defp apply_action(socket, :saml, _params) do
    socket
    |> assign(:page_title, "SAML")
  end
end
