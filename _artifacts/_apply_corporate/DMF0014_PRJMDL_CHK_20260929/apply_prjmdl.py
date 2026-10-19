"""PKG_DMF0014.P_DMF0014_CUST_FCST_EXCEL_UPLOAD — Project/Model 존재 검증 보정 [E20260929-DMF0014PRJMDL]

사용자 지시 (2026-09-29) :
  "DMF0014 EXCEL UPLOAD 시 PROJECT, MODEL 명이 존재하지 않아도 VALIDATION 에 조회되지 않고 정상 처리됩니다."
  → 원인 보고(재현 S1~S6) 후 "1,2 모두 적용해주세요."

  원인 ① Customer Project/Model 이 고객모델 마스터에 없어도, 같은 행 [Project]/[Model] 열이
         SCM_MST_SITE_ITEM 에 있으면 '품목 경로 구제'로 통과 (S1·S2)
  원인 ② [Project]/[Model] 열 자체 검증 부재 — AS-IS 'Invalid Project.'/'Invalid Model.' 블록이 /* */ 사문 (S3·S4)

변경 (전부 P_DMF0014_CUST_FCST_EXCEL_UPLOAD 내부, Division != '40' 분기) :
  ① Invalid Customer Project : SCM_MST_SITE_ITEM 구제 NOT EXISTS 제거 → 고객모델 마스터(Div, Site, Customer Project) 단독 판정
  ② Invalid Customer Model   : NOT EXISTS (CM 정확일치 UNION SITE_ITEM) → CM 정확일치 단독 판정
  ③ 신설 Invalid Project     : [Project] 열이 (Div, Site) SCM_MST_SITE_ITEM.PROJECT_CODE(VALID_YN='Y') 에 없음 (빈칸 포함)
  ④ 신설 Invalid Model       : [Project] 통과 행 중 (Div, Site, [Project], [Model]) SITE_ITEM 조합 없음 (빈칸 포함)
     · 기준 = SCM_MST_SITE_ITEM : 저장 시 DM_PLN_CUSTOMER_PSI.PROJECT_CODE/ITEM_ID 로 적재되고
       조회(P_DMF0014_GET_CUST_FCST_UPLOAD_DATA) 시 SITE_ITEM 과 조인해 EDIT_FLAG(DEPT) 를 정한다.
     · AS-IS 사문 블록(CUSTOMER_MODEL.PROJECT_CODE/ITEM_ID 매핑 일치)은 채택하지 않음 — 사문 그대로 보존.
  ⑤ 정책 주석(E20260923-DMF0014VALMSG 'SITE_ITEM 구제' 서술) 동기화

범위 : _SM 프로시저 무변경(미배선). Division 40 분기 무변경.
usage: python apply_prjmdl.py backup | apply | restore
"""
import datetime, pathlib, re, sys

HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parents[1] / "_diagnostics"))
import ora, oracledb  # noqa: E402

NAME, TYP = "PKG_DMF0014", "PACKAGE BODY"
ASIS = HERE / "00_BACKUP_ASIS" / "PKG_DMF0014_BODY.PRE_PRJMDL.sql"
TOBE = HERE / "01_APPLY" / "PKG_DMF0014_BODY.PRJMDL.sql"
TAG = "E20260929-DMF0014PRJMDL"
PROC_BEG = "PROCEDURE P_DMF0014_CUST_FCST_EXCEL_UPLOAD\n"
PROC_END = "END P_DMF0014_CUST_FCST_EXCEL_UPLOAD;"

# ① Customer Project — SITE_ITEM 구제 줄 제거
PRJ_CM_LINE = ("                AND    NOT EXISTS (SELECT 1 FROM DM_MST_CUSTOMER_MODEL GC, SCM_MST_DIVISION GD WHERE GC.DIVISION_ID = GD.DIVISION_ID AND GC.VALID_YN = 'Y' AND (GD.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1 OR GD.DIVISION_NAME = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1) AND GC.SCM_SITE_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2 AND GC.CUSTOMER_PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4)\n")
PRJ_SI_LINE = ("                AND    NOT EXISTS (SELECT 1 FROM SCM_MST_SITE_ITEM GI, SCM_MST_DIVISION GD WHERE GI.DIVISION_ID = GD.DIVISION_ID AND GI.VALID_YN = 'Y' AND (GD.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1 OR GD.DIVISION_NAME = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1) AND GI.SCM_SITE_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2 AND GI.PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE12 AND GI.ITEM_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE13);\n")
PRJ_NEW = (PRJ_CM_LINE.rstrip("\n") + ";  /*[" + TAG + "] [Project]/[Model] 품목 경로(SITE_ITEM) 구제 제거 — 고객모델 마스터 단독 판정*/\n")

# ② Customer Model — UNION SITE_ITEM 구제 제거
MDL_OLD = ("                        AND    CM.VALID_YN = 'Y'\n"
           "                        UNION\n"
           "                        SELECT 1\n"
           "                        FROM   SCM_MST_SITE_ITEM SI, SCM_MST_DIVISION D3\n"
           "                        WHERE  SI.DIVISION_ID = D3.DIVISION_ID\n"
           "                        AND    SI.SCM_SITE_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2\n"
           "                        AND    SI.PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE12  /*[E20260915-DMF0014MSTCHK] AS-IS L453 = Project 열(구 ATTRIBUTE4)*/\n"
           "                        AND    SI.ITEM_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE13       /*[E20260915-DMF0014MSTCHK] AS-IS L454 = Model 열(구 ATTRIBUTE5)*/\n"
           "                        AND    (D3.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1 OR D3.DIVISION_NAME = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1)\n"
           "                        AND    SI.VALID_YN = 'Y');\n")
MDL_NEW = ("                        AND    CM.VALID_YN = 'Y');  /*[" + TAG + "] UNION SCM_MST_SITE_ITEM([Project]/[Model]) 구제 제거 — 고객모델 마스터 단독 판정.\n"
           "                                                     [Project]/[Model] 열은 아래 'Invalid Project'/'Invalid Model' 이 별도 검증*/\n")

# ⑤ 정책 주석
CMT_OLD = ("                   'Invalid Customer Model' 로 뭉뚱그렸다. 판정 = (Division, Sales Site, Customer Project) 가 고객모델 마스터에 없고\n"
           "                   [Project]/[Model] 품목 경로(SITE_ITEM)로도 구제되지 않는 행. 반려 집합은 종전과 동일 — 메시지만 분리. */\n")
CMT_NEW = ("                   'Invalid Customer Model' 로 뭉뚱그렸다. 판정 = (Division, Sales Site, Customer Project) 가 고객모델 마스터에 없는 행.\n"
           "                   [" + TAG + "] 종전의 [Project]/[Model] 품목 경로(SITE_ITEM) 구제는 제거했다 — 존재하지 않는\n"
           "                   Customer Project/Model 이 통과하던 결함(사용자 지적 2026-09-29). */\n")

# ③④ 신설 블록 — 'Model 품목 마스터(ITEM_SN)' 검증 직전에 삽입
INS_ANCHOR = "            /* [E20260915-DMF0014MSTCHK] ② Model 품목 마스터"
_ROW = ("                WHERE  PROGRAM_ID = V_PROGRAM_ID\n"
        "                AND    SHEET_NAME = V_SHEET_NAME\n"
        "                AND    CREATED_BY = P_CREATED_BY\n"
        "                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE\n"
        "                AND    UPLOAD_STATUS_CODE IN ('UPLOAD','ERROR')\n"
        "                AND    EXISTS (SELECT 1 FROM SCM_MST_SITE GS, SCM_MST_DIVISION GD WHERE GS.DIVISION_ID = GD.DIVISION_ID AND GS.VALID_YN = 'Y' AND GS.SCM_SITE_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2 AND (GD.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1 OR GD.DIVISION_NAME = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1))  /*[" + TAG + "] 가드: Division/Sales Site 오류 행 제외*/\n")
_SI_PRJ = "SELECT 1 FROM SCM_MST_SITE_ITEM GI, SCM_MST_DIVISION GD WHERE GI.DIVISION_ID = GD.DIVISION_ID AND GI.VALID_YN = 'Y' AND (GD.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1 OR GD.DIVISION_NAME = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1) AND GI.SCM_SITE_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2 AND GI.PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE12"


def _msg(rule, h, col):
    one = f"'{rule} ['||{h}||': '||NVL({col},'(empty)')||']'"
    return f"SUBSTR(CASE WHEN MESSAGE_TEXT IS NULL THEN {one} ELSE MESSAGE_TEXT || ' / ' || {one} END, 1, 4000)"


def _log(typ, text):
    return ("                v_err_cnt := SQL%ROWCOUNT;\n"
            "                IF v_err_cnt > 0 THEN\n"
            f"                    V_LOG_TYPE    := '{typ}';\n"
            f"                    V_LOG_MESSAGE := '########## ERROR {text}. ##########';\n"
            "                    V_DESCRIPTION := 'rows=' || TO_CHAR(v_err_cnt);\n"
            "                    D_EVENT_DATE  := SYSTIMESTAMP;\n"
            "                    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);\n"
            "                    COMMIT;   -- ERROR 상태 확정 (전 검증 계속 수행 — E20260911-DMF0014MULTI)\n"
            "                END IF;\n")


NEW_BLOCK = (
    "            /* [" + TAG + "] [Project]/[Model] 열 존재 검증 (사용자 지시 2026-09-29).\n"
    "               저장 시 DM_PLN_CUSTOMER_PSI.PROJECT_CODE/ITEM_ID 로 그대로 적재되고, 조회 시 SCM_MST_SITE_ITEM 과\n"
    "               조인해 EDIT_FLAG(DEPT) 를 정하므로 (Division, Sales Site) 의 SCM_MST_SITE_ITEM(VALID_YN='Y') 에 있어야 한다.\n"
    "               빈칸도 오류. 아래 사문 블록(AS-IS 'Invalid Project.'/'Invalid Model.', CUSTOMER_MODEL 매핑 일치 기준)은 채택하지 않음. */\n"
    "            IF V_DIVISION != '40' THEN\n"
    "                UPDATE SCM_ADM_EXCEL_UPLOAD\n"
    "                SET    UPLOAD_STATUS_CODE = 'ERROR', MESSAGE_TEXT = " + _msg("Invalid Project", "v_h12", "ATTRIBUTE12") + "\n"
    + _ROW +
    "                AND    NOT EXISTS (" + _SI_PRJ + ");\n"
    + _log("103", "Invalid Project") +
    "\n"
    "                UPDATE SCM_ADM_EXCEL_UPLOAD\n"
    "                SET    UPLOAD_STATUS_CODE = 'ERROR', MESSAGE_TEXT = " + _msg("Invalid Model", "v_h13", "ATTRIBUTE13") + "\n"
    + _ROW +
    "                AND    EXISTS (" + _SI_PRJ + ")  /*[" + TAG + "] 가드: [Project] 통과 행만 — Project 오류는 위 'Invalid Project' 가 담당*/\n"
    "                AND    NOT EXISTS (" + _SI_PRJ + " AND GI.ITEM_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE13);\n"
    + _log("104", "Invalid Model ([Project]/[Model] SITE_ITEM)") +
    "            END IF;\n\n"
)


def fetch(cur):
    # FRESH-GATE: 항상 DB 에서 새로 읽은 원문 기준
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE=:t ORDER BY LINE", n=NAME, t=TYP)
    return "".join(r[0] for r in cur.fetchall())


def ddl(text):
    head, rest = text.split("\n", 1)
    head = re.sub(r'(?i)^\s*PACKAGE\s+BODY\s+"?\w+"?', f'CREATE OR REPLACE PACKAGE BODY SCM_MGR."{NAME}"', head, count=1)
    return head + "\n" + rest


def body_of(f):
    t = f.read_text(encoding="utf-8")
    return re.sub(r"\n/\s*$", "", t[t.index("CREATE OR REPLACE"):].rstrip())


def patch(src):
    b = src.index(PROC_BEG); e = src.index(PROC_END, b)
    seg = src[b:e]
    for name, old, cnt in (("PRJ", PRJ_CM_LINE + PRJ_SI_LINE, 1), ("MDL", MDL_OLD, 1), ("CMT", CMT_OLD, 1), ("INS", INS_ANCHOR, 1)):
        assert seg.count(old) == cnt, f"{name} 앵커 {seg.count(old)}회 (기대 {cnt})"
    seg = seg.replace(PRJ_CM_LINE + PRJ_SI_LINE, PRJ_NEW)
    seg = seg.replace(MDL_OLD, MDL_NEW)
    seg = seg.replace(CMT_OLD, CMT_NEW)
    seg = seg.replace(INS_ANCHOR, NEW_BLOCK + INS_ANCHOR)
    out = src[:b] + seg + src[e:]
    # 결과 가드
    nb = out.index(PROC_BEG); ne = out.index(PROC_END, nb); ns = out[nb:ne]
    assert "UNION\n                        SELECT 1\n                        FROM   SCM_MST_SITE_ITEM SI" not in ns, "Customer Model 구제 잔존"
    assert ns.count("'Invalid Project ['") == 2 and ns.count("'Invalid Model ['") == 4, "신설 메시지 수 이상"
    # 블록 주석 중첩 가드 (PLS-00103 실사고 2026-09-24)
    depth = 0; i = 0
    while i < len(NEW_BLOCK) - 1:
        two = NEW_BLOCK[i:i + 2]
        if two == "/*": depth += 1; assert depth == 1, "중첩 블록 주석"; i += 2; continue
        if two == "*/": depth -= 1; i += 2; continue
        i += 1
    assert depth == 0
    assert src[:b] == out[:b] and src[e:] == out[len(out) - len(src[e:]):], "대상 프로시저 밖 변경"
    return out


def main():
    mode = sys.argv[1]
    u, p, d = ora.conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d); cur = con.cursor()
    cur.execute("SELECT SYS_CONTEXT('USERENV','CON_NAME') FROM DUAL"); assert cur.fetchone()[0].upper() == "ZIOUI1", "대상 DB 가 ZIOUI1 아님"
    if mode == "backup":
        src = fetch(cur)
        assert TAG not in src, "이미 반영"
        patched = patch(src)
        cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE=:t", n=NAME, t=TYP)
        stamp = (f"-- SOURCE-FRESH: SCM_MGR.{NAME} {TYP} LAST_DDL={cur.fetchone()[0]} "
                 f"FETCHED={datetime.datetime.now():%Y-%m-%d %H:%M} DB=ZIOUI1\n"
                 f"-- [{TAG}] Customer Project/Model SITE_ITEM 구제 제거 + [Project]/[Model] 열 SITE_ITEM 존재 검증 신설\n"
                 "SET DEFINE OFF\nSET SQLBLANKLINES ON\n")
        ASIS.parent.mkdir(parents=True, exist_ok=True); TOBE.parent.mkdir(parents=True, exist_ok=True)
        ASIS.write_text(stamp + ddl(src).rstrip() + "\n/\n", encoding="utf-8", newline="\n")
        TOBE.write_text(stamp + ddl(patched).rstrip() + "\n/\n", encoding="utf-8", newline="\n")
        print("backup ok — 변경 4곳 (PRJ 구제제거 / MDL 구제제거 / 주석 / 신설블록 2검증)")
    elif mode == "apply":
        # FRESH-GATE: 적용 직전 DB 원문 == 백업본
        assert ddl(fetch(cur)).rstrip() == body_of(ASIS), "FRESH-GATE 실패: 백업 이후 DB 원문 변경 — 중단"
        cur.execute(body_of(TOBE))
        cur.execute("SELECT STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE=:t", n=NAME, t=TYP)
        print("status", cur.fetchone())
        cur.execute("SELECT LINE, POSITION, TEXT FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE=:t ORDER BY SEQUENCE", n=NAME, t=TYP)
        errs = cur.fetchall(); print("errors", len(errs))
        for x in errs[:10]: print("  ", x)
        print("applied == TOBE", ddl(fetch(cur)).rstrip() == body_of(TOBE))
    elif mode == "restore":
        cur.execute(body_of(ASIS))
        cur.execute("SELECT STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE=:t", n=NAME, t=TYP); print("restored", cur.fetchone())


if __name__ == "__main__":
    main()
