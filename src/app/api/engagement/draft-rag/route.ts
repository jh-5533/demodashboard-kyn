import { NextResponse } from 'next/server'

const MOCK_RAG_DRAFT = `Based on our knowledge base, here is a tailored draft response:

Thank you for your message. I have reviewed your requirements against our current product portfolio and market terms.

Based on the information provided, I can confirm that we have suitable coverage options available. I will prepare a formal proposal incorporating the specific limits and deductible structures that align with your risk profile.

You can expect the proposal in your inbox within 2 business days.

Best regards,
Trade Risk Solutions

[Sources: TRS_Product_Guide_2026.pdf, Trade_Credit_Underwriting_Guide.pdf]`

export async function POST() {
  return NextResponse.json({ id: `rag-draft-${Date.now()}`, content: MOCK_RAG_DRAFT, sources: [{ file_name: 'TRS_Product_Guide_2026.pdf', similarity: 0.91 }, { file_name: 'Trade_Credit_Underwriting_Guide.pdf', similarity: 0.84 }], created_at: new Date().toISOString() })
}

export async function GET() {
  return NextResponse.json(null)
}
