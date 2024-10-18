const gotoEnterRoom  = document.getElementById('goto_enterRoom')
const gotoCreateRoom = document.getElementById('goto_createRoom')
const enterRoom      = document.getElementById('enterRoom')
const createRoom     = document.getElementById('createRoom')
const flags          = [...document.getElementsByClassName('flag')]

/*
    Nao tem nada de importante aqui ainda, sao apenas para testar o front.
    elas trocam o conteudo do que esta dentro da caixa do input no home
*/

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

gotoEnterRoom.addEventListener('click', ()=>{
    document.getElementById('credentials').style.display = 'none'
    document.getElementById('enter-room').style.display = 'block'
})

gotoCreateRoom.addEventListener('click', ()=>{
    document.getElementById('credentials').style.display = 'none'
    document.getElementById('create-room').style.display = 'block'
})

enterRoom.addEventListener('click', ()=>{
    document.getElementById('enter-room').style.display = 'none'
    document.getElementById('credentials').style.display = 'block'
})

createRoom.addEventListener('click', ()=>{
    document.getElementById('create-room').style.display = 'none'
    document.getElementById('credentials').style.display = 'block'
})