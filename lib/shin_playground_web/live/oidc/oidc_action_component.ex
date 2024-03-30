defmodule ShinPlaygroundWeb.OIDC.OIDCActionComponent do
  use ShinPlaygroundWeb, :live_component

  def handle_event("validate", %{"discovery_endpoint" => discovery_endpoint}, socket) do
    send_update(__MODULE__,
      id: "oidc",
      action: {:load_provider_configuration, discovery_endpoint}
    )

    socket =
      socket
      |> assign(oidc_loading: true)

    {:noreply, socket}
  end

  def update(%{action: {:load_provider_configuration, discovery_endpoint}}, socket) do
    decoded_oidc_provider_configuration =
      ShinAuth.OIDC.load_provider_configuration(discovery_endpoint)

    socket =
      socket |> assign(decoded_oidc_provider_configuration: decoded_oidc_provider_configuration)

    {:ok, socket}
  end

  def update(regular_assigns, socket) do
    {:ok, assign(socket, regular_assigns)}
  end
end
