#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""DMF0014 Excel Upload — 'Invalid Measure Upload Bucket' 클라우드 전건 오류 정정 (2026-08-23).

## 증상 (클라우드만 / 사내 정상)
파일 선택(mode=0 검증) 단계에서 전건이 `ERROR / Invalid Measure Upload Bucket.` 로 분류된다.

## 원인 — 헤더 일자 파싱이 **문자 서식과 NLS 에 의존**한다
버킷 타입(DAILY/WEEKLY/MONTHLY)은 헤더행 일자 4칸(ATTRIBUTE14~17)의 **간격**으로 정한다.
그런데 종전 식은 다음 두 가지에 걸린다.

    (a) 행 채택 조건   : REGEXP_LIKE(Z.ATTRIBUTE15, '^[0-9.eE+-]+$')
        → 셀 문자열이 '2026-08-10' / '2026-08-10 00:00:00' 처럼 **날짜 서식**이면 탈락.
          채택 행이 0건이 되면 `UPLOAD_BUCKET_TYPE IN (빈 집합)` → NOT EXISTS 성립 → **전건 ERROR**.
    (b) 값 변환        : TO_DATE(TO_CHAR(TO_NUMBER(Z.ATTRIBUTEnn)), 'YYYYMMDD')
        → `TO_NUMBER` 는 **NLS_NUMERIC_CHARACTERS** 에 의존한다. 엑셀 숫자셀이 '20260803.0' 로
          들어오는데 소수점 문자가 ','인 DB 라면 ORA-01722. 사내는 '.,' 라 통과, 클라우드가 다르면 실패.

사내 실측(2026-08-23): NLS_NUMERIC_CHARACTERS='.,' / 헤더 셀 '20260803' 순수 8자리 → 그래서 사내만 정상.

## 정정 — 서식·NLS 무관 정규화
숫자만 뽑아 앞 8자리를 취한다. `'2026-08-10'` · `'20260810.0'` · `'2.026081E7'` · 공백 포함 모두 동일 결과.

    TO_DATE(CASE WHEN LENGTH(REGEXP_REPLACE(TRIM(x),'[^0-9]','')) >= 8
                 THEN SUBSTR(REGEXP_REPLACE(TRIM(x),'[^0-9]',''),1,8) END, 'YYYYMMDD')

8자리 미만이면 NULL → 기존 NVL 폴백 사슬이 그대로 다음 간격을 쓴다(동작 보존).
행 채택 조건도 같은 기준(숫자 8자리 이상)으로 바꿔 날짜 서식 헤더를 받아들인다.

마커 `[E20260823-BUCKETNLS]`. 대상 = `P_DMF0014_CUST_FCST_EXCEL_UPLOAD` 1지점 (배선 제외 `_SM` 은 미적용).

실행: python apply.py   (점검만: --dry)
"""
import pathlib
import re
import sys

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb  # noqa: E402
from ora import conn_info  # noqa: E402

HERE = pathlib.Path(__file__).resolve().parent
DRY = "--dry" in sys.argv
MARK = "E20260823-BUCKETNLS"

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0014' "
            "AND TYPE='PACKAGE BODY' ORDER BY LINE")
body = "".join(t for (t,) in cur if t is not None)
print(f"[1] 현행 BODY {body.count(chr(10)) + 1}줄")
if MARK in body:
    sys.exit(f"⛔ 이미 적용됨 ({MARK})")

lines = body.split("\n")
idx = [i for i, l in enumerate(lines) if "TO_DATE(TO_CHAR(TO_NUMBER(" in l]
print(f"[2] 취약 식 보유 행 {len(idx)}개 → {[i + 1 for i in idx]}")
if len(idx) != 1:
    sys.exit("⛔ 예상(1행)과 다르다 — 본문 변경됨. 수동 확인 필요")
target = idx[0]
old_line = lines[target]

# 채택 조건(같은 서브쿼리) 행 찾기 — REGEXP_LIKE(Z.ATTRIBUTE15 ...)
cond = [i for i, l in enumerate(lines) if "REGEXP_LIKE(Z.ATTRIBUTE15" in l]
print(f"[3] 행 채택 조건 보유 행 {len(cond)}개 → {[i + 1 for i in cond]}")
if len(cond) != 1:
    sys.exit("⛔ 채택 조건 행을 특정하지 못함")


def norm(attr: str) -> str:
    """서식·NLS 무관 8자리 일자 추출."""
    raw = f"REGEXP_REPLACE(TRIM(Z.{attr}),'[^0-9]','')"
    return f"TO_DATE(CASE WHEN LENGTH({raw}) >= 8 THEN SUBSTR({raw},1,8) END,'YYYYMMDD')"


new_expr = (
    "                        AND    D.UPLOAD_BUCKET_TYPE IN ("
    "SELECT CASE (NVL(NVL(" + norm("ATTRIBUTE16") + " - " + norm("ATTRIBUTE15") + ", "
    + norm("ATTRIBUTE15") + " - " + norm("ATTRIBUTE14") + "), "
    + norm("ATTRIBUTE17") + " - " + norm("ATTRIBUTE16") + "))"
    "  /* [E20260823-BUCKETNLS] 헤더 일자 = 숫자만 추출한 앞 8자리로 판정. 구식 TO_DATE(TO_CHAR(TO_NUMBER(x)))"
    " 는 NLS_NUMERIC_CHARACTERS 에 의존해(엑셀 '20260803.0' → 소수점 문자가 ','인 DB 에서 ORA-01722)"
    " 클라우드에서만 깨졌다. 날짜서식('2026-08-10')·과학표기·공백도 같은 값으로 수렴한다."
    " 8자리 미만이면 NULL → 기존 NVL 폴백이 다음 간격을 쓴다(동작 보존). */"
)
lines[target] = new_expr + old_line[old_line.index("  /* [BUCKET FIX 07-08]"):] \
    if "  /* [BUCKET FIX 07-08]" in old_line else new_expr

old_cond = lines[cond[0]]
new_cond = old_cond.replace(
    "REGEXP_LIKE(Z.ATTRIBUTE15, '^[0-9.eE+-]+$')",
    "LENGTH(REGEXP_REPLACE(TRIM(Z.ATTRIBUTE15),'[^0-9]','')) >= 8"
    "  /* [E20260823-BUCKETNLS] 날짜서식 헤더('2026-08-10')도 채택 — 구 정규식은 숫자문자만 허용해"
    "     클라우드에서 채택 0건 → 빈 IN 집합 → 전건 'Invalid Measure Upload Bucket' 이 됐다 */")
if new_cond == old_cond:
    sys.exit("⛔ 채택 조건 치환 실패 (원문 불일치)")
lines[cond[0]] = new_cond

body2 = "\n".join(lines)
print(f"[4] 패치 후 {body2.count(chr(10)) + 1}줄 / 마커 {body2.count(MARK)}회 (기대 2)")

stamp = cur.execute("SELECT TO_CHAR(SYSDATE,'YYYYMMDD_HH24MISS') FROM DUAL").fetchone()[0]
(HERE / f"BACKUP_PKG_DMF0014_BODY_{stamp}.sql").write_text(
    "CREATE OR REPLACE " + body + "\n/\n", encoding="utf-8")
(HERE / "PREVIEW_PKG_DMF0014_BODY.sql").write_text(
    "CREATE OR REPLACE " + body2 + "\n/\n", encoding="utf-8")
print(f"[5] 백업/미리보기 기록 (stamp {stamp})")

if DRY:
    print("\n(dry) 적용하지 않음")
    con.close()
    sys.exit(0)

cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 120")
cur.execute("CREATE OR REPLACE " + body2)
cur.execute("""SELECT STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR'
                AND OBJECT_NAME='PKG_DMF0014' AND OBJECT_TYPE='PACKAGE BODY'""")
st = cur.fetchone()[0]
print(f"[6] 컴파일 STATUS = {st}")
if st != "VALID":
    cur.execute("""SELECT LINE, POSITION, TEXT FROM ALL_ERRORS
                    WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0014' ORDER BY SEQUENCE""")
    for ln, pos, txt in cur.fetchall()[:8]:
        print(f"    {ln}:{pos} {txt}")
    sys.exit("⛔ INVALID — 백업으로 원복")
con.commit()
con.close()
print("\n적용 완료")
