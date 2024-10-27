# lib/songapp_web/live/home_phoenix_live.ex
defmodule SongappWeb.HowLive do
  use SongappWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <%!-- <div id="how_live" data-page="how_live" phx-hook="LoadSpecificJs"> --%>
      <%!-- <h1>how Page</h1> --%>
      <%!-- <nav> --%>
        <%!-- <a href="#" phx-click="navigate" phx-value-page="home">Home</a> --%>
        <%!-- <a href="#" phx-click="navigate" phx-value-page="about">About</a> --%>
        <%!-- <a href="#" phx-click="navigate" phx-value-page="how">How to Play</a> --%>
      <%!-- </nav> --%>
      <link rel="stylesheet" href={@socket.endpoint.static_path("/assets/how_live.css")}>
    <%!-- </div> --%>











    <!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <%!-- <link rel="shortcut icon" href="/assets/logo.png" type="image/x-icon"> --%>
    <%!-- <link rel="stylesheet" href="/songapp/assets/css/app.css">
    <link rel="stylesheet" href="/songapp/assets/css/aboutUs.css"> --%>
    <%!-- <link rel="stylesheet" href="/songapp/assets/css/howToPlay.css"> --%>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900&display=swap" rel="stylesheet">

    <title>Song Guesser</title>
</head>
<body>
    <!-- início do header -->
    <header>

        <!-- início do menu -->
        <div class="menu">
            <!-- botao de voltar ao inicio -->
            <%!-- <a href="index.html">Home</a> --%>
            <a href="#" phx-click="navigate" phx-value-page="home">Home</a>
            <!-- botao que direciona a um tutorial em texto -->
            <%!-- <a href="howToPlay.html">How To Play</a> --%>
            <a href="#" phx-click="navigate" phx-value-page="how">How to Play</a>
            <!-- botao que direciona a uma pagina que nos apresenta -->
            <%!-- <a href="aboutUs.html">About Us</a> --%>
            <a href="#" phx-click="navigate" phx-value-page="about">About us</a>
        </div>
        <!-- fim do menu -->


        <!-- inicio da logo -->
        <div class="logo">
            <!-- img logo -->
            <img src="/images/logo.png" alt="logotipo do Song Guesser">
        </div>
        <!-- inicio da logo -->

    </header>
    <!-- final do header -->

    <section>
        <div id="text_box">
            <h1>How to Play</h1>
            <p>Lorem ipsum, dolor sit amet consectetur adipisicing elit. Eius quibusdam nobis deleniti repudiandae quas rerum, natus totam provident dolore esse laborum porro vero tenetur suscipit nesciunt itaque sed vitae voluptas?</p>
            <p>Lorem ipsum, dolor sit amet consectetur adipisicing elit. Eius quibusdam nobis deleniti repudiandae quas rerum, natus totam provident dolore esse laborum porro vero tenetur suscipit nesciunt itaque sed vitae voluptas?</p>
            <br>
            <p>Lorem ipsum, dolor sit amet consectetur adipisicing elit. Eius quibusdam nobis deleniti repudiandae quas rerum, natus totam provident dolore esse laborum porro vero tenetur suscipit nesciunt itaque sed vitae voluptas?</p>
            <p>Lorem ipsum, dolor sit amet consectetur adipisicing elit. Eius quibusdam nobis deleniti repudiandae quas rerum, natus totam provident dolore esse laborum porro vero tenetur suscipit nesciunt itaque sed vitae voluptas?</p>
            <br>
            <p>Lorem ipsum, dolor sit amet consectetur adipisicing elit. Eius quibusdam nobis deleniti repudiandae quas rerum, natus totam provident dolore esse laborum porro vero tenetur suscipit nesciunt itaque sed vitae voluptas?</p>
            <p>Lorem ipsum, dolor sit amet consectetur adipisicing elit. Eius quibusdam nobis deleniti repudiandae quas rerum, natus totam provident dolore esse laborum porro vero tenetur suscipit nesciunt itaque sed vitae voluptas?</p>
            <br>
            <p>Lorem ipsum, dolor sit amet consectetur adipisicing elit. Eius quibusdam nobis deleniti repudiandae quas rerum, natus totam provident dolore esse laborum porro vero tenetur suscipit nesciunt itaque sed vitae voluptas?</p>
            <p>Lorem ipsum, dolor sit amet consectetur adipisicing elit. Eius quibusdam nobis deleniti repudiandae quas rerum, natus totam provident dolore esse laborum porro vero tenetur suscipit nesciunt itaque sed vitae voluptas?</p>
            <br>
            <p>Lorem ipsum, dolor sit amet consectetur adipisicing elit. Eius quibusdam nobis deleniti repudiandae quas rerum, natus totam provident dolore esse laborum porro vero tenetur suscipit nesciunt itaque sed vitae voluptas?</p>
            <p>Lorem ipsum, dolor sit amet consectetur adipisicing elit. Eius quibusdam nobis deleniti repudiandae quas rerum, natus totam provident dolore esse laborum porro vero tenetur suscipit nesciunt itaque sed vitae voluptas?</p>
            <br>
            <p>Lorem ipsum, dolor sit amet consectetur adipisicing elit. Eius quibusdam nobis deleniti repudiandae quas rerum, natus totam provident dolore esse laborum porro vero tenetur suscipit nesciunt itaque sed vitae voluptas?</p>
            <p>Lorem ipsum, dolor sit amet consectetur adipisicing elit. Eius quibusdam nobis deleniti repudiandae quas rerum, natus totam provident dolore esse laborum porro vero tenetur suscipit nesciunt itaque sed vitae voluptas?</p>
            <br>
            <p>Lorem ipsum, dolor sit amet consectetur adipisicing elit. Eius quibusdam nobis deleniti repudiandae quas rerum, natus totam provident dolore esse laborum porro vero tenetur suscipit nesciunt itaque sed vitae voluptas?</p>
            <p>Lorem ipsum, dolor sit amet consectetur adipisicing elit. Eius quibusdam nobis deleniti repudiandae quas rerum, natus totam provident dolore esse laborum porro vero tenetur suscipit nesciunt itaque sed vitae voluptas?</p>
            <br>
            <p>Lorem ipsum, dolor sit amet consectetur adipisicing elit. Eius quibusdam nobis deleniti repudiandae quas rerum, natus totam provident dolore esse laborum porro vero tenetur suscipit nesciunt itaque sed vitae voluptas?</p>
            <p>Lorem ipsum, dolor sit amet consectetur adipisicing elit. Eius quibusdam nobis deleniti repudiandae quas rerum, natus totam provident dolore esse laborum porro vero tenetur suscipit nesciunt itaque sed vitae voluptas?</p>
        </div>
    </section>
</body>
</html>













    """
  end

  def handle_event("navigate", %{"page" => page}, socket) do
    {:noreply, push_redirect(socket, to: "/" <> page)}
  end
end
