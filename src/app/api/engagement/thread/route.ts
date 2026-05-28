import { NextRequest, NextResponse } from 'next/server'
import { MOCK_THREAD_DETAILS } from '@/lib/mock-data'

export async function GET(req: NextRequest) {
  const params = new URL(req.url).searchParams
  const threadId = params.get('thread_id')
  const email = params.get('email')

  if (threadId) {
    const detail = MOCK_THREAD_DETAILS[threadId]
    if (detail) return NextResponse.json(detail)
    return NextResponse.json({ thread: null, messages: [] })
  }

  if (email) {
    const entry = Object.values(MOCK_THREAD_DETAILS).find(d =>
      (d.messages as Array<{ from_address: string }>).some(m => m.from_address === email)
    )
    if (entry) return NextResponse.json(entry)
  }

  return NextResponse.json({ thread: null, messages: [] })
}

export async function DELETE() {
  return NextResponse.json({ ok: true })
}
