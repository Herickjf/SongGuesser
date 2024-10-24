/*
    JavaScript configurations for the frontend file 'index.html'
*/

const nickname          = document.getElementById('nickname_input');
const roomCode          = document.getElementById('roomCode_input');
const password          = document.getElementById('password_input');
const goto_enterRoom    = document.getElementById('goto_enterRoom');
const goto_createRoom   = document.getElementById('goto_createRoom');
const enterRoom         = document.getElementById('enterRoom');
const createRoom        = document.getElementById('createRoom');
const flags             = [...document.getElementsByClassName('flag')]

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
    if(selected != null){
        selected = selected[0]
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