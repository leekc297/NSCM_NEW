"""[E20261119-DMF0082ROWGOAL] PKG_DMF0082 BODY 3문장 FETCH FIRST 1 ROWS(1행 목표) 제거 패치 생성
기준본 = _base_body.txt (2026-11-19 17:48:46 ZIOUI1 ALL_SOURCE 조회, LAST_DDL 2026-11-17 19:51:52)
출력 = 01_PKG_DMF0082_BODY_ROWGOAL.sql (CREATE OR REPLACE 전체본)
"""
import os, sys
sys.path.insert(0, r'C:\Projects\NSCM\tools\DbConn')
import dbconn
D = os.path.dirname(os.path.abspath(__file__))
BASE = open(os.path.join(D, '_base_body.txt'), encoding='utf-8').read()
# FRESH-GATE: 생성 직전 DB 원문(ALL_SOURCE) 재조회 == 기준본
_c = dbconn.connect('tobe'); _k = _c.cursor()
_k.execute("select text from all_source where owner='SCM_MGR' and name='PKG_DMF0082' and type='PACKAGE BODY' order by line")
assert ''.join(r[0] for r in _k) == BASE, 'FRESH-GATE 실패: 기준본 이후 DB 원문 변경 — 중단·재조회'
L = BASE.split('\n')
M = '[E20261119-DMF0082ROWGOAL]'

def put(lineno, old, new):
    i = lineno - 1
    assert L[i] == old, (lineno, L[i])
    L[i] = new

# 이력 1줄 (24074 다음)
assert L[24073].startswith(' * 2026.11.03\tPOJ'), L[24073]
L.insert(24074, f" * 2026.11.19\tadmin\t\t{M} 대량 저장 검증 3문장(#5 Site/Item, #18 판가 삭제 40·81) FETCH FIRST 1 → MIN() 집계 (1행 목표 계획이 행마다 전체 조인 반복 → 운영 45,495행 827초+)")
off = 1

# #5 Site/Item Master Valid (원 24890 / 24904)
put(24890 + off, "            SELECT A.ITEM_ID INTO v_valid_item_id",
    f"            SELECT MIN(A.ITEM_ID) INTO v_valid_item_id  --{M} 종전 SELECT A.ITEM_ID ... FETCH FIRST 1 ROWS ONLY")
put(24904 + off, "            FETCH FIRST 1 ROWS ONLY;",
    f"            ;  --{M} FETCH FIRST 1 ROWS ONLY 제거 (위반 0건이면 MIN = NULL = 종전 NO_DATA_FOUND 와 같은 결과)")

# #18 판가 삭제 40 (원 25706 / 25757)
s18 = "                SELECT '● Sales Site : ' || F.SCM_SITE_ID || ' / ● Model : ' || F.ITEM_ID"
put(25706 + off, s18,
    f"                SELECT MIN('● Sales Site : ' || F.SCM_SITE_ID || ' / ● Model : ' || F.ITEM_ID)  --{M}")
put(25757 + off, "                FETCH FIRST 1 ROWS ONLY;",
    f"                ;  --{M} FETCH FIRST 1 ROWS ONLY 제거")

# #18 판가 삭제 81 (원 25778 / 25824)
put(25778 + off, s18,
    f"                SELECT MIN('● Sales Site : ' || F.SCM_SITE_ID || ' / ● Model : ' || F.ITEM_ID)  --{M}")
put(25824 + off, "                FETCH FIRST 1 ROWS ONLY;",
    f"                ;  --{M} FETCH FIRST 1 ROWS ONLY 제거")

body = '\n'.join(L)
open(os.path.join(D, '_fixed_body.txt'), 'w', encoding='utf-8').write(body)
src = open(os.path.join(D, '00_BACKUP_PKG_DMF0082_BODY.ASIS.sql'), encoding='utf-8').readline().strip()
open(os.path.join(D, '01_PKG_DMF0082_BODY_ROWGOAL.sql'), 'w', encoding='utf-8').write(
    src + '\n' + f'-- {M} 대상 = 저장 SP P_DMF0082_SAVE_MAIN_DATA 3문장 + 이력 1줄 (그 밖의 줄 변경 없음)\n'
    + 'CREATE OR REPLACE ' + body.rstrip() + '\n/\n')
print('ok', body.count(M))
