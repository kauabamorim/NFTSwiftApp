import { error } from "console";
import { Request, Response } from "express";
import jwt from "jsonwebtoken";
import { jwtSecret } from "../config/authConfig";
import { PrismaClient, User } from "@prisma/client";

const prisma = new PrismaClient();

async function signUp(req: Request, res: Response) {
  const { email, password, name, lastName, username } = req.body as User;

  if (!email || !password || !name || !lastName || !username) {
    throw error;
  }

  try {
    const existingUser = await prisma.user.findUnique({
      where: {
        email: email,
      },
    });

    if (existingUser) {
      return res.status(409).json({ message: "Email already exists" });
    }

    const existingUsername = await prisma.user.findUnique({
      where: {
        username: username,
      },
    });

    if (existingUsername) {
      return res.status(409).json({ message: "Username already exists" });
    }

    const user = await prisma.user.create({
      data: {
        email: email,
        password: password,
        name: name,
        lastName: lastName,
        username: username,
      },
    });

    const token = jwt.sign({ userId: user.id }, jwtSecret, {
      expiresIn: "1h",
    });

    return res.status(200).json({ token });
  } catch (error) {
    console.log("Signup Error: ", error);
    res.status(500).json({ message: "Signup failed" });
  }
}

async function login(req: Request, res: Response) {
  const { email, password } = req.body as User;

  if (!email || !password) {
    throw error;
  }

  try {
    const existingUser = await prisma.user.findUnique({
      where: {
        email: email,
      },
    });

    if (!existingUser) {
      return res.status(401).json({ message: "Invalid credentials" });
    }

    if (existingUser.password !== password) {
      return res.status(401).json({ message: "Incorrect password" });
    }

    const token = jwt.sign({ userId: existingUser.id }, jwtSecret, {
      expiresIn: "1h",
    });

    return res.status(200).json({ token });
  } catch (error) {
    console.log("Login Error: ", error);
    res.status(500).json({ message: "Login failed" });
  }
}


async function searchAllUsers(req: Request, res: Response) {
  try {
    const allUsers = await prisma.user.findMany();

    return res.status(200).json({ allUsers });
  } catch (error) {
    
  }
}

export { signUp, login, searchAllUsers };
