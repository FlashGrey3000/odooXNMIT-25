"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";

export default function SignupPage() {
  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");

  const fastAPIurl = "http://10.57.140.70:8000";
  const router = useRouter();

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    if (password !== confirmPassword) {
      alert("Passwords do not match!");
      return;
    }

    try {
      const res = await fetch(`${fastAPIurl}/signup/`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          name,
          email,
          password,
        }),
      });

      if (!res.ok) {
        const errorData = await res.json();
        console.error("Signup failed:", errorData);
        alert(`Error: ${errorData.detail || "Signup failed"}`);
        return;
      }

      const data = await res.json();
      console.log("Signup successful:", data);
      alert("Signup successful!");
      router.push("/login");
    } catch (err) {
      console.error("Network error:", err);
      alert("Could not connect to the server.");
    }
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
          Join Us Today!
        </h2>
        <p className="text-gray-600 mt-2 text-center max-w-md">
          Create an account to unlock exclusive features and stay connected.
        </p>
      </div>

      <div className="flex w-full md:w-1/2 items-center justify-center p-8 md:bg-black bg-gray-100">
        <div className="max-w-md w-full md:bg-white md:p-10 rounded-2xl">
          <h2 className="text-2xl font-bold text-gray-800 mb-6 text-center">
            Sign Up
          </h2>
          <form onSubmit={handleSubmit} className="space-y-4">
            <div>
              <label className="block text-gray-700 mb-1">Name</label>
              <input
                type="text"
                value={name}
                onChange={(e) => setName(e.target.value)}
                required
                className="w-full px-4 py-2 border rounded-lg focus:ring focus:ring-blue-300 focus:outline-none text-gray-800"
              />
            </div>
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
            <div>
              <label className="block text-gray-700 mb-1">Confirm Password</label>
              <input
                type="password"
                value={confirmPassword}
                onChange={(e) => setConfirmPassword(e.target.value)}
                required
                className="w-full px-4 py-2 border rounded-lg focus:ring focus:ring-blue-300 focus:outline-none text-gray-800"
              />
            </div>
            <button
              type="submit"
              className="w-full bg-blue-600 text-white py-2 rounded-lg hover:bg-blue-700 transition"
            >
              Sign Up
            </button>
          </form>
          <p className="text-center text-gray-600 mt-4">
            Already have an account?{" "}
            <a href="/login" className="text-blue-600 hover:underline">
              Log in
            </a>
          </p>
        </div>
      </div>
    </div>
  );
}