#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""STEP7 — 붕괴가 실제로 난 형태(INSERT ... WITH ISV ... SELECT 통짜)의 플랜을 OLD/NEW 비교.

⚠ 앞선 STEP5 는 무효한 검증이었다: INSERT 를 떼어낸 SELECT 는 **다른 SQL** 이고
   옵티마이저가 다르게 costing 한다. 실제 사고 커서(5dchxk6z8k7hg)는 INSERT 형태였고,
   AWR 상 이 SQL_ID 는 plan_hash 237589406 **단 하나뿐**(8회 수행, 누적 10,489초)이다.
   즉 "가끔 나오는 나쁜 플랜"이 아니라 **이 형태에서 항상 나오는 플랜**이었다.

EXPLAIN PLAN 은 실행하지 않으므로 DML 위험이 없다.
"""
import sys, pathlib, re
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info, fetch, show
import oracledb

OUT = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate")
OLD_F = OUT / "BACKUP_PKG_DMF0044_BODY_pre_transfertune_20260810.sql"
NEW_F = OUT / "PKG_DMF0044_BODY_TRANSFERTUNE_20260810.sql"


def mask(s):
    out = list(s); i = 0; n = len(s)
    while i < n:
        if s[i] == "'":
            j = i + 1
            while j < n:
                if s[j] == "'":
                    if j + 1 < n and s[j+1] == "'": j += 2; continue
                    break
                j += 1
            for k in range(i, min(j+1, n)): out[k] = ' '
            i = j + 1
        elif s.startswith('--', i):
            j = s.find('\n', i); j = n if j < 0 else j
            for k in range(i, j): out[k] = ' '
            i = j
        elif s.startswith('/*', i):
            j = s.find('*/', i+2); j = n if j < 0 else j+2
            for k in range(i, j): out[k] = ' '
            i = j
        else:
            i += 1
    return "".join(out)


def extract_insert(text, proc, target):
    """INSERT 문 전체(INSERT INTO ... ;)를 그대로 반환 — 사고 형태 보존"""
    m = mask(text)
    start = [mm.start() for mm in re.finditer(r'(?im)^\s*PROCEDURE\s+' + proc + r'\b', m)][0]
    nxt = [mm.start() for mm in re.finditer(r'(?im)^\s*PROCEDURE\s+\w+', m) if mm.start() > start]
    end = nxt[0] if nxt else len(m)
    ins = start + m[start:end].index('INSERT INTO ' + target)
    j = ins; depth = 0
    while j < end:
        if m[j] == '(': depth += 1
        elif m[j] == ')': depth -= 1
        elif m[j] == ';' and depth == 0: break
        j += 1
    return text[ins:j].strip()


def bindify(sql):
    sql = re.sub(r'\bP_DIVISION_ID\b', ':div', sql)
    sql = re.sub(r'\bP_VERSION_NO\b', ':ver', sql)
    sql = re.sub(r'\bP_YYYY\b', ':yyyy', sql)
    sql = re.sub(r'\bv_user_id\b', ':usr', sql)
    sql = re.sub(r'\bv_ori_version_no\b', ':oriv', sql)
    sql = re.sub(r'\bV_SP_BP\b', ':spbp', sql)
    return sql


u, p, dsn = conn_info()
con = oracledb.connect(user=u, password=p, dsn=dsn)
con.call_timeout = 300000
cur = con.cursor()

TARGETS = [
    ("PRODUCT_CREATE  [★ 사고 문장]", 'P_DMF0044_SALES_REPORT_PRODUCT_CREATE', 'SCM_MGR.DM_MOBILE_REPORT_PRODUCT'),
    ("DEPT_CREATE  GTT 적재문",        'P_DMF0044_SALES_REPORT_DEPT_CREATE',    'SCM_MGR.GT_DMF0044_DEPT_RPT_C'),
]

summary = []
for title, proc, tgt in TARGETS:
    for lbl, f in (("OLD", OLD_F), ("NEW", NEW_F)):
        sql = bindify(extract_insert(f.read_text(encoding='utf-8'), proc, tgt))
        sid = f"T44I_{lbl}_{proc[-12:]}"[:29]
        binds = {k: v for k, v in
                 {"div": '40', "ver": 'R_S_20260128_V002_C', "yyyy": '2026',
                  "usr": 'mdf_batch', "oriv": 'R_S_20260128_V001', "spbp": 'SP'}.items()
                 if (':' + k) in sql}
        cur.execute(f"EXPLAIN PLAN SET STATEMENT_ID='{sid}' FOR {sql}", binds)
        print("\n" + "=" * 116)
        print(f"### {title} — {lbl}")
        print("=" * 116)
        show(*fetch(cur, """SELECT id, LPAD(' ',depth)||operation||' '||NVL(options,'') op,
                                   object_name, cardinality est_rows, cost
                              FROM plan_table WHERE statement_id=:s ORDER BY id""", {"s": sid}))
        cur.execute("""SELECT (SELECT COUNT(*) FROM plan_table WHERE statement_id=:s AND options='PUSHED PREDICATE'),
                              (SELECT NVL(MAX(cardinality),0) FROM plan_table WHERE statement_id=:s),
                              (SELECT NVL(MAX(cost),0) FROM plan_table WHERE statement_id=:s),
                              (SELECT COUNT(*) FROM plan_table WHERE statement_id=:s AND operation='NESTED LOOPS')
                         FROM DUAL""", {"s": sid})
        npp, mc, mcost, nnl = cur.fetchone()
        verdict = "⛔ 붕괴 형태" if npp else "✅ PUSHED PREDICATE 없음"
        print(f"  ★ PUSHED PREDICATE={npp}  NESTED LOOPS={nnl}  최대 EST={int(mc):,}  최대 COST={int(mcost):,}   {verdict}")
        summary.append((title, lbl, npp, int(mc), int(mcost)))
        cur.execute("DELETE FROM plan_table WHERE statement_id=:s", {"s": sid})
        con.commit()

print("\n" + "#" * 116)
print(f"{'문장':<34}{'':4}{'PUSHED PRED':>12}{'최대 EST 행':>18}{'최대 COST':>16}")
print("#" * 116)
for t, l, npp, mc, mcost in summary:
    print(f"{t:<34}{l:>4}{npp:>12}{mc:>18,}{mcost:>16,}")
con.close()
