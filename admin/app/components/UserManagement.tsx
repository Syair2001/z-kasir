'use client';

import { useEffect, useState } from 'react';

interface User {
  id: number;
  username: string;
  email: string;
  is_approved: boolean;
  store?: { name: string; address: string };
}

export default function UserManagement() {
  const [users, setUsers] = useState<User[]>([]);
  const [loading, setLoading] = useState(true);

  const fetchUsers = async () => {
    const res = await fetch('http://localhost:8000/api/admin/pending-users/', { // Bisa diganti endpoint all users
      headers: { Authorization: `Bearer ${localStorage.getItem('token')}` },
    });
    const data = await res.json();
    setUsers(data);
    setLoading(false);
  };

  useEffect(() => {
    fetchUsers();
  }, []);

  const toggleApproval = async (userId: number, currentStatus: boolean) => {
    // Backend perlu endpoint toggle approval
    await fetch(`http://localhost:8000/api/admin/approve/${userId}/`, {
      method: 'POST',
      headers: { Authorization: `Bearer ${localStorage.getItem('token')}` },
    });
    fetchUsers();
  };

  if (loading) return <div className="p-10">Loading users...</div>;

  return (
    <div className="p-8">
      <h2 className="text-2xl font-bold mb-6">Manajemen User Mustahik</h2>

      <div className="overflow-x-auto">
        <table className="w-full border-collapse">
          <thead>
            <tr className="bg-gray-100">
              <th className="p-4 text-left">Username</th>
              <th className="p-4 text-left">Email</th>
              <th className="p-4 text-left">Toko</th>
              <th className="p-4 text-center">Status</th>
              <th className="p-4 text-center">Aksi</th>
            </tr>
          </thead>
          <tbody>
            {users.map(user => (
              <tr key={user.id} className="border-b hover:bg-gray-50">
                <td className="p-4 font-medium">{user.username}</td>
                <td className="p-4 text-gray-600">{user.email}</td>
                <td className="p-4">{user.store?.name || '-'}</td>
                <td className="p-4 text-center">
                  <span className={`px-3 py-1 rounded-full text-sm ${user.is_approved ? 'bg-green-100 text-green-700' : 'bg-yellow-100 text-yellow-700'}`}>
                    {user.is_approved ? '✅ Aktif' : '⏳ Pending'}
                  </span>
                </td>
                <td className="p-4 text-center">
                  <button
                    onClick={() => toggleApproval(user.id, user.is_approved)}
                    className={`px-5 py-2 rounded-lg text-sm font-medium ${user.is_approved ? 'bg-red-100 text-red-700 hover:bg-red-200' : 'bg-green-600 text-white hover:bg-green-700'}`}
                  >
                    {user.is_approved ? 'Nonaktifkan' : 'Aktifkan'}
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}