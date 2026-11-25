#!/usr/bin/env python3
"""Validate the unified in-house Xylem skill library.

Accepts two historical frontmatter/section styles:
  - pack style: JSON-quoted description; Procedure / Exit evidence / Guardrails
  - house style: plain description; MUST rules + a completion section + References
Requires one catalog entry per skill and globally unique IDs.
"""
from pathlib import Path
import json
import re
import sys

root = Path(__file__).resolve().parent
paths = sorted(root.glob('xylem-*/SKILL.md'))
errors = []
seen = set()

for path in paths:
    raw = path.read_text(encoding='utf-8')
    parts = raw.split('---\n', 2)
    if len(parts) != 3 or parts[0] != '':
        errors.append(f'{path}: missing frontmatter')
        continue
    front = {}
    for line in parts[1].splitlines():
        if ': ' in line:
            key, value = line.split(': ', 1)
            front[key] = value.strip()
    name = front.get('name', '')
    if name != path.parent.name or not re.fullmatch(r'[a-z0-9]+(?:-[a-z0-9]+)*', name) or len(name) > 64:
        errors.append(f'{path}: invalid ID')
    if name in seen:
        errors.append(f'{path}: duplicate ID')
    seen.add(name)
    description = front.get('description', '')
    if description.startswith('"'):
        try:
            description = json.loads(description)
        except ValueError:
            errors.append(f'{path}: invalid JSON description')
    if not isinstance(description, str) or not (1 <= len(description) <= 1024):
        errors.append(f'{path}: invalid description')

    body = parts[2]
    pack_style = all(s in body for s in ('## Procedure', '## Exit evidence', '## Guardrails'))
    house_style = ('MUST' in body and '## References' in body and any(
        marker in body for marker in (
            '## Done when', '## Completion criteria', '## Status and completion',
            '## Exit evidence', '## Completion', '*Done when*', 'Done when',
        )
    ))
    # Legacy pre-existing skills remain valid with only section headings; the
    # strict MUST/completion/References checks apply to the new platform skills.
    legacy_style = bool(re.search(r'^## ', body, re.M))
    if not (pack_style or house_style or legacy_style):
        errors.append(f'{path}: no recognised structure')
    if name.startswith('xylem-platform-') or name in ('xylem-lotus-kernel', 'xylem-agent-workflow'):
        if not house_style:
            errors.append(f'{path}: platform skill missing MUST/completion/References')

catalog = root / 'SKILL-CATALOG.md'
if not catalog.is_file():
    errors.append('missing SKILL-CATALOG.md')
else:
    text = catalog.read_text(encoding='utf-8')
    listed = set(re.findall(r'`(xylem-[a-z0-9-]+)`', text))
    missing = sorted(seen - listed)
    if missing:
        errors.append('catalog missing: ' + ', '.join(missing))

print(f'Validated {len(paths)} skill files; {len(errors)} errors')
for error in errors:
    print(error)
sys.exit(bool(errors))
