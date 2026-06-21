#!/usr/bin/env python3
"""
옵션 C — SP body LEFT JOIN 추가 (GTT 변경 X, ORA-14450 우회)

배경:
  apply 76 의 GTT ALTER 가 ORA-14450 (lock 37 session) + KILL SESSION 권한 없음.
  대안: GT_DMF0043_SALES_LIST_C INSERT SELECT 안에 원본 source (BP_FCST / SALES_PLAN) LEFT JOIN
        추가하여 PRODUCT_GROUP 가져옴 → 'N' 하드코딩 제거.

수정:
  Step 1) GT_DMF0043_SALES_LIST_C INSERT SELECT (L319~L487) 안에 LEFT JOIN 2 추가 (BP + SP)
  Step 2) L334 'N' AS PRODUCT_GROUP → NVL(COALESCE(BP.PRODUCT_GROUP, SP.PRODUCT_GROUP), 'N')
  Step 3) L559 compatibility 동일 변경
  Step 4) sanity 검증
"""
import datetime
from pathlib import Path
import oracledb

CONN = dict(user="SCM_MGR", password="!SCMroqkf2026", dsn="121.162.245.167:2521/OCGSCMD_P01")
SP = "DMF0043_GET_CONTRIBUTION_SALES_LIST"
BACKUP_DIR = Path(__file__).parent.parent / "_diagnostics"
LOG_DIR = Path(__file__).parent / "_logs"
LOG_DIR.mkdir(parents=True, exist_ok=True)

# L334 의 row context — FROM GT_DMF0043_PLAN_REPORT_C A LEFT JOIN SCM_MST_SITE_ITEM I (L338-L339)
# LEFT JOIN BP/SP 추가 위치 — TEAM JOIN 직후 (L363 부근, 6번째 LEFT JOIN 후)

PG_BIZ_JOIN_NEW = """\t\tLEFT JOIN DM_PLN_BP_FCST_REPORT_C BP
\t\t  ON BP.DIVISION_ID = A.DIVISION_ID
\t\t AND BP.VERSION_NO = A.VERSION_NO
\t\t AND BP.PROJECT_CODE = A.PROJECT_CODE
\t\t AND BP.SCM_SITE_ID = A.SCM_SITE_ID
\t\t AND BP.ITEM_ID = A.ITEM_ID
\t\t AND BP.YYYYMM = A.YYYYMMDD
\t\t AND BP.MEASURE = 'SalesAmt_USD'
\t\tLEFT JOIN DM_PLN_SALES_PLAN_REPORT_C SP
\t\t  ON SP.DIVISION_ID = A.DIVISION_ID
\t\t AND SP.VERSION_NO = A.VERSION_NO
\t\t AND SP.PROJECT_CODE = A.PROJECT_CODE
\t\t AND SP.SCM_SITE_ID = A.SCM_SITE_ID
\t\t AND SP.ITEM_ID = A.ITEM_ID
\t\t AND SP.YYYYMMDD = A.YYYYMMDD
\t\t AND SP.MEASURE = 'SalesAmt_USD'
"""

def main():
    ts = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    log = [f"=== 옵션 C: SP body LEFT JOIN PG ({ts}) ==="]
    conn = oracledb.connect(**CONN)
    cur = conn.cursor()
    cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 1800")
    try:
        cur.execute("SELECT TEXT FROM USER_SOURCE WHERE NAME=:n AND TYPE='PROCEDURE' ORDER BY LINE", n=SP)
        src = "".join((r[0] or "") for r in cur.fetchall())
        (BACKUP_DIR / f"{SP}_optionC_before_{ts}.sql").write_text("CREATE OR REPLACE " + src, encoding="utf-8")
        log.append(f"  [BACKUP] {len(src)} chars")

        # === Patch 1+2+3: GT_SALES_LIST_C INSERT 1번째 + compatibility 2번째 ===
        # 두 곳 모두: FROM GT_DMF0043_PLAN_REPORT_C A 다음의 LEFT JOIN SCM_MST_SITE_ITEM I... 직후에 BP/SP JOIN 추가
        # 검색 anchor: `LEFT JOIN DM_MST_ITEM_SINGLE_V C` 다음의 ON 절 (3 line) 직후
        # 가장 안정적 anchor 는 TEAM subquery 끝 부분
        anchor = "\t\t) TEAM ON A.SCM_SITE_ID = TEAM.SCM_SITE_ID --담당자\n\t\t      AND TEAM.DIVISION_ID = A.DIVISION_ID\n"
        cnt = src.count(anchor)
        log.append(f"  [ANCHOR] TEAM JOIN end pattern hits: {cnt} (expected 2 — main + compatibility)")
        if cnt == 0:
            # fallback — 다른 anchor 시도
            anchor = ") TEAM ON A.SCM_SITE_ID = TEAM.SCM_SITE_ID"
            cnt = src.count(anchor)
            log.append(f"  [FALLBACK ANCHOR] hits: {cnt}")

        # 두 안전한 패턴 검색
        if "I.OWNER = TEAM.USER_ID" in src:
            # 실제 anchor — TEAM ON 절의 마지막 line
            cur.execute("SELECT LINE, TEXT FROM USER_SOURCE WHERE NAME=:n AND TYPE='PROCEDURE' AND TEXT LIKE '%TEAM ON %' ORDER BY LINE", n=SP)
            for r in cur.fetchall():
                log.append(f"    L{r[0]:>3}: {(r[1] or '').rstrip()[:140]}")

        # Patch: PG 'N' → NVL(COALESCE(BP.PRODUCT_GROUP, SP.PRODUCT_GROUP), 'N')
        pg_n_old = "             , 'N' AS PRODUCT_GROUP --[Round3 patch] REPORT_GROUP3 제거로 빈값"
        pg_n_new = "             , NVL(COALESCE(BP.PRODUCT_GROUP, SP.PRODUCT_GROUP), 'N') AS PRODUCT_GROUP --[옵션C] BP/SP source LEFT JOIN 으로 가져옴"
        cnt_pg = src.count(pg_n_old)
        log.append(f"  [PATCH PG] 'N' AS PRODUCT_GROUP hits: {cnt_pg}")

        if cnt_pg == 0:
            log.append("  [FAIL] PG pattern not found")
            return 2

        # JOIN 추가 위치 — TEAM 서브쿼리 끝 검색
        # 대략 L382 부근 (1차) + L607 부근 (2차)
        # SP body 의 정확한 TEAM end anchor 확인 — 'AND TEAM.DIVISION_ID = A.DIVISION_ID' 다음의 ' WHERE 1=1' 또는 ' GROUP BY'
        team_end_anchor_1 = "AND TEAM.DIVISION_ID = A.DIVISION_ID"
        cnt_team = src.count(team_end_anchor_1)
        log.append(f"  [TEAM END ANCHOR] hits: {cnt_team}")

        # Patch: TEAM JOIN 끝 직후 BP/SP LEFT JOIN 추가 (모든 occurrences)
        new_team_end = team_end_anchor_1 + "\n" + PG_BIZ_JOIN_NEW
        patched = src.replace(team_end_anchor_1 + "\n", new_team_end, cnt_team)  # all occurrences

        # 그 다음 PG 'N' → NVL 변경
        patched = patched.replace(pg_n_old, pg_n_new)

        # CREATE OR REPLACE
        try:
            cur.execute("CREATE OR REPLACE " + patched)
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
        if status != 'VALID':
            return 6

        # Sanity 검증
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
                log.append(f"  [SANITY ERR] verSeq={vs}: {str(e)[:100]}")

        log.append("  [DONE]")
        print("[OK] 옵션 C apply 완료")
    finally:
        (LOG_DIR / f"{ts}_OPTION_C.log").write_text("\n".join(log), encoding="utf-8")
        conn.close()
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
