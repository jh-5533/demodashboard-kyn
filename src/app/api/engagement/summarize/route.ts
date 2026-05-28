import { NextResponse } from 'next/server'

export async function POST() {
  return NextResponse.json({
    summary: 'The client has expressed interest in coverage and is awaiting a formal proposal. Key requirements have been noted and a specialist is preparing the submission.',
    next_action: 'Prepare and send tailored insurance proposal within 2 business days.',
    draft_reply: 'Thank you for the additional details. I will prepare a tailored proposal and have it with you by end of week.\n\nBest regards,\nTrade Risk Solutions',
  })
}
