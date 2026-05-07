'use client';

import { useEffect, useState } from 'react';

interface Stats {
  total_transactions: number;
  total_revenue: number;
  total_mustahik: number;
  active_mustahik: number;
}

export default function DashboardStats() {
  const [stats, setStats] = useState<Stats | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetch('http://localhost:8000/api/admin/dashboard/', {
      headers: { Authorization: `Bearer ${localStorage.getItem('token')}` },
    })
      .then(res => res.json())
      .then(data => {
        setStats(data);
        setLoading(false);
      })
      .catch(() => setLoading(false));
  }, []);

  if (loading) return <div className="p-10 text-center">Loading dashboard...</div>;

  return (
    <div className="p-8">
      <h2 className="text-2xl font-bold mb-8">Dashboard Overview</h2>
      
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        <div className="bg-blue-50 p-6 rounded-xl border border-blue-100">
          <p className="text-blue-600">Total Transaksi</p>
          <p className="text-4xl font-bold mt-2">{stats?.total_transactions}</p>
        </div>
        <div className="bg-green-50 p-6 rounded-xl border border-green-100">
          <p className="text-green-600">Total Pendapatan</p>
          <p className="text-4xl font-bold mt-2">Rp {stats?.total_revenue.toLocaleString('id-ID')}</p>
        </div>
        <div className="bg-purple-50 p-6 rounded-xl border border-purple-100">
          <p className="text-purple-600">Total Mustahik</p>
          <p className="text-4xl font-bold mt-2">{stats?.total_mustahik}</p>
        </div>
        <div className="bg-amber-50 p-6 rounded-xl border border-amber-100">
          <p className="text-amber-600">Mustahik Aktif</p>
          <p className="text-4xl font-bold mt-2">{stats?.active_mustahik}</p>
        </div>
      </div>
    </div>
  );
}