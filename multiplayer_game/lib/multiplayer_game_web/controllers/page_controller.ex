# defmodule MultiplayerGameWeb.PageController do
#   use MultiplayerGameWeb, :controller

#   def home(conn, _params) do
#     # The home page is often custom made,
#     # so skip the default app layout.
#     render(conn, :home, layout: false)
#   end
# end


defmodule MultiplayerGameWeb.PageController do
  use MultiplayerGameWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
