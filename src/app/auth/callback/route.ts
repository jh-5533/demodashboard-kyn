import { NextRequest, NextResponse } from 'next/server'

// Demo mode: OAuth callback not used — redirect straight to overview
export async function GET(request: NextRequest) {
  const { origin } = new URL(request.url)
  return NextResponse.redirect(`${origin}/overview`)
}
