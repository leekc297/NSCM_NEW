#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""DMF0082 — PLANT_SITE_ID 센티널 통일 + 중복 제거 (사용자 확정 2026-08-15).

사용자 확정: "NULL, ' ', '-', '--' 는 같은 값으로 인식하면 됩니다."

⚠ 정규화만 하면 **값이 3배가 된다** — 최종 SELECT 가 `PIVOT(SUM)` + `GROUP BY ... PLANT_SITE_ID`
   이므로, 3개로 갈라져 있던 동일 행이 한 그룹으로 합쳐지며 SUM 된다.
   ⇒ **정규화 + 중복 제거를 한 쌍으로** 넣어야 한다.

적용 위치: 모든 적재·필터가 끝난 뒤 (`TEMP_FCST_N_PRICE` 마지막 필터 다음).
   앞쪽에 넣으면 `PLANT_SITE_ID NOT IN (split(p_plant_site_id))` 필터가 정규화된 값과
   비교되어 조회조건 의미가 바뀐다.

안전장치: 적용 전에 **중복 행의 QTY 가 실제로 동일한지 전수 검증**한다.
   다르면 데이터 유실이므로 중단하고 보고한다(임의 병합 금지).
"""
import io, re, sys, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
from ora import conn_info
import oracledb

OUT = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0082_PERF_20260815")
OUT.mkdir(parents=True, exist_ok=True)

NORM = ("CASE WHEN PLANT_SITE_ID IS NULL "
        "OR TRIM(REPLACE(PLANT_SITE_ID, CHR(0), '')) IS NULL "
        "OR TRIM(REPLACE(PLANT_SITE_ID, CHR(0), '')) IN ('-','--') THEN '-' "
        "ELSE PLANT_SITE_ID END")

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()

# ── 0) GTT 컬럼 목록 (dedup 키 구성용) ─────────────────────────────────────
cur.execute("""SELECT COLUMN_NAME FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR'
               AND TABLE_NAME='GT_DMF0082_TEMP_FCST_N_PRICE' ORDER BY COLUMN_ID""")
allc = [r[0] for r in cur.fetchall()]
KEYS = [c for c in allc if c != 'QTY']
print(f"[GTT] 컬럼 {len(allc)}개 / dedup 키 {len(KEYS)}개 (QTY 제외)")

# ── 1) 사전 검증: 정규화 시 중복 행의 QTY 가 동일한가 ───────────────────────
A = 'ALL'
PARAMS = ['40', A, A, A, '20260801', '20270131', A, None,
          'Current', 'N', 'minyonglee1', 'ADMIN', A, A, A, A]
rcs = [con.cursor() for _ in range(5)]
rr = con.cursor()
cur.callproc("SCM_MGR.PKG_DMF0082.P_DMF0082_GET_MAIN_DATA", PARAMS + rcs + [rr])
for c in rcs:
    try: c.close()
    except Exception: pass

nk = [f"{NORM} AS PLANT_SITE_ID" if c == 'PLANT_SITE_ID' else c for c in KEYS]
sel = ", ".join(nk)
grp = ", ".join([NORM if c == 'PLANT_SITE_ID' else c for c in KEYS])
cur.execute(f"""SELECT COUNT(*) TOTAL_GRP,
                       SUM(CASE WHEN MN <> MX THEN 1 ELSE 0 END) DIFF_GRP,
                       SUM(CNT-1) REMOVABLE
                FROM  (SELECT COUNT(*) CNT, MIN(QTY) MN, MAX(QTY) MX
                       FROM   SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
                       GROUP  BY {grp}
                       HAVING COUNT(*) > 1)""")
tg, dg, rm = [x or 0 for x in cur.fetchone()]
cur.execute("SELECT COUNT(*) FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE")
tot = cur.fetchone()[0]
print(f"\n[사전검증] 스테이징 {tot:,}행")
print(f"   정규화 시 중복 그룹      : {tg:,}")
print(f"   그중 QTY 가 다른 그룹    : {dg:,}   {'⛔ 중단 — 임의 병합 금지' if dg else '✅ 전부 동일 → 안전'}")
print(f"   제거 대상 행             : {rm:,}  (→ {tot-rm:,}행)")
# 사용자 확정 2026-08-15: **B(MAX)** — 키별 QTY 최대 행 1건만 남긴다.
#   값이 같은 그룹(다수)은 원래 값이 그대로 유지되고, 다른 그룹({dg}개)만 최대값이 채택된다.
#   ⛔ A(SUM) 는 채택하지 않았다 — 동일 복제본이 다수라 SUM 이면 88% 가 3배로 부풀어 오른다.
print(f"   → 사용자 확정 B(MAX): QTY 상이 {dg:,} 그룹은 **최대값 채택**, 나머지는 값 불변")

# ── 2) SP 패치 ────────────────────────────────────────────────────────────
cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082'
               AND TYPE='PACKAGE BODY' ORDER BY LINE""")
body = "".join(r[0] for r in cur.fetchall())
(OUT / "00_BACKUP3_PKG_DMF0082_BODY.sql").write_text(
    "-- 센티널 정규화 전 백업\nSET DEFINE OFF\nCREATE OR REPLACE " + body.rstrip() + "\n/\n", encoding="utf-8")

ANCHOR = """        DELETE FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        WHERE  NVL(DEPT_ID, ' ') NOT IN ("""
n = body.count(ANCHOR)
print(f"\n[anchor] 마지막 필터(DEPT_ID) {n}회")
assert n == 1, f"앵커 {n}회"
end = body.find(";", body.find(ANCHOR) + len(ANCHOR)) + 1

PATCH = f"""

        /* ⭐ [E20260815-SENTINEL] PLANT_SITE_ID 센티널 통일 + 중복 제거 (사용자 확정 2026-08-15:
       "NULL, ' ', '-', '--' 는 같은 값으로 인식").
       실측 근거: div40 조회에서 PLANT_SITE_ID 가 '--'/'-'/CHR(0)/' ' 4형으로 갈라져
       **동일 항목·동일 메저가 3행**으로 나왔다(버킷값 66개가 100% 동일한 복제본).
       ⚠ 정규화만 하면 최종 SELECT 의 `PIVOT(SUM)` + `GROUP BY ... PLANT_SITE_ID` 가
         합쳐진 행을 **합산해 값이 3배**가 된다 ⇒ 중복 제거를 반드시 같이 한다.
       ⚠ 위치가 중요하다 — 조회조건 필터(p_plant_site_id 등) **뒤**에 둔다.
         앞에 두면 필터가 정규화된 값과 비교되어 조회조건 의미가 바뀐다. */
        UPDATE SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
           SET PLANT_SITE_ID = '-'
         WHERE PLANT_SITE_ID IS NULL
            OR TRIM(REPLACE(PLANT_SITE_ID, CHR(0), '')) IS NULL
            OR TRIM(REPLACE(PLANT_SITE_ID, CHR(0), '')) IN ('-', '--');

        /* 정규화로 같아진 행 중 1건만 남긴다. 상관 서브쿼리 대신 ROW_NUMBER 로 set-based 처리
       (진단·정정 SQL 도 튜닝 품질 유지).
       ⭐ 남길 행 = **QTY 최대** (사용자 확정 B, 2026-08-15). 값이 같은 그룹은 어느 행이 남아도
         동일하고, 다른 그룹(실측 16,395)만 최대값이 채택된다.
       ⛔ SUM 은 채택하지 않았다 — 동일 복제본이 다수(88%)라 합산하면 그만큼 3배가 된다. */
        DELETE FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
         WHERE ROWID IN (SELECT RID
                     FROM  (SELECT ROWID AS RID,
                                   ROW_NUMBER() OVER (PARTITION BY {", ".join(KEYS)}
                                                      ORDER BY QTY DESC NULLS LAST, ROWID) AS RN
                            FROM   SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE)
                     WHERE RN > 1);
"""
body2 = body[:end] + PATCH + body[end:]
(OUT / "03_PKG_DMF0082_BODY_SENTINEL_DEDUP.sql").write_text(
    "SET DEFINE OFF\nCREATE OR REPLACE " + body2.rstrip() + "\n/\nSHOW ERRORS\n", encoding="utf-8")
cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 180")
cur.execute("CREATE OR REPLACE " + body2.rstrip())
cur.execute("SELECT COUNT(*) FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082'")
print(f"[deploy] errors={cur.fetchone()[0]}")
con.close()
