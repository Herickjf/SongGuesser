
export default function aboutLive() {
    console.log("roomtest.js loaded");
}

document.getElementById("btn-create-room").addEventListener("click", () => {
    const roomPW = document.getElementById("room-password").value;
    const roomRounds = document.getElementById("room-max-rounds").value;
    const roomMaxPlayers = document.getElementById("room-max-players").value;
    const roomLanguage = document.getElementById("room-language").value;
    const nickname = document.getElementById("nickname-input").value;
    const photoId = document.getElementById("photo-id-input").value;

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
});

// Entrar em uma sala existente
document.getElementById("btn-join-room").addEventListener("click", () => {
    const roomCode = document.getElementById("room-code").value;
    const roomPW = document.getElementById("join-room-password").value;
    const nickname = document.getElementById("nickname-input").value;
    const photoId = document.getElementById("photo-id-input").value;

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
});

document.getElementById("btn-send-msg").addEventListener("click", (e) => {
    console.log("clicked");
    const msg = document.getElementById("chat-input").value;
    if (this.currentChannel) {
        this.currentChannel.push("shout", { body: msg });
        document.getElementById("chat-input").value = "";
    }
});