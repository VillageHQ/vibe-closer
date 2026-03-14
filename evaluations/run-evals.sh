#!/bin/bash
# Run vibe-closer evaluations
# Usage: ./evaluations/run-evals.sh [--eval <name>]

set -euo pipefail

EVAL_DIR="$(dirname "$0")"
SPECIFIC_EVAL=""

while [[ $# -gt 0 ]]; do
  case $1 in
    --eval)
      SPECIFIC_EVAL="$2"
      shift 2
      ;;
    *)
      echo "Usage: $0 [--eval <name>]"
      echo "Available evals: routing, outreach-quality, setup, learning, context"
      exit 1
      ;;
  esac
done

run_eval() {
  local eval_file="$1"
  local eval_name
  eval_name=$(basename "$eval_file" .md | sed 's/eval-//')

  echo "========================================="
  echo "Running eval: $eval_name"
  echo "========================================="
  echo "Eval file: $eval_file"
  echo ""
  echo "To run this eval, use Claude Code with:"
  echo "  claude --print \"Read $eval_file and execute each test case against the vibe-closer skill. Report pass/fail for each.\""
  echo ""
}

if [[ -n "$SPECIFIC_EVAL" ]]; then
  eval_file="$EVAL_DIR/eval-${SPECIFIC_EVAL}.md"
  if [[ ! -f "$eval_file" ]]; then
    echo "Error: Eval '$SPECIFIC_EVAL' not found at $eval_file"
    exit 1
  fi
  run_eval "$eval_file"
else
  for eval_file in "$EVAL_DIR"/eval-*.md; do
    run_eval "$eval_file"
  done
fi

echo "Done. Run individual evals with: $0 --eval <name>"
