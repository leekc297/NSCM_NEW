#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""dmf0044_etc_writeback_apply.py — DMF0044 ETC 저장분을 DM_PLN_SALES_ETC_REPORT_C 에 반영 (2026-08-11)

## 배경 (읽는 표 ≠ 쓰는 표)
DMF0044 Data Type=2(ETC) 는
  * 조회 원천 = `DM_PLN_SALES_ETC_REPORT_C`  (GET SP L1471~1585, `P_DATA_TYPE <> '1'` 분기)
  * 저장 대상 = `DM_PLN_SALES_PLAN_REPORT_C` (`P_DMF0044_SAVE_SALES_PLAN_REPORT_C` MERGE, DATA_TYPE='2')
로 서로 달라 **저장한 값이 같은 화면 재조회에 영영 나타나지 않는다**.
AS-IS DMF0044 도 ETC_REPORT_C 에 쓰기 0건(읽기 전용)이므로 이관 결함은 아니고, 사용자 사양의 신규 보완이다.

## 채택 규약 — AS-IS DMF0049_SAVE 방식 (사용자 확정 2026-08-11)
AS-IS `DMF0049_SAVE` (AsIs_LGCE_SCMDEV_SP1_DDL.sql L168757~168832) 원문:
    -- UPDATE -- 동일한 년월/메저가 있으면 데이터를 지우고, #테이블의 데이터를 인서트한다.
    DELETE A FROM DM_PLN_SALES_ETC_REPORT_C A JOIN #results_MST B
      ON A.DATA_SEQ=B.DATA_SEQ AND A.FCST_TYPE=B.FCST_TYPE AND A.MEASURE=B.MEASURE
     AND A.YYYYMMDD LIKE LEFT(B.YYYYMMDD,6)+'%'   ... 이어서 INSERT
    -- 신규(DATA_SEQ='') 는 MAX(DATA_SEQ) + DENSE_RANK() 로 채번
⇒ 배분(pro-rata) 없음. **동일 그룹 다중 행을 지우고 1행으로 입력**한다.

## 식별키 — 사내 전수 실측(2026-08-11, DM_PLN_SALES_ETC_REPORT_C 209,696행)
FE 가 공급하는 15키(+월) = DIVISION_ID / VERSION_NO / CUTOFF_TYPE / DEPARTMENT_ID / DEPT_ID /
END_CUST_REPORT / CUST_REPORT / PRODUCT_GROUP / ITEM_ID / MEASURE / SUBSTR(YYYYMMDD,1,6) /
CURRENCY / COMPANY_ID / CELL_MODEL_INFO / ATTRIBUTE3(=CELL_MODEL)

  | 지표 | 실측 |
  |---|---|
  | FE 키 그룹 수 | 209,645 (총 209,696행) |
  | **FE 키가 2개 이상 그리드 행에 걸침** | **0건** (MAX_GRID=1) ⇒ 과잉 삭제 불가능 |
  | 1행 그룹 | 209,594 (99.976%) |
  | 2행 그룹 | 51 (0.024%) — 전부 동일 일자·DATA_SEQ 만 상이, 양쪽 QTY≠0 |
  | 일자 규약 | 01/02/03 = 월 첫 영업일 (GTT YYYYMMDD 변환값과 동일) |

즉 배분 규칙이 필요한 진짜 1:N 은 없다. 중복 51건은 **대표행(MIN DATA_SEQ)에 화면 합계를 남기고
잔여를 제거**한다 — 화면이 보내는 값이 곧 그 그룹의 합계이므로 총액 불변.

## 구현 (3 문장, 전부 set-based)
  (1) 'D' 요청분   : 매칭 행 전량 DELETE
  (2) 중복 정리     : 매칭 그룹 내 ROW_NUMBER()>1 행 DELETE  ("동일 다중 행 삭제")
  (3) MERGE        : 대표행 PK 에 UPDATE(QTY+감사스탬프) / 미존재 시 INSERT(DATA_SEQ 채번)
      - ON 은 **정확히 PK**(VERSION_NO, DIVISION_ID, DATA_SEQ, MEASURE, YYYYMMDD) → 모호성 0
      - 감사 컬럼은 AS-IS 재INSERT 와 동일하게 CREATED_BY/CREATION_DATE 까지 갱신
      - 채번 = AS-IS 파리티 `NVL(MAX(DATA_SEQ),1) + DENSE_RANK()`

## ⭐ 동작 범위 확대 (의도적, 보고 대상)
기존 PLAN 저장은 `IF v_cutoff_type = 'REPORT_SP_W'` 안에만 있어 **REPORT_BP_M 은 저장이 무동작**이었다.
본 블록은 그 IF **밖**에 두어 BP 타입 ETC 편집도 원장에 남는다(ETC 행 자체가 CUTOFF_TYPE 로 구분됨).

사용:
  python dmf0044_etc_writeback_apply.py --dump     # live BODY 백업
  python dmf0044_etc_writeback_apply.py --patch    # 백업본에 hunk 적용
  python dmf0044_etc_writeback_apply.py --deploy   # 배포 + 컴파일 + 선행 마커 잔존 확인
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
BACKUP = OUT / "BACKUP_PKG_DMF0044_BODY_pre_etcwb_20260811.sql"
PATCHED = OUT / "PKG_DMF0044_BODY_ETCWB_20260811.sql"

# ⭐ 회귀 감시 — 선행 적용분이 이 배포로 유실되면 안 된다
GUARD_MARKS = {
    "AUTHUNION 2026-08-09": 1,             # 권한그룹 합집합
    "20260805 MERGE-ON 파리티 복원": 1,     # PLAN SAVE MERGE ON 3키 복원
    "PIVOTSEL 2026-08-10": 1,              # 동적 PIVOT SELECT 목록 분리
    "TUNE-V": 2,                           # DM_MST_ITEM_SINGLE_V 셀프조인 제거 (호출지점 2곳 — L9413/L9754 실측)
}

# ── ETC_REPORT_C(A) ↔ GTT payload(B) 매칭 술어 ───────────────────────────────────────────────
#   NOT NULL + 항상 공급되는 6키는 원형 유지(PK 선두 VERSION_NO/DIVISION_ID 인덱스 사용),
#   나머지는 hook #119 센티널 규약으로 양변 정규화(''=NULL 미매칭 차단).
_PRED = """                   A.VERSION_NO    = {b}.VERSION_NO
               AND A.DIVISION_ID   = {b}.DIVISION_ID
               AND A.CUTOFF_TYPE   = {b}.CUTOFF_TYPE
               AND A.ITEM_ID       = {b}.ITEM_ID
               AND A.MEASURE       = {b}.MEASURE
               AND A.CURRENCY      = {b}.CURRENCY
               AND SUBSTR(A.YYYYMMDD,1,6) = SUBSTR({b}.YYYYMMDD,1,6)
               AND NVL(NULLIF(TRIM(A.DEPARTMENT_ID),''),'-')   = NVL(NULLIF(TRIM({b}.DEPARTMENT_ID),''),'-')
               AND NVL(NULLIF(TRIM(A.DEPT_ID),''),'-')         = NVL(NULLIF(TRIM({b}.DEPT_ID),''),'-')
               AND NVL(NULLIF(TRIM(A.END_CUST_REPORT),''),'-') = NVL(NULLIF(TRIM({b}.END_CUST_REPORT),''),'-')
               AND NVL(NULLIF(TRIM(A.CUST_REPORT),''),'-')     = NVL(NULLIF(TRIM({b}.CUST_REPORT),''),'-')
               AND NVL(NULLIF(TRIM(A.PRODUCT_GROUP),''),'-')   = NVL(NULLIF(TRIM({b}.PRODUCT_GROUP),''),'-')
               AND NVL(NULLIF(TRIM(A.COMPANY_ID),''),'-')      = NVL(NULLIF(TRIM({b}.COMPANY_ID),''),'-')
               AND NVL(NULLIF(TRIM(A.CELL_MODEL_INFO),''),'-') = NVL(NULLIF(TRIM({b}.CELL_MODEL_INFO),''),'-')
               AND NVL(NULLIF(TRIM(A.ATTRIBUTE3),''),'-')      = NVL(NULLIF(TRIM({b}.CELL_MODEL),''),'-')"""

# 중복 정리용 — 매칭 그룹의 PARTITION BY 축(= 위 술어의 A 측 표현식과 1:1)
_PART = """                          A2.VERSION_NO, A2.DIVISION_ID, A2.CUTOFF_TYPE, A2.ITEM_ID, A2.MEASURE
                        , A2.CURRENCY, SUBSTR(A2.YYYYMMDD,1,6)
                        , NVL(NULLIF(TRIM(A2.DEPARTMENT_ID),''),'-')
                        , NVL(NULLIF(TRIM(A2.DEPT_ID),''),'-')
                        , NVL(NULLIF(TRIM(A2.END_CUST_REPORT),''),'-')
                        , NVL(NULLIF(TRIM(A2.CUST_REPORT),''),'-')
                        , NVL(NULLIF(TRIM(A2.PRODUCT_GROUP),''),'-')
                        , NVL(NULLIF(TRIM(A2.COMPANY_ID),''),'-')
                        , NVL(NULLIF(TRIM(A2.CELL_MODEL_INFO),''),'-')
                        , NVL(NULLIF(TRIM(A2.ATTRIBUTE3),''),'-')"""

# 기존 대표행 조회용 인라인뷰 (그룹 → 남길 DATA_SEQ / YYYYMMDD)
_EXIST_VIEW = """            SELECT VERSION_NO, DIVISION_ID, CUTOFF_TYPE, ITEM_ID, MEASURE, CURRENCY
                 , SUBSTR(YYYYMMDD,1,6)                          AS K_YM
                 , NVL(NULLIF(TRIM(DEPARTMENT_ID),''),'-')       AS K_DEPARTMENT
                 , NVL(NULLIF(TRIM(DEPT_ID),''),'-')             AS K_DEPT
                 , NVL(NULLIF(TRIM(END_CUST_REPORT),''),'-')     AS K_ECR
                 , NVL(NULLIF(TRIM(CUST_REPORT),''),'-')         AS K_CR
                 , NVL(NULLIF(TRIM(PRODUCT_GROUP),''),'-')       AS K_PG
                 , NVL(NULLIF(TRIM(COMPANY_ID),''),'-')          AS K_CO
                 , NVL(NULLIF(TRIM(CELL_MODEL_INFO),''),'-')     AS K_CMI
                 , NVL(NULLIF(TRIM(ATTRIBUTE3),''),'-')          AS K_CM
                 , MIN(DATA_SEQ)                                 AS KEEP_SEQ
                 , MIN(YYYYMMDD)                                 AS KEEP_YMD
            FROM   SCM_MGR.DM_PLN_SALES_ETC_REPORT_C
            WHERE  (VERSION_NO, DIVISION_ID) IN (SELECT VERSION_NO, DIVISION_ID FROM SCM_MGR.GT_0044_RESULTS_MST)
            GROUP BY VERSION_NO, DIVISION_ID, CUTOFF_TYPE, ITEM_ID, MEASURE, CURRENCY
                 , SUBSTR(YYYYMMDD,1,6)
                 , NVL(NULLIF(TRIM(DEPARTMENT_ID),''),'-')
                 , NVL(NULLIF(TRIM(DEPT_ID),''),'-')
                 , NVL(NULLIF(TRIM(END_CUST_REPORT),''),'-')
                 , NVL(NULLIF(TRIM(CUST_REPORT),''),'-')
                 , NVL(NULLIF(TRIM(PRODUCT_GROUP),''),'-')
                 , NVL(NULLIF(TRIM(COMPANY_ID),''),'-')
                 , NVL(NULLIF(TRIM(CELL_MODEL_INFO),''),'-')
                 , NVL(NULLIF(TRIM(ATTRIBUTE3),''),'-')"""

ETC_BLOCK = """    --------------------------------------------------------------------------------------------◇◇◇◇
    -- [ETCWB 2026-08-11] DM_PLN_SALES_ETC_REPORT_C 반영 (ETC 화면 저장분이 재조회에 보이도록)
    --   배경 : ETC 는 조회 원천(ETC_REPORT_C) 과 저장 대상(PLAN_REPORT_C) 이 달라 저장분이 화면에
    --          영영 보이지 않았다. AS-IS DMF0044 도 ETC_REPORT_C 쓰기 0건(읽기 전용) — 신규 보완 사양.
    --   규약 : AS-IS DMF0049_SAVE(SP1 L168757~168832) "동일 년월/메저 행을 지우고 다시 INSERT" 그대로.
    --          배분(pro-rata) 없음.
    --   식별 : FE 15키 + 월. 사내 전수 실측(209,696행) — 이 키가 2개 이상 그리드 행에 걸치는 경우
    --          0건(과잉 삭제 불가). 중복 51건(0.024%)은 동일 일자·DATA_SEQ 만 상이 → 대표행에
    --          화면 합계를 남기고 잔여 제거(총액 불변).
    --   범위 : PLAN 저장(REPORT_SP_W 전용) IF 밖 — BP_M ETC 편집도 원장에 남는다.
    --------------------------------------------------------------------------------------------◇◇◇◇

    -- (ETCWB-1) 삭제 요청분('D') — 매칭 행 전량 제거
    DELETE FROM SCM_MGR.DM_PLN_SALES_ETC_REPORT_C A
    WHERE  EXISTS (
               SELECT 1
               FROM   SCM_MGR.GT_0044_RESULTS_MST B
               WHERE  B.ACTIVE_FLAG = 'D'
               AND
{PRED_D}
           );

    -- (ETCWB-2) 동일 그룹 중복행 제거 — 대표행(MIN DATA_SEQ, MIN YYYYMMDD) 1건만 남긴다
    DELETE FROM SCM_MGR.DM_PLN_SALES_ETC_REPORT_C
    WHERE  ROWID IN (
               SELECT RID
               FROM (
                   SELECT A2.ROWID AS RID
                        , ROW_NUMBER() OVER (
                            PARTITION BY
{PART}
                            ORDER BY A2.DATA_SEQ, A2.YYYYMMDD
                          ) AS RN
                   FROM   SCM_MGR.DM_PLN_SALES_ETC_REPORT_C A2
                   WHERE  EXISTS (
                              SELECT 1
                              FROM   SCM_MGR.GT_0044_RESULTS_MST B
                              WHERE  B.ACTIVE_FLAG <> 'D'
                              AND
{PRED_A2}
                          )
               )
               WHERE RN > 1
           );

    -- (ETCWB-3) 신규행 DATA_SEQ 채번 기준 (AS-IS L168802 `ISNULL(MAX(DATA_SEQ),1)` 파리티)
    SELECT NVL(MAX(DATA_SEQ), 1)
    INTO   n_etc_max_seq
    FROM   SCM_MGR.DM_PLN_SALES_ETC_REPORT_C
    WHERE  VERSION_NO  = v_version_no
    AND    DIVISION_ID = v_division_id;

    -- (ETCWB-3b) 감사 사용자 확보 — ⚠ P_CREATED_BY 는 BE 가 세션 사용자 **1개만** 주입한다.
    --   payload N행을 '^' 로 split 하면 2번째 행부터 REGEXP_SUBSTR 가 NULL 을 낸다.
    --   PLAN_REPORT_C 는 해당 컬럼이 nullable 이라 조용히 넘어갔지만 ETC_REPORT_C 는
    --   CREATED_BY / LAST_UPDATED_BY 가 NOT NULL → ORA-01407 (2026-08-11 실사고).
    SELECT MAX(CREATED_BY)
    INTO   v_etc_user
    FROM   SCM_MGR.GT_0044_RESULTS_MST
    WHERE  CREATED_BY IS NOT NULL;

    -- (ETCWB-4) 대표행 UPDATE / 미존재 시 INSERT — ON 은 정확히 PK 5키
    MERGE INTO SCM_MGR.DM_PLN_SALES_ETC_REPORT_C A
    USING (
        SELECT B.*
             , NVL(E.KEEP_SEQ,
                   n_etc_max_seq + DENSE_RANK() OVER (
                       ORDER BY NVL(NULLIF(TRIM(B.DEPARTMENT_ID),''),'-')
                              , NVL(NULLIF(TRIM(B.DEPT_ID),''),'-')
                              , NVL(NULLIF(TRIM(B.CUST_REPORT),''),'-')
                              , NVL(NULLIF(TRIM(B.END_CUST_REPORT),''),'-')
                              , NVL(NULLIF(TRIM(B.PRODUCT_GROUP),''),'-')
                              , B.ITEM_ID
                              , B.CURRENCY
                              , NVL(NULLIF(TRIM(B.COMPANY_ID),''),'-')
                              , NVL(NULLIF(TRIM(B.CELL_MODEL_INFO),''),'-')
                              , NVL(NULLIF(TRIM(B.CELL_MODEL),''),'-')
                   )) AS TGT_SEQ
             , NVL(E.KEEP_YMD, B.YYYYMMDD) AS TGT_YMD
        FROM   SCM_MGR.GT_0044_RESULTS_MST B
        LEFT JOIN (
{EXIST_VIEW}
        ) E
            ON  E.VERSION_NO    = B.VERSION_NO
            AND E.DIVISION_ID   = B.DIVISION_ID
            AND E.CUTOFF_TYPE   = B.CUTOFF_TYPE
            AND E.ITEM_ID       = B.ITEM_ID
            AND E.MEASURE       = B.MEASURE
            AND E.CURRENCY      = B.CURRENCY
            AND E.K_YM          = SUBSTR(B.YYYYMMDD,1,6)
            AND E.K_DEPARTMENT  = NVL(NULLIF(TRIM(B.DEPARTMENT_ID),''),'-')
            AND E.K_DEPT        = NVL(NULLIF(TRIM(B.DEPT_ID),''),'-')
            AND E.K_ECR         = NVL(NULLIF(TRIM(B.END_CUST_REPORT),''),'-')
            AND E.K_CR          = NVL(NULLIF(TRIM(B.CUST_REPORT),''),'-')
            AND E.K_PG          = NVL(NULLIF(TRIM(B.PRODUCT_GROUP),''),'-')
            AND E.K_CO          = NVL(NULLIF(TRIM(B.COMPANY_ID),''),'-')
            AND E.K_CMI         = NVL(NULLIF(TRIM(B.CELL_MODEL_INFO),''),'-')
            AND E.K_CM          = NVL(NULLIF(TRIM(B.CELL_MODEL),''),'-')
        WHERE  B.ACTIVE_FLAG <> 'D'
    ) B2
    ON (
            A.VERSION_NO  = B2.VERSION_NO
        AND A.DIVISION_ID = B2.DIVISION_ID
        AND A.DATA_SEQ    = B2.TGT_SEQ
        AND A.MEASURE     = B2.MEASURE
        AND A.YYYYMMDD    = B2.TGT_YMD
    )
    WHEN MATCHED THEN
        -- 생성정보(CREATED_BY/CREATION_DATE)는 보존한다 — AS-IS 는 재INSERT 라 덮어썼지만,
        -- 본 구현은 대표행 UPDATE 이므로 원 생성 이력을 지울 이유가 없다.
        UPDATE SET
            A.QTY              = TO_NUMBER(B2.QTY),
            A.LAST_UPDATED_BY  = NVL(NVL(B2.CREATED_BY, v_etc_user), A.LAST_UPDATED_BY),
            A.LAST_UPDATE_DATE = SYSDATE
    WHEN NOT MATCHED THEN
        INSERT (
            VERSION_NO, DIVISION_ID, DATA_SEQ, CUTOFF_TYPE, CUTOFF_YYYYMMDD,
            DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME,
            END_CUST_REPORT, CUST_REPORT, PRODUCT_GROUP,
            PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID,
            MEASURE, YYYYMMDD, CURRENCY, COMPANY_ID,
            CELL_MODEL_INFO, ATTRIBUTE3, QTY,
            CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
        )
        VALUES (
            B2.VERSION_NO, B2.DIVISION_ID, B2.TGT_SEQ, B2.CUTOFF_TYPE,
            NVL(B2.CUTOFF_YYYYMMDD, '-'),                 -- NOT NULL (hook #119 센티널)
            NVL(B2.DEPARTMENT_ID, '-'), B2.DEPARTMENT_NAME,
            NVL(B2.DEPT_ID, '-'), B2.DEPT_NAME,
            B2.END_CUST_REPORT, B2.CUST_REPORT, B2.PRODUCT_GROUP,
            '-', '-', NVL(B2.ITEM_ID, '-'), '-', '-', '-', '-',
            NVL(B2.MEASURE, '-'), NVL(B2.TGT_YMD, '-'), NVL(B2.CURRENCY, '-'), B2.COMPANY_ID,
            B2.CELL_MODEL_INFO, B2.CELL_MODEL, TO_NUMBER(B2.QTY),
            NVL(NVL(B2.CREATED_BY, v_etc_user), 'admin'), SYSDATE,
            NVL(NVL(B2.CREATED_BY, v_etc_user), 'admin'), SYSDATE
        );

"""


def _block():
    return (ETC_BLOCK
            .replace("{PRED_D}", _PRED.format(b="B"))
            .replace("{PRED_A2}", _PRED.format(b="B").replace("A.", "A2."))
            .replace("{PART}", _PART)
            .replace("{EXIST_VIEW}", _EXIST_VIEW))


# ── hunk ①: 변수 선언 추가 ──────────────────────────────────────────────────────────────────
_H1_OLD = "    n_logo_count            PLS_INTEGER := 0;\n"
_H1_NEW = (
    "    n_logo_count            PLS_INTEGER := 0;\n"
    "    -- [ETCWB 2026-08-11] ETC_REPORT_C 신규행 DATA_SEQ 채번 기준 (AS-IS @v_max_seq 파리티)\n"
    "    n_etc_max_seq           NUMBER := 0;\n"
    "    -- [ETCWB 2026-08-11] 감사 사용자 — '^' split 2번째 행부터 P_CREATED_BY 가 NULL 이라 필요\n"
    "    v_etc_user              VARCHAR2(100 CHAR);\n"
)

# ── hunk ②: ETC 반영 블록 삽입 (PLAN 저장 IF 종료 직후, GDW lookup MERGE 앞) ────────────────
_H2_OLD = "    --ELSE\n"


def live_body():
    import oracledb

    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute(
            """SELECT TEXT FROM ALL_SOURCE
                WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' AND TYPE='PACKAGE BODY' ORDER BY LINE"""
        )
        rows = cur.fetchall()
    if not rows:
        sys.exit("[error] PACKAGE BODY 없음: PKG_DMF0044")
    return "CREATE OR REPLACE " + "".join(r[0] for r in rows).lstrip()


def cmd_dump():
    OUT.mkdir(parents=True, exist_ok=True)
    body = live_body()
    BACKUP.write_text(body, encoding="utf-8")
    print("[dump] %s (%d 행)" % (BACKUP, len(body.splitlines())))
    for m, n in GUARD_MARKS.items():
        got = body.count(m)
        print("  선행 마커 '%s' = %d건 (기대 %d)%s" % (m, got, n, "" if got == n else "  ⚠"))
    if "ETCWB" in body:
        print("  ⚠ 이미 ETCWB 마커가 있다 — 재적용 금지")
    return 0


def cmd_patch():
    if not BACKUP.is_file():
        sys.exit("[error] 백업 부재 — --dump 선행")
    text = BACKUP.read_text(encoding="utf-8")
    if "ETCWB" in text:
        sys.exit("[error] 이미 ETCWB 적용됨 — 중단")
    for label, old, cnt in (("H1 변수선언", _H1_OLD, 1), ("H2 삽입지점", _H2_OLD, 1)):
        n = text.count(old)
        if n != cnt:
            sys.exit("[error] %s 앵커 %d건 (기대 %d건) — 손대지 않음" % (label, n, cnt))
    text = text.replace(_H1_OLD, _H1_NEW)
    text = text.replace(_H2_OLD, _block() + _H2_OLD)
    for m, n in GUARD_MARKS.items():
        if text.count(m) != n:
            sys.exit("[error] 선행 마커 '%s' 소실 — 중단" % m)
    # PLAN 저장 경로 무변경 확인
    if text.count("MERGE INTO SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A") != \
       BACKUP.read_text(encoding="utf-8").count("MERGE INTO SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A"):
        sys.exit("[error] PLAN 저장 MERGE 건수 변동 — 중단")
    PATCHED.write_text(text, encoding="utf-8")
    print("[patch] %s (%d행, 백업 대비 +%d행)"
          % (PATCHED, len(text.splitlines()),
             len(text.splitlines()) - len(BACKUP.read_text(encoding="utf-8").splitlines())))
    print("  ETCWB 마커 %d건 / 선행 마커 %d종 유지 ✅ / PLAN MERGE 무변경 ✅"
          % (text.count("ETCWB"), len(GUARD_MARKS)))
    return 0


def cmd_deploy():
    import oracledb

    if not PATCHED.is_file():
        sys.exit("[error] 배포본 부재 — --patch 선행")
    sql = PATCHED.read_text(encoding="utf-8").rstrip().rstrip("/").rstrip()
    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 60")
        cur.execute(sql)
        cur.execute("SELECT OBJECT_TYPE, STATUS FROM ALL_OBJECTS "
                    "WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0044' ORDER BY 1")
        for r in cur.fetchall():
            print("  %-14s %s" % (r[0], r[1]))
        cur.execute("SELECT LINE, POSITION, TEXT FROM ALL_ERRORS "
                    "WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' ORDER BY SEQUENCE")
        errs = cur.fetchall()
        for e in errs:
            print("  ⛔ L%s:%s %s" % (e[0], e[1], e[2]))
        for m, n in list(GUARD_MARKS.items()) + [("ETCWB", None)]:
            cur.execute("SELECT COUNT(*) FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' "
                        "AND TYPE='PACKAGE BODY' AND INSTR(TEXT, :m) > 0", {"m": m})
            got = cur.fetchone()[0]
            ok = "" if (n is None and got > 0) or (n is not None and got == n) else "  ⛔ 회귀"
            print("  마커 '%s' = %d%s" % (m, got, ok))
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
