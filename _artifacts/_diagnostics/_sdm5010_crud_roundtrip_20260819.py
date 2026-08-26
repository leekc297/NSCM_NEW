#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""_sdm5010_crud_roundtrip_20260819.py — SDM5010 사내 CRUD 왕복 실증 (2026-08-19)

R0 시드 → R1 GET_TAB1 → R2 CONFIRM(변경 케이스 B_000002) → R2b CONFIRM(신규 케이스 C — D5 발화 실측)
→ R3 CANCEL(A 신규 케이스) → R4 SAVE_TAB2 + GET_TAB2 재조회 → R5 전량 삭제 + 집합 불변식 검증

- 세션: minyonglee1 / division 40 / SDM5010 / 'SPMS Administrator'
- 시드 lookup: CELL_TYPE=PRISM / STACK=AZS / BIZ=CELL / CLS=DEV (검증 통과 조합, _sdm_sample_seed_20260819.py)
- ⚠ CONFIRM UPDATE 는 LENGTH(DPJT_CODE)=6 게이트 보유 → E2E 행 DPJT_CODE 는 6자('E2E5A0'/'E2E5B0'/'E2E5C0')
- ⚠ 변경 케이스(PARENT 有)는 SP 가 V_DPJT_KEY := P_DPJT_KEY (키 불변) → D5 는 신규 케이스에서만 발화
  → R2 에서 키 불변+USER_MAP 잔존 실측, R2b(신규 케이스 C) 에서 키 변경+USER_MAP 동기 발화 실측
- 원상복구 의무: finally 에서 E2E 행 전량 삭제 + 시작 전 대비 집합 불변식(행수+ORA_HASH 합) 비교
"""
import sys

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import ora  # noqa: E402
import oracledb  # noqa: E402

USER = "minyonglee1"
DIV = "40"
MNU = "SDM5010"
UGR = "SPMS Administrator"

K_A = "E2E_SDM5010_A"            # 신규요청 (WAITING, PARENT NULL) — R3 반려 대상
K_B1 = "E2E_SDM5010_B_000001"    # 원본 B (MODIFYING)
K_B2 = "E2E_SDM5010_B_000002"    # 변경요청 (REQ_MOD, PARENT=B1) — R2 승인 대상
K_C = "E2E_SDM5010_C_TEMP"       # 신규요청 (WAITING) — R2b D5 발화 실측용
C_A, C_B, C_C = "E2E5A0", "E2E5B0", "E2E5C0"  # 6자 코드 (CONFIRM LENGTH=6 게이트)
E2E_KEYS = [K_A, K_B1, K_B2, K_C]
E2E_CODES = [C_A, C_B, C_C]

FAILS = []


def check(name, cond, detail=""):
    tag = "PASS" if cond else "FAIL"
    print(f"  [{tag}] {name}" + (f" — {detail}" if detail else ""))
    if not cond:
        FAILS.append(f"{name}: {detail}")


def one(cur, sql, binds=None):
    cur.execute(sql, binds or {})
    r = cur.fetchone()
    return r


def mst_row(cur, key):
    return one(cur, """SELECT DPJT_KEY, DPJT_CODE, DPJT_SEQ, DPJT_REG_STATUS,
                              NVL(DPJT_MGMT_STATUS,'~NULL~'), DPJT_DEVELOP_STATUS, CNFM_USER_ID,
                              TO_CHAR(REG_COMP_DATE,'YYYY-MM-DD')
                         FROM SCM_MGR.SPMS_PROJECT_MST WHERE DPJT_KEY=:k""", {"k": key})


def call_result(cur, plsql, binds):
    """result 커서 SP 호출 — CODE 컬럼명 기반 판정 (위치 기반 금지)."""
    rc = cur.var(oracledb.DB_TYPE_CURSOR)
    binds = dict(binds, rc=rc)
    cur.execute(plsql, binds)
    c = rc.getvalue()
    cols = [d[0] for d in c.description]
    row = c.fetchone()
    d = dict(zip(cols, row))
    return d.get("CODE"), d.get("MSG"), d.get("EVENT")


def snapshot(cur):
    """집합 불변식: 안정 컬럼 기반 행수 + ORA_HASH 합 (MST / USER_MAP)."""
    m = one(cur, """SELECT COUNT(*), NVL(SUM(ORA_HASH(DPJT_KEY||'|'||DPJT_CODE||'|'||DPJT_SEQ||'|'||
                           DPJT_REG_STATUS||'|'||NVL(DPJT_MGMT_STATUS,'-')||'|'||DPJT_NAME||'|'||
                           NVL(DPJT_DEVELOP_STATUS,'-'))),0)
                      FROM SCM_MGR.SPMS_PROJECT_MST""")
    u = one(cur, """SELECT COUNT(*), NVL(SUM(ORA_HASH(DPJT_KEY||'|'||USER_ID||'|'||DPJT_AUTH_TYPE||'|'||
                           NVL(DPJT_AUTH_STATUS,'-'))),0)
                      FROM SCM_MGR.SPMS_PROJECT_USER_MAP""")
    return (m[0], m[1], u[0], u[1])


def cleanup(cur, con, label):
    n1 = n2 = 0
    for k in E2E_KEYS:
        cur.execute("DELETE FROM SCM_MGR.SPMS_PROJECT_USER_MAP WHERE DPJT_KEY=:k", {"k": k})
        n2 += cur.rowcount
        cur.execute("DELETE FROM SCM_MGR.SPMS_PROJECT_MST WHERE DPJT_KEY=:k", {"k": k})
        n1 += cur.rowcount
    # CONFIRM 신규 케이스가 재채번한 키(코드 파생·공백 변형 포함) 스윕
    for c in E2E_CODES:
        cur.execute("DELETE FROM SCM_MGR.SPMS_PROJECT_USER_MAP WHERE DPJT_CODE=:c OR DPJT_KEY LIKE :p",
                    {"c": c, "p": c + "\\_%"})
        n2 += cur.rowcount
        cur.execute("DELETE FROM SCM_MGR.SPMS_PROJECT_MST WHERE DPJT_CODE=:c", {"c": c})
        n1 += cur.rowcount
    con.commit()
    print(f"  {label}: MST {n1}행 / USER_MAP {n2}행 삭제")
    return n1, n2


def insert_mst(cur, key, code, seq, name, status, reg_cat, parent, mgmt="TEMP"):
    cur.execute(
        """INSERT INTO SCM_MGR.SPMS_PROJECT_MST
             (DPJT_KEY, DPJT_CODE, DPJT_SEQ, DPJT_NAME, DIVISION_ID, DPJT_CLASS, END_CUSTOMER,
              CELL_TYPE, BIZ_TYPE, STACK_METHOD, SOP_DATE, SOP_PLANT_ID,
              MGMT_USER_ID, CNFM_USER_ID, DPJT_REG_STATUS,
              REG_REQ_DATE, REG_MOD_DATE, REG_COMP_DATE, DPJT_REG_CAT, DPJT_MGMT_STATUS,
              DPJT_KEY_PARENT, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
           VALUES
             (:k, :c, :sq, :n, '40', 'DEV', '-',
              'PRISM', 'CELL', 'AZS', ADD_MONTHS(TRUNC(SYSDATE), 5), '-',
              :mu, :mu, :st,
              TRUNC(SYSDATE)-10, NULL, TRUNC(SYSDATE)-1, :cat, :mg,
              :pa, 'admin', SYSDATE, 'admin', SYSDATE)""",
        {"k": key, "c": code, "sq": seq, "n": name, "mu": USER, "st": status,
         "cat": reg_cat, "mg": mgmt, "pa": parent},
    )


def insert_map(cur, key, code, seq, name):
    cur.execute(
        """INSERT INTO SCM_MGR.SPMS_PROJECT_USER_MAP
             (DPJT_KEY, USER_ID, DPJT_AUTH_TYPE, DPJT_AUTH_STATUS, DPJT_CODE, DPJT_SEQ, DPJT_NAME,
              CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
           VALUES (:k, :u, 'ADMIN', 'CONFIRM', :c, :sq, :n, 'admin', SYSDATE, 'admin', SYSDATE)""",
        {"k": key, "u": USER, "c": code, "sq": seq, "n": name},
    )


def main():
    u, p, d = ora.conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d)
    cur = con.cursor()

    print("=== 사전: 기존 E2E 잔재 제거 + 기준 스냅샷 ===")
    cleanup(cur, con, "사전 스윕")
    base = snapshot(cur)
    base_samples = one(cur, """SELECT COUNT(*) FROM SCM_MGR.SPMS_PROJECT_MST
                                WHERE DPJT_KEY IN ('26VW01_000001','26VW02_000001','26GM01_000001',
                                                   '26TY01_000001','26HK01_000001')""")[0]
    print(f"  기준: MST {base[0]}행/hash {base[1]} · USER_MAP {base[2]}행/hash {base[3]} · 샘플 5건={base_samples}")

    try:
        # ── R0 시드 ──────────────────────────────────────────────────────────
        print("\n=== R0 시드 ===")
        insert_mst(cur, K_A, C_A, 1, "E2E A NewReq", "WAITING", "NEW", None)
        insert_mst(cur, K_B1, C_B, 1, "E2E B Origin", "MODIFYING", "NEW", None, mgmt="NORMAL")
        insert_mst(cur, K_B2, C_B, 2, "E2E B ChgReq", "REQ_MOD", "MOD", K_B1)
        insert_mst(cur, K_C, C_C, 1, "E2E C NewReq", "WAITING", "NEW", None)
        insert_map(cur, K_B2, C_B, 2, "E2E B ChgReq")   # D5 검증용 (B 변경요청 키)
        insert_map(cur, K_C, C_C, 1, "E2E C NewReq")    # D5 발화 실측용 (C 신규 키)
        con.commit()
        print(f"  MST 4행(A WAITING / B1 MODIFYING / B2 REQ_MOD parent={K_B1} / C WAITING) + USER_MAP 2행(B2, C)")

        # ── R1 GET_TAB1 ─────────────────────────────────────────────────────
        print("\n=== R1 GET_TAB1 (세션 minyonglee1/40/SDM5010/SPMS Administrator) ===")
        rc1 = cur.var(oracledb.DB_TYPE_CURSOR)
        rc2 = cur.var(oracledb.DB_TYPE_CURSOR)
        cur.execute("""BEGIN SCM_MGR.PKG_SDM5010.P_SDM5010_GET_TAB1_PJT_REG_REQ(
                         :dv, :us, :mn, :gr, :c1, :c2); END;""",
                    {"dv": DIV, "us": USER, "mn": MNU, "gr": UGR, "c1": rc1, "c2": rc2})
        c1 = rc1.getvalue()
        cols = [x[0] for x in c1.description]
        rows = [dict(zip(cols, r)) for r in c1.fetchall()]
        res = dict(zip([x[0] for x in rc2.getvalue().description], rc2.getvalue().fetchone() or ())) \
            if rc2.getvalue() else {}
        # rc2.getvalue() 는 동일 커서 객체 반환 — 위 이중 호출 안전하나 명시 재사용
        keys_found = {r["DPJT_KEY"]: r for r in rows}
        check("R1 커서 컬럼 36개", len(cols) == 36, f"실측 {len(cols)}")
        check("R1 시드 3건 조회(A/B2/C — WAITING·REQ_MOD 만)", all(k in keys_found for k in (K_A, K_B2, K_C)),
              f"조회 키={sorted(keys_found)}")
        check("R1 B1(MODIFYING) 미조회", K_B1 not in keys_found)
        if K_A in keys_found and K_B2 in keys_found:
            a, b2 = keys_found[K_A], keys_found[K_B2]
            check("R1 A 권한상태=WRITING(USER_MAP 0건)", a["DPJT_ATUH_REG_STATUS"] == "WRITING",
                  f"{a['DPJT_ATUH_REG_STATUS']}/{a['DPJT_ATUH_REG_STATUS_NAME']}/{a['DPJT_ATUH_REG_STATUS_COLOR_TYPE']}")
            check("R1 B2 권한상태=COMPLETE(USER_MAP 1건)", b2["DPJT_ATUH_REG_STATUS"] == "COMPLETE",
                  f"{b2['DPJT_ATUH_REG_STATUS']}/{b2['DPJT_ATUH_REG_STATUS_NAME']}/{b2['DPJT_ATUH_REG_STATUS_COLOR_TYPE']}")
            check("R1 B2 PARENT 반환", b2["DPJT_KEY_PARENT"] == K_B1, f"{b2['DPJT_KEY_PARENT']}")

        # ── R2 CONFIRM (B2 변경 케이스) ──────────────────────────────────────
        print("\n=== R2 CONFIRM (B_000002 변경 케이스 — 계약 15 IN) ===")
        map_before = one(cur, "SELECT DPJT_KEY FROM SCM_MGR.SPMS_PROJECT_USER_MAP WHERE DPJT_CODE=:c", {"c": C_B})
        code, msg, ev = call_result(cur, """BEGIN SCM_MGR.PKG_SDM5010.P_SDM5010_BTN_TAB1_CONFIRM(
              :k, :c, :sq, :pa, :dv, :cl, :ec, :nm, :ct, :sm, :bz, :sd, :sp, :nt, :us, :rc); END;""",
            {"k": K_B2, "c": C_B, "sq": "2", "pa": K_B1, "dv": DIV, "cl": "DEV", "ec": "-",
             "nm": "E2E B ChgReq", "ct": "PRISM", "sm": "AZS", "bz": "CELL",
             "sd": "2027-01-15", "sp": "-", "nt": "E2E confirm B2", "us": USER})
        check("R2 결과 CODE='0'", code == "0", f"CODE={code} MSG={msg} EVENT={ev}")
        b2 = mst_row(cur, K_B2)
        b1 = mst_row(cur, K_B1)
        check("R2 B2=COMPLETE (CHG_COMPLETE 아님 — 자기 행)", b2 and b2[3] == "COMPLETE",
              f"B2 상태={b2[3] if b2 else '행 소실'} MGMT={b2[4] if b2 else '-'} CNFM={b2[6] if b2 else '-'} REG_COMP={b2[7] if b2 else '-'}")
        check("R2 원본 B1=CHG_COMPLETE 전이 (D4 정정)", b1 and b1[3] == "CHG_COMPLETE",
              f"B1 상태={b1[3] if b1 else '행 소실'} MGMT={b1[4] if b1 else '-'}")
        map_after = one(cur, "SELECT DPJT_KEY FROM SCM_MGR.SPMS_PROJECT_USER_MAP WHERE DPJT_CODE=:c", {"c": C_B})
        check("R2 변경 케이스 키 불변 → USER_MAP 키 유지 (D5 가드 미발화 정상)",
              map_before and map_after and map_before[0] == K_B2 and map_after[0] == K_B2,
              f"변경 전={map_before[0] if map_before else None} → 후={map_after[0] if map_after else None}")

        # ── R2b CONFIRM (C 신규 케이스 — D5 발화 실측) ───────────────────────
        print("\n=== R2b CONFIRM (C 신규 케이스 — D5 키 동기 발화 + D11 채번 실측) ===")
        code, msg, ev = call_result(cur, """BEGIN SCM_MGR.PKG_SDM5010.P_SDM5010_BTN_TAB1_CONFIRM(
              :k, :c, :sq, :pa, :dv, :cl, :ec, :nm, :ct, :sm, :bz, :sd, :sp, :nt, :us, :rc); END;""",
            {"k": K_C, "c": C_C, "sq": "1", "pa": None, "dv": DIV, "cl": "DEV", "ec": "-",
             "nm": "E2E C NewReq", "ct": "PRISM", "sm": "AZS", "bz": "CELL",
             "sd": "2027-01-15", "sp": "-", "nt": "E2E confirm C", "us": USER})
        check("R2b 결과 CODE='0'", code == "0", f"CODE={code} MSG={msg} EVENT={ev}")
        newc = one(cur, """SELECT DPJT_KEY, DPJT_SEQ, DPJT_REG_STATUS FROM SCM_MGR.SPMS_PROJECT_MST
                            WHERE DPJT_CODE=:c""", {"c": C_C})
        mapc = one(cur, "SELECT DPJT_KEY FROM SCM_MGR.SPMS_PROJECT_USER_MAP WHERE DPJT_CODE=:c", {"c": C_C})
        newkey = newc[0] if newc else None
        check("R2b 신규 케이스 DPJT_KEY 재채번(변경 발생)", newc is not None and newkey != K_C,
              f"변경 전={K_C!r} → 후={newkey!r} (SEQ={newc[1] if newc else '-'}, 상태={newc[2] if newc else '-'})")
        check("R2b D5 발화: USER_MAP 키 동기", mapc is not None and mapc[0] == newkey,
              f"USER_MAP 키: 변경 전={K_C!r} → 후={mapc[0] if mapc else None!r}")
        if newkey and " " in newkey:
            print(f"  [발견] 신규 승인 키에 공백 포함 {newkey!r} — TO_CHAR(seq,'000000') 부호 공백 (FM 부재) 잠재결함")

        # ── R3 CANCEL (A 신규 케이스) ────────────────────────────────────────
        print("\n=== R3 CANCEL (A 신규 케이스 — PARENT NULL) ===")
        code, msg, ev = call_result(cur, """BEGIN SCM_MGR.PKG_SDM5010.P_SDM5010_BTN_TAB1_CANCEL(
              :dv, :k, :pa, :nt, :us, :rc); END;""",
            {"dv": DIV, "k": K_A, "pa": None, "nt": "E2E cancel A", "us": USER})
        check("R3 결과 CODE='0'", code == "0", f"CODE={code} MSG={msg} EVENT={ev}")
        a = mst_row(cur, K_A)
        check("R3 A=REJECT (COMPLETE 로 되돌지 않음 — D3 정정)", a and a[3] == "REJECT",
              f"A 상태={a[3] if a else '행 소실'} MGMT={a[4] if a else '-'} (기대 REJECT/DISABLED)")
        check("R3 A MGMT=DISABLED (반려행 비활성)", a and a[4] == "DISABLED", f"실측 {a[4] if a else '-'}")

        # ── R4 SAVE_TAB2 + GET_TAB2 재조회 ──────────────────────────────────
        print("\n=== R4 SAVE_TAB2 (B_000002: DEVELOP_STATUS=PROD / DISABLED=CHECKED) ===")
        code, msg, ev = call_result(cur, """BEGIN SCM_MGR.PKG_SDM5010.P_SDM5010_SAVE_TAB2_PJT_MASTER(
              'M', :k, 'PROD', 'CHECKED', :us, :rc); END;""", {"k": K_B2, "us": USER})
        check("R4 결과 CODE='0'", code == "0", f"CODE={code} MSG={msg} EVENT={ev}")
        b2 = mst_row(cur, K_B2)
        check("R4 원장 DPJT_MGMT_STATUS='DISABLED'", b2 and b2[4] == "DISABLED", f"실측 {b2[4] if b2 else '-'}")
        check("R4 원장 DPJT_DEVELOP_STATUS='PROD'", b2 and b2[5] == "PROD", f"실측 {b2[5] if b2 else '-'}")
        rc1 = cur.var(oracledb.DB_TYPE_CURSOR)
        rc2 = cur.var(oracledb.DB_TYPE_CURSOR)
        cur.execute("""BEGIN SCM_MGR.PKG_SDM5010.P_SDM5010_GET_TAB2_PJT_MASTER(
                         :dv, 'ALL', 'ALL', 'ALL', 'ALL', '', '', :us, :c1, :c2); END;""",
                    {"dv": DIV, "us": USER, "c1": rc1, "c2": rc2})
        c1 = rc1.getvalue()
        cols2 = [x[0] for x in c1.description]
        rows2 = {}
        for r in c1.fetchall():
            rd = dict(zip(cols2, r))  # 중복 REG_COMP_DATE 는 후행이 덮으나 검증 축 아님
            rows2[rd["DPJT_KEY"]] = rd
        check("R4 GET_TAB2 커서 36열(REG_COMP_DATE 중복 포함)", len(cols2) == 36, f"실측 {len(cols2)}")
        check("R4 GET_TAB2 B2 조회 + DISABLE_YN='CHECKED'",
              K_B2 in rows2 and rows2[K_B2]["DISABLE_YN"] == "CHECKED",
              f"DISABLE_YN={rows2[K_B2]['DISABLE_YN'] if K_B2 in rows2 else '행 미조회'}"
              + (f" DEVELOP={rows2[K_B2]['DPJT_DEVELOP_STATUS']}/{rows2[K_B2]['DPJT_DEVELOP_STATUS_NAME']}" if K_B2 in rows2 else ""))
        check("R4 GET_TAB2 B1(CHG_COMPLETE) 조회 + DISABLE_YN='CHECKED'(DISABLED 전이분)",
              K_B1 in rows2 and rows2[K_B1]["DISABLE_YN"] == "CHECKED",
              f"DISABLE_YN={rows2[K_B1]['DISABLE_YN']}" if K_B1 in rows2 else "행 미조회")

    finally:
        # ── R5 정리 + 집합 불변식 ────────────────────────────────────────────
        print("\n=== R5 정리 (E2E 전량 삭제 + 집합 불변식) ===")
        cleanup(cur, con, "R5 삭제")
        rem = one(cur, """SELECT COUNT(*) FROM SCM_MGR.SPMS_PROJECT_MST
                           WHERE DPJT_KEY LIKE 'E2E%' OR DPJT_CODE IN ('E2E5A0','E2E5B0','E2E5C0')""")[0]
        rem2 = one(cur, """SELECT COUNT(*) FROM SCM_MGR.SPMS_PROJECT_USER_MAP
                            WHERE DPJT_KEY LIKE 'E2E%' OR DPJT_CODE IN ('E2E5A0','E2E5B0','E2E5C0')""")[0]
        check("R5 잔여 0 (MST/USER_MAP)", rem == 0 and rem2 == 0, f"MST={rem} USER_MAP={rem2}")
        after = snapshot(cur)
        samples = one(cur, """SELECT COUNT(*) FROM SCM_MGR.SPMS_PROJECT_MST
                               WHERE DPJT_KEY IN ('26VW01_000001','26VW02_000001','26GM01_000001',
                                                  '26TY01_000001','26HK01_000001')""")[0]
        check("R5 집합 불변식 MST (행수+hash 합 = 시작 전)", after[0] == base[0] and after[1] == base[1],
              f"기준 {base[0]}/{base[1]} → 종료 {after[0]}/{after[1]}")
        check("R5 집합 불변식 USER_MAP", after[2] == base[2] and after[3] == base[3],
              f"기준 {base[2]}/{base[3]} → 종료 {after[2]}/{after[3]}")
        check("R5 기존 샘플 5건 불변", samples == base_samples, f"{base_samples} → {samples}")
        cur.close()
        con.close()

    print("\n=== 최종:", "전 항목 PASS" if not FAILS else f"FAIL {len(FAILS)}건")
    for f in FAILS:
        print("  -", f)
    sys.exit(0 if not FAILS else 1)


if __name__ == "__main__":
    main()
