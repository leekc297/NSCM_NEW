"""BPS I/F 반영 대상 0건 안내 — PR_SCM_MST_EXCHANGE_RATE_UI (화면 전용 래퍼) 만 수정.
usage: python apply_wrapper.py backup|apply|test
  backup : 현재 원문 → 00_BACKUP_ASIS/ , 신규 DDL → 01_APPLY/ (DB 무변경)
  apply  : 게이트(현재 원문 == 백업) 통과 시 배포 → STATUS / ERRORS / GRANT 확인
  test   : P_BATCH_YN='N' 호출 → 결과 커서 출력 (대상 0건이면 배치 미호출 → 데이터 무변경)
"""
import pathlib, sys

HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parents[1] / "_diagnostics"))
import ora  # noqa: E402

ASIS = HERE / "00_BACKUP_ASIS" / "PR_SCM_MST_EXCHANGE_RATE_UI.ASIS.sql"
TOBE = HERE / "01_APPLY" / "PR_SCM_MST_EXCHANGE_RATE_UI.sql"

NEW_DDL = """CREATE OR REPLACE PROCEDURE SCM_MGR."PR_SCM_MST_EXCHANGE_RATE_UI" (
    P_BATCH_YN      IN  VARCHAR2 DEFAULT 'N',
    O_RESULT_CURSOR OUT SYS_REFCURSOR
) AS
    V_ERR        VARCHAR2(200 CHAR);
    V_TARGET_CNT NUMBER;
BEGIN
    --[E20260915-BPSIFNODATA] 반영 대상 0건 안내 (사용자 지시 2026-09-15).
    --  공유 배치 PR_SCM_MST_EXCHANGE_RATE 는 대상이 없어도 오류 없이 끝나 이 래퍼가 항상 success 를 돌려줬고,
    --  화면은 "정상 반영" 토스트 후 값이 그대로여서 반영된 것으로 오인됐다(사내 XIF 0행 실측).
    --  → 배치 CUR_E 와 **동일 조건**으로 대상 건수를 먼저 세고, 0건이면 배치를 호출하지 않고 안내를 돌려준다.
    --  CODE <> '0' 이면 FE(ExchangeRateModal handleBpsIf)가 RESULT_MSG 를 Alert 로 표시한다 — FE 무변경.
    --  공유 배치 본문은 무수정(야간 배치 P_BATCH_YN='Y' 경로 영향 없음).
    IF P_BATCH_YN = 'Y' THEN
        SELECT COUNT(*)
          INTO V_TARGET_CNT
          FROM SCM_MGR.XIF_GSC_MOVE_EXCHANGE_RATE_SN E
         WHERE NVL(E.TRANSF_FLAG, 'N') = 'N'
           AND E.SCENARIO_TYPE_CD IN ('ML', 'RF');
    ELSE
        SELECT COUNT(*)
          INTO V_TARGET_CNT
          FROM SCM_MGR.XIF_GSC_MOVE_EXCHANGE_RATE_SN E
         WHERE E.TRANSF_DATE = (SELECT MAX(A.TRANSF_DATE)
                                  FROM SCM_MGR.XIF_GSC_MOVE_EXCHANGE_RATE_SN A
                                 WHERE A.SCENARIO_TYPE_CD IN ('ML', 'RF'))
           AND E.SCENARIO_TYPE_CD IN ('ML', 'RF');
    END IF;

    IF V_TARGET_CNT = 0 THEN
        OPEN O_RESULT_CURSOR FOR
            SELECT '1' AS CODE, '반영할 환율 정보가 없습니다' AS RESULT_MSG, CAST(NULL AS VARCHAR2(200 CHAR)) AS EVENT FROM DUAL;
        RETURN;
    END IF;

    SCM_MGR.PR_SCM_MST_EXCHANGE_RATE(P_BATCH_YN);
    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'success' AS RESULT_MSG, CAST(NULL AS VARCHAR2(200 CHAR)) AS EVENT FROM DUAL;
EXCEPTION
    WHEN OTHERS THEN
        V_ERR := SUBSTR(SQLERRM, 1, 200);
        ROLLBACK;
        OPEN O_RESULT_CURSOR FOR
            SELECT '9' AS CODE, 'fail' AS RESULT_MSG, V_ERR AS EVENT FROM DUAL;
END PR_SCM_MST_EXCHANGE_RATE_UI;
"""


def src(cur):
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PR_SCM_MST_EXCHANGE_RATE_UI' ORDER BY LINE")
    return "".join(r[0] for r in cur.fetchall())


def asis_ddl(text):
    return "CREATE OR REPLACE " + text.replace('PROCEDURE           "PR_SCM_MST_EXCHANGE_RATE_UI"',
                                               'PROCEDURE SCM_MGR."PR_SCM_MST_EXCHANGE_RATE_UI"', 1).rstrip() + "\n/\n"


def main():
    mode = sys.argv[1]
    import oracledb
    u, p, d = ora.conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        if mode == "backup":
            ASIS.parent.mkdir(parents=True, exist_ok=True)
            TOBE.parent.mkdir(parents=True, exist_ok=True)
            ASIS.write_text(asis_ddl(src(cur)), encoding="utf-8")
            TOBE.write_text(NEW_DDL + "/\n", encoding="utf-8")
            print("written")
        elif mode == "apply":
            assert asis_ddl(src(cur)) == ASIS.read_text(encoding="utf-8"), "게이트 실패: 현재 원문 != 백업본 — 중단"
            cur.execute(TOBE.read_text(encoding="utf-8").rstrip().rstrip("/").rstrip())
            cur.execute("SELECT STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PR_SCM_MST_EXCHANGE_RATE_UI'")
            print("status", cur.fetchall())
            cur.execute("SELECT LINE, POSITION, TEXT FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME='PR_SCM_MST_EXCHANGE_RATE_UI' ORDER BY SEQUENCE")
            print("errors", cur.fetchall() or 0)
            cur.execute("SELECT GRANTEE, PRIVILEGE FROM ALL_TAB_PRIVS WHERE TABLE_SCHEMA='SCM_MGR' AND TABLE_NAME='PR_SCM_MST_EXCHANGE_RATE_UI'")
            print("grants", cur.fetchall())
        elif mode == "test":
            cur.execute("SELECT COUNT(*) FROM SCM_MGR.XIF_GSC_MOVE_EXCHANGE_RATE_SN")
            print("XIF rows:", cur.fetchone()[0])
            rc = cur.var(oracledb.DB_TYPE_CURSOR)
            cur.callproc("SCM_MGR.PR_SCM_MST_EXCHANGE_RATE_UI", ["N", rc])
            c = rc.getvalue()
            print([x[0] for x in c.description], c.fetchall())


if __name__ == "__main__":
    main()
