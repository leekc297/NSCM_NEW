# -*- coding: utf-8 -*-
"""PKG_DMF0042.P_DMF0042_SAVE_DM_PLN_BP_FCST — 세트 첫 행이 오면 세트 전체를 0 으로 일괄 생성 [E20260930-DMF0042SETZERO]

사용자 결정 (2026-09-30): "FE 수정 없이 DB 단에서 — SET ROW 중 최초 ROW 가 들어오면 SET 전체를 0 으로 일괄 생성하고,
이후 실제 값이 들어오면 수정".
배경: TO-BE FE 는 바뀐 셀의 메저 1행만 보낸다(AS-IS 는 BP+LOC 2행 1조). SP 의 08-24 보충(L4356)은 Business_Plan 이 오면
원장 LOC 를 GTT 에 복사하지만 **신규 키는 원장에 짝이 없어** 복사할 게 없고, LOC INSERT(TMP.MEASURE='LOC' 조인)가
돌지 않아 SalesAmt_LOC/KRW/USD 가 파생되지 않는다(사내 실측: Peopleworks/202702 = LOC·SalesAmt 만, BP 없음).
조치 (기존 보충 INSERT 바로 뒤에 삽입만 — I/M 행만 대상, 'D' 제외, 모두 NOT EXISTS 가드):
  ② Business_Plan 이 왔는데 GTT·원장 어디에도 그 키·월의 LOC 가 없으면  → GTT 에 LOC = 0 행
  ④ LOC 가 왔는데 GTT·원장 어디에도 그 키·월의 Business_Plan 이 없으면 → GTT 에 Business_Plan = 0 행
  (①=기존: BP 가 오고 원장에 LOC 있으면 복사. LOC 가 오고 원장에 BP 있으면 → 파생이 원장 FCST 를 직접 읽으므로 보충 불요)
  이후 흐름 무수정: GTT BP/LOC → 원장 삽입(MEASURE·YYYYMM 키 삭제 후) → LOC INSERT 가 원장 BP × GTT LOC 로 SalesAmt_LOC,
  환율로 SalesAmt_KRW/USD 파생 → 세트(40: BP·LOC·SalesAmt_LOC·KRW·USD) 가 0 으로 함께 생성된다.
  키 정규화: 삽입 지점은 L4338 NVL 정규화 UPDATE 이후라 GTT 키는 원장('-')과 같은 표기.
FRESH-GATE: 지금 DB 원문 기준(오늘 17:07 KBJ 타작업자 수정본 위) · 적용 직전 재조회 일치 시에만 CREATE OR REPLACE. 삽입만, 기존 줄 1바이트 불변.
usage: python apply_setzero.py backup | apply | restore
"""
import datetime, io, pathlib, sys
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parents[1] / "_diagnostics"))
from ora import conn_info
import oracledb

MODE = sys.argv[1] if len(sys.argv) > 1 else "backup"
TAG = "E20260930-DMF0042SETZERO"
NAME, TYP = "PKG_DMF0042", "PACKAGE BODY"
BAK = HERE / "00_BACKUP_PKG_DMF0042_BODY.sql"
NEW = HERE / "01_PKG_DMF0042_BODY_SETZERO.sql"
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
ps = next(i for i, t in enumerate(L) if t.strip() == "PROCEDURE P_DMF0042_SAVE_DM_PLN_BP_FCST")
pe = next(i for i in range(ps + 1, len(L)) if L[i].strip().startswith("PROCEDURE "))
# 앵커: 기존 ① 보충 INSERT(2026.08.24 AJS) 의 끝 `, A.CELL_PROD_SITE;` 다음의 A002 로그 줄 직전
a1 = [i for i in range(ps, pe) if "2026.08.24 AJS 수량만 와도 금액을 만들 수 있게 LOC 단가를 원장에서 보완" in L[i]]
anchor = [i for i in range(ps, pe) if "V_PROGRAM_NAME || ' : A002-- :'" in L[i]]
assert len(a1) == 1 and len(anchor) == 1 and a1[0] < anchor[0], (a1, anchor)
k = anchor[0]
prev = next(i for i in range(k - 1, k - 5, -1) if L[i].strip())
assert L[prev].strip() == ", A.CELL_PROD_SITE;", L[prev]
assert "AND B.MEASURE = 'Business_Plan'" in "".join(L[a1[0]:k]) and "AND A.MEASURE = 'LOC'" in "".join(L[a1[0]:k])

COLS = ("ACTIVE_FLAG, DIVISION_ID, PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, FCST_TYPE, INCOTERMS, "
        "ITEM_USE, UNIT_ENERGY, MEASURE, YYYYMM, CURRENCY, QTY, DEPT_ID, END_CUSTOMER, BIZ_TYPE, CELL_PROD_SITE, CREATED_BY, LAST_UPDATED_BY")
KEYS = ["DIVISION_ID", "PROJECT_CODE", "SCM_SITE_ID", "PLANT_SITE_ID", "ITEM_ID", "FCST_TYPE", "INCOTERMS", "ITEM_USE",
        "UNIT_ENERGY", "YYYYMM", "CURRENCY", "DEPT_ID", "END_CUSTOMER", "BIZ_TYPE", "CELL_PROD_SITE"]
I8 = "        "


def arm(have, make, note):
    """GTT 에 `have` 메저(I/M)가 있는 키·월에 `make` 메저가 GTT·원장 어디에도 없으면 QTY 0 으로 GTT 에 만든다."""
    eq = lambda a, b: "\n".join(f"{I8}                  AND {a}.{c} = {b}.{c}" for c in KEYS)
    return f"""{I8}/*[{TAG}] {note} — 사용자 결정 2026-09-30 "세트 첫 행이 오면 세트 전체를 0 으로 일괄 생성, 이후 실제 값이 오면 수정".
{I8}   GTT 에 {have}(I/M) 가 있는 키·월에 {make} 가 GTT 에도 원장에도 없으면 {make} = 0 행을 GTT 에 만든다
{I8}   ('D' 행 제외 · 원장에 이미 있으면 그대로 둔다 = 실제 값 보존). 뒤의 원장 삽입·SalesAmt 파생은 무수정 */
{I8}INSERT /*+ NO_PARALLEL */
{I8}  INTO GT_SDPB2_BP_FCST_4
{I8}     ( {COLS} )
{I8}SELECT MAX(B.ACTIVE_FLAG), B.DIVISION_ID, B.PROJECT_CODE, MAX(B.PROJECT_NAME), B.SCM_SITE_ID, B.PLANT_SITE_ID, B.ITEM_ID
{I8}     , B.FCST_TYPE, B.INCOTERMS, B.ITEM_USE, B.UNIT_ENERGY, '{make}', B.YYYYMM, B.CURRENCY, 0
{I8}     , B.DEPT_ID, B.END_CUSTOMER, B.BIZ_TYPE, B.CELL_PROD_SITE, MAX(B.CREATED_BY), MAX(B.LAST_UPDATED_BY)
{I8}  FROM GT_SDPB2_BP_FCST_4 B
{I8} WHERE B.MEASURE = '{have}'
{I8}   AND B.ACTIVE_FLAG IN ('I', 'M')
{I8}   AND NOT EXISTS (SELECT 1 FROM GT_SDPB2_BP_FCST_4 C
{I8}                   WHERE C.MEASURE = '{make}'
{eq('C', 'B')})
{I8}   AND NOT EXISTS (SELECT 1 FROM DM_PLN_BP_FCST A
{I8}                   WHERE A.MEASURE = '{make}'
{eq('A', 'B')})
{I8} GROUP BY B.DIVISION_ID, B.PROJECT_CODE, B.SCM_SITE_ID, B.PLANT_SITE_ID, B.ITEM_ID, B.FCST_TYPE, B.INCOTERMS, B.ITEM_USE
{I8}        , B.UNIT_ENERGY, B.YYYYMM, B.CURRENCY, B.DEPT_ID, B.END_CUSTOMER, B.BIZ_TYPE, B.CELL_PROD_SITE;

"""


block = (arm("Business_Plan", "LOC", "② 수량(Business_Plan)만 온 신규 키·월 → LOC 0 생성")
         + arm("LOC", "Business_Plan", "④ 단가(LOC)만 온 신규 키·월 → Business_Plan 0 생성"))
new = L[:k] + [block] + L[k:]
src1 = "".join(new)
assert "".join(new[:k]) + "".join(new[k + 1:]) == src0 and src1.count(TAG) == 2
print(f"기준본 LAST_DDL={ddl0}  삽입 지점 L{k+1} (A002 로그 직전, ① 보충 INSERT 뒤)  삽입 {block.count(chr(10))}줄")

now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
stamp = f"-- SOURCE-FRESH: SCM_MGR.{NAME} {TYP} LAST_DDL={ddl0} FETCHED={now} DB=ZIOUI1\n"
BAK.write_text(stamp + "-- 적용 전 원문 (2026-09-30 17:07 KBJ 수정본)\nCREATE OR REPLACE " + src0.rstrip() + "\n/\n", encoding="utf-8")
NEW.write_text(stamp + f"-- [{TAG}] PKG_DMF0042 BODY 전체본 (삽입만)\nSET DEFINE OFF\nSET SQLBLANKLINES ON\nCREATE OR REPLACE " + src1.rstrip() + "\n/\nSHOW ERRORS PACKAGE BODY SCM_MGR.PKG_DMF0042\n", encoding="utf-8")
(HERE / "_insert_preview.sql").write_text(block, encoding="utf-8")
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
