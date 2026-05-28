import { NextRequest, NextResponse } from 'next/server'
import { MOCK_ENGAGEMENT_DRAFT } from '@/lib/mock-data'

export async function GET() {
  return NextResponse.json([])
}

export async function POST(req: NextRequest) {
  const body = await req.json().catch(() => ({}))
  const threadId = body.thread_id ?? body.threadId ?? 'demo'
  return NextResponse.json({ draftId: `draft-${Date.now()}`, content: MOCK_ENGAGEMENT_DRAFT(threadId), contactId: 'demo-contact' })
}

export async function PATCH() {
  return NextResponse.json({ ok: true })
}
