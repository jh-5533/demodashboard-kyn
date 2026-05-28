import { NextResponse } from 'next/server'

export async function POST() {
  return NextResponse.json({ ok: true, id: `ob-saved-${Date.now()}` })
}
