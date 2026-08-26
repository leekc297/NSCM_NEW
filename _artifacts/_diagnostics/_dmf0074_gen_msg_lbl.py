#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""_dmf0074_gen_msg_lbl.py — DMF0074 이관 패키지의 MSG/LBL 축 생성 (2026-08-18)

배경: `_survey/axis_sweep_result.json` 의 C_msg_lbl_mnu 는 코드를 찾아냈는데
      `10_META_DMF0074_ALL_AXES.sql` 에는 MSG/LBL 문장이 **한 건도 없다**
      (이관패키지 MSG/LBL/MNU 4분류 동봉 의무 위반 계보).

정책: **INSERT-only** (WHEN NOT MATCHED 만). 클라우드에 같은 코드가 이미 있으면
      그 문구를 절대 덮어쓰지 않는다 — 코드는 화면 간 공유 자산이라 한 화면 기준으로
      덮으면 다른 화면이 조용히 오표기된다(2026-08-14 사용자 확정).
"""
import os
import sys
import time

import oracledb

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")

OUT = (r"C:\Projects\NSCM\_artifacts\_deploy_packages\DMF0074_CLOUD_20260818"
       r"\A_DB\11_MSG_LBL_DMF0074.sql")

CODES = [
    # MSG — 화면 사용분 (AS-IS 미등록 MSG00049 / MSG00427 은 TO-BE 미사용이라 제외)
    "MSG00002", "MSG00097", "MSG00108", "MSG00137", "MSG00255",
    "MSG00265", "MSG00283", "MSG00614", "MSG00656",
    # LBL — 화면 사용분 (SCM_ADM_MSG_M 이 MSG/LBL 공용 원장)
    "LBL00001", "LBL00003", "LBL00011", "LBL00080", "LBL00112",
    "LBL00608", "LBL00617", "LBL00627", "LBL00653", "LBL00664",
    "LBL00665", "LBL00739", "LBL00762", "LBL00763",
]


def q(s: str) -> str:
    return s.replace("'", "''")


def main():
    import ora

    u, p, d = ora.conn_info()
    con = None
    for _ in range(10):
        try:
            con = oracledb.connect(user=u, password=p, dsn=d)
            break
        except Exception:  # noqa: BLE001
            time.sleep(10)
    if con is None:
        raise SystemExit("접속 실패")
    cur = con.cursor()

    binds = ",".join(f":c{i}" for i in range(len(CODES)))
    cur.execute(
        f"""SELECT MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN
              FROM SCM_ADM_MSG_M WHERE MSG_ID IN ({binds})
             ORDER BY MSG_ID, LANG_CD""",
        CODES,
    )
    rows = cur.fetchall()
    found = sorted({r[0] for r in rows})
    missing = [c for c in CODES if c not in found]

    lines = [
        "-- 11_MSG_LBL_DMF0074.sql — DMF0074 사용 MSG/LBL 축 (사내 원장 실값, 2026-08-18)",
        "--",
        "-- ⚠ INSERT-only. 클라우드에 같은 코드가 이미 있으면 **문구를 덮어쓰지 않는다**",
        "--   (코드는 화면 간 공유 자산 — 한 화면 기준으로 덮으면 다른 화면이 조용히 오표기).",
        "--   적용 후 차이가 있으면 대조해 별도 판단할 것.",
        f"-- 대상 {len(found)} 코드 x 언어 = {len(rows)} 행. SCM_ADM_MSG_M 은 MSG/LBL 공용 원장.",
        "--",
        "-- AS-IS 코드 중 사내 원장 미등록분(이관 대상 아님):",
        "--   MSG00049(유효한 날짜 형식 아님) → TO-BE dayjs .isValid() 로 대체",
        "--   MSG00427(MRF:Y 버전 없음)      → TO-BE MSG00656 으로 신규 채번 대체",
        "",
    ]
    for msg_id, lang, nm, tp, use in rows:
        lines += [
            "MERGE INTO SCM_MGR.SCM_ADM_MSG_M T",
            f"USING (SELECT '{msg_id}' AS MSG_ID, '{lang}' AS LANG_CD FROM DUAL) S",
            "ON (T.MSG_ID = S.MSG_ID AND T.LANG_CD = S.LANG_CD)",
            "WHEN NOT MATCHED THEN INSERT (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN,"
            " CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)",
            f"VALUES ('{msg_id}', '{lang}', '{q(nm or '')}', '{q(tp or 'MSG')}',"
            f" '{q(use or 'Y')}', 'admin', SYSDATE, 'admin', SYSDATE);",
            "",
        ]
    lines += [
        "COMMIT;",
        "",
        "-- 검증: 아래가 0행이면 전 코드 등재 완료",
        "SELECT C.CODE FROM (",
        "  " + " UNION ALL ".join(f"SELECT '{c}' AS CODE FROM DUAL" for c in found),
        ") C WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_MSG_M M WHERE M.MSG_ID = C.CODE);",
        "",
    ]

    os.makedirs(os.path.dirname(OUT), exist_ok=True)
    with open(OUT, "w", encoding="utf-8", newline="") as f:
        f.write("\n".join(lines))

    print(f"생성: {OUT}")
    print(f"  코드 {len(found)}종 / 행 {len(rows)}건")
    if missing:
        print(f"  ⚠ 원장 미등록(제외): {', '.join(missing)}")
    cur.close()
    con.close()


if __name__ == "__main__":
    main()
