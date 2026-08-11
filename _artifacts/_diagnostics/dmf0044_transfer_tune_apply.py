#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""dmf0044_transfer_tune_apply.py — DMF0044 TRANSFER 경로 튜닝 (2026-08-10)

## 0. 병목 식별 (먼저 병목을 가른 뒤, 병목에만 1→2→3 순위 적용 — 사용자 지시)

실측 근거 = 사내 라이브 세션 SID 512 / SERIAL# 2298 / SQL_ID `5dchxk6z8k7hg`
(2026-08-10 20:45:07 기동, 52분 경과 시점 관측, 사용자 승인 후 KILL):

    elapsed 4,909초 / CPU 4,900초 / buffer_gets 263,097,767 / rows_processed 0
    ASH 샘플 3,183건 **전량(100%)** 이 플랜 라인 11 · ON CPU 한 곳

    3 SORT GROUP BY NOSORT
    4  NESTED LOOPS                     EST 1,300,191,509
    5   INDEX FULL SCAN PK_SCM_ITEM_M   443,488행 구동
    6    VIEW PUSHED PREDICATE          starts 35,238  ← 구동행마다 재실행
   11      INDEX SKIP SCAN PK_SCM_ITEM_M
            filter SUBSTR(ITEM_ID,1,12)=SUBSTR(T1.ITEM_ID,1,12)   ← ★ 병목 100%

⇒ 병목은 **오직 `DM_MST_ITEM_SINGLE_V` 산출 1곳**. TRANSFER 의 나머지 구간
   (LOAD TABLE CONVENTIONAL / HASH GROUP BY / 룩업 조인)은 output_rows 0 으로
   **아예 도달조차 못 했다** — 즉 다른 구간은 이번 병목이 아니다.

## 1. 1순위 — 구조 치환 (SELECT 목록 함수 / SELECT 컬럼절 서브쿼리 제거)  ← TUNE-V

`DM_MST_ITEM_SINGLE_V` 는 SCM_MST_ITEM_SN 을 `SUBSTR(ITEM_ID,1,12)` 로 집계한
인라인뷰(T2)와 **셀프조인**한다. 옵티마이저가 그 인라인뷰에 PUSHED PREDICATE 를 걸면
GROUP BY 뷰가 **행별 상관 집계**로 전개되고, 비-SARGable SUBSTR 필터의 SKIP SCAN 이
구동행 수만큼 반복된다. 앞선 `/*+ MATERIALIZE */`(TUNE-M) 는 **이 붕괴를 막지 못했다**
— 붕괴가 "실체화하는 그 문장" 안으로 옮겨갔을 뿐이다(위 플랜 L2 LOAD AS SELECT 하위).

⇒ 힌트로 옵티마이저 판단을 바꾸는 대신 **셀프조인 자체를 제거**해
   PUSHED PREDICATE 가 성립 불가능한 형태로 만든다(단일 패스 + 분석함수).

등가 근거: T2 는 같은 테이블을 같은 키로 집계한 것이므로 T1 의 모든 행은 반드시
자기 그룹과 매칭된다(inner join 이 행을 떨구지 않음). 따라서
"T1 그룹(DIVISION_ID,ITEM_ID)별 MAX(T2.col)" = "SUBSTR12 파티션 전체의 MAX(col)".

실측 (DIVISION_ID='40', 바인드 사용):
    행수 168,619 / BIZ_TYPE NOT NULL 9,895 / PACK_COUNT 합 34,086  ← OLD·NEW 완전일치
    MINUS 양방향 0행 PASS / PASS
    COST 1,618,474 → 8,499     서버측 0.41초 → 0.21초
    플랜  HASH JOIN(EST 241,175,427) 소멸 → TABLE ACCESS FULL + HASH GROUP BY + WINDOW SORT

## 2. 2순위 — 인덱스 SARGable

1순위로 `SUBSTR(ITEM_ID,1,12)` 조인 술어 자체가 사라져 **비-SARGable 술어가 소멸**한다.
별도 인덱스 신설 불필요. (참고: FP_MGR.SCM_ITEM_M 에는 ITEM_ID_12 류 가상컬럼이 없고
PK 는 (ITEM_ID, COMPANY_ID, DIVISION_ID, SITE_ID) 라 DIVISION_ID 단독 조건이
SKIP SCAN 으로 빠지는 구조였다. 운영 DDL 임의 실행 금지 원칙에 따라 **신설은 제안만**.)

## 3. 3순위 — 힌트

1순위로 해결되어 **불필요**. 기존 `/*+ MATERIALIZE */` 는 ISV 가 UNION ALL 두 갈래에서
각각 참조되므로 1회 산출 목적에서 **유지**한다(붕괴 방지 목적이 아니라 중복 산출 방지 목적).

## 4. 별건 지시 — SELECT 컬럼절의 SELECT → JOIN 치환 (1순위 FUNCTION 과 동급)  ← TUNE-J

파서(괄호깊이 추적, 주석·문자열 마스킹)로 TRANSFER 경로 전수 스캔 → 5건 발견, 전량 치환.
유일성 실측 후 치환했으므로 **행 증식 없음**:
    SCM_ADM_LOOKUP_MASTER_DETAIL  MDF_DEPARTMENT            15행 / 15키 (1:1)
                                  DMF0044_DEPARTMENT_TEAM2  29행 / 29키 (1:1)
    DM_MDF_VERSION  PK_DM_MDF_VERSION = (DIVISION_ID, VERSION_NO) UNIQUE (1:1)

사용: python dmf0044_transfer_tune_apply.py --dump / --patch / --deploy
"""
import argparse
import pathlib
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info  # noqa: E402

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

ROOT = pathlib.Path(__file__).resolve().parents[2]
OUT = ROOT / "_artifacts" / "_apply_corporate"
BACKUP = OUT / "BACKUP_PKG_DMF0044_BODY_pre_transfertune_20260810.sql"
PATCHED = OUT / "PKG_DMF0044_BODY_TRANSFERTUNE_20260810.sql"

MARK_V = "TUNE-V 2026-08-10"
MARK_J = "TUNE-J 2026-08-10"

# ===========================================================================
# A. 병목 1순위 — ISV 구조 치환 (DEPT_CREATE / PRODUCT_CREATE 2곳 동일 원문)
# ===========================================================================
A_OLD = """        -- TUNE-M 2026-08-10: hook #129 1순위(구조 개선) — 힌트 대신 선계산 후 JOIN.
        --   DM_MST_ITEM_SINGLE_V 를 1회만 산출해 실체화한 뒤 조인한다.
        --   실측(대상 버전 R_S_20260128_V002_C, 전체 문장 형태 그대로 재현):
        --     원본 5.3초 / NO_PUSH_PRED(B)+USE_HASH(B) 5.0초 / +NO_PUSH_PRED(A) 5.1초
        --     / WITH MATERIALIZE 0.7초 — 결과 4안 모두 (23행, 합 3076304299584.838) 동일.
        --   바인드 변수 환경에서 카디널리티가 무너지면(EST 2.4억, INDEX FULL SCAN 구동)
        --   힌트로는 못 막는다. MATERIALIZE 는 옵티마이저 판단과 무관하게 1회 산출을 보장한다.
        WITH ISV AS (
            SELECT /*+ MATERIALIZE */ DIVISION_ID, ITEM_ID, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_CELL_PACK_COUNT
              FROM DM_MST_ITEM_SINGLE_V
             -- TUNE-M2 2026-08-10: 사전필터. 조인이 A.DIVISION_ID = B.DIVISION_ID 이고
             --   A 는 항상 DIVISION_ID = P_DIVISION_ID 로 걸리므로 타 division 행은
             --   조인될 수 없다 ⇒ 결과 불변. 386,286행 0.7초 → 168,619행 0.3초.
             WHERE DIVISION_ID = P_DIVISION_ID )
"""

A_NEW = """        -- TUNE-V 2026-08-10: hook #129 1순위(구조) — DM_MST_ITEM_SINGLE_V 사용 중단.
        --   ⚠ 앞선 TUNE-M(/*+ MATERIALIZE */ 로 1회 산출) 은 **실패한 조치**였다.
        --     리터럴 재현에서는 0.7초였으나, 바인드 실사용에서는 붕괴가 사라진 게 아니라
        --     "실체화하는 그 문장" 안으로 옮겨갔을 뿐이다. 그 근거를 남긴다:
        --     SID 512 / SQL_ID 5dchxk6z8k7hg — CPU 4,900초, buffer_gets 2.63억, 처리행 0,
        --     ASH 3,183 샘플 전량(100%)이 플랜 L11 INDEX SKIP SCAN PK_SCM_ITEM_M 한 곳.
        --     (L4 NESTED LOOPS EST 13억 / L6 VIEW PUSHED PREDICATE starts 35,238)
        --   원인: 뷰가 SCM_MST_ITEM_SN 을 SUBSTR(ITEM_ID,1,12) 로 집계한 인라인뷰와
        --     셀프조인하는 구조라, 옵티마이저가 PUSHED PREDICATE 를 걸면 GROUP BY 뷰가
        --     행별 상관 집계로 전개되고 비-SARGable SUBSTR 필터가 구동행 수만큼 반복된다.
        --   조치: 힌트로 판단을 바꾸는 대신 **셀프조인 자체를 제거** — PUSHED PREDICATE 가
        --     성립 불가능한 단일 패스 + 분석함수 형태로 바꾼다(2순위 SARGable 문제도 동시 소멸).
        --   등가: T2 는 같은 테이블을 같은 키로 집계한 것이라 T1 의 모든 행이 반드시 자기 그룹과
        --     매칭된다(inner join 이 행을 떨구지 않음) ⇒ "T1 그룹별 MAX(T2.col)"
        --     = "SUBSTR12 파티션 전체의 MAX(col)". 실측 DIVISION_ID='40':
        --     168,619행 / BIZ NOT NULL 9,895 / PACK 합 34,086 — OLD·NEW 완전일치,
        --     MINUS 양방향 0행 PASS, COST 1,618,474 → 8,499, 서버측 0.41초 → 0.21초.
        WITH ISV AS (
            -- /*+ MATERIALIZE */ 유지 사유: ISV 는 아래 UNION ALL 두 갈래에서 각각 참조된다.
            --   붕괴 방지용이 아니라 **중복 산출 방지용**이다(3순위 힌트는 불필요해짐).
            SELECT /*+ MATERIALIZE */ DIVISION_ID, ITEM_ID
                 , MAX(MAX(FORECAST_INFO_BIZ_TYPE))
                       OVER (PARTITION BY DIVISION_ID, SUBSTR(ITEM_ID,1,12)) AS FORECAST_INFO_BIZ_TYPE
                 , MAX(MAX(FORECAST_INFO_CELL_PACK_COUNT))
                       OVER (PARTITION BY DIVISION_ID, SUBSTR(ITEM_ID,1,12)) AS FORECAST_INFO_CELL_PACK_COUNT
              FROM SCM_MST_ITEM_SN
             -- TUNE-M2 2026-08-10: 사전필터(유지). 조인이 A.DIVISION_ID = B.DIVISION_ID 이고
             --   A 는 항상 DIVISION_ID = P_DIVISION_ID 로 걸리므로 타 division 행은
             --   조인될 수 없다 ⇒ 결과 불변.
             WHERE DIVISION_ID = P_DIVISION_ID
             GROUP BY DIVISION_ID, ITEM_ID )
"""

# ===========================================================================
# B1. DEPT_CREATE — 상관 스칼라 서브쿼리 2건 → LEFT OUTER JOIN
# ===========================================================================
B1_OLD = """                             , NVL((SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                     WHERE LOOKUP_TYPE = 'MDF_DEPARTMENT' AND C.DEPARTMENT_ID = SEGMENT1 AND ROWNUM = 1), '') AS DEPARTMENT_NAME
                             , NVL((SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                     WHERE LOOKUP_TYPE = 'DMF0044_DEPARTMENT_TEAM2' AND C.DEPT_ID = SEGMENT1 AND ROWNUM = 1), '') AS DEPT_NAME
"""

B1_NEW = """                             -- TUNE-J 2026-08-10: SELECT 컬럼절 스칼라 서브쿼리 → LEFT OUTER JOIN
                             --   (SELECT 목록 안의 SELECT 는 1순위 FUNCTION 과 동급 대체 대상 — 사용자 지시)
                             --   유일성 실측: SCM_ADM_LOOKUP_MASTER_DETAIL 의 (LOOKUP_TYPE, SEGMENT1) 은
                             --     MDF_DEPARTMENT 15행/15키, DMF0044_DEPARTMENT_TEAM2 29행/29키 로 1:1
                             --     ⇒ LEFT JOIN 이 행을 증식시키지 않는다(원본 ROWNUM=1 과 동일 결과).
                             --   NVL(x,'') 제거 사유: Oracle 은 '' = NULL 이라 NVL(x,'') ≡ x (항등).
                             --     미매치 시 NULL 유지는 **필수** — 바깥 ROW_NUMBER ORDER BY 의
                             --     `DEPARTMENT_NAME IS NULL` 분기와 GROUP BY 가 이 NULL 을 본다.
                             , LD.SEGMENT2  AS DEPARTMENT_NAME
                             , LT.SEGMENT2  AS DEPT_NAME
"""

B1F_OLD = """                                       WHERE DIVISION_ID = P_DIVISION_ID AND VERSION_NO = P_VERSION_NO ) Y
                         WHERE 1 = 1
"""

B1F_NEW = """                                       WHERE DIVISION_ID = P_DIVISION_ID AND VERSION_NO = P_VERSION_NO ) Y
                          -- TUNE-J 2026-08-10: 위 선택목록 스칼라 서브쿼리 2건의 조인 대체분
                          LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LD
                            ON LD.LOOKUP_TYPE = 'MDF_DEPARTMENT'           AND LD.SEGMENT1 = C.DEPARTMENT_ID
                          LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LT
                            ON LT.LOOKUP_TYPE = 'DMF0044_DEPARTMENT_TEAM2' AND LT.SEGMENT1 = C.DEPT_ID
                         WHERE 1 = 1
"""

# ===========================================================================
# B2. DEPT_CREATE — SELECT NVL((SELECT ...), NULL) INTO ... FROM DUAL  (1회성)
# ===========================================================================
B2_OLD = """        SELECT NVL((SELECT ORI_VERSION_NO FROM SCM_MGR.DM_MDF_VERSION
                     WHERE DIVISION_ID = P_DIVISION_ID AND VERSION_NO = P_VERSION_NO AND ROWNUM = 1), NULL)
          INTO v_ori_version_no FROM DUAL;
"""

B2_NEW = """        -- TUNE-J 2026-08-10: SELECT 컬럼절 서브쿼리(FROM DUAL 감싸기) 제거 → 직접 집계 조회.
        --   NVL(x, NULL) ≡ x (항등). PK_DM_MDF_VERSION=(DIVISION_ID,VERSION_NO) UNIQUE 이므로
        --   대상은 0 또는 1행 ⇒ MAX() 는 원본 ROWNUM=1 과 같은 값이며,
        --   집계라 행이 없어도 NO_DATA_FOUND 없이 NULL 을 돌려준다(원본과 동일 거동).
        SELECT MAX(ORI_VERSION_NO)
          INTO v_ori_version_no
          FROM SCM_MGR.DM_MDF_VERSION
         WHERE DIVISION_ID = P_DIVISION_ID AND VERSION_NO = P_VERSION_NO;
"""

# ===========================================================================
# B3. PRODUCT_CREATE — 비상관 스칼라 서브쿼리 → LEFT OUTER JOIN (+ GROUP BY 동반)
# ===========================================================================
B3_OLD = """             , NVL((SELECT V.ORI_VERSION_NO FROM SCM_MGR.DM_MDF_VERSION V
                     WHERE V.DIVISION_ID = P_DIVISION_ID AND V.VERSION_NO = P_VERSION_NO AND ROWNUM = 1), '-') AS ORI_VERSION_NO
"""

B3_NEW = """             -- TUNE-J 2026-08-10: SELECT 컬럼절 스칼라 서브쿼리 → LEFT OUTER JOIN.
             --   집계(MAX)만 있고 GROUP BY 가 없는 인라인뷰는 **항상 정확히 1행**을 돌려주므로
             --   LEFT JOIN ON 1=1 은 행을 떨구지도 늘리지도 않는다(0행이면 NULL → NVL 로 '-').
             --   PK_DM_MDF_VERSION=(DIVISION_ID,VERSION_NO) UNIQUE ⇒ MAX() = 원본 ROWNUM=1.
             , NVL(OV.ORI_VERSION_NO, '-') AS ORI_VERSION_NO
"""

B3F_OLD = """               ) Y
         WHERE 1 = 1
           AND A.YYYYMMDD LIKE Y.YYYY || '%'
"""

B3F_NEW = """               ) Y
          -- TUNE-J 2026-08-10: 위 ORI_VERSION_NO 스칼라 서브쿼리의 조인 대체분 (항상 1행)
          LEFT OUTER JOIN ( SELECT MAX(V.ORI_VERSION_NO) AS ORI_VERSION_NO
                              FROM SCM_MGR.DM_MDF_VERSION V
                             WHERE V.DIVISION_ID = P_DIVISION_ID
                               AND V.VERSION_NO  = P_VERSION_NO ) OV
            ON 1 = 1
         WHERE 1 = 1
           AND A.YYYYMMDD LIKE Y.YYYY || '%'
"""

B3G_OLD = """             , A.MEASURE
             , B.DISPLAY_SEQ
             , Y.YYYY;
"""

B3G_NEW = """             , A.MEASURE
             , B.DISPLAY_SEQ
             , Y.YYYY
             -- TUNE-J 2026-08-10: OV 는 전 행에 걸쳐 단일 값(1행 인라인뷰)이므로
             --   GROUP BY 에 추가해도 그룹 구성은 불변이다. 선택목록에 든 이상 문법상 필수.
             , OV.ORI_VERSION_NO;
"""

# ===========================================================================
# B4. EXCHANGE_RATE_CREATE — 비상관 스칼라 서브쿼리 → LEFT OUTER JOIN (+ GROUP BY)
# ===========================================================================
B4_OLD = """             , NVL((SELECT V.ORI_VERSION_NO FROM SCM_MGR.DM_MDF_VERSION V
                WHERE V.VERSION_NO = P_VERSION_NO AND V.DIVISION_ID = P_DIVISION_ID AND ROWNUM = 1), '-') AS ORI_VERSION_NO
"""

B4_NEW = """             -- TUNE-J 2026-08-10: SELECT 컬럼절 스칼라 서브쿼리 → LEFT OUTER JOIN (B3 와 동일 근거)
             , NVL(OV.ORI_VERSION_NO, '-') AS ORI_VERSION_NO
"""

B4F_OLD = """        ) Y
        WHERE  E.DIVISION_ID = P_DIVISION_ID
"""

B4F_NEW = """        ) Y
        -- TUNE-J 2026-08-10: 위 ORI_VERSION_NO 스칼라 서브쿼리의 조인 대체분 (항상 1행)
        LEFT OUTER JOIN ( SELECT MAX(V.ORI_VERSION_NO) AS ORI_VERSION_NO
                            FROM SCM_MGR.DM_MDF_VERSION V
                           WHERE V.DIVISION_ID = P_DIVISION_ID
                             AND V.VERSION_NO  = P_VERSION_NO ) OV
          ON 1 = 1
        WHERE  E.DIVISION_ID = P_DIVISION_ID
"""

B4G_OLD = """             , E.CURRENCY
             , E.UNIT_CURRENCY;
"""

B4G_NEW = """             , E.CURRENCY
             , E.UNIT_CURRENCY
             -- TUNE-J 2026-08-10: OV 는 단일 값(1행 인라인뷰) ⇒ 그룹 구성 불변. 문법상 필수.
             , OV.ORI_VERSION_NO;
"""

# (앵커, 치환, 기대건수, 설명)
EDITS = [
    (A_OLD,   A_NEW,   2, "A  병목 1순위 — ISV 셀프조인 제거(단일패스+분석함수)"),
    (B1_OLD,  B1_NEW,  1, "B1 DEPT 룩업 스칼라 서브쿼리 2건 → 조인컬럼 참조"),
    (B1F_OLD, B1F_NEW, 1, "B1 DEPT LEFT OUTER JOIN 2개 삽입"),
    (B2_OLD,  B2_NEW,  1, "B2 DEPT ORI_VERSION_NO (FROM DUAL 감싸기 제거)"),
    (B3_OLD,  B3_NEW,  1, "B3 PRODUCT ORI_VERSION_NO 선택목록"),
    (B3F_OLD, B3F_NEW, 1, "B3 PRODUCT LEFT OUTER JOIN 삽입"),
    (B3G_OLD, B3G_NEW, 1, "B3 PRODUCT GROUP BY 동반"),
    (B4_OLD,  B4_NEW,  1, "B4 EXCHANGE ORI_VERSION_NO 선택목록"),
    (B4F_OLD, B4F_NEW, 1, "B4 EXCHANGE LEFT OUTER JOIN 삽입"),
    (B4G_OLD, B4G_NEW, 1, "B4 EXCHANGE GROUP BY 동반"),
]


def live_body():
    import oracledb

    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044'
                        AND TYPE='PACKAGE BODY' ORDER BY LINE""")
        rows = cur.fetchall()
    if not rows:
        sys.exit("[error] PACKAGE BODY 없음")
    return "CREATE OR REPLACE " + "".join(r[0] for r in rows).lstrip()


def cmd_dump():
    OUT.mkdir(parents=True, exist_ok=True)
    body = live_body()
    BACKUP.write_text(body, encoding="utf-8")
    print("[dump] %s (%d 행)" % (BACKUP, len(body.splitlines())))
    bad = 0
    for old, _new, exp, desc in EDITS:
        got = body.count(old)
        ok = got == exp
        bad += 0 if ok else 1
        print("  %-58s 앵커 %d (기대 %d)%s" % (desc, got, exp, "" if ok else "  ⛔"))
    for m in (MARK_V, MARK_J):
        print("  신규 마커 '%s' 사전 존재 = %d (기대 0)%s"
              % (m, body.count(m), "" if body.count(m) == 0 else "  ⛔"))
        bad += 0 if body.count(m) == 0 else 1
    print("  → 불일치 %d건 %s" % (bad, "✅" if bad == 0 else "⛔ 패치 금지"))
    return 1 if bad else 0


def cmd_patch():
    if not BACKUP.is_file():
        sys.exit("[error] 백업 부재 — --dump 선행")
    orig = BACKUP.read_text(encoding="utf-8")
    text = orig
    for old, new, exp, desc in EDITS:
        got = text.count(old)
        if got != exp:
            sys.exit("[error] %s — 앵커 %d건 (기대 %d). 손대지 않음" % (desc, got, exp))
        text = text.replace(old, new)
        print("  적용 %-58s %d곳" % (desc, exp))

    # --- 무결성 검사 1: 역치환으로 원문이 정확히 복원되는가 (부수 변경 0 증명) ---
    rev = text
    for old, new, _exp, _d in reversed(EDITS):
        rev = rev.replace(new, old)
    if rev != orig:
        sys.exit("[error] 역치환 복원 불일치 — 의도치 않은 부수 변경 가능. 중단")
    print("  ✅ 역치환 복원 일치 — 의도한 %d개 구간 외 변경 0" % len(EDITS))

    # --- 무결성 검사 2: 마커/구조 카운트 ---
    checks = [
        (MARK_V, 2, "TUNE-V 마커"),
        ("SELECT /*+ MATERIALIZE */", 2, "MATERIALIZE 힌트(유지)"),
        ("              FROM DM_MST_ITEM_SINGLE_V\n", 0, "구 뷰 잔존(ISV CTE 한정)"),
        ("              FROM SCM_MST_ITEM_SN\n", 2, "신규 원천 테이블"),
        ("GROUP BY DIVISION_ID, ITEM_ID )", 2, "ISV GROUP BY"),
        ("LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LD", 1, "DEPT LD 조인"),
        ("LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LT", 1, "DEPT LT 조인"),
        ("NVL(OV.ORI_VERSION_NO, '-')", 2, "OV 참조"),
        ("P_VERSION_NO ) OV\n", 2, "OV 인라인뷰"),   # ') OV' 만 쓰면 ') OVER (' 와 충돌
        ("ON 1 = 1\n", 2, "OV 조인조건"),
        (", OV.ORI_VERSION_NO;", 2, "GROUP BY 동반"),
    ]
    for s, exp, desc in checks:
        got = text.count(s)
        if got != exp:
            sys.exit("[error] %s = %d (기대 %d) — 중단" % (desc, got, exp))
        print("  ✅ %-24s %d" % (desc, got))

    # --- 무결성 검사 3: 남은 선택목록 스칼라 서브쿼리 0건 (TRANSFER 경로) ---
    for s in ("NVL((SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL",
              "NVL((SELECT V.ORI_VERSION_NO",
              "NVL((SELECT ORI_VERSION_NO"):
        if s in text:
            sys.exit("[error] 선택목록 서브쿼리 잔존: %s — 중단" % s)
    print("  ✅ TRANSFER 경로 선택목록 스칼라 서브쿼리 잔존 0건")

    # --- 무결성 검사 4: TRANSFER 경로 밖의 DM_MST_ITEM_SINGLE_V 사용은 건드리지 않았음 ---
    #     (이번 범위는 TRANSFER 4 PROC 한정 — 나머지 사용처는 그대로 두는 것이 의도된 결과)
    n_before = orig.count("DM_MST_ITEM_SINGLE_V")
    n_after = text.count("DM_MST_ITEM_SINGLE_V")
    if n_before - n_after != 2:
        sys.exit("[error] 구 뷰 참조 감소 %d (기대 2 — ISV CTE 2곳만) — 중단" % (n_before - n_after))
    print("  ✅ 구 뷰 참조 %d → %d (ISV CTE 2곳만 제거, 경로 밖 %d곳 보존)"
          % (n_before, n_after, n_after))

    PATCHED.write_text(text, encoding="utf-8")
    print("[patch] %s (%d행, 원본 %d행)" % (PATCHED, len(text.splitlines()), len(orig.splitlines())))
    return 0


def cmd_deploy():
    import oracledb

    if not PATCHED.is_file():
        sys.exit("[error] 배포본 부재 — --patch 선행")
    sql = PATCHED.read_text(encoding="utf-8").rstrip().rstrip("/").rstrip()
    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 120")
        cur.execute(sql)
        cur.execute("""SELECT OBJECT_TYPE, STATUS FROM ALL_OBJECTS
                        WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0044' ORDER BY 1""")
        for r in cur.fetchall():
            print("  %-14s %s" % r)
        cur.execute("""SELECT LINE, POSITION, TEXT FROM ALL_ERRORS
                        WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' ORDER BY SEQUENCE""")
        errs = cur.fetchall()
        for e in errs:
            print("  ⛔ L%s:%s %s" % e)
        for m in (MARK_V, MARK_J):
            cur.execute("""SELECT NVL(SUM(REGEXP_COUNT(TEXT, :m)),0) FROM ALL_SOURCE
                            WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' AND TYPE='PACKAGE BODY'""",
                        {"m": m.replace("-", r"\-")})
            print("  배포 후 마커 '%s' = %d" % (m, cur.fetchone()[0]))
    return 1 if errs else 0


def main():
    ap = argparse.ArgumentParser()
    for f in ("dump", "patch", "deploy"):
        ap.add_argument("--" + f, action="store_true")
    a = ap.parse_args()
    if a.dump:
        sys.exit(cmd_dump())
    if a.patch:
        sys.exit(cmd_patch())
    if a.deploy:
        sys.exit(cmd_deploy())
    ap.error("--dump / --patch / --deploy 중 하나 필요")


if __name__ == "__main__":
    main()
