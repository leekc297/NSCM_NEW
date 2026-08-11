#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""_tmp_t_deploy_retry.py — TUNET2 배포 재시도 루프 (ORA-04021 대응)

패키지가 실행 중 세션에 pin 되어 있으면 `CREATE OR REPLACE` 가 ORA-04021 로 죽는다.
KILL 은 사용자만 하므로, **잠금이 풀리는 순간 자동으로 적용**되도록 대기·재시도한다.

- 배포 본문/단언은 dmf0044_matz2_apply.cmd_deploy 를 그대로 재사용 (검증 로직 중복 없음)
- 이미 적용돼 있으면(마커 존재) 재적용하지 않고 종료 (멱등)
- 시한(기본 25분) 초과 시 적용하지 않고 종료
"""
import pathlib
import sys
import time

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
import dmf0044_matz2_apply as T  # noqa: E402
from ora import conn_info  # noqa: E402

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

MAX_S = int(sys.argv[1]) if len(sys.argv) > 1 else 1500
STEP = 30


def already_applied():
    import oracledb

    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute("""SELECT NVL(SUM(REGEXP_COUNT(TEXT,'TUNE\\-M2 2026\\-08\\-10')),0) FROM ALL_SOURCE
                        WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' AND TYPE='PACKAGE BODY'""")
        return cur.fetchone()[0]


def main():
    t0 = time.time()
    n = 0
    while True:
        el = int(time.time() - t0)
        if already_applied():
            print("[+%4ds] 이미 적용됨 (TUNE-T2 존재) — 종료" % el)
            return 0
        n += 1
        print("[+%4ds] 시도 #%d ..." % (el, n), flush=True)
        try:
            rc = T.cmd_deploy()
            print("[+%4ds] 배포 성공 (rc=%d)" % (int(time.time() - t0), rc), flush=True)
            return rc
        except SystemExit as e:
            print("   중단: %s" % e, flush=True)
            return 1
        except Exception as e:
            msg = str(e)[:110]
            print("   실패: %s" % msg, flush=True)
            if "ORA-04021" not in msg and "ORA-04043" not in msg and "ORA-00054" not in msg:
                print("   잠금 외 오류 — 재시도 않고 종료", flush=True)
                return 1
        if time.time() - t0 >= MAX_S:
            print("[+%4ds] 시한 초과 — 미적용 상태로 종료" % int(time.time() - t0), flush=True)
            return 2
        time.sleep(STEP)


if __name__ == "__main__":
    sys.exit(main())

