# -*- coding: utf-8 -*-
"""[E20261012-DMF0082LATFIX] PKG_DMF0082.P_DMF0082_GET_MAIN_DATA MF_SP INSERT 의 VD 인라인뷰 lateral 해소 — 사내 ZIOUI1 적용.

기준본 = **지금 DB 에서 새로 읽은** PKG_DMF0082 BODY (USER_SOURCE) — 로컬 사본 금지 (hook #152). 10-12 당일 AJS 활성 수정(09:52) 위에 외과 치환.
패치 = _artifacts/_diagnostics/DMF0082_LATFIX_20261012/latfix_patches.py (복제본 PKG_DMF0082_LFT 로 6커서 동등성 검증 완료분 동일 함수)
       적용 범위 = GET_MAIN_DATA 구간 1곳 (타 프로시저 1바이트 불변 — 앵커·건수 assert)
FRESH-GATE: 추출 시 LAST_DDL 기록 → 실행 직전 원문 재조회 일치 시에만 CREATE OR REPLACE. 컴파일 오류 시 백업 자동 원복.
산출: 00_BACKUP_PKG_DMF0082_BODY.sql / 01_PKG_DMF0082_BODY_LATFIX.sql / 99_ROLLBACK_PKG_DMF0082_BODY.sql
사용: python apply_latfix.py build   (파일만 생성)
      python apply_latfix.py apply   (생성 + 사내 적용)
"""
import datetime, io, pathlib, re, sys
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace", line_buffering=True)
HERE = pathlib.Path(__file__).resolve().parent
DIAG = HERE.parents[1] / "_diagnostics"
sys.path.insert(0, str(DIAG))
sys.path.insert(0, str(DIAG / "DMF0082_LATFIX_20261012"))
from ora import conn_info
import oracledb
import latfix_patches

MODE = sys.argv[1] if len(sys.argv) > 1 else "build"
MARK = latfix_patches.MARK
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

m1 = re.search(r"(?m)^PROCEDURE P_DMF0082_GET_MAIN_DATA\s*$", src)
m2 = re.search(r"(?m)^PROCEDURE ", src[m1.end():])
head, proc, tail = src[:m1.start()], src[m1.start():m1.end() + m2.start()], src[m1.end() + m2.start():]
orig_proc = proc
proc, n = latfix_patches.latfix(proc)
assert n == 1
hist_anchor = " * 2026.01.30       jssbae       [E20260130-001907]_FCST&PRICE MGMT Cutoff 버전 조회 대상 테이블 변경\n"
assert proc.count(hist_anchor) == 1, "History 앵커 매칭 != 1"
proc = proc.replace(hist_anchor, hist_anchor +
    f" * 2026.10.12       admin        [{MARK}] MF_SP INSERT 의 VD(SCM_MST_SITE 82 선집계) 인라인뷰 ON 절 바인드 조건을 뷰 안으로 이동 —\n"
    f" *                               lateral(VW_LAT) 행별 MERGE JOIN OUTER 제거 (hook #129 1순위 · 6커서 전행 동일 검증)\n")
new_src = head + proc + tail
assert head + orig_proc + tail == src
print(f"기준본 LAST_DDL={ddl0}  패치 latfix:{n}  GET_MAIN_DATA {len(orig_proc):,}B → {len(proc):,}B  (타 구간 불변)")

stamp = f"-- SOURCE-FRESH: SCM_MGR.PKG_DMF0082 PACKAGE BODY LAST_DDL={ddl0} FETCHED={now} DB=ZIOUI1\n"
bk = HERE / "00_BACKUP_PKG_DMF0082_BODY.sql"
assert not bk.exists() or MODE == "build", "백업 파일이 이미 존재 — 덮어쓰기 금지(적용 전 원본 보존)"
bk.write_text(stamp + "-- 적용 전 원문 백업 (USER_SOURCE 그대로)\nCREATE OR REPLACE " + src.rstrip() + "\n/\n", encoding="utf-8")
(HERE / "99_ROLLBACK_PKG_DMF0082_BODY.sql").write_text(
    stamp + f"-- [{MARK}] 원복 = 적용 전 원문 재컴파일\nCREATE OR REPLACE " + src.rstrip() + "\n/\n", encoding="utf-8")
(HERE / "01_PKG_DMF0082_BODY_LATFIX.sql").write_text(
    stamp + f"-- [{MARK}] PKG_DMF0082 BODY 전체본 (GET_MAIN_DATA VD 인라인뷰 1곳 + History 2줄만 변경)\nCREATE OR REPLACE " + new_src.rstrip() + "\n/\n",
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
    after = fetch_body()
    # 마커 문자열은 VD 1줄 + History 첫 줄 = 2곳 (History 둘째 줄은 마커 없음). USER_SOURCE 는 끝 개행이 없어 rstrip 비교.
    assert after.count(MARK) == 2 and after.rstrip() == new_src.rstrip(), "적용본 != DB 원문"
    cur.execute("SELECT COUNT(*) FROM USER_OBJECTS WHERE STATUS<>'VALID' AND OBJECT_NAME IN (SELECT NAME FROM USER_DEPENDENCIES WHERE REFERENCED_NAME='PKG_DMF0082')")
    print("의존 INVALID:", cur.fetchone()[0])
    print("적용 완료 — 마커 2곳(VD 1 + History 1) 확인")
cn.close()
