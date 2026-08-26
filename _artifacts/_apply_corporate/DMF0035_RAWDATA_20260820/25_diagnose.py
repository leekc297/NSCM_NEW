# -*- coding: utf-8 -*-
"""PKG_DMF0035 GET 경로 전 문장 진단표 (hook #129 순위축) — 읽기 전용, 추정 금지.

축
  V$SQL 귀속 : SQL_FULLTEXT ↔ BODY 문장 **바인드 무관 세그먼트 매칭**(권위) + PROGRAM_LINE# 근접(보조)
               ⚠ PROGRAM_LINE# 는 문장 구간 밖을 가리키는 경우가 있어 단독 사용 금지(pl=3075 실측 오귀속).
               ⚠ 같은 BODY 문장에 SQL_ID 가 여럿이면 **현재 본문과 일치하는 것만 LIVE**, 나머지는 STALE(패치 전 커서).
  ①          : SELECT 목록 상관 스칼라 서브쿼리 수 / 스칼라 함수 호출 수
  ②          : 비-SARGable 술어 (컬럼에 함수 / 선행 와일드카드 LIKE / CASE=상수)
  ③          : 참조 상용표(비 GTT) 등가 술어 컬럼의 인덱스 커버 여부
  ④ 선행축소 : 구동 원천이 대용량 원장인가 / 축소 술어가 원장 스캔 시점에 걸리는가
"""
import io
import json
import re
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info

BASE = r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0035_RAWDATA_20260820"
u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()

cur.execute("""SELECT LINE, TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0035'
               AND TYPE='PACKAGE BODY' ORDER BY LINE""")
src = [(ln, t.rstrip("\n")) for ln, t in cur.fetchall()]
MAXLN = src[-1][0]
cur.execute("""SELECT OBJECT_ID FROM ALL_OBJECTS WHERE OWNER='SCM_MGR'
               AND OBJECT_NAME='PKG_DMF0035' AND OBJECT_TYPE='PACKAGE BODY'""")
PID = cur.fetchone()[0]


def strip_comments_keep_lines(lines):
    out, in_blk = [], False
    for t in lines:
        s = t
        if in_blk:
            j = s.find("*/")
            if j < 0:
                out.append("")
                continue
            s = " " * (j + 2) + s[j + 2:]
            in_blk = False
        res, i, in_q = [], 0, False
        while i < len(s):
            c = s[i]
            if in_q:
                res.append(c)
                if c == "'":
                    in_q = False
                i += 1
                continue
            if c == "'":
                in_q = True
                res.append(c)
                i += 1
                continue
            if s.startswith("--", i):
                break
            if s.startswith("/*", i):
                j = s.find("*/", i + 2)
                if j < 0:
                    in_blk = True
                    break
                res.append(" " * (j + 2 - i))
                i = j + 2
                continue
            res.append(c)
            i += 1
        out.append("".join(res))
    return out


LIVE = strip_comments_keep_lines([t for _, t in src])
procs = [(ln, re.match(r"\s*(?:PROCEDURE|FUNCTION)\s+(\w+)", t, re.I).group(1))
         for ln, t in src
         if re.match(r"\s*(?:PROCEDURE|FUNCTION)\s+(\w+)", t, re.I) and not t.rstrip().endswith(";")]


def owner_proc(line):
    c = [n for l, n in procs if l <= line]
    return c[-1] if c else "?"


START_RE = re.compile(r"^\s*(INSERT\s+INTO|UPDATE\s+|DELETE\s+FROM|MERGE\s+INTO|OPEN\s+\w+\s+FOR|SELECT\s)", re.I)
stmts, ln = [], 1
while ln <= MAXLN:
    if START_RE.match(LIVE[ln - 1]):
        s, buf = ln, []
        while ln <= MAXLN:
            buf.append(LIVE[ln - 1])
            if ";" in LIVE[ln - 1]:
                break
            ln += 1
        stmts.append({"start": s, "end": ln, "proc": owner_proc(s),
                      "kind": re.match(r"\s*(\w+)", buf[0]).group(1).upper(),
                      "sql": "\n".join(buf)})
    ln += 1


def norm(s):
    s = re.sub(r"\s+", " ", s)
    s = re.sub(r"\s*([(),=<>|+*/-])\s*", r"\1", s)
    return s.strip().upper().rstrip(";")


for st in stmts:
    st["n"] = norm(st["sql"])

# ---------------- V$SQL 귀속 ----------------
cur.execute("""SELECT SQL_ID, CHILD_NUMBER, PROGRAM_LINE#, EXECUTIONS, ELAPSED_TIME, BUFFER_GETS,
                      DISK_READS, ROWS_PROCESSED, PLAN_HASH_VALUE, SQL_FULLTEXT
                 FROM V$SQL WHERE PROGRAM_ID=:p""", {"p": PID})
cursors = []
for (sid, ch, pl, ex, el, bg, dr, rp, ph, ft) in cur.fetchall():
    cursors.append({"sql_id": sid, "child": ch, "pline": pl, "exec": ex, "el": el / 1e6,
                    "bg": bg, "dr": dr, "rows": rp, "ph": ph,
                    "n": norm(ft.read() if hasattr(ft, "read") else str(ft))})

for c in cursors:
    segs = [x for x in re.split(r":B\d+", c["n"]) if len(x.strip()) > 3]
    best, bestscore = None, -1
    for st in stmts:
        pos, ok = 0, True
        for sg in segs:
            j = st["n"].find(sg, pos)
            if j < 0:
                ok = False
                break
            pos = j + len(sg)
        if ok:
            # 길이 근접도 = 유일성 보강
            score = 1e6 - abs(len(st["n"]) - len(c["n"]))
            if score > bestscore:
                best, bestscore = st, score
    c["stmt"] = best
    c["match"] = "TEXT" if best else None
    if best is None:                      # 축B 실패 → 축A(PROGRAM_LINE# 근접) 보조
        cand = [s for s in stmts if s["start"] >= c["pline"] - 12]
        if cand:
            c["stmt"] = min(cand, key=lambda s: s["start"])
            c["match"] = "PLINE"

for st in stmts:
    st["cur"] = []
for c in cursors:
    if c["stmt"] is not None:
        c["stmt"]["cur"].append(c)

# LIVE/STALE 판정: 본문과 텍스트 매칭된 커서 = LIVE, PLINE 로만 붙은 커서 = STALE(패치 전 본문)
for st in stmts:
    for c in st["cur"]:
        c["state"] = "LIVE" if c["match"] == "TEXT" else "STALE"

# ---------------- ①②③④ 정적 축 ----------------
FUNC_RE = re.compile(r"\b(SCM_MGR\.)?(UF_\w+|FN_\w+|PKG_\w+\.\w+)\s*\(", re.I)


def select_list(nsql):
    """최상위 SELECT ~ 대응 FROM 구간 (괄호 깊이 0)."""
    m = re.search(r"\bSELECT\b", nsql)
    if not m:
        return ""
    i, depth = m.end(), 0
    while i < len(nsql):
        if nsql[i] == "(":
            depth += 1
        elif nsql[i] == ")":
            depth -= 1
        elif depth == 0 and nsql.startswith("FROM", i) and (i == 0 or not nsql[i - 1].isalnum()):
            return nsql[m.end():i]
        i += 1
    return nsql[m.end():]


def subqueries(s):
    """s 안의 (SELECT ...) 최상위 괄호 블록 목록."""
    out = []
    for m in re.finditer(r"\(SELECT\b", s):
        i, depth = m.start(), 0
        while i < len(s):
            if s[i] == "(":
                depth += 1
            elif s[i] == ")":
                depth -= 1
                if depth == 0:
                    out.append(s[m.start():i + 1])
                    break
            i += 1
    return out


NONSARG = [
    (r"\b(NVL|SUBSTR|TO_CHAR|TO_DATE|UPPER|LOWER|TRIM|REPLACE|LTRIM|RTRIM|INSTR)\(\w+\.\w+[^)]*\)\s*(=|<>|>|<|>=|<=|LIKE|IN)", "컬럼에 함수"),
    (r"LIKE'%", "선행 와일드카드 LIKE"),
    (r"CASE WHEN[^=]{0,300}?END=", "CASE 식 = 상수"),
]

rows = []
for st in stmts:
    sl = select_list(st["n"])
    subs = subqueries(sl)
    corr, plain = 0, 0
    for sq in subs:
        inner_alias = set(re.findall(r"\b(?:FROM|JOIN)\s+(?:SCM_MGR\.)?\w+\s+(\w+)", sq))
        outer_refs = set(re.findall(r"\b(\w+)\.\w+", sq)) - inner_alias - {"SCM_MGR"}
        (corr if outer_refs else plain).__int__()
        if outer_refs:
            corr += 1
        else:
            plain += 1
    funcs = len(FUNC_RE.findall(sl))
    where = st["n"][len(sl):] if sl else st["n"]
    ns = []
    for pat, name in NONSARG:
        k = len(re.findall(pat, where))
        if k:
            ns.append(f"{name}x{k}")
    tables = sorted(set(re.findall(r"\b(?:FROM|JOIN)\s+SCM_MGR\.(\w+)", st["n"])))
    st.update({"corr": corr, "plainsub": plain, "funcs": funcs, "nonsarg": ns, "tables": tables})
    live = [c for c in st["cur"] if c["state"] == "LIVE"]
    stale = [c for c in st["cur"] if c["state"] == "STALE"]
    st["live_el"] = sum(c["el"] for c in live)
    st["live_ex"] = sum(c["exec"] for c in live)
    st["live_bg"] = sum(c["bg"] for c in live)
    st["live_dr"] = sum(c["dr"] for c in live)
    st["live_rows"] = sum(c["rows"] for c in live)
    st["live_ids"] = sorted({c["sql_id"] for c in live})
    st["stale_ids"] = sorted({c["sql_id"] for c in stale})

# ---------------- 상용표(비 GTT) 인덱스 인벤토리 ----------------
alltab = sorted({t for st in stmts for t in st["tables"]})
cur.execute("""SELECT TABLE_NAME, NUM_ROWS, BLOCKS, TEMPORARY FROM ALL_TABLES
                WHERE OWNER='SCM_MGR' AND TABLE_NAME IN (SELECT COLUMN_VALUE FROM TABLE(:l))""",
            l=con.cursor().arrayvar(str, alltab) if False else None) if False else None
tabinfo = {}
for t in alltab:
    cur.execute("SELECT NUM_ROWS, BLOCKS, TEMPORARY FROM ALL_TABLES WHERE OWNER='SCM_MGR' AND TABLE_NAME=:t", {"t": t})
    r = cur.fetchone()
    if r:
        tabinfo[t] = {"rows": r[0], "blocks": r[1], "temp": r[2], "idx": []}
        cur.execute("""SELECT I.INDEX_NAME, LISTAGG(C.COLUMN_NAME,',') WITHIN GROUP (ORDER BY C.COLUMN_POSITION)
                         FROM ALL_INDEXES I JOIN ALL_IND_COLUMNS C ON C.INDEX_OWNER=I.OWNER AND C.INDEX_NAME=I.INDEX_NAME
                        WHERE I.TABLE_OWNER='SCM_MGR' AND I.TABLE_NAME=:t GROUP BY I.INDEX_NAME""", {"t": t})
        tabinfo[t]["idx"] = cur.fetchall()

json.dump({"stmts": [{k: v for k, v in s.items() if k not in ("cur", "n")} for s in stmts],
           "tables": tabinfo},
          open(BASE + r"\26_DIAG.json", "w", encoding="utf-8"), ensure_ascii=False, indent=1, default=str)

# ---------------- 출력 ----------------
hot = sorted(stmts, key=lambda s: -(s["live_el"]))
print("=== [진단표] PKG_DMF0035 GET 경로 전 문장 — LIVE 커서 소요 순 ===")
print(f"{'BODY라인':>13} {'KIND':<6} {'EXEC':>4} {'s/exec':>8} {'EL_s':>8} {'BUFGETS':>12} {'DISK':>9} {'ROWS':>9} "
      f"{'①상관':>5} {'①함수':>5}  대상 / ②비SARG")
for st in hot:
    if st["live_el"] < 0.02 and not st["stale_ids"]:
        continue
    tgt = re.search(r"(?:INSERT INTO|UPDATE|DELETE FROM|MERGE INTO)\s+(?:SCM_MGR\.)?(\w+)", st["n"])
    print(f"L{st['start']:>5}-{st['end']:<6} {st['kind']:<6} {st['live_ex']:>4} "
          f"{st['live_el']/max(st['live_ex'],1):>8.3f} {st['live_el']:>8.2f} {st['live_bg']:>12} "
          f"{st['live_dr']:>9} {st['live_rows']:>9} {st['corr']:>5} {st['funcs']:>5}  "
          f"{(tgt.group(1) if tgt else st['kind'])}"
          f"{'  ②' + ','.join(st['nonsarg']) if st['nonsarg'] else ''}"
          f"{'  [STALE:' + ','.join(st['stale_ids']) + ']' if st['stale_ids'] else ''}")

print("\n=== ① 상관 스칼라 서브쿼리 보유 문장 전수 (소요 무관) ===")
for st in sorted(stmts, key=lambda s: -s["corr"]):
    if st["corr"] == 0:
        continue
    print(f"  L{st['start']:>5}-{st['end']:<6} 상관 {st['corr']:>2}개 / 비상관 {st['plainsub']:>2}개 "
          f"/ 함수 {st['funcs']}  LIVE {st['live_el']:.2f}s  표={','.join(st['tables'])[:80]}")

print("\n=== 참조표 인벤토리 (GTT/상용 구분 + 인덱스) ===")
for t, v in sorted(tabinfo.items(), key=lambda kv: -(kv[1]["rows"] or 0)):
    kind = "GTT" if v["temp"] == "Y" else "상용"
    print(f"  [{kind}] {t:<32} rows={v['rows']} blocks={v['blocks']} idx={len(v['idx'])}")
    if kind == "상용":
        for n, c in v["idx"]:
            print(f"        {n:<34} {c}")
con.close()
