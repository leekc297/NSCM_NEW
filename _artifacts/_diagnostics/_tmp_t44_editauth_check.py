#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""EDITFLAGSTD 적용 전 실측 3가지 (조회 전용)
   ① 현행 판정식 입력 V_GROUP_ID 가 이 사용자에게 무엇으로 채워지는가
   ② 표준 권한뷰 SCM_ADM_USER_MNU_EDIT_AUTH_V 가 이 사용자에게 'Y' 를 주는가
   ③ AS-IS 원문의 EDIT_FLAG 식은 무엇인가 (파리티 판정)
"""
import sys, pathlib, re
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info, fetch, show
import oracledb

USER, MNU, DIV = 'minyonglee1', 'DMF0044', '40'
u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
con.call_timeout = 300000
cur = con.cursor()

def sec(t): print("\n" + "=" * 116); print(t); print("=" * 116)

sec("[①] V_GROUP_ID 대입 로직 (라이브 원문)")
cur.execute("""SELECT LINE, TEXT FROM ALL_SOURCE
                WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' AND TYPE='PACKAGE BODY'
                  AND UPPER(TEXT) LIKE '%V_GROUP_ID%' ORDER BY LINE""")
for ln, tx in cur.fetchall():
    print(f"    L{ln:5d} | {tx.rstrip()[:165]}")

sec("[①-b] GET_ADMIN_GROUP 계열 함수/뷰 존재 확인")
show(*fetch(cur, """SELECT owner, object_name, object_type FROM all_objects
                     WHERE UPPER(object_name) LIKE '%ADMIN_GROUP%'
                        OR UPPER(object_name) LIKE '%USER_MNU_EDIT_AUTH%'
                     ORDER BY owner, object_name"""))

sec(f"[②] 표준 권한뷰 조회 — USER={USER} MNU={MNU} UNIT_TP_CD='D' UNIT_ID={DIV}")
try:
    show(*fetch(cur, """
    SELECT USER_ID, MNU_ID, UNIT_TP_CD, UNIT_ID, EDIT_YN
      FROM SCM_ADM_USER_MNU_EDIT_AUTH_V
     WHERE USER_ID=:u AND MNU_ID=:m
     ORDER BY UNIT_TP_CD, UNIT_ID""", {"u": USER, "m": MNU}))
    cur.execute("""SELECT NVL((SELECT MAX(T2.EDIT_YN) FROM SCM_ADM_USER_MNU_EDIT_AUTH_V T2
                                WHERE T2.USER_ID=:u AND T2.MNU_ID=:m
                                  AND T2.UNIT_TP_CD='D' AND T2.UNIT_ID=:d),'N') FROM DUAL""",
                {"u": USER, "m": MNU, "d": DIV})
    print(f"\n  ★ EDITFLAGSTD 식의 실제 산출값 = {cur.fetchone()[0]!r}")
except Exception as e:
    print("  ", str(e)[:300])

sec("[②-b] 같은 패턴을 이미 쓰는 곳 (GET_MEASURE) — 표준 여부 확인")
cur.execute("""SELECT LINE, TEXT FROM ALL_SOURCE
                WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' AND TYPE='PACKAGE BODY'
                  AND UPPER(TEXT) LIKE '%USER_MNU_EDIT_AUTH_V%' ORDER BY LINE""")
for ln, tx in cur.fetchall():
    print(f"    L{ln:5d} | {tx.rstrip()[:165]}")

sec("[③] AS-IS 원문 EDIT_FLAG 식 (파리티 판정 — DATA_TYPE 조건 유무가 쟁점)")
import io
p_asis = pathlib.Path(r"C:\Projects\NSCM\Doc\_legacy_source\DB_DDL\AsIs_LGCE_SCMDEV_SP1_DDL.sql")
found = 0
if p_asis.exists():
    with io.open(p_asis, encoding="utf-8", errors="ignore") as f:
        for i, ln in enumerate(f, 1):
            if re.search(r'EDIT_FLAG', ln, re.I):
                print(f"    SP1:{i:7d} | {ln.strip()[:160]}")
                found += 1
                if found > 25: break
print(f"    → SP1 에서 EDIT_FLAG 출현 {found} 건")

con.close()
