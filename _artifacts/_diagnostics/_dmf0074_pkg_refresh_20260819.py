#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""_dmf0074_pkg_refresh_20260818.py — DMF0074_CLOUD_20260819 rev.6 드리프트 검증 + 갱신

계획(dmf0074-logical-pebble.md):
  V1 BODY   : 패키지 02_BODY ↔ ALL_SOURCE 신선 덤프 (해시·라인·마커) + LAST_DDL
  V2 FE     : B_FE/metal-link-price ↔ 라이브 폴더 해시 전건
  V3 locales: 패키지 3본 ↔ 라이브 3본 해시 — 불일치 시 라이브 본으로 교체(--apply)
  V4 스윕   : 메타 10테이블 DMF0074 delta (직전 취합 2026-08-18 03:54 이후)
  V5 MSG/LBL: 11_MSG_LBL 의 23코드 원장 재대조

사용: python _dmf0074_pkg_refresh_20260818.py [--apply]
  (--apply 없으면 검증만 / 있으면 낡은 산출물 갱신까지)
"""
import hashlib
import os
import shutil
import sys
import time

import oracledb

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")

PKG = r"C:\Projects\NSCM\_artifacts\_deploy_packages\DMF0074_CLOUD_20260819"
LIVE_FE = r"C:\Projects\NSCM\nscm-fe\features\demand\src\pages\metal-link-price"
LIVE_LOC = r"C:\Projects\NSCM\nscm-fe\public\locales"
SINCE = "2026-08-18 04:00:00"  # 직전 취합 03:54 이후

META_TABLES = [
    ("SCM_ADM_CMBO_SQL_M", ["SQL_ID", "SQL_DTL_CTN"]),
    ("SCM_MST_SHEET_COLUMNS", ["PROGRAM_ID"]),
    ("SCM_MST_SHEET_MEASURE", ["PROGRAM_ID"]),
    ("SCM_ADM_PROC_M", ["PROC_NM"]),
    ("SCM_ADM_API_M", ["API_ID", "API_URL"]),
    ("SCM_ADM_MNU_BTN_MPG_M", ["MNU_ID", "API_ID"]),
    ("SCM_ADM_USER_GR_MNU_BTN_MPG_M", ["MNU_ID"]),
    ("SCM_ADM_EXCEL_COLUMNS", ["PROGRAM_ID"]),
    ("SCM_ADM_LOOKUP_MASTER_DETAIL", ["SEGMENT2"]),
    ("SCM_ADM_MSG_M", ["MSG_ID"]),
]

MSG_LBL_CODES = [
    "MSG00002", "MSG00097", "MSG00108", "MSG00137", "MSG00255",
    "MSG00265", "MSG00283", "MSG00614", "MSG00656",
    "LBL00001", "LBL00003", "LBL00011", "LBL00080", "LBL00112",
    "LBL00608", "LBL00617", "LBL00627", "LBL00653", "LBL00664",
    "LBL00665", "LBL00739", "LBL00762", "LBL00763",
]


def sha(path):
    return hashlib.sha256(open(path, "rb").read()).hexdigest()[:12]


def main():
    apply_mode = "--apply" in sys.argv
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
    fails = []

    # ── V1 BODY ───────────────────────────────────────────────────────────────
    print("=" * 100)
    print("[V1] PKG_DMF0074 BODY — 패키지 ↔ ALL_SOURCE")
    cur.execute(
        """SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0074'
            AND TYPE='PACKAGE BODY' ORDER BY LINE"""
    )
    live_body = "CREATE OR REPLACE " + "".join(r[0] for r in cur.fetchall()).rstrip() + "\n/\n"
    pkg_body_path = os.path.join(PKG, "A_DB", "02_PKG_DMF0074_BODY.sql")
    pkg_body = open(pkg_body_path, encoding="utf-8").read()
    h_live = hashlib.sha256(live_body.encode("utf-8")).hexdigest()[:12]
    h_pkg = hashlib.sha256(pkg_body.encode("utf-8")).hexdigest()[:12]
    cur.execute(
        """SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS
            WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0074' AND OBJECT_TYPE='PACKAGE BODY'"""
    )
    print(f"   LAST_DDL = {cur.fetchone()[0]} (기대 2026-08-18 14:06:xx)")
    for name, txt in (("패키지", pkg_body), ("라이브", live_body)):
        mk = txt.count("MRFPARITY 2026-08-18")
        t14 = sum(1 for ln in txt.splitlines() if ln.startswith("              AND    NVL(ATTRIBUTE7, 'N') = 'Y'"))
        t12 = sum(1 for ln in txt.splitlines() if ln.startswith("            AND    NVL(ATTRIBUTE7, 'N') = 'Y'"))
        print(f"   {name}: {len(txt.splitlines())}줄 / MRFPARITY {mk} / TEMPLATE활성 {t14} / UPLOAD활성 {t12}")
    if h_live == h_pkg:
        print(f"   해시 일치 OK ({h_pkg})")
    else:
        print(f"   ⚠ 해시 불일치 pkg={h_pkg} live={h_live}")
        if apply_mode:
            open(pkg_body_path, "w", encoding="utf-8", newline="").write(live_body)
            print("   → [apply] 라이브 덤프로 교체")
        else:
            fails.append("V1 BODY 해시")

    # ── V2 FE ─────────────────────────────────────────────────────────────────
    print("=" * 100)
    print("[V2] B_FE/metal-link-price ↔ 라이브")
    pkg_fe = os.path.join(PKG, "B_FE", "metal-link-price")
    diff = 0
    for root, _, files in os.walk(LIVE_FE):
        for f in files:
            lp = os.path.join(root, f)
            rel = os.path.relpath(lp, LIVE_FE)
            pp = os.path.join(pkg_fe, rel)
            if not os.path.exists(pp):
                print(f"   ⚠ 패키지 누락: {rel}")
                diff += 1
                if apply_mode:
                    os.makedirs(os.path.dirname(pp), exist_ok=True)
                    shutil.copy2(lp, pp)
                    print("     → [apply] 복사")
            elif sha(lp) != sha(pp):
                print(f"   ⚠ 내용 상이: {rel}")
                diff += 1
                if apply_mode:
                    shutil.copy2(lp, pp)
                    print("     → [apply] 교체")
    print(f"   {'전건 일치 OK' if diff == 0 else f'상이 {diff}건' + (' (갱신됨)' if apply_mode else '')}")
    if diff and not apply_mode:
        fails.append("V2 FE")

    # ── V3 locales ────────────────────────────────────────────────────────────
    print("=" * 100)
    print("[V3] B_FE/locales ↔ 라이브 (MSG01001 포함 여부)")
    for f in ("KO.json", "EN.json", "CN.json"):
        lp = os.path.join(LIVE_LOC, f)
        pp = os.path.join(PKG, "B_FE", "locales", f)
        same = sha(lp) == sha(pp)
        has01001 = "MSG01001" in open(pp, encoding="utf-8").read()
        print(f"   {f}: 해시 {'일치' if same else '상이'} / 패키지 MSG01001 {'有' if has01001 else '無'}")
        if not same:
            if apply_mode:
                shutil.copy2(lp, pp)
                print("     → [apply] 라이브 본으로 교체")
            else:
                fails.append(f"V3 {f}")

    # ── V4 메타 스윕 ──────────────────────────────────────────────────────────
    print("=" * 100)
    print(f"[V4] 메타 스윕 — {SINCE} 이후 DMF0074 delta (실패=중단)")
    for tbl, cols in META_TABLES:
        cur.execute(
            "SELECT COLUMN_NAME FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR' AND TABLE_NAME=:t",
            {"t": tbl},
        )
        have = {r[0] for r in cur.fetchall()}
        if not have:
            raise SystemExit(f"[중단] {tbl} 부재")
        idcols = [c for c in cols if c in have]
        if not idcols or "LAST_UPDATE_DATE" not in have:
            raise SystemExit(f"[중단] {tbl} 식별/갱신 컬럼 부재")
        like = " OR ".join(f"UPPER({c}) LIKE '%DMF0074%'" for c in idcols)
        cur.execute(
            f"""SELECT COUNT(*) FROM SCM_MGR.{tbl}
                 WHERE ({like}) AND LAST_UPDATE_DATE >= TO_DATE('{SINCE}','YYYY-MM-DD HH24:MI:SS')"""
        )
        n = cur.fetchone()[0]
        print(f"   {tbl:<34} delta = {n}")
        if n:
            fails.append(f"V4 {tbl} delta={n} — 산출물 추가 필요")

    # ── V5 MSG/LBL ────────────────────────────────────────────────────────────
    print("=" * 100)
    print("[V5] 11_MSG_LBL 23코드 원장 재대조")
    binds = ",".join(f":c{i}" for i in range(len(MSG_LBL_CODES)))
    cur.execute(
        f"SELECT COUNT(DISTINCT MSG_ID), COUNT(*) FROM SCM_ADM_MSG_M WHERE MSG_ID IN ({binds})",
        MSG_LBL_CODES,
    )
    codes, rows = cur.fetchone()
    print(f"   원장: {codes}코드 / {rows}행 (기대 23 / 69)")
    if codes != 23 or rows != 69:
        fails.append(f"V5 MSG/LBL {codes}/{rows}")

    print("=" * 100)
    print(f"[결과] {'전건 일치 — rev.6 상태 보증' if not fails else '드리프트: ' + ' · '.join(fails)}")
    cur.close()
    con.close()
    sys.exit(1 if fails else 0)


if __name__ == "__main__":
    main()
