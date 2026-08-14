#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""dmf0003_save_authgate_apply.py — SAVE 권한·시간창 게이트 이식 (2026-08-12, 마커 AUTHGATE)

## 사고 (실 CRUD 권한 테스트에서 적출)
SCP Planner(coeogus, 82) 로 SAVE call-proc 직접 호출 시 **서버가 통과**시켜 원장이 갱신됐다.
FE(scpEditBlocked)·버튼 권한만 차단하고, AS-IS `dbo.DMF0003_SAVE_MKT_FCST` L690~779 의
**SP 내 권한·시간창 게이트가 미이식**(TO-BE P_AUTHORITY 는 선언만 — 주석 "이식 예정 2026-07-20").

## AS-IS 계약 (L690~779, E20260604-000994)
- `GET_ADMIN_GROUP_MEASURE` lookup (S1=권한, S2='DMF0003', S3=division,
  ATTRIBUTE1=요일('ALL'|DAYOFWEEK), ATTRIBUTE2~3=허용 HHMM 구간, ATTRIBUTE4=LIMIT_AUTH).
- SCP Planner: 현재 요일·시각 매칭 행 **0건 → 차단** ("수정 가능한 시간이 아닙니다") — lookup 미등록=전면 차단(보수).
- 비SCP: 본인 권한 행의 LIMIT_AUTH 그룹 시간창이 **현재와 매칭되면 차단** (조립 메시지).

## 조치
프롤로그(시작 LOG 직후, unfold 루프 전)에 P_DIVISION_ID 첫 토큰으로 1회 게이트.
오류 규약 = 기존 ERR_RTN 경로(V_LOG_TYPE 'INVALID' + V_DESCRIPTION + V_INVALID + GOTO).

사용: --dump / --patch / --deploy / --verify
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
BACKUP = OUT / "BACKUP_PKG_DMF0003_BODY_pre_authgate_20260812.sql"
PATCHED = OUT / "PKG_DMF0003_BODY_AUTHGATE_20260812.sql"
MARKER = "AUTHGATE"

_ANCHOR = (
    "    V_LOG_MESSAGE := NULL; /*-- <- 변수 재사용을 위하여 초기화해야함 --*/\n"
    "    V_CREATED_BY  := NULL;\n"
    "    -- 시작 LOG (END)\n"
)
_INSERT = """
    -- ====================================================================================================
    -- [AUTHGATE 2026-08-12] 저장 권한·시간창 게이트 — AS-IS dbo.DMF0003_SAVE_MKT_FCST L690~779 1:1
    --   (E20260604-000994). 미이식 상태에서 SCP Planner 가 SAVE 를 서버 통과하던 결함(실 CRUD 실측)을 정정.
    --   lookup = GET_ADMIN_GROUP_MEASURE (S2='DMF0003', S3=division, A1=요일('ALL'|DAYOFWEEK),
    --   A2~A3=허용 HHMM 구간). SCP=매칭 0건이면 차단(미등록=전면 차단, AS-IS 보수 동작).
    -- ====================================================================================================
    DECLARE
        AG_DIVISION_ID  VARCHAR2(100);
        AG_CNT          PLS_INTEGER := 0;
        AG_EDIT_DAYS    VARCHAR2(100);
        AG_FROM_TIME    VARCHAR2(100);
        AG_TO_TIME      VARCHAR2(100);
        AG_LIMIT_AUTH   VARCHAR2(100);
    BEGIN
        AG_DIVISION_ID := CASE WHEN INSTR(P_DIVISION_ID, '^') > 0
                               THEN SUBSTR(P_DIVISION_ID, 1, INSTR(P_DIVISION_ID, '^') - 1)
                               ELSE P_DIVISION_ID END;

        IF P_AUTHORITY = 'SCP Planner' THEN
            SELECT COUNT(*) INTO AG_CNT
            FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B
            WHERE  B.LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
              AND  B.VALID_YN    = 'Y'
              AND  B.SEGMENT2    = 'DMF0003'
              AND  B.SEGMENT3    = AG_DIVISION_ID
              AND  B.SEGMENT1    = 'SCP Planner'
              AND  (B.ATTRIBUTE1 = 'ALL' OR B.ATTRIBUTE1 IN (
                       SELECT C.DAYOFWEEK FROM SCM_MGR.SCM_SYS_CALENDAR_M C
                       WHERE  C.BASIS_YYYYMMDD = TO_CHAR(SYSDATE, 'YYYYMMDD')))
              AND  TO_NUMBER(TO_CHAR(SYSDATE, 'HH24MI'))
                       BETWEEN TO_NUMBER(B.ATTRIBUTE2) AND TO_NUMBER(B.ATTRIBUTE3);
            IF AG_CNT = 0 THEN
                V_LOG_TYPE    := 'INVALID';
                V_DESCRIPTION := 'SCP Planner 권한사용자의 수정 가능한 시간이 아닙니다.';
                V_INVALID     := TRUE;
                GOTO ERR_RTN;
            END IF;
        ELSIF P_AUTHORITY IS NOT NULL THEN
            SELECT COUNT(*)
                 , MAX(D.ATTRIBUTE1)
                 , MAX(SUBSTR(D.ATTRIBUTE2, 1, 2) || ':' || SUBSTR(D.ATTRIBUTE2, 3, 2))
                 , MAX(SUBSTR(D.ATTRIBUTE3, 1, 2) || ':' || SUBSTR(D.ATTRIBUTE3, 3, 2))
                 , MAX(D.SEGMENT1)
              INTO AG_CNT, AG_EDIT_DAYS, AG_FROM_TIME, AG_TO_TIME, AG_LIMIT_AUTH
            FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL D
            WHERE  D.LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
              AND  D.VALID_YN    = 'Y'
              AND  D.SEGMENT2    = 'DMF0003'
              AND  D.SEGMENT3    = AG_DIVISION_ID
              AND  D.SEGMENT1 IN (
                       SELECT B.ATTRIBUTE4
                       FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B
                       WHERE  B.LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
                         AND  B.VALID_YN    = 'Y'
                         AND  B.SEGMENT2    = 'DMF0003'
                         AND  B.SEGMENT3    = AG_DIVISION_ID
                         AND  B.SEGMENT1    = P_AUTHORITY)
              AND  (D.ATTRIBUTE1 = 'ALL' OR D.ATTRIBUTE1 IN (
                       SELECT C.DAYOFWEEK FROM SCM_MGR.SCM_SYS_CALENDAR_M C
                       WHERE  C.BASIS_YYYYMMDD = TO_CHAR(SYSDATE, 'YYYYMMDD')))
              AND  TO_NUMBER(TO_CHAR(SYSDATE, 'HH24MI'))
                       BETWEEN TO_NUMBER(D.ATTRIBUTE2) AND TO_NUMBER(D.ATTRIBUTE3);
            IF AG_CNT > 0 THEN
                V_LOG_TYPE    := 'INVALID';
                V_DESCRIPTION := AG_LIMIT_AUTH || ' 권한 사용자가 ' || AG_EDIT_DAYS || ' '
                                 || AG_FROM_TIME || ' 부터 ' || AG_TO_TIME
                                 || ' 까지 수정하는 시간입니다. ' || P_AUTHORITY
                                 || ' 권한 사용자는 해당 시간에 수정이 불가합니다.';
                V_INVALID     := TRUE;
                GOTO ERR_RTN;
            END IF;
        END IF;
    END;
"""


def live_body():
    import oracledb

    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0003'
                       AND TYPE='PACKAGE BODY' ORDER BY LINE""")
        rows = cur.fetchall()
    if not rows:
        sys.exit("[error] BODY 없음")
    return "CREATE OR REPLACE " + "".join(r[0] for r in rows).lstrip()


def cmd_dump():
    OUT.mkdir(parents=True, exist_ok=True)
    body = live_body()
    BACKUP.write_text(body, encoding="utf-8")
    print("[dump] %s (%d행) / 앵커 %d건 (기대 1)" % (BACKUP, len(body.splitlines()), body.count(_ANCHOR)))
    return 0


def cmd_patch():
    if not BACKUP.is_file():
        sys.exit("[error] --dump 선행")
    text = BACKUP.read_text(encoding="utf-8")
    if MARKER in text:
        sys.exit("[error] 이미 적용됨")
    n = text.count(_ANCHOR)
    if n != 1:
        sys.exit("[error] 앵커 %d건 (기대 1) — 손대지 않음" % n)
    text = text.replace(_ANCHOR, _ANCHOR + _INSERT, 1)
    if text.count(MARKER) != 1:
        sys.exit("[error] 삽입 결과 마커 %d (기대 1)" % text.count(MARKER))
    PATCHED.write_text(text, encoding="utf-8")
    print("[patch] %s ✅" % PATCHED)
    return 0


def cmd_deploy():
    import oracledb

    sql = PATCHED.read_text(encoding="utf-8").rstrip().rstrip("/").rstrip()
    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 60")
        cur.execute(sql)
        cur.execute("""SELECT OBJECT_TYPE, STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR'
                       AND OBJECT_NAME='PKG_DMF0003' ORDER BY 1""")
        for r in cur.fetchall():
            print("  %-14s %s" % (r[0], r[1]))
        cur.execute("""SELECT LINE, POSITION, TEXT FROM ALL_ERRORS WHERE OWNER='SCM_MGR'
                       AND NAME='PKG_DMF0003' ORDER BY SEQUENCE""")
        errs = cur.fetchall()
        for e in errs:
            print("  ⛔ L%s:%s %s" % e)
    return 1 if errs else 0


def main():
    ap = argparse.ArgumentParser()
    for f in ("dump", "patch", "deploy"):
        ap.add_argument("--" + f, action="store_true")
    a = ap.parse_args()
    for f in ("dump", "patch", "deploy"):
        if getattr(a, f):
            sys.exit(globals()["cmd_" + f]())
    ap.error("--dump/--patch/--deploy 필요")


if __name__ == "__main__":
    main()
