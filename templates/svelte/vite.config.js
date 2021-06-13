import { defineConfig } from "vite";
import coffee from "vite-plugin-coffee";
import { svelte } from "@sveltejs/vite-plugin-svelte";
import { coffeescript } from "svelte-preprocess";

export default defineConfig({
  plugins: [
    coffee({
      jsx: false,
    }),
    svelte({
      preprocess: [coffeescript()],
    }),
  ],
});
