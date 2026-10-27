"""[E20261026-DMF0082-MKTAMTAUDIT] DMF0082 조회 — MKT FCST 금액 메저(MKT_AMT_KRW / MKT_AMT_LOC) 의
LAST UPDATE DATE · LAST UPDATED BY 공란 보완 (사용자 신고 2026-10-26)

원인: 81 계열 금액 arm 4곳이 CREATE_DATE / LAST_UPDATED_BY 를 NULL 로 고정 적재
      (P_DMF0082_GET_MAIN_DATA 3곳 = Current·MF·SF 버전 / P_DMF0082_GET_MAIN_DATA_CURRENT 1곳)
조치: 다른 수요 메저와 같은 규칙 — 원천 원장(DM_PLN_SALES_PLAN / _C) 행의
      MAX(CREATION_DATE) · 그 시점의 LAST_UPDATED_BY 를 키·일자 단위로 집계해 채운다 (최종 출력은 기존 윈도 MAX 그대로).
방식: 사내 DB 최신 원문(USER_SOURCE) 기준 외과 치환 · 각 지점 매칭 수 assert · 적용 직전 FRESH-GATE 재조회 비교

  python apply_mktamt_audit.py dry     # 원문 조회 → 치환본 생성·diff 출력 (DB 무변경)
  python apply_mktamt_audit.py apply   # FRESH-GATE 통과 시 CREATE OR REPLACE + 컴파일 검증
"""
import sys, os, re, io, difflib, datetime
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
MARK = "E20261026-DMF0082-MKTAMTAUDIT"
NAME, TYPE = "PKG_DMF0082", "PACKAGE BODY"
AGG = ", MAX(S.CREATION_DATE) AS CREATE_DATE, MAX(S.LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY S.CREATION_DATE) AS LAST_UPDATED_BY  --[" + MARK + "]"


def fetch(cur):
    cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'), STATUS FROM USER_OBJECTS WHERE OBJECT_NAME=:n AND OBJECT_TYPE=:t", n=NAME, t=TYPE)
    meta = cur.fetchone()
    cur.execute("SELECT TEXT FROM USER_SOURCE WHERE NAME=:n AND TYPE=:t ORDER BY LINE", n=NAME, t=TYPE)
    return "".join(r[0] for r in cur.fetchall()), meta


def transform(src):
    if MARK in src:
        raise SystemExit("ABORT: 이미 적용된 원문 (마커 존재)")
    L = src.split("\n")
    # ① 단일 줄 NULL (GET_MAIN_DATA 3곳)
    one = [i for i, l in enumerate(L) if re.fullmatch(r"\s*, NULL AS CREATE_DATE, NULL AS LAST_UPDATED_BY\s*", l)]
    # ② 두 줄 NULL (GET_MAIN_DATA_CURRENT 1곳)
    two = [i for i, l in enumerate(L[:-1]) if re.fullmatch(r"\s*, NULL AS CREATE_DATE\s*", l) and re.fullmatch(r"\s*, NULL AS LAST_UPDATED_BY\s*", L[i + 1])]
    if len(one) != 3 or len(two) != 1:
        raise SystemExit(f"ABORT: NULL 지점 매칭 단일줄={len(one)}(기대 3) 두줄={len(two)}(기대 1)")
    edits = []
    for i in one + two:
        # 해당 arm 의 원천 서브쿼리: 아래 20줄 안의 SUM(S.QTY) AS QTY + 바로 다음 FROM 이 DM_PLN_SALES_PLAN(_C) S
        j = next((k for k in range(i, min(i + 20, len(L))) if re.search(r"SUM\(S\.QTY\) AS QTY\s*$", L[k])), None)
        if j is None or not re.search(r"FROM\s+SCM_MGR\.DM_PLN_SALES_PLAN(_C)?\s+S\s*$", L[j + 1]):
            raise SystemExit(f"ABORT: 줄 {i+1} 원천 서브쿼리 미확인")
        # 원천 서브쿼리 안에 MKT_AMT 필터가 있어야 금액 arm
        if not any("S.MEASURE IN ('MKT_AMT_KRW', 'MKT_AMT_LOC')" in L[k] for k in range(j, j + 6)):
            raise SystemExit(f"ABORT: 줄 {i+1} 금액 arm 아님")
        edits.append((i, j))
    for i, j in edits:
        if i in one:
            ind = re.match(r"\s*", L[i]).group(0)
            L[i] = f"{ind}, A.CREATE_DATE, A.LAST_UPDATED_BY  --[{MARK}] 원천 행 수정 정보 (구: NULL AS CREATE_DATE, NULL AS LAST_UPDATED_BY)"
        else:
            ind = re.match(r"\s*", L[i]).group(0)
            L[i] = f"{ind}, A.CREATE_DATE  --[{MARK}] 구: NULL AS CREATE_DATE"
            L[i + 1] = f"{ind}, A.LAST_UPDATED_BY  --[{MARK}] 구: NULL AS LAST_UPDATED_BY"
        L[j] = L[j].rstrip() + AGG
    return "\n".join(L), [i + 1 for i, _ in edits]


def ddl(text):
    return "CREATE OR REPLACE " + text.rstrip()


def main(mode):
    u, p, d = conn_info()
    cn = oracledb.connect(user=u, password=p, dsn=d)
    cur = cn.cursor()
    base, meta = fetch(cur)
    fetched = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
    print(f"원문 조회: {NAME} {TYPE} LAST_DDL={meta[0]} STATUS={meta[1]} 줄수={base.count(chr(10))+1} FETCHED={fetched}")
    new, at = transform(base)
    os.makedirs(HERE, exist_ok=True)
    stamp = f"-- SOURCE-FRESH: SCM_MGR.{NAME} {TYPE} LAST_DDL={meta[0]} FETCHED={fetched} DB=ZIOUI1\n"
    open(os.path.join(HERE, f"00_BACKUP_{NAME}.ASIS.sql"), "w", encoding="utf-8").write(stamp + ddl(base) + "\n/\n")
    open(os.path.join(HERE, f"01_NEW_{NAME}_BODY.sql"), "w", encoding="utf-8").write(stamp + "-- [" + MARK + "] 금액 arm 4곳 수정 정보 채움\n" + ddl(new) + "\n/\n")
    diff = list(difflib.unified_diff(base.split("\n"), new.split("\n"), lineterm="", n=0))
    print(f"수정 지점(원문 줄): {at} · diff 줄 {len([x for x in diff if x[:1] in '+-' and x[:3] not in ('+++','---')])}")
    for x in diff:
        if x.startswith(("+", "-")) and not x.startswith(("+++", "---")):
            print("   ", x[:200])
    if mode != "apply":
        print("DRY — DB 무변경"); return
    # FRESH-GATE: 적용 직전 재조회 == 착수 기준본
    now, meta2 = fetch(cur)
    if now != base:
        raise SystemExit("FRESH-GATE 실패: 착수 후 DB 원문 변경 — 중단·재조회·재병합")
    print("FRESH-GATE 통과 (적용 직전 원문 == 착수 기준본)")
    cur.execute(ddl(new))
    cur.execute("SELECT STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM USER_OBJECTS WHERE OBJECT_NAME=:n AND OBJECT_TYPE=:t", n=NAME, t=TYPE)
    st = cur.fetchone()
    cur.execute("SELECT COUNT(*) FROM USER_ERRORS WHERE NAME=:n AND TYPE=:t", n=NAME, t=TYPE)
    ne = cur.fetchone()[0]
    after, _ = fetch(cur)
    print(f"적용 결과: STATUS={st[0]} LAST_DDL={st[1]} USER_ERRORS={ne} 적용본==DB원문 {after.rstrip()==new.rstrip()}")
    cur.execute("SELECT OBJECT_NAME, OBJECT_TYPE FROM USER_OBJECTS WHERE STATUS='INVALID' AND OBJECT_NAME LIKE '%DMF0082%'")
    print("DMF0082 관련 INVALID:", cur.fetchall())
    cn.close()


if __name__ == "__main__":
    main(sys.argv[1] if len(sys.argv) > 1 else "dry")
