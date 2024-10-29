const Rooms = {

    currentChannel: null, // Variável para rastrear o canal atual
    socket: null, // Variável para rastrear o soquete
    eventsAdded: false, // Controle para adicionar eventos apenas uma vez
    player: null, 
    game: null,
    players: null,
    guesses: null,

    getPlayers: function () {
        return this.players;
    },
    getPlayer: function () {
        return this.player;
    },
    getGame: function () {
        return this.game;
    },

    joinRoom: async function (roomCode, password, nickname, photoId) {
        console.log("Joining room: ", this.currentChannel, this.socket);
    
        // Create a new channel for the provided roomCode
        const channel = this.socket.channel(`room:${roomCode}`, { password, nickname, photo_id: photoId });
    
        return new Promise((resolve, reject) => {
            channel.join()
                .receive("ok", resp => {
                    this.currentChannel = channel; // Update the current channel to the new one
                    console.log("Joined room", resp);
                    this.player = JSON.parse(resp.player)
                    this.game = JSON.parse(resp.room)
                    this.players = JSON.parse(resp.players)
                    resolve(resp); // Resolve with the response data on success
                })
                .receive("error", resp => {
                    console.log("Unable to join room", resp);
                    reject({ "failed": true, "message": resp }); // Reject with an error object on failure
                });
        });
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

        // console.log("Creating room", roomPW, roomRounds, roomMaxPlayers, roomLanguage, nickname, photoId);

        if (this.currentChannel) {
            this.currentChannel.push("create_room", {
                password: roomPW,
                rounds: Number(roomRounds),
                max_players: Number(roomMaxPlayers),
                language: roomLanguage,
                nickname: nickname,
                photo_id: photoId
            }).receive("ok", (resp) => {
                alert(`Room created with code: ${resp.room_code}`);
                this.joinRoom(resp.room_code, roomPW, nickname, photoId);

                return {"failed": false, "roomCode":resp.room_code}
                this.player = JSON.parse(resp.player)
                this.game = JSON.parse(resp.room)
                this.players = JSON.parse(resp.players)


                }).receive("error", (resp) => {
                    alert("Unable to create room")
                    return {"failed": true, "message": resp}
                });
        }
 
        console.log("Pos tentativa de criar sala");
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
        // returna ok ou error retorn {:ok, socket: {object} } ou {:error, reason: "error pra dar alert"}


    },

    getOut: function () {

        if (this.currentChannel) {
            this.removeListeners(); // Remove eventos do canal atual
            this.currentChannel.leave()
                .receive("ok", () => console.log(`Left room: ${roomCode}`))
                .receive("error", () => console.log(`Failed to leave room: ${roomCode}`));
        }
        this.joinRoom("lobby", '', '', '');
    },

    sendNextRoundOrder: function () {
        // envia ordem para o servidor para iniciar a próxima rodada, se o jogador for o líder
        if (this.currentChannel) {
            this.currentChannel.push("next_round_order", {});
        }
    },

    sendMusicSelection: function (musicId) {
        if (this.currentChannel) {
            this.currentChannel.push("music_selection", { id: musicId });
        }
    },

    sendMessage: function (message) {

        if (this.currentChannel) {
            this.currentChannel.push("shout", { body: message });
        }
    },


    setListenShout: function (func) {

        if (this.currentChannel) {
            this.currentChannel.on("shout", payload => {

                console.log("Received message", payload);
                func(payload);

                // mensagem de alguem da sala 
                // payload = {body: "message", nickname: "nickname"}
            });
        }

    },

    setListenGame: function (func) {
        if (this.currentChannel) {
            console.log("Listening to game events");
            this.currentChannel.on("game", payload => {

                console.log("Received game", payload);
                func(payload);

                // estado atualizado do jogo 
            });
        }
    },

    setListenPlayers: function (func) {
        if (this.currentChannel) {
            console.log("Listening to players events");
            this.currentChannel.on("players", payload => {

                console.log("Received players", payload);
                func(payload);
                // lista de playes na sala
            });
        }
    },

    setListenMusicQuesses: function (func) {

        if (this.currentChannel) {
            console.log("Listening to music quesses events");
            this.currentChannel.on("guesses", payload => {

                console.log("Received music quesses", payload);
                func(payload);

                // recebe o palpite de music dos outros jogadores,
                // em uma lista de musicas

            });
        }
    },

    removeListeners: function () {
        if (this.currentChannel) {
            this.currentChannel.off("shout");
            this.currentChannel.off("game");
            this.currentChannel.off("players");
            this.currentChannel.off("quesses");
        }
    },

    testlog: function () {
        console.log("Test log");
        console.log(this.currentChannel);
    },
};

export default Rooms;