import { defineConfig } from "vite";
import react from "@vitejs/plugin-react-swc";

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react()],
  server: {
    proxy: {
      "/api": {
        target: process.env.VITE_API_PATH || "http://65.0.85.33:4000", // Update to your EC2 backend
        changeOrigin: true,
        rewrite: (path) => path.replace(/^\/api/, ""), // This ensures /api is not passed to the backend
      },
    },
  },
});
