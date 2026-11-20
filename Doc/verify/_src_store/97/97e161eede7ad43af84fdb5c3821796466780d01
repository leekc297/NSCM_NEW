# -*- coding: utf-8 -*-
"""실저장 잔존 변경 실측(2026-10-31) — 저장 대상 테이블에서 E2E 계정이 --since 이후 만들거나 고친 행 수를 DB 에서 센다. 정리가 끝났다는 주장의 증거.

  python tools/Harness/verify/save_residue.py <MENU_ID> --since "2026-10-31 13:30:00"
    → Doc/verify/<ID>/save_residue.csv(테이블·신규 행·수정 행·감사 컬럼 유무) · 콘솔 요약 · 잔존 ≥1 이면 exit 3
  감사 컬럼이 없는 테이블은 '측정 불가' 로 표시한다(0건으로 쓰지 않는다)
"""
import argparse, csv, json, os, sys
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn'))
from dbconn import connect  # noqa: E402


def main():
    ap = argparse.ArgumentParser(); ap.add_argument('menu'); ap.add_argument('--since', required=True); ap.add_argument('--account', default=''); a = ap.parse_args(); mid = a.menu.upper()
    spec = json.load(open(os.path.join(HERE, 'cleanup_spec.json'), encoding='utf-8')).get(mid) or {}
    cfg = json.load(open(os.path.join(ROOT, 'tools', 'E2E', 'e2e.config.json'), encoding='utf-8-sig')); user = a.account or cfg.get('defaultAccount', '')  # 2026-11-03 명부 계정 실저장 잔존
    tables = list(dict.fromkeys((spec.get('tables') or []) + (spec.get('unresolved_tables') or []) + ([spec['root']['table']] if spec.get('root') else []) + [c['table'] for c in spec.get('children', [])]))
    out = []; residue = 0
    with connect('tobe') as cx:
        cur = cx.cursor()
        for t in tables:
            cur.execute("SELECT COLUMN_NAME FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR' AND TABLE_NAME=:t", t=t); cols = {r[0] for r in cur.fetchall()}
            row = {'table': t, 'new_rows': '측정 불가', 'updated_rows': '측정 불가', 'cleaned_by_spec': 'Y' if t in (spec.get('tables') or []) else 'N'}
            if {'CREATION_DATE', 'CREATED_BY'} <= cols:
                cur.execute(f"SELECT COUNT(*) FROM {t} WHERE CREATION_DATE >= TO_DATE(:s,'YYYY-MM-DD HH24:MI:SS') AND UPPER(CREATED_BY)=UPPER(:u)", s=a.since, u=user); row['new_rows'] = cur.fetchone()[0]; residue += row['new_rows']
            if {'LAST_UPDATE_DATE', 'LAST_UPDATED_BY'} <= cols:
                cur.execute(f"SELECT COUNT(*) FROM {t} WHERE LAST_UPDATE_DATE >= TO_DATE(:s,'YYYY-MM-DD HH24:MI:SS') AND UPPER(LAST_UPDATED_BY)=UPPER(:u)", s=a.since, u=user); row['updated_rows'] = cur.fetchone()[0]; residue += row['updated_rows']
            out.append(row)
    d = os.path.join(ROOT, 'Doc', 'verify', mid); os.makedirs(d, exist_ok=True)
    with open(os.path.join(d, 'save_residue.csv'), 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=['table', 'new_rows', 'updated_rows', 'cleaned_by_spec']); w.writeheader(); w.writerows(out)
    print(f'{mid}: 계정 {user} · {a.since} 이후 잔존 합계 {residue} · 테이블 {len(tables)} → Doc/verify/{mid}/save_residue.csv')
    return 3 if residue else 0


if __name__ == '__main__':
    sys.exit(main())
