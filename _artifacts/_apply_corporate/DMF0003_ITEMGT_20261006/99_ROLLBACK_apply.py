"""[E20261006-ITEMGT] 원복 — 초기화 DELETE 블록 · 3단 적재 블록 제거, 임시테이블 참조 6곳을 뷰로 되돌린다.

결과 = 2026-10-02 20:31:56 원문(뷰 DM_MST_ITEM_SINGLE_V 직접 조회판). ASISPARITY 가드(비활성 8곳)는 되살리지 않는다.
방식: 지금 DB 원문(ALL_SOURCE)을 새로 읽어 그 위에서 삽입·치환분만 되돌림 (백업 파일 통째 덮어쓰기 아님 — 적용 이후 타 작업자 변경 보존).
임시테이블 4종은 남겨 둔다(다른 객체가 참조하지 않으며 비어 있음).
  python 99_ROLLBACK_apply.py
"""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import build_apply as B

TAIL = "  /* " + B.MARK + " 뷰 DM_MST_ITEM_SINGLE_V → 임시테이블 */"

with B.connect() as con:
    cur = con.cursor()
    base = B.read_source(cur)
    src = base["src"]
    if src.count(B.MARK) != 9 or B.INIT_BLOCK not in src or B.LOAD_BLOCK not in src or src.count(TAIL) != 6:
        sys.exit("ABORT: 삽입분 불일치 (이미 원복됐거나 원문 변경 — 수동 확인 필요)")
    new = src.replace("\n" + B.INIT_BLOCK, "", 1).replace("\n\n" + B.LOAD_BLOCK, "", 1)
    lines = new.split("\n")
    for i, l in enumerate(lines):
        if l.endswith(TAIL):
            lines[i] = l[:-len(TAIL)].replace(B.GT_ALL, B.VIEW)
    new = "\n".join(lines)
    assert B.MARK not in new and B.GT_ALL not in new
    print("10-02 원문과 동일:", B.md5(new) == B.BASE_MD5)
    # FRESH-GATE: 적용 직전 재조회 == 방금 읽은 기준본
    now = B.read_source(cur)
    if now["md5"] != base["md5"] or now["last_ddl"] != base["last_ddl"]:
        sys.exit("FRESH-GATE FAIL")
    print("FRESH-GATE PASS")
    cur.execute(B.ddl_text(new).rstrip())
    after = B.read_source(cur)
    cur.execute("SELECT COUNT(*) FROM all_errors WHERE owner='SCM_MGR' AND name=:n", n=B.PKG)
    print("ROLLBACK DONE", after["last_ddl"], after["status"], "errors", cur.fetchone()[0])
