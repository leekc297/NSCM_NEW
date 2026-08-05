# 카테고리 01 — UI 디자인·레이아웃 / UI Design & Layout

> **연다: 언제?** 화면·팝업의 **보이는 것**(배치/높이/색/헤더/아이콘/정렬)을 만들거나 고칠 때.
> **원칙**: 본 파일은 인덱스 — 본문은 `Doc/_rules_v2/hooks/<name>.md`. 카운트는 RULESET_MASTER §4 만 보유.

| # | Hook | 강도 | 계율 1줄 |
|---:|---|:--:|---|
| 90 | [figma-layout-parity-mandatory](../hooks/figma-layout-parity-mandatory.md) | ⭐⭐⭐ | Figma MD 영역 배치대로 구현(디자인-우선). 수정 시 불일치면 레이아웃 교체. **단, Figma=디자인 참조 only — 정책 판단 금지(§1.5)** |
| 94 | [search-condition-height-uniformity](../hooks/search-condition-height-uniformity.md) | ⭐⭐⭐ | 조회조건 모든 객체 높이 **36px** (Main+Popup). DatePicker=`.datePickerFix`. 1단 4개=`gridSize` |
| 93 | [grid-multi-tier-header-height](../hooks/grid-multi-tier-header-height.md) | ⭐⭐⭐ | 다단 헤더 총높이 **48px 고정** (1단48/2단24/3단16). 1단높이×N 비대화 금지 |
| 95 | [grid-cell-backcolor-standard](../hooks/grid-cell-backcolor-standard.md) | ⭐⭐⭐ | 셀 배경 3색: 기본 White+zebra / 편집가능 Yellow / 편집-잠금 Gray. 전체 회색·inline 색 금지 |
| 108 | [ui-grid-corner-no-header](../hooks/ui-grid-corner-no-header.md) | ⭐⭐ | rowHeader 그리드 = TopLeft 전체 단일 머지 + **'No.'** 라벨 + 중앙 정렬 |
| 120 | [ui-title-icon-buttons-standard](../hooks/ui-title-icon-buttons-standard.md) | ⭐⭐ | **환율 버튼=항상 아이콘**(IcExchangeRate). 아이콘 순서=왼쪽부터 환율→GridColumnSet→Measure. 텍스트 버튼은 아이콘 앞 |
| 121 | [form-common-styles-mandatory](../hooks/form-common-styles-mandatory.md) | ⭐⭐ | **폼 스타일=`@foundation` common-styles 공용 클래스만**(`formItem` 전 FormItem 필수/`customGrid`/`customCheckbox`/`popupSearchField`) — 로컬 scss 폼 레이아웃 신설 금지. 정본 SalesSiteForm |
| 96 | [column-align-code-standard](../hooks/column-align-code-standard.md) | ⭐⭐ | `HORIZONTAL_ALIGN_CODE`=단일문자 C/L/R ("Center" 전체단어 금지 — 정렬 silent 미적용) |
| 34 | [popup-dialog-layout](../hooks/popup-dialog-layout.md) | ⭐ | CustomDialog 잘림·중앙 미표시 방지 레이아웃 |
| 83 | [search-area-button-position-and-toggle](../hooks/search-area-button-position-and-toggle.md) | ⭐ | 검색버튼 위치 표준 + 3단↑ 조회조건 펼침/닫기 토글 |
| 87 | [screen-combo-validation-message-mandatory](../hooks/screen-combo-validation-message-mandatory.md) §D | ⭐⭐⭐ | 다단 헤더 depth=DB 라벨 메타(`getColumnDepth`) — 화면 하드코딩 금지 |
| 101 | [ui-work-entry-playbook](../hooks/ui-work-entry-playbook.md) | ⭐⭐⭐ | "보완"=전면 점검·교정 / "신규 생성"=14단계 3-way cross-check — UI 작업 진입 플레이북 |

## Cross-ref
- TO-BE 정밀: `_tobe/06_search_area.md` / `_tobe/07_datagrid.md` / `_tobe/00_SCREEN_ANATOMY.md`
- 메모리: `feedback_search_condition_height_uniformity` / `feedback_grid_multi_tier_header_height` / `feedback_grid_cell_backcolor_standard` / `feedback_grid_corner_no_header_standard` / `feedback_icon_buttons_and_lbl_reuse` / `feedback_figma_design_reference_only`
- 체크리스트: RULESET_MASTER §3.1 (PRE-WRITE 디자인 항목)
