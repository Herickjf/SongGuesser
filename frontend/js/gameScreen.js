/*
    JavaScript configurations for the frontend file 'gameScreen.html'
*/
const linkButton        = document.getElementById('link_button');
const searchSong        = document.getElementById('search_song');


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
    copyLink('123456');
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
    album_image.style.width = 100;
    album_image.style.height = 100;
    album_image.style.backgroundImage = `url(${image})`;

    let artist_name = document.getElementById('artist_info');
    let song_name = document.getElementById('track_info');
    artist_name.innerHTML = artist;
    song_name.innerHTML = song;

    let symbol = document.getElementById('symbol_isRight');
    if(isRight){
        symbol.classList = 'fas fa-check-circle';
        document.getElementById('isRight').innerHTML = 'RIIIIGHT!';
    } else{
        symbol.classList = 'fas fa-times-circle';
        document.getElementById('isRight').innerHTML = 'WROOOONG!';
    }
 }
























link = "https://cdnt-preview.dzcdn.net/api/1/1/4/5/9/0/459c235b39ef8badd04c5ef181f58c24.mp3?hdnea=exp=1729648847~acl=/api/1/1/4/5/9/0/459c235b39ef8badd04c5ef181f58c24.mp3*~data=user_id=0,application_id=42~hmac=41b71fd4dd3bd0338c3b5510b46e60d7f0b81499ef1351e18bf49e1ca4f21e47"
playSong(link, "https:\/\/api.deezer.com\/artist\/75491\/image", "Lady Gaga", "Die with a smile", false);
