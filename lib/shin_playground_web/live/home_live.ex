defmodule ShinPlaygroundWeb.HomeLive do
  use ShinPlaygroundWeb, :live_view

  import ShinPlaygroundWeb.HomeLive.NavbarComponent
  alias ShinPlaygroundWeb.SAML.SAMLActionComponent
  alias ShinPlaygroundWeb.OIDC.OIDCActionComponent

  @impl true
  def mount(_params, _session, socket) do
    form_saml = to_form(%{"saml_xml" => ""})
    form_oidc = to_form(%{"discovery_endpoint" => ""})

    socket =
      socket
      |> assign(
        live_action: socket.assigns.live_action || :saml,
        form_saml: form_saml,
        form_oidc: form_oidc,
        saml_xml: nil,
        decoded_saml: nil,
        malformed_xml_error: nil,
        decoded_oidc_provider_configuration: nil,
        oidc_provider_configuration_error: nil,
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
