#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""DMF0082 조회(P_DMF0082_GET_MAIN_DATA) 병목 실측 — hook #129 ⓿단계.

원칙(룰):
  · 병목은 **ASH 실측**으로 먼저 특정한다. 추정으로 손대지 않는다.
  · 귀속은 **SQL_ID 단위 실측**만 인정한다(명명 추정·단독재현 성적 채택 금지).
  · 진단 SQL 자체도 상관 스칼라/상관 IN 없이 선계산+JOIN 으로 짠다.

방법: 전용 세션에 마커(CLIENT_INFO)를 찍고 SP 를 실행 → 그 세션의 ASH 를 SQL_ID×대기이벤트로
      집계해 시간 점유를 나눈다. 커서는 **전량 fetch** 해야 SP 밖 직렬화 비용까지 드러난다.
"""
import io, sys, time, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
from ora import conn_info
import oracledb

MARK = "DMF0082GETASH"

def run(div, frm, to, user="minyonglee1", grp="ADMIN", fetch=True):
    u, p, d = conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d)
    cur = con.cursor()
    cur.execute("SELECT SYS_CONTEXT('USERENV','SID') FROM DUAL")
    sid = cur.fetchone()[0]
    cur.execute("BEGIN DBMS_APPLICATION_INFO.SET_CLIENT_INFO(:1); END;", [MARK])

    rcs = [con.cursor() for _ in range(5)]
    rr = con.cursor()
    t0 = time.time()
    # ⚠ 화면은 미선택 필터를 NULL 이 아니라 **'ALL'** 로 보낸다(SP 입력 로그 실측).
    #   NULL 로 보내면 FN_SCM_GET_WHERE_SQL 이 조건을 만들어 전건 탈락 → 0행이 되어 병목이 안 드러난다.
    A = 'ALL'
    cur.callproc("SCM_MGR.PKG_DMF0082.P_DMF0082_GET_MAIN_DATA",
                 [div, A, A, A, frm, to, A, A,
                  None, 'Y', user, grp, A, A, A, A,
                  rcs[0], rcs[1], rcs[2], rcs[3], rcs[4], rr])
    t_sp = time.time() - t0

    counts, t_fetch = [], 0.0
    if fetch:
        t1 = time.time()
        for rc in rcs:
            try:
                counts.append(len(rc.fetchall()))
            except Exception:
                counts.append(-1)
        t_fetch = time.time() - t1
    print(f"\n[div {div} {frm}~{to}]  SP {t_sp:7.2f}s | fetch {t_fetch:7.2f}s | 합계 {t_sp+t_fetch:7.2f}s")
    print(f"   결과행 O_RC1~5 = {counts}")
    for rc in rcs:
        try: rc.close()
        except Exception: pass
    con.close()
    return sid, t_sp, t_fetch

def ash(minutes=12):
    u, p, d = conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d)
    cur = con.cursor()
    # 마커가 찍힌 세션의 샘플만. 선계산 후 JOIN (상관 서브쿼리 금지 — 진단 SQL 품질 룰)
    cur.execute("""
        WITH A AS (
            SELECT SQL_ID,
                   NVL(EVENT, 'ON CPU')                AS EVENT,
                   COUNT(*)                            AS SAMPLES
            FROM   V$ACTIVE_SESSION_HISTORY
            WHERE  SAMPLE_TIME > SYSDATE - :mins/1440
            AND    CLIENT_ID IS NULL
            AND    MODULE IS NOT NULL
            AND    PROGRAM LIKE '%python%'
            GROUP  BY SQL_ID, NVL(EVENT, 'ON CPU')
        ), S AS (
            SELECT SQL_ID, MIN(SUBSTR(SQL_TEXT,1,120)) AS TXT
            FROM   V$SQL
            GROUP  BY SQL_ID
        )
        SELECT A.SQL_ID, A.EVENT, A.SAMPLES, S.TXT
        FROM   A LEFT JOIN S ON S.SQL_ID = A.SQL_ID
        ORDER  BY A.SAMPLES DESC FETCH FIRST 25 ROWS ONLY""", mins=minutes)
    rows = cur.fetchall()
    tot = sum(r[2] for r in rows) or 1
    print(f"\n=== ASH 귀속 (최근 {minutes}분, python 세션) — 총 {tot} 샘플(≈{tot}초) ===")
    print(f"   {'SQL_ID':<15}{'EVENT':<28}{'초':>5}{'%':>7}  SQL")
    for r in rows:
        print(f"   {str(r[0]):<15}{r[1][:27]:<28}{r[2]:>5}{100*r[2]/tot:>6.1f}%  {(r[3] or '')[:60]}")
    con.close()

if __name__ == "__main__":
    div = sys.argv[1] if len(sys.argv) > 1 else "40"
    frm = sys.argv[2] if len(sys.argv) > 2 else "20260801"
    to  = sys.argv[3] if len(sys.argv) > 3 else "20270131"
    run(div, frm, to)
    ash()
