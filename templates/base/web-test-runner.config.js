const vite = require("vite-web-test-runner-plugin");
const { playwrightLauncher } = require("@web/test-runner-playwright");

module.exports = {
  plugins: [vite()],
  browsers: [playwrightLauncher({ product: "firefox" })],
};
