"""PKG_DMF0014.P_DMF0014_CUST_FCST_EXCEL_UPLOAD — 업로드 검증 마스터 확인 보완 [E20260915-DMF0014MSTCHK] (2026-09-15)

배경: 저장([OK], mode=1) 시 PR_DM_PLN_CUST_FCST_TO_MKT_FCST 541행 SELECT INTO(SITE_ITEM by Project/Model 열) ORA-01403 → SQL ERROR.
      업로드 검증은 통과(Customer Model 검증의 SITE_ITEM 조건이 ATTRIBUTE4/5 로 변환됨 — AS-IS 는 ATTRIBUTE12/13).
보완(메인 프로시저 구간만 — _SM 프로시저 무변경, Division != 40 경로 = 반영 프로시저 호출 경로):
  ① Customer Model 검증 SITE_ITEM 조건 ATTRIBUTE4/5 → ATTRIBUTE12/13 (AS-IS DMF0014_CUST_FCST_EXCEL_UPLOAD L453~454 파리티) + 메시지에 [Project]/[Model] 안내
  ② Model 품목 마스터(SCM_MST_ITEM_SN) 존재 — 반영 프로시저 600행 SELECT INTO 무예외처리 대응 (대상 품목 = Customer Model 등록 품목, 없으면 [Model] 열)
  ③ Customs Handbook = LOOKUP 'DOM/EXP' (AS-IS 주석 블록 의도 복원 — 원장에 '72' 등 비정상값 유입 실측)
usage: python apply_masterchk.py backup|apply|test
"""
import datetime, pathlib, re, sys

HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parents[1] / "_diagnostics"))
import ora  # noqa: E402

NAME, TYP = "PKG_DMF0014", "PACKAGE BODY"
ASIS = HERE / "00_BACKUP_ASIS" / "PKG_DMF0014_BODY.ASIS.sql"
TOBE = HERE / "01_APPLY" / "PKG_DMF0014_BODY.sql"
SPLIT = "PROCEDURE P_DMF0014_CUST_FCST_EXCEL_UPLOAD_SM"

OLD_MSG = "'Invalid Customer Model - 등록되지 않은 Customer Model 입니다. [Customer Model*] 확인'"
NEW_MSG = "'Invalid Customer Model - 등록되지 않은 Customer Model 이거나 [Project]/[Model] 이 품목 마스터(Site Item)에 없습니다. [Customer Model*]/[Project]/[Model] 확인'"
OLD_SI = ("                        AND    SI.PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4\n"
          "                        AND    SI.ITEM_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE5\n")
NEW_SI = ("                        AND    SI.PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE12  /*[E20260915-DMF0014MSTCHK] AS-IS L453 = Project 열(구 ATTRIBUTE4)*/\n"
          "                        AND    SI.ITEM_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE13       /*[E20260915-DMF0014MSTCHK] AS-IS L454 = Model 열(구 ATTRIBUTE5)*/\n")
ANCHOR = ("                END IF;\n            END IF;\n\n            BEGIN\n"
          "                -- ---------------------------------------------------------------------\n"
          "                --scm2_mgr.xLOG('Invalid Customer Model ', SQL%ROWCOUNT, 7, TRUE);\n")

HEAD = """                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    UPLOAD_STATUS_CODE = 'ERROR', MESSAGE_TEXT = CASE WHEN MESSAGE_TEXT IS NULL THEN {m} ELSE MESSAGE_TEXT || ' / ' || {m} END
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    UPLOAD_STATUS_CODE IN ('UPLOAD','ERROR')
"""
TAIL = """                v_err_cnt := SQL%ROWCOUNT;
                IF v_err_cnt > 0 THEN
                    V_LOG_TYPE    := '{lt}';
                    V_LOG_MESSAGE := '########## ERROR {lm}. ##########';
                    V_DESCRIPTION := NULL;
                    D_EVENT_DATE  := SYSTIMESTAMP;
                    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                    COMMIT;   -- ERROR 상태 확정 (전 검증 계속 수행 — E20260911-DMF0014MULTI)
                END IF;
"""
M_MODEL = "'Invalid Model - 품목 마스터(Item)에 없는 Model 입니다. [Model] 확인'"
M_DOMEXP = "'Invalid Customs Handbook - 등록되지 않은 Customs Handbook 입니다(D/E). [Customs Handbook*] 확인'"
INSERT = ("""                END IF;
            END IF;

            /* [E20260915-DMF0014MSTCHK] ② Model 품목 마스터 — 저장 후 반영(PR_DM_PLN_CUST_FCST_TO_MKT_FCST)이
               품목 분류(SCM_MST_ITEM_SN)를 예외처리 없이 조회하므로(ORA-01403) 업로드 단계에서 오류 행으로 거른다.
               대상 품목 = 반영 프로시저와 동일 규칙: Customer Model 마스터 품목 → 없으면 [Model] 열. */
            IF V_DIVISION != '40' THEN
""" + HEAD.format(m=M_MODEL) + """                AND    NOT EXISTS (SELECT 1
                        FROM   SCM_MST_ITEM_SN S
                        WHERE  S.ITEM_ID = NVL((SELECT MAX(CM.ITEM_ID)
                                                FROM   DM_MST_CUSTOMER_MODEL CM, SCM_MST_DIVISION D2
                                                WHERE  CM.DIVISION_ID = D2.DIVISION_ID
                                                AND    (D2.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1 OR D2.DIVISION_NAME = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1)
                                                AND    CM.SCM_SITE_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2
                                                AND    CM.CUSTOMER_PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4
                                                AND    CM.CUSTOMER_MODEL = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE5), SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE13));
""" + TAIL.format(lt="101", lm="Invalid Model") + """
                /* [E20260915-DMF0014MSTCHK] ③ Customs Handbook = LOOKUP 'DOM/EXP' (AS-IS 주석 블록의 검증 의도 복원) */
""" + HEAD.format(m=M_DOMEXP) + """                AND    NOT EXISTS (SELECT 1
                        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL L
                        WHERE  L.LOOKUP_TYPE = 'DOM/EXP'
                        AND    L.SEGMENT1 = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE8
                        AND    L.VALID_YN = 'Y');
""" + TAIL.format(lt="102", lm="Invalid Customs Handbook") + """            END IF;

            BEGIN
                -- ---------------------------------------------------------------------
                --scm2_mgr.xLOG('Invalid Customer Model ', SQL%ROWCOUNT, 7, TRUE);
""")


def fetch(cur):
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE=:t ORDER BY LINE", n=NAME, t=TYP)
    return "".join(r[0] for r in cur.fetchall())


def last_ddl(cur):
    cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'), STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE=:t", n=NAME, t=TYP)
    return cur.fetchone()


def ddl(text):
    head, rest = text.split("\n", 1)
    assert re.match(r"\s*PACKAGE\s+BODY\b", head, re.I), head[:60]
    return f'CREATE OR REPLACE PACKAGE BODY SCM_MGR."{NAME}" IS\n' + rest


def patch(src):
    i = src.index(SPLIT)
    main, rest = src[:i], src[i:]
    for old, new, tag in ((OLD_MSG, NEW_MSG, "msg"), (OLD_SI, NEW_SI, "site_item"), (ANCHOR, INSERT, "anchor")):
        n = main.count(old) if tag != "msg" else main.count(old)
        if tag == "msg":
            assert n == 2, (tag, n)   # CASE 의 THEN/ELSE 양쪽
        else:
            assert n == 1, (tag, n)
        main = main.replace(old, new)
    return main + rest


def main():
    mode = sys.argv[1]
    import oracledb
    u, p, d = ora.conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        if mode == "backup":
            src = fetch(cur)
            assert "E20260915-DMF0014MSTCHK" not in src, "이미 반영됨"
            ldt, st = last_ddl(cur)
            fetched = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
            stamp = f"-- SOURCE-FRESH: SCM_MGR.{NAME} {TYP} LAST_DDL={ldt} FETCHED={fetched} DB=ZIOUI1\n"
            ASIS.parent.mkdir(parents=True, exist_ok=True); TOBE.parent.mkdir(parents=True, exist_ok=True)
            ASIS.write_text(stamp + ddl(src).rstrip() + "\n/\n", encoding="utf-8")
            TOBE.write_text(stamp + ddl(patch(src)).rstrip() + "\n/\n", encoding="utf-8")
            print("backup written — LAST_DDL", ldt, st, "lines", src.count("\n"))
        elif mode == "apply":
            # FRESH-GATE (hook #152): 적용 직전 DB 원문 재조회 == 착수 백업본 — 다르면 중단
            body = lambda f: f.read_text(encoding="utf-8").split("\n", 1)[1]
            assert ddl(fetch(cur)).rstrip() + "\n/\n" == body(ASIS), "FRESH-GATE 실패: 백업 이후 DB 원문 변경 — 중단·재조회"
            cur.execute(body(TOBE).rstrip().rstrip("/").rstrip())
            print("status", last_ddl(cur))
            cur.execute("SELECT LINE, POSITION, TEXT FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE=:t ORDER BY SEQUENCE", n=NAME, t=TYP)
            print("errors", cur.fetchall() or 0)
            s = fetch(cur)
            print("applied == TOBE:", ddl(s).rstrip() + "\n/\n" == body(TOBE), "| marker", s.count("E20260915-DMF0014MSTCHK"))
            cur.execute("""SELECT OBJECT_NAME, OBJECT_TYPE FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND STATUS='INVALID' AND OBJECT_TYPE IN ('PACKAGE','PACKAGE BODY','PROCEDURE','FUNCTION','VIEW')
                           AND LAST_DDL_TIME > SYSDATE - 1""")
            print("invalid(24h)", cur.fetchall() or 0)


if __name__ == "__main__":
    main()
