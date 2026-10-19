"""[E20261006-ASISPARITY] 원복 — PKG_DMF0044 / PKG_DMF0049 의 비활성 줄 주석 해제 + 설명 주석 제거 + 문구 2곳 되돌림.

방식: 지금 DB 원문(ALL_SOURCE)을 새로 읽어 그 위에서 이번 변경분만 걷어낸다 (백업 파일 통째 덮어쓰기 아님 —
      적용 이후 타 작업자 변경 보존).
  python 99_ROLLBACK_apply.py               # 두 패키지
  python 99_ROLLBACK_apply.py PKG_DMF0049   # 한 패키지만
"""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import build_apply as B

targets = sys.argv[1:] or list(B.PKGS)
assert all(p in B.PKGS for p in targets), targets

with B.connect() as con:
    cur = con.cursor()
    for pkg in targets:
        base = B.read_source(cur, pkg)
        src = base["src"]
        if src.count(B.MARK) != B.MARKS[pkg]:
            sys.exit(f"ABORT {pkg}: 표식 개수 불일치 (이미 원복됐거나 원문 변경 — 수동 확인 필요)")
        new = B.restore(src)
        assert B.MARK not in new and len(new.split("\n")) == len(src.split("\n")) - B.ADDED[pkg]
        assert B.TRANSFORM[pkg](new) == src, pkg + ": 원복본에 다시 적용한 결과가 현재 원문과 다름"
        # FRESH-GATE: 적용 직전 재조회 == 방금 읽은 기준본
        now = B.read_source(cur, pkg)
        if now["md5"] != base["md5"] or now["last_ddl"] != base["last_ddl"]:
            sys.exit("FRESH-GATE FAIL " + pkg)
        print("FRESH-GATE PASS", pkg)
        cur.execute(B.ddl_text(new).rstrip())
        after = B.read_source(cur, pkg)
        cur.execute("SELECT COUNT(*) FROM all_errors WHERE owner='SCM_MGR' AND name=:n", n=pkg)
        print("ROLLBACK DONE", pkg, after["last_ddl"], after["status"], "errors", cur.fetchone()[0])
