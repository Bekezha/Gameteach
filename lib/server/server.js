import http from "http";
import { Server } from "socket.io";
import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import connectDB from "./config/db.js";
import userRoutes from "./routes/userRoutes.js";
import gameRoutes from "./routes/gameRoutes.js";
import setupSocket from "./socketManager.js";

dotenv.config();
connectDB();

const app = express();
app.use(cors());
app.use(express.json());

app.get("/health", (_req, res) => {
  res.status(200).json({ ok: true });
});

// Роуттар
app.use("/api/users", userRoutes);
app.use("/api/games", gameRoutes);

const PORT = process.env.PORT || 5000;

const server = http.createServer(app);
const io = new Server(server, {
  cors: {
    origin: "*",
    methods: ["GET", "POST"]
  }
});

setupSocket(io);

server.listen(PORT, () => console.log(`🚀 Server running on port ${PORT}`));
