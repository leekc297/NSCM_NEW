# -*- coding: utf-8 -*-
"""[E20261104-DMF0082ONEQUERY] 사내 ZIOUI1 — PKG_DMF0082 백업 후 P_DMF0082_GET_MAIN_DATA 를 PKG_DMF0082_1104 구간으로 교체 (2026-11-09 사용자 지시)

  python -I apply_corporate.py check     # 게이트만(변경 없음)
  python -I apply_corporate.py apply     # 게이트 → 파일 백업 → 백업 패키지 PKG_DMF0082_BAK1109 → 클라우드 패키지 SQL 00·10·20·90 실행 → 원문 대조

실행 SQL = _artifacts/_deploy_packages/DMF0082_GMD_REPLACE_CLOUD_20261109/A_DB/*.sql (클라우드에 드리는 파일 그대로 · 사내 리허설 14:03 판정 실패 0)
게이트: ① 원본 BODY LAST_DDL = 2026-11-04 14:48:42 (FRESH) ② 1104 BODY = 2026-11-06 06:09:06 ③ _coldiff_full 등 비교 프로세스 없음
        ④ V$SESSION 에서 PKG_DMF0082 실행 중 세션 0 (이 접속 제외)
원복: 같은 폴더 A_DB/99_ROLLBACK.sql (ZB_DMF0082_GMD_BAK 백업 원문) 또는 00_BACKUP_PKG_DMF0082_BODY_20261109.sql
"""
import sys, os, re, datetime, subprocess
sys.stdout.reconfigure(encoding='utf-8', errors='replace')
sys.path.insert(0, r"C:\Projects\NSCM\tools\DbConn")
import dbconn, oracledb, run_sql

HERE = os.path.dirname(os.path.abspath(__file__))
PKGDIR = r"C:\Projects\NSCM\_artifacts\_deploy_packages\DMF0082_GMD_REPLACE_CLOUD_20261109\A_DB"
TGT, SRC, BAK = 'PKG_DMF0082', 'PKG_DMF0082_1104', 'PKG_DMF0082_BAK1109'
EXP_TGT, EXP_SRC = '2026-11-04 14:48:42', '2026-11-06 06:09:06'
mode = sys.argv[1] if len(sys.argv) > 1 else 'check'
r = dbconn.resolve('tobe', dbconn.load_cfg())
cx = oracledb.connect(user='SCM_MGR', password=r['password'], dsn=f"{r['host']}:{r['port']}/{r['service']}")
c = cx.cursor()
log = open(os.path.join(HERE, f"_apply_{mode}_{datetime.datetime.now().strftime('%Y%m%d_%H%M%S')}.log"), 'w', encoding='utf-8')


def L(s):
    print(s, flush=True); log.write(s + '\n'); log.flush()


def one(sql, **b):
    c.execute(sql, **b); return c.fetchone()


def src(name, typ):
    c.execute("SELECT TEXT FROM USER_SOURCE WHERE NAME=:n AND TYPE=:t ORDER BY LINE", n=name, t=typ)
    return ''.join(x[0] or '' for x in c.fetchall())


now = one("SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS'), SYS_CONTEXT('USERENV','DB_NAME'), USER FROM DUAL")
L(f"== {mode} {now}")
# FRESH-GATE: 적용 직전 DB 원문 LAST_DDL 재조회 → 기준본(원본 14:48:42 · 1104 06:09:06)과 같아야 진행. 원문 본체는 ① 백업 단계에서 이 시점 USER_SOURCE 로 다시 읽는다.
ddl = {n: one("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM USER_OBJECTS WHERE OBJECT_NAME=:n AND OBJECT_TYPE='PACKAGE BODY'", n=n)[0] for n in (TGT, SRC)}
g1, g2 = ddl[TGT] == EXP_TGT, ddl[SRC] == EXP_SRC
ps = subprocess.run(['powershell', '-NoProfile', '-Command',
                     "Get-CimInstance Win32_Process -Filter \"Name='python.exe'\" | Where-Object { $_.CommandLine -match '_coldiff|compare.py|measure.py|_rehearse|--rehearse' } | ForEach-Object { $_.ProcessId }"],
                    capture_output=True, text=True).stdout.split()
g3 = len(ps) == 0
c.execute("SELECT SYS_CONTEXT('USERENV','SID') FROM DUAL"); me = c.fetchone()[0]
try:
    n = one("""SELECT COUNT(*) FROM V$SESSION S WHERE S.SID <> :me AND S.STATUS='ACTIVE'
               AND S.PLSQL_ENTRY_OBJECT_ID IN (SELECT OBJECT_ID FROM USER_OBJECTS WHERE OBJECT_NAME=:t AND OBJECT_TYPE='PACKAGE')""", me=me, t=TGT)[0]
    g4 = n == 0
except Exception as e:
    n, g4 = f'조회 불가 {e}', False
L(f"게이트 ① 원본 BODY {ddl[TGT]} {'OK' if g1 else '✗'} ② 1104 BODY {ddl[SRC]} {'OK' if g2 else '✗'} ③ 비교 프로세스 {ps or '없음'} {'OK' if g3 else '✗'} ④ 원본 실행 세션 {n} {'OK' if g4 else '✗'}")
if not (g1 and g2 and g3 and g4):
    L('중단 — 게이트 불통과 · 변경 없음'); sys.exit(2)
if mode != 'apply':
    L('check 끝 — 변경 없음'); sys.exit(0)

# ① 파일 백업
stamp = datetime.datetime.now().strftime('%Y-%m-%d %H:%M')
spec, body = src(TGT, 'PACKAGE'), src(TGT, 'PACKAGE BODY')
for typ, s, fn in (('PACKAGE', spec, '00_BACKUP_PKG_DMF0082_SPEC_20261109.sql'), ('PACKAGE BODY', body, '00_BACKUP_PKG_DMF0082_BODY_20261109.sql')):
    ld = one("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM USER_OBJECTS WHERE OBJECT_NAME=:n AND OBJECT_TYPE=:t", n=TGT, t=typ)[0]
    open(os.path.join(HERE, fn), 'w', encoding='utf-8', newline='\n').write(
        f"-- SOURCE-FRESH: SCM_MGR.{TGT} {typ} LAST_DDL={ld} FETCHED={stamp} DB={now[1]}\n-- 교체 전 원문 백업(되돌리기용) · 실행 = 이 파일 전체 F5\n"
        + "CREATE OR REPLACE " + s.rstrip() + "\n/\n")
    L(f"파일 백업 {fn} {len(s)}자 (LAST_DDL {ld})")

# ② 백업 패키지(컴파일본) — 이전 원본 ↔ 새 원본 등가 대조용
for typ, s in (('PACKAGE', spec), ('PACKAGE BODY', body)):
    try:
        c.execute('CREATE OR REPLACE ' + re.sub(r'\bPKG_DMF0082\b', BAK, s))
    except Exception as e:
        L(f"백업 패키지 {typ} 생성 경고 {str(e).splitlines()[0][:160]}")
c.execute("SELECT OBJECT_TYPE, STATUS FROM USER_OBJECTS WHERE OBJECT_NAME=:n ORDER BY 1", n=BAK)
bst = c.fetchall(); L(f"백업 패키지 {BAK} {bst}")
if not all(x[1] == 'VALID' for x in bst) or len(bst) != 2:
    L('중단 — 백업 패키지 VALID 아님 · 원본 무변경'); sys.exit(3)


# ③ 클라우드 패키지 SQL 그대로 실행
def run(f):
    text = open(os.path.join(PKGDIR, f), encoding='utf-8').read()
    c.callproc('DBMS_OUTPUT.ENABLE', [None])
    nf = 0
    L(f"── {f} {datetime.datetime.now().strftime('%H:%M:%S')}")
    for kind, s in run_sql.split_script(text, {}):
        sql = s.strip() if kind == 'block' else s.strip().rstrip(';')
        if not sql: continue
        try:
            c.execute(sql)
            if re.match(r'^\s*(WITH|SELECT)', sql, re.I):
                for rw in c.fetchall()[:8]: L(f"   {tuple(str(x)[:50] for x in rw[:9])}")
        except Exception as e:
            nf += 1; L(f"   FAIL {str(e).splitlines()[0][:220]}")
        lv, sv = c.var(str), c.var(int)
        while True:
            c.callproc('DBMS_OUTPUT.GET_LINE', (lv, sv))
            if sv.getvalue() != 0: break
            L('   > ' + (lv.getvalue() or ''))
    cx.commit()
    L(f"   → 실패 {nf}")
    return nf


bad = 0
for f in ('00_PRECHECK_CLOUD.sql', '10_BACKUP_PKG_DMF0082.sql', '20_APPLY_GMD_REPLACE.sql', '90_VERIFY.sql'):
    bad += run(f)
    if bad: L('중단 — 위 실패 확인'); sys.exit(4)

# ④ 원문 대조: 새 원본 BODY = 1104 BODY(이름만 원본) · SPEC 무변경
nb = src(TGT, 'PACKAGE BODY'); want = re.sub(r'\bPKG_DMF0082_1104\b', TGT, src(SRC, 'PACKAGE BODY'))
L(f"원문 대조 BODY(새 원본 = 1104 · 이름만 다름): {'동일' if nb.rstrip() == want.rstrip() else '불일치'} ({len(nb)}자)")
L(f"원문 대조 SPEC(무변경): {'동일' if src(TGT, 'PACKAGE') == spec else '불일치'}")
c.execute("SELECT OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM USER_OBJECTS WHERE OBJECT_NAME=:n ORDER BY 1", n=TGT)
L(f"최종 {TGT} {c.fetchall()} · 오류 {one('SELECT COUNT(*) FROM USER_ERRORS WHERE NAME=:n', n=TGT)[0]}")
L('== apply 끝')
