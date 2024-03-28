defmodule ShinPlaygroundWeb.HomeLive.NavbarComponent do
  use ShinPlaygroundWeb, :live_component

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  # TODO: Add transitions on hover
  def navbar(assigns) do
    ~H"""
    <nav class="mt-4 flex items-start place-content-start	min-h-min bg-gray-800 rounded-navbar shadow-md p-3 gap-5">
      <.link patch={~p"/oidc"} class="flex gap-3 items-center">
        <div class="bg-navbar-hover h-[30px] w-[30px] flex items-center justify-center border-[1px] border-navbar-icon rounded-lg">
          <img src="/images/openid-connect.svg" class="h-[35px] w-[35px]" />
        </div>

        <div>
          <span class="text-white">OpenID Connect</span>
        </div>
      </.link>

      <.link patch={~p"/saml"} class="flex gap-3 items-center">
        <div class="bg-navbar-hover h-[30px] w-[30px] flex items-center justify-center border-[1px] border-navbar-icon rounded-lg">
          <img src="/images/saml.svg" class="h-[21px] w-[21px]" />
        </div>

        <div>
          <span class="text-white">SAML</span>
        </div>
      </.link>
    </nav>
    """
  end
end
