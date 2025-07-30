"use client";
import { useEffect } from "react";
import { onAuthStateChanged } from "firebase/auth";
import { useRouter } from "next/navigation";
import { auth } from "@/config/firebase";

export default function Dashboard() {
  const router = useRouter();

  useEffect(() => {
    const unsubscribe = onAuthStateChanged(auth, (user) => {
      if (!user) {
        router.push("/login");
      }
    });

    return () => unsubscribe();
  }, [router]);

  return (
    <div className="min-h-screen bg-gray-50 p-6">
      <header className="mb-6">
        <h1 className="text-3xl font-bold text-gray-800">Dashboard</h1>
        <p className="text-gray-600 mt-1">Welcome back! Here's a quick overview of your spending.</p>
      </header>

      {/* Summary Cards */}
      <section className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6 mb-8">
        <div className="bg-white p-4 rounded shadow">
          <h2 className="text-sm text-gray-500">Total Income</h2>
          <p className="text-2xl font-semibold text-green-600">$2,500</p>
        </div>

        <div className="bg-white p-4 rounded shadow">
          <h2 className="text-sm text-gray-500">Total Expenses</h2>
          <p className="text-2xl font-semibold text-red-600">$1,200</p>
        </div>

        <div className="bg-white p-4 rounded shadow">
          <h2 className="text-sm text-gray-500">Balance</h2>
          <p className="text-2xl font-semibold text-blue-600">$1,300</p>
        </div>
      </section>

      {/* Placeholder for charts, transactions, etc. */}
      <section className="bg-white p-6 rounded shadow">
        <h2 className="text-lg font-semibold text-gray-800 mb-4">Recent Transactions</h2>
        <p className="text-gray-500">You don’t have any recent transactions yet.</p>
      </section>
    </div>
  );
}
