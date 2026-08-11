#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""STEP4 — 변경된 3개 문장의 OLD/NEW 결과 완전동일 증명 (배포 전 필수)

INSERT 는 떼고 **SELECT 부분만** 뽑아 양쪽을 각각 실행 → 행 다중집합 비교.
  · DATE 컬럼(SYSDATE)은 비결정적이라 비교에서 제외 (cursor.description 으로 자동 판별)
  · MINUS 보다 강함 — 중복 건수 차이까지 잡는다
  · DEPT 최종문은 GTT 선적재 필요 → 내 세션 GTT 에만 적재(세션 전용) 후 ROLLBACK
  · 원장 테이블 UPDATE(부서 기타 재배정)는 **실행하지 않는다** (실데이터 훼손 금지)
"""
import sys, pathlib, re, time
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info
import oracledb

OUT = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate")
OLD_F = OUT / "BACKUP_PKG_DMF0044_BODY_pre_transfertune_20260810.sql"
NEW_F = OUT / "PKG_DMF0044_BODY_TRANSFERTUNE_20260810.sql"

DIV, VER = '40', 'R_S_20260128_V002_C'


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


def extract(text, proc, target, occurrence=0):
    """proc 안의 `INSERT INTO target ( ... ) <SELECT...>;` 에서 SELECT 부분만 반환"""
    m = mask(text)
    ps = [mm.start() for mm in re.finditer(r'(?im)^\s*PROCEDURE\s+' + proc + r'\b', m)]
    if not ps: raise SystemExit(f"proc not found: {proc}")
    start = ps[0]
    nxt = [mm.start() for mm in re.finditer(r'(?im)^\s*PROCEDURE\s+\w+', m) if mm.start() > start]
    end = nxt[0] if nxt else len(m)
    hits = [mm.start() for mm in re.finditer(re.escape('INSERT INTO ' + target), m[start:end])]
    ins = start + hits[occurrence]
    # 컬럼목록 여는 괄호 → 닫는 괄호
    i = m.index('(', ins); depth = 0
    while i < end:
        if m[i] == '(': depth += 1
        elif m[i] == ')':
            depth -= 1
            if depth == 0: break
        i += 1
    body_start = i + 1
    # 깊이 0 의 ';'
    j = body_start; depth = 0
    while j < end:
        if m[j] == '(': depth += 1
        elif m[j] == ')': depth -= 1
        elif m[j] == ';' and depth == 0: break
        j += 1
    return text[body_start:j].strip()


def bindify(sql):
    """PL/SQL 변수 → 바인드/리터럴 (원문 형태 최대 보존)"""
    sql = re.sub(r'\bP_DIVISION_ID\b', f"'{DIV}'", sql)
    sql = re.sub(r'\bP_VERSION_NO\b', f"'{VER}'", sql)
    sql = re.sub(r'\bP_YYYY\b', ':yyyy', sql)
    sql = re.sub(r'\bv_user_id\b', "'mdf_batch'", sql)
    sql = re.sub(r'\bv_ori_version_no\b', ':oriv', sql)
    sql = re.sub(r'\bV_SP_BP\b', ':spbp', sql)
    return sql


old_txt = OLD_F.read_text(encoding='utf-8')
new_txt = NEW_F.read_text(encoding='utf-8')

u, p, dsn = conn_info()
con = oracledb.connect(user=u, password=p, dsn=dsn)
con.call_timeout = 1800000
cur = con.cursor()

cur.execute("SELECT MAX(SUBSTR(YYYYMMDD,1,4)) FROM DM_MDF_VERSION WHERE VERSION_NO=:v", {"v": VER})
YYYY = cur.fetchone()[0]
cur.execute("SELECT MAX(ORI_VERSION_NO) FROM SCM_MGR.DM_MDF_VERSION WHERE DIVISION_ID=:d AND VERSION_NO=:v",
            {"d": DIV, "v": VER})
ORIV = cur.fetchone()[0]
cur.execute("""SELECT CASE WHEN COUNT(*)>0 THEN 'BP' ELSE 'SP' END FROM DM_PLN_SALES_PLAN_REPORT_C
                WHERE DIVISION_ID=:d AND VERSION_NO=:v AND MEASURE='Business_Plan' AND ROWNUM=1""",
            {"d": DIV, "v": VER})
SPBP = cur.fetchone()[0]
print(f"[binds] DIVISION={DIV} VERSION={VER} YYYY={YYYY} ORI_VERSION_NO={ORIV!r} SP_BP={SPBP}\n")

BINDS = {"yyyy": YYYY, "oriv": ORIV, "spbp": SPBP}


def run(sql, label):
    used = {k: v for k, v in BINDS.items() if (':' + k) in sql}
    t0 = time.time()
    cur.execute(sql, used)
    cols = [c[0] for c in cur.description]
    types = [c[1] for c in cur.description]
    drop = {i for i, t in enumerate(types) if t is oracledb.DB_TYPE_DATE or t is oracledb.DB_TYPE_TIMESTAMP}
    rows = cur.fetchall()
    el = time.time() - t0
    keep = [tuple(v for i, v in enumerate(r) if i not in drop) for r in rows]
    print(f"    {label:4s} {el:8.2f}초  {len(rows):>9,} 행  (비교제외 DATE 컬럼 {sorted(cols[i] for i in drop)})")
    return el, keep


def compare(name, old_sql, new_sql):
    print(f"\n{'='*110}\n### {name}\n{'='*110}")
    eo, ro = run(bindify(old_sql), "OLD")
    en, rn = run(bindify(new_sql), "NEW")
    # NULL 이 섞이면 tuple 비교가 TypeError 이므로 정렬키를 (is_null, 문자열) 로 정규화.
    #   값 자체는 손대지 않고 '순서 결정'에만 쓴다 → 비교의 엄밀성은 그대로.
    def key(row):
        return tuple((v is None, '' if v is None else str(v)) for v in row)
    so, sn = sorted(ro, key=key), sorted(rn, key=key)
    same = so == sn
    print(f"    → 행수 {len(ro):,} vs {len(rn):,} / 다중집합 완전일치: {'PASS ✅' if same else 'FAIL ⛔'}")
    if not same:
        onlyo = [r for r in so if r not in sn][:3]
        onlyn = [r for r in sn if r not in so][:3]
        print(f"      OLD 에만: {onlyo}\n      NEW 에만: {onlyn}")
    if eo > 0 and en > 0:
        print(f"    → 소요 {eo:.2f}초 → {en:.2f}초 ({eo/en:.1f}배)" if en else "")
    return same


ok = []

# ---- 1) PRODUCT_CREATE (병목 문장) ----
ok.append(compare(
    "1) P_DMF0044_SALES_REPORT_PRODUCT_CREATE — DM_MOBILE_REPORT_PRODUCT 적재 [★ 병목 문장]",
    extract(old_txt, 'P_DMF0044_SALES_REPORT_PRODUCT_CREATE', 'SCM_MGR.DM_MOBILE_REPORT_PRODUCT'),
    extract(new_txt, 'P_DMF0044_SALES_REPORT_PRODUCT_CREATE', 'SCM_MGR.DM_MOBILE_REPORT_PRODUCT')))

# ---- 2) EXCHANGE_RATE_CREATE ----
ok.append(compare(
    "2) P_DMF0044_SALES_REPORT_EXCHANGE_RATE_CREATE — DM_MOBILE_REPORT_EXCHANGE_RATE 적재",
    extract(old_txt, 'P_DMF0044_SALES_REPORT_EXCHANGE_RATE_CREATE', 'SCM_MGR.DM_MOBILE_REPORT_EXCHANGE_RATE'),
    extract(new_txt, 'P_DMF0044_SALES_REPORT_EXCHANGE_RATE_CREATE', 'SCM_MGR.DM_MOBILE_REPORT_EXCHANGE_RATE')))

# ---- 3) DEPT_CREATE 1단계 : GTT 적재문 ----
d1_old = extract(old_txt, 'P_DMF0044_SALES_REPORT_DEPT_CREATE', 'SCM_MGR.GT_DMF0044_DEPT_RPT_C')
d1_new = extract(new_txt, 'P_DMF0044_SALES_REPORT_DEPT_CREATE', 'SCM_MGR.GT_DMF0044_DEPT_RPT_C')
ok.append(compare("3) P_DMF0044_SALES_REPORT_DEPT_CREATE — GTT 적재문 (ISV 포함)", d1_old, d1_new))

# ---- 4) DEPT_CREATE 2단계 : 최종 INSERT SELECT (GTT 선적재 필요) ----
print(f"\n{'='*110}\n### 4) P_DMF0044_SALES_REPORT_DEPT_CREATE — DM_MOBILE_REPORT_DEPT 적재문\n{'='*110}")
cur.execute("DELETE FROM SCM_MGR.GT_DMF0044_DEPT_RPT_C")
cur.execute("""INSERT INTO SCM_MGR.GT_DMF0044_DEPT_RPT_C
   ( DIVISION_ID, PRODUCT_GROUP, MEASURE, YYYYMMDD, ATTRIBUTE1, ATTRIBUTE2,
     DEPARTMENT_ID, DEPT_ID, END_CUST_REPORT, CUST_REPORT, QTY ) """ + bindify(d1_new),
            {k: v for k, v in BINDS.items() if (':' + k) in bindify(d1_new)})
print(f"    [준비] 내 세션 GTT 적재 {cur.rowcount:,} 행 (세션 전용 · 원장 UPDATE 는 미실행)")
ok.append(compare("4) DM_MOBILE_REPORT_DEPT 적재문",
                  extract(old_txt, 'P_DMF0044_SALES_REPORT_DEPT_CREATE', 'SCM_MGR.DM_MOBILE_REPORT_DEPT'),
                  extract(new_txt, 'P_DMF0044_SALES_REPORT_DEPT_CREATE', 'SCM_MGR.DM_MOBILE_REPORT_DEPT')))

con.rollback()
cur.execute("DELETE FROM SCM_MGR.GT_DMF0044_DEPT_RPT_C")
con.rollback()
print("\n[정리] ROLLBACK 완료 (GTT 세션 전용 · 원장 무변경)")

print(f"\n{'#'*110}\n종합: {sum(ok)}/{len(ok)} PASS  {'✅ 배포 가능' if all(ok) else '⛔ 배포 금지'}\n{'#'*110}")
con.close()
sys.exit(0 if all(ok) else 1)
