// app/layout.tsx
import type { Metadata } from 'next';
import { AuthProvider } from './components/auth/AuthProvider';
import './globals.css';

export const metadata: Metadata = {
  title: 'BAZNAS Barru - Z-Kasir Admin',
  description: 'Admin Panel Z-Kasir BAZNAS Barru',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="id">
      <body>
        <AuthProvider>
          {children}
        </AuthProvider>
      </body>
    </html>
  );
}