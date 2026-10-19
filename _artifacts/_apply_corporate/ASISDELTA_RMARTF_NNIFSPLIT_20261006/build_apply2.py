"""[E20261006-ASISDELTA] 2차 — RMA RTF 예외항목 비교 조건 #005~#007 (확정 시트 번호 26·27·28)

  PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE  [E20260812-001054]
  AS-IS 운영 원문은 3곳 모두 옛 조건(A.MEASURE = B.MEASURE)을 남긴 채 리터럴 비교 1줄을 덧붙였다.
    L1783-1784  DM_PLN_MKT_FCST            RTF_PR     arm : + AND 'RTF_PR'     = B.MEASURE   (#005)
    L1874-1875  DM_PLN_CFM_MKT_DEMAND_PLAN RTF_SYS_RP arm : + AND 'RTF_SYS_RP' = B.MEASURE   (#006)
    L1912-1913  DM_PLN_CFM_MKT_DEMAND_PLAN RTF_PR     arm : + AND 'RTF_PR'     = B.MEASURE   (#007)
  운영 원문 그대로(옛 조건 유지 + 1줄 추가) 옮긴다 — 실행 결과는 추가 전과 같다 (사용자 결정 2026-10-06 "현상태 유지").

방식: 지금 DB 원문(ALL_SOURCE) 위에 3줄 삽입 (기존 줄 변경·삭제 없음).
  python build_apply2.py backup | build | apply
"""
import sys, os, json
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import build_apply as B

HERE = B.HERE
NAME = B.BAL
STATE = os.path.join(HERE, "_fresh_state2.json")
MKT_OLD = B.BAL_OLD                                   # 1차 후 RTF_PR arm 에만 남아 있음
CFM_OLD = "                              AND A.INCOTERMS     = B.INCOTERMS   AND A.MEASURE      = B.MEASURE"
TAIL = "  /* " + B.BAL_SR + " 비교대상 명시 — 원 조건 유지 + 추가 (AS-IS 운영 {}) " + B.MARK + " */"
ADD = {"005": "                              AND 'RTF_PR'        = B.MEASURE" + TAIL.format("L1783-1784"),
       "006": "                              AND 'RTF_SYS_RP'    = B.MEASURE" + TAIL.format("L1874-1875"),
       "007": "                              AND 'RTF_PR'        = B.MEASURE" + TAIL.format("L1912-1913")}


def arm_of(lines, i):
    """i 줄 위쪽에서 가장 가까운 SELECT 의 대상 테이블·메저."""
    j = next(k for k in range(i, i - 20, -1) if lines[k].lstrip().startswith("SELECT A.DIVISION_ID"))
    meas = "RTF_SYS_RP" if "'RTF_SYS_RP' AS MEASURE" in lines[j] else "RTF_PR" if "'RTF_PR' AS MEASURE" in lines[j] else None
    frm = next(lines[k].strip() for k in range(j, i) if lines[k].strip().startswith("FROM DM_PLN_"))
    return frm, meas


def transform(src):
    assert src.count(B.MARK) == 2 and src.count(B.BAL_NEW) == 1, "1차 적용 상태가 아님"
    assert not any(a in src for a in ADD.values()), "이미 반영됨"
    lines = src.split("\n")
    n0 = len(lines)
    m = [i for i, l in enumerate(lines) if l == MKT_OLD]
    c = [i for i, l in enumerate(lines) if l == CFM_OLD]
    assert len(m) == 1 and len(c) == 2, (len(m), len(c))
    assert arm_of(lines, m[0]) == ("FROM DM_PLN_MKT_FCST A", "RTF_PR")
    assert arm_of(lines, c[0]) == ("FROM DM_PLN_CFM_MKT_DEMAND_PLAN A", "RTF_SYS_RP")
    assert arm_of(lines, c[1]) == ("FROM DM_PLN_CFM_MKT_DEMAND_PLAN A", "RTF_PR")
    for i, k in sorted(((m[0], "005"), (c[0], "006"), (c[1], "007")), reverse=True):   # 뒤에서부터 삽입
        lines.insert(i + 1, ADD[k])
    out = "\n".join(lines)
    assert len(lines) == n0 + 3 and out.count(B.MARK) == 5
    assert [l for l in lines if l not in ADD.values()] == src.split("\n"), "삽입 외 변경 발생"
    return out


def backup():
    with B.connect() as con:
        b = B.read_source(con.cursor(), NAME)
    with open(os.path.join(HERE, f"03_BACKUP_{NAME}.sql"), "w", encoding="utf-8", newline="\n") as f:
        f.write(B.stamp(NAME, b) + B.ddl_text(b["src"]) + "/\n")
    with open(os.path.join(HERE, f"_base2_{NAME}.txt"), "w", encoding="utf-8", newline="\n") as f:
        f.write(b["src"])
    json.dump({k: b[k] for k in ("last_ddl", "status", "md5")}, open(STATE, "w"), indent=1)
    print("BACKUP", NAME, b["last_ddl"], b["status"], b["md5"])


def build(cur):
    base = B.read_source(cur, NAME)
    new = transform(base["src"])
    with open(os.path.join(HERE, f"04_{NAME}.sql"), "w", encoding="utf-8", newline="\n") as f:
        f.write(B.stamp(NAME, base) + "-- " + B.MARK + " RMA RTF 예외항목 비교 조건 #005~#007 " + B.BAL_SR + "\n" + B.ddl_text(new) + "/\n")
    print("BUILD", NAME, "base", base["last_ddl"], base["md5"], "lines", len(base["src"].split("\n")), "->", len(new.split("\n")))
    return base, new


def apply():
    saved = json.load(open(STATE))
    with B.connect() as con:
        cur = con.cursor()
        base, new = build(cur)
        if saved["md5"] != base["md5"]:
            sys.exit("ABORT: 착수 시 백업본과 현재 DB 원문이 다름 — 재조회·재검토 필요")
        # FRESH-GATE: 적용 직전 DB 원문 재조회 == 방금 읽은 기준본
        now = B.read_source(cur, NAME)
        if now["md5"] != base["md5"] or now["last_ddl"] != base["last_ddl"]:
            sys.exit("FRESH-GATE FAIL: 착수 후 DB 원문 변경 — 중단")
        print("FRESH-GATE PASS", now["last_ddl"], now["md5"])
        cur.execute(B.ddl_text(new).rstrip())
        after = B.read_source(cur, NAME)
        cur.execute("SELECT line, position, text FROM all_errors WHERE owner='SCM_MGR' AND name=:n ORDER BY sequence", n=NAME)
        errs = cur.fetchall()
        cur.execute("SELECT d.name, d.type, o.status FROM all_dependencies d JOIN all_objects o "
                    "ON o.owner=d.owner AND o.object_name=d.name AND o.object_type=d.type "
                    "WHERE d.referenced_owner='SCM_MGR' AND d.referenced_name=:n ORDER BY 1", n=NAME)
        deps = cur.fetchall()
        same = after["src"].rstrip() == new.rstrip()
        print("AFTER", after["last_ddl"], after["status"], "errors", len(errs), "same_as_built", same, "dependents", deps)
        json.dump({"before": {k: base[k] for k in ("last_ddl", "status", "md5")}, "after": {k: after[k] for k in ("last_ddl", "status", "md5")},
                   "errors": errs, "same_as_built": same, "dependents": deps},
                  open(os.path.join(HERE, "_apply_result2.json"), "w", encoding="utf-8"), indent=1, ensure_ascii=False)


if __name__ == "__main__":
    cmd = sys.argv[1:]
    if cmd == ["backup"]:
        backup()
    elif cmd == ["apply"]:
        apply()
    else:
        with B.connect() as con:
            build(con.cursor())
