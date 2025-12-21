import Link from 'next/link'

const articles = [
  {
    slug: 'tai-sao-mau-nuoc-tieu-quan-trong',
    title: 'Tại sao màu nước tiểu quan trọng?',
    summary: 'Màu sắc nước tiểu là chỉ số đơn giản nhất để đánh giá tình trạng hydration của cơ thể.',
    category: '💧 Cơ bản',
    readTime: 5,
    imageUrl: null,
  },
  {
    slug: '5-dau-hieu-co-the-thieu-nuoc',
    title: '5 dấu hiệu cơ thể đang thiếu nước',
    summary: 'Nhận biết sớm các dấu hiệu mất nước giúp bạn bảo vệ sức khỏe tốt hơn.',
    category: '💧 Cơ bản',
    readTime: 4,
    imageUrl: null,
  },
  {
    slug: 'uong-nuoc-dung-cach-khi-tap-gym',
    title: 'Uống nước đúng cách khi tập gym',
    summary: 'Hướng dẫn chi tiết cách bù nước trước, trong và sau khi tập luyện.',
    category: '🏃 Thể thao',
    readTime: 6,
    imageUrl: null,
  },
  {
    slug: 'ca-phe-co-thuc-su-gay-mat-nuoc',
    title: 'Cà phê có thực sự gây mất nước?',
    summary: 'Giải đáp thắc mắc phổ biến về tác động của cà phê đến hydration.',
    category: '🥗 Dinh dưỡng',
    readTime: 5,
    imageUrl: null,
  },
  {
    slug: 'nuoc-dua-vs-nuoc-loc',
    title: 'Nước dừa vs nước lọc: Loại nào tốt hơn?',
    summary: 'So sánh chi tiết hai loại đồ uống phổ biến để bù nước.',
    category: '🥗 Dinh dưỡng',
    readTime: 7,
    imageUrl: null,
  },
  {
    slug: 'hydration-khi-mang-thai',
    title: 'Hướng dẫn hydration khi mang thai',
    summary: 'Tầm quan trọng của việc uống đủ nước trong thai kỳ.',
    category: '🤰 Mang thai',
    readTime: 8,
    imageUrl: null,
  },
]

export default function BlogPage() {
  return (
    <div className="container mx-auto px-4 py-12">
      {/* Hero */}
      <div className="text-center mb-12">
        <h1 className="text-4xl font-bold text-deep-ocean mb-4">Science Hub</h1>
        <p className="text-gray-600 max-w-2xl mx-auto">
          Kiến thức khoa học về hydration, được chọn lọc và biên soạn bởi đội ngũ chuyên gia.
        </p>
      </div>

      {/* Categories */}
      <div className="flex items-center justify-center gap-3 mb-12 flex-wrap">
        {['Tất cả', '💧 Cơ bản', '🥗 Dinh dưỡng', '🏃 Thể thao', '⚖️ Giảm cân', '🤰 Mang thai'].map((cat) => (
          <button
            key={cat}
            className="px-4 py-2 rounded-full bg-white border border-gray-200 text-sm font-medium hover:border-hydro-end hover:text-hydro-end transition-colors"
          >
            {cat}
          </button>
        ))}
      </div>

      {/* Articles grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
        {articles.map((article) => (
          <Link
            key={article.slug}
            href={`/blog/${article.slug}`}
            className="bg-white rounded-2xl overflow-hidden shadow-sm border border-gray-100 hover:shadow-lg transition-shadow group"
          >
            {/* Thumbnail */}
            <div className="h-48 bg-gradient-to-br from-science/20 to-hydro-end/20 flex items-center justify-center">
              <span className="text-5xl opacity-50">📄</span>
            </div>
            {/* Content */}
            <div className="p-6">
              <div className="flex items-center justify-between mb-3">
                <span className="px-3 py-1 bg-purple-100 text-purple-600 text-xs rounded-full">
                  {article.category}
                </span>
                <span className="text-xs text-gray-400">{article.readTime} min</span>
              </div>
              <h2 className="text-lg font-bold text-deep-ocean mb-2 group-hover:text-hydro-end transition-colors">
                {article.title}
              </h2>
              <p className="text-gray-500 text-sm line-clamp-2">
                {article.summary}
              </p>
            </div>
          </Link>
        ))}
      </div>

      {/* Load more */}
      <div className="text-center mt-12">
        <button className="px-8 py-3 bg-hydro-gradient text-white font-medium rounded-full hover:opacity-90 transition-opacity">
          Load More Articles
        </button>
      </div>
    </div>
  )
}

