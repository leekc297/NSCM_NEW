# -*- coding: utf-8 -*-
"""컬럼 설정 Save 시험용 개인화 스냅샷·복원 (2026-11-04 · EG021/EG392)

  python -I tools/Harness/verify/titleset_guard.py backup  <USER> <PROGRAM> <FILE>   → JSON {"ok","rows"}
  python -I tools/Harness/verify/titleset_guard.py restore <USER> <PROGRAM> <FILE>   → JSON {"ok","deleted","restored","same"}

  SCM_MST_TITLESET_USER 는 (USER_ID, PROGRAM_ID) 단위 개인화다(DIVISION 칼럼 없음).
  backup 은 그 묶음 전 행을 파일로 남기고, restore 는 묶음을 지운 뒤 파일 행을 그대로 다시 넣는다.
  복원 뒤 행 구성(시트·유형·칼럼·순서)이 백업과 같은지 대조해 same 으로 알린다.
  사용자 설정 덮어쓰기 금지(11-02 DMF0082 사고) — Save 시험은 반드시 backup 성공 뒤에만, restore 는 finally 에서.
"""
import datetime, json, os, sys
sys.stdout.reconfigure(encoding='utf-8', errors='replace')
ROOT = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn'))
T = 'SCM_MGR.SCM_MST_TITLESET_USER'


def rows_of(cur, u, p):
    cur.execute(f'SELECT * FROM {T} WHERE USER_ID = :u AND PROGRAM_ID = :p', u=u, p=p)
    names = [d[0] for d in cur.description]
    return names, [dict(zip(names, r)) for r in cur.fetchall()]


def sig(rows):
    return sorted((str(r.get('SHEET_NAME')), str(r.get('USER_INQUIRY_COLUMN_TYPE_CODE')), str(r.get('COLUMN_NAME')), str(r.get('SORT_ORDER_NO'))) for r in rows)


def main(act, u, p, fp):
    from dbconn import connect
    with connect('tobe', write=(act == 'restore')) as cx:
        cur = cx.cursor()
        if act == 'backup':
            names, rows = rows_of(cur, u, p)
            json.dump({'user': u, 'program': p, 'names': names, 'rows': rows, 'at': datetime.datetime.now().isoformat(timespec='seconds')},
                      open(fp, 'w', encoding='utf-8'), ensure_ascii=False, default=str)
            print(json.dumps({'ok': True, 'rows': len(rows)})); return 0
        if act == 'restore':
            b = json.load(open(fp, encoding='utf-8'))
            if b.get('user') != u or b.get('program') != p:
                print(json.dumps({'ok': False, 'err': 'backup 대상 불일치'})); return 1
            cur.execute(f"SELECT COLUMN_NAME, DATA_TYPE FROM ALL_TAB_COLUMNS WHERE OWNER = 'SCM_MGR' AND TABLE_NAME = 'SCM_MST_TITLESET_USER'")
            typ = dict(cur.fetchall())
            cur.execute(f'DELETE FROM {T} WHERE USER_ID = :u AND PROGRAM_ID = :p', u=u, p=p); deleted = cur.rowcount
            cols = b['names']
            for r in b['rows']:
                vals = []
                for c in cols:
                    v = r.get(c)
                    if typ.get(c) == 'DATE' and v not in (None, ''):
                        v = datetime.datetime.fromisoformat(str(v))
                    vals.append(v)
                cur.execute(f"INSERT INTO {T} ({','.join(cols)}) VALUES ({','.join(':' + str(i) for i in range(len(cols)))})", vals)
            cx.commit()
            _, now = rows_of(cur, u, p)
            print(json.dumps({'ok': True, 'deleted': deleted, 'restored': len(b['rows']), 'same': sig(now) == sig(b['rows'])})); return 0
    print(json.dumps({'ok': False, 'err': 'act = backup|restore'})); return 2


if __name__ == '__main__':
    try:
        sys.exit(main(*sys.argv[1:5]))
    except Exception as e:  # 측정 실패 = ERROR 로 전달
        print(json.dumps({'ok': False, 'err': str(e)[:300]}, ensure_ascii=False)); sys.exit(1)
