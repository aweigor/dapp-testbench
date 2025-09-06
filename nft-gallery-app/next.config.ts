import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  env: {
    API_KEY: process.env.NEXT_PUBLIC_API_KEY,
  },
};

export default nextConfig;
