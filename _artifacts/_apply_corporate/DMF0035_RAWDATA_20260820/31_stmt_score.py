# -*- coding: utf-8 -*-
"""L1610 문장 단위 성적 실측 — V$SQL 에서 현행 커서를 **본문 대조로 특정**해 s/exec·buffer·disk·플랜 축 출력.

사용: 31_stmt_score.py <label>
패치하면 SQL 텍스트가 바뀌어 SQL_ID 도 바뀐다 → SQL_ID 고정 조회 금지.
`INSERT INTO SCM_MGR.GT_DM35_RAW_DATA` 커서 중 **현재 BODY L1610 문장과 세그먼트 일치**하는 것만 채택.
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
label = sys.argv[1]
u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()

cur.execute("""SELECT LINE, TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0035'
               AND TYPE='PACKAGE BODY' ORDER BY LINE""")
src = {ln: t.rstrip("\n") for ln, t in cur.fetchall()}
maxln = max(src)

# 현재 본문에서 대상 문장(GT_DM35_RAW_DATA 적재 중 DM_PLN_MKT_FCST_C + CFM_..._C UNION ALL 을 쓰는 것) 특정
starts = [ln for ln, t in src.items() if re.search(r"INSERT\s+INTO\s+SCM_MGR\.GT_DM35_RAW_DATA\b", t, re.I)]
target = None
for s in sorted(starts):
    buf, ln = [], s
    while ln <= maxln:
        buf.append(src[ln])
        if ";" in re.sub(r"--[^\n]*", "", src[ln]):
            break
        ln += 1
    body = "\n".join(buf)
    if "DM_PLN_MKT_FCST_C F" in body and "DM_PLN_CFM_MKT_DEMAND_PLAN_C F" in body and "GT_DM35_VERSION E" in body:
        target = (s, ln, body)
        break
assert target, "대상 문장 미특정 — 중단"
s, e, body = target
print(f"[대상] BODY L{s}-{e}")


def norm(x):
    x = re.sub(r"/\*.*?\*/", " ", x, flags=re.S)
    x = re.sub(r"--[^\n]*", " ", x)
    x = re.sub(r"\s+", " ", x)
    x = re.sub(r"\s*([(),=<>|+*/-])\s*", r"\1", x)
    return x.strip().upper().rstrip(";")


nb = norm(body)
cur.execute("""SELECT SQL_ID, CHILD_NUMBER, PLAN_HASH_VALUE, EXECUTIONS, ELAPSED_TIME, BUFFER_GETS,
                      DISK_READS, ROWS_PROCESSED, SQL_FULLTEXT
                 FROM V$SQL WHERE SQL_TEXT LIKE 'INSERT INTO SCM_MGR.GT_DM35_RAW_DATA%'""")
hits = []
for (sid, ch, ph, ex, el, bg, dr, rp, ft) in cur.fetchall():
    nf = norm(ft.read() if hasattr(ft, "read") else str(ft))
    segs = [x for x in re.split(r":B\d+", nf) if len(x.strip()) > 3]
    pos, ok = 0, True
    for sg in segs:
        j = nb.find(sg, pos)
        if j < 0:
            ok = False
            break
        pos = j + len(sg)
    if ok:
        hits.append({"sql_id": sid, "child": ch, "plan_hash": ph, "exec": ex,
                     "el_s": round(el / 1e6, 2), "bg": bg, "dr": dr, "rows": rp})

print(f"[매칭 커서] {len(hits)}건")
for h in hits:
    print(f"  {h['sql_id']} ch{h['child']} plan={h['plan_hash']} exec={h['exec']} "
          f"{h['el_s']}s ({h['el_s']/max(h['exec'],1):.3f} s/exec) buf={h['bg']} disk={h['dr']} rows={h['rows']}")

agg = {"label": label, "line": f"L{s}-{e}", "exec": sum(h["exec"] for h in hits),
       "el_s": round(sum(h["el_s"] for h in hits), 2), "bg": sum(h["bg"] for h in hits),
       "dr": sum(h["dr"] for h in hits), "rows": sum(h["rows"] for h in hits), "cursors": hits}
agg["s_exec"] = round(agg["el_s"] / max(agg["exec"], 1), 3)
agg["bg_exec"] = agg["bg"] // max(agg["exec"], 1)
agg["dr_exec"] = agg["dr"] // max(agg["exec"], 1)
print(f"[합계 {label}] exec={agg['exec']} {agg['s_exec']} s/exec  buf/exec={agg['bg_exec']}  "
      f"disk/exec={agg['dr_exec']}  rows={agg['rows']}")

# 플랜 축 — 원장 접근 방식 + access predicate
for h in hits:
    cur.execute("""SELECT ID, OPERATION, OPTIONS, OBJECT_NAME, CARDINALITY, ACCESS_PREDICATES
                     FROM V$SQL_PLAN WHERE SQL_ID=:s AND CHILD_NUMBER=:c
                      AND OBJECT_NAME IN ('DM_PLN_MKT_FCST_C','DM_PLN_CFM_MKT_DEMAND_PLAN_C',
                                          'PK_DM_PLN_MKT_FCST_C_PART','IDX_DM_PLN_MKT_FCST_C_N3',
                                          'PK_DM_PLN_CFM_MKT_DEMAND_PLAN_C_PART',
                                          'GT_DM35_T_LAST_SETUP_C','GT_DM35_EDI_SENDER')
                    ORDER BY ID""", {"s": h["sql_id"], "c": h["child"]})
    print(f"  --- plan {h['sql_id']} ch{h['child']} ---")
    for r in cur.fetchall():
        print(f"    {r[0]:>3} {r[1]} {r[2] or ''} [{r[3]}] card={r[4]}"
              + (f"\n        ACCESS: {r[5][:200]}" if r[5] else ""))
    cur.execute("""SELECT COUNT(*) FROM V$SQL_PLAN WHERE SQL_ID=:s AND CHILD_NUMBER=:c
                    AND OBJECT_NAME='GT_DM35_T_LAST_SETUP_C'""", {"s": h["sql_id"], "c": h["child"]})
    ls = cur.fetchone()[0]
    cur.execute("""SELECT COUNT(*) FROM V$SQL_PLAN WHERE SQL_ID=:s AND CHILD_NUMBER=:c
                    AND OBJECT_NAME='GT_DM35_EDI_SENDER'""", {"s": h["sql_id"], "c": h["child"]})
    es = cur.fetchone()[0]
    print(f"    GTT 접근 오퍼레이션 수: T_LAST_SETUP_C={ls} EDI_SENDER={es}")

json.dump(agg, open(f"{BASE}\\SCORE_{label}.json", "w", encoding="utf-8"), ensure_ascii=False, indent=1)
con.close()
