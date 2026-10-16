import { resolve } from "node:path";
import { defineConfig } from "vite";

const frontend = import.meta.dirname;

export default defineConfig({
  publicDir: false,
  build: {
    outDir: resolve(frontend, "../app/static/dist"),
    emptyOutDir: false,
    rollupOptions: {
      input: resolve(frontend, "src/brand-list-entry.tsx"),
      output: {
        format: "iife",
        entryFileNames: "brand-list.js",
      },
    },
  },
});
