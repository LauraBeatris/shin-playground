defmodule ShinPlaygroundWeb.HomeLive.SamlInfoComponent do
  use ShinPlaygroundWeb, :live_component

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  attr :malformed_xml_error, :string, required: true
  attr :decoded_saml, :map, required: true
  attr :type, :atom, required: true

  def saml_info(assigns) do
    ~H"""
    <div class="w-full flex flex-col gap-2">
      <header class="flex w-full justify-between items-end">
        <h3 class="block font-bold text-gray-600 text-md">
          SAML Info
        </h3>

        <button
          :if={@type == :response}
          disabled={@malformed_xml_error}
          type="button"
          phx-click={show_modal("saml-response")}
          class="disabled:opacity-50 border border-gray-300 font-bold rounded-md px-2 py-1 bg-white/25"
        >
          View more
        </button>
      </header>

      <div
        :if={is_nil(@decoded_saml) or @malformed_xml_error}
        class="relative text-gray-600 z-10 w-full rounded-md border border-gray-300 bg-white/50 shadow-sm"
      >
        <div
          class="absolute w-full h-full z-20 bg-white bg-clip-padding bg-opacity-15 flex justify-center items-center gap-1"
          style="backdrop-filter: blur(3px);"
        >
          <%= if @malformed_xml_error do %>
            <.icon name="hero-exclamation-triangle" class="text-red-500" />
            <p class="text-red-400 text-md"><%= @malformed_xml_error %></p>
          <% else %>
            <.icon name="hero-arrow-long-up" />
            <p class="text-md">Enter XML to visualize info</p>
          <% end %>
        </div>

        <h3 class="p-3 w-full  border-b border-gray-300">Common</h3>

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
        </ul>
      </div>

      <div
        :if={@type == :response and is_map(@decoded_saml) and is_nil(@malformed_xml_error)}
        class="relative text-gray-600 z-10 w-full rounded-md border border-gray-300 bg-white/50 shadow-sm"
      >
        <h3 class="p-3 w-full  border-b border-gray-300">Common</h3>

        <ul class="w-full p-3">
          <.list_item value={@decoded_saml.common.version} label="Version" />
          <.list_item value={@decoded_saml.common.issuer} label="Issuer" />
          <.list_item value={@decoded_saml.common.destination} label="Destination" />
          <.list_item value={@decoded_saml.common.issue_instant} label="IssueInstant" />
        </ul>
      </div>

      <div
        :if={@type == :request and is_map(@decoded_saml) and is_nil(@malformed_xml_error)}
        class="relative text-gray-600 z-10 w-full rounded-md border border-gray-300 bg-white/50 shadow-sm"
      >
        <h3 class="p-3 w-full  border-b border-gray-300">Common</h3>

        <ul class="w-full p-3">
          <.list_item value={@decoded_saml.common.version} label="Version" />
          <.list_item value={@decoded_saml.common.assertion_consumer_service_url} label="ACS URL" />
          <.list_item value={@decoded_saml.common.issuer} label="Issuer" />
          <.list_item value={@decoded_saml.common.issue_instant} label="IssueInstant" />
        </ul>
      </div>
    </div>
    """
  end

  attr :label, :string, required: true
  attr :value, :string, required: true

  defp list_item(assigns) do
    ~H"""
    <li class="gap-5 w-full flex justify-between border-b last:border-b-0 border-gray-300 first:pt-0 py-2">
      <strong class="text-gray-600"><%= @label %></strong>

      <span class="truncate"><%= @value %></span>
    </li>
    """
  end
end
