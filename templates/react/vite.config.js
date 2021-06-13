import { defineConfig } from "vite";
import coffee from "vite-plugin-coffee";
import reactRefresh from "@vitejs/plugin-react-refresh";

export default defineConfig({
  plugins: [
    coffee({
      jsx: true,
    }),
    reactRefresh(),
  ],
});
