#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""PKG_DMF0014 업로드 SP — **허위 성공 차단 가드**.

사고(2026-08-14): 적재(mode=1)가 INSERT 를 실행했지만 후속 프로시저의 ROLLBACK 으로 되돌려졌고,
   그 예외가 삼켜져 SP 는 그대로 CODE=0 SUCCESS 를 반환했다. 화면은 "저장 완료", 원장은 0건.

가드 2중 — 둘 다 필요하다:
  ① `v_ins_cnt := SQL%ROWCOUNT` — INSERT 가 애초에 0행인 경우(조인/필터 붕괴)
  ② **적재 후 실재 재확인** — ①만으로는 못 잡는다. ROLLBACK 이 나도 PL/SQL 변수 v_ins_cnt 는
     롤백 이전 값을 그대로 들고 있기 때문. 그래서 성공 커서를 열기 직전에 원장을 다시 세어,
     "넣었다고 했는데 없는" 상태를 실패로 돌린다.
"""
import io, pathlib, sys
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
from ora import conn_info
import oracledb

OUT = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0014_EXCELFORM_20260814")

DECL_OLD = """        v_err_cnt        NUMBER;
    BEGIN"""
DECL_NEW = """        v_err_cnt        NUMBER;
        /* ⭐ [2026-08-14 허위성공 차단] 적재 실적 추적용 */
        v_ins_cnt        NUMBER := 0;   /* INSERT 가 반환한 행수 */
        v_live_cnt       NUMBER := 0;   /* 적재 후 원장에 **실제로 남아있는** 행수 */
        d_ins_from       DATE;          /* 적재 시작 시각 — 재확인 범위 기준 */
    BEGIN"""

STAMP_OLD = """IF P_MODE > 0 AND V_COUNT = 0 THEN"""
STAMP_NEW = """d_ins_from := SYSDATE; /* ⭐ 적재 시작 시각 고정 — 아래 실재 재확인의 하한 */
            IF P_MODE > 0 AND V_COUNT = 0 THEN"""

INS_OLD = """                AND    C.COLUMN_NAME = V.COLUMN_NAME
                AND    C.YYYYMMDD IS NOT NULL
                AND    V.VALUE IS NOT NULL;"""
INS_NEW = """                AND    C.COLUMN_NAME = V.COLUMN_NAME
                AND    C.YYYYMMDD IS NOT NULL
                AND    V.VALUE IS NOT NULL;

                v_ins_cnt := SQL%ROWCOUNT; /* ⭐ [허위성공 차단 ①] 0행이면 조인/필터가 무너진 것 */"""

OK_OLD = """OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;"""
OK_NEW = """/* ⭐ [허위성공 차단 ②] 적재 모드인데 원장에 남은 게 없으면 성공으로 보고하지 않는다.
           v_ins_cnt 만으로는 부족하다 — 하위 프로시저가 ROLLBACK 하면 행은 사라져도 이 변수는
           롤백 이전 값을 그대로 들고 있다(2026-08-14 실사고). 그래서 원장을 다시 센다. */
        IF NVL(P_MODE, 0) > 0 THEN
            SELECT COUNT(*)
            INTO   v_live_cnt
            FROM   DM_PLN_CUSTOMER_PSI
            WHERE  CREATED_BY = P_CREATED_BY
            AND    CREATION_DATE >= d_ins_from;

            IF NVL(v_ins_cnt, 0) = 0 OR NVL(v_live_cnt, 0) = 0 THEN
                BEGIN
                    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, 'ERROR', N_LOG_COUNT
                      , '########## SAVE VERIFY FAILED — inserted=' || NVL(v_ins_cnt, 0)
                        || ' / live=' || NVL(v_live_cnt, 0) || ' ##########'
                      , P_MODE, SYSTIMESTAMP);
                EXCEPTION WHEN OTHERS THEN NULL; END;
                OPEN O_RESULT_CURSOR FOR
                    SELECT '-1' AS CODE
                         , 'ERR_RTN: - Save verify failed (inserted=' || NVL(v_ins_cnt, 0)
                           || ', persisted=' || NVL(v_live_cnt, 0) || ')' AS MSG
                         , 'SAVE_VERIFY' AS EVENT
                    FROM   DUAL;
                RETURN;
            END IF;
        END IF;

        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;"""

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0014'
               AND TYPE='PACKAGE BODY' ORDER BY LINE""")
body = "".join(r[0] for r in cur.fetchall())

# ⚠ 앵커가 _SM 변형 프로시저와 겹친다 → **메인 프로시저 구간에만** 적용한다.
SM  = "PROCEDURE P_DMF0014_CUST_FCST_EXCEL_UPLOAD_SM"
BEG = "PROCEDURE P_DMF0014_CUST_FCST_EXCEL_UPLOAD"
b0 = body.find(BEG); b1 = body.find(SM)
assert 0 < b0 < b1, "업로드 프로시저 경계 미발견"
pre, head, tail = body[:b0], body[b0:b1], body[b1:]
for name, old in [("DECL", DECL_OLD), ("STAMP", STAMP_OLD), ("INSERT", INS_OLD), ("OK", OK_OLD)]:
    n = head.count(old)
    print(f"  [anchor] {name:<7} proc={n}회 (pre={pre.count(old)} tail={tail.count(old)} — 미적용)")
    assert n == 1, f"{name} 앵커 head {n}회"
head = head.replace(DECL_OLD, DECL_NEW, 1)
head = head.replace(STAMP_OLD, STAMP_NEW, 1)
head = head.replace(INS_OLD, INS_NEW, 1)
head = head.replace(OK_OLD, OK_NEW, 1)
body = pre + head + tail

(OUT / "13_PKG_DMF0014_BODY_SAVE_VERIFY_GUARD.sql").write_text(
    "SET DEFINE OFF\nCREATE OR REPLACE " + body.rstrip() + "\n/\n", encoding="utf-8")
cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 120")
cur.execute("CREATE OR REPLACE " + body.rstrip())
cur.execute("""SELECT LINE, TEXT FROM ALL_ERRORS WHERE OWNER='SCM_MGR'
               AND NAME='PKG_DMF0014' ORDER BY SEQUENCE""")
errs = cur.fetchall()
print(f"[deploy] errors={len(errs)}")
for e in errs[:6]:
    print("   ", e[0], str(e[1])[:130])
con.close()
