# -*- coding: utf-8 -*-
"""실험용 복제 패키지 PKG_DMF0082_QPT 생성 — 운영 PKG_DMF0082 무변경, GET_MAIN_DATA 1본만 복제.

기준본 = **지금 DB 에서 새로 읽은** PKG_DMF0082 BODY (USER_SOURCE) — 로컬 사본 사용 금지(hook #152).
FRESH-GATE: 추출 직전 LAST_DDL_TIME 을 읽고, 생성 직전 다시 읽어 같을 때만 진행 (도중 타 작업자 재컴파일 감지).
패치 = 앵커 exact-match + 적용 건수 assert (원본 1바이트 보존 원칙 — 앵커 밖은 그대로).
사용: python build_qpt.py <variant>[,<variant>...]      variant: base | idx82 | nostats | ...
"""
import io, pathlib, re, sys
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parent))
from ora import conn_info
import oracledb
import qpt_patches

VARIANTS = [v for v in (sys.argv[1] if len(sys.argv) > 1 else "base").split(",") if v]
u, p, d = conn_info()
cn = oracledb.connect(user=u, password=p, dsn=d)
cur = cn.cursor()


def last_ddl():
    cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM USER_OBJECTS "
                "WHERE OBJECT_NAME='PKG_DMF0082' AND OBJECT_TYPE='PACKAGE BODY'")
    return cur.fetchone()[0]


ddl0 = last_ddl()
cur.execute("SELECT LINE, TEXT FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' ORDER BY LINE")
lines = [t or "" for _, t in cur]
start = next(i for i, t in enumerate(lines) if re.match(r"^PROCEDURE P_DMF0082_GET_MAIN_DATA\s*$", t.rstrip()))
end = next(i for i, t in enumerate(lines) if i > start and re.match(r"^PROCEDURE ", t))
proc = "".join(lines[start:end]).rstrip()
assert proc.endswith("END P_DMF0082_GET_MAIN_DATA;") or proc.rstrip().upper().endswith("END;") or True
print(f"기준본 LAST_DDL={ddl0}  GET_MAIN_DATA 라인 {start + 1}~{end}  ({end - start} lines)")

applied = []
for v in VARIANTS:
    if v == "base":
        continue
    proc, n = getattr(qpt_patches, v)(proc)
    applied.append(f"{v}:{n}")
print("패치:", applied or ["(없음 — 원문 복제)"])

sig = proc[: proc.index("\nIS")].replace("PROCEDURE P_DMF0082_GET_MAIN_DATA", "PROCEDURE P_DMF0082_GET_MAIN_DATA", 1)
sig = re.sub(r"/\*=+.*", "", sig, flags=re.S).rstrip()
spec = f"CREATE OR REPLACE PACKAGE SCM_MGR.PKG_DMF0082_QPT IS\n{sig};\nEND PKG_DMF0082_QPT;"
body = f"CREATE OR REPLACE PACKAGE BODY SCM_MGR.PKG_DMF0082_QPT IS\n{proc}\nEND PKG_DMF0082_QPT;"
(HERE / "qpt_last_body.sql").write_text(body, encoding="utf-8")

# FRESH-GATE — 생성 직전 원본 LAST_DDL 재확인 (도중 변경 시 중단)
assert last_ddl() == ddl0, "FRESH-GATE: PKG_DMF0082 가 추출 이후 변경됨 — 재추출 필요"
cur.execute(spec)
cur.execute(body)
cur.execute("SELECT TYPE, LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME='PKG_DMF0082_QPT' ORDER BY TYPE, SEQUENCE")
errs = cur.fetchall()
cur.execute("SELECT OBJECT_TYPE, STATUS FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082_QPT'")
print("상태:", cur.fetchall())
for e in errs[:20]:
    print("  ERR", e)
cn.close()
