"""[E20261006-ASISDELTA] 원복 — 이번에 바꾼 줄만 되돌린다.

방식: 지금 DB 원문(ALL_SOURCE)을 새로 읽어 그 위에서 변경분만 제거 (백업 파일 통째 덮어쓰기 아님 —
      적용 이후 타 작업자 변경 보존).
  python 99_ROLLBACK_apply.py            # 두 객체 모두
  python 99_ROLLBACK_apply.py BAL | NSD  # 한 객체만
"""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import build_apply as B


def undo_bal(src):
    import build_apply2 as B2                      # 2차(#005~#007) 삽입 3줄 먼저 제거
    assert all(src.count(a) == (1 if k != "005" else 1) for k, a in B2.ADD.items()) or not any(a in src for a in B2.ADD.values())
    assert sum(l in B2.ADD.values() for l in src.split("\n")) in (0, 3), "2차 삽입분 개수 불일치"
    src = "\n".join(l for l in src.split("\n") if l not in B2.ADD.values())
    lines = src.split("\n")
    assert src.count(B.BAL_NEW) == 1 and src.count(B.BAL_HDR) == 1 and src.count(B.MARK) == 2, "변경분 개수 불일치"
    lines = [B.BAL_OLD if l == B.BAL_NEW else l for l in lines if l != B.BAL_HDR]
    out = "\n".join(lines)
    assert B.MARK not in out and out.count(B.BAL_OLD) == 2
    return out


def undo_nsd(src):
    lines = src.split("\n")
    assert src.count(B.MARK) == 3, "변경분 개수 불일치"
    s, e = lines.index(B.NSD_OPEN), lines.index(B.NSD_CLOSE)
    assert lines[s + 1] == B.NSD_NOTE and e - s - 2 == B.NSD_BLOCK_LINES
    block = lines[s + 2:e]
    assert all(l.startswith(B.CMT) for l in block)
    lines[s:e + 1] = [l[len(B.CMT):] for l in block]
    lines = [l for l in lines if l != B.NSD_HDR]
    out = "\n".join(lines)
    assert B.MARK not in out
    return out


TARGET = {"BAL": (B.BAL, undo_bal), "NSD": (B.NSD, undo_nsd)}
pick = sys.argv[1:] or list(TARGET)
with B.connect() as con:
    cur = con.cursor()
    for k in pick:
        name, fn = TARGET[k]
        base = B.read_source(cur, name)
        new = fn(base["src"])
        # FRESH-GATE: 적용 직전 재조회 == 방금 읽은 기준본
        now = B.read_source(cur, name)
        if now["md5"] != base["md5"] or now["last_ddl"] != base["last_ddl"]:
            sys.exit("FRESH-GATE FAIL " + name)
        print("FRESH-GATE PASS", name)
        cur.execute(B.ddl_text(new).rstrip())
        after = B.read_source(cur, name)
        cur.execute("SELECT COUNT(*) FROM all_errors WHERE owner='SCM_MGR' AND name=:n", n=name)
        print("ROLLBACK DONE", name, after["last_ddl"], after["status"], "errors", cur.fetchone()[0])
