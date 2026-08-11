#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""authunion_apply.py — 권한그룹 판정 합집합(AUTHUNION) 화면별 적용기 (2026-08-09)

`dmf0042_authunion_patch.py`(DMF0042 전용)를 **다화면 재사용 가능**하게 일반화한 것.
정책 원천 = 2026-08-04 사용자 확정("복수 권한그룹 보유 시 편집권한을 합집합으로").
대상 선정 = `authunion_coverage_scan.py` 의 '미적용/혼재' × FE USER_ID·GHOST 직전달.

사용:
  python authunion_apply.py --pkg PKG_DMF0044 --dump
  python authunion_apply.py --pkg PKG_DMF0044 --patch     # 치환 1곳만, diff 출력
  python authunion_apply.py --pkg PKG_DMF0044 --deploy    # 배포 + 컴파일/마커 자동 검증
  python authunion_apply.py --pkg PKG_DMF0044 --verify    # 판정식 사전/사후 대조 (읽기 전용)

⛔ 안전장치: 치환 대상이 정확히 TARGETS[pkg]['count'] 건이 아니면 **중단**한다.
   (원문이 예상과 다르면 손대지 않는다 — 룰 sp-body-no-rewrite)
"""
import argparse
import pathlib
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info  # noqa: E402

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

ROOT = pathlib.Path(__file__).resolve().parents[2]
OUT = ROOT / "_artifacts" / "_apply_corporate"
MARK = "AUTHUNION 2026-08-09"

# 화면별 치환 정의 — OLD 는 **라이브 소스 원문 그대로**(들여쓰기 포함). count 는 기대 치환 건수.
#   users = 보유그룹 조회에 넣을 세션 파라미터들(그룹명/USER_ID/감사키 어느 것이 와도 해석되게).
TARGETS = {
    "PKG_DMF0044": {
        "old": "            AND    SEGMENT1 = P_USER_GROUP",
        "new": ("            AND    (SEGMENT1 = P_USER_GROUP  --[%s] 보유그룹 합집합 판정 (사용자 승인)\n"
                "                    OR SEGMENT1 IN (SELECT G.USER_GR_ID FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M G\n"
                "                                    WHERE G.USER_ID IN (P_USER_GROUP, P_USER_ID, P_CREATED_BY)\n"
                "                                      AND G.USE_YN = 'Y'))" % MARK),
        "count": 1,
        "users": ["P_USER_GROUP", "P_USER_ID", "P_CREATED_BY"],
    },
    # ⚠ DMF0049 는 파라미터가 **소문자** `p_user_group` 이다(DMF0044 는 대문자). 원문 그대로 맞춘다 —
    #   대문자로 두면 치환 0건이 되고 안전장치가 중단시킨다(2026-08-09 실측).
    "PKG_DMF0049": {
        "old": "            AND    SEGMENT1 = p_user_group",
        "new": ("            AND    (SEGMENT1 = p_user_group  --[%s] 보유그룹 합집합 판정 (사용자 승인)\n"
                "                    OR SEGMENT1 IN (SELECT G.USER_GR_ID FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M G\n"
                "                                    WHERE G.USER_ID IN (p_user_group, p_user_id, p_created_by)\n"
                "                                      AND G.USE_YN = 'Y'))" % MARK),
        "count": 1,
        "users": ["p_user_group", "p_user_id", "p_created_by"],
    },
}


def paths(pkg):
    return (OUT / ("BACKUP_%s_BODY_pre_authunion_20260809.sql" % pkg),
            OUT / ("%s_BODY_AUTHUNION_20260809.sql" % pkg))


def live_body(pkg):
    import oracledb

    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute(
            """SELECT TEXT FROM ALL_SOURCE
                WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE='PACKAGE BODY' ORDER BY LINE""",
            {"n": pkg},
        )
        rows = cur.fetchall()
    if not rows:
        sys.exit("[error] PACKAGE BODY 없음: %s" % pkg)
    return "".join(r[0] for r in rows)


def cmd_dump(pkg):
    backup, _ = paths(pkg)
    body = live_body(pkg)
    OUT.mkdir(parents=True, exist_ok=True)
    backup.write_text("CREATE OR REPLACE " + body.lstrip(), encoding="utf-8")
    print("[dump] %s (%d 행)" % (backup, len(body.splitlines())))
    return 0


def cmd_patch(pkg):
    backup, patched = paths(pkg)
    if not backup.is_file():
        sys.exit("[error] 백업 부재 — --dump 선행")
    cfg = TARGETS[pkg]
    text = backup.read_text(encoding="utf-8")
    n = text.count(cfg["old"])
    if n != cfg["count"]:
        sys.exit("[error] 치환 대상 %d건 (기대 %d건) — 원문 확인 필요. 손대지 않음" % (n, cfg["count"]))
    new_text = text.replace(cfg["old"], cfg["new"])
    patched.write_text(new_text, encoding="utf-8")
    print("[patch] %s" % patched)
    print("  %d행 → %d행" % (len(text.splitlines()), len(new_text.splitlines())))
    i = new_text.find(cfg["new"])
    print("---- 치환 근방 ----")
    print(new_text[max(0, i - 300): i + len(cfg["new"]) + 60])
    return 0


def cmd_deploy(pkg):
    import oracledb

    _, patched = paths(pkg)
    if not patched.is_file():
        sys.exit("[error] 배포본 부재 — --patch 선행")
    sql = patched.read_text(encoding="utf-8").rstrip().rstrip("/").rstrip()
    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 60")
        cur.execute(sql)
        cur.execute(
            "SELECT OBJECT_TYPE, STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n ORDER BY 1",
            {"n": pkg},
        )
        for r in cur.fetchall():
            print("  %-14s %s" % (r[0], r[1]))
        cur.execute(
            "SELECT LINE, POSITION, TEXT FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME=:n ORDER BY SEQUENCE",
            {"n": pkg},
        )
        errs = cur.fetchall()
        for e in errs:
            print("  ⛔ L%s:%s %s" % (e[0], e[1], e[2]))
        cur.execute(
            "SELECT COUNT(*) FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n "
            "AND TYPE='PACKAGE BODY' AND INSTR(TEXT, :m) > 0",
            {"n": pkg, "m": MARK},
        )
        print("  AUTHUNION 마커 라인 수 = %d (기대 %d)" % (cur.fetchone()[0], TARGETS[pkg]["count"]))
    return 1 if errs else 0


def cmd_verify(pkg, accounts):
    """판정식 사전(단일)/사후(합집합) 대조 — 회귀 0·과권한 0 확인 (읽기 전용)."""
    import oracledb

    u, p, d = conn_info()
    print("== %s 판정식 대조 (단일그룹 → 합집합) ==" % pkg)
    print("%-16s %10s %10s   %s" % ("전달값", "단일", "합집합", "해석"))
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        for who in accounts:
            cur.execute(
                """SELECT
                     (SELECT COUNT(1) FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                       WHERE LOOKUP_TYPE='GET_ADMIN_GROUP' AND VALID_YN='Y' AND SEGMENT2='ALL'
                         AND SEGMENT1 = :w),
                     (SELECT COUNT(1) FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                       WHERE LOOKUP_TYPE='GET_ADMIN_GROUP' AND VALID_YN='Y' AND SEGMENT2='ALL'
                         AND (SEGMENT1 = :w
                              OR SEGMENT1 IN (SELECT G.USER_GR_ID FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M G
                                               WHERE G.USER_ID = :w AND G.USE_YN='Y')))
                   FROM DUAL""",
                {"w": who},
            )
            a, b = cur.fetchone()
            note = ("유지" if a > 0 and b > 0 else
                    "⭐ 해소(탈락→통과)" if a == 0 and b > 0 else
                    "변화 없음(과권한 0)" if a == 0 and b == 0 else "⛔ 회귀")
            print("%-16s %10d %10d   %s" % (who, a, b, note))
    return 0


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--pkg", required=True)
    ap.add_argument("--dump", action="store_true")
    ap.add_argument("--patch", action="store_true")
    ap.add_argument("--deploy", action="store_true")
    ap.add_argument("--verify", action="store_true")
    ap.add_argument("--accounts", default="ADMIN,GHOST_GROUP,minyonglee1,bpark416,jaehyeok,yooah.chung")
    a = ap.parse_args()
    if a.pkg not in TARGETS:
        sys.exit("[error] TARGETS 미등록: %s (등록: %s)" % (a.pkg, ", ".join(TARGETS)))
    if a.dump:
        sys.exit(cmd_dump(a.pkg))
    if a.patch:
        sys.exit(cmd_patch(a.pkg))
    if a.deploy:
        sys.exit(cmd_deploy(a.pkg))
    if a.verify:
        sys.exit(cmd_verify(a.pkg, [x.strip() for x in a.accounts.split(",") if x.strip()]))
    ap.error("--dump / --patch / --deploy / --verify 중 하나 필요")


if __name__ == "__main__":
    main()
