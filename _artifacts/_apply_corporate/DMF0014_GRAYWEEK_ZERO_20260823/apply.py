#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""DMF0014 Excel Upload — 회색(입력불가) 주차 값 = **0 으로 적재** (사용자 지시 2026-08-23).

## 요구
    "Customer Fcst Master 에서 valid = 'Y' 가 아닌데 Excel 에 값이 존재하는 경우에는 0 으로 저장해주세요."
    "가능하면 UI 수정없이 PKG 수정만으로 보완되도록 해주세요."

## 종전 동작 (2026-08-18 [E20260818-GRAYWEEK])
회색 주차에 값이 있으면 스테이징 행을 `UPLOAD_STATUS_CODE='ERROR'` 로 바꾸고 **업로드 전체를 반려**했다.
→ 사용자 지시로 정책 전환: 반려하지 않고 **그 칸만 0 으로 적재**한다(다른 칸은 정상값 그대로).

## 변경 2지점 (P_DMF0014_CUST_FCST_EXCEL_UPLOAD)
1. GRAYWEEK 검증 블록 → **집계·로그 전용**으로 축소. 상태 변경(ERROR)·즉시 RETURN 제거.
   (건수는 로그 타입 175 로 남겨 "몇 칸이 0 처리됐는지" 추적 가능)
2. 원장 적재 INSERT 의 값 컬럼 → 마스터 유효 주차면 원값, 아니면 **0**.
   판정식은 종전 검증과 **같은 술어**(DM_MST_CUSTOMER_FCST VALID_YN='Y' + division/site/measure/bucket)를
   그대로 쓴다 — 판정 기준이 갈라지면 화면 회색과 적재 결과가 어긋난다.

마커 `[E20260823-GRAYZERO]`. UI(FE) 변경 없음.

실행: python apply.py        (점검만: python apply.py --dry)
원복: 백업 파일 `BACKUP_PKG_DMF0014_BODY_<타임스탬프>.sql` 을 그대로 실행
"""
import pathlib
import sys

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb  # noqa: E402
from ora import conn_info  # noqa: E402

HERE = pathlib.Path(__file__).resolve().parent
DRY = "--dry" in sys.argv
MARK = "[E20260823-GRAYZERO]"

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()

# ── 현행 BODY 덤프 ────────────────────────────────────────────────
cur.execute(
    "SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0014' "
    "AND TYPE='PACKAGE BODY' ORDER BY LINE"
)
body = "".join(t for (t,) in cur if t is not None)
if not body:
    sys.exit("⛔ BODY 덤프 실패")
print(f"[1] 현행 BODY {body.count(chr(10)) + 1}줄")
if MARK in body:
    sys.exit(f"⛔ 이미 적용됨 ({MARK}) — 중복 적용 방지")

lines = body.split("\n")

# ── 패치 A: GRAYWEEK 검증 블록 → 집계·로그 전용 ─────────────────────
start = next((i for i, l in enumerate(lines) if "E20260818-GRAYWEEK" in l), None)
if start is None:
    sys.exit("⛔ GRAYWEEK 블록을 찾지 못함 — 본문이 바뀌었다. 수동 확인 필요")
b = next(i for i in range(start, len(lines)) if lines[i].strip() == "BEGIN")
e = next(i for i in range(b + 1, len(lines)) if lines[i].rstrip() == "            END;")
old_block = "\n".join(lines[start : e + 1])
print(f"[2] GRAYWEEK 블록 = 본문 {start + 1}~{e + 1}행 ({e - start + 1}줄)")

new_block = """            /* [E20260818-GRAYWEEK → E20260823-GRAYZERO] 회색(입력불가) 주차 정책 전환 ─────
               종전: 회색 주차에 값이 있으면 스테이징 행을 ERROR 로 바꾸고 업로드 전체를 반려했다.
               변경(사용자 지시 2026-08-23): **반려하지 않는다.** 그 칸만 0 으로 적재하고
                 나머지 칸은 정상값 그대로 넣는다 — 적재부 INSTEAD 값 CASE 참조.
               여기서는 몇 칸이 0 처리 대상인지만 세어 로그(175)에 남긴다. 상태 변경·RETURN 없음. */
            BEGIN
                SELECT COUNT(*)
                INTO   v_err_cnt
                FROM   SCM_ADM_EXCEL_UPLOAD AEU
                WHERE  AEU.PROGRAM_ID = V_PROGRAM_ID
                AND    AEU.SHEET_NAME = V_SHEET_NAME
                AND    AEU.CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(AEU.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    AEU.UPLOAD_STATUS_CODE = 'UPLOAD'
                AND    EXISTS (
                        SELECT 1
                        FROM   (SELECT CASE W.IDX
                                         WHEN 14 THEN H.ATTRIBUTE14 WHEN 15 THEN H.ATTRIBUTE15
                                         WHEN 16 THEN H.ATTRIBUTE16 WHEN 17 THEN H.ATTRIBUTE17
                                         ELSE H.ATTRIBUTE18 END AS WK_RAW
                                      ,W.IDX
                                FROM   SCM_ADM_EXCEL_UPLOAD H
                                      ,(SELECT 14 IDX FROM DUAL UNION ALL SELECT 15 FROM DUAL
                                        UNION ALL SELECT 16 FROM DUAL UNION ALL SELECT 17 FROM DUAL
                                        UNION ALL SELECT 18 FROM DUAL) W
                                WHERE  H.PROGRAM_ID = V_PROGRAM_ID
                                AND    H.SHEET_NAME = V_SHEET_NAME
                                AND    H.CREATED_BY = P_CREATED_BY
                                AND    TO_CHAR(H.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                                AND    (H.ATTRIBUTE1 IS NULL OR UPPER(H.ATTRIBUTE1) = 'DIVISION*')) WK
                        WHERE  WK.WK_RAW IS NOT NULL
                        AND    REGEXP_LIKE(WK.WK_RAW, '^[0-9.eE+-]+$')
                        /* 값이 입력된 주차만 대상 (빈칸은 통과) */
                        AND    (CASE WK.IDX
                                  WHEN 14 THEN AEU.ATTRIBUTE14 WHEN 15 THEN AEU.ATTRIBUTE15
                                  WHEN 16 THEN AEU.ATTRIBUTE16 WHEN 17 THEN AEU.ATTRIBUTE17
                                  ELSE AEU.ATTRIBUTE18 END) IS NOT NULL
                        AND    NOT EXISTS (
                                SELECT 1
                                FROM   DM_MST_CUSTOMER_FCST M, SCM_MST_DIVISION MD
                                WHERE  M.VALID_YN = 'Y'
                                AND    M.DIVISION_ID = MD.DIVISION_ID
                                AND    (MD.DIVISION_ID = AEU.ATTRIBUTE1 OR MD.DIVISION_NAME = AEU.ATTRIBUTE1)
                                AND    M.SCM_SITE_ID = AEU.ATTRIBUTE2
                                AND    M.MEASURE     = AEU.ATTRIBUTE10
                                AND    M.SUMMARY_BUCKET_VALUE =
                                       TO_CHAR(TO_NUMBER(WK.WK_RAW), 'FM99999999')));

                IF v_err_cnt > 0 THEN
                    V_LOG_TYPE    := '175';
                    V_LOG_MESSAGE := '########## GRAYZERO: non-editable week value -> 0 (rows=' || v_err_cnt || ') ##########';
                    V_DESCRIPTION := NULL;
                    D_EVENT_DATE  := SYSTIMESTAMP;
                    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                END IF;
            END;"""

body2 = body.replace(old_block, new_block, 1)
if body2 == body:
    sys.exit("⛔ 패치 A 실패 (블록 치환 안 됨)")

# ── 패치 B: 적재 값 → 마스터 미유효 주차면 0 ─────────────────────────
old_val = """                      ,C.YYYYMMDD
                      ,TO_NUMBER(V.VALUE)"""
new_val = """                      ,C.YYYYMMDD
                      /* [E20260823-GRAYZERO] Customer Fcst Master 가 VALID_YN='Y' 로 열어둔 주차가
                         아니면(화면 회색 구간) 사용자가 값을 넣었어도 **0 으로 적재**한다.
                         판정식은 위 GRAYZERO 집계와 동일한 술어 — 기준이 갈라지면 화면 색과 적재가 어긋난다. */
                      ,CASE WHEN EXISTS (
                                SELECT 1
                                FROM   DM_MST_CUSTOMER_FCST M, SCM_MST_DIVISION MD
                                WHERE  M.VALID_YN = 'Y'
                                AND    M.DIVISION_ID = MD.DIVISION_ID
                                AND    (MD.DIVISION_ID = V.ATTRIBUTE1 OR MD.DIVISION_NAME = V.ATTRIBUTE1)
                                AND    M.SCM_SITE_ID = V.ATTRIBUTE2
                                AND    M.MEASURE     = V.ATTRIBUTE10
                                AND    M.SUMMARY_BUCKET_VALUE = TRIM(C.YYYYMMDD))
                            THEN TO_NUMBER(V.VALUE) ELSE 0 END"""
cnt_before = body2.count(old_val)
print(f"[3] 적재 값 컬럼 후보 {cnt_before}곳 (메인 SP 1 + _SM 1 = 2 예상)")
if cnt_before == 0:
    sys.exit("⛔ 패치 B 실패 (적재 SELECT 값 컬럼을 못 찾음)")
# 메인 SP(P_DMF0014_CUST_FCST_EXCEL_UPLOAD) 안의 첫 번째만 — _SM 은 배선 제외 SP
main_end = body2.index("PROCEDURE P_DMF0014_CUST_FCST_EXCEL_UPLOAD_SM")
head, tail = body2[:main_end], body2[main_end:]
if old_val not in head:
    sys.exit("⛔ 패치 B 실패 (메인 SP 구간에 값 컬럼 없음)")
body3 = head.replace(old_val, new_val, 1) + tail

print(f"[4] 패치 후 {body3.count(chr(10)) + 1}줄 / 마커 {body3.count(MARK)}회")

stamp = cur.execute("SELECT TO_CHAR(SYSDATE,'YYYYMMDD_HH24MISS') FROM DUAL").fetchone()[0]
(HERE / f"BACKUP_PKG_DMF0014_BODY_{stamp}.sql").write_text(
    "CREATE OR REPLACE " + body + "\n/\n", encoding="utf-8")
(HERE / "PREVIEW_PKG_DMF0014_BODY.sql").write_text(
    "CREATE OR REPLACE " + body3 + "\n/\n", encoding="utf-8")
print(f"[5] 백업 BACKUP_PKG_DMF0014_BODY_{stamp}.sql / 미리보기 PREVIEW_PKG_DMF0014_BODY.sql")

if DRY:
    print("\n(dry) 적용하지 않음")
    con.close()
    sys.exit(0)

cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 120")
cur.execute("CREATE OR REPLACE " + body3)
cur.execute("""SELECT STATUS FROM ALL_OBJECTS
                WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0014' AND OBJECT_TYPE='PACKAGE BODY'""")
status = cur.fetchone()[0]
print(f"[6] 컴파일 STATUS = {status}")
if status != "VALID":
    cur.execute("""SELECT LINE, POSITION, TEXT FROM ALL_ERRORS
                    WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0014' ORDER BY SEQUENCE""")
    for ln, pos, txt in cur.fetchall()[:10]:
        print(f"    {ln}:{pos} {txt}")
    print("⛔ INVALID — 백업으로 원복하세요")
    con.close()
    sys.exit(1)

cur.execute("""SELECT COUNT(*) FROM ALL_SOURCE
                WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0014' AND TYPE='PACKAGE BODY'
                AND INSTR(TEXT, 'E20260823-GRAYZERO') > 0""")
print(f"[7] 마커 실측 {cur.fetchone()[0]}행 (기대 2)")
con.commit()
con.close()
print("\n적용 완료")
