"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { 
  LayoutDashboard, Users, Clock, BarChart3, Store, LogOut 
} from "lucide-react";
import { cn } from "@/lib/utils";
import { Button } from "@/components/ui/button";

const menuItems = [
  { icon: LayoutDashboard, label: "Dashboard", href: "/admin/dashboard" },
  { icon: Clock, label: "Pending Approval", href: "/admin/pending" },
  { icon: Users, label: "Kelola Mustahik", href: "/admin/users" },
  { icon: Store, label: "Kedai Mustahik", href: "/admin/stores" },
  { icon: BarChart3, label: "Laporan & Donasi", href: "/admin/reports" },
];

export function Sidebar({ isOpen, setIsOpen }: { isOpen: boolean; setIsOpen: (v: boolean) => void }) {
  const pathname = usePathname();

  return (
    <div className={cn("h-full bg-white dark:bg-gray-900 border-r transition-all", 
      isOpen ? "w-72" : "w-20")}>
      <div className="p-6 flex items-center gap-3 border-b">
        <div className="w-10 h-10 bg-emerald-600 rounded-xl flex items-center justify-center text-white font-bold">
          B
        </div>
        {isOpen && <h1 className="font-bold text-xl">BAZNAS Barru</h1>}
      </div>

      <nav className="p-4 space-y-2">
        {menuItems.map((item) => {
          const isActive = pathname === item.href;
          return (
            <Link key={item.href} href={item.href}>
              <Button
                variant={isActive ? "default" : "ghost"}
                className={cn("w-full justify-start gap-3", !isOpen && "justify-center")}
              >
                <item.icon className="w-5 h-5" />
                {isOpen && <span>{item.label}</span>}
              </Button>
            </Link>
          );
        })}
      </nav>

      <div className="absolute bottom-6 px-4 w-full">
        <Button variant="ghost" className="w-full justify-start gap-3 text-red-500">
          <LogOut className="w-5 h-5" />
          {isOpen && "Keluar"}
        </Button>
      </div>
    </div>
  );
}