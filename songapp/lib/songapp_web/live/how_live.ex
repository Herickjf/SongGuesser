# lib/songapp_web/live/home_phoenix_live.ex
defmodule SongappWeb.HowLive do
  use SongappWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
      <%!-- <h1>how Page</h1> --%>
      <%!-- <nav> --%>
        <%!-- <a href="#" phx-click="navigate" phx-value-page="home">Home</a> --%>
        <%!-- <a href="#" phx-click="navigate" phx-value-page="about">About</a> --%>
        <%!-- <a href="#" phx-click="navigate" phx-value-page="how">How to Play</a> --%>
      <%!-- </nav> --%>
      <link rel="stylesheet" href={@socket.endpoint.static_path("/assets/how_live.css")}>
    <%!-- </div> --%>











    <%!-- <!DOCTYPE html>
    <html lang="en">
    <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0"> --%>

    <%!-- <link rel="shortcut icon" href="/assets/logo.png" type="image/x-icon"> --%>
    <%!-- <link rel="stylesheet" href="/songapp/assets/css/app.css">
    <link rel="stylesheet" href="/songapp/assets/css/aboutUs.css"> --%>
    <%!-- <link rel="stylesheet" href="/songapp/assets/css/howToPlay.css"> --%>
    <%!--
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900&display=swap" rel="stylesheet"> --%>

    <%!-- <title>Song Guesser</title> --%>
    <%!-- </head> --%>
    <%!-- <body> --%>
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

      <p><b>Important!</b></p>
      <p>The APIs may fail in searching, finding or verifying the lyrics of the songs</p>

      <h1>Inspirations:</h1>
      <br>
      <p>The game is inspired by the Elle channel segment, in which participants are given a specific word and must quickly remember a song that contains that word in its lyrics. The game's dynamics are simple, but it requires a good musical repertoire and mental agility, as there is little time to think and respond.</p>
      <br>
      <p>The goal of our game is to create a fun environment, testing not only the musical knowledge but also the creativity of the players. Throughout the rounds, the tension increases as the words are revealed, and laughter arises with unexpected answers or desperate attempts to remember a song that fits. Our game is a fun way to test the participants' memory and musical knowledge, providing moments of relaxation among friends.</p>
      <br>
      <h1>How to Play</h1>
      <br>
      <p><b>1- Provide Name and Join or Create Room:</b></p>
        <p>Player Name: Each player must enter their name to be identified in the game. Join Room: Enter the code of the created room and the password provided by the host. Create Room: If you wish to create a room, enter a password for the room.</p>
        <br>

        <p><b>2- Room Settings:</b></p>
        <p>Number of Players: Set the maximum number of players between 1 and 20. Number of Rounds: Choose the number of rounds, which can vary from 3 to 15. Language Selection: Set the language of the game: Portuguese, English, or Spanish. Choose Avatar: All players can choose an avatar to represent them in the game.</p>
        <br>

        <p><b>3- In the Waiting Room:</b></p>
        <p>Invited Players: Remain on a waiting screen until the host starts the game. Host: Controls the moment to start the game and gives the command to begin.</p>
        <br>

        <p><b>4- Starting the Game:</b></p>
        <p>Round Word: At the beginning of each round, a keyword is presented, and the timer starts running. Challenge: In 20 seconds, players must type the name of the artist and the name of the corresponding song by clicking on "search."</p>
        <br>

        <p><b>5 - Song Selection:</b></p>
        <p>After pressing "search," up to five song options are presented for each player. Select the desired song.</p>
        <br>

        <p><b>6- Round Results:</b></p>
        <p>At the end of the round, a list is displayed with each player's attempts, indicating whether the choice was correct or not. Each player can listen to a preview of the correct song and see additional information about it.</p>
        <br>

        <p><b>7- Start of New Rounds:</b></p>
        <p>The host controls the start of each new round, being able to determine when players should proceed.</p>
        <br>

        <p><b>8- Final Ranking:</b></p>
        <p>At the end of all rounds, the top three scores are displayed in an overall ranking.</p>
        <br>

        <h1>Good luck and have fun in the game!</h1>
        <br>
      </div>
    </section>
    <%!-- </body>
    </html> --%>





    <div id="how_live" data-page="how_live" phx-hook="LoadSpecificJs"/>








    """
  end

  def handle_event("navigate", %{"page" => page}, socket) do
    {:noreply, push_redirect(socket, to: "/" <> page)}
  end
end
