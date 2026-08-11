#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""dmf0082_team_filter_fix.py — 조회조건 Team(deptId) 필터 무시 결함 정정 (2026-08-11, 마커 TEAMFILTER)

## 사고 (통합테스트 1st No.37 + 이번 실측 N-1)
문서(8/6): "Team 선택(IM1팀) 재조회 시 SQL 에러". SQL 에러는 조회조건 3 IN append(08-07)로 해소됐으나,
2026-08-11 HTTP 실측에서 **deptId 값을 보내도 전 팀 17,495행이 그대로** 반환됨을 확인.

## 원인 (실측)
`P_DMF0082_GET_MAIN_DATA` 의 `p_team_id` 는 **JSON 로그(L210)에만 쓰이고 필터 지점이 없다**
(L7725 의 팀 필터는 다른 프로시저). PROC_M 배선(deptId→IN 2)은 정상 — SP 가 버리는 구조.

## 조치
PLANT_SITE(2026-08-04)·PROJECT/OWNER(08-07) 와 **동형** — 스테이징 완료 후 GTT 단일 지점 DELETE.
컬럼 = GT_DMF0082_TEMP_FCST_N_PRICE.DEPT_ID (콤마 다중 = UF_FX_String_SplitForIN).
삽입 위치 = Sender Code 필터 END IF 직후(앵커 유일성 검증). GET 만 수정(CURRENT 는 FE 미사용 aux).

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
BACKUP = OUT / "BACKUP_PKG_DMF0082_BODY_pre_teamfilter_20260811.sql"
PATCHED = OUT / "PKG_DMF0082_BODY_TEAMFILTER_20260811.sql"
MARKER = "TEAMFILTER"

_ANCHOR = (
    "        AND    SENDER_CODE NOT IN (\n"
    "                   SELECT COLUMN_VALUE\n"
    "                   FROM   TABLE(UF_FX_String_SplitForIN(p_sender_code, ',')));\n"
    "    END IF;\n"
)
_INSERT = (
    "\n"
    "    -- ====================================================================================================\n"
    "    -- [TEAMFILTER 2026-08-11] 조회조건 Team(deptId) 필터 — 통합테스트 1st No.37 (+실측 N-1)\n"
    "    --   p_team_id 가 로그에만 쓰이고 필터 지점이 없어 팀 지정이 무시되던 결함. PLANT_SITE 동형.\n"
    "    -- ====================================================================================================\n"
    "\n"
    "    IF p_team_id IS NOT NULL AND p_team_id <> 'ALL' THEN\n"
    "        DELETE FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE\n"
    "        WHERE  NVL(DEPT_ID, ' ') NOT IN (\n"
    "                   SELECT COLUMN_VALUE\n"
    "                   FROM   TABLE(UF_FX_String_SplitForIN(p_team_id, ',')));\n"
    "    END IF;\n"
)


def live_body():
    import oracledb

    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082'
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
    # GTT 에 DEPT_ID 실재 확인
    import oracledb
    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute("""SELECT COUNT(*) FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR'
                       AND TABLE_NAME='GT_DMF0082_TEMP_FCST_N_PRICE' AND COLUMN_NAME='DEPT_ID'""")
        print("  GT_DMF0082_TEMP_FCST_N_PRICE.DEPT_ID 실재: %s" % (cur.fetchone()[0] == 1))
    return 0


def cmd_patch():
    if not BACKUP.is_file():
        sys.exit("[error] --dump 선행")
    text = BACKUP.read_text(encoding="utf-8")
    if MARKER in text:
        sys.exit("[error] 이미 적용됨")
    n = text.count(_ANCHOR)
    # 앵커 2곳 실측(2026-08-11): #1=GET(GT_DMF0082_TEMP_FCST_N_PRICE — **팀 필터 부재 = 결함**)
    #   #2=CURRENT(GTT_MF_SP — L7725 에 인라인 팀 필터 **기존재** → 수정 금지).
    #   ⇒ **첫 번째 앵커에만** 삽입한다.
    if n != 2:
        sys.exit("[error] 앵커 %d건 (기대 2: GET+CURRENT) — 구조 변동, 손대지 않음" % n)
    text = text.replace(_ANCHOR, _ANCHOR + _INSERT, 1)
    if text.count(MARKER) != 1:
        sys.exit("[error] 삽입 결과 마커 %d (기대 1)" % text.count(MARKER))
    PATCHED.write_text(text, encoding="utf-8")
    print("[patch] %s ✅ (GET 1곳만 — CURRENT 는 인라인 필터 기존재)" % PATCHED)
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
                       AND OBJECT_NAME='PKG_DMF0082' ORDER BY 1""")
        for r in cur.fetchall():
            print("  %-14s %s" % (r[0], r[1]))
        cur.execute("""SELECT LINE, POSITION, TEXT FROM ALL_ERRORS WHERE OWNER='SCM_MGR'
                       AND NAME='PKG_DMF0082' ORDER BY SEQUENCE""")
        errs = cur.fetchall()
        for e in errs:
            print("  ⛔ L%s:%s %s" % e)
    return 1 if errs else 0


def cmd_verify():
    """HTTP FE 동일 경로 — Team 1건 지정 시 행수 감소 + 전행 해당 팀."""
    import requests

    base, user = "http://localhost:8080", "minyonglee1"
    s = requests.Session()
    s.post(f"{base}/user/login", json={"userId": user}, timeout=30)

    def search(extra):
        f = {"divisionId": "40", "deptId": "ALL", "endCustomer": "ALL", "bizType": "ALL",
             "fromYyyymmdd": "20260801", "toYyyymmdd": "20270201", "salesSite": "ALL",
             "itemId": "", "versionType": "Current", "qtyYn": "N",
             "sesUserId": user, "userGroup": user,
             "plantSiteId": "ALL", "projectCode": "ALL", "owner": "ALL", "senderCode": "ALL"}
        f.update(extra)
        r = s.post(f"{base}/DMF0082/FcstNPrice/SEARCH/call-proc", json=f, timeout=300)
        return (r.json().get("result") or {}).get("fcstNPrice") or []

    base_rows = search({})
    teams = sorted({str(x.get("TEAM_ID")) for x in base_rows if x.get("TEAM_ID")})
    print("  기준 %d행 / 팀 %d종" % (len(base_rows), len(teams)))
    t0 = teams[0]
    r1 = search({"deptId": t0})
    ok = len(r1) < len(base_rows) and all(str(x.get("TEAM_ID")) == t0 for x in r1)
    print("  Team=%s → %d행 / 전행 해당 팀=%s  %s"
          % (t0, len(r1), all(str(x.get("TEAM_ID")) == t0 for x in r1), "PASS" if ok else "FAIL"))
    r2 = search({"deptId": ",".join(teams[:2])})
    got = {str(x.get("TEAM_ID")) for x in r2}
    ok2 = got <= set(teams[:2]) and len(r2) > 0
    print("  Team 2건 콤마 → %d행 / 집합=%s  %s" % (len(r2), sorted(got), "PASS" if ok2 else "FAIL"))
    return 0 if (ok and ok2) else 1


def main():
    ap = argparse.ArgumentParser()
    for f in ("dump", "patch", "deploy", "verify"):
        ap.add_argument("--" + f, action="store_true")
    a = ap.parse_args()
    for f in ("dump", "patch", "deploy", "verify"):
        if getattr(a, f):
            sys.exit(globals()["cmd_" + f]())
    ap.error("--dump/--patch/--deploy/--verify 필요")


if __name__ == "__main__":
    main()
