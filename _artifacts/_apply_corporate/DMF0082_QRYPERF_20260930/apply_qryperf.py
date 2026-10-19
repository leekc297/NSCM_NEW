# -*- coding: utf-8 -*-
"""[E20260930-DMF0082QRYPERF] PKG_DMF0082.P_DMF0082_GET_MAIN_DATA 조회 속도개선 — 사내 ZIOUI1 적용.

기준본 = **지금 DB 에서 새로 읽은** PKG_DMF0082 BODY (USER_SOURCE) — 로컬 사본 금지 (hook #152).
패치 = _artifacts/_diagnostics/DMF0082_QRYPERF_20260930/qpt_patches.py (복제본 PKG_DMF0082_QPT 로 검증 완료분 동일 함수)
       적용 범위 = GET_MAIN_DATA 구간만 (타 프로시저 1바이트 불변 — 앵커·건수 assert)
         idx82     : SCM_MST_FUTURE_PRICE 계획구간 읽기 2곳 INDEX(IDX02) — div82 풀스캔 2회 제거
         nostats   : SP 내 DBMS_STATS.GATHER_TABLE_STATS 13건 NULL (수집비용 + 커서무효화 하드파싱 제거)
         vmi82fold : div82 후행 UPDATE 2건 → MF_SP INSERT 흡수 (SET 절 스칼라 서브쿼리 → 선집계 JOIN)
         dedupchk  : 중복제거 안전망 DELETE 를 중복 존재 시에만 실행
FRESH-GATE: 추출 시 LAST_DDL 기록 → 실행 직전 재조회 일치 시에만 CREATE OR REPLACE. 컴파일 오류 시 백업 자동 원복.
산출: 00_BACKUP_PKG_DMF0082_BODY.sql / 01_PKG_DMF0082_BODY_QRYPERF.sql / 99_ROLLBACK_PKG_DMF0082_BODY.sql
사용: python apply_qryperf.py build   (파일만 생성)
      python apply_qryperf.py apply   (생성 + 사내 적용)
"""
import datetime, io, pathlib, re, sys
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
HERE = pathlib.Path(__file__).resolve().parent
DIAG = HERE.parents[1] / "_diagnostics"
sys.path.insert(0, str(DIAG))
sys.path.insert(0, str(DIAG / "DMF0082_QRYPERF_20260930"))
from ora import conn_info
import oracledb
import qpt_patches

MODE = sys.argv[1] if len(sys.argv) > 1 else "build"
MARK = "E20260930-DMF0082QRYPERF"
u, p, d = conn_info()
cn = oracledb.connect(user=u, password=p, dsn=d)
cur = cn.cursor()


def last_ddl():
    cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM USER_OBJECTS "
                "WHERE OBJECT_NAME='PKG_DMF0082' AND OBJECT_TYPE='PACKAGE BODY'")
    return cur.fetchone()[0]


def fetch_body():
    cur.execute("SELECT TEXT FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' ORDER BY LINE")
    return "".join(t or "" for (t,) in cur)


ddl0 = last_ddl()
src = fetch_body()
now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
assert MARK not in src, "이미 적용된 원문 — 재적용 금지(멱등 가드)"

# GET_MAIN_DATA 구간 분리
m1 = re.search(r"(?m)^PROCEDURE P_DMF0082_GET_MAIN_DATA\s*$", src)
m2 = re.search(r"(?m)^PROCEDURE ", src[m1.end():])
head, proc, tail = src[:m1.start()], src[m1.start():m1.end() + m2.start()], src[m1.end() + m2.start():]
orig_proc = proc
counts = []
for fn in ("idx82", "nostats", "vmi82fold", "dedupchk"):
    proc, n = getattr(qpt_patches, fn)(proc)
    counts.append(f"{fn}:{n}")
assert counts == ["idx82:2", "nostats:13", "vmi82fold:6", "dedupchk:1"], counts
proc = proc.replace("[QPT-", f"[{MARK}-")
proc = proc.replace("QPT-NOSTATS", f"{MARK}-NOSTATS")
assert "QPT" not in proc.replace("V_QPT_DUP_CNT", ""), "QPT 표식 잔존"
hist_anchor = " * 2026.01.30       jssbae       [E20260130-001907]_FCST&PRICE MGMT Cutoff 버전 조회 대상 테이블 변경\n"
assert proc.count(hist_anchor) == 1
proc = proc.replace(hist_anchor, hist_anchor +
    f" * 2026.09.30       admin        [{MARK}] 조회 속도개선: FUTURE_PRICE IDX02 지정(82 풀스캔 제거) / SP 내 GTT 통계수집 13건 제거 /\n"
    f" *                               82 후행 UPDATE 2건 INSERT 흡수 / 중복제거 안전망 조건부 실행 (결과 전행 동일 검증)\n")
new_src = head + proc + tail
assert head + orig_proc + tail == src
print(f"기준본 LAST_DDL={ddl0}  패치 {counts}  GET_MAIN_DATA {len(orig_proc):,}B → {len(proc):,}B  (타 구간 불변)")

stamp = f"-- SOURCE-FRESH: SCM_MGR.PKG_DMF0082 PACKAGE BODY LAST_DDL={ddl0} FETCHED={now} DB=ZIOUI1\n"
(HERE / "00_BACKUP_PKG_DMF0082_BODY.sql").write_text(
    stamp + "-- 적용 전 원문 백업 (USER_SOURCE 그대로)\nCREATE OR REPLACE " + src.rstrip() + "\n/\n", encoding="utf-8")
(HERE / "99_ROLLBACK_PKG_DMF0082_BODY.sql").write_text(
    stamp + f"-- [{MARK}] 원복 = 적용 전 원문 재컴파일\nCREATE OR REPLACE " + src.rstrip() + "\n/\n", encoding="utf-8")
(HERE / "01_PKG_DMF0082_BODY_QRYPERF.sql").write_text(
    stamp + f"-- [{MARK}] PKG_DMF0082 BODY 전체본 (GET_MAIN_DATA 만 변경)\nCREATE OR REPLACE " + new_src.rstrip() + "\n/\n",
    encoding="utf-8")
print("파일 생성 완료")

if MODE == "apply":
    # FRESH-GATE — 실행 직전 원문 재조회 일치 확인
    assert last_ddl() == ddl0 and fetch_body() == src, "FRESH-GATE: 추출 이후 PKG_DMF0082 변경됨 — 중단"
    cur.execute("CREATE OR REPLACE " + new_src.rstrip())
    cur.execute("SELECT STATUS FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082' AND OBJECT_TYPE='PACKAGE BODY'")
    st = cur.fetchone()[0]
    cur.execute("SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' ORDER BY SEQUENCE")
    errs = cur.fetchall()
    print(f"적용 결과 STATUS={st} 오류={len(errs)}  LAST_DDL={last_ddl()}")
    if st != "VALID" or errs:
        for e in errs[:20]:
            print("  ERR", e)
        cur.execute("CREATE OR REPLACE " + src.rstrip())
        cur.execute("SELECT STATUS FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082' AND OBJECT_TYPE='PACKAGE BODY'")
        print("⚠ 컴파일 실패 → 백업 원복 STATUS=", cur.fetchone()[0])
        sys.exit(1)
    assert MARK in fetch_body()
    print("적용 완료 — 마커 확인")
cn.close()
