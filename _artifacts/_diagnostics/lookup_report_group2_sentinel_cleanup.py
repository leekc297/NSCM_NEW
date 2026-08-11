#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""lookup_report_group2_sentinel_cleanup.py — [결함 B-1] REPORT_GROUP2 센티널 변형 행 정리 (2026-08-10)

## 증상 (조용한 오류 — 에러 없이 금액이 틀림)
`P_DMF0044_SALES_REPORT_DEPT_CREATE` 의
    LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B
      ON A.CUST_REPORT = B.SEGMENT1 AND B.LOOKUP_TYPE = 'REPORT_GROUP2'
은 **집계 이전**에 붙는다. SEGMENT1 이 2행이면 원천 행이 2배로 불어난 뒤 같은 그룹으로 합산된다.

실측 (버전 R_S_20260810_V009_C, 원천합계 vs 산출합계):
    LGE/KT&G   1,072,445,367,869.54  →  2,144,890,735,739.08   배수 2.0  ⛔
    동남아         32,368,247,885.38  →     64,736,495,770.76   배수 2.0  ⛔
    그 외 전 구간 배수 1.0 정상

## 원인 — '중복'이 아니라 **센티널 변형** (PK 를 통과한 이유)
PK = (LOOKUP_TYPE, SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5).
두 행은 **SEGMENT4 만** ' ' vs '-' 로 달라 PK 제약을 통과했다(ATTRIBUTE1~15 도 동일 패턴).
MSSQL '' → Oracle 이관 시 관례 2종(' ' / '-')이 혼재한 결과.
[[feedback_pk_sentinel_normalization]] (hook #119 §1.5 — 변형 ' '/'-'/'--' 은 '-' 로 통일) 계열.

## 어느 행을 지우는가 — 분포로 판정 (추측 아님)
    REPORT_GROUP2 의 SEGMENT4 분포 :  '-' 92행(97.9%)  /  ' ' 2행(2.1%)
    ' ' 2행 = 정확히 문제의 2키(LGE/KT&G, 동남아) ⇒ ' ' 가 이상치, '-' 가 관례
    두 행은 SEGMENT4·ATTRIBUTE1~15 를 제외한 **전 컬럼이 동일**
      (SEGMENT2/3/5, DISPLAY_SEQ, VALID_YN, DESCRIPTION, CREATION_DATE,
       LAST_UPDATE_DATE, LAST_UPDATED_BY 까지 일치) ⇒ 최신 갱신분 유실 위험 없음
    REPORT_GROUP2 를 SEGMENT4 로 거르는 소비자 : 0건 (SEGMENT4 언급 48건은 전부 타 LOOKUP_TYPE)

⇒ **SEGMENT4 = ' ' 인 2행 삭제** (SEGMENT4='-' 짝이 존재하는 경우에만 — 멱등 가드)

사용: python lookup_report_group2_sentinel_cleanup.py --backup / --delete / --verify
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
BACKUP = OUT / "BACKUP_LOOKUP_REPORT_GROUP2_sentinel_rows_20260810.sql"

# 멱등 가드: '-' 짝이 있는 ' ' 행만
WHERE = """ LOOKUP_TYPE = 'REPORT_GROUP2'
   AND SEGMENT4 = ' '
   AND EXISTS ( SELECT 1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL X
                 WHERE X.LOOKUP_TYPE = 'REPORT_GROUP2'
                   AND X.SEGMENT1 = L.SEGMENT1
                   AND X.SEGMENT2 = L.SEGMENT2
                   AND X.SEGMENT3 = L.SEGMENT3
                   AND X.SEGMENT5 = L.SEGMENT5
                   AND X.SEGMENT4 = '-' )"""
EXPECT = 2


def q(v):
    if v is None:
        return "NULL"
    if hasattr(v, "strftime"):
        return "TO_DATE('%s','YYYY-MM-DD HH24:MI:SS')" % v.strftime("%Y-%m-%d %H:%M:%S")
    if isinstance(v, (int, float)):
        return str(v)
    return "'" + str(v).replace("'", "''") + "'"


def cmd_backup():
    import oracledb

    OUT.mkdir(parents=True, exist_ok=True)
    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute("""SELECT column_name FROM all_tab_columns WHERE owner='SCM_MGR'
                        AND table_name='SCM_ADM_LOOKUP_MASTER_DETAIL' ORDER BY column_id""")
        cols = [r[0] for r in cur.fetchall()]
        cur.execute("SELECT %s FROM SCM_ADM_LOOKUP_MASTER_DETAIL L WHERE %s" % (", ".join(cols), WHERE))
        rows = cur.fetchall()
    if len(rows) != EXPECT:
        sys.exit("[error] 대상 %d행 (기대 %d) — 중단" % (len(rows), EXPECT))
    lines = [
        "-- 원복본 — REPORT_GROUP2 센티널 변형 행 (SEGMENT4=' ') 2행",
        "-- 생성 2026-08-10 / 삭제 전 원문 그대로. 되돌릴 때 이 파일을 실행.",
        "-- 근거: lookup_report_group2_sentinel_cleanup.py 헤더 참조",
        "",
    ]
    for r in rows:
        lines.append("INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL (%s)" % ", ".join(cols))
        lines.append("VALUES (%s);" % ", ".join(q(v) for v in r))
        lines.append("")
    lines.append("COMMIT;")
    BACKUP.write_text("\n".join(lines), encoding="utf-8")
    print("[backup] %s" % BACKUP)
    print("  보존 행수 %d" % len(rows))
    for r in rows:
        m = dict(zip(cols, r))
        print("    SEGMENT1=%r SEGMENT4=%r DESCRIPTION=%r" % (m["SEGMENT1"], m["SEGMENT4"], m["DESCRIPTION"]))
    return 0


def cmd_delete():
    import oracledb

    if not BACKUP.is_file():
        sys.exit("[error] 백업 부재 — --backup 선행")
    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute("SELECT COUNT(*) FROM SCM_ADM_LOOKUP_MASTER_DETAIL L WHERE %s" % WHERE)
        n = cur.fetchone()[0]
        if n == 0:
            print("[delete] 대상 0행 — 이미 정리됨(멱등). 변경 없음.")
            return 0
        if n != EXPECT:
            sys.exit("[error] 대상 %d행 (기대 %d) — 중단" % (n, EXPECT))
        cur.execute("DELETE FROM SCM_ADM_LOOKUP_MASTER_DETAIL L WHERE %s" % WHERE)
        deleted = cur.rowcount
        if deleted != EXPECT:
            con.rollback()
            sys.exit("[error] 삭제 %d행 (기대 %d) — ROLLBACK" % (deleted, EXPECT))
        cur.execute("""SELECT COUNT(*) FROM ( SELECT SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                        WHERE LOOKUP_TYPE='REPORT_GROUP2' GROUP BY SEGMENT1 HAVING COUNT(*)>1 )""")
        dup = cur.fetchone()[0]
        if dup != 0:
            con.rollback()
            sys.exit("[error] 삭제 후에도 SEGMENT1 중복 %d건 — ROLLBACK" % dup)
        con.commit()
        print("[delete] %d행 삭제 + COMMIT / SEGMENT1 중복 잔존 %d건 ✅" % (deleted, dup))
    return 0


def cmd_verify():
    import oracledb

    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute("""SELECT '['||SEGMENT4||']', COUNT(*) FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                        WHERE LOOKUP_TYPE='REPORT_GROUP2' GROUP BY SEGMENT4 ORDER BY 2 DESC""")
        print("  SEGMENT4 분포:", ", ".join("%s=%d" % r for r in cur.fetchall()))
        cur.execute("""SELECT SEGMENT1, COUNT(*) FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                        WHERE LOOKUP_TYPE='REPORT_GROUP2' GROUP BY SEGMENT1 HAVING COUNT(*)>1""")
        dups = cur.fetchall()
        print("  SEGMENT1 중복:", dups if dups else "0건 ✅")
        cur.execute("""SELECT COUNT(*) FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE='REPORT_GROUP2'""")
        print("  REPORT_GROUP2 총 행수:", cur.fetchone()[0])
    return 0


def main():
    ap = argparse.ArgumentParser()
    for f in ("backup", "delete", "verify"):
        ap.add_argument("--" + f, action="store_true")
    a = ap.parse_args()
    if a.backup:
        sys.exit(cmd_backup())
    if a.delete:
        sys.exit(cmd_delete())
    if a.verify:
        sys.exit(cmd_verify())
    ap.error("--backup / --delete / --verify 중 하나 필요")


if __name__ == "__main__":
    main()
