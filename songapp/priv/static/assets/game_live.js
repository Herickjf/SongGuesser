export default function gameLive() {
    console.log("game_live.js loaded");

    /*
        JavaScript configurations for the frontend file 'gameScreen.html'
    */
    const linkButton = document.getElementById('link_button');
    const searchSong = document.getElementById('search_song');
    const exitRoomBtn = [...document.getElementsByClassName('btn_exit')]
    const startBtn = [...document.getElementsByClassName('btn_start')][0]
    const restartBtn = document.getElementById('btn_restart')
    const nextRoundBtn = [...document.getElementsByClassName('btn_next_round')][0]

    // divs for each match moment
    // round_box
    const waitingForRound = document.getElementById('waiting_for')
    const whilePlayingRound = document.getElementById('while_playing')
    const betweenRounds = document.getElementById('between_rounds')
    const rankingBoxRounds = document.getElementById('ranking_box')
    const no_music_box = document.getElementById('no_music_player_box')
    // songs_box
    const waitingForSong = document.getElementById('waiting_for_song')
    const didntFoundSong = document.getElementById('didnt_found')
    const whilePlayingSong = document.getElementById('while_playing_song')
    const betweenRoundsSong = document.getElementById('between_rounds_song')
    const rankingBoxSong = document.getElementById('ranking_box_song')

    // song touch
    const songs = [...document.getElementsByClassName('song_found')]
    var returnedSongsList = []    // lista de musicas que o backend retorna a cada busca



    // Por padrão, o botão de nextRound e de start não é visível
    nextRoundBtn.style.visibility = 'hidden'
    startBtn.style.visibility = 'hidden'


    function copyLink(code) {
        // mudar string caso mude o link
        var link = "http://localhost:4000/home?id=" + code;

        var tempInput = document.createElement("input");
        tempInput.value = link;
        document.body.appendChild(tempInput);
        tempInput.select();
        document.execCommand("copy");
        document.body.removeChild(tempInput);

        alert("Room link copied!");
    }
    linkButton.addEventListener('click', () => {
        let code = document.getElementById('room_code_exib').innerText
        copyLink(code);
    })


    async function runTimeBar(seconds) {
        // Recebe a barra de tempo
        let timebar = document.getElementById('timer_run');
        timebar.style.width = '0%';

        // A cada 1 segundo, diminui 100/seconds da barra, de maneira suave
        for (let i = seconds; i >= 0; i--) {
            timebar.style.width = `${(i / seconds) * 100}%`;
            await new Promise(r => setTimeout(r, 1000));
        }

        let songs = [...document.getElementsByClassName('song_found')]
        songs.forEach((el) => {
            el.parentNode.removeChild(el)
        })

    }

    searchSong.addEventListener('click', () => {
        let artist_name = document.getElementById('artist_name').value;
        let track_name = document.getElementById('track_name').value;

        fetch('http://localhost:4000/api/search_song', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                "artist": artist_name,
                "track": track_name
            })
        })
            .then(response => response.json())
            .then(data => {
                // data = JSON.parse(data)
                // console.log(data)
                if (data.valid == false || data.amount == 0) {
                    // Caso a musica nao seja encontrada, exibe a mensagem de erro
                    returnedSongsList = []
                    whilePlayingSong.style.display = 'none'
                    didntFoundSong.style.display = 'flex'
                } else {
                    waitingForSong.style.display = 'none';
                    didntFoundSong.style.display = 'none';
                    whilePlayingSong.style.display = 'flex';

                    // Primeiramente, limpa as musicas que ja estiverem na tela
                    [...document.getElementsByClassName("song_found")].forEach((song) => {
                        song.parentNode.removeChild(song)
                    })
                    let found = data.found
                    returnedSongsList = found
                    found.forEach((song) => {
                        let songDiv = document.createElement('div')
                        songDiv.classList.add('song_found')
                        songDiv.innerHTML = `
                    <div class="cover" style="background-image: url(${song.album_cover_link});
                    background-size: cover;
                    background-position:center"></div>
                    <div class="info">
                        <h2>${song.song}</h2>
                        <p>${song.artist}</p>
                    </div>
                `
                        let caixa = document.getElementsByClassName('songs')[0]
                        caixa.appendChild(songDiv)
                    })

                    updateSongsButton()
                }
            })
            .catch(error => {
                console.error("Erro ao buscar músicas:", error);
                // Você pode adicionar uma mensagem de erro aqui se a requisição falhar
                didntFoundSong.style.display = 'flex';
                whilePlayingSong.style.display = 'none';
            });
    })

    function playSong(link, image, artist, song, isRight) {
        // Recebe o link para a música e formata o player



        // Recebe o player
        let player = document.querySelector('audio');
        player.src = link;


        let album_image = document.getElementById('album_image');
        album_image.style.backgroundImage = `url(${image})`;

        let artist_name = document.getElementById('artist_info');
        let song_name = document.getElementById('track_info');
        artist_name.innerHTML = artist;
        song_name.innerHTML = song;

        let symbol = document.getElementById('symbol_isRight');
        if (isRight) {
            symbol.classList = 'fa fa-check-circle';
            symbol.style.color = '#56F956'
            document.getElementById('isRight').innerHTML = 'RIIIIGHT!';
        } else {
            symbol.classList = 'fa fa-times-circle';
            symbol.style.color = '#F04949'
            document.getElementById('isRight').innerHTML = 'WROOOONG!';
        }
    }

    const cleanBoxes = () => {
        didntFoundSong.style.display = 'none'
        waitingForRound.style.display = 'none'
        waitingForSong.style.display = 'none'
        whilePlayingRound.style.display = 'none'
        whilePlayingSong.style.display = 'none'
        betweenRounds.style.display = 'none'
        betweenRoundsSong.style.display = 'none'
        rankingBoxRounds.style.display = 'none'
        rankingBoxSong.style.display = 'none'
        no_music_box.style.display = 'none'
    }

    exitRoomBtn.forEach((el) => {
        el.addEventListener('click', () => {
            window.Rooms.getOut()
        })
    })

    startBtn.addEventListener('click', () => {
        // windows logics
        if (waitingForRound) {
            cleanBoxes()

            whilePlayingRound.style.display = 'flex'
            whilePlayingSong.style.display = 'flex'
        }

        startRound()
    })
    nextRoundBtn.addEventListener('click', () => {
        // windows logics
        if (betweenRounds) {
            cleanBoxes()
        }

        startRound()
    })
    restartBtn.addEventListener('click', () => {
        // windows logics
        if (whilePlayingRound) {
            cleanBoxes()

            whilePlayingRound.style.display = 'flex'
            whilePlayingSong.style.display = 'flex'
        }
        // runTimeBar(15)
        startRound()
    })

    function updateSongsButton() {
        let songs = [...document.getElementsByClassName('song_found')]

        songs.forEach((el, ind) => {
            el.addEventListener('click', () => {
                let selectedList = [...document.getElementsByClassName('song_selected')]

                if (selectedList.length > 0) {
                    selectedList.forEach((item) => {
                        item.classList.remove('song_selected')
                    })
                }

                el.classList.add('song_selected')
                let artist = el.getElementsByClassName('info')[0].getElementsByTagName('p')[0].innerHTML
                let song = el.getElementsByClassName('info')[0].getElementsByTagName('h2')[0].innerHTML

                let selectedMusicId = returnedSongsList[ind].music_id
                window.Rooms.sendMusicSelection(artist, song, selectedMusicId)
            })
        })
    }

    function updatePlayers() {
        /*
            Recebe uma lista de jogadores e atualiza a lista de jogadores na tela
            Supondo que o parametro passado e uma lista de objetos com os seguintes atributos:
            {
                "nickname": "nome do jogador",
                "avatar": "avatar do jogador",
                "score": "pontuacao do jogador"
            }
    
            A funcao ira atualizar a lista de jogadores na tela
        */

        // Ordena os jogadores com base em seus scores
        let players = window.Rooms.getPlayers()
        let player = window.Rooms.getPlayer()
        let room = window.Rooms.getGame()

        try {
            if (player.is_admin) {
                nextRoundBtn.style.visibility = 'visible'
                startBtn.style.visibility = 'visible'
            }
        } catch (e) {
            // Caso ocorra um erro, não faz nada
            // console.log(e)
        }

        // console.log("Coleta dos elementos do parte dos players:")
        // console.log(document.getElementById('room_code_exib'))
        // console.log(document.getElementById('players_max'))
        // console.log(document.getElementById('players_min'))
        try {
            document.getElementById('room_code_exib').innerHTML = room.code
            document.getElementById('players_max').innerHTML = room.max_players
            document.getElementById('players_min').innerHTML = players.length
        } catch (e) {
            // console.log("deu erro aqui")
        }

        // ordena pelo score
        try {
            for (let i = 0; i < players.length; i++) {
                for (let j = 0; j < players.length; j++) {
                    if (players[i].score > players[j].score) {
                        let aux = players[i];
                        players[i] = players[j];
                        players[j] = aux;
                    }
                }
            }
        } catch (e) {
            // Caso ocorra um erro, não faz nada
            // console.log(e)
        }

        // Limpa a lista de jogadores já exibida
        try {
            let players_cards = [...document.getElementsByClassName('player')]
            if (players_cards.length > 0) {
                players_cards.forEach((el) => {
                    el.parentNode.removeChild(el);
                })
            }
        } catch (e) {
            // console.log(e)
        }

        try {
            players.forEach((player) => {
                let playerDiv = document.createElement('div')
                playerDiv.classList.add('player')

                if (player.is_admin) {
                    playerDiv.innerHTML = `
                    <div class="profile" id="host" style="background-image: url(/images/avatars/${player.photo_id}.png); 
                    background-size: cover;
                    background-position:center"><i class="fas fa-crown"></i></div>
                    <div class="info">
                        <h2>${player.nickname}</h2>
                        <p>${player.score} points</p>
                    </div>
                `
                } else {
                    playerDiv.innerHTML = `
                    <div class="profile" style="background-image: url(/images/avatars/${player.photo_id}.png);
                    background-size: cover;
                    background-position:center"></div>
                    <div class="info">
                        <h2>${player.nickname}</h2>
                        <p>${player.score} points</p>
                    </div>
                `
                }
                document.getElementById('players').appendChild(playerDiv)
            })
        } catch (e) {
            // Caso ocorra um erro, não faz nada
            console.log(e)
        }

        updateRanking()
    }

    function updateRanking() {
        /*
            Recebe uma lista de jogadores e configura o ranking da rodada
            Supondo que o parametro passado e uma lista de objetos com os seguintes atributos:
            {
                "nickname": "nome do jogador",
                "avatar": "avatar do jogador",
                "score": "pontuacao do jogador"
            }
        */

        let players = window.Rooms.getPlayers()
        let ranking = []
        let max = 3
        for (let i = 0; i < players.length && max != 0; i++) {
            ranking.push({
                "nickname": players[i].nickname,
                "avatar": players[i].photo_id,
                "score": players[i].score
            })
            max--;
        }

        // // Ordena os jogadores com base em seus scores
        // for(let i = 0; i < ranking.length; i++){
        //     for(let j = 0; j < ranking.length; j++){
        //         if(ranking[i].score > ranking[j].score){
        //             let aux = ranking[i];
        //             ranking[i] = ranking[j];
        //             ranking[j] = aux;
        //         }
        //     }
        // }

        console.log("Ranking:")
        console.log(ranking)
        try {
            // Adiciona as imagens e as informacoes dos jogadores no ranking
            document.getElementById('first_place_img').style.backgroundImage = `url(/images/avatars/${ranking[0].avatar}.png)`
            document.getElementById('first_place_name').innerHTML = ranking[0].nickname
            document.getElementById('first_place_points').innerHTML = ranking[0].score + ' points'
            document.getElementById('first_place').style.visibility = 'visible'
            console.log("Adicionou o primeiro colocado")


            document.getElementById('second_place_img').style.backgroundImage = `url(/images/avatars/${ranking[1].avatar}.png)`
            document.getElementById('second_place_name').innerHTML = ranking[1].nickname
            document.getElementById('second_place_points').innerHTML = ranking[1].score + ' points'
            document.getElementById('second_place').style.visibility = 'visible'
            console.log("Adicionou o segundo colocado")


            document.getElementById('third_place_img').style.backgroundImage = `url(/images/avatars/${ranking[2].avatar}.png)`
            document.getElementById('third_place_name').innerHTML = ranking[2].nickname
            document.getElementById('third_place_points').innerHTML = ranking[2].score + ' points'
            document.getElementById('third_place').style.visibility = 'visible'
            console.log("Adicionou o terceiro colocado")

        } catch (e) {
            // Caso ocorra um erro, é pq não tem pelo menos 3 jogadores
            console.log("Erro: " + e)
        }

        document.getElementById('winner_name').innerHTML = ranking[0].nickname
        document.getElementById('winner_points').innerHTML = ranking[0].score
    }

    function startRound() {
        // troca da tela de espera para a tela de jogo
        waitingForRound.style.display = 'none'
        betweenRounds.style.display = 'none'
        whilePlayingRound.style.display = 'flex'

        // coloca a tela lateral pra modo de pesquisa de musicas
        didntFoundSong.style.display = 'none'
        betweenRoundsSong.style.display = 'none'
        waitingForSong.style.display = 'none'
        whilePlayingSong.style.display = 'flex'
        updateSongsButton()
        window.Rooms.sendNextRoundOrder()
    }

    function updateRoom() {
        let room = window.Rooms.getGame()
        // console.log("-----------------------")
        // console.log("Atualizando a sala", room)

        if (room.status == 'waiting') {
            // Se a sala estiver esperando, exibe a tela de espera
            cleanBoxes()
            waitingForRound.style.display = 'flex'
        } else if (room.status == 'playing') {
            // Se a sala estiver jogando, exibe a tela de jogo
            cleanBoxes()
            whilePlayingRound.style.display = 'flex'
            whilePlayingSong.style.display = 'flex'
            let round_words = [...document.getElementsByClassName('round_word')]
            round_words.forEach((el) => {
                el.innerHTML = room.room_word.toUpperCase()
            })
            runTimeBar(30)
        } else if (room.status == 'between_rounds') {
            // Se a sala estiver entre rodadas, exibe a tela de entre rodadas
            cleanBoxes()
            cleanSongsResults()
            betweenRounds.style.display = 'flex'
            betweenRoundsSong.style.display = 'flex'
            updateGuesses()
        } else if (room.status == 'end') {
            // Se a sala estiver exibindo o ranking, exibe a tela de ranking
            cleanBoxes()
            rankingBoxRounds.style.display = 'flex'
            betweenRoundsSong.style.display = 'flex'
            cleanSongsResults()
            updateGuesses()
        }
    }

    function cleanSongsResults() {
        let trash = [...document.getElementsByClassName('song_results')]

        if (trash.length > 0) {
            trash.forEach((el) => {
                el.parentNode.removeChild(el)
            })
        }
    }

    function getPlayerName(players, id) {
        for (let i = 0; i < players.length; i++) {
            if (players[i].id == id) {
                return players[i].nickname
            }
        }
    }

    function updateGuesses() {
        let guesses = window.Rooms.getGuesses()
        let players = window.Rooms.getPlayers()


        /*
            Primeiramente, acumula os jogadores que colocaram a mesma musica
            Com o formato:
            [{
                "song": "nome da musica",
                "artist": "nome do artista",
                "album_cover_link": "link da capa do album",
                "players": ["jogador 1", "jogador 2", ...]
            }]
            },
            ...        
            ]
        */

        let guessLength = !guesses ? 0 : guesses.length
        let acumulator = []
        for (let i = 0; i < guessLength; i++) {
            // Passo 1: verifica se a musica ja foi acumulada
            let found = false
            for (let j = 0; j < acumulator.length; j++) {
                if (acumulator[j].song == guesses[i].song && acumulator[j].artist == guesses[i].artist) {
                    acumulator[j].players.push(guesses[i].player)
                    found = true
                    break
                }
            }

            // Passo 2: se a musica nao foi acumulada, acumula ela
            let album_cover_link = ""
            let song_preview = ""
            fetch("http://localhost:4000/api/search_by_id", {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    "id": guesses[i].selected_music_id,
                })
            }).then(response => response.json())
                .then(data => {
                    // data = JSON.parse(data)
                    // console.log(data)
                    if (data.valid == true) {
                        album_cover_link = data.result.album_link
                        song_preview = data.result.music_preview
                    } else {
                        alert("Erro ao buscar os dados da musica")
                    }

                    let name_player = getPlayerName(players, guesses[i].player_id)

                    if (!found) {
                        acumulator.push({
                            "song": guesses[i].song_name,
                            "artist": guesses[i].artist,
                            "album_cover_link": album_cover_link,
                            "song_preview": song_preview,
                            "players": [name_player],
                            "is_correct": guesses[i].is_correct
                        })
                    }


                    /*
                        Com a lista acumulada, exibe na tela
                    */

                    if (i == guessLength - 1) {
                        let caixa = document.getElementsByClassName('results_songs_box')[0]


                        cleanSongsResults()

                        for (let i = 0; i < acumulator.length; i++) {
                            // console.log(acumulator[i])
                            let el = acumulator[i]
                            // console.log("inserindo "+ el + " na tela")
                            let songDiv = document.createElement('div')
                            let player_str = el.players.join(" e ")
                            songDiv.classList.add('song_results')
                            if (el.is_correct)
                                songDiv.classList.add('correct_song')
                            else
                                songDiv.classList.add('wrong_song')

                            songDiv.innerHTML = `
                        <div class="cover" style="background: url(${el.album_cover_link}); background-size: cover; background-position: center"></div>
                        <div class="info">
                        <h6>${player_str}</h6>
                        <h2>${el.song}</h2>
                        <p>${el.artist}</p>
                        </div>
                    `
                            caixa.appendChild(songDiv)
                        }

                        updateResults()
                        viewOtherMusics()
                        return
                    }
                })

        }
    }

    function updateResults() {
        let guesses = window.Rooms.getGuesses()
        let player = window.Rooms.getPlayer()

        if (!guesses)
            return


        // Informa pro jogador se ele acertou ou errou a musica
        try {
            guesses = [...guesses]
        } catch (e) {
            guesses = [guesses]

        }

        guesses.forEach((el) => {
            if (el.player_id == player.id) {
                if (el.is_correct) {
                    document.getElementById('isRight').innerHTML = 'RIIIIGHT!';
                } else {
                    document.getElementById('isRight').innerHTML = 'WROOOONG!';
                }


                fetch("http://localhost:4000/api/search_by_id", {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        "id": el.selected_music_id,
                    })
                }).then(response => response.json())
                    .then(data => {
                        // data = JSON.parse(data)
                        // console.log(data)
                        if (data.valid == true) {
                            playSong(data.result.music_preview, data.result.album_link, el.artist, el.song_name, el.is_correct)
                        } else {
                            alert("Erro ao buscar os dados da musica")
                        }
                    })

            }
        })
    }

    function viewOtherMusics() {
        // Permite que o usuario ouca musicas que outros jogadores escolheram

        let song_results = [...document.getElementsByClassName('song_results')]
        let artist = ""
        let song = ""

        let guesses = window.Rooms.getGuesses()
        // console.log(song_results)

        song_results.forEach((el, ind) => {
            el.addEventListener('click', () => {
                artist = el.getElementsByClassName('info')[0].getElementsByTagName('p')[0].innerHTML
                song = el.getElementsByClassName('info')[0].getElementsByTagName('h2')[0].innerHTML

                // console.log("Dados: " + artist + ", " + song)
                let selectedMusicId = guesses[ind].selected_music_id
                let gs = guesses[ind]

                fetch("http://localhost:4000/api/search_by_id", {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        "id": selectedMusicId,
                    })
                }).then(response => response.json())
                    .then(data => {
                        // data = JSON.parse(data)
                        // console.log(data)
                        if (data.valid == true) {
                            playSong(data.result.music_preview, data.result.album_link, artist, song, gs.is_correct)
                        } else {
                            alert("Erro ao buscar os dados da musica")
                        }
                    })
            })
        })
    }

    updatePlayers()

    window.Rooms.setListenPlayers(updatePlayers)
    window.Rooms.setListenGame(updateRoom)
    window.Rooms.setListenMusicGuesses(updateGuesses)


    window.Rooms.setListenShout((payload) => {
        // {
        //     body: body,
        //     nickname: player.nickname
        // }
        console.log("Received message", payload);
        let msg = payload.body
        let chat_area = document.getElementById('chat_area')
        let player = payload.nickname
        let chat = document.createElement('div')
        chat.classList.add('chat')
        chat.innerHTML = `
        <p>
        <span>${player}</span> :
        ${msg}</p>
    `
        chat_area.appendChild(chat)
        document.getElementById('msg_text').value = ""
    })

    document.getElementById('send_msg').addEventListener('click', () => {
        let msg = document.getElementById('msg_text').value
        window.Rooms.sendMessage(msg)
    })

}