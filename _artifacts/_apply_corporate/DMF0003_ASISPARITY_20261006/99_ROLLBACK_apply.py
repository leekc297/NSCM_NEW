"""[E20261006-ASISPARITY] 원복 — 삽입한 가드 8곳 + 설명 주석 3줄만 걷어낸다.

방식: 지금 DB 원문(ALL_SOURCE)을 새로 읽어 그 위에서 삽입분만 제거 (백업 파일 통째 덮어쓰기 아님 —
      적용 이후 타 작업자 변경 보존).
  python 99_ROLLBACK_apply.py
"""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import build_apply as B

with B.connect() as con:
    cur = con.cursor()
    base = B.read_source(cur)
    src = base["src"]
    if src.count(B.GUARD_IF) != 4 or src.count(B.GUARD_SQL) != 4:
        sys.exit("ABORT: 삽입분 개수 불일치 (이미 원복됐거나 원문 변경 — 수동 확인 필요)")
    lines = [l for l in src.split("\n")
             if not (l.strip().startswith("-- " + B.MARK) or l.startswith(B.GUARD_SQL))]
    new = "\n".join(lines).replace(B.GUARD_IF, " THEN")
    assert B.MARK not in new and len(new.split("\n")) == len(src.split("\n")) - 7
    # FRESH-GATE: 적용 직전 재조회 == 방금 읽은 기준본
    now = B.read_source(cur)
    if now["md5"] != base["md5"] or now["last_ddl"] != base["last_ddl"]:
        sys.exit("FRESH-GATE FAIL")
    print("FRESH-GATE PASS")
    cur.execute(B.ddl_text(new).rstrip())
    after = B.read_source(cur)
    cur.execute("SELECT COUNT(*) FROM all_errors WHERE owner='SCM_MGR' AND name=:n", n=B.PKG)
    print("ROLLBACK DONE", after["last_ddl"], after["status"], "errors", cur.fetchone()[0])
