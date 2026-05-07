'use client';

import { useEffect, useState } from 'react';

interface PendingUser {
  id: number;
  username: string;
  email: string;
}

export default function PendingApproval() {
  const [users, setUsers] = useState<PendingUser[]>([]);
  const [loading, setLoading] = useState(true);

  const fetchPending = async () => {
    const res = await fetch('http://localhost:8000/api/admin/pending-users/', {
      headers: { Authorization: `Bearer ${localStorage.getItem('token')}` },
    });
    const data = await res.json();
    setUsers(data);
    setLoading(false);
  };

  useEffect(() => {
    fetchPending();
  }, []);

  const approveUser = async (userId: number) => {
    if (!confirm('Setujui user ini?')) return;

    await fetch(`http://localhost:8000/api/admin/approve/${userId}/`, {
      method: 'POST',
      headers: { 
        'Content-Type': 'application/json',
        Authorization: `Bearer ${localStorage.getItem('token')}` 
      },
    });

    alert('User telah disetujui');
    fetchPending();
  };

  if (loading) return <div className="p-10">Loading pending users...</div>;

  return (
    <div className="p-8">
      <h2 className="text-2xl font-bold mb-6">Pending Approval Mustahik</h2>

      {users.length === 0 ? (
        <p className="text-gray-500">Tidak ada permohonan pending.</p>
      ) : (
        <div className="space-y-4">
          {users.map(user => (
            <div key={user.id} className="flex items-center justify-between bg-white border p-6 rounded-xl shadow-sm">
              <div>
                <p className="font-semibold">{user.username}</p>
                <p className="text-gray-500 text-sm">{user.email}</p>
              </div>
              <button
                onClick={() => approveUser(user.id)}
                className="bg-green-600 hover:bg-green-700 text-white px-6 py-3 rounded-lg font-medium transition"
              >
                ✅ Setujui
              </button>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}