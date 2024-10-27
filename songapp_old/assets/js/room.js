// const Rooms = {

//     currentChannel: null, // Variável para rastrear o canal atual
//     socket: null, // Variável para rastrear o soquete
//     eventsAdded: false, // Controle para adicionar eventos apenas uma vez

//     joinRoom: function (roomCode, password, nickname, photoId) {
//         console.log("Joining room: ", this.currentChannel, this.socket);
//         if (this.currentChannel) {
//             this.removeListeners(); // Remove eventos do canal atual
//             this.currentChannel.leave()
//                 .receive("ok", () => console.log(`Left room: ${roomCode}`))
//                 .receive("error", () => console.log(`Failed to leave room: ${roomCode}`));
//         }

//         // Criar um novo canal para o roomCode fornecido
//         const channel = this.socket.channel(`room:${roomCode}`, { password: password, nickname: nickname, photo_id: photoId });

//         channel.join()
//             .receive("ok", resp => {
//                 console.log("Joined room successfully", resp);
//                 this.currentChannel = channel; // Atualizar o canal atual para o novo
//                 this.listenEvents(); // Adiciona eventos do canal atual

//                 console.log("current Channel", this.currentChannel);
//             })
//             .receive("error", resp => { console.log("Unable to join room", resp) });
//     },

//     init: function (socket) {
//         console.log("rommmmmmmmmmmmmmm");
//         this.socket = socket;
//         this.joinRoom("lobby", document.getElementById("room-password").value, document.getElementById("nickname").value, document.getElementById("photo-id").value);

//         if (!this.eventsAdded) {
//             this.addEventsInputs();
//             this.eventsAdded = true; // Marcar como eventos adicionados
//         }
//     },

//     addEventsInputs: function () {
//         document.getElementById("btn-create-room").addEventListener("click", () => {
//             const roomPW = document.getElementById("room-password").value;
//             const roomRounds = document.getElementById("room-rounds").value;
//             const roomMaxPlayers = document.getElementById("room-max-players").value;
//             const roomLanguage = document.getElementById("room-language").value;
//             const nickname = document.getElementById("nickname").value;
//             const photoId = document.getElementById("photo-id").value;

//             // const data = createRoom()

//             // {
//             //     room_password: string;
//             //     room_rounds: number;
//             //     room_max_players: number;
//             //     room_language: string;
//             //     nickname: string;
//             //     photo_id: number;
//             // }

//             console.log("Creating room", roomPW, roomRounds, roomMaxPlayers, roomLanguage, nickname, photoId);

//             if (this.currentChannel) {
//                 this.currentChannel.push("create_room", {
//                     password: roomPW,
//                     rounds: Number(roomRounds),
//                     max_players: Number(roomMaxPlayers),
//                     language: roomLanguage,
//                     nickname: nickname,
//                     photo_id: photoId
//                 }).receive("ok", (resp) => {
//                     alert(`Room created with code: ${resp.room_code}`,
//                     );
//                     this.joinRoom(resp.room_code, roomPW, nickname, photoId);

//                     // # Esconder a seção de criação de sala e mostrar a seção de chat


//                 }).receive("error", (resp) => alert("Unable to create room"));
//             }
//         });

//         // Entrar em uma sala existente
//         document.getElementById("btn-join-room").addEventListener("click", () => {
//             const roomCode = document.getElementById("room-code").value;
//             const roomPW = document.getElementById("join-room-password").value;
//             const nickname = document.getElementById("nickname").value;
//             const photoId = document.getElementById("photo-id").value;

//             // const data = luisvaimedar()

//             // {
//             //     room_code: string
//             //     room_password: string
//             //     photo_id: number
//             //     nickname: string
//             // }

//             this.joinRoom(roomCode, roomPW, nickname, photoId);
//         });

//         document.getElementById("btn-send-msg").addEventListener("click", (e) => {
//             console.log("clicked");
//             const msg = document.getElementById("chat-input").value;
//             if (this.currentChannel) {
//                 this.currentChannel.push("shout", { body: msg });
//                 document.getElementById("chat-input").value = "";
//             }
//         });
//     },

//     listenEvents: function () {

//         if (this.currentChannel) {
//             console.log("Listening to shout events");
//             this.currentChannel.on("shout", payload => {
//                 console.log("Received message", payload);
//                 const chatContainer = document.getElementById("chat-box");
//                 chatContainer.innerText += `${payload.nickname}: ${payload.body}\n`;
//             });
//         }


//     },

//     removeListeners: function () {
//         if (this.currentChannel) {
//             this.currentChannel.off("shout"); // Remove listeners do canal
//         }
//     }
// };

// export default Rooms;