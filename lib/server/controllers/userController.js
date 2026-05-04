import User from "../models/userModel.js";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";

// 🔹 Тіркелу
export const registerUser = async (req, res) => {
  try {
    const { name, email, password, role } = req.body;

    if (typeof name !== 'string' || typeof email !== 'string' || typeof password !== 'string') {
      return res.status(400).json({ message: "Invalid input types" });
    }

    const existingUser = await User.findOne({ email });
    if (existingUser) return res.status(400).json({ message: "Email already exists" });

    const hashedPassword = await bcrypt.hash(password, 10);

    const newUser = await User.create({ name, email, password: hashedPassword, role: role || 'student' });

    res.status(201).json({ message: "User registered successfully", user: newUser });
  } catch (error) {
    res.status(500).json({ message: "Server error", error });
  }
};

// 🔹 Кіру
export const loginUser = async (req, res) => {
  try {
    const { email, password } = req.body;

    if (typeof email !== 'string' || typeof password !== 'string') {
      return res.status(400).json({ message: "Invalid input types" });
    }

    const user = await User.findOne({ email });
    if (!user) return res.status(404).json({ message: "User not found" });

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) return res.status(400).json({ message: "Invalid password" });

    const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET, { expiresIn: "7d" });

    res.status(200).json({ message: "Login successful", token, user });
  } catch (error) {
    res.status(500).json({ message: "Server error", error });
  }
};

// 🔹 Get User Profile
export const getMe = async (req, res) => {
  try {
    const user = await User.findById(req.user.id).select("-password");
    if (user) {
      res.json(user);
    } else {
      res.status(404).json({ message: "User not found" });
    }
  } catch (error) {
    res.status(500).json({ message: "Server error", error });
  }
};

// 🔹 Update Stats
export const updateStats = async (req, res) => {
  try {
    let { answeredQuestions, gamesPlayed } = req.body;
    const user = await User.findById(req.user.id);

    if (user) {
      // Validate inputs to prevent cheating
      answeredQuestions = Number(answeredQuestions) || 0;
      gamesPlayed = Number(gamesPlayed) || 0;

      if (answeredQuestions < 0 || gamesPlayed < 0) {
        return res.status(400).json({ message: "Invalid stats" });
      }

      // Cap maximum values per request
      const validQuestions = Math.min(answeredQuestions, 50);
      const validGames = Math.min(gamesPlayed, 5);

      if (validQuestions > 0) user.answeredQuestions += validQuestions;
      if (validGames > 0) user.gamesPlayed += validGames;

      // Calculate points
      if (validQuestions > 0) user.points += (validQuestions * 2);
      if (validGames > 0) user.points += (validGames * 10);

      const updatedUser = await user.save();
      res.json(updatedUser);
    } else {
      res.status(404).json({ message: "User not found" });
    }
  } catch (error) {
    res.status(500).json({ message: "Server error", error });
  }
};

// 🔹 Get Leaderboard
export const getLeaderboard = async (req, res) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const skip = (page - 1) * limit;

    const users = await User.find()
      .sort({ points: -1 })
      .skip(skip)
      .limit(limit)
      .select("-password -email");

    res.json(users);
  } catch (error) {
    res.status(500).json({ message: "Server error", error });
  }
};
