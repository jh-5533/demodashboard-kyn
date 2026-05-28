import { NextResponse } from 'next/server'
import { MOCK_AUDIT_LOG } from '@/lib/mock-data'

export async function GET() {
  return NextResponse.json(MOCK_AUDIT_LOG)
}

export async function POST() {
  return NextResponse.json({ ok: true })
}
