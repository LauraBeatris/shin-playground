defmodule ShinPlaygroundWeb.SAML.SAMLActionComponent do
  use ShinPlaygroundWeb, :live_component

  import ShinPlaygroundWeb.SAML.SAMLInfoComponent

  def handle_event("decode", %{"saml_xml" => ""}, socket) do
    socket =
      socket
      |> assign(
        type: nil,
        saml_xml: nil,
        decoded_saml: nil,
        malformed_xml_error: nil
      )

    {:noreply, socket}
  end

  def handle_event("decode", %{"saml_xml" => saml_xml}, socket) do
    sanitized_xml = sanitize_xml_input(saml_xml)

    with {:ok, type} <- get_saml_xml_type(sanitized_xml) do
      decoded_xml = decode_xml_input(sanitized_xml, type)

      case decoded_xml do
        {:error, %ShinAuth.SAML.Response.Error{}} ->
          socket =
            socket
            |> assign(malformed_xml_error: "Malformed SAML response")

          {:noreply, socket}

        {:error, %ShinAuth.SAML.Request.Error{}} ->
          socket =
            socket
            |> assign(malformed_xml_error: "Malformed SAML request")

          {:noreply, socket}

        {:ok, value} ->
          socket =
            socket
            |> assign(
              type: type,
              decoded_saml: value,
              saml_xml: saml_xml,
              malformed_xml_error: nil
            )

          {:noreply, socket}
      end
    else
      {:error, _} ->
        socket =
          socket
          |> assign(
            decoded_saml: nil,
            saml_xml: nil,
            malformed_xml_error: "Invalid SAML type"
          )

        {:noreply, socket}
    end
  end

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
            type: :response,
            saml_xml: saml_xml,
            decoded_saml: saml_response,
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

  defp sanitize_xml_input(xml) do
    xml
    |> String.replace(~r/\r?\n|\r/, "")
    |> String.replace(~r/>\s+</, "><")
  end

  defp get_saml_xml_type(xml) do
    cond do
      String.contains?(xml, "samlp:AuthnRequest") -> {:ok, :request}
      String.contains?(xml, "samlp:Response") -> {:ok, :response}
      true -> {:error, :unknown}
    end
  end

  defp decode_xml_input(xml, type) when type == :request or type == :response do
    case type do
      :request -> ShinAuth.SAML.decode_saml_request(xml)
      :response -> ShinAuth.SAML.decode_saml_response(xml)
    end
  end
end
