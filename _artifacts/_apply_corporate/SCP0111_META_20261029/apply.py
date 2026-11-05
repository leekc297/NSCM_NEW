# SCP0111 메타 보완 사내(ZIOUI1) 적용 — FRESH-GATE(적용 직전 대상 행 재조회) → 01_SCP0111_META.sql → 사후 검증
#   사용: python apply.py           (게이트·실행·검증 후 COMMIT)
#         python apply.py --dry     (게이트·실행·검증 후 ROLLBACK)
import sys, re, pathlib
sys.path.insert(0, r'C:\Projects\NSCM\tools\DbConn')
import dbconn

DRY = '--dry' in sys.argv
HERE = pathlib.Path(__file__).parent
con = dbconn.connect('tobe', write=True)
cur = con.cursor()

def one(sql, **b):
    cur.execute(sql, b); return cur.fetchall()

host = one("SELECT SYS_CONTEXT('USERENV','SERVER_HOST'), SYS_CONTEXT('USERENV','SERVICE_NAME'), TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL")[0]
print('DB', host)
assert host[1].lower() == 'zioui1', 'ZIOUI1 아님 — 중단'

# ---- FRESH-GATE: 착수 시(2026-10-29 11:2x) 실측값과 동일해야 진행 ----
api = one("SELECT API_URL, USE_YN FROM SCM_MGR.SCM_ADM_API_M WHERE API_ID='SCP0111_essPackLine_SEARCH'")
assert api == [('PKG_SCP0111.P_SCP0111_GET_ESS_PACK_LINE', 'Y')], f'FRESH-GATE API_M 변경: {api}'
proc = one("SELECT SORT_ORD, COL_NM, DATA_TP_CD, COL_TP_CD FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM='PKG_SCP0111.P_SCP0111_GET_ESS_PACK_LINE' ORDER BY SORT_ORD")
assert proc == [(100, 'o_rc1', 'CURSOR', 'OUT'), (101, 'O_RESULT_CURSOR', 'PROC_RESULT', 'OUT')], f'FRESH-GATE PROC_M 변경: {proc}'
args = one("SELECT a.POSITION, a.ARGUMENT_NAME, a.IN_OUT FROM ALL_ARGUMENTS a JOIN ALL_PROCEDURES p ON p.OWNER=a.OWNER AND p.OBJECT_NAME=a.PACKAGE_NAME AND p.SUBPROGRAM_ID=a.SUBPROGRAM_ID WHERE a.OWNER='SCM_MGR' AND a.PACKAGE_NAME='PKG_SCP0111' AND p.PROCEDURE_NAME='P_SCP0111_GET_ESS_PACK_LINE' AND a.DATA_LEVEL=0 ORDER BY a.POSITION")
assert args == [(1, 'O_RC', 'OUT'), (2, 'O_RESULT_CURSOR', 'OUT')], f'FRESH-GATE ALL_ARGUMENTS 변경: {args}'
btn_before = one("SELECT MNU_BTN_CD, API_ID FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID='SCP0111' AND SHT_NM='essPackLine'")
print('BTN_MPG essPackLine before', btn_before)
assert btn_before in ([], [('SEARCH', 'SCP0111_essPackLine_SEARCH')]), f'FRESH-GATE BTN_MPG 예상외 행: {btn_before}'
band = one("SELECT NVL(MAX(MSG_ID),'MSG01000') FROM SCM_MGR.SCM_ADM_MSG_M WHERE MSG_ID LIKE 'MSG%' AND MSG_ID >= 'MSG01001' AND MSG_ID <= 'MSG09999'")[0][0]
mine = one("SELECT MSG_ID, LANG_CD FROM SCM_MGR.SCM_ADM_MSG_M WHERE MSG_ID IN ('MSG01477','MSG01478') ORDER BY 1,2")
print('MSG band max', band, 'existing 1477/1478', mine)
# 채번 충돌 assert(hook #98 §7): 미적용 상태면 max=MSG01476, 재실행이면 내 6행만 존재
if not mine:
    assert band == 'MSG01476', f'채번 충돌 — 대역 max {band} (MSG01476 기대) · 재채번 필요'
else:
    assert len(mine) == 6, f'MSG01477/78 부분 존재(타 작업자 선점 의심) — 중단: {mine}'

# ---- 실행 ----
sql = (HERE / '01_SCP0111_META.sql').read_text(encoding='utf-8')
body = '\n'.join(l for l in sql.splitlines() if not l.lstrip().startswith('--'))
stmts = [s.strip() for s in body.split(';') if s.strip() and s.strip().upper() != 'COMMIT']
for s in stmts:
    cur.execute(s); print('OK', cur.rowcount, re.sub(r'\s+', ' ', s)[:70])

# ---- 사후 검증 (값 단언) ----
btn = one("SELECT MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN, CREATED_BY FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID='SCP0111' AND SHT_NM='essPackLine'")
print('BTN_MPG after', btn)
assert btn == [('SCP0111', 'essPackLine', 'SEARCH', 'SCP0111_essPackLine_SEARCH', 'Y', 'admin')] or (btn_before and len(btn) == 1)
msgs = one("SELECT MSG_ID, LANG_CD, MSG_TP_CD, USE_YN, CREATED_BY FROM SCM_MGR.SCM_ADM_MSG_M WHERE MSG_ID IN ('MSG01477','MSG01478') ORDER BY 1,2")
print('MSG after', msgs)
assert len(msgs) == 6 and all(m[2] == 'MSG' and m[3] == 'Y' for m in msgs)
# BE 해석 경로 실측: PR_GET_PROC_INFO_LIST(mnuId, shtNm, mnuBtnCd) 가 PROC_M 2행을 돌려주는가
import oracledb
oc = cur.var(oracledb.CURSOR)
cur.callproc('SCM_MGR.PKG_NSCM_UI_COMM.PR_GET_PROC_INFO_LIST', ['SCP0111', 'essPackLine', 'SEARCH', oc])
info = [tuple(r) for r in oc.getvalue().fetchall()]
print('PR_GET_PROC_INFO_LIST', info)
assert len(info) == 2 and {r[1] for r in info} == {'o_rc1', 'O_RESULT_CURSOR'}

if DRY:
    con.rollback(); print('DRY — ROLLBACK')
else:
    con.commit(); print('COMMIT', one("SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL")[0][0])
