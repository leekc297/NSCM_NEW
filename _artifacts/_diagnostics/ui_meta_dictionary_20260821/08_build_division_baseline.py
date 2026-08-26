#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""08_build_division_baseline.py — division별 AS-IS 기준 대조 (사용자 지정 2026-08-21).

배경: TO-BE 가 AS-IS 보다 **넓은 division 을 개방**한 화면은, 개방된 division 의 동작 근거가
      자기 AS-IS 원본에 없다. DMF0082 가 그렇다 — `DMF0082.cs:L342` 가 조회조건 Division 을
      `CODE='40'` 로 단일 고정해 81/82 는 조회조건 진입 자체가 불가했다.
      그래서 "AS-IS 에 없다" 를 곧 "결함" 으로 읽으면 안 되고, **division 마다 기준 화면을 바꿔**
      대조해야 한다 (00_config.DIVISION_BASELINE).

DMF0082 기준: 40 → AS-IS DMF0082 / 81·82 → AS-IS DMF0003 (Mkt Fcst)

산출: dict_division_baseline.json
  · per-division 기준 컬럼 집합 (기준 화면에서 그 division 을 포함하는 행)
  · TO-BE 현재 컬럼과의 대조 — 기준에 있고 TO-BE 에 없음 / TO-BE 단독 / 편집속성 불일치
  · 조회조건도 동일 규칙으로 기준 화면에서 뽑아 대조

⚠ 조인 키는 **COLUMN_NAME(정규화본)** 이다. 시트명이 화면마다 다르고(FcstNPrice ↔ Mkt Fcst),
   AS-IS DMF0003 은 division 40 전용 컬럼에 '40' 접미를 붙인다(ITEM_ID40 ↔ ITEM_ID).
   접미를 떼지 않으면 같은 축이 갈라져 허위 격차가 생긴다 (cfg.norm_col).
⚠ 이 산출물은 **대조표**다. 여기 값으로 메타를 자동 INSERT 하지 않는다
   (`ui-category-setup-no-arbitrary-data` 승계).
"""
import collections
import os
import sys

import cfg

# 편집 관련 속성 — division 별 "편집 가능 항목" 기준의 실체
EDIT_ATTRS = ["CELL_CONTROL_OBJECT_TYPE_CODE", "CELL_COMBO_DATA_TYPE",
              "VISIBLE_FLAG", "COLUMN_LABEL_NAME"]

# ⚠ **AS-IS 메타로 판정 불가한 축** — AS-IS `INPUT_TP_CD` 는 14,675행 **전부 'S'** 다.
#   그래서 이 축을 그냥 비교하면 거의 모든 컬럼이 'S'→'IO/IM' 불일치로 잡혀 진짜 신호를 덮는다
#   (초기 구현이 그랬다: div40 11건 중 9건이 이 축이었다).
#   AS-IS 의 실제 편집 가능 여부는 `.cs` 의 LockRange/LockColumn 에 있고 메타에 없다.
#   ⇒ 별도 버킷으로 빼서 "판정 불가" 로 명시한다. 숨기지도, 결함으로 세지도 않는다.
UNDECIDABLE_ATTRS = ["INPUT_TP_CD"]


def div_rows(rows, program, sheet, division):
    """기준 화면·**시트**에서 해당 division 을 포함하는 행 (DIVISION_ID 토큰 집합 판정)."""
    out = {}
    for r in rows:
        if r["PROGRAM_ID"] != program or cfg.norm_txt(r["SHEET_NAME"]) != sheet:
            continue
        toks = cfg.norm_div(r["DIVISION_ID"])
        # DIVISION_ID 공란 = division 무관(전 division 공통)으로 본다 — AS-IS 프레임워크 동작.
        if toks and division not in toks:
            continue
        out[cfg.norm_col(r["COLUMN_NAME"])] = r
    return out


def cond_rows(extract_dir, program, division):
    """기준 화면의 AS-IS 조회조건 중 해당 division 에서 사용되는 항목."""
    p = os.path.join(extract_dir, f"{program}.json")
    if not os.path.exists(p):
        return {}, f"extract/{program}.json 없음"
    d = cfg.jload(p)
    key = "div40" if division == "40" else ("div82" if division == "82" else "div81")
    out = {}
    for c in d.get("conditions", []):
        a = c.get("asis") or {}
        raw = cfg.norm_txt(a.get(key))
        low = raw.lower()
        unusable = any(w in low for w in ("진입 불가", "불가", "disabled", "비활성", "숨김", "미사용"))
        out[c["cond"]] = {
            "usable": bool(raw) and not unusable,
            "raw": raw or cfg.unknown("서술 없음"),
            "control": a.get("control") or cfg.unknown("AS-IS 서술 없음"),
            "combo": a.get("combo") or cfg.unknown("AS-IS 서술 없음"),
        }
    return out, ""


def main():
    asis = cfg.jload("asis_columns.json")["rows"]
    tobe = cfg.jload("tobe_columns.json")["rows"]
    out = {}

    for target, spec in cfg.DIVISION_BASELINE.items():
        tsheet = spec["target_sheet"]
        mapping = spec["by_division"]
        tobe_by_div = {d: div_rows(tobe, target, tsheet, d) for d in mapping}

        per_div = {}
        for division, (src, ssheet) in mapping.items():
            base = div_rows(asis, src, ssheet, division)
            cur = tobe_by_div[division]
            missing = sorted(set(base) - set(cur))
            extra = sorted(set(cur) - set(base))
            mismatch, undecidable = [], []
            for c in sorted(set(base) & set(cur)):
                b, t = base[c], cur[c]
                diff = {k: {"baseline": cfg.norm_txt(b[k]), "tobe": cfg.norm_txt(t[k])}
                        for k in EDIT_ATTRS
                        if cfg.norm_txt(b[k]) != cfg.norm_txt(t[k])}
                und = {k: {"baseline": cfg.norm_txt(b[k]), "tobe": cfg.norm_txt(t[k])}
                       for k in UNDECIDABLE_ATTRS
                       if cfg.norm_txt(b[k]) != cfg.norm_txt(t[k])}
                if diff:
                    mismatch.append({"column": c, "diff": diff})
                if und:
                    undecidable.append({"column": c, "diff": und})
            conds, note = cond_rows(cfg.SEARCHCOND_EXTRACT, src, division)
            per_div[division] = {
                "baseline_source": f"{src} / {ssheet}",
                "self_source": src == target,
                "baseline_columns": len(base),
                "tobe_columns": len(cur),
                "missing_vs_baseline": missing,
                "tobe_only": extra,
                "attr_mismatch": mismatch,
                "attr_undecidable": undecidable,
                "search_conditions_usable": sorted(k for k, v in conds.items() if v["usable"]),
                "search_conditions_unusable": sorted(k for k, v in conds.items() if not v["usable"]),
                "search_condition_note": note or "",
            }
            print(f"  [{target} / div {division:6s}] 기준={src}/{ssheet:12s} "
                  f"기준컬럼 {len(base):3d} · TO-BE {len(cur):3d} · "
                  f"기준에만 {len(missing):3d} · TO-BE만 {len(extra):3d} · 속성불일치 {len(mismatch):3d} "
                  f"(판정불가 {len(undecidable):2d}) · "
                  f"조회조건 사용가능 {len(per_div[division]['search_conditions_usable'])}")
        out[target] = {
            "target_sheet": tsheet,
            "mapping": {k: f"{v[0]} / {v[1]}" for k, v in mapping.items()},
            "join_key": cfg.DIVISION_BASELINE_JOIN + " (division 접미 정규화: cfg.norm_col)",
        "name_suffixes_stripped": list(cfg.DIVISION_BASELINE_NAME_SUFFIXES),
            "per_division": per_div,
        }

    meta = {
        "snapshot": cfg.SNAPSHOT_DATE,
        "rule": "division 마다 AS-IS 기준 화면을 달리 본다 (00_config.DIVISION_BASELINE)",
        "why": "TO-BE 가 AS-IS 보다 넓은 division 을 개방한 화면은 자기 AS-IS 에 그 division 의 "
               "동작 근거가 없다. DMF0082 = DMF0082.cs:L342 dtDivision.Select(\"CODE='40'\") 로 "
               "조회조건 40 단일 고정 → 81/82 기준은 AS-IS DMF0003(Mkt Fcst).",
        "join_key": cfg.DIVISION_BASELINE_JOIN + " (division 접미 정규화: cfg.norm_col)",
        "name_suffixes_stripped": list(cfg.DIVISION_BASELINE_NAME_SUFFIXES),
        "division_id_blank": "DIVISION_ID 공란 = division 무관(전 division 공통)으로 판정",
        "compare_attrs": EDIT_ATTRS,
        "undecidable_attrs": UNDECIDABLE_ATTRS,
        "undecidable_why": "AS-IS INPUT_TP_CD 는 전행 'S' 라 비교 의미가 없다. AS-IS 의 편집 가능 "
                           "여부는 .cs LockRange/LockColumn 에 있고 메타에 없다 — 판정 불가 축.",
        "usage": "대조표다. 이 값으로 메타를 자동 INSERT 하지 않는다 "
                 "(ui-category-setup-no-arbitrary-data 승계).",
    }
    print("  -> " + cfg.jdump({"meta": meta, "targets": out}, "dict_division_baseline.json"))


if __name__ == "__main__":
    sys.exit(main())
