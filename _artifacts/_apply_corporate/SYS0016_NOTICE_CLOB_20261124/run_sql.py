"""SQL*Plus 형식 파일을 '/' 줄 단위로 나눠 실행. SET/PROMPT 줄은 출력만. 사용: python -u run_sql.py <file>"""
import os
import sys
import time

sys.stdout.reconfigure(encoding='utf-8')
ROOT = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn'))
from dbconn import connect  # noqa: E402

path = sys.argv[1]
blocks, buf = [], []
for line in open(path, encoding='utf-8').read().splitlines():
    s = line.strip()
    if s == '/':
        if ''.join(buf).strip():
            blocks.append('\n'.join(buf))
        buf = []
    elif not buf and (s.upper().startswith('SET ') or s.upper().startswith('PROMPT') or s.startswith('--') or not s):
        if s.upper().startswith('PROMPT'):
            blocks.append(('PROMPT', s[6:].strip()))
    else:
        buf.append(line)
if ''.join(buf).strip():
    print('ERROR trailing block without "/"')
    sys.exit(1)

with connect('tobe') as cx:
    cx.call_timeout = 300000
    cur = cx.cursor()
    cur.callproc('dbms_output.enable', [None])
    for b in blocks:
        if isinstance(b, tuple):
            print('>>', b[1])
            continue
        t = time.time()
        err = None
        try:
            cur.execute(b)
        except Exception as e:  # noqa: BLE001
            err = e
        lv, st = cur.var(str), cur.var(int)
        while True:
            cur.callproc('dbms_output.get_line', (lv, st))
            if st.getvalue() != 0:
                break
            print('  ', lv.getvalue())
        if err is not None:
            print('ERROR', str(err)[:800])
            sys.exit(1)
        print(f'   ({time.time() - t:.2f}s)')
print('OK', time.strftime('%Y-%m-%d %H:%M:%S'))
