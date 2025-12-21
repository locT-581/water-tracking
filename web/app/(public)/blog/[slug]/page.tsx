import { Metadata } from 'next'
import Link from 'next/link'
import { ArrowLeft, Clock, Share2, Bookmark } from 'lucide-react'

// Generate static params for common articles
export async function generateStaticParams() {
  return [
    { slug: 'tai-sao-mau-nuoc-tieu-quan-trong' },
    { slug: '5-dau-hieu-co-the-thieu-nuoc' },
    { slug: 'uong-nuoc-dung-cach-khi-tap-gym' },
  ]
}

// Generate metadata for SEO
export async function generateMetadata({
  params,
}: {
  params: { slug: string }
}): Promise<Metadata> {
  return {
    title: `Article - SmartHydro Science Hub`,
    description: 'Kiến thức khoa học về hydration',
  }
}

export default function ArticlePage({
  params,
}: {
  params: { slug: string }
}) {
  return (
    <article className="container mx-auto px-4 py-8 max-w-4xl">
      {/* Back button */}
      <Link
        href="/blog"
        className="inline-flex items-center gap-2 text-gray-500 hover:text-hydro-end mb-8"
      >
        <ArrowLeft className="w-4 h-4" />
        Back to Science Hub
      </Link>

      {/* Header */}
      <header className="mb-8">
        <div className="flex items-center gap-4 mb-4">
          <span className="px-4 py-2 bg-purple-100 text-purple-600 text-sm rounded-full font-medium">
            💧 Kiến thức cơ bản
          </span>
          <div className="flex items-center gap-2 text-gray-400 text-sm">
            <Clock className="w-4 h-4" />
            5 phút đọc
          </div>
        </div>
        <h1 className="text-4xl font-bold text-deep-ocean mb-4 leading-tight">
          Tại sao màu nước tiểu quan trọng?
        </h1>
        <p className="text-xl text-gray-600">
          Màu sắc nước tiểu là một trong những chỉ số đơn giản nhất để đánh giá tình trạng hydration của cơ thể.
        </p>
        
        {/* Actions */}
        <div className="flex items-center gap-4 mt-6 pt-6 border-t border-gray-200">
          <button className="flex items-center gap-2 text-gray-500 hover:text-hydro-end">
            <Bookmark className="w-5 h-5" />
            Save
          </button>
          <button className="flex items-center gap-2 text-gray-500 hover:text-hydro-end">
            <Share2 className="w-5 h-5" />
            Share
          </button>
        </div>
      </header>

      {/* Featured image */}
      <div className="h-80 bg-gradient-to-br from-science/30 to-hydro-end/30 rounded-2xl mb-8 flex items-center justify-center">
        <span className="text-6xl opacity-50">💧</span>
      </div>

      {/* Content */}
      <div className="prose prose-lg max-w-none">
        <p className="lead text-xl text-gray-600">
          Khi cơ thể được cung cấp đủ nước, nước tiểu thường có màu vàng nhạt như rơm hoặc gần như trong suốt. 
          Đây là dấu hiệu cho thấy thận đang hoạt động tốt và cơ thể được hydrat hóa đầy đủ.
        </p>

        <h2>Bảng màu nước tiểu</h2>
        <p>
          Ngược lại, khi nước tiểu có màu vàng đậm hoặc màu hổ phách, đây có thể là dấu hiệu cơ thể đang thiếu nước. 
          Trong trường hợp này, thận phải cô đặc nước tiểu để giữ lại nước cho cơ thể.
        </p>

        <ul>
          <li><strong>Trong suốt:</strong> Có thể bạn đang uống quá nhiều nước</li>
          <li><strong>Vàng nhạt:</strong> Tình trạng hydration lý tưởng</li>
          <li><strong>Vàng đậm:</strong> Cần uống thêm nước</li>
          <li><strong>Màu hổ phách:</strong> Mất nước - cần bổ sung ngay</li>
          <li><strong>Nâu:</strong> Mất nước nghiêm trọng hoặc có vấn đề về gan</li>
        </ul>

        <div className="bg-yellow-50 border border-yellow-200 rounded-xl p-6 my-8">
          <h3 className="text-yellow-800 flex items-center gap-2 mt-0">
            💡 Mẹo hay
          </h3>
          <p className="text-yellow-700 mb-0">
            Kiểm tra màu nước tiểu vào buổi sáng khi thức dậy để có đánh giá chính xác nhất về tình trạng hydration.
          </p>
        </div>

        <h2>Các yếu tố khác ảnh hưởng đến màu nước tiểu</h2>
        <p>
          Một số yếu tố khác cũng có thể ảnh hưởng đến màu nước tiểu:
        </p>

        <ul>
          <li><strong>Thực phẩm:</strong> Củ cải đường, cà rốt có thể làm đổi màu</li>
          <li><strong>Thuốc:</strong> Một số loại vitamin B làm nước tiểu có màu vàng neon</li>
          <li><strong>Bệnh lý:</strong> Nhiễm trùng, bệnh gan có thể gây thay đổi màu sắc bất thường</li>
        </ul>

        <h2>Khi nào cần gặp bác sĩ?</h2>
        <p>
          Nếu màu nước tiểu của bạn thay đổi đột ngột mà không liên quan đến thực phẩm hoặc thuốc, 
          hoặc nếu có kèm theo các triệu chứng khác như đau, sốt, hãy tham khảo ý kiến bác sĩ.
        </p>
      </div>

      {/* Sources */}
      <div className="mt-12 pt-8 border-t border-gray-200">
        <h3 className="font-bold text-deep-ocean mb-4">Nguồn tham khảo</h3>
        <ul className="text-sm text-gray-500 space-y-2">
          <li>• American Journal of Clinical Nutrition, 2016</li>
          <li>• Mayo Clinic - Urine color and health</li>
          <li>• National Kidney Foundation - Hydration guidelines</li>
        </ul>
      </div>

      {/* Related articles */}
      <div className="mt-12 pt-8 border-t border-gray-200">
        <h3 className="font-bold text-deep-ocean mb-6">Bài viết liên quan</h3>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          {[
            { title: '5 dấu hiệu cơ thể đang thiếu nước', slug: '5-dau-hieu-co-the-thieu-nuoc' },
            { title: 'Uống nước đúng cách khi tập gym', slug: 'uong-nuoc-dung-cach-khi-tap-gym' },
          ].map((article) => (
            <Link
              key={article.slug}
              href={`/blog/${article.slug}`}
              className="p-4 bg-gray-50 rounded-xl hover:bg-gray-100 transition-colors"
            >
              <h4 className="font-medium text-deep-ocean hover:text-hydro-end">
                {article.title}
              </h4>
            </Link>
          ))}
        </div>
      </div>
    </article>
  )
}

