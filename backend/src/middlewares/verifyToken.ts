import { NextFunction, Request, Response } from "express";

import jwt from "jsonwebtoken";

import { jwtSecret } from "../config/authConfig";

export async function verifyToken(
  req: Request,
  res: Response,
  next: NextFunction
) {
  try {
    const tokenString = req.headers.authorization;

    if (!tokenString)
      return res.status(400).json({ error: "Token Not Provided" });

    const [type, token] = tokenString.split(" ");

    if (!type || type !== "Bearer")
      return res.status(401).json({ erro: "Token Type errado" });

    if (!token) return res.status(401).json({ erro: "Token Invalido" });

    jwt.verify(token, jwtSecret, async (error, decoded) => {
      if (error) return res.status(401).json({ erro: "Token Expirado" });
      req.body.tokenInfo = decoded;
      return next();
    });
    return false;
  } catch (error) {
    console.log(error);
    res.status(401).json({ erro: "Ocorreu um erro ao validar o token" });
    return false;
  }
}
