let Rooms = {
    init(socket) {
        // Substituir o "lobby" por uma sala específica ao entrar
        let roomCode = document.getElementById("room-code").value || "lobby";
        let channel = socket.channel(`room:${roomCode}`, {password: document.getElementById("room-password").value})

        channel.join()
            .receive("ok", resp => { console.log("Joined successfully", resp) })
            .receive("error", resp => { console.log("Unable to join", resp) })

        listenForRoom(channel)

        document.getElementById("btn-create-room").addEventListener("click", function() {
            let roomPW = document.getElementById("room-password").value
            let roomRounds = document.getElementById("room-rounds").value
            let roomMaxPlayers = document.getElementById("room-max-players").value
            let roomLanguage = document.getElementById("room-language").value

            
            channel.push("create_room", {
                password: roomPW,
                rounds: roomRounds,
                max_players: roomMaxPlayers,
                language: roomLanguage
            }).receive("ok", (resp) => {
                
                alert(`Room created with code: ${resp.room_code}`)
            })
        })

        document.getElementById("btn-join-room").addEventListener("click", function() {
            let roomCode = document.getElementById("room-code").value;
            let roomPW = document.getElementById("join-room-password").value;
            let nickname = document.getElementById("nickname").value;
            let photoId = document.getElementById("photo-id").value;
      
            let channel = socket.channel(`room:${roomCode}`, {password: roomPW, nickname: nickname, photo_id: photoId});
      
            channel.join()
              .receive("ok", resp => { console.log("Joined room successfully", resp) })
              .receive("error", resp => { console.log("Unable to join", resp) });
          });
    }
}

function listenForRoom(channel) {

    document.getElementById("btn-send-msg").addEventListener("click", function(e) {
        console.log("clicked")

        let msg = document.getElementById("chat-input").value
        channel.push("shout", {body: msg})
        document.getElementById("chat-input").value = ""
    })

    channel.on("shout", payload => {
        let chatContainer = document.getElementById("chat-box")
        chatContainer.innerText += `${payload.body}\n`
    })
}

export default Rooms