#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""_patch_dmf0082_upload_batch_20260818.py — DMF0082 Excel Upload 2-Step NOT_SAVABLE 정정

증상: [Upload] 후 [OK] 클릭 시 `NOT_SAVABLE (SUCCESS=0, ERROR=0)` (사용자 신고 2026-08-18.
      실측: 18:36:55 배치 = @TITLE 1 + SUCCESS 14행 — 검증·분류는 정상 완료돼 있었다).
원인: 배치 유도가 `UPLOAD_STATUS_CODE = 'UPLOAD'` 로 고정 — [Upload](P_MODE=0)가 분류하며
      상태를 SUCCESS/ERROR 로 바꾸므로 [OK](P_MODE=1) 시점엔 'UPLOAD' 행이 없어
      v_creation_date = NULL → 카운트 스코프 무매칭 → SUCCESS=0/ERROR=0 → NOT_SAVABLE.
정정: 정본 DMF0074(2-Step 26케이스 검증 완료) 패턴 이식 — 유도는 **상태 무관 최신 배치**
      (PKG_DMF0074 L978~983 에는 상태 필터가 없다).
      P_MODE=0 은 BE 가 매번 새 CREATION_DATE 로 INSERT('UPLOAD')하므로 동작 불변,
      P_MODE=1 은 분류 완료(SUCCESS/ERROR) 배치를 정상 인식하게 된다.
"""
import sys
import time

import oracledb

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")

SRC = r"C:\Projects\NSCM\_artifacts\_apply_corporate\PKG_DMF0082_BODY_deployed_20260818.sql"
OUT = r"C:\Projects\NSCM\_artifacts\_apply_corporate\PKG_DMF0082_BODY_UPLOADBATCH_20260818.sql"

OLD = """    SELECT TO_CHAR(MAX(T.CREATION_DATE), 'YYYY-MM-DD HH24:MI:SS.FF3')
    INTO   v_creation_date
    FROM   SCM_MGR.SCM_ADM_EXCEL_UPLOAD T
    WHERE  T.PROGRAM_ID = v_program_id
    AND    T.SHEET_NAME = v_sheet_name
    AND    T.CREATED_BY = p_created_by
    AND    T.UPLOAD_STATUS_CODE = 'UPLOAD';
"""

NEW = """    --[E20260818-UPLOADBATCH] 2-Step NOT_SAVABLE 정정 — 배치 유도에서 상태 필터 제거.
    --  구 조건 `AND T.UPLOAD_STATUS_CODE = 'UPLOAD'` 는 [Upload](P_MODE=0)가 분류하며 상태를
    --  SUCCESS/ERROR 로 바꾼 뒤의 [OK](P_MODE=1)에서 배치를 못 찾아(v_creation_date=NULL)
    --  카운트가 0/0 → NOT_SAVABLE 이 났다(2026-08-18 실사고 — 18:36 배치 SUCCESS 14행 실측).
    --  정본 = PKG_DMF0074 L978~983 (상태 무관 최신 배치. 2-Step 26케이스 검증 2026-08-16).
    SELECT TO_CHAR(MAX(T.CREATION_DATE), 'YYYY-MM-DD HH24:MI:SS.FF3')
    INTO   v_creation_date
    FROM   SCM_MGR.SCM_ADM_EXCEL_UPLOAD T
    WHERE  T.PROGRAM_ID = v_program_id
    AND    T.SHEET_NAME = v_sheet_name
    AND    T.CREATED_BY = p_created_by;
"""


def main():
    body = open(SRC, encoding="utf-8").read()
    cnt = body.count(OLD)
    if cnt != 1:
        raise SystemExit(f"[중단] 기준선 불일치 — 유도 블록 {cnt}회 (1이어야 함)")
    patched = body.replace(OLD, NEW)
    open(OUT, "w", encoding="utf-8", newline="").write(patched)
    print(f"[1] 패치본 생성 {OUT} (+{len(patched.splitlines()) - len(body.splitlines())}줄)")

    import ora

    u, p, d = ora.conn_info()
    con = None
    for _ in range(10):
        try:
            con = oracledb.connect(user=u, password=p, dsn=d)
            break
        except Exception:  # noqa: BLE001
            time.sleep(10)
    if con is None:
        raise SystemExit("접속 실패")
    cur = con.cursor()
    cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 120")
    ddl = patched.rstrip()
    if ddl.endswith("/"):
        ddl = ddl[:-1].rstrip()
    cur.execute(ddl)
    print("[2] 재배포 실행 완료")

    cur.execute(
        """SELECT OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS')
             FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0082' ORDER BY 1"""
    )
    for r in cur.fetchall():
        print("    ", " | ".join(str(v) for v in r))
    cur.execute(
        """SELECT COUNT(*) FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082'"""
    )
    print(f"    컴파일 오류 = {cur.fetchone()[0]} (0이어야 함)")
    cur.execute(
        """SELECT COUNT(*) FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082'
            AND TYPE='PACKAGE BODY' AND TEXT LIKE '%E20260818-UPLOADBATCH%'"""
    )
    print(f"    마커 = {cur.fetchone()[0]}")

    # 3) 실사고 배치로 유도·카운트 시뮬 (읽기 전용) — 정정 후 [OK] 가 무엇을 세게 되는지
    cur.execute(
        """SELECT TO_CHAR(MAX(T.CREATION_DATE),'YYYY-MM-DD HH24:MI:SS.FF3')
             FROM SCM_ADM_EXCEL_UPLOAD T
            WHERE T.PROGRAM_ID='DMF0082' AND T.SHEET_NAME='FcstNPrice'
              AND T.CREATED_BY='minyonglee1'"""
    )
    vcd = cur.fetchone()[0]
    print(f"[3] 유도 시뮬: v_creation_date = {vcd}")
    cur.execute(
        """SELECT COUNT(CASE WHEN UPLOAD_STATUS_CODE='SUCCESS' THEN 1 END),
                  COUNT(CASE WHEN UPLOAD_STATUS_CODE='ERROR' THEN 1 END)
             FROM SCM_ADM_EXCEL_UPLOAD
            WHERE PROGRAM_ID='DMF0082' AND SHEET_NAME='FcstNPrice' AND CREATED_BY='minyonglee1'
              AND TO_CHAR(CREATION_DATE,'YYYY-MM-DD HH24:MI:SS.FF3') = :v""",
        {"v": vcd},
    )
    s, e = cur.fetchone()
    print(f"    카운트 시뮬: SUCCESS={s} / ERROR={e} → {'SAVABLE (OK 진행 가능)' if s > 0 and e == 0 else '차단'}")
    cur.close()
    con.close()


if __name__ == "__main__":
    main()
