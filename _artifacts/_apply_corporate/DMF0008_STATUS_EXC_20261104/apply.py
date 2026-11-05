# -*- coding: utf-8 -*-
"""GAP-138 보완 — PKG_DMF0008.P_DMF0008_STATUS_UPDATE 래퍼에 예외 처리 추가 (사내 ZIOUI1 · 2026-11-04)

결함: 래퍼에 EXCEPTION 이 없어 래퍼 안 오류(하위 PR_DM_DNM_EDI_CALLOFF_STATUS 무효 → ORA-06508 / 패키지 상태 ORA-04068 /
      로그 조회 오류 등)가 BE SqlException → HTTP 500(GlobalExceptionHandler.java:120-134) 으로 올라가고,
      FE 공통 응답 처리(axios-interceptors.ts:57-59)는 500 을 오류로 던지지 않아 화면이 「Status Update 완료」로 표시(검증 V-2ffa0a67).
보완: 래퍼 끝에 EXCEPTION WHEN OTHERS → 오류 로그(PR_SCM_SYS_LOG_BATCH) + 결과 커서 CODE '-1'·MSG=SQLERRM
      → 이미 PASS 확인된 CODE -1 경로(FE 인터셉터가 Error 로 던짐 → 화면 오류 알림, V-e65a425f)로 합류.
절차(hook #152): 착수 원문 조회·백업(00_BACKUP) → 외과 치환(고유 매칭 assert) → 01_PATCH 기록 → FRESH-GATE(적용 직전 재조회 == 착수본) → 적용 → USER_ERRORS 0 · STATUS VALID · LAST_DDL 갱신 확인.
  python -I _artifacts/_apply_corporate/DMF0008_STATUS_EXC_20261104/apply.py [--apply]
"""
import datetime, json, os, sys
sys.stdout.reconfigure(encoding='utf-8', errors='replace')
ROOT = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn'))
from dbconn import connect  # noqa: E402

HERE = os.path.dirname(os.path.abspath(__file__))
OWNER, NAME, TYP = 'SCM_MGR', 'PKG_DMF0008', 'PACKAGE BODY'
OLD = """        SELECT '-1' AS CODE, NVL(V_ERR_MSG, 'ERROR') AS MSG, '' AS EVENT FROM DUAL;
    END IF;
END P_DMF0008_STATUS_UPDATE;
"""
NEW = """        SELECT '-1' AS CODE, NVL(V_ERR_MSG, 'ERROR') AS MSG, '' AS EVENT FROM DUAL;
    END IF;
-- [E20261104-STATUSEXC] 2026.11.04 검증엔진 GAP-138 — 래퍼 안 오류(하위 프로시저 무효 ORA-06508 · ORA-04068 등)가
--   BE SQL 오류(HTTP 500)로 올라가면 화면이 「Status Update 완료」로 표시되던 결함. 오류를 CODE -1 결과로 돌려준다(FE 가 오류 알림).
EXCEPTION
    WHEN OTHERS THEN
        V_ERR_MSG := SUBSTR(SQLERRM, 1, 4000);
        BEGIN
            PR_SCM_SYS_LOG_BATCH('P_DMF0008_STATUS_UPDATE', 'ERROR', 0, SUBSTR(V_ERR_MSG, 1, 1000)
                               , SUBSTR('ERROR_LINE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 500), SYSDATE
                               , P_IN_PARA_DATA  => V_IN_PARA_DATA
                               , P_SQL_ERR_CODE  => TO_CHAR(SQLCODE)
                               , P_SQL_ERR_MSG   => V_ERR_MSG
                               , P_SQL_BACKTRACE => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        EXCEPTION WHEN OTHERS THEN NULL;  -- 로그 실패가 결과 반환을 막지 않게
        END;
        OPEN O_RESULT_CURSOR FOR
        SELECT '-1' AS CODE, V_ERR_MSG AS MSG, '' AS EVENT FROM DUAL;
END P_DMF0008_STATUS_UPDATE;
"""


def fetch(cur):
    cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'), STATUS FROM ALL_OBJECTS WHERE OWNER=:o AND OBJECT_NAME=:n AND OBJECT_TYPE=:t", o=OWNER, n=NAME, t=TYP)
    ddl, st = cur.fetchone()
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER=:o AND NAME=:n AND TYPE=:t ORDER BY LINE", o=OWNER, n=NAME, t=TYP)
    return ''.join(r[0] for r in cur.fetchall()), ddl, st


def as_ddl(body):
    return 'CREATE OR REPLACE ' + body.rstrip().rstrip(';') + ';'


def main():
    apply_ = '--apply' in sys.argv
    out = {}
    with connect('tobe', write=apply_) as cx:
        cur = cx.cursor()
        base, ddl0, st0 = fetch(cur)
        cur.execute("SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL"); at = cur.fetchone()[0]
        out['base'] = {'last_ddl': ddl0, 'status': st0, 'read_at': at, 'chars': len(base)}
        stamp = f'-- SOURCE-FRESH: {OWNER}.{NAME} ({TYP}) LAST_DDL {ddl0} · STATUS {st0} · 조회 {at} · 사내 ZIOUI1\n'
        open(os.path.join(HERE, '00_BACKUP_PKG_DMF0008_BODY.sql'), 'w', encoding='utf-8', newline='\n').write(stamp + as_ddl(base) + '\n/\n')
        n = base.count(OLD)
        if n != 1:
            out['err'] = f'대상 매칭 {n} ≠ 1 — 원문 변경 또는 이미 반영'; out['already'] = '[E20261104-STATUSEXC]' in base
            print(json.dumps(out, ensure_ascii=False)); return 3
        tobe = base.replace(OLD, NEW)
        open(os.path.join(HERE, '01_PATCH_PKG_DMF0008_BODY.sql'), 'w', encoding='utf-8', newline='\n').write(stamp + as_ddl(tobe) + '\n/\n')
        out['patch_lines'] = {'before': base.count('\n'), 'after': tobe.count('\n')}
        if not apply_:
            out['mode'] = 'dry (파일만 기록)'; print(json.dumps(out, ensure_ascii=False)); return 0
        now, ddl1, _ = fetch(cur)   # FRESH-GATE
        if now != base or ddl1 != ddl0:
            out['err'] = f'FRESH-GATE 실패 — 착수 후 원문 변경(LAST_DDL {ddl0}→{ddl1}) · 중단'; print(json.dumps(out, ensure_ascii=False)); return 4
        cur.execute(as_ddl(tobe))
        cur.execute("SELECT LINE, POSITION, TEXT FROM ALL_ERRORS WHERE OWNER=:o AND NAME=:n AND TYPE=:t ORDER BY SEQUENCE", o=OWNER, n=NAME, t=TYP)
        errs = cur.fetchall()
        _, ddl2, st2 = fetch(cur)
        out['applied'] = {'last_ddl': ddl2, 'status': st2, 'errors': [list(map(str, e)) for e in errs][:10], 'marker': '[E20261104-STATUSEXC]' in fetch(cur)[0]}
    print(json.dumps(out, ensure_ascii=False)); return 0 if not out['applied']['errors'] and out['applied']['status'] == 'VALID' else 5


if __name__ == '__main__':
    sys.exit(main())
