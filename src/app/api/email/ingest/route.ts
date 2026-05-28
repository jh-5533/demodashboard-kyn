import { NextResponse } from 'next/server'

export async function GET() {
  return NextResponse.json({ ok: true, ingested: 0 })
}

export async function POST() {
  return NextResponse.json({ ok: true, ingested: 0 })
}
