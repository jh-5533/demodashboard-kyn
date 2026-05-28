-- =============================================================================
-- KYN Demo Dashboard — Seed Data
-- Singapore B2B insurance brokerage demo data
-- Run this in your Supabase SQL editor (after applying full_schema.sql)
-- =============================================================================

-- thread_summaries table (not in exported schema but used by engagement agent)
CREATE TABLE IF NOT EXISTS "public"."thread_summaries" (
    "id"          uuid DEFAULT gen_random_uuid() NOT NULL,
    "thread_id"   uuid NOT NULL,
    "summary"     text,
    "next_action" text,
    "draft_reply" text,
    "created_at"  timestamp with time zone DEFAULT now(),
    CONSTRAINT "thread_summaries_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "thread_summaries_thread_id_fkey"
        FOREIGN KEY ("thread_id") REFERENCES "public"."email_threads"("id") ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS "idx_thread_summaries_thread_id"
    ON "public"."thread_summaries" ("thread_id");

-- gemini_usage_log table (used by AI cost tracking)
CREATE TABLE IF NOT EXISTS "public"."gemini_usage_log" (
    "id"            uuid DEFAULT gen_random_uuid() NOT NULL,
    "feature"       text NOT NULL,
    "input_tokens"  bigint DEFAULT 0,
    "output_tokens" bigint DEFAULT 0,
    "cost_usd"      numeric(12,8) DEFAULT 0,
    "thread_id"     uuid,
    "metadata"      jsonb,
    "created_at"    timestamp with time zone DEFAULT now(),
    CONSTRAINT "gemini_usage_log_pkey" PRIMARY KEY ("id")
);

-- =============================================================================
-- 1. COMPANIES
-- =============================================================================

INSERT INTO companies (id, name, domain, type, industry, address, notes, created_at)
VALUES
  ('11111111-1111-1111-1111-111111111001',
   'Meridian Logistics Pte Ltd',
   'meridianlogistics.com.sg',
   'sme',
   'Logistics & Supply Chain',
   '18 Tuas South Avenue 2, Singapore 637461',
   'Fleet of 45 trucks, ~60 foreign workers on payroll. Existing customer since 2023.',
   now() - interval '14 months'),

  ('11111111-1111-1111-1111-111111111002',
   'Vertex Technology Solutions Pte Ltd',
   'vertextech.sg',
   'sme',
   'Information Technology',
   '1 Fusionopolis Way, #08-11 Connexis North, Singapore 138632',
   'SaaS company, 38 employees. Handles PII and financial data for 200+ enterprise clients. Cyber risk is high priority.',
   now() - interval '8 months'),

  ('11111111-1111-1111-1111-111111111003',
   'SingHealth Systems Pte Ltd',
   'singhealthsystems.sg',
   'corporate',
   'Healthcare',
   '20 College Road, Academia, Singapore 169856',
   'Private hospital group operating 3 specialist clinics. Needs medical malpractice and PI coverage.',
   now() - interval '5 months'),

  ('11111111-1111-1111-1111-111111111004',
   'Pacific Construction Group Pte Ltd',
   'pacificconst.com.sg',
   'corporate',
   'Construction',
   '2 Tanjong Pagar Plaza, #07-03, Singapore 082002',
   'BCA Grade A1 contractor. ~120 workers on active sites. Property and workmen compensation are core needs.',
   now() - interval '20 months'),

  ('11111111-1111-1111-1111-111111111005',
   'Pinnacle Financial Advisors Pte Ltd',
   'pinnaclefa.sg',
   'institution',
   'Financial Services',
   '6 Shenton Way, #22-08 OUE Downtown 1, Singapore 068809',
   'MAS-licensed financial advisory firm. 12 financial advisers. PI and D&O cover required annually.',
   now() - interval '3 months');

-- =============================================================================
-- 2. CONTACTS (insert without inbound_lead_id first to avoid circular FK)
-- =============================================================================

INSERT INTO contacts (id, full_name, email, phone, source, engagement_stage, notes, tags, created_at)
VALUES
  ('22222222-2222-2222-2222-222222222001',
   'Lim Wei Jian',
   'weijian.lim@meridianlogistics.com.sg',
   '+6591234001',
   'email',
   'converted',
   'COO at Meridian. Primary decision-maker for all insurance. Prefers quick email responses.',
   ARRAY['converted','logistics','decision_maker'],
   now() - interval '14 months'),

  ('22222222-2222-2222-2222-222222222002',
   'Priya Nair',
   'priya.nair@vertextech.sg',
   '+6581234002',
   'email',
   'proposal',
   'Head of Finance at Vertex. Evaluating cyber insurance after a phishing incident last quarter.',
   ARRAY['prospect','tech','cyber'],
   now() - interval '8 months'),

  ('22222222-2222-2222-2222-222222222003',
   'Dr Ahmad Faizal bin Ismail',
   'ahmad.faizal@singhealthsystems.sg',
   '+6591234003',
   'email',
   'qualified',
   'Chief Medical Officer. Personally involved in malpractice claim review. Urgent renewal needed.',
   ARRAY['healthcare','pi','urgent'],
   now() - interval '5 months'),

  ('22222222-2222-2222-2222-222222222004',
   'Tan Boon Huat',
   'boonhuat.tan@pacificconst.com.sg',
   '+6581234004',
   'email',
   'converted',
   'GM Operations at Pacific. Long-term relationship since 2021. Annual renewal due in July.',
   ARRAY['converted','construction','renewal'],
   now() - interval '20 months'),

  ('22222222-2222-2222-2222-222222222005',
   'Chua Jing Wen',
   'jingwen.chua@pinnaclefa.sg',
   '+6591234005',
   'email',
   'qualified',
   'Compliance Manager. Sourcing PI cover for the first time after MAS audit flagged a gap.',
   ARRAY['financial','pi','compliance'],
   now() - interval '3 months'),

  ('22222222-2222-2222-2222-222222222006',
   'Marcus Lee Zhi Hao',
   'marcus.lee@gmail.com',
   '+6581234006',
   'whatsapp',
   'engaged',
   'SME owner in F&B. Enquired via WhatsApp about fire insurance for warehouse. Follow-up pending.',
   ARRAY['sme','property','whatsapp'],
   now() - interval '12 days'),

  ('22222222-2222-2222-2222-222222222007',
   'Siti Rahimah binte Yusof',
   'siti.rahimah@nimbusretail.sg',
   '+6591234007',
   'website',
   'engaged',
   'HR Manager at Nimbus Retail. Filled in website form for foreign worker levy insurance.',
   ARRAY['sme','foreign_worker','website'],
   now() - interval '6 days');

-- =============================================================================
-- 3. COMPANY ↔ CONTACT LINKS
-- =============================================================================

INSERT INTO company_contacts (id, company_id, contact_id, role, is_primary, created_at)
VALUES
  ('77777777-7777-7777-7777-777777777001',
   '11111111-1111-1111-1111-111111111001',
   '22222222-2222-2222-2222-222222222001',
   'decision_maker', true, now() - interval '14 months'),

  ('77777777-7777-7777-7777-777777777002',
   '11111111-1111-1111-1111-111111111002',
   '22222222-2222-2222-2222-222222222002',
   'decision_maker', true, now() - interval '8 months'),

  ('77777777-7777-7777-7777-777777777003',
   '11111111-1111-1111-1111-111111111003',
   '22222222-2222-2222-2222-222222222003',
   'decision_maker', true, now() - interval '5 months'),

  ('77777777-7777-7777-7777-777777777004',
   '11111111-1111-1111-1111-111111111004',
   '22222222-2222-2222-2222-222222222004',
   'decision_maker', true, now() - interval '20 months'),

  ('77777777-7777-7777-7777-777777777005',
   '11111111-1111-1111-1111-111111111005',
   '22222222-2222-2222-2222-222222222005',
   'decision_maker', true, now() - interval '3 months');

-- =============================================================================
-- 4. INBOUND LEADS
-- =============================================================================

INSERT INTO inbound_leads (id, contact_id, company_id, source, first_name, last_name, email, phone,
  company, contact_type, topic, details, message, status, created_at)
VALUES
  ('33333333-3333-3333-3333-333333333001',
   NULL, NULL,
   'whatsapp_click',
   'Kevin', 'Goh',
   'kevin.goh@horisontech.sg', '+6591230011',
   'Horison Technologies', 'decision_maker',
   'Cyber Insurance',
   'Small IT firm (~20 pax). First time buying cyber cover. Asking about ransomware protection.',
   'Hi, I found your number on Google. We are a small IT company and want to know more about cyber insurance coverage and pricing.',
   'new',
   now() - interval '2 days'),

  ('33333333-3333-3333-3333-333333333002',
   '22222222-2222-2222-2222-222222222007',
   NULL,
   'website_form',
   'Siti Rahimah', 'Yusof',
   'siti.rahimah@nimbusretail.sg', '+6591234007',
   'Nimbus Retail Pte Ltd', 'hr_manager',
   'Foreign Worker Levy Insurance',
   'Currently has 35 foreign workers on S-Pass and Work Permit. Existing policy with NTUC expiring next month.',
   'We need to renew our foreign worker levy insurance. Our current policy expires end of June and we have 35 workers.',
   'engaged',
   now() - interval '6 days'),

  ('33333333-3333-3333-3333-333333333003',
   '22222222-2222-2222-2222-222222222006',
   NULL,
   'whatsapp_click',
   'Marcus', 'Lee',
   'marcus.lee@gmail.com', '+6581234006',
   NULL, 'business_owner',
   'Property / Fire Insurance',
   'Warehouse in Jurong, 3000 sqm. Contents worth ~$500k. Looking for fire + flood coverage.',
   'I have a warehouse I want to insure against fire and flooding. Can you help me?',
   'engaged',
   now() - interval '12 days'),

  ('33333333-3333-3333-3333-333333333004',
   NULL, NULL,
   'website_form',
   'Raymond', 'Chia',
   'raymond.chia@crestlogistics.sg', '+6581230044',
   'Crest Logistics Pte Ltd', 'cfo',
   'Workmen Compensation',
   'Fleet of 30 drivers + 15 warehouse staff. Previous insurer raised premium 22%. Shopping for better rate.',
   'Looking for workmen compensation insurance for our logistics operations. Current insurer increased premium significantly this year.',
   'qualified',
   now() - interval '18 days'),

  ('33333333-3333-3333-3333-333333333005',
   NULL, NULL,
   'email',
   'Ng', 'Pei Shan',
   'peishan.ng@brightclinic.sg', '+6591230055',
   'Bright Family Clinic', 'practice_manager',
   'Medical Malpractice',
   'GP clinic, 2 doctors. Never had malpractice cover. Prompted by a patient complaint last month.',
   NULL,
   'contacted',
   now() - interval '9 days'),

  ('33333333-3333-3333-3333-333333333006',
   NULL, NULL,
   'website_form',
   'Darren', 'Woo',
   'darren.woo@impactmedia.sg', '+6581230066',
   'Impact Media Pte Ltd', 'director',
   'Professional Indemnity',
   'Digital marketing agency, 8 staff. Client suing for missed campaign deliverables. Wants PI urgently.',
   'We need professional indemnity insurance urgently. We have a potential legal dispute with a client.',
   'new',
   now() - interval '1 day');

-- Update contacts to link inbound leads (avoiding circular insert)
UPDATE contacts
SET inbound_lead_id = '33333333-3333-3333-3333-333333333003'
WHERE id = '22222222-2222-2222-2222-222222222006';

UPDATE contacts
SET inbound_lead_id = '33333333-3333-3333-3333-333333333002'
WHERE id = '22222222-2222-2222-2222-222222222007';

-- =============================================================================
-- 5. CUSTOMERS (converted accounts)
-- =============================================================================

INSERT INTO customers (id, type, contact_id, company_id, account_manager, status, customer_since, notes, created_at)
VALUES
  ('44444444-4444-4444-4444-444444444001',
   'company',
   '22222222-2222-2222-2222-222222222001',
   '11111111-1111-1111-1111-111111111001',
   'Sarah Tan',
   'active',
   '2023-03-15',
   'Long-term client. Paid on time every year. Good referral source.',
   now() - interval '14 months'),

  ('44444444-4444-4444-4444-444444444002',
   'company',
   '22222222-2222-2222-2222-222222222002',
   '11111111-1111-1111-1111-111111111002',
   'James Ho',
   'active',
   '2024-09-01',
   'New client from 2024. High-value cyber portfolio. Upsell opportunity for D&O.',
   now() - interval '8 months'),

  ('44444444-4444-4444-4444-444444444003',
   'company',
   '22222222-2222-2222-2222-222222222004',
   '11111111-1111-1111-1111-111111111004',
   'Sarah Tan',
   'renewal_due',
   '2021-07-01',
   'Property policy up for renewal in July 2026. Workmen comp renewed in April. Strong relationship.',
   now() - interval '20 months');

-- =============================================================================
-- 6. DEALS
-- =============================================================================

INSERT INTO deals (id, customer_id, title, product_type, stage, value_estimate, close_date_estimate, notes, created_at)
VALUES
  ('55555555-5555-5555-5555-555555555001',
   '44444444-4444-4444-4444-444444444001',
   'Meridian — Foreign Worker Levy Renewal FY2026',
   'foreign_worker',
   'negotiation',
   18500.00,
   '2026-06-15',
   'Renewal of 60 FW policy. NTUC currently offering counter-quote. Need to match or beat by 5%.',
   now() - interval '3 weeks'),

  ('55555555-5555-5555-5555-555555555002',
   '44444444-4444-4444-4444-444444444002',
   'Vertex — Cyber Insurance (New)',
   'cyber',
   'proposal',
   24000.00,
   '2026-06-30',
   'First cyber policy. Sent Chubb and AIG quotes. Awaiting Priya sign-off after board approval.',
   now() - interval '6 weeks'),

  ('55555555-5555-5555-5555-555555555003',
   '44444444-4444-4444-4444-444444444002',
   'Vertex — Group Medical Benefits',
   'medical',
   'discovery',
   32000.00,
   '2026-08-31',
   'Secondary opportunity. Priya mentioned current group medical is with AIA expiring in Sept.',
   now() - interval '3 weeks'),

  ('55555555-5555-5555-5555-555555555004',
   '44444444-4444-4444-4444-444444444003',
   'Pacific — Commercial Property Renewal FY2026',
   'property',
   'negotiation',
   45000.00,
   '2026-07-31',
   'Three active construction sites. Sum insured $12M. MSIG is incumbent; also quoting Tokio Marine.',
   now() - interval '8 weeks'),

  ('55555555-5555-5555-5555-555555555005',
   '44444444-4444-4444-4444-444444444003',
   'Pacific — Workmen Compensation Renewal FY2026',
   'workmen',
   'closed_won',
   21000.00,
   '2026-04-30',
   'Renewed with QBE. 120 workers. Clean claims record secured a 3% discount.',
   now() - interval '4 weeks');

-- =============================================================================
-- 7. EMAIL THREADS
-- =============================================================================

INSERT INTO email_threads (id, gmail_thread_id, customer_id, deal_id, contact_id, subject, snippet,
  last_message_at, message_count, status, created_at)
VALUES
  ('66666666-6666-6666-6666-666666666001',
   'DEMO_GMAIL_THREAD_001',
   '44444444-4444-4444-4444-444444444002',
   '55555555-5555-5555-5555-555555555002',
   '22222222-2222-2222-2222-222222222002',
   'Re: Cyber Insurance Quotation — Vertex Technology Solutions',
   'Thank you for sending over the Chubb and AIG quotes. I have reviewed both and have a few questions before presenting to the board...',
   now() - interval '2 days',
   3,
   'active',
   now() - interval '3 weeks'),

  ('66666666-6666-6666-6666-666666666002',
   'DEMO_GMAIL_THREAD_002',
   '44444444-4444-4444-4444-444444444003',
   '55555555-5555-5555-5555-555555555004',
   '22222222-2222-2222-2222-222222222004',
   'Re: Commercial Property Renewal — Pacific Construction Group',
   'Hi James, we have reviewed the MSIG renewal terms. The premium increase of 12% is higher than expected given our clean claims...',
   now() - interval '1 day',
   4,
   'active',
   now() - interval '8 weeks'),

  ('66666666-6666-6666-6666-666666666003',
   'DEMO_GMAIL_THREAD_003',
   NULL,
   NULL,
   '22222222-2222-2222-2222-222222222005',
   'Professional Indemnity Insurance — Initial Enquiry',
   'Dear Trade Risk, my name is Chua Jing Wen from Pinnacle Financial Advisors. We are seeking PI coverage following a recent MAS audit...',
   now() - interval '3 days',
   2,
   'active',
   now() - interval '3 months'),

  ('66666666-6666-6666-6666-666666666004',
   'DEMO_GMAIL_THREAD_004',
   NULL,
   NULL,
   '22222222-2222-2222-2222-222222222003',
   'Medical Malpractice Coverage — SingHealth Systems',
   'Hi, following our phone call last week, I have compiled the details of our three clinics as requested. Please find attached our claims history...',
   now() - interval '4 days',
   3,
   'active',
   now() - interval '5 months');

-- =============================================================================
-- 8. EMAIL MESSAGES
-- =============================================================================

-- Thread 1: Cyber Insurance (Vertex)
INSERT INTO email_messages (id, thread_id, gmail_message_id, direction, from_address, subject, body_text, sent_at)
VALUES
  ('88888888-8888-8888-8888-888888888101',
   '66666666-6666-6666-6666-666666666001',
   'DEMO_MSG_101',
   'inbound',
   'priya.nair@vertextech.sg',
   'Cyber Insurance Enquiry — Vertex Technology Solutions',
   'Hi Trade Risk team,

My name is Priya Nair, Head of Finance at Vertex Technology Solutions. We are a SaaS company handling financial data for enterprise clients and we recently had a phishing incident that fortunately did not result in a breach, but it has highlighted that we do not have cyber insurance.

We have about 38 employees and handle PII and financial data for over 200 clients. Could you advise on the type of coverage we should look at and provide a ballpark premium range?

Thank you,
Priya Nair
Head of Finance | Vertex Technology Solutions
T: +65 8123 4002',
   now() - interval '3 weeks'),

  ('88888888-8888-8888-8888-888888888102',
   '66666666-6666-6666-6666-666666666001',
   'DEMO_MSG_102',
   'outbound',
   'james.ho@traderisksol.com',
   'Re: Cyber Insurance Enquiry — Vertex Technology Solutions',
   'Dear Priya,

Thank you for reaching out. Given Vertex''s profile — SaaS provider handling PII and financial data — a standalone Cyber Liability policy would be the most appropriate coverage.

I have prepared quotes from two leading insurers:

1. Chubb CyberEdge — S$24,000/year
   • Limit: S$2M per occurrence
   • Covers: data breach response, ransomware, business interruption, third-party liability

2. AIG CyberEdge — S$21,500/year
   • Limit: S$1.5M per occurrence
   • Slightly narrower third-party liability sublimit

I recommend Chubb for the broader coverage given your client data exposure. I am happy to walk through the policy wordings in a call.

Best regards,
James Ho
Trade Risk Solutions
T: +65 6234 5678',
   now() - interval '2 weeks'),

  ('88888888-8888-8888-8888-888888888103',
   '66666666-6666-6666-6666-666666666001',
   'DEMO_MSG_103',
   'inbound',
   'priya.nair@vertextech.sg',
   'Re: Cyber Insurance Quotation — Vertex Technology Solutions',
   'Hi James,

Thank you for sending over the Chubb and AIG quotes. I have reviewed both and have a few questions before presenting to the board next Friday:

1. Does the Chubb policy cover incidents originating from a third-party vendor (e.g., our cloud hosting provider)?
2. Is there a waiting period for business interruption claims?
3. Can the limit be increased to S$3M and what would the premium adjustment be?

Could you also send over the full policy wording for Chubb?

Thanks,
Priya',
   now() - interval '2 days');

-- Thread 2: Property Renewal (Pacific)
INSERT INTO email_messages (id, thread_id, gmail_message_id, direction, from_address, subject, body_text, sent_at)
VALUES
  ('88888888-8888-8888-8888-888888888201',
   '66666666-6666-6666-6666-666666666002',
   'DEMO_MSG_201',
   'outbound',
   'sarah.tan@traderisksol.com',
   'Commercial Property Renewal — Pacific Construction Group FY2026',
   'Dear Boon Huat,

I hope you are well. Your commercial property policy with MSIG is due for renewal on 31 July 2026.

MSIG has provided their renewal terms:
• Sum insured: S$12,000,000 (same as current)
• Premium: S$47,700 (increase of 12% from S$42,600 last year)
• Note: MSIG has applied a loading due to increased construction activity in the sector

I am also obtaining a competitive quote from Tokio Marine. I will revert by end of this week with a full comparison.

Warm regards,
Sarah Tan
Trade Risk Solutions',
   now() - interval '7 weeks'),

  ('88888888-8888-8888-8888-888888888202',
   '66666666-6666-6666-6666-666666666002',
   'DEMO_MSG_202',
   'inbound',
   'boonhuat.tan@pacificconst.com.sg',
   'Re: Commercial Property Renewal — Pacific Construction Group FY2026',
   'Hi Sarah,

Thanks for the heads up. A 12% increase is quite steep — we have had zero claims in the past 3 years. Please do get the Tokio Marine quote and let us see if we can negotiate MSIG down.

Also, can you clarify whether the current policy covers our new site at Tengah Industrial Estate? We broke ground there last month.

Best,
Boon Huat',
   now() - interval '6 weeks'),

  ('88888888-8888-8888-8888-888888888203',
   '66666666-6666-6666-6666-666666666002',
   'DEMO_MSG_203',
   'outbound',
   'sarah.tan@traderisksol.com',
   'Re: Commercial Property Renewal — Pacific Construction Group FY2026',
   'Dear Boon Huat,

Good news — Tokio Marine came back with a competitive quote of S$44,200 for the same S$12M sum insured, which is only a 3.8% increase. I have also confirmed with MSIG that the Tengah site is covered under the blanket "any location" clause in your current policy.

I have put together a side-by-side comparison:

                MSIG (Renewal)    Tokio Marine
Premium         S$47,700          S$44,200
Sum Insured     S$12M             S$12M
BI Cover        12 months         12 months
Deductible      S$5,000           S$7,500 (Tengah only)

I recommend Tokio Marine unless you have a preference to stay with MSIG. Please let me know and I will proceed with binding.

Regards,
Sarah',
   now() - interval '3 weeks'),

  ('88888888-8888-8888-8888-888888888204',
   '66666666-6666-6666-6666-666666666002',
   'DEMO_MSG_204',
   'inbound',
   'boonhuat.tan@pacificconst.com.sg',
   'Re: Commercial Property Renewal — Pacific Construction Group FY2026',
   'Hi Sarah,

Thank you for the comparison. The Tokio Marine offer looks good. We are comfortable with the higher deductible for Tengah — that site has very new equipment.

Please go ahead with Tokio Marine. I will need the cover note by 15 July at the latest for our bank''s documentation.

Boon Huat',
   now() - interval '1 day');

-- Thread 3: Professional Indemnity (Pinnacle Financial)
INSERT INTO email_messages (id, thread_id, gmail_message_id, direction, from_address, subject, body_text, sent_at)
VALUES
  ('88888888-8888-8888-8888-888888888301',
   '66666666-6666-6666-6666-666666666003',
   'DEMO_MSG_301',
   'inbound',
   'jingwen.chua@pinnaclefa.sg',
   'Professional Indemnity Insurance — Initial Enquiry',
   'Dear Trade Risk,

My name is Chua Jing Wen, Compliance Manager at Pinnacle Financial Advisors. We are a MAS-licensed financial advisory firm with 12 representatives.

Following a recent MAS audit, we have been advised to obtain Professional Indemnity insurance. We do not currently hold any PI cover. Could you advise on what is required for MAS compliance and provide a quote?

Our AUM is approximately S$180 million.

Thank you,
Jing Wen Chua
Compliance Manager | Pinnacle Financial Advisors Pte Ltd',
   now() - interval '3 months'),

  ('88888888-8888-8888-8888-888888888302',
   '66666666-6666-6666-6666-666666666003',
   'DEMO_MSG_302',
   'outbound',
   'james.ho@traderisksol.com',
   'Re: Professional Indemnity Insurance — Initial Enquiry',
   'Dear Jing Wen,

Thank you for reaching out. For MAS-licensed financial advisers, PI insurance is indeed a compliance requirement under the Financial Advisers Act.

Based on your AUM of S$180M and 12 FAR, I would recommend:

• Coverage limit: S$2,000,000 per claim / S$4,000,000 aggregate
• Estimated annual premium: S$8,500 – S$11,000 (subject to full proposal form)
• Retroactive date: we should apply for a retroactive date to protect against prior acts

I will send you a proposal form from QBE and Zurich. Completion typically takes 2-3 business days and we can bind within a week.

Given the MAS timeline, I suggest we prioritise this. Would you be available for a 30-minute call this week?

Best,
James Ho',
   now() - interval '3 days');

-- Thread 4: Medical Malpractice (SingHealth)
INSERT INTO email_messages (id, thread_id, gmail_message_id, direction, from_address, subject, body_text, sent_at)
VALUES
  ('88888888-8888-8888-8888-888888888401',
   '66666666-6666-6666-6666-666666666004',
   'DEMO_MSG_401',
   'inbound',
   'ahmad.faizal@singhealthsystems.sg',
   'Medical Malpractice Coverage — SingHealth Systems',
   'Dear Trade Risk,

Following our phone call last week, I have compiled the details of our three specialist clinics as requested. Please find details below:

1. SingHealth Orthopaedic Centre — 2 surgeons, 1 anaesthetist
2. SingHealth Cardiology Clinic — 1 cardiologist, 1 specialist nurse
3. SingHealth Women''s Health — 2 OBGYNs

Total consults last year: approximately 8,400. We have had 2 minor patient complaints in the past 3 years, both resolved without legal action.

Please advise on appropriate coverage limits and premium estimate.

Dr Ahmad Faizal
Chief Medical Officer | SingHealth Systems Pte Ltd',
   now() - interval '3 weeks'),

  ('88888888-8888-8888-8888-888888888402',
   '66666666-6666-6666-6666-666666666004',
   'DEMO_MSG_402',
   'outbound',
   'james.ho@traderisksol.com',
   'Re: Medical Malpractice Coverage — SingHealth Systems',
   'Dear Dr Ahmad,

Thank you for the detailed brief. Based on the clinical profile provided, I recommend the following:

Medical Malpractice Policy (Claims-Made Basis):
• Limit: S$5,000,000 per claim / S$10,000,000 aggregate
• Covers: negligence, errors, omissions by all named medical practitioners
• Run-off tail: 5 years post-policy expiry (critical given claims-made trigger)
• Estimated annual premium: S$28,000 – S$36,000 depending on insurer

I will be approaching AIG, Chubb, and QBE. To complete the proposal forms, I will need:
1. Curriculum vitae of each named practitioner
2. Details of the 2 complaints (nature + resolution)
3. Copy of your current professional registration certificates

Could your team compile these within the week? I can have quotes ready within 10 days.

Best,
James Ho',
   now() - interval '2 weeks'),

  ('88888888-8888-8888-8888-888888888403',
   '66666666-6666-6666-6666-666666666004',
   'DEMO_MSG_403',
   'inbound',
   'ahmad.faizal@singhealthsystems.sg',
   'Re: Medical Malpractice Coverage — SingHealth Systems',
   'Hi James,

We are compiling the documents. I should have everything ready by end of this week.

One follow-up question: if one of our surgeons leaves the practice mid-policy, can their name be removed and the premium adjusted? We have one surgeon considering retirement in Q4.

Also, our board would like to understand if the tail coverage can be purchased separately if we decide to close one clinic.

Dr Ahmad',
   now() - interval '4 days');

-- =============================================================================
-- 9. EMAIL PARTICIPANTS
-- =============================================================================

-- Thread 1 participants
INSERT INTO email_participants (id, thread_id, message_id, email, name, role, contact_id)
VALUES
  ('99999999-9999-9999-9999-999999999101',
   '66666666-6666-6666-6666-666666666001',
   '88888888-8888-8888-8888-888888888101',
   'priya.nair@vertextech.sg', 'Priya Nair', 'from',
   '22222222-2222-2222-2222-222222222002'),

  ('99999999-9999-9999-9999-999999999102',
   '66666666-6666-6666-6666-666666666001',
   '88888888-8888-8888-8888-888888888101',
   'james.ho@traderisksol.com', 'James Ho', 'to', NULL),

  ('99999999-9999-9999-9999-999999999103',
   '66666666-6666-6666-6666-666666666001',
   '88888888-8888-8888-8888-888888888102',
   'james.ho@traderisksol.com', 'James Ho', 'from', NULL),

  ('99999999-9999-9999-9999-999999999104',
   '66666666-6666-6666-6666-666666666001',
   '88888888-8888-8888-8888-888888888102',
   'priya.nair@vertextech.sg', 'Priya Nair', 'to',
   '22222222-2222-2222-2222-222222222002'),

  ('99999999-9999-9999-9999-999999999105',
   '66666666-6666-6666-6666-666666666001',
   '88888888-8888-8888-8888-888888888103',
   'priya.nair@vertextech.sg', 'Priya Nair', 'from',
   '22222222-2222-2222-2222-222222222002'),

  ('99999999-9999-9999-9999-999999999106',
   '66666666-6666-6666-6666-666666666001',
   '88888888-8888-8888-8888-888888888103',
   'james.ho@traderisksol.com', 'James Ho', 'to', NULL);

-- Thread 2 participants
INSERT INTO email_participants (id, thread_id, message_id, email, name, role, contact_id)
VALUES
  ('99999999-9999-9999-9999-999999999201',
   '66666666-6666-6666-6666-666666666002',
   '88888888-8888-8888-8888-888888888201',
   'sarah.tan@traderisksol.com', 'Sarah Tan', 'from', NULL),

  ('99999999-9999-9999-9999-999999999202',
   '66666666-6666-6666-6666-666666666002',
   '88888888-8888-8888-8888-888888888201',
   'boonhuat.tan@pacificconst.com.sg', 'Tan Boon Huat', 'to',
   '22222222-2222-2222-2222-222222222004'),

  ('99999999-9999-9999-9999-999999999203',
   '66666666-6666-6666-6666-666666666002',
   '88888888-8888-8888-8888-888888888202',
   'boonhuat.tan@pacificconst.com.sg', 'Tan Boon Huat', 'from',
   '22222222-2222-2222-2222-222222222004'),

  ('99999999-9999-9999-9999-999999999204',
   '66666666-6666-6666-6666-666666666002',
   '88888888-8888-8888-8888-888888888202',
   'sarah.tan@traderisksol.com', 'Sarah Tan', 'to', NULL),

  ('99999999-9999-9999-9999-999999999205',
   '66666666-6666-6666-6666-666666666002',
   '88888888-8888-8888-8888-888888888203',
   'sarah.tan@traderisksol.com', 'Sarah Tan', 'from', NULL),

  ('99999999-9999-9999-9999-999999999206',
   '66666666-6666-6666-6666-666666666002',
   '88888888-8888-8888-8888-888888888203',
   'boonhuat.tan@pacificconst.com.sg', 'Tan Boon Huat', 'to',
   '22222222-2222-2222-2222-222222222004'),

  ('99999999-9999-9999-9999-999999999207',
   '66666666-6666-6666-6666-666666666002',
   '88888888-8888-8888-8888-888888888204',
   'boonhuat.tan@pacificconst.com.sg', 'Tan Boon Huat', 'from',
   '22222222-2222-2222-2222-222222222004'),

  ('99999999-9999-9999-9999-999999999208',
   '66666666-6666-6666-6666-666666666002',
   '88888888-8888-8888-8888-888888888204',
   'sarah.tan@traderisksol.com', 'Sarah Tan', 'to', NULL);

-- Thread 3 participants
INSERT INTO email_participants (id, thread_id, message_id, email, name, role, contact_id)
VALUES
  ('99999999-9999-9999-9999-999999999301',
   '66666666-6666-6666-6666-666666666003',
   '88888888-8888-8888-8888-888888888301',
   'jingwen.chua@pinnaclefa.sg', 'Chua Jing Wen', 'from',
   '22222222-2222-2222-2222-222222222005'),

  ('99999999-9999-9999-9999-999999999302',
   '66666666-6666-6666-6666-666666666003',
   '88888888-8888-8888-8888-888888888301',
   'james.ho@traderisksol.com', 'James Ho', 'to', NULL),

  ('99999999-9999-9999-9999-999999999303',
   '66666666-6666-6666-6666-666666666003',
   '88888888-8888-8888-8888-888888888302',
   'james.ho@traderisksol.com', 'James Ho', 'from', NULL),

  ('99999999-9999-9999-9999-999999999304',
   '66666666-6666-6666-6666-666666666003',
   '88888888-8888-8888-8888-888888888302',
   'jingwen.chua@pinnaclefa.sg', 'Chua Jing Wen', 'to',
   '22222222-2222-2222-2222-222222222005');

-- Thread 4 participants
INSERT INTO email_participants (id, thread_id, message_id, email, name, role, contact_id)
VALUES
  ('99999999-9999-9999-9999-999999999401',
   '66666666-6666-6666-6666-666666666004',
   '88888888-8888-8888-8888-888888888401',
   'ahmad.faizal@singhealthsystems.sg', 'Dr Ahmad Faizal', 'from',
   '22222222-2222-2222-2222-222222222003'),

  ('99999999-9999-9999-9999-999999999402',
   '66666666-6666-6666-6666-666666666004',
   '88888888-8888-8888-8888-888888888401',
   'james.ho@traderisksol.com', 'James Ho', 'to', NULL),

  ('99999999-9999-9999-9999-999999999403',
   '66666666-6666-6666-6666-666666666004',
   '88888888-8888-8888-8888-888888888402',
   'james.ho@traderisksol.com', 'James Ho', 'from', NULL),

  ('99999999-9999-9999-9999-999999999404',
   '66666666-6666-6666-6666-666666666004',
   '88888888-8888-8888-8888-888888888402',
   'ahmad.faizal@singhealthsystems.sg', 'Dr Ahmad Faizal', 'to',
   '22222222-2222-2222-2222-222222222003'),

  ('99999999-9999-9999-9999-999999999405',
   '66666666-6666-6666-6666-666666666004',
   '88888888-8888-8888-8888-888888888403',
   'ahmad.faizal@singhealthsystems.sg', 'Dr Ahmad Faizal', 'from',
   '22222222-2222-2222-2222-222222222003'),

  ('99999999-9999-9999-9999-999999999406',
   '66666666-6666-6666-6666-666666666004',
   '88888888-8888-8888-8888-888888888403',
   'james.ho@traderisksol.com', 'James Ho', 'to', NULL);

-- =============================================================================
-- 10. THREAD SUMMARIES (AI-generated analysis per thread)
-- =============================================================================

INSERT INTO thread_summaries (id, thread_id, summary, next_action, draft_reply, created_at)
VALUES
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaa001',
   '66666666-6666-6666-6666-666666666001',
   'Priya Nair (Head of Finance, Vertex Technology) is evaluating cyber insurance for the first time following a phishing incident. Two quotes presented: Chubb CyberEdge at S$24,000 (S$2M limit) and AIG at S$21,500 (S$1.5M limit). Priya is preparing for a board presentation next Friday and has asked three specific technical questions about the Chubb policy: (1) third-party vendor coverage, (2) business interruption waiting period, and (3) feasibility of increasing the limit to S$3M.',
   'Answer Priya''s three questions and send Chubb full policy wording. Provide revised S$3M quote. Aim to have answers to her within 24 hours before the board meeting.',
   'Dear Priya,

Thank you for your questions — I am happy to clarify before your board presentation.

1. **Third-party vendor incidents**: Yes, the Chubb CyberEdge policy covers incidents originating from third-party vendors (including cloud hosting providers) under the "Dependent System Failure" sub-limit of S$500,000. This is a meaningful advantage over the AIG policy, which excludes vendor-originated events.

2. **Business interruption waiting period**: There is an 8-hour waiting period before BI coverage triggers. In practice, this means a ransomware attack that causes prolonged downtime (typically >24 hours) is fully covered from hour 8 onward.

3. **Increasing to S$3M**: Chubb can accommodate a S$3M limit. The adjusted premium would be approximately S$31,500/year — a 31% premium for 50% more coverage, which is strong value given your client data exposure.

I have attached the full Chubb CyberEdge policy wording for your review. I am available for a call before your board meeting if that would help.

Best regards,
James Ho
Trade Risk Solutions | T: +65 6234 5678',
   now() - interval '1 day'),

  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaa002',
   '66666666-6666-6666-6666-666666666002',
   'Pacific Construction Group''s commercial property policy with MSIG is due for renewal on 31 July 2026. MSIG proposed a 12% premium increase to S$47,700. Tokio Marine counter-quote obtained at S$44,200 (3.8% increase), same S$12M sum insured but with a higher deductible (S$7,500) for the new Tengah Industrial Estate site. Tan Boon Huat has confirmed he wants to proceed with Tokio Marine and requires the cover note by 15 July for bank documentation.',
   'Bind the Tokio Marine policy. Issue cover note to Boon Huat by 15 July. Update deal stage to closed_won. Schedule reminder for Tengah site deductible note in the policy schedule.',
   'Dear Boon Huat,

Thank you for confirming — great choice. Tokio Marine''s pricing and breadth of cover is excellent value.

I will proceed to bind the policy now. You can expect:
• Formal cover note: by end of week (well before your 15 July deadline)
• Full policy schedule: within 10 working days of binding

I will note the Tengah site deductible (S$7,500) clearly in the schedule so there are no surprises.

As a reminder, your workmen compensation policy renewed in April is current through to April 2027.

I will be in touch shortly.

Warm regards,
Sarah Tan
Trade Risk Solutions',
   now() - interval '12 hours'),

  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaa003',
   '66666666-6666-6666-6666-666666666003',
   'Chua Jing Wen (Compliance Manager, Pinnacle Financial Advisors) is seeking PI insurance for the first time following a MAS audit that identified a compliance gap. The firm is MAS-licensed with 12 financial advisers and AUM of S$180M. Initial guidance provided: S$2M/S$4M limit, estimated S$8,500-S$11,000 premium, claims-made basis with retroactive date. Agent suggested a 30-minute discovery call to progress. No response to call invite yet — follow-up warranted.',
   'Follow up with Jing Wen on the call invite. Also send the QBE and Zurich proposal forms now so she can start compiling information in parallel. MAS compliance urgency should be highlighted.',
   'Dear Jing Wen,

I wanted to follow up on my earlier email and the call invite I sent. Given the MAS audit finding, I understand this coverage needs to be in place as soon as possible.

To help us move quickly, I have attached proposal forms from both QBE and Zurich. If you could complete the key sections — particularly the nature of your advisory activities, any pending complaints or claims, and the CVs of your senior advisers — we can turnaround quotes within 5 business days of receipt.

The most time-sensitive element is the retroactive date: we want to lock in coverage that protects you from any prior unidentified exposures, and the retroactive date negotiations with insurers can take a few days.

Are you free for a 20-minute call this week? Thursday or Friday afternoon works well for me.

Best,
James Ho',
   now() - interval '2 days'),

  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaa004',
   '66666666-6666-6666-6666-666666666004',
   'Dr Ahmad Faizal (CMO, SingHealth Systems) is seeking medical malpractice coverage for three specialist clinics (orthopaedic, cardiology, women''s health) with 6 practitioners and ~8,400 annual consults. Two prior complaints resolved without legal action. Recommended S$5M/S$10M limits, estimated S$28,000-S$36,000 premium, claims-made basis with 5-year run-off tail. Dr Ahmad has asked about mid-term removal of a departing surgeon and whether tail coverage can be purchased per-clinic. Documents compilation in progress.',
   'Answer Dr Ahmad''s questions about mid-term endorsements and per-clinic tail coverage. Once documents are received (expected end of week), submit proposal to AIG, Chubb, and QBE. Target quotes within 10 working days.',
   'Dear Dr Ahmad,

Thank you for the update — looking forward to receiving the documents.

To answer your questions:

1. **Removing a departing surgeon mid-policy**: Yes, this is handled via an endorsement. If the surgeon retires mid-policy, we remove their name and the insurer will apply a pro-rata premium credit for the remaining period. We typically process this within 5-7 business days of notification.

2. **Per-clinic tail coverage**: Yes, tail (run-off) coverage can be structured on a per-location basis if you close one clinic. The tail premium is typically 150-200% of the departing clinic''s allocated annual premium for a 5-year run-off. I will ensure this flexibility is built into the policy structure from the outset.

Please do send the documents when ready — I will have the first round of quotes to you within 10 working days.

Best,
James Ho',
   now() - interval '3 days');

-- =============================================================================
-- 11. AI DRAFTS (pending agent-generated replies)
-- =============================================================================

INSERT INTO ai_drafts (id, contact_id, thread_id, channel, subject, body, status, generated_by, created_at)
VALUES
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbb01',
   '22222222-2222-2222-2222-222222222002',
   '66666666-6666-6666-6666-666666666001',
   'email',
   'Re: Cyber Insurance Quotation — Vertex Technology Solutions',
   'Dear Priya,

Thank you for your questions — I am happy to clarify before your board presentation.

1. **Third-party vendor incidents**: Yes, the Chubb CyberEdge policy covers incidents originating from third-party vendors (including cloud hosting providers) under the "Dependent System Failure" sub-limit of S$500,000. This is a meaningful advantage over the AIG policy, which excludes vendor-originated events.

2. **Business interruption waiting period**: There is an 8-hour waiting period before BI coverage triggers. In practice, this means a ransomware attack that causes prolonged downtime (typically >24 hours) is fully covered from hour 8 onward.

3. **Increasing to S$3M**: Chubb can accommodate a S$3M limit. The adjusted premium would be approximately S$31,500/year — a 31% premium for 50% more coverage, which is strong value given your client data exposure.

I have attached the full Chubb CyberEdge policy wording for your review. I am available for a call before your board meeting if that would help.

Best regards,
James Ho
Trade Risk Solutions | T: +65 6234 5678',
   'pending',
   'gemini',
   now() - interval '1 day'),

  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbb02',
   '22222222-2222-2222-2222-222222222005',
   '66666666-6666-6666-6666-666666666003',
   'email',
   'Re: Professional Indemnity Insurance — Follow-Up & Proposal Forms',
   'Dear Jing Wen,

I wanted to follow up on my earlier email and the call invite I sent. Given the MAS audit finding, I understand this coverage needs to be in place as soon as possible.

To help us move quickly, I have attached proposal forms from both QBE and Zurich. If you could complete the key sections — particularly the nature of your advisory activities, any pending complaints or claims, and the CVs of your senior advisers — we can turnaround quotes within 5 business days of receipt.

The most time-sensitive element is the retroactive date: we want to lock in coverage that protects you from any prior unidentified exposures, and the retroactive date negotiations with insurers can take a few days.

Are you free for a 20-minute call this week? Thursday or Friday afternoon works well for me.

Best,
James Ho',
   'pending',
   'gemini',
   now() - interval '2 days'),

  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbb03',
   '22222222-2222-2222-2222-222222222003',
   '66666666-6666-6666-6666-666666666004',
   'email',
   'Re: Medical Malpractice Coverage — Mid-Term Endorsements & Tail Cover',
   'Dear Dr Ahmad,

Thank you for the update — looking forward to receiving the documents.

To answer your questions:

1. **Removing a departing surgeon mid-policy**: Yes, this is handled via an endorsement. If the surgeon retires mid-policy, we remove their name and the insurer will apply a pro-rata premium credit for the remaining period. We typically process this within 5-7 business days of notification.

2. **Per-clinic tail coverage**: Yes, tail (run-off) coverage can be structured on a per-location basis if you close one clinic. The tail premium is typically 150-200% of the departing clinic''s allocated annual premium for a 5-year run-off. I will ensure this flexibility is built into the policy structure from the outset.

Please do send the documents when ready — I will have the first round of quotes to you within 10 working days.

Best,
James Ho',
   'pending',
   'gemini',
   now() - interval '3 days');

-- =============================================================================
-- 12. INTERACTIONS (call and meeting notes)
-- =============================================================================

INSERT INTO interactions (id, customer_id, contact_id, deal_id, type, summary, created_by, created_at)
VALUES
  ('cccccccc-cccc-cccc-cccc-cccccccccc01',
   '44444444-4444-4444-4444-444444444001',
   '22222222-2222-2222-2222-222222222001',
   '55555555-5555-5555-5555-555555555001',
   'call',
   'Called Lim Wei Jian to discuss foreign worker levy renewal. He mentioned NTUC has sent a counter-quote that is S$1,200 cheaper. We discussed the service value difference and agreed to review the policy scope. He will revert by Friday.',
   'Sarah Tan',
   now() - interval '10 days'),

  ('cccccccc-cccc-cccc-cccc-cccccccccc02',
   '44444444-4444-4444-4444-444444444003',
   '22222222-2222-2222-2222-222222222004',
   '55555555-5555-5555-5555-555555555004',
   'meeting',
   'Site visit to Pacific Construction Toa Payoh office. Walked through the Tokio Marine vs MSIG comparison with Boon Huat and his operations team. Confirmed Tengah site coverage requirements. Client agreed to Tokio Marine pending board sign-off (expected this week).',
   'Sarah Tan',
   now() - interval '5 days'),

  ('cccccccc-cccc-cccc-cccc-cccccccccc03',
   '44444444-4444-4444-4444-444444444002',
   '22222222-2222-2222-2222-222222222002',
   '55555555-5555-5555-5555-555555555002',
   'note',
   'Priya confirmed she has board meeting next Friday to present the cyber insurance proposal. She asked for answers to 3 technical questions about Chubb policy. AI draft generated and pending review. Priority: respond within 24 hours.',
   'James Ho',
   now() - interval '2 days'),

  ('cccccccc-cccc-cccc-cccc-cccccccccc04',
   NULL,
   '22222222-2222-2222-2222-222222222006',
   NULL,
   'whatsapp',
   'Marcus asked about fire + flood cover for his Jurong warehouse. Sent WhatsApp message with overview of commercial property policy and request for building valuation details. Awaiting response.',
   'James Ho',
   now() - interval '10 days'),

  ('cccccccc-cccc-cccc-cccc-cccccccccc05',
   NULL,
   '22222222-2222-2222-2222-222222222005',
   NULL,
   'call',
   'Introductory call with Chua Jing Wen. 20 minutes. She explained the MAS audit finding and urgency. Confirmed 12 FA reps, AUM ~S$180M. Discussed PI basics. Sent follow-up email with premium estimates. She will review with her CEO before sending proposal form.',
   'James Ho',
   now() - interval '3 months'),

  ('cccccccc-cccc-cccc-cccc-cccccccccc06',
   '44444444-4444-4444-4444-444444444003',
   '22222222-2222-2222-2222-222222222004',
   '55555555-5555-5555-5555-555555555005',
   'note',
   'Workmen compensation renewed with QBE. Policy no. WC-2026-PAC-0441. Premium S$21,000. 120 workers covered. Boon Huat was pleased with the 3% discount secured. Good opportunity to mention property renewal is next.',
   'Sarah Tan',
   now() - interval '4 weeks');

-- =============================================================================
-- 13. POLICIES (active and renewal-due)
-- =============================================================================

INSERT INTO policies (id, customer_id, deal_id, policy_number, insurer, product_type,
  sum_insured, premium, start_date, end_date, renewal_date, status, created_at)
VALUES
  ('dddddddd-dddd-dddd-dddd-dddddddddd01',
   '44444444-4444-4444-4444-444444444001',
   '55555555-5555-5555-5555-555555555001',
   'FW-2025-MER-0321',
   'FWD Insurance',
   'foreign_worker',
   NULL,
   18500.00,
   '2025-07-01',
   '2026-06-30',
   '2026-05-31',
   'active',
   now() - interval '11 months'),

  ('dddddddd-dddd-dddd-dddd-dddddddddd02',
   '44444444-4444-4444-4444-444444444003',
   '55555555-5555-5555-5555-555555555005',
   'WC-2026-PAC-0441',
   'QBE Insurance',
   'workmen',
   NULL,
   21000.00,
   '2026-04-01',
   '2027-03-31',
   '2027-02-28',
   'active',
   now() - interval '4 weeks'),

  ('dddddddd-dddd-dddd-dddd-dddddddddd03',
   '44444444-4444-4444-4444-444444444003',
   NULL,
   'CP-2025-PAC-0118',
   'MSIG Insurance',
   'property',
   12000000.00,
   42600.00,
   '2025-08-01',
   '2026-07-31',
   '2026-06-30',
   'active',
   now() - interval '10 months'),

  ('dddddddd-dddd-dddd-dddd-dddddddddd04',
   '44444444-4444-4444-4444-444444444002',
   NULL,
   'GM-2024-VTX-0077',
   'AIA Singapore',
   'medical',
   NULL,
   28500.00,
   '2024-09-01',
   '2025-08-31',
   '2025-07-31',
   'active',
   now() - interval '8 months');

-- =============================================================================
-- 14. OUTBOUND LEADS (prospecting pipeline)
-- =============================================================================

INSERT INTO outbound_leads (id, record_type, source, first_name, last_name, full_name,
  headline, current_title, current_company, current_industry, location, country_code,
  email, status, notes, created_at)
VALUES
  ('eeeeeeee-eeee-eeee-eeee-eeeeeeeeee01',
   'person',
   'people_search',
   'David', 'Koh',
   'David Koh Wei Ming',
   'CFO at Horizon Marine Services | Insurance & Risk Management',
   'Chief Financial Officer',
   'Horizon Marine Services Pte Ltd',
   'Maritime & Shipping',
   'Singapore, Singapore',
   'SG',
   'david.koh@horizonmarine.sg',
   'contacted',
   'CFO of mid-sized marine logistics firm (~80 staff). LinkedIn outreach sent. Interested in workmen comp and marine cargo. Follow up in 2 weeks.',
   now() - interval '3 weeks'),

  ('eeeeeeee-eeee-eeee-eeee-eeeeeeeeee02',
   'person',
   'people_search',
   'Linda', 'Seah',
   'Linda Seah Hwee Leng',
   'Operations Director | Healthcare Technology | Series B',
   'Operations Director',
   'MedTech Innovations Pte Ltd',
   'Healthcare Technology',
   'Singapore, Singapore',
   'SG',
   'linda.seah@medtechinnovations.sg',
   'new',
   'Series B healthtech startup. Growing fast. Likely need cyber + PI for enterprise contracts. Cold outreach not sent yet.',
   now() - interval '5 days'),

  ('eeeeeeee-eeee-eeee-eeee-eeeeeeeeee03',
   'person',
   'url_lookup',
   'Hassan', 'bin Razak',
   'Hassan bin Razak',
   'General Manager, Safir Construction | BCA Grade A2',
   'General Manager',
   'Safir Construction Pte Ltd',
   'Construction',
   'Singapore, Singapore',
   'SG',
   'hassan@safirconstruct.sg',
   'engaged',
   'Referred by Tan Boon Huat (Pacific Construction). GM at Safir — BCA Grade A2 contractor, ~80 workers. Interested in workmen comp and property. Call scheduled for next Tuesday.',
   now() - interval '8 days'),

  ('eeeeeeee-eeee-eeee-eeee-eeeeeeeeee04',
   'person',
   'people_search',
   'Grace', 'Teo',
   'Grace Teo Li Shan',
   'Head of Compliance & Legal | Asset Management | MAS Regulated',
   'Head of Compliance',
   'Aquila Capital Management Pte Ltd',
   'Asset Management',
   'Singapore, Singapore',
   'SG',
   'grace.teo@aquilacapital.sg',
   'new',
   'MAS-regulated fund manager. AUM ~S$450M. Very likely to need PI and D&O. Identified via LinkedIn search. Warm intro possible via Chua Jing Wen (Pinnacle).',
   now() - interval '2 days');

-- =============================================================================
-- 15. WHATSAPP CONVERSATIONS & MESSAGES
-- =============================================================================

INSERT INTO whatsapp_conversations (id, contact_id, status, last_message_at, created_at)
VALUES
  ('ffffffff-ffff-ffff-ffff-ffffffffffff1',
   '22222222-2222-2222-2222-222222222006',
   'active',
   now() - interval '10 days',
   now() - interval '12 days'),

  ('ffffffff-ffff-ffff-ffff-ffffffffffff2',
   '22222222-2222-2222-2222-222222222007',
   'active',
   now() - interval '5 days',
   now() - interval '6 days');

INSERT INTO whatsapp_messages (id, contact_id, conversation_id, direction, phone_number,
  message, status, sent_at, created_at)
VALUES
  ('11111111-aaaa-bbbb-cccc-111111111001',
   '22222222-2222-2222-2222-222222222006',
   'ffffffff-ffff-ffff-ffff-ffffffffffff1',
   'inbound',
   '+6581234006',
   'Hi, I have a warehouse I want to insure against fire and flooding. Can you help me?',
   'read',
   now() - interval '12 days',
   now() - interval '12 days'),

  ('11111111-aaaa-bbbb-cccc-111111111002',
   '22222222-2222-2222-2222-222222222006',
   'ffffffff-ffff-ffff-ffff-ffffffffffff1',
   'outbound',
   '+6581234006',
   'Hi Marcus! Thanks for reaching out to Trade Risk Solutions. We can definitely help with warehouse fire and flood insurance. To prepare a quote, could you share: (1) location and approximate floor area, (2) estimated value of contents/stock, (3) whether the building is owned or leased? Looking forward to helping you.',
   'delivered',
   now() - interval '10 days',
   now() - interval '10 days'),

  ('11111111-aaaa-bbbb-cccc-111111111003',
   '22222222-2222-2222-2222-222222222007',
   'ffffffff-ffff-ffff-ffff-ffffffffffff2',
   'inbound',
   '+6591234007',
   'Hello, I filled in your website form about foreign worker levy insurance. We have 35 workers and our policy expires end of June. Is it possible to get a quote quickly?',
   'read',
   now() - interval '6 days',
   now() - interval '6 days'),

  ('11111111-aaaa-bbbb-cccc-111111111004',
   '22222222-2222-2222-2222-222222222007',
   'ffffffff-ffff-ffff-ffff-ffffffffffff2',
   'outbound',
   '+6591234007',
   'Hi Siti, thank you for following up! We received your enquiry. For 35 foreign workers, we can get a quote ready within 2 business days. I will need a list of workers with their pass types (S-Pass / Work Permit) and nationalities. Could you email that to us at enquiry@traderisksol.com? We will prioritise this given your June deadline.',
   'delivered',
   now() - interval '5 days',
   now() - interval '5 days');

-- Pending WhatsApp draft for Marcus
INSERT INTO whatsapp_drafts (id, conversation_id, content, status, created_at)
VALUES
  ('22222222-cccc-dddd-eeee-222222222001',
   'ffffffff-ffff-ffff-ffff-ffffffffffff1',
   'Hi Marcus, just following up on the warehouse insurance enquiry from last week. Were you able to get the details together (floor area, contents value, ownership)? We want to make sure we get you covered before any gap in protection. Let me know if you need any help!',
   'pending',
   now() - interval '3 days');

-- =============================================================================
-- 16. AI USAGE LOG (sample entries for analytics dashboard)
-- =============================================================================

INSERT INTO gemini_usage_log (feature, input_tokens, output_tokens, cost_usd, thread_id, created_at)
VALUES
  ('auto_summarize',  3420, 612, 0.000880,  '66666666-6666-6666-6666-666666666001', now() - interval '1 day'),
  ('draft_reply',     2810, 894, 0.000959,  '66666666-6666-6666-6666-666666666001', now() - interval '1 day'),
  ('auto_summarize',  4102, 724, 0.001050,  '66666666-6666-6666-6666-666666666002', now() - interval '12 hours'),
  ('draft_reply',     3215, 1022, 0.001095, '66666666-6666-6666-6666-666666666002', now() - interval '10 hours'),
  ('auto_summarize',  2890, 580, 0.000782,  '66666666-6666-6666-6666-666666666003', now() - interval '2 days'),
  ('draft_reply',     3540, 910, 0.001077,  '66666666-6666-6666-6666-666666666003', now() - interval '2 days'),
  ('auto_summarize',  5230, 820, 0.001278,  '66666666-6666-6666-6666-666666666004', now() - interval '3 days'),
  ('draft_reply',     4180, 1150, 0.001317, '66666666-6666-6666-6666-666666666004', now() - interval '3 days'),
  ('email_analysis',  6800, 0,   0.001020,  NULL,                                   now() - interval '4 days'),
  ('email_analysis',  7200, 0,   0.001080,  NULL,                                   now() - interval '5 days'),
  ('rag_index',       0,    0,   0.000425,  NULL,                                   now() - interval '7 days'),
  ('outbound_search', 2100, 480, 0.000603,  NULL,                                   now() - interval '6 days');

-- =============================================================================
-- Done! Summary of seeded data:
--   Companies:          5
--   Contacts:           7
--   Company-contacts:   5
--   Inbound leads:      6
--   Customers:          3
--   Deals:              5
--   Email threads:      4
--   Email messages:    12
--   Email participants: 20
--   Thread summaries:   4
--   AI drafts:          3
--   Interactions:       6
--   Policies:           4
--   Outbound leads:     4
--   WA conversations:   2
--   WA messages:        4
--   WA drafts:          1
--   Gemini usage log:  12
-- =============================================================================
