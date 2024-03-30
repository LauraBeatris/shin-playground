defmodule ShinPlaygroundWeb.HomeLive do
  use ShinPlaygroundWeb, :live_view

  import ShinPlaygroundWeb.HomeLive.NavbarComponent
  alias ShinPlaygroundWeb.SAML.SAMLActionComponent

  @impl true
  def mount(_params, _session, socket) do
    form = to_form(%{"saml_xml" => ""})

    socket =
      socket
      |> assign(
        form: form,
        saml_xml: nil,
        decoded_saml: nil,
        malformed_xml_error: nil,
        type: nil
      )

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :oidc, _params) do
    socket
  end

  defp apply_action(socket, :saml, _params) do
    socket
  end
end
