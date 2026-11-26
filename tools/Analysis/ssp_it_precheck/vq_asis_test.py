# -*- coding: utf-8 -*-
"""AS-IS(MSSQL) 대조 쿼리 시험(읽기 전용)
  1단계 : 실행하지 않고 문법 · 결과 열만 확인(sp_describe_first_result_set) → TO-BE 같은 번호 쿼리와 열 이름 대조
  2단계 : 실제 실행(쿼리당 제한 시간 초과 시 중단). --no-run 이면 1단계만. --skip VQ-42 처럼 실행 제외 지정
  python -u vq_asis_test.py <V9 xlsx> [--no-run] [--limit 60] [--skip VQ-42,...] [VQ-xx ...]"""
import sys, time, os
sys.stdout.reconfigure(encoding='utf-8')
sys.path.insert(0, r'c:\Projects\NSCM\tools\DbConn')
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import dbconn, openpyxl
from vq_asis import ASIS
from vq_new import VQ
args = sys.argv[2:]; no_run = '--no-run' in args
limit = int(args[args.index('--limit') + 1]) if '--limit' in args else 60
skip = set(args[args.index('--skip') + 1].split(',')) if '--skip' in args else set()
only = [x for x in args if x.startswith('VQ-') and ',' not in x and x not in skip]
tobe_sql = {v[0]: (v[5], v[6]) for v in VQ}
q = openpyxl.load_workbook(sys.argv[1])['검증쿼리']
for r in range(2, 40):
    i = q.cell(r, 1).value
    if i == 'VQ-27': tobe_sql[i] = (q.cell(r, 6).value, {'ITEM_ID': 'X', 'FROM_YYYYMMDD': '20261001', 'TO_YYYYMMDD': '20261231'})
    if i == 'VQ-31': tobe_sql[i] = (q.cell(r, 6).value, {'PLAN_START': '20261009'})
a = dbconn.connect('asis'); a.timeout = limit; ac = a.cursor()
t = dbconn.connect('tobe'); tc = t.cursor()
ac.execute("SELECT DB_NAME(), CONVERT(VARCHAR(19), GETDATE(), 120)"); print('AS-IS', tuple(ac.fetchone()), '· 실행 제한', limit, '초')
ok = ng = diff = ran = slow = 0
for i, (sql, _) in ASIS.items():
    if only and i not in only: continue
    try:
        ac.execute("EXEC sp_describe_first_result_set ?", sql); acols = [r[2].upper() for r in ac.fetchall()]
        s, b = tobe_sql[i]; tc.execute('SELECT * FROM (' + s.split('\n ORDER BY')[0] + ') WHERE 1 = 0', b); tcols = [d[0].upper() for d in tc.description]
        same = acols == tcols; ok += 1; diff += 0 if same else 1
        msg = f'{i} 문법 OK · 열 {len(acols)}개 ' + ('TO-BE 와 같음' if same else f'다름 AS-IS {acols} / TO-BE {tcols}')
    except Exception as e:
        print(f'{i} 문법 ERR | {str(e)[:300]}'); ng += 1; continue
    if no_run or i in skip: print(msg, '| 실행 안 함'); continue
    t0 = time.time()
    try:
        ac.execute(sql); rows = ac.fetchmany(500); ran += 1
        print(msg, f'| 실행 {time.time() - t0:5.1f}s rows={len(rows)}')
        for r in rows[:2]: print('     ', ' | '.join('' if v is None else str(v)[:24] for v in r))
    except Exception as e:
        slow += 1; print(msg, f'| 실행 중단 {time.time() - t0:5.1f}s {str(e)[:120]}')
        try: ac.cancel()
        except Exception: pass
        ac = a.cursor()
ac.execute("SELECT CONVERT(VARCHAR(19), GETDATE(), 120)"); print('종료', ac.fetchone()[0], f'· 문법 정상 {ok} · 문법 오류 {ng} · 열 이름 다름 {diff} · 실행 완료 {ran} · 제한 시간 초과 {slow}')
a.close(); t.close()
