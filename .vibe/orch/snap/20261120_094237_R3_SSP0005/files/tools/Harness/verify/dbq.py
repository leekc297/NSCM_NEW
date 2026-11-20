# -*- coding: utf-8 -*-
"""E2E 시나리오용 단건 DB 조회 — 결과를 JSON 으로 출력(2026-11-03 · dbcell 단계 EG129/EG103)

  python -I tools/Harness/verify/dbq.py "<SQL with :v bind>" "<bind value>"
  → {"ok":true,"rows":[[...]],"cols":[...]}  (최대 50행 — 환경변수 DBQ_MAX 로 상한 변경 · 상한에 닿으면 truncated=true · 첫 칸이 비교값)
  읽기 전용 접속(tobe) · SELECT 만 허용(앞 토큰 검사) · 값은 바인드로만 넣어 SQL 주입 없음
"""
import json, os, re, sys
sys.stdout.reconfigure(encoding='utf-8', errors='replace')
ROOT = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn'))


def main(sql, val):
    if not re.match(r'^\s*(select|with)\b', sql, re.I):
        print(json.dumps({'ok': False, 'err': 'SELECT 만 허용'})); return 1
    from dbconn import connect
    try:
        with connect('tobe') as cx:
            cur = cx.cursor()
            cur.execute(sql, {'v': val} if ':v' in sql else [])
            mx = int(os.environ.get('DBQ_MAX') or 50); raw = cur.fetchmany(mx + 1); trunc = len(raw) > mx
            rows = [[None if x is None else str(x) for x in r] for r in raw[:mx]]
            cols = [d[0] for d in cur.description]
        print(json.dumps({'ok': True, 'rows': rows, 'cols': cols, 'truncated': trunc}, ensure_ascii=False)); return 0
    except Exception as e:
        print(json.dumps({'ok': False, 'err': str(e)[:300]}, ensure_ascii=False)); return 1


if __name__ == '__main__':
    sys.exit(main(sys.argv[1], sys.argv[2] if len(sys.argv) > 2 else ''))
