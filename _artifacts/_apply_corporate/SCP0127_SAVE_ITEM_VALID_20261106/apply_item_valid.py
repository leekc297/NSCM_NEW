# -*- coding: utf-8 -*-
"""사내오라클(ZIOUI1) 적용 — PKG_SCP0127.P_SCP0127_SAVE_PRECEDE_SAFETY_STOCK_DAY 품목(ITEM_ID) 유효성 검증 추가 (2026-11-06 · CheckList E7 EG-629cff83 · 사용자 판정 3-b 오류)
결함: 팝업(FPTextModal) 셀 ITEM_ID 에 Key-in 한 잘못된 값이 메시지 없이 저장 요청에 실려 저장된다.
      AS-IS SaveData(.cs:726-735)는 dsSearchInfo.Tables[5](= SEARCH_INFO 6번 커서: SCM_MST_ITEM_SN ∪ SCP_OPMZ_VIRTUAL_BOM.ITEM_ID_CHILD)에 없는 ITEM_ID 면 MSG00458 을 띄우고 저장을 중단한다.
      TO-BE FE(precedeSafetyStockDaySaveValidation.ts:65-69)는 "실제 존재 검증은 SP 응답으로만 최종 확정" 이라 적어 두고 SP 에는 검증이 없다(2026-11-06 23:0x ALL_SOURCE 실측).
보완(DB 객체 우선 · DB MODE): SAVE SP 의 행 루프에서 삭제가 아닌 행마다 ITEM_ID 가 (SCM_MST_ITEM_SN ∪ SCP_OPMZ_VIRTUAL_BOM) 의 그 사업부 품목인지 확인하고 없으면
      RAISE_APPLICATION_ERROR(-20010, 'MODEL: <ITEM_ID>' || CHR(10) || '유효하지 않은 모델입니다!') — SCM_ADM_MSG_M MSG00458(KO) 문구 · 같은 SP 의 기존 오류 방식(-20010 한글 리터럴)과 동일.
      FE 사전 검증(AS-IS 동일 동작)은 별도 가이드(Doc/gen/SCP0127/E7_FE_GUIDE.md · DB MODE 라 직접 수정 안 함).
절차(hook #152 db-source-refresh-before-work): ① ALL_SOURCE 로 DB 원문 새로 조회(기준본·백업 .ASIS.sql) ② OLD 정확히 1회 매칭 assert ③ FRESH-GATE(적용 직전 재조회 == 기준본) ④ CREATE OR REPLACE PACKAGE BODY
      ⑤ STATUS VALID · ALL_ERRORS 0 · 의존 재컴파일 INVALID 0 · 검증 호출(잘못된 ITEM_ID 1행 → ORA-20010 MODEL · 트랜잭션 ROLLBACK) · LAST_DDL 갱신 확인 ⑥ 패키지 SQL(SOURCE-FRESH 스탬프) 기록
  python _artifacts/_apply_corporate/SCP0127_SAVE_ITEM_VALID_20261106/apply_item_valid.py [--dry-run]
"""
import datetime, os, sys
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn')); import dbconn
import oracledb
PKG = 'PKG_SCP0127'
DRY = '--dry-run' in sys.argv

OLD_DECL = """    V_CNT               NUMBER(10) := 0;

    V_PROGRAM_NAME      VARCHAR2(150 CHAR) := 'SCP0127_SAVE_PRECEDE_SAFETY_STOCK_DAY';"""
NEW_DECL = """    V_CNT               NUMBER(10) := 0;
    V_ITEM_CNT          NUMBER(10) := 0;   /* 2026-11-06 E7 품목 유효성(MSG00458) */

    V_PROGRAM_NAME      VARCHAR2(150 CHAR) := 'SCP0127_SAVE_PRECEDE_SAFETY_STOCK_DAY';"""
OLD_CHK = """        /* 삭제가 아닌 경우 중복 확인 */
        IF V_ACTIVE_FLAG <> 'D'
        THEN
"""
NEW_CHK = """        /* 삭제가 아닌 경우 중복 확인 */
        IF V_ACTIVE_FLAG <> 'D'
        THEN

            /* 2026-11-06 E7(CR-089 · AS-IS SaveData .cs:726-735 MSG00458): 품목 유효성 — SEARCH_INFO 6번 커서(품목 원장 ∪ 가상 BOM)에 없는 ITEM_ID 는 저장 거부 */
            SELECT COUNT(*)
              INTO V_ITEM_CNT
              FROM DUAL
             WHERE EXISTS (SELECT 1
                             FROM SCM_MST_ITEM_SN A
                            WHERE A.DIVISION_ID = V_DIVISION_ID
                              AND A.ITEM_ID     = V_ITEM_ID)
                OR EXISTS (SELECT 1
                             FROM SCP_OPMZ_VIRTUAL_BOM A
                            WHERE A.DIVISION_ID   = V_DIVISION_ID
                              AND A.ITEM_ID_CHILD = V_ITEM_ID);

            IF V_ITEM_CNT = 0
            THEN
                RAISE_APPLICATION_ERROR(-20010, 'MODEL: ' || V_ITEM_ID || CHR(10) || '유효하지 않은 모델입니다!');   /* MSG00458 */
            END IF;
"""


def fetch(cur):
    cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'), STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE='PACKAGE BODY'", n=PKG)
    ddl_t, st = cur.fetchone()
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE='PACKAGE BODY' ORDER BY LINE", n=PKG)
    src = ''.join(r[0] or '' for r in cur.fetchall())
    return src, ddl_t, st


def main():
    cfg = dbconn.load_cfg(); print('DB:', dbconn.describe('tobe', cfg))
    cx = dbconn.connect('tobe', cfg); cur = cx.cursor()
    cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST'), SYS_CONTEXT('USERENV','DB_NAME') FROM DUAL"); print('SERVER_HOST/DB:', cur.fetchone())
    now = datetime.datetime.now().strftime('%Y-%m-%d %H:%M')
    bdir = os.path.join(HERE, '00_BACKUP'); os.makedirs(bdir, exist_ok=True)
    base, t, st = fetch(cur)
    open(os.path.join(bdir, f'{PKG}_BODY.ASIS.sql'), 'w', encoding='utf-8').write(f"-- SOURCE-FRESH: SCM_MGR.{PKG} PACKAGE BODY LAST_DDL={t} FETCHED={now} DB=ZIOUI1 (착수 기준본 · 원복용)\nCREATE OR REPLACE {base}\n/\n")
    print(f'{PKG} BODY: LAST_DDL={t} STATUS={st} · 줄 {base.count(chr(10))} · OLD_DECL {base.count(OLD_DECL)}회 · OLD_CHK {base.count(OLD_CHK)}회 · 이미 반영 {"Y" if "V_ITEM_CNT" in base else "N"}')
    assert 'V_ITEM_CNT' not in base, '이미 반영됨(중단)'
    assert base.count(OLD_DECL) == 1 and base.count(OLD_CHK) == 1, 'OLD 매칭 != 1 — 원문이 바뀜(중단)'
    tobe = base.replace(OLD_DECL, NEW_DECL).replace(OLD_CHK, NEW_CHK)
    ddl = 'CREATE OR REPLACE ' + tobe
    sql_p = os.path.join(HERE, f'01_{PKG}_BODY.sql')
    open(sql_p, 'w', encoding='utf-8').write(f"-- SOURCE-FRESH: SCM_MGR.{PKG} PACKAGE BODY LAST_DDL={t} FETCHED={now} DB=ZIOUI1\n-- 변경: SAVE 행 루프(삭제 제외)에 ITEM_ID 유효성(SCM_MST_ITEM_SN ∪ SCP_OPMZ_VIRTUAL_BOM) → RAISE -20010 MSG00458\n{ddl}\n/\n")
    if DRY:
        print(f'[DRY] 적용 생략 → {os.path.relpath(sql_p, ROOT)}'); cx.rollback(); cx.close(); return 0
    # FRESH-GATE: 적용 직전 DB 원문 재조회 == 착수 기준본
    now_src, now_t, _ = fetch(cur)
    assert now_src == base, f'FRESH-GATE 실패: 착수 후 DB 원문 변경(LAST_DDL {t} → {now_t}) — 중단·재조회·재병합'
    cur.execute(ddl); cx.commit()
    cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'), STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE='PACKAGE BODY'", n=PKG)
    print(f'적용 완료 → LAST_DDL/STATUS {cur.fetchone()}')
    cur.execute("SELECT LINE, POSITION, TEXT FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME=:n ORDER BY SEQUENCE", n=PKG); errs = cur.fetchall(); print(f'ALL_ERRORS {len(errs)}', errs[:5])
    src2, _, _ = fetch(cur); print('적용본 == DB 원문:', src2 == tobe)
    # 의존 객체 재컴파일
    cur.execute("SELECT DISTINCT NAME, TYPE FROM ALL_DEPENDENCIES WHERE OWNER='SCM_MGR' AND REFERENCED_NAME=:n AND NAME<>:n", n=PKG); deps = cur.fetchall()
    for name, typ in deps:
        t2 = {'PACKAGE BODY': 'PACKAGE', 'TYPE BODY': 'TYPE'}.get(typ, typ)
        try: cur.execute(f'ALTER {t2} SCM_MGR.{name} COMPILE' + (' BODY' if typ == 'PACKAGE BODY' else ''))
        except Exception as e: print(f'   재컴파일 실패 {name}: {str(e)[:100]}')
    inv = []
    if deps:
        cur.execute("SELECT OBJECT_NAME, OBJECT_TYPE, STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME IN (" + ','.join(f"'{n}'" for n, _ in deps) + ") AND STATUS <> 'VALID'"); inv = cur.fetchall()
    print(f'의존 객체 {len(deps)}개 재컴파일 · INVALID {len(inv)}', inv[:8])
    # 검증 호출: 잘못된 ITEM_ID 1행(I) → ORA-20010 MODEL … · 어떤 DML 전에 RAISE 되므로 변경 0 · 그래도 ROLLBACK
    args = {'P_ACTIVE_FLAG': 'I', 'P_VALUE_TYPE': 'MIN', 'P_DIVISION_ID': '40', 'P_OPMZ_PLAN_GR_ID': 'PG0014', 'P_SCM_SITE_ID': 'ZZ_E2E', 'P_ITEM_ID': 'ZZ_E2E_BAD_KEY', 'P_STAGE': 'ZZ', 'P_FROM_YYYYMMDD': '20990101', 'P_TO_YYYYMMDD': '20990102',
            'P_TYPE_APPLY_DAY': '1', 'P_VALUE_DESCRIPTION': 'e2e', 'P_VALID_YN': 'Y', 'P_PRE_VALUE_TYPE': '', 'P_PRE_DIVISION_ID': '', 'P_PRE_OPMZ_PLAN_GR_ID': '', 'P_PRE_SCM_SITE_ID': '', 'P_PRE_ITEM_ID': '', 'P_PRE_STAGE': '', 'P_PRE_FROM_YYYYMMDD': '', 'P_PRE_TO_YYYYMMDD': ''}
    cur.execute("SELECT ARGUMENT_NAME, DATA_TYPE, IN_OUT FROM ALL_ARGUMENTS WHERE OWNER='SCM_MGR' AND PACKAGE_NAME=:p AND OBJECT_NAME='P_SCP0127_SAVE_PRECEDE_SAFETY_STOCK_DAY' AND DATA_LEVEL=0 ORDER BY POSITION", p=PKG)
    sig = cur.fetchall(); print('SAVE 서명', len(sig), [s[0] for s in sig])
    binds = {}
    for an, dt, io in sig:
        if io != 'IN': binds[an] = cur.var(oracledb.CURSOR)
        elif an in args: binds[an] = args[an]
        elif an == 'P_USER_ID': binds[an] = 'e2e_verify'
        else: binds[an] = ''
    call = f"BEGIN SCM_MGR.{PKG}.P_SCP0127_SAVE_PRECEDE_SAFETY_STOCK_DAY({', '.join(f'{k} => :{k}' for k in binds)}); END;"
    cur.execute("SELECT COUNT(*) FROM SCM_MGR.SCP_OPMZ_PRECEDE_SAFETY_STOCK_DAY"); n0 = cur.fetchone()[0]
    try:
        cur.execute(call, binds); print('검증 호출: 예외 없음(기대와 다름) — OUT 커서 확인 필요')
        for k, v in binds.items():
            if hasattr(v, 'getvalue'):
                rs = v.getvalue()
                try: print('  ', k, rs.fetchall()[:3])
                except Exception: pass
    except Exception as e:
        print('검증 호출(잘못된 ITEM_ID): →', str(e).splitlines()[0][:160])
    cx.rollback()
    cur.execute("SELECT COUNT(*) FROM SCM_MGR.SCP_OPMZ_PRECEDE_SAFETY_STOCK_DAY"); n1 = cur.fetchone()[0]; print(f'테이블 행수 전/후 {n0}/{n1}')
    open(os.path.join(HERE, 'REPORT.md'), 'a', encoding='utf-8').write(f"\n## {now} 적용\n- DB ZIOUI1 · {PKG} PACKAGE BODY · ALL_ERRORS {len(errs)} · 의존 {len(deps)} 재컴파일 · INVALID {len(inv)} · 테이블 행수 전/후 {n0}/{n1}\n- 변경: SAVE 행 루프(삭제 제외) ITEM_ID 유효성 → RAISE -20010 'MODEL: <ITEM_ID>\\n유효하지 않은 모델입니다!'(MSG00458)\n")
    cx.close(); return 0


if __name__ == '__main__':
    sys.exit(main())
