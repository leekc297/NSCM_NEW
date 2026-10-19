# -*- coding: utf-8 -*-
"""PKG_DMF0014.P_DMF0014_CUST_FCST_EXCEL_UPLOAD — [Project]/[Model] DMF0005 마스터(SCM_MST_SITE_ITEM) 단독 검증 재활성
[E20260930-DMF0014PMSI]

경위 (2026-09-30):
  13:38 [E20260930-DMF0014ASISPM] 에서 "AS-IS 완전 동일" 선택으로 ③ [Project]/[Model] 단독 검증(E20260929 신설)을 '--' 비활성.
  → 사용자 실측: [Project]=AAA, [Model]=BBB 업로드가 통과. "DMF0005 UI 에서 관리하는 MASTER 체크 로직이 누락" 지적 →
     재활성 선택 (Customer Project 비활성 · Customer Model AS-IS 판정(고객모델 마스터 OR SITE_ITEM) 은 유지).
변경: ASISPM 이 '--' 를 붙인 ③ 블록(줄 단위) 만 원문으로 복원 + 머리 마커 1줄 교체. 그 외 1바이트 불변 (assert).
FRESH-GATE: 지금 DB 원문 기준 · 적용 직전 재조회 일치 시에만 CREATE OR REPLACE. 실패 시 원복.
usage: python apply_pmsi_reenable.py backup | apply | restore
"""
import datetime, io, pathlib, sys
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parents[1] / "_diagnostics"))
from ora import conn_info
import oracledb

MODE = sys.argv[1] if len(sys.argv) > 1 else "backup"
TAG, PREV = "E20260930-DMF0014PMSI", "E20260930-DMF0014ASISPM"
NAME, TYP = "PKG_DMF0014", "PACKAGE BODY"
BAK = HERE / "10_BACKUP_PKG_DMF0014_BODY.pre_PMSI.sql"
NEW = HERE / "11_PKG_DMF0014_BODY_PMSI.sql"
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
hd = [i for i, t in enumerate(L) if f"--[{PREV}] 아래 [Project]/[Model] 단독 검증" in t]
assert len(hd) == 1, hd
h = hd[0]
assert L[h + 1].startswith("--            /* [E20260929-DMF0014PRJMDL] [Project]/[Model] 열 존재 검증"), L[h + 1][:80]
e = next(i for i in range(h + 1, h + 60) if L[i].rstrip("\n") == "--            END IF;")
assert "E20260915-DMF0014MSTCHK" in L[e + 2] and any("V_LOG_TYPE    := '104';" in L[i] for i in range(h, e)), L[e + 2][:80]
new = list(L)
new[h] = (f"            --[{TAG}] [Project]/[Model] DMF0005 마스터(SCM_MST_SITE_ITEM) 단독 검증 재활성 — [Project]=AAA/[Model]=BBB 통과 지적"
          f"(사용자 2026-09-30). Customer Project 비활성·Customer Model AS-IS 판정은 [{PREV}] 유지\n")
for i in range(h + 1, e + 1):
    if L[i].startswith("--"):
        new[i] = L[i][2:]
changed = [i for i in range(len(L)) if L[i] != new[i]]
assert set(changed) <= set(range(h, e + 1)) and len(changed) >= e - h - 2, changed[:5]
src1 = "".join(new)
print(f"기준본 LAST_DDL={ddl0}  ③ L{h+1}~{e+1} 재활성 ({len(changed)}줄)")

now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
stamp = f"-- SOURCE-FRESH: SCM_MGR.{NAME} {TYP} LAST_DDL={ddl0} FETCHED={now} DB=ZIOUI1\n"
BAK.write_text(stamp + "-- 적용 전 원문 (ASISPM 적용본)\nCREATE OR REPLACE " + src0.rstrip() + "\n/\n", encoding="utf-8")
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
