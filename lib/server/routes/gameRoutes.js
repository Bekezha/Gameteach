import express from "express";
import { createGame, getAllGames } from "../controllers/gameController.js";
import { protect } from "../middleware/authMiddleware.js";

const router = express.Router();

router.route("/").post(protect, createGame).get(protect, getAllGames);

export default router;
