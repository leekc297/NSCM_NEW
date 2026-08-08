# 카테고리 04 — 조회조건·콤보·cascade / Search Conditions & Combos

> **연다: 언제?** SearchArea 조회조건 구성/콤보 데이터 원천/Division cascade 를 다룰 때.
> **2축 의무**: 명칭·유형 = #112 카탈로그 / 데이터 추출 쿼리 = #117 AS-IS 정합 — 서로 별개 축, 둘 다 통과.

| # | Hook | 강도 | 계율 1줄 |
|---:|---|:--:|---|
| 112 | [search-condition-asis-tobe-catalog](../hooks/search-condition-asis-tobe-catalog.md) | ⭐⭐ | SCP·DM 조회조건 = 카탈로그(953행/99화면) **전 행 대조** — 명칭 rename 13쌍 + 다중선택=검색+ALL + 카운트 일치 보고 |
| 117 | [search-condition-datasource-asis-parity](../hooks/search-condition-datasource-asis-parity.md) | ⭐⭐ | 항목별 추출 쿼리 AS-IS 1:1(BigFilter.xml/UP_FX 실측) + **공유 CMBO 수정 전 FE 소비자 전수 grep** — 소비자 2+ = 화면 전용 SQL_ID 분리. ⭐ **§5.5~§5.10(2026-08-08)**: UP_FX 키 = ①CMBO 등록 ②배선 ③FE 파라미터 **3분할 완결** + 토큰 대사표·quoting·빈 catch 금지·편집/조회 이원화(메타 교체 금지) — 게이트 = `ui_gate_runner` 섹션 7 / `ui_http_e2e` D2 / hook G-F·G-G. ⭐ **§5.11 combo SP 프롤로그 이식**(GET_ADMIN_GROUP 권한 승격·PM_TEAM_MAPPING — 리터럴 ADMIN 축소 금지) + **§5.12 호출 지점 N:N 대사**(InsertRow 최우선) — 자동화 `combo_callsite_parity.py` = 게이트 섹션 8 |
| 5 | [cascade-combo-filter](../hooks/cascade-combo-filter.md) | ⭐⭐⭐ | Division→하위 'ALL' reset + Map dedup + 1RT + **§1.4 Div 변경=Grid 비움+CRUD reset** + **§5-G Grid 셀 cascade**(dataMap 스왑/원복) |
| 6 | [cascade-pattern-check](../hooks/cascade-pattern-check.md) | ⭐ | 조회조건·grid cascade 패턴 점검 (룰 07 §2.10) |
| 26 | [messaging-api-and-search-fields-mandatory](../hooks/messaging-api-and-search-fields-mandatory.md) | ⭐⭐⭐ | searchFields 카탈로그 14종 + apiClient 10 + useMessageStore 5 |
| 52 | [search-area-extra-conditions](../hooks/search-area-extra-conditions.md) | ⭐ | 2단(6필드) 초과 시 `extraConditions` 분리 |
| 53 | [search-button-when-no-searcharea](../hooks/search-button-when-no-searcharea.md) | ⭐ | SearchArea 부재 화면 = SubTitle `searchAction` prop |
| 83 | [search-area-button-position-and-toggle](../hooks/search-area-button-position-and-toggle.md) | ⭐ | 검색버튼 위치 + 3단↑ 펼침/닫기 토글 |
| 87 | [screen-combo-validation-message-mandatory](../hooks/screen-combo-validation-message-mandatory.md) §L·§V | ⭐⭐⭐ | 콤보 옵션=룩업 조회(하드코딩 금지) + 날짜 셀 표시↔검증 형식 일치 |
| 94 | [search-condition-height-uniformity](../hooks/search-condition-height-uniformity.md) | ⭐⭐⭐ | (디자인 축 — 카테고리 01 참조) 36px + 1단 4개 |
| 121 | [form-common-styles-mandatory](../hooks/form-common-styles-mandatory.md) | ⭐⭐ | (디자인 축 — 카테고리 01 주소속) SearchArea/폼 스타일 = 공용 common-styles 클래스만(`formItem` 등 4종) — 로컬 scss 폼 레이아웃 금지 |
| 29 | [oracle-cmbo-varname-quote](../hooks/oracle-cmbo-varname-quote.md) | ⭐ | CMBO_SQL_M `@varName` → `TO_CHAR()` wrap (ORA-01722) |
| 123 | [screen-modal-cascade-filter-analysis](../hooks/screen-modal-cascade-filter-analysis.md) | ⭐⭐⭐ | 신규 화면=Cascade/Filter **AS-IS 전수 상세분석 → `Doc/화면분석서/{UI}_..._Cascade_Filter_전수.md` 생성 후 적용** / UI 보완 시 md 부재면 **선분석·생성 후 보완** |

## Cross-ref
- 카탈로그 원문: `_rules_v2/_mapping/search_conditions_scp_dm.md` · TO-BE 정밀: `_tobe/06_search_area.md`
- 메모리: `feedback_search_fields_catalog` / `feedback_form_search_area_standard` / `feedback_combo_registry_full_sync`(미등록=조용한 빈콤보) / `feedback_bind_combo_value_quoting` / `feedback_grid_combo_show_name_not_code` / `feedback_division_change_grid_reset` / `feedback_tabprocquery_filters_reference_identity`(인라인 filters 금지) / `feedback_search_refetch_stale_closure`
- 조회 런타임 원천 구분: 콤보=`SCM_ADM_CMBO_SQL_M`(getCombo/useTabComboQueries) / 룩업=`SCM_ADM_LOOKUP_MASTER(+_DETAIL)`(getLookup/useTabLookupQuery)
