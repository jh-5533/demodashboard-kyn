import { NextRequest, NextResponse } from 'next/server'
import { MOCK_OUTBOUND_LEADS } from '@/lib/mock-data'

const leads = [...MOCK_OUTBOUND_LEADS]

export async function GET(req: NextRequest) {
  const urlsOnly = req.nextUrl.searchParams.get('urls') === 'true'
  if (urlsOnly) return NextResponse.json(leads.map(l => ({ linkedin_url: l.linkedin_url })))
  return NextResponse.json(leads)
}

export async function PATCH(req: NextRequest) {
  const { id, status, notes } = await req.json()
  const lead = leads.find(l => l.id === id) as Record<string, unknown> | undefined
  if (lead) {
    if (status !== undefined) lead.status = status
    if (notes !== undefined) lead.notes = notes
  }
  return NextResponse.json({ ok: true })
}
