#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""cmbo_division_mssql_concat_fix.py — 공유 콤보 'Division' MSSQL `+` 연결 → Oracle `||` 정정 (2026-08-11)

## 결함
`SCM_ADM_CMBO_SQL_M.SQL_ID='Division'` 이 **미변환 MSSQL** 이다:
    WHERE (@divisionId IS NULL OR DIVISION_ID   LIKE '%' + @divisionId + '%')
       OR (@divisionId IS NULL OR DIVISION_NAME LIKE '%' + @divisionId + '%')
Oracle 은 문자열 `+` 연결 불가 → **파라미터 전달 시 실패**(러너 `rows=-1`).
미전달이면 BE 가 `''` 치환 → `'' IS NULL` = TRUE 로 앞 조건만으로 통과해 **우연히 전체 14행**.

## 조용했던 이유
`SELECT DIVISION_ID AS CODE, DIVISION_ID AS NAME` — **CODE == NAME** 이라 콤보가 0행이어도
그리드 표시 텍스트가 코드와 동일하다(드롭다운만 빔). "CODE raw 표시" 증상이 안 나타나는 예외.

## 소비 범위 (2026-08-11 실측)
`SCM_MST_SHEET_COLUMNS.CELL_COMBO_DATA_TYPE='Division'` = **35컬럼 / 24화면**
(DM 13 + SCP 2 + SSP 9). 전 CMBO 중 `'%' +` 패턴 보유는 **이 1건뿐**(전수 스캔).

## 조치
`'%' + ` → `'%' || ` / ` + '%'` → ` || '%'` 치환. 다른 문자 변경 없음.
치환 후 FE 가 `q(v)`=`'40'` 을 raw 치환하면
`('40' IS NULL OR DIVISION_ID LIKE '%' || '40' || '%')` 로 정상 동작한다.

사용:
  python cmbo_division_mssql_concat_fix.py            # dry-run (before/after 원문)
  python cmbo_division_mssql_concat_fix.py --apply    # 백업 SQL 생성 후 UPDATE + 실행 검증
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

SQL_ID = "Division"
OUT = pathlib.Path(__file__).resolve().parents[1] / "_apply_corporate"
BACKUP = OUT / "BACKUP_CMBO_SQL_M_Division_20260811.sql"


def read_sql(cur):
    cur.execute("SELECT SQL_DTL_CTN FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID = :s", {"s": SQL_ID})
    r = cur.fetchone()
    if not r:
        sys.exit("[error] SQL_ID='%s' 없음" % SQL_ID)
    v = r[0]
    return v.read() if hasattr(v, "read") else str(v)


def convert(s):
    return s.replace("'%' + ", "'%' || ").replace(" + '%'", " || '%'")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--apply", action="store_true")
    a = ap.parse_args()

    import oracledb

    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        before = read_sql(cur)
        after = convert(before)
        print("[before]\n%s\n" % before.strip())
        if before == after:
            print("[skip] `+` 연결 없음 — 이미 정정됨")
            return 0
        print("[after]\n%s\n" % after.strip())

        # 소비 범위 재확인 (보고용)
        cur.execute("""SELECT COUNT(*) , COUNT(DISTINCT PROGRAM_ID)
                       FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
                       WHERE CELL_COMBO_DATA_TYPE = :s""", {"s": SQL_ID})
        cols, screens = cur.fetchone()
        print("[소비] %d컬럼 / %d화면" % (cols, screens))

        if not a.apply:
            print("\n(dry-run — --apply 로 실행)")
            return 0

        OUT.mkdir(parents=True, exist_ok=True)
        BACKUP.write_text(
            "-- 원복 SQL — SCM_ADM_CMBO_SQL_M.SQL_ID='%s' (2026-08-11 정정 직전 원문)\n"
            "UPDATE SCM_MGR.SCM_ADM_CMBO_SQL_M SET SQL_DTL_CTN = q'[%s]'\n WHERE SQL_ID = '%s';\nCOMMIT;\n"
            % (SQL_ID, before, SQL_ID), encoding="utf-8")
        print("[backup] %s" % BACKUP)

        cur.setinputsizes(v=oracledb.CLOB)
        cur.execute("""UPDATE SCM_MGR.SCM_ADM_CMBO_SQL_M
                       SET SQL_DTL_CTN = :v, LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE
                       WHERE SQL_ID = :s""", {"v": after, "s": SQL_ID})
        n = cur.rowcount
        con.commit()
        print("[apply] %d행 UPDATE + COMMIT" % n)

        # ── 실행 검증: 파라미터 전달/미전달 양쪽 ──────────────────────────────────────
        now = read_sql(cur)
        print("[검증] `+` 잔존 = %d건" % (now.count("'%' + ") + now.count(" + '%'")))
        for label, val in (("전달 '40'", "'40'"), ("미전달 ''", "''")):
            probe = now.replace("@divisionId", val)
            try:
                cur.execute(probe)
                print("  %s → %d행 PASS" % (label, len(cur.fetchall())))
            except Exception as e:  # noqa: BLE001
                print("  %s → ⛔ %s" % (label, str(e)[:120]))
    return 0


if __name__ == "__main__":
    sys.exit(main())
