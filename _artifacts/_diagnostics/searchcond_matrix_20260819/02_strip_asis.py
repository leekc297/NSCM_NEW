#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""02_strip_asis.py — AS-IS .cs 13본 주석 제거 전처리본 생성 (hook #138 §3)

strip_code_comments.py --mode cs 를 라이브러리로 사용. 라인 수 1:1 보존 —
전처리본 라인번호 = 원본 라인번호 (evidence 인용용).
출력: asis_stripped/{MENU_ID}.cs
"""
import os
import sys

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from strip_code_comments import strip_cs  # noqa: E402

BASE = r"C:\Projects\NSCM\GSCM\06.UIL\GSCM.DM.Forms.UIL"
HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, "asis_stripped")

TARGETS = {
    "DMF0003": r"Plan\DMF0003_MktFcst\DMF0003_MktFcst.cs",
    "DMF0004": r"Master\DMF0004_SalesSite\DMF0004_SalesSite.cs",
    "DMF0005": r"Master\DMF0005_SaleSite_PjtModelMapping\DMF0005_SaleSite_PjtModelMapping.cs",
    "DMF0006": r"Master\DMF0006_CustomerModelMapping\DMF0006_CustomerModelMapping.cs",
    "DMF0007": r"Master\DMF0007_CustFcstMaster\DMF0007_CustFcstMaster.cs",
    "DMF0014": r"Plan\DMF0014_CustFcstUpload\DMF0014_CustFcstUpload.cs",
    "DMF0020": r"Master\DMF0020_SalesFuturePrice\DMF0020_SalesFuturePrice.cs",
    "DMF0021": r"Plan\DMF0021_SalesPlan\DMF0021_SalesPlan.cs",
    "DMF0042": r"Plan\DMF0042_BizPlan\DMF0042_BizPlan.cs",
    "DMF0048": r"Plan\DMF0048_SalesMonitoring\DMF0048_SalesMonitoring.cs",
    "DMF0072": r"Master\DMF0072_NNMasterMapping\DMF0072_NNMasterMapping.cs",
    "DMF0074": r"Plan\DMF0074_MetalLinkPrice\DMF0074_MetalLinkPrice.cs",
    "DMF0082": r"Plan\DMF0082_FcstNPrice_Mgmt\DMF0082_FcstNPrice_Mgmt.cs",
}


def read_any(path):
    raw = open(path, "rb").read()
    for enc in ("utf-8-sig", "utf-8", "cp949", "utf-16"):
        try:
            return raw.decode(enc)
        except UnicodeDecodeError:
            continue
    return raw.decode("utf-8", errors="replace")


def main():
    os.makedirs(OUT, exist_ok=True)
    for mid, rel in TARGETS.items():
        src = os.path.join(BASE, rel)
        text = read_any(src)
        stripped = strip_cs(text)
        n_src, n_out = text.count("\n"), stripped.count("\n")
        assert n_src == n_out, f"{mid}: 라인 수 불일치 {n_src} vs {n_out}"
        out_path = os.path.join(OUT, f"{mid}.cs")
        with open(out_path, "w", encoding="utf-8", newline="") as f:
            f.write(stripped)
        print(f"{mid}: {n_src + 1}줄 → {out_path} (라인 보존 OK)")


if __name__ == "__main__":
    main()
