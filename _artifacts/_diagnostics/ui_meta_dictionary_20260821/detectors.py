# -*- coding: utf-8 -*-
"""detectors.py — 컬럼 메타 결함 검출기 (D1~D11) 단일 구현.

04_build_column_dict.py 가 전수 적용하고, 06_verify.py 가 **합성 행**으로 검출기 자체를 검증한다.
두 곳이 같은 함수를 보므로 "사전은 잡는데 게이트는 못 잡는" 식으로 갈릴 수 없다.

⚠ 검출기 검증을 **실데이터의 알려진 사고**로만 하면, 그 사고가 고쳐지는 순간 게이트가 FAIL 로
  뒤집힌다(2026-08-21 DMF0049 PK 중복이 적재 중 해소되며 실제로 발생). 데이터가 고쳐진 것은
  게이트 결함이 아니다. 그래서 검출기는 합성 행으로 검증하고, 실데이터의 사고 잔존 여부는
  **정보성 기록**으로 따로 낸다.
"""

SEVERITY = {
    "D1": "ERROR", "D2": "ERROR", "D3": "INFO", "D4": "ERROR", "D5": "WARN",
    "D6": "ERROR", "D7": "ERROR", "D8": "ERROR", "D9": "ERROR", "D10": "ERROR",
    "D11": "ERROR", "D12": "WARN", "D13": "WARN", "D14": "WARN", "D15": "INFO",
}

DEFECT_DESC = {
    "D1": "콤보인데 CELL_COMBO_DATA_TYPE 공란 → CODE 노출",
    "D2": "콤보 SQL_ID 미등록 → 0행·CODE 노출",
    "D3": "콤보가 @토큰 요구 — FE 전달 필요(미전달=조용한 0행)",
    "D4": "모달 컨트롤인데 CELL_COMBO_DATA_TYPE(모달키) 공란/오값 → 선택 창 안 뜸",
    "D5": "사전 편집표준은 모달인데 **모달 없는** 컨트롤로 등록 → 선택 창 불가",
    "D6": "INPUT_TP_CD 가 FE enum 밖 (MI/OI 역순 등) → 편집 불가 fallthrough",
    "D7": "HORIZONTAL_ALIGN_CODE 가 C/L/R 밖 → 좌측 fallback",
    "D8": "CELL_CONTROL_OBJECT_TYPE_CODE 가 허용값 밖 → 미해석",
    "D9": "PK 중복 → 어느 행이 적용될지 비결정적",
    "D10": "AS-IS lookup 에만 있고 FE enum 에 없는 컨트롤 → 미해석",
    "D11": "키(PROGRAM_ID/SHEET_NAME/COLUMN_NAME) 공란 행 — 어느 화면에도 속하지 않는 쓰레기 행",
    "D12": "CELL_COMBO_DATA_TYPE 가 지정됐으나 컨트롤이 FPComboBox 가 아니라 **소비되지 않음**",
    "D13": "모달 컬럼의 ATTRIBUTE1 에 모달키 잔존 — 구 규약(슬롯 이전 전) 잔재",
    "D14": "DIVISION_ID 가 AS-IS 보다 **축소** — 그 division 에서 컬럼이 사라짐",
    "D15": "DIVISION_ID 가 AS-IS 보다 **확장** — TO-BE 추가분, 근거 확인 대상",
}

# ⭐ 콤보 소비 조건 — 코드 실측(packages/shared/.../data-grid/DataGrid.tsx L477·L498):
#     column.cellCtrlObjTpCd === CELL_CONTROL_TYPE.COMBO && column.cellCboDataTp
#   ⇒ 컨트롤이 FPComboBox 가 **아니면** CELL_COMBO_DATA_TYPE 은 읽히지 않는다(dataMap 미생성).
#     따라서 그 행의 콤보 미등록·토큰 미전달은 **CODE 노출의 원인이 될 수 없다** — D2/D3 대상 밖.
#     (DMF0082 forecast-price.constants.ts L146~149 가 같은 사실을 이미 기록해 두었다.)
#   ⚠ AS-IS 도 동일하다 — `GSCM/01.Framework/GSCM.Windows.Forms/Class/SpreadInfo.cs:1442`
#     `if (cellControlType == "FPComboBox")` 안에서만 CELL_COMBO_DATA_TYPE 을 읽는다.
#     ⇒ 컨트롤 공란 + 콤보 ID 조합이 **AS-IS 에도 같은 모양이면** TO-BE 가 만든 결함이 아니라
#       원본 잔재다. 그걸 "콤보로 만들어 주는" 것은 보완이 아니라 **AS-IS 대비 기능 추가**다.
COMBO_CONSUMING_CONTROL = "FPComboBox"

SESSION_TOKENS = {"@sesuserid", "@seslangcd"}


def row_defects(r, ctx, cfg):
    """행 1개에서 D1~D8·D10·D11 을 적출한다. (D9=PK 중복은 집합 판정이라 호출부에서)

    ctx = {cmbo_ids, cmbo_tokens, allowed_controls, lookup_only, edit_standard_of,
           asis_of}  # asis_of(prog, sheet, col) -> AS-IS 행 또는 None (파리티 대조용)
    반환 = [(code, detail), ...]
    """
    out = []
    if not (cfg.norm_txt(r["PROGRAM_ID"]) and cfg.norm_txt(r["SHEET_NAME"])
            and cfg.norm_txt(r["COLUMN_NAME"])):
        out.append(("D11", "키 3부 중 공란 존재 — 어느 화면에도 속하지 않는 행"))
        return out

    ctrl = cfg.norm_txt(r["CELL_CONTROL_OBJECT_TYPE_CODE"])
    combo = cfg.norm_txt(r["CELL_COMBO_DATA_TYPE"])
    inp = cfg.norm_txt(r["INPUT_TP_CD"])
    align = cfg.norm_txt(r["HORIZONTAL_ALIGN_CODE"])
    a1 = cfg.norm_txt(r["ATTRIBUTE1"])

    consumes = ctrl == COMBO_CONSUMING_CONTROL
    if consumes and not combo:
        out.append(("D1", "콤보 컬럼인데 CELL_COMBO_DATA_TYPE 공란 → 드롭다운 없음·CODE 노출"))
    if combo and not consumes and ctrl not in cfg.MODAL_CONTROLS:
        # 콤보 ID 는 있는데 컨트롤이 FPComboBox 가 아니다 → 값이 읽히지 않는다.
        #   컨트롤 공란 = "콤보로 만들려다 만" 상태(D1 의 거울) / 다른 컨트롤 = 미소비 잔재.
        #   ⚠ 2026-08-22 규약 전환 — **모달 컨트롤은 제외**한다. 그 슬롯은 콤보 ID 가 아니라
        #     **모달키**라 "소비되지 않음" 이 아니다(아래 D4 가 반대로 공란을 적출한다).
        a = ctx["asis_of"](r["PROGRAM_ID"], r["SHEET_NAME"], r["COLUMN_NAME"])
        same_as_asis = bool(a) and (cfg.norm_txt(a["CELL_CONTROL_OBJECT_TYPE_CODE"]) == ctrl
                                    and cfg.norm_txt(a["CELL_COMBO_DATA_TYPE"]) == combo)
        parity = ("AS-IS 동일 모양 — 원본 잔재이므로 **정정 대상 아님**(고치면 AS-IS 대비 기능 추가)"
                  if same_as_asis else
                  ("AS-IS 행 없음(TO-BE 신설) — 의도 확인 필요" if not a else
                   "AS-IS 와 다름 — TO-BE 에서 생김. 확인 필요"))
        shape = "컨트롤 공란" if not ctrl else f"컨트롤 '{ctrl}'"
        out.append(("D12", f"CELL_COMBO_DATA_TYPE '{combo}' 지정 + {shape} → 소비되지 않음. {parity}"))
    if combo and consumes:
        if combo not in ctx["cmbo_ids"]:
            out.append(("D2", f"CELL_COMBO_DATA_TYPE '{combo}' 가 SCM_ADM_CMBO_SQL_M 미등록 "
                              "→ 0행·CODE 노출"))
        else:
            need = [x for x in sorted(ctx["cmbo_tokens"].get(combo, set()))
                    if x.lower() not in SESSION_TOKENS]
            if need:
                out.append(("D3", f"콤보 '{combo}' 가 {', '.join(need)} 요구 — "
                                  "FE 전달 필요(미전달=조용한 0행)"))
    # ⭐ [2026-08-22 규약 전환] 모달 식별자 슬롯 = **`CELL_COMBO_DATA_TYPE`**.
    #   `CELL_COMBO_DATA_TYPE` 은 컨트롤 타입에 따라 의미가 갈린다:
    #       FPComboBox            → 콤보 SQL_ID
    #       FPModal / FPTextModal → 모달키
    #   근거: AS-IS 메타에는 모달 개념이 없다(`FPModal` **0건** 전수 실측, ATTRIBUTE1 에 Modal/Popup
    #   문자열 0건). `ATTRIBUTE1~5` 는 AS-IS `SpreadInfo` 의 `sParam1~5`(파라미터) 자리이고 실제 값도
    #   division 토큰이다 — 거기에 모달키를 넣던 것은 TO-BE 관례였고 AS-IS 값을 덮어썼다.
    if ctrl in cfg.MODAL_CONTROLS:
        if not combo:
            out.append(("D4", f"{ctrl} 인데 CELL_COMBO_DATA_TYPE(모달키) 공란 → 선택 창이 뜨지 않음"))
        else:
            toks = cfg.norm_div(combo)
            if toks and toks <= set(cfg.DIVISION_TOKENS):
                out.append(("D4", f"{ctrl} CELL_COMBO_DATA_TYPE='{combo}' — "
                                  "모달키 자리에 division 목록이 들어감"))
        # ATTRIBUTE1 은 파라미터 슬롯으로 돌아갔다 — 모달키가 남아 있으면 구 규약 잔재다.
        if a1 and a1 in ctx.get("modal_keys", set()):
            out.append(("D13", f"{ctrl} ATTRIBUTE1='{a1}' 이 모달키 값 — 구 규약 잔재. "
                              "모달키는 CELL_COMBO_DATA_TYPE 가 단일 원천이고 "
                              "ATTRIBUTE1 은 파라미터(sParam1) 자리다"))

    # ⭐ [2026-08-22] DIVISION_ID 를 **AS-IS 동일 화면·동일 시트** 실값과 대조한다.
    #   계기: DMF0082 `CELL_PROD_SITE_ID` — 요구가 "81 에서 제외" 였는데 구현이 81 만 빼고 82 를 남겨
    #   `'40,82'` 가 됐고(AS-IS 는 `'40'` 단독), 그 잘못된 기대값이 검증 스크립트와 클라우드 패키지
    #   3본에 그대로 전파됐다. **요구 문구를 기대값으로 직접 옮기고 AS-IS 를 대조하지 않은 것**이 원인.
    #   ⇒ division 토큰은 요구 문구가 아니라 AS-IS 실측이 정본이다(hook #142 §1.2).
    #   축소(D14)가 확장(D15)보다 위험하다 — AS-IS 에 있던 division 에서 컬럼이 사라진다.
    a_div = ctx["asis_of"](r["PROGRAM_ID"], r["SHEET_NAME"], r["COLUMN_NAME"])
    if a_div is not None:
        at = cfg.norm_div(a_div.get("DIVISION_ID"))
        tt = cfg.norm_div(r.get("DIVISION_ID"))
        if at != tt:
            lost, gained = sorted(at - tt), sorted(tt - at)
            if lost:
                out.append(("D14", f"DIVISION_ID 축소 — AS-IS {sorted(at)} → TO-BE {sorted(tt)} "
                                   f"(사라진 division: {lost}). 그 division 에서 컬럼이 안 보인다"))
            if gained:
                out.append(("D15", f"DIVISION_ID 확장 — AS-IS {sorted(at)} → TO-BE {sorted(tt)} "
                                   f"(추가된 division: {gained}). TO-BE 확장 근거 확인 대상"))

    # D5 — 사전 편집표준이 모달인데 모달이 아닌 컨트롤로 등록.
    #   ⚠ 2026-08-22 정정: `FPTextModal` 은 **자유입력이 정상**이다(AS-IS 파리티).
    #     구 판정은 "모달 표준인데 텍스트 = 결함" 으로 봐서 AS-IS 사양을 결함으로 오탐했다
    #     (DMF0082 ITEM_ID 실사고 — AS-IS 가 TextCellType+아이콘이라 타이핑이 정상이었다).
    #     ⇒ 모달 보유 컨트롤이면 통과. 모달이 아예 없는 컨트롤일 때만 적출한다.
    std = ctx["edit_standard_of"](cfg.norm_txt(r["COLUMN_NAME"]).upper())
    if (std and std.get("confidence") in ("high", "medium")
            and std.get("control", {}).get("value") in cfg.MODAL_CONTROLS
            and ctrl and ctrl not in cfg.MODAL_CONTROLS and inp and inp != "S"):
        # ⚠ 파리티 가드 — 이 셀의 **AS-IS 실값과 같으면 결함이 아니다**.
        #   사전 표준은 컬럼명 축의 통계일 뿐이고, 같은 이름이라도 화면마다 의미가 다르다
        #   (실사고: DMF0049 `MDF Reports.ITEM_ID` 는 AS-IS 가 FPComboBox/`DM_LOOKUP_DIV` 인
        #    lookup 구분 콤보인데, ITEM_ID 통계 표준이 모달이라 결함으로 적출됐다).
        #   hook #142 §2 — 사전은 대조용이고 해당 셀의 AS-IS 실값이 상위 근거다.
        a = ctx["asis_of"](r["PROGRAM_ID"], r["SHEET_NAME"], r["COLUMN_NAME"])
        if not (a and cfg.norm_txt(a["CELL_CONTROL_OBJECT_TYPE_CODE"]) == ctrl):
            gap = "AS-IS 행 없음(TO-BE 신설)" if not a else (
                f"AS-IS 는 '{cfg.norm_txt(a['CELL_CONTROL_OBJECT_TYPE_CODE']) or '(공란)'}'")
            out.append(("D5", f"사전 편집표준은 모달({std['control']['value']}, {std['control']['n']}건)인데 "
                              f"'{ctrl}' 로 등록 — 모달 경로가 없어 선택 창을 띄울 수 없음. {gap}"))
    if inp and inp not in cfg.INPUT_TP_CODES:
        fix = cfg.BAD_INPUT_TP.get(inp)
        out.append(("D6", f"INPUT_TP_CD '{inp}' 는 FE enum(S/O/M/IO/IM) 밖" +
                    (f" — '{fix}' 오기로 보임. 현 상태는 편집 불가로 조용히 fallthrough" if fix else "")))
    if align and align not in cfg.ALIGN_CODES:
        fix = cfg.BAD_ALIGN.get(align)
        out.append(("D7", f"HORIZONTAL_ALIGN_CODE '{align}' 는 C/L/R 밖" +
                    (f" — '{fix}' 로 정정 필요. 현 상태는 좌측 fallback" if fix else "")))
    if ctrl and ctrl not in ctx["allowed_controls"]:
        out.append(("D8", f"CELL_CONTROL_OBJECT_TYPE_CODE '{ctrl}' 가 허용 컨트롤 밖 → 미해석"))
    if ctrl and ctrl in ctx["lookup_only"]:
        out.append(("D10", f"'{ctrl}' 는 lookup 에만 있고 FE enum(CELL_CONTROL_TYPE)에 없음 → 미해석"))
    return out


# 36열 빈 행 — 합성 테스트용 베이스
BLANK_ROW = {
    "PROGRAM_ID": "TST0001", "SHEET_NAME": "Sheet", "COLUMN_NAME": "TEST_COL",
    "COLUMN_LABEL_NAME": "Test", "SORT_ORDER_NO": 10, "DATA_SORT_METHOD_CODE": "",
    "SMALL_CLASS_LABEL_NAME": "", "LARGE_CLASS_LABEL_NAME": "", "FIXED_FLAG": "N",
    "COLUMN_WIDTH": 80, "CELL_CONTROL_OBJECT_TYPE_CODE": "", "CELL_COMBO_DATA_TYPE": "",
    "DATA_SCALE_NUMBER": None, "DATA_MAX_LENGTH": None, "HORIZONTAL_ALIGN_CODE": "C",
    "UPPERCASE_APPLY_FLAG": "N", "VISIBLE_FLAG": "Y", "DIVISION_ID": "", "DEFAULT_FLAG": "Y",
    "USER_SELECTABLE_FLAG": "Y", "VALID_YN": "Y", "CREATED_BY": "admin", "CREATION_DATE": "",
    "LAST_UPDATED_BY": "admin", "LAST_UPDATE_DATE": "", "INPUT_TP_CD": "S",
    **{f"ATTRIBUTE{i}": "" for i in range(1, 11)},
}


def synth(**over):
    r = dict(BLANK_ROW)
    r.update(over)
    return r
