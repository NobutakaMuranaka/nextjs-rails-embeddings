import Navigation from './components/navigation'
import './globals.css'

// レイアウト
const RootLayout = async ({ children }: { children: React.ReactNode }) => {
  return (
    <html>
      <body>
        <div className="flex flex-col min-h-screen">
          <Navigation />

          <main className="flex-1 container max-w-screen-md mx-auto px-5 py-5">{children}</main>

          <footer className="py-5 border-t">
            <div className="text-center text-sm text-gray-500">
              Copyright © All rights reserved | SUZUKAZINE
            </div>
          </footer>
        </div>
      </body>
    </html>)
}

export default RootLayout