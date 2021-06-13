# vite-plugin-coffee

Coffeescript plugin for Vitejs

Made for [create-coffee-app](https://www.npmjs.com/package/create-coffee-app)

## Usage

```js
// vite.config.js
import { defineConfig } from "vite";
import coffee from "vite-plugin-coffee";

export default defineConfig({
  plugins: [
    coffee({
      // Set to true if you use react
      jsx: false,
    }),
  ],
});
```
