"""DMF0014 Excel Form SP — 헤더 전용(데이터 0행) 반환으로 변경 (사용자 요청 2026-08-27)
   P_DMF0014_GET_EXCEL_FORM_DATA: 키 조합 실데이터 대신 식별 컬럼 NULL 헤더 캐리어 1행 +
   PERIOD_BUCKETS(조회구간 버킷 일자) + UPLOAD_VALID_WEEKS(division·구간 내 VALID_YN='Y' 버킷) 만 반환.
   시그니처·커서 컬럼명 불변(FE 계약 유지). preview-only 기본 / --apply 시 직접 컴파일."""
import sys, os, datetime, re
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import ora, oracledb
OUT = r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0014_EXCELFORM_HDRONLY_20260827"; os.makedirs(OUT, exist_ok=True)
u, p, d = ora.conn_info(); con = oracledb.connect(user=u, password=p, dsn=d); cur = con.cursor()
def src(t):
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0014' AND TYPE=:t ORDER BY LINE", t=t); return [r[0] for r in cur.fetchall()]
spec, body = src("PACKAGE"), src("PACKAGE BODY")
ts = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
open(os.path.join(OUT, f"BACKUP_PKG_DMF0014_{ts}.sql"), "w", encoding="utf-8").write("CREATE OR REPLACE " + "".join(spec) + "\n/\nCREATE OR REPLACE " + "".join(body) + "\n/\n")
full = "".join(body)
if "E20260827-EXCELFORM-HDRONLY" in full: print("already applied"); sys.exit(0)
L = body[:]
def ln(i): return " ".join(L[i - 1].split())
# 앵커 (2026-08-27 실측 라인)
assert ln(7103) == "PROCEDURE P_DMF0014_GET_EXCEL_FORM_DATA", ln(7103)
assert ln(7167).startswith("-- [E20260814-EXCELFORM-V7]"), ln(7167)
assert ln(7169) == "V_SQL_TEXT := '", ln(7169)
assert ln(7303) == "OPEN O_RC1 FOR V_SQL_TEXT;", ln(7303)
assert ln(7305) == "OPEN O_RESULT_CURSOR FOR", ln(7305)
new_block = """        --------------------------------------------------------------------------------------
        -- [E20260827-EXCELFORM-HDRONLY] Excel Form = 데이터 없이 **헤더만** (사용자 요청 2026-08-27).
        --   종전 V7(키 조합 실데이터 전량)은 백업에 보존. 커서 컬럼명·시그니처는 FE 계약대로 유지하되
        --   식별 컬럼은 전부 NULL 인 헤더 캐리어 1행만 반환한다:
        --     PERIOD_BUCKETS     = 조회구간(P_START~P_END)·버킷타입의 버킷 일자 전량 → FE 값 컬럼 생성
        --     UPLOAD_VALID_WEEKS = 그중 division 의 DM_MST_CUSTOMER_FCST VALID_YN='Y' 버킷 → 입력가능 표식
        --   FE(CustomerFcstTemplateModal)는 SCM_SITE_ID NULL 행을 헤더 캐리어로 판정해 데이터행 0건으로 내보낸다.
        --------------------------------------------------------------------------------------
        OPEN O_RC1 FOR
            SELECT CAST(NULL AS VARCHAR2(120))  AS DIVISION_ID
                 , CAST(NULL AS VARCHAR2(240))  AS SCM_SITE_ID
                 , CAST(NULL AS VARCHAR2(240))  AS PLANT_SITE_ID
                 , CAST(NULL AS VARCHAR2(200))  AS CUSTOMER_PROJECT_CODE
                 , CAST(NULL AS VARCHAR2(400))  AS CUSTOMER_MODEL
                 , CAST(NULL AS VARCHAR2(40))   AS INCOTERMS
                 , CAST(NULL AS VARCHAR2(40))   AS FCST_TYPE
                 , CAST(NULL AS VARCHAR2(40))   AS DOM_EXP
                 , CAST(NULL AS VARCHAR2(200))  AS MEASURE_GROUP
                 , CAST(NULL AS VARCHAR2(200))  AS MEASURE
                 , CAST(NULL AS VARCHAR2(40))   AS UPLOAD_UOM
                 , CAST(NULL AS VARCHAR2(200))  AS PROJECT_CODE
                 , CAST(NULL AS VARCHAR2(200))  AS ITEM_ID
                 , CAST(NULL AS VARCHAR2(200))  AS CUSTOMER_CODE
                 , (SELECT LISTAGG(V.SBV, ',') WITHIN GROUP (ORDER BY V.SBV)
                      FROM (SELECT DISTINCT MF.SUMMARY_BUCKET_VALUE AS SBV
                              FROM DM_MST_CUSTOMER_FCST MF
                             WHERE MF.VALID_YN = 'Y'
                               AND MF.UPLOAD_BUCKET_TYPE = P_BUCKET_TYPE
                               AND (P_DIVISION_ID IS NULL OR P_DIVISION_ID = 'ALL'
                                    OR INSTR(',' || P_DIVISION_ID || ',', ',' || MF.DIVISION_ID || ',') > 0)
                               AND MF.SUMMARY_BUCKET_VALUE BETWEEN P_START_YYYYMMDD AND P_END_YYYYMMDD) V
                   ) AS UPLOAD_VALID_WEEKS
                 , (SELECT LISTAGG(BK.SBV, ',') WITHIN GROUP (ORDER BY BK.SBV)
                      FROM (SELECT DISTINCT MB.SUMMARY_BUCKET_VALUE AS SBV
                              FROM DM_MST_CUSTOMER_FCST MB
                             WHERE MB.UPLOAD_BUCKET_TYPE = P_BUCKET_TYPE
                               AND MB.SUMMARY_BUCKET_VALUE BETWEEN P_START_YYYYMMDD AND P_END_YYYYMMDD) BK
                   ) AS PERIOD_BUCKETS
              FROM DUAL;

"""
# 7167(V7 주석) ~ 7303(OPEN O_RC1 FOR V_SQL_TEXT;) 교체 → 7304 빈줄 유지
L[7166:7303] = [new_block]
new_body = "".join(L)
assert new_body.count("E20260827-EXCELFORM-HDRONLY") == 1
assert "OPEN O_RC1 FOR V_SQL_TEXT" not in new_body[new_body.index("PROCEDURE P_DMF0014_GET_EXCEL_FORM_DATA"):new_body.index("END P_DMF0014_GET_EXCEL_FORM_DATA")]
prev = os.path.join(OUT, "PREVIEW_PKG_DMF0014_BODY.sql")
open(prev, "w", encoding="utf-8").write("CREATE OR REPLACE " + new_body + "\n/\n"); print("preview written:", prev)
if "--apply" not in sys.argv: print("preview-only (배포 = ora.py exec PREVIEW_PKG_DMF0014_BODY.sql)"); sys.exit(0)
