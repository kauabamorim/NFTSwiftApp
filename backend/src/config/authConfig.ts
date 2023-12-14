import dotenv from "dotenv";
dotenv.config();

const jwtSecret = process.env.AUTH_SECRET_API as string;

export { jwtSecret };