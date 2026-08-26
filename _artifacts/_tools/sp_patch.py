#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""PKG/SP 본문 패치 1-커맨드 실행기 (백업 → 치환 → 컴파일 → 마커 검증 → 실패 시 자동 원복).

## 왜 (사용자 지적 2026-08-23 "보완 작업이 너무 오래 걸린다")
SP 한 곳 고치는 데 매번 같은 스크립트를 손으로 다시 썼다 — 덤프·백업·치환·컴파일·에러출력·원복.
2026-08-23 하루에만 3번 반복(GRAYZERO / BUCKETNLS / procedures 병합). 그 절차를 고정한다.

## 쓰는 법
    # 1) 치환 쌍을 JSON 으로 준비 (old 는 본문에 **정확히 1회** 나와야 한다)
    #    [{"old": "...", "new": "..."}, ...]
    python sp_patch.py --object PKG_DMF0014 --edits edits.json --marker E20260823-XXXX --dry
    python sp_patch.py --object PKG_DMF0014 --edits edits.json --marker E20260823-XXXX --out-dir _artifacts/_apply_corporate/DMF0014_XXXX_20260823

옵션
    --type "PACKAGE BODY"|PROCEDURE|FUNCTION|PACKAGE   (기본 PACKAGE BODY)
    --expect-marker N   적용 후 기대 마커 행수 (미지정 = 1 이상이면 통과)
    --dry               치환 결과만 미리보기 파일로 남기고 DB 미적용

## 안전장치 (직접 짤 때 자주 빠뜨리던 것들)
- old 문자열 출현 횟수 검사 — 0 이면 중단, 2 이상이면 **어느 것인지 모르므로 중단**
- 마커 사전 존재 검사 → 중복 적용 차단
- 적용 전 원문을 `BACKUP_<obj>_<stamp>.sql` 로 저장(그대로 실행하면 원복)
- 컴파일 INVALID 면 `ALL_ERRORS` 출력 후 **백업으로 자동 원복**
"""
import argparse
import io
import json
import pathlib
import sys

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")

import oracledb  # noqa: E402
from ora import conn_info  # noqa: E402


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--object", required=True)
    ap.add_argument("--type", default="PACKAGE BODY")
    ap.add_argument("--edits", required=True, help="치환 쌍 JSON 파일")
    ap.add_argument("--marker", required=True)
    ap.add_argument("--expect-marker", type=int, default=0)
    ap.add_argument("--out-dir", default=".")
    ap.add_argument("--dry", action="store_true")
    a = ap.parse_args()

    out = pathlib.Path(a.out_dir)
    out.mkdir(parents=True, exist_ok=True)
    edits = json.loads(pathlib.Path(a.edits).read_text(encoding="utf-8"))

    u, p, d = conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d)
    cur = con.cursor()
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE=:t ORDER BY LINE",
                {"n": a.object, "t": a.type})
    src = "".join(t for (t,) in cur if t is not None)
    if not src:
        sys.exit(f"⛔ {a.object} ({a.type}) 덤프 실패")
    print(f"[1] 현행 {src.count(chr(10)) + 1}줄")
    if a.marker in src:
        sys.exit(f"⛔ 마커 {a.marker} 가 이미 있다 — 중복 적용 방지")

    patched = src
    for i, e in enumerate(edits, 1):
        old, new = e["old"], e["new"]
        n = patched.count(old)
        if n != 1:
            sys.exit(f"⛔ edit#{i}: old 출현 {n}회 (정확히 1회여야 한다)\n    앞 80자: {old[:80]!r}")
        patched = patched.replace(old, new, 1)
        print(f"[2] edit#{i} 적용 ({len(old)}자 → {len(new)}자)")

    mk = patched.count(a.marker)
    print(f"[3] 패치 후 {patched.count(chr(10)) + 1}줄 / 마커 {mk}회")
    if mk == 0:
        sys.exit("⛔ 치환문에 마커가 없다 — 추적 불가라 중단")
    if a.expect_marker and mk != a.expect_marker:
        sys.exit(f"⛔ 마커 {mk}회 ≠ 기대 {a.expect_marker}회")

    stamp = cur.execute("SELECT TO_CHAR(SYSDATE,'YYYYMMDD_HH24MISS') FROM DUAL").fetchone()[0]
    bak = out / f"BACKUP_{a.object}_{stamp}.sql"
    bak.write_text("CREATE OR REPLACE " + src + "\n/\n", encoding="utf-8")
    (out / f"PREVIEW_{a.object}.sql").write_text("CREATE OR REPLACE " + patched + "\n/\n", encoding="utf-8")
    print(f"[4] 백업 {bak.name} / 미리보기 PREVIEW_{a.object}.sql")

    if a.dry:
        print("\n(dry) DB 미적용")
        return 0

    cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 120")
    cur.execute("CREATE OR REPLACE " + patched)
    cur.execute("""SELECT STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR'
                    AND OBJECT_NAME=:n AND OBJECT_TYPE=:t""", {"n": a.object, "t": a.type})
    st = cur.fetchone()[0]
    print(f"[5] 컴파일 STATUS = {st}")
    if st != "VALID":
        cur.execute("""SELECT LINE, POSITION, TEXT FROM ALL_ERRORS
                        WHERE OWNER='SCM_MGR' AND NAME=:n ORDER BY SEQUENCE""", {"n": a.object})
        for ln, pos, txt in cur.fetchall()[:10]:
            print(f"    {ln}:{pos} {txt.rstrip()}")
        print("[6] 자동 원복 실행")
        cur.execute("CREATE OR REPLACE " + src)
        con.commit()
        sys.exit("⛔ INVALID — 원복 완료. 치환문을 고쳐 다시 시도")

    cur.execute("""SELECT COUNT(*) FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE=:t
                    AND INSTR(TEXT, :m) > 0""", {"n": a.object, "t": a.type, "m": a.marker})
    print(f"[6] 라이브 마커 실측 {cur.fetchone()[0]}행")
    con.commit()
    con.close()
    print("\n적용 완료")
    return 0


if __name__ == "__main__":
    sys.exit(main())
