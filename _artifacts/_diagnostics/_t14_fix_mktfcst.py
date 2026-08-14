#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""PR_DM_PLN_CUST_FCST_TO_MKT_FCST — 업로드 적재를 롤백시키던 SELECT INTO 2종 정정.

증상(2026-08-14): DMF0014 Excel Upload 저장이 "저장 완료" 를 내면서 원장 0건.
계보: 상위 PKG_DMF0014 가 INSERT 후 이 프로시저를 호출 → 여기서 예외 → 이 프로시저의
      `EXCEPTION WHEN OTHERS THEN ROLLBACK;` 이 **상위의 미커밋 INSERT까지 되돌림** →
      예외를 재발생시키지 않아 상위는 그대로 SUCCESS 반환.

① L1217/L1222 ORA-01422 — `GT_DPCF_MIN_MAX_PSI_2` 초기화 누락
   이 GTT 는 DURATION=SYS$SESSION(ON COMMIT PRESERVE) 인데 INSERT 만 있고 DELETE 가 없다.
   measure 별 커서 루프를 도는 구조라 2번째 measure 부터 행이 누적 → `RN = 1` 이 복수가 되어
   단일행 SELECT INTO 가 깨진다.
   ⇒ 바로 아래 형제 블록(L1233 `DELETE FROM GT_DPCF_TMP_SITE_CUSTOMER_MAP_2;
      /* MEASURE별 cursor 작업이므로 초기화 */`)와 **동일한 패턴으로 초기화**를 넣는다.
   ⚠ MIN()/MAX() 로 바꾸는 우회는 쓰지 않는다 — 그러면 직전 measure 의 잔여 행까지 섞여
      구간이 조용히 틀어진다(오류가 사라질 뿐 결과가 더 나빠진다).

② L926/L941 ORA-01403 — 마스터 미존재 시 핸들러 없음
   `N_VALID_BUCKET_TYPE` 은 L909 에서 NULL 로 초기화되고 L979 에 `IF N_VALID_BUCKET_TYPE IS NULL`
   분기가 이미 있다. 즉 **NULL 은 설계된 정상 경로**이고, 빠진 것은 NO_DATA_FOUND 핸들러뿐이다.
   ⇒ 두 블록에 핸들러를 달아 원래 의도한 NULL 경로로 흐르게 한다.
"""
import io, pathlib, sys
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
from ora import conn_info
import oracledb

OUT = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0014_EXCELFORM_20260814")
NAME = "PR_DM_PLN_CUST_FCST_TO_MKT_FCST"

HANDLER = """                            EXCEPTION
                                /* ⭐ [2026-08-14] 마스터에 해당 주차 bucket 이 없으면 NULL 로 둔다.
                                   N_VALID_BUCKET_TYPE 은 L909 에서 NULL 초기화되고 아래 979행에
                                   `IF N_VALID_BUCKET_TYPE IS NULL` 분기가 이미 있다 = NULL 은 설계된 경로.
                                   핸들러가 없어 ORA-01403 이 위로 튀었고, 이 프로시저의
                                   WHEN OTHERS THEN ROLLBACK 이 **호출자(DMF0014 업로드)의 INSERT까지**
                                   되돌려 "저장 완료인데 0건" 사고가 났다. */
                                WHEN NO_DATA_FOUND THEN
                                    N_VALID_BUCKET_TYPE := NULL;
                                WHEN TOO_MANY_ROWS THEN
                                    /* 마스터가 모호하면 유효 bucket 을 단정하지 않는다(동일 NULL 경로). */
                                    N_VALID_BUCKET_TYPE := NULL;
                            END;"""

RESET = """                DELETE FROM GT_DPCF_MIN_MAX_PSI_2; /* ⭐ [2026-08-14] MEASURE별 cursor 작업이므로 초기화
                   — 이 GTT 는 ON COMMIT PRESERVE 라 지우지 않으면 measure 마다 누적되어
                     아래 `WHERE RN = 1` 이 복수 행을 반환한다(ORA-01422). 형제 블록 L1233 과 동일 패턴. */"""

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("""SELECT LINE, TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:1
               AND TYPE='PROCEDURE' ORDER BY LINE""", [NAME])
rows = cur.fetchall()
lines = [r[1].rstrip("\n") for r in rows]           # 0-based index = LINE-1
print(f"[source] {len(lines)} lines")

def at(line_no):
    return lines[line_no - 1].strip()

# 앵커 실측 검증 — 라인 번호로 손대므로 내용 확인이 필수
assert at(1205) == "BEGIN",  f"L1205={at(1205)!r}"
assert at(1206).startswith("INSERT"), f"L1206={at(1206)!r}"
assert at(938) == "END;",    f"L938={at(938)!r}"
assert at(939) == "ELSE",    f"L939={at(939)!r}"
assert at(952) == "END;",    f"L952={at(952)!r}"
assert at(953) == "END IF;", f"L953={at(953)!r}"
print("[anchor] 3곳 실측 일치")

# 라인 번호가 밀리지 않도록 **뒤에서 앞으로** 적용
lines[1205 - 1] = "BEGIN\n" + RESET          # L1205 BEGIN 직후 초기화 삽입
lines[952 - 1] = HANDLER                      # ELSE 블록
lines[938 - 1] = HANDLER                      # DAILY 블록

src = "\n".join(lines)
stmt = "CREATE OR REPLACE " + src.rstrip()
(OUT / "12_PR_DM_PLN_CUST_FCST_TO_MKT_FCST_SELECTINTO_FIX.sql").write_text(
    "SET DEFINE OFF\n" + stmt + "\n/\n", encoding="utf-8")

cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 120")
cur.execute(stmt)
cur.execute("""SELECT LINE, TEXT FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME=:1
               ORDER BY SEQUENCE""", [NAME])
errs = cur.fetchall()
print(f"[deploy] errors={len(errs)}")
for e in errs[:6]:
    print("   ", e[0], str(e[1])[:130])
cur.execute("""SELECT STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:1""", [NAME])
print(f"[status] {cur.fetchone()[0]}")
con.close()
