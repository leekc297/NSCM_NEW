#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""_patch_dmf0074_mrf_comment_20260818.py — DMF0074 Template MRF 필터 AS-IS 파리티 복원

배경: AS-IS 변환 원본(To-be_v2_converted/06_Packages/04_Package_PKG_DMF0074.sql:688)에서
      TEMPLATE 쪽 `--AND NVL(ATTRIBUTE7,'') = 'Y'` 는 **주석**이다. 그런데 사내 배포본은
      2026-06-01 ~ 07-10 사이에 이 줄이 **활성화**되어 있었다(들여쓰기 14칸 = 후삽입 흔적).
      금주 SP_W 버전은 전 division ATTRIBUTE7=NULL 이라, 활성 상태에서는 과거 MRF='Y' 버전으로
      밀려나 81/82 는 원장 0행 → 템플릿 0건 → MSG00656 안내가 뜬다(사용자 신고 2026-08-18).
      형제 화면 PKG_DMF0020(L2697)·DMF0020_GET_SALES_PRICE_TEMPLATE(L66)은 지금도 주석 상태다.

조치: TEMPLATE 쪽 1줄만 주석 처리(AS-IS 동일). **UPLOAD 쪽(GT_DM74_TEMP_VERSION_NO 적재)은
      변환 원본에서도 활성이므로 그대로 둔다.**
"""
import os
import sys
import time

import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")

BACKUP = os.path.join(HERE, "BACKUP_PKG_DMF0074_BODY_pre_mrfcomment_20260818.sql")
PATCHED = os.path.join(HERE, "PKG_DMF0074_BODY_MRFCOMMENT_20260818.sql")

# ⚠ 들여쓰기 14칸 = TEMPLATE 쪽 유일 (UPLOAD 쪽은 12칸) — 오치환 방지
OLD = """            AND    VERSION_TYPE = 'SP_W'
              AND    NVL(ATTRIBUTE7, 'N') = 'Y'
"""

NEW = """            AND    VERSION_TYPE = 'SP_W'
            --[MRFPARITY 2026-08-18] AS-IS 파리티 복원 — 변환 원본에서 이 줄은 **주석**이다
            --  (To-be_v2_converted/06_Packages/04_Package_PKG_DMF0074.sql:688 `--AND NVL(ATTRIBUTE7,'') = 'Y'`).
            --  활성화하면 금주 SP_W 는 전 division ATTRIBUTE7=NULL 이라 과거 MRF='Y' 버전으로 밀리고,
            --  81/82 는 그 버전의 원장이 0행이라 템플릿 0건 → MSG00656 안내가 뜬다(사용자 신고).
            --  형제 화면 PKG_DMF0020 L2697 도 동일하게 주석 유지. UPLOAD 쪽 적재 조건은 원본대로 활성 유지.
            --AND    NVL(ATTRIBUTE7, 'N') = 'Y'
"""


def connect(retries=10, wait=10):
    import ora

    u, p, d = ora.conn_info()
    last = None
    for _ in range(retries):
        try:
            return oracledb.connect(user=u, password=p, dsn=d)
        except Exception as e:  # noqa: BLE001
            last = e
            time.sleep(wait)
    raise SystemExit(f"접속 실패: {last}")


def main():
    con = connect()
    cur = con.cursor()

    # 1) 배포본 실측 덤프 = 백업 겸 패치 기준선
    cur.execute(
        """SELECT TEXT FROM ALL_SOURCE
            WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0074' AND TYPE='PACKAGE BODY'
            ORDER BY LINE"""
    )
    body = "".join(r[0] for r in cur.fetchall())
    with open(BACKUP, "w", encoding="utf-8", newline="") as f:
        f.write("CREATE OR REPLACE " + body.rstrip() + "\n/\n")
    print(f"[1] 백업 = {BACKUP} ({len(body.splitlines())} lines)")

    # 2) 치환 — 정확히 1회
    src = "CREATE OR REPLACE " + body.rstrip() + "\n"
    cnt = src.count(OLD)
    if cnt != 1:
        raise SystemExit(f"[중단] 기준선 불일치 — TEMPLATE 블록 {cnt}회 (1이어야 함)")
    src = src.replace(OLD, NEW)
    # UPLOAD 쪽(12칸)은 그대로 남아 있어야 한다
    remain = src.count("            AND    NVL(ATTRIBUTE7, 'N') = 'Y'\n")
    print(f"[2] 치환 완료 — UPLOAD 쪽 활성 조건 잔존 {remain}건 (1이어야 정상)")
    if remain != 1:
        raise SystemExit("[중단] UPLOAD 쪽 조건이 함께 바뀌었다")
    with open(PATCHED, "w", encoding="utf-8", newline="") as f:
        f.write(src)
    print(f"    패치본 = {PATCHED}")

    # 3) 배포
    cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 120")
    ddl = src.rstrip()
    cur.execute(ddl)
    print("[3] 재배포 실행 완료")

    # 4) 검증 — 대상 객체 실측 (#136)
    for title, sql in [
        ("상태", """SELECT OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL
                      FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0074' ORDER BY 1"""),
        ("컴파일 오류", """SELECT LINE, POSITION, SUBSTR(TEXT,1,110) TXT FROM ALL_ERRORS
                            WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0074' ORDER BY SEQUENCE"""),
        ("ATTRIBUTE7 조건 현황 (주석/활성)", """SELECT LINE, RTRIM(SUBSTR(TEXT,1,80)) SRC FROM ALL_SOURCE
                            WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0074' AND TYPE='PACKAGE BODY'
                              AND TEXT LIKE '%NVL(ATTRIBUTE7%' ORDER BY LINE"""),
    ]:
        print(f"\n{'=' * 95}\n[검증] {title}\n{'=' * 95}")
        cur.execute(sql)
        cols = [c[0] for c in cur.description]
        rows = cur.fetchall()
        print(" | ".join(cols))
        print("-" * 95)
        for r in rows:
            print(" | ".join("" if v is None else str(v) for v in r))
        print(f"({len(rows)} rows)")

    cur.close()
    con.close()


if __name__ == "__main__":
    main()
