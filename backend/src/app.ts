import express, { json } from "express";
import path from "path";
import routes from "./routes/routes";
import cors from "cors";

const app = express();

const port = process.env.PORT || 3002;

app.use(cors());
app.use(json());

app.use(routes);
app.use(express.static(path.join(__dirname, "public")));

app.listen(port, () => {
  console.log(`Porta: ${port}`);
});
