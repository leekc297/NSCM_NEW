# -*- coding: utf-8 -*-
"""[E20261006-ASISDELTA] PKG_DMF0004.P_DMF0004_SAVE_SALES_SITE_DATA 저장 실행 검증

저장 SP 는 내부 COMMIT 을 한다. 그래서 실제 화면에 나오지 않는 시험 전용 키만 쓴다.
  · 키 = DIVISION_ID 'ZZ' (실사업부 아님 — 어떤 화면 조회에도 걸리지 않는다) + SCM_SITE_ID 'ZZTEST_ASISDELTA_%'
  · 호출 직전 assert: SCM_MST_SITE / SCM_MST_SITE_H / SCM_MST_SITE_CUSTOMER 에 DIVISION_ID='ZZ' 0건
  · VALID_YN='Y' 로만 저장 (N 이면 고객 일괄 비활성·공용 이력 SP 를 탄다 — 시험 범위 밖)
  · 종료 시(성공·실패 모두) DIVISION_ID='ZZ' 행만 삭제하고 0건 확인
  python t04_test.py
"""
import io, json, os, sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
DIV, S1, S2, USER = "ZZ", "ZZTEST_ASISDELTA_1", "ZZTEST_ASISDELTA_2", "minyonglee1"
TABLES = ("SCM_MST_SITE", "SCM_MST_SITE_H", "SCM_MST_SITE_CUSTOMER")
results = []


def count_zz(cur):
    out = {}
    for t in TABLES:
        cur.execute(f"SELECT COUNT(*) FROM SCM_MGR.{t} WHERE DIVISION_ID = :d", d=DIV)
        out[t] = cur.fetchone()[0]
    return out


def row(site, crud, **extra):
    r = {"CRUD_TYPE": crud, "DIVISION_ID": DIV, "SCM_SITE_ID": site, "END_CUSTOMER": "ZZTEST", "SOLDTO_CUSTOMER": "ZZTEST",
         "CITY": "ZZ999", "COUNTRY": "ZZ", "VMI_YN": "N", "VALID_YN": "Y", "COMPANY_ID": "ZZTEST", "SHIP_PLAN_AUTO": "N"}
    r.update(extra)
    return r


def save(con, rows):
    cur = con.cursor()
    rc = con.cursor()
    data = cur.var(oracledb.DB_TYPE_CLOB)
    data.setvalue(0, json.dumps(rows, ensure_ascii=False))
    cur.callproc("SCM_MGR.PKG_DMF0004.P_DMF0004_SAVE_SALES_SITE_DATA", [data, USER, rc])
    return tuple(rc.fetchone())


def site(cur, s):
    cur.execute("SELECT ATTRIBUTE3, ATTRIBUTE5, ATTRIBUTE2, VMI_YN, VALID_YN, COMPANY_ID, SITE_TYPE, END_CUSTOMER, CITY "
                "FROM SCM_MGR.SCM_MST_SITE WHERE DIVISION_ID = :d AND SCM_SITE_ID = :s", d=DIV, s=s)
    return cur.fetchone()


def check(name, got, want):
    ok = got == want
    results.append({"case": name, "ok": ok, "got": repr(got), "want": repr(want)})
    print("PASS" if ok else "FAIL", "|", name, "|", got, "" if ok else f"(기대 {want})")


def main():
    u, p, d = conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d)
    cur = con.cursor()
    before = count_zz(cur)
    assert all(v == 0 for v in before.values()), f"시험 키가 이미 있음 — 중단 {before}"
    cur.execute("SELECT COUNT(*) FROM SCM_MGR.SCM_MST_SITE")
    total_before = cur.fetchone()[0]
    try:
        # T1 신규 — 값 앞뒤 공백 → TRIM 저장 (AS-IS L229-230·L242 / L457-458·L479-480)
        r = save(con, [row(S1, "I", DISTRIBUTION_CHANNEL="  50 ", ATTRIBUTE5=" 7  ")])
        check("T1 신규 저장 결과", r[:2], ("0", "SUCCESS"))
        check("T1 신규: ATTRIBUTE3/5 TRIM 저장 · 기존 컬럼 정상", site(cur, S1),
              ("50", "7", "N", "N", "Y", "ZZTEST", "SALES", "ZZTEST", "ZZ999"))
        # T2 수정 — 페이로드에 두 키가 없음 → 기존 값 유지 (TO-BE 방어)
        r = save(con, [row(S1, "M", VMI_YN="Y")])
        check("T2 키 없는 수정 결과", r[:2], ("0", "SUCCESS"))
        check("T2 키 없는 수정: ATTRIBUTE3/5 유지 · VMI 만 변경", site(cur, S1)[:4], ("50", "7", "N", "Y"))
        # T3 수정 — 새 값 (숫자형 포함) → 그대로 저장 (AS-IS L433-434)
        r = save(con, [row(S1, "M", DISTRIBUTION_CHANNEL="AB", ATTRIBUTE5=0)])
        check("T3 값 변경 결과", r[:2], ("0", "SUCCESS"))
        check("T3 값 변경: ATTRIBUTE3/5 갱신", site(cur, S1)[:2], ("AB", "0"))
        # T4 수정 — 한쪽 키만 있음 → 있는 쪽만 저장
        r = save(con, [row(S1, "M", ATTRIBUTE5="15")])
        check("T4 한쪽 키만: ATTRIBUTE3 유지 · ATTRIBUTE5 갱신", site(cur, S1)[:2], ("AB", "15"))
        # T5 수정 — 키는 있고 값이 null/빈값 → 비움 (AS-IS 는 '' 저장 = Oracle NULL)
        r = save(con, [row(S1, "M", DISTRIBUTION_CHANNEL=None, ATTRIBUTE5="")])
        check("T5 null·빈값 결과", r[:2], ("0", "SUCCESS"))
        check("T5 null·빈값: ATTRIBUTE3/5 비움", site(cur, S1)[:2], (None, None))
        # T6 신규 — 두 키 없음 (화면에서 행 추가한 신규행) → NULL 로 생성
        r = save(con, [row(S2, "I")])
        check("T6 키 없는 신규 결과", r[:2], ("0", "SUCCESS"))
        check("T6 키 없는 신규: ATTRIBUTE3/5 NULL · 기존 컬럼 정상", site(cur, S2),
              (None, None, "N", "N", "Y", "ZZTEST", "SALES", "ZZTEST", "ZZ999"))
        # T7 다건 — 한 번에 2행 (값 있는 행 + 키 없는 행)
        r = save(con, [row(S1, "M", DISTRIBUTION_CHANNEL="X1", ATTRIBUTE5="1"), row(S2, "M")])
        check("T7 다건 결과(처리 행수)", r, ("0", "SUCCESS", "2"))
        check("T7 다건: 1행 갱신", site(cur, S1)[:2], ("X1", "1"))
        check("T7 다건: 2행 유지", site(cur, S2)[:2], (None, None))
        # T8 기존 검증 회귀 — 필수값 누락은 종전대로 오류 반환·미저장
        r = save(con, [row(S1, "M", DISTRIBUTION_CHANNEL="NO", COMPANY_ID=None)])
        check("T8 필수 누락: 오류 코드", r[0], "-1")
        check("T8 필수 누락: 값 미변경", site(cur, S1)[:2], ("X1", "1"))
        # T9 중복 신규 — 종전대로 오류
        r = save(con, [row(S1, "I", DISTRIBUTION_CHANNEL="DUP")])
        check("T9 중복 신규: 오류 코드", r[0], "-1")
        # T10 길이 초과(151자) — 조용히 잘리거나 비워지지 않고 오류가 나야 한다
        try:
            r = save(con, [row(S1, "M", DISTRIBUTION_CHANNEL="L" * 151)])
            check("T10 길이 초과: 오류 발생", "오류 없음 " + str(r), "ORA-12899")
        except oracledb.DatabaseError as e:
            check("T10 길이 초과: 오류 발생", "ORA-12899" if "ORA-12899" in str(e) else str(e)[:120], "ORA-12899")
        check("T10 길이 초과: 값 미변경", site(cur, S1)[:2], ("X1", "1"))
        # 이력 — 성공 저장 8건(T1~T7: 1+1+1+1+1+1+2)마다 행 복사, ATTRIBUTE3/5 포함
        cur.execute("SELECT COUNT(*) FROM SCM_MGR.SCM_MST_SITE_H WHERE DIVISION_ID = :d", d=DIV)
        check("이력 건수", cur.fetchone()[0], 8)
        cur.execute("SELECT COUNT(*) FROM SCM_MGR.SCM_MST_SITE_H WHERE DIVISION_ID = :d AND SCM_SITE_ID = :s "
                    "AND ATTRIBUTE3 = '50' AND ATTRIBUTE5 = '7'", d=DIV, s=S1)
        check("이력에 ATTRIBUTE3/5 기록(T1·T2 = 2건)", cur.fetchone()[0], 2)
    finally:
        con.rollback()
        # 정리 — 시험 키(DIVISION_ID='ZZ')만. 호출 전 0건이었으므로 전부 이 시험이 만든 행이다.
        for t in TABLES:
            cur.execute(f"DELETE FROM SCM_MGR.{t} WHERE DIVISION_ID = :d", d=DIV)
            print("정리", t, cur.rowcount)
        con.commit()
        after = count_zz(cur)
        cur.execute("SELECT COUNT(*) FROM SCM_MGR.SCM_MST_SITE")
        total_after = cur.fetchone()[0]
        check("정리 후 시험 키 잔여 0", after, {t: 0 for t in TABLES})
        check("SCM_MST_SITE 전체 건수 불변", total_after, total_before)
        con.close()
    ok = all(x["ok"] for x in results)
    json.dump({"ok": ok, "results": results}, open(os.path.join(HERE, "_test_result_DMF0004.json"), "w", encoding="utf-8"),
              ensure_ascii=False, indent=1)
    print("\n결과:", "ALL PASS" if ok else "FAIL", f"({sum(x['ok'] for x in results)}/{len(results)})")
    sys.exit(0 if ok else 1)


if __name__ == "__main__":
    main()
