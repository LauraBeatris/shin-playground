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
        saml_xml: nil,
        saml_response: nil,
        malformed_xml_error: nil
      )

    {:ok, socket}
  end

  @impl true
  def handle_event("decode", %{"saml_xml" => ""}, socket) do
    socket =
      socket
      |> assign(
        saml_xml: nil,
        saml_response: nil,
        malformed_xml_error: nil
      )

    {:noreply, socket}
  end

  @impl true
  def handle_event("decode", %{"saml_xml" => saml_xml}, socket) do
    decoded_result =
      String.replace(saml_xml, ~r/\r?\n|\r/, "")
      |> String.replace(~r/>\s+</, "><")
      |> ShinAuth.SAML.decode_saml_response()

    case decoded_result do
      {:error, %ShinAuth.SAML.Response.Error{message: message}} ->
        socket =
          socket
          |> assign(malformed_xml_error: message)

        {:noreply, socket}

      {:ok, value} ->
        socket =
          socket
          |> assign(
            saml_response: value,
            saml_xml: saml_xml,
            malformed_xml_error: nil
          )

        {:noreply, socket}
    end
  end

  @impl true
  def handle_event("show_example", _, socket) do
    xml_file_path = Application.app_dir(:shin_playground, "priv/static/saml_example.xml")

    case File.read(xml_file_path) do
      {:ok, saml_xml} ->
        {:ok, saml_response} =
          String.replace(saml_xml, ~r/\r?\n|\r/, "")
          |> String.replace(~r/>\s+</, "><")
          |> ShinAuth.SAML.decode_saml_response()

        socket =
          socket
          |> assign(
            saml_xml: saml_xml,
            saml_response: saml_response,
            malformed_xml_error: nil
          )

        {:noreply, socket}

      {:error, reason} ->
        socket =
          socket
          |> assign(malformed_xml_error: reason)

        {:noreply, socket}
    end
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
