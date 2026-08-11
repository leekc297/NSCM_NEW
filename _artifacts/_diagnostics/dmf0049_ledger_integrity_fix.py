#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""dmf0049_ledger_integrity_fix.py — DM_PLN_SALES_ETC_REPORT_C 원장 정합 3건 (2026-08-11)

사용자 지시: "원장 정합 (소규모) 작업 진행". **삭제하지 않고 값만 정합**시킨다.

## 대상 (사전 실측 — 추정 아님)
| # | 대상 | 행수 | 근거 |
|---|---|---:|---|
| ① | `SOLDTO_CODE IS NULL` → `'-'` | 20 | 센티널 `'-'` 가 209,744행으로 정본(hook #119 §1.5). 전부 2026-08-11 생성(테스트분) |
| ② | `DEPARTMENT_NAME IS NULL` → 같은 (DIVISION_ID, DEPARTMENT_ID) 의 정상값 | 72 | 전부 div40 / DEPARTMENT_ID=58691249, 형제 행이 '마케팅1.IM' 을 가짐. 2026-08-11 생성(테스트분) |
| ③ | `DEPT_NAME <> 마스터` → 마스터값 | 2,532 | div40 / DEPT 4종 / 버전 3종. 아래 사유 참조 |

## ③ 을 왜 고치는가 (유령 행 근본 해소)
저장 SP 가 `DEPT_NAME` 을 **항상 현재 마스터 룩업값으로 덮어쓴다**(BODY L1059~1060 — AS-IS SP 도
동일 CASE 구조 = 파리티). 그런데 조회는 Oracle PIVOT 이라 **암묵 GROUP BY 에 T_DEPT_NAME 이 참여**한다
(BODY L607·L618). ⇒ 원장값이 옛 명칭인 부서는 **한 셀만 저장해도 그 월만 새 이름이 되어 행이 갈라진다**
(2026-08-11 실사고: DATA_SEQ=120 이 4행으로 표시). 원장을 마스터에 맞추면 재발이 없어진다.
실측 불일치는 전체 209,764행 중 **2,532행(1.2%) / 4 DEPT** 뿐이다(나머지 207,232행은 이미 일치):
    IT/HEV팀 → 'IT / HEV팀'(1,586+152) · IM팀 → 'IM 영업팀'(719) · 중국EV TFT(중국EV P) → '중국EV Task'(75)
⚠ 이는 "DEPT_NAME 은 기록 시점 스냅샷이 아니라 **현재 이름**" 이라는 시스템 설계(저장 시 덮어씀)를
  따르는 조치다. 스냅샷 보존이 업무 요구라면 ③은 하지 말아야 한다 — 사용자 확인 후 진행.

사용:
  python dmf0049_ledger_integrity_fix.py --dump / --apply / --verify
"""
import argparse
import json
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
BACKUP = OUT / "BACKUP_DMF0049_LEDGER_INTEGRITY_20260811.json"

EXPECT = {"soldto": 20, "deptname": 72, "dept_master": 2532}

# 마스터 룩업 선계산 (상관 스칼라 금지 — 선계산 + JOIN)
LK = """
  SELECT SEGMENT1 AS DEPT_ID,
         CASE WHEN LOOKUP_TYPE='DMF0044_DEPARTMENT_TEAM2' THEN '40'
              ELSE SUBSTR(LOOKUP_TYPE, LENGTH('DMF0044_DEPARTMENT_TEAM2_')+1) END AS DIVISION_ID,
         MIN(SEGMENT2) AS MASTER_NAME
    FROM SCM_ADM_LOOKUP_MASTER_DETAIL
   WHERE LOOKUP_TYPE LIKE 'DMF0044_DEPARTMENT_TEAM2%'
   GROUP BY SEGMENT1,
         CASE WHEN LOOKUP_TYPE='DMF0044_DEPARTMENT_TEAM2' THEN '40'
              ELSE SUBSTR(LOOKUP_TYPE, LENGTH('DMF0044_DEPARTMENT_TEAM2_')+1) END
"""


def _counts(cur):
    out = {}
    cur.execute("SELECT COUNT(*) FROM DM_PLN_SALES_ETC_REPORT_C WHERE SOLDTO_CODE IS NULL")
    out["soldto"] = cur.fetchone()[0]
    cur.execute("SELECT COUNT(*) FROM DM_PLN_SALES_ETC_REPORT_C WHERE DEPARTMENT_NAME IS NULL")
    out["deptname"] = cur.fetchone()[0]
    cur.execute("""SELECT COUNT(*) FROM DM_PLN_SALES_ETC_REPORT_C R
                     JOIN (%s) LK ON LK.DEPT_ID=R.DEPT_ID AND LK.DIVISION_ID=R.DIVISION_ID
                    WHERE R.DEPT_NAME IS NOT NULL AND R.DEPT_NAME <> LK.MASTER_NAME""" % LK)
    out["dept_master"] = cur.fetchone()[0]
    return out


def cmd_dump():
    import oracledb

    OUT.mkdir(parents=True, exist_ok=True)
    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        print("[before] ", _counts(cur))
        cur.execute("""
            SELECT ROWIDTOCHAR(R.ROWID), R.DIVISION_ID, R.VERSION_NO, R.DATA_SEQ, R.MEASURE,
                   R.YYYYMMDD, R.SOLDTO_CODE, R.DEPARTMENT_NAME, R.DEPT_NAME
              FROM DM_PLN_SALES_ETC_REPORT_C R
              LEFT JOIN (%s) LK ON LK.DEPT_ID=R.DEPT_ID AND LK.DIVISION_ID=R.DIVISION_ID
             WHERE R.SOLDTO_CODE IS NULL
                OR R.DEPARTMENT_NAME IS NULL
                OR (R.DEPT_NAME IS NOT NULL AND LK.MASTER_NAME IS NOT NULL
                    AND R.DEPT_NAME <> LK.MASTER_NAME)
        """ % LK)
        cols = [c[0] for c in cur.description]
        rows = [dict(zip(cols, r)) for r in cur.fetchall()]
    BACKUP.write_text(json.dumps(rows, ensure_ascii=False, indent=1, default=str), encoding="utf-8")
    print("[dump] %s — 영향 행 %d건 (ROWID + 변경 전 값)" % (BACKUP, len(rows)))
    return 0


def cmd_apply():
    import oracledb

    if not BACKUP.is_file():
        sys.exit("[error] 백업 부재 — --dump 선행")
    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        before = _counts(cur)
        print("[before]", before)
        for k, v in EXPECT.items():
            if before[k] != v:
                sys.exit("[error] %s 실측 %d ≠ 기대 %d — 상태가 달라졌다. 재실측 후 진행" % (k, before[k], v))

        # ① SOLDTO_CODE
        cur.execute("""UPDATE DM_PLN_SALES_ETC_REPORT_C
                          SET SOLDTO_CODE='-', LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
                        WHERE SOLDTO_CODE IS NULL""")
        n1 = cur.rowcount
        print("  ① SOLDTO_CODE → '-'                      %d행" % n1)

        # ② DEPARTMENT_NAME — 같은 (division, department) 형제 정상값으로 (선계산 MERGE)
        cur.execute("""
            MERGE INTO DM_PLN_SALES_ETC_REPORT_C T
            USING ( SELECT DIVISION_ID, DEPARTMENT_ID, MIN(DEPARTMENT_NAME) AS NM
                      FROM DM_PLN_SALES_ETC_REPORT_C
                     WHERE DEPARTMENT_NAME IS NOT NULL
                     GROUP BY DIVISION_ID, DEPARTMENT_ID ) S
               ON ( T.DIVISION_ID = S.DIVISION_ID AND T.DEPARTMENT_ID = S.DEPARTMENT_ID )
             WHEN MATCHED THEN UPDATE
                  SET T.DEPARTMENT_NAME = S.NM,
                      T.LAST_UPDATED_BY = 'admin', T.LAST_UPDATE_DATE = SYSDATE
                WHERE T.DEPARTMENT_NAME IS NULL
        """)
        n2 = cur.rowcount
        print("  ② DEPARTMENT_NAME → 형제 정상값            %d행" % n2)

        # ③ DEPT_NAME — 현재 마스터값으로
        cur.execute("""
            MERGE INTO DM_PLN_SALES_ETC_REPORT_C T
            USING ( %s ) S
               ON ( T.DEPT_ID = S.DEPT_ID AND T.DIVISION_ID = S.DIVISION_ID )
             WHEN MATCHED THEN UPDATE
                  SET T.DEPT_NAME = S.MASTER_NAME,
                      T.LAST_UPDATED_BY = 'admin', T.LAST_UPDATE_DATE = SYSDATE
                WHERE T.DEPT_NAME IS NOT NULL AND T.DEPT_NAME <> S.MASTER_NAME
        """ % LK)
        n3 = cur.rowcount
        print("  ③ DEPT_NAME → 마스터값                    %d행" % n3)

        got = {"soldto": n1, "deptname": n2, "dept_master": n3}
        if got != EXPECT:
            con.rollback()
            sys.exit("[error] 갱신 건수 %s ≠ 기대 %s — 롤백" % (got, EXPECT))
        con.commit()
        print("\n[after] ", _counts(cur), " (전부 0 이어야 정상)")
    return 0


def cmd_verify():
    import oracledb

    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        c = _counts(con.cursor())
    print("  잔여:", c)
    return 0 if all(v == 0 for v in c.values()) else 1


def main():
    ap = argparse.ArgumentParser()
    for f in ("dump", "apply", "verify"):
        ap.add_argument("--" + f, action="store_true")
    a = ap.parse_args()
    for f in ("dump", "apply", "verify"):
        if getattr(a, f):
            sys.exit(globals()["cmd_" + f]())
    ap.error("--dump / --apply / --verify 중 하나 필요")


if __name__ == "__main__":
    main()
