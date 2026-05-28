import { NextResponse } from 'next/server'

export async function POST() {
  return NextResponse.json({ email: 'demo.contact@example.sg', status: 'verified' })
}
