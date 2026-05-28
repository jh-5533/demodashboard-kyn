import { NextRequest, NextResponse } from 'next/server'
import { MOCK_THREAD_SUMMARIES } from '@/lib/mock-data'

export async function GET(req: NextRequest) {
  const threadId = new URL(req.url).searchParams.get('thread_id')
  if (!threadId) return NextResponse.json([])
  return NextResponse.json(MOCK_THREAD_SUMMARIES[threadId] ?? [])
}

export async function PATCH() {
  return NextResponse.json({ ok: true })
}
