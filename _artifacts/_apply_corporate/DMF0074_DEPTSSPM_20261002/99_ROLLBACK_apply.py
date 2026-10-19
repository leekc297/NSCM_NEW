"""[E20261002-DEPTSSPM] 원복 — 사용자 지시(2026-10-02): "DMF0074 EXCEL UPLOAD 시 DEPT_ID 넣는 작업은 취소. 원복"

방식: 지금 DB 원문(ALL_SOURCE)을 새로 읽어 그 위에서 DEPTSSPM 5지점만 역치환한다 (백업 파일 통째 덮어쓰기 아님 —
      적용 이후 타 작업자 변경이 있어도 보존). DB 원문이 적용본과 동일하면 결과 == 00_BACKUP 임을 추가 assert.
"""
import sys, os, hashlib
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import build_apply as B

HERE = B.HERE
M = B.MARK


def rev1(src, new, old, what):
    n = src.count(new)
    if n != 1:
        sys.exit(f"ABORT: {what} 일치 {n}회 (1회여야 함)")
    return src.replace(new, old)


def untransform(src):
    if src.count(M) != 5:
        sys.exit(f"ABORT: 마커 {src.count(M)}개 (5개여야 함) — 이미 원복됐거나 원문 변경")
    v = B.sspm_view("        ")
    src = rev1(src, "        USING " + v + "\n", "        USING SCM_MGR.GT_DM74_TMP_METAL_LINK_PRICE B\n", "MERGE USING")
    src = rev1(src, f"                ,A.DEPT_ID                = CASE WHEN B.DEPT_ID = '-' THEN A.DEPT_ID ELSE B.DEPT_ID END /*{M} 기존 행도 SSPM DEPT_ID 로 (SSPM 미등록이면 유지)*/\n", "", "MATCHED DEPT_ID")
    src = rev1(src, f"\n                --,B.DEPT_ID\n                , B.DEPT_ID /*{M} AS-IS 공백저장('-') → SSPM DEPT_ID*/\n",
               "\n                --,B.DEPT_ID\n                , '-'\n", "MERGE INSERT VALUES")
    src = rev1(src, f"\n              --,B.DEPT_ID\n              , B.DEPT_ID /*{M} AS-IS 공백저장('-') → SSPM DEPT_ID*/\n",
               "\n              --,B.DEPT_ID\n              , '-'\n", "_H SELECT")
    src = rev1(src, "        FROM " + v + ";\n", "        FROM SCM_MGR.GT_DM74_TMP_METAL_LINK_PRICE B;\n", "_H FROM")
    assert M not in src
    return src


with B.connect() as con:
    cur = con.cursor()
    base = B.read_source(cur)
    print("NOW", base["last_ddl"], base["md5"], "marker", base["src"].count(M))
    restored = untransform(base["src"])
    applied = B.strip(open(os.path.join(HERE, "01_PKG_DMF0074_BODY.sql"), encoding="utf-8").read())[len("CREATE OR REPLACE "):]
    backup = B.strip(open(os.path.join(HERE, "00_BACKUP_PKG_DMF0074_BODY.sql"), encoding="utf-8").read())[len("CREATE OR REPLACE "):]
    same_as_applied = base["src"].rstrip() == applied.rstrip()
    print("DB==적용본", same_as_applied, "/ 원복본==00_BACKUP", restored.rstrip() == backup.rstrip())
    if same_as_applied:
        assert restored.rstrip() == backup.rstrip(), "역치환 결과가 백업과 다름"
    # FRESH-GATE: 적용 직전 DB 원문 재조회 == 방금 읽은 기준본
    now = B.read_source(cur)
    if now["md5"] != base["md5"] or now["last_ddl"] != base["last_ddl"]:
        sys.exit("FRESH-GATE FAIL")
    print("FRESH-GATE PASS")
    cur.execute(B.ddl_text(restored).rstrip())
    cur.execute("SELECT object_type, status, TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') FROM user_objects WHERE object_name=:n ORDER BY 1", n=B.PKG)
    for r in cur:
        print("  ", r)
    cur.execute("SELECT COUNT(*) FROM user_errors WHERE name=:n", n=B.PKG)
    print("USER_ERRORS", cur.fetchone()[0])
    after = B.read_source(cur)
    print("DB==00_BACKUP", after["src"].rstrip() == backup.rstrip(), "marker", after["src"].count(M),
          "md5", hashlib.md5(after["src"].encode("utf-8")).hexdigest())
    cur.execute("SELECT COUNT(*) FROM all_objects WHERE owner='SCM_MGR' AND status='INVALID'")
    print("SCM_MGR INVALID objects", cur.fetchone()[0])
