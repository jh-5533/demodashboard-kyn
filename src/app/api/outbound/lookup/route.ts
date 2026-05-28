import { NextResponse } from 'next/server'

export async function POST() {
  return NextResponse.json({
    id: 'demo-lookup',
    full_name: 'Demo Contact',
    title: 'CFO',
    company: 'Demo Company Pte Ltd',
    location: 'Singapore',
    linkedin_url: 'https://linkedin.com/in/demo',
    headline: 'CFO at Demo Company | Finance & Risk Management',
  })
}
