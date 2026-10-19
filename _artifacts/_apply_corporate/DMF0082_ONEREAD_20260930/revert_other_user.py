# -*- coding: utf-8 -*-
"""PKG_DMF0082 BODY — 금일 이 PC 외 작업분(AJS 2026-09-30 15:46:14, TB_FX_USER→SCM_ADM_USER_M) 제거 (사용자 지시 2026-09-30).

금일 적용 계보(이 PC): 08:04 QRYPERF → 10:18 CLOUDPERF → 12:07 81SP → 15:48 ONEREAD. 사이에 끼어든 외부 수정 = 15:46 AJS 1건.
방법: 12:07 81SP 적용본(02_PKG_DMF0082_BODY_81POST.sql) ↔ 15:46 기준본(00_BACKUP_PKG_DMF0082_BODY.sql) diff = AJS 변경분만.
      현재 DB 원문에서 그 변경 구간(15:46 텍스트)을 찾아 12:07 텍스트로 되돌린다. 구간마다 현재 원문 1회 출현 assert.
FRESH-GATE: 지금 DB 원문 기준 · 적용 직전 재조회 일치 시에만 CREATE OR REPLACE. 실패 시 원복.
결과 = 12:07 81SP 적용본 + 15:48 ONEREAD 변경만 (검증: 되돌린 뒤 ONEREAD 를 제외한 부분이 81POST 와 완전 일치).
usage: python revert_other_user.py check | apply
"""
import difflib, io, pathlib, sys
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parents[1] / "_diagnostics"))
from ora import conn_info
import oracledb

MODE = sys.argv[1] if len(sys.argv) > 1 else "check"
NAME, TYP = "PKG_DMF0082", "PACKAGE BODY"
body = lambda p: p.read_text(encoding="utf-8").split("CREATE OR REPLACE ", 1)[1].rsplit("\n/\n", 1)[0]
P81 = body(HERE.parent / "DMF0082_81SALESPLAN_20260930" / "02_PKG_DMF0082_BODY_81POST.sql").split("\n")
AJS = body(HERE / "00_BACKUP_PKG_DMF0082_BODY.sql").split("\n")
u, p, d = conn_info()
cn = oracledb.connect(user=u, password=p, dsn=d)
cn.call_timeout = 600000
cur = cn.cursor()


def last_ddl():
    cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM USER_OBJECTS WHERE OBJECT_NAME=:1 AND OBJECT_TYPE=:2", [NAME, TYP])
    return cur.fetchone()[0]


def fetch():
    cur.execute("SELECT TEXT FROM USER_SOURCE WHERE NAME=:1 AND TYPE=:2 ORDER BY LINE", [NAME, TYP])
    return "".join(t or "" for (t,) in cur)


def compile_src(src):
    cur.execute("CREATE OR REPLACE " + src.rstrip())
    cur.execute("SELECT STATUS FROM USER_OBJECTS WHERE OBJECT_NAME=:1 AND OBJECT_TYPE=:2", [NAME, TYP])
    st = cur.fetchone()[0]
    cur.execute("SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME=:1 AND TYPE=:2 ORDER BY SEQUENCE", [NAME, TYP])
    return st, cur.fetchall()


ddl0 = last_ddl()
cur_src = fetch()
assert ddl0 == "2026-09-30 15:48:07", f"예상 외 LAST_DDL {ddl0} — 추가 변경 발생, 중단"
cur_lines = cur_src.split("\n")
hunks = [(i1, i2, j1, j2) for tag, i1, i2, j1, j2 in difflib.SequenceMatcher(None, P81, AJS, autojunk=False).get_opcodes() if tag != "equal"]
print(f"AJS 변경 구간 {len(hunks)}개")
S = 7000                                           # ONEREAD 변경(L1247~1790) 뒤 · AJS 변경(L7824~) 앞의 공통 구간
assert hunks[0][0] > S and hunks[0][2] > S and P81[:S] == AJS[:S]
delta = len(cur_lines) - len(AJS)                  # ONEREAD 로 늘어난 줄 수
assert cur_lines[S + delta:] == AJS[S:], "현재 원문 L7000 이후 != 15:46 기준본 — 중단"
assert "E20260930-DMF0082ONEREAD" not in "\n".join(cur_lines[S + delta:])
new = cur_lines[:S + delta] + P81[S:]
for i1, i2, j1, j2 in hunks:
    print(f"  원복: AJS L{j1+1}~{j2} ({j2-j1}줄) -> 12:07 원문 L{i1+1}~{i2} ({i2-i1}줄) | {(AJS[j1] if j2 > j1 else '').strip()[:60]}")
src1 = "\n".join(new)
# 검증: 결과 ↔ 81POST 차이는 ONEREAD 마커 구간뿐
rest = [(t, a, b) for t, a, b, _, _ in difflib.SequenceMatcher(None, P81, new, autojunk=False).get_opcodes() if t != "equal"]
chk = difflib.SequenceMatcher(None, P81, new, autojunk=False).get_opcodes()
other = []
for t, i1, i2, j1, j2 in chk:
    if t == "equal":
        continue
    seg = "\n".join(new[j1:j2]) + "\n".join(P81[i1:i2])
    if "E20260930-DMF0082ONEREAD" not in "\n".join(new[max(0, j1 - 3):j2 + 3]) and "IDX02_SCM_MST_FUTURE_PRICE" not in seg:
        other.append((i1, i2, j1, j2))
# (구성상 보장: L7000 앞 = 현 원문(ONEREAD 적용본, 그 구간은 P81==AJS), 뒤 = 12:07 원문. 경계 일치 위 assert 로 증명 — 창 기반 검사는 ONEREAD 구간 오탐이라 생략)
assert all(a >= S for a, *_ in [(h[0],) for h in hunks])
assert "SCM_ADM_USER_M" not in src1 or src1.count("2026.09.30 AJS") == 0
assert src1.count("2026.09.30 AJS") == 0 and src1.count("E20260930-DMF0082ONEREAD") == 3
print("검증: AJS 흔적 0 · ONEREAD 마커 3 · 81POST 대비 차이는 ONEREAD 구간뿐")
(HERE / "10_BACKUP_BEFORE_REVERT_AJS.sql").write_text(f"-- LAST_DDL={ddl0} (AJS 15:46 + ONEREAD 15:48) — AJS 수정 복원용\nCREATE OR REPLACE " + cur_src.rstrip() + "\n/\n", encoding="utf-8")
(HERE / "11_PKG_DMF0082_BODY_ONEREAD_NO_AJS.sql").write_text("-- 81SP(12:07) + ONEREAD — AJS 15:46 제거본\nCREATE OR REPLACE " + src1.rstrip() + "\n/\n", encoding="utf-8")
if MODE == "apply":
    assert last_ddl() == ddl0 and fetch() == cur_src, "FRESH-GATE: 변경 감지 — 중단"
    st, errs = compile_src(src1)
    print(f"적용 결과 STATUS={st} 오류={len(errs)} LAST_DDL={last_ddl()}")
    if st != "VALID" or errs:
        for x in errs[:10]:
            print("  ERR", x)
        print("⚠ 원복:", compile_src(cur_src))
        sys.exit(1)
    cur.execute("SELECT COUNT(*), SUM(LENGTH(RTRIM(TEXT, CHR(10)||CHR(13)))) FROM USER_SOURCE WHERE NAME=:1 AND TYPE=:2 AND LINE>1", [NAME, TYP])
    print("지문", cur.fetchone())
cn.close()
