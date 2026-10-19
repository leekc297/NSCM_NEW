# -*- coding: utf-8 -*-
"""PKG_DMF0014.P_DMF0014_CUST_FCST_EXCEL_UPLOAD — Customer Project / Customer Model / [Project]·[Model] 검증 AS-IS 동일화
[E20260930-DMF0014ASISPM]

사용자 지시 (2026-09-30):
  "Customer Project 는 AS-IS 에서 주석이었는데 풀렸다. Model 은 Validation 이 안 나온다."
  "AS-IS 가 둘 다를 보고 있었으면 둘 다를 보도록" + [Project]/[Model] 단독 검증 = "제거 — AS-IS 완전 동일" 선택.

AS-IS 원문 (LGCE_SCMDEV DMF0014_CUST_FCST_EXCEL_UPLOAD, 2026-09-30 직접 조회):
  L399~427 'Invalid Customer Project.'  → /* */ 주석
  L429~470 'Invalid Customer Model.' (division != 40) → NOT EXISTS ( 고객모델 마스터(Site, Customer Project, Customer Model)
                                                                      UNION SCM_MST_SITE_ITEM(Site, Project=ATTR12, Model=ATTR13) )
  L918~980 'Invalid Project.' / 'Invalid Model.' → /* */ 주석

변경 (division != '40' 분기, 이 프로시저 안만 — _SM·40 분기 무변경):
  ① Invalid Customer Project 블록(E20260923 분리 신설분) 비활성 — 줄 단위 '--' (내부 /* */ 와 중첩 금지)
  ② Invalid Customer Model : Customer Project 통과 가드 줄 비활성 + NOT EXISTS 에 SITE_ITEM UNION 복원 (09-29 제거분 원복)
  ③ Invalid Project / Invalid Model([Project]/[Model] SITE_ITEM, E20260929 신설분) 블록 비활성 — 줄 단위 '--'
  유지: Sales Site 가드, 품목분류(ITEM_SN) 'Invalid Model'(E20260915 — 가드가 이미 'Customer Model OR SITE_ITEM')
FRESH-GATE: 원문을 지금 DB 에서 읽고 적용 직전 재조회 일치 시에만 CREATE OR REPLACE. 실패 시 원복.
usage: python apply_asis_prjmdl.py backup | apply | restore
"""
import datetime, io, pathlib, sys
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parents[1] / "_diagnostics"))
from ora import conn_info
import oracledb

MODE = sys.argv[1] if len(sys.argv) > 1 else "backup"
TAG = "E20260930-DMF0014ASISPM"
NAME, TYP = "PKG_DMF0014", "PACKAGE BODY"
BAK = HERE / "00_BACKUP_PKG_DMF0014_BODY.sql"
NEW = HERE / "01_PKG_DMF0014_BODY_ASISPM.sql"
u, p, d = conn_info()
cn = oracledb.connect(user=u, password=p, dsn=d)
cur = cn.cursor()


def last_ddl():
    cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM USER_OBJECTS WHERE OBJECT_NAME=:1 AND OBJECT_TYPE=:2", [NAME, TYP])
    return cur.fetchone()[0]


def fetch():
    cur.execute("SELECT TEXT FROM USER_SOURCE WHERE NAME=:1 AND TYPE=:2 ORDER BY LINE", [NAME, TYP])
    return [t or "" for (t,) in cur]


def compile_src(src):
    cur.execute("CREATE OR REPLACE " + src.rstrip())
    cur.execute("SELECT STATUS FROM USER_OBJECTS WHERE OBJECT_NAME=:1 AND OBJECT_TYPE=:2", [NAME, TYP])
    st = cur.fetchone()[0]
    cur.execute("SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME=:1 AND TYPE=:2 ORDER BY SEQUENCE", [NAME, TYP])
    return st, cur.fetchall()


if MODE == "restore":
    src = BAK.read_text(encoding="utf-8").split("CREATE OR REPLACE ", 1)[1].rsplit("\n/\n", 1)[0]
    print("restore:", compile_src(src))
    sys.exit(0)

ddl0 = last_ddl()
L = fetch()
src0 = "".join(L)
assert TAG not in src0, "이미 적용됨"
p0 = [i for i, t in enumerate(L) if t.strip() == "PROCEDURE P_DMF0014_CUST_FCST_EXCEL_UPLOAD"]
p1 = [i for i, t in enumerate(L) if "PROCEDURE P_DMF0014_CUST_FCST_EXCEL_UPLOAD_SM" in t]
assert len(p0) == 1 and len(p1) == 1, (p0, p1)
lo, hi = p0[0], p1[0]
rng = lambda pred: [i for i in range(lo, hi) if pred(L[i])]

# ① Customer Project 블록
a = rng(lambda t: "[E20260923-DMF0014VALMSG] Customer Project 분리 검증" in t)
assert len(a) == 1
cp_s = a[0] - 1
assert L[cp_s].rstrip("\n") == "            IF V_DIVISION != '40' THEN"
cp_e = next(i for i in range(cp_s, hi) if L[i].rstrip("\n") == "            END IF;")
assert any("'Invalid Customer Project [" in L[i] for i in range(cp_s, cp_e)) and cp_e - cp_s < 30

# ② Customer Model 블록
m = rng(lambda t: "MESSAGE_TEXT = SUBSTR(CASE WHEN MESSAGE_TEXT IS NULL THEN 'Invalid Customer Model [" in t)
assert len(m) == 1
m = m[0]
gate = m + 7
assert L[gate].startswith("                AND    EXISTS (SELECT 1 FROM DM_MST_CUSTOMER_MODEL GC") \
    and "GC.CUSTOMER_PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4)" in L[gate] and "CUSTOMER_MODEL = " not in L[gate], L[gate][:120]
cl1, cl2 = m + 15, m + 16
assert L[cl1].startswith("                        AND    CM.VALID_YN = 'Y');  /*[E20260929-DMF0014PRJMDL] UNION SCM_MST_SITE_ITEM"), L[cl1]
assert "[Project]/[Model] 열은 아래 'Invalid Project'/'Invalid Model' 이 별도 검증*/" in L[cl2], L[cl2]
assert "CM.CUSTOMER_MODEL = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE5" in L[m + 13]

# ③ [Project]/[Model] 블록
b = rng(lambda t: t.startswith("            /* [E20260929-DMF0014PRJMDL] [Project]/[Model] 열 존재 검증"))
assert len(b) == 1
pm_s = b[0]
t104 = next(i for i in range(pm_s, hi) if "V_LOG_TYPE    := '104';" in L[i])
pm_e = next(i for i in range(t104, hi) if L[i].rstrip("\n") == "            END IF;")
assert pm_s > cl2 and pm_e - pm_s < 50 and "E20260915-DMF0014MSTCHK" in L[pm_e + 2], L[pm_e + 2][:80]

off = lambda t: "--" + t if t.strip() else t
new = list(L)
for i in range(pm_s, pm_e + 1):            # 뒤에서부터 (인덱스 보존)
    new[i] = off(L[i])
new[pm_s] = (f"            --[{TAG}] 아래 [Project]/[Model] 단독 검증(E20260929 신설) 비활성 — AS-IS 'Invalid Project.'/'Invalid Model.' 주석 파리티 (사용자 결정 2026-09-30)\n"
             + new[pm_s])
new[cl1] = ("                        AND    CM.VALID_YN = 'Y'\n"
            f"                        UNION  /*[{TAG}] AS-IS L447~455 복원 — [Project]/[Model] 가 SCM_MST_SITE_ITEM 에 있으면 통과 (09-29 제거분 원복, 사용자 결정 2026-09-30)*/\n"
            "                        SELECT 1\n"
            "                        FROM   SCM_MST_SITE_ITEM SI, SCM_MST_DIVISION D3\n"
            "                        WHERE  SI.DIVISION_ID = D3.DIVISION_ID\n"
            "                        AND    SI.SCM_SITE_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2\n"
            "                        AND    SI.PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE12  /*AS-IS L453 = Project 열*/\n"
            "                        AND    SI.ITEM_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE13       /*AS-IS L454 = Model 열*/\n"
            "                        AND    (D3.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1 OR D3.DIVISION_NAME = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1)\n"
            "                        AND    SI.VALID_YN = 'Y');\n")
new[cl2] = ""
new[gate] = (f"                --[{TAG}] Customer Project 통과 가드 비활성 — AS-IS 는 Customer Project 검증이 주석이라 Customer Model 이 직접 판정\n"
             + off(L[gate]))
for i in range(cp_s, cp_e + 1):
    new[i] = off(L[i])
new[cp_s] = (f"            --[{TAG}] 아래 Invalid Customer Project 블록(E20260923 분리 신설) 비활성 — AS-IS L399~427 /* */ 주석 파리티 (사용자 지적 2026-09-30)\n"
             + new[cp_s])
src1 = "".join(new)
# 변경 범위 단언: 대상 줄 외 불변
changed = [i for i in range(len(L)) if L[i] != new[i]]
allowed = set(range(cp_s, cp_e + 1)) | {gate, cl1, cl2} | set(range(pm_s, pm_e + 1))
assert set(changed) <= allowed, sorted(set(changed) - allowed)[:5]
assert "/*" not in "".join(t for t in new[cp_s:cp_e + 1] if not t.lstrip().startswith("--")), "주석 중첩 위험"
print(f"기준본 LAST_DDL={ddl0}  ①CustProject L{cp_s+1}~{cp_e+1} 비활성  ②CustModel 가드 L{gate+1} 비활성·UNION 복원 L{cl1+1}  ③Project/Model L{pm_s+1}~{pm_e+1} 비활성")

now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
stamp = f"-- SOURCE-FRESH: SCM_MGR.{NAME} {TYP} LAST_DDL={ddl0} FETCHED={now} DB=ZIOUI1\n"
BAK.write_text(stamp + "-- 적용 전 원문\nCREATE OR REPLACE " + src0.rstrip() + "\n/\n", encoding="utf-8")
NEW.write_text(stamp + f"-- [{TAG}] PKG_DMF0014 BODY 전체본\nCREATE OR REPLACE " + src1.rstrip() + "\n/\n", encoding="utf-8")
print("파일 생성 완료")

if MODE == "apply":
    assert last_ddl() == ddl0 and "".join(fetch()) == src0, "FRESH-GATE: 추출 이후 변경 감지 — 중단"
    st, errs = compile_src(src1)
    print(f"적용 결과 STATUS={st} 오류={len(errs)} LAST_DDL={last_ddl()}")
    if st != "VALID" or errs:
        for e in errs[:15]:
            print("  ERR", e)
        print("⚠ 원복:", compile_src(src0))
        sys.exit(1)
    print("마커 수:", "".join(fetch()).count(TAG))
cn.close()
