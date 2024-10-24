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
}

searchSong.addEventListener('click', () => {
    console.log("oi")
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

        whilePlayingRound.style.display = 'flex'
        whilePlayingSong.style.display = 'flex'
    }
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


link = "https://cdnt-preview.dzcdn.net/api/1/1/4/5/9/0/459c235b39ef8badd04c5ef181f58c24.mp3?hdnea=exp=1729648847~acl=/api/1/1/4/5/9/0/459c235b39ef8badd04c5ef181f58c24.mp3*~data=user_id=0,application_id=42~hmac=41b71fd4dd3bd0338c3b5510b46e60d7f0b81499ef1351e18bf49e1ca4f21e47"
playSong(link, "https:\/\/api.deezer.com\/artist\/75491\/image", "Lady Gaga", "Die with a smile", false);
