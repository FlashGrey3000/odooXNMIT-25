"use client";

import { useState } from "react";

export default function LoginPage() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    console.log("Login attempt:", { email, password });
  };

  return (
    <div className="flex min-h-screen">
      <div className="hidden md:flex w-1/2 bg-gray-100 items-center justify-center flex-col p-10">
        <img
          src="/synergy_sphere_logo.png"
          alt="Illustration"
          className="w-2/3 mb-6"
        />
        <h2 className="text-3xl font-bold text-gray-800 text-center">
          Welcome Back!
        </h2>
        <p className="text-gray-600 mt-2 text-center max-w-md">
          Sign in to continue exploring amazing features and stay connected.
        </p>
      </div>

      <div className="flex w-full md:w-1/2 items-center justify-center p-8 md:bg-black bg-gray-100">
        <div className="max-w-md w-full md:bg-white md:p-10 rounded-2xl">
          <h2 className="text-2xl font-bold text-gray-800 mb-6 text-center">
            Login
          </h2>
          <form onSubmit={handleSubmit} className="space-y-4">
            <div>
              <label className="block text-gray-700 mb-1">Email</label>
              <input
                type="email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                required
                className="w-full px-4 py-2 border rounded-lg focus:ring focus:ring-blue-300 focus:outline-none text-gray-800"
              />
            </div>
            <div>
              <label className="block text-gray-700 mb-1">Password</label>
              <input
                type="password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                required
                className="w-full px-4 py-2 border rounded-lg focus:ring focus:ring-blue-300 focus:outline-none text-gray-800"
              />
            </div>
            <button
              type="submit"
              className="w-full bg-blue-600 text-white py-2 rounded-lg hover:bg-blue-700 transition"
            >
              Sign In
            </button>
          </form>
          <p className="text-center text-gray-600 mt-4">
            Don’t have an account?{" "}
            <a href="/signup" className="text-blue-600 hover:underline">
              Sign up
            </a>
          </p>
        </div>
      </div>
    </div>
  );
}