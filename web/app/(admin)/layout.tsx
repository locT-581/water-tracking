'use client'

import Link from 'next/link'
import { usePathname } from 'next/navigation'
import { 
  LayoutDashboard, 
  FileText, 
  Bell, 
  Users,
  Settings,
  LogOut,
  Droplets
} from 'lucide-react'

const sidebarItems = [
  { icon: LayoutDashboard, label: 'Dashboard', href: '/dashboard' },
  { icon: FileText, label: 'Articles', href: '/articles' },
  { icon: Bell, label: 'Notifications', href: '/notifications' },
  { icon: Users, label: 'Users', href: '/users' },
  { icon: Settings, label: 'Settings', href: '/settings' },
]

export default function AdminLayout({
  children,
}: {
  children: React.ReactNode
}) {
  const pathname = usePathname()

  return (
    <div className="min-h-screen flex bg-gray-50">
      {/* Sidebar */}
      <aside className="w-64 bg-white border-r border-gray-200 flex flex-col">
        {/* Logo */}
        <div className="p-6 border-b border-gray-200">
          <Link href="/dashboard" className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-xl bg-hydro-gradient flex items-center justify-center">
              <Droplets className="w-5 h-5 text-white" />
            </div>
            <div>
              <h1 className="font-bold text-deep-ocean">SmartHydro</h1>
              <p className="text-xs text-gray-500">Admin Panel</p>
            </div>
          </Link>
        </div>

        {/* Navigation */}
        <nav className="flex-1 p-4">
          <ul className="space-y-1">
            {sidebarItems.map((item) => {
              const isActive = pathname.startsWith(item.href)
              return (
                <li key={item.href}>
                  <Link
                    href={item.href}
                    className={`flex items-center gap-3 px-4 py-3 rounded-xl transition-colors ${
                      isActive
                        ? 'bg-hydro-end/10 text-hydro-end font-medium'
                        : 'text-gray-600 hover:bg-gray-100'
                    }`}
                  >
                    <item.icon className="w-5 h-5" />
                    {item.label}
                  </Link>
                </li>
              )
            })}
          </ul>
        </nav>

        {/* User section */}
        <div className="p-4 border-t border-gray-200">
          <div className="flex items-center gap-3 px-4 py-3">
            <div className="w-10 h-10 rounded-full bg-gray-200 flex items-center justify-center">
              <span className="text-gray-600 font-medium">A</span>
            </div>
            <div className="flex-1">
              <p className="font-medium text-sm">Admin User</p>
              <p className="text-xs text-gray-500">admin@smarthydro.com</p>
            </div>
            <button className="p-2 text-gray-400 hover:text-gray-600 rounded-lg hover:bg-gray-100">
              <LogOut className="w-4 h-4" />
            </button>
          </div>
        </div>
      </aside>

      {/* Main content */}
      <main className="flex-1 overflow-auto">
        {children}
      </main>
    </div>
  )
}

