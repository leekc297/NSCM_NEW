# -*- coding: utf-8 -*-
"""SQL 파일을 SQL*Plus 로 「파일 전체 실행」 시험(사내 ZIOUI1) — 변경 호출은 빈 문장으로 바꾼 사본으로 실행해 실제 변경 없음
  python sqlplus_dryrun.py <파일.sql> [--keep-calls]   · 접속값은 .env.asis TOBE_DB_* (출력하지 않음)
  판정 : 출력에 ORA- · PLS- · SP2- 가 0건이면 스크립트 실행 형식 통과
  2026-11-25 : 블록 끝 / 가 없어 클라우드 스크립트 실행에서 PLS-00103 발생 → 사용자에게 주기 전에 이 시험을 거친다"""
import sys, os, io, re, subprocess, tempfile
sys.stdout.reconfigure(encoding='utf-8')
ROOT = r'c:\Projects\NSCM'
env = {}
for ln in io.open(os.path.join(ROOT, '.env.asis'), encoding='utf-8', errors='replace'):
    m = re.match(r'\s*(TOBE_DB_\w+)\s*=\s*(.*)\s*$', ln)
    if m: env[m.group(1)] = m.group(2).strip().strip('"').strip("'")
src = io.open(sys.argv[1], encoding='utf-8').read().replace('\r\n', '\n')
keep = '--keep-calls' in sys.argv
calls = re.findall(r'(?m)^\s*(?:PR_|SCM_ADM_)[A-Z0-9_]+\s*(?:\(.*?\))?;', src, flags=re.S)
body = src if keep else re.sub(r'(?ms)^(\s*)((?:PR_|SCM_ADM_)[A-Z0-9_]+\s*(?:\([^;]*?\))?;)', lambda m: m.group(1) + 'NULL;   /* 시험 : 호출 생략 */', src)
d = tempfile.mkdtemp(prefix='sqlplus_dry_')
io.open(os.path.join(d, 'target.sql'), 'w', encoding='utf-8', newline='\n').write(body)
io.open(os.path.join(d, 'run.sql'), 'w', encoding='utf-8', newline='\n').write(
    'SET ECHO OFF FEEDBACK ON PAGESIZE 100 LINESIZE 250 TRIMSPOOL ON SQLBLANKLINES OFF\nALTER SESSION SET CURRENT_SCHEMA = SCM_MGR;\n@target.sql\nEXIT\n')
e = dict(os.environ, NLS_LANG='KOREAN_KOREA.AL32UTF8')
conn = f'{env["TOBE_DB_USER"]}/"{env["TOBE_DB_PASS"]}"@//{env["TOBE_DB_HOST"]}:{env["TOBE_DB_PORT"]}/{env["TOBE_DB_PDB"]}'
r = subprocess.run([r'C:\oracle\instantclient_23_26\sqlplus.exe', '-S', '-L', conn, '@run.sql'], cwd=d, env=e, capture_output=True, timeout=540)
out = (r.stdout + r.stderr).decode('utf-8', 'replace').replace(env['TOBE_DB_PASS'], '***')
errs = re.findall(r'(?m)^.*(?:ORA-\d+|PLS-\d+|SP2-\d+).*$', out)
print(f'호출 {len(calls)}개' + ('(그대로 실행)' if keep else '(빈 문장으로 바꿔 실행)'), '· 종료코드', r.returncode, '· 오류 줄', len(errs))
for x in errs[:12]: print('  ERR', x[:200])
print('· PL/SQL 처리 정상 완료', out.count('PL/SQL 처리가 정상적으로 완료') + out.count('PL/SQL procedure successfully completed'), '· 결과 묶음(행 선택 문구)', len(re.findall(r'행이 선택|rows? selected|선택된 행 없음|no rows selected', out)))
if '--show' in sys.argv: print(out[-3000:])
