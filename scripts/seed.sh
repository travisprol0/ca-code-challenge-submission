#!/usr/bin/env bash
# Full bootstrap: install WP core, activate plugins, switch theme, seed content.
# Idempotent: safe to re-run after `make reset && make up`.

set -euo pipefail

WP="wp --allow-root"
SITE_URL="${WP_SITE_URL:-http://localhost:8080}"
SITE_TITLE="${WP_SITE_TITLE:-Brand Reviews Challenge}"
ADMIN_USER="${WP_ADMIN_USER:-admin}"
ADMIN_PASS="${WP_ADMIN_PASSWORD:-admin}"
ADMIN_EMAIL="${WP_ADMIN_EMAIL:-admin@example.com}"

echo "==> Waiting for DB..."
until $WP db check >/dev/null 2>&1; do sleep 1; done

echo "==> Installing WordPress core (if needed)..."
if ! $WP core is-installed 2>/dev/null; then
  $WP core install \
    --url="$SITE_URL" \
    --title="$SITE_TITLE" \
    --admin_user="$ADMIN_USER" \
    --admin_password="$ADMIN_PASS" \
    --admin_email="$ADMIN_EMAIL" \
    --skip-email
fi

echo "==> Setting permalink structure..."
$WP rewrite structure '/%postname%/' --hard

echo "==> Installing & activating plugins..."
$WP plugin install advanced-custom-fields wordpress-seo --activate

echo "==> Activating consumer-reviews theme..."
$WP theme activate consumer-reviews

echo "==> Flushing rewrite rules so CPTs are routable..."
$WP rewrite flush --hard

echo "==> Creating industry taxonomy terms..."
for term in "Insurance" "Telecom" "Home Services" "Finance" "Retail"; do
  $WP term create industry "$term" --porcelain 2>/dev/null || true
done

echo "==> Creating reviewer users..."
declare -A REVIEWER_IDS
create_user() {
  local login="$1" name="$2" email="$3"
  local existing
  existing=$($WP user get "$login" --field=ID 2>/dev/null || true)
  if [ -z "$existing" ]; then
    existing=$($WP user create "$login" "$email" \
      --role=subscriber \
      --display_name="$name" \
      --user_pass="changeme" \
      --porcelain)
  fi
  REVIEWER_IDS["$login"]="$existing"
}
create_user sarah_k  "Sarah K."  sarah@example.com
create_user mike_t   "Mike T."   mike@example.com
create_user jenny_w  "Jenny W."  jenny@example.com
create_user david_l  "David L."  david@example.com
create_user anna_r   "Anna R."   anna@example.com
create_user roberto_g "Roberto G." roberto@example.com
create_user maya_p   "Maya P."   maya@example.com
create_user kenji_o  "Kenji O."  kenji@example.com

echo "==> Creating pages..."
create_page() {
  local title="$1" content="$2"
  local id
  id=$($WP post list --post_type=page --title="$title" --field=ID 2>/dev/null | head -n1)
  if [ -z "$id" ]; then
    id=$($WP post create --post_type=page --post_status=publish \
      --post_title="$title" --post_content="$content" --porcelain)
  fi
  echo "$id"
}
HOME_ID=$(create_page "Home" "<p>Welcome to our independent brand reviews directory.</p>")
ABOUT_ID=$(create_page "About" "<p>We collect honest customer reviews of consumer brands across insurance, telecom, finance, home services, and retail. All reviews are written by real users and are not influenced by the brands themselves.</p><p>This site is sample data for an interview challenge.</p>")
CONTACT_ID=$(create_page "Contact" "<p>Email us at hello@example.com</p>")

$WP option update show_on_front page >/dev/null
$WP option update page_on_front "$HOME_ID" >/dev/null

echo "==> Creating brands..."
declare -A BRAND_IDS

create_brand() {
  local slug="$1" title="$2" description="$3"
  local website="$4" founded="$5" hq="$6" avg_rating="$7" industry="$8"
  local seo_title="$9" seo_desc="${10}"

  local id
  id=$($WP post list --post_type=brand --name="$slug" --field=ID 2>/dev/null | head -n1)
  if [ -z "$id" ]; then
    id=$($WP post create \
      --post_type=brand \
      --post_status=publish \
      --post_title="$title" \
      --post_name="$slug" \
      --post_content="$description" \
      --porcelain)
  fi
  BRAND_IDS["$slug"]="$id"

  $WP post meta update "$id" website_url "$website"                       >/dev/null
  $WP post meta update "$id" _website_url field_brand_website_url         >/dev/null
  $WP post meta update "$id" founded_year "$founded"                      >/dev/null
  $WP post meta update "$id" _founded_year field_brand_founded_year       >/dev/null
  $WP post meta update "$id" headquarters "$hq"                           >/dev/null
  $WP post meta update "$id" _headquarters field_brand_headquarters       >/dev/null
  $WP post meta update "$id" average_rating "$avg_rating"                 >/dev/null
  $WP post meta update "$id" _average_rating field_brand_average_rating   >/dev/null

  $WP post term set "$id" industry "$industry" >/dev/null

  $WP post meta update "$id" _yoast_wpseo_title "$seo_title"     >/dev/null
  $WP post meta update "$id" _yoast_wpseo_metadesc "$seo_desc"   >/dev/null
}

# 5 brands, one per industry
create_brand "acme-insurance" "Acme Insurance Co." \
  "<p>Acme Insurance is a long-running general-lines insurer offering auto, home, and umbrella coverage across 38 US states. The company was founded in Hartford, Connecticut in 1985 and operates through a network of approximately 1,200 independent agents.</p><p>Acme is best known for its agent-led model and strong claims response times. Their flagship product is the bundled auto + home policy, which accounts for roughly 60% of their book of business. The company also writes commercial lines for small businesses, though that's a smaller segment.</p><p>Acme is rated A (Excellent) by AM Best and has paid dividends to policyholders in 38 of the last 40 years through its participating insurance products.</p>" \
  "https://acme-insurance.example.com" 1985 "Hartford, CT" 4.2 "Insurance" \
  "Acme Insurance Reviews - Auto, Home & Umbrella Coverage" \
  "Read 12 independent customer reviews of Acme Insurance, a Hartford-based insurer offering auto, home, and umbrella policies in 38 US states."

create_brand "primepath-bank" "PrimePath Bank" \
  "<p>PrimePath Bank is a regional retail bank operating 220 branches across the Northeast United States. Founded in 1978 and headquartered in New York City, PrimePath offers personal checking, savings, mortgages, auto loans, and small-business banking.</p><p>The bank is FDIC-insured and is considered a mid-tier regional player with approximately \$48 billion in assets. PrimePath has invested significantly in mobile banking over the past three years, though customer reviews suggest the app still trails the national banks in polish.</p><p>PrimePath is known for relatively competitive mortgage rates and a strong physical branch network in markets where the major banks have been closing locations.</p>" \
  "https://primepath-bank.example.com" 1978 "New York, NY" 4.0 "Finance" \
  "PrimePath Bank Reviews - Checking, Savings, Loans" \
  "PrimePath Bank customer reviews. Northeast regional bank offering checking, savings, and loans across 220 branches."

create_brand "homeshield-pro" "HomeShield Pro" \
  "<p>HomeShield Pro sells home warranty contracts that cover repair and replacement costs for HVAC systems, major appliances, and plumbing. The company was founded in 1999 in Atlanta, Georgia and serves homeowners in 47 states.</p><p>HomeShield Pro offers three tiers of coverage: a basic systems plan, a basic appliances plan, and a combined plan that bundles both. Service is delivered through a network of approximately 25,000 pre-vetted contractors. Customers pay a flat service fee (typically \$75-\$125) per claim regardless of the actual repair cost.</p><p>The company is one of the largest home warranty providers in the United States and is a frequent subject of consumer complaints related to claim denials and contract exclusions — themes that show up in the customer reviews below.</p>" \
  "https://homeshield-pro.example.com" 1999 "Atlanta, GA" 3.9 "Home Services" \
  "HomeShield Pro Home Warranty Reviews" \
  "Read real customer reviews of HomeShield Pro home warranty plans covering HVAC, appliances, and plumbing."

create_brand "swiftstream-internet" "SwiftStream Internet" \
  "<p>SwiftStream Internet is a fixed wireless ISP serving suburban and rural markets in the American Southwest. Founded in 2014 and headquartered in Austin, Texas, SwiftStream operates approximately 400 wireless tower sites across Texas, New Mexico, Arizona, and parts of Oklahoma.</p><p>SwiftStream's value proposition is bringing reliable broadband to areas that don't have cable or fiber service. Speeds range from 25 Mbps on the entry tier to 100 Mbps on the top residential plan. The technology requires line-of-sight to a tower, which limits availability within their nominal coverage areas.</p><p>Customer reviews are bimodal: rural customers without cable alternatives tend to rate them highly, while reviewers who compare them to wired broadband are more critical, particularly around weather-related outages.</p>" \
  "https://swiftstream-internet.example.com" 2014 "Austin, TX" 3.5 "Telecom" \
  "SwiftStream Internet Reviews - Rural Fixed Wireless ISP" \
  "Read reviews of SwiftStream Internet, a Texas-based fixed wireless ISP for suburban and rural Southwest customers."

create_brand "urbanretail-co" "UrbanRetail Co." \
  "<p>UrbanRetail Co. is a multi-category online retailer offering apparel, home goods, kitchen products, and small electronics. The company was founded in 2005 in Seattle and ships to customers throughout North America from three regional fulfillment centers.</p><p>UrbanRetail operates a marketplace model where roughly 70% of inventory is supplied by third-party brands and 30% is their own private-label products. The company is known for fast shipping (typically two-day standard) and a relatively generous return policy.</p><p>Customer sentiment in reviews tends to vary by category — home goods and kitchen products score consistently well, while private-label apparel is more frequently cited as inconsistent in quality. Promotional pricing practices around major shopping events are a recurring complaint.</p>" \
  "https://urbanretail-co.example.com" 2005 "Seattle, WA" 4.4 "Retail" \
  "UrbanRetail Co. Reviews - Apparel, Home, Electronics" \
  "Customer reviews of UrbanRetail Co., a Seattle-based online retailer carrying apparel, home goods, and small electronics."

echo "==> Creating reviews..."

create_review() {
  local title="$1" body="$2" rating="$3" reviewer_name="$4" reviewer_location="$5"
  local brand_slug="$6" author_login="$7"

  local brand_id="${BRAND_IDS[$brand_slug]}"
  local author_id="${REVIEWER_IDS[$author_login]}"

  local existing
  existing=$($WP post list --post_type=review --title="$title" --field=ID 2>/dev/null | head -n1)
  if [ -n "$existing" ]; then return; fi

  local id
  id=$($WP post create \
    --post_type=review \
    --post_status=publish \
    --post_author="$author_id" \
    --post_title="$title" \
    --post_content="$body" \
    --porcelain)

  $WP post meta update "$id" rating "$rating"                                  >/dev/null
  $WP post meta update "$id" _rating field_review_rating                       >/dev/null
  $WP post meta update "$id" reviewer_name "$reviewer_name"                    >/dev/null
  $WP post meta update "$id" _reviewer_name field_review_reviewer_name         >/dev/null
  $WP post meta update "$id" reviewer_location "$reviewer_location"            >/dev/null
  $WP post meta update "$id" _reviewer_location field_review_reviewer_location >/dev/null
  $WP post meta update "$id" brand "$brand_id"                                 >/dev/null
  $WP post meta update "$id" _brand field_review_brand                         >/dev/null
}

# === ACME INSURANCE (12 reviews) ===
create_review "Smooth auto claim after a parking-lot fender bender" \
  "<p>Got rear-ended in a grocery store parking lot last March. Filed the claim online in about 10 minutes — uploaded photos, described what happened, and that was it. An adjuster called me the next morning. Rental car was set up that afternoon. The body shop they recommended was professional and the car came back looking new. Total time from accident to having my car back was 11 days, which felt reasonable for the amount of damage. Rate stayed flat at renewal. No complaints.</p>" \
  5 "Sarah K." "Denver, CO" "acme-insurance" "sarah_k"

create_review "Decent coverage but pricey for younger drivers" \
  "<p>Acme has been fine for me personally, but when I added my 22-year-old son to the policy the quote came in 40% higher than two other carriers I checked. I get that young drivers are expensive, but the gap was too big to ignore. He's now insured elsewhere. The split isn't ideal for paperwork but it's saving us about \$1,800/year.</p>" \
  3 "Mike T." "Albany, NY" "acme-insurance" "mike_t"

create_review "Agent was a lifesaver during the storm" \
  "<p>A tree came down on our detached garage during a derecho last summer. My local Acme agent walked me through everything personally — called twice in the first 48 hours to check in, helped me find a tree service that could handle the removal, and made sure the adjuster had everything they needed. That kind of service is hard to find now. We've been with this agent for 14 years and I won't switch.</p>" \
  5 "Jenny W." "Cedar Rapids, IA" "acme-insurance" "jenny_w"

create_review "Renewal sticker shock with no explanation" \
  "<p>No claims, no tickets, exactly the same coverage I've had for six years. Renewal came in 18% higher than last year. Called the agent and the answer was basically \"the whole market is up.\" Maybe true but I expected a more substantive explanation given the loyalty. Shopping around this cycle.</p>" \
  2 "David L." "Hartford, CT" "acme-insurance" "david_l"

create_review "Bundled home and auto, saved real money" \
  "<p>We had a separate home and auto carrier for years and finally bundled with Acme. The savings were genuine — about \$640 a year combined. The transition was painless; their team handled cancellation of the old policies. The home policy is actually broader than what we had before. I'd recommend this to anyone with both a home and a car.</p>" \
  5 "Anna R." "Portland, OR" "acme-insurance" "anna_r"

create_review "Long hold times on the support line" \
  "<p>Coverage is fine but every time I need to call the 800 number I'm on hold 25+ minutes. Local agent is responsive but not always available for billing questions. They need to staff up the call center or push more self-service.</p>" \
  3 "Roberto G." "Charlotte, NC" "acme-insurance" "roberto_g"

create_review "Quick payout on a totaled vehicle" \
  "<p>My car was totaled in a hailstorm. I had a check in hand 14 days after the inspection. The number was fair — within \$200 of what KBB suggested. The whole process was easier than I expected for a total loss claim. Switched my newer car to Acme too.</p>" \
  5 "Maya P." "Oklahoma City, OK" "acme-insurance" "maya_p"

create_review "Online portal feels like 2010" \
  "<p>Coverage and pricing are competitive. The online portal is a disaster — slow, ugly, missing features the app has. I do everything through the mobile app or by calling. They should retire the portal entirely or rebuild it.</p>" \
  3 "Kenji O." "Boston, MA" "acme-insurance" "kenji_o"

create_review "Umbrella policy was easy to add" \
  "<p>Added a \$1M umbrella policy. The process was completely painless — about 15 minutes on a phone call with my agent, paperwork emailed for e-signature the same day. Pricing was competitive with what I'd seen quoted elsewhere. Peace of mind for not much money.</p>" \
  5 "Sarah K." "Denver, CO" "acme-insurance" "sarah_k"

create_review "Glass claim handling was confusing" \
  "<p>Cracked windshield. Got bounced between the glass shop and Acme three different times trying to figure out who was paying what. Eventually got fixed but I shouldn't have to coordinate that myself. Two stars docked for the experience even though it ultimately got resolved.</p>" \
  3 "Mike T." "Albany, NY" "acme-insurance" "mike_t"

create_review "Discount for safe driving was real" \
  "<p>Enrolled in their telematics program. Drove the way I always drive. After six months my premium dropped 14%. That's real money. The app is just OK but it does the job and isn't intrusive.</p>" \
  4 "Jenny W." "Cedar Rapids, IA" "acme-insurance" "jenny_w"

create_review "Fine but nothing special" \
  "<p>I've had Acme for three years. Never filed a claim. Premium is on the higher side of fair. App works. Agent is responsive enough. I don't have strong feelings either way, which I guess is what you want from insurance.</p>" \
  4 "David L." "Hartford, CT" "acme-insurance" "david_l"

# === PRIMEPATH BANK (12 reviews) ===
create_review "Branches still matter and they have them" \
  "<p>I do most banking online but having a real branch I can walk into for the unusual stuff makes a difference. Tellers at my local branch know my name. When I needed a notarized document and a cashier's check the same day, it was a 15-minute visit. That's increasingly hard to find.</p>" \
  5 "Anna R." "Boston, MA" "primepath-bank" "anna_r"

create_review "Mobile app feels dated" \
  "<p>App is functional but feels like 2014. Mobile deposit fails about 1 in 5 times for me — usually it can't read the back endorsement. Login flow is slow. Big banks have spoiled me on apps and PrimePath is noticeably behind.</p>" \
  3 "Mike T." "Albany, NY" "primepath-bank" "mike_t"

create_review "Got a great rate on our mortgage" \
  "<p>Our loan officer was excellent — patient with first-time-buyer questions, transparent on fees, and the final rate came in 0.5% under the best online lender we were comparing against. Close-of-loan went smoothly. Their mortgage operation is one of the strongest things about this bank.</p>" \
  5 "Sarah K." "Stamford, CT" "primepath-bank" "sarah_k"

create_review "Overdraft policy is aggressive" \
  "<p>Got hit with two \$35 overdraft fees in one weekend on transactions that posted out of order. Bank's position is that this is standard practice. It might be standard but it doesn't feel right. Looking at credit unions now.</p>" \
  2 "Roberto G." "Charlotte, NC" "primepath-bank" "roberto_g"

create_review "Personal banker actually returns calls" \
  "<p>When we opened our accounts they assigned us a personal banker. I assumed this was theater. Turns out he actually answers his direct line and remembers our situation. Set up a HELOC with him over two short calls. The relationship-banking thing is real here, at least at this branch.</p>" \
  5 "Jenny W." "Albany, NY" "primepath-bank" "jenny_w"

create_review "Savings rate is uncompetitive" \
  "<p>Their savings rate is 0.05% while online banks are offering 4%+. PrimePath knows their depositors are sticky and prices accordingly. I keep my emergency fund elsewhere now and just use PrimePath for checking. Decent bank, bad savings product.</p>" \
  2 "David L." "Hartford, CT" "primepath-bank" "david_l"

create_review "Small business banking has been solid" \
  "<p>Opened a small business account two years ago. The branch handles cash deposits, the business cards arrive promptly, fees are predictable. Their cash-management product isn't cutting-edge but it works. We've been happy enough to stay.</p>" \
  4 "Maya P." "Oklahoma City, OK" "primepath-bank" "maya_p"

create_review "Auto loan process was painful" \
  "<p>Pre-approved online, then the dealer ran into issues uploading documents to their portal, which delayed closing by three days. Eventually got the car. The rate was fine. The friction with the dealer was not.</p>" \
  3 "Kenji O." "Boston, MA" "primepath-bank" "kenji_o"

create_review "Free notary services at the branch" \
  "<p>Needed three documents notarized for an estate. Walked into the branch, the banker did it on the spot, didn't charge me. Try getting that anywhere else. Little things matter.</p>" \
  5 "Anna R." "Boston, MA" "primepath-bank" "anna_r"

create_review "Wire transfer fees are high" \
  "<p>\$35 for a domestic outgoing wire, \$50 for international. That's well above what online banks charge. Most of the time it doesn't matter, but for closing a real estate transaction it adds up. Negotiated it down twice with my banker but it shouldn't require that.</p>" \
  3 "Sarah K." "Stamford, CT" "primepath-bank" "sarah_k"

create_review "Quick HELOC approval" \
  "<p>Approved for a HELOC in under two weeks. Documentation was reasonable. The rate is variable, which I knew going in. Funded for a kitchen reno and it's been straightforward to draw on. Customer service has been responsive when I've called.</p>" \
  4 "Mike T." "Albany, NY" "primepath-bank" "mike_t"

create_review "Tellers and managers are well-trained" \
  "<p>Walked into a branch on vacation in another state. They handled my issue (replacing a debit card lost in a rental car) in 20 minutes. Pleasant, professional, didn't try to upsell. The branch experience is genuinely good.</p>" \
  5 "Roberto G." "Charlotte, NC" "primepath-bank" "roberto_g"

# === HOMESHIELD PRO (12 reviews) ===
create_review "Covered a dead AC unit in July — worth the cost" \
  "<p>The compressor on our AC died during a heat wave. HomeShield dispatched a contractor within 48 hours and approved a full replacement of the outdoor unit. With the service fee we paid about \$125 for a repair that would have cost us roughly \$4,200 out of pocket. The plan has paid for itself many times over already.</p>" \
  5 "Sarah K." "Denver, CO" "homeshield-pro" "sarah_k"

create_review "Lots of exclusions buried in the fine print" \
  "<p>They denied my dishwasher claim citing pre-existing wear. The contractor's inspection notes were vague and didn't really support the denial. Appealed and got nowhere. Read the contract very carefully before signing — the list of exclusions is long.</p>" \
  2 "David L." "Hartford, CT" "homeshield-pro" "david_l"

create_review "Reliable for routine appliance failures" \
  "<p>Used HomeShield three times in two years — garbage disposal, dryer heating element, kitchen faucet. All handled, all under the service fee. The contractors they sent were on time and professional. Not flashy, but it works for the routine stuff.</p>" \
  4 "Jenny W." "Chicago, IL" "homeshield-pro" "jenny_w"

create_review "Long wait for plumber dispatch" \
  "<p>Filed a claim for a leaking water heater. Waited four days for the plumber to come out. By then I'd already had to shut the water off and arrange alternate hot water. The plumber was fine when they finally arrived but the dispatch SLA needs work.</p>" \
  2 "Mike T." "Albany, NY" "homeshield-pro" "mike_t"

create_review "Refrigerator replacement was approved" \
  "<p>Compressor went on a 9-year-old fridge. The technician determined it was non-repairable. HomeShield approved a replacement and gave us a check for the depreciated value, plus credits toward delivery and removal. The new fridge cost us about \$400 out of pocket. Acceptable outcome.</p>" \
  4 "Anna R." "Portland, OR" "homeshield-pro" "anna_r"

create_review "Contractor quality is inconsistent" \
  "<p>Of the four contractors HomeShield has sent us over two years, two were excellent and two were sloppy. One left a worse mess than they fixed (don't ask). The hit rate is too random for what we pay.</p>" \
  3 "Roberto G." "Charlotte, NC" "homeshield-pro" "roberto_g"

create_review "Cancellation policy is sneaky" \
  "<p>Tried to cancel after our coverage year ended. They had auto-enrolled us in a new term at a higher rate three weeks before the renewal date. Eventually got the cancellation processed but it required a phone call and a strongly worded email. Read your renewal letter.</p>" \
  2 "Maya P." "Oklahoma City, OK" "homeshield-pro" "maya_p"

create_review "HVAC tune-up included is a real perk" \
  "<p>The annual HVAC tune-up included in our plan is worth about half the premium on its own. Technician this year caught a capacitor that was starting to bulge and replaced it as part of the visit. Probably saved us a summer service call.</p>" \
  5 "Kenji O." "Boston, MA" "homeshield-pro" "kenji_o"

create_review "Denied a clearly covered claim" \
  "<p>Garbage disposal stopped working. Contractor said the unit needed replacement. HomeShield denied the claim citing improper installation by a prior owner. There is no way for me to prove or disprove that. Felt like a pretextual denial. Eventually fixed it myself.</p>" \
  1 "David L." "Hartford, CT" "homeshield-pro" "david_l"

create_review "Pool equipment add-on saved us a fortune" \
  "<p>Added the optional pool/spa coverage. The pool pump died in year one. Replacement plus labor would have been \$2,800 out of pocket. We paid the service fee and a small upgrade differential. The pool coverage tier specifically has been a great value for us.</p>" \
  5 "Jenny W." "Chicago, IL" "homeshield-pro" "jenny_w"

create_review "Customer service hold times are brutal" \
  "<p>Hold times average 35-45 minutes whenever I call. Chat is no faster. Filed claims and follow-ups via email are at least answered the next business day. If you have time-sensitive issues this is frustrating.</p>" \
  2 "Sarah K." "Denver, CO" "homeshield-pro" "sarah_k"

create_review "Renewal pricing more than doubled" \
  "<p>Our first-year price was \$48/mo. Renewal came in at \$104/mo with no changes to coverage. When I called, the rep offered to bring it down to \$78 if I committed for two years. Felt like a car-dealership negotiation. Switched to a competitor.</p>" \
  2 "Roberto G." "Charlotte, NC" "homeshield-pro" "roberto_g"

# === SWIFTSTREAM INTERNET (12 reviews) ===
create_review "Finally an option that isn't satellite" \
  "<p>I'm 12 miles outside town with no cable. SwiftStream is night-and-day better than the satellite service we suffered with for years. Video calls work, the kids can stream, and we don't get throttled to dial-up speeds after 50GB. It's not gigabit but for our area it's transformational.</p>" \
  5 "Sarah K." "Marble Falls, TX" "swiftstream-internet" "sarah_k"

create_review "Drops out every time it rains" \
  "<p>Speeds are fine when it works. But any storm and we're offline for hours. Tech says that's just how fixed wireless behaves. I get that, but it makes anything time-sensitive (work calls, telehealth) unreliable.</p>" \
  2 "Mike T." "Liberty Hill, TX" "swiftstream-internet" "mike_t"

create_review "Acceptable rural option, not a city replacement" \
  "<p>Pings are higher than wired connections. Gaming and video calls are usable but not great. For browsing and streaming it's perfectly adequate. If you have an alternative, evaluate carefully; if you don't, SwiftStream is the best you'll do.</p>" \
  3 "David L." "Fredericksburg, TX" "swiftstream-internet" "david_l"

create_review "Install crew was professional" \
  "<p>The install took about 3 hours. Crew was on time, walked me through the antenna placement options, mounted it cleanly, and made sure I had a stable signal before they left. The price is what it is for rural service — install was the bright spot.</p>" \
  4 "Jenny W." "Boerne, TX" "swiftstream-internet" "jenny_w"

create_review "Speed advertised vs delivered" \
  "<p>I pay for the 100 Mbps tier. Most days I see 45-60 Mbps. Tech told me the tower is oversubscribed. They keep saying they'll add capacity. I have been hearing that for 14 months.</p>" \
  2 "Anna R." "Las Cruces, NM" "swiftstream-internet" "anna_r"

create_review "Customer service is unusually helpful" \
  "<p>Called support twice in the last year. Both reps were patient, knowledgeable, and didn't read from a script. They sent a tech out to re-aim my antenna when speeds dropped and refused to charge me for the visit. Refreshing.</p>" \
  5 "Roberto G." "Tucson, AZ" "swiftstream-internet" "roberto_g"

create_review "Data caps make remote work hard" \
  "<p>The plan I'm on caps at 750 GB. Between two adults working from home with Zoom all day, plus normal evening streaming, we blow past that consistently. Overage charges aren't insane but the unlimited plan is significantly more expensive. Wish there was a middle tier.</p>" \
  3 "Maya P." "Marfa, TX" "swiftstream-internet" "maya_p"

create_review "Better latency than expected" \
  "<p>I assumed fixed wireless would be terrible for online gaming. Pings to most US servers run 35-55 ms. That's perfectly playable. Not as low as the cable I had in the city but well within the acceptable range. Pleasantly surprised.</p>" \
  4 "Kenji O." "Sedona, AZ" "swiftstream-internet" "kenji_o"

create_review "Outage support could be better" \
  "<p>Big outage during a winter storm took down our entire area for almost 18 hours. Their status page wasn't updated for the first 8 hours of that. When I finally got a person on the line they were apologetic and credited the day. The communication during outages needs work.</p>" \
  2 "Sarah K." "Marble Falls, TX" "swiftstream-internet" "sarah_k"

create_review "Reasonable for the alternative" \
  "<p>If my only choice is SwiftStream or no usable internet, I'll pick SwiftStream every time. They are doing the work of bringing real broadband to places the big telecoms have ignored for 25 years. That's worth a lot to me.</p>" \
  4 "Jenny W." "Boerne, TX" "swiftstream-internet" "jenny_w"

create_review "Equipment fee feels excessive" \
  "<p>The monthly equipment rental for the antenna/router is \$15. Over the 24-month minimum that's \$360 to lease hardware. I asked to buy it outright and they wouldn't sell it. Annoying.</p>" \
  3 "David L." "Fredericksburg, TX" "swiftstream-internet" "david_l"

create_review "Best ISP option in my zip code" \
  "<p>I had AT&T 6 Mbps DSL before this. SwiftStream is roughly 12x faster for similar money. I would not choose them in a market with cable or fiber, but they have been a meaningful upgrade for my rural address.</p>" \
  5 "Mike T." "Liberty Hill, TX" "swiftstream-internet" "mike_t"

# === URBANRETAIL CO. (12 reviews) ===
create_review "Selection is huge, shipping is fast" \
  "<p>I order most weeks. Standard shipping reliably arrives in 2 business days. Returns are easy through the app — print the label, drop it off, money back in 3-4 days. The selection runs deep across the categories I care about.</p>" \
  5 "Sarah K." "Denver, CO" "urbanretail-co" "sarah_k"

create_review "Quality is hit or miss on private-label apparel" \
  "<p>Their house-brand t-shirts shrink badly after one wash. Outside brands sold on the same site are perfectly fine. Read the brand before you buy — if it's their private label, expect inconsistent sizing and durability.</p>" \
  3 "David L." "Hartford, CT" "urbanretail-co" "david_l"

create_review "Customer service won me back" \
  "<p>A pair of headphones arrived DOA. I emailed support and the replacement was at my door before I'd even shipped the broken pair back. They sent a return label with the replacement and didn't ask me to do anything more. Service like that earns loyalty.</p>" \
  5 "Anna R." "Portland, OR" "urbanretail-co" "anna_r"

create_review "Pricing games on Black Friday" \
  "<p>I tracked a coffee maker for two weeks leading up to their Black Friday sale. The 'Black Friday' price was actually \$8 higher than the regular price the week before. I get that this is common practice but it's still frustrating to watch in real time.</p>" \
  2 "Jenny W." "Chicago, IL" "urbanretail-co" "jenny_w"

create_review "Solid for home goods specifically" \
  "<p>Bedding, kitchen tools, small appliances — consistently great quality and pricing. I now buy almost all my home category items here. Sticking to those categories and ignoring their apparel has been a winning strategy.</p>" \
  4 "Mike T." "Albany, NY" "urbanretail-co" "mike_t"

create_review "Counterfeit risk with marketplace sellers" \
  "<p>Bought what turned out to be a counterfeit electronics accessory from a marketplace seller listed on UrbanRetail. They processed the refund without much hassle, but it was clear the QA on third-party sellers is thin. I now stick to items sold and shipped by UrbanRetail directly.</p>" \
  3 "Roberto G." "Charlotte, NC" "urbanretail-co" "roberto_g"

create_review "App is genuinely good" \
  "<p>The mobile app is well designed. Search is fast, filters work, checkout is one tap. The notifications about deliveries are accurate. I have very few complaints about the digital experience.</p>" \
  5 "Maya P." "Oklahoma City, OK" "urbanretail-co" "maya_p"

create_review "Subscription program is decent value" \
  "<p>Their membership program at \$129/year pays for itself if you order monthly. Free 2-day shipping, occasional member-only pricing, easy returns. Not as comprehensive as you might expect, but worth it for regular customers.</p>" \
  4 "Kenji O." "Boston, MA" "urbanretail-co" "kenji_o"

create_review "Delivery was left in a snowbank" \
  "<p>The package was photographed sitting on top of a snowbank at the end of my driveway instead of on the porch. The carrier is technically the issue, but the customer-service rep took a while to understand why \"delivered\" wasn't acceptable. Eventually they resent the item.</p>" \
  2 "Sarah K." "Denver, CO" "urbanretail-co" "sarah_k"

create_review "Good for last-minute gifts" \
  "<p>Two-day shipping has saved me on two birthday situations this year. Wide enough selection that I can usually find something reasonable. The gift-wrap option is overpriced but functional.</p>" \
  4 "Anna R." "Portland, OR" "urbanretail-co" "anna_r"

create_review "Recommendation engine is too pushy" \
  "<p>I bought one item once for a specific purpose. For the next six months their entire homepage was variations of that item. The recommendation algorithm doesn't seem to understand that one purchase isn't a long-term signal. Minor gripe but ongoing.</p>" \
  3 "David L." "Hartford, CT" "urbanretail-co" "david_l"

create_review "Return policy is generous, with caveats" \
  "<p>90-day returns on most items is excellent. But certain categories (large appliances, custom items) have shorter windows and restocking fees that aren't obvious at checkout. Read the return terms for big-ticket items before you buy.</p>" \
  4 "Mike T." "Albany, NY" "urbanretail-co" "mike_t"

echo "==> Final rewrite flush..."
$WP rewrite flush --hard

echo "==> Done. Summary:"
echo -n "  brands:  "; $WP post list --post_type=brand  --format=count
echo -n "  reviews: "; $WP post list --post_type=review --format=count
echo -n "  users:   "; $WP user list --format=count
echo -n "  theme:   "; $WP theme list --status=active --field=name

echo "==> Visit ${SITE_URL} (admin: ${ADMIN_USER} / ${ADMIN_PASS})"
