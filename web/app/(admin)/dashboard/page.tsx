import { FileText, Users, TrendingUp, Droplets } from 'lucide-react'

const stats = [
  { label: 'Total Users', value: '12,345', icon: Users, change: '+12%', color: 'bg-blue-500' },
  { label: 'Published Articles', value: '45', icon: FileText, change: '+3', color: 'bg-purple-500' },
  { label: 'Active Today', value: '2,891', icon: TrendingUp, change: '+18%', color: 'bg-green-500' },
  { label: 'Water Logged (L)', value: '45,230', icon: Droplets, change: '+8%', color: 'bg-cyan-500' },
]

export default function DashboardPage() {
  return (
    <div className="p-8">
      {/* Header */}
      <div className="mb-8">
        <h1 className="text-2xl font-bold text-deep-ocean">Dashboard</h1>
        <p className="text-gray-500">Welcome back! Here's what's happening with SmartHydro.</p>
      </div>

      {/* Stats grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
        {stats.map((stat) => (
          <div key={stat.label} className="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
            <div className="flex items-center justify-between mb-4">
              <div className={`w-12 h-12 ${stat.color} rounded-xl flex items-center justify-center`}>
                <stat.icon className="w-6 h-6 text-white" />
              </div>
              <span className="text-green-500 text-sm font-medium">{stat.change}</span>
            </div>
            <p className="text-3xl font-bold text-deep-ocean mb-1">{stat.value}</p>
            <p className="text-gray-500 text-sm">{stat.label}</p>
          </div>
        ))}
      </div>

      {/* Charts section */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Activity chart */}
        <div className="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
          <h3 className="font-bold text-deep-ocean mb-4">User Activity</h3>
          <div className="h-64 flex items-center justify-center bg-gray-50 rounded-xl">
            <p className="text-gray-400">Chart placeholder (recharts)</p>
          </div>
        </div>

        {/* Top articles */}
        <div className="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
          <h3 className="font-bold text-deep-ocean mb-4">Popular Articles</h3>
          <div className="space-y-4">
            {[
              'Tại sao màu nước tiểu quan trọng?',
              '5 dấu hiệu cơ thể đang thiếu nước',
              'Uống nước đúng cách khi tập gym',
            ].map((title, index) => (
              <div key={title} className="flex items-center gap-4 p-4 bg-gray-50 rounded-xl">
                <span className="w-8 h-8 rounded-lg bg-hydro-gradient text-white flex items-center justify-center font-bold text-sm">
                  {index + 1}
                </span>
                <div className="flex-1">
                  <p className="font-medium text-sm">{title}</p>
                  <p className="text-xs text-gray-500">{Math.floor(Math.random() * 1000) + 500} views</p>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  )
}

