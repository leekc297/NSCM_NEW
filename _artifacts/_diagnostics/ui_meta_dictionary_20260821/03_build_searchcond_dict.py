#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""03_build_searchcond_dict.py — 조회조건 지식사전 (항목 축) 생성.

기존 MATRIX 는 **화면 축**(화면 × 조건)이다. 여기서는 같은 근거를 **항목 축**(조건 → 표준)으로
pivot 한다. MATRIX 와 그 extract JSON 은 원천으로 두고 수정하지 않는다.

입력
  ../searchcond_matrix_20260819/extract/*.json        13UI · 154 조건 (실측 1차 근거)
  ../searchcond_matrix_20260819/04_build_outputs.py   COND_ORDER / COND_ALIAS (표준명 단일 소스)
  cmbo_meta.json                                      콤보 167건 + @토큰 (콤보의 최종 심판)
  Doc/_rules_v2/_mapping/search_conditions_scp_dm.md  953행/99화면 (2차 근거)
  nscm-fe/.../searchFields/SearchFields.tsx           TO-BE 표준 필드

출력  dict_search_conditions.json
"""
import ast
import io
import os
import re
import sys

import cfg

EXTRACT = cfg.SEARCHCOND_EXTRACT
BUILDER = os.path.join(cfg.SEARCHCOND_PIPELINE, "04_build_outputs.py")
SEARCHFIELDS = os.path.join(cfg.ROOT, "nscm-fe", "features", "master", "src",
                            "components", "searchFields", "SearchFields.tsx")

# 세션이 자동 주입하는 토큰 — 화면이 전달할 필요가 없으므로 ARG 판정에서 제외한다.
#   BE BaseService.makeComboQuery 가 넣어주는 것은 @sesUserId / @sesLangCd 둘뿐이다.
SESSION_TOKENS = {"@sesuserid", "@seslangcd"}

# division 사용여부 판정 어휘 — 원문(raw)은 항상 보존하고 분류만 덧붙인다.
NEG_WORDS = ("disabled", "비활성", "숨김", "미사용", "미재현", "제외", "없음", "미표시")
POS_WORDS = ("공통", "활성", "사용", "표시", "고정", "적용", "행소스", "동일")

NONE_PAT = re.compile(r"\A(없음|-|해당없음|N/?A)\.?\Z", re.I)
CLIENT_PAT = re.compile(r"클라|client|프론트|FE\s*필터|toOptions|필터링")
TAIL_PAT = re.compile(r"\s*\(표준명 외.*?\)\s*\Z")


def load_std_names():
    """표준 조건명(COND_ORDER)·정규화표(COND_ALIAS)를 기존 빌더 소스에서 그대로 읽어온다.

    값을 복사해 두면 두 곳이 갈라지므로 ast 로 원본에서 추출한다 (표준명 단일 소스 유지).
    """
    tree = ast.parse(io.open(BUILDER, encoding="utf-8").read())
    out = {}
    for node in tree.body:
        if isinstance(node, ast.Assign) and len(node.targets) == 1:
            t = node.targets[0]
            if isinstance(t, ast.Name) and t.id in ("COND_ORDER", "COND_ALIAS"):
                out[t.id] = ast.literal_eval(node.value)
    missing = {"COND_ORDER", "COND_ALIAS"} - set(out)
    if missing:
        raise SystemExit(f"{BUILDER} 에서 {missing} 추출 실패 — 원본 구조 변경 여부 확인")
    return out["COND_ORDER"], out["COND_ALIAS"]


def norm_cond(name, alias):
    n = (name or "").strip()
    if n in alias:
        return alias[n]
    base = TAIL_PAT.sub("", n).strip()          # '(표준명 외 — ...)' 꼬리표 제거 후 재시도
    if base in alias:
        return alias[base]
    return base or n


def classify_div(text):
    """div40 / div81 / div82 자유서술 → 사용·미사용·조건부·해당없음 + 원문 보존."""
    t = (text or "").strip()
    if not t:
        return {"use": "해당없음", "raw": ""}
    low = t.lower()
    neg = any(w in low for w in NEG_WORDS)
    pos = any(w in t for w in POS_WORDS)
    if neg and pos:
        return {"use": "조건부", "raw": t}
    if neg:
        return {"use": "미사용", "raw": t}
    if pos:
        return {"use": "사용", "raw": t}
    return {"use": "조건부", "raw": t}


def resolve_combo(text, cmbo_ids):
    """tobe.combo 자유서술에서 실제 등록된 CMBO SQL_ID 를 찾아낸다 (가장 긴 일치 우선).

    ⚠ 부분문자열 매칭 금지. 'ProjectByDivision' 안의 'Division' 처럼 **더 긴 식별자의 일부**를
      콤보로 잡으면 PJT·Model 같은 팝업 조건에 엉뚱한 콤보가 붙는다.
      단어 경계 일치만 인정하고, 없으면 틀린 답 대신 미해석(None)을 돌려준다.
    """
    t = (text or "").strip()
    if not t:
        return None
    hits = [s for s in cmbo_ids
            if re.search(r"(?<![A-Za-z0-9_])" + re.escape(s) + r"(?![A-Za-z0-9_])", t)]
    return max(hits, key=len) if hits else None


# 조회조건 컨트롤 종류 — binding_mode 는 콤보·팝업에만 의미가 있다.
CONTROL_KINDS = (
    ("팝업", re.compile(r"팝업|모달|popup|modal|Modal", re.I)),
    ("콤보", re.compile(r"콤보|combo|dropdown|Dropdown|Select", re.I)),
    ("체크박스", re.compile(r"체크|checkbox|Checkbox", re.I)),
    ("달력", re.compile(r"달력|date|Date|월|일자", re.I)),
    ("텍스트", re.compile(r"텍스트|input|Input|text", re.I)),
)


def control_kind(text):
    t = (text or "").strip()
    if not t:
        return cfg.unknown("컨트롤 서술 없음")
    for kind, pat in CONTROL_KINDS:
        if pat.search(t):
            return kind
    return cfg.unknown("컨트롤 종류 미판정")


def classify_binding(tobe, tokens, cmbo_id, kind):
    """CASCADE / ARG / FILTER 판정 (플랜 Phase 1 규칙).

    ARG     콤보 SQL 이 세션 자동주입 외의 @토큰을 요구 — 미전달 시 조용한 0행이라 발견이 가장 늦다
    CASCADE 상위 조건 변경 시 하위 재조회·reset 이 있음
    FILTER  토큰 없이 전량 fetch 후 클라이언트 필터
    """
    # 체크박스·달력·텍스트는 데이터 소스가 없어 binding 개념 자체가 없다.
    #   이것을 '미확인' 으로 두면 사전에 잡음이 쌓여 진짜 미확인이 묻힌다.
    if kind in ("체크박스", "달력", "텍스트"):
        return {"modes": [], "primary": f"해당없음({kind})", "why": {}}

    modes, why = [], {}
    user_tokens = [t for t in tokens if t.lower() not in SESSION_TOKENS]
    if user_tokens:
        modes.append("ARG")
        why["ARG"] = f"{cmbo_id} 콤보 SQL 이 {', '.join(user_tokens)} 요구 (세션 자동주입 제외)"

    casc = (tobe.get("cascade") or "").strip()
    if casc and not NONE_PAT.match(casc):
        modes.append("CASCADE")
        why["CASCADE"] = casc

    filt = (tobe.get("filter") or "").strip()
    params = (tobe.get("params") or "").strip()
    if CLIENT_PAT.search(filt + " " + params) and not user_tokens:
        modes.append("FILTER")
        why["FILTER"] = filt or params

    if not modes:
        if filt:
            modes.append("FILTER")
            why["FILTER"] = filt
        else:
            return {"modes": [], "primary": cfg.unknown("cascade·filter·params 서술 부재"), "why": {}}

    primary = "ARG" if "ARG" in modes else ("CASCADE" if "CASCADE" in modes else "FILTER")
    return {"modes": modes, "primary": primary, "why": why}


def parse_searchfields():
    """@master/searchFields 의 export 필드명 목록."""
    if not os.path.exists(SEARCHFIELDS):
        return []
    src = io.open(SEARCHFIELDS, encoding="utf-8", errors="ignore").read()
    return sorted(set(re.findall(r"export const (\w+Field)\b", src)))


def parse_catalog():
    """카탈로그 953행 → {To-Be 명칭: [화면...]} (2차 근거·커버리지 산정용).

    ⚠ 표가 두 형태다 — '구분' 열이 있는 14열과 없는 13열. 고정 인덱스로 읽으면 1,054행이
      한 칸씩 밀려 조용히 오독된다. 반드시 각 표의 **헤더 행에서 열 위치를 찾아** 쓴다.
    """
    p = cfg.SEARCHCOND_CATALOG
    if not os.path.exists(p):
        return {}, 0
    by_name, total, screen, idx = {}, 0, None, None
    for ln in io.open(p, encoding="utf-8"):
        m = re.match(r"\A###\s+(.+?)\s*\(\d+행", ln)
        if m:
            screen, idx = m.group(1).strip(), None
            continue
        if not screen or not ln.startswith("|"):
            continue
        cells = [c.strip() for c in ln.rstrip("\n").strip().strip("|").split("|")]
        if "To-Be 명칭" in cells:                       # 헤더 행 — 열 위치 확정
            idx = cells.index("To-Be 명칭")
            continue
        if idx is None or all(set(c) <= {"-", ":"} for c in cells if c):
            continue                                    # 구분선 또는 헤더 이전
        total += 1
        if idx < len(cells) and cells[idx]:
            by_name.setdefault(cells[idx], []).append(screen)
    return by_name, total


def build_entry(ui, c, cmbo_by_id, cmbo_ids):
    asis, tobe = c.get("asis") or {}, c.get("tobe") or {}
    cmbo_id = resolve_combo(tobe.get("combo"), cmbo_ids)
    toks = sorted({t for r in cmbo_by_id.get(cmbo_id, []) for t in r["TOKENS"]}) if cmbo_id else []
    kind = control_kind(tobe.get("control"))
    return {
        "ui": ui,
        "cond_raw": c.get("cond"),
        "control_kind": kind,
        "label_asis": asis.get("label") or cfg.unknown("AS-IS 서술 없음"),
        "label_tobe": tobe.get("label") or cfg.unknown("TO-BE 미구현"),
        "control_asis": asis.get("control") or cfg.unknown("AS-IS 서술 없음"),
        "control_tobe": tobe.get("control") or cfg.unknown("TO-BE 미구현"),
        "combo_text": tobe.get("combo") or cfg.unknown("콤보 서술 없음"),
        "combo_sql_id": cmbo_id or cfg.unknown("CMBO 미해석(콤보 아님 또는 미등록)"),
        "combo_tokens": toks,
        "binding": classify_binding(tobe, toks, cmbo_id or "?", kind),
        "division_usage": {
            "40": classify_div(tobe.get("div40")),
            "81": classify_div(tobe.get("div81")),
            "82": classify_div(tobe.get("div82")),
        },
        "required": tobe.get("required") or cfg.unknown("필수여부 서술 없음"),
        "default": tobe.get("default") or cfg.unknown("기본값 서술 없음"),
        "evidence": (tobe.get("evidence") or []) + (asis.get("evidence") or []),
    }


def main():
    cond_order, cond_alias = load_std_names()
    cmbo = cfg.jload("cmbo_meta.json")
    cmbo_by_id = {}
    for r in cmbo:
        cmbo_by_id.setdefault(r["SQL_ID"], []).append(r)
    cmbo_ids = sorted(cmbo_by_id, key=len, reverse=True)
    fields = parse_searchfields()
    catalog, catalog_rows = parse_catalog()
    print(f"  표준 조건명 {len(cond_order)}종 · CMBO {len(cmbo)}건 · searchFields {len(fields)}종"
          f" · 카탈로그 {catalog_rows}행/{len(catalog)}명칭")

    buckets, n_records = {}, 0
    for fn in sorted(os.listdir(EXTRACT)):
        if not fn.endswith(".json"):
            continue
        d = cfg.jload(fn, base=EXTRACT)
        for c in d.get("conditions", []):
            n_records += 1
            buckets.setdefault(norm_cond(c.get("cond"), cond_alias), []).append(
                build_entry(d["ui"], c, cmbo_by_id, cmbo_ids))

    order = {n: i for i, n in enumerate(cond_order)}
    out = []
    for std in sorted(buckets, key=lambda s: (order.get(s, 999), s)):
        items = buckets[std]
        flds = sorted({f for it in items for f in fields if f in (it["control_tobe"] or "")})
        combos = sorted({it["combo_sql_id"] for it in items if not cfg.is_unknown(it["combo_sql_id"])})
        primaries = sorted({it["binding"]["primary"] for it in items})
        kinds = sorted({it["control_kind"] for it in items})
        div_std = {}
        for d in ("40", "81", "82"):
            uniq = sorted({it["division_usage"][d]["use"] for it in items})
            div_std[d] = uniq[0] if len(uniq) == 1 else "화면별 상이(" + ",".join(uniq) + ")"
        cat = catalog.get(std, [])
        out.append({
            "cond": std,
            "std_axis": std in order,
            "ui_count": len(items),
            "uis": sorted({it["ui"] for it in items}),
            "tobe_fields": flds or [cfg.unknown("공용 필드 미사용(화면 로컬 구현)")],
            "combo_sql_ids": combos or [cfg.unknown("콤보 아님 또는 CMBO 미등록")],
            "combo_tokens": sorted({t for it in items for t in it["combo_tokens"]}),
            "control_kind": kinds[0] if len(kinds) == 1 else "화면별 상이(" + ",".join(kinds) + ")",
            "binding_primary": primaries[0] if len(primaries) == 1
                               else "화면별 상이(" + ",".join(primaries) + ")",
            "binding_modes_seen": sorted({m for it in items for m in it["binding"]["modes"]}),
            "division_usage_standard": div_std,
            "catalog_screens": len(cat),
            "coverage": "실측(13UI)" + (f"+카탈로그({len(cat)}화면)" if cat else ""),
            "screens": items,
        })

    meta = {
        "snapshot": cfg.SNAPSHOT_DATE,
        "asis_source": cfg.ASIS_SOURCE_LABEL,
        "primary_evidence": "DMF 13UI 조회조건 MATRIX v1.0 (extract/*.json 154조건)",
        "secondary_evidence": f"search_conditions_scp_dm.md {catalog_rows}행/99화면 (2026-01-22 스냅샷)",
        "combo_authority": f"SCM_ADM_CMBO_SQL_M {len(cmbo)}건 실덤프",
        "searchfields": fields,
        "division_axis_limit": "MATRIX 원천이 40/81/82 3분기만 구분한다. 81_UC/81_HM 등 세부는 raw 서술에만 남는다.",
        "binding_priority": "primary = ARG > CASCADE > FILTER (ARG 미전달은 조용한 0행이라 발견이 가장 늦다)",
        "records": n_records,
    }
    print(f"  조건 레코드 {n_records} → 항목 {len(out)}종")
    print("  -> " + cfg.jdump({"meta": meta, "conditions": out}, "dict_search_conditions.json"))


if __name__ == "__main__":
    sys.exit(main())
