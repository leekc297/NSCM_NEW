#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""dmf0042_authunion_patch.py — PKG_DMF0042 권한그룹 판정 합집합(AUTHUNION) 적용 (2026-08-09)

배경: 2026-08-04 사용자 확정 정책 "사용자가 여러 권한그룹 보유 시 각 그룹의 편집권한을 합집합으로 사용"
      이 PKG_DMF0082(5곳)/PKG_DMF0021(3곳)/PKG_DMF0003(v2) 에만 적용돼 있고 **DMF0042 는 미적용**이었다.
      (memory feedback_session_groupid_ghost_field / 2026-08-09 게이트 마감 §6 이월 → 사용자 승인)

동작:
  --dump   라이브 BODY 를 백업 파일로 저장 (원본 1바이트 무수정 — 룰 sp-body-no-rewrite)
  --patch  백업본에서 **판정 WHERE 절 1곳만** 치환한 배포본 생성 + diff 출력
  --deploy 배포본 실행 + 컴파일 상태/에러 리포트

치환 대상(유일): PKG_DMF0042 BODY 의 GET_ADMIN_GROUP 판정
    AND    SEGMENT1 = p_userinfo;
  → AND    (SEGMENT1 = p_userinfo  --[AUTHUNION 2026-08-09] 보유그룹 합집합 판정 (사용자 승인)
            OR SEGMENT1 IN (SELECT G.USER_GR_ID FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M G
                            WHERE G.USER_ID IN (p_userinfo, p_created_by) AND G.USE_YN = 'Y'));
"""
import argparse
import pathlib
import re
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info  # noqa: E402

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

ROOT = pathlib.Path(__file__).resolve().parents[2]
OUT = ROOT / "_artifacts" / "_apply_corporate"
BACKUP = OUT / "BACKUP_PKG_DMF0042_BODY_pre_authunion_20260809.sql"
PATCHED = OUT / "PKG_DMF0042_BODY_AUTHUNION_20260809.sql"

OLD = "\tAND    SEGMENT1 = p_userinfo;"
NEW = (
    "\tAND    (SEGMENT1 = p_userinfo  --[AUTHUNION 2026-08-09] 보유그룹 합집합 판정 (사용자 승인)\n"
    "\t        OR SEGMENT1 IN (SELECT G.USER_GR_ID FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M G\n"
    "\t                        WHERE G.USER_ID IN (p_userinfo, p_created_by) AND G.USE_YN = 'Y'));"
)


def live_body():
    import oracledb

    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute(
            """SELECT TEXT FROM ALL_SOURCE
                WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0042' AND TYPE='PACKAGE BODY'
                ORDER BY LINE"""
        )
        return "".join(r[0] for r in cur.fetchall())


def cmd_dump():
    body = live_body()
    OUT.mkdir(parents=True, exist_ok=True)
    BACKUP.write_text("CREATE OR REPLACE " + body.lstrip(), encoding="utf-8")
    print(f"[dump] {BACKUP} ({len(body.splitlines())} 행)")
    return 0


def cmd_patch():
    if not BACKUP.is_file():
        sys.exit("[error] 백업 부재 — --dump 선행")
    text = BACKUP.read_text(encoding="utf-8")
    n = text.count(OLD)
    if n != 1:
        # ⛔ 0건이면 이미 적용됐거나 원문이 다르고, 2건 이상이면 의도치 않은 지점까지 바꾼다.
        sys.exit(f"[error] 치환 대상 {n}건 (기대 1건) — 원문 확인 필요")
    patched = text.replace(OLD, NEW)
    PATCHED.write_text(patched, encoding="utf-8")
    print(f"[patch] {PATCHED}")
    print(f"  기존 {len(text.splitlines())}행 → 배포본 {len(patched.splitlines())}행 (+2)")
    # diff 근방 출력 — 무엇이 바뀌는지 눈으로 확인
    i = patched.find(NEW)
    print("---- 치환 근방 ----")
    print(patched[max(0, i - 320):i + len(NEW) + 40])
    return 0


def cmd_deploy():
    import oracledb

    if not PATCHED.is_file():
        sys.exit("[error] 배포본 부재 — --patch 선행")
    sql = PATCHED.read_text(encoding="utf-8").rstrip().rstrip("/").rstrip()
    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        # 라이브 PKG 재배포 — 실행 중 세션이 잡고 있으면 ORA-04021. 대기 상한을 명시한다.
        cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 60")
        cur.execute(sql)
        cur.execute(
            "SELECT OBJECT_TYPE, STATUS FROM ALL_OBJECTS "
            "WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0042' ORDER BY 1"
        )
        for r in cur.fetchall():
            print(f"  {r[0]:14} {r[1]}")
        cur.execute(
            "SELECT LINE, POSITION, TEXT FROM ALL_ERRORS "
            "WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0042' ORDER BY SEQUENCE"
        )
        errs = cur.fetchall()
        for e in errs:
            print(f"  ⛔ L{e[0]}:{e[1]} {e[2]}")
        cur.execute(
            "SELECT COUNT(*) FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0042' "
            "AND TYPE='PACKAGE BODY' AND INSTR(TEXT,'AUTHUNION 2026-08-09') > 0"
        )
        print(f"  AUTHUNION 마커 라인 수 = {cur.fetchone()[0]} (기대 1)")
        return 1 if errs else 0


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dump", action="store_true")
    ap.add_argument("--patch", action="store_true")
    ap.add_argument("--deploy", action="store_true")
    a = ap.parse_args()
    if a.dump:
        sys.exit(cmd_dump())
    if a.patch:
        sys.exit(cmd_patch())
    if a.deploy:
        sys.exit(cmd_deploy())
    ap.error("--dump / --patch / --deploy 중 하나 필요")


if __name__ == "__main__":
    main()
