import { NextRequest } from 'next/server'

export const maxDuration = 60

const DEMO_COMPANIES = [
  { name: 'Pacific Rim Logistics', domain: 'pacrimlog.sg', linkedin_url: 'https://linkedin.com/company/pacrimlog', industry: 'Logistics', size: '51-200 employees', location: 'Singapore' },
  { name: 'Apex Marine Services', domain: 'apexmarine.sg', linkedin_url: 'https://linkedin.com/company/apexmarine', industry: 'Maritime', size: '11-50 employees', location: 'Singapore' },
  { name: 'SunBridge Capital', domain: 'sunbridgecap.sg', linkedin_url: 'https://linkedin.com/company/sunbridgecap', industry: 'Financial Services', size: '11-50 employees', location: 'Singapore' },
  { name: 'CoreBuild Engineering', domain: 'corebuild.sg', linkedin_url: 'https://linkedin.com/company/corebuild', industry: 'Construction', size: '201-500 employees', location: 'Singapore' },
  { name: 'NovaTech Solutions', domain: 'novatech.sg', linkedin_url: 'https://linkedin.com/company/novatech', industry: 'Technology', size: '51-200 employees', location: 'Singapore' },
]

const DEMO_PEOPLE = [
  { full_name: 'Jonathan Lim', title: 'CFO', email: 'jonathan.lim@pacrimlog.sg', linkedin_url: 'https://linkedin.com/in/jonathan-lim-cfo' },
  { full_name: 'Serena Tan', title: 'Operations Director', email: 'serena.tan@apexmarine.sg', linkedin_url: 'https://linkedin.com/in/serena-tan-ops' },
  { full_name: 'Brandon Ho', title: 'CEO', email: 'brandon.ho@sunbridgecap.sg', linkedin_url: 'https://linkedin.com/in/brandon-ho-ceo' },
  { full_name: 'Jasmine Koh', title: 'Finance Director', email: 'jasmine.koh@corebuild.sg', linkedin_url: 'https://linkedin.com/in/jasmine-koh-fd' },
  { full_name: 'Michael Teo', title: 'COO', email: 'michael.teo@novatech.sg', linkedin_url: 'https://linkedin.com/in/michael-teo-coo' },
]

export async function POST(req: NextRequest) {
  const { query, roles, maxCompanies } = await req.json().catch(() => ({}))
  const encoder = new TextEncoder()
  const limit = Math.min(maxCompanies ?? 5, DEMO_COMPANIES.length)

  const stream = new ReadableStream({
    async start(controller) {
      function emit(data: unknown) {
        controller.enqueue(encoder.encode(`data: ${JSON.stringify(data)}\n\n`))
      }

      emit({ type: 'status', message: `Searching for companies matching "${query ?? 'your criteria'}"...` })
      await new Promise(r => setTimeout(r, 600))

      for (let i = 0; i < limit; i++) {
        const company = DEMO_COMPANIES[i]
        emit({ type: 'company_found', company })
        await new Promise(r => setTimeout(r, 400))

        if (DEMO_PEOPLE[i] && roles) {
          const person = { ...DEMO_PEOPLE[i], company: company.name }
          emit({ type: 'person_found', person, company: company.name })
          await new Promise(r => setTimeout(r, 300))
          emit({ type: 'person_saved', person: { ...person, id: `ob-demo-${i}` } })
        }
        await new Promise(r => setTimeout(r, 200))
      }

      emit({ type: 'done', saved: limit })
      controller.close()
    },
  })

  return new Response(stream, {
    headers: { 'Content-Type': 'text/event-stream', 'Cache-Control': 'no-cache', Connection: 'keep-alive' },
  })
}
