#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""DMF0003 — 조회 시 PK 센티널 정규화 대상 실측 (hook #129 §9.1 R3 적용).

사용자 보고(2026-08-15): 저장 후 `AS_FROM_SITE` 에 '-' 가 들어가 **동일 정적 구조에서
  AS_FROM_SITE 만 다른 ROW 가 신규 생성**됨. 조회 시 PK 항목의 ' '/'-'/'--' 를 '-' 로 통일해 달라.

⓪ 추정 금지 — 아래를 실측으로 확정한다.
   ① DMF0003 조회 SP 와 스테이징 GTT 특정
   ② 원장 테이블의 **PK 컬럼** 목록 (딕셔너리)
   ③ 각 PK 컬럼의 센티널 변형 분포 (NULL/''/' '/'-'/'--'/CHR(0))
   ④ 최종 SELECT 의 집계함수 (PIVOT(SUM) 이면 정규화 단독 금지 — dedup 동반)
"""
import io, re, sys, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
from ora import conn_info
import oracledb

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()

# ── ① 조회 SP / GTT ────────────────────────────────────────────────────────
print("=== PKG_DMF0003 프로시저 ===")
cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0003'
               AND TYPE='PACKAGE BODY' ORDER BY LINE""")
body = "".join(r[0] for r in cur.fetchall())
if not body:
    sys.exit("⛔ PKG_DMF0003 BODY 없음")
procs = [(m.start(), m.group(1)) for m in re.finditer(r"PROCEDURE\s+(\w+)", body)]
for i, (pos, nm) in enumerate(procs):
    end = procs[i+1][0] if i+1 < len(procs) else len(body)
    print(f"   {nm:<48}{end-pos:>8,}자")

print("\n=== GT_DMF0003* GTT ===")
cur.execute("""SELECT TABLE_NAME FROM ALL_TABLES WHERE OWNER='SCM_MGR'
               AND TEMPORARY='Y' AND TABLE_NAME LIKE 'GT_DMF0003%' ORDER BY 1""")
gtts = [r[0] for r in cur.fetchall()]
print(f"   {len(gtts)}개: {gtts}")

# ── ② AS_FROM_SITE 를 가진 테이블/GTT ──────────────────────────────────────
print("\n=== AS_FROM_SITE 보유 객체 ===")
cur.execute("""SELECT c.TABLE_NAME, t.TEMPORARY, c.DATA_TYPE, c.DATA_LENGTH, c.NULLABLE
               FROM ALL_TAB_COLUMNS c JOIN ALL_TABLES t
                 ON t.OWNER=c.OWNER AND t.TABLE_NAME=c.TABLE_NAME
               WHERE c.OWNER='SCM_MGR' AND c.COLUMN_NAME='AS_FROM_SITE'
               ORDER BY t.TEMPORARY DESC, c.TABLE_NAME""")
for r in cur.fetchall():
    kind = 'GTT' if r[1] == 'Y' else '테이블'
    print(f"   {r[0]:<40}{kind:<6}{r[2]}({r[3]}) NULL={r[4]}")

# ── ③ DMF0003 원장의 PK + 센티널 분포 ──────────────────────────────────────
CAND = ['DM_PLN_MKT_FCST', 'DM_PLN_MKT_FCST_C', 'DM_PLN_CFM_MKT_DEMAND_PLAN',
        'DM_PLN_CFM_MKT_DEMAND_PLAN_C']
print("\n=== 원장 PK 컬럼별 센티널 변형 분포 ===")
for t in CAND:
    cur.execute("""SELECT cc.COLUMN_NAME FROM ALL_CONSTRAINTS k
                   JOIN ALL_CONS_COLUMNS cc ON k.OWNER=cc.OWNER AND k.CONSTRAINT_NAME=cc.CONSTRAINT_NAME
                   WHERE k.OWNER='SCM_MGR' AND k.TABLE_NAME=:1 AND k.CONSTRAINT_TYPE='P'
                   ORDER BY cc.POSITION""", [t])
    pk = [r[0] for r in cur.fetchall()]
    if not pk:
        print(f"\n  {t}: PK 없음"); continue
    cur.execute("""SELECT COLUMN_NAME FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR'
                   AND TABLE_NAME=:1 AND DATA_TYPE IN ('VARCHAR2','CHAR')""", [t])
    chars = {r[0] for r in cur.fetchall()}
    tgt = [c for c in pk if c in chars]
    print(f"\n  {t}  PK={'+'.join(pk)}")
    for c in tgt:
        cur.execute(f"""SELECT SUM(CASE WHEN {c} IS NULL THEN 1 ELSE 0 END),
                               SUM(CASE WHEN {c}='-' THEN 1 ELSE 0 END),
                               SUM(CASE WHEN {c}='--' THEN 1 ELSE 0 END),
                               SUM(CASE WHEN {c} IS NOT NULL
                                        AND TRIM(REPLACE({c},CHR(0),'')) IS NULL THEN 1 ELSE 0 END),
                               COUNT(*)
                        FROM {t}""")
        nul, d1, d2, blank, tot = [x or 0 for x in cur.fetchone()]
        variants = sum(1 for x in (nul, d1, d2, blank) if x)
        if variants >= 2:
            print(f"     ⚠ {c:<26} NULL={nul:,} '-'={d1:,} '--'={d2:,} 공백/NUL={blank:,} / {tot:,}행  ← 분열")
        elif variants == 1:
            print(f"       {c:<26} NULL={nul:,} '-'={d1:,} '--'={d2:,} 공백/NUL={blank:,} / {tot:,}행")
con.close()
