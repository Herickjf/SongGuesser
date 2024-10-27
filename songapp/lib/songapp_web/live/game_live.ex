# lib/songapp_web/live/game_live.ex
defmodule SongappWeb.GameLive do
  use SongappWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div id="game_live" data-page="game_live" phx-hook="LoadSpecificJs">
      <%!-- <h1>Game Page</h1> --%>
      <%!-- <nav> --%>
        <%!-- <a href="#" phx-click="navigate" phx-value-page="home">Home</a> --%>
        <%!-- <a href="#" phx-click="navigate" phx-value-page="about">About</a> --%>
        <%!-- <a href="#" phx-click="navigate" phx-value-page="how">How to Play</a> --%>
      <%!-- </nav> --%>
      <!-- CSS específico (opcional) -->
      <link rel="stylesheet" href={@socket.endpoint.static_path("/assets/game_live.css")}>







      <!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet" href="/songapp/assets/css/app.css">
    <link rel="stylesheet" href="/songapp/assets/css/gameStyle.css">

    <link rel="shortcut icon" href="/SongGuesser/assets/logo.png" type="image/x-icon">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">


    <title>Song Guesser</title>
</head>
<body>
    <!-- inicio da logo -->
    <div class="logo">
        <!-- img logo -->
        <img src="/songapp/songapp/priv/static/images/logo.png" alt="logotipo do Song Guesser">
    </div>
    <!-- inicio da logo -->


    <!-- início classe da sala -->
    <div id="room">

        <!-- inicio de players -->
        <div id="players_box">

            <!-- link pra outra sala -->
            <div id="room_link">
                <p>12TF9M &#8594; <a href="" id="link_button" alt="Copiar Link"><i class="fa fa-clone"></i></a></p>
            </div>

            <h1>Players (<span id="players_min"></span> / <span id="players_max"></span>)</h1>

            <div id="players">
                <div class="player">
                    <div class="profile">
                    </div>
                    <div class="info">
                        <h2>Nickname</h2>
                        <p>10 points</p>
                    </div>
                </div>
                <div class="player">
                    <div class="profile" id="host">
                        <i class="fas fa-crown"></i>
                    </div>
                    <div class="info">
                        <h2>Nickname</h2>
                        <p>10 points</p>
                    </div>
                </div>
                <div class="player">
                    <div class="profile">
                    </div>
                    <div class="info">
                        <h2>Nickname</h2>
                        <p>10 points</p>
                    </div>
                </div>
                <div class="player">
                    <div class="profile">
                    </div>
                    <div class="info">
                        <h2>Nickname</h2>
                        <p>10 points</p>
                    </div>
                </div>
                <div class="player">
                    <div class="profile">
                    </div>
                    <div class="info">
                        <h2>Nickname</h2>
                        <p>10 points</p>
                    </div>
                </div>
                <div class="player">
                    <div class="profile">
                    </div>
                    <div class="info">
                        <h2>Nickname</h2>
                        <p>10 points</p>
                    </div>
                </div>
                <div class="player">
                    <div class="profile ">
                    </div>
                    <div class="info">
                        <h2>Nickname</h2>
                        <p>10 points</p>
                    </div>
                </div>
                <div class="player">
                    <div class="profile">
                    </div>
                    <div class="info">
                        <h2>Nickname</h2>
                        <p>10 points</p>
                    </div>
                </div>
            </div>
        </div>
        <!-- fim de players -->

        <!-- inicio de round -->
        <div id="round_box" >
            <div id="word_box">
                <h1>WORD</h1>
            </div>

            <div id="waiting_for">
                <p>Waiting for the host to start</p>
            </div>

            <div id="while_playing" style="display: none">
                <div id="content">
                    <p>Enter a song with the word <span class="round_word">WORD</span></p>

                    <div id="inputs">
                        <div class="input">
                            <label for="artist_name">Artist name:</label>
                            <input type="text" id="artist_name" placeholder="Enter the artist name" maxlength="50"/>
                        </div>

                        <div class="input">
                            <label for="track_name">Song title:</label>
                            <input type="text" id="track_name" placeholder="Enter the song name" maxlength="100"/>
                        </div>

                    </div>

                    <button class="button" id="search_song">Search</button>
                </div>

                <div id="timer_box">
                    <div id="timer_clock">
                        <i class="fa fa-clock-o"></i>
                    </div>
                    <div id="timer_counter">
                        <div id="timer_run"></div>
                    </div>
                </div>

            </div>

            <div id="between_rounds" style="display: none">
                <div>
                    <p>For the word <span class="round_word">palavra</span> you are...</p>
                    <h1 id="isRight">RIGHTT</h1>
                    <br>
                    <p>Listen to a preview of this song on the player below</p>
                </div>

                <div id="music_player_box">
                    <div id="song_information">
                        <div id="album_image"></div>

                        <div id="song_description">
                            <div>
                                <h5 id="track_info">Song Title</h5>
                                <h6 id="artist_info">Artist</h6>
                            </div>

                            <i class="fa fa-check-circle" id="symbol_isRight"></i>
                        </div>
                    </div>

                    <div id="music_player">
                        <audio controls>
                            <!-- Aqui contera a musica vinda do backend -->
                            <source src="#" type="audio/ogg">
                        </audio>
                    </div>
                </div>

                <button class="button" id="btn_nextRound">Next Round</button>
            </div>

            <div id="ranking_box" style="display: none;">
                <div id="playersCards_box">
                    <div class="playerCard" id="second_place">
                        <div class="playerCard_img" id="second_place_img"></div>
                        <div class="playerCard_name" id="second_place_name">Herick</div>
                        <div class="playerCard_points" id="second_place_points">0 points</div>
                    </div>

                    <div class="playerCard" id="first_place">
                        <div class="playerCard_img" id="first_place_img"></div>
                        <div class="playerCard_name" id="first_place_name">Luis</div>
                        <div class="playerCard_points" id="first_place_points">10 points</div>
                    </div>

                    <div class="playerCard" id="third_place">
                        <div class="playerCard_img" id="third_place_img"></div>
                        <div class="playerCard_name" id="third_place_name">Alguem</div>
                        <div class="playerCard_points" id="third_place_points">-10 points</div>
                    </div>
                </div>

                <div>
                    <p><span id="winner_name">Player</span> won with <span id="winner_points">n</span> points!</p>
                    <p id="congrat_msg">Congratulations!</p>
                </div>
            </div>

        </div>


        <!-- inicio de songsInfo -->
        <div id="songs_box">

            <div id="waiting_for_song" style="display: none;">
                <h1>Start the Game!</h1>
                <div class="btns">
                    <button class="button btn_start">Start</button>
                    <button class="button btn_exit">Exit</button>
                </div>
            </div>

            <div id="didnt_found" style="display: none;">
                <h1>No music found</h1>
                <button class="button btn_exit">Exit</button>
            </div>

            <div id="while_playing_song"  style="display: none;">
                <h1>Which song?</h1>

                <div id="songs">

                    <div class="song_found">
                        <div class="cover"></div>
                        <div class="info">
                            <h2>Song title</h2>
                            <p>Artist name</p>
                        </div>
                    </div>

                    <div class="song_found">
                        <div class="cover"></div>
                        <div class="info">
                            <h2>Song title</h2>
                            <p>Artist name</p>
                        </div>
                    </div>
                    <div class="song_found">
                        <div class="cover"></div>
                        <div class="info">
                            <h2>Song title</h2>
                            <p>Artist name</p>
                        </div>
                    </div>
                    <div class="song_found">
                        <div class="cover"></div>
                        <div class="info">
                            <h2>Song title</h2>
                            <p>Artist name</p>
                        </div>
                    </div>
                    <div class="song_found">
                        <div class="cover"></div>
                        <div class="info">
                            <h2>Song title</h2>
                            <p>Artist name</p>
                        </div>
                    </div>

                </div>

                <div class="btns">
                    <button class="button btn_exit">Exit</button>
                </div>

            </div>

            <div id="between_rounds_song" >
                <h1>Answers: </h1>

                <div id="songs">

                    <div class="song_results correct_song">
                        <div class="cover"></div>
                        <div class="info">
                            <h6>Fulano e beltrano</h6>
                            <h2>I Think They Call This Love</h2>
                            <p>Sei lá o nome</p>
                        </div>
                    </div>
                    <div class="song_results wrong_song">
                        <div class="cover"></div>
                        <div class="info">
                            <h6>Fulano e beltrano</h6>
                            <h2>Hair</h2>
                            <p>Suriel Hess</p>
                        </div>
                    </div>
                    <div class="song_results correct_song">
                        <div class="cover"></div>
                        <div class="info">
                            <h6>Fulano e beltrano</h6>
                            <h2>Believer</h2>
                            <p>Imagine Dragons</p>
                        </div>
                    </div>
                    <div class="song_results correct_song">
                        <div class="cover"></div>
                        <div class="info">
                            <h6>Fulano e beltrano</h6>
                            <h2>Roses</h2>
                            <p>Shawn Mendes</p>
                        </div>
                    </div>


                </div>

                <div class="btns">
                    <button class="button btn_next_round">Next round</button>
                    <button class="button btn_exit">Exit</button>
                </div>
            </div>

            <div id="ranking_box_song" style="display: none;">
                <h1>Check the Results</h1>

                <div class="btns">
                    <button class="button" id="btn_restart">Restart</button>
                    <button class="button btn_exit">Exit</button>
                </div>
            </div>
        </div>
        <!-- fim de songsInfo -->

    </div>
    <!-- final classe da sala -->
</body>
</html>








    </div>
    """
  end

  def handle_event("navigate", %{"page" => page}, socket) do
    {:noreply, push_redirect(socket, to: "/" <> page)}
  end
end
