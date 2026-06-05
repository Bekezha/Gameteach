// socketManager.js
const setupSocket = (io) => {
    let waitingPlayer = null;

    io.on("connection", (socket) => {
        console.log(`👤 New connection: ${socket.id}`);

        socket.on("join_duel", (userData) => {
            console.log(`🔍 Player searching for duel: ${userData.name}`);

            if (waitingPlayer) {
                // Match found!
                const opponent = waitingPlayer;
                waitingPlayer = null;

                const roomId = `${opponent.socketId}#${socket.id}`;

                // Join both to a private room
                socket.join(roomId);
                // We need to tell the other player too. 
                // But the other player might not be in a room yet.
                // We'll emit to their specific socket ID.

                const gameData = {
                    roomId,
                    opponent: { name: userData.name, id: userData.id },
                    questions: [
                        { q: "HTML-де гиперсілтеме жасау үшін қандай тег қолданылады?", a: ["<a>", "<div>", "<img>", "<p>"], c: "<a>" },
                        { q: "CSS-те мәтін түсін қалай өзгертеміз?", a: ["color", "font-weight", "background", "border"], c: "color" },
                        { q: "JavaScript-те айнымалыны қалай жариялаймыз?", a: ["var", "string", "int", "float"], c: "var" },
                        { q: "Python-да тізімді жариялау белгісі?", a: ["[]", "{}", "()", "<>"], c: "[]" },
                        { q: "Flutter қай бағдарламалау тіліне негізделген?", a: ["Dart", "Java", "Swift", "C#"], c: "Dart" },
                    ]
                };

                const opponentGameData = {
                    roomId,
                    opponent: { name: opponent.name, id: opponent.id },
                    questions: gameData.questions
                };

                io.to(socket.id).emit("match_found", gameData);
                io.to(opponent.socketId).emit("match_found", opponentGameData);

                console.log(`🤝 Match started in room ${roomId}`);
            } else {
                waitingPlayer = {
                    socketId: socket.id,
                    name: userData.name,
                    id: userData.id
                };
                console.log(`⏳ Player waiting: ${userData.name}`);
            }
        });

        socket.on("answer_question", (data) => {
            // data: { roomId, score, questionIndex }
            socket.to(data.roomId).emit("opponent_update", {
                score: data.score,
                questionIndex: data.questionIndex
            });
        });

        socket.on("game_over", (data) => {
            socket.to(data.roomId).emit("duel_finished", {
                finalScore: data.score
            });
        });

        socket.on("disconnect", () => {
            console.log(`🔌 Disconnected: ${socket.id}`);
            if (waitingPlayer && waitingPlayer.socketId === socket.id) {
                waitingPlayer = null;
            }
        });
    });
};

export default setupSocket;
