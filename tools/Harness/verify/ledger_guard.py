"""정합검증 CRUD 실제 저장 안전장치 — 저장 직전 빈 키 확인 · 공유 마스터 스냅샷 기록(2026-10-24)

  python tools/Harness/verify/ledger_guard.py check  <MENU_ID> '<JSON {"DIVISION_ID":"40",...}>'   → stdout JSON {ok, free, why, counts}
  python tools/Harness/verify/ledger_guard.py record <MENU_ID> '<JSON 같은 키>'                    → Doc/verify/<ID>/crud_keys.json 에 키·저장 시각·스냅샷 추가

정의 = cleanup_spec.json 의 "<MENU_ID>": {"mode": "keyset", "keys": [...], "tables": [...], "allow": {"DIVISION_ID": ["40"]}, "snapshot": [...]}
원칙(메모리 '사내 E2E = 원장에 없는 (키, 기간)만' · 사용자 지시 2026-10-23 CRUD 실제 저장):
  · free = 저장이 쓰는 모든 테이블에 그 키(keys 전부 일치) 행이 0건 — 그래야 저장 후 그 키의 행 = 전부 E2E 가 만든 행(정리 범위가 정확)
  · allow 밖 값(예 DMF0005 Div 81 = 저장 중 ERP 인터페이스 전송 · 되돌릴 수 없음)이면 free=false
  · snapshot = 저장이 갱신하는 공유 마스터 행(예 SCM_MST_SITE.ETL_DEPT_ID)을 저장 전에 떠 둔다 → cleanup_marker.py 가 원복
"""
import datetime
import json
import os
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn'))
from dbconn import connect  # noqa: E402

SPEC = os.path.join(os.path.dirname(__file__), 'cleanup_spec.json')


def spec_of(mid):
    s = json.load(open(SPEC, encoding='utf-8')).get(mid) if os.path.exists(SPEC) else None
    return s if s and s.get('mode') == 'keyset' else None


def where(keys, vals):
    return ' AND '.join(f'{k} = :{k}' for k in keys), {k: vals[k] for k in keys}


def main():
    if len(sys.argv) < 4:
        print(__doc__)
        return 2
    mode, mid, vals = sys.argv[1], sys.argv[2].upper(), json.loads(sys.argv[3])
    sp = spec_of(mid)
    if not sp:
        print(json.dumps({'ok': True, 'free': True, 'why': 'keyset 정의 없음(가드 미적용)', 'counts': {}}, ensure_ascii=False))
        return 0
    missing = [k for k in sp['keys'] if not str(vals.get(k) or '').strip()]
    if missing and mode != 'suggest':  # 추천은 키가 비어 있어도 한다(신규행 Model 공란에서 빈 키를 찾는 용도 — 2026-10-24)
        print(json.dumps({'ok': True, 'free': False, 'why': f'키 값 없음 {missing}', 'counts': {}}, ensure_ascii=False))
        return 0
    for k, allowed in (sp.get('allow') or {}).items():
        if str(vals.get(k)) not in allowed and not (mode == 'suggest' and not vals.get(k)):
            print(json.dumps({'ok': True, 'free': False, 'why': f'{k}={vals.get(k)} 는 저장 허용 밖 {allowed} — {sp.get("allow_why", "")}', 'counts': {}}, ensure_ascii=False))
            return 0
    with connect('tobe') as cx:
        cur = cx.cursor()
        if mode == 'check':
            w, b = where(sp['keys'], vals)
            counts = {}
            for t in sp['tables']:
                cur.execute(f'SELECT COUNT(*) FROM {t} WHERE {w}', b)
                counts[t] = cur.fetchone()[0]
            busy = {t: n for t, n in counts.items() if n}
            # require = 저장 SP 가 받아주는 키여야 한다(예 DMF0005 활성 모델) — 0건이면 빈 키여도 쓰지 않는다(2026-10-25)
            bad = []
            for rq in sp.get('require', []):
                cur.execute(rq['sql'], {k: str(vals.get(k) or '') for k in rq.get('binds', [])})
                if not cur.fetchone()[0]:
                    bad.append(rq.get('why', 'require 불충족'))
            why = ('기존 행 있음 ' + json.dumps(busy, ensure_ascii=False)) if busy else ('저장 불가 키 — ' + '; '.join(bad)) if bad else '모든 대상 테이블 0건'
            print(json.dumps({'ok': True, 'free': not busy and not bad, 'why': why, 'counts': counts}, ensure_ascii=False))
            return 0
        if mode == 'suggest':
            # 빈 키 추천 — spec.suggest.sql(행 값 바인드)이 내는 후보 키 중 대상 테이블 전부에 0건인 것(최대 10)
            sg = sp.get('suggest')
            if not sg:
                print(json.dumps({'ok': True, 'keys': [], 'why': 'suggest 정의 없음'}, ensure_ascii=False))
                return 0
            nots = ' AND '.join(f"NOT EXISTS (SELECT 1 FROM {t} X WHERE " + ' AND '.join(f'X.{k} = C.{k}' for k in sp['keys']) + ')' for t in sp['tables'])
            q = f"SELECT * FROM ({sg['sql']}) C WHERE {nots} AND ROWNUM <= 10"
            binds = {k: str(vals.get(k) or '') for k in sg.get('binds', [])}
            cur.execute(q, binds)
            cols = [d[0] for d in cur.description]
            keys = [dict(zip(cols, r)) for r in cur.fetchall()]
            print(json.dumps({'ok': True, 'keys': keys, 'why': f'{len(keys)}건'}, ensure_ascii=False, default=str))
            return 0
        if mode == 'record':
            snaps = []
            for sn in sp.get('snapshot', []):
                sw, sb = where(sn['keys'], vals)
                cur.execute(f"SELECT {', '.join(sn['cols'])} FROM {sn['table']} WHERE {sw}", sb)
                snaps.append({'table': sn['table'], 'keys': {k: vals[k] for k in sn['keys']}, 'rows': [dict(zip(sn['cols'], [v.isoformat() if isinstance(v, datetime.datetime) else v for v in r])) for r in cur.fetchall()]})
            cur.execute('SELECT SYSDATE FROM DUAL')
            now = cur.fetchone()[0]
            p = os.path.join(ROOT, 'Doc', 'verify', mid, 'crud_keys.json')
            data = json.load(open(p, encoding='utf-8')) if os.path.exists(p) else []
            # 2026-11-25 T640: 저장 뒤 정리 위임(crud.ts deferDbCleanup) — _ago_sec = 저장 시작 뒤 지난 초(DB 시각에서 뺌) · _account = 저장한 계정(cleanup·F8 감사 기대값)
            ago = int(vals.get('_ago_sec') or 0)
            ent = {'keys': {k: vals[k] for k in sp['keys']}, 'saved_before': (now - datetime.timedelta(seconds=ago)).isoformat(), 'snapshots': snaps}
            if vals.get('_account'):
                ent['account'] = str(vals['_account'])
            # T640: 마커 칸·값 — 키가 다른 연쇄 행(SCP0005 이력 표 ROUTE_ID 0 행)도 마커 + 저장 계정 + 저장 시각으로 정리
            if vals.get('_marker_col') and vals.get('_marker'):
                ent['marker'] = {'col': str(vals['_marker_col']).upper(), 'value': str(vals['_marker'])}
            data.append(ent)
            json.dump(data, open(p, 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
            print(json.dumps({'ok': True, 'recorded': len(data)}, ensure_ascii=False))
            return 0
    print(json.dumps({'ok': False, 'why': f'알 수 없는 모드 {mode}'}, ensure_ascii=False))
    return 2


if __name__ == '__main__':
    sys.exit(main())
