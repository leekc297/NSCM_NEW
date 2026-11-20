# -*- coding: utf-8 -*-
"""GAP-267 Set Price(DMF0042 · Div 40) 1회 실측 + 자동 복원 — 사용자 직접 실행용 (2026-11-04)

  python -I tools/Harness/verify/gap267_setprice_run.py            (실행)
  python -I tools/Harness/verify/gap267_setprice_run.py --dry      (사전 측정만 · 쓰기 없음)

왜 사용자 실행인가: Claude Code 자동 권한 판정이 운영(사내) BP 원장 대량 재계산을 '공유 자원 변경'으로 차단(11-04 18:1x·20:4x).
순서:
  1) 사전: DB 시각 T · AS-IS 계산식 불일치 수(SalesAmt_X = 단가 X × Business_Plan, 허용 0.0005·|Q|+0.01) · 대상 4 Measure 행 수
  2) 직전 백업: SCM_MGR.ZV_BPFCST40_SP_<T> = Div 40 · MEASURE IN (KRW,USD,SalesAmt_KRW,SalesAmt_USD) (Set Price MERGE 대상 · PKG_DMF0042 3419-3423·3554-3660)
  3) 화면 실행: 시나리오 'zz실측 Set Price 실행'(정기 체인 제외 · 실행 뒤 행 제거) — Playwright · 계정 Div=40 DM Admin
  4) 사후: 불일치 수 · SYSTEM 이 T 이후 바꾼 행 수(갱신/신규) · 백업 행 소실 수(MERGE 는 DELETE 없음 → 0 기대)
  5) 복원: T 이후 SYSTEM 갱신 4 Measure 행 — 백업에 있는 키 = 백업 값으로 MERGE UPDATE · 없는 키(신규) = DELETE → COMMIT
  6) 복원 대조: 대상 범위 현재 ↔ 백업 차이 0 기대
판정: PASS = 사후 불일치 0 · 소실 0 (AS-IS 계산식대로 금액 재계산) / 그 외 FAIL · 결과 JSON 은 Doc/verify/DMF0042/gap267_setprice_<T>.json
"""
import datetime, json, os, subprocess, sys
sys.stdout.reconfigure(encoding='utf-8', errors='replace')
ROOT = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn'))
from dbconn import connect  # noqa: E402

T_LEDGER = 'SCM_MGR.DM_PLN_BP_FCST'
MEAS = "('KRW','USD','SalesAmt_KRW','SalesAmt_USD')"
KEYS = ['DIVISION_ID', 'PROJECT_CODE', 'SCM_SITE_ID', 'ITEM_ID', 'FCST_TYPE', 'MEASURE', 'PLANT_SITE_ID', 'DEPT_ID', 'END_CUSTOMER',
        'BIZ_TYPE', 'YYYYMM', 'CURRENCY', 'ITEM_USE', 'UNIT_ENERGY', 'INCOTERMS', 'CELL_PROD_SITE']
NONKEY = ['DOM_EXP', 'PROJECT_NAME', 'QTY', 'CELL_PER_PACK', 'CELL_PER_MODULE', 'MODULE_PER_PACK', 'CREATED_BY', 'CREATION_DATE',
          'LAST_UPDATED_BY', 'LAST_UPDATE_DATE'] + [f'ATTRIBUTE{i}' for i in range(1, 11)]
ON = lambda a, b: ' AND '.join(f'{a}.{k} = {b}.{k}' for k in KEYS)  # noqa: E731
SCN = 'DMF0042,zz실측 Set Price 실행,"search;srvguard:Set Price|SELECT 0 FROM DUAL|@resp:.",,,,M2,GAP-267 실측(gap267_setprice_run.py · 정기 체인 제외),Div=40;DM Admin'


def mismatch(cur):
    k15 = [k for k in KEYS if k != 'MEASURE']
    on = lambda x: ' AND '.join(f'S.{k} = {x}.{k}' for k in k15)  # noqa: E731
    out = {}
    for m in ('KRW', 'USD'):
        cur.execute(f"""SELECT COUNT(*), SUM(CASE WHEN ABS(S.QTY - P.QTY*Q.QTY) > 0.0005*ABS(Q.QTY)+0.01 THEN 1 ELSE 0 END)
              FROM {T_LEDGER} S JOIN {T_LEDGER} P ON {on('P')} AND P.MEASURE = '{m}' JOIN {T_LEDGER} Q ON {on('Q')} AND Q.MEASURE = 'Business_Plan'
             WHERE S.DIVISION_ID = '40' AND S.MEASURE = 'SalesAmt_{m}'""")
        n, bad = cur.fetchone(); out[m] = {'rows': int(n or 0), 'mismatch': int(bad or 0)}
    return out


def scenario(add):
    p = os.path.join(ROOT, 'Doc', 'verify', 'scenario_expect.csv')
    raw = open(p, encoding='utf-8-sig', newline='').read(); nl = '\r\n' if '\r\n' in raw else '\n'
    lines = [l for l in raw.split(nl) if l and 'zz실측 Set Price' not in l]
    if add: lines.append(SCN)
    open(p, 'w', encoding='utf-8-sig', newline='').write(nl.join(lines) + nl)
    subprocess.run([sys.executable, '-I', os.path.join(ROOT, 'tools', 'Harness', 'verify', 'ledger.py'), 'DMF0042'], capture_output=True)


def main():
    dry = '--dry' in sys.argv
    res = {'ok': False}
    with connect('tobe', write=not dry) as cx:
        cur = cx.cursor()
        cur.execute("SELECT TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS'), TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL"); tag, t0 = cur.fetchone()
        res.update(t0=t0, pre=mismatch(cur))
        cur.execute(f"SELECT COUNT(*) FROM {T_LEDGER} WHERE DIVISION_ID = '40' AND MEASURE IN {MEAS}"); res['scope_rows'] = cur.fetchone()[0]
        print(json.dumps({'step': 'pre', **res}, ensure_ascii=False), flush=True)
        if dry: return 0
        bk = f'SCM_MGR.ZV_BPFCST40_SP_{tag}'
        cur.execute(f"CREATE TABLE {bk} AS SELECT * FROM {T_LEDGER} WHERE DIVISION_ID = '40' AND MEASURE IN {MEAS}")
        cur.execute(f'SELECT COUNT(*) FROM {bk}'); res['backup'] = {'table': bk, 'rows': cur.fetchone()[0]}
        print(json.dumps({'step': 'backup', **res['backup']}, ensure_ascii=False), flush=True)
        # 3) 화면 실행
        S = os.path.join(ROOT, 'Doc', 'verify', 'DMF0042', f'gap267_{tag}'); os.makedirs(S, exist_ok=True)
        env = dict(os.environ, SCN_ONLY='zz실측 Set Price', VERIFY_ID='DMF0042', CL_SELFTEST_BASE='1', CL_RESULTS=os.path.join(S, 'cl.json'), E2E_RESULTS=S)
        try:
            scenario(True)
            e2e = os.path.join(ROOT, 'tools', 'E2E')
            pr = subprocess.run(['node', os.path.join(e2e, 'node_modules', '@playwright', 'test', 'cli.js'), 'test', '_verify', '--grep', '문서 시나리오', '--workers', '1', '--retries', '0'],
                                cwd=e2e, env=env, capture_output=True, text=True, encoding='utf-8', errors='replace', timeout=1800)
            res['playwright_rc'] = pr.returncode
            try:
                d = json.load(open(os.path.join(S, 'cl.json'), encoding='utf-8')); rs = d if isinstance(d, list) else d.get('results', [])
                res['screen'] = [{'row_id': r['row_id'], 'result': r['result'], 'evidence': r['evidence'][:1200]} for r in rs if 'Set Price' in r['evidence']]
            except Exception as e:  # noqa: BLE001
                res['screen'] = f'결과 파일 없음: {e}'
        finally:
            scenario(False)
        print(json.dumps({'step': 'screen', 'rc': res.get('playwright_rc'), 'screen': res.get('screen')}, ensure_ascii=False)[:1500], flush=True)
        # 4) 사후
        res['post'] = mismatch(cur)
        tb = f"TO_DATE('{t0}','YYYY-MM-DD HH24:MI:SS')"
        scope = f"A.DIVISION_ID = '40' AND A.LAST_UPDATED_BY = 'SYSTEM' AND A.LAST_UPDATE_DATE >= {tb} AND A.MEASURE IN {MEAS}"
        cur.execute(f"SELECT SUM(CASE WHEN EXISTS (SELECT 1 FROM {bk} B WHERE {ON('A','B')}) THEN 1 ELSE 0 END), SUM(CASE WHEN NOT EXISTS (SELECT 1 FROM {bk} B WHERE {ON('A','B')}) THEN 1 ELSE 0 END) FROM {T_LEDGER} A WHERE {scope}")
        upd, ins = cur.fetchone(); res['touched'] = {'updated': int(upd or 0), 'inserted': int(ins or 0)}
        cur.execute(f"SELECT COUNT(*) FROM {bk} B WHERE NOT EXISTS (SELECT 1 FROM {T_LEDGER} A WHERE {ON('A','B')})"); res['lost'] = cur.fetchone()[0]
        res['verdict'] = 'PASS' if res['post']['KRW']['mismatch'] == 0 and res['post']['USD']['mismatch'] == 0 and res['lost'] == 0 and (res['touched']['updated'] + res['touched']['inserted']) > 0 else 'FAIL'
        print(json.dumps({'step': 'post', 'post': res['post'], 'touched': res['touched'], 'lost': res['lost'], 'verdict': res['verdict']}, ensure_ascii=False), flush=True)
        # 5) 복원
        setc = ', '.join(f'A.{c} = B.{c}' for c in NONKEY)
        cur.execute(f"MERGE INTO {T_LEDGER} A USING {bk} B ON ({ON('A','B')}) WHEN MATCHED THEN UPDATE SET {setc} WHERE {scope}")
        r_upd = cur.rowcount
        cur.execute(f"DELETE FROM {T_LEDGER} A WHERE {scope} AND NOT EXISTS (SELECT 1 FROM {bk} B WHERE {ON('A','B')})")
        r_del = cur.rowcount
        cx.commit()
        res['restore'] = {'merged': r_upd, 'deleted': r_del}
        # 6) 복원 대조 — 백업 ↔ 현재(대상 범위) 차이
        cmp_cols = ' AND '.join(f"DECODE(A.{c}, B.{c}, 1, 0) = 1" for c in NONKEY if c not in ('CREATION_DATE',))
        cur.execute(f"SELECT COUNT(*) FROM {bk} B WHERE NOT EXISTS (SELECT 1 FROM {T_LEDGER} A WHERE {ON('A','B')} AND {cmp_cols})"); diff_b = cur.fetchone()[0]
        cur.execute(f"SELECT COUNT(*) FROM {T_LEDGER} A WHERE A.DIVISION_ID = '40' AND A.MEASURE IN {MEAS} AND NOT EXISTS (SELECT 1 FROM {bk} B WHERE {ON('A','B')})"); extra = cur.fetchone()[0]
        res['restore_check'] = {'backup_rows_not_identical': diff_b, 'rows_not_in_backup': extra, 'same': diff_b == 0 and extra == 0,
                                'note': '0 이 아니면 T 이후 다른 사용자 저장분일 수 있음 — LAST_UPDATED_BY 로 확인'}
        res['after_restore'] = mismatch(cur)
        res['ok'] = True
    fp = os.path.join(ROOT, 'Doc', 'verify', 'DMF0042', f'gap267_setprice_{tag}.json')
    json.dump(res, open(fp, 'w', encoding='utf-8'), ensure_ascii=False, indent=1, default=str)
    print(json.dumps({'step': 'done', 'verdict': res.get('verdict'), 'restore': res.get('restore'), 'restore_check': res.get('restore_check'), 'file': fp}, ensure_ascii=False), flush=True)
    return 0


if __name__ == '__main__':
    try:
        sys.exit(main())
    except Exception as e:  # noqa: BLE001
        print(json.dumps({'ok': False, 'err': str(e)[:600]}, ensure_ascii=False)); sys.exit(1)
