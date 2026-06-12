#!/usr/bin/env python3
"""
DMF0043_GET_CONTRIBUTE_MAIN_DATA: SITE_ITEM 의 PRODUCT_GROUP 하드코딩 '' → 'N'.

사고 (2026-06-11 사용자 보고):
  RATE 입력 + SAVE 후 "저장 완료" alert 노출 + 메인 grid 재조회 시 RATE 셀 빈칸.
  DB 검증: DM_MST_CONTRIBUTE_RATIO_MST 에 PRODUCT_GROUP='N' 으로 정상 INSERT 됨.
  Root cause:
    - 사내 schema SCM_MST_SITE_ITEM 에 REPORT_GROUP3 미존재 (마이그레이션 시 dropped)
    - GET SP 가 SITE_ITEM.PRODUCT_GROUP 을 '' (empty/NULL) 하드코딩
    - FE handleSave (ContributeMain.tsx:140) 는 NOT NULL 회피 위해 'N' 저장
    - LEFT JOIN ON SITE_ITEM.PRODUCT_GROUP = RATIO.PRODUCT_GROUP 의 '' vs 'N' 매칭 0건
    - → 모든 RATIO PIVOT 셀 NULL → 사용자 "데이터 보이지 않음" 인식

Fix (Option A — 최소 변경):
  GET SP 의 SITE_ITEM.PRODUCT_GROUP 하드코딩 '' → 'N' (3곳 AS + 3곳 GROUP BY)
  → FE 저장값 ('N') 과 일치 → JOIN 성공 → 저장 후 RATE 셀 표시 ✓

대상 SP 1종:
  DMF0043_GET_CONTRIBUTE_MAIN_DATA

수정 위치 (6곳):
  - v_Query CLOB (escaped '''' → '''N''') : 1 AS 라인 + 1 GROUP BY 라인
  - native SQL (p_dis != 'ALL') ('' → 'N')   : 1 AS 라인 + 1 GROUP BY 라인
  - native SQL (p_his = 'Y')   ('' → 'N')   : 1 AS 라인 + 1 GROUP BY 라인
"""
import re
import datetime
from pathlib import Path
import oracledb

CONN_PARAMS = dict(
    user="SCM_MGR",
    password="!SCMroqkf2026",
    dsn=oracledb.makedsn(host="121.162.245.167", port=2521, sid="ESSCMD"),
)

SP_NAME = "DMF0043_GET_CONTRIBUTE_MAIN_DATA"

BACKUP_DIR = Path(__file__).parent.parent / "_diagnostics"
BACKUP_DIR.mkdir(parents=True, exist_ok=True)
LOG_DIR = Path(__file__).parent / "_logs"
LOG_DIR.mkdir(parents=True, exist_ok=True)


def fetch_user_source(conn, name: str) -> str:
    cursor = conn.cursor()
    cursor.execute(
        "SELECT TEXT FROM USER_SOURCE WHERE NAME=:n AND TYPE='PROCEDURE' ORDER BY LINE",
        n=name,
    )
    lines = [row[0] or "" for row in cursor.fetchall()]
    cursor.close()
    return "".join(lines)


def main():
    ts = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    log_file = LOG_DIR / f"{ts}_DMF0043_MAIN_PRODUCT_GROUP_N.log"
    log_lines = [
        f"=== FIX: {SP_NAME} PRODUCT_GROUP '' → 'N' (Option A) ===",
        f"  TIME: {datetime.datetime.now().isoformat()}",
    ]

    conn = oracledb.connect(**CONN_PARAMS)
    try:
        src = fetch_user_source(conn, SP_NAME)
        if not src:
            log_lines.append(f"[FAIL] {SP_NAME} not found")
            return 2

        backup_file = BACKUP_DIR / f"{SP_NAME}_pg_empty_before_{ts}.sql"
        backup_file.write_text("CREATE OR REPLACE " + src, encoding="utf-8")
        log_lines.append(f"  [BACKUP] {len(src)} chars → {backup_file.name}")

        patched = src
        match_log = []

        # ⚠ 순서 중요: P2/P4 (2-quote 패턴, native SQL) 먼저 적용 → P1/P3 (4-quote 패턴, CLOB) 나중
        #   이유: P1 이 ''''  → ''N'' (5char) 로 바꾼 직후 P2 가 ''N'' 의 trailing '' 를 다시
        #         매치하여 ''N'N' 으로 깨뜨리는 사고 방지

        # Pattern 2: native SQL — '' AS PRODUCT_GROUP --PRODUCT_GR (As-Is parity, 2026-06-01)
        #   (?<!') = 원본 line 387 의 '''' 의 trailing '' 매치 차단 (원본 line 471/680 만 잡음)
        p2 = re.compile(
            r"(?<!')''(\s+AS PRODUCT_GROUP --PRODUCT_GR \(As-Is parity, 2026-06-01\))"
        )
        m2 = p2.findall(patched)
        patched = p2.sub(r"'N'\1", patched)
        match_log.append(f"  [P2 native AS]        매치: {len(m2)} (expected 2)")

        # Pattern 4: native SQL GROUP BY '' — 형태:
        #     , NVL(A.ATTRIBUTE1,'')
        #     , ''                         ← target
        #     , NVL(C.FORECAST_INFO_BIZ_TYPE,'')
        p4 = re.compile(
            r"(NVL\(A\.ATTRIBUTE1,''\)[ \t]*\n[ \t]*,[ \t]*)''([ \t]*\n[ \t]*,[ \t]*NVL\(C\.FORECAST_INFO_BIZ_TYPE,''\))"
        )
        m4 = p4.findall(patched)
        patched = p4.sub(r"\1'N'\2", patched)
        match_log.append(f"  [P4 native GROUP BY]  매치: {len(m4)} (expected 2)")

        # Pattern 1: v_Query CLOB — '''' AS PRODUCT_GROUP --PRODUCT_GR (As-Is parity, 2026-06-01)
        #   OPEN PL/SQL 문자열 안: '' = escaped '. 그러므로:
        #     '''' (4 source char) → '' (dynamic SQL = empty string literal)
        #     ''N'' (5 source char) → 'N' (dynamic SQL = 'N' literal) ← 목표
        p1 = re.compile(
            r"''''(\s+AS PRODUCT_GROUP --PRODUCT_GR \(As-Is parity, 2026-06-01\))"
        )
        m1 = p1.findall(patched)
        patched = p1.sub(r"''N''\1", patched)
        match_log.append(f"  [P1 v_Query AS]       매치: {len(m1)} (expected 1)")

        # Pattern 3: v_Query CLOB GROUP BY '''' — 형태:
        #     , NVL(A.ATTRIBUTE1,'''')
        #     , ''''                       ← target
        #     , NVL(C.FORECAST_INFO_BIZ_TYPE,'''')
        p3 = re.compile(
            r"(NVL\(A\.ATTRIBUTE1,''''\)[ \t]*\n[ \t]*,[ \t]*)''''([ \t]*\n[ \t]*,[ \t]*NVL\(C\.FORECAST_INFO_BIZ_TYPE,''''\))"
        )
        m3 = p3.findall(patched)
        patched = p3.sub(r"\1''N''\2", patched)
        match_log.append(f"  [P3 v_Query GROUP BY] 매치: {len(m3)} (expected 1)")

        log_lines.extend(match_log)
        log_lines.append(f"  [PATCHED] size: {len(patched)} (delta {len(patched)-len(src)})")

        total = len(m1) + len(m2) + len(m3) + len(m4)
        if total != 6:
            log_lines.append(f"  [WARN] 매치 총합 {total} ≠ 6 — 패턴 확인 필요. 적용 보류")
            log_file.write_text("\n".join(log_lines), encoding="utf-8")
            print(f"[WARN] 매치 총합 {total} ≠ 6 — see {log_file}")
            return 3

        if patched == src:
            log_lines.append("  [SKIP] 차이 없음 (이미 fix 됐을 수 있음)")
            log_file.write_text("\n".join(log_lines), encoding="utf-8")
            print("[SKIP] 차이 없음")
            return 0

        # CREATE OR REPLACE
        ddl = "CREATE OR REPLACE " + patched
        cursor = conn.cursor()
        try:
            cursor.execute(ddl)
            conn.commit()
            log_lines.append(f"  [OK] CREATE OR REPLACE")
        except oracledb.DatabaseError as e:
            log_lines.append(f"  [ERR] {e}")
            cursor.execute(
                "SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME=:n AND TYPE='PROCEDURE' ORDER BY SEQUENCE",
                n=SP_NAME,
            )
            for line, pos, text in cursor.fetchall():
                log_lines.append(f"    Line {line}:{pos}  {text}")
            log_file.write_text("\n".join(log_lines), encoding="utf-8")
            print(f"[ERR] DDL 실패 — see {log_file}")
            return 4
        finally:
            cursor.close()

        # VALID 검증
        cursor = conn.cursor()
        cursor.execute(
            "SELECT STATUS FROM USER_OBJECTS WHERE OBJECT_NAME=:n AND OBJECT_TYPE='PROCEDURE'",
            n=SP_NAME,
        )
        status_row = cursor.fetchone()
        cursor.close()
        status = status_row[0] if status_row else "?"
        log_lines.append(f"  [STATUS] {status}")

        log_file.write_text("\n".join(log_lines), encoding="utf-8")
        if status == "VALID":
            print(f"[OK] {SP_NAME} 갱신 완료 (STATUS=VALID)")
            return 0
        else:
            print(f"[ERR] {SP_NAME} STATUS={status} — see {log_file}")
            return 5
    finally:
        conn.close()


if __name__ == "__main__":
    import sys
    sys.exit(main())
