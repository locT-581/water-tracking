'use client'

import { useState } from 'react'
import Link from 'next/link'
import { ArrowLeft, Save, Eye } from 'lucide-react'

const categories = [
  { value: 'basic', label: '💧 Kiến thức cơ bản' },
  { value: 'nutrition', label: '🥗 Dinh dưỡng' },
  { value: 'weight_loss', label: '⚖️ Giảm cân' },
  { value: 'kidney', label: '🫘 Thận' },
  { value: 'sports', label: '🏃 Thể thao' },
  { value: 'pregnancy', label: '🤰 Mang thai' },
]

export default function NewArticlePage() {
  const [title, setTitle] = useState('')
  const [summary, setSummary] = useState('')
  const [category, setCategory] = useState('')
  const [content, setContent] = useState('')

  return (
    <div className="p-8">
      {/* Header */}
      <div className="flex items-center justify-between mb-8">
        <div className="flex items-center gap-4">
          <Link href="/articles" className="p-2 hover:bg-gray-100 rounded-lg">
            <ArrowLeft className="w-5 h-5 text-gray-500" />
          </Link>
          <div>
            <h1 className="text-2xl font-bold text-deep-ocean">New Article</h1>
            <p className="text-gray-500">Create a new Science Hub article</p>
          </div>
        </div>
        <div className="flex items-center gap-3">
          <button className="flex items-center gap-2 px-4 py-2 text-gray-600 hover:bg-gray-100 rounded-xl">
            <Eye className="w-4 h-4" />
            Preview
          </button>
          <button className="flex items-center gap-2 px-4 py-2 bg-gray-200 text-gray-700 font-medium rounded-xl hover:bg-gray-300">
            Save Draft
          </button>
          <button className="flex items-center gap-2 px-6 py-2 bg-hydro-gradient text-white font-medium rounded-xl hover:opacity-90">
            <Save className="w-4 h-4" />
            Publish
          </button>
        </div>
      </div>

      <div className="grid grid-cols-3 gap-8">
        {/* Main editor */}
        <div className="col-span-2 space-y-6">
          {/* Title */}
          <div className="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
            <label className="block text-sm font-medium text-gray-700 mb-2">Title</label>
            <input
              type="text"
              value={title}
              onChange={(e) => setTitle(e.target.value)}
              placeholder="Enter article title..."
              className="w-full px-4 py-3 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-hydro-end focus:border-transparent text-lg"
            />
          </div>

          {/* Summary */}
          <div className="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
            <label className="block text-sm font-medium text-gray-700 mb-2">Summary</label>
            <textarea
              value={summary}
              onChange={(e) => setSummary(e.target.value)}
              placeholder="Brief summary for article cards (max 200 chars)"
              rows={2}
              maxLength={200}
              className="w-full px-4 py-3 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-hydro-end focus:border-transparent resize-none"
            />
            <p className="text-right text-xs text-gray-400 mt-1">{summary.length}/200</p>
          </div>

          {/* Content editor */}
          <div className="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
            <label className="block text-sm font-medium text-gray-700 mb-2">Content</label>
            {/* Placeholder for Tiptap editor */}
            <div className="border border-gray-200 rounded-xl overflow-hidden">
              <div className="flex items-center gap-1 px-4 py-2 bg-gray-50 border-b border-gray-200">
                <button className="p-2 hover:bg-gray-200 rounded text-sm font-bold">B</button>
                <button className="p-2 hover:bg-gray-200 rounded text-sm italic">I</button>
                <button className="p-2 hover:bg-gray-200 rounded text-sm underline">U</button>
                <span className="w-px h-6 bg-gray-300 mx-2"></span>
                <button className="p-2 hover:bg-gray-200 rounded text-sm">H1</button>
                <button className="p-2 hover:bg-gray-200 rounded text-sm">H2</button>
                <button className="p-2 hover:bg-gray-200 rounded text-sm">H3</button>
                <span className="w-px h-6 bg-gray-300 mx-2"></span>
                <button className="p-2 hover:bg-gray-200 rounded text-sm">• List</button>
                <button className="p-2 hover:bg-gray-200 rounded text-sm">1. List</button>
                <span className="w-px h-6 bg-gray-300 mx-2"></span>
                <button className="p-2 hover:bg-gray-200 rounded text-sm">🔗 Link</button>
                <button className="p-2 hover:bg-gray-200 rounded text-sm">🖼️ Image</button>
              </div>
              <textarea
                value={content}
                onChange={(e) => setContent(e.target.value)}
                placeholder="Write your article content here... (Tiptap editor will be integrated)"
                rows={20}
                className="w-full px-4 py-4 focus:outline-none resize-none"
              />
            </div>
          </div>
        </div>

        {/* Sidebar */}
        <div className="space-y-6">
          {/* Category */}
          <div className="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
            <label className="block text-sm font-medium text-gray-700 mb-2">Category</label>
            <select
              value={category}
              onChange={(e) => setCategory(e.target.value)}
              className="w-full px-4 py-3 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-hydro-end focus:border-transparent"
            >
              <option value="">Select category...</option>
              {categories.map((cat) => (
                <option key={cat.value} value={cat.value}>{cat.label}</option>
              ))}
            </select>
          </div>

          {/* Thumbnail */}
          <div className="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
            <label className="block text-sm font-medium text-gray-700 mb-2">Thumbnail</label>
            <div className="border-2 border-dashed border-gray-200 rounded-xl p-8 text-center hover:border-hydro-end cursor-pointer transition-colors">
              <div className="w-12 h-12 mx-auto mb-4 bg-gray-100 rounded-xl flex items-center justify-center">
                <span className="text-2xl">🖼️</span>
              </div>
              <p className="text-sm text-gray-500">Click to upload thumbnail</p>
              <p className="text-xs text-gray-400 mt-1">PNG, JPG up to 2MB</p>
            </div>
          </div>

          {/* Medical sources */}
          <div className="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
            <label className="block text-sm font-medium text-gray-700 mb-2">Medical Sources</label>
            <textarea
              placeholder="Add references, one per line..."
              rows={4}
              className="w-full px-4 py-3 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-hydro-end focus:border-transparent resize-none text-sm"
            />
            <p className="text-xs text-gray-400 mt-1">Important for scientific credibility</p>
          </div>

          {/* SEO */}
          <div className="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
            <label className="block text-sm font-medium text-gray-700 mb-2">SEO Settings</label>
            <input
              type="text"
              placeholder="URL slug (auto-generated)"
              className="w-full px-4 py-2 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-hydro-end focus:border-transparent text-sm mb-3"
            />
            <textarea
              placeholder="Meta description for search engines..."
              rows={2}
              className="w-full px-4 py-2 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-hydro-end focus:border-transparent resize-none text-sm"
            />
          </div>
        </div>
      </div>
    </div>
  )
}

