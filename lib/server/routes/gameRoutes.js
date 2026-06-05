import express from "express";
import { createGame, getAllGames, getMyGames } from "../controllers/gameController.js";
import { protect } from "../middleware/authMiddleware.js";

const router = express.Router();

router.route("/").post(protect, createGame).get(protect, getAllGames);
router.route("/my-games").get(protect, getMyGames);

export default router;
