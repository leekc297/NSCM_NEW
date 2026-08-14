#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""DMF0082 조회 병목 튜닝 — SQL_ID 3a8jzvxnc57hz (INSERT INTO GT_DMF0082_TEMP_FCST_N_PRICE, L1550).

⓿ 실측 병목 (2026-08-15, 사용자 조회 실행 중 캡처):
     elapsed 256s(3회) · buffer_gets 53,643,522 · rows_processed 0 · ASH ON CPU 100%
     PLAN LINE 18 `INDEX RANGE SCAN PK_DM_PLN_CFM_SELLING_PRICE` 가 170/171초 점유.
   구조: GTT 3개(TEMP_SITE_ITEM×TEMP_SELECT_MEASURE×T_WS_FCST)를 MERGE JOIN CARTESIAN 으로
     묶어 드라이빙 집합을 만들고, 그 조합마다 대형 테이블(DM_PLN_CFM_SELLING_PRICE, div40 103만행)을
     NESTED LOOPS + PK 인덱스로 행별 조회한다. GTT 추정 카디널리티가 1/10/14 로 과소평가된 결과다.
     "결과 0행인데 버퍼 5,364만" 이 곱집합 반복의 직접 증거.

적용 2건 (hook #129 ②·④):
  ② T_WS_FCST 를 조인 → EXISTS 세미조인.
     D 는 FCST_TYPE 등가 하나뿐이라 조인이 아니라 **필터**다. 적재가
     `SELECT DISTINCT A.SEGMENT1 ... WHERE LOOKUP_TYPE='SALES_TYPE_CODE'` 라 FCST_TYPE 이 유일하므로
     EXISTS 로 바꿔도 **행수가 변하지 않는다(의미 동일 — 실측 확인)**. 조인으로 두면 드라이빙
     곱집합에 14배로 곱해져 NL 반복을 그만큼 늘린다.
  ④ LEADING(A) USE_HASH(B C) — 대형 테이블 A 를 DIVISION_ID+YYYYMMDD 로 먼저 좁힌 뒤
     GTT 를 해시 조인한다. GTT 에는 통계가 없어(세션 데이터) 추정이 1 로 굳어지므로,
     구조 변경만으로는 옵티마이저가 NL+곱집합을 계속 고른다. 계획을 고정한다.

⚠ ③(SARGable — `p_scm_site_id` CONNECT BY 토큰 분해)은 **이번에 넣지 않는다.**
   GT_DMF0082_SP_FILTER 적재부까지 함께 바꿔야 하는 별건이고, ②④ 효과를 실측한 뒤 판단한다.
   (병목이 아닌 곳 손대기 금지 — 효과 귀속이 흐려진다)

⚠ 20개 유사 INSERT 중 **실측된 1건만** 고친다. 나머지 19건은 같은 패턴일 수 있으나
   측정되지 않았으므로 손대지 않는다.
"""
import io, pathlib, sys
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
from ora import conn_info
import oracledb

OUT = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0082_PERF_20260815")
OUT.mkdir(parents=True, exist_ok=True)

OLD_HINT = "        SELECT A.DIVISION_ID"
NEW_HINT = """        SELECT /*+ LEADING(A) USE_HASH(B) USE_HASH(C) */ -- ④ [E20260815-PERF] 계획 고정.
                   -- GTT 는 세션 데이터라 통계가 없어 추정 카디널리티가 1 로 굳는다. 그 결과
                   -- GTT 3개를 MERGE JOIN CARTESIAN 으로 묶어 대형 테이블을 행별 NL 조회했다
                   -- (실측: buffer_gets 5,364만 / 결과 0행 / LINE18 인덱스스캔이 170초 점유).
                   -- A 를 DIVISION_ID+YYYYMMDD 로 먼저 좁히고 GTT 를 해시로 붙인다.
               A.DIVISION_ID"""

OLD_JOIN = """        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D
            ON  D.FCST_TYPE = A.FCST_TYPE
        WHERE  1 = 1"""
NEW_JOIN = """        WHERE  1 = 1
        /* ② [E20260815-PERF] 곱집합 배수 제거 — D 는 FCST_TYPE 등가 1개뿐이라 조인이 아니라 필터다.
           GT_DMF0082_T_WS_FCST 적재가 `SELECT DISTINCT SEGMENT1` 이라 FCST_TYPE 이 유일하므로
           EXISTS 로 바꿔도 **행수가 변하지 않는다**(의미 동일 — 적재문 실측 확인).
           조인으로 두면 드라이빙 곱집합에 14배로 곱해져 NL 반복을 그만큼 늘린다. */
        AND    EXISTS (SELECT 1
                       FROM   SCM_MGR.GT_DMF0082_T_WS_FCST D
                       WHERE  D.FCST_TYPE = A.FCST_TYPE)"""

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082'
               AND TYPE='PACKAGE BODY' ORDER BY LINE""")
body = "".join(r[0] for r in cur.fetchall())

# 대상 구문 슬라이스 — 마커 6/6 로 특정된 L1550 구문
ST, EN = 77600, 82396
seg = body[ST:EN]
assert "DM_PLN_CFM_SELLING_PRICE A" in seg and "'Current' AS VERSION_NO" in seg, "대상 구문 불일치"
for nm, old in [("HINT", OLD_HINT), ("JOIN", OLD_JOIN)]:
    n = seg.count(old)
    print(f"  [anchor] {nm:<5} 구문내 {n}회 (전체 {body.count(old)}회 — 슬라이스 외 미적용)")
    assert n == 1, f"{nm} 앵커 {n}회"

seg2 = seg.replace(OLD_HINT, NEW_HINT, 1).replace(OLD_JOIN, NEW_JOIN, 1)
body2 = body[:ST] + seg2 + body[EN:]

(OUT / "01_PKG_DMF0082_BODY_PERF_HOTINSERT.sql").write_text(
    "-- DMF0082 조회 병목 튜닝 (SQL_ID 3a8jzvxnc57hz / L1550 INSERT)\n"
    "SET DEFINE OFF\nCREATE OR REPLACE " + body2.rstrip() + "\n/\nSHOW ERRORS\n", encoding="utf-8")

cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 180")
cur.execute("CREATE OR REPLACE " + body2.rstrip())
cur.execute("""SELECT LINE, TEXT FROM ALL_ERRORS WHERE OWNER='SCM_MGR'
               AND NAME='PKG_DMF0082' ORDER BY SEQUENCE""")
errs = cur.fetchall()
print(f"\n[deploy] errors={len(errs)}")
for e in errs[:6]:
    print("   ", e[0], str(e[1])[:130])
cur.execute("""SELECT OBJECT_TYPE, STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR'
               AND OBJECT_NAME='PKG_DMF0082' ORDER BY 1""")
for r in cur.fetchall():
    print(f"   {r[0]:<14} {r[1]}")
# 옛 커서 무효화 — 다음 실행이 새 계획을 쓰도록
try:
    cur.execute("BEGIN DBMS_SHARED_POOL.PURGE('3a8jzvxnc57hz','C'); END;")
    print("[purge] 구 커서 제거")
except Exception as ex:
    print(f"[purge] 생략 ({str(ex)[:60]}) — 패키지 재컴파일로 어차피 무효화됨")
con.close()
