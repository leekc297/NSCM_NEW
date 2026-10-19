"""DMF0082(forecast-price) · DMF0044(sales-reports) 공통소스 다운로드 최신화 (2026-09-15).
분류(내용 대조, 개행 정규화):
  SAME        로컬 == 공통 HEAD
  ADOPT       로컬 == 공통 이력본(내 편집 없음) 또는 공통 신규 → 공통 HEAD 채택
  MERGE       로컬이 어떤 공통 이력본과도 불일치(내 편집) → base = 로컬과 변경량 최소 이력본, git merge-file 3-way
  CONFLICT    3-way 충돌 → 로컬 유지 + .common/.base 사본 보관 (보고)
  LOCAL_ONLY  공통에 없는 로컬 파일 → 유지
usage: python common_dl.py plan|apply
"""
import difflib, json, pathlib, subprocess, sys, tempfile

REPO = pathlib.Path(r"C:\Projects\NSCM\nscm-fe")
HERE = pathlib.Path(__file__).resolve().parent
REF = "common/main"
DIRS = ["features/demand/src/pages/forecast-price", "features/demand/src/pages/sales-reports"]


def git(*a, binary=False):
    r = subprocess.run(["git", "-C", str(REPO), *a], capture_output=True)
    if r.returncode:
        raise RuntimeError(r.stderr.decode("utf-8", "replace"))
    return r.stdout if binary else r.stdout.decode("utf-8", "replace")


def norm(b):
    return b.replace(b"\r\n", b"\n")


def show(rev, path):
    try:
        return git("show", f"{rev}:nscm-fe/{path}", binary=True)
    except RuntimeError:
        return None


def main(mode):
    head = git("rev-parse", "--short", REF).strip()
    common_files = set()
    for d in DIRS:
        for line in git("ls-tree", "-r", "--name-only", REF, f"nscm-fe/{d}").splitlines():
            common_files.add(line[len("nscm-fe/"):])
    local_files = {str(p.relative_to(REPO)).replace("\\", "/") for d in DIRS for p in (REPO / d).rglob("*") if p.is_file()}
    rows = []
    for rel in sorted(common_files | local_files):
        lp = REPO / rel
        loc = lp.read_bytes() if lp.exists() else None
        com = show(REF, rel) if rel in common_files else None
        if com is None:
            rows.append({"file": rel, "cls": "LOCAL_ONLY"}); continue
        if loc is None:
            rows.append({"file": rel, "cls": "ADOPT", "why": "공통 신규"}); continue
        if norm(loc) == norm(com):
            rows.append({"file": rel, "cls": "SAME"}); continue
        hist = git("log", "--format=%h", REF, "--", f"nscm-fe/{rel}").split()
        best, best_d, matched = None, None, None
        for h in hist:
            b = show(h, rel)
            if b is None:
                continue
            if norm(b) == norm(loc):
                matched = h; break
            dcount = sum(1 for x in difflib.unified_diff(norm(b).decode("utf-8", "replace").splitlines(), norm(loc).decode("utf-8", "replace").splitlines(), lineterm="", n=0)
                         if x[:1] in "+-" and not x.startswith(("+++", "---")))
            if best_d is None or dcount < best_d:
                best, best_d = h, dcount
        if matched:
            rows.append({"file": rel, "cls": "ADOPT", "why": f"로컬 = 공통 {matched} 판본"}); continue
        rows.append({"file": rel, "cls": "MERGE", "base": best, "local_vs_base": best_d})

    if mode == "apply":
        bk = HERE / "BACKUP_LOCAL"
        for r in rows:
            rel = r["file"]; lp = REPO / rel
            if lp.exists() and r["cls"] != "SAME":
                t = bk / rel; t.parent.mkdir(parents=True, exist_ok=True); t.write_bytes(lp.read_bytes())
            if r["cls"] == "ADOPT":
                lp.parent.mkdir(parents=True, exist_ok=True); lp.write_bytes(show(REF, rel))
            elif r["cls"] == "MERGE":
                with tempfile.TemporaryDirectory() as td:
                    td = pathlib.Path(td)
                    (td / "local").write_bytes(norm(lp.read_bytes()))
                    (td / "base").write_bytes(norm(show(r["base"], rel)))
                    (td / "common").write_bytes(norm(show(REF, rel)))
                    res = subprocess.run(["git", "merge-file", "-p", "-L", "local", "-L", "base", "-L", "common",
                                          str(td / "local"), str(td / "base"), str(td / "common")], capture_output=True)
                    if res.returncode == 0:
                        crlf = b"\r\n" in show(REF, rel)
                        out = res.stdout.replace(b"\n", b"\r\n") if crlf else res.stdout
                        lp.write_bytes(out); r["result"] = "merged"
                    else:
                        r["cls"] = "CONFLICT"; r["result"] = f"충돌 {res.returncode}건 — 로컬 유지"
                        c = HERE / "CONFLICT" / rel; c.parent.mkdir(parents=True, exist_ok=True)
                        pathlib.Path(str(c) + ".common").write_bytes(show(REF, rel))
                        pathlib.Path(str(c) + ".base").write_bytes(show(r["base"], rel))
                        pathlib.Path(str(c) + ".merge_conflict").write_bytes(res.stdout)
        (HERE / "result.json").write_text(json.dumps({"ref": head, "rows": rows}, ensure_ascii=False, indent=2), encoding="utf-8")
    print("common HEAD", head)
    for r in rows:
        if r["cls"] != "SAME":
            print(f"{r['cls']:<10} {r['file']}  {r.get('why') or ''}{('base ' + r['base'] + ' Δ' + str(r['local_vs_base'])) if r.get('base') else ''} {r.get('result') or ''}")
    print({c: sum(1 for r in rows if r["cls"] == c) for c in ("SAME", "ADOPT", "MERGE", "CONFLICT", "LOCAL_ONLY")})


if __name__ == "__main__":
    main(sys.argv[1])
