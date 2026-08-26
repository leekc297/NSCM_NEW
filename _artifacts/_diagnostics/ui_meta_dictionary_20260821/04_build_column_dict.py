#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""04_build_column_dict.py — SHEET_COLUMN 지식사전 (COLUMN_NAME 축) 생성.

목적 (사용자 명시): 신규 UI 의 GRID COLUMN 에서
  · 콤보 미설정/오지정으로 **NAME 대신 CODE 가 표시**되는 사고
  · ITEM(MODEL) 처럼 **MODAL 미설정으로 선택 창이 안 뜨는** 사고
를 "화면마다 다시 판단" 대신 "사전 대조"로 막는다.

설계 핵심 3가지 (실측이 강제한 것)
  ① AS-IS 의 INPUT_TP_CD 는 전행 'S' 단일값이고 FPModal 은 0건이다 → **편집·모달 축은
     AS-IS 메타로 검증 불가**. 근거는 TO-BE 실적 + AS-IS `.cs` 이며 confidence 로 강도를 표시한다.
  ② naive 최빈값은 오답을 만든다 (ITEM_ID 445행 중 FPTextBox 205 = 읽기전용 표시행이 대다수).
     → **표시(display) 표준 / 편집(edit) 표준**을 분리하고, 편집표준의 모집단은
     콤보·모달이 실제로 배정된 행으로만 잡는다.
  ③ 대소문자 변형이 있다 (item_id/ITEM_ID, incoterms/INCOTERMS, plant_site_id).
     → UPPER 정규화 키 + 변형 실측 기록.

입력  asis_columns.json / tobe_columns.json / cmbo_meta.json /
      lookup_domain_tobe.json(정본) + lookup_domain_asis.json(교차검증)
출력  dict_sheet_columns.json  (사전 + 프로그램별 결함 D1~D10)
"""
import collections
import sys

import cfg
import detectors

# 편집표준 confidence 임계 — 근거 행수
CONF = [(5, "high"), (2, "medium"), (1, "low")]

# 세션이 자동 주입하는 콤보 토큰 (FE 전달 의무 대상에서 제외)
SESSION_TOKENS = {"@sesuserid", "@seslangcd"}


def conf_of(n):
    for lo, name in CONF:
        if n >= lo:
            return name
    return "none"


def mode_of(counter, unknown_reason):
    """최빈값 + 전체 분포. 근거가 없으면 미확인(사유)."""
    if not counter:
        return {"value": cfg.unknown(unknown_reason), "n": 0, "dist": {}}
    value, n = counter.most_common(1)[0]
    return {"value": value, "n": n, "dist": dict(counter.most_common())}


def norm_key(name):
    return (name or "").strip().upper()


def load_side(fname):
    d = cfg.jload(fname)
    return d["rows"], d["meta"]


def main():
    asis_rows, asis_meta = load_side("asis_columns.json")
    tobe_rows, tobe_meta = load_side("tobe_columns.json")
    cmbo = cfg.jload("cmbo_meta.json")
    lk_tobe = cfg.jload("lookup_domain_tobe.json")
    lk_asis = cfg.jload("lookup_domain_asis.json")

    cmbo_ids = {r["SQL_ID"] for r in cmbo}
    cmbo_tokens = {}
    for r in cmbo:
        cmbo_tokens.setdefault(r["SQL_ID"], set()).update(r["TOKENS"])
    # 값 도메인 정본 = TO-BE lookup. AS-IS 판은 교차검증용 — 갈리면 사전에 기록한다.
    lookup_controls = set(lk_tobe["by_type"].get("CELL_CONTROL_OBJECT_TYPE_CODE", []))
    asis_controls = set(lk_asis["by_type"].get("CELL_CONTROL_OBJECT_TYPE_CODE", []))
    if not lookup_controls:
        raise SystemExit("[LOOKUP EMPTY] TO-BE 컨트롤 도메인 0건 — 02_dump_tobe.py 를 다시 실행하십시오")
    lookup_divergence = {
        "tobe_only": sorted(lookup_controls - asis_controls),
        "asis_only": sorted(asis_controls - lookup_controls),
        "aligned": sorted(lookup_controls) == sorted(asis_controls),
    }
    # 허용 컨트롤 = FE enum ∪ lookup. 둘 중 하나에만 있는 값은 사전에 사유로 남긴다.
    allowed_controls = set(cfg.CELL_CONTROL_TYPES) | lookup_controls
    fe_only = sorted(set(cfg.CELL_CONTROL_TYPES) - lookup_controls)
    lookup_only = sorted(lookup_controls - set(cfg.CELL_CONTROL_TYPES))
    print(f"  콤보 {len(cmbo_ids)}종 · 허용 컨트롤 {len(allowed_controls)}종"
          f" (FE 전용 {fe_only} / lookup 전용 {lookup_only})")
    print(f"  값도메인 AS-IS↔TO-BE {'일치' if lookup_divergence['aligned'] else lookup_divergence}")

    keys = sorted({norm_key(r["COLUMN_NAME"]) for r in asis_rows} |
                  {norm_key(r["COLUMN_NAME"]) for r in tobe_rows})
    by_key = {k: {"asis": [], "tobe": []} for k in keys}
    for r in asis_rows:
        by_key[norm_key(r["COLUMN_NAME"])]["asis"].append(r)
    for r in tobe_rows:
        by_key[norm_key(r["COLUMN_NAME"])]["tobe"].append(r)

    # ── 교대쌍(swap pair) 탐지 ────────────────────────────────────────────────
    #   AS-IS DMF0049 실측: 같은 라벨을 가진 `X`(콤보) 와 `T_X`(텍스트) 를 `.cs` 가 모드별로
    #   번갈아 노출한다(EditButton/InsertRow ↔ FindData). 메타만 보면 "같은 라벨 2컬럼이 둘 다
    #   VISIBLE='Y'" 로만 보여 오해를 부르므로 사전이 쌍으로 묶어 알려준다.
    swap_pairs = {}
    for k in keys:
        if not k.startswith("T_"):
            continue
        base = k[2:]
        if base not in by_key:
            continue
        for side in ("asis", "tobe"):
            for t in by_key[k][side]:
                for b in by_key[base][side]:
                    if (t["PROGRAM_ID"] == b["PROGRAM_ID"] and t["SHEET_NAME"] == b["SHEET_NAME"]
                            and cfg.norm_txt(t["COLUMN_LABEL_NAME"]) ==
                                cfg.norm_txt(b["COLUMN_LABEL_NAME"])):
                        swap_pairs.setdefault((base, k), []).append(
                            {"side": side, "program": t["PROGRAM_ID"], "sheet": t["SHEET_NAME"],
                             "label": cfg.norm_txt(t["COLUMN_LABEL_NAME"]),
                             "combo_side_ctrl": cfg.norm_txt(b["CELL_CONTROL_OBJECT_TYPE_CODE"]),
                             "combo_side_visible": b["VISIBLE_FLAG"],
                             "text_side_visible": t["VISIBLE_FLAG"]})
    pair_of = {}
    for (base, tname), hits in swap_pairs.items():
        pair_of[base] = {"partner": tname, "role": "콤보측", "hits": hits}
        pair_of[tname] = {"partner": base, "role": "텍스트측", "hits": hits}
    print(f"  교대쌍 후보 {len(swap_pairs)}쌍 탐지")

    out = []
    for k in keys:
        a, t = by_key[k]["asis"], by_key[k]["tobe"]
        both = a + t
        variants = sorted({r["COLUMN_NAME"] for r in both})

        label = collections.Counter(cfg.norm_txt(r["COLUMN_LABEL_NAME"]) for r in both
                                    if cfg.norm_txt(r["COLUMN_LABEL_NAME"]))
        align_raw = collections.Counter(cfg.norm_txt(r["HORIZONTAL_ALIGN_CODE"]) for r in both
                                        if cfg.norm_txt(r["HORIZONTAL_ALIGN_CODE"]))
        align_ok = collections.Counter({v: n for v, n in align_raw.items() if v in cfg.ALIGN_CODES})
        width = collections.Counter(cfg.norm_num(r["COLUMN_WIDTH"]) for r in both
                                    if cfg.norm_num(r["COLUMN_WIDTH"]) is not None)
        scale = collections.Counter(cfg.norm_num(r["DATA_SCALE_NUMBER"]) for r in both
                                    if cfg.norm_num(r["DATA_SCALE_NUMBER"]) is not None)
        maxlen = collections.Counter(cfg.norm_num(r["DATA_MAX_LENGTH"]) for r in both
                                     if cfg.norm_num(r["DATA_MAX_LENGTH"]) is not None)

        # 표시 표준 = 전 행 기준 최빈 컨트롤 (읽기전용 표시 컬럼이 대다수인 현실을 그대로 반영)
        #   ⚠ **허용값 밖의 값은 표준 산출에서 배제**한다. 사전이 잘못된 값을 표준으로 가르치면
        #     그대로 베끼는 순간 사고가 재생산된다 (실측: CELL_CONTROL='S' 204행 = INPUT_TP_CD 오기입).
        #     배제한 값은 control_illegal 로 따로 남겨 원본 결함을 숨기지 않는다.
        ctrl_raw = collections.Counter(cfg.norm_txt(r["CELL_CONTROL_OBJECT_TYPE_CODE"]) or "(공란)"
                                       for r in both)
        disp = collections.Counter({v: n for v, n in ctrl_raw.items()
                                    if v == "(공란)" or v in allowed_controls})
        ctrl_illegal = {v: n for v, n in ctrl_raw.items()
                        if v != "(공란)" and v not in allowed_controls}

        # ⭐ 편집 표준 = 콤보/모달이 실제 배정된 행만 모집단 (naive 최빈값 함정 회피)
        edit_rows = [r for r in both
                     if cfg.norm_txt(r["CELL_CONTROL_OBJECT_TYPE_CODE"]) in cfg.EDIT_CONTROLS
                     and cfg.norm_txt(r["CELL_CONTROL_OBJECT_TYPE_CODE"]) in allowed_controls]
        e_ctrl = collections.Counter(cfg.norm_txt(r["CELL_CONTROL_OBJECT_TYPE_CODE"])
                                     for r in edit_rows)
        e_combo = collections.Counter(cfg.norm_txt(r["CELL_COMBO_DATA_TYPE"]) for r in edit_rows
                                      if cfg.norm_txt(r["CELL_COMBO_DATA_TYPE"]))
        modal_rows = [r for r in edit_rows
                      if cfg.norm_txt(r["CELL_CONTROL_OBJECT_TYPE_CODE"]) == "FPModal"]
        # 모달키 표준 — ⚠ **division 목록이 들어간 오값을 배제**한다 (실측: ITEM_ID ATTRIBUTE1 이
        #   '81,82' 1건 / 'ITEM' 1건 동수라, 배제하지 않으면 사전이 결함값을 표준으로 가르친다).
        #   배제분은 modal_key_illegal 로 남겨 원본 결함을 숨기지 않는다 (D4 가 별도로 적출한다).
        def _bad_modal(v):
            toks = cfg.norm_div(v)
            return bool(toks) and toks <= set(cfg.DIVISION_TOKENS)

        modal_raw = collections.Counter(cfg.norm_txt(r["ATTRIBUTE1"]) for r in modal_rows
                                        if cfg.norm_txt(r["ATTRIBUTE1"]))
        e_modal = collections.Counter({v: n for v, n in modal_raw.items() if not _bad_modal(v)})
        modal_illegal = {v: n for v, n in modal_raw.items() if _bad_modal(v)}
        e_cascade = collections.Counter(cfg.norm_txt(r["ATTRIBUTE2"]) for r in edit_rows
                                        if cfg.norm_txt(r["ATTRIBUTE2"]))
        # INPUT_TP_CD 는 TO-BE 전용 축 (AS-IS 전행 'S')
        e_input = collections.Counter(cfg.norm_txt(r["INPUT_TP_CD"]) for r in t
                                      if cfg.norm_txt(r["INPUT_TP_CD"]) in cfg.INPUT_TP_CODES)
        combo_std = mode_of(e_combo, "콤보 배정 이력 없음")
        toks = sorted(cmbo_tokens.get(combo_std["value"], set())) if not cfg.is_unknown(
            combo_std["value"]) else []
        # ⭐ 표준 콤보가 TO-BE 에 등록돼 있는가 — 미등록이면 그대로 베끼는 순간 0행·CODE 노출.
        #   다만 "미등록 = 결함" 은 아니다. TO-BE 가 다른 ID 로 재매핑한 선례가 있다
        #   (AS-IS FCST_TYPE → TO-BE DM_LOOKUP_DIV). 그래서 **등록 여부를 표기**하고,
        #   같은 컬럼의 TO-BE 실사용 콤보를 대안 후보로 함께 제시한다 (매핑 판단은 사람이 한다).
        combo_registered = (not cfg.is_unknown(combo_std["value"])
                            and combo_std["value"] in cmbo_ids)
        tobe_alts = sorted({cfg.norm_txt(r["CELL_COMBO_DATA_TYPE"]) for r in t
                            if cfg.norm_txt(r["CELL_COMBO_DATA_TYPE"]) in cmbo_ids})
        if cfg.is_unknown(combo_std["value"]):
            combo_gap = "해당없음(콤보 아님)"
        elif combo_registered:
            combo_gap = "등록됨"
        else:
            combo_gap = ("TO-BE CMBO 미등록 — " +
                         (f"동일 컬럼 TO-BE 실사용: {', '.join(tobe_alts)}" if tobe_alts
                          else "TO-BE 대안 없음. 콤보로 쓰려면 SCM_ADM_CMBO_SQL_M 등록이 선행"))

        divs = collections.Counter()
        for r in both:
            for d in cfg.norm_div(r["DIVISION_ID"]):
                divs[d] += 1
        sheet_suffix = sorted({r["SHEET_NAME"] for r in both
                               if any(r["SHEET_NAME"].endswith("_" + d)
                                      for d in cfg.DIVISION_TOKENS)})

        out.append({
            "key": k,
            "name_variants": variants,
            "case_inconsistent": len(variants) > 1,
            "usage": {
                "asis_rows": len(a), "asis_programs": len({r["PROGRAM_ID"] for r in a}),
                "tobe_rows": len(t), "tobe_programs": len({r["PROGRAM_ID"] for r in t}),
            },
            "label_standard": mode_of(label, "라벨 이력 없음"),
            "align_standard": mode_of(align_ok, "정렬코드 이력 없음"),
            "align_illegal": {v: n for v, n in align_raw.items() if v not in cfg.ALIGN_CODES},
            "width_standard": mode_of(width, "폭 이력 없음"),
            "scale_standard": mode_of(scale, "소수자리 이력 없음"),
            "max_length_standard": mode_of(maxlen, "최대길이 이력 없음"),
            "display_standard": mode_of(disp, "표시 컨트롤 이력 없음"),
            "control_illegal": ctrl_illegal,
            "edit_standard": {
                "control": mode_of(e_ctrl, "콤보·모달 배정 이력 없음"),
                "combo_sql_id": combo_std,
                "combo_registered": combo_registered,
                "combo_gap": combo_gap,
                "combo_tobe_alternatives": tobe_alts,
                "combo_tokens": toks,
                "combo_user_tokens": [x for x in toks if x.lower() not in SESSION_TOKENS],
                "modal_key": mode_of(e_modal, "모달키 이력 없음"),
                "modal_key_illegal": modal_illegal,
                "cascade_filter": mode_of(e_cascade, "cascade 필터 이력 없음"),
                "input_tp_cd": mode_of(e_input, "TO-BE 편집형 이력 없음"),
                "evidence_rows": len(edit_rows),
                "confidence": conf_of(len(edit_rows)),
            },
            "swap_pair": pair_of.get(k, None),
            "division_usage": dict(divs.most_common()),
            "division_sheet_variants": sheet_suffix,
            "programs_asis": sorted({r["PROGRAM_ID"] for r in a}),
            "programs_tobe": sorted({r["PROGRAM_ID"] for r in t}),
        })

    # ── 결함 적출 (TO-BE 기준 — 고칠 수 있는 쪽) ──────────────────────────────
    std_by_key = {o["key"]: o for o in out}
    defects = []

    # 심각도·검출 로직은 detectors.py 단일 구현을 쓴다 (06_verify 가 같은 함수를 합성 행으로 검증).
    SEVERITY = detectors.SEVERITY

    def add(code, r, detail):
        defects.append({
            "code": code, "severity": SEVERITY[code],
            "program": r["PROGRAM_ID"], "sheet": r["SHEET_NAME"],
            "column": r["COLUMN_NAME"], "detail": detail,
        })

    pk = collections.Counter((r["PROGRAM_ID"], r["SHEET_NAME"], r["COLUMN_NAME"])
                             for r in tobe_rows)
    for (p_, s_, c_), n in pk.items():
        if n > 1:
            variants_seen = sorted({
                f'{cfg.norm_txt(r["INPUT_TP_CD"])}/{cfg.norm_txt(r["CELL_CONTROL_OBJECT_TYPE_CODE"])}'
                for r in tobe_rows
                if (r["PROGRAM_ID"], r["SHEET_NAME"], r["COLUMN_NAME"]) == (p_, s_, c_)})
            defects.append({"code": "D9", "severity": "ERROR", "program": p_, "sheet": s_,
                            "column": c_,
                            "detail": f"PK 중복 {n}행 — 값 조합 {variants_seen}. 어느 행이 적용될지 비결정적"})

    ctx = {
        "cmbo_ids": cmbo_ids,
        "cmbo_tokens": cmbo_tokens,
        "allowed_controls": allowed_controls,
        "lookup_only": set(lookup_only),
        "edit_standard_of": lambda k: std_by_key.get(k, {}).get("edit_standard"),
        # AS-IS 파리티 대조 — "TO-BE 가 만든 결함" 과 "AS-IS 원본 잔재" 를 가른다
        "modal_keys": set(cfg.MODAL_KEYS),
        "asis_of": (lambda idx: (lambda p_, s_, c_: idx.get((p_, s_, c_))))(
            {(r["PROGRAM_ID"], r["SHEET_NAME"], r["COLUMN_NAME"]): r for r in asis_rows}),
    }
    for r in tobe_rows:
        for code, detail in detectors.row_defects(r, ctx, cfg):
            add(code, r, detail)

    unreg = [o["key"] for o in out
             if o["edit_standard"]["combo_gap"].startswith("TO-BE CMBO 미등록")]
    print(f"  표준 콤보 TO-BE 미등록 {len(unreg)}컬럼 (매핑 판단 대상)")

    by_code = collections.Counter(d["code"] for d in defects)
    by_sev = collections.Counter(d["severity"] for d in defects)
    by_prog = collections.Counter(d["program"] for d in defects if d["severity"] == "ERROR")
    n_err = by_sev["ERROR"]
    print(f"  사전 {len(out)}종 · 적출 {len(defects)}건 "
          f"(ERROR {n_err} / WARN {by_sev['WARN']} / INFO {by_sev['INFO']})")
    for c, n in sorted(by_code.items()):
        print(f"    {c}[{SEVERITY[c]}]: {n}")

    meta = {
        "snapshot": cfg.SNAPSHOT_DATE,
        "asis_source": asis_meta.get("label"),
        "asis_rows": len(asis_rows), "tobe_rows": len(tobe_rows),
        "structural_facts": [
            "AS-IS 의 INPUT_TP_CD 는 전행 'S' 단일값이고 FPModal 은 0건 — 편집·모달 축은 TO-BE 전용이다.",
            "표시표준(전 행 최빈)과 편집표준(콤보·모달 배정행 한정)을 분리한다. "
            "합치면 읽기전용 행이 다수라 항상 TextBox 가 표준이 된다.",
            "값 도메인 정본은 TO-BE SCM_ADM_LOOKUP_MASTER_DETAIL(64,500행) — AS-IS 와 동일 "
            "(컨트롤 13종·align C/L/R). 2026-08-21 관측된 0행은 적재 창의 일시 상태였다.",
        ],
        "lookup_source": "TO-BE SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL (AS-IS 교차검증)",
        "lookup_divergence": lookup_divergence,
        # ⭐ AS-IS 와 의도적으로 다른 값 — 되돌림 방지용 등록부(cfg 단일 소스).
        "intentional_divergence": [
            {"program_id": k[0], "sheet_name": k[1], "column_name": k[2], "field": k[3],
             "asis": v[0], "tobe": v[1], "reason": v[2]}
            for k, v in cfg.INTENTIONAL_DIVERGENCE.items()
        ],
        "allowed_controls": sorted(allowed_controls),
        "controls_fe_only": fe_only,
        "controls_lookup_only": lookup_only,
        "confidence_rule": "high>=5 / medium 2~4 / low 1 / none 0 (근거 = 콤보·모달 배정 행수)",
        "defect_codes": detectors.DEFECT_DESC,
        "swap_pair_note": "AS-IS DMF0049 실측 — 같은 라벨의 X(콤보)/T_X(텍스트) 를 .cs 가 모드별로 "
                          "번갈아 노출한다. 메타만 보면 '같은 라벨 2컬럼 둘 다 VISIBLE=Y' 로만 보인다.",
        "severity_rule": "ERROR=메타만으로 확정되는 결함 / WARN=사전 표준과 불일치 / "
                         "INFO=FE 전달 의무 고지(메타만으론 판정 불가)",
        "combo_unregistered_standard": sorted(unreg),
        "combo_gap_note": "표준 콤보가 TO-BE CMBO 에 없다 = 즉시 결함이 아니라 **매핑 판단 대상**. "
                          "TO-BE 가 다른 ID 로 재매핑한 선례가 있다(AS-IS FCST_TYPE → DM_LOOKUP_DIV). "
                          "대안 후보는 combo_tobe_alternatives 참조.",
        "defects_by_code": dict(sorted(by_code.items())),
        "defects_by_severity": dict(sorted(by_sev.items())),
        "error_top_programs": dict(by_prog.most_common(15)),
    }
    print("  -> " + cfg.jdump({"meta": meta, "columns": out, "defects": defects,
                               "swap_pairs": [{"combo_side": b, "text_side": tn, "hits": h}
                                              for (b, tn), h in sorted(swap_pairs.items())]},
                              "dict_sheet_columns.json"))


if __name__ == "__main__":
    sys.exit(main())
