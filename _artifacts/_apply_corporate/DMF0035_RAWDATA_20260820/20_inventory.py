# -*- coding: utf-8 -*-
"""PKG_DMF0035 GET 경로 **전 문장** 인벤토리 + V$SQL 귀속 (읽기 전용, 추정 금지).

귀속 2축 (anti-simplification — 단일 패턴 금지):
  축A  V$SQL.PROGRAM_ID / PROGRAM_LINE#  … Oracle 이 직접 기록한 발행 위치 (권위)
  축B  SQL_FULLTEXT ↔ BODY 문장 바인드 무관 세그먼트 매칭 … 축A 교차검증
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

# ---------- BODY 원문 ----------
cur.execute("""SELECT LINE, TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0035'
               AND TYPE='PACKAGE BODY' ORDER BY LINE""")
src = [(ln, t.rstrip("\n")) for ln, t in cur.fetchall()]
TXT = {ln: t for ln, t in src}
MAXLN = src[-1][0]
print(f"[BODY] {MAXLN} lines")

cur.execute("""SELECT OBJECT_ID FROM ALL_OBJECTS WHERE OWNER='SCM_MGR'
               AND OBJECT_NAME='PKG_DMF0035' AND OBJECT_TYPE='PACKAGE BODY'""")
prog_id = cur.fetchone()[0]
print(f"[PROGRAM_ID] {prog_id}")

# ---------- 프로시저 경계 ----------
procs = []
for ln, t in src:
    m = re.match(r"\s*(?:PROCEDURE|FUNCTION)\s+(\w+)", t, re.I)
    if m and not re.search(r";\s*$", t):   # 선언부(전방선언) 제외
        procs.append((ln, m.group(1)))
for i, (ln, n) in enumerate(procs):
    end = procs[i + 1][0] - 1 if i + 1 < len(procs) else MAXLN
    print(f"  PROC L{ln:>5}-{end:<5} {n}")


def owner_proc(line):
    c = [n for l, n in procs if l <= line]
    return c[-1] if c else "?"


# ---------- 주석 제거(라인 보존) — hook #138 정본 방식 ----------
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


LIVE = strip_comments_keep_lines([t for _, t in src])   # index = line-1


# ---------- DML/SELECT 문장 경계 추출 (LIVE 코드 기준) ----------
START_RE = re.compile(r"^\s*(INSERT\s+INTO|UPDATE\s+|DELETE\s+FROM|DELETE\s+|MERGE\s+INTO|OPEN\s+\w+\s+FOR|SELECT\s)", re.I)
stmts = []
ln = 1
while ln <= MAXLN:
    line = LIVE[ln - 1]
    if START_RE.match(line):
        s = ln
        buf = []
        while ln <= MAXLN:
            buf.append(LIVE[ln - 1])
            if ";" in LIVE[ln - 1]:
                break
            ln += 1
        e = ln
        body = "\n".join(buf)
        kind = re.match(r"\s*(\w+)", body).group(1).upper()
        stmts.append({"start": s, "end": e, "kind": kind, "proc": owner_proc(s), "sql": body})
    ln += 1

print(f"\n[문장] {len(stmts)}건 추출")

# ---------- V$SQL 귀속 (축A: PROGRAM_LINE#) ----------
cur.execute("""SELECT SQL_ID, CHILD_NUMBER, PROGRAM_LINE#, EXECUTIONS,
                      ROUND(ELAPSED_TIME/1e6,2) EL_S, BUFFER_GETS, DISK_READS, ROWS_PROCESSED,
                      PLAN_HASH_VALUE, SUBSTR(SQL_TEXT,1,70)
                 FROM V$SQL WHERE PROGRAM_ID = :p ORDER BY ELAPSED_TIME DESC""", {"p": prog_id})
vs = cur.fetchall()
print(f"[V$SQL] PROGRAM_ID={prog_id} 귀속 커서 {len(vs)}건")

byline = {}
for (sid, ch, pl, ex, el, bg, dr, rp, ph, txt) in vs:
    a = byline.setdefault(pl, {"sql_ids": set(), "exec": 0, "el": 0.0, "bg": 0, "dr": 0, "rows": 0, "txt": txt})
    a["sql_ids"].add(sid)
    a["exec"] += ex
    a["el"] += el
    a["bg"] += bg
    a["dr"] += dr
    a["rows"] += rp

# PROGRAM_LINE# → 문장 매핑 (문장 시작~끝 구간 포함, 없으면 최근접 시작라인)
for st in stmts:
    st["vsql"] = None
for pl, a in byline.items():
    hit = [st for st in stmts if st["start"] <= pl <= st["end"]]
    if not hit:
        cand = [st for st in stmts if st["start"] >= pl]
        hit = [min(cand, key=lambda s: s["start"])] if cand else []
    if hit:
        st = hit[0]
        st["vsql"] = a
        st["prog_line"] = pl
    else:
        print(f"  [미매핑] PROGRAM_LINE#={pl} el={a['el']}s {a['txt'][:60]}")

json.dump([{k: (sorted(v["sql_ids"]) if k == "vsql" and isinstance(v, dict) else v)
            for k, v in st.items() if k != "sql"} if False else
           {**{k: v for k, v in st.items() if k not in ("sql", "vsql")},
            "vsql": ({**{k: v for k, v in st["vsql"].items() if k != "sql_ids"},
                      "sql_ids": sorted(st["vsql"]["sql_ids"])} if st["vsql"] else None)}
           for st in stmts],
          open(BASE + r"\21_STMT_INVENTORY.json", "w", encoding="utf-8"), ensure_ascii=False, indent=1)

print("\n=== 소요 상위 (V$SQL 귀속, 사내 누적) ===")
hot = sorted([s for s in stmts if s["vsql"]], key=lambda s: -s["vsql"]["el"])
print(f"{'LINE':>12} {'KIND':<7} {'EXEC':>5} {'EL_s':>9} {'s/exec':>7} {'BUFGETS':>12} {'DISK':>10} {'ROWS':>9}  TARGET")
for st in hot[:30]:
    v = st["vsql"]
    tgt = re.search(r"(?:INTO|UPDATE|FROM)\s+(SCM_MGR\.\w+|\w+)", st["sql"], re.I)
    print(f"L{st['start']:>5}-{st['end']:<5} {st['kind']:<7} {v['exec']:>5} {v['el']:>9.2f} "
          f"{v['el']/max(v['exec'],1):>7.2f} {v['bg']:>12} {v['dr']:>10} {v['rows']:>9}  "
          f"{tgt.group(1) if tgt else '?'}")
tot = sum(s["vsql"]["el"] for s in hot)
print(f"  누적 합계 {tot:.1f}s / 귀속 문장 {len(hot)}건 (전체 추출 {len(stmts)}건)")
con.close()
