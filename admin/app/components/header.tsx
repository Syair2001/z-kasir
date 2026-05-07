"use client";

import { Bell, Moon, Sun } from "lucide-react";
import { useTheme } from "next-themes";
import { Button } from "@/components/ui/button";

export function Header({ toggleSidebar }: { toggleSidebar: () => void }) {
  const { theme, setTheme } = useTheme();

  return (
    <header className="h-16 border-b bg-white dark:bg-gray-900 px-6 flex items-center justify-between">
      <Button variant="ghost" onClick={toggleSidebar} className="md:hidden">
        ☰
      </Button>

      <div className="flex items-center gap-4">
        <Button variant="ghost" size="icon" onClick={() => setTheme(theme === "dark" ? "light" : "dark")}>
          {theme === "dark" ? <Sun /> : <Moon />}
        </Button>
        
        <Button variant="ghost" size="icon">
          <Bell />
        </Button>

        <div className="flex items-center gap-3">
          <div className="text-right">
            <p className="text-sm font-medium">Admin BAZNAS</p>
            <p className="text-xs text-gray-500">Barru</p>
          </div>
          <div className="w-9 h-9 bg-emerald-600 rounded-full" />
        </div>
      </div>
    </header>
  );
}