# 패키지 SSP_SHIP_PLAN_40_PERF2_CLOUD_20261126 사내 리허설 : 기준본 A 경로, 기준본 B 경로, SKIP, 원복
import sys, subprocess
sys.path.insert(0, r'c:\Projects\NSCM\tools\DbConn')
import dbconn
from build_package_perf2 import BASE_A, BASE_B, FINAL, rd, fetch_src
A, B, F = rd(BASE_A), rd(BASE_B), rd(FINAL)
c = dbconn.connect('tobe').cursor()
P = r'c:/Projects/NSCM/_artifacts/_deploy_packages/SSP_SHIP_PLAN_40_PERF2_CLOUD_20261126/A_DB/'
R = r'c:/Projects/NSCM/_artifacts/_apply_corporate/SHIP_PLAN_40_3SP_PERF_20261126/run_pkg.py'
def st(tag):
    s = fetch_src(c)
    c.execute("SELECT STATUS, TO_CHAR(LAST_DDL_TIME,'HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PR_SSP_ANL_SHIP_PLAN_40' AND OBJECT_TYPE='PROCEDURE'")
    print('==', tag, c.fetchone(), 'DB=', 'A' if s == A else 'B' if s == B else 'FINAL' if s == F else 'OTHER', flush=True)
def run(*fs):
    out = subprocess.run([sys.executable, R] + [P + f for f in fs], capture_output=True, text=True, encoding='utf-8').stdout
    print('\n'.join(l for l in out.split('\n') if l.strip() and 'ALTER SESSION' not in l), flush=True)
assert fetch_src(c) == F
c.execute('CREATE OR REPLACE ' + A); st('기준본 A 로 되돌림')
run('00_PRECHECK.sql', '05_BACKUP.sql', '20_REPLACE_PR_SSP_ANL_SHIP_PLAN_40.sql', '90_VERIFY.sql'); st('A 경로 적용 뒤')
run('20_REPLACE_PR_SSP_ANL_SHIP_PLAN_40.sql'); st('재실행(SKIP)')
run('99_ROLLBACK.sql'); st('원복 뒤(A 기대)')
c.execute('CREATE OR REPLACE ' + B); st('기준본 B 로 바꿈')
run('00_PRECHECK.sql', '20_REPLACE_PR_SSP_ANL_SHIP_PLAN_40.sql', '90_VERIFY.sql'); st('B 경로 적용 뒤(FINAL 기대)')
