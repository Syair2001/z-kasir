// app/page.tsx
'use client';

import { useState } from 'react';
import ProtectedRoute from './components/auth/ProtectedRoute';
import DashboardStats from './components/DashboardStats';
import PendingApproval from './components/PendingApproval';
import UserManagement from './components/UserManagement';
import { useAuth } from './components/auth/AuthProvider';

export default function AdminDashboard() {
  const [activeTab, setActiveTab] = useState<'dashboard' | 'pending' | 'users'>('dashboard');
  const { logout } = useAuth();

  return (
    <ProtectedRoute>
      <div className="min-h-screen bg-gray-50">
        <header className="bg-blue-700 text-white shadow-lg">
          <div className="max-w-7xl mx-auto px-6 py-5 flex justify-between items-center">
            <div>
              <h1 className="text-3xl font-bold">Z-Kasir BAZNAS Barru</h1>
              <p className="text-blue-200">Admin Panel</p>
            </div>
            <button
              onClick={logout}
              className="bg-white/20 hover:bg-white/30 px-5 py-2 rounded-xl font-medium transition"
            >
              Keluar
            </button>
          </div>
        </header>

        <div className="max-w-7xl mx-auto px-6 py-8">
          {/* Tabs */}
          <div className="flex bg-white rounded-2xl shadow mb-8 p-1">
            {(['dashboard', 'pending', 'users'] as const).map((tab) => (
              <button
                key={tab}
                onClick={() => setActiveTab(tab)}
                className={`flex-1 py-4 rounded-xl font-medium transition ${activeTab === tab ? 'bg-blue-600 text-white shadow' : 'text-gray-600 hover:bg-gray-100'}`}
              >
                {tab === 'dashboard' && 'Dashboard'}
                {tab === 'pending' && 'Pending Approval'}
                {tab === 'users' && 'Manajemen User'}
              </button>
            ))}
          </div>

          {activeTab === 'dashboard' && <DashboardStats />}
          {activeTab === 'pending' && <PendingApproval />}
          {activeTab === 'users' && <UserManagement />}
        </div>
      </div>
    </ProtectedRoute>
  );
}