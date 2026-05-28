import { NextRequest, NextResponse } from 'next/server'
import { MOCK_INBOUND_LEADS } from '@/lib/mock-data'

const leads = [...MOCK_INBOUND_LEADS]

export async function GET() {
  return NextResponse.json(leads)
}

export async function PATCH(req: NextRequest) {
  const { id, status } = await req.json()
  if (!id || !status) return NextResponse.json({ error: 'id and status required' }, { status: 400 })
  const lead = leads.find(l => l.id === id)
  if (lead) (lead as Record<string, unknown>).status = status
  return NextResponse.json({ ok: true })
}
