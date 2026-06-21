#!/usr/bin/env python3
"""
옵션 B — 신규 GTT V2 + SP body reference 변경

배경:
  apply 76 GTT ALTER ORA-14450 (37 lock 잔존) + KILL SESSION 권한 없음.
  사용자 명시 (2026-06-20):
    1. GTT lock → 신규 GTT 작성 진행
    2. LEFT JOIN 결과 오염 우려 — 옵션 C 거부

작업:
  Step 1) CREATE GLOBAL TEMPORARY TABLE GT_DMF0043_PLAN_REPORT_C_V2
          (기존 7 컬럼 + PRODUCT_GROUP + FORECAST_INFO_BIZ_TYPE) ON COMMIT PRESERVE ROWS
  Step 2) SP body 의 모든 GT_DMF0043_PLAN_REPORT_C → V2 변경
  Step 3) INSERT SELECT 의 source 절에 PRODUCT_GROUP / FORECAST_INFO_BIZ_TYPE 추가
          (BP_FCST 와 SALES_PLAN 두 곳)
  Step 4) L334 + L559 'N' AS PRODUCT_GROUP → NVL(A.PRODUCT_GROUP, 'N')
  Step 5) sanity 검증
  Step 6) (optional) 기존 GTT DROP — 다른 SP 사용 없으면

기존 GTT 영향: 기존 SP/뷰 의 GT_DMF0043_PLAN_REPORT_C reference 확인 후 결정.
"""
import datetime
from pathlib import Path
import oracledb

CONN = dict(user="SCM_MGR", password="!SCMroqkf2026", dsn="121.162.245.167:2521/OCGSCMD_P01")
SP = "DMF0043_GET_CONTRIBUTION_SALES_LIST"
OLD_GTT = "GT_DMF0043_PLAN_REPORT_C"
NEW_GTT = "GT_DMF0043_PLAN_REPORT_C_V2"
BACKUP_DIR = Path(__file__).parent.parent / "_diagnostics"
LOG_DIR = Path(__file__).parent / "_logs"
LOG_DIR.mkdir(parents=True, exist_ok=True)

def main():
    ts = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    log = [f"=== 옵션 B: 신규 GTT V2 ({ts}) ==="]
    conn = oracledb.connect(**CONN)
    cur = conn.cursor()
    cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 60")
    try:
        # === Step 1: GTT V2 CREATE (멱등 — 존재 시 DROP 후 재생성) ============
        cur.execute(f"SELECT COUNT(*) FROM USER_TABLES WHERE TABLE_NAME='{NEW_GTT}'")
        if cur.fetchone()[0] > 0:
            try:
                cur.execute(f"DROP TABLE SCM_MGR.{NEW_GTT}")
                log.append(f"  [DROP existing {NEW_GTT}] OK")
            except Exception as e:
                log.append(f"  [DROP fail] {str(e)[:100]} — 기존 V2 사용")
        cur.execute(f"""
            CREATE GLOBAL TEMPORARY TABLE SCM_MGR.{NEW_GTT} (
                DIVISION_ID              VARCHAR2(60),
                VERSION_NO               VARCHAR2(150),
                PROJECT_CODE             VARCHAR2(60),
                SCM_SITE_ID              VARCHAR2(60),
                ITEM_ID                  VARCHAR2(60),
                YYYYMMDD                 VARCHAR2(8),
                QTY                      NUMBER,
                PRODUCT_GROUP            VARCHAR2(60),
                FORECAST_INFO_BIZ_TYPE   VARCHAR2(60)
            ) ON COMMIT PRESERVE ROWS
        """)
        log.append(f"  [CREATE GTT V2] OK")

        # === Step 2~4: SP body patch =====================================
        cur.execute("SELECT TEXT FROM USER_SOURCE WHERE NAME=:n AND TYPE='PROCEDURE' ORDER BY LINE", n=SP)
        src = "".join((r[0] or "") for r in cur.fetchall())
        (BACKUP_DIR / f"{SP}_optionB_before_{ts}.sql").write_text("CREATE OR REPLACE " + src, encoding="utf-8")
        log.append(f"  [BACKUP] {len(src)} chars")

        # Patch 1: BP_FCST INSERT (L264~L290) — column list + SELECT 절 PG/BIZ 추가
        bpfcst_old = """\tINSERT INTO GT_DMF0043_PLAN_REPORT_C
\tSELECT DIVISION_ID
\t     , VERSION_NO
\t     , PROJECT_CODE
\t     , SCM_SITE_ID
\t     , ITEM_ID
\t     , YYYYMMDD
\t     , QTY
\t FROM (
\t\t   SELECT DIVISION_ID
\t\t     , VERSION_NO
\t\t     , PROJECT_CODE
\t\t     , SCM_SITE_ID
\t\t     , ITEM_ID
\t\t     , YYYYMM AS YYYYMMDD
\t\t     , QTY
\t\t  FROM DM_PLN_BP_FCST_REPORT_C"""
        bpfcst_new = f"""\tINSERT INTO {NEW_GTT}
\tSELECT DIVISION_ID
\t     , VERSION_NO
\t     , PROJECT_CODE
\t     , SCM_SITE_ID
\t     , ITEM_ID
\t     , YYYYMMDD
\t     , QTY
\t     , PRODUCT_GROUP
\t     , '' AS FORECAST_INFO_BIZ_TYPE
\t FROM (
\t\t   SELECT DIVISION_ID
\t\t     , VERSION_NO
\t\t     , PROJECT_CODE
\t\t     , SCM_SITE_ID
\t\t     , ITEM_ID
\t\t     , YYYYMM AS YYYYMMDD
\t\t     , QTY
\t\t     , PRODUCT_GROUP
\t\t  FROM DM_PLN_BP_FCST_REPORT_C"""
        if bpfcst_old in src:
            src = src.replace(bpfcst_old, bpfcst_new)
            log.append("  [PATCH 1 BP_FCST INSERT] OK (PG 추가, V2 reference)")
        else:
            log.append("  [WARN BP_FCST INSERT 패턴 미매칭]")

        # Patch 2: SALES_PLAN INSERT — 동일 패턴
        salesplan_old = """\tINSERT INTO GT_DMF0043_PLAN_REPORT_C
\tSELECT DIVISION_ID
\t     , VERSION_NO
\t     , PROJECT_CODE
\t     , SCM_SITE_ID
\t     , ITEM_ID
\t     , YYYYMMDD
\t     , QTY
\t FROM ( SELECT DIVISION_ID
\t\t     , VERSION_NO
\t\t     , PROJECT_CODE
\t\t     , SCM_SITE_ID
\t\t     , ITEM_ID
\t\t     , YYYYMMDD
\t\t     , QTY
\t\t  FROM DM_PLN_SALES_PLAN_REPORT_C"""
        salesplan_new = f"""\tINSERT INTO {NEW_GTT}
\tSELECT DIVISION_ID
\t     , VERSION_NO
\t     , PROJECT_CODE
\t     , SCM_SITE_ID
\t     , ITEM_ID
\t     , YYYYMMDD
\t     , QTY
\t     , PRODUCT_GROUP
\t     , FORECAST_INFO_BIZ_TYPE
\t FROM ( SELECT DIVISION_ID
\t\t     , VERSION_NO
\t\t     , PROJECT_CODE
\t\t     , SCM_SITE_ID
\t\t     , ITEM_ID
\t\t     , YYYYMMDD
\t\t     , QTY
\t\t     , PRODUCT_GROUP
\t\t     , FORECAST_INFO_BIZ_TYPE
\t\t  FROM DM_PLN_SALES_PLAN_REPORT_C"""
        if salesplan_old in src:
            src = src.replace(salesplan_old, salesplan_new)
            log.append("  [PATCH 2 SALES_PLAN INSERT] OK (PG/BIZ 추가, V2 reference)")
        else:
            log.append("  [WARN SALES_PLAN INSERT 패턴 미매칭]")

        # Patch 3: 모든 잔존 GT_DMF0043_PLAN_REPORT_C reference → V2
        before_cnt = src.count(OLD_GTT)
        src = src.replace(OLD_GTT, NEW_GTT)
        after_cnt = src.count(OLD_GTT)
        log.append(f"  [PATCH 3 GTT reference] {OLD_GTT} → V2: changed {before_cnt - after_cnt}, 잔존 {after_cnt}")

        # Patch 4: L334 + L559 — 'N' AS PRODUCT_GROUP → NVL(A.PRODUCT_GROUP, 'N')
        pg_old = "             , 'N' AS PRODUCT_GROUP --[Round3 patch] REPORT_GROUP3 제거로 빈값"
        pg_new = "             , NVL(A.PRODUCT_GROUP, 'N') AS PRODUCT_GROUP --[옵션B] V2 GTT 의 PG 사용"
        cnt_pg = src.count(pg_old)
        src = src.replace(pg_old, pg_new)
        log.append(f"  [PATCH 4 PG NVL] {cnt_pg} 곳")

        # CREATE OR REPLACE
        try:
            cur.execute("CREATE OR REPLACE " + src)
            conn.commit()
            log.append("  [CREATE OR REPLACE] OK")
        except oracledb.DatabaseError as e:
            log.append(f"  [ERR] {str(e)[:200]}")
            cur.execute("SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME=:n ORDER BY SEQUENCE", n=SP)
            for ln, pos, text in cur.fetchall()[:10]:
                log.append(f"    L{ln}:{pos} {text}")
            return 5

        cur.execute("SELECT STATUS FROM USER_OBJECTS WHERE OBJECT_NAME=:n AND OBJECT_TYPE='PROCEDURE'", n=SP)
        status = cur.fetchone()[0]
        log.append(f"  [STATUS] {status}")
        if status != 'VALID':
            return 6

        # === Step 5: Sanity 검증 =============================================
        for vs, yyyy, vno in [('9','2025','R_S_20251126_V002_C'), ('9','2025','R_B_20260223_V001'), ('12','2024','R_S_20260128_V002_C')]:
            rc_m = cur.var(oracledb.CURSOR); rc_s = cur.var(oracledb.CURSOR); rc_c = cur.var(oracledb.CURSOR)
            try:
                cur.callproc(SP, ['40', vs, vno, '', 'ALL', 'ALL', 'N', 'N', 'minyonglee1', rc_m, rc_s, rc_c])
                mrows = rc_m.getvalue().fetchall()
                if mrows:
                    cs = [d[0] for d in rc_m.getvalue().description]
                    r0 = dict(zip(cs, mrows[0]))
                    nz = sum(1 for v in r0.values() if isinstance(v,(int,float)) and v != 0)
                    log.append(f"  [SANITY] verSeq={vs} VER={vno:<26} rows={len(mrows)} non_zero={nz}")
                    if nz > 0:
                        sample = {k: v for k, v in r0.items() if isinstance(v,(int,float)) and v != 0}
                        log.append(f"    sample: {dict(list(sample.items())[:3])}")
            except Exception as e:
                log.append(f"  [SANITY ERR] verSeq={vs}: {str(e)[:120]}")

        log.append("  [DONE]")
        print("[OK] 옵션 B apply 완료")
    finally:
        (LOG_DIR / f"{ts}_OPTION_B.log").write_text("\n".join(log), encoding="utf-8")
        conn.close()
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
