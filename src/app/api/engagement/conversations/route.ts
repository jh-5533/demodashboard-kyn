import { NextResponse } from 'next/server'
import { MOCK_CONVERSATIONS } from '@/lib/mock-data'

export async function GET() {
  return NextResponse.json(MOCK_CONVERSATIONS)
}
