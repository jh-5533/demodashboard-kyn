import { NextResponse } from 'next/server'

export async function POST() {
  return NextResponse.json({
    ok: true,
    id: `sum-${Date.now()}`,
    summary: 'Summary refreshed. The client is actively engaged in discussion regarding their insurance requirements. A proposal is being prepared based on their stated needs.',
    next_action: 'Follow up with formal quote by end of week.',
    draft_reply: 'Following up on our earlier conversation — I will have the proposal ready for your review shortly.\n\nBest regards,\nTrade Risk Solutions',
    created_at: new Date().toISOString(),
  })
}
