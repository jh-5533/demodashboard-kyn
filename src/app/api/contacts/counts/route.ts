import { NextResponse } from 'next/server'
import { MOCK_CONTACT_COUNTS } from '@/lib/mock-data'

export async function GET() {
  return NextResponse.json(MOCK_CONTACT_COUNTS)
}
