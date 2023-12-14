import { Router } from "express";
import { login, searchAllUsers, signUp } from "../controllers/userController";
import { verifyToken } from "../middlewares/verifyToken";

const router = Router();

router.post("/register", signUp);
router.post("/login", login);

router.get("/allUsers", searchAllUsers);

export default router;
