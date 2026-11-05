# -*- coding: utf-8 -*-
"""TO-BE 메타 조회(읽기 전용) — 팝업 검사 기대값 원천 (2026-10-31 E02)

  python -I tools/Harness/verify/facts_popup_meta.py <MENU_ID> [--account <ID>]  -> Doc/verify/_parallel/E02/facts/<ID>.meta.json

산출
  columns : SCM_MST_SHEET_COLUMNS 전 행(PROGRAM_ID=메뉴) — 셀 입력 방식 CELL_CONTROL_OBJECT_TYPE_CODE · DIVISION_ID · DEFAULT_FLAG · VISIBLE_FLAG
  measures: SCM_MST_SHEET_MEASURE 전 행(PROGRAM_ID=메뉴) — DIVISION_ID · DEFAULT_FLAG · USER_SELECTABLE_FLAG · VALID_YN
  titleset: 계정별 개인화 행수(PROGRAM_ID=메뉴 · SHEET_NAME 별)
  no_personal_accounts: 명부(tools/E2E/users.json 의 사용자)와 사내 사용자(SCM_ADM_USER_M) 중 이 메뉴 개인화 행이 없는 계정(앞 20명)

읽기 전용. 쓰기·COMMIT 없음. 화면 고유값 없음.
"""
import json, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn'))
from dbconn import connect  # noqa: E402

OUT = os.path.join(ROOT, 'Doc', 'verify', '_parallel', 'E02', 'facts')


def rows(c, sql, **b):
    c.execute(sql, b)
    n = [d[0] for d in c.description]
    return [dict(zip(n, ['' if v is None else (v if isinstance(v, (int, float)) else str(v)) for v in r])) for r in c.fetchall()]


def run(mid, account=''):
    cx = connect('tobe')
    c = cx.cursor()
    cols = rows(c, """select SHEET_NAME, COLUMN_NAME, COLUMN_LABEL_NAME, CELL_CONTROL_OBJECT_TYPE_CODE, DIVISION_ID, DEFAULT_FLAG, VISIBLE_FLAG, USER_SELECTABLE_FLAG, SORT_ORDER_NO
                       from SCM_MST_SHEET_COLUMNS where PROGRAM_ID = :m order by SHEET_NAME, SORT_ORDER_NO""", m=mid)
    meas = rows(c, """select SHEET_NAME, COLUMN_NAME, COLUMN_LABEL_NAME, DIVISION_ID, DEFAULT_FLAG, USER_SELECTABLE_FLAG, VALID_YN, SORT_ORDER_NO
                       from SCM_MST_SHEET_MEASURE where PROGRAM_ID = :m order by SHEET_NAME, SORT_ORDER_NO""", m=mid)
    ts = rows(c, """select USER_ID, SHEET_NAME, USER_INQUIRY_COLUMN_TYPE_CODE, count(*) N from SCM_MST_TITLESET_USER where PROGRAM_ID = :m
                     group by USER_ID, SHEET_NAME, USER_INQUIRY_COLUMN_TYPE_CODE""", m=mid)
    have = {t['USER_ID'].lower() for t in ts}
    pool = []
    try:
        uj = json.load(open(os.path.join(ROOT, 'tools', 'E2E', 'users.json'), encoding='utf-8-sig'))
        for v in (uj.get('areas') or {}).values():
            for u in (v if isinstance(v, list) else []):
                uid = (u.get('id') if isinstance(u, dict) else u) or ''
                if uid:
                    pool.append(uid.lower())
    except (OSError, ValueError):
        pass
    nop = [u for u in dict.fromkeys(pool) if u not in have][:20]
    j = {'menu': mid, 'columns': cols, 'measures': meas, 'titleset': ts, 'no_personal_accounts': nop,
         'account': account, 'account_personal': [t for t in ts if t['USER_ID'].lower() == account.lower()] if account else []}
    os.makedirs(OUT, exist_ok=True)
    with open(os.path.join(OUT, f'{mid}.meta.json'), 'w', encoding='utf-8') as f:
        json.dump(j, f, ensure_ascii=False, indent=0)
    cx.close()
    return j


if __name__ == '__main__':
    sys.stdout.reconfigure(encoding='utf-8')
    a = sys.argv[1:]
    acc = ''
    if '--account' in a:
        i = a.index('--account')
        acc = a[i + 1]
        del a[i:i + 2]
    for m in a:
        j = run(m, acc)
        print(m, 'columns', len(j['columns']), 'measures', len(j['measures']), 'titleset', len(j['titleset']), 'no_personal', j['no_personal_accounts'][:5])
