#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""DMF0082 40 division — **사용자 UI 실행 파라미터 그대로** 재현 + 계측.

파라미터 출처: `SCM_SYS_LOG_BATCH.IN_PARA_DATA` 2026-08-15 03:51:32 (사용자 실행분 실측).
  {"p_division_id":"40","p_team_id":"ALL","p_customer":"ALL","p_biz_type":"ALL",
   "p_from_yyyymmdd":"20260801","p_to_yyyymmdd":"20270131","p_scm_site_id":"ALL",
   "p_item_id":null,"p_version_type":"Current","p_qty_yn":"N",
   "p_created_by":"minyonglee1","p_user_group":"ADMIN",
   "p_plant_site_id":"ALL","p_project_code":"ALL","p_owner":"ALL","p_sender_code":"ALL"}

⚠ 앞선 재현 실패 2건의 원인(기록):
   · 1차: p_item_id 를 'ALL' 로 넣음 (실제는 **NULL**)
   · 2차: 필터를 '' 로, user_group 을 userId 로 넣음 (실제는 **'ALL'** / **'ADMIN'**)
   ⇒ FE 스토어 코드만 보고 추정하면 틀린다. **SP 입력 로그가 정본**이다.
"""
import io, sys, time, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
from ora import conn_info
import oracledb

A = 'ALL'
PARAMS = ['40', A, A, A, '20260801', '20270131', A, None,
          'Current', 'N', 'minyonglee1', 'ADMIN', A, A, A, A]

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("BEGIN DBMS_APPLICATION_INFO.SET_MODULE('DMF0082REPRO','GET'); END;")
cur.execute("SELECT SYS_CONTEXT('USERENV','SID') FROM DUAL")
sid = cur.fetchone()[0]
print(f"[session] SID={sid}  (ASH 귀속용)")

rcs = [con.cursor() for _ in range(5)]
rr = con.cursor()
t0 = time.time()
cur.callproc("SCM_MGR.PKG_DMF0082.P_DMF0082_GET_MAIN_DATA", PARAMS + rcs + [rr])
t_sp = time.time() - t0
t1 = time.time()
cnt = [len(c.fetchall()) for c in rcs]
t_fetch = time.time() - t1
print(f"\n[SP]    {t_sp:8.2f}s")
print(f"[fetch] {t_fetch:8.2f}s")
print(f"[합계]  {t_sp + t_fetch:8.2f}s")
print(f"[결과]  fcstNPrice={cnt[0]}행  drop1~4={cnt[1:]}")

# 같은 세션 GTT 잔량 — 어느 단계까지 채워졌나
cur.execute("""SELECT TABLE_NAME FROM ALL_TABLES WHERE OWNER='SCM_MGR'
               AND TEMPORARY='Y' AND TABLE_NAME LIKE 'GT_DMF0082%' ORDER BY 1""")
print("\n=== GTT 잔량 (0행 아닌 것) ===")
for (t,) in cur.fetchall():
    cur.execute(f"SELECT COUNT(*) FROM {t}")
    n = cur.fetchone()[0]
    if n:
        print(f"   {t:<50}{n:>9,}")
con.close()
