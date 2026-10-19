"""DMF0044 자릿수 초과 메시지 문구 보완 — PKG_DMF0044 BODY FN_CHK_QTY_DIGITS 반환 문구만 교체.
usage: python apply_msg_format.py backup|apply|test
  backup : 현재 BODY 를 00_BACKUP_ASIS/ 에 저장 + 01_APPLY/ 에 치환본 생성 (DB 무변경)
  apply  : 게이트(현재 BODY == 백업) 통과 시 01_APPLY 본 배포 → STATUS/ERRORS 확인
  test   : ETC(_C) / Cutoff(_C_CF) 저장 SP 를 초과값 1행으로 호출 → 반환 커서 MSG 출력
           (검증은 DML 이전 RETURN — 원장 무변경. 로그 테이블에만 INVALID 1건 기록)
"""
import pathlib, sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[2] / "_diagnostics"))
import ora  # noqa: E402

HERE = pathlib.Path(__file__).resolve().parent
ASIS = HERE / "00_BACKUP_ASIS" / "PKG_DMF0044_BODY.ASIS.sql"
TOBE = HERE / "01_APPLY" / "PKG_DMF0044_BODY.sql"

OLD = """                    IF V_CNT <= 10 THEN
                        V_KEY := 'Model='    || NVL(FN_TOK(G_T_ITEM_ID, I), '-')
                              || ' / Measure=' || NVL(FN_TOK(G_T_MEASURE, I), '-')
                              || ' / 기간='    || NVL(FN_TOK(G_T_YYYYMMDD, I), '-')
                              || ' / 부서='    || NVL(FN_TOK(G_T_DEPT_NAME, I), '-');
                        V_DET := V_DET || CHR(10)
                              || '  - [' || I || '행] ' || V_KEY
                              || CHR(10) || '      입력값 ' || V_RAW
                              || ' (정수부 '
                              || LENGTH(TO_CHAR(TRUNC(ABS(V_NUM)),
                                        'FM' || RPAD('9', 38, '9'))) || '자리)';
                    END IF;
                END IF;
            END IF;
        END LOOP;
        IF V_CNT = 0 THEN RETURN NULL; END IF;
        --[E20260903-DMF0044NUM] 메시지 문구 = 사용자 지정 원문 그대로 (2026-09-03 최종).
        --  문구에 건수·자릿수 등 어떤 가공도 덧붙이지 않는다. 뒤에 붙는 것은 위반 값 상세뿐.
        RETURN '허용 가능한 자릿수를 초과하였습니다.'
               || V_DET
               || CASE WHEN V_CNT > 10 THEN CHR(10) || '  ... 외 ' || (V_CNT - 10) || '건' END;"""

NEW = """                    IF V_CNT <= 10 THEN
                        --[E20260915-DMF0044MSGFMT] 상세 형식 = 사용자 지정 (2026-09-15):
                        --  항목별 1줄 "라벨 : 값" / 입력값은 원문 토큰 그대로. 위반 건 사이는 빈 줄 1개.
                        V_KEY := 'Model : '   || NVL(FN_TOK(G_T_ITEM_ID, I), '-')   || CHR(10)
                              || 'Measure : ' || NVL(FN_TOK(G_T_MEASURE, I), '-')   || CHR(10)
                              || '기간 : '    || NVL(FN_TOK(G_T_YYYYMMDD, I), '-')  || CHR(10)
                              || '부서 : '    || NVL(FN_TOK(G_T_DEPT_NAME, I), '-') || CHR(10)
                              || '입력값 '    || V_RAW;
                        V_DET := V_DET || CHR(10)
                              || CASE WHEN V_CNT > 1 THEN CHR(10) END
                              || V_KEY;
                    END IF;
                END IF;
            END IF;
        END LOOP;
        IF V_CNT = 0 THEN RETURN NULL; END IF;
        --[E20260915-DMF0044MSGFMT] 메시지 문구 = 사용자 지정 원문 (2026-09-15 — 09-03 문구 대체).
        --  "30자리" = QTY NUMBER(30,10) 전체 정밀도, "정수20자리" = P_MAX.
        RETURN '허용 가능한 자릿수를 초과하였습니다. 30자리(정수' || P_MAX || '자리) 이내로 입력하세요.'
               || V_DET
               || CASE WHEN V_CNT > 10 THEN CHR(10) || CHR(10) || '... 외 ' || (V_CNT - 10) || '건' END;"""


def current_body(cur):
    cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044'
                   AND TYPE='PACKAGE BODY' ORDER BY LINE""")
    return "".join(r[0] for r in cur.fetchall())


def ddl(body):
    # ALL_SOURCE 첫 줄 = "PACKAGE BODY PKG_DMF0044 ..." → 스키마 명시 CREATE OR REPLACE
    head, rest = body.split("\n", 1)
    assert head.strip().upper().startswith("PACKAGE BODY"), head[:80]
    name_part = head.strip()[len("PACKAGE BODY"):].strip()
    if not name_part.upper().startswith("SCM_MGR."):
        name_part = "SCM_MGR." + name_part
    return "CREATE OR REPLACE PACKAGE BODY " + name_part + "\n" + rest


def main():
    mode = sys.argv[1]
    import oracledb
    u, p, d = ora.conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        if mode == "backup":
            body = current_body(cur)
            assert body.count(OLD) == 1, f"치환 대상 블록 일치 {body.count(OLD)}건 (1건이어야 함)"
            ASIS.parent.mkdir(parents=True, exist_ok=True)
            TOBE.parent.mkdir(parents=True, exist_ok=True)
            ASIS.write_text(ddl(body) + "\n/\n", encoding="utf-8")
            TOBE.write_text(ddl(body.replace(OLD, NEW)) + "\n/\n", encoding="utf-8")
            print("backup lines", body.count("\n"), "-> ASIS/TOBE written")
        elif mode == "apply":
            body = current_body(cur)
            asis = ASIS.read_text(encoding="utf-8")
            assert ddl(body) + "\n/\n" == asis, "게이트 실패: 현재 BODY != 백업본 (그 사이 변경됨) — 중단"
            tobe = TOBE.read_text(encoding="utf-8")
            cur.execute(tobe.rstrip().rstrip("/").rstrip())
            cur.execute("""SELECT OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS')
                           FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0044'""")
            for r in cur.fetchall():
                print(r)
            cur.execute("""SELECT LINE, POSITION, TEXT FROM ALL_ERRORS WHERE OWNER='SCM_MGR'
                           AND NAME='PKG_DMF0044' ORDER BY SEQUENCE""")
            errs = cur.fetchall()
            print("errors:", errs if errs else 0)
            print("applied body == TOBE:", ddl(current_body(cur)) + "\n/\n" == tobe)
        elif mode == "test":
            over = "7.777777777777778e+35"
            etc = dict(P_ACTIVE_FLAG="M", P_DIVISION_ID="40", P_VERSION_NO="TEST_DIGIT", P_CUTOFF_TYPE="",
                       P_CUTOFF_YYYYMMDD="", P_DEPARTMENT_ID="D1", P_DEPARTMENT_NAME="Dept",
                       P_DEPT_ID="T1", P_DEPT_NAME="IM1팀", P_END_CUST_REPORT="", P_CUST_REPORT="",
                       P_PRODUCT_GROUP="", P_ITEM_ID="MCCM349215A1-002", P_MEASURE="RTF_SYS_RP",
                       P_YYYYMMDD="202602", P_CURRENCY="USD", P_COMPANY_ID="C1", P_QTY=over,
                       P_CREATED_BY="minyonglee1", P_CELL_MODEL_INFO="", P_CELL_MODEL="")
            cf = {k: v for k, v in etc.items() if k not in ("P_CELL_MODEL_INFO", "P_CELL_MODEL")}
            cf.update(P_SCM_SITE_ID="-", P_PROJECT_CODE="-", P_FCST_TYPE="-", P_INCOTERMS="-",
                      P_CELL_PROD_SITE="-", P_PLANT_SITE_ID="-")
            # 다건 — 2번째 행도 초과 (위반 건 구분 형식 확인)
            multi = {k: v + "^" + v for k, v in cf.items()}
            multi["P_ITEM_ID"] = "MCCM349215A1-002^MODEL-B"
            multi["P_QTY"] = over + "^123456789012345678901"
            for name, args in (("P_DMF0044_SAVE_SALES_PLAN_REPORT_C", etc),
                               ("P_DMF0044_SAVE_SALES_PLAN_REPORT_C_CF", cf),
                               ("P_DMF0044_SAVE_SALES_PLAN_REPORT_C_CF (2건)", multi)):
                rc = cur.var(oracledb.DB_TYPE_CURSOR)
                cur.callproc("SCM_MGR.PKG_DMF0044." + name.split(" ")[0], keyword_parameters={**args, "O_RESULT_CURSOR": rc})
                rows = rc.getvalue().fetchall()
                print(f"=== {name}")
                for r in rows:
                    print("CODE:", r[0])
                    print(r[1])
            con.rollback()


if __name__ == "__main__":
    main()
