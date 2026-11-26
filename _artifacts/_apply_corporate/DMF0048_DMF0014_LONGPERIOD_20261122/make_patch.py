"""[E20261122-LONGPERIOD] DMF0048 Daily 1년 이상 · DMF0014 Daily 2년 조회 Sql Error 보완 패치 생성

원인(사내 ZIOUI1 SCM_SYS_LOG_BATCH 2026-11-22 실측)
  PKG_DMF0048 1828행  ORA-22835 : FN_SPLITSTRING(V_PV_LIST) 입력 VARCHAR2 4000 바이트 초과(1년 4,815 · 2년 9,620)
  PKG_DMF0048 2327~2328행        : REPLACE 바꿀 문자열 32K 초과 잠복(3년 PIVOT IN 35,468 → ORA-22828)
  PKG_DMF0014 6649행  ORA-22828 : REPLACE(V_SQL_TEXT,'v_iteration',V_ITERATION) 바꿀 문자열 32K 초과(Daily 2년)
보완
  DMF0048 1) 칸 목록 자르기를 PL/SQL 안 DBMS_LOB 로 처리  2) 큰 목록 2개는 REPLACE 대신 잘라 붙이기
          3) SELECT 칸 수 1,000 초과 시 원인 문구로 오류(MSG01505 · 화면 사전 알림은 FE 가이드)
  DMF0014 6649행 REPLACE 대신 잘라 붙이기
기준본 = 이 스크립트 실행 시 ALL_SOURCE 새로 조회(#152). 치환은 고유 매칭 assert.
"""
import sys, os
sys.path.insert(0, r'C:\Projects\NSCM\tools\DbConn')
import dbconn

D = os.path.dirname(os.path.abspath(__file__))
MK = '[E20261122-LONGPERIOD]'

c = dbconn.connect('tobe'); k = c.cursor()
k.execute("select to_char(sysdate,'YYYY-MM-DD HH24:MI:SS') from dual"); FETCHED = k.fetchone()[0]


def fetch(name):
    k.execute("select to_char(last_ddl_time,'YYYY-MM-DD HH24:MI:SS'), status from all_objects "
              "where owner='SCM_MGR' and object_name=:n and object_type='PACKAGE BODY'", n=name)
    ddl, st = k.fetchone()
    k.execute("select text from all_source where owner='SCM_MGR' and name=:n and type='PACKAGE BODY' order by line", n=name)
    return ''.join(r[0] for r in k), ddl, st


def sub(src, old, new, label):
    n = src.count(old)
    assert n == 1, f'{label}: 대상 매칭 {n}건(1건이어야 함) — 원문이 바뀌었거나 이미 반영됨'
    return src.replace(old, new)


# ---------------- PKG_DMF0048 ----------------
b48, ddl48, st48 = fetch('PKG_DMF0048')
assert MK not in b48, 'PKG_DMF0048 이미 반영됨'

OLD48_1 = """        V_PIVOT_IN := NULL;
        FOR R IN (SELECT VALUE FROM TABLE(FN_SPLITSTRING(V_PV_LIST, ','))) LOOP
            IF V_PIVOT_IN IS NOT NULL THEN
                V_PIVOT_IN := V_PIVOT_IN || ',';
            END IF;
            V_PIVOT_IN := V_PIVOT_IN || '''' || R.VALUE || ''' AS ' || R.VALUE;
        END LOOP;
"""
NEW48_1 = """        V_PIVOT_IN := NULL;
-- 2026.11.22 """ + MK + """ FN_SPLITSTRING 입력 VARCHAR2 4000 바이트 한도(Daily 1년 4,815 → ORA-22835) — 칸 목록을 PL/SQL 안에서 직접 자름 (START)
        -- FOR R IN (SELECT VALUE FROM TABLE(FN_SPLITSTRING(V_PV_LIST, ','))) LOOP
        --     IF V_PIVOT_IN IS NOT NULL THEN
        --         V_PIVOT_IN := V_PIVOT_IN || ',';
        --     END IF;
        --     V_PIVOT_IN := V_PIVOT_IN || '''' || R.VALUE || ''' AS ' || R.VALUE;
        -- END LOOP;
        DECLARE
            V_LP_POS  PLS_INTEGER := 1;
            V_LP_NEXT PLS_INTEGER;
            V_LP_VAL  VARCHAR2(100);
        BEGIN
            IF V_PV_LIST IS NOT NULL THEN
                LOOP
                    V_LP_NEXT := DBMS_LOB.INSTR(V_PV_LIST, ',', V_LP_POS);
                    V_LP_VAL  := TRIM(CASE WHEN V_LP_NEXT = 0 THEN DBMS_LOB.SUBSTR(V_PV_LIST, 100, V_LP_POS)
                                           ELSE DBMS_LOB.SUBSTR(V_PV_LIST, V_LP_NEXT - V_LP_POS, V_LP_POS) END);
                    IF V_PIVOT_IN IS NOT NULL THEN
                        V_PIVOT_IN := V_PIVOT_IN || ',';
                    END IF;
                    V_PIVOT_IN := V_PIVOT_IN || '''' || V_LP_VAL || ''' AS ' || V_LP_VAL;
                    EXIT WHEN V_LP_NEXT = 0;
                    V_LP_POS := V_LP_NEXT + 1;
                END LOOP;
            END IF;
        END;
-- 2026.11.22 """ + MK + """ (END)
"""
b48n = sub(b48, OLD48_1, NEW48_1, 'DMF0048-1 칸 목록 자르기')

OLD48_2 = """            V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'V_PV_COL_LIST', V_PV_COL_LIST); -- 3. SELECT절용 (긴 것 먼저)
            V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'V_PV_LIST', V_PIVOT_IN); -- 4. PIVOT IN용
"""
NEW48_2 = """-- 2026.11.22 """ + MK + """ REPLACE 바꿀 문자열 32K 한도(ORA-22828) — 큰 목록 2개는 자리표시 위치에 잘라 붙임 · SELECT 칸 1,000개 초과는 원인 문구로 오류 (START)
            -- V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'V_PV_COL_LIST', V_PV_COL_LIST); -- 3. SELECT절용 (긴 것 먼저)
            -- V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'V_PV_LIST', V_PIVOT_IN); -- 4. PIVOT IN용
            IF NVL(REGEXP_COUNT(V_COLLIST, ','), 0) + NVL(REGEXP_COUNT(V_PV_COL_LIST, ','), 0) + 4 > 1000 THEN
                RAISE_APPLICATION_ERROR(-20010, 'MSG01505 조회 칸 수 ' || TO_CHAR(NVL(REGEXP_COUNT(V_COLLIST, ','), 0) + NVL(REGEXP_COUNT(V_PV_COL_LIST, ','), 0) + 4)
                                               || '개가 1,000개를 넘습니다(Bucket ' || P_BUCKET || ' ' || P_FROM_YYYYMMDD || '~' || P_TO_YYYYMMDD || ').');
            END IF;
            V_SQL_TEXT := SUBSTR(V_SQL_TEXT, 1, INSTR(V_SQL_TEXT, 'V_PV_COL_LIST') - 1) || V_PV_COL_LIST
                       || SUBSTR(V_SQL_TEXT, INSTR(V_SQL_TEXT, 'V_PV_COL_LIST') + LENGTH('V_PV_COL_LIST')); -- 3. SELECT절용
            V_SQL_TEXT := SUBSTR(V_SQL_TEXT, 1, INSTR(V_SQL_TEXT, 'V_PV_LIST') - 1) || V_PIVOT_IN
                       || SUBSTR(V_SQL_TEXT, INSTR(V_SQL_TEXT, 'V_PV_LIST') + LENGTH('V_PV_LIST')); -- 4. PIVOT IN용
-- 2026.11.22 """ + MK + """ (END)
"""
b48n = sub(b48n, OLD48_2, NEW48_2, 'DMF0048-2 큰 목록 잘라 붙이기')

# ---------------- PKG_DMF0014 ----------------
b14, ddl14, st14 = fetch('PKG_DMF0014')
assert MK not in b14, 'PKG_DMF0014 이미 반영됨'
OLD14 = """        V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'v_iteration', V_ITERATION);
"""
NEW14 = """-- 2026.11.22 """ + MK + """ REPLACE 바꿀 문자열 32K 한도(Daily 2년 ORA-22828) — 기간 칸 목록을 자리표시 위치에 잘라 붙임 (START)
        -- V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'v_iteration', V_ITERATION);
        V_SQL_TEXT := SUBSTR(V_SQL_TEXT, 1, INSTR(V_SQL_TEXT, 'v_iteration') - 1) || V_ITERATION
                   || SUBSTR(V_SQL_TEXT, INSTR(V_SQL_TEXT, 'v_iteration') + LENGTH('v_iteration'));
-- 2026.11.22 """ + MK + """ (END)
"""
b14n = sub(b14, OLD14, NEW14, 'DMF0014 v_iteration 잘라 붙이기')

# 자리표시 1건 확인(잘라 붙이기는 첫 위치 1건만 바꿈 — REPLACE 와 같은 결과가 되려면 1건이어야 함)
for src, tok in ((b48, "'SELECT V_COLUMN\n                    , SORT_ORDER_NO\n                    , V_PV_COL_LIST"), (b48, 'IN ( V_PV_LIST )'), (b14, '             v_iteration\n')):
    assert src.count(tok) == 1, f'자리표시 확인 실패: {tok!r}'

for name, base, new, ddl, st in (('PKG_DMF0048', b48, b48n, ddl48, st48), ('PKG_DMF0014', b14, b14n, ddl14, st14)):
    open(os.path.join(D, f'_base_{name}_BODY.txt'), 'w', encoding='utf-8', newline='').write(base)
    open(os.path.join(D, f'_fixed_{name}_BODY.txt'), 'w', encoding='utf-8', newline='').write(new)
    stamp = f'-- SOURCE-FRESH: SCM_MGR.{name} PACKAGE BODY LAST_DDL={ddl} FETCHED={FETCHED[:16]} DB=ZIOUI1\n'
    open(os.path.join(D, f'00_BACKUP_{name}_BODY.ASIS.sql'), 'w', encoding='utf-8', newline='').write(
        stamp + 'CREATE OR REPLACE ' + base.rstrip() + '\n/\n')
    print(name, 'LAST_DDL', ddl, st, '| 줄 수', base.count('\n'), '→', new.count('\n'))
# FRESH-GATE(추출 직후): 기준본 저장 뒤 DB 원문 재조회 == 기준본. 적용 직전 FRESH-GATE 는 apply.py 가 다시 한다.
assert fetch('PKG_DMF0048')[0] == b48 and fetch('PKG_DMF0014')[0] == b14, 'FRESH-GATE 실패: 추출 중 DB 원문 변경 — 재실행'
print('FETCHED', FETCHED)
