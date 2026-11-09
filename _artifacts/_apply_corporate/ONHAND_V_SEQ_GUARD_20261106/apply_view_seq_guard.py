# -*- coding: utf-8 -*-
"""사내오라클(ZIOUI1) 적용 — 재고 뷰 2종의 SEQ 변환 가드 (2026-11-06 · 차등 검증 W8-B 가 찾은 TO-BE 결함)
결함: SCP_PLN_SALES_ONHAND_V / SCP_OPT_PLANT_ONHAND_V 의 `TO_NUMBER(REGEXP_SUBSTR(A.OPT_PLAN_ID, '[^-]+$'))` 가 구포맷 ID(예 20260615_40_18650_004_S005)에서 ORA-01722.
      가드 `REGEXP_LIKE(REGEXP_SUBSTR(M.PLAN_ID,'[^-]+$'),'^[0-9]+$')` 는 M 에만 걸려 Oracle 평가 순서에 따라 A 의 TO_NUMBER 가 먼저 실행된다.
      → PKG_SCP0016.P_SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL(버전 SP_W_20260615) · 의존 객체 16개(PKG_SCP0010 · FN_GET_SCP_ANL_* · PR_SCP_ANL_PSI_*) 가 영향.
보완: 최신 원문 위 외과 치환 `TO_NUMBER(... DEFAULT NULL ON CONVERSION ERROR)` — 뷰 주석의 'TO_NUMBER 가드' 의도와 같음 · 변환 불가 행은 SEQ NULL(숫자 SEQ 와 매칭 안 됨 = 종전 가드 의도)
절차(hook #152 db-source-refresh-before-work): ① DBMS_METADATA 로 DB 원문 새로 조회(기준본·백업 .ASIS.sql) ② OLD 정확히 1회 매칭 assert ③ FRESH-GATE(적용 직전 재조회 == 기준본) ④ CREATE OR REPLACE
      ⑤ STATUS VALID · ALL_ERRORS 0 · 의존 INVALID 재컴파일 · 검증 질의(오류 값 조회) · LAST_DDL 갱신 확인 ⑥ 패키지 SQL(SOURCE-FRESH 스탬프) 기록
  python _artifacts/_apply_corporate/ONHAND_V_SEQ_GUARD_20261106/apply_view_seq_guard.py [--dry-run]
"""
import datetime, os, sys
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn')); import dbconn
VIEWS = ['SCP_PLN_SALES_ONHAND_V', 'SCP_OPT_PLANT_ONHAND_V']
OLD = "TO_NUMBER(REGEXP_SUBSTR(A.OPT_PLAN_ID, '[^-]+$'))"
NEW = "TO_NUMBER(REGEXP_SUBSTR(A.OPT_PLAN_ID, '[^-]+$') DEFAULT NULL ON CONVERSION ERROR)"
MARK = "/* 2026-11-06 W8 SEQ 변환 가드(ORA-01722 구포맷 ID) — DEFAULT NULL ON CONVERSION ERROR */"
BAD = '20260615_40_18650_004_S005'
EXPECTED = {'SCP_PLN_SALES_ONHAND_V': 1, 'SCP_OPT_PLANT_ONHAND_V': 2}  # 2026-11-06 22:1x 실측(DBMS_METADATA): PLANT 는 ID 문자열 조합(145행)과 SEQ CAST(150행) 두 곳 — 전부 가드
DRY = '--dry-run' in sys.argv


def fetch(cur, v):
    cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'), STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE='VIEW'", n=v)
    ddl_t, st = cur.fetchone()
    cur.execute("SELECT DBMS_METADATA.GET_DDL('VIEW', :n, 'SCM_MGR') FROM DUAL", n=v)
    d = cur.fetchone()[0]; d = d.read() if hasattr(d, 'read') else str(d)
    return d.rstrip().rstrip(';').rstrip(), ddl_t, st


def main():
    cfg = dbconn.load_cfg(); print('DB:', dbconn.describe('tobe', cfg))
    cx = dbconn.connect('tobe', cfg); cur = cx.cursor()
    cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST'), SYS_CONTEXT('USERENV','DB_NAME') FROM DUAL"); print('SERVER_HOST/DB:', cur.fetchone())
    now = datetime.datetime.now().strftime('%Y-%m-%d %H:%M')
    bdir = os.path.join(HERE, '00_BACKUP'); os.makedirs(bdir, exist_ok=True)
    base = {}
    for v in VIEWS:
        d, t, st = fetch(cur, v); base[v] = (d, t, st)
        open(os.path.join(bdir, f'{v}.ASIS.sql'), 'w', encoding='utf-8').write(f"-- SOURCE-FRESH: SCM_MGR.{v} VIEW LAST_DDL={t} FETCHED={now} DB=ZIOUI1 (착수 기준본 · 원복용)\n{d};\n")
        n = d.count(OLD)
        print(f'{v}: LAST_DDL={t} STATUS={st} · OLD 매칭 {n}회(기대 {EXPECTED[v]}) · 이미 반영 {"Y" if NEW in d else "N"}')
        assert n == EXPECTED[v], f'{v}: OLD 매칭 {n} ≠ 기대 {EXPECTED[v]} — 원문이 바뀌었거나 이미 반영됨(중단)'
    # 보고용: 오류 재현(적용 전)
    try:
        cur.execute(f"SELECT COUNT(*) FROM SCM_MGR.SCP_PLN_SALES_ONHAND_V WHERE SEQ = 0 AND PLAN_ID = '{BAD}'"); print('적용 전 검증 질의: 오류 없음(재현 안 됨)', cur.fetchone())
    except Exception as e:
        print('적용 전 검증 질의: 재현 →', str(e).splitlines()[0][:120])
    for v in VIEWS:
        d, t, st = base[v]
        tobe = d.replace(OLD, NEW + ' ' + MARK)
        sql_p = os.path.join(HERE, f'01_{v}.sql')
        open(sql_p, 'w', encoding='utf-8').write(f"-- SOURCE-FRESH: SCM_MGR.{v} VIEW LAST_DDL={t} FETCHED={now} DB=ZIOUI1\n-- 변경: {OLD} → {NEW}\n{tobe};\n")
        if DRY:
            print(f'[DRY] {v}: 적용 생략 → {os.path.relpath(sql_p, ROOT)}'); continue
        # FRESH-GATE: 적용 직전 DB 원문 재조회 == 착수 기준본
        now_d, now_t, _ = fetch(cur, v)
        assert now_d == d, f'FRESH-GATE 실패: {v} 착수 후 DB 원문 변경(LAST_DDL {t} → {now_t}) — 중단·재조회·재병합'
        cur.execute(tobe); cx.commit()
        cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'), STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE='VIEW'", n=v)
        print(f'{v}: 적용 완료 → LAST_DDL/STATUS {cur.fetchone()}')
        cur.execute("SELECT COUNT(*) FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME=:n", n=v); print(f'   ALL_ERRORS {cur.fetchone()[0]}')
        d2, _, _ = fetch(cur, v); print('   적용본 == DB 원문:', d2.count(NEW) == EXPECTED[v] and OLD not in d2)
    if DRY:
        cx.rollback(); cx.close(); return 0
    # 의존 객체 재컴파일·VALID 확인
    cur.execute("SELECT DISTINCT NAME, TYPE FROM ALL_DEPENDENCIES WHERE OWNER='SCM_MGR' AND REFERENCED_NAME IN ('SCP_PLN_SALES_ONHAND_V','SCP_OPT_PLANT_ONHAND_V')")
    deps = cur.fetchall(); inv = []
    for name, typ in deps:
        t2 = {'PACKAGE BODY': 'PACKAGE', 'TYPE BODY': 'TYPE'}.get(typ, typ)
        try:
            cur.execute(f'ALTER {t2} SCM_MGR.{name} COMPILE' + (' BODY' if typ == 'PACKAGE BODY' else ''))
        except Exception as e:
            print(f'   재컴파일 실패 {name}: {str(e)[:100]}')
    cur.execute("SELECT OBJECT_NAME, OBJECT_TYPE, STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME IN (" + ','.join(f"'{n}'" for n, _ in deps) + ") AND STATUS <> 'VALID'")
    inv = cur.fetchall(); print(f'의존 객체 {len(deps)}개 재컴파일 · INVALID {len(inv)}', inv[:8])
    # 검증 질의: 오류 값이 더 이상 ORA-01722 를 내지 않음
    for v in VIEWS:
        try:
            cur.execute(f"SELECT COUNT(*) FROM SCM_MGR.{v} WHERE SEQ IS NULL AND PLAN_ID LIKE '%' || :b || '%'", b=BAD); print(f'검증 {v}: 오류 없음 · SEQ NULL 행(구포맷·해당 PLAN_ID) {cur.fetchone()[0]}')
        except Exception as e:
            print(f'검증 {v}: 여전히 오류 → {str(e).splitlines()[0][:120]}')
    open(os.path.join(HERE, 'REPORT.md'), 'a', encoding='utf-8').write(f"\n## {now} 적용\n- DB ZIOUI1 · 뷰 2 · 의존 {len(deps)} 재컴파일 · INVALID {len(inv)}\n- 변경: `{OLD}` → `{NEW}`\n")
    cx.close(); return 0


if __name__ == '__main__':
    sys.exit(main())
