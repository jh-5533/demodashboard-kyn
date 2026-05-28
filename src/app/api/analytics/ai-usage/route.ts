import { NextResponse } from 'next/server'
import { MOCK_AI_USAGE } from '@/lib/mock-data'

export async function GET() {
  return NextResponse.json(MOCK_AI_USAGE)
}
