"use client";

import { useState } from "react";
import { Switch } from "@headlessui/react"; // headless toggle switch
import { PowerIcon } from "@heroicons/react/24/outline";

export default function ProfilePage() {
  // Example states (replace with real user data)
  const user = {
    name: "John Doe",
    email: "john.doe@example.com",
  };

  const [notificationsEnabled, setNotificationsEnabled] = useState(true);
  const [darkModeEnabled, setDarkModeEnabled] = useState(false);

  return (
    <div className="max-w-2xl mx-auto p-6">
      <h1 className="text-2xl font-bold text-gray-800 mb-6">Profile & Settings</h1>

      <div className="bg-white shadow rounded-2xl p-6 mb-6">
        <h2 className="text-lg font-semibold text-gray-800 mb-4">User Information</h2>
        <p className="text-gray-700">
          <span className="font-medium">Name:</span> {user.name}
        </p>
        <p className="text-gray-700">
          <span className="font-medium">Email:</span> {user.email}
        </p>
      </div>

      <div className="bg-white shadow rounded-2xl p-6 mb-6">
        <h2 className="text-lg font-semibold text-gray-800 mb-4">Preferences</h2>

        <div className="flex items-center justify-between py-3">
          <span className="text-gray-700">Enable Notifications</span>
          <Switch
            checked={notificationsEnabled}
            onChange={setNotificationsEnabled}
            className={`${
              notificationsEnabled ? "bg-blue-600" : "bg-gray-300"
            } relative inline-flex h-6 w-11 items-center rounded-full transition`}
          >
            <span
              className={`${
                notificationsEnabled ? "translate-x-6" : "translate-x-1"
              } inline-block h-4 w-4 transform rounded-full bg-white transition`}
            />
          </Switch>
        </div>

        <div className="flex items-center justify-between py-3">
          <span className="text-gray-700">Dark Mode</span>
          <Switch
            checked={darkModeEnabled}
            onChange={setDarkModeEnabled}
            className={`${
              darkModeEnabled ? "bg-blue-600" : "bg-gray-300"
            } relative inline-flex h-6 w-11 items-center rounded-full transition`}
          >
            <span
              className={`${
                darkModeEnabled ? "translate-x-6" : "translate-x-1"
              } inline-block h-4 w-4 transform rounded-full bg-white transition`}
            />
          </Switch>
        </div>
      </div>

      <form
        action={async () => {
        //   "use server";
          // await signOut({ redirectTo: "/" });
        }}
      >
        <button className="flex items-center gap-2 bg-red-500 text-white px-4 py-2 rounded-lg shadow hover:bg-red-600 transition">
          <PowerIcon className="w-5 h-5" />
          Logout
        </button>
      </form>
    </div>
  );
}
