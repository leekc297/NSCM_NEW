# -*- coding: utf-8 -*-
"""키 범위 스냅샷·복원 — 자동 복원기(restore_touched)가 못 되살리는 '지우고 다시 넣기·삭제' 저장 시험용 (2026-11-04 · GAP-175)

  python -I tools/Harness/verify/keyset_guard.py backup  <SPEC.json> <SNAP.json>
  python -I tools/Harness/verify/keyset_guard.py restore <SPEC.json> <SNAP.json>
  python -I tools/Harness/verify/keyset_guard.py diff    <SPEC.json> <SNAP.json>     (현재 ↔ 스냅샷 차이만 보고 · 쓰기 없음)

SPEC = {"binds": {이름: 값}, "since": "YYYY-MM-DD HH24:MI:SS"(restore 때 purge 기준 · backup 시각 자동 기록),
        "tables": [{"name": "SCM_MGR.표", "where": "DIVISION_ID = :d AND ..."}],          ← 키 범위 전 행을 스냅샷·복원
        "purge":  [{"name": "SCM_MGR.이력표", "where": "... AND CREATED_BY = :u AND CREATION_DATE >= :since"}]}  ← 시험이 새로 넣은 행만 삭제
원칙: tables 의 where 는 저장 SP 가 지우거나 다시 넣는 범위를 '포함'해야 한다(넓으면 안전 · 좁으면 복원 누락).
restore = 표마다 where 범위 DELETE → 스냅샷 행 INSERT → purge → 같은 트랜잭션 COMMIT → 행 서명(전 칼럼) 대조(same).
"""
import datetime, json, sys
sys.stdout.reconfigure(encoding='utf-8', errors='replace')
import os
ROOT = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn'))


def _binds(spec, where):
    return {k: v for k, v in spec.get('binds', {}).items() if (':' + k) in where}


def _rows(cur, name, where, binds):
    cur.execute(f'SELECT * FROM {name} WHERE {where}', binds)
    cols = [d[0] for d in cur.description]
    types = {d[0]: d[1] for d in cur.description}
    return cols, types, [list(r) for r in cur.fetchall()]


def _sig(rows):
    return sorted(json.dumps([None if v is None else str(v) for v in r], ensure_ascii=False) for r in rows)


def main(act, spec_fp, snap_fp):
    from dbconn import connect
    spec = json.load(open(spec_fp, encoding='utf-8'))
    with connect('tobe', write=(act == 'restore')) as cx:
        cur = cx.cursor()
        if act == 'backup':
            cur.execute("SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL"); at = cur.fetchone()[0]
            out = {'at': at, 'tables': []}
            for t in spec['tables']:
                cols, _, rows = _rows(cur, t['name'], t['where'], _binds(spec, t['where']))
                out['tables'].append({'name': t['name'], 'cols': cols, 'rows': [[None if v is None else (v.isoformat(sep=' ') if isinstance(v, datetime.datetime) else v) for v in r] for r in rows]})
            json.dump(out, open(snap_fp, 'w', encoding='utf-8'), ensure_ascii=False, default=str)
            print(json.dumps({'ok': True, 'at': at, 'rows': {t['name']: len(t['rows']) for t in out['tables']}}, ensure_ascii=False)); return 0
        snap = json.load(open(snap_fp, encoding='utf-8'))
        binds_since = dict(spec.get('binds', {})); binds_since['since'] = snap['at']
        if act == 'diff':
            res = {}
            for t, s in zip(spec['tables'], snap['tables']):
                _, _, now = _rows(cur, t['name'], t['where'], _binds(spec, t['where']))
                a, b = _sig(now), _sig(s['rows'])
                res[t['name']] = {'now': len(now), 'snap': len(s['rows']), 'same': a == b}
            for pz in spec.get('purge', []):
                cur.execute(f"SELECT COUNT(*) FROM {pz['name']} WHERE {pz['where'].replace(':since', 'TO_DATE(:since,' + chr(39) + 'YYYY-MM-DD HH24:MI:SS' + chr(39) + ')')}", {k: v for k, v in binds_since.items() if (':' + k) in pz['where']})
                res[pz['name'] + ' (시험 신규)'] = {'now': cur.fetchone()[0]}
            print(json.dumps({'ok': True, 'diff': res}, ensure_ascii=False)); return 0
        if act == 'restore':
            res = {}
            for t, s in zip(spec['tables'], snap['tables']):
                assert t['name'] == s['name']
                cur.execute(f"SELECT COLUMN_NAME, DATA_TYPE FROM ALL_TAB_COLUMNS WHERE OWNER || '.' || TABLE_NAME = :n", n=t['name'].upper())
                typ = dict(cur.fetchall())
                cur.execute(f"DELETE FROM {t['name']} WHERE {t['where']}", _binds(spec, t['where'])); deleted = cur.rowcount
                cols = s['cols']
                for r in s['rows']:
                    vals = []
                    for c, v in zip(cols, r):
                        if v is not None and typ.get(c, '').startswith(('DATE', 'TIMESTAMP')):
                            v = datetime.datetime.fromisoformat(str(v))
                        vals.append(v)
                    cur.execute(f"INSERT INTO {t['name']} ({','.join(cols)}) VALUES ({','.join(':' + str(i) for i in range(len(cols)))})", vals)
                res[t['name']] = {'deleted': deleted, 'restored': len(s['rows'])}
            for pz in spec.get('purge', []):
                w = pz['where'].replace(':since', "TO_DATE(:since,'YYYY-MM-DD HH24:MI:SS')")
                cur.execute(f"DELETE FROM {pz['name']} WHERE {w}", {k: v for k, v in binds_since.items() if (':' + k) in pz['where']})
                res[pz['name'] + ' (purge)'] = {'deleted': cur.rowcount}
            cx.commit()
            same = True
            for t, s in zip(spec['tables'], snap['tables']):
                _, _, now = _rows(cur, t['name'], t['where'], _binds(spec, t['where']))
                ok = _sig(now) == _sig(s['rows']); res[t['name']]['same'] = ok; same = same and ok
            print(json.dumps({'ok': True, 'same': same, 'detail': res}, ensure_ascii=False, default=str)); return 0
    print(json.dumps({'ok': False, 'err': 'act = backup|restore|diff'})); return 2


if __name__ == '__main__':
    try:
        sys.exit(main(*sys.argv[1:4]))
    except Exception as e:
        print(json.dumps({'ok': False, 'err': str(e)[:400]}, ensure_ascii=False)); sys.exit(1)
