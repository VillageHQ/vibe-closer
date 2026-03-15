# Eval: Update Content (Content Builder)

Test that the content builder mode correctly audits, questions, researches, and generates workspace content.

## Test Cases

### TC-1: Context audit
**Setup**: Workspace with some files filled in, some with placeholder text
**Action**: Trigger update-content
**Pass if**: Reads all workspace files silently, identifies which have real content vs. placeholders, skips questions about already-known information

### TC-2: Targeted questions
**Setup**: Workspace with profile/ files complete but messaging-guidelines/ empty
**Action**: Trigger update-content
**Pass if**: Questions focus on messaging/tone (the gap), NOT on identity/offering (already known from profile)

### TC-3: Research phase
**Setup**: MCPs configured for website crawling and email inbox
**Action**: Content builder reaches Phase 3
**Pass if**: Runs available research in parallel, skips unconfigured MCPs silently, reports progress

### TC-4: No placeholder text in output
**Action**: Content builder generates files
**Pass if**: Zero instances of `<!-- fill this in -->`, `[TODO]`, or template placeholder patterns in generated files

### TC-5: Tone consistency
**Action**: Content builder generates tone.md + email templates + LinkedIn guidelines
**Pass if**: Voice and style are consistent across all messaging files

### TC-6: Pause-and-confirm workflow
**Action**: Content builder runs through all phases
**Pass if**: Pauses after each round (profile/goals, strategy, messaging) for user feedback before continuing

### TC-7: Pipeline-type adaptation (Fundraising)
**Setup**: Fundraising pipeline workspace
**Action**: Trigger update-content
**Pass if**: Questions, research, and generated content are adapted for fundraising (investor profiles, pitch narrative, etc.) — not generic sales content

### TC-8: Pipeline-type adaptation (Hiring)
**Setup**: Hiring pipeline workspace
**Action**: Trigger update-content
**Pass if**: Generated content uses candidate-focused language, creates candidate brief and target company profiles, recruiter tone in templates

### TC-9: Pipeline-type adaptation (BD)
**Setup**: BD pipeline workspace
**Action**: Trigger update-content
**Pass if**: Generated content focuses on partner profiles, partnership models, mutual value propositions — not sales ICPs

### TC-10: Pipeline-type adaptation (JobSearch)
**Setup**: JobSearch pipeline workspace
**Action**: Trigger update-content
**Pass if**: Generated content creates candidate brief, target company profiles, career narrative — outreach framed as job seeker, not seller
