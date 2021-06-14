const vite = require("vite-web-test-runner-plugin");
import { playwrightLauncher } from "@web/test-runner-playwright";

module.exports = {
  plugins: [vite()],
  browsers: [playwrightLauncher({ product: "firefox" })],
};
