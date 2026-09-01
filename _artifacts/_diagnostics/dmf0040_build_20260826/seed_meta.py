# -*- coding: utf-8 -*-
"""DMF0040 메타 시딩 — SHEET_MEASURE 49(DMF0035 축 복제·AS-IS 사전 대조 완료) + 배선 5축.
멱등 MERGE (논리키 실측: SHEET_MEASURE=(PROGRAM_ID,SHEET_NAME,COLUMN_NAME) 유일 확인).
이관 SQL 동시 산출 → _deploy_packages/DMF0040_CLOUD_20260826/A_DB/"""
import io, sys, pathlib
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace", line_buffering=True)
import oracledb
from ora import conn_info

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
OUT = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_deploy_packages\DMF0040_CLOUD_20260826\A_DB")
OUT.mkdir(parents=True, exist_ok=True)
sqls = {"01": [], "02": [], "03": []}

# ── 1) SHEET_MEASURE: DMF0035 49행 → DMF0040 복제 (전 컬럼) ──
MERGE_M = """MERGE INTO SCM_MGR.SCM_MST_SHEET_MEASURE T
USING (SELECT 'DMF0040' PROGRAM_ID, S.SHEET_NAME, S.COLUMN_NAME, S.COLUMN_LABEL_NAME, S.SORT_ORDER_NO,
              S.SMALL_CLASS_LABEL_NAME, S.LARGE_CLASS_LABEL_NAME, S.DEFAULT_FLAG, S.USER_SELECTABLE_FLAG,
              S.DIVISION_ID, S.VALID_YN, S.ATTRIBUTE1, S.ATTRIBUTE2, S.ATTRIBUTE3, S.ATTRIBUTE4, S.ATTRIBUTE5,
              S.ATTRIBUTE6, S.ATTRIBUTE7, S.ATTRIBUTE8, S.ATTRIBUTE9, S.ATTRIBUTE10, S.INPUT_TP_CD
       FROM SCM_MGR.SCM_MST_SHEET_MEASURE S
       WHERE S.PROGRAM_ID='DMF0035' AND S.SHEET_NAME='Mkt Fcst Waterfall') X
ON (T.PROGRAM_ID=X.PROGRAM_ID AND T.SHEET_NAME=X.SHEET_NAME AND T.COLUMN_NAME=X.COLUMN_NAME)
WHEN MATCHED THEN UPDATE SET
     T.COLUMN_LABEL_NAME=X.COLUMN_LABEL_NAME, T.SORT_ORDER_NO=X.SORT_ORDER_NO,
     T.SMALL_CLASS_LABEL_NAME=X.SMALL_CLASS_LABEL_NAME, T.LARGE_CLASS_LABEL_NAME=X.LARGE_CLASS_LABEL_NAME,
     T.DEFAULT_FLAG=X.DEFAULT_FLAG, T.USER_SELECTABLE_FLAG=X.USER_SELECTABLE_FLAG,
     T.DIVISION_ID=X.DIVISION_ID, T.VALID_YN=X.VALID_YN,
     T.ATTRIBUTE1=X.ATTRIBUTE1, T.ATTRIBUTE2=X.ATTRIBUTE2, T.ATTRIBUTE3=X.ATTRIBUTE3, T.ATTRIBUTE4=X.ATTRIBUTE4,
     T.ATTRIBUTE5=X.ATTRIBUTE5, T.ATTRIBUTE6=X.ATTRIBUTE6, T.ATTRIBUTE7=X.ATTRIBUTE7, T.ATTRIBUTE8=X.ATTRIBUTE8,
     T.ATTRIBUTE9=X.ATTRIBUTE9, T.ATTRIBUTE10=X.ATTRIBUTE10, T.INPUT_TP_CD=X.INPUT_TP_CD,
     T.LAST_UPDATED_BY='admin', T.LAST_UPDATE_DATE=SYSDATE
WHEN NOT MATCHED THEN INSERT
    (PROGRAM_ID, SHEET_NAME, COLUMN_NAME, COLUMN_LABEL_NAME, SORT_ORDER_NO, SMALL_CLASS_LABEL_NAME,
     LARGE_CLASS_LABEL_NAME, DEFAULT_FLAG, USER_SELECTABLE_FLAG, DIVISION_ID, VALID_YN,
     ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8,
     ATTRIBUTE9, ATTRIBUTE10, INPUT_TP_CD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
VALUES (X.PROGRAM_ID, X.SHEET_NAME, X.COLUMN_NAME, X.COLUMN_LABEL_NAME, X.SORT_ORDER_NO, X.SMALL_CLASS_LABEL_NAME,
     X.LARGE_CLASS_LABEL_NAME, X.DEFAULT_FLAG, X.USER_SELECTABLE_FLAG, X.DIVISION_ID, X.VALID_YN,
     X.ATTRIBUTE1, X.ATTRIBUTE2, X.ATTRIBUTE3, X.ATTRIBUTE4, X.ATTRIBUTE5, X.ATTRIBUTE6, X.ATTRIBUTE7, X.ATTRIBUTE8,
     X.ATTRIBUTE9, X.ATTRIBUTE10, X.INPUT_TP_CD, 'admin', SYSDATE, 'admin', SYSDATE)"""
cur.execute(MERGE_M)
print("SHEET_MEASURE MERGE:", cur.rowcount, "행 (기대 49)", flush=True)
assert cur.rowcount == 49
sqls["01"].append("-- [E20260826-DMF0040MEAS] SHEET_MEASURE 49행 — DMF0035 'Mkt Fcst Waterfall' 축 복제\n"
                  "-- 근거: AS-IS btnMeasure = TitleSet(PROGRAM_ID='DMF0035') 공유(.cs L1350) + PKG_DMF0040 BODY 는 PROGRAM_ID='DMF0040' 참조(L362)\n"
                  "--       → DMF0040 독립 축 시딩. 값 = TO-BE DMF0035(사전 03_sheet_measures.md AS-IS 대조 반영본) 그대로.\n"
                  "-- ⚠ 클라우드 실행 시 DMF0035 축이 선행 존재해야 함 (기이관 확인됨).\n" + MERGE_M + ";\nCOMMIT;")

# ── 2) API_M 3행 ──
APIS = [
    ("DMF0040_mktFcstComparison_SEARCH", "DMF0040 MKT FCST Comparison 메인 조회 (버전 최대 2 비교·Waterfall)", "PKG_DMF0040.P_DMF0040_GET_MKT_FCST_COMPARISON"),
    ("DMF0040_spreadTitle_SEARCH", "DMF0040 동적 시간축 컬럼 조회", "DMF0040_GET_SPREAD_TITLE"),
    ("DMF0040_version_SEARCH", "DMF0040 Waterfall 버전 목록 (SCM0002 축: MF — DMF0035 versionWf 동계약)", "PKG_SCM0002.P_SCM0002_GET_VERSIONBYWATERFALLPOPUP"),
]
MERGE_A = """MERGE INTO SCM_MGR.SCM_ADM_API_M T
USING (SELECT :1 API_ID, 'PROC_SELECT' API_TP_CD, :2 API_MSG_ID, :3 API_MSG_DESC, :4 API_URL, 'Y' USE_YN FROM DUAL) X
ON (T.API_ID=X.API_ID)
WHEN MATCHED THEN UPDATE SET T.API_URL=X.API_URL, T.API_MSG_DESC=X.API_MSG_DESC, T.USE_YN='Y',
     T.LAST_UPDATED_BY='admin', T.LAST_UPDATE_DATE=SYSDATE
WHEN NOT MATCHED THEN INSERT (API_ID, API_TP_CD, API_MSG_ID, API_MSG_DESC, API_URL, USE_YN,
     CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
VALUES (X.API_ID, X.API_TP_CD, X.API_MSG_ID, X.API_MSG_DESC, X.API_URL, 'Y', 'admin', SYSDATE, 'admin', SYSDATE)"""
for api_id, desc, url in APIS:
    cur.execute(MERGE_A, [api_id, "MSG_API_" + api_id, desc, url])
    lit = MERGE_A.replace(":1", "'%s'" % api_id).replace(":2", "'MSG_API_%s'" % api_id) \
                 .replace(":3", "'%s'" % desc.replace("'", "''")).replace(":4", "'%s'" % url)
    sqls["02"].append(lit + ";")
print("API_M 3행", flush=True)

# ── 3) PROC_M — 2본 (SCM0002 는 기등재 확인) ──
cur.execute("SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM='PKG_SCM0002.P_SCM0002_GET_VERSIONBYWATERFALLPOPUP'")
scm0002 = cur.fetchone()[0]
print("PKG_SCM0002 PROC_M 기등재:", scm0002, "행", flush=True)
assert scm0002 > 0, "PKG_SCM0002 PROC_M 미등재 — 별도 시딩 필요"

PROCS = {
    "PKG_DMF0040.P_DMF0040_GET_MKT_FCST_COMPARISON": [
        ("divisionId", "VARCHAR", "IN"), ("scmSiteId", "VARCHAR", "IN"), ("plantSiteId", "VARCHAR", "IN"),
        ("teamId", "VARCHAR", "IN"), ("customer", "VARCHAR", "IN"), ("bizType", "VARCHAR", "IN"),
        ("projectCode", "VARCHAR", "IN"), ("itemId", "VARCHAR", "IN"), ("fromYyyymmdd", "VARCHAR", "IN"),
        ("toYyyymmdd", "VARCHAR", "IN"), ("sesUserId", "VARCHAR", "IN"), ("versionNo", "VARCHAR", "IN"),
        ("itemType", "VARCHAR", "IN"), ("owner", "VARCHAR", "IN"), ("diffOnly", "VARCHAR", "IN"),
        ("bucket", "VARCHAR", "IN"), ("userId", "VARCHAR", "IN"), ("mnuId", "VARCHAR", "IN"),
        ("o_rc1", "CURSOR", "OUT"), ("O_RESULT_CURSOR", "PROC_RESULT", "OUT"),
    ],
    "DMF0040_GET_SPREAD_TITLE": [
        ("startYyyymmdd", "VARCHAR", "IN"), ("endYyyymmdd", "VARCHAR", "IN"), ("sesUserId", "VARCHAR", "IN"),
        ("divisionId", "VARCHAR", "IN"), ("bucket", "VARCHAR", "IN"),
        ("o_rc1", "CURSOR", "OUT"), ("O_RESULT_CURSOR", "PROC_RESULT", "OUT"),
    ],
}
# 이관 표준 = DELETE+INSERT (proc-meta-signature-match)
for proc, params in PROCS.items():
    cur.execute("DELETE FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM=:1", [proc])
    stmts = ["DELETE FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM='%s';" % proc]
    for i, (col, dt, tp) in enumerate(params, 1):
        cur.execute("""INSERT INTO SCM_MGR.SCM_ADM_PROC_M
            (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
            VALUES (:1, :2, :3, :4, :5, 'admin', SYSDATE, 'admin', SYSDATE)""", [proc, col, dt, tp, i])
        stmts.append("INSERT INTO SCM_MGR.SCM_ADM_PROC_M (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) "
                     "VALUES ('%s', '%s', '%s', '%s', %d, 'admin', SYSDATE, 'admin', SYSDATE);" % (proc, col, dt, tp, i))
    sqls["03"].append("\n".join(stmts))
    print("PROC_M %s: %d행" % (proc, len(params)), flush=True)

# ── 4) BTN 배선 3행 + 그룹 권한 (메뉴권한 실측 4그룹) ──
BTNS = [("mktFcstComparison", "SEARCH", "DMF0040_mktFcstComparison_SEARCH"),
        ("spreadTitle", "SEARCH", "DMF0040_spreadTitle_SEARCH"),
        ("version", "SEARCH", "DMF0040_version_SEARCH")]
MERGE_B = """MERGE INTO SCM_MGR.SCM_ADM_MNU_BTN_MPG_M T
USING (SELECT 'DMF0040' MNU_ID, :1 SHT_NM, :2 MNU_BTN_CD, :3 API_ID FROM DUAL) X
ON (T.MNU_ID=X.MNU_ID AND T.SHT_NM=X.SHT_NM AND T.MNU_BTN_CD=X.MNU_BTN_CD)
WHEN MATCHED THEN UPDATE SET T.API_ID=X.API_ID, T.USE_YN='Y', T.LAST_UPDATED_BY='admin', T.LAST_UPDATE_DATE=SYSDATE
WHEN NOT MATCHED THEN INSERT (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
VALUES (X.MNU_ID, X.SHT_NM, X.MNU_BTN_CD, X.API_ID, 'Y', 'admin', SYSDATE, 'admin', SYSDATE)"""
GROUPS = ["ADMIN", "DM ADMIN", "DM Viewer", "SCP Planner"]
MERGE_G = """MERGE INTO SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M T
USING (SELECT :1 USER_GR_ID, 'DMF0040' MNU_ID, :2 SHT_NM, :3 MNU_BTN_CD FROM DUAL) X
ON (T.USER_GR_ID=X.USER_GR_ID AND T.MNU_ID=X.MNU_ID AND T.SHT_NM=X.SHT_NM AND T.MNU_BTN_CD=X.MNU_BTN_CD)
WHEN MATCHED THEN UPDATE SET T.USE_YN='Y', T.LAST_UPDATED_BY='admin', T.LAST_UPDATE_DATE=SYSDATE
WHEN NOT MATCHED THEN INSERT (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
VALUES (X.USER_GR_ID, X.MNU_ID, X.SHT_NM, X.MNU_BTN_CD, 'Y', 'admin', SYSDATE, 'admin', SYSDATE)"""
for sh, btn, api in BTNS:
    cur.execute(MERGE_B, [sh, btn, api])
    sqls["03"].append(MERGE_B.replace(":1", "'%s'" % sh).replace(":2", "'%s'" % btn).replace(":3", "'%s'" % api) + ";")
    for g in GROUPS:
        cur.execute(MERGE_G, [g, sh, btn])
        sqls["03"].append(MERGE_G.replace(":1", "'%s'" % g).replace(":2", "'%s'" % sh).replace(":3", "'%s'" % btn) + ";")
print("BTN 3 + 그룹권한 %d행" % (len(BTNS) * len(GROUPS)), flush=True)
con.commit()
print("커밋 완료", flush=True)

# ── 검증 ──
cur.execute("SELECT COUNT(*) FROM SCM_MGR.SCM_MST_SHEET_MEASURE WHERE PROGRAM_ID='DMF0040'")
print("검증 SHEET_MEASURE DMF0040:", cur.fetchone()[0], "(기대 49)", flush=True)
cur.execute("SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM LIKE '%DMF0040%'")
print("검증 PROC_M:", cur.fetchone()[0], "(기대 27)", flush=True)
def btn_auth(uid):
    rc = con.cursor(); c = con.cursor()
    c.callproc("SCM_MGR.PKG_NSCM_UI_COM_AUTH.PR_GET_MNU_BTN_AUTH", [uid, "DMF0040", rc])
    return sorted({"%s:%s" % (r[1], r[2]) for r in rc.fetchall()})
print("검증 버튼 SP bindy122678(ADMIN):", btn_auth("bindy122678"), flush=True)
print("검증 버튼 SP DM_V_TEST(Viewer):", btn_auth("DM_V_TEST"), flush=True)
con.close()

# 이관 SQL 파일
(OUT / "01_SHEET_MEASURE.sql").write_text("\n\n".join(sqls["01"]) + "\n", encoding="utf-8")
(OUT / "02_API_M.sql").write_text("-- [E20260826-DMF0040API] API 3본 (PROC_SELECT)\n" + "\n\n".join(sqls["02"]) + "\nCOMMIT;\n", encoding="utf-8")
(OUT / "03_PROC_BTN_AUTH.sql").write_text("-- [E20260826-DMF0040WIRE] PROC_M(DELETE+INSERT 27) + BTN 3 + 그룹권한 12 (메뉴권한 실측 4그룹)\n"
                                          "-- ⚠ PKG_SCM0002 PROC_M 은 기등재(사내 실측) — 클라우드도 DMF0035 이관분으로 존재 가정, 90_VERIFY 로 확인\n"
                                          + "\n\n".join(sqls["03"]) + "\nCOMMIT;\n", encoding="utf-8")
print("이관 SQL 3본:", OUT, flush=True)
