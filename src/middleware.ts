import { NextResponse, type NextRequest } from 'next/server'

// Demo mode: all routes are public, no auth required
export async function middleware(request: NextRequest) {
  const { pathname } = request.nextUrl

  // Redirect root and login straight to the dashboard
  if (pathname === '/' || pathname === '/login') {
    return NextResponse.redirect(new URL('/overview', request.url))
  }

  return NextResponse.next()
}

export const config = {
  matcher: ['/((?!_next/static|_next/image|favicon.ico|api/|.*\\.(?:svg|png|jpg|jpeg|gif|webp)$).*)'],
}
