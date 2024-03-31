defmodule ShinPlaygroundWeb.OIDC.OIDCActionComponent do
  use ShinPlaygroundWeb, :live_component

  def handle_event(
        "load-provider-configuration",
        %{"discovery_endpoint" => discovery_endpoint},
        socket
      ) do
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
      |> assign(oidc_provider_configuration_error: nil)

    {:noreply, socket}
  end

  def update(%{action: {:load_provider_configuration, discovery_endpoint}}, socket) do
    case ShinAuth.OIDC.load_provider_configuration(discovery_endpoint) do
      {:ok, value} ->
        socket =
          socket
          |> assign(decoded_oidc_provider_configuration: value)

        socket =
          socket
          |> push_event("js-exec", %{
            to: "#oidc_loader",
            attr: "data-done"
          })

        {:ok, socket}

      {:error, %ShinAuth.OIDC.ProviderConfiguration.Error{message: message}} ->
        socket =
          socket
          |> assign(
            decoded_oidc_provider_configuration: nil,
            oidc_provider_configuration_error: message
          )

        socket =
          socket
          |> push_event("js-exec", %{
            to: "#oidc_loader",
            attr: "data-done"
          })

        {:ok, socket}
    end
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

  def oidc_provider_configuration(assigns) do
    ~H"""
    <ul class="w-full h-full p-3">
      <.list_item
        :if={@provider_configuration.issuer}
        value={@provider_configuration.issuer}
        label="Issuer"
      />
      <.list_item
        :if={@provider_configuration.authorization_endpoint}
        value={@provider_configuration.authorization_endpoint}
        label="Authorization Endpoint"
      />
      <.list_item
        :if={@provider_configuration.token_endpoint}
        value={@provider_configuration.token_endpoint}
        label="Token Endpoint"
      />
      <.list_item
        :if={@provider_configuration.introspection_endpoint}
        value={@provider_configuration.introspection_endpoint}
        label="Introspection Endpoint"
      />
      <.list_item
        :if={@provider_configuration.userinfo_endpoint}
        value={@provider_configuration.userinfo_endpoint}
        label="User Info Endpoint"
      />
      <.list_item
        :if={@provider_configuration.end_session_endpoint}
        value={@provider_configuration.end_session_endpoint}
        label="Ping End Session Endpoint"
      />
      <.list_item
        :if={@provider_configuration.revocation_endpoint}
        value={@provider_configuration.revocation_endpoint}
        label="Revocation Endpoint"
      />
      <.list_item
        :if={@provider_configuration.jwks_uri}
        value={@provider_configuration.jwks_uri}
        label="JWKS URI"
      />
      <.list_item
        :if={@provider_configuration.scopes_supported}
        value={Enum.join(@provider_configuration.scopes_supported, ", ")}
        label="Scopes Supported"
      />
      <.list_item
        :if={@provider_configuration.response_types_supported}
        value={Enum.join(@provider_configuration.response_types_supported, ", ")}
        label="Response Types Supported"
      />
      <.list_item
        :if={@provider_configuration.grant_types_supported}
        value={Enum.join(@provider_configuration.grant_types_supported, ", ")}
        label="Grant Types Supported"
      />
      <.list_item
        :if={@provider_configuration.subject_types_supported}
        value={Enum.join(@provider_configuration.subject_types_supported, ", ")}
        label="Subject Types Supported"
      />
    </ul>
    """
  end

  def list_item(assigns) do
    ~H"""
    <li class="gap-5 w-full flex justify-between border-b last:border-b-0 border-gray-300 first:pt-0 py-2">
      <strong class="text-gray-600"><%= @label %></strong>

      <span class="truncate"><%= @value %></span>
    </li>
    """
  end

  defp empty_state(assigns) do
    ~H"""
    <ul class="w-full p-3">
      <li class="w-full flex justify-between border-b border-gray-300 pb-2">
        <strong class="text-gray-600">-</strong>

        <span class="font-serif">-</span>
      </li>

      <li class="w-full flex justify-between border-b border-gray-300 py-2">
        <strong class="text-gray-600">-</strong>

        <span class="font-serif">-</span>
      </li>

      <li class="w-full flex justify-between border-b border-gray-300 py-2">
        <strong class="text-gray-600">-</strong>

        <span class="font-serif">-</span>
      </li>

      <li class="w-full flex justify-between border-b border-gray-300 py-2">
        <strong class="text-gray-600">-</strong>

        <span class="font-serif">-</span>
      </li>

      <li class="w-full flex justify-between border-b border-gray-300 py-2">
        <strong class="text-gray-600">-</strong>

        <span class="font-serif">-</span>
      </li>

      <li class="w-full flex justify-between border-b border-gray-300 py-2">
        <strong class="text-gray-600">-</strong>

        <span class="font-serif">-</span>
      </li>

      <li class="w-full flex justify-between border-b border-gray-300 py-2">
        <strong class="text-gray-600">-</strong>

        <span class="font-serif">-</span>
      </li>

      <li class="w-full flex justify-between border-b border-gray-300 py-2">
        <strong class="text-gray-600">-</strong>

        <span class="font-serif">-</span>
      </li>

      <li class="w-full flex justify-between border-b border-gray-300 py-2">
        <strong class="text-gray-600">-</strong>

        <span class="font-serif">-</span>
      </li>

      <li class="w-full flex justify-between border-b border-gray-300 py-2">
        <strong class="text-gray-600">-</strong>

        <span class="font-serif">-</span>
      </li>

      <li class="w-full flex justify-between border-b border-gray-300 py-2">
        <strong class="text-gray-600">-</strong>

        <span class="font-serif">-</span>
      </li>

      <li class="w-full flex justify-between border-b border-gray-300 py-2">
        <strong class="text-gray-600">-</strong>

        <span class="font-serif">-</span>
      </li>

      <li class="w-full flex justify-between border-b border-gray-300 py-2">
        <strong class="text-gray-600">-</strong>

        <span class="font-serif">-</span>
      </li>
    </ul>
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
