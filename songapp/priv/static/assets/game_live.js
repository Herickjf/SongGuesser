export default function gameLive() {
    console.log("game_live.js loaded");
}

/*
    JavaScript configurations for the frontend file 'gameScreen.html'
*/
const linkButton        = document.getElementById('link_button');
const searchSong        = document.getElementById('search_song');
const exitRoomBtn       = [...document.getElementsByClassName('btn_exit')]
const startBtn          = [...document.getElementsByClassName('btn_start')][0]
const restartBtn        = document.getElementById('btn_restart')
const nextRoundBtn      = [...document.getElementsByClassName('btn_next_round')][0]

// divs for each match moment
    // round_box
const waitingForRound   = document.getElementById('waiting_for')
const whilePlayingRound = document.getElementById('while_playing')
const betweenRounds     = document.getElementById('between_rounds')
const rankingBoxRounds  = document.getElementById('ranking_box')
    // songs_box
const waitingForSong    = document.getElementById('waiting_for_song')
const didntFoundSong    = document.getElementById('didnt_found')
const whilePlayingSong  = document.getElementById('while_playing_song')
const betweenRoundsSong = document.getElementById('between_rounds_song')
const rankingBoxSong    = document.getElementById('ranking_box_song')

// song touch
const songs             = [...document.getElementsByClassName('song_found')]

setTimeout(() => {
    window.Rooms.setListenPlayers(updatePlayers)
}, 1000)


function copyLink(code){
    var link = "http://localhost:5500/frontend/index.html?id=" + code;
    
    var tempInput = document.createElement("input");
    tempInput.value = link;
    document.body.appendChild(tempInput);
    tempInput.select();
    document.execCommand("copy");
    document.body.removeChild(tempInput);

    alert(`Código ${code} copiado para área de transferência!`);
}
linkButton.addEventListener('click', () =>{
    copyLink('12345678');
})


async function runTimeBar(seconds){
    // Recebe a barra de tempo
    let timebar = document.getElementById('timer_run');
    timebar.style.width = '0%';

    // A cada 1 segundo, diminui 100/seconds da barra, de maneira suave
    for(let i = seconds; i >= 0; i--){
        timebar.style.width = `${(i/seconds)*100}%`;
        await new Promise(r => setTimeout(r, 1000));
    }

    // Quando a barra chegar a 0, coleta e envia a musica selecionada, caso haja
    let selected_song = document.getElementsByClassName('song_selected');
    if(selected_song.length > 0){
        let artist_name = selected_song[0].children[1].children[0].innerHTML;
        let song_name = selected_song[0].children[1].children[1].innerHTML;
        window.Rooms.sendMusicSelection(artist_name, song_name);
    } 
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
        data = JSON.parse(data)
        if(data.valid == false || data.amount == 0){
            // Caso a musica nao seja encontrada, exibe a mensagem de erro
            whilePlayingSong.style.display = 'none'
            didntFoundSong.style.display = 'flex'
        }else{
            waitingForSong.style.display = 'none';
            didntFoundSong.style.display = 'none';
            whilePlayingSong.style.display = 'flex';

            // Primeiramente, limpa as musicas que ja estiverem na tela
            [...document.getElementsByClassName("song_found")].forEach((song) => {
                song.parentNode.removeChild(song)
            })

            let found = data.found
            found.forEach((song) => {
                let songDiv = document.createElement('div')
                songDiv.classList.add('song_found')
                songDiv.innerHTML = `
                    <div class="cover" style="background-image: url(${song.album_image})"></div>
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

function playSong(link, image, artist, song, isRight){
    // Recebe o link para a música e formata o player

    // Recebe o player
    let player = document.querySelector('audio');
    player.src = link;


    let album_image = document.getElementById('album_image');

    let artist_name = document.getElementById('artist_info');
    let song_name = document.getElementById('track_info');
    artist_name.innerHTML = artist;
    song_name.innerHTML = song;

    let symbol = document.getElementById('symbol_isRight');
    if(isRight){
        symbol.classList = 'fa fa-check-circle';
        symbol.style.color = '#56F956'
        document.getElementById('isRight').innerHTML = 'RIIIIGHT!';
    } else{
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
}

exitRoomBtn.forEach((el) => {
    el.addEventListener('click', () => {
        console.log("exiting room...")
    })
}) 
startBtn.addEventListener('click', () => {
    // windows logics
    if(waitingForRound){
        cleanBoxes()
        
        whilePlayingRound.style.display = 'flex'
        whilePlayingSong.style.display = 'flex'
    }
})
nextRoundBtn.addEventListener('click', () => {
    // windows logics
    if(betweenRounds){
        cleanBoxes()
    }

    startRound()
})
restartBtn.addEventListener('click', () => {
    // windows logics
    if(whilePlayingRound){
        cleanBoxes()
        
        whilePlayingRound.style.display = 'flex'
        whilePlayingSong.style.display = 'flex'
    }
    // runTimeBar(15)
})

function updateSongsButton(){
    let songs = [...document.getElementsByClassName('song_found')]

    songs.forEach((el) => {
        el.addEventListener('click', () => {
            let selectedList = [...document.getElementsByClassName('song_selected')]
    
            if(selectedList.length > 0){
                selectedList.forEach((item) =>{
                    item.classList.remove('song_selected')
                })
            }
            
            el.classList.add('song_selected')
        })
    })
}

function updatePlayers(){
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
    players.forEach((player) => {
        console.log(player)
    })
    for(let i = 0; i < players.length; i++){
        for(let j = 0; j < players.length; j++){
            if(players[i].score > players[j].score){
                let aux = players[i];
                players[i] = players[j];
                players[j] = aux;
            }
        }
    }

    // Limpa a lista de jogadores já exibida
    try{
        players_box = document.getElementById('players')
        console.log(players_box)
        if(players_box != undefined){
            players_box.innerHTML = ''
            players_box.children.forEach((child) => {
                child.parentNode.removeChild(child);
            })
        }
    }catch(e){
        console.log("Erro ao limpar a lista de jogadores")
    }

    players.forEach((player) => {
        let playerDiv = document.createElement('div')
        playerDiv.classList.add('player')
        playerDiv.innerHTML = `
            <div class="profile" style="background-image: url(/frontend/assets/avatars/${player.photo_id}.png)"></div>
            <div class="info">
                <h2>${player.nickname}</h2>
                <p>${player.score} points</p>
            </div>
        `
        document.getElementById('players').appendChild(playerDiv)
    })

}

function updateRanking(ranking){
    /*
        Recebe uma lista de jogadores e configura o ranking da rodada
        Supondo que o parametro passado e uma lista de objetos com os seguintes atributos:
        {
            "nickname": "nome do jogador",
            "avatar": "avatar do jogador",
            "score": "pontuacao do jogador"
        }
    */

    // Ordena os jogadores com base em seus scores
    for(let i = 0; i < ranking.length; i++){
        for(let j = 0; j < ranking.length; j++){
            if(ranking[i].score > ranking[j].score){
                let aux = ranking[i];
                ranking[i] = ranking[j];
                ranking[j] = aux;
            }
        }
    }

    // Adiciona as imagens e as informacoes dos jogadores no ranking
    document.getElementById('first_place_img').style.backgroundImage = `url(/frontend/assets/avatars/${ranking[0].avatar}.png)`
    document.getElementById('first_place_name').innerHTML = ranking[0].nickname
    document.getElementById('first_place_score').innerHTML = ranking[0].score + ' points'

    document.getElementById('second_place_img').style.backgroundImage = `url(/frontend/assets/avatars/${ranking[1].avatar}.png)`
    document.getElementById('second_place_name').innerHTML = ranking[1].nickname
    document.getElementById('second_place_score').innerHTML = ranking[1].score + ' points'

    document.getElementById('third_place_img').style.backgroundImage = `url(/frontend/assets/avatars/${ranking[2].avatar}.png)`
    document.getElementById('third_place_name').innerHTML = ranking[2].nickname
    document.getElementById('third_place_score').innerHTML = ranking[2].score + ' points'
    
}

function startRound(){
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


    runTimeBar(20)
}

updatePlayers()