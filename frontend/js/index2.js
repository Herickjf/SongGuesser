const flags             = [...document.getElementsByClassName('flag')]
const addPlayer         = document.getElementById('addPlayer')
const removeLast        = document.getElementById('removeLastPlayer')
var pencilList          = [... document.getElementsByClassName('change_image')]
const selectImages      = document.getElementById('selection_images')
var images              = [... document.getElementById('images').children]
var userImg             = [... document.getElementsByClassName('user_image')]
const createRoom        = document.getElementById('createRoom')

let indice_to_change

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

addPlayer.addEventListener('click', ()=>{
    // Verifica se ja nao excedeu o maximo
    let current_qtd = document.getElementById("current_qtd")
    if(current_qtd.innerHTML == "20"){
        alert("Cannot add another player. Room size limit exceeded!")
        return;
    }

    current_qtd.innerHTML = String(Number(current_qtd.innerHTML) + 1)
    
    // Criacoes e atribuicoes de classes
    let newBox = document.createElement('div')
    newBox.classList.add('format_player_box')

    let new_image_box = document.createElement('div')
    new_image_box.classList.add('imageSelection_box')

    let user_image = document.createElement('div')
    user_image.classList.add('user_image')

    let pencil_box = document.createElement('div')
    pencil_box.classList.add('fa')
    pencil_box.classList.add('fa-pencil')
    pencil_box.classList.add('change_image')

    let info_box = document.createElement('div')
    info_box.classList.add('info')

    let input_box = document.createElement('div')
    input_box.classList.add('input')

    let input_text = document.createElement('input')
    input_text.classList.add('player_name_input')
    input_text.setAttribute("type", "text")
    input_text.setAttribute("placeholder", "Enter player name")


    // Insercoes
    user_image.appendChild(pencil_box)
    new_image_box.appendChild(user_image)
    newBox.appendChild(new_image_box)
    input_box.appendChild(input_text)
    info_box.appendChild(input_box)
    newBox.appendChild(info_box)

    // Insercao na pagina
    document.getElementsByClassName('create_players_box')[0].appendChild(newBox)
    updatePencilFunctions()
})

removeLast.addEventListener('click', ()=>{
    let current_qtd = document.getElementById("current_qtd")
    if(current_qtd.innerHTML == "0"){
        alert("Nao ha mais nenhum jogador a ser removido!")
        return;
    }

    let box = document.getElementsByClassName('create_players_box')[0]

    if(box.children.length == 1){
        document.getElementsByClassName('player_name_input')[0].value = ""
    }else{
        current_qtd.innerHTML = String(Number(current_qtd.innerHTML) - 1)
        box.removeChild(box.children[box.children.length - 1])
    }

    updatePencilFunctions()
})

function updatePencilFunctions(){
    images     = [... document.getElementById('images').children]
    pencilList = [... document.getElementsByClassName('change_image')]
    userImg    = [... document.getElementsByClassName('user_image')]
    
    images.forEach((el, i) => {
        el.addEventListener('click', ()=>{
            userImg[indice_to_change].style.backgroundImage = `url(/SongGuesser/assets/avatars/${i+1}.png)`
            selectImages.style.visibility = "hidden";
        })
    })

    pencilList.forEach((el, ind) => {
        el.addEventListener('click', ()=>{
            selectImages.style.visibility = "visible"
            indice_to_change = ind
        })
    })
    
}

createRoom.addEventListener('click', ()=>{
    /*
        1.
            Coletar e validar rounds
            Coletar e validar a linguagem
            Coletar avatars
            Coletar e validar nicks

        2.
            Trocar de tela e atualizar os players lá na outra tela
    
    */
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
    console.log("Quantidade de Rounds: " + nRounds)

    // Coleta e verificao da linguagem
    let flagSelected = document.getElementsByClassName('selected')
    let language = ""
    if(flagSelected.length == 0){
        alert("Selecione uma linguagem para a sala!")
        return
    }else{
        if(flagSelected[0].classList.contains('br')){
            language = "portuguese"
        }else if(flagSelected[0].classList.contains('es')){
            language = "spanish"
        }else{              
            language = "english"
        }
    }

    console.log("Idioma: " + language)

    // ///////////////////////////////////////////
    //avatar test
    let avatarInput = [...document.getElementsByClassName('user_image')]
    let avatarIndexes = []
    avatarInput.forEach((el) => {
        let index = window.getComputedStyle(el).backgroundImage
        index = index.split('/'); // pois o backgroundImage foi definido em CSS, não inline 
        index = index[index.length - 1];  
        index = parseInt(index.split('.')[0])

        avatarIndexes.push(index)
    })
    console.log("Lista de indices dos avatars: " + avatarIndexes)
    //nick test
    let nicksInput = [...document.getElementsByClassName('player_name_input')]
    let nickNoneCounter = 0
    let nickList = []
    nicksInput.forEach((el) => {
        if(el.value != ""){
            let nickRegex = /^[a-zA-Z0-9]{1,15}$/
            if(nickRegex.test(el.value)){
                nickList.push(el.value)
            }else{
                alert(`Use just letters and numbers, or nicknames of maximum 15 characteres for the nick number ${nicksInput.indexOf(el)+1}`)
                return
            }
        }else{
            nickList.push(`Player${nickNoneCounter+1}`)
            nickNoneCounter++
        }
    })
    console.log("Lista de nicks: " + nickList)
})

updatePencilFunctions()

fetch("http://15.228.220.61:4000/api/validate", {
    method: "POST",
    headers: {
        "Content-Type": "application/json"
    },
    body: JSON.stringify({
        "word": "morte",
        "chosen": {"artist": "Billie Eilish", "song": "happier than ever"}
    })
})
.then(response => response.json())
.then(data => {
    console.log(data);
})
.catch(error => {
    console.error("Erro:", error);
});
