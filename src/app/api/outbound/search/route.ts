import { NextResponse } from 'next/server'

const MOCK_PEOPLE = [
  { id: 'p1', full_name: 'Jonathan Lim', title: 'CFO', company: 'Pacific Rim Logistics', location: 'Singapore', linkedin_url: 'https://linkedin.com/in/jonathan-lim-cfo' },
  { id: 'p2', full_name: 'Serena Tan', title: 'Operations Director', company: 'Apex Marine Services', location: 'Singapore', linkedin_url: 'https://linkedin.com/in/serena-tan-ops' },
  { id: 'p3', full_name: 'Brandon Ho', title: 'CEO', company: 'SunBridge Capital', location: 'Singapore', linkedin_url: 'https://linkedin.com/in/brandon-ho-ceo' },
]

export async function POST() {
  return NextResponse.json({ items: MOCK_PEOPLE, total: MOCK_PEOPLE.length, page: 1 })
}
