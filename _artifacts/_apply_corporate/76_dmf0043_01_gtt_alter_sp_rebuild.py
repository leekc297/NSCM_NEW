#!/usr/bin/env python3
"""
DMF0043_GET_CONTRIBUTION_SALES_LIST — Phase B+C+D1 본질 수정

문제:
  GT_DMF0043_SALES_LIST_C.PRODUCT_GROUP = 'N' (전 row) + DM_BIZ_TYPE=NULL
  → RATIO_DTL JOIN 시 PG/BIZ_TYPE 매칭 0 → main rows non_zero=0 (사용자 보고 "데이터 안 나옴")

Root cause:
  - SITE_ITEM.REPORT_GROUP3 컬럼 dropped (사내 schema) → SP 가 'N' AS PG 하드코딩
  - GT_DMF0043_PLAN_REPORT_C DDL 에 PG/BIZ_TYPE 컬럼 없음 → INSERT 시 source 의 PG 손실
  - RATIO_DTL 의 PG = '원통형/파우치형/...' (실값) — GT 의 'N' 과 매칭 0

Fix (사용자 명시 옵션 C — Phase B + C + D1):
  Step 1) GTT DDL ALTER: GT_DMF0043_PLAN_REPORT_C 에 PRODUCT_GROUP + FORECAST_INFO_BIZ_TYPE 컬럼 추가
  Step 2) SP body L264~L317 INSERT — SELECT 절에 PG/BIZ_TYPE source 추가 (BP_FCST/SALES_PLAN 둘 다)
  Step 3) SP body L334 'N' AS PRODUCT_GROUP → NVL(A.PRODUCT_GROUP, 'N')
  Step 4) SP body L559 compatibility 동일 변경
  Step 5) Sanity 검증 — non_zero cell > 0 확인
"""
import re, datetime
from pathlib import Path
import oracledb

CONN = dict(user="SCM_MGR", password="!SCMroqkf2026", dsn="121.162.245.167:2521/OCGSCMD_P01")
SP = "DMF0043_GET_CONTRIBUTION_SALES_LIST"
BACKUP_DIR = Path(__file__).parent.parent / "_diagnostics"
LOG_DIR = Path(__file__).parent / "_logs"
LOG_DIR.mkdir(parents=True, exist_ok=True)

def main():
    ts = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    log = [f"=== Phase B+C+D1 본질 수정 ({ts}) ==="]
    conn = oracledb.connect(**CONN)
    cur = conn.cursor()
    cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 1800")
    try:
        # === Step 1: GTT DDL ALTER (PG + BIZ_TYPE 컬럼 추가) =================
        # 멱등 check
        cur.execute("SELECT COLUMN_NAME FROM USER_TAB_COLUMNS WHERE TABLE_NAME='GT_DMF0043_PLAN_REPORT_C'")
        existing_cols = [r[0] for r in cur.fetchall()]
        log.append(f"  [GTT cols before] {existing_cols}")
        if 'PRODUCT_GROUP' not in existing_cols:
            cur.execute("ALTER TABLE SCM_MGR.GT_DMF0043_PLAN_REPORT_C ADD (PRODUCT_GROUP VARCHAR2(60))")
            log.append("  [ALTER] PRODUCT_GROUP 추가")
        if 'FORECAST_INFO_BIZ_TYPE' not in existing_cols:
            cur.execute("ALTER TABLE SCM_MGR.GT_DMF0043_PLAN_REPORT_C ADD (FORECAST_INFO_BIZ_TYPE VARCHAR2(60))")
            log.append("  [ALTER] FORECAST_INFO_BIZ_TYPE 추가")
        conn.commit()

        # === Step 2~4: SP body BACKUP + patch ============================
        cur.execute("SELECT TEXT FROM USER_SOURCE WHERE NAME=:n AND TYPE='PROCEDURE' ORDER BY LINE", n=SP)
        src = "".join((r[0] or "") for r in cur.fetchall())
        (BACKUP_DIR / f"{SP}_phaseBCD1_before_{ts}.sql").write_text("CREATE OR REPLACE " + src, encoding="utf-8")
        log.append(f"  [BACKUP] {len(src)} chars")

        # Patch 1: BP_FCST INSERT (L264~L290) — PG/BIZ 컬럼 추가
        # 기존: INSERT INTO GT_DMF0043_PLAN_REPORT_C SELECT DIVISION_ID, VERSION_NO, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, YYYYMMDD, QTY
        # 추가: PRODUCT_GROUP, '' AS FORECAST_INFO_BIZ_TYPE (BP_FCST 에 BIZ 없음)
        bpfcst_outer_old = """\tINSERT INTO GT_DMF0043_PLAN_REPORT_C
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
        bpfcst_outer_new = """\tINSERT INTO GT_DMF0043_PLAN_REPORT_C
\tSELECT DIVISION_ID
\t     , VERSION_NO
\t     , PROJECT_CODE
\t     , SCM_SITE_ID
\t     , ITEM_ID
\t     , YYYYMMDD
\t     , QTY
\t     , PRODUCT_GROUP
\t     , FORECAST_INFO_BIZ_TYPE
\t FROM (
\t\t   SELECT DIVISION_ID
\t\t     , VERSION_NO
\t\t     , PROJECT_CODE
\t\t     , SCM_SITE_ID
\t\t     , ITEM_ID
\t\t     , YYYYMM AS YYYYMMDD
\t\t     , QTY
\t\t     , PRODUCT_GROUP
\t\t     , '' AS FORECAST_INFO_BIZ_TYPE
\t\t  FROM DM_PLN_BP_FCST_REPORT_C"""
        if bpfcst_outer_old in src:
            src = src.replace(bpfcst_outer_old, bpfcst_outer_new)
            log.append("  [PATCH 1] BP_FCST INSERT — PG/BIZ 컬럼 추가 OK")
        else:
            log.append("  [WARN] BP_FCST INSERT 패턴 미매칭")

        # Patch 2: SALES_PLAN INSERT — 동일 추가
        salesplan_outer_old = """\tINSERT INTO GT_DMF0043_PLAN_REPORT_C
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
        salesplan_outer_new = """\tINSERT INTO GT_DMF0043_PLAN_REPORT_C
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
        if salesplan_outer_old in src:
            src = src.replace(salesplan_outer_old, salesplan_outer_new)
            log.append("  [PATCH 2] SALES_PLAN INSERT — PG/BIZ 컬럼 추가 OK")
        else:
            log.append("  [WARN] SALES_PLAN INSERT 패턴 미매칭")

        # Patch 3+4: L334, L559 의 'N' AS PRODUCT_GROUP → NVL(A.PRODUCT_GROUP, 'N')
        # 동시에 NVL(C.FORECAST_INFO_BIZ_TYPE, '') → NVL(C.FORECAST_INFO_BIZ_TYPE, A.FORECAST_INFO_BIZ_TYPE) 도 가능하나 일단 PG 만
        pg_n_old = "             , 'N' AS PRODUCT_GROUP --[Round3 patch] REPORT_GROUP3 제거로 빈값"
        pg_n_new = "             , NVL(A.PRODUCT_GROUP, 'N') AS PRODUCT_GROUP --[Phase B] GT_PLAN.PG 사용 (REPORT_GROUP3 dropped 대체)"
        cnt = src.count(pg_n_old)
        if cnt > 0:
            src = src.replace(pg_n_old, pg_n_new)
            log.append(f"  [PATCH 3-4] 'N' AS PRODUCT_GROUP → NVL(A.PRODUCT_GROUP) {cnt} 곳")
        else:
            log.append("  [WARN] 'N' AS PRODUCT_GROUP 패턴 미매칭")

        # CREATE OR REPLACE
        try:
            cur.execute("CREATE OR REPLACE " + src)
            conn.commit()
            log.append("  [CREATE OR REPLACE] OK")
        except oracledb.DatabaseError as e:
            log.append(f"  [ERR] {e}")
            cur.execute("SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME=:n ORDER BY SEQUENCE", n=SP)
            for ln, pos, text in cur.fetchall():
                log.append(f"    L{ln}:{pos} {text}")
            return 5

        cur.execute("SELECT STATUS FROM USER_OBJECTS WHERE OBJECT_NAME=:n AND OBJECT_TYPE='PROCEDURE'", n=SP)
        status = cur.fetchone()[0]
        log.append(f"  [STATUS] {status}")

        # === Step 5: Sanity 검증 ============================================
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
                        log.append(f"    sample non_zero: {dict(list(sample.items())[:3])}")
            except Exception as e:
                log.append(f"  [ERR] verSeq={vs}: {str(e)[:100]}")

        log.append("  [DONE]")
        print("[OK] apply 완료")
    finally:
        (LOG_DIR / f"{ts}_PHASE_BCD1.log").write_text("\n".join(log), encoding="utf-8")
        conn.close()
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
