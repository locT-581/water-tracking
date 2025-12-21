import Link from 'next/link'
import { Droplets } from 'lucide-react'

export default function PublicLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <header className="bg-white border-b border-gray-200 sticky top-0 z-50">
        <div className="container mx-auto px-4 py-4 flex items-center justify-between">
          <Link href="/" className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-xl bg-hydro-gradient flex items-center justify-center">
              <Droplets className="w-5 h-5 text-white" />
            </div>
            <div>
              <h1 className="font-bold text-deep-ocean">SmartHydro</h1>
              <p className="text-xs text-gray-500">Science Hub</p>
            </div>
          </Link>
          <nav className="flex items-center gap-6">
            <Link href="/blog" className="text-gray-600 hover:text-hydro-end font-medium">
              Articles
            </Link>
            <Link href="/blog?category=basic" className="text-gray-600 hover:text-hydro-end">
              Basics
            </Link>
            <Link href="/blog?category=nutrition" className="text-gray-600 hover:text-hydro-end">
              Nutrition
            </Link>
            <Link href="/blog?category=sports" className="text-gray-600 hover:text-hydro-end">
              Sports
            </Link>
          </nav>
        </div>
      </header>

      {/* Main content */}
      <main>{children}</main>

      {/* Footer */}
      <footer className="bg-deep-ocean text-white py-12 mt-16">
        <div className="container mx-auto px-4">
          <div className="grid grid-cols-1 md:grid-cols-4 gap-8">
            <div>
              <div className="flex items-center gap-3 mb-4">
                <div className="w-10 h-10 rounded-xl bg-hydro-gradient flex items-center justify-center">
                  <Droplets className="w-5 h-5 text-white" />
                </div>
                <h3 className="font-bold">SmartHydro</h3>
              </div>
              <p className="text-gray-400 text-sm">
                Hydration tuned to your biology.
              </p>
            </div>
            <div>
              <h4 className="font-bold mb-4">Categories</h4>
              <ul className="space-y-2 text-gray-400 text-sm">
                <li><Link href="/blog?category=basic" className="hover:text-white">Basics</Link></li>
                <li><Link href="/blog?category=nutrition" className="hover:text-white">Nutrition</Link></li>
                <li><Link href="/blog?category=sports" className="hover:text-white">Sports</Link></li>
                <li><Link href="/blog?category=pregnancy" className="hover:text-white">Pregnancy</Link></li>
              </ul>
            </div>
            <div>
              <h4 className="font-bold mb-4">Download App</h4>
              <ul className="space-y-2 text-gray-400 text-sm">
                <li><Link href="#" className="hover:text-white">App Store</Link></li>
                <li><Link href="#" className="hover:text-white">Google Play</Link></li>
              </ul>
            </div>
            <div>
              <h4 className="font-bold mb-4">Legal</h4>
              <ul className="space-y-2 text-gray-400 text-sm">
                <li><Link href="#" className="hover:text-white">Privacy Policy</Link></li>
                <li><Link href="#" className="hover:text-white">Terms of Service</Link></li>
              </ul>
            </div>
          </div>
          <div className="border-t border-gray-700 mt-8 pt-8 text-center text-gray-400 text-sm">
            © 2025 SmartHydro. All rights reserved.
          </div>
        </div>
      </footer>
    </div>
  )
}

