#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""_sdm1020_crud_roundtrip_20260819.py — SDM1020 사내 CRUD 왕복 (D3/D12 정정 실증 + 시드 자급 + 전량 정리)

전제: SPMS_PROJECT_MST / SPMS_PROJECT_USER_MAP 재생성 직후 0행 (2026-08-19).
R0 SEED : GET INNER JOIN 8축(DIV/PCL/CLT/SMD/BIZ/USR/DPT/RGS) 전부 통과하는 시드 1+1행 생성
          (lookup 실값: DPJT_CLASS=DEV / CELL_TYPE=PRISM / STACK_METHOD=AZS / BIZ_TYPE=CELL,
           MGMT_USER_ID=minyonglee1(SSO 실존·DEPT LESIC), DIVISION_ID='40', 감사 'admin')
R1 GET  : 기간 NULL + 기간 지정 2케이스 — 시드 조회 + 3상태 체크박스 도메인. 0행 시 조인축 깔때기.
R2 BTN_REQ 'M' 단건 : 신행 REQ_MOD 생성 + 원본 MODIFYING 전이(D3 실증) → 신행 삭제 + 원본 원복
R3 AUTH : 합성 사용자 WRITE 요청 → (WRITE,REQUEST) → 미체크 재호출 → 행 삭제(D12 실증)
R4 CLEAN: E2E 생성분 전량 삭제 → 두 테이블 각 0행 실측 (집합 불변식)
"""
import sys

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import ora  # noqa: E402
import oracledb  # noqa: E402

TESTUSER = "E2ETEST_SDM1020"
SEED_CODE = "E2E_SDM1020"
SEED_KEY = "E2E_SDM1020_000001"
SEED_USER = "minyonglee1"

JOIN_FUNNEL = [
    ("DIV", "SELECT COUNT(*) FROM SCM_MGR.SCM_MST_DIVISION WHERE DIVISION_ID='40'"),
    ("PCL", """SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER LKM
               JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LKD
                 ON LKM.LOOKUP_TYPE=LKD.LOOKUP_TYPE AND LKD.VALID_YN='Y'
               WHERE LKM.LOOKUP_TYPE='SPMS_DPJT_CLASS' AND LKM.VALID_YN='Y' AND LKD.SEGMENT1='DEV'"""),
    ("CLT", """SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER LKM
               JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LKD
                 ON LKM.LOOKUP_TYPE=LKD.LOOKUP_TYPE AND LKD.VALID_YN='Y'
               WHERE LKM.LOOKUP_TYPE='SPMS_CELL_TYPE' AND LKM.VALID_YN='Y'
                 AND LKD.SEGMENT1='40' AND LKD.SEGMENT2='PRISM'"""),
    ("SMD", """SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER LKM
               JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LKD
                 ON LKM.LOOKUP_TYPE=LKD.LOOKUP_TYPE AND LKD.VALID_YN='Y'
               WHERE LKM.LOOKUP_TYPE='SPMS_CELL_STACK_METHOD' AND LKM.VALID_YN='Y'
                 AND LKD.SEGMENT1='40' AND LKD.SEGMENT4='AZS'"""),
    ("BIZ", """SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER LKM
               JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LKD
                 ON LKM.LOOKUP_TYPE=LKD.LOOKUP_TYPE AND LKD.VALID_YN='Y'
               WHERE LKM.LOOKUP_TYPE='DM_BIZ_TYPE' AND LKM.VALID_YN='Y' AND LKD.SEGMENT1='CELL'"""),
    ("USR", "SELECT COUNT(*) FROM SCM_MGR.SCM_MST_SSO_USER_INFO WHERE USER_ID='minyonglee1'"),
    ("DPT", """SELECT COUNT(*) FROM SCM_MGR.SCM_MST_SSO_DEPT_INFO D
               WHERE D.DEPT_ID=(SELECT DEPT_ID FROM SCM_MGR.SCM_MST_SSO_USER_INFO WHERE USER_ID='minyonglee1')"""),
    ("RGS", """SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER LKM
               JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LKD
                 ON LKM.LOOKUP_TYPE=LKD.LOOKUP_TYPE AND LKD.VALID_YN='Y'
               WHERE LKM.LOOKUP_TYPE='SPMS_DPJT_REG_STATUS' AND LKM.VALID_YN='Y' AND LKD.SEGMENT1='COMPLETE'"""),
]


def run_get(cur, fr, to):
    rc1 = cur.var(oracledb.DB_TYPE_CURSOR)
    rc2 = cur.var(oracledb.DB_TYPE_CURSOR)
    cur.execute(
        """BEGIN SCM_MGR.PKG_SDM1020.P_SDM1020_GET_PJT_LIST(
             '40', 'ALL', 'ALL', 'ALL', :fr, :to, :usr, :c1, :c2); END;""",
        {"fr": fr, "to": to, "usr": SEED_USER, "c1": rc1, "c2": rc2},
    )
    c1 = rc1.getvalue()
    cols = [x[0] for x in c1.description]
    return cols, c1.fetchall()


def main():
    u, p, d = ora.conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d)
    cur = con.cursor()

    # ── R0 SEED ───────────────────────────────────────────────────────────────
    cur.execute("DELETE FROM SCM_MGR.SPMS_PROJECT_USER_MAP WHERE DPJT_KEY LIKE 'E2E_SDM1020%'")
    cur.execute("DELETE FROM SCM_MGR.SPMS_PROJECT_MST WHERE DPJT_CODE=:c OR DPJT_KEY LIKE 'E2E_SDM1020%'", {"c": SEED_CODE})
    cur.execute(
        """INSERT INTO SCM_MGR.SPMS_PROJECT_MST
             (DPJT_KEY, DPJT_CODE, DPJT_SEQ, DPJT_NAME, DIVISION_ID, DPJT_CLASS, END_CUSTOMER,
              CELL_TYPE, BIZ_TYPE, STACK_METHOD, SOP_DATE, SOP_PLANT_ID,
              MGMT_USER_ID, CNFM_USER_ID, DPJT_REG_STATUS,
              REG_REQ_DATE, REG_MOD_DATE, REG_COMP_DATE, DPJT_REG_CAT, DPJT_MGMT_STATUS,
              CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
           VALUES
             (:k, :c, 1, 'E2E SDM1020 Seed Project', '40', 'DEV', '-',
              'PRISM', 'CELL', 'AZS', DATE '2027-01-01', '-',
              :mu, :mu, 'COMPLETE',
              TRUNC(SYSDATE), NULL, TRUNC(SYSDATE), 'NEW', 'TEMP',
              'admin', SYSDATE, 'admin', SYSDATE)""",
        {"k": SEED_KEY, "c": SEED_CODE, "mu": SEED_USER},
    )
    cur.execute(
        """INSERT INTO SCM_MGR.SPMS_PROJECT_USER_MAP
             (DPJT_KEY, USER_ID, DPJT_AUTH_TYPE, DPJT_AUTH_STATUS, DPJT_CODE, DPJT_SEQ, DPJT_NAME,
              CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
           VALUES
             (:k, :u, 'ADMIN', 'CONFIRM', :c, 1, 'E2E SDM1020 Seed Project',
              'admin', SYSDATE, 'admin', SYSDATE)""",
        {"k": SEED_KEY, "u": SEED_USER, "c": SEED_CODE},
    )
    con.commit()
    print(f"R0 SEED: MST 1행({SEED_KEY}, COMPLETE) + USER_MAP 1행({SEED_USER}, ADMIN/CONFIRM)")

    # ── R1 GET (기간 NULL / 기간 지정) ────────────────────────────────────────
    for label, fr, to in (("기간 NULL", None, None), ("기간 지정", "2026-01-01", "2026-12-31")):
        cols, rows = run_get(cur, fr, to)
        print(f"R1 GET[{label}]: {len(rows)}행 / 컬럼 {len(cols)}")
        if not rows:
            print("   0행 — 조인축 깔때기:")
            for name, sql in JOIN_FUNNEL:
                cur.execute(sql)
                print(f"     {name}: {cur.fetchone()[0]}")
            raise AssertionError(f"R1[{label}] 0행 — 위 깔때기에서 0인 축이 원인")
        ik = cols.index("DPJT_KEY")
        assert any(r[ik] == SEED_KEY for r in rows), f"R1[{label}] 시드 {SEED_KEY} 미조회"
        iw = cols.index("DPJT_AUTH_REQ_WRITE")
        ir = cols.index("DPJT_AUTH_REQ_READ")
        states = {r[iw] for r in rows} | {r[ir] for r in rows}
        assert states <= {"DISABLED", "CHECKED", "UNCHECKED", None}, f"3상태 위반: {states}"
        seed = next(r for r in rows if r[ik] == SEED_KEY)
        it = cols.index("DPJT_AUTH_TYPE")
        print(f"   시드 조회 OK / 내권한={seed[it]} / 3상태={sorted(x for x in states if x)}")
        assert seed[it] == "ADMIN" and seed[iw] == "DISABLED", "ADMIN/CONFIRM → DISABLED 위반"

    key = SEED_KEY

    # ── R2 BTN_REQ — D3 실증 ─────────────────────────────────────────────────
    cur.execute(
        """SELECT DPJT_CODE, DPJT_SEQ, DIVISION_ID, DPJT_CLASS, END_CUSTOMER, DPJT_NAME,
                  CELL_TYPE, STACK_METHOD, BIZ_TYPE, TO_CHAR(SOP_DATE,'YYYY-MM-DD'), SOP_PLANT_ID,
                  DPJT_REG_STATUS, TO_CHAR(REG_MOD_DATE,'YYYYMMDD'), LAST_UPDATED_BY,
                  TO_CHAR(LAST_UPDATE_DATE,'YYYYMMDD HH24MISS')
             FROM SCM_MGR.SPMS_PROJECT_MST WHERE DPJT_KEY=:k""",
        {"k": key},
    )
    (code, seq, div, cls, ec, name, ct, sm, bt, sop, plant,
     o_stat, o_mod, o_by, o_upd) = cur.fetchone()
    rc = cur.var(oracledb.DB_TYPE_CURSOR)
    cur.execute(
        """BEGIN SCM_MGR.PKG_SDM1020.P_SDM1020_BTN_REQ_PJT_REG(
             'M', :k, :c, :s, :d, :cl, :e, :n, :ct, :sm, :bt, :sop, :pl, :u, :rc); END;""",
        {"k": key, "c": code, "s": str(seq), "d": div, "cl": cls, "e": ec, "n": name,
         "ct": ct or "", "sm": sm or "", "bt": bt or "", "sop": sop or "", "pl": plant or "",
         "u": TESTUSER, "rc": rc},
    )
    res = rc.getvalue().fetchall()
    print(f"R2 BTN_REQ 결과커서: {res}")
    assert res and res[0][0] == "0", f"BTN_REQ CODE!=0: {res}"
    cur.execute(
        """SELECT DPJT_KEY, DPJT_REG_STATUS FROM SCM_MGR.SPMS_PROJECT_MST
            WHERE DPJT_KEY_PARENT=:k AND MGMT_USER_ID=:u AND DPJT_REG_STATUS='REQ_MOD'""",
        {"k": key, "u": TESTUSER},
    )
    new_rows = cur.fetchall()
    assert len(new_rows) == 1, f"신행 {len(new_rows)}건"
    new_key = new_rows[0][0]
    cur.execute("SELECT DPJT_REG_STATUS FROM SCM_MGR.SPMS_PROJECT_MST WHERE DPJT_KEY=:k", {"k": key})
    after_stat = cur.fetchone()[0]
    print(f"   신행 {new_key!r}=REQ_MOD OK / 원본 상태 {o_stat} → {after_stat}")
    assert after_stat == "MODIFYING", "D3 전이 실패!"
    print("   [PASS] D3 실증: 원본 MODIFYING 전이 동작")
    # 원복
    cur.execute("DELETE FROM SCM_MGR.SPMS_PROJECT_MST WHERE DPJT_KEY=:k", {"k": new_key})
    cur.execute(
        """UPDATE SCM_MGR.SPMS_PROJECT_MST
              SET DPJT_REG_STATUS=:s,
                  REG_MOD_DATE=TO_DATE(:m,'YYYYMMDD'),
                  LAST_UPDATED_BY=:b,
                  LAST_UPDATE_DATE=TO_DATE(:t,'YYYYMMDD HH24MISS')
            WHERE DPJT_KEY=:k""",
        {"s": o_stat, "m": o_mod, "b": o_by, "t": o_upd, "k": key},
    )
    con.commit()
    cur.execute("SELECT DPJT_REG_STATUS FROM SCM_MGR.SPMS_PROJECT_MST WHERE DPJT_KEY=:k", {"k": key})
    assert cur.fetchone()[0] == o_stat
    cur.execute("SELECT COUNT(*) FROM SCM_MGR.SPMS_PROJECT_MST WHERE DPJT_KEY=:k", {"k": new_key})
    assert cur.fetchone()[0] == 0
    print("   원상복구 OK (신행 삭제 + 원본 상태/감사 원복)")

    # ── R3 AUTH — D12 실증 (합성 사용자, 자정리) ─────────────────────────────
    rc = cur.var(oracledb.DB_TYPE_CURSOR)
    cur.execute(
        """BEGIN SCM_MGR.PKG_SDM1020.P_SDM1020_REQ_PJT_AUTH(:k, 'CHECKED', '', :u, :rc); END;""",
        {"k": key, "u": TESTUSER, "rc": rc},
    )
    print(f"R3 권한요청(WRITE): {rc.getvalue().fetchall()}")
    cur.execute(
        """SELECT DPJT_AUTH_TYPE, DPJT_AUTH_STATUS FROM SCM_MGR.SPMS_PROJECT_USER_MAP
            WHERE DPJT_KEY=:k AND USER_ID=:u""", {"k": key, "u": TESTUSER})
    row = cur.fetchone()
    assert row == ("WRITE", "REQUEST"), f"요청 행 {row}"
    print("   요청 행 (WRITE, REQUEST) OK")
    rc = cur.var(oracledb.DB_TYPE_CURSOR)
    cur.execute(
        """BEGIN SCM_MGR.PKG_SDM1020.P_SDM1020_REQ_PJT_AUTH(:k, '', '', :u, :rc); END;""",
        {"k": key, "u": TESTUSER, "rc": rc},
    )
    print(f"R3 권한요청 취소: {rc.getvalue().fetchall()}")
    cur.execute(
        """SELECT COUNT(*) FROM SCM_MGR.SPMS_PROJECT_USER_MAP
            WHERE DPJT_KEY=:k AND USER_ID=:u""", {"k": key, "u": TESTUSER})
    left = cur.fetchone()[0]
    assert left == 0, f"취소 후 잔존 {left}"
    print("   [PASS] D12 실증: 미체크 재호출 = 요청 행 삭제 (자정리 완료)")

    # ── R4 CLEAN — 전량 정리 + 집합 불변식(0행) ──────────────────────────────
    cur.execute("DELETE FROM SCM_MGR.SPMS_PROJECT_USER_MAP WHERE DPJT_KEY LIKE 'E2E_SDM1020%' OR USER_ID=:u", {"u": TESTUSER})
    n_um = cur.rowcount
    cur.execute("DELETE FROM SCM_MGR.SPMS_PROJECT_MST WHERE DPJT_CODE=:c OR DPJT_KEY LIKE 'E2E_SDM1020%'", {"c": SEED_CODE})
    n_m = cur.rowcount
    con.commit()
    cur.execute("SELECT (SELECT COUNT(*) FROM SCM_MGR.SPMS_PROJECT_MST),"
                "(SELECT COUNT(*) FROM SCM_MGR.SPMS_PROJECT_USER_MAP) FROM DUAL")
    cm, cu = cur.fetchone()
    print(f"R4 CLEAN: MST 삭제 {n_m}행 / USER_MAP 삭제 {n_um}행 → 잔여 MST={cm}, USER_MAP={cu}")
    assert cm == 0 and cu == 0, "집합 불변식 위반 — 잔여 행 존재"
    print("   [PASS] 집합 불변식: 두 테이블 모두 0행 (시작 상태 복원)")

    cur.close()
    con.close()
    print("[결과] SDM1020 CRUD 왕복 전건 PASS — R0 시드 / R1 GET 2케이스 / R2 D3 / R3 D12 / R4 0행 복원")


if __name__ == "__main__":
    main()
