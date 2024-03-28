defmodule ShinPlaygroundWeb.HomeLive do
  use ShinPlaygroundWeb, :live_view

  import ShinPlaygroundWeb.HomeLive.NavbarComponent

  @impl true
  def mount(_params, _session, socket) do
    form = to_form(%{"saml_xml" => ""})

    socket =
      socket
      |> assign(
        live_action: :saml,
        form: form,
        saml_response: nil
      )

    {:ok, socket}
  end

  @impl true
  def handle_event("decode", %{"saml_xml" => saml_xml}, socket) do
    decoded_result =
      String.replace(saml_xml, ~r/\r?\n|\r/, "")
      |> String.replace(~r/>\s+</, "><")
      |> ShinAuth.SAML.decode_saml_response()

    saml_response =
      case decoded_result do
        {:error, %ShinAuth.SAML.Response.Error{message: message}} -> {:error, message}
        saml_response -> saml_response
      end

    socket =
      socket |> assign(saml_response: saml_response)

    {:noreply, socket}
  end

  @impl true
  def handle_event("show_example", _, socket) do
    {:noreply, socket}
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
