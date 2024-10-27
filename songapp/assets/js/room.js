const Rooms = {

    currentChannel: null, // Variável para rastrear o canal atual
    socket: null, // Variável para rastrear o soquete
    eventsAdded: false, // Controle para adicionar eventos apenas uma vez

    joinRoom: function (roomCode, password, nickname, photoId) {
        console.log("Joining room: ", this.currentChannel, this.socket);
        if (this.currentChannel) {
            this.removeListeners(); // Remove eventos do canal atual
            this.currentChannel.leave()
                .receive("ok", () => console.log(`Left room: ${roomCode}`))
                .receive("error", () => console.log(`Failed to leave room: ${roomCode}`));
        }

        // Criar um novo canal para o roomCode fornecido
        const channel = this.socket.channel(`room:${roomCode}`, { password: password, nickname: nickname, photo_id: photoId });

        channel.join()
            .receive("ok", resp => {
                console.log("Joined room successfully", resp);
                this.currentChannel = channel; // Atualizar o canal atual para o novo
                this.listenEvents(); // Adiciona eventos do canal atual

                console.log("current Channel", this.currentChannel);
            })
            .receive("error", resp => { console.log("Unable to join room", resp) });
    },

    init: function (socket) {


        console.log("init room");
        this.socket = socket;
        this.joinRoom("lobby", '', '', '');

    },

    createRoom: function (roomPW, roomRounds, roomMaxPlayers, roomLanguage, nickname, photoId) {

        if (!roomPW) {
            alert("Password cannot be empty");
            return;
        }
        if (!roomRounds || isNaN(roomRounds) || Number(roomRounds) <= 0) {
            alert("Rounds must be a valid number greater than 0");
            return;
        }
        if (!roomMaxPlayers || isNaN(roomMaxPlayers) || Number(roomMaxPlayers) <= 0) {
            alert("Max players must be a valid number greater than 0");
            return;
        }
        if (!roomLanguage) {
            alert("Language cannot be empty");
            return;
        }
        if (!nickname) {
            alert("Nickname cannot be empty");
            return;
        }
        if (!photoId) {
            alert("Photo ID cannot be empty");
            return;
        }

        console.log("Creating room", roomPW, roomRounds, roomMaxPlayers, roomLanguage, nickname, photoId);

        if (this.currentChannel) {
            this.currentChannel.push("create_room", {
                password: roomPW,
                rounds: Number(roomRounds),
                max_players: Number(roomMaxPlayers),
                language: roomLanguage,
                nickname: nickname,
                photo_id: photoId
            }).receive("ok", (resp) => {
                alert(`Room created with code: ${resp.room_code}`,
                );
                this.joinRoom(resp.room_code, roomPW, nickname, photoId);

                // # Esconder a seção de criação de sala e mostrar a seção de chat


            }).receive("error", (resp) => alert("Unable to create room"));
        }

    },

    enterRoom: function (roomCode, roomPW, nickname, photoId) {

        if (!roomCode) {
            alert("Room code cannot be empty");
            return;
        }
        if (!roomPW) {
            alert("Password cannot be empty");
            return;
        }
        if (!nickname) {
            alert("Nickname cannot be empty");
            return;
        }
        if (!photoId) {
            alert("Photo ID cannot be empty");
            return;
        }

        this.joinRoom(roomCode, roomPW, nickname, photoId);



    },

    sendMessage: function (message) {

        if (this.currentChannel) {
            this.currentChannel.push("shout", { body: msg });
            document.getElementById("chat-input").value = "";
        }
    },


    listenEvents: function () {

        if (this.currentChannel) {
            console.log("Listening to shout events");
            this.currentChannel.on("shout", payload => {
                console.log("Received message", payload);
                const chatContainer = document.getElementById("chat-box");
                chatContainer.innerText += `${payload.nickname}: ${payload.body}\n`;
            });
        }

    },

    removeListeners: function () {
        if (this.currentChannel) {
            this.currentChannel.off("shout"); // Remove listeners do canal
        }
    }
};

export default Rooms;