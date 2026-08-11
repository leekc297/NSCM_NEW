#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""ORA-00001 (PK_DM_MOBILE_REPORT_DEPT) 근본원인 규명 — 내 변경분인가 기존 결함인가

가설: 최종 INSERT 의 GROUP BY 에는 `B.DISPLAY_SEQ` 가 들어 있으나 PK 에는 없다.
      B = LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL (LOOKUP_TYPE='REPORT_GROUP2')
      이 룩업의 SEGMENT1 에 **중복키 2건**이 있고 DISPLAY_SEQ 가 서로 다르면
      한 논리행이 2 그룹으로 갈라져 **동일 PK 2행** → ORA-00001.
      이 조인은 내 변경분이 아니라 **원래부터 있던 것** → 기존 결함 여부를 실증한다.

검증: 같은 버전에 대해 OLD(백업본) / NEW(라이브) 최종 SELECT 를 각각 돌려
      PK 중복 건수를 비교한다. 둘 다 >0 이면 기존 결함(내 변경 무관).
※ 조회 전용 + GTT 는 내 세션 전용, 마지막에 ROLLBACK.
"""
import sys, pathlib, re
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info, fetch, show
import oracledb

OUT = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate")
OLD_F = OUT / "BACKUP_PKG_DMF0044_BODY_pre_transfertune_20260810.sql"
DIV, VER = '40', 'R_S_20260810_V009_C'

u, p, dsn = conn_info()
con = oracledb.connect(user=u, password=p, dsn=dsn)
con.call_timeout = 900000
cur = con.cursor()

def sec(t): print("\n" + "=" * 116); print(t); print("=" * 116)

sec("[1] REPORT_GROUP2 중복키의 DISPLAY_SEQ — 그룹 분열 유발 여부")
show(*fetch(cur, """
SELECT SEGMENT1, COUNT(*) cnt, COUNT(DISTINCT DISPLAY_SEQ) distinct_seq,
       LISTAGG(DISPLAY_SEQ, ' / ') WITHIN GROUP (ORDER BY DISPLAY_SEQ) seqs,
       LISTAGG(SEGMENT2, ' / ') WITHIN GROUP (ORDER BY DISPLAY_SEQ) seg2s
  FROM SCM_ADM_LOOKUP_MASTER_DETAIL
 WHERE LOOKUP_TYPE='REPORT_GROUP2'
 GROUP BY SEGMENT1 HAVING COUNT(*) > 1 ORDER BY SEGMENT1"""))

sec(f"[2] 문제 버전 {VER} 의 CUST_REPORT 가 그 중복키를 포함하는가")
show(*fetch(cur, """
SELECT CUST_REPORT, COUNT(*) rows_
  FROM DM_PLN_SALES_PLAN_REPORT_C
 WHERE DIVISION_ID=:d AND VERSION_NO=:v
   AND CUST_REPORT IN (SELECT SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                        WHERE LOOKUP_TYPE='REPORT_GROUP2'
                        GROUP BY SEGMENT1 HAVING COUNT(*)>1)
 GROUP BY CUST_REPORT ORDER BY CUST_REPORT""", {"d": DIV, "v": VER}))
show(*fetch(cur, """
SELECT CUST_REPORT, COUNT(*) rows_
  FROM DM_PLN_SALES_ETC_REPORT_C
 WHERE DIVISION_ID=:d AND VERSION_NO=:v
   AND CUST_REPORT IN (SELECT SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                        WHERE LOOKUP_TYPE='REPORT_GROUP2'
                        GROUP BY SEGMENT1 HAVING COUNT(*)>1)
 GROUP BY CUST_REPORT ORDER BY CUST_REPORT""", {"d": DIV, "v": VER}))

# ---------- 문장 추출 ----------
def mask(s):
    out = list(s); i = 0; n = len(s)
    while i < n:
        if s[i] == "'":
            j = i + 1
            while j < n:
                if s[j] == "'":
                    if j + 1 < n and s[j+1] == "'": j += 2; continue
                    break
                j += 1
            for k in range(i, min(j+1, n)): out[k] = ' '
            i = j + 1
        elif s.startswith('--', i):
            j = s.find('\n', i); j = n if j < 0 else j
            for k in range(i, j): out[k] = ' '
            i = j
        elif s.startswith('/*', i):
            j = s.find('*/', i+2); j = n if j < 0 else j+2
            for k in range(i, j): out[k] = ' '
            i = j
        else:
            i += 1
    return "".join(out)

def extract(text, proc, target, keep_insert=False):
    M = mask(text)
    s = [mm.start() for mm in re.finditer(r'(?im)^\s*PROCEDURE\s+' + proc + r'\b', M)][0]
    nx = [mm.start() for mm in re.finditer(r'(?im)^\s*PROCEDURE\s+\w+', M) if mm.start() > s]
    e = nx[0] if nx else len(M)
    ins = s + M[s:e].index('INSERT INTO ' + target)
    i = M.index('(', ins); depth = 0
    while i < e:
        if M[i] == '(': depth += 1
        elif M[i] == ')':
            depth -= 1
            if depth == 0: break
        i += 1
    j = i + 1; depth = 0
    while j < e:
        if M[j] == '(': depth += 1
        elif M[j] == ')': depth -= 1
        elif M[j] == ';' and depth == 0: break
        j += 1
    return (text[ins:j] if keep_insert else text[i+1:j]).strip()

def lit(sql, spbp, oriv):
    sql = re.sub(r'\bP_DIVISION_ID\b', f"'{DIV}'", sql)
    sql = re.sub(r'\bP_VERSION_NO\b', f"'{VER}'", sql)
    sql = re.sub(r'\bv_user_id\b', "'mdf_batch'", sql)
    sql = re.sub(r'\bv_ori_version_no\b', 'NULL' if oriv is None else f"'{oriv}'", sql)
    sql = re.sub(r'\bV_SP_BP\b', f"'{spbp}'", sql)
    return sql

cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044'
                AND TYPE='PACKAGE BODY' ORDER BY LINE""")
live = "".join(r[0] for r in cur.fetchall())
old = OLD_F.read_text(encoding='utf-8')

cur.execute("""SELECT CASE WHEN COUNT(*)>0 THEN 'BP' ELSE 'SP' END FROM DM_PLN_SALES_PLAN_REPORT_C
                WHERE DIVISION_ID=:d AND VERSION_NO=:v AND MEASURE='Business_Plan' AND ROWNUM=1""",
            {"d": DIV, "v": VER})
SPBP = cur.fetchone()[0]
cur.execute("SELECT MAX(ORI_VERSION_NO) FROM SCM_MGR.DM_MDF_VERSION WHERE DIVISION_ID=:d AND VERSION_NO=:v",
            {"d": DIV, "v": VER})
ORIV = cur.fetchone()[0]

PK = ("DIVISION_ID, VERSION_NO, YYYY, SP_BP_TYPE, UPPER_DEPT_NAME, DEPT_NAME, "
      "CUST_INFO, PRODUCT_NAME, PRODUCT_DETAIL, MEASURE")
COLS = PK + (", MM01, MM02, MM03, MM04, MM05, MM06, MM07, MM08, MM09, MM10, MM11, MM12,"
             " ORI_VERSION_NO, SORT_NO, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE")

sec(f"[3] OLD(백업본) vs NEW(라이브) — {VER} 최종 SELECT 의 PK 중복 건수")
try:
    for lbl, src in (("OLD", old), ("NEW", live)):
        # GTT 를 해당 라벨의 적재문으로 채운다
        cur.execute("DELETE FROM SCM_MGR.GT_DMF0044_DEPT_RPT_C")
        gtt = lit(extract(src, 'P_DMF0044_SALES_REPORT_DEPT_CREATE', 'SCM_MGR.GT_DMF0044_DEPT_RPT_C'), SPBP, ORIV)
        cur.execute("""INSERT INTO SCM_MGR.GT_DMF0044_DEPT_RPT_C
            ( DIVISION_ID, PRODUCT_GROUP, MEASURE, YYYYMMDD, ATTRIBUTE1, ATTRIBUTE2,
              DEPARTMENT_ID, DEPT_ID, END_CUST_REPORT, CUST_REPORT, QTY ) """ + gtt)
        gttn = cur.rowcount
        sel = lit(extract(src, 'P_DMF0044_SALES_REPORT_DEPT_CREATE', 'SCM_MGR.DM_MOBILE_REPORT_DEPT'), SPBP, ORIV)
        cur.execute(f"""SELECT COUNT(*) total_rows,
                               (SELECT COUNT(*) FROM (
                                  SELECT {PK}, COUNT(*) c FROM ( SELECT {COLS} FROM ({sel}) )
                                   GROUP BY {PK} HAVING COUNT(*)>1)) dup_pk_keys,
                               (SELECT NVL(SUM(c-1),0) FROM (
                                  SELECT {PK}, COUNT(*) c FROM ( SELECT {COLS} FROM ({sel}) )
                                   GROUP BY {PK} HAVING COUNT(*)>1)) surplus_rows
                          FROM ({sel})""")
        t, dk, sr = cur.fetchone()
        v = "⛔ ORA-00001 발생" if dk else "✅ 정상"
        print(f"  {lbl}: GTT {gttn:,}행 / 결과 {t:,}행 / PK 중복키 {dk} / 초과행 {sr}   {v}")

    sec("[4] 중복 PK 실물 (NEW 기준) — 무엇이 갈라졌는가")
    sel = lit(extract(live, 'P_DMF0044_SALES_REPORT_DEPT_CREATE', 'SCM_MGR.DM_MOBILE_REPORT_DEPT'), SPBP, ORIV)
    show(*fetch(cur, f"""
        SELECT CUST_INFO, DEPT_NAME, PRODUCT_NAME, MEASURE, COUNT(*) c,
               COUNT(DISTINCT SORT_NO) distinct_sort_no,
               LISTAGG(SORT_NO, ' / ') WITHIN GROUP (ORDER BY SORT_NO) sort_nos
          FROM ( SELECT {COLS} FROM ({sel}) )
         GROUP BY {PK} HAVING COUNT(*)>1
         ORDER BY 1,2,3,4 FETCH FIRST 20 ROWS ONLY"""))
finally:
    con.rollback()
    cur.execute("DELETE FROM SCM_MGR.GT_DMF0044_DEPT_RPT_C")
    con.rollback()
    print("\n[정리] ROLLBACK 완료 (GTT 세션 전용 · 원장 무변경)")
con.close()
