# -*- coding: utf-8 -*-
"""PKG_DMF0049 SETFULL 보충 INSERT 정정 [E20260930-DMF0049SETFULL2] — 세트 판정을 DATA_SEQ 채번 키(DENSE_RANK 19컬럼)+월 기준으로.

클라우드 실사고 (2026-09-30 19:41, ORA-00001 PK_DM_PLN_SALES_ETC_REPORT_C @ INSERT 대상(DATA_SEQ 미존재) 원장 INSERT):
  SETFULL(1차) 보충 INSERT 는 식별 33컬럼이 전부 같은 행끼리만 같은 세트로 봤다. 화면 세트 행들 사이에 채번 키가 아닌 컬럼
  (T_DEPARTMENT_NAME·DEPARTMENT_EDIT_FLAG·FCST_TYPE·CELL_MODEL*·PROJECT_CODE·SCM_SITE_ID 등)이 다르면 그룹이 갈라져 같은
  (채번 DATA_SEQ, MEASURE, 월) 로 보충 행이 두 벌 생겨 PK 충돌. 사내 재현 시나리오는 행 간 값이 모두 같아 통과했었다.
정정: 세트 키 = VERSION_NO·DIVISION_ID·DATA_SEQ + DENSE_RANK 19컬럼 + YYYYMMDD. 비-키 컬럼은 그룹 MAX 로 대표값.
      NOT EXISTS 도 같은 키 + MEASURE (NULL-safe DECODE). 원장 보존 가드 유지.
방법: 1차 블록(마커 `/*[E20260930-DMF0049SETFULL] 메저 세트 보충` ~ 앵커 `--Start [C20210125-000207] 40사업부 Unit Price Measure 추가` 직전)을
      통째로 새 블록으로 교체. (a) 비활성 2줄은 그대로. FRESH-GATE 동일.
usage: python apply_setfull2.py backup | apply | restore
"""
import datetime, io, pathlib, sys
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parents[1] / "_diagnostics"))
from ora import conn_info
import oracledb

MODE = sys.argv[1] if len(sys.argv) > 1 else "backup"
TAG1, TAG = "E20260930-DMF0049SETFULL", "E20260930-DMF0049SETFULL2"
NAME, TYP = "PKG_DMF0049", "PACKAGE BODY"
BAK = HERE / "10_BACKUP_PKG_DMF0049_BODY_pre_SETFULL2.sql"
NEW = HERE / "11_PKG_DMF0049_BODY_SETFULL2.sql"
u, p, d = conn_info()
cn = oracledb.connect(user=u, password=p, dsn=d)
cn.call_timeout = 900000
cur = cn.cursor()


def last_ddl():
    cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM USER_OBJECTS WHERE OBJECT_NAME=:1 AND OBJECT_TYPE=:2", [NAME, TYP])
    return cur.fetchone()[0]


def fetch():
    cur.execute("SELECT TEXT FROM USER_SOURCE WHERE NAME=:1 AND TYPE=:2 ORDER BY LINE", [NAME, TYP])
    return [t or "" for (t,) in cur]


def compile_src(src):
    cur.execute("CREATE OR REPLACE " + src.rstrip())
    cur.execute("SELECT STATUS FROM USER_OBJECTS WHERE OBJECT_NAME=:1 AND OBJECT_TYPE=:2", [NAME, TYP])
    st = cur.fetchone()[0]
    cur.execute("SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME=:1 AND TYPE=:2 ORDER BY SEQUENCE", [NAME, TYP])
    return st, cur.fetchall()


if MODE == "restore":
    src = BAK.read_text(encoding="utf-8").split("CREATE OR REPLACE ", 1)[1].rsplit("\n/\n", 1)[0]
    print("restore:", compile_src(src))
    sys.exit(0)

ddl0 = last_ddl()
L = fetch()
src0 = "".join(L)
assert TAG not in src0, "이미 적용됨"
bs = [i for i, t in enumerate(L) if f"/*[{TAG1}] 메저 세트 보충" in t]
anc = [i for i, t in enumerate(L) if t.strip() == "--Start [C20210125-000207] 40사업부 Unit Price Measure 추가"]
assert len(bs) == 1 and len(anc) == 1 and bs[0] < anc[0], (bs, anc)
b0, b1 = bs[0], anc[0]                      # [b0, b1) = 1차 보충 블록 (끝 빈 줄 포함)
blk1 = "".join(L[b0:b1])
assert "INSERT INTO SCM_MGR.GT_DMF0049_RESULTS_MST" in blk1 and blk1.count(";") == 1 and "DECODE(C." in blk1

KEY = ["VERSION_NO", "DIVISION_ID", "DATA_SEQ",                                   # PK 축
       "DEPARTMENT_ID", "DEPT_ID", "CUST_REPORT", "END_CUST_REPORT", "SOLDTO_CODE", "SOLDTO_CUST_REPORT", "PRODUCT_GROUP", "ITEM_ID",
       "PRODUCT_DETAILS", "CURRENCY", "COMPANY_ID", "BIZ_TYPE", "APPLICATION_GR", "APPLICATION", "COUNTRY_CODE", "ITEM_USE",
       "SOLDTO_COUNTRY", "SHIPTO_COUNTRY", "END_CUSTOMER",                         # DENSE_RANK 19컬럼 (INSERT 경로 채번 키)
       "YYYYMMDD"]
REST = ["ACTIVE_FLAG", "RESULT_MONTH", "DEPARTMENT_EDIT_FLAG", "T_DEPARTMENT_NAME", "PROJECT_CODE", "SCM_SITE_ID", "CELL_MODEL_INFO",
        "CELL_MODEL", "FCST_TYPE", "CREATED_BY"]                                   # 비-키: 그룹 MAX 대표값
I4 = "    "
cols = ", ".join(KEY + REST)
sel = ", ".join([f"S.{c}" for c in KEY] + [f"S.{c}" for c in REST])
grp_sel = ", ".join([f"B.{c}" for c in KEY] + [f"MAX(B.{c}) AS {c}" for c in REST])
grp_by = ", ".join(f"B.{c}" for c in KEY)
nulleq = "\n".join(f"{I4}                     AND DECODE(C.{c}, S.{c}, 1, 0) = 1" for c in KEY)
block = f"""{I4}/*[{TAG}] 메저 세트 보충 (2차 — 1차 [{TAG1}] 블록 교체) — 사용자 지시 2026-09-30 "Insert 시 3개 ROW 가 생성되고 값을 1개 ROW 에만
{I4}   입력해도 3개 ROW 가 항상 같이 저장". 세트 판정 = PK 축(VERSION·DIVISION·DATA_SEQ) + INSERT 경로 DATA_SEQ 채번 키(DENSE_RANK 19컬럼) + 월.
{I4}   1차는 식별 33컬럼 전부 동일을 요구해 세트 행 간 비-키 컬럼(부서명·편집플래그·FCST_TYPE 등)이 다르면 같은 (DATA_SEQ, MEASURE, 월) 보충 행이
{I4}   두 벌 생겨 클라우드 ORA-00001(2026-09-30 19:41) — 비-키 컬럼은 그룹 MAX 대표값. division 메저 목록 = P_DMF0049_GET_MEASURE 와 같은 원천·INSTR.
{I4}   원장에 그 세트·월·메저가 이미 있으면 보충하지 않는다(수정 경로 실제 값 보존). 위 [C20210125-000207] RTF_SYS_RP 0 행 삭제는 1차와 같이 비활성. */
{I4}INSERT INTO SCM_MGR.GT_DMF0049_RESULTS_MST
{I4}    ( {cols}
{I4}    , MEASURE, QTY )
{I4}SELECT {sel}
{I4}     , M.COLUMN_NAME, '0'
{I4}  FROM ( SELECT {grp_sel}
{I4}           FROM SCM_MGR.GT_DMF0049_RESULTS_MST B
{I4}          WHERE NVL(B.ACTIVE_FLAG, '-') <> 'D'
{I4}          GROUP BY {grp_by} ) S
{I4}  JOIN SCM_MST_SHEET_MEASURE M
{I4}    ON M.PROGRAM_ID = 'DMF0049'
{I4}   AND M.SHEET_NAME IN ( 'MDF Reports', 'mdfReports' )
{I4}   AND M.COLUMN_NAME IN ('SalesAmt_KRW', 'SalesAmt_LOC', 'RTF_SYS_RP')
{I4}   AND M.VALID_YN = 'Y'
{I4}   AND INSTR(M.DIVISION_ID, S.DIVISION_ID) > 0
{I4} WHERE NOT EXISTS ( SELECT 1 FROM SCM_MGR.GT_DMF0049_RESULTS_MST C
{I4}                     WHERE C.MEASURE = M.COLUMN_NAME
{I4}                       AND NVL(C.ACTIVE_FLAG, '-') <> 'D'
{nulleq} )
{I4}   -- 원장에 그 세트·월·메저가 이미 있으면 보충하지 않는다 (GTT YYYYMMDD 는 이 시점 yyyymm)
{I4}   AND NOT EXISTS ( SELECT 1 FROM DM_PLN_SALES_ETC_REPORT_C A
{I4}                     WHERE S.DATA_SEQ IS NOT NULL
{I4}                       AND A.VERSION_NO = S.VERSION_NO
{I4}                       AND A.DIVISION_ID = NVL(S.DIVISION_ID, '-')
{I4}                       AND TO_CHAR(A.DATA_SEQ) = S.DATA_SEQ
{I4}                       AND A.MEASURE = M.COLUMN_NAME
{I4}                       AND SUBSTR(A.YYYYMMDD, 1, 6) = SUBSTR(S.YYYYMMDD, 1, 6) );

"""
new = L[:b0] + [block] + L[b1:]
src1 = "".join(new)
assert "".join(L[:b0]) + "".join(L[b1:]) == src0.replace(blk1, "", 1)
assert src1.count(f"/*[{TAG}]") == 1 and src1.count(f"--[{TAG1}] 비활성") == 2 and f"/*[{TAG1}] 메저 세트 보충" not in src1   # 1차 블록 제거·2차 1개·비활성 2줄 유지
print(f"기준본 LAST_DDL={ddl0}  1차 블록 L{b0+1}~{b1} ({b1-b0}줄) → 2차 블록 {block.count(chr(10))}줄 교체")

now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
stamp = f"-- SOURCE-FRESH: SCM_MGR.{NAME} {TYP} LAST_DDL={ddl0} FETCHED={now} DB=ZIOUI1\n"
BAK.write_text(stamp + "-- 적용 전 원문 (SETFULL 1차 적용본)\nCREATE OR REPLACE " + src0.rstrip() + "\n/\n", encoding="utf-8")
NEW.write_text(stamp + f"-- [{TAG}] PKG_DMF0049 BODY 전체본\nSET DEFINE OFF\nSET SQLBLANKLINES ON\nCREATE OR REPLACE " + src1.rstrip() + "\n/\nSHOW ERRORS PACKAGE BODY SCM_MGR.PKG_DMF0049\n", encoding="utf-8")
(HERE / "_change_preview2.sql").write_text("-- (a) 1차와 동일: [C20210125-000207] DELETE 2줄 '--' 비활성 유지\n-- (b) 아래 블록이 1차 보충 블록을 통째로 대체 — 위치 = `--Start [C20210125-000207] 40사업부 Unit Price Measure 추가` 직전\n" + block, encoding="utf-8")
print("파일 생성 완료")

if MODE == "apply":
    assert last_ddl() == ddl0 and "".join(fetch()) == src0, "FRESH-GATE: 추출 이후 변경 감지 — 중단"
    st, errs = compile_src(src1)
    print(f"적용 결과 STATUS={st} 오류={len(errs)} LAST_DDL={last_ddl()}")
    if st != "VALID" or errs:
        for x in errs[:15]:
            print("  ERR", x)
        print("⚠ 원복:", compile_src(src0))
        sys.exit(1)
cn.close()
