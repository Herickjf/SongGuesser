let Rooms = {
    currentChannel: null, // Variável para rastrear o canal atual
    init(socket) {
        // Função para entrar em uma sala específica
        const joinRoom = (roomCode, password, nickname, photoId) => {
            // Se já existe um canal ativo, deixe-o antes de entrar no novo
            if (this.currentChannel) {
                this.currentChannel.leave()
                    .receive("ok", () => console.log(`Left room: ${roomCode}`))
                    .receive("error", () => console.log(`Failed to leave room: ${roomCode}`));
            }

            // Criar um novo canal para o roomCode fornecido
            let channel = socket.channel(`room:${roomCode}`, { password: password, nickname: nickname, photo_id: photoId });

            channel.join()
                .receive("ok", resp => { 
                    console.log("Joined room successfully", resp); 
                    this.currentChannel = channel; // Atualizar o canal atual para o novo
                })
                .receive("error", resp => { console.log("Unable to join room", resp) });

            listenForRoom(channel);
        };

        // Criação de sala
        document.getElementById("btn-create-room").addEventListener("click", function () {
            let roomPW = document.getElementById("room-password").value;
            let roomRounds = document.getElementById("room-rounds").value;
            let roomMaxPlayers = document.getElementById("room-max-players").value;
            let roomLanguage = document.getElementById("room-language").value;

            if (Rooms.currentChannel) {
                Rooms.currentChannel.push("create_room", {
                    password: roomPW,
                    rounds: Number(roomRounds),
                    max_players: Number(roomMaxPlayers),
                    language: roomLanguage
                }).receive("ok", (resp) => {
                    alert(`Room created with code: ${resp.room_code}`);
                    joinRoom(resp.room_code, roomPW, document.getElementById("nickname").value, document.getElementById("photo-id").value);
                }).receive("error", (resp) => alert("Unable to create room"));
            }
        });

        // Entrar em uma sala existente
        document.getElementById("btn-join-room").addEventListener("click", function () {
            let roomCode = document.getElementById("room-code").value;
            let roomPW = document.getElementById("join-room-password").value;
            let nickname = document.getElementById("nickname").value;
            let photoId = document.getElementById("photo-id").value;

            joinRoom(roomCode, roomPW, nickname, photoId);
        });
    }
};

function listenForRoom(channel) {
    // Escutar o envio de mensagens (shout)
    document.getElementById("btn-send-msg").addEventListener("click", function (e) {
        console.log("clicked");
        let msg = document.getElementById("chat-input").value;
        channel.push("shout", { body: msg, room_code: channel.topic.split(":")[1] });
        document.getElementById("chat-input").value = "";
    });

    // Receber as mensagens enviadas pela sala
    channel.on("shout", payload => {
        let chatContainer = document.getElementById("chat-box");
        chatContainer.innerText += `${payload.body}\n`;
    });
}

export default Rooms;
