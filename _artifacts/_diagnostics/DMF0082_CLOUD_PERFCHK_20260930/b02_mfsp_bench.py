# -*- coding: utf-8 -*-
"""MF_SP 적재(L3908~4048, 18xg1y5298qgq) 개선 후보 실측 — 사내 ZIOUI1 · GTT 만 · 끝에 ROLLBACK.

같은 세션에서 GET_MAIN_DATA 1회 실행(GTT 적재) → MF_SP 를 비우고 아래 3안을 각각 실행해 시간·적재결과 SHA 비교.
  A0 = 원문 (GROUP BY + MAX 40여 개 + VD 조인 ON 절 p_division_id — LATERAL 변환됨)
  A1 = GROUP BY 제거 (업무키 유일 시 행 1:1 — SUM(x)=x · MAX(x)=x)
  A2 = A1 + VD 조인 조건을 서브쿼리 안으로 (LATERAL 제거)
  G  = A1/A2 적용 가드 — TEMP_FCST_N_PRICE 업무키(GROUP BY 키) 중복 0 확인 비용
사용: python b02_mfsp_bench.py <div> <user>
"""
import io, sys, re, time, hashlib, pathlib, datetime
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[1]))
from ora import conn_info
import oracledb

DIV = sys.argv[1] if len(sys.argv) > 1 else "82"
USER = sys.argv[2] if len(sys.argv) > 2 else "k0101"
today = datetime.date.today()
frm = today.replace(day=1)
m = frm.month - 1 + 6
to = datetime.date(frm.year + m // 12, m % 12 + 1, 1) - datetime.timedelta(days=1)
FRM, TO = frm.strftime("%Y%m%d"), to.strftime("%Y%m%d")
EXP = max((frm + datetime.timedelta(days=350)).strftime("%Y%m%d"), TO)   # V_EXP_YYYYMMDD (L448)

u, p, d = conn_info()
cn = oracledb.connect(user=u, password=p, dsn=d)
cn.call_timeout = 1800000
cur = cn.cursor()
cur.execute("SELECT LINE, TEXT FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' ORDER BY LINE")
src = {ln: (t or "") for ln, t in cur}
assert src[3908].lstrip().startswith("INSERT /*[E20260812-PERF]") and "GT_DMF0082_MF_SP" in src[3908]
assert src[4043].strip().startswith("GROUP BY F.DIVISION_ID") and src[4048].rstrip().endswith("CAL.MONTH_END_YN;")
assert "MAX(VD.VMI_STD_DIO)" in src[3985] and "AND p_division_id  = '82'" in src[4042]

A0 = re.sub(r"--[^\n]*", "", "".join(src[i] for i in range(3908, 4049))).strip().rstrip(";")
BINDS = (("V_GROUP_ID", ":grp"), ("V_EXP_YYYYMMDD", ":exp"), ("p_to_yyyymmdd", ":t"),
         ("p_from_yyyymmdd", ":f"), ("p_scm_site_id", ":site"), ("p_division_id", ":d"))


def bind(s):
    # 문자열 리터럴 안(예: PARAM_NM = 'p_scm_site_id')은 치환 금지
    for name, b in BINDS:
        s = re.sub(r"(?<!')\b" + name + r"\b(?!')", b, s)
    return s


A1 = A0[:A0.index("GROUP BY F.DIVISION_ID")]
A1 = A1.replace("SUM(F.QTY)", "F.QTY").replace("NVL(MAX(F.AS_FROM_SITE), ' ')", "NVL(F.AS_FROM_SITE, ' ')")
A1 = re.sub(r"MAX\((F\.\w+)\)", r"\1", A1)
A1 = A1.replace("MAX('N') AS NEW_FLAG", "'N' AS NEW_FLAG").replace("MAX(VD.VMI_STD_DIO)", "VD.VMI_STD_DIO")
assert A1.count(", MAX(CASE WHEN p_scm_site_id") == 1
A1 = A1.replace(", MAX(CASE WHEN p_scm_site_id", ", (CASE WHEN p_scm_site_id")
_head = A1.split("FROM   SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE F")[0]   # 최상위 SELECT 절 (서브쿼리 PVT·VD·CAL 의 MAX 는 정당)
assert "MAX(" not in _head and "SUM(" not in _head, "최상위 집계 잔존"
old_vd = """        WHERE  S.DIVISION_ID = '82'
        GROUP BY S.SCM_SITE_ID
    ) VD ON  VD.SCM_SITE_ID = F.SCM_SITE_ID
         AND p_division_id  = '82'"""
assert A1.count(old_vd) == 1, "VD 앵커"
A2 = A1.replace(old_vd, """        WHERE  S.DIVISION_ID = '82' AND p_division_id = '82'
        GROUP BY S.SCM_SITE_ID
    ) VD ON  VD.SCM_SITE_ID = F.SCM_SITE_ID""")
assert A0.count(old_vd) == 1
A3 = A0.replace(old_vd, """        WHERE  S.DIVISION_ID = '82' AND p_division_id = '82'
        GROUP BY S.SCM_SITE_ID
    ) VD ON  VD.SCM_SITE_ID = F.SCM_SITE_ID""")   # LATERAL 만 해소 · GROUP BY 유지
A0, A1, A2, A3 = bind(A0), bind(A1), bind(A2), bind(A3)
G = """SELECT COUNT(*) FROM (SELECT 1 FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
       GROUP BY DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS,
                MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, MEASURE_GROUP, SORT_ORDER_NO
       HAVING COUNT(*) > 1) WHERE ROWNUM = 1"""

cur.execute("SELECT ARGUMENT_NAME, IN_OUT FROM USER_ARGUMENTS WHERE PACKAGE_NAME='PKG_DMF0082'"
            " AND OBJECT_NAME='P_DMF0082_GET_MAIN_DATA' AND DATA_LEVEL=0 ORDER BY POSITION")
P = {"P_DIVISION_ID": DIV, "P_TEAM_ID": "ALL", "P_CUSTOMER": "ALL", "P_BIZ_TYPE": "ALL",
     "P_FROM_YYYYMMDD": FRM, "P_TO_YYYYMMDD": TO, "P_SCM_SITE_ID": "ALL", "P_ITEM_ID": None,
     "P_VERSION_TYPE": "Current", "P_QTY_YN": "N", "P_CREATED_BY": USER, "P_USER_GROUP": "ADMIN",
     "P_PLANT_SITE_ID": "ALL", "P_PROJECT_CODE": "ALL", "P_OWNER": "ALL", "P_SENDER_CODE": "ALL"}
args = [P[a] if io_ == "IN" else cn.cursor() for a, io_ in cur.fetchall()]
cur.callproc("PKG_DMF0082.P_DMF0082_GET_MAIN_DATA", args)
cur.execute("""SELECT COUNT(1) FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE='GET_ADMIN_GROUP' AND VALID_YN='Y'
               AND (SEGMENT1=:g OR SEGMENT1 IN (SELECT G.USER_GR_ID FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M G
                    WHERE G.USER_ID IN (:g,:u) AND G.USE_YN='Y')) AND SEGMENT2='ALL'""", g="ADMIN", u=USER)
GRP = "ADMIN" if cur.fetchone()[0] > 0 else ""
cur.execute("SELECT COUNT(*) FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE")
print(f"div={DIV} user={USER} TEMP_FCST_N_PRICE={cur.fetchone()[0]:,}  V_EXP={EXP} V_GROUP_ID='{GRP}'")
cols = [r[0] for r in cur.execute("SELECT COLUMN_NAME FROM USER_TAB_COLUMNS WHERE TABLE_NAME='GT_DMF0082_MF_SP' ORDER BY COLUMN_ID")]
keycols = ",".join(cols)


def mf_sha():
    cur.execute(f"SELECT {keycols} FROM SCM_MGR.GT_DMF0082_MF_SP ORDER BY {keycols}")
    rows = cur.fetchall()
    return len(rows), hashlib.sha256("\n".join("|".join("" if v is None else str(v) for v in r) for r in rows).encode()).hexdigest()[:16]


base = mf_sha()
print(f"  SP 적재 MF_SP          rows {base[0]:,}  sha {base[1]}")
B = {"d": DIV, "site": "ALL", "f": FRM, "t": TO, "exp": EXP, "grp": GRP}
for label, sql in (("A0 원문", A0), ("A3 LATERAL만 해소", A3), ("A2 +LATERAL 제거", A2), ("A3 (재)", A3), ("A2 (재)", A2)):
    cur.execute("SAVEPOINT B02")
    cur.execute("DELETE FROM SCM_MGR.GT_DMF0082_MF_SP")
    b = {k: v for k, v in B.items() if f":{k}" in sql}
    t = time.time(); cur.execute(sql, b); el = time.time() - t
    n, h = mf_sha()
    print(f"  {label:18} {el:6.2f}s  rows {n:,}  sha {h}  {'= SP' if h == base[1] else '≠ SP'}")
    cur.execute("ROLLBACK TO SAVEPOINT B02")
t = time.time(); cur.execute(G); dup = cur.fetchone()[0]
print(f"  G  업무키 중복 점검      {time.time() - t:6.2f}s  중복그룹 {dup}")
cn.rollback()
cn.close()
