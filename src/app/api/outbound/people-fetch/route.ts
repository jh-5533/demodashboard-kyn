import { NextResponse } from 'next/server'

export async function POST() {
  return NextResponse.json([
    { id: 'pf1', full_name: 'Alice Tan', title: 'CFO', linkedin_url: 'https://linkedin.com/in/alice-tan-demo', email_status: 'verified' },
    { id: 'pf2', full_name: 'Brian Lim', title: 'CEO', linkedin_url: 'https://linkedin.com/in/brian-lim-demo', email_status: 'guessed' },
    { id: 'pf3', full_name: 'Carol Ho', title: 'Operations Director', linkedin_url: 'https://linkedin.com/in/carol-ho-demo', email_status: 'not_found' },
  ])
}
