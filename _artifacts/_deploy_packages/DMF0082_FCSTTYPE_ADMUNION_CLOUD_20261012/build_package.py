"""DMF0082 FCST Type 콤보 — 관리자 그룹 + DM Planner (W/S) 겸직자는 81 에서 일반 유형 ∪ W/S 유형 [E20261012-FCSTTYPEADM]

사용자 신고(2026-10-12 클라우드): Division 81 · minyonglee1(ADMIN) Insert Row 의 FCST Type 에 W/S 유형 6종만 보인다.
원인: 콤보 SQL 2종이 81 에서 'DM Planner (W/S)' 보유 여부만 보고 W/S 유형만 준다 (ADMIN 보유는 판정에 없음 — 08-14 등록 이래 동일).
조치(사용자 승인 1안, 2026-10-12): 관리자 그룹(ADMIN · DM ADMIN · SCM PI Admin)을 함께 가진 사용자는 81 에서
  일반 유형(SALES_TYPE_CODE, W/S 전용 제외) + W/S 유형을 모두 받는다 (중복 코드는 한 번만).
  W/S 만 가진 사용자, W/S + DM Planner 사용자, 비 W/S 사용자, 40 조회는 종전과 동일.

방식: 패치형 — 대상 DB 의 등록 SQL 원문에 정규식 치환 2곳 (사내·클라우드 원문이 줄바꿈·TO_CHAR 유무로 다르므로 전체 교체 금지).
  치환식은 이 파일 한 곳에서 정의하고 10_APPLY / 99_ROLLBACK / 검증이 같은 식을 쓴다.

  python build_package.py dry     # 사내 현재본 + 클라우드 동형본(BK20260907 = 08-31 판)에 치환을 적용해 보고 결과·케이스 검증 (무변경)
  python build_package.py build   # A_DB/*.sql 생성
"""
import sys, os, io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
MARK = "E20261012-FCSTTYPEADM"
IDS = ("FcstTypeEditDMF0082", "FcstTypeByUserGroupDMF0082")
BAK = "SCM_ADM_CMBO_SQL_M_BAK20261012_FTADM"

# ── 치환식 (Oracle 정규식) ─────────────────────────────────────────────────────────────────
#   WS  = 'DM Planner (W/S)' 보유 판정의 끝부분 (사내 G.USE_YN / 클라우드 TO_CHAR(G.USE_YN) 양쪽 대응)
WS = r"G\.USER_GR_ID\s*=\s*'DM Planner \(W/S\)'\s+AND\s+(TO_CHAR\(G\.USE_YN\)|G\.USE_YN)\s*=\s*'Y'\s*\)"
#   P1  = 첫 분기(W/S 유형)의 W/S 판정 바로 뒤가 UNION ALL 인 곳 — SQL 당 정확히 1곳
P1 = "(" + WS + r")(\s+UNION ALL)"
#   P2  = 둘째 분기(일반 유형)의 `NOT ( 81 계열 AND W/S 보유 )` — SQL 당 정확히 1곳
P2 = (r"(NOT\s*\(\s*NVL\(TRIM\(@divisionId\),\s*'-'\)\s+LIKE\s+'81%'\s+AND\s+EXISTS\s*\(\s*SELECT 1 FROM SCM_MGR\.SCM_ADM_USER_GR_MPG_M G\s+"
      r"WHERE\s+G\.USER_ID\s*=\s*@sesUserId\s+AND\s+" + WS + r"\s*\))")
ADM = ("EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M A WHERE A.USER_ID = @sesUserId "
       "AND A.USER_GR_ID IN ('ADMIN', 'DM ADMIN', 'DM Planner', 'SCM PI Admin') AND TO_CHAR(A.USE_YN) = 'Y')")
#   R1  = W/S 분기: 관리자 겸직자는 일반 유형과 겹치는 코드를 여기서 빼 중복을 막는다
R1 = (r"\1 /* [" + MARK + "] 일반 그룹 겸직자는 일반 유형도 함께 받으므로 겹치는 코드는 여기서 제외(중복 방지) */ "
      "AND NOT ( SEGMENT1 IN (SELECT S.SEGMENT1 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL S WHERE S.LOOKUP_TYPE = 'SALES_TYPE_CODE' "
      "AND S.VALID_YN = 'Y' AND NVL(S.ATTRIBUTE2, ' ') <> 'Y') AND " + ADM + r" )\3")
#   R2  = 일반 분기: 관리자 그룹 겸직자는 81 + W/S 여도 일반 유형을 받는다
R2 = r"( \1 OR " + ADM + " )"
# 역치환(원복)용 — 적용 후 문구를 그대로 찾아 지운다
U1 = R1[len(r"\1"):-len(r"\3")]
U2_HEAD, U2_TAIL = "( ", " OR " + ADM + " )"


def connect():
    u, p, d = conn_info()
    cn = oracledb.connect(user=u, password=p, dsn=d)
    cn.call_timeout = 300000
    return cn


def transform(cur, text):
    cur.execute("SELECT REGEXP_COUNT(:t, :p1), REGEXP_COUNT(:t, :p2) FROM dual", t=text, p1=P1, p2=P2)
    c1, c2 = cur.fetchone()
    if (c1, c2) != (1, 1):
        raise SystemExit(f"ABORT: 앵커 매칭 P1={c1} P2={c2} (각 1 기대)")
    cur.execute("SELECT REGEXP_REPLACE(REGEXP_REPLACE(:t, :p2, :r2), :p1, :r1) FROM dual", t=text, p1=P1, p2=P2, r1=R1, r2=R2)
    return cur.fetchone()[0]


def untransform(new):
    out = new.replace(U1, "")
    i = out.index(U2_TAIL)
    j = out.rindex(U2_HEAD + "NOT", 0, i)
    return out[:j] + out[j + len(U2_HEAD):i] + out[i + len(U2_TAIL):]


def run_combo(cur, text, div, user):
    sql = text.replace("@divisionId", f"'{div}'").replace("@sesUserId", f"'{user}'")
    cur.execute(sql)
    return [r[0] for r in cur.fetchall()]


def pick_users(cur):
    def one(sql):
        cur.execute(sql)
        r = cur.fetchone()
        return r[0] if r else None
    base = ("SELECT G.USER_ID FROM SCM_ADM_USER_GR_MPG_M G WHERE G.USE_YN = 'Y' GROUP BY G.USER_ID HAVING ")
    ws = "MAX(CASE WHEN G.USER_GR_ID = 'DM Planner (W/S)' THEN 1 ELSE 0 END)"
    adm = "MAX(CASE WHEN G.USER_GR_ID IN ('ADMIN','DM ADMIN','SCM PI Admin') THEN 1 ELSE 0 END)"
    dmp = "MAX(CASE WHEN G.USER_GR_ID = 'DM Planner' THEN 1 ELSE 0 END)"
    tail = " ORDER BY CASE G.USER_ID WHEN 'minyonglee1' THEN 0 ELSE 1 END, G.USER_ID FETCH FIRST 1 ROWS ONLY"
    return {
        "관리자+W/S": one(base + f"{ws}=1 AND {adm}=1" + tail),
        "W/S 단독": one(base + f"{ws}=1 AND {adm}=0 AND {dmp}=0" + tail),
        "W/S+DM Planner": one(base + f"{ws}=1 AND {adm}=0 AND {dmp}=1" + tail),
        "비 W/S": one(base + f"{ws}=0 AND {dmp}=1 AND {adm}=0" + tail),
    }


def dry():
    with connect() as cn:
        cur = cn.cursor()
        users = pick_users(cur)
        print("케이스 사용자:", users)
        ok = True
        for src, label in (("SCM_ADM_CMBO_SQL_M", "사내 현재본"), ("SCM_ADM_CMBO_SQL_M_BK20260907", "클라우드 동형본(08-31 판)")):
            for sid in IDS:
                cur.execute(f"SELECT sql_dtl_ctn FROM {src} WHERE sql_id = :s", s=sid)
                old = cur.fetchone()[0]
                if MARK in old:
                    print(f"[{label}] {sid}: 이미 적용됨 — 건너뜀"); continue
                new = transform(cur, old)
                back = untransform(new)
                print(f"[{label}] {sid}: {len(old)} → {len(new)}자 · {len(new.encode('utf-8'))}바이트 · 역치환 원문 복원 {back == old}")
                ok &= back == old and len(new.encode('utf-8')) <= 4000
                for case, user in users.items():
                    if not user: continue
                    for div in ("81", "40"):
                        a, b = run_combo(cur, old, div, user), run_combo(cur, new, div, user)
                        exp_change = case in ("관리자+W/S", "W/S+DM Planner") and div == "81"
                        good = (a != b) == exp_change and len(b) == len(set(b))
                        ok &= good
                        print(f"     {case:14s} {user:12s} div {div}: {len(a):2d} → {len(b):2d}종 {'변경' if a != b else '동일'} {'OK' if good else 'FAIL'}"
                              + (f"  추가 {sorted(set(b) - set(a))}" if a != b else ""))
        print("DRY", "PASS" if ok else "FAIL")
        cn.rollback()


def q(s):
    return s.replace("'", "''")


def build():
    os.makedirs(os.path.join(HERE, "A_DB"), exist_ok=True)
    apply_sql = f"""-- 10_APPLY — [{MARK}] DMF0082 FCST Type 콤보 2종 패치 (전체 F5, 값 입력 없음, 멱등)
-- 증상: Division 81 에서 관리자 그룹(ADMIN 등)과 'DM Planner (W/S)' 를 함께 가진 사용자의 Insert 행 FCST Type 후보가 W/S 유형 6종뿐
-- 원인: 콤보 SQL 이 81 에서 'DM Planner (W/S)' 보유만 보고 W/S 유형만 준다 (관리자 그룹 보유는 판정에 없음)
-- 조치(사용자 확정 2026-10-12): 일반 그룹(ADMIN · DM ADMIN · DM Planner · SCM PI Admin) 겸직자는 81 에서 일반 유형 + W/S 유형을 모두 받는다 (중복 코드 1회)
--       "W/S + DM Planner 사용자도 DM Planner 가 할 수 있는 모든 것을 할 수 있어야 한다"
--       W/S 만 가진 사용자 · 비 W/S 사용자 · 40 조회는 종전과 동일
-- 방식: 이 DB 의 등록 SQL 원문(SCM_ADM_CMBO_SQL_M.SQL_DTL_CTN)에 정규식 치환 2곳. 사내·클라우드 원문이 달라 전체 교체하지 않는다.
-- 가드: 마커 있으면 무동작 · 앵커가 각 1곳이 아니면 중단(무변경) · 4000바이트 초과 시 중단 · 적용 전 원문을 {BAK} 에 보관
-- 원복: 99_ROLLBACK_FCSTTYPE_ADMUNION.sql
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    c_mark CONSTANT VARCHAR2(40)   := '{MARK}';
    c_p1   CONSTANT VARCHAR2(2000) := '{q(P1)}';
    c_p2   CONSTANT VARCHAR2(2000) := '{q(P2)}';
    c_r1   CONSTANT VARCHAR2(4000) := '{q(R1)}';
    c_r2   CONSTANT VARCHAR2(2000) := '{q(R2)}';
    v_new  VARCHAR2(32767);
    n_bak  PLS_INTEGER;
    n_done PLS_INTEGER := 0;
BEGIN
    SELECT COUNT(*) INTO n_bak FROM USER_TABLES WHERE TABLE_NAME = '{BAK}';
    IF n_bak = 0 THEN
        EXECUTE IMMEDIATE 'CREATE TABLE {BAK} AS SELECT * FROM SCM_ADM_CMBO_SQL_M WHERE SQL_ID IN (''{IDS[0]}'',''{IDS[1]}'')';
        DBMS_OUTPUT.PUT_LINE('BACKUP — {BAK} 생성 (적용 전 원문 2행)');
    END IF;
    FOR r IN (SELECT SQL_ID, SQL_DTL_CTN FROM SCM_ADM_CMBO_SQL_M WHERE SQL_ID IN ('{IDS[0]}','{IDS[1]}') ORDER BY SQL_ID) LOOP
        IF INSTR(r.SQL_DTL_CTN, c_mark) > 0 THEN
            DBMS_OUTPUT.PUT_LINE('SKIP — ' || r.SQL_ID || ' 이미 적용됨');
        ELSE
            IF REGEXP_COUNT(r.SQL_DTL_CTN, c_p1) <> 1 OR REGEXP_COUNT(r.SQL_DTL_CTN, c_p2) <> 1 THEN
                ROLLBACK;
                RAISE_APPLICATION_ERROR(-20001, '중단 — ' || r.SQL_ID || ' 앵커 매칭 ' || REGEXP_COUNT(r.SQL_DTL_CTN, c_p1) || '/' || REGEXP_COUNT(r.SQL_DTL_CTN, c_p2)
                                                || ' (각 1 기대). 등록 SQL 원문이 예상과 다름 → 00_PRECHECK 결과 회신. 변경 취소함');
            END IF;
            v_new := REGEXP_REPLACE(REGEXP_REPLACE(r.SQL_DTL_CTN, c_p2, c_r2), c_p1, c_r1);
            IF LENGTHB(v_new) > 4000 THEN
                ROLLBACK;
                RAISE_APPLICATION_ERROR(-20002, '중단 — ' || r.SQL_ID || ' 치환 결과 ' || LENGTHB(v_new) || '바이트 (4000 초과). 변경 취소함');
            END IF;
            UPDATE SCM_ADM_CMBO_SQL_M SET SQL_DTL_CTN = v_new, LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE WHERE SQL_ID = r.SQL_ID;
            n_done := n_done + 1;
            DBMS_OUTPUT.PUT_LINE('APPLIED — ' || r.SQL_ID || ' ' || LENGTHB(r.SQL_DTL_CTN) || ' → ' || LENGTHB(v_new) || '바이트');
        END IF;
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('DONE — ' || n_done || '건 적용 · COMMIT · ' || TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS'));
END;
/
"""
    rollback_sql = f"""-- 99 ROLLBACK — [{MARK}] 10_APPLY 가 보관한 적용 전 원문으로 되돌린다 (전체 F5, 멱등)
-- 대상 = 지금 마커가 들어 있는 행만. 보관 테이블 {BAK} 이 없으면 무동작.
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    n_bak  PLS_INTEGER;
    n_done PLS_INTEGER := 0;
BEGIN
    SELECT COUNT(*) INTO n_bak FROM USER_TABLES WHERE TABLE_NAME = '{BAK}';
    IF n_bak = 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 보관 테이블 {BAK} 없음 (적용 이력 없음)');
        RETURN;
    END IF;
    EXECUTE IMMEDIATE 'UPDATE SCM_ADM_CMBO_SQL_M M SET (M.SQL_DTL_CTN, M.LAST_UPDATED_BY, M.LAST_UPDATE_DATE) = '
                   || '(SELECT B.SQL_DTL_CTN, B.LAST_UPDATED_BY, B.LAST_UPDATE_DATE FROM {BAK} B WHERE B.SQL_ID = M.SQL_ID) '
                   || 'WHERE M.SQL_ID IN (SELECT B.SQL_ID FROM {BAK} B) AND INSTR(M.SQL_DTL_CTN, ''{MARK}'') > 0';
    n_done := SQL%ROWCOUNT;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('ROLLED BACK — ' || n_done || '건 원문 복원 · COMMIT · ' || TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS'));
END;
/
"""
    precheck_sql = f"""-- 00_PRECHECK — 조회 전용 (전체 F5, 값 입력 없음). [{MARK}] 적용 전 상태
-- * [P1] 콤보 SQL 2종 — 마커(적용 여부) · 앵커 2곳 매칭 수(각 1 이어야 10 적용 가능) · 길이
-- * [P2] 대상 사용자 — 일반 그룹(ADMIN · DM ADMIN · DM Planner · SCM PI Admin)과 'DM Planner (W/S)' 를 함께 가진 사용자 (적용 뒤 81 에서 후보가 늘어나는 사람)
-- * [P3] 영향 없는 사용자 수 — W/S 보유자 중 일반 그룹이 없는 사람 (적용 뒤에도 81 에서 W/S 유형만)
SET LINESIZE 200 PAGESIZE 200
SET DEFINE OFF
COLUMN CHK FORMAT A4
COLUMN SQL_ID FORMAT A30
COLUMN WHO FORMAT A12
COLUMN JUDGE FORMAT A60
COLUMN GROUPS FORMAT A110
SELECT 'P1' CHK, M.SQL_ID, SUBSTR(M.LAST_UPDATED_BY,1,12) WHO, TO_CHAR(M.LAST_UPDATE_DATE,'YYYY-MM-DD HH24:MI') UPD, LENGTHB(M.SQL_DTL_CTN) BYTES,
       CASE WHEN INSTR(M.SQL_DTL_CTN, '{MARK}') > 0 THEN 'Y' ELSE 'N' END APPLIED,
       REGEXP_COUNT(M.SQL_DTL_CTN, '{q(P1)}') ANCHOR1,
       REGEXP_COUNT(M.SQL_DTL_CTN, '{q(P2)}') ANCHOR2,
       CASE WHEN INSTR(M.SQL_DTL_CTN, '{MARK}') > 0 THEN '적용됨 — 10 재실행은 무동작'
            WHEN REGEXP_COUNT(M.SQL_DTL_CTN, '{q(P1)}') = 1
             AND REGEXP_COUNT(M.SQL_DTL_CTN, '{q(P2)}') = 1 THEN 'PASS → 10 적용 가능'
            ELSE 'FAIL — 앵커 불일치 (원문이 예상과 다름) → 중단·회신' END JUDGE
  FROM SCM_ADM_CMBO_SQL_M M WHERE M.SQL_ID IN ('{IDS[0]}','{IDS[1]}') ORDER BY M.SQL_ID;
SELECT 'P2' CHK, G.USER_ID, LISTAGG(G.USER_GR_ID, ' | ') WITHIN GROUP (ORDER BY G.USER_GR_ID) GROUPS
  FROM SCM_ADM_USER_GR_MPG_M G WHERE TO_CHAR(G.USE_YN) = 'Y'
 GROUP BY G.USER_ID
HAVING MAX(CASE WHEN G.USER_GR_ID = 'DM Planner (W/S)' THEN 1 ELSE 0 END) = 1
   AND MAX(CASE WHEN G.USER_GR_ID IN ('ADMIN','DM ADMIN','DM Planner','SCM PI Admin') THEN 1 ELSE 0 END) = 1
 ORDER BY G.USER_ID;
SELECT 'P3' CHK, COUNT(*) WS_ONLY_USERS FROM (
  SELECT G.USER_ID FROM SCM_ADM_USER_GR_MPG_M G WHERE TO_CHAR(G.USE_YN) = 'Y' GROUP BY G.USER_ID
  HAVING MAX(CASE WHEN G.USER_GR_ID = 'DM Planner (W/S)' THEN 1 ELSE 0 END) = 1
     AND MAX(CASE WHEN G.USER_GR_ID IN ('ADMIN','DM ADMIN','DM Planner','SCM PI Admin') THEN 1 ELSE 0 END) = 0);
"""
    verify_sql = f"""-- 90 VERIFY — [{MARK}] 콤보 2종을 케이스별 사용자·division 으로 실제 실행해 후보 수 확인 (조회만 · 전체 F5 · 값 입력 없음)
-- * 기대: 관리자+W/S · 81 = 14종(일반 12 + WS 2, 중복 0) / W/S+DM Planner · 81 = 14종 / W/S 단독 · 81 = 6종 / 비 W/S · 81 = 12종 / 40 은 전부 12종
-- * 케이스 사용자는 이 DB 의 그룹 보유 현황에서 고른다 (없으면 그 줄은 '대상 사용자 없음')
-- * 10 실행 전에 돌리면 관리자+W/S · 81 이 6종 — 그 자체가 적용 전 증거
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    TYPE t_s IS TABLE OF VARCHAR2(200) INDEX BY PLS_INTEGER;
    v_case t_s; v_user t_s; v_exp81 t_s;
    v_sql  VARCHAR2(32767);
    v_txt  VARCHAR2(4000);
    n PLS_INTEGER; nd PLS_INTEGER;
    c_ws  CONSTANT VARCHAR2(200) := 'MAX(CASE WHEN G.USER_GR_ID = ''DM Planner (W/S)'' THEN 1 ELSE 0 END)';
    c_adm CONSTANT VARCHAR2(200) := 'MAX(CASE WHEN G.USER_GR_ID IN (''ADMIN'',''DM ADMIN'',''SCM PI Admin'') THEN 1 ELSE 0 END)';
    c_dmp CONSTANT VARCHAR2(200) := 'MAX(CASE WHEN G.USER_GR_ID = ''DM Planner'' THEN 1 ELSE 0 END)';
    FUNCTION pick(p_having VARCHAR2) RETURN VARCHAR2 IS
        v VARCHAR2(200);
    BEGIN
        EXECUTE IMMEDIATE 'SELECT MIN(USER_ID) KEEP (DENSE_RANK FIRST ORDER BY CASE USER_ID WHEN ''minyonglee1'' THEN 0 ELSE 1 END, USER_ID) FROM ('
            || 'SELECT G.USER_ID FROM SCM_ADM_USER_GR_MPG_M G WHERE TO_CHAR(G.USE_YN) = ''Y'' GROUP BY G.USER_ID HAVING ' || p_having || ')' INTO v;
        RETURN v;
    END;
BEGIN
    v_case(1) := '관리자+W/S';     v_user(1) := pick(c_ws || '=1 AND ' || c_adm || '=1');                         v_exp81(1) := '14';
    v_case(2) := 'W/S 단독';       v_user(2) := pick(c_ws || '=1 AND ' || c_adm || '=0 AND ' || c_dmp || '=0');   v_exp81(2) := '6';
    v_case(3) := 'W/S+DM Planner'; v_user(3) := pick(c_ws || '=1 AND ' || c_adm || '=0 AND ' || c_dmp || '=1');   v_exp81(3) := '14';
    v_case(4) := '비 W/S';         v_user(4) := pick(c_ws || '=0 AND ' || c_adm || '=0 AND ' || c_dmp || '=1');   v_exp81(4) := '12';
    FOR m IN (SELECT SQL_ID, SQL_DTL_CTN, CASE WHEN INSTR(SQL_DTL_CTN, '{MARK}') > 0 THEN 'Y' ELSE 'N' END APPLIED
                FROM SCM_ADM_CMBO_SQL_M WHERE SQL_ID IN ('{IDS[0]}','{IDS[1]}') ORDER BY SQL_ID) LOOP
        DBMS_OUTPUT.PUT_LINE('== ' || m.SQL_ID || ' (마커 ' || m.APPLIED || ')');
        FOR i IN 1 .. 4 LOOP
            IF v_user(i) IS NULL THEN
                DBMS_OUTPUT.PUT_LINE('   ' || RPAD(v_case(i), 16) || ' 대상 사용자 없음');
            ELSE
                FOR d IN (SELECT '81' dv FROM DUAL UNION ALL SELECT '40' FROM DUAL) LOOP
                    v_txt := REPLACE(REPLACE(m.SQL_DTL_CTN, '@divisionId', '''' || d.dv || ''''), '@sesUserId', '''' || v_user(i) || '''');
                    v_sql := 'SELECT COUNT(*), COUNT(DISTINCT CODE) FROM (' || v_txt || ')';
                    BEGIN
                        EXECUTE IMMEDIATE v_sql INTO n, nd;
                        DBMS_OUTPUT.PUT_LINE('   ' || RPAD(v_case(i), 16) || RPAD(v_user(i), 14) || ' div ' || d.dv || ' : ' || n || '종 · 중복 ' || (n - nd)
                            || CASE WHEN n <> nd THEN '  FAIL(중복)'
                                    WHEN d.dv = '81' AND TO_CHAR(n) = v_exp81(i) THEN '  PASS'
                                    WHEN d.dv = '81' AND i IN (1, 3) AND n = 6 THEN '  (적용 전 상태)'
                                    WHEN d.dv = '40' AND n = 12 THEN '  PASS'
                                    ELSE '  CHECK — 기대 ' || CASE WHEN d.dv = '81' THEN v_exp81(i) ELSE '12' END || '종 (룩업 건수가 사내와 다르면 달라질 수 있음)' END);
                    EXCEPTION WHEN OTHERS THEN
                        DBMS_OUTPUT.PUT_LINE('   ' || RPAD(v_case(i), 16) || RPAD(v_user(i), 14) || ' div ' || d.dv || ' : FAIL — ' || SUBSTR(SQLERRM, 1, 150));
                    END;
                END LOOP;
            END IF;
        END LOOP;
    END LOOP;
END;
/
"""
    for name, txt in (("00_PRECHECK_CLOUD.sql", precheck_sql), ("10_APPLY_FCSTTYPE_ADMUNION.sql", apply_sql),
                      ("90_VERIFY.sql", verify_sql), ("99_ROLLBACK_FCSTTYPE_ADMUNION.sql", rollback_sql)):
        open(os.path.join(HERE, "A_DB", name), "w", encoding="utf-8", newline="\n").write(txt)
        print("WROTE", name, txt.count("\n"), "lines")


if __name__ == "__main__":
    {"dry": dry, "build": build}[sys.argv[1]]()
