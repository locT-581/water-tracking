import Link from 'next/link'
import { Plus, Search, Filter } from 'lucide-react'

const articles = [
  { id: '1', title: 'Tại sao màu nước tiểu quan trọng?', category: 'Cơ bản', status: 'published', views: 1234, createdAt: '2024-01-15' },
  { id: '2', title: '5 dấu hiệu cơ thể đang thiếu nước', category: 'Cơ bản', status: 'published', views: 987, createdAt: '2024-01-14' },
  { id: '3', title: 'Uống nước đúng cách khi tập gym', category: 'Thể thao', status: 'draft', views: 0, createdAt: '2024-01-13' },
  { id: '4', title: 'Cà phê có thực sự gây mất nước?', category: 'Dinh dưỡng', status: 'published', views: 756, createdAt: '2024-01-12' },
  { id: '5', title: 'Nước dừa vs nước lọc', category: 'Dinh dưỡng', status: 'draft', views: 0, createdAt: '2024-01-11' },
]

export default function ArticlesPage() {
  return (
    <div className="p-8">
      {/* Header */}
      <div className="flex items-center justify-between mb-8">
        <div>
          <h1 className="text-2xl font-bold text-deep-ocean">Articles</h1>
          <p className="text-gray-500">Manage Science Hub content</p>
        </div>
        <Link
          href="/articles/new"
          className="flex items-center gap-2 px-6 py-3 bg-hydro-gradient text-white font-medium rounded-xl hover:opacity-90 transition-opacity"
        >
          <Plus className="w-5 h-5" />
          New Article
        </Link>
      </div>

      {/* Filters */}
      <div className="flex items-center gap-4 mb-6">
        <div className="flex-1 relative">
          <Search className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" />
          <input
            type="text"
            placeholder="Search articles..."
            className="w-full pl-12 pr-4 py-3 bg-white border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-hydro-end focus:border-transparent"
          />
        </div>
        <button className="flex items-center gap-2 px-4 py-3 bg-white border border-gray-200 rounded-xl hover:bg-gray-50">
          <Filter className="w-5 h-5 text-gray-500" />
          Filter
        </button>
      </div>

      {/* Table */}
      <div className="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden">
        <table className="w-full">
          <thead>
            <tr className="bg-gray-50 border-b border-gray-200">
              <th className="text-left px-6 py-4 text-sm font-medium text-gray-500">Title</th>
              <th className="text-left px-6 py-4 text-sm font-medium text-gray-500">Category</th>
              <th className="text-left px-6 py-4 text-sm font-medium text-gray-500">Status</th>
              <th className="text-left px-6 py-4 text-sm font-medium text-gray-500">Views</th>
              <th className="text-left px-6 py-4 text-sm font-medium text-gray-500">Created</th>
              <th className="text-left px-6 py-4 text-sm font-medium text-gray-500">Actions</th>
            </tr>
          </thead>
          <tbody>
            {articles.map((article) => (
              <tr key={article.id} className="border-b border-gray-100 hover:bg-gray-50">
                <td className="px-6 py-4">
                  <Link href={`/articles/${article.id}`} className="font-medium text-deep-ocean hover:text-hydro-end">
                    {article.title}
                  </Link>
                </td>
                <td className="px-6 py-4">
                  <span className="px-3 py-1 bg-purple-100 text-purple-600 text-sm rounded-full">
                    {article.category}
                  </span>
                </td>
                <td className="px-6 py-4">
                  <span className={`px-3 py-1 text-sm rounded-full ${
                    article.status === 'published'
                      ? 'bg-green-100 text-green-600'
                      : 'bg-yellow-100 text-yellow-600'
                  }`}>
                    {article.status === 'published' ? 'Published' : 'Draft'}
                  </span>
                </td>
                <td className="px-6 py-4 text-gray-600">{article.views.toLocaleString()}</td>
                <td className="px-6 py-4 text-gray-500 text-sm">{article.createdAt}</td>
                <td className="px-6 py-4">
                  <Link
                    href={`/articles/${article.id}`}
                    className="text-hydro-end hover:underline text-sm font-medium"
                  >
                    Edit
                  </Link>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  )
}

