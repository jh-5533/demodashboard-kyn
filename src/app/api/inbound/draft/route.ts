import { NextRequest, NextResponse } from 'next/server'
import { MOCK_INBOUND_DRAFT } from '@/lib/mock-data'

export async function POST(req: NextRequest) {
  const { name, topic } = await req.json().catch(() => ({ name: 'there', topic: '' }))
  return NextResponse.json({ content: MOCK_INBOUND_DRAFT(name ?? 'there', topic ?? '') })
}
