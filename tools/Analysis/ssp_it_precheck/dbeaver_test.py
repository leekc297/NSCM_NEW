# -*- coding: utf-8 -*-
"""검증쿼리(사전점검) DBeaver 형태 최종본 시험(읽기 전용)
  ① 금지 형태 검사(lint) ② TO-BE(ZIOUI1) 실행 — 변환 전(바인드) 결과와 행 수 대조 ③ AS-IS(LGCE_SCMDEV) 문법 · 결과 열(실행 안 함) + 열 이름 TO-BE 대조
  python -u dbeaver_test.py <V9 xlsx> --test-date YYYYMMDD [--asis-run 60] [--out rows.json]
  --test-date = 시험일(필수 · 2026-11-26 R221). 없거나 형식이 틀리면 쿼리 행을 만들지 않고 끝냄"""
import sys, time, os, json, re, datetime
sys.stdout.reconfigure(encoding='utf-8')
sys.path.insert(0, r'c:\Projects\NSCM\tools\DbConn')
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import dbconn, openpyxl
import dbeaver as D
from vq_new import VQ
args = sys.argv[2:]
TD = args[args.index('--test-date') + 1] if '--test-date' in args and args.index('--test-date') + 1 < len(args) else ''
try:
    if not re.fullmatch(r'\d{8}', TD): raise ValueError(TD)   # strptime 은 7자리(2026112)도 받아들임
    datetime.datetime.strptime(TD, '%Y%m%d')
except ValueError:
    print('시험일 없음 또는 형식 오류(--test-date YYYYMMDD) · 쿼리 행 저장 안 함 · 입력값', repr(TD)); sys.exit(2)
T, T1 = D.set_test_date(TD)
# 손으로 쓴 MSSQL 본문(VQ-41 등)의 DECLARE @TEST_DATE 고정값도 시험일로 바꿈
D.OVERRIDE_MS = {k: re.sub(r"(DECLARE @TEST_DATE CHAR\(8\) = ')\d{8}'", lambda m: m.group(1) + T + "'", v) for k, v in D.OVERRIDE_MS.items()}
print('시험일', T, '· 시험일 - 1', T1)
q = openpyxl.load_workbook(sys.argv[1])['검증쿼리']
v9 = [[q.cell(r, c).value for c in range(1, 7)] for r in range(2, 34) if q.cell(r, 1).value in ('VQ-27', 'VQ-31')]
final = D.build(v9, test_date=T); test = D.build(v9, test=True, test_date=T)
bad = [(r[0], side, D.lint(s)) for r in final for side, s in (('TO-BE', r[5]), ('AS-IS', r[6])) if s != '-' and D.lint(s)]
print('① 금지 형태', len(bad), bad[:5], '· 쿼리 TO-BE', len(final), '· AS-IS', sum(1 for r in final if r[6] != '-'), '· 최대 줄 수', max(max(r[5].count('\n'), r[6].count('\n')) + 1 for r in final))
t = dbconn.connect('tobe'); tc = t.cursor()
tc.execute("SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL"); print('② TO-BE 시작', tc.fetchone()[0])
old = {v[0]: (v[5], v[6]) for v in VQ}
for r in v9: old[r[0]] = (r[5], {'PLAN_START': '20261009'} if r[0] == 'VQ-31' else {'ITEM_ID': 'MCCM349215A1-111', 'FROM_YYYYMMDD': '20261001', 'TO_YYYYMMDD': '20261231'})
ok = ng = dif = 0; tcols = {}
for r in test:
    i, sql = r[0], r[5]; t0 = time.time()
    try:
        tc.execute(sql); cols = [d[0].upper() for d in tc.description]; n1 = len(tc.fetchmany(5000)); el = time.time() - t0; tcols[i] = cols
        tc.execute(*old[i]); n0 = len(tc.fetchmany(5000)); c0 = [d[0].upper() for d in tc.description]
        same = n0 == n1 and c0 == cols; ok += 1; dif += 0 if same else 1
        print(f'  {i} OK {el:5.1f}s rows={n1} | 변환 전 rows={n0} ' + ('같음' if same else '다름'))
    except Exception as e:
        ng += 1; print(f'  {i} ERR {time.time() - t0:5.1f}s | {str(e)[:260]}')
tc.execute("SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL"); print('② TO-BE 종료', tc.fetchone()[0], f'· 정상 {ok} · 오류 {ng} · 변환 전과 다름 {dif}')
a = dbconn.connect('asis'); lim = int(args[args.index('--asis-run') + 1]) if '--asis-run' in args else 0
if lim: a.timeout = lim
ac = a.cursor(); ac.execute("SELECT DB_NAME(), CONVERT(VARCHAR(19), GETDATE(), 120)"); print('③ AS-IS', tuple(ac.fetchone()))
aok = ang = adif = ran = slow = 0
for r in final:
    i, sql = r[0], r[6]
    if sql == '-': continue
    try:
        ac.execute("EXEC sp_describe_first_result_set ?", sql); cols = [x[2].upper() for x in ac.fetchall()]; aok += 1
        same = cols == tcols.get(i); adif += 0 if same else 1; msg = f'  {i} 문법 OK · 열 {len(cols)}개 ' + ('TO-BE 와 같음' if same else f'다름 {cols} / {tcols.get(i)}')
    except Exception as e:
        ang += 1; print(f'  {i} 문법 ERR | {str(e)[:260]}'); continue
    if lim and i != 'VQ-42':
        t0 = time.time()
        try: ac.execute(sql); n = len(ac.fetchmany(500)); ran += 1; msg += f' | 실행 {time.time() - t0:5.1f}s rows={n}'
        except Exception as e:
            slow += 1; msg += f' | 실행 중단 {time.time() - t0:5.1f}s'
            try: ac.cancel()
            except Exception: pass
            ac = a.cursor()
    print(msg)
ac.execute("SELECT CONVERT(VARCHAR(19), GETDATE(), 120)"); print('③ AS-IS 종료', ac.fetchone()[0], f'· 문법 정상 {aok} · 문법 오류 {ang} · 열 이름 다름 {adif} · 실행 완료 {ran} · 제한 시간 초과 {slow}')
if '--out' in args:
    json.dump(final, open(args[args.index('--out') + 1], 'w', encoding='utf-8'), ensure_ascii=False, indent=1); print('저장', len(final))
