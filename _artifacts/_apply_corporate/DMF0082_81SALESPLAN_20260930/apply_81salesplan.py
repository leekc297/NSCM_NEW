# -*- coding: utf-8 -*-
"""[E20260930-DMF0082-81SP] DMF0082 81 저장 후속처리 누락 보완 — 사내 ZIOUI1 적용.

요구 (사용자 확정 2026-09-30):
  81 저장 = AS-IS DMF0003_SAVE_MKT_FCST 저장 후속처리 + TO-BE 가 81 에 연 SCM_FCST 는 AS-IS 40 의 Sales Plan 동기화.
  동기화 범위 = 40 과 동일 전체(MKT_FCST·SCM_FCST·RTF_SYS_RP 수량 + SalesAmt·MKT_AMT 금액) / 구현 위치 = 공용 SP 에 81 분기.

객체 2 (둘 다 '삽입만' — 기존 줄 1바이트 불변 assert):
  [A] PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_MKT_FCST_SAVE (공용 SP)
      IF (V_DIVISION_ID = '40') 블록 뒤에 ELSIF (SUBSTR(V_DIVISION_ID,1,2) = '81') 분기 추가 — T2 원천만 81 로:
        MKT_FCST·SCM_FCST = DM_PLN_MKT_FCST (CELL_PROD '-') / RTF_SYS_RP = DM_PLN_CFM_MKT_DEMAND_PLAN (CELL_PROD 실값)
        판가 = SCM_MST_FUTURE_PRICE — 배치 비-40 분기는 RTF 금액 조인에서 CELL_PROD 를 빼므로(LOCAL_KRW L411~442)
               T2 에 실재하는 셀생산지별로 판가 행을 복제해 공통부 조인(CELL_PROD 포함)과 등가화.
      공통부(SALES_PLAN_TEMP → DELETE/INSERT DM_PLN_SALES_PLAN)·40 분기 무수정.
  [B] PKG_DMF0082 BODY — P_DMF0082_SAVE_MAIN_DATA ■9 게이트 `IF v_is_81 = 'N' ... END IF` 에 ELSE 분기 추가:
        ① RMA → RTF_SYS_RP (AS-IS DMF0003 L2499~2591 = TO-BE PKG_DMF0003 L12055~12114 1:1, 결과 = GT_PRDM1_T_MAIN)
        ② PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE(division, 'CALL') (AS-IS DMF0003 L2595~2634 — 대상 GTT = GT_PRDM_SEND_TARGET_DATA)
        ③ GT_PRDM_RESULTS 적재 → [A] 호출 (40 전파 P_PR_DM_PLN_CFM_TO_MKT_FCST L15721~15771 동형, 81 키 = PROJECT_CODE)
FRESH-GATE: 두 객체 원문을 지금 DB 에서 읽고, 적용 직전 LAST_DDL·원문 재조회 일치 시에만 CREATE OR REPLACE. 실패 시 원복.
사용: python apply_81salesplan.py build | apply
"""
import datetime, io, pathlib, sys
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parents[1] / "_diagnostics"))
from ora import conn_info
import oracledb

MODE = sys.argv[1] if len(sys.argv) > 1 else "build"
MARK = "E20260930-DMF0082-81SP"
SP = "PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_MKT_FCST_SAVE"
u, p, d = conn_info()
cn = oracledb.connect(user=u, password=p, dsn=d)
cur = cn.cursor()


def last_ddl(name, typ):
    cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM USER_OBJECTS WHERE OBJECT_NAME=:1 AND OBJECT_TYPE=:2", [name, typ])
    return cur.fetchone()[0]


def lines(name, typ):
    cur.execute("SELECT TEXT FROM USER_SOURCE WHERE NAME=:1 AND TYPE=:2 ORDER BY LINE", [name, typ])
    return [t or "" for (t,) in cur]


def insert_after(src_lines, anchor_idx, new_text):
    return src_lines[:anchor_idx + 1] + [new_text] + src_lines[anchor_idx + 1:]


now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
BR_A = (HERE / "_branch_A_81.sql").read_text(encoding="utf-8").replace("{MARK}", MARK)
BR_B = (HERE / "_branch_B_81.sql").read_text(encoding="utf-8").replace("{MARK}", MARK)

# ====================================================================================== [A] 공용 SP
ddlA = last_ddl(SP, "PROCEDURE")
A = lines(SP, "PROCEDURE")
srcA = "".join(A)
assert MARK not in srcA, "[A] 이미 적용됨"
iA = [i for i, t in enumerate(A) if t.rstrip("\r\n") == "\tEND IF;" and "A00E--" in A[i - 1]]
assert len(iA) == 1, iA
iA = iA[0]
assert A[113].strip() == "IF (V_DIVISION_ID = '40') THEN" and iA == 255, (A[113], iA)
hA = [i for i, t in enumerate(A) if "[PJ202650304] NextSCM Migration" in t]
assert len(hA) == 1
newA = insert_after(A, iA - 1, BR_A)          # 40 블록 마지막 줄(A00E) 다음 · END IF 앞
newA = insert_after(newA, hA[0], f" * 2026.09.30\tadmin\t\t\t[{MARK}] 81 사업부 분기 추가 (DMF0082 81 저장 실시간 동기화 — 40 분기·공통부 무수정)\n")
assert [t for t in newA if t != BR_A and MARK not in t] == A, "[A] 기존 줄 변경 감지"
srcA_new = "".join(newA)

# ====================================================================================== [B] PKG_DMF0082 BODY
ddlB = last_ddl("PKG_DMF0082", "PACKAGE BODY")
B = lines("PKG_DMF0082", "PACKAGE BODY")
srcB = "".join(B)
assert MARK not in srcB, "[B] 이미 적용됨"
iB = [i for i, t in enumerate(B) if t.strip() == "P_PR_DM_PLN_CFM_TO_MKT_FCST(v_created_by, v_inner_result_cursor);"]
assert len(iB) == 1, iB
iB = iB[0]
assert B[iB - 5].strip() == "IF v_is_81 = 'N' THEN" and B[iB - 1].strip() == "COMMIT;" and B[iB + 1].strip() == "END IF;", B[iB - 5:iB + 2]
hB = [i for i, t in enumerate(B) if t.startswith(" * 2026.07.14") and "[DIV81] Division 81(LIKE '81%') 분기" in t]
assert len(hB) == 1, hB
newB = insert_after(B, iB, BR_B)             # P_PR_... 호출 줄 다음 · END IF 앞
newB = insert_after(newB, hB[0] + 1, f" * 2026.09.30\tadmin\t\t[{MARK}] 81 저장 후속처리 보완 — RMA→RTF · BALANCE_CREATE(CALL) · Sales Plan 동기화 (40 경로 무수정)\n")
assert [t for t in newB if t != BR_B and MARK not in t] == B, "[B] 기존 줄 변경 감지"
srcB_new = "".join(newB)
print(f"[A] {SP} LAST_DDL={ddlA} +{len(BR_A.splitlines()) + 1}줄  [B] PKG_DMF0082 BODY LAST_DDL={ddlB} +{len(BR_B.splitlines()) + 1}줄")

stampA = f"-- SOURCE-FRESH: SCM_MGR.{SP} PROCEDURE LAST_DDL={ddlA} FETCHED={now} DB=ZIOUI1\n"
stampB = f"-- SOURCE-FRESH: SCM_MGR.PKG_DMF0082 PACKAGE BODY LAST_DDL={ddlB} FETCHED={now} DB=ZIOUI1\n"
w = lambda n, s: (HERE / n).write_text(s, encoding="utf-8")
w("00_BACKUP_SALES_PLAN_SYNC_SP.sql", stampA + "-- 적용 전 원문\nCREATE OR REPLACE " + srcA.rstrip() + "\n/\n")
w("00_BACKUP_PKG_DMF0082_BODY.sql", stampB + "-- 적용 전 원문\nCREATE OR REPLACE " + srcB.rstrip() + "\n/\n")
w("01_SALES_PLAN_SYNC_SP_81.sql", stampA + f"-- [{MARK}] 공용 SP 81 분기 추가 (전체본)\nCREATE OR REPLACE " + srcA_new.rstrip() + "\n/\n")
w("02_PKG_DMF0082_BODY_81POST.sql", stampB + f"-- [{MARK}] PKG_DMF0082 BODY 전체본 (SAVE ■9 81 ELSE 분기)\nCREATE OR REPLACE " + srcB_new.rstrip() + "\n/\n")
w("99_ROLLBACK_SALES_PLAN_SYNC_SP.sql", stampA + f"-- [{MARK}] 원복\nCREATE OR REPLACE " + srcA.rstrip() + "\n/\n")
w("99_ROLLBACK_PKG_DMF0082_BODY.sql", stampB + f"-- [{MARK}] 원복\nCREATE OR REPLACE " + srcB.rstrip() + "\n/\n")
print("파일 생성 완료")


def compile_one(name, typ, new_src, old_src):
    cur.execute("CREATE OR REPLACE " + new_src.rstrip())
    cur.execute("SELECT STATUS FROM USER_OBJECTS WHERE OBJECT_NAME=:1 AND OBJECT_TYPE=:2", [name, typ])
    st = cur.fetchone()[0]
    cur.execute("SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME=:1 AND TYPE=:2 ORDER BY SEQUENCE", [name, typ])
    errs = cur.fetchall()
    print(f"  {name} {typ}: STATUS={st} 오류={len(errs)} LAST_DDL={last_ddl(name, typ)}")
    if st != "VALID" or errs:
        for e in errs[:15]:
            print("    ERR", e)
        cur.execute("CREATE OR REPLACE " + old_src.rstrip())
        print("  ⚠ 원복 완료")
        return False
    return True


if MODE == "apply":
    # FRESH-GATE — 실행 직전 두 객체 원문 재조회 일치 확인
    assert last_ddl(SP, "PROCEDURE") == ddlA and "".join(lines(SP, "PROCEDURE")) == srcA, "FRESH-GATE [A] 변경 감지"
    assert last_ddl("PKG_DMF0082", "PACKAGE BODY") == ddlB and "".join(lines("PKG_DMF0082", "PACKAGE BODY")) == srcB, "FRESH-GATE [B] 변경 감지"
    if not compile_one(SP, "PROCEDURE", srcA_new, srcA):
        sys.exit(1)
    if not compile_one("PKG_DMF0082", "PACKAGE BODY", srcB_new, srcB):
        compile_one(SP, "PROCEDURE", srcA, srcA)   # A 도 원복 (한 세트)
        sys.exit(1)
    print("적용 완료 — 마커:",
          "".join(lines(SP, "PROCEDURE")).count(MARK), "/", "".join(lines("PKG_DMF0082", "PACKAGE BODY")).count(MARK))
cn.close()
