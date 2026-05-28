import { NextResponse } from 'next/server'
import { MOCK_RAG_INDEX } from '@/lib/mock-data'

export async function GET() {
  return NextResponse.json({ files: MOCK_RAG_INDEX, total_chunks: MOCK_RAG_INDEX.reduce((s, f) => s + f.chunks, 0) })
}

export async function POST() {
  return NextResponse.json({ ok: true, indexed: MOCK_RAG_INDEX.length, total_chunks: MOCK_RAG_INDEX.reduce((s, f) => s + f.chunks, 0) })
}
