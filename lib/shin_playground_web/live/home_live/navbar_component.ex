defmodule ShinPlaygroundWeb.HomeLive.NavbarComponent do
  use ShinPlaygroundWeb, :live_component

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  # TODO: Add transitions on hover + use slots / attrs
  def navbar(assigns) do
    ~H"""
    <nav class="mt-4 flex items-start place-content-start	min-h-min bg-gray-800 rounded-navbar shadow-md px-2 py-3 gap-1">
      <.link
        patch={~p"/oidc"}
        class="flex p-1 gap-3 items-center rounded-lg  transition duration-300 ease-in-out hover:bg-navbar-hover hover:bg-opacity-35"
      >
        <div class="bg-navbar-hover h-[30px] w-[30px] flex items-center justify-center border-[1px] border-navbar-icon rounded-lg ">
          <img src="/images/openid-connect.svg" class="h-[35px] w-[35px]" />
        </div>

        <div class="flex">
          <span class="text-white font-light">OpenID Connect</span>
        </div>
      </.link>

      <.link
        patch={~p"/saml"}
        class="flex p-1 rounded-lg gap-3 items-center transition duration-300 ease-in-out hover:bg-navbar-hover hover:bg-opacity-35"
      >
        <div class="bg-navbar-hover  h-[30px] w-[30px] flex items-center justify-center border-[1px] border-navbar-icon rounded-lg ">
          <img src="/images/saml.svg" class="h-[21px] w-[21px]" />
        </div>

        <div class="flex">
          <span class="text-white font-light">SAML</span>
        </div>
      </.link>
    </nav>
    """
  end
end
