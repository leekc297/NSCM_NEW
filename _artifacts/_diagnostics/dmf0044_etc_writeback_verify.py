#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""dmf0044_etc_writeback_verify.py — ETCWB(ETC 저장 반영) 실증 (2026-08-11)

⚠ 저장 SP 는 내부 COMMIT 하므로 rollback 이 무의미하다([[feedback_save_sp_direct_call_commits]]).
   따라서 **실데이터를 건드리지 않는 합성 식별자**(CELL_MODEL_INFO='ZZ_ETCWB_TEST')로만 왕복하고,
   끝에 잔여 0 을 집합 불변식으로 확인한다.

검증 축
  A. 사전 스냅샷      : ETC/PLAN 총 행수 + 대상 버전 행수
  B. I 경로 (신규)    : SAVE(qty=111) → ETC 에 1행 INSERT (DATA_SEQ 채번 > 기존 MAX)
  C. M 경로 (갱신)    : SAVE(qty=222) → 같은 행 UPDATE (행 증가 0)
  D. 조회 반영        : GET SP 실행 → ETC 그리드 결과에 222 가 실제로 보이는지
  E. D 경로 (삭제)    : SAVE(activeFlag='D') → ETC 행 제거
  F. 잔여 정리·불변식 : PLAN_REPORT_C 의 테스트 잔여 제거 + 총 행수 원복 확인
"""
import pathlib
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info  # noqa: E402

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

MARK = "ZZ_ETCWB_TEST"
DIV, VER, CUT = "40", "R_S_20260128_V002_C", "REPORT_SP_W"
# ⚠ 합성 식별자는 **PLAN_REPORT_C PK 에 포함된 컬럼**으로 갈라야 한다.
#   PK = (VERSION_NO, DIVISION_ID, DEPARTMENT_ID, DEPT_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID,
#         FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, CURRENCY, COMPANY_ID,
#         COMPO_40, CELL_PROD_SITE) — CELL_MODEL_INFO/ATTRIBUTE3 는 PK 가 아니다.
#   그 둘만 바꾸면 PLAN MERGE 가 NOT MATCHED → INSERT 로 흘러 ORA-00001 이 난다(기존 결함).
YM, MEASURE, ITEM = "202503", "SalesAmt_KRW", "ZZ_ETCWB"
IDENT = dict(
    P_DIVISION_ID=DIV, P_VERSION_NO=VER, P_CUTOFF_TYPE=CUT, P_CUTOFF_YYYYMMDD="",
    # ⭐ 신규행 실제 payload 재현 (2026-08-11 정정) — AS-IS 는 InsertRow 에서 이름 컬럼을 잠그기만 하고
    #   채우지 않으므로 **DEPARTMENT_NAME/DEPT_NAME 은 빈값으로 온다**. 종전 harness 가 실명을 넣는 바람에
    #   PLAN INSERT 의 NOT NULL 위반(ORA-01400)을 놓쳤다 ⇒ 실제와 같게 빈값으로 둔다.
    P_DEPARTMENT_ID="50030981", P_DEPARTMENT_NAME="",
    P_DEPT_ID="58099468", P_DEPT_NAME="",
    P_END_CUST_REPORT="NT", P_CUST_REPORT="NT(iPhone)", P_PRODUCT_GROUP="파우치형",
    P_ITEM_ID=ITEM, P_MEASURE=MEASURE, P_YYYYMMDD=YM, P_CURRENCY="USD", P_COMPANY_ID="HQ00",
    P_CREATED_BY="claude_etcwb", P_CELL_MODEL_INFO=MARK, P_CELL_MODEL=MARK,
)

ETC = "SCM_MGR.DM_PLN_SALES_ETC_REPORT_C"
PLAN = "SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C"


def scalar(cur, sql, binds=None):
    cur.execute(sql, binds or {})
    return cur.fetchone()[0]


def etc_test_rows(cur):
    cur.execute(
        f"SELECT DATA_SEQ, MEASURE, YYYYMMDD, QTY, CREATED_BY FROM {ETC} "
        "WHERE DIVISION_ID=:d AND VERSION_NO=:v AND CELL_MODEL_INFO=:m ORDER BY DATA_SEQ, MEASURE",
        {"d": DIV, "v": VER, "m": MARK})
    return cur.fetchall()


def call_save(cur, active_flag, qty, n=1, measures=None, months=None):
    """실제 FE payload 형태로 호출한다.

    ⚠ 핵심: 값 키는 '^' 로 n 회 반복하되 **P_CREATED_BY 는 BE 가 세션 사용자 1개만 주입**한다.
       (2026-08-11 ORA-01407 실사고 — 단일행 테스트로는 절대 재현되지 않는다)
    """
    measures = measures or [MEASURE]
    months = months or [YM]
    combos = [(m, y) for y in months for m in measures][:n] if n > 1 else [(measures[0], months[0])]
    args = {}
    for k, v in IDENT.items():
        if k == "P_CREATED_BY":
            args[k] = v                      # ⭐ 반복하지 않는다 (BE 주입 파리티)
        elif k == "P_MEASURE":
            args[k] = "^".join(c[0] for c in combos)
        elif k == "P_YYYYMMDD":
            args[k] = "^".join(c[1] for c in combos)
        else:
            args[k] = "^".join([v] * len(combos))
    args["P_ACTIVE_FLAG"] = "^".join([active_flag] * len(combos))
    args["P_QTY"] = "^".join([qty] * len(combos))
    out = cur.var(__import__("oracledb").DB_TYPE_CURSOR)
    args["O_RESULT_CURSOR"] = out
    cur.callproc("SCM_MGR.PKG_DMF0044.P_DMF0044_SAVE_SALES_PLAN_REPORT_C", keywordParameters=args)
    try:
        rc = out.getvalue()
        cols = [c[0] for c in rc.description] if rc.description else []
        rows = rc.fetchall()
        return dict(zip(cols, rows[0])) if rows else {}
    except Exception as e:  # noqa: BLE001
        return {"(cursor)": str(e)}


def main():
    import oracledb

    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()

        # ── A. 사전 스냅샷 ────────────────────────────────────────────────────────────────
        etc0 = scalar(cur, f"SELECT COUNT(*) FROM {ETC}")
        plan0 = scalar(cur, f"SELECT COUNT(*) FROM {PLAN}")
        vmax0 = scalar(cur, f"SELECT NVL(MAX(DATA_SEQ),1) FROM {ETC} WHERE VERSION_NO=:v AND DIVISION_ID=:d",
                       {"v": VER, "d": DIV})
        print("[A] 사전  ETC=%d행 / PLAN=%d행 / MAX(DATA_SEQ)=%s" % (etc0, plan0, vmax0))
        if etc_test_rows(cur):
            sys.exit("[error] 테스트 마커 행이 이미 존재 — 중단")

        # ── B. I 경로 (다행 payload — 2 measure × 3 개월 = 6행, FE 실제 형태) ─────────────
        MSRS = [MEASURE, "SalesAmt_LOC"]
        MONS = ["202503", "202504", "202505"]
        print("[B] SAVE activeFlag='I' qty=111 × 6행 …",
              call_save(cur, "I", "111", n=6, measures=MSRS, months=MONS))
        rows = etc_test_rows(cur)
        etc1 = scalar(cur, f"SELECT COUNT(*) FROM {ETC}")
        seqs = {r[0] for r in rows}
        ok_b = (len(rows) == 6 and all(float(r[3]) == 111.0 for r in rows)
                and etc1 - etc0 == 6 and len(seqs) == 1 and max(seqs) > vmax0)
        print("    ETC 테스트행 %d건 / DATA_SEQ %s / 총 %d행 (+%d)"
              % (len(rows), sorted(seqs), etc1, etc1 - etc0))
        print("    ⇒ INSERT 경로 %s (6행·DATA_SEQ 단일 %s > 기존 MAX %s · 감사컬럼 NOT NULL 통과)"
              % ("PASS" if ok_b else "FAIL", sorted(seqs), vmax0))

        # ── C. M 경로 ─────────────────────────────────────────────────────────────────────
        print("[C] SAVE activeFlag='M' qty=222 × 6행 …",
              call_save(cur, "M", "222", n=6, measures=MSRS, months=MONS))
        rows = etc_test_rows(cur)
        etc2 = scalar(cur, f"SELECT COUNT(*) FROM {ETC}")
        ok_c = (len(rows) == 6 and all(float(r[3]) == 222.0 for r in rows) and etc2 == etc1)
        print("    ETC 테스트행 %d건 (QTY %s) / 총 %d행 (증가 %d)"
              % (len(rows), sorted({float(r[3]) for r in rows}), etc2, etc2 - etc1))
        print("    ⇒ UPDATE 경로 %s (행 증가 0 · 전 행 QTY 222)" % ("PASS" if ok_c else "FAIL"))

        # ── D. 조회 반영 ──────────────────────────────────────────────────────────────────
        # ⚠ 여기서 예외가 나도 [E]/[F] 정리가 반드시 돌아야 한다(테스트 행 원장 잔류 방지)
        ok_d = False
        try:
            rc = cur.var(oracledb.DB_TYPE_CURSOR)
            res = cur.var(oracledb.DB_TYPE_CURSOR)
            cur.callproc("SCM_MGR.PKG_DMF0044.P_DMF0044_GET_SALES_REPORTS_DATA", keywordParameters=dict(
                P_DIVISION_ID=DIV, P_MDF_TYPE=CUT, P_YYYY=YM[:4], P_SP_VERSION_NO=VER,
            # ⚠ P_CREATED_BY 는 GT_F044_SELECT_MEASURE(=사용자 titleset) 적재 키다.
            #   minyonglee1 은 SCM_MST_TITLESET_USER 에 SHEET_NAME 변형 2종('MDF Reports'/'mdfReports')이
            #   함께 있어 10개 메저가 각 2행 → 최종 JOIN 에서 전 값이 2배가 된다(별개 조회 결함).
            #   저장→조회 반영 자체를 재려면 **단일 변형 계정**으로 읽어야 한다.
            #   또한 GT_F044_SELECT_MEASURE.MEASURE 는 VARCHAR2(20) 이라 21자 메저 보유 계정
            #   (예: kjj0070)은 조회 자체가 ORA-12899 로 실패한다(별개 기존 결함).
                #   ⛔ 게다가 GET 은 titleset 이 없는 사용자에게 SHEET_NAME='MDF Reports' 행을
                #      **자동 생성**한다. 레거시 'mdfReports' 보유자로 호출하면 그 순간 변형 2종이
                #      되어 오염된다(2026-08-11 실사고 — dong.lee2/jssbae 20행 생성 후 원복).
                #      ⇒ 반드시 **이미 'MDF Reports' 만 보유한 계정**으로 읽는다.
                P_DATA_TYPE="2", P_USER_GROUP="ADMIN", P_CREATED_BY="jiwon.park",
                P_USER_ID="minyonglee1", P_MNU_ID="DMF0044",
                O_RC1=rc, O_RESULT_CURSOR=res))
            g = rc.getvalue()
            gcols = [c[0] for c in g.description]
            hit = [r for r in g.fetchall() if str(r[gcols.index("CELL_MODEL_INFO")]) == MARK]
            col = "M_" + YM
            vals = ([(h[gcols.index("MEASURE")], h[gcols.index(col)]) for h in hit]
                    if col in gcols else [])
            ok_d = len(hit) == 2 and all(v is not None and float(v) == 222.0 for _, v in vals)
            print("[D] GET(ETC) 테스트행 %d건 / %s = %s ⇒ 조회 반영 %s"
                  % (len(hit), col, vals, "PASS" if ok_d else "FAIL"))
        except Exception as e:  # noqa: BLE001
            print("[D] GET 실행 실패(조회 경로 별개 결함) — 정리는 계속 진행: %s" % str(e)[:220])

        # ── E. D 경로 ─────────────────────────────────────────────────────────────────────
        print("[E] SAVE activeFlag='D' × 6행 …",
              call_save(cur, "D", "222", n=6, measures=MSRS, months=MONS))
        rows = etc_test_rows(cur)
        ok_e = len(rows) == 0
        print("    ETC 테스트행 %d건 ⇒ DELETE 경로 %s" % (len(rows), "PASS" if ok_e else "FAIL"))

        # ── F. 잔여 정리 + 불변식 ─────────────────────────────────────────────────────────
        cur.execute(f"DELETE FROM {PLAN} WHERE DIVISION_ID=:d AND VERSION_NO=:v "
                    "AND ITEM_ID=:i", {"d": DIV, "v": VER, "i": ITEM})
        n_plan_clean = cur.rowcount
        con.commit()
        etc3 = scalar(cur, f"SELECT COUNT(*) FROM {ETC}")
        plan3 = scalar(cur, f"SELECT COUNT(*) FROM {PLAN}")
        ok_f = etc3 == etc0 and plan3 == plan0
        print("[F] PLAN 테스트 잔여 %d행 정리 / ETC %d→%d · PLAN %d→%d ⇒ 불변식 %s"
              % (n_plan_clean, etc0, etc3, plan0, plan3, "PASS" if ok_f else "FAIL"))

        allok = all([ok_b, ok_c, ok_d, ok_e, ok_f])
        print("\n=== 종합: %s ===" % ("PASS" if allok else "FAIL"))
        return 0 if allok else 1


if __name__ == "__main__":
    sys.exit(main())
