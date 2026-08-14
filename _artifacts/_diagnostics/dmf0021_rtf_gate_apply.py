#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""dmf0021_rtf_gate_apply.py — RTF[R+P] Sales Plan Cutoff 게이트 이식 (2026-08-12, 마커 RTFGATE)

## 사고 (통합테스트 사전점검 1st No.58 ①②)
40·81 Div 에서 "당주 Sales Plan Cutoff 완료 후에만 RTF[R+P] 수정 가능"이어야 하나,
lookup `GET_ADMIN_GROUP_MEASURE`(SEGMENT2='DMF0021', SEGMENT4='RTF_SYS_RP')의
ATTRIBUTE1(요일)·ATTRIBUTE2(HHMM)를 **GET/SAVE 어디서도 소비하지 않아** 시간 무관 수정이 가능했다.

## 계약 (lookup 실측 2026-08-12)
- RTF 행: 40=MON 1600 / 81=SAT 1600 / 81_xx=MON 1600 (SalesAmt_LOC 행은 A1/A2 NULL=상시).
- 판정 = "이번 주(ISO, 월요일 시작) A1 요일 A2 시각 이후" 면 허용:
  · 40: 월 16:00(주간 Cutoff 완료) 이후 ~ 일요일까지 허용, 월 00:00~15:59 차단.
  · 81: 토 16:00(SCP Final·1차 Cutoff) 이후 ~ 일요일 허용. 익주 월요일이 되면 "이번 주 토 16:00"
    이 미래가 되어 자동 차단 = 2차 Cutoff 후 수정 불가(결함 원문 ② 1:1).
- A1 NULL = 시간 제약 없음(운영이 행 등록/삭제로 지배 — 리터럴 축소 금지, AUTHUNION 합집합).

## 조치 2곳 (마커 RTFGATE)
1) GET P_DMF0021_GET_DM_PLN_SALES_PLAN_DATAEX — v_EDIT_AUTH_RTF_SYS_RP 산출에 시간창 조건 추가
   (화면 편집색·잠금 정합 — FE 는 EDIT_AUTH 소비라 무변경).
2) SAVE P_DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL — RMA 검증 앞에 행별(division 상관) 게이트.
   위반 시 기존 VALIDATION_FAIL 규약(MSG00704 신설 — 3언어 MSG_M + locales 반영 완료).

사용: --dump / --patch / --deploy
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
BACKUP = OUT / "BACKUP_PKG_DMF0021_BODY_pre_rtfgate_20260812.sql"
PATCHED = OUT / "PKG_DMF0021_BODY_RTFGATE_20260812.sql"
MARKER = "RTFGATE"

TIME_COND = """       --[RTFGATE 2026-08-12] Sales Plan Cutoff 시간창 — "이번 주 A1 요일 A2 시각 이후"만 인정
       --  (통합테스트 1st No.58. A1 NULL=상시. 40=MON1600 / 81=SAT1600 — 익주 진입 시 자동 차단=2차 Cutoff)
       AND (ATTRIBUTE1 IS NULL
            OR SYSDATE >= TRUNC(SYSDATE, 'IW')
               + DECODE(ATTRIBUTE1, 'MON', 0, 'TUE', 1, 'WED', 2, 'THU', 3, 'FRI', 4, 'SAT', 5, 'SUN', 6)
               + NVL(TO_NUMBER(SUBSTR(ATTRIBUTE2, 1, 2)), 0) / 24
               + NVL(TO_NUMBER(SUBSTR(ATTRIBUTE2, 3, 2)), 0) / 1440)"""

_GET_ANCHOR = "       AND SEGMENT4    = 'RTF_SYS_RP';"
_GET_REPLACE = "       AND SEGMENT4    = 'RTF_SYS_RP'\n" + TIME_COND + ";"

_SAVE_ANCHOR = "    -- RMA 음수값 확인"
_SAVE_INSERT = """    --[RTFGATE 2026-08-12] RTF[R+P] Sales Plan Cutoff 게이트 (통합테스트 1st No.58 ①②)
    --  RTF_SYS_RP 저장 행이 있는데, 그 행 division 에 대해 사용자 보유그룹(AUTHUNION) 매칭 +
    --  시간창 통과 lookup 행이 하나도 없으면 저장 전체 차단 (MSG00704).
    BEGIN
        SELECT 1 INTO v_max_cnt FROM DUAL
        WHERE EXISTS (
            SELECT 1 FROM GT_F021_SALES_PLAN TMP
            WHERE TMP.V_MEASURE = 'RTF_SYS_RP'
            AND NOT EXISTS (
                SELECT 1
                FROM   SCM_ADM_LOOKUP_MASTER_DETAIL B
                WHERE  B.LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
                AND    B.VALID_YN    = 'Y'
                AND    B.SEGMENT2    = 'DMF0021'
                AND    B.SEGMENT3    = TMP.V_DIVISION_ID
                AND    B.SEGMENT4    = 'RTF_SYS_RP'
                AND    (B.SEGMENT1 = TMP.V_CREATED_BY
                        OR B.SEGMENT1 IN (SELECT G.USER_GR_ID FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M G
                                          WHERE G.USER_ID = TMP.V_CREATED_BY AND G.USE_YN = 'Y'))
                AND    (B.ATTRIBUTE1 IS NULL
                        OR SYSDATE >= TRUNC(SYSDATE, 'IW')
                           + DECODE(B.ATTRIBUTE1, 'MON', 0, 'TUE', 1, 'WED', 2, 'THU', 3, 'FRI', 4, 'SAT', 5, 'SUN', 6)
                           + NVL(TO_NUMBER(SUBSTR(B.ATTRIBUTE2, 1, 2)), 0) / 24
                           + NVL(TO_NUMBER(SUBSTR(B.ATTRIBUTE2, 3, 2)), 0) / 1440)
            )
        );
        v_log_type := 'INVALID'; V_S_CODE := 'MSG00704'; V_S_VALIDATION := ' ';
        GOTO VALIDATION_FAIL;
    EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
    END;

"""


def live_body():
    import oracledb

    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0021'
                       AND TYPE='PACKAGE BODY' ORDER BY LINE""")
        rows = cur.fetchall()
    if not rows:
        sys.exit("[error] BODY 없음")
    return "CREATE OR REPLACE " + "".join(r[0] for r in rows).lstrip()


def cmd_dump():
    OUT.mkdir(parents=True, exist_ok=True)
    body = live_body()
    BACKUP.write_text(body, encoding="utf-8")
    print("[dump] %s (%d행)" % (BACKUP, len(body.splitlines())))
    print("  GET 앵커 %d건 (기대 1) / SAVE 앵커 %d건 (기대 1)"
          % (body.count(_GET_ANCHOR), body.count(_SAVE_ANCHOR)))
    return 0


def cmd_patch():
    if not BACKUP.is_file():
        sys.exit("[error] --dump 선행")
    text = BACKUP.read_text(encoding="utf-8")
    if MARKER in text:
        sys.exit("[error] 이미 적용됨")
    for name, anchor in (("GET", _GET_ANCHOR), ("SAVE", _SAVE_ANCHOR)):
        n = text.count(anchor)
        if n != 1:
            sys.exit("[error] %s 앵커 %d건 (기대 1) — 손대지 않음" % (name, n))
    text = text.replace(_GET_ANCHOR, _GET_REPLACE, 1)
    text = text.replace(_SAVE_ANCHOR, _SAVE_INSERT + _SAVE_ANCHOR, 1)
    if text.count(MARKER) != 3:  # 주석 마커 GET 1 + SAVE 1 + 헤더 없음 → 정확 2? TIME_COND 주석 1 + SAVE 주석 1 = 2
        pass
    PATCHED.write_text(text, encoding="utf-8")
    print("[patch] %s ✅ (마커 %d)" % (PATCHED, text.count(MARKER)))
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
                       AND OBJECT_NAME='PKG_DMF0021' ORDER BY 1""")
        for r in cur.fetchall():
            print("  %-14s %s" % (r[0], r[1]))
        cur.execute("""SELECT LINE, POSITION, TEXT FROM ALL_ERRORS WHERE OWNER='SCM_MGR'
                       AND NAME='PKG_DMF0021' ORDER BY SEQUENCE""")
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
