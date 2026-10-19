"""Auto-fix GROUP BY expressions that no longer match a changed SELECT expression.
For each regression finding (fresh vs backup): take the SELECT item at the same statement position in the backup,
derive its key (the OLD expression), find that key among the fresh GROUP BY items (and ORDER BY/HAVING items),
and replace that span with the NEW SELECT expression's source text.
Usage: python groupby_fix.py <backup.sql> <fresh.sql> <out.sql> [marker]
Prints every replacement; exits 2 if any finding could not be resolved.
"""
import sys, json, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).parent))
from groupby_scan import (strip_comments, tokenize, is_op, split_items, strip_alias, key, unwrap_outer_parens,
                          clause_end, STOP_GROUP, scan, line_of, KW, VAR_PREFIX)


def statements(sql):
    """yield dicts: select tokens (a,fi), group items (with spans), order/having items, for each GROUP BY"""
    s = strip_comments(sql); toks = tokenize(s); n = len(toks); out = []
    for gi in range(n - 1):
        if not (toks[gi][0] == "id" and toks[gi][1] == "GROUP" and toks[gi + 1][0] == "id" and toks[gi + 1][1] == "BY"):
            continue
        d = 0; si = None
        for k in range(gi - 1, -1, -1):
            t = toks[k]
            if is_op(t, ")"): d += 1
            elif is_op(t, "("):
                d -= 1
                if d < 0: break
            elif d == 0 and t[0] == "id" and t[1] == "SELECT":
                si = k; break
        if si is None: continue
        a = si + 1
        if a < n and toks[a][0] == "id" and toks[a][1] in ("DISTINCT", "UNIQUE", "ALL"): a += 1
        d = 0; fi = None
        for k in range(a, gi):
            t = toks[k]
            if is_op(t, "("): d += 1
            elif is_op(t, ")"): d -= 1
            elif d == 0 and t[0] == "id" and t[1] == "FROM": fi = k; break
        if fi is None: continue
        ge = clause_end(toks, gi + 2, STOP_GROUP)
        gitems = [x for x in split_items(toks, gi + 2, ge) if x]
        # ORDER BY / HAVING items after group
        extra = []; k = ge
        while k < n and not is_op(toks[k], ";"):
            t = toks[k]
            if t[0] == "id" and t[1] == "HAVING":
                e = clause_end(toks, k + 1, {"ORDER", "UNION", "MINUS", "INTERSECT", "FETCH"}); extra.append(toks[k + 1:e]); k = e; continue
            if t[0] == "id" and t[1] == "ORDER" and k + 1 < n and toks[k + 1][1] == "BY":
                e = clause_end(toks, k + 2, {"UNION", "MINUS", "INTERSECT", "FETCH", "OFFSET", "FOR"})
                extra += [x for x in split_items(toks, k + 2, e) if x]; k = e; continue
            if is_op(t, ")") or (t[0] == "id" and t[1] in ("UNION", "MINUS", "INTERSECT")): break
            k += 1
        sitems = [strip_alias(x) for x in split_items(toks, a, fi) if x]
        out.append({"si": si, "gi": gi, "sitems": sitems, "gitems": gitems, "extra": extra, "s": s, "toks": toks,
                    "sel_line": line_of(s, toks[si][2]), "grp_line": line_of(s, toks[gi][2])})
    return out


def tok_end(s, t):
    """end position of a token in the comment-stripped text"""
    kind, text, pos = t
    if kind == "str":
        return pos + len(text)
    # re-measure raw token length from source
    import re
    m = re.match(r"'(?:[^']|'')*'|\"[^\"]+\"(?:\.\"[^\"]+\")*|\d+(?:\.\d+)?|[A-Za-z_][\w$#]*(?:\.[A-Za-z_\"][\w$#\"]*)*|\|\||<>|!=|>=|<=|:=|=>|\.\.|.", s[pos:])
    return pos + len(m.group())


def span(s, item):
    return item[0][2], tok_end(s, item[-1])


def fix(backup_sql, fresh_sql, marker="[E20261009-GRPBYFIX]"):
    before = {(x["kind"], x["item"], x["sev"]) for x in scan(backup_sql)}
    regress = [x for x in scan(fresh_sql) if (x["kind"], x["item"], x["sev"]) not in before]
    if not regress:
        return fresh_sql, [], []
    bst = statements(backup_sql); fst = statements(fresh_sql)
    # pair statements by order of GROUP BY occurrence (same count expected; else by select line proximity)
    if len(bst) != len(fst):
        pairs = []
        for f in fst:
            cand = min(bst, key=lambda b: abs(b["sel_line"] - f["sel_line"]))
            pairs.append((cand, f))
    else:
        pairs = list(zip(bst, fst))
    edits = []  # (start, end, new_text, info)
    unresolved = []
    for r in regress:
        # find fresh statement containing this finding
        f = next((x for x in fst if x["sel_line"] == r["select_line"] and x["grp_line"] == r["group_by_line"]), None)
        if f is None:
            unresolved.append((r, "statement not found")); continue
        b = next((bb for bb, ff in pairs if ff is f), None)
        if b is None:
            unresolved.append((r, "backup statement not paired")); continue
        s = f["s"]
        # the fresh select item matching finding text
        fitem = next((it for it in f["sitems"] if " ".join(t[1] for t in it)[:200] == r["item"]), None)
        if fitem is None:
            unresolved.append((r, "select item not found")); continue
        idx = f["sitems"].index(fitem)
        if idx >= len(b["sitems"]):
            unresolved.append((r, "backup select item index out of range")); continue
        old_key = key(b["sitems"][idx]); new_key = key(fitem)
        if old_key == new_key:
            unresolved.append((r, "select item unchanged vs backup (pre-existing mismatch or alias/position shift)")); continue
        new_text = s[span(s, fitem)[0]:span(s, fitem)[1]]
        # candidates: fresh group items (+extra) whose key == old_key (after unwrapping outer parens)
        hit = 0
        for git in f["gitems"] + f["extra"]:
            core = unwrap_outer_parens(git)
            if key(core) == old_key:
                st, en = span(s, core)
                edits.append((st, en, new_text, {"obj_line": line_of(s, st), "old": s[st:en], "new": new_text, "finding_line": r["line"], "how": "old-expr"}))
                hit += 1
        if hit == 0:
            # 2차: 같은 컬럼 집합을 가진 GROUP BY 항목(10-08 에 리터럴만 '/' 로 바뀐 NVL(x,'/') 등) — 후보가 정확히 1개일 때만
            cols = lambda it: tuple(sorted(t[1] for t in it if t[0] in ("id", "qid") and (("." in t[1]) or (t[1] not in KW and not t[1].startswith(VAR_PREFIX)))))
            want = cols(fitem)
            cands = [unwrap_outer_parens(g) for g in f["gitems"] + f["extra"]]
            cands = [c for c in cands if cols(c) == want and key(c) != new_key and want]
            if len(cands) == 1:
                core = cands[0]; st, en = span(s, core)
                edits.append((st, en, new_text, {"obj_line": line_of(s, st), "old": s[st:en], "new": new_text, "finding_line": r["line"], "how": "same-columns"}))
                hit = 1
            elif len(cands) > 1:
                unresolved.append((r, f"ambiguous: {len(cands)} GROUP BY items share columns {want}"))
            else:
                unresolved.append((r, f"no GROUP BY/ORDER BY/HAVING item equals old expr {old_key[:80]}"))
    # apply edits right-to-left on the ORIGINAL (with comments) text: positions are identical because strip_comments preserves length
    out = fresh_sql
    applied = []
    for st, en, new_text, info in sorted(edits, key=lambda e: -e[0]):
        assert strip_comments(out)[st:en] == info["old"]
        out = out[:st] + new_text + " /* " + marker + " GROUP BY 식 = SELECT 식 */" + out[en:]
        applied.append(info)
    return out, applied, unresolved


if __name__ == "__main__":
    bsql = open(sys.argv[1], encoding="utf-8", errors="ignore").read()
    fsql = open(sys.argv[2], encoding="utf-8", errors="ignore").read()
    out, applied, unresolved = fix(bsql, fsql, sys.argv[4] if len(sys.argv) > 4 else "[E20261009-GRPBYFIX]")
    for a in sorted(applied, key=lambda a: a["obj_line"]):
        print(f"  FIX[{a.get('how','')}] L{a['obj_line']} (select L{a['finding_line']}): {a['old'][:90]}  =>  {a['new'][:90]}")
    for r, why in unresolved:
        print(f"  UNRESOLVED L{r['line']} (GROUP BY L{r['group_by_line']}): {r['item'][:80]} | {why}")
    pathlib.Path(sys.argv[3]).write_text(out, encoding="utf-8")
    left = [x for x in scan(out) if (x["kind"], x["item"], x["sev"]) not in {(y["kind"], y["item"], y["sev"]) for y in scan(bsql)}]
    print(f"  applied={len(applied)} unresolved={len(unresolved)} remaining_new_findings_after_fix={len(left)}")
    sys.exit(2 if unresolved or left else 0)
