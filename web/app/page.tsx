import Link from 'next/link'

export default function Home() {
  return (
    <main className="min-h-screen flex flex-col items-center justify-center bg-gradient-to-br from-hydro-start to-hydro-end">
      <div className="text-center text-white">
        {/* Logo */}
        <div className="w-24 h-24 mx-auto mb-8 bg-white rounded-full flex items-center justify-center shadow-2xl">
          <svg className="w-12 h-12 text-hydro-end" fill="currentColor" viewBox="0 0 24 24">
            <path d="M12 2c-5.33 4.55-8 8.48-8 11.8 0 4.98 3.8 8.2 8 8.2s8-3.22 8-8.2c0-3.32-2.67-7.25-8-11.8zm0 18c-3.35 0-6-2.57-6-6.2 0-2.34 1.95-5.44 6-9.14 4.05 3.7 6 6.79 6 9.14 0 3.63-2.65 6.2-6 6.2z"/>
          </svg>
        </div>
        
        <h1 className="text-5xl font-bold font-heading mb-4">SmartHydro</h1>
        <p className="text-xl mb-12 opacity-90">Hydration tuned to your biology.</p>
        
        {/* Navigation links */}
        <div className="flex gap-4 justify-center">
          <Link 
            href="/blog"
            className="px-8 py-4 bg-white text-hydro-end font-bold rounded-full hover:bg-white/90 transition-colors shadow-lg"
          >
            Science Hub
          </Link>
          <Link 
            href="/dashboard"
            className="px-8 py-4 bg-white/20 text-white font-bold rounded-full hover:bg-white/30 transition-colors border border-white/30"
          >
            Admin Dashboard
          </Link>
        </div>
      </div>
      
      {/* Footer */}
      <footer className="absolute bottom-8 text-white/70 text-sm">
        © 2025 SmartHydro. All rights reserved.
      </footer>
    </main>
  )
}

