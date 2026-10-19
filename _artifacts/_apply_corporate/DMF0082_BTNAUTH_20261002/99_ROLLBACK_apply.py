"""[E20261002-BTNAUTH] 원복 — P_DMF0082_GET_BUTTON_AUTH 제거 + 호출 등록 4종 삭제

방식: 지금 DB 원문(ALL_SOURCE)을 새로 읽어 그 위에서 추가분만 걷어낸다 (백업 파일 통째 덮어쓰기 아님 —
      적용 이후 타 작업자 변경 보존). BODY → SPEC 순서. 메타는 PK 로 지정 삭제.
  python 99_ROLLBACK_apply.py        # 실행
"""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import build_apply as B

with B.connect() as con:
    cur = con.cursor()
    spec = B.read_source(cur, "PACKAGE")
    body = B.read_source(cur, "PACKAGE BODY")
    if spec["src"].count(B.SPEC_DECL) != 1:
        sys.exit("ABORT: SPEC 선언 위치 특정 불가 (이미 원복됐거나 원문 변경)")
    proc = B.body_proc(B.auth_block(body["src"], B.SP))
    if body["src"].count(proc) != 1:
        sys.exit("ABORT: BODY 프로시저 원문 불일치 (적용 이후 변경됨 — 수동 확인 필요)")
    new_body = body["src"].replace(proc, "")
    new_spec = spec["src"].replace(B.SPEC_DECL, "")
    assert B.SP not in new_body and B.SP not in new_spec
    # FRESH-GATE: 적용 직전 재조회 == 방금 읽은 기준본
    for t, base in (("PACKAGE", spec), ("PACKAGE BODY", body)):
        now = B.read_source(cur, t)
        if now["md5"] != base["md5"] or now["last_ddl"] != base["last_ddl"]:
            sys.exit(f"FRESH-GATE FAIL [{t}]")
    print("FRESH-GATE PASS")
    cur.execute(B.ddl_text(new_body).rstrip())
    cur.execute(B.ddl_text(new_spec).rstrip())
    cur.execute("ALTER PACKAGE SCM_MGR.PKG_DMF0082 COMPILE BODY")
    cur.execute("SELECT object_type, status FROM user_objects WHERE object_name=:n ORDER BY 1", n=B.PKG)
    print(cur.fetchall())
    cur.execute("SELECT COUNT(*) FROM user_errors WHERE name=:n", n=B.PKG)
    print("USER_ERRORS", cur.fetchone()[0])
    for sql in (
        "DELETE FROM scm_adm_user_gr_mnu_btn_mpg_m WHERE mnu_id='DMF0082' AND sht_nm='buttonAuth' AND mnu_btn_cd='SEARCH'",
        "DELETE FROM scm_adm_mnu_btn_mpg_m WHERE mnu_id='DMF0082' AND sht_nm='buttonAuth' AND mnu_btn_cd='SEARCH'",
        "DELETE FROM scm_adm_proc_m WHERE proc_nm='PKG_DMF0082.P_DMF0082_GET_BUTTON_AUTH'",
        "DELETE FROM scm_adm_api_m WHERE api_id='DMF0082_buttonAuth_SEARCH'",
    ):
        cur.execute(sql)
        print("  deleted", cur.rowcount, "|", sql[:60])
    con.commit()
    print("ROLLBACK DONE")
