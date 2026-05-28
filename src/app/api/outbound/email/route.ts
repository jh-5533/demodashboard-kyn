import { NextResponse } from 'next/server'

export async function POST() {
  return NextResponse.json({ ok: true, messageId: `demo-msg-${Date.now()}` })
}
