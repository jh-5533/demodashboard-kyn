import { NextResponse } from 'next/server'
import { MOCK_OUTBOUND_HISTORY } from '@/lib/mock-data'

const MOCK_COMPANIES = [
  { id: 'c1', company_name: 'Pacific Rim Logistics', domain: 'pacrimlog.sg', linkedin_url: 'https://linkedin.com/company/pacrimlog', industry: 'Logistics', source_rank: 1 },
  { id: 'c2', company_name: 'Apex Marine Services', domain: 'apexmarine.sg', linkedin_url: 'https://linkedin.com/company/apexmarine', industry: 'Maritime', source_rank: 2 },
  { id: 'c3', company_name: 'SunBridge Capital', domain: 'sunbridgecap.sg', linkedin_url: 'https://linkedin.com/company/sunbridgecap', industry: 'Financial Services', source_rank: 3 },
]

const MOCK_PEOPLE = [
  { id: 'p1', full_name: 'Jonathan Lim', title: 'CFO', email: 'jonathan.lim@pacrimlog.sg', linkedin_url: 'https://linkedin.com/in/jonathan-lim-cfo' },
  { id: 'p2', full_name: 'Serena Tan', title: 'Operations Director', email: 'serena.tan@apexmarine.sg', linkedin_url: 'https://linkedin.com/in/serena-tan-ops' },
]

export async function GET(req: Request) {
  const id = new URL(req.url).searchParams.get('id')
  if (id) return NextResponse.json({ companies: MOCK_COMPANIES, people: MOCK_PEOPLE })
  return NextResponse.json(MOCK_OUTBOUND_HISTORY)
}
