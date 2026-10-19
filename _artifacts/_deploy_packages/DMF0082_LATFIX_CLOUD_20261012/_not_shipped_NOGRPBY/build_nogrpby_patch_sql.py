# -*- coding: utf-8 -*-
"""[E20261012-DMF0082NOGRPBY] 클라우드 패치형 SQL 생성기 — 11_APPLY_NOGRPBY_PATCH.sql / 98_ROLLBACK_NOGRPBY_PATCH.sql.

OLD 블록 = **지금 사내 DB(USER_SOURCE) 에서 읽은** LATFIX 적용 뒤 MF_SP INSERT 문장 (INSERT 줄 ~ GROUP BY 마지막 줄) — 클라우드 BODY 의 같은 구간과
동일해야 한다(AJS 10-08~12 변경은 이 구간 밖 — 사내 실측). NEW 블록 = latfix_patches.nogrpby(OLD).
FRESH-GATE: 생성 시점 사내 LAST_DDL 을 파일 머리에 기록. 클라우드 10/11 은 적용 직전 자기 USER_SOURCE 를 읽어 OLD 블록과 **정확히 일치**할 때만 치환한다.
사용: python build_nogrpby_patch_sql.py   (사내 NOGRPBY 적용 전에 실행 — 적용 뒤에는 OLD 블록이 사라져 생성 불가)
"""
import datetime, io, pathlib, re, sys
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace", line_buffering=True)
HERE = pathlib.Path(__file__).resolve().parent
DIAG = HERE.parents[1] / "_diagnostics"
sys.path.insert(0, str(DIAG))
sys.path.insert(0, str(DIAG / "DMF0082_LATFIX_20261012"))
from ora import conn_info
import oracledb
import latfix_patches

MARK = latfix_patches.MARK2
u, p, d = conn_info()
cn = oracledb.connect(user=u, password=p, dsn=d)
cur = cn.cursor()
cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082' AND OBJECT_TYPE='PACKAGE BODY'")
ddl0 = cur.fetchone()[0]
cur.execute("SELECT TEXT FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' ORDER BY LINE")
src = "".join(t or "" for (t,) in cur)
cn.close()
assert src.count(latfix_patches.MARK) == 2 and MARK not in src, "사내 원문 상태가 LATFIX 적용·NOGRPBY 미적용이 아님"

s0 = src.index("    INSERT /*[E20260812-PERF] APPEND PARALLEL 제거")
s1 = src.index(", CAL.YYYYMM, CAL.YYYYMMWW, CAL.WEEK_END_YN, CAL.MONTH_END_YN;", s0)
s1 = src.index("\n", s1) + 1
old_blk = src[s0:s1]
new_blk, n = latfix_patches.nogrpby(old_blk)
assert n == 52 and src.count(old_blk) == 1
for blk in (old_blk, new_blk):
    assert "}'" not in blk and "'}" not in blk, "q'{ }' 구분자 충돌"
    assert len(blk.encode("utf-8")) < 30000, "블록 32767 바이트 초과"
hist = " * 2026.01.30       jssbae       [E20260130-001907]_FCST&PRICE MGMT Cutoff 버전 조회 대상 테이블 변경\n"
hist2 = hist + (f" * 2026.10.12       admin        [{MARK}] MF_SP INSERT 의 항등 GROUP BY(그룹=1행 · 직전 중복제거 블록이 키 유일 보장) 제거 —\n"
                f" *                               60속성 15만~44만 행 SORT GROUP BY·TEMP 유출 제거 (hook #129 1-b · 6커서 전행 동일 + 시나리오 매트릭스 검증)\n")
assert src.count(hist) == 1
now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")


def lit(s):  # PL/SQL q'{...}' 리터럴 (줄바꿈 포함 그대로)
    return "q'{" + s + "}'"


COMMON = f"""SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_src   CLOB;
    v_new   CLOB;
    v_st    VARCHAR2(30);
    v_err   PLS_INTEGER;
    c_mark  CONSTANT VARCHAR2(40) := '{MARK}';
    c_lat   CONSTANT VARCHAR2(40) := '{latfix_patches.MARK}';
    c_old   CONSTANT VARCHAR2(32767) := {lit(old_blk)};
    c_new   CONSTANT VARCHAR2(32767) := {lit(new_blk)};
    c_hist  CONSTANT VARCHAR2(32767) := {lit(hist)};
    c_hist2 CONSTANT VARCHAR2(32767) := {lit(hist2)};
    FUNCTION cnt(p_src CLOB, p_tok VARCHAR2) RETURN PLS_INTEGER IS
        n PLS_INTEGER := 0; pos PLS_INTEGER := 1;
    BEGIN
        LOOP
            pos := DBMS_LOB.INSTR(p_src, p_tok, pos);
            EXIT WHEN pos = 0 OR pos IS NULL;
            n := n + 1; pos := pos + LENGTH(p_tok);
        END LOOP;
        RETURN n;
    END;
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_src, TRUE);
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_src, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
    v_src := REPLACE(v_src, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화 (앵커는 LF 기준)
"""

APPLY = f"""-- 11_APPLY — [{MARK}] MF_SP INSERT 항등 GROUP BY 제거 (hook #129 1-b) — 패치형 (전체 F5, 값 입력 없음, 멱등)
-- 선행: 10_APPLY_LATFIX_PATCH (LATFIX 마커 2곳 필요 — OLD 블록이 LATFIX 적용 뒤 문장이다)
-- 방식: 이 DB 의 USER_SOURCE 를 읽어 MF_SP INSERT 문장 블록이 OLD 와 **정확히 일치**할 때만 NEW 로 치환 + History 2줄. 불일치 = 중단·원문 무변경.
-- 등가 근거: 직전 중복제거 블록(DEDUPCHK/ROW_NUMBER DELETE)이 F 를 키 유일로 보장하고 그 뒤 F 쓰기 없음 · CAL(캘린더 일자 유일)·PVT·VD 조인키 유일
--           → 그룹 = 1행 → SUM/MAX 항등 (사내 실측 152,390/152,390 · 184,612/184,612 · 6커서 전행 동일 + 시나리오 매트릭스)
-- 생성: 사내 ZIOUI1 LAST_DDL={ddl0} 원문의 블록을 OLD 로 추출 ({now}) — build_nogrpby_patch_sql.py
{COMMON}    IF cnt(v_src, c_mark) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 이미 적용됨 (마커 ' || cnt(v_src, c_mark) || '곳). 원문 무변경');
        RETURN;
    END IF;
    IF cnt(v_src, c_lat) <> 2 THEN
        RAISE_APPLICATION_ERROR(-20021, '중단 — 선행 LATFIX 마커 ' || cnt(v_src, c_lat) || '곳 (2 기대). 10_APPLY_LATFIX_PATCH 먼저');
    END IF;
    IF cnt(v_src, c_old) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20022, '중단 — MF_SP INSERT 블록이 사내 기준과 다름 (매칭 ' || cnt(v_src, c_old) || '건). 원문 비교 필요');
    END IF;
    IF cnt(v_src, c_hist) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20023, '중단 — History 앵커 매칭 ' || cnt(v_src, c_hist) || '건 (1 기대)');
    END IF;
    v_new := REPLACE(REPLACE(v_src, c_old, c_new), c_hist, c_hist2);
    IF cnt(v_new, c_mark) <> 3 THEN
        RAISE_APPLICATION_ERROR(-20024, '중단 — 치환 결과 마커 ' || cnt(v_new, c_mark) || '곳 (3 기대)');
    END IF;
    EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
    SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0082' AND OBJECT_TYPE = 'PACKAGE BODY';
    SELECT COUNT(*) INTO v_err FROM USER_ERRORS WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY';
    IF v_st <> 'VALID' OR v_err > 0 THEN
        FOR e IN (SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY' ORDER BY SEQUENCE FETCH FIRST 10 ROWS ONLY) LOOP
            DBMS_OUTPUT.PUT_LINE('  ERR L' || e.LINE || ':' || e.POSITION || ' ' || e.TEXT);
        END LOOP;
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_src;
        RAISE_APPLICATION_ERROR(-20025, '컴파일 실패(' || v_st || ', 오류 ' || v_err || ') → 원문 복원함');
    END IF;
    DBMS_OUTPUT.PUT_LINE('APPLIED — PKG_DMF0082 BODY ' || v_st || ' · 마커 ' || cnt(v_new, c_mark) || '곳 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082' ORDER BY OBJECT_TYPE;
"""

ROLLBACK = f"""-- 98 ROLLBACK — [{MARK}] 역치환 (NEW 블록 → OLD 블록, History 2줄 제거). 전체 F5, 멱등. 마커 없으면 무동작
{COMMON}    IF cnt(v_src, c_mark) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 마커 없음(미적용 상태). 원문 무변경');
        RETURN;
    END IF;
    IF cnt(v_src, c_new) <> 1 OR cnt(v_src, c_hist2) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20031, '중단 — 역치환 앵커 매칭 블록 ' || cnt(v_src, c_new) || ' / History ' || cnt(v_src, c_hist2) || ' (각 1 기대)');
    END IF;
    v_new := REPLACE(REPLACE(v_src, c_new, c_old), c_hist2, c_hist);
    IF cnt(v_new, c_mark) <> 0 THEN
        RAISE_APPLICATION_ERROR(-20032, '중단 — 역치환 뒤 마커 잔존 ' || cnt(v_new, c_mark));
    END IF;
    EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
    SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0082' AND OBJECT_TYPE = 'PACKAGE BODY';
    SELECT COUNT(*) INTO v_err FROM USER_ERRORS WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY';
    DBMS_OUTPUT.PUT_LINE('ROLLED BACK — PKG_DMF0082 BODY ' || v_st || ' · 오류 ' || v_err || ' · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT COUNT(*) FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{MARK}%') MARKERS
  FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082' ORDER BY OBJECT_TYPE;
"""
(HERE / "A_DB" / "11_APPLY_NOGRPBY_PATCH.sql").write_text(APPLY, encoding="utf-8")
(HERE / "A_DB" / "98_ROLLBACK_NOGRPBY_PATCH.sql").write_text(ROLLBACK, encoding="utf-8")
print(f"생성 완료 — OLD {len(old_blk)}자/{len(old_blk.encode('utf-8'))}B · NEW {len(new_blk)}자/{len(new_blk.encode('utf-8'))}B · 사내 LAST_DDL {ddl0}")
