"""[E20261013-DMF0082SSPMNEW] 검증 — 영구 테이블 무변경

 T1  검증 문장을 **DB 에 적용된 원문에서 그대로 추출**해, 세션 GTT(GT_PRDM1_T_MAIN)에 가상 입력행을 넣고 실행 (ROLLBACK)
     - 신규 행 + 4키 유효 등록          → 통과
     - 신규 행 + 다른 Project 로만 등록  → 차단 (이번 보완 대상)
     - 신규 행 + 4키는 있으나 VALID_YN=N → 차단
     - 신규 행 + 마스터에 전혀 없음      → 차단
     - 수정('M')·삭제('D') 행 + 4키 없음 → 통과 (신규 행만 대상)
 T2  저장 SP 를 실제 호출 — '다른 Project' 신규 행 1건. 검증에서 막혀 저장되지 않아야 한다.
     호출 전후 원장(수요·판가)에 그 키가 0건임을 확인 (막히지 않으면 FAIL 로 보고하고 넣어진 행을 알린다).

 케이스 키는 실행 시점 마스터에서 고른다.
  python test_sspmnew.py
"""
import sys, io, re
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

MARK = "[E20261013-DMF0082SSPMNEW]"
BAD_PROJECT = "ZZ_SSPMNEW_TEST"


def main():
    u, p, d = conn_info()
    cn = oracledb.connect(user=u, password=p, dsn=d)
    cn.call_timeout = 600000
    cur = cn.cursor()
    cur.execute("SELECT text FROM user_source WHERE name='PKG_DMF0082' AND type='PACKAGE BODY' ORDER BY line")
    body = "".join(r[0] for r in cur)
    i = body.index(MARK)
    m = re.search(r"SELECT 'Project : '.*?FETCH\s+FIRST 1 ROWS ONLY", body[i:], re.S)
    stmt = re.sub(r"INTO\s+v_sspm_new\s+", "", m.group(0))
    print("추출 문장", len(stmt), "자 · 적용본 마커", body.count(MARK))

    # 케이스 키 (40) — 실값 Project 유효 1건(같은 Site-Model 이 빈값 Project 로는 등록되지 않은 것) / 빈값 Project 유효 1건 / 무효 1건
    SENT = "('-','/')"
    cur.execute(f"""SELECT division_id, project_code, scm_site_id, item_id FROM SCM_MST_SITE_ITEM S
                    WHERE division_id='40' AND valid_yn='Y' AND project_code NOT IN {SENT} AND TRIM(project_code) IS NOT NULL
                      AND NOT EXISTS (SELECT 1 FROM SCM_MST_SITE_ITEM X WHERE X.division_id=S.division_id AND X.scm_site_id=S.scm_site_id
                                         AND X.item_id=S.item_id AND X.valid_yn='Y' AND X.project_code IN {SENT})
                    ORDER BY project_code, scm_site_id, item_id FETCH FIRST 1 ROWS ONLY""")
    ok = cur.fetchone()
    cur.execute(f"""SELECT division_id, project_code, scm_site_id, item_id FROM SCM_MST_SITE_ITEM S
                    WHERE division_id='40' AND valid_yn='Y' AND project_code IN {SENT}
                    ORDER BY scm_site_id, item_id FETCH FIRST 1 ROWS ONLY""")
    sent = cur.fetchone()
    cur.execute("""SELECT division_id, project_code, scm_site_id, item_id FROM SCM_MST_SITE_ITEM S
                    WHERE division_id='40' AND valid_yn='N'
                      AND NOT EXISTS (SELECT 1 FROM SCM_MST_SITE_ITEM X WHERE X.division_id=S.division_id
                                         AND X.scm_site_id=S.scm_site_id AND X.item_id=S.item_id AND X.valid_yn='Y')
                    ORDER BY project_code, scm_site_id, item_id FETCH FIRST 1 ROWS ONLY""")
    inv = cur.fetchone()
    print("실값 키", ok, "/ 빈값 Project 키", sent, "/ 무효 키", inv)
    other = "/" if sent[1] == "-" else "-"

    cases = [
        ("신규 + 4키 유효(실값 Project)",        "I", ok[0], ok[1], ok[2], ok[3], False),
        ("신규 + 다른 Project",                  "I", ok[0], BAD_PROJECT, ok[2], ok[3], True),
        ("신규 + Project 빈값(마스터는 실값뿐)", "I", ok[0], "-", ok[2], ok[3], True),
        (f"신규 + 마스터 '{sent[1]}' · 입력 '{sent[1]}'", "I", sent[0], sent[1], sent[2], sent[3], False),
        (f"신규 + 마스터 '{sent[1]}' · 입력 '{other}'",   "I", sent[0], other, sent[2], sent[3], False),
        ("신규 + 4키 있으나 무효",               "I", inv[0], inv[1], inv[2], inv[3], True),
        ("신규 + 마스터에 없음",                 "I", "40", BAD_PROJECT, "ZZ_NO_SITE", "ZZ_NO_ITEM", True),
        ("수정 + 다른 Project",                  "M", ok[0], BAD_PROJECT, ok[2], ok[3], False),
        ("삭제 + 다른 Project",                  "D", ok[0], BAD_PROJECT, ok[2], ok[3], False),
    ]
    all_ok = True
    print("== T1 추출 문장 × 가상 입력행")
    for name, act, div, prj, site, item, expect_block in cases:
        cur.execute("DELETE FROM SCM_MGR.GT_PRDM1_T_MAIN")
        cur.execute("""INSERT INTO SCM_MGR.GT_PRDM1_T_MAIN (ACTION, DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE,
                           INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY_PRICE, CREATED_BY)
                       VALUES (:a, :d, :p, :p, :s, :i, 'E', 'MPS', 'CPT', 'MKT_FCST', '-', '-', TO_CHAR(SYSDATE+7,'YYYYMMDD'), 1, 'test')""",
                    a=act, d=div, p=prj, s=site, i=item)
        cur.execute(stmt)
        r = cur.fetchone()
        blocked = r is not None
        good = blocked == expect_block
        all_ok &= good
        print(f"   {name:34s} → {'차단' if blocked else '통과'} {'OK' if good else 'FAIL'}" + (f"  [{r[0].replace(chr(10), ' / ')}]" if blocked else ""))
    cn.rollback()

    print("== T2 저장 SP 실제 호출 — 신규 행 · 다른 Project (막혀야 함)")
    ymd_sql = "SELECT TO_CHAR(TRUNC(SYSDATE,'IW')+7,'YYYYMMDD') FROM dual"
    cur.execute(ymd_sql)
    ymd = cur.fetchone()[0]
    key = dict(d=ok[0], p=BAD_PROJECT, s=ok[2], i=ok[3])
    cnt_sql = ("SELECT (SELECT COUNT(*) FROM DM_PLN_CFM_MKT_DEMAND_PLAN WHERE division_id=:d AND project_code=:p AND scm_site_id=:s AND item_id=:i) + "
               "(SELECT COUNT(*) FROM DM_PLN_CFM_SELLING_PRICE WHERE division_id=:d AND project_code=:p AND scm_site_id=:s AND item_id=:i) FROM dual")
    cur.execute(cnt_sql, key)
    before = cur.fetchone()[0]
    if before != 0:
        print("   SKIP — 테스트 키가 원장에 이미 존재", before, "(호출하지 않음)")
        all_ok = False
    else:
        rc = cn.cursor()
        cur.callproc("SCM_MGR.PKG_DMF0082.P_DMF0082_SAVE_MAIN_DATA",
                     ["I", ok[0], BAD_PROJECT, BAD_PROJECT, ok[2], ok[3], "E", "MPS", "CPT", "MKT_FCST", "-", "-", ymd, "", "1", "minyonglee1", "", rc])
        cols = [c[0] for c in rc.description]
        row = rc.fetchone()
        res = dict(zip(cols, row)) if row else {}
        msg = str(res.get("RESULT_MSG", "")).replace("\n", " / ")
        print("   결과", res.get("RESULT_CODE"), "|", msg[:200])
        cn.rollback()
        cur.execute(cnt_sql, key)
        after = cur.fetchone()[0]
        hit = "Sales Site Project Model 에 등록되지 않은 조합" in msg
        print(f"   원장 건수 {before} → {after} · 5-1 메시지 {'적중' if hit else '아님(앞선 검증에서 막힘 — 메시지 확인)'}")
        if after != 0:
            print("   !!! FAIL — 막히지 않고 저장됨. 위 키의 행을 정리해야 함:", key)
            all_ok = False
        elif str(res.get("RESULT_CODE")) == "0":
            print("   !!! FAIL — 성공 응답")
            all_ok = False
    print("RESULT", "PASS" if all_ok else "FAIL")


if __name__ == "__main__":
    main()
