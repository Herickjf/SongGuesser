const Rooms = {
    currentChannel: null, // Variável para rastrear o canal atual
    socket: null, // Variável para rastrear o soquete
    eventsAdded: false, // Controle para adicionar eventos apenas uma vez
    player: null,
    game: null,
    players: null,
    guesses: null,

    getGuesses: function () {
        return this.guesses;
    },
    getPlayers: function () {
        return this.players;
    },
    getPlayer: function () {
        return this.player;
    },
    getGame: function () {
        return this.game;
    },

    joinRoom: function (roomCode, password, nickname, photoId) {

        if (this.currentChannel) {
            this.removeListeners(); // Remover ouvintes antigos
            this.currentChannel.leave(); // Garantir que o canal antigo é deixado
        }

        this.channel = this.socket.channel(`room:${roomCode}`, { password, nickname, photo_id: photoId });

        return new Promise((resolve, reject) => {
            this.channel.join()
                .receive("ok", resp => {
                    this.currentChannel = this.channel; // Atualizar canal atual para o novo
                    console.log("Joined room", resp);
                    this.player = JSON.parse(resp.player);
                    this.game = JSON.parse(resp.room);
                    this.players = JSON.parse(resp.players);
                    resolve(resp);
                })
                .receive("error", resp => {
                    console.log("Unable to join room", resp);
                    reject({ "failed": true, "message": resp });
                });
        });
    },

    init: function (socket) {
        console.log("init room");
        this.socket = socket;

        // Entrando na sala lobby
        this.currentChannel = this.socket.channel(`room:lobby`);
        this.currentChannel.join()
            .receive("ok", resp => {
                console.log("Joined lobby");
            })
            .receive("error", resp => {
                console.log("Unable to join lobby", resp);
            });
    },

    createRoom: function (roomPW, roomRounds, roomMaxPlayers, roomLanguage, nickname, photoId) {
        if (!roomPW) return alert("Password cannot be empty");
        if (!roomRounds || isNaN(roomRounds) || Number(roomRounds) <= 0) return alert("Rounds must be a valid number greater than 0");
        if (!roomMaxPlayers || isNaN(roomMaxPlayers) || Number(roomMaxPlayers) <= 0) return alert("Max players must be a valid number greater than 0");
        if (!roomLanguage) return alert("Language cannot be empty");
        if (!nickname) return alert("Nickname cannot be empty");
        if (!photoId) return alert("Photo ID cannot be empty");

        if (this.currentChannel) {
            return new Promise((resolve, reject) => {
                this.currentChannel.push("create_room", {
                    password: roomPW,
                    rounds: Number(roomRounds),
                    max_players: Number(roomMaxPlayers),
                    language: roomLanguage,
                    nickname: nickname,
                    photo_id: photoId
                })
                .receive("ok", (resp) => {
                    alert(`Room created with code: ${resp.room_code}`);
                    this.joinRoom(resp.room_code, roomPW, nickname, photoId).then(resolve).catch(reject);
                })
                .receive("error", (resp) => {
                    alert("Unable to create room");
                    reject({ "failed": true, "message": resp });
                });
            });
        }
    },

    enterRoom: function (roomCode, roomPW, nickname, photoId) {
        if (!roomCode) return alert("Room code cannot be empty");
        if (!roomPW) return alert("Password cannot be empty");
        if (!nickname) return alert("Nickname cannot be empty");
        if (!photoId) return alert("Photo ID cannot be empty");

        return this.joinRoom(roomCode, roomPW, nickname, photoId);
    },

    getOut: function () {
        if (!this.currentChannel) {
            console.log("No room to leave");
            return;
        }

        console.log("Leaving room");
        this.currentChannel.push("disconnect", {})
            .receive("ok", () => console.log("Disconnected from room"))
            .receive("error", () => console.log("Failed to disconnect from room"));

        this.removeListeners(); // Remove eventos do canal atual
        this.currentChannel.leave()
            .receive("ok", () => console.log("Left room"))
            .receive("error", () => console.log("Failed to leave room"));

        this.init(this.socket); // Reinitialize the room
    },

    sendNextRoundOrder: function () {
        if (this.currentChannel) {
            this.currentChannel.push("next_round_order", {});
        }
    },

    sendMusicSelection: function (artist, songName, music_id) {
        if (this.currentChannel) {
            this.currentChannel.push("music_selection", { artist: artist, song_name: songName, music_id: music_id });
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
            });
        }
    },

    setListenGame: function (func) {
        if (this.currentChannel) {
            console.log("Listening to game events");
            this.currentChannel.on("game", payload => {
                console.log("Received game", payload);
                this.game = JSON.parse(payload.room);
                func();
            });
        }
    },

    setListenPlayers: function (func) {
        if (this.currentChannel) {
            console.log("Listening to players events");
            this.currentChannel.on("players", payload => {
                console.log("Received players", payload);
                this.players = JSON.parse(payload.players);
                this.players.forEach((el) => {
                    if (el.id === this.player.id) {
                        this.player = el;
                    }
                });
                func();
            });
        }
    },

    setListenMusicGuesses: function (func) { // Corrigido o nome para "MusicGuesses"
        if (this.currentChannel) {
            console.log("Listening to music guesses events");
            this.currentChannel.on("guesses", payload => {
                console.log("Received music guesses", payload);
                this.guesses = JSON.parse(payload.guesses);
                func();
            });
        }
    },

    removeListeners: function () {
        if (this.currentChannel) {
            this.currentChannel.off("shout");
            this.currentChannel.off("game");
            this.currentChannel.off("players");
            this.currentChannel.off("guesses");
        }
    },

    testlog: function () {
        console.log("Test log");
        console.log(this.currentChannel);
    },
};

export default Rooms;
