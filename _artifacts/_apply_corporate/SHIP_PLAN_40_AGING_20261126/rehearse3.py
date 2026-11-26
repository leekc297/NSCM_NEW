# 패치판 20 / 15 진단 사내 리허설 : 클라우드처럼 기준본 B 에서 1줄이 다른 원문(B'), A, 실패 경로(-20011)
import sys, subprocess
sys.path.insert(0, r'c:\Projects\NSCM\tools\DbConn')
import dbconn
from build_package_perf2 import BASE_A, BASE_B, FINAL, rd
from build_patch_perf2 import fetch_src
A, B, F = rd(BASE_A), rd(BASE_B), rd(FINAL)
c = dbconn.connect('tobe').cursor()
P = r'c:/Projects/NSCM/_artifacts/_deploy_packages/SSP_SHIP_PLAN_40_PERF2_CLOUD_20261126/A_DB/'
R = r'c:/Projects/NSCM/_artifacts/_apply_corporate/SHIP_PLAN_40_3SP_PERF_20261126/run_pkg.py'
def tweak(s, ln=100):
    a = s.split('\n'); a[ln - 1] = a[ln - 1] + '   '; return '\n'.join(a)
B2, F2 = tweak(B), tweak(F)
def st(tag, exp):
    s = fetch_src(c)
    c.execute("SELECT STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PR_SSP_ANL_SHIP_PLAN_40' AND OBJECT_TYPE='PROCEDURE'")
    print('==', tag, c.fetchone()[0], '기대 일치' if s == exp else '기대와 다름', flush=True)
def run(*fs):
    out = subprocess.run([sys.executable, R] + [P + f for f in fs], capture_output=True, text=True, encoding='utf-8').stdout
    print('\n'.join(l for l in out.split('\n') if l.strip() and 'ALTER SESSION' not in l), flush=True)
assert fetch_src(c) == F
c.execute('CREATE OR REPLACE ' + B2); st("B' (B + 100줄 다름)", B2)
run('15_DIFF_SOURCE.sql', '20_PATCH_PR_SSP_ANL_SHIP_PLAN_40.sql', '90_VERIFY.sql'); st("B' 패치 뒤 = FINAL' 기대", F2)
run('20_PATCH_PR_SSP_ANL_SHIP_PLAN_40.sql'); st('재실행 SKIP', F2)
c.execute('CREATE OR REPLACE ' + A); st('A', A)
run('20_PATCH_PR_SSP_ANL_SHIP_PLAN_40.sql'); st('A 패치 뒤 = FINAL 기대', F)
bad = B.replace('           AND A.CUTOFF_DATE = B.CUTOFF_DATE\n', '           AND A.CUTOFF_DATE  = B.CUTOFF_DATE\n', 1); assert bad != B
c.execute('CREATE OR REPLACE ' + bad); st('B 의 1-6 위치 1칸 다름', bad)
run('20_PATCH_PR_SSP_ANL_SHIP_PLAN_40.sql'); st('-20011 뒤 원문 무변경 기대', bad)
c.execute('CREATE OR REPLACE ' + F); st('사내 최종본 복원', F)
