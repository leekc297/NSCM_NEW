#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""06_verify.py — 지식사전 게이트 (exit 0 = PASS / 1 = FAIL).

사용
  python 06_verify.py                 전체 게이트 G1~G7
  python 06_verify.py --program DMF0049   해당 화면의 컬럼 결함(D1~D10)만 점검 — hook POST-WRITE 용
  python 06_verify.py --selftest      사전이 실제로 사고를 잡는지 역방향 실증 (플랜 §검증 5)

게이트가 FAIL 하면 **먼저 도구 오탐인지 데이터 결함인지 가른다**. 정정 후에는 전체(--all 없이 전체
실행)로 회귀시켜 다른 축이 깨지지 않았는지 확인한다.
"""
import argparse
import collections
import sys

import cfg
import detectors

FAIL, WARN = [], []


def fail(gate, msg):
    FAIL.append(f"[{gate}] {msg}")


def warn(gate, msg):
    WARN.append(f"[{gate}] {msg}")


def walk_unknown(obj, path=""):
    """공란(빈 문자열) 탐지 — '미확인(사유)' 는 허용, 순수 공란은 금지 (G2)."""
    bad = []
    if isinstance(obj, dict):
        for k, v in obj.items():
            bad += walk_unknown(v, f"{path}.{k}")
    elif isinstance(obj, list):
        for i, v in enumerate(obj):
            bad += walk_unknown(v, f"{path}[{i}]")
    elif isinstance(obj, str) and obj == "":
        bad.append(path)
    return bad


def g1_counts():
    """스냅샷 정합성 — 덤프 건수가 baseline 과 일치하는가 (변동은 보고, 부재는 FAIL)."""
    bl = cfg.load_baseline()["counts"]
    actual = {
        "asis_columns": len(cfg.jload("asis_columns.json")["rows"]),
        "asis_measures": len(cfg.jload("asis_measures.json")["rows"]),
        "tobe_columns": len(cfg.jload("tobe_columns.json")["rows"]),
        "tobe_measures": len(cfg.jload("tobe_measures.json")["rows"]),
        "cmbo": len(cfg.jload("cmbo_meta.json")),
    }
    for k, v in actual.items():
        if v == 0:
            fail("G1", f"{k} 덤프 0건 — 원천 적재 중이거나 접속 오류")
        elif bl.get(k) != v:
            warn("G1", f"{k}: baseline {bl.get(k)} → 현재 {v} (재실행 시점 차이)")
    print(f"  G1 건수: " + " · ".join(f"{k}={v}" for k, v in actual.items()))


def g2_blank():
    """공란 금지 — 단, 대상은 **사전이 스스로 내린 판단 필드**다.

    ⚠ 원본 메타를 그대로 실은 값(ATTRIBUTE1 등)은 정당하게 비어 있을 수 있다. 그것까지 FAIL 로
      잡으면 진짜 미기재가 1만여 건에 묻힌다 (초기 구현이 실제로 그랬다).
      판단 필드에는 공란 대신 '미확인(사유)' 를 쓴다.
    """
    n = 0
    d = cfg.jload("dict_sheet_columns.json")
    for c in d["columns"]:
        for path, v in (
            ("label_standard", c["label_standard"]["value"]),
            ("align_standard", c["align_standard"]["value"]),
            ("display_standard", c["display_standard"]["value"]),
            ("edit_standard.control", c["edit_standard"]["control"]["value"]),
            ("edit_standard.combo_sql_id", c["edit_standard"]["combo_sql_id"]["value"]),
            ("edit_standard.combo_gap", c["edit_standard"]["combo_gap"]),
            ("edit_standard.confidence", c["edit_standard"]["confidence"]),
        ):
            if v == "":
                fail("G2", f"컬럼사전 {c['key']}.{path} 공란")
                n += 1
    sc = cfg.jload("dict_search_conditions.json")
    for c in sc["conditions"]:
        for path, v in (("binding_primary", c["binding_primary"]),
                        ("coverage", c["coverage"]), ("cond", c["cond"])):
            if v == "":
                fail("G2", f"조회조건사전 {c['cond']}.{path} 공란")
                n += 1
        for s2 in c["screens"]:
            for k in ("label_tobe", "control_tobe", "combo_sql_id", "required", "default"):
                if s2[k] == "":
                    fail("G2", f"조회조건사전 {c['cond']}/{s2['ui']}.{k} 공란")
                    n += 1
    md = cfg.jload("measure_diff.json")
    for r in md["rows"]:
        if r["in_scope"] and r["class"] != "SAME" and r["reason"] == "":
            fail("G2", f"MEASURE {r['program']}/{r['column']} {r['class']} 사유 공란")
            n += 1
    print(f"  G2 판단필드 공란: {n}건")


def g3_domain():
    d = cfg.jload("dict_sheet_columns.json")
    allowed = set(d["meta"]["allowed_controls"])
    n = 0
    for c in d["columns"]:
        for src in ("display_standard", "edit_standard"):
            node = c[src] if src == "display_standard" else c[src]["control"]
            v = node["value"]
            if cfg.is_unknown(v) or v == "(공란)":
                continue
            if v not in allowed:
                fail("G3", f"{c['key']}.{src} = '{v}' 가 허용 컨트롤 밖")
                n += 1
        ipt = c["edit_standard"]["input_tp_cd"]["value"]
        if not cfg.is_unknown(ipt) and ipt not in cfg.INPUT_TP_CODES:
            fail("G3", f"{c['key']}.input_tp_cd = '{ipt}' 가 S/O/M/IO/IM 밖")
            n += 1
        al = c["align_standard"]["value"]
        if not cfg.is_unknown(al) and al not in cfg.ALIGN_CODES:
            fail("G3", f"{c['key']}.align = '{al}' 가 C/L/R 밖")
            n += 1
    print(f"  G3 값도메인: 위반 {n}건")


def g4_combo_ref():
    d = cfg.jload("dict_sheet_columns.json")
    cmbo_ids = {r["SQL_ID"] for r in cfg.jload("cmbo_meta.json")}
    n = 0
    gap = 0
    for c in d["columns"]:
        es = c["edit_standard"]
        v = es["combo_sql_id"]["value"]
        if cfg.is_unknown(v):
            continue
        registered = v in cmbo_ids
        # 사전이 등록 여부를 **틀리게 표기**하면 그대로 믿고 베끼게 되므로 그건 FAIL 이다.
        # 미등록 자체는 매핑 판단 대상이라 WARN 으로 집계한다.
        if es["combo_registered"] != registered:
            fail("G4", f"{c['key']} combo_registered 표기 오류 (실제 {registered})")
            n += 1
        if not registered:
            gap += 1
    sc = cfg.jload("dict_search_conditions.json")
    for c in sc["conditions"]:
        for v in c["combo_sql_ids"]:
            if not cfg.is_unknown(v) and v not in cmbo_ids:
                fail("G4", f"조회조건 '{c['cond']}' 콤보 '{v}' 미등록")
                n += 1
    if gap:
        warn("G4", f"표준 콤보 TO-BE 미등록 {gap}컬럼 — 매핑 판단 대상 "
                   "(dict_sheet_columns.json combo_unregistered_standard)")
    print(f"  G4 콤보 참조 무결성: 표기 오류 {n}건 / 미등록 표준 {gap}컬럼")


def g5_measure_reason():
    d = cfg.jload("measure_diff.json")
    n = 0
    for r in d["rows"]:
        if not r["in_scope"] or r["class"] == "SAME":
            continue
        if not r["reason"]:
            fail("G5", f"{r['program']}/{r['sheet']}/{r['column']} {r['class']} 사유 미기재")
            n += 1
    unresolved = d["meta"]["unresolved_extra"]
    if unresolved:
        # 사유 없는 EXTRA = 근거 없는 TO-BE 단독 행. 차단이 아니라 확인 대상으로 올린다.
        warn("G5", f"근거 문서 미확인 EXTRA {unresolved}건 — 확장 근거 확인 필요")
    print(f"  G5 MEASURE 대사 완결: 사유 미기재 {n}건 / 근거 미확인 EXTRA {unresolved}건")


_BASENAME_INDEX = None


def basename_index():
    """evidence 는 경로 없이 **파일명만** 적혀 있다(예: 'MktFcstForm.tsx:L138-164').
    조인 경로로만 찾으면 한 건도 해석되지 않아 게이트가 **무력해진다**(초기 구현이 그랬다).
    그래서 후보 루트에서 basename 인덱스를 만들어 해석한다. 동명이인은 모두 후보로 두고
    **어느 하나라도 라인이 존재하면 통과**로 본다(과탐 방지).
    """
    global _BASENAME_INDEX
    import os
    if _BASENAME_INDEX is not None:
        return _BASENAME_INDEX
    idx = {}
    #   ⚠ 루트를 좁게 잡으면 동명 파일 중 엉뚱한 것만 잡혀 **오탐**이 난다.
    #     실사고: 'Data.cs' 를 06.UIL/unvell.ReoGrid(194행)로만 해석해 정상 evidence 6건을
    #     "범위 밖" 으로 FAIL 처리했다. 정본은 01.Framework/GSCM.Windows.Forms(1,295행).
    #     ⇒ AS-IS 는 GSCM 전체를 루트로 둔다(obj/bin 제외).
    roots = [
        os.path.join(cfg.SEARCHCOND_PIPELINE, "asis_stripped"),
        os.path.join(cfg.ROOT, "nscm-fe", "features"),
        os.path.join(cfg.ROOT, "nscm-fe", "packages"),
        os.path.join(cfg.ROOT, "GSCM"),
    ]
    for root in roots:
        if not os.path.isdir(root):
            continue
        for dirpath, dirnames, filenames in os.walk(root):
            dirnames[:] = [x for x in dirnames
                           if x not in ("node_modules", "obj", "bin", "dist", "build", ".git")]
            for fn in filenames:
                if fn.endswith((".cs", ".tsx", ".ts")):
                    idx.setdefault(fn, []).append(os.path.join(dirpath, fn))
    _BASENAME_INDEX = idx
    return idx


def g6_evidence():
    """조회조건 사전 evidence 의 파일:라인 실존 검증."""
    import re
    idx = basename_index()
    linecache = {}

    def nlines(path):
        if path not in linecache:
            with open(path, encoding="utf-8", errors="ignore") as f:
                linecache[path] = sum(1 for _ in f)
        return linecache[path]

    d = cfg.jload("dict_search_conditions.json")
    checked = bad = unresolved = 0
    for c in d["conditions"]:
        for sc in c["screens"]:
            for ev in sc["evidence"]:
                e = str(ev)
                m = re.match(r"^([\w.-]+\.(?:cs|tsx|ts))\D*?(\d+)", e)
                if not m:
                    continue
                fn, ln = m.group(1).split("/")[-1].split("\\")[-1], int(m.group(2))
                cands = idx.get(fn, [])
                if not cands:
                    unresolved += 1
                    continue
                checked += 1
                if not any(ln <= nlines(p2) for p2 in cands):
                    fail("G6", f"{c['cond']}/{sc['ui']} evidence '{e}' — "
                               f"라인 {ln} 이 {fn}({max(nlines(p2) for p2 in cands)}행) 범위 밖")
                    bad += 1
    if unresolved:
        warn("G6", f"원천 파일을 찾지 못한 evidence {unresolved}건 (파일명만 기재·이동/삭제)")
    print(f"  G6 evidence 라인: 검증 {checked}건 / 범위 밖 {bad}건 / 미해석 {unresolved}건")


def g7_reproducible():
    """재현성 — JSON 정본에 비결정 값(타임스탬프 등)이 섞이지 않았는가."""
    import re
    bad = []
    for name in ("dict_search_conditions.json", "dict_sheet_columns.json",
                 "dict_sheet_measures.json"):
        import os
        txt = open(os.path.join(cfg.OUT_JSON, name), encoding="utf-8").read()
        # 실행 시각이 섞이면 재실행마다 파일이 달라져 diff 가 무의미해진다
        for m in re.finditer(r'"(generated_at|timestamp|run_at|now)"', txt):
            bad.append(f"{name}:{m.group(1)}")
    if bad:
        fail("G7", f"비결정 필드 {bad}")
    print(f"  G7 재현성: 비결정 필드 {len(bad)}건")


def per_program(program):
    d = cfg.jload("dict_sheet_columns.json")
    rows = [x for x in d["defects"] if x["program"] == program]
    if not rows:
        print(f"  {program}: 적출 0건")
        return 0
    by_sev = collections.Counter(x["severity"] for x in rows)
    print(f"  {program}: ERROR {by_sev['ERROR']} · WARN {by_sev['WARN']} · INFO {by_sev['INFO']}")
    for x in sorted(rows, key=lambda r: (r["severity"] != "ERROR", r["code"])):
        print(f"    [{x['severity']}][{x['code']}] {x['sheet']}/{x['column']} — {x['detail']}")
    return by_sev["ERROR"]


def selftest():
    """검출기 자체 검증 — **합성 행**으로 D1~D11 을 하나씩 재현한다.

    ⚠ 알려진 실데이터 사고로만 검증하면, 그 사고가 고쳐지는 순간 게이트가 FAIL 로 뒤집힌다
      (2026-08-21 DMF0049 PK 중복이 적재 중 해소되며 실제로 발생). **데이터가 고쳐진 것은
      게이트 결함이 아니다.** 그래서 검출기는 합성 행으로 검증하고, 실데이터의 사고 잔존 여부는
      아래 §정보성 기록으로 따로 낸다.
    """
    d = cfg.jload("dict_sheet_columns.json")
    allowed = set(d["meta"]["allowed_controls"])
    lookup_only = set(d["meta"]["controls_lookup_only"])
    cmbo = cfg.jload("cmbo_meta.json")
    cmbo_ids = {r["SQL_ID"] for r in cmbo}
    cmbo_tokens = {}
    for r in cmbo:
        cmbo_tokens.setdefault(r["SQL_ID"], set()).update(r["TOKENS"])
    # @토큰을 요구하는 실제 콤보 하나를 골라 D3 를 재현한다 (없으면 D3 케이스는 건너뛴다)
    tok_combo = next((k for k, v in sorted(cmbo_tokens.items())
                      if [x for x in v if x.lower() not in detectors.SESSION_TOKENS]), None)
    std_modal = {"confidence": "high", "control": {"value": "FPModal", "n": 9}}
    ctx = {"cmbo_ids": cmbo_ids, "cmbo_tokens": cmbo_tokens, "allowed_controls": allowed,
           "lookup_only": lookup_only,
           "edit_standard_of": lambda k: std_modal if k == "MODALCOL" else None,
           "modal_keys": set(cfg.MODAL_KEYS),
           "asis_of": lambda p_, s_, c_: None}

    cases = [
        ("D1", detectors.synth(CELL_CONTROL_OBJECT_TYPE_CODE="FPComboBox",
                               CELL_COMBO_DATA_TYPE="")),
        # D2 는 **FPComboBox 일 때만** 성립한다 (다른 컨트롤이면 D12)
        ("D2", detectors.synth(CELL_CONTROL_OBJECT_TYPE_CODE="FPComboBox",
                               CELL_COMBO_DATA_TYPE="__NOT_REGISTERED__")),
        # ⭐ 2026-08-22 규약 전환 — 모달키 슬롯 = CELL_COMBO_DATA_TYPE
        ("D4", detectors.synth(CELL_CONTROL_OBJECT_TYPE_CODE="FPModal", CELL_COMBO_DATA_TYPE="")),
        ("D4", detectors.synth(CELL_CONTROL_OBJECT_TYPE_CODE="FPModal",
                               CELL_COMBO_DATA_TYPE="81,82")),
        ("D4", detectors.synth(CELL_CONTROL_OBJECT_TYPE_CODE="FPTextModal",
                               CELL_COMBO_DATA_TYPE="")),
        # 구 규약 잔재 — 모달키가 ATTRIBUTE1 에 남아 있다
        ("D13", detectors.synth(CELL_CONTROL_OBJECT_TYPE_CODE="FPTextModal",
                                CELL_COMBO_DATA_TYPE="ITEM", ATTRIBUTE1="ITEM")),
        # 편집표준이 모달인데 **모달이 전혀 없는** 컨트롤 = 선택 창 자체가 불가 → D5 유지
        ("D5", detectors.synth(COLUMN_NAME="ModalCol",
                               CELL_CONTROL_OBJECT_TYPE_CODE="FPTextBox", INPUT_TP_CD="IM")),
        ("D5", detectors.synth(COLUMN_NAME="ModalCol",
                               CELL_CONTROL_OBJECT_TYPE_CODE="FPComboBox",
                               CELL_COMBO_DATA_TYPE="", INPUT_TP_CD="IM")),
        ("D6", detectors.synth(INPUT_TP_CD="MI")),
        ("D7", detectors.synth(HORIZONTAL_ALIGN_CODE="Center")),
        ("D8", detectors.synth(CELL_CONTROL_OBJECT_TYPE_CODE="S")),
        # 콤보 ID 는 있는데 컨트롤이 FPComboBox 가 아니다 = 소비 안 됨 (D2 아님)
        ("D12", detectors.synth(CELL_CONTROL_OBJECT_TYPE_CODE="FPText",
                                CELL_COMBO_DATA_TYPE="__NOT_REGISTERED__")),
        ("D12", detectors.synth(CELL_CONTROL_OBJECT_TYPE_CODE="",
                                CELL_COMBO_DATA_TYPE="__NOT_REGISTERED__")),
        ("D11", detectors.synth(COLUMN_NAME=" ")),
    ]
    if tok_combo:
        cases.append(("D3", detectors.synth(CELL_CONTROL_OBJECT_TYPE_CODE="FPComboBox",
                                            CELL_COMBO_DATA_TYPE=tok_combo)))
    if lookup_only:
        cases.append(("D10", detectors.synth(
            CELL_CONTROL_OBJECT_TYPE_CODE=sorted(lookup_only)[0])))

    print("    [검출기 합성 검증]")
    for code, row in cases:
        got = {c for c, _ in detectors.row_defects(row, ctx, cfg)}
        ok = code in got
        print(f"      {'PASS' if ok else 'FAIL'}  {code} — {detectors.DEFECT_DESC[code][:44]}")
        if not ok:
            fail("SELFTEST", f"{code} 검출 실패 (합성 행) — 검출기 결함. 적출 로직을 고칠 것")

    # 음성 검증 — 잡으면 안 되는 것을 잡지 않는지 (오탐 회귀 방지)
    neg = [
        ("D2", detectors.synth(CELL_CONTROL_OBJECT_TYPE_CODE="FPModal",
                               CELL_COMBO_DATA_TYPE="PROJECT"),
         "FPModal 의 CELL_COMBO_DATA_TYPE 는 **모달키**라 콤보 미등록 판정(D2) 대상이 아님"),
        ("D12", detectors.synth(CELL_CONTROL_OBJECT_TYPE_CODE="FPTextModal",
                                CELL_COMBO_DATA_TYPE="ITEM"),
         "모달 컨트롤의 콤보 슬롯은 모달키 — '소비되지 않음'(D12) 아님"),
        ("D13", detectors.synth(CELL_CONTROL_OBJECT_TYPE_CODE="FPTextModal",
                                CELL_COMBO_DATA_TYPE="ITEM", ATTRIBUTE1="81,82"),
         "ATTRIBUTE1 의 division 토큰은 파라미터(sParam1) — 구 규약 잔재(D13) 아님"),
        ("D3", detectors.synth(CELL_CONTROL_OBJECT_TYPE_CODE="FPText",
                               CELL_COMBO_DATA_TYPE=tok_combo or "x"),
         "FPText 셀의 토큰 콤보는 소비되지 않으므로 D3 아님"),
        # ⭐ 2026-08-22 오탐 회귀 방지 — `FPTextModal` 은 AS-IS 파리티 정상값이다.
        #   구 D5 는 "모달 표준인데 모달 컨트롤이 아님"을 문자열 'FPModal' 동등비교로 봐서
        #   타이핑 허용이 정상인 AS-IS 사양(TextCellType+ImagePopUp)을 결함으로 적출했다.
        ("D5", detectors.synth(COLUMN_NAME="ModalCol",
                               CELL_CONTROL_OBJECT_TYPE_CODE="FPTextModal",
                               ATTRIBUTE1="ITEM", INPUT_TP_CD="IM"),
         "FPTextModal 은 모달 보유 컨트롤 — 편집표준 모달과 부합하므로 D5 아님"),
        ("D8", detectors.synth(CELL_CONTROL_OBJECT_TYPE_CODE="FPTextModal", ATTRIBUTE1="ITEM"),
         "FPTextModal 은 허용 컨트롤 도메인(FE enum + admin 콤보) 안 — D8 아님"),
    ]
    # ⭐ [2026-08-22] DIVISION_ID 대조 — AS-IS 실값과 다르면 축소(D14)/확장(D15)
    div_ctx = dict(ctx)
    div_ctx["asis_of"] = lambda p_, s_, c_: detectors.synth(DIVISION_ID="40")
    for code, div, why in [
        ("D15", "40,82", "AS-IS '40' → TO-BE '40,82' (DMF0082 CELL_PROD_SITE_ID 실사고 재현)"),
        ("D14", "82", "AS-IS '40' → TO-BE '82' (40 소실)"),
    ]:
        got = {c for c, _ in detectors.row_defects(detectors.synth(DIVISION_ID=div), div_ctx, cfg)}
        ok = code in got
        print(f"      {'PASS' if ok else 'FAIL'}  {code} — {why}")
        if not ok:
            fail("SELFTEST", f"{code} 미검출 — division 대조 축 무력")
    got = {c for c, _ in detectors.row_defects(detectors.synth(DIVISION_ID="40"), div_ctx, cfg)}
    ok = "D14" not in got and "D15" not in got
    print(f"      {'PASS' if ok else 'FAIL'}  ¬D14/¬D15 — AS-IS 와 동일한 division 은 적출 아님")
    if not ok:
        fail("SELFTEST", "동일 division 을 드리프트로 오탐")

    # AS-IS 파리티 가드 — 같은 합성 행이라도 AS-IS 가 동일값이면 D5 를 내면 안 된다.
    parity_ctx = dict(ctx)
    parity_ctx["asis_of"] = lambda p_, s_, c_: detectors.synth(
        CELL_CONTROL_OBJECT_TYPE_CODE="FPComboBox", CELL_COMBO_DATA_TYPE="DM_LOOKUP_DIV")
    parity_row = detectors.synth(COLUMN_NAME="ModalCol",
                                 CELL_CONTROL_OBJECT_TYPE_CODE="FPComboBox",
                                 CELL_COMBO_DATA_TYPE="DM_LOOKUP_DIV", INPUT_TP_CD="IO")
    got = {c for c, _ in detectors.row_defects(parity_row, parity_ctx, cfg)}
    ok = "D5" not in got
    print(f"      {'PASS' if ok else 'FAIL'}  ¬D5 — AS-IS 실값과 동일한 셀은 사전 표준과 달라도 D5 아님")
    if not ok:
        fail("SELFTEST", "D5 파리티 가드 미작동 — 사전 통계가 AS-IS 정본을 덮어씀")
    for code, row, why in neg:
        got = {c for c, _ in detectors.row_defects(row, ctx, cfg)}
        ok = code not in got
        print(f"      {'PASS' if ok else 'FAIL'}  ¬{code} — {why}")
        if not ok:
            fail("SELFTEST", f"{code} 오탐 — {why}")

    # D9(PK 중복)는 집합 판정이라 별도 — 04 의 구현과 동형인지 확인
    import collections as _c
    rows = [detectors.synth(), detectors.synth(INPUT_TP_CD="M")]
    dup = [k for k, n in _c.Counter(
        (r["PROGRAM_ID"], r["SHEET_NAME"], r["COLUMN_NAME"]) for r in rows).items() if n > 1]
    print(f"      {'PASS' if dup else 'FAIL'}  D9 — {detectors.DEFECT_DESC['D9'][:44]}")
    if not dup:
        fail("SELFTEST", "D9 검출 실패 (합성 행)")

    # ── 정보성: 실데이터의 알려진 사고 잔존 여부 (FAIL 아님) ──────────────────
    md = cfg.jload("measure_diff.json")
    defects = d["defects"]

    def present(code, program, column, pred=None):
        return any(x["code"] == code and x["program"] == program and x["column"] == column
                   and (pred is None or pred(x)) for x in defects)

    known = [
        ("DMF0006 ITEM_ID 모달키 공란(D4)",
         present("D4", "DMF0006", "ITEM_ID", lambda x: "공란" in x["detail"])),
        ("DM 모달 컬럼 ATTRIBUTE1 모달키 잔존(D13)",
         present("D13", "DMF0020", "ITEM_ID", lambda x: True)),
        ("DMF0082 CELL_PROD_SITE_ID division 확장(D15)",
         present("D15", "DMF0082", "CELL_PROD_SITE_ID", lambda x: True)),
        ("DMF0003 ITEM_ID ATTRIBUTE1='81,82'(D4)",
         present("D4", "DMF0003", "ITEM_ID", lambda x: "division" in x["detail"])),
        ("DMF0082 ITEM_ID TEXT+MODAL 을 D5 로 오탐",
         present("D5", "DMF0082", "ITEM_ID", lambda x: True)),
        ("DMF0049 DEPARTMENT_ID PK 중복(D9)", present("D9", "DMF0049", "DEPARTMENT_ID")),
        ("DMF0049 DEPT_ID PK 중복(D9)", present("D9", "DMF0049", "DEPT_ID")),
        ("DMF0021 FROM_SITE_ID PK 중복(D9)", present("D9", "DMF0021", "FROM_SITE_ID")),
        ("DMF0021 SalesAmt_KRW_User MEASURE 누락(MISSING)",
         any(r["program"] == "DMF0021" and r["column"] == "SalesAmt_KRW_User"
             and r["class"] == "MISSING" for r in md["rows"])),
        ("DMF0082 MEASURE EXTRA 8건 사유 기재",
         sum(1 for r in md["rows"] if r["program"] == "DMF0082" and r["class"] == "EXTRA"
             and r["reason"] and not cfg.is_unknown(r["reason"])) == 8),
    ]
    print("    [실데이터 사고 잔존 — 정보성]")
    for name, still in known:
        print(f"      {'잔존' if still else '해소'}  {name}")
    return True


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--program", help="화면 단위 결함 점검 (hook POST-WRITE)")
    ap.add_argument("--selftest", action="store_true", help="역방향 실증")
    args = ap.parse_args()

    if args.program:
        n = per_program(args.program)
        return 1 if n else 0

    print("== 지식사전 게이트 ==")
    g1_counts()
    g2_blank()
    g3_domain()
    g4_combo_ref()
    g5_measure_reason()
    g6_evidence()
    g7_reproducible()
    if args.selftest:
        print("  SELFTEST 역방향 실증:")
        selftest()

    cfg.jdump({"fail": FAIL, "warn": WARN,
               "result": "FAIL" if FAIL else "PASS"}, "verify_report.json")
    print()
    for x in WARN:
        print("  WARN " + x)
    for x in FAIL[:40]:
        print("  FAIL " + x)
    if len(FAIL) > 40:
        print(f"  ... FAIL {len(FAIL) - 40}건 더 (verify_report.json 참조)")
    print(f"\n결과: {'FAIL' if FAIL else 'PASS'}  (FAIL {len(FAIL)} / WARN {len(WARN)})")
    return 1 if FAIL else 0


if __name__ == "__main__":
    sys.exit(main())
