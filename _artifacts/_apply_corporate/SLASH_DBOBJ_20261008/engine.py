# -*- coding: utf-8 -*-
"""[E20261008-SLASHOBJ] FRESH-GATE 내장 — plan 이 ALL_SOURCE/DBMS_METADATA 원문을 재조회해 SHA1 을 기록하고, apply 가 적용 직전 다시 읽어 같은지 assert 한다(다르면 SKIP).
NULL 센티널 '/' 전환 — DB 객체 변경 엔진 (시트 2_DB객체_변경 2,169줄 / 110객체)

사용:
  python engine.py plan                      # 사내 FRESH 원문 재조회 → 줄 매칭·새 줄 계산 → patches.json + PLAN_REPORT.md (DB 무변경)
  python engine.py apply [--only OBJ,...]    # plan 결과로 CREATE OR REPLACE (객체별: 백업 → 적용 → ALL_ERRORS/VALID/줄수 → 실패 시 즉시 원복)
  python engine.py apply --dsn host:port/svc --user U --pass P   # 다른 DB(클라우드) 에 같은 패치를 그 DB 의 FRESH 원문 기준으로 적용
  python engine.py verify                    # 적용 후 재스캔: 객체별 남은 '-' 줄 수 vs 시트 4(유지) 대조

원칙(시트 요약 '적용 절차'): 줄 번호는 참고값 → '현재' 텍스트로 FRESH 원문에서 줄을 찾는다(정확 일치 → 유일 일치 → 잘림 접두 일치).
같은 줄의 여러 행은 difflib 편집 구간을 합쳐 한 줄로 적용(겹치면 미해결). 한 줄이라도 미해결이면 그 객체는 적용하지 않고 보고한다.
"""
import sys, re, json, pathlib, difflib, collections, datetime, argparse, hashlib
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import openpyxl, oracledb
from ora import conn_info

HERE = pathlib.Path(__file__).resolve().parent
XLSX = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_diagnostics\SLASH_SENTINEL_DMLRISK_20261007\슬래시전환_DEFAULT_DB객체_정리_20261007_v4.xlsx")
OWNER = "SCM_MGR"
MARK = "[E20261008-SLASHOBJ]"

# ---------- 시트 읽기 ----------
def load_sheet(name):
    ws = openpyxl.load_workbook(XLSX, read_only=True)[name]
    rows = list(ws.iter_rows(values_only=True)); hdr = rows[0]; I = {h: i for i, h in enumerate(hdr)}
    return [dict(zip(hdr, r)) for r in rows[1:]], I

def targets():
    rows, _ = load_sheet("2_DB객체_변경")
    by_obj = collections.OrderedDict()
    for r in rows:
        key = (r["객체유형"], r["객체명"])
        by_obj.setdefault(key, collections.OrderedDict()).setdefault(int(r["줄"]), []).append(r)
    return by_obj

# ---------- 원문 ----------
def connect(args):
    if args and args.dsn:
        return oracledb.connect(user=args.user, password=args.password, dsn=args.dsn)
    u, p, d = conn_info(); return oracledb.connect(user=u, password=p, dsn=d)

def fetch_source(cur, otype, name):
    """PACKAGE BODY/PROCEDURE/FUNCTION: ALL_SOURCE 줄 리스트(개행 제거). VIEW: DBMS_METADATA DDL 을 줄로."""
    if otype == "VIEW":
        cur.execute("SELECT DBMS_METADATA.GET_DDL('VIEW', :n, :o) FROM dual", n=name, o=OWNER)
        ddl = cur.fetchone()[0]; ddl = ddl.read() if hasattr(ddl, "read") else str(ddl)
        return [l.rstrip("\r") for l in ddl.split("\n")], "ddl"
    cur.execute("SELECT text FROM all_source WHERE owner=:o AND name=:n AND type=:t ORDER BY line", o=OWNER, n=name, t=otype)
    lines = [(r[0] or "").rstrip("\r\n") for r in cur.fetchall()]
    return lines, "source"

def obj_status(cur, otype, name):
    cur.execute("SELECT status, TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') FROM all_objects WHERE owner=:o AND object_name=:n AND object_type=:t", o=OWNER, n=name, t=otype)
    r = cur.fetchone(); return r if r else (None, None)

def errors(cur, otype, name):
    cur.execute("SELECT line, position, text FROM all_errors WHERE owner=:o AND name=:n AND type=:t AND attribute='ERROR' ORDER BY sequence", o=OWNER, n=name, t=otype)
    return cur.fetchall()

# ---------- 규칙 (잘림/after==cur 보정용) ----------
RX_VAR = re.compile(r"IN\s*\(\s*'-'\s*,\s*'--'\s*\)\s*THEN\s*'-'", re.I)
RX_NVL_SIMPLE = re.compile(r"(NVL\s*\((?:[^()]|\([^()]*\))*?,\s*)'-'(\s*\))", re.I)
RX_NVL_DQ = re.compile(r"(NVL\s*\((?:[^()]|\([^()]*\))*?,\s*)''-''(\s*\))", re.I)   # 동적 SQL 문자열 안 NVL(x,''-'')
RX_CMP_DQ = re.compile(r"(''-''\s*\))\s*(=|<>|!=)\s*''-''", re.I)

def rule_line(line, actions):
    """시트 '변경 후' 가 없을 때(잘림·다중행 NVL 등) 전체 줄에 규칙 적용. 변경 없으면 None."""
    new = line
    if any(a == "변형정규화→'/'" for a in actions):
        new = RX_VAR.sub("IN ('-', '--', '/') THEN '/'", new)
    if any(a == "NVL→'/'" for a in actions):
        new = RX_NVL_SIMPLE.sub(r"\1'/'\2", new)
        new = RX_NVL_DQ.sub(r"\1''/''\2", new)
        new = re.sub(r"(NVL\s*\((?:[^()]|\([^()]*\))*?,\s*''/''\s*\))\s*(=|<>|!=)\s*''-''", r"\1 \2 ''/''", new, flags=re.I)   # NVL(x,''/'') = ''-'' → ''/''
        new = re.sub(r"(NVL\s*\((?:[^()]|\([^()]*\))*?,\s*'/'\s*\))\s*(=|<>|!=)\s*'-'", r"\1 \2 '/'", new, flags=re.I)       # NVL(x,'/') = '-' → '/'
    if any(a in ("비교→'/'", "리터럴→'/'") for a in actions) and new == line and ("''-''" in line) and line.count("''-''") == 1:
        new = line.replace("''-''", "''/''")
    if any(a in ("리터럴→'/'", "비교→'/'", "NVL→'/'") for a in actions) and new == line:
        if line.count("'-'") == 1: new = line.replace("'-'", "'/'")   # 여러 줄에 걸친 NVL(...) 의 닫는 줄 ", '-')" 등
    return new if new != line else None

def map_occurrences(cur_sheet, afters, real):
    """시트 '현재'→'변경 후' 가 '-'→'/' 자리 치환만일 때, 그 출현 순번을 실제 줄(공백만 다른)에 적용"""
    occ = [m.start() for m in re.finditer(r"'-'", cur_sheet)]
    idxs = set()
    for a in afters:
        if not a or a == cur_sheet or len(a) != len(cur_sheet): return None
        for k, pos in enumerate(occ):
            if a[pos:pos + 3] == "'/'": idxs.add(k)
            elif a[pos:pos + 3] != "'-'": return None
        if any(a[i] != cur_sheet[i] for i in range(len(a)) if not any(p <= i < p + 3 for p in occ)): return None
    ro = [m.start() for m in re.finditer(r"'-'", real)]
    if len(ro) != len(occ) or not idxs: return None
    out = real
    for k in sorted(idxs, reverse=True): out = out[:ro[k]] + "'/'" + out[ro[k] + 3:]
    return out

# ---------- 줄 매칭 ----------
def locate(src, line_no, cur_text, shift=None):
    """(index, how) — 정확 줄 일치 / 전체 검색 유일 일치 / 객체 공통 줄밀림(shift) 일치 / 잘림 접두 유일 일치 / None"""
    cur = (cur_text or "").strip()
    if not cur: return None, "empty"
    if 1 <= line_no <= len(src) and src[line_no - 1].strip() == cur: return line_no - 1, "exact"
    hits = [i for i, l in enumerate(src) if l.strip() == cur]
    if len(hits) == 1: return hits[0], "search"
    if len(hits) > 1:
        if shift is not None:
            sh = [i for i in hits if i - (line_no - 1) == shift]
            if len(sh) == 1: return sh[0], "shift"
            sh = [i for i in hits if abs(i - (line_no - 1) - shift) <= 3]
            if len(sh) == 1: return sh[0], "shift~3"
        near = sorted(hits, key=lambda i: abs(i - (line_no - 1)))
        if abs(near[0] - (line_no - 1)) <= 30 and (len(near) < 2 or abs(near[1] - (line_no - 1)) > 30): return near[0], "search-near"
        return None, f"ambiguous({len(hits)})"
    if len(cur) >= 480:  # 잘림
        pref = cur[:400]; hits = [i for i, l in enumerate(src) if l.strip().startswith(pref)]
        if len(hits) == 1: return hits[0], "prefix"
        if len(hits) > 1:
            near = sorted(hits, key=lambda i: abs(i - (line_no - 1)))
            if abs(near[0] - (line_no - 1)) <= 30: return near[0], "prefix-near"
    # 공백 차이 허용(탭/연속 공백)
    norm = lambda s: re.sub(r"\s+", " ", s.strip())
    hits = [i for i, l in enumerate(src) if norm(l) == norm(cur)]
    if len(hits) == 1: return hits[0], "ws-norm"
    return None, "notfound"

def merge_edits(cur, afters):
    """여러 행의 '변경 후' 를 cur 기준 편집구간으로 합친다. 겹치면 None."""
    ops = []
    for a in afters:
        if a is None or a == cur: continue
        sm = difflib.SequenceMatcher(None, cur, a, autojunk=False)
        for tag, i1, i2, j1, j2 in sm.get_opcodes():
            if tag != "equal": ops.append((i1, i2, a[j1:j2]))
    if not ops: return None
    ops.sort()
    merged = []
    for o in ops:
        if merged and o[0] < merged[-1][1]:
            if o == merged[-1]: continue  # 같은 편집 중복
            return None
        merged.append(o)
    out = cur
    for i1, i2, rep in reversed(merged): out = out[:i1] + rep + out[i2:]
    return out

def canon(s):
    """허용 변환을 되돌려 원문과 같아지는지 보는 정규화: '/'→'-', NVL(NULLIF(RTRIM(x),''),'-')→NVL(x,'-'), IN('-','--','-')→IN('-','--'), 공백·대소문자 무시"""
    s = s.replace("'/'", "'-'").replace("''/''", "''-''")
    s = re.sub(r"NVL\(\s*NULLIF\(\s*RTRIM\((.*?)\)\s*,\s*''\s*\)\s*,\s*'-'\s*\)", lambda m: "NVL(" + m.group(1) + ",'-')", s, flags=re.I)
    s = re.sub(r"IN\s*\(\s*'-'\s*,\s*'--'\s*,\s*'-'\s*\)", "IN ('-','--')", s, flags=re.I)
    s = re.sub(r"\s+", "", s)
    s = re.sub(r",'", ",'", s)
    return s.upper()

def valid_change(old, new):
    return new != old and new.count("'/'") + new.count("''/''") > old.count("'/'") + old.count("''/''") and canon(old) == canon(new)

def compute_new_line(src_line, rows):
    new, note = _compute_new_line(src_line, rows)
    if new is None: return None, note
    if valid_change(src_line, new): return new, note
    # 시트 변경 후 병합 결과가 규칙 범위를 벗어남(행별 변경안 표기 차이 등) → 결정적 규칙으로 재산출
    lead = src_line[:len(src_line) - len(src_line.lstrip())]
    alt = rule_line(src_line.strip(), [r["적용 액션(규칙)"] for r in rows])
    if alt and valid_change(src_line, lead + alt): return lead + alt, "rule(merge-invalid)"
    return None, "merge-invalid"

def _compute_new_line(src_line, rows):
    """해당 줄의 시트 행들 → 새 줄. 반환 (new_line or None, note)"""
    cur_sheet = max((r["현재"] or "" for r in rows), key=len).strip()
    actions = [r["적용 액션(규칙)"] for r in rows]
    truncated = any(r.get("원문 500자 잘림('-' 는 뒤쪽)") == "Y" for r in rows) or len(cur_sheet) >= 480
    afters = [(r["변경 후"] or "").strip() for r in rows]
    lead = src_line[:len(src_line) - len(src_line.lstrip())]
    real = src_line.strip()
    if not truncated and real == cur_sheet:
        usable = [a for a in afters if a and a != cur_sheet]
        if usable:
            merged = merge_edits(cur_sheet, usable)
            if merged is None: return None, "merge-overlap"
            # 행 중 변경 후 가 없는(after==cur) 행이 있으면 그 행의 규칙도 추가 적용
            missing = [r["적용 액션(규칙)"] for r, a in zip(rows, afters) if not a or a == cur_sheet]
            if missing:
                extra = rule_line(merged, missing)
                if extra: merged = extra
            return lead + merged, "sheet"
        new = rule_line(real, actions)
        return (lead + new, "rule(after==cur)") if new else (None, "no-change-derivable")
    # 잘림 또는 FRESH 원문이 시트와 다름(공백 등) → ① 출현 순번 매핑 ② 규칙 적용
    if not truncated and re.sub(r"\s+", " ", real) == re.sub(r"\s+", " ", cur_sheet):
        mapped = map_occurrences(cur_sheet, [a for a in afters if a], real)
        if mapped: return lead + mapped, "occurrence-map(ws-diff)"
    new = rule_line(real, actions)
    if new: return lead + new, "rule(" + ("truncated" if truncated else "ws-diff") + ")"
    # 규칙으로 안 되면 시트 변경 후를 접두 범위에만 적용 시도
    if truncated:
        for a in afters:
            if a and a != cur_sheet and len(a) >= 480 and real.startswith(cur_sheet[:400]):
                head = merge_edits(cur_sheet, [a])
                if head and real.startswith(cur_sheet): return lead + head + real[len(cur_sheet):], "sheet-prefix"
    return None, "no-change-derivable"

# ---------- plan ----------
KEEP_BY_OBJ = {}
def load_keep():
    rows, _ = load_sheet("4_DB객체_유지")
    for r in rows: KEEP_BY_OBJ.setdefault((r["객체유형"], r["객체명"]), {})[int(r["줄"])] = (r["현재"] or "").strip()

def plan(args):
    load_keep(); by_obj = targets(); con = connect(args); cur = con.cursor()
    patches = {}; report = []; stat = collections.Counter(); unresolved_rows = []
    only = set(args.only.split(",")) if getattr(args, "only", None) else None
    for (otype, name), lines in by_obj.items():
        if only and name not in only: continue
        status, ddl = obj_status(cur, otype, name)
        if status is None:
            report.append(dict(object=f"{otype} {name}", result="MISSING", lines=sum(len(v) for v in lines.values()))); stat["obj_missing"] += 1; continue
        src, kind = fetch_source(cur, otype, name)
        edits = []; bad = []
        first = {lno: locate(src, lno, max((r["현재"] or "" for r in rows), key=len)) for lno, rows in lines.items()}
        keep_lines = KEEP_BY_OBJ.get((otype, name), {})   # 시트4(유지) 의 (줄 → 텍스트)
        # (patched9) 순번 완전일치 우선: 같은 텍스트가 원문에 N번, 시트2+시트4 에도 정확히 N줄이면 순서대로 1:1 이 유일 정답.
        #   줄밀림이 구간마다 다를 때 exact(우연히 같은 줄번호의 다른 출현)/search-near(가까운 다른 출현)가 틀리므로 1차 결과를 덮어쓴다.
        by_text_all = collections.defaultdict(list)
        for lno, rows in lines.items(): by_text_all[max((r["현재"] or "" for r in rows), key=len).strip()].append(lno)
        for txt, lnos in by_text_all.items():
            hits_all = [i for i, l in enumerate(src) if l.strip() == txt]
            klns = [kl for kl, kt in keep_lines.items() if kt == txt and kl not in lnos]
            if len(hits_all) >= 2 and len(hits_all) == len(lnos) + len(klns):
                for lno, i in zip(sorted(set(lnos) | set(klns)), hits_all):
                    if lno in lnos: first[lno] = (i, "ordinal-full")
        # (patched9) 1차 결과끼리 같은 원문 줄을 가리키면(search-near 충돌 등) 둘 다 미확정으로 돌려 2차에서 다시 찾는다.
        cnt = collections.Counter(idx for idx, how in first.values() if idx is not None)
        for lno, (idx, how) in list(first.items()):
            if idx is not None and cnt[idx] > 1: first[lno] = (None, f"collide({how})")
        shifts = [idx - (lno - 1) for lno, (idx, how) in first.items() if idx is not None and how in ("exact", "search", "ordinal-full")]
        shift = sorted(shifts)[len(shifts) // 2] if shifts else None   # 객체 공통 줄밀림(중앙값)
        # 순번 매핑: 같은 텍스트가 원문에 N번, 시트에도 그 객체에 N줄 있으면 순서대로 1:1 (전부 변경 대상이므로 안전)
        by_text = collections.defaultdict(list)
        for lno, rows in lines.items(): by_text[max((r["현재"] or "" for r in rows), key=len).strip()].append(lno)
        ordinal = {}
        used0 ={idx for idx, how in first.values() if idx is not None}
        for txt, lnos in by_text.items():
            hits = [i for i, l in enumerate(src) if l.strip() == txt]
            lnos = [l for l in lnos if first[l][0] is None]; hits = [i for i in hits if i not in used0]
            if len(hits) == 1 and len(lnos) == 1: ordinal[lnos[0]] = hits[0]; continue
            if len(hits) <= 1: continue
            if len(hits) == len(lnos):
                for lno, i in zip(sorted(lnos), hits): ordinal[lno] = i
            else:
                # 시트2 + 시트4 의 같은 텍스트 줄을 합쳐 순번 매핑 (유지 줄은 매핑만 하고 변경하지 않음)
                all_lnos = sorted(set(lnos) | {kl for kl, kt in keep_lines.items() if kt == txt})
                if len(all_lnos) == len(hits):
                    for lno, i in zip(all_lnos, hits):
                        if lno in lnos: ordinal[lno] = i
        used = {idx for idx, how in first.values() if idx is not None}   # 1차(exact/search)로 확정된 줄은 다른 시트 줄의 후보에서 제외(중복 매핑 금지)
        for lno, rows in lines.items():
            idx, how = first[lno]
            txt = max((r["현재"] or "" for r in rows), key=len).strip()
            if idx is None:   # (patched9) 2차 후보를 순서대로 모아 아직 안 쓰인 첫 후보만 채택 — 이미 쓰인 줄로의 중복 매핑 금지
                cands = []
                if shift is not None:
                    i2, h2 = locate(src, lno, txt, shift)
                    if i2 is not None: cands.append((i2, h2))
                if lno in ordinal: cands.append((ordinal[lno], "ordinal"))
                if shift is not None:
                    hits = [i for i, l in enumerate(src) if l.strip() == txt and i not in used]
                    if len(hits) >= 2:
                        ds = sorted((abs(i - (lno - 1 + shift)), i) for i in hits)
                        if ds[0][0] <= 60 and ds[1][0] >= 3 * max(ds[0][0], 1): cands.append((ds[0][1], f"nearest-shift({ds[0][0]})"))
                    elif len(hits) == 1 and abs(hits[0] - (lno - 1 + shift)) <= 60: cands.append((hits[0], "last-free"))
                free = [(i, h) for i, h in cands if i not in used]
                if free: idx, how = free[0]
                elif cands: how = "dup-target"
            if idx is not None: used.add(idx)
            if idx is None:
                txt = max((r["현재"] or "" for r in rows), key=len).strip(); hits = [i + 1 for i, l in enumerate(src) if l.strip() == txt]
                bad.append(dict(line=lno, why=how, cur=(rows[0]["현재"] or "")[:160], hits=hits[:20], shift=shift, now_at_line=(src[lno - 1].strip()[:120] if 0 < lno <= len(src) else None))); continue
            new, note = compute_new_line(src[idx], rows)
            if new is None:
                bad.append(dict(line=lno, found=idx + 1, why=note, cur=src[idx][:160])); continue
            if new.count("'-'") == src[idx].count("'-'") and "'/'" not in new.replace(src[idx], ""):
                bad.append(dict(line=lno, found=idx + 1, why="no-dash-changed", cur=src[idx][:160], new=new[:160])); continue
            edits.append(dict(sheet_line=lno, found=idx + 1, how=how, note=note, rows=len(rows), actions=sorted({r["적용 액션(규칙)"] for r in rows}), old=src[idx], new=new))
        for b in bad: unresolved_rows.append(dict(object=f"{otype} {name}", **b))
        res = "READY" if not bad else "BLOCKED"
        stat[res] += 1; stat["edits"] += len(edits); stat["bad"] += len(bad)
        patches[f"{otype}|{name}"] = dict(object_type=otype, name=name, kind=kind, status=status, last_ddl=ddl, source_lines=len(src),
                                          source_sha1=hashlib.sha1("\n".join(src).encode("utf-8")).hexdigest(), edits=edits, unresolved=bad, result=res)
        report.append(dict(object=f"{otype} {name}", result=res, lines=len(lines), edits=len(edits), unresolved=len(bad), how=collections.Counter(e["how"] for e in edits), note=collections.Counter(e["note"] for e in edits)))
    if only and (HERE / "patches.json").exists():   # --only: 다른 객체의 기존 계획은 보존
        prev = json.loads((HERE / "patches.json").read_text(encoding="utf-8"))["patches"]; prev.update(patches); patches = prev
    (HERE / "patches.json").write_text(json.dumps(dict(planned_at=datetime.datetime.now().isoformat(timespec="seconds"), db=con.dsn, patches=patches), ensure_ascii=False, indent=1), encoding="utf-8")
    md = [f"# {MARK} PLAN — {datetime.datetime.now():%Y-%m-%d %H:%M} · DB {con.dsn}", "", f"객체 {len(by_obj)} · READY {stat['READY']} · BLOCKED {stat['BLOCKED']} · MISSING {stat['obj_missing']} · 적용 줄 {stat['edits']} · 미해결 줄 {stat['bad']}", "",
          "| 객체 | 결과 | 시트 줄 | 적용 줄 | 미해결 | 매칭 | 산출 |", "|---|---|---:|---:|---:|---|---|"]
    for r in report:
        md.append(f"| {r['object']} | {r['result']} | {r['lines']} | {r.get('edits','')} | {r.get('unresolved','')} | {dict(r['how']) if r.get('how') else ''} | {dict(r['note']) if r.get('note') else ''} |")
    if unresolved_rows:
        md += ["", "## 미해결 줄", "", "| 객체 | 시트 줄 | 찾은 줄 | 사유 | 시트 현재 | 지금 그 줄 | 후보 줄 |", "|---|---:|---:|---|---|---|---|"]
        for b in unresolved_rows:
            cur_esc = (b.get('cur') or '').replace('|', '\\|')[:120]
            now_esc = (b.get('now_at_line') or '').replace('|', '\\|')[:100]
            md.append(f"| {b['object']} | {b['line']} | {b.get('found','')} | {b['why']} | `{cur_esc}` | `{now_esc}` | {b.get('hits','')} |")
    (HERE / "PLAN_REPORT.md").write_text("\n".join(md), encoding="utf-8")
    print("PLAN:", dict(stat)); print("unresolved:", len(unresolved_rows))
    for b in unresolved_rows[:40]: print("  ", b["object"], "L", b["line"], b["why"], "|", (b.get("cur") or "")[:100])

# ---------- apply ----------
def build_ddl(p, src_lines):
    if p["kind"] == "ddl":
        return "\n".join(src_lines).rstrip().rstrip(";")
    text = "\n".join(src_lines)
    return "CREATE OR REPLACE " + text.lstrip()

def apply(args):
    P = json.loads((HERE / "patches.json").read_text(encoding="utf-8"))["patches"]
    only = set(args.only.split(",")) if args.only else None
    con = connect(args); cur = con.cursor(); tag = "corp" if not args.dsn else re.sub(r"\W+", "_", args.dsn)
    bk = HERE / f"00_BACKUP_{tag}"; nw = HERE / f"01_NEW_{tag}"; bk.mkdir(exist_ok=True); nw.mkdir(exist_ok=True)
    log = []; stat = collections.Counter()
    for key, p in P.items():
        if p["result"] != "READY": stat["skip_blocked"] += 1; continue
        if only and p["name"] not in only: continue
        otype, name = p["object_type"], p["name"]
        src, kind = fetch_source(cur, otype, name)  # FRESH-GATE: 적용 직전 DB 원문 재조회
        sha = hashlib.sha1("\n".join(src).encode("utf-8")).hexdigest()
        # FRESH-GATE assert: plan 시점 원문(source_sha1)과 동일해야 적용. 다르면 plan 을 다시 돌려야 한다 (다른 DB 면 그 DB 로 plan 부터).
        if sha != p["source_sha1"]:
            log.append(dict(object=key, result="SKIP(FRESH-GATE: source changed since plan)", sha_plan=p["source_sha1"], sha_now=sha)); stat["skip_fresh"] += 1; print("SKIP FRESH-GATE", key); continue
        # FRESH-GATE 통과(SHA 동일) → plan 이 확정한 줄 번호(found)를 그대로 사용. 줄 텍스트가 plan 의 old 와 같은지 한 번 더 확인
        new_src = list(src); applied = 0; miss = []
        for e in p["edits"]:
            i = e["found"] - 1
            if not (0 <= i < len(new_src)) or new_src[i].rstrip() != e["old"].rstrip():
                miss.append(dict(line=e["found"], old=e["old"][:120], now=(new_src[i][:120] if 0 <= i < len(new_src) else None))); continue
            new_src[i] = e["new"]; applied += 1
        if miss:
            log.append(dict(object=key, result="SKIP(patch-miss)", applied=applied, miss=miss)); stat["skip_miss"] += 1; print("SKIP", key, "miss", len(miss)); continue
        (bk / f"{name}.{otype.replace(' ', '_')}.sql").write_text("\n".join(src), encoding="utf-8")
        (nw / f"{name}.{otype.replace(' ', '_')}.sql").write_text("\n".join(new_src), encoding="utf-8")
        ddl = build_ddl(p, new_src)
        try:
            cur.execute(ddl)
        except Exception as ex:
            try: cur.execute(build_ddl(p, src))
            except Exception as ex2: log.append(dict(object=key, result="FAIL+RESTORE_FAIL", error=str(ex)[:300], restore_error=str(ex2)[:200])); stat["fail"] += 1; print("FAIL", key, str(ex)[:160]); continue
            log.append(dict(object=key, result="FAIL(restored)", error=str(ex)[:300])); stat["fail"] += 1; print("FAIL(restored)", key, str(ex)[:160]); continue
        errs = errors(cur, otype, name); st, ddl_t = obj_status(cur, otype, name)
        src2, _ = fetch_source(cur, otype, name)
        if errs or st != "VALID":
            cur.execute(build_ddl(p, src)); log.append(dict(object=key, result="INVALID(restored)", errors=[f"L{l}:{c} {t[:120]}" for l, c, t in errs][:5])); stat["fail"] += 1
            print("INVALID(restored)", key, errs[:2]); continue
        ok_lines = (len(src2) == len(src)) if kind == "source" else True
        log.append(dict(object=key, result="OK", applied=applied, lines_before=len(src), lines_after=len(src2), same_line_count=ok_lines, sha_before=sha, status=st, last_ddl=ddl_t)); stat["ok"] += 1; stat["applied_lines"] += applied
        print("OK", key, "lines", applied, "| line count", len(src), "->", len(src2))
    (HERE / f"APPLY_LOG_{tag}.json").write_text(json.dumps(dict(at=datetime.datetime.now().isoformat(timespec="seconds"), db=con.dsn, stat=dict(stat), log=log), ensure_ascii=False, indent=1), encoding="utf-8")
    print("APPLY:", dict(stat))

# ---------- verify ----------
def verify(args):
    P = json.loads((HERE / "patches.json").read_text(encoding="utf-8"))["patches"]
    keep, _ = load_sheet("4_DB객체_유지"); keep_cnt = collections.Counter((r["객체유형"], r["객체명"]) for r in keep)
    con = connect(args); cur = con.cursor(); out = []
    for key, p in P.items():
        otype, name = p["object_type"], p["name"]
        if obj_status(cur, otype, name)[0] is None: continue
        src, _ = fetch_source(cur, otype, name)
        dash_lines = [i + 1 for i, l in enumerate(src) if "'-'" in l and not l.strip().startswith("--")]
        st, _ = obj_status(cur, otype, name); errs = errors(cur, otype, name)
        out.append(dict(object=key, status=st, errors=len(errs), remaining_dash_lines=len(dash_lines), keep_sheet_rows=keep_cnt.get((otype, name), 0), planned_edits=len(p["edits"]), result=p["result"]))
    (HERE / "VERIFY_REPORT.json").write_text(json.dumps(out, ensure_ascii=False, indent=1), encoding="utf-8")
    for o in out: print(f"{o['object']:60s} {o['status']:8s} err={o['errors']} dash_lines={o['remaining_dash_lines']:4d} keep_rows={o['keep_sheet_rows']:3d} edits={o['planned_edits']} {o['result']}")

if __name__ == "__main__":
    ap = argparse.ArgumentParser(); ap.add_argument("cmd", choices=["plan", "apply", "verify"]); ap.add_argument("--only"); ap.add_argument("--dsn"); ap.add_argument("--user"); ap.add_argument("--password")
    a = ap.parse_args(); {"plan": plan, "apply": apply, "verify": verify}[a.cmd](a)
