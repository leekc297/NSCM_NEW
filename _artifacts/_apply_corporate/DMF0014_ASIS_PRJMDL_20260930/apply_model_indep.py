# -*- coding: utf-8 -*-
"""PKG_DMF0014.P_DMF0014_CUST_FCST_EXCEL_UPLOAD — Invalid Model 을 Project 오류 행에서도 판정 [E20260930-DMF0014MDLIND]

사용자 지적 (2026-09-30): "[Model] 에도 B(BBB)가 들어가서 같이 Validation 에 나와야 하는데 Project 만 나온다."
원인: Invalid Model(log 104) 에 'Project 통과 행만' 가드(EXISTS SITE_ITEM (Div, Site, [Project])) — Project 오류 행은 Model 미판정.
변경 (가드 1줄 교체):
  Project 통과 행   → 종전 그대로 (Div, Site, [Project], [Model]) 조합이 SITE_ITEM 에 없으면 Invalid Model
  Project 오류 행   → (Div, Site, [Model]) 가 SITE_ITEM 에 아예 없을 때만 Invalid Model
                     (정상 Model + 틀린 Project 행에 Model 오류가 오탐으로 붙지 않게)
FRESH-GATE: 지금 DB 원문 기준 · 적용 직전 재조회 일치 시에만 CREATE OR REPLACE. 실패 시 원복.
usage: python apply_model_indep.py backup | apply | restore
"""
import datetime, io, pathlib, sys
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parents[1] / "_diagnostics"))
from ora import conn_info
import oracledb

MODE = sys.argv[1] if len(sys.argv) > 1 else "backup"
TAG = "E20260930-DMF0014MDLIND"
NAME, TYP = "PKG_DMF0014", "PACKAGE BODY"
BAK = HERE / "20_BACKUP_PKG_DMF0014_BODY.pre_MDLIND.sql"
NEW = HERE / "21_PKG_DMF0014_BODY_MDLIND.sql"
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
t104 = [i for i, t in enumerate(L) if "V_LOG_TYPE    := '104';" in t]
assert len(t104) == 1, t104
m = next(i for i in range(t104[0], t104[0] - 20, -1) if "'Invalid Model ['||v_h13||': '||NVL(ATTRIBUTE13" in L[i])
g = m + 7
gate_prefix = ("                AND    EXISTS (SELECT 1 FROM SCM_MST_SITE_ITEM GI, SCM_MST_DIVISION GD WHERE GI.DIVISION_ID = GD.DIVISION_ID "
               "AND GI.VALID_YN = 'Y' AND (GD.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1 OR GD.DIVISION_NAME = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1) "
               "AND GI.SCM_SITE_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2 AND GI.PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE12)")
assert L[g].startswith(gate_prefix), L[g][:200]
assert "GI.ITEM_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE13" in L[g + 1] and L[g + 1].lstrip().startswith("AND    NOT EXISTS"), L[g + 1][:120]
proj_exists = gate_prefix.strip()[len("AND    "):]
new_gate = ("                AND    (" + proj_exists + "\n"
            "                        OR NOT EXISTS (SELECT 1 FROM SCM_MST_SITE_ITEM GI, SCM_MST_DIVISION GD WHERE GI.DIVISION_ID = GD.DIVISION_ID "
            "AND GI.VALID_YN = 'Y' AND (GD.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1 OR GD.DIVISION_NAME = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1) "
            "AND GI.SCM_SITE_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2 AND GI.ITEM_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE13))"
            f"  /*[{TAG}] 구 가드 'Project 통과 행만' → Project 오류 행도 판정: Project 통과면 (Site,Project,Model) 조합, "
            "Project 오류면 (Site,Model) 자체 미등재일 때만 (사용자 지적 2026-09-30 — [Project]=AAA·[Model]=BBB 중 Model 미표기)*/\n")
new = list(L)
new[g] = new_gate
assert [i for i in range(len(L)) if L[i] != new[i]] == [g]
src1 = "".join(new)
print(f"기준본 LAST_DDL={ddl0}  Invalid Model 가드 L{g+1} 교체")

now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
stamp = f"-- SOURCE-FRESH: SCM_MGR.{NAME} {TYP} LAST_DDL={ddl0} FETCHED={now} DB=ZIOUI1\n"
BAK.write_text(stamp + "-- 적용 전 원문 (PMSI 적용본)\nCREATE OR REPLACE " + src0.rstrip() + "\n/\n", encoding="utf-8")
NEW.write_text(stamp + f"-- [{TAG}] PKG_DMF0014 BODY 전체본\nCREATE OR REPLACE " + src1.rstrip() + "\n/\n", encoding="utf-8")
print("파일 생성 완료")

if MODE == "apply":
    assert last_ddl() == ddl0 and "".join(fetch()) == src0, "FRESH-GATE: 추출 이후 변경 감지 — 중단"
    st, errs = compile_src(src1)
    print(f"적용 결과 STATUS={st} 오류={len(errs)} LAST_DDL={last_ddl()}")
    if st != "VALID" or errs:
        for x in errs[:15]:
            print("  ERR", x)
        print("⚠ 원복:", compile_src(src0))
        sys.exit(1)
cn.close()
