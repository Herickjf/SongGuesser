# lib/songapp_web/live/home_phoenix_live.ex
defmodule SongappWeb.HomeLive do
  use SongappWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div id="home_live" data-page="home_live" phx-hook="LoadSpecificJs"/>
      <%!-- <h1>Home Page</h1> --%>
      <%!-- <nav> --%>
        <%!-- <a href="#" phx-click="navigate" phx-value-page="about">About</a> --%>
        <%!-- <a href="#" phx-click="navigate" phx-value-page="game-screen">Game Screen</a> --%>
        <%!-- <a href="#" phx-click="navigate" phx-value-page="how">How to Play</a> --%>
        <%!-- <a href="#" phx-click="navigate" phx-value-page="rooms-test">Rooms Test</a> --%>
      <%!-- </nav> --%>
      <%!-- <link rel="stylesheet" href={@socket.endpoint.static_path("/css/home_live.css")}> --%>







      <%!-- <.flash_group flash={@flash} /> --%>

<%!-- <!DOCTYPE html> --%>
<%!-- <html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="shortcut icon" href="/songapp/songapp/priv/static/images/logo.png" type="image/x-icon">
    <link rel="stylesheet" href="/songapp/assets/css/app.css">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">    <link rel="preconnect" href="https://fonts.googleapis.com">

    <title>Song Guesser</title>
</head>
<body> --%>

        <div id="selection_images">
            <h1>Choose an avatar:</h1>

            <div id="images">
                <div></div>
                <div></div>
                <div></div>
                <div></div>
                <div></div>
                <div></div>
                <div></div>
                <div></div>
                <div></div>
                <div></div>
                <div></div>
                <div></div>
                <div></div>
                <div></div>
                <div></div>
                <div></div>
                <div></div>
                <div></div>
                <div></div>
                <div></div>
                <div></div>
                <div></div>
                <div></div>
                <div></div>
                <div></div>
                <div></div>
                <div></div>
                <div></div>
                <div></div>
                <div></div>
                <div></div>
                <div></div>
                <div></div>
                <div></div>
                <div></div>
            </div>
        </div>

    <!-- início do header -->
    <header>

        <!-- início do menu -->
        <div class="menu">
            <!-- botao de voltar ao inicio -->
            <%!-- <a href="">Home</a> --%>
            <a href="#" phx-click="navigate" phx-value-page="home">Home</a>
            <!-- botao que direciona a um tutorial em texto -->
            <%!-- <a href="howToPlay">How To Play</a> --%>
            <a href="#" phx-click="navigate" phx-value-page="how">How to Play</a>
            <!-- botao que direciona a uma pagina que nos apresenta -->
            <a href="#" phx-click="navigate" phx-value-page="about">About Us</a>
            <%!-- <a href="about"></a> --%>
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

    <!-- Inicio da area de Input -->
    <div class="content">
        <div id="input_box">
            <!-- Inicio da div de input introdutoria -->
            <div id="credentials">
                <!-- Titulo da div -->

                <h1>Song Guesser</h1>

                <!-- Input para o nome do usuario -->
                <div class="input">
                    <label for="nickname_input">Nickname:</label>
                    <input type="text" id="nickname_input" placeholder="Enter your nickname" maxlength="25">
                </div>

                <!-- Input para o codigo da sala -->
                <div class="input">
                    <label for="roomCode_input">Room code (to enter):</label>
                    <input type="text" id="roomCode_input" placeholder="Enter the room code" maxlength="6">
                </div>

                <div class="btns">
                    <!-- Botao para entrar na sala -->
                    <button class="button" id="goto_enterRoom">Enter room</button>

                    <!-- Botao para criar uma sala -->
                    <button class="button" id="goto_createRoom">Create room</button>
                </div>

            </div>
            <!-- Fim da div de input introdutoria-->


            <!-- Inicio da div para entrar na sala -->
            <div id="enter-room" style="display: none">
                <!-- Exibicao do codigo e do criador da sala -->
                <div class="exibitions">
                    <h1 id="show_roomCode">Room password</h1>
                </div>

                <div class="imageSelection_box">
                    <div class="user_image" id="player_avatar">
                        <i class="fa fa-pencil change_image"></i>
                    </div>
                </div>

                <!-- Input da senha para a sala -->
                <div class="input">
                    <label for="password_input">Password:</label>
                    <input type="text" id="password_input" maxlength="10" placeholder="Enter the room password">
                </div>

                <!-- Exibicao da bandeira que informa a linguagem da sala -->
                <!-- <div class="language">
                    <p>Language:</p>
                    <div class="imgs selected">
                        <img src="/songapp/songapp/priv/static/images/flags/brasil.png">
                    </div>
                </div> -->

                <!-- Botao para entrar na sala -->
                <div class="btns">
                    <button class="button" id="enterRoom">Enter room</button>
                </div>

            </div>
            <!-- Fim da div para entrar na sala -->


            <!-- Inicio da div para criar uma sala -->
            <div id="create-room" style="display: none">
                <h1>Creating room</h1>

                <div class="imageSelection_box">
                    <div class="user_image" id="host_avatar">
                        <div class="fa fa-pencil change_image"></div>
                    </div>
                </div>

                <!-- Campo para criar uma senha para a sala -->
                <div class="input">
                    <label for="create_password">Create password:</label>
                    <input type="text" id="create_password" maxlength="10" placeholder="Create a password">
                </div>

                <div class="double_input ">
                    <!-- Input do maximo de jogadores permitido na sala -->
                    <div class="input last_input">
                        <label for="max_players">Max. players:</label>
                        <input type="number" id="max_players" min="2" max="20" placeholder="2 - 20">
                    </div>

                    <!-- Input do numero de rodadas -->
                    <div class="input last_input">
                        <label for="rounds">Rounds:</label>
                        <input type="number" id="rounds" min="3" max="15" placeholder="3 - 15">
                    </div>
                </div>

                <!-- Escolher linguagem -->
                <div class="language">
                    <p>Language:</p>
                    <div class="imgs">
                        <img class="flag" src="/images/flags/eua.png" alt="US flag">
                        <img class="flag" src="/images/flags/brasil.png" alt="Brasil flag">
                        <img class="flag" src="/images/flags/spain.png" alt="Spain flag">
                    </div>
                </div>

                <!-- Botao para criar a sala -->
                <div class="btns">
                    <button class="button" id="createRoom">Create room</button>
                </div>
            </div>
            <!-- Fim da div para criar uma sala -->

        </div>
        <!-- Fim da area de input -->
    </div>


    <a  id="change_to_gameScreen" style="visibility: hidden" href="#" phx-click="navigate" phx-value-page="game"></a>
        <%!-- </body>
        </html> --%>









    <%!-- </div> --%>
    """
  end

  def handle_event("navigate", %{"page" => page}, socket) do
    {:noreply, push_redirect(socket, to: "/" <> page)}
  end
end
