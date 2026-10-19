# -*- coding: utf-8 -*-
"""PKG_DMF0049.P_DMF0049_SAVE_SALES_ETC_REPORT_C — 메저 세트(40: SalesAmt_LOC·SalesAmt_KRW·RTF_SYS_RP) 를 항상 온전히 저장 [E20260930-DMF0049SETFULL]

사용자 지시 (2026-09-30): "Insert 시 3개 ROW 가 생성되고, 값을 1개 ROW 에만 입력해도 3개 ROW 가 항상 같이 저장. FE 수정 없이 DB 단에서."
원인: FE 는 세트 × 월 × 세트내 3행을 모두 보내지만(AS-IS SaveData 1:1), 저장 SP 의 AS-IS 규칙 [C20210125-000207]
      "40사업부 RTF Measure 없으면 Row 삭제" (DELETE ... MEASURE='RTF_SYS_RP' AND ACTIVE_FLAG='I' AND QTY='0') 가 Insert 시
      RTF_SYS_RP 0 행을 버려 세트가 2행으로 저장된다 (사내 원장 실측: qjastar 세트 전부 SalesAmt_KRW·SalesAmt_LOC 2행뿐).
      한 번 2행이 된 세트는 이후 저장에서도 화면이 2행만 보내 계속 2행이다.
조치:
  (a) 위 DELETE 2줄을 줄 단위 `--` 비활성 (AS-IS 규칙 폐지 — 사용자 지시).
  (b) 세트 보충 INSERT 신설 — GTT 의 세트(식별 컬럼 동일 · 월 동일 · 'D' 제외)마다 division 메저 목록(SCM_MST_SHEET_MEASURE DMF0049
      'MDF Reports' × INSTR(DIVISION_ID) — P_DMF0049_GET_MEASURE 와 동일 원천·동일 필터)에 있는데 GTT 에 없는 메저를 QTY '0' 으로 채운다.
      기존 2행 세트도 다음 저장 때 3행으로 복구된다. 뒤 흐름(LOC 단가 파생·원장 삭제/삽입·이력) 무수정.
FRESH-GATE: 지금 DB 원문 기준 · 적용 직전 재조회 일치 시에만 CREATE OR REPLACE. (a) 2줄 주석화 + (b) 삽입 외 1바이트 불변.
usage: python apply_setfull.py backup | apply | restore
"""
import datetime, io, pathlib, sys
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parents[1] / "_diagnostics"))
from ora import conn_info
import oracledb

MODE = sys.argv[1] if len(sys.argv) > 1 else "backup"
TAG = "E20260930-DMF0049SETFULL"
NAME, TYP = "PKG_DMF0049", "PACKAGE BODY"
BAK = HERE / "00_BACKUP_PKG_DMF0049_BODY.sql"
NEW = HERE / "01_PKG_DMF0049_BODY_SETFULL.sql"
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
ps = next(i for i, t in enumerate(L) if t.strip() == "PROCEDURE P_DMF0049_SAVE_SALES_ETC_REPORT_C")
pe = len(L)   # SAVE 가 패키지 마지막 프로시저 (안의 로컬 PROCEDURE LOG_END 로 범위를 끊지 않는다) — 앵커 유일성은 아래 len==1 로 보장
d1 = [i for i in range(ps, pe) if L[i].strip() == "DELETE FROM SCM_MGR.GT_DMF0049_RESULTS_MST"
      and L[i + 1].strip() == "WHERE DIVISION_ID = '40' AND MEASURE = 'RTF_SYS_RP' AND ACTIVE_FLAG = 'I' AND QTY = '0';"]
anc = [i for i in range(ps, pe) if L[i].strip() == "--Start [C20210125-000207] 40사업부 Unit Price Measure 추가"]
assert len(d1) == 1 and len(anc) == 1 and d1[0] < anc[0], (d1, anc)
assert "40사업부 RTF Measure 없으면 Row 삭제" in L[d1[0] - 1]
k_del, k_anc = d1[0], anc[0]

# 세트 식별 컬럼 = 파싱 시 채워지는 컬럼 중 MEASURE·QTY 제외 (뒤에서 갱신되는 부가정보 컬럼은 이 시점 NULL — 대상 아님)
IDC = ["ACTIVE_FLAG", "RESULT_MONTH", "DIVISION_ID", "VERSION_NO", "DATA_SEQ", "DEPARTMENT_ID", "DEPARTMENT_EDIT_FLAG", "T_DEPARTMENT_NAME",
       "DEPT_ID", "CUST_REPORT", "END_CUST_REPORT", "SOLDTO_CODE", "SOLDTO_CUST_REPORT", "PRODUCT_GROUP", "ITEM_ID", "PRODUCT_DETAILS",
       "CURRENCY", "COMPANY_ID", "BIZ_TYPE", "APPLICATION_GR", "APPLICATION", "COUNTRY_CODE", "PROJECT_CODE", "SCM_SITE_ID", "CELL_MODEL_INFO",
       "CELL_MODEL", "FCST_TYPE", "YYYYMMDD", "CREATED_BY", "ITEM_USE", "SOLDTO_COUNTRY", "SHIPTO_COUNTRY", "END_CUSTOMER"]
I4 = "    "
cols = ", ".join(IDC)
sel = ", ".join(f"S.{c}" for c in IDC)
grp = ", ".join(f"B.{c}" for c in IDC)
nulleq = "\n".join(f"{I4}                     AND DECODE(C.{c}, S.{c}, 1, 0) = 1" for c in IDC)   # NULL-safe 동등 (NULL=NULL 참)
block = f"""{I4}/*[{TAG}] 메저 세트 보충 — 사용자 지시 2026-09-30 "Insert 시 3개 ROW 가 생성되고 값을 1개 ROW 에만 입력해도 3개 ROW 가 항상
{I4}   같이 저장". GTT 의 세트(식별 컬럼 + 월 동일, 'D' 제외)마다 division 메저 목록(P_DMF0049_GET_MEASURE 와 같은 원천·INSTR 필터)에 있는데
{I4}   GTT 에 없는 메저를 QTY '0' 으로 채운다. 위 [C20210125-000207] RTF_SYS_RP 0 행 삭제도 같은 지시로 비활성. 기존 2행 세트는 다음 저장 때 3행으로 복구. */
{I4}INSERT INTO SCM_MGR.GT_DMF0049_RESULTS_MST
{I4}    ( {cols}
{I4}    , MEASURE, QTY )
{I4}SELECT {sel}
{I4}     , M.COLUMN_NAME, '0'
{I4}  FROM ( SELECT {grp}
{I4}           FROM SCM_MGR.GT_DMF0049_RESULTS_MST B
{I4}          WHERE NVL(B.ACTIVE_FLAG, '-') <> 'D'
{I4}          GROUP BY {grp} ) S
{I4}  JOIN SCM_MST_SHEET_MEASURE M
{I4}    ON M.PROGRAM_ID = 'DMF0049'
{I4}   AND M.SHEET_NAME IN ( 'MDF Reports', 'mdfReports' )
{I4}   AND M.COLUMN_NAME IN ('SalesAmt_KRW', 'SalesAmt_LOC', 'RTF_SYS_RP')
{I4}   AND M.VALID_YN = 'Y'
{I4}   AND INSTR(M.DIVISION_ID, S.DIVISION_ID) > 0
{I4} WHERE NOT EXISTS ( SELECT 1 FROM SCM_MGR.GT_DMF0049_RESULTS_MST C
{I4}                     WHERE C.MEASURE = M.COLUMN_NAME
{nulleq} )
{I4}   -- 원장에 그 세트·월·메저가 이미 있으면 보충하지 않는다 (수정 경로에서 실제 값을 0 으로 덮지 않음 — GTT YYYYMMDD 는 이 시점 yyyymm)
{I4}   AND NOT EXISTS ( SELECT 1 FROM DM_PLN_SALES_ETC_REPORT_C A
{I4}                     WHERE S.DATA_SEQ IS NOT NULL
{I4}                       AND A.VERSION_NO = S.VERSION_NO
{I4}                       AND A.DIVISION_ID = NVL(S.DIVISION_ID, '-')
{I4}                       AND TO_CHAR(A.DATA_SEQ) = S.DATA_SEQ
{I4}                       AND A.MEASURE = M.COLUMN_NAME
{I4}                       AND SUBSTR(A.YYYYMMDD, 1, 6) = SUBSTR(S.YYYYMMDD, 1, 6) );

"""
new = list(L)
new[k_del] = f"{I4}--[{TAG}] 비활성 (사용자 지시 2026-09-30 — RTF_SYS_RP 0 행도 세트로 저장) : " + L[k_del].lstrip()
new[k_del + 1] = f"{I4}--[{TAG}] 비활성 : " + L[k_del + 1].lstrip()
new[k_anc:k_anc] = [block]
src1 = "".join(new)
chk = list(new); del chk[k_anc]
assert all(chk[i] == L[i] for i in range(len(L)) if i not in (k_del, k_del + 1)) and len(chk) == len(L)
assert src1.count(TAG) == 3
print(f"기준본 LAST_DDL={ddl0}  (a) L{k_del+1}~{k_del+2} 비활성  (b) L{k_anc+1} 앞 삽입 {block.count(chr(10))}줄")

now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
stamp = f"-- SOURCE-FRESH: SCM_MGR.{NAME} {TYP} LAST_DDL={ddl0} FETCHED={now} DB=ZIOUI1\n"
BAK.write_text(stamp + "-- 적용 전 원문\nCREATE OR REPLACE " + src0.rstrip() + "\n/\n", encoding="utf-8")
NEW.write_text(stamp + f"-- [{TAG}] PKG_DMF0049 BODY 전체본\nSET DEFINE OFF\nSET SQLBLANKLINES ON\nCREATE OR REPLACE " + src1.rstrip() + "\n/\nSHOW ERRORS PACKAGE BODY SCM_MGR.PKG_DMF0049\n", encoding="utf-8")
(HERE / "_change_preview.sql").write_text("".join(new[k_del - 1:k_del + 2]) + "\n...\n" + block, encoding="utf-8")
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
