#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""03_verify.py — 추출 JSON 13본 검증 게이트 (플랜 §2)

① crosscheck(카탈로그 대사) 존재 + 불일치 시 reason 필수
② TO-BE 콤보 control 인데 combo 문자열에서 CMBO SQL_ID 를 하나도 못 찾으면 FAIL
   (단 '미등록'/'없음'/'미확인' 명기는 통과)
③ AS-IS 콤보 원천 실존 — BigFilter.xml 또는 UP_FX_GetCommonDataList.sql 에 언급 실존
   ('_SCP 변형'/'미수록'/'미확인' 명기는 통과-주의)
④ evidence 라인번호 실존 (asis_stripped / nscm-fe 파일 인덱스 대조)
⑤ 13 UI 완비 + 조건 레코드 공란 금지
출력: 콘솔 + verify_report.json
"""
import glob
import json
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
UIS = ["DMF0003", "DMF0004", "DMF0005", "DMF0006", "DMF0007", "DMF0014", "DMF0020",
       "DMF0021", "DMF0042", "DMF0048", "DMF0072", "DMF0074", "DMF0082"]

BIGFILTER = r"C:\Projects\NSCM\GSCM\04.WSL\FoxQuery\DM\Common\BigFilter.xml"
UPFX = r"C:\Projects\NSCM\_artifacts\_diagnostics\asis_sp_bodies\UP_FX_GetCommonDataList.sql"
FE_ROOT = r"C:\Projects\NSCM\nscm-fe"

SKIP_MARKS = ("미등록", "미수록", "미확인", "없음", "N/A", "팝업", "달력", "텍스트", "체크",
              "정적", "고정", "SP ", "프로시저", "useTabProcQuery")


def read_any(path):
    raw = open(path, "rb").read()
    for enc in ("utf-8-sig", "utf-8", "cp949", "utf-16"):
        try:
            return raw.decode(enc)
        except UnicodeDecodeError:
            continue
    return raw.decode("utf-8", errors="replace")


def main():
    cmbo = json.load(open(os.path.join(HERE, "cmbo_meta.json"), encoding="utf-8"))
    cmbo_ids = {r["SQL_ID"] for r in cmbo}
    bigfilter = read_any(BIGFILTER)
    upfx = read_any(UPFX)

    # evidence 해석용 파일 인덱스: basename -> [fullpath]
    file_index = {}
    for p in glob.glob(os.path.join(HERE, "asis_stripped", "*.cs")):
        file_index.setdefault(os.path.basename(p), []).append(p)
    fe_dirs = []
    for feat, pages in (("demand", ["mkt-fcst", "customer-fcst-upload", "sales-plan", "business-plan",
                                    "sales-monitoring", "metal-link-price", "forecast-price"]),
                        ("master", ["sales-site", "sales-site-project-model", "customer-model-mapping",
                                    "customer-forecast-master", "sales-future-price", "nn-master-mapping"])):
        for pg in pages:
            fe_dirs.append(os.path.join(FE_ROOT, "features", feat, "src", "pages", pg))
    fe_dirs.append(os.path.join(FE_ROOT, "features", "master", "src", "components", "searchFields"))
    # AS-IS 원본 폴더 (Designer.cs / Framework evidence 용)
    asis_dirs = [
        r"C:\Projects\NSCM\GSCM\06.UIL\GSCM.DM.Forms.UIL\Plan",
        r"C:\Projects\NSCM\GSCM\06.UIL\GSCM.DM.Forms.UIL\Master",
    ]
    fw_files = [
        r"C:\Projects\NSCM\GSCM\01.Framework\GSCM.Windows.Forms\Service\DataService.cs",
        r"C:\Projects\NSCM\GSCM\01.Framework\GSCM.Windows.Forms\Class\Data_SCP.cs",
        r"C:\Projects\NSCM\GSCM\01.Framework\GSCM.Windows.Forms\Class\Data.cs",
        BIGFILTER, UPFX,
    ]
    for p in fw_files:
        if os.path.exists(p):
            file_index.setdefault(os.path.basename(p), []).append(p)
    for d in fe_dirs:
        for root, dirs, files in os.walk(d):
            if "BACKUP_20260818" in root or "node_modules" in root:
                continue
            for f in files:
                if f.endswith((".tsx", ".ts", ".cs")):
                    file_index.setdefault(f, []).append(os.path.join(root, f))
    for d in asis_dirs:
        for root, dirs, files in os.walk(d):
            for f in files:
                if f.endswith(".Designer.cs"):
                    file_index.setdefault(f, []).append(os.path.join(root, f))
    line_cache = {}

    def line_count(path):
        if path not in line_cache:
            line_cache[path] = read_any(path).count("\n") + 1
        return line_cache[path]

    report = {"fails": [], "warns": [], "ui": {}}

    for mid in UIS:
        path = os.path.join(HERE, "extract", f"{mid}.json")
        if not os.path.exists(path):
            report["fails"].append(f"{mid}: extract JSON 부재")
            continue
        data = json.load(open(path, encoding="utf-8"))
        conds = data.get("conditions", [])
        n_asis = sum(1 for c in conds if c.get("asis"))
        n_tobe = sum(1 for c in conds if c.get("tobe"))
        cc = data.get("crosscheck") or {}
        report["ui"][mid] = {
            "conds": len(conds), "asis": n_asis, "tobe": n_tobe,
            "catalog_screen": cc.get("catalog_screen"),
            "catalog_asis_rows": cc.get("catalog_asis_rows"),
            "catalog_tobe_rows": cc.get("catalog_tobe_rows"),
            "reason": cc.get("reason"),
        }
        if not conds:
            report["fails"].append(f"{mid}: 조건 0건")
        # ① 카탈로그 대사
        if not cc:
            report["fails"].append(f"{mid}: crosscheck 부재")
        else:
            ca, ct = cc.get("catalog_asis_rows"), cc.get("catalog_tobe_rows")
            if isinstance(ca, int) and ca != n_asis and not cc.get("reason"):
                report["fails"].append(f"{mid}: AS-IS 카운트 {n_asis} vs 카탈로그 {ca} — reason 없음")
            if isinstance(ct, int) and ct != n_tobe and not cc.get("reason"):
                report["fails"].append(f"{mid}: TO-BE 카운트 {n_tobe} vs 카탈로그 {ct} — reason 없음")

        for c in conds:
            cond = c.get("cond", "?")
            tag = f"{mid}/{cond}"
            if not c.get("asis") and not c.get("tobe"):
                report["fails"].append(f"{tag}: 양측 모두 null")
            # ⑤ 공란 금지 + ④ evidence
            for side in ("asis", "tobe"):
                s = c.get(side)
                if not s:
                    continue
                for k in ("control", "combo", "params", "filter", "cascade", "required", "default"):
                    v = s.get(k)
                    if v is None or (isinstance(v, str) and v.strip() == ""):
                        report["fails"].append(f"{tag}.{side}.{k}: 공란 (미확인 명기 필요)")
                for ev in s.get("evidence") or []:
                    ev_s = str(ev).strip()
                    # 관대 파서: '파일명(…확장자) … L123[,L456][-L789]' 복수 참조 허용.
                    #   cmbo_meta / SQL_NM 등 파일 아닌 근거는 검사 대상 아님(정보성).
                    refs = re.findall(
                        r"([\w.\-]+\.(?:cs|tsx|ts|xml|sql|json|md))\s*:?\s*((?:L?\d+(?:\s*[-~,]\s*)?)+)",
                        ev_s)
                    if not refs:
                        continue  # 파일 참조 없음 — 정보성 근거
                    for fname_raw, lines_raw in refs:
                        fname = os.path.basename(fname_raw.replace("\\", "/"))
                        if "..." in fname_raw:
                            report["warns"].append(f"{tag}.{side}: evidence 파일명 축약 '{ev_s}'")
                            continue
                        cands = file_index.get(fname)
                        if not cands:
                            report["warns"].append(f"{tag}.{side}: evidence 파일 미해석 '{ev_s}'")
                            continue
                        for ln_s in re.findall(r"\d+", lines_raw):
                            ln = int(ln_s)
                            if not any(ln <= line_count(p) for p in cands):
                                report["fails"].append(
                                    f"{tag}.{side}: evidence 라인 초과 '{fname}:{ln}' ({ev_s})")
            # ② TO-BE 콤보 실존
            t = c.get("tobe")
            if t and str(t.get("control", "")).startswith("콤보"):
                combo_s = str(t.get("combo", ""))
                ids = [w for w in re.findall(r"[A-Za-z][A-Za-z0-9_]+", combo_s) if w in cmbo_ids]
                if not ids and not any(mk in combo_s for mk in SKIP_MARKS):
                    report["fails"].append(f"{tag}: TO-BE 콤보 CMBO 미매칭 '{combo_s}'")
            # ③ AS-IS 콤보 원천 실존
            a = c.get("asis")
            if a and str(a.get("control", "")).startswith("콤보"):
                combo_s = str(a.get("combo", ""))
                if any(mk in combo_s for mk in SKIP_MARKS):
                    continue
                names = re.findall(r"[A-Za-z][A-Za-z0-9_]+", combo_s)
                found = any((n in bigfilter or ("'" + n + "'") in upfx or n in upfx)
                            for n in names if len(n) > 3 and n not in
                            ("GetDMInnerTable", "Data", "Common", "Type", "CMBO", "true", "false"))
                if not found:
                    report["warns"].append(f"{tag}: AS-IS 콤보 원천 미확인 '{combo_s}'")

    with open(os.path.join(HERE, "verify_report.json"), "w", encoding="utf-8") as f:
        json.dump(report, f, ensure_ascii=False, indent=1)

    print("=" * 90)
    for mid in UIS:
        u = report["ui"].get(mid)
        if u:
            print(f"{mid}: 조건 {u['conds']} (AS-IS {u['asis']} / TO-BE {u['tobe']}) "
                  f"카탈로그[{u['catalog_screen']}]: {u['catalog_asis_rows']}/{u['catalog_tobe_rows']}")
    print("=" * 90)
    print(f"FAIL {len(report['fails'])}건")
    for x in report["fails"][:60]:
        print("  X", x)
    print(f"WARN {len(report['warns'])}건")
    for x in report["warns"][:40]:
        print("  !", x)
    sys.exit(1 if report["fails"] else 0)


if __name__ == "__main__":
    main()
