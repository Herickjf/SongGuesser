/*
JavaScript configurations for the frontend file 'index.html'
*/
console.log("da zoom nessa bct")

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
    

    console.log('clicked')        
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

const create_room_params = () => {
    /*
    Redirects the user to the new 'room' page, if all the data are correct.
    */
   
    selectImages.style.visibility = "hidden"

    // verificar se a senha e o nickname foram preenchidos
    if(password.value == ""){
        alert("Please, enter the password!")
        return { "success": false }
    }
    if(nickname.value == ""){
        alert("Please, enter the nickname!")
        // "voltar" a tela
        document.getElementById('create-room').style.display = 'none'
        document.getElementById('credentials').style.display = 'flex'
        return {"success": false}
    }
    
    
    // teste de validade do nickname e da senha
    let nickNameRegex = /^[a-zA-Z0-9]+$/;
    let passwordRegex = /^[a-zA-Z0-9!@#$%^&*()_+={}\[\]:;"'<>,.?/\\|~`-]+$/
    
    if(!nickNameRegex.test(nickname.value)){
        nickname.value = ""
        // "voltar" a tela
        document.getElementById('create-room').style.display = 'none'
        document.getElementById('credentials').style.display = 'flex'
        
        alert("Choose a nickname with letters and numbers only!")
        return {"success": false};
    }
    if(!passwordRegex.test(password.value)){
        password.value = ""
        alert("Choose a password with letters, numbers and valid simbols only!")
        return {"success": false};
    }
    
    
    // tratamento da quantidade maxima de players
    let max_playersInput = document.getElementById('max_players')
    let max_players = 0
    if(max_playersInput.value != ""){
        max_players = parseInt(max_playersInput.value)
        if(max_players < 2) 
            max_players = 2
        else if(max_players > 20)
            max_players = 20
    }else{
        max_players = 2
    }
    
    
    // tratamento da quantidade de rounds
    let roundsInput = document.getElementById('rounds')
    let nRounds = 0
    if(roundsInput.value != ""){
        nRounds = parseInt(roundsInput.value)
        if(nRounds < 3) 
            nRounds = 3
        else if(nRounds > 15)
            nRounds = 15
    }else{
        nRounds = 3
    }
    
    
    // Coleta e verificao da linguagem
    let flagSelected = document.getElementsByClassName('selected')
    let language = ""
    
    if(flagSelected[0].classList.contains('br')){
        language = "portuguese"
    }else if(flagSelected[0].classList.contains('es')){
        language = "spanish"
    }else{              
        language = "english"
    }
    
    
    // coletar o avatar
    let avatarInput = document.getElementById('host_avatar')
    let avatar = window.getComputedStyle(avatarInput).backgroundImage // pois o backgroundImage foi definido em CSS, não inline 
    avatar = avatar.split('/'); 
    avatar = avatar[avatar.length - 1];  
    avatar = parseInt(avatar.split('.')[0])
    
    return {
        "success": true,
        "room_password": password.value,
        "room_rounds": nRounds,
        "room_max_players": max_players,
        "room_language": language,
        "nickname": nickname.value,
        "photo_id": avatar
    }
}

const join_room_params = () => {
    // verificar se a senha e o nickname foram preenchidos
    if(password.value == ""){
        alert("Fill the password input")
        return { "success": false }
    }
    if(nickname.value == ""){
        alert("Fill the nickname input")
        // "voltar" a tela
        document.getElementById('enter-room').style.display = 'none'
        document.getElementById('credentials').style.display = 'flex'
        return { "success": false }
    }
    
    
    // teste de validade do nickname e da senha
    let nickNameRegex = /^[a-zA-Z0-9]+$/;
    let passwordRegex = /^[a-zA-Z0-9!@#$%^&*()_+={}\[\]:;"'<>,.?/\\|~`-]+$/
    
    if(!nickNameRegex.test(nickname.value)){
        nickname.value = ""
        // "voltar" a tela
        document.getElementById('create-room').style.display = 'none'
        document.getElementById('credentials').style.display = 'flex'
        
        alert("Choose a nickname with letters and numbers only!")
        return { "success": false };
    }
    if(!passwordRegex.test(password.value)){
        password.value = ""
        alert("Choose a password with letters, numbers and valid simbols only!")
        return { "success": false }
    }     
    
    
    // verificando o codigo da sala
    let roomCodeRegex = /^[A-Z0-9]+$/;
    
    let roomCodeInput = document.getElementById('roomCode_input')
    if(!roomCodeRegex.test(roomCodeInput.value)){
        document.getElementById('enter-room').style.display = 'none'
        document.getElementById('credentials').style.display = 'flex'
        
        alert("Please, enter a valid room code!")
        return { "success": false };
    }

    // coletar o avatar
    let avatarInput = document.getElementById('player_avatar')
    let avatar = window.getComputedStyle(avatarInput).backgroundImage // pois o backgroundImage foi definido em CSS, não inline 
    avatar = avatar.split('/'); 
    avatar = avatar[avatar.length - 1];  
    avatar = parseInt(avatar.split('.')[0])

    return {
        "success": true,
        "room_code": roomCode.value,
        "room_password": password.value,
        "photo_id": avatar,
        "nickname": nickname.value
    }
}


changeImg.forEach((el) => {
    el.addEventListener('click', ()=>{
        console.log(selectImages)
        console.log(selectImages.style.display)
        selectImages.style.visibility = "visible"
    })
})

images.forEach((el, i) => {
    el.addEventListener('click', ()=>{
        userImg[0].style.backgroundImage = `url(/frontend/assets/avatars/${i+1}.png)`
        userImg[1].style.backgroundImage = `url(/frontend/assets/avatars/${i+1}.png)`
        selectImages.style.visibility = "hidden";
    })
})



// /////////////////////////////////////
// Exportando as funcoes 
export { create_room_params, join_room_params };