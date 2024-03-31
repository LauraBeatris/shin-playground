defmodule ShinPlaygroundWeb.OIDC.OIDCActionComponent do
  use ShinPlaygroundWeb, :live_component

  def handle_event("validate", %{"discovery_endpoint" => discovery_endpoint}, socket) do
    send_update(__MODULE__,
      id: "oidc",
      action: {:load_provider_configuration, discovery_endpoint}
    )

    socket =
      socket
      |> push_event("js-exec", %{
        to: "#oidc_loader",
        attr: "data-wait"
      })

    {:noreply, socket}
  end

  def update(%{action: {:load_provider_configuration, discovery_endpoint}}, socket) do
    decoded_oidc_provider_configuration =
      ShinAuth.OIDC.load_provider_configuration(discovery_endpoint)

    socket =
      socket |> assign(decoded_oidc_provider_configuration: decoded_oidc_provider_configuration)

    socket =
      socket
      |> push_event("js-exec", %{
        to: "#oidc_loader",
        attr: "data-done"
      })

    {:ok, socket}
  end

  def update(regular_assigns, socket) do
    {:ok, assign(socket, regular_assigns)}
  end

  def loader(assigns) do
    ~H"""
    <svg
      class="hidden animate-spin h-5 w-5 text-gray-800"
      xmlns="http://www.w3.org/2000/svg"
      fill="none"
      viewBox="0 0 24 24"
      id={@id}
      data-wait={show_loader()}
      data-done={hide_loader()}
    >
      <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4">
      </circle>
      <path
        class="opacity-75"
        fill="currentColor"
        d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
      >
      </path>
    </svg>
    """
  end

  defp show_loader() do
    JS.hide(%JS{},
      to: "#oidc_empty_state"
    )
    |> JS.show(
      to: "#oidc_loader",
      transition: {"ease-out duration-300", "opacity-0", "opacity-100"}
    )
  end

  defp hide_loader() do
    JS.hide(%JS{},
      to: "#oidc_loader",
      transition: {"ease-in duration-300", "opacity-100", "opacity-0"}
    )
  end
end
