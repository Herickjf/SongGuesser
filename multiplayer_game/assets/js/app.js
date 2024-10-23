import {Socket} from "phoenix"

let socket = new Socket("/ws/socket", {params: {token: "player"}})
socket.connect()

// Cria um canal "room:lobby"
let channel = socket.channel("room:lobby", {})

// Exemplo de envio de evento para criar sala
document.getElementById("create_room_btn").addEventListener("click", () => {
  let roomName = prompt("Digite o nome da sala:")
  channel.push("create_room", {room_name: roomName})
})

// Recebe o evento de sala criada
channel.on("room_created", payload => {
  alert(`Sala ${payload.room_name} criada com sucesso!`)
})

// Exemplo de envio de evento para entrar na sala
document.getElementById("join_room_btn").addEventListener("click", () => {
  let roomName = prompt("Digite o nome da sala para entrar:")
  channel.push("join_room", {room_name: roomName})
})

// Recebe o evento de entrada na sala
channel.on("joined_room", payload => {
  alert(`Você entrou na sala ${payload.room_name}!`)
})
