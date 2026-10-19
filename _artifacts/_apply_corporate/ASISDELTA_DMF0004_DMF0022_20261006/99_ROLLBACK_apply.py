"""[E20261006-ASISDELTA] 원복 — 지금 DB 원문(ALL_SOURCE)에서 이번 변경분만 걷어낸다 (그 뒤 다른 작업분은 보존)

  python 99_ROLLBACK_apply.py DMF0004    # 삽입 19줄 제거
  python 99_ROLLBACK_apply.py DMF0022    # 주석 2줄 제거 + 조건 2줄 원복
FRESH-GATE: 실행 직전 재조회한 원문이 방금 읽은 원문과 같을 때만 적용한다.
"""
import sys, os

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from build_apply import connect, read_source, ddl_text, MARK, OLD22, NEW22, TARGETS

EXPECT = {"DMF0004": 19, "DMF0022": 2}


def revert(key, src):
    lines = src.split("\n")
    if key == "DMF0022":
        assert src.count(NEW22) == 2 and src.count(MARK) == 2
        out = "\n".join(l for l in lines if MARK not in l).replace(NEW22, OLD22)
        return out, len(lines) - len(out.split("\n"))
    # DMF0004: 표식 주석 5줄 + 각 주석 바로 아래 삽입 줄 (4·4·2·2·2)
    follow = {"AS-IS L229-230": 4, "HAS_* =": 4, "AS-IS L433-434": 2, "AS-IS L457-458": 2, "AS-IS L479-480": 2}
    drop = set()
    for i, l in enumerate(lines):
        if MARK in l:
            n = [v for k, v in follow.items() if k in l]
            assert len(n) == 1, l
            drop.update(range(i, i + 1 + n[0]))
    for i in drop:
        assert any(t in lines[i] for t in (MARK, "DISTRIBUTION_CHANNEL", "ATTRIBUTE5", "ATTRIBUTE3")), lines[i]
    out = "\n".join(l for i, l in enumerate(lines) if i not in drop)
    assert MARK not in out
    return out, len(drop)


if __name__ == "__main__":
    key = sys.argv[1]
    pkg = TARGETS[key][0]
    with connect() as con:
        cur = con.cursor()
        base = read_source(cur, pkg)
        new, n = revert(key, base["src"])
        assert n == EXPECT[key], n
        # FRESH-GATE: 적용 직전 DB 원문(ALL_SOURCE) 재조회 == 방금 읽은 기준본
        now = read_source(cur, pkg)
        if now["md5"] != base["md5"] or now["last_ddl"] != base["last_ddl"]:
            sys.exit("FRESH-GATE FAIL: 원문 변경 — 중단")
        cur.execute(ddl_text(new).rstrip())
        after = read_source(cur, pkg)
        cur.execute("SELECT COUNT(*) FROM all_errors WHERE owner='SCM_MGR' AND name=:n", n=pkg)
        print("ROLLBACK", pkg, f"-{n} lines", after["last_ddl"], after["status"], "errors", cur.fetchone()[0])
