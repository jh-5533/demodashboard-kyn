import { NextResponse } from 'next/server'

export async function POST() {
  return NextResponse.json({
    subject: 'Trade Credit Insurance Solutions for Your Business',
    body: "Hi [Name],\n\nI came across your company and wanted to reach out about trade credit insurance solutions that could protect your receivables and support your growth.\n\nAt Trade Risk Solutions, we specialise in helping Singapore businesses manage buyer credit risk across Southeast Asia. Our clients typically see 85–90% of approved credit limits covered, with competitive premium rates starting from 0.25% of insured turnover.\n\nWould you be open to a 15-minute call to explore if this could be relevant to your business?\n\nBest regards,\nTrade Risk Solutions\n+65 6227 8988 | hello@trade-risksol.com",
  })
}
