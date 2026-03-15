# Vibe-Closer Evaluations

Test suite to validate skill quality across key workflows.

## Running Evaluations

```bash
# Run all evals
./evaluations/run-evals.sh

# Run a specific eval
./evaluations/run-evals.sh --eval setup
./evaluations/run-evals.sh --eval outreach-quality
./evaluations/run-evals.sh --eval routing
```

## Eval Categories

### 1. Workflow Routing (`eval-routing.md`)
Does the skill correctly route user intents to the right action file?

### 2. Outreach Quality (`eval-outreach-quality.md`)
Are generated messages personalized, on-tone, and following template guidelines?

### 3. Setup Flow (`eval-setup.md`)
Does setup correctly create workspace, configure providers, and create DB?

### 4. Learning Loop (`eval-learning.md`)
Does the learn action correctly identify patterns and propose workspace updates?

### 5. Context Gathering (`eval-context.md`)
Does lead context aggregation pull from all configured sources correctly?

### 6. Poll New Activity (`eval-poll.md`)
Does email polling correctly detect, filter, and route incoming replies?

### 7. Add Note & Regenerate (`eval-add-note.md`)
Does user feedback get captured and activities flagged for regeneration?

### 8. Update Content (`eval-update-content.md`)
Does the content builder correctly audit workspace, ask targeted questions, and generate quality content?

## Adding New Evals

1. Create a new `eval-*.md` file with test scenarios
2. Each scenario has: input, expected behavior, pass criteria
3. Add to `run-evals.sh`
