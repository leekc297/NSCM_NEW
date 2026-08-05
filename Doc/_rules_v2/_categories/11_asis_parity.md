# 카테고리 11 — AS-IS 분석·정합 / AS-IS Analysis & Parity

> **연다: 언제?** AS-IS 원소스(.cs) 분석, TO-BE 1:1 매핑 검증, 분석서/설계서 산출물 작성 시.
> **대원칙**: AS-IS 전량 Read(처음~끝) — 부분 발췌·자동 추출 1회 통과 채택 금지 (anti-simplification).

| # | Hook | 강도 | 계율 1줄 |
|---:|---|:--:|---|
| 2 | [asis-coverage-check](../hooks/asis-coverage-check.md) | ⭐⭐ | AS-IS 4축(Event/API/Validation/Expression) 100% 매핑 + §0.5 권한 게이트 3형 + `__asis-mapping__.md` 의무 |
| 1 | [asis-button-mapping](../hooks/asis-button-mapping.md) | ⭐ | CRUD 6 + Aux 4 버튼 AS-IS 매핑 → hotkeyConfig |
| 49 | [screen-entry-asis-baseline](../hooks/screen-entry-asis-baseline.md) | ⭐ | 신규 화면 진입 AS-IS baseline 4단계 |
| 33 | [popup-asis-analysis](../hooks/popup-asis-analysis.md) | ⭐ | Popup 9 카테고리 .cs deep read — 호출 팝업은 별도 파일 |
| 105 | [screen-analysis-workbook-standard](../hooks/screen-analysis-workbook-standard.md) | ⭐⭐ | 화면설계서 8시트 / UI분석서 10시트 신포맷 + 0단계 선행 산출물(주요이벤트·제약매트릭스 MD) + 카운트 대사 |
| 91 | [sheet-name-asis-preserve-mandatory](../hooks/sheet-name-asis-preserve-mandatory.md) | ⭐⭐⭐ | SHEET_NAME=AS-IS 원본 보존 (카테고리 08 공유) |
| 112 | [search-condition-asis-tobe-catalog](../hooks/search-condition-asis-tobe-catalog.md) | ⭐⭐ | 조회조건 카탈로그 전 행 대조 (카테고리 04 공유) |
| 117 | [search-condition-datasource-asis-parity](../hooks/search-condition-datasource-asis-parity.md) | ⭐⭐ | 추출 쿼리 AS-IS 1:1 — 불일치=MINUS 실측 판정 (카테고리 04 공유) |
| 114 | [msg-id-asis-tobe-conversion](../hooks/msg-id-asis-tobe-conversion.md) | ⭐⭐⭐ | AS-IS MSG_ID 그대로 복사 금지 (카테고리 07 공유) |
| 101 | [ui-work-entry-playbook](../hooks/ui-work-entry-playbook.md) §2 | ⭐⭐⭐ | 신규 UI = 분석 MD 8종+xlsx+매트릭스+원시 .cs **3-way cross-check** |

## 필수 원천 (실측 순서)
1. **원소스**: `GSCM/06.UIL/...`(최신 정본) vs `GSCM_20260512`(이전) — 메모리 `reference_asis_source_folders`. 화면 .cs + Designer.cs + **호출 팝업 .cs 별도**
2. **분석 MD 8종**: `Doc/_analysis/domain_{DM|Common|SCM}/screens/{ID}/` — **validation.md + expressions.md 필독** + 카운트 일치 의무(PR 게이트)
3. **xlsx 13시트**: `_analysis/_screens/{27~32}_*_Screens/` — ⚠️ 1~10 시트 오염 사고 이력: `00_정정안내` 시트 있으면 **MD 폴더 1차 신뢰**
4. **통합 매트릭스**: `_analysis/Screen_POPUP_SP_Tables_Matrix.xlsx`(3,318행/395화면/710 SP)
5. **AS-IS DB**: `.env.asis` MSSQL 직접 (SP body=sys.sql_modules / lookup 값 / collation 실측)

## Cross-ref
- AS-IS Framework 7: `_rules_v2/_asis/00_framework/01~07`(BaseForm/DataService/MessageHelper/Logging/Auth/UsrControls/FoxDataClient)
- 격차 10: `_rules_v2/_mapping/asis_to_tobe.md` · 메모리: `feedback_popup_asis_precision` / `feedback_asis_grid_column_extraction` / `feedback_drilldown_grid_flow_asis_mapping`
