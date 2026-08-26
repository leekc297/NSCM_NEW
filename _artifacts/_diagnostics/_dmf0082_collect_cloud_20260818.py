#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""_dmf0082_collect_cloud_20260818.py — DMF0082 클라우드 이관 패키지 취합 (2026-08-18)

정책(hook deploy-axis-sweep-mandatory / #135 / 룰 22):
  · 축은 손나열이 아니라 **기계 스윕** — 직전 클라우드 패키지(DMF0082_PERF_CLOUD_20260815) 이후
    LAST_UPDATE_DATE 기준 delta 를 메타 테이블 전수에서 실측.
  · DB 원문은 배포본 ALL_SOURCE/원장 실측 덤프(파일 재사용 금지 — 신선도 보장).
  · 스윕 쿼리 실패 = 즉시 중단(SKIP 금지).
"""
import os
import sys
import time

import oracledb

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")

PKG = r"C:\Projects\NSCM\_artifacts\_deploy_packages\DMF0082_CLOUD_20260818"
SINCE = "2026-08-16"  # 직전 클라우드 패키지 PERF_CLOUD_20260815 이후

META_TABLES = [
    # (테이블, DMF0082 식별 컬럼 후보) — 스윕 대상. 컬럼 부재 시 즉시 중단.
    ("SCM_ADM_CMBO_SQL_M", ["SQL_ID", "SQL_DTL_CTN"]),
    ("SCM_MST_SHEET_COLUMNS", ["PROGRAM_ID"]),
    ("SCM_MST_SHEET_MEASURE", ["PROGRAM_ID"]),
    ("SCM_ADM_PROC_M", ["PROC_NM"]),
    ("SCM_ADM_API_M", ["API_ID", "API_URL"]),
    ("SCM_ADM_MNU_BTN_MPG_M", ["MNU_ID", "API_ID"]),
    ("SCM_ADM_USER_GR_MNU_BTN_MPG_M", ["MNU_ID"]),
    ("SCM_ADM_EXCEL_COLUMNS", ["PROGRAM_ID"]),
    ("SCM_ADM_LOOKUP_MASTER_DETAIL", ["SEGMENT2"]),
    ("SCM_ADM_MSG_M", ["MSG_ID"]),
]


def q(s):
    return "" if s is None else str(s).replace("'", "''")


def main():
    import ora

    u, p, d = ora.conn_info()
    con = None
    for _ in range(10):
        try:
            con = oracledb.connect(user=u, password=p, dsn=d)
            break
        except Exception:  # noqa: BLE001
            time.sleep(10)
    if con is None:
        raise SystemExit("접속 실패")
    cur = con.cursor()
    os.makedirs(os.path.join(PKG, "A_DB"), exist_ok=True)

    # ── 1) 기계 스윕: SINCE 이후 갱신된 DMF0082 관련 메타 행 ──────────────────────
    print("=" * 100)
    print(f"[1] 기계 스윕 — {SINCE} 이후 갱신 + DMF0082 연관 행 (실패=중단)")
    print("=" * 100)
    sweep = {}
    for tbl, cols in META_TABLES:
        cur.execute(
            f"""SELECT COLUMN_NAME FROM ALL_TAB_COLUMNS
                 WHERE OWNER='SCM_MGR' AND TABLE_NAME=:t""",
            {"t": tbl},
        )
        have = {r[0] for r in cur.fetchall()}
        if not have:
            raise SystemExit(f"[중단] {tbl} 부재")
        idcols = [c for c in cols if c in have]
        if not idcols:
            raise SystemExit(f"[중단] {tbl} 식별 컬럼({cols}) 전부 부재")
        like = " OR ".join(f"UPPER({c}) LIKE '%DMF0082%'" for c in idcols)
        upd = "LAST_UPDATE_DATE" if "LAST_UPDATE_DATE" in have else None
        if upd is None:
            raise SystemExit(f"[중단] {tbl} LAST_UPDATE_DATE 부재")
        cur.execute(
            f"""SELECT COUNT(*) FROM SCM_MGR.{tbl}
                 WHERE ({like}) AND {upd} >= TO_DATE('{SINCE}','YYYY-MM-DD')"""
        )
        n = cur.fetchone()[0]
        sweep[tbl] = n
        print(f"   {tbl:<34} delta = {n}")

    # 공유 자산(문자열에 DMF0082 없음) — 오늘 변경분 직접 확인
    cur.execute(
        """SELECT COUNT(*) FROM SCM_ADM_CMBO_SQL_M
            WHERE SQL_ID IN ('EndCustomer','SiteEndCustomerMapDMF0082')
              AND LAST_UPDATE_DATE >= TO_DATE(:s,'YYYY-MM-DD')""",
        {"s": SINCE},
    )
    print(f"   (공유) EndCustomer/SiteEndCustomerMap delta = {cur.fetchone()[0]}")

    # ── 2) PKG_DMF0082 SPEC+BODY 신선 덤프 ────────────────────────────────────────
    for typ, fname in (("PACKAGE", "01_PKG_DMF0082_SPEC.sql"), ("PACKAGE BODY", "02_PKG_DMF0082_BODY.sql")):
        cur.execute(
            """SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082'
                AND TYPE=:t ORDER BY LINE""",
            {"t": typ},
        )
        body = "".join(r[0] for r in cur.fetchall())
        path = os.path.join(PKG, "A_DB", fname)
        open(path, "w", encoding="utf-8", newline="").write(
            "CREATE OR REPLACE " + body.rstrip() + "\n/\n"
        )
        print(f"[2] {fname} — {len(body.splitlines())}줄 (ALL_SOURCE 신선 덤프)")

    # ── 3) CMBO 3본 (원장 실값 기반 MERGE) ────────────────────────────────────────
    lines = [
        "-- 03_CMBO_DMF0082_20260818.sql — 콤보 3본 (사내 원장 실값 스냅샷, 2026-08-18)",
        "--  ① EndCustomerByDivisionDMF0082 : 그리드 End Customer 셀 콤보 — division 3분기",
        "--     ((1) lookup 축 / (2) 40 SITE_ITEM owner 축 / (3) 81·82 = 조회조건과 동일한",
        "--      SCM_MST_SITE.END_CUSTOMER 축 [E20260818-ENDCUST81])",
        "--  ② SiteEndCustomerMapDMF0082 : 신규 — FE 표시/키 분리용 site→End Customer 맵",
        "--     (그리드 END_CUSTOMER 표시값을 조회조건 축으로 파생 — ForecastPrice.tsx ENDCUSTDISP)",
        "--  ③ (공유 ⚠) EndCustomer : 조회조건 콤보 정렬 — ORDER BY DIVISION_ID, DEPT_ID, CODE",
        "--     → DIVISION_ID, NAME, CODE (팀 우선 정렬이 드롭다운에서 무작위로 보이던 신고 정정).",
        "--     ⚠ 20개 화면 공유 — 적용 전 클라우드 등록본과 대조 권장.",
        "",
    ]
    for sid in ("EndCustomerByDivisionDMF0082", "SiteEndCustomerMapDMF0082", "EndCustomer"):
        cur.execute(
            "SELECT SQL_DTL_CTN, MDU_DIVS_CD, SQL_NM, USE_YN FROM SCM_ADM_CMBO_SQL_M WHERE SQL_ID=:i",
            {"i": sid},
        )
        row = cur.fetchone()
        if not row:
            raise SystemExit(f"[중단] CMBO {sid} 부재")
        body, mdu, nm, use = row
        body = body if isinstance(body, str) else body.read()
        lines += [
            f"MERGE INTO SCM_MGR.SCM_ADM_CMBO_SQL_M T",
            f"USING (SELECT '{sid}' AS SQL_ID FROM DUAL) S ON (T.SQL_ID = S.SQL_ID)",
            f"WHEN MATCHED THEN UPDATE SET SQL_DTL_CTN = '{q(body)}', USE_YN = '{q(use)}',",
            f"  LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE",
            f"WHEN NOT MATCHED THEN INSERT (SQL_ID, MDU_DIVS_CD, SQL_NM, SQL_DTL_CTN, USE_YN,"
            f" CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)",
            f"VALUES ('{sid}', '{q(mdu)}', '{q(nm)}', '{q(body)}', '{q(use)}',"
            f" 'admin', SYSDATE, 'admin', SYSDATE);",
            "",
        ]
    lines.append("COMMIT;")
    open(os.path.join(PKG, "A_DB", "03_CMBO_DMF0082_20260818.sql"), "w", encoding="utf-8", newline="").write("\n".join(lines))
    print("[3] 03_CMBO_DMF0082_20260818.sql — 3본")

    # ── 4) GRANT/SYNONYM (환율 BPS I/F) ──────────────────────────────────────────
    grant = """-- 04_GRANT_SYNONYM_EXCHANGE_RATE_UI.sql — DMF0082 환율 모달 [BPS I/F] PLS-00201 정정
--   원인: 2026-08-07 신설 standalone 래퍼 PR_SCM_MST_EXCHANGE_RATE_UI 에 앱 계정 노출 세트
--         (시노님 + EXECUTE GRANT)가 누락 — 무접두 호출이 식별자 미해석(ORA-06550/PLS-00201).
--   같은 화면의 PKG_DMF0082 / PR_SCM_MST_EXCHANGE_RATE 는 두 계정 모두 보유 — 신설 객체만 빠짐.

-- (1) GRANT — SCM_MGR 로 실행 가능
GRANT EXECUTE ON SCM_MGR.PR_SCM_MST_EXCHANGE_RATE_UI TO SCMP_APP;
GRANT EXECUTE ON SCM_MGR.PR_SCM_MST_EXCHANGE_RATE_UI TO SCMD_APP;

-- (2) 시노님 — DBA 또는 각 앱 계정으로 실행 (SCM_MGR 은 CREATE ANY SYNONYM 없음 → ORA-01031)
CREATE OR REPLACE SYNONYM SCMP_APP.PR_SCM_MST_EXCHANGE_RATE_UI FOR SCM_MGR.PR_SCM_MST_EXCHANGE_RATE_UI;
CREATE OR REPLACE SYNONYM SCMD_APP.PR_SCM_MST_EXCHANGE_RATE_UI FOR SCM_MGR.PR_SCM_MST_EXCHANGE_RATE_UI;

-- 검증 (기대: GRANT 2행 + 시노님 2행)
SELECT 'GRANT' AXIS, GRANTEE, PRIVILEGE FROM ALL_TAB_PRIVS
 WHERE TABLE_SCHEMA='SCM_MGR' AND TABLE_NAME='PR_SCM_MST_EXCHANGE_RATE_UI'
UNION ALL
SELECT '시노님', OWNER, TABLE_NAME FROM ALL_SYNONYMS
 WHERE TABLE_OWNER='SCM_MGR' AND TABLE_NAME='PR_SCM_MST_EXCHANGE_RATE_UI' ORDER BY 1,2;
"""
    open(os.path.join(PKG, "A_DB", "04_GRANT_SYNONYM_EXCHANGE_RATE_UI.sql"), "w", encoding="utf-8", newline="").write(grant)
    print("[4] 04_GRANT_SYNONYM_EXCHANGE_RATE_UI.sql")

    # ── 5) PRECHECK / VERIFY ─────────────────────────────────────────────────────
    pre = """-- 00_CLOUD_PRECHECK.sql — 적용 전 확인 (QA/DEV 각각, 조회만)
-- C1) 현재 BODY 마커 기준선 — 어떤 정정이 이미 있는가
SELECT M, CNT FROM (
 SELECT 'UPLOADBATCH(2단 NOT_SAVABLE 정정)' M, COUNT(*) CNT FROM ALL_SOURCE
  WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%E20260818-UPLOADBATCH%'
 UNION ALL SELECT 'PRICECHK1(판가검증 1단계 전진)', COUNT(*) FROM ALL_SOURCE
  WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%E20260818-PRICECHK1%'
 UNION ALL SELECT 'SENTINEL3', COUNT(*) FROM ALL_SOURCE
  WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%SENTINEL3 2026-08-07%'
 UNION ALL SELECT 'FCSTNAME(No.49)', COUNT(*) FROM ALL_SOURCE
  WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%E20260814-FCSTNAME%'
 UNION ALL SELECT 'UPLOADSAVE(2단 적재)', COUNT(*) FROM ALL_SOURCE
  WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%E20260813-UPLOADSAVE%'
);
-- 사내 기대: UPLOADBATCH 1 / PRICECHK1 1 / SENTINEL3 2+ / FCSTNAME 1 / UPLOADSAVE 1
-- 전부 0 이면 클라우드는 구본 — 02_BODY 전체 교체로 일괄 반영됨(회귀 범위 큼을 인지).

-- C2) PRICECHK1 이 참조하는 객체 존재 (부재 시 컴파일 실패)
SELECT TABLE_NAME FROM ALL_TABLES WHERE OWNER='SCM_MGR'
  AND TABLE_NAME IN ('GT_PRDM1_T_MAIN','GT_PRDM1_T_PRICE','GT_PRDM1_MSHYCHU1','GT_PRDM1_MSHYCHU2',
                     'GT_DMF0082_FCST_PRICE_EXCEL','GT_DMF0082_FCST_PRICE_UNPIVOT',
                     'GT_DMF0082_FCST_PRICE_WEEKLY','GT_DMF0082_FCST_PRICE_DAILY','GT_DMF0082_FCST_PRICE_BUCKET');
-- 기대: 9행

-- C3) 검증 스위치 lookup (기대: MEASURE 4 / FCST_TYPE 7)
SELECT SEGMENT1, COUNT(*) FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
 WHERE LOOKUP_TYPE='MKT_FCST_VALIDATION_PRICE' GROUP BY SEGMENT1;

-- C4) 공유 콤보 EndCustomer 현재 ORDER BY (변경 전 대조용)
SELECT SQL_ID, CASE WHEN SQL_DTL_CTN LIKE '%ORDER BY DIVISION_ID, NAME, CODE%' THEN '신본(이름순)'
            WHEN SQL_DTL_CTN LIKE '%ORDER BY DIVISION_ID, DEPT_ID, CODE%' THEN '구본(팀순)' ELSE '기타' END
  FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID='EndCustomer';
"""
    open(os.path.join(PKG, "00_CLOUD_PRECHECK.sql"), "w", encoding="utf-8", newline="").write(pre)

    ver = """-- 90_VERIFY.sql — 적용 후 검증 (대상 객체 실측 — 룰 #136)
-- V1) BODY VALID + 오류 0
SELECT OBJECT_TYPE, STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0082';
SELECT COUNT(*) ERRS FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082';  -- 기대 0
-- V2) 마커 (기대: UPLOADBATCH 1 / PRICECHK1 1 / ENDCUST81 1)
SELECT 'UPLOADBATCH' M, COUNT(*) FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082'
  AND TYPE='PACKAGE BODY' AND TEXT LIKE '%E20260818-UPLOADBATCH%'
UNION ALL SELECT 'PRICECHK1', COUNT(*) FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082'
  AND TYPE='PACKAGE BODY' AND TEXT LIKE '%E20260818-PRICECHK1%'
UNION ALL SELECT 'CMBO ENDCUST81', COUNT(*) FROM SCM_MGR.SCM_ADM_CMBO_SQL_M
  WHERE SQL_ID='EndCustomerByDivisionDMF0082' AND SQL_DTL_CTN LIKE '%E20260818-ENDCUST81%';
-- V3) 신규 콤보 (기대 1행)
SELECT SQL_ID, USE_YN FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID='SiteEndCustomerMapDMF0082';
-- V4) BPS I/F 노출 세트 (기대: GRANT 2 + 시노님 2)
SELECT 'GRANT' A, COUNT(*) C FROM ALL_TAB_PRIVS
 WHERE TABLE_SCHEMA='SCM_MGR' AND TABLE_NAME='PR_SCM_MST_EXCHANGE_RATE_UI'
UNION ALL SELECT '시노님', COUNT(*) FROM ALL_SYNONYMS
 WHERE TABLE_OWNER='SCM_MGR' AND TABLE_NAME='PR_SCM_MST_EXCHANGE_RATE_UI';
-- V5) 런타임 스모크 (사내 실증 시나리오 재현)
--  ① Excel Upload: [Upload] → 판가 미입력 키가 1단계 ERROR(미입력 주차 병기)로 분류되는가
--  ② [OK]: ERROR 0 파일이 NOT_SAVABLE 없이 적재되는가
--  ③ 81 조회: 그리드 End Customer 가 조회조건과 같은 값으로 표시되는가 (FE 배포 후)
--  ④ 환율 모달 [BPS I/F]: SQL ERROR 없이 성공 토스트
"""
    open(os.path.join(PKG, "A_DB", "90_VERIFY.sql"), "w", encoding="utf-8", newline="").write(ver)
    print("[5] 00_CLOUD_PRECHECK.sql + 90_VERIFY.sql")
    cur.close()
    con.close()


if __name__ == "__main__":
    main()
