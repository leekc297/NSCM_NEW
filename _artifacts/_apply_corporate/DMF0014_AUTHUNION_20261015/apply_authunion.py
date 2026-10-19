#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""DMF0014 AUTHUNION 적용 (2026-10-15, 사용자 승인 "적용해주세요")

배경: AS-IS DMF0014_GET_CUST_FCST_UPLOAD_DATA 는 p_userinfo(=NowGroupID 그룹명)가 lookup GET_ADMIN_GROUP
     (VALID_YN='Y', SEGMENT2='ALL') 에 있으면 ADMIN → EDIT_FLAG 전행 'Y'.
     TO-BE FE 는 session.groupId(유령 필드) || USER_ID 를 넘기므로 SEGMENT1 = P_USERINFO 가 항상 0건.
조치: PKG_DMF0014 BODY 의 판정 WHERE 2곳(P_DMF0014_GET_CUST_FCST_UPLOAD_DATA / P_DMF0014_GET_EXCEL_FORM_DATA)을
     보유그룹 합집합(AUTHUNION) 판정으로 확장 — FE 무수정(사용자 상시 지시: DB 객체 수정 우선).

사용:
  python apply_authunion.py --patch    # 최신 원문 조회 → ASIS 백업 + TOBE 생성 (DB 무변경)
  python apply_authunion.py --deploy   # FRESH-GATE(재조회==ASIS) → CREATE OR REPLACE → VALID/ERRORS/마커 검증
  python apply_authunion.py --rollback # ASIS 백업으로 원복 (FRESH-GATE: 현재==TOBE 일 때만)
"""
import argparse
import pathlib
import sys

ROOT = pathlib.Path(__file__).resolve().parents[3]
sys.path.insert(0, str(ROOT / "_artifacts" / "_diagnostics"))
from ora import conn_info  # noqa: E402
import oracledb  # noqa: E402

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

HERE = pathlib.Path(__file__).resolve().parent
OWNER, NAME, TYPE = "SCM_MGR", "PKG_DMF0014", "PACKAGE BODY"
ASIS = HERE / "PKG_DMF0014_BODY.ASIS.sql"
TOBE = HERE / "PKG_DMF0014_BODY_AUTHUNION_20261015.sql"
MARK = "AUTHUNION 2026-10-15"

OLD = "        AND    SEGMENT1 = P_USERINFO;\n"
NEW = ("        AND    (SEGMENT1 = P_USERINFO  --[%s] 보유그룹 합집합 판정 (FE groupId 유령 → USER_ID 전달 대응)\n"
       "                OR SEGMENT1 IN (SELECT G.USER_GR_ID FROM SCM_ADM_USER_GR_MPG_M G\n"
       "                                WHERE  G.USER_ID IN (P_USERINFO, P_USER_ID, P_CREATED_BY)\n"
       "                                AND    G.USE_YN = 'Y'));\n" % MARK)
EXPECT = 2


def connect():
    u, p, d = conn_info()
    return oracledb.connect(user=u, password=p, dsn=d)


def fetch(cur):
    """최신 원문 새로고침 (ALL_SOURCE + LAST_DDL_TIME) — #152"""
    cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST'), SYS_CONTEXT('USERENV','SERVICE_NAME'), "
                "TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL")
    host, svc, now = cur.fetchone()
    cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'), STATUS FROM ALL_OBJECTS "
                "WHERE OWNER=:o AND OBJECT_NAME=:n AND OBJECT_TYPE=:t", {"o": OWNER, "n": NAME, "t": TYPE})
    lddl, status = cur.fetchone()
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER=:o AND NAME=:n AND TYPE=:t ORDER BY LINE",
                {"o": OWNER, "n": NAME, "t": TYPE})
    body = "".join(r[0] for r in cur.fetchall())
    print("[fetch] DB=%s/%s FETCHED=%s LAST_DDL=%s STATUS=%s lines=%d"
          % (host, svc, now, lddl, status, len(body.splitlines())))
    return body, lddl, now, host


def ddl(body):
    return "CREATE OR REPLACE " + body.lstrip()


def verify(cur):
    cur.execute("SELECT OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS "
                "WHERE OWNER=:o AND OBJECT_NAME=:n ORDER BY 1", {"o": OWNER, "n": NAME})
    for r in cur.fetchall():
        print("  %-14s %-8s LAST_DDL=%s" % r)
    cur.execute("SELECT LINE, POSITION, TEXT FROM ALL_ERRORS WHERE OWNER=:o AND NAME=:n ORDER BY SEQUENCE",
                {"o": OWNER, "n": NAME})
    errs = cur.fetchall()
    for e in errs:
        print("  ⛔ L%s:%s %s" % e)
    print("  ALL_ERRORS = %d" % len(errs))
    return errs


def cmd_patch():
    with connect() as con:
        body, lddl, now, host = fetch(con.cursor())
    n = body.count(OLD)
    if n != EXPECT:
        sys.exit("[error] 치환 대상 %d건 (기대 %d) — 원문 변경/기반영 의심. 손대지 않음" % (n, EXPECT))
    stamp = "-- SOURCE-FRESH: %s.%s %s LAST_DDL=%s FETCHED=%s DB=ZIOUI1(%s)\n" % (OWNER, NAME, TYPE, lddl, now[:16], host)
    ASIS.write_text(ddl(body), encoding="utf-8")
    TOBE.write_text(stamp + ddl(body.replace(OLD, NEW)), encoding="utf-8")
    print("[patch] ASIS=%s\n        TOBE=%s (치환 %d건)" % (ASIS.name, TOBE.name, n))


def strip_stamp(text):
    return "".join(l for l in text.splitlines(True) if not l.startswith("-- SOURCE-FRESH:"))


def cmd_deploy():
    tobe_sql = strip_stamp(TOBE.read_text(encoding="utf-8"))
    with connect() as con:
        cur = con.cursor()
        body, _, _, _ = fetch(cur)
        # FRESH-GATE: 적용 직전 DB 원문 재조회 == 착수 기준본
        if ddl(body) != ASIS.read_text(encoding="utf-8"):
            sys.exit("[FRESH-GATE 실패] 착수 후 DB 원문 변경 — 중단 (--patch 재실행 후 재검토)")
        print("[FRESH-GATE] PASS")
        cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 60")
        cur.execute(tobe_sql.rstrip().rstrip("/").rstrip())
        errs = verify(cur)
        after, _, _, _ = fetch(cur)
        same = ddl(after) == tobe_sql
        print("  적용본 == DB 원문 : %s" % same)
        print("  마커 라인 수 = %d (기대 %d)" % (after.count(MARK), EXPECT))
    return 1 if errs or not same else 0


def cmd_rollback():
    with connect() as con:
        cur = con.cursor()
        body, _, _, _ = fetch(cur)
        # FRESH-GATE: 현재 원문 == 내가 적용한 TOBE 일 때만 원복 (타 작업자 변경 보호)
        if ddl(body) != strip_stamp(TOBE.read_text(encoding="utf-8")):
            sys.exit("[FRESH-GATE 실패] 현재 DB 원문 ≠ TOBE — 원복 중단")
        cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 60")
        cur.execute(ASIS.read_text(encoding="utf-8").rstrip().rstrip("/").rstrip())
        return 1 if verify(cur) else 0


if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    g = ap.add_mutually_exclusive_group(required=True)
    g.add_argument("--patch", action="store_true")
    g.add_argument("--deploy", action="store_true")
    g.add_argument("--rollback", action="store_true")
    a = ap.parse_args()
    if a.patch:
        cmd_patch()
    elif a.deploy:
        sys.exit(cmd_deploy())
    else:
        sys.exit(cmd_rollback())
