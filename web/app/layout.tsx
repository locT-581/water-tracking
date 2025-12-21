import type { Metadata } from 'next'
import { Inter, Nunito } from 'next/font/google'
import './globals.css'

const inter = Inter({
  subsets: ['latin', 'vietnamese'],
  variable: '--font-sans',
})

const nunito = Nunito({
  subsets: ['latin', 'vietnamese'],
  variable: '--font-heading',
})

export const metadata: Metadata = {
  title: 'SmartHydro Admin',
  description: 'SmartHydro - Admin Dashboard & Science Hub',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="vi" className={`${inter.variable} ${nunito.variable}`}>
      <body className="font-sans antialiased">{children}</body>
    </html>
  )
}

