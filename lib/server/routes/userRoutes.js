import express from "express";
import { registerUser, loginUser, getMe, updateStats, getLeaderboard } from "../controllers/userController.js";
import { protect } from "../middleware/authMiddleware.js";

const router = express.Router();

router.post("/register", registerUser);
router.post("/login", loginUser);

router.get("/me", protect, getMe);
router.post("/update-stats", protect, updateStats);
router.get("/leaderboard", protect, getLeaderboard);

export default router;


