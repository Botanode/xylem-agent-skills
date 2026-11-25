#!/usr/bin/env python3
import argparse, os, sys
from pathlib import Path

parser = argparse.ArgumentParser(description="Install Xylem skills without overwriting differing files.")
g = parser.add_mutually_exclusive_group(required=True)
g.add_argument("--project", type=Path)
g.add_argument("--global-skills", action="store_true")
parser.add_argument("--dry-run", action="store_true")
args = parser.parse_args()
root = Path(__file__).resolve().parent
# Canonical in-house library for this workspace.
source = root
if args.project:
    project = args.project.expanduser().resolve()
    if not project.is_dir(): parser.error("project directory must exist")
    target = project / ".agents" / "skills"
else:
    target = Path(os.environ.get("XDG_CONFIG_HOME") or (Path.home() / ".config")) / "opencode" / "skills"
files = [(p, target / p.relative_to(source)) for p in sorted(source.glob("*/SKILL.md"))]
if not files: parser.error("no packaged skills found")
if args.project:
    policy = project / "AGENTS.md"
    if policy.exists() or policy.is_symlink():
        print(f"PRESERVED {policy}; manually merge/review {root / 'AGENTS.md'}")
    else: files.append((root / "AGENTS.md", policy))
conflicts = []
for src, dst in files:
    if dst.is_symlink() or any(p.is_symlink() for p in dst.parents):
        conflicts.append(f"symlink path: {dst}")
    elif dst.exists() and (not dst.is_file() or src.read_bytes() != dst.read_bytes()):
        conflicts.append(f"different existing file: {dst}")
    elif any(p.exists() and not p.is_dir() for p in dst.parents):
        conflicts.append(f"parent not directory: {dst}")
if conflicts:
    print("Installation refused; no files written:")
    print("\n".join(conflicts)); sys.exit(1)
for src, dst in files:
    if dst.exists(): print(f"SKIP identical {dst}"); continue
    print(f"{'WOULD INSTALL' if args.dry_run else 'INSTALL'} {dst}")
    if not args.dry_run:
        dst.parent.mkdir(parents=True, exist_ok=True)
        with dst.open("xb") as f: f.write(src.read_bytes())
print("Dry run complete." if args.dry_run else "Install complete. Verify discovery in OpenCode and review repository rules.")
