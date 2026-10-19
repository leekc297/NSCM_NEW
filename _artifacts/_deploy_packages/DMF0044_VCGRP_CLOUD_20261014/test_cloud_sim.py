"""[E20261014-DMF0044VCGRP] 패치 v2 검증 — 사내 DB 에서 "QA 원문 모양" 을 흉내 내 10 · 99 를 실제로 돌려 본다

  python test_cloud_sim.py

QA(2026-10-14 00_PRECHECK L2)에서 확인된 차이를 사내 적용 전 원문(00)에 그대로 입힌다.
  - 대상 16줄의 들여쓰기: 탭 → 공백 4칸
  - 줄 끝 '--  2026.10.11 AJS' 주석 없음
  - 4줄(1 · 2 · 6 · 8번째)은 빈값 표기가 아직 '-' : NVL(A.CURRENCY, '-') · NVL(B.SALES_COMPANY, '-')
순서
  A. 사내 실제 원문: 99 → 10 → (DB == 사내 적용본, 설명 주석 들여쓰기만 제외) → 10(SKIP) → 99 → (DB == 사내 적용 전)
  B. QA 모양 원문을 사내 패키지에 잠시 올림 → 10 → 파싱 점검(같은 계열 0) · 대상 16줄 확인 → 99
  C. 사내 적용본(01)으로 되돌리고 DB == 01 확인  (어느 단계에서 실패해도 C 는 실행한다)
패키지 BODY 를 잠시 바꾸는 테스트다 — 내용은 들여쓰기 · 주석 · 빈값 표기만 다른 같은 코드이고, 끝나면 사내 적용본으로 돌아간다.
"""
import sys, os, re, subprocess
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import build_package as P
import run_rehearsal as R
corp = P.corp
CHECK = r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0044_GRPUPPER_20261014\check_static_sql.py"


def db_src(cur):
    return corp.read_source(cur)["src"].rstrip()


def put(cur, body):
    cur.execute("CREATE OR REPLACE " + body.rstrip() + "\n")
    cur.execute("SELECT status FROM user_objects WHERE object_name='PKG_DMF0044' AND object_type='PACKAGE BODY'")
    st = cur.fetchone()[0]
    assert st == "VALID", st


def run(cur, fname, seq):
    R.run(cur, fname, seq)
    return open(os.path.join(R.OUT, f"{seq:02d}_{fname[:-4]}.out.txt"), encoding="utf-8").read()


def norm(body):
    return "\n".join(l.strip() if P.MARK in l else l for l in body.split("\n"))


def qa_like(old_body):
    seq, _, _, _ = P.derive()
    keys = [s["ko"] for s in seq]
    lines, k, dash = old_body.split("\n"), 0, {1, 2, 6, 8}
    a = old_body[:old_body.index(P.P_START)].count("\n") + 1
    for i in range(a, len(lines)):
        if k < len(keys) and P.key(lines[i]) == keys[k]:
            ln = lines[i].replace("\t", "    ")
            ln = re.sub(r"\s*--\s*2026\.10\.11 AJS\s*$", "", ln)
            if k + 1 in dash:
                ln = re.sub(r"NVL\((A\.CURRENCY|B\.SALES_COMPANY), '/'\)", r"NVL(\1, '-')", ln)
            lines[i] = ln
            k += 1
    assert k == len(keys)
    return "\n".join(lines)


def main():
    old_body, new_body = P.body_of(corp.F_BAK).rstrip(), P.body_of(corp.F_NEW).rstrip()
    con = corp.connect()
    cur = con.cursor()
    cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST'), TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM dual")
    print("DB", cur.fetchone())
    fail = []

    def check(name, ok):
        print("PASS" if ok else "FAIL", "|", name)
        if not ok:
            fail.append(name)

    try:
        # FRESH-GATE: 시작 직전 DB 원문(ALL_SOURCE 재조회) == 사내 적용본(01). 다르면 누군가 바꾼 것이므로 테스트하지 않는다
        assert norm(db_src(cur)) == norm(new_body), "FRESH-GATE FAIL: 시작 상태가 사내 적용본이 아님"
        print("===== A. 사내 실제 원문")
        check("A1 99 원복 메시지", "ROLLED BACK" in run(cur, "99_ROLLBACK_VCGRP_PATCH.sql", 1))
        check("A2 원복 뒤 DB == 사내 적용 전(00)", db_src(cur) == old_body)
        check("A3 10 적용 메시지", "APPLIED" in run(cur, "10_APPLY_VCGRP_PATCH.sql", 2))
        check("A4 적용 뒤 DB == 사내 적용본(01) (설명 주석 들여쓰기 제외)", norm(db_src(cur)) == norm(new_body))
        check("A5 10 재실행 = SKIP", "SKIP" in run(cur, "10_APPLY_VCGRP_PATCH.sql", 3))
        check("A6 99 원복 메시지", "ROLLED BACK" in run(cur, "99_ROLLBACK_VCGRP_PATCH.sql", 4))
        check("A7 원복 뒤 DB == 사내 적용 전(00)", db_src(cur) == old_body)

        print("===== B. QA 모양 원문 (들여쓰기 공백 · AJS 주석 없음 · 4줄 '-')")
        qa = qa_like(old_body)
        check("B0 QA 모양 원문이 사내 적용 전과 다르다(흉내가 들어갔다)", qa != old_body and qa.count("NVL(A.CURRENCY, '-')") >= 3)
        put(cur, qa)
        out = run(cur, "00_PRECHECK_CLOUD.sql", 5)
        check("B1 00 L2 = 16줄 · '-' 4줄", out.count("L2 줄 |") == 16 and out.count("'-')") == 4)
        check("B2 10 적용 메시지", "APPLIED" in run(cur, "10_APPLY_VCGRP_PATCH.sql", 6))
        got = db_src(cur)
        reg = P.region(got)
        check("B3 대상 줄에 '-' · NVL(X, '/') 단독 꼴이 남지 않음",
              all(P.key(l) not in {s["ko"] for s in P.derive()[0]} for l in reg.split("\n")))
        check("B4 들여쓰기 보존 (탭 0 → 대상 줄은 공백 그대로)", sum(1 for l in reg.split("\n") if l.startswith("    ") and "NVL(NULLIF(RTRIM(A.CURRENCY),''), '/'), M.O_MEASURE" in l) >= 3)
        r = subprocess.run([sys.executable, CHECK, "PKG_DMF0044"], capture_output=True, text=True, encoding="utf-8")
        line = next((l for l in r.stdout.split("\n") if "같은 계열 오류" in l), "")
        print("   ", line.strip())
        check("B5 적용 뒤 패키지 파싱 점검: 같은 계열 오류 0건", ": 0 건" in line)
        out = run(cur, "90_VERIFY.sql", 7)
        check("B6 90 V1 PASS · V3 16줄 모두 적용 후 꼴", "V1 마커 | 1 | PASS" in out and out.count("적용 후 꼴") == 16 and "적용 전 꼴" not in out)
        check("B7 99 원복 메시지", "ROLLED BACK" in run(cur, "99_ROLLBACK_VCGRP_PATCH.sql", 8))
        back = db_src(cur)
        check("B8 원복 뒤 = QA 모양 원문에서 '-' 4줄만 '/' 로 바뀐 상태 (알려진 한계)",
              back == re.sub(r"NVL\((A\.CURRENCY|B\.SALES_COMPANY), '-'\)(?=, M\.O_MEASURE, A\.PLANT_SITE_ID, A\.YYYYMMDD\n|\n)", r"NVL(\1, '/')", qa))
    except Exception as e:   # noqa
        fail.append("예외: " + str(e)[:300])
        print("ERROR", str(e)[:300])
    finally:
        print("===== C. 사내 적용본(01)으로 복귀")
        put(cur, new_body)
        ok = db_src(cur) == new_body
        print("PASS" if ok else "FAIL", "| C1 DB == 사내 적용본(01)")
        if not ok:
            fail.append("C1")
    print("RESULT", "PASS" if not fail else "FAIL " + str(fail))
    sys.exit(0 if not fail else 1)


if __name__ == "__main__":
    main()
