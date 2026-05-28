import { NextResponse } from 'next/server'

export async function POST() {
  return NextResponse.json({
    companies: [
      { name: 'Pacific Rim Logistics', domain: 'pacrimlog.sg', relevance: 'High — logistics company matching search criteria' },
      { name: 'Apex Marine Services', domain: 'apexmarine.sg', relevance: 'High — marine services with trade exposure' },
      { name: 'CoreBuild Engineering', domain: 'corebuild.sg', relevance: 'Medium — construction firm with supplier credit needs' },
    ],
  })
}
