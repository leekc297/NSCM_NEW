import sys, io, subprocess
sys.path.insert(0, r'c:\Projects\NSCM\tools\DbConn')
import dbconn
from build_owmsmax import N, rd, fetch_src, meta
asis = rd(N + '.ASIS.sql'); tobe = rd(N + '.TOBE.sql')
c = dbconn.connect('tobe').cursor()
P = r'c:/Projects/NSCM/_artifacts/_deploy_packages/SSP_SHIP_PLAN_40_OWMSMAX_CLOUD_20261126/A_DB/'
R = r'c:/Projects/NSCM/_artifacts/_apply_corporate/SHIP_PLAN_40_3SP_PERF_20261126/run_pkg.py'
def st(tag):
    s = fetch_src(c); print('==', tag, meta(c)[:2], 'DB==ASIS', s == asis, 'DB==TOBE', s == tobe, flush=True)
def run(*fs):
    print(subprocess.run([sys.executable, R] + [P + f for f in fs], capture_output=True, text=True, encoding='utf-8').stdout, flush=True)
assert fetch_src(c) == tobe
c.execute('CREATE OR REPLACE ' + asis); st('사내 원문을 착수 기준본으로 되돌림')
run('00_PRECHECK.sql', '05_BACKUP.sql', '20_REPLACE_PR_SSP_ANL_SHIP_PLAN_40.sql', '90_VERIFY.sql'); st('적용 뒤')
run('20_REPLACE_PR_SSP_ANL_SHIP_PLAN_40.sql'); st('재실행(SKIP 기대)')
run('99_ROLLBACK.sql'); st('원복 뒤(ASIS 기대)')
run('20_REPLACE_PR_SSP_ANL_SHIP_PLAN_40.sql', '90_VERIFY.sql'); st('재적용 뒤(TOBE 기대)')
