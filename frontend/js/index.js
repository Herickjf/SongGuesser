/*
    JavaScript configurations for the frontend file 'index.html'
*/

const nickname          = document.getElementById('nickname_input');
const roomCode          = document.getElementById('roomCode_input');
const password          = document.getElementById('create_password');
const goto_enterRoom    = document.getElementById('goto_enterRoom');
const goto_createRoom   = document.getElementById('goto_createRoom');
const enterRoom         = document.getElementById('enterRoom');
const createRoom        = document.getElementById('createRoom');
const flags             = [...document.getElementsByClassName('flag')]
const userImg           = [...document.getElementsByClassName('user_image')]
const changeImg         = [...document.getElementsByClassName('change_image')]
const images            = [...document.getElementById('images').children]
const selectImages      = document.getElementById('selection_images')

const maxPlayersInput   = document.getElementById('max_players')
const nRoundsInput   = document.getElementById('rounds')

// parametros e funcao para autofill
const inputCode = document.getElementById('roomCode_input');
const urlParams = new URLSearchParams(window.location.search);
const id = urlParams.get('id');


function fillCode(id){
    if(id !== ""){
        // tratar ids maiores que 6
        inputCode.value = id;
    }
}
fillCode(id);


function removeFlagSelected(){
    // Remove qual bandeira estiver escolhida
    let selected = document.getElementsByClassName("selected")
    if(selected.length != 0){
        selected = selected[0]
        // console.log(selected.classList)
        selected.classList.remove('selected')
    }
}

flags.forEach((el, i, flags) => {
    el.addEventListener('click', ()=>{
        removeFlagSelected();
        el.classList.add('selected');
    });
})

goto_enterRoom.addEventListener('click', () => {
    /*
        Redirects the user to the 'enterRoom' page.
    */
    
    document.getElementById('credentials').style.display = 'none'
    document.getElementById('enter-room').style.display = 'block'

});

goto_createRoom.addEventListener('click', () => {
    /*
        Redirects the user to the 'createRoom' page.
        If the name is empty, it will alert the user.
    */
    if(nickname.value == ''){
        alert('Please, enter a nickname');
        return;
    }
    document.getElementById('credentials').style.display = 'none'
    document.getElementById('create-room').style.display = 'block'
});

enterRoom.addEventListener('click', () => {
    /*
        Redirects the user to the 'room' page, if the password of the room is correct.
    */
   
    let nickNameRegex = /^[a-zA-Z0-9]+$/;
    let passwordRegex = /^[a-zA-Z0-9!@#$%^&*()_+={}\[\]:;"'<>,.?/\\|~`-]{6,10}$/
    let roomCodeRegex = /^[A-Z0-9]{6}$/
    
    if(!nickNameRegex.test(nickname.value)){
        nickname.value = ""
        // "voltar" a tela
        document.getElementById('enter-room').style.display = 'none'
        document.getElementById('credentials').style.display = 'flex'
        
        alert("Choose a nickname with letters and numbers only!")
        return;
    }
    if(!passwordRegex.test(password.value)){
        console.log(password.value)
        password.value = ""
        alert("Fill the password with letters, numbers and valid simbols only!")
        return;
    }
    if(!roomCodeRegex.test(roomCode.value)){
        roomCode.value = ""
        
        document.getElementById('enter-room').style.display = 'none'
        document.getElementById('credentials').style.display = 'flex'

        alert("Invalid Code!")
        return;
    }
    
    let route = '';
    fetch(route, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            'roomCode': roomCode.value,
            'password': password.value,
            'nickname': nickname.value,
        })
    })
    .then(response => response.json())
    .then(data => {
        if (data.valid == true) {
            // To be implemented
        } else {
            // If it's not valid, it will alert the user and redirect to the credentials inputs.
            alert(data.message);
            document.getElementById('credentials').style.display = 'block'
            document.getElementById('enter-room').style.display = 'none'
        }
    })
    .catch(error => {
        console.error('Error:', error);
    });
});

createRoom.addEventListener('click', () => {
    /*
        Redirects the user to the new 'room' page, if all the data are correct.
    */

    // garantir que a entrada numerica nao esteja fora do intervalo definido
    if(maxPlayersInput.value == "" || nRoundsInput.value == "" || password.value == ""){
        alert("Preencha todos os campos")
        return
    }

    let max_players = parseInt(maxPlayersInput.value)   // 2 - 20
    let num_rounds = parseInt(nRoundsInput.value)       // 3 - 15

    if(max_players > 20){
        max_players = 20;
    }else if(max_players < 2){
        max_players = 2;
    }
    maxPlayersInput.value = max_players

    if(num_rounds > 15){
        num_rounds = 15;
    }else if(num_rounds < 3){
        num_rounds = 3;
    }
    nRoundsInput.value = num_rounds

    // teste de validade do nickname e da senha
    let nickNameRegex = /^[a-zA-Z0-9]+$/;
    let passwordRegex = /^[a-zA-Z0-9!@#$%^&*()_+={}\[\]:;"'<>,.?/\\|~`-]{6,10}$/
    
    if(!nickNameRegex.test(nickname.value)){
        nickname.value = ""
        // "voltar" a tela
        document.getElementById('create-room').style.display = 'none'
        document.getElementById('credentials').style.display = 'flex'
        
        alert("Choose a nickname with letters and numbers only!")
        return;
    }
    if(!passwordRegex.test(password.value)){
        password.value = ""
        alert("Choose a password with letters, numbers and valid simbols only!")
        return;
    }

    selectImages.style.visibility = "hidden"
    let route = '';
    fetch(route, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            'roomCode': roomCode.value,
            'password': password.value,
            'nickname': nickname.value,
        })
    })
    .then(response => response.json())
    .then(data => {
        if (data.valid == true) {
            //To be implemented
        } else {
            // If it's not valid, it will alert the user and redirect to the credentials inputs.
            alert(data.message);
            document.getElementById('credentials').style.display = 'block'
            document.getElementById('create-room').style.display = 'none'
        }
    })
    .catch(error => {
        console.error('Error:', error);
    });
});

changeImg.forEach((el) => {
    el.addEventListener('click', ()=>{
        console.log(selectImages)
        console.log(selectImages.style.display)
        selectImages.style.visibility = "visible"
    })
})

images.forEach((el, i) => {
    el.addEventListener('click', ()=>{
        userImg[0].style.backgroundImage = `url(/SongGuesser/assets/avatars/${i+1}.png)`
        userImg[1].style.backgroundImage = `url(/SongGuesser/assets/avatars/${i+1}.png)`
        selectImages.style.visibility = "hidden";
    })
})