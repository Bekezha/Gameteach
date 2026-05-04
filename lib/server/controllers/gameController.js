import Game from "../models/gameModel.js";

// @desc    Create a new game
// @route   POST /api/games
// @access  Private
export const createGame = async (req, res) => {
    try {
        const { title, questions } = req.body;

        if (!title || !questions || questions.length === 0) {
            return res.status(400).json({ message: "Неправильные данные для игры." });
        }

        const game = await Game.create({
            title,
            authorId: req.user._id, // Set by authMiddleware
            questions,
        });

        res.status(201).json(game);
    } catch (error) {
        res.status(500).json({ message: "Ошибка сервера при создании игры", error: error.message });
    }
};

// @desc    Get all games
// @route   GET /api/games
// @access  Public (or Private depending on needs)
export const getAllGames = async (req, res) => {
    try {
        const games = await Game.find({}).populate("authorId", "name email");
        res.status(200).json(games);
    } catch (error) {
        res.status(500).json({ message: "Ошибка сервера при получении игр", error: error.message });
    }
};
