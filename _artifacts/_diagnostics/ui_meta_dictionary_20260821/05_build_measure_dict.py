#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""05_build_measure_dict.py — SHEET_MEASURE 지식사전 + AS-IS↔TO-BE 전수 대사.

목적 (사용자 명시): "AS-IS 의 MEASURE 를 그대로 복사해서 설정할 수 있도록" — 그런데 실제로는
차이가 나 있다. 그 차이가 **누락 결함**인지 **의도된 TO-BE 확장**인지를 전수로 갈라낸다.

⚠ 대사 키 정정 (플랜은 4부 키를 가정했으나 실측으로 교정)
    실측: `PK_SCM_MST_SHEET_MEASURE` = UNIQUE INDEX(PROGRAM_ID, SHEET_NAME, COLUMN_NAME) — 3부.
          (제약이 아니라 인덱스만 존재. AS-IS/TO-BE 모두 3부 키 중복 0건.)
    ⇒ DIVISION_ID 는 **키가 아니라 비교 대상 속성**이다. 키에 넣으면 division 목록이 바뀐 행이
      MISSING+EXTRA 한 쌍으로 뻥튀기되어 진짜 누락이 묻힌다.

DIVISION_ID 비교는 CSV 문자열이 아니라 **토큰 집합**으로 한다 — '40,82,81' 과 '81,82,40' 은 같다.
'' 과 NULL 은 동치로 둔다 (Oracle ''=NULL).

입력  asis_measures.json / tobe_measures.json
출력  dict_sheet_measures.json (사전) · measure_diff.json (대사 결과)
"""
import collections
import sys

import cfg

KEY = ("PROGRAM_ID", "SHEET_NAME", "COLUMN_NAME")

# 대사 대상 속성 12종 — 비교 방식별로 나눈다
CMP_TEXT = ["COLUMN_LABEL_NAME", "SMALL_CLASS_LABEL_NAME", "LARGE_CLASS_LABEL_NAME",
            "DEFAULT_FLAG", "USER_SELECTABLE_FLAG", "VALID_YN", "INPUT_TP_CD",
            "ATTRIBUTE1", "ATTRIBUTE2", "ATTRIBUTE3"]
CMP_NUM = ["SORT_ORDER_NO"]
CMP_DIV = ["DIVISION_ID"]

# TO-BE 에만 있는 행(EXTRA)의 확인된 사유. 근거 문서를 반드시 동반한다.
#   여기에 없는 EXTRA 는 '미확인' 으로 남고 게이트 G5 가 잡는다 — 사유 없는 EXTRA = 결함 취급.
EXTRA_REASONS = {
    ("DMF0082", "FcstNPrice"): (
        "2026-08-07 UICATEGORY 81/82 확장 (AS-IS 는 division 40 단독) — "
        "Doc/_archive/work_reports/2026-08-07_DMF0082_uicategory_보완.md"),
}


# 81 세분 division 토큰 (참고용 — 확장 판정은 아래 규칙으로 한다)
DIV_81_SUB = {"81_UC", "81_HM", "81_ST", "81_HD", "81_HG"}

# Oracle NOT NULL DEFAULT 를 가진 플래그 — AS-IS 공란이 이관 시 기본값으로 채워진다
NOTNULL_DEFAULT = {"DEFAULT_FLAG": "Y", "USER_SELECTABLE_FLAG": "Y", "VALID_YN": None}


def kof(r):
    return tuple(r[k] for k in KEY)


def classify_diff(diffs):
    """DIFF 를 계통별로 분류한다 — 118건을 뭉뚱그리면 진짜 결함이 묻힌다.

    DIV_81_EXPANSION  DIVISION_ID 가 81 세분 토큰만 늘어난 경우 = TO-BE 의도된 확장
    EMPTY_TO_DEFAULT  AS-IS 공란 → TO-BE 가 Oracle NOT NULL DEFAULT 로 채운 경우
                      ⚠ 무해하지 않다. DEFAULT_FLAG '' → 'Y' 는 "기본 미표시" 였던 measure 가
                        **기본 표시**로 바뀌는 의미 변경이다(titleset seed 가 DEFAULT_FLAG='Y' 기준).
    REAL              위 둘로 설명되지 않는 실차이
    """
    kinds = set()
    for d in diffs:
        c = d["col"]
        if c == "DIVISION_ID":
            only_asis = set(d.get("only_asis") or [])
            only_tobe = set(d.get("only_tobe") or [])
            # ⭐ 확장 판정은 **토큰 종류가 아니라 방향**으로 한다.
            #   AS-IS 것을 하나도 잃지 않고 TO-BE 가 division 만 더한 경우 = 적용범위 확장.
            #   (초기 구현은 81 세분 토큰만 확장으로 봐서, '40' → '40,81,82,81_*' 처럼
            #    기본 토큰 81/82 가 함께 늘어난 DMF0082 10건을 REAL 로 오분류했다.)
            #   반대로 **AS-IS 에 있던 division 이 빠지면**(only_asis 비지 않음) 적용범위 축소이므로
            #   확장으로 덮지 않고 REAL 로 남긴다 — 실사용 division 이 화면에서 사라지는 사고다.
            if only_asis:
                kinds.add("DIV_SCOPE_REMOVED")
            elif only_tobe and only_tobe <= set(cfg.DIVISION_TOKENS):
                kinds.add("DIV_SCOPE_ADDED")
            else:
                kinds.add("REAL")
        elif c in NOTNULL_DEFAULT and d["asis"] == "" and d["tobe"] != "":
            exp = NOTNULL_DEFAULT[c]
            kinds.add("EMPTY_TO_DEFAULT" if exp is None or d["tobe"] == exp else "REAL")
        else:
            kinds.add("REAL")
    return sorted(kinds)


def diff_row(a, t):
    """AS-IS 행 a 와 TO-BE 행 t 의 속성 차이 목록."""
    out = []
    for c in CMP_TEXT:
        va, vt = cfg.norm_txt(a[c]), cfg.norm_txt(t[c])
        if va != vt:
            out.append({"col": c, "asis": va, "tobe": vt})
    for c in CMP_NUM:
        va, vt = cfg.norm_num(a[c]), cfg.norm_num(t[c])
        if va != vt:
            out.append({"col": c, "asis": va, "tobe": vt})
    for c in CMP_DIV:
        sa, st = cfg.norm_div(a[c]), cfg.norm_div(t[c])
        if sa != st:
            out.append({"col": c, "asis": sorted(sa), "tobe": sorted(st),
                        "only_asis": sorted(sa - st), "only_tobe": sorted(st - sa)})
    return out


def main():
    asis = cfg.jload("asis_measures.json")
    tobe = cfg.jload("tobe_measures.json")
    a_rows, t_rows = asis["rows"], tobe["rows"]
    a_by, t_by = {kof(r): r for r in a_rows}, {kof(r): r for r in t_rows}
    if len(a_by) != len(a_rows) or len(t_by) != len(t_rows):
        raise SystemExit("[KEY FAIL] 3부 키 중복 발견 — 대사 키 가정 재검증 필요")

    scope = set(cfg.MEASURE_PROGRAMS)
    print(f"  대사 범위 {len(scope)} PROGRAM_ID (DM 도메인 우선) · "
          f"AS-IS {len(a_rows)}행 / TO-BE {len(t_rows)}행 전체 보관")

    results, unresolved = [], 0
    for k in sorted(set(a_by) | set(t_by)):
        prog, sheet, col = k
        in_scope = prog in scope
        a, t = a_by.get(k), t_by.get(k)
        kinds = []
        if a and t:
            d = diff_row(a, t)
            if not d:
                cls, reason = "SAME", ""
            else:
                cls = "DIFF"
                reason = f"속성 {len(d)}종 불일치: " + ", ".join(x["col"] for x in d)
                kinds = classify_diff(d)
        elif a and not t:
            cls, d = "MISSING", []
            reason = "AS-IS 존재 / TO-BE 부재 — 이관 누락"
        else:
            cls, d = "EXTRA", []
            key2 = (prog, sheet)
            reason = EXTRA_REASONS.get(key2, "")
            if not reason:
                reason = cfg.unknown("TO-BE 단독 행 — 확장 근거 문서 미확인")
                if in_scope:
                    unresolved += 1
        results.append({
            "program": prog, "sheet": sheet, "column": col,
            "in_scope": in_scope, "class": cls, "reason": reason, "diffs": d,
            "diff_kinds": kinds if cls == "DIFF" else [],
            "asis": {c: cfg.norm_txt(a[c]) for c in CMP_TEXT + CMP_DIV} if a else None,
            "tobe": {c: cfg.norm_txt(t[c]) for c in CMP_TEXT + CMP_DIV} if t else None,
            "sort_asis": cfg.norm_num(a["SORT_ORDER_NO"]) if a else None,
            "sort_tobe": cfg.norm_num(t["SORT_ORDER_NO"]) if t else None,
        })

    scoped = [r for r in results if r["in_scope"]]
    by_cls = collections.Counter(r["class"] for r in scoped)
    by_cls_all = collections.Counter(r["class"] for r in results)
    print(f"  [DM 범위] SAME {by_cls['SAME']} · DIFF {by_cls['DIFF']} · "
          f"MISSING {by_cls['MISSING']} · EXTRA {by_cls['EXTRA']} "
          f"(사유 미확인 EXTRA {unresolved})")
    print(f"  [전 도메인] " + " · ".join(f"{c} {n}" for c, n in sorted(by_cls_all.items())))

    # 프로그램별 요약 (사람이 먼저 보는 축)
    per_prog = {}
    for r in scoped:
        p = per_prog.setdefault(r["program"], collections.Counter())
        p[r["class"]] += 1
    prog_summary = {p: dict(sorted(c.items())) for p, c in sorted(per_prog.items())
                    if set(c) - {"SAME"}}

    # DIFF 가 어느 속성에서 나는지 — 계통 결함 파악용
    diff_cols = collections.Counter(x["col"] for r in scoped if r["class"] == "DIFF"
                                    for x in r["diffs"])
    # 확인 대상 = REAL + DIV_SCOPE_REMOVED (축소는 설명되는 차이가 아니다)
    ATTENTION = {"REAL", "DIV_SCOPE_REMOVED"}
    kind_cnt = collections.Counter(
        ("+".join(sorted(ATTENTION & set(r["diff_kinds"]))) or "+".join(r["diff_kinds"]))
        for r in scoped if r["class"] == "DIFF")
    real_diff = sum(1 for r in scoped
                    if r["class"] == "DIFF" and (ATTENTION & set(r["diff_kinds"])))
    print(f"  DIFF 계통: " + " · ".join(f"{k} {n}" for k, n in kind_cnt.most_common()))
    print(f"  ⇒ 확인 대상(REAL + DIV_SCOPE_REMOVED) {real_diff}건")

    cfg.jdump({
        "meta": {
            "snapshot": cfg.SNAPSHOT_DATE,
            "asis_source": asis["meta"].get("label"),
            "key": list(KEY),
            "key_evidence": "PK_SCM_MST_SHEET_MEASURE = UNIQUE INDEX(PROGRAM_ID,SHEET_NAME,"
                            "COLUMN_NAME) 실측. 제약 아님. 양측 3부 키 중복 0건.",
            "compare_columns": CMP_TEXT + CMP_NUM + CMP_DIV,
            "division_compare": "토큰 집합 비교 ('40,82,81' == '81,82,40'). ''==NULL",
            "scope": sorted(scope),
            "scoped_summary": dict(sorted(by_cls.items())),
            "all_summary": dict(sorted(by_cls_all.items())),
            "unresolved_extra": unresolved,
            "diff_columns": dict(diff_cols.most_common()),
            "diff_kinds": dict(kind_cnt.most_common()),
            "diff_kind_rule": {
                "DIV_SCOPE_ADDED": "AS-IS division 을 유지한 채 TO-BE 가 division 만 추가 — 적용범위 확장",
                "DIV_SCOPE_REMOVED": "AS-IS 에 있던 division 이 TO-BE 에서 빠짐 — **확인 대상**"
                                     "(실사용 division 이 화면에서 사라지는 사고)",
                "EMPTY_TO_DEFAULT": "AS-IS 공란 → Oracle NOT NULL DEFAULT 로 채워짐. "
                                    "⚠ DEFAULT_FLAG ''→'Y' 는 기본 미표시 measure 가 기본 표시로 바뀌는 의미 변경",
                "REAL": "위 둘로 설명되지 않는 실차이 — 확인 대상",
            },
            "real_diff": real_diff,
            "program_summary": prog_summary,
        },
        "rows": results,
    }, "measure_diff.json")

    # ── MEASURE 사전 (COLUMN_NAME 축) ────────────────────────────────────────
    keys = sorted({r["COLUMN_NAME"].strip().upper() for r in a_rows + t_rows})
    bucket = {k: {"asis": [], "tobe": []} for k in keys}
    for r in a_rows:
        bucket[r["COLUMN_NAME"].strip().upper()]["asis"].append(r)
    for r in t_rows:
        bucket[r["COLUMN_NAME"].strip().upper()]["tobe"].append(r)

    dic = []
    for k in keys:
        a, t = bucket[k]["asis"], bucket[k]["tobe"]
        both = a + t
        label = collections.Counter(cfg.norm_txt(r["COLUMN_LABEL_NAME"]) for r in both
                                    if cfg.norm_txt(r["COLUMN_LABEL_NAME"]))
        sort = collections.Counter(cfg.norm_num(r["SORT_ORDER_NO"]) for r in both
                                   if cfg.norm_num(r["SORT_ORDER_NO"]) is not None)
        default = collections.Counter(cfg.norm_txt(r["DEFAULT_FLAG"]) for r in both
                                      if cfg.norm_txt(r["DEFAULT_FLAG"]))
        selectable = collections.Counter(cfg.norm_txt(r["USER_SELECTABLE_FLAG"]) for r in both
                                         if cfg.norm_txt(r["USER_SELECTABLE_FLAG"]))
        color = collections.Counter(cfg.norm_txt(r["ATTRIBUTE3"]) for r in both
                                    if cfg.norm_txt(r["ATTRIBUTE3"]))
        divs = collections.Counter()
        for r in both:
            for dv in cfg.norm_div(r["DIVISION_ID"]):
                divs[dv] += 1
        variants = sorted({r["COLUMN_NAME"] for r in both})
        top_label = label.most_common(1)[0] if label else None
        dic.append({
            "key": k,
            "name_variants": variants,
            "case_inconsistent": len(variants) > 1,
            "usage": {"asis_rows": len(a), "asis_programs": len({r["PROGRAM_ID"] for r in a}),
                      "tobe_rows": len(t), "tobe_programs": len({r["PROGRAM_ID"] for r in t})},
            "label_standard": ({"value": top_label[0], "n": top_label[1],
                                "dist": dict(label.most_common())}
                               if top_label else
                               {"value": cfg.unknown("라벨 이력 없음"), "n": 0, "dist": {}}),
            "sort_dist": dict(sort.most_common()),
            "default_flag_dist": dict(default.most_common()),
            "user_selectable_dist": dict(selectable.most_common()),
            "measure_color_attr3": dict(color.most_common()),
            "division_usage": dict(divs.most_common()),
            "programs_asis": sorted({r["PROGRAM_ID"] for r in a}),
            "programs_tobe": sorted({r["PROGRAM_ID"] for r in t}),
        })

    print(f"  MEASURE 사전 {len(dic)}종")
    print("  -> " + cfg.jdump({
        "meta": {"snapshot": cfg.SNAPSHOT_DATE, "asis_source": asis["meta"].get("label"),
                 "asis_rows": len(a_rows), "tobe_rows": len(t_rows),
                 "note": "ATTRIBUTE3 = MEASURE_COLOR. SHEET_MEASURE 에는 width/align/scale/"
                         "cell control 이 없다 — PIVOT 값 슬롯이다."},
        "measures": dic,
    }, "dict_sheet_measures.json"))


if __name__ == "__main__":
    sys.exit(main())
