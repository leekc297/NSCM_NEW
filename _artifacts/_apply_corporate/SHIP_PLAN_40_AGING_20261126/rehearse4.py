# PERF3 사내 리허설 : 클라우드와 같은 상태(PERF2 최종본 + 1752줄 공백 다름) → 00, 05, 15, 20, 90 → 20 → 99 → 사내 최종본 복원
import sys, subprocess
sys.path.insert(0, r'c:\Projects\NSCM\tools\DbConn')
import dbconn
import build_package_perf3 as p3
F2, F3 = p3.bpk.rd(p3.FINAL2), p3.bpk.rd(p3.FINAL3)
def tweak(s):
    a = s.split('\n'); k = [i for i, x in enumerate(a) if x == '        ' and i > 1700][0]; a[k] = ''; return '\n'.join(a)
F2c, F3c = tweak(F2), tweak(F3)
c = dbconn.connect('tobe').cursor()
P = r'c:/Projects/NSCM/_artifacts/_deploy_packages/SSP_SHIP_PLAN_40_PERF3_CLOUD_20261126/A_DB/'
R = r'c:/Projects/NSCM/_artifacts/_apply_corporate/SHIP_PLAN_40_3SP_PERF_20261126/run_pkg.py'
def st(tag):
    s = p3.fetch_src(c)
    c.execute("SELECT STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PR_SSP_ANL_SHIP_PLAN_40' AND OBJECT_TYPE='PROCEDURE'")
    print('==', tag, c.fetchone()[0], 'DB=', {F2: 'F2', F3: 'F3', F2c: "F2'", F3c: "F3'"}.get(s, 'OTHER'), flush=True)
def run(*fs):
    out = subprocess.run([sys.executable, R] + [P + f for f in fs], capture_output=True, text=True, encoding='utf-8').stdout
    print('\n'.join(l for l in out.split('\n') if l.strip() and 'ALTER SESSION' not in l), flush=True)
assert p3.fetch_src(c) == F3
c.execute('CREATE OR REPLACE ' + F2c); st("클라우드 상태 F2' 로 둠")
run('00_PRECHECK.sql', '05_BACKUP.sql', '15_DIFF_SOURCE.sql', '20_PATCH_PR_SSP_ANL_SHIP_PLAN_40.sql', '90_VERIFY.sql'); st("적용 뒤(F3' 기대)")
run('20_PATCH_PR_SSP_ANL_SHIP_PLAN_40.sql'); st('재실행(SKIP)')
run('99_ROLLBACK.sql'); st("원복 뒤(F2' 기대)")
c.execute('CREATE OR REPLACE ' + F3); st('사내 최종본 복원(F3 기대)')
