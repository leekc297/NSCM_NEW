#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""No.41 — P_DMF0082_GET_MAIN_DATA_CURRENT 의 O_RC4(measure 편집권한 커서) 실행 검증.

FE 계약: useForecastPriceStore.setMeasureAuth 가 EDIT_AUTH_YN='Y' 인 measure 만 편집 허용.
따라서 이 커서의 (컬럼명 · 행 내용) 이 요구 No.41 의 정답표와 일치해야 한다.
"""
import sys, io, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
from ora import conn_info
import oracledb

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()

cur.execute("SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI (DY)','NLS_DATE_LANGUAGE=ENGLISH') FROM DUAL")
print(f"# 실행 시각(서버) = {cur.fetchone()[0]}\n")

CASES = [
    ("40", "jaehyeok"),
    ("40", "hongjae.kim"),
    ("40", "minyonglee1"),
    ("81", "jaehyeok"),
    ("81", "hongjae.kim"),
    ("81_HD", "jaehyeok"),
    ("82", "jaehyeok"),
]

for div, uid in CASES:
    cur.execute(
        """SELECT LISTAGG(G.USER_GR_ID, ', ') WITHIN GROUP (ORDER BY G.USER_GR_ID)
           FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M G WHERE G.USER_ID = :u AND G.USE_YN='Y'""",
        {"u": uid},
    )
    groups = cur.fetchone()[0] or "(없음)"

    outs = [con.cursor() for _ in range(6)]
    try:
        cur.callproc(
            "SCM_MGR.PKG_DMF0082.P_DMF0082_GET_MAIN_DATA_CURRENT",
            [div, "", "", "", "20260801", "20260831", "", "", "Current", "Y", uid, uid, "", "", "", ""]
            + outs,
        )
        rc4 = outs[3]
        cols = [c[0] for c in rc4.description]
        data = rc4.fetchall()
        print(f"## div={div:<6} user={uid:<12} groups=[{groups}]")
        print(f"   O_RC4 컬럼 = {cols}")
        for r in data:
            print("   " + " | ".join(f"{cols[i]}={r[i]}" for i in range(len(cols))))
        print()
    except Exception as e:
        print(f"## div={div:<6} user={uid:<12} → ERROR {e}\n")

con.close()
