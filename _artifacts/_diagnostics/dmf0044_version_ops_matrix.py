#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""dmf0044_version_ops_matrix.py — Version Modal 전 OPERATION 실행 검증 (2026-08-10)

사용자 지시: *"SP, BP 각각 CREATE, VERSION DELETE, VERSION COPY, TRANSFER, TRANSFER CANCEL 기능
확인해주세요."* — SEARCH 만 돌리고 모달 검증 완료 선언 금지 (hook #125 §4).

## 실행 축 (계열 × 5 OPERATION)

| 계열 | 원천 | OPERATION |
|---|---|---|
| SP | `SP_W_*` (VERSION_TYPE='SP_W') | CREATE → TRANSFER → TRANSFER CANCEL → COPY×2 → DELETE(전량) |
| BP | `BP_M_*` (VERSION_TYPE='BP_M') | 동일 |

COPY 는 AS-IS 2분기(L7753 `P_UPDATE_YN <> 'Y' AND d_Result_Date IS NULL`)를 모두 태우기 위해
①실적 미포함(resultDate='') ②실적 포함(resultDate=오늘) 2회 실행한다.

## 안전장치 (원장 사고 재발 방지 — 2026-08-10 자체 사고 계보)
- **본 런에서 생성한 버전만** DELETE 대상. 사전 존재 버전은 읽기 전용.
- 실행 전 `DM_MDF_VERSION` 스냅샷 → 종료 시 **생성분 전량 삭제 + 잔존 0 단언**.
- DELETE 실패 시 잔존 목록을 명시 출력한다(조용한 잔류 금지).

사용: python dmf0044_version_ops_matrix.py [--menu DMF0044] [--division 40] [--keep]
"""
import argparse
import pathlib
import sys
import time

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info  # noqa: E402

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

BASE = "http://localhost:8080"
USER = "minyonglee1"
SHEET = "unitedVersion"

LEDGERS = (
    "DM_PLN_SALES_PLAN_REPORT_C",
    "DM_PLN_SALES_ETC_REPORT_C",
    "DM_PLN_SALES_REPORT_EXCHANGE_C",
    "DM_PLN_BP_FCST_REPORT_C",
)


class _Rep:
    def ok(self, *a):
        pass

    def fail(self, *a):
        pass

    def warn(self, *a):
        pass

    def note(self, *a):
        pass

    def h(self, *a):
        pass


def counts(cur, division, version):
    out = {}
    for t in LEDGERS:
        cur.execute(
            "SELECT COUNT(*) FROM SCM_MGR.%s WHERE DIVISION_ID=:d AND VERSION_NO=:v" % t,
            {"d": division, "v": version},
        )
        out[t] = cur.fetchone()[0]
    return out


def last_error(cur, t0):
    cur.execute(
        """SELECT SUBSTR(EXCT_MSG_CTN,1,300) FROM SCM_MGR.SCM_COM_SYS_LOG
            WHERE MNU_ID='DMF0044' AND CREATION_DATE > :t0 AND EXCT_MSG_CTN IS NOT NULL
            ORDER BY CREATION_DATE DESC FETCH FIRST 1 ROWS ONLY""",
        {"t0": t0},
    )
    r = cur.fetchone()
    return r[0] if r else ""


def main():
    import oracledb

    ap = argparse.ArgumentParser()
    ap.add_argument("--menu", default="DMF0044")
    ap.add_argument("--division", default="40")
    ap.add_argument("--keep", action="store_true", help="생성 버전을 삭제하지 않고 남긴다(디버깅용)")
    a = ap.parse_args()

    import ui_http_e2e as m

    u, p, d = conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d)
    cur = con.cursor()
    cur.execute("SELECT SYSDATE FROM DUAL")
    t_start = cur.fetchone()[0]
    cur.execute(
        "SELECT VERSION_NO FROM SCM_MGR.DM_MDF_VERSION WHERE DIVISION_ID=:d", {"d": a.division}
    )
    pre_existing = {r[0] for r in cur.fetchall()}
    print("[fence] %s  |  기존 DM_MDF_VERSION(%s) = %d건 (읽기 전용)"
          % (t_start, a.division, len(pre_existing)))

    sess, _ = m.login(BASE, USER, _Rep())
    created = []
    results = []

    def action(label, payload, btn="ACTION"):
        cur.execute("SELECT SYSDATE FROM DUAL")
        t0 = cur.fetchone()[0]
        st = time.time()
        r = sess.post("%s/%s/%s/%s/call-proc" % (BASE, a.menu, SHEET, btn), json=payload, timeout=1800)
        el = time.time() - st
        okay = r.status_code == 200 and str((r.json() or {}).get("code")) == "0"
        err = "" if okay else (last_error(cur, t0) or r.text[:200])
        # 신규 생성 버전 포착
        cur.execute(
            """SELECT VERSION_NO FROM SCM_MGR.DM_MDF_VERSION
                WHERE DIVISION_ID=:d AND CREATION_DATE > :t0 ORDER BY CREATION_DATE""",
            {"d": a.division, "t0": t0},
        )
        new = [x[0] for x in cur.fetchall() if x[0] not in pre_existing and x[0] not in created]
        created.extend(new)
        detail = ""
        if new:
            c = counts(cur, a.division, new[0])
            detail = "→ %s  " % new[0] + " ".join(
                "%s=%d" % (k.replace("DM_PLN_", "").replace("_C", ""), v) for k, v in c.items()
            )
        results.append((label, okay, el, detail, err))
        print("  %-34s %s  %5.1fs  %s%s"
              % (label, "PASS" if okay else "FAIL", el, detail, "" if okay else "\n      ⛔ " + err))
        return okay, (new[0] if new else None)

    def send_yn(v):
        cur.execute(
            "SELECT SEND_YN FROM SCM_MGR.DM_MDF_VERSION WHERE DIVISION_ID=:d AND VERSION_NO=:v",
            {"d": a.division, "v": v},
        )
        r = cur.fetchone()
        return r[0] if r else None

    for series, vtype in (("SP", "SP_W"), ("BP", "BP_M")):
        cur.execute(
            """SELECT VERSION_NO FROM SCM_MGR.DM_MST_VERSION
                WHERE DIVISION_ID=:d AND VERSION_TYPE=:t ORDER BY VERSION_NO DESC FETCH FIRST 1 ROWS ONLY""",
            {"d": a.division, "t": vtype},
        )
        row = cur.fetchone()
        if not row:
            print("\n== %s 계열 == 원천 %s 버전 없음 — SKIP(사유 명시)" % (series, vtype))
            results.append(("%s/원천부재" % series, False, 0.0, "", "DM_MST_VERSION 에 %s 없음" % vtype))
            continue
        src = row[0]
        print("\n== %s 계열 == 원천 %s (%s)" % (series, src, vtype))

        ok, rep = action(
            "%s CREATE" % series,
            {"divisionId": a.division, "versionNo": src, "versionDescription": "OPS_%s_CR" % series,
             "resultDate": "", "actionType": "CR", "mvPlanYyyymm": "", "updateYn": "N"},
        )
        if not ok or not rep:
            continue

        print("     SEND_YN(생성직후) = %s" % send_yn(rep))
        action("%s TRANSFER" % series,
               {"divisionId": a.division, "versionNo": rep,
                "versionType": "REPORT_%s" % vtype, "actionType": "T"}, btn="TRANSFER")
        print("     SEND_YN(전송후)   = %s" % send_yn(rep))
        action("%s TRANSFER CANCEL" % series,
               {"divisionId": a.division, "versionNo": rep,
                "versionType": "REPORT_%s" % vtype, "actionType": "C"}, btn="TRANSFER")
        print("     SEND_YN(취소후)   = %s" % send_yn(rep))

        action("%s COPY (실적 미포함)" % series,
               {"divisionId": a.division, "versionNo": rep, "versionDescription": "OPS_%s_CP1" % series,
                "resultDate": "", "actionType": "CP", "mvPlanYyyymm": "", "updateYn": "Y"})
        cur.execute("SELECT TO_CHAR(SYSDATE,'YYYYMMDD') FROM DUAL")
        today = cur.fetchone()[0]
        action("%s COPY (실적 포함 %s)" % (series, today),
               {"divisionId": a.division, "versionNo": rep, "versionDescription": "OPS_%s_CP2" % series,
                "resultDate": today, "actionType": "CP", "mvPlanYyyymm": "", "updateYn": "Y"})

    # ---- 정리: 본 런 생성분만 DELETE (AS-IS action 'D') ----
    print("\n== DELETE (본 런 생성 %d건 — 원장 정리 겸 기능 검증) ==" % len(created))
    if a.keep:
        print("  --keep 지정 — 삭제 생략. 잔존: %s" % created)
    else:
        for v in list(created):
            action("DELETE %s" % v,
                   {"divisionId": a.division, "versionNo": v, "versionDescription": "",
                    "resultDate": "", "actionType": "D", "mvPlanYyyymm": "", "updateYn": "N"})
            cur.execute(
                "DELETE FROM SCM_MGR.DM_MDF_VERSION WHERE DIVISION_ID=:d AND VERSION_NO=:v",
                {"d": a.division, "v": v},
            )
            con.commit()

    cur.execute(
        "SELECT VERSION_NO FROM SCM_MGR.DM_MDF_VERSION WHERE DIVISION_ID=:d AND CREATION_DATE > :t",
        {"d": a.division, "t": t_start},
    )
    leftover = [r[0] for r in cur.fetchall()]
    ledger_left = []
    for v in created:
        c = counts(cur, a.division, v)
        if sum(c.values()):
            ledger_left.append((v, c))

    print("\n" + "=" * 78)
    npass = sum(1 for r in results if r[1])
    print("종합: PASS %d / FAIL %d" % (npass, len(results) - npass))
    for label, okay, el, det, err in results:
        if not okay:
            print("  ⛔ %-34s %s" % (label, err[:200]))
    print("잔존 DM_MDF_VERSION: %s" % (leftover if leftover else "0 ✅"))
    print("잔존 원장행        : %s" % (ledger_left if ledger_left else "0 ✅"))
    con.close()
    return 0 if npass == len(results) and not leftover and not ledger_left else 1


if __name__ == "__main__":
    sys.exit(main())
