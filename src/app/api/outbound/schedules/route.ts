import { NextRequest, NextResponse } from 'next/server'
import { MOCK_OUTBOUND_SCHEDULES } from '@/lib/mock-data'

const schedules = [...MOCK_OUTBOUND_SCHEDULES] as Array<Record<string, unknown>>

export async function GET() {
  return NextResponse.json(schedules)
}

export async function POST(req: NextRequest) {
  const body = await req.json()
  const newSched = { id: `sched-${Date.now()}`, ...body, is_active: true, runs_count: 0, next_run_at: new Date(Date.now() + 86400000).toISOString(), last_run_at: null, created_at: new Date().toISOString() }
  schedules.unshift(newSched)
  return NextResponse.json([newSched])
}

export async function PATCH(req: NextRequest) {
  const { id, is_active } = await req.json()
  const sched = schedules.find(s => s.id === id)
  if (sched) sched.is_active = is_active
  return NextResponse.json({ ok: true })
}

export async function DELETE(req: NextRequest) {
  const { id } = await req.json()
  const idx = schedules.findIndex(s => s.id === id)
  if (idx !== -1) schedules.splice(idx, 1)
  return NextResponse.json({ ok: true })
}
