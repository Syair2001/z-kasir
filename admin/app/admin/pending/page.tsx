// app/admin/pending/page.tsx
'use client';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";

export default function PendingUsers() {
  const queryClient = useQueryClient();

  const { data: users } = useQuery({
    queryKey: ['pending-users'],
    queryFn: () => fetchWithAuth('/admin/pending-users/').then(r => r.json())
  });

  const approveMutation = useMutation({
    mutationFn: (userId: number) => 
      fetchWithAuth(`/admin/approve/${userId}/`, { method: 'POST' }),
    onSuccess: () => queryClient.invalidateQueries({ queryKey: ['pending-users'] })
  });

  return (
    <div className="space-y-6">
      <h1 className="text-3xl font-bold">Permohonan Verifikasi Mustahik</h1>
      
      <div className="rounded-md border">
        <table className="w-full">
          <thead>
            <tr className="border-b bg-muted">
              <th className="text-left p-4">Nama</th>
              <th className="text-left p-4">Username</th>
              <th className="text-left p-4">Email</th>
              <th className="p-4">Status</th>
              <th className="p-4">Aksi</th>
            </tr>
          </thead>
          <tbody>
            {users?.map((user: any) => (
              <tr key={user.id} className="border-b">
                <td className="p-4">{user.username}</td>
                <td className="p-4">{user.email}</td>
                <td className="p-4">
                  <Badge variant="secondary">Menunggu</Badge>
                </td>
                <td className="p-4">
                  <Button onClick={() => approveMutation.mutate(user.id)}>
                    Setujui
                  </Button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}