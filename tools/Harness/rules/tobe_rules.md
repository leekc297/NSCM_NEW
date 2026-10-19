# To-Be 룰 색인 — 어느 룰이 어디서 기계 판정되는가 (2026-10-16)

문서 룰(사람용)과 하네스 판정(기계용)의 대응표. **판정은 CSV/check.js 가 하고, 문서는 설명이다.** 새 룰은 문서에 쓰기 전에 아래 "판정 위치" 열부터 채운다.

| 영역 | 문서 룰 (원천) | 하네스 판정 위치 | 상태 |
|---|---|---|---|
| 화면 폴더·파일 7종 | `_rules_v2/_tobe/01_file_structure.md`, `.claude/rules/00-fe-screen.md` §B | gen.js 가 그대로 생성 · check.js S01 | 판정 |
| import 별칭·feature 간 금지 | `_tobe/02_imports.md`, 금지 Top 11 #1·#2 | forbidden F01/F02 | 판정 |
| Page 조합(MainTitle/Form/SubTitle/Grid) | `_tobe/03_main_component.md` | gen.js 템플릿 · check.js S03 | 판정 |
| Store(createPersistedStoreWithTab, 검색조건 저장/복원 G1) | `_tobe/04_store.md`, `_mapping/asis_to_tobe.md` §2 | gen.js 템플릿(fetchStaticColumns + search-conditions) | 생성만 |
| constants(MENU_ID/SHEETS 케이싱) | `_tobe/05_constants.md` | gen.js · check.js S00/G01 | 판정 |
| SearchArea/FormItem/콤보 변환/inline 금지 | `_tobe/06_search_area.md` §1·§3·§4 | check.js S02 · forbidden F13/F14/F15 | 판정 |
| 조회조건 카탈로그 13종 + 콤보ID | `_tobe/06_search_area.md` §6, `_dictionary/01_search_conditions.md` | **map_field.csv** → gen.js (카탈로그 필드·콤보ID·LBL) | 판정(생성) |
| 컨트롤 타입 매핑 | `_mapping/asis_to_tobe.md`, `06_search_area.md` §5 | **map_control.csv** · check.js D01(사전 밖 컴포넌트) | 판정 |
| 버튼 → SubTitle/팝업/단축키 | `_tobe/09_subtitle_hotkey.md`, `10_popup_modal.md` | **map_button.csv** → gen.js | 생성만 |
| 이벤트 배선(그리드/폼) | `_tobe/07_datagrid.md`, `09_WIJMO_VALIDATION_EXPRESSION.md` | **map_event.csv** → 스텁 · check.js G03 | 판정(존재) |
| Grid 컬럼 메타 / 하드코딩 허용 | `_tobe/08_column_meta.md`, `_dictionary/02_sheet_columns.md` | gen.js(META→staticColumns, HARDCODED→HARD_COLUMNS) · forbidden F10 | 판정 |
| CRUD_TYPE 전용·행상태 필드 금지 | `check-ui-gates.ps1` G-A | forbidden F06 (중복 판정 — 둘 다 유지) | 판정 |
| 빈 catch·콤보 quoting | `check-ui-gates.ps1` G-F/G-G | forbidden F11 (quoting 은 기존 hook 유지) | 판정 |
| As-is 대사(엔드포인트·이벤트·컨트롤·시트) | `.claude/rules/00-fe-screen.md` §D, `asis-coverage-check` | **__asis-mapping__.md** 생성 + check.js M01~M05/G01~G04 | 판정 |
| 의도된 차이(레이아웃 아티팩트·내장 버튼·SPREAD_TITLE→메타·공통 콤보 SP) | `_mapping/asis_to_tobe.md` 격차 결정, `__asis-mapping__.md` 해당없음 사유 1,747행 | **allowed_gaps.csv** | 판정 |
| Validation/Expression 100% | `09_WIJMO_VALIDATION_EXPRESSION.md`, `Doc/_analysis/.../validation.md·expressions.md` | gen.js → `hooks/use{Page}Validation.ts`(V-nnn 마커)·`use{Page}Expression.ts`(E-nnn) · check.js V01(마커 수 = MD 행 수, 누락 BLOCK) / V02(apply TODO 잔존, final BLOCK) | 판정 |
| SP 등록 4 메타 테이블 | `08_SCREEN_REGISTRATION.md` | gen.js `register.json`(3-키 초안) — 등록 자체는 클라우드 | 생성만 |
| BE 표준(Controller/Service/MyBatis) | `_tobe/11_be_controller_service.md`, `04_BE_RULES.md` | forbidden F08/F09(scope java — check.js 는 FE 폴더만 봄) | 후보(BE 체크 미연결) |
| MSSQL→Oracle 치환 | `02-db-sql.md`, `project_db_migration_rules` | forbidden F07(scope sql) · 기존 `check-dbeaver-sql.ps1` | 기존 hook |
| i18n MSG/LBL 코드 | `_categories/07_i18n_msg.md` | forbidden F12(미확정 코드) · map_field.csv lbl | 판정 |

## 룰 추가 절차
1. 어떤 CSV 가 맞는지 고른다: 매핑(map_*) / 허용(allowed_gaps) / 금지(forbidden).
2. 한 줄 추가 → `node gen.js <ID>` 재생성과 `node check.js --page …` 둘 다 바로 반영.
3. 문서(_tobe/_dev_rules)에는 "판정: forbidden F16" 처럼 판정 위치를 적는다. 판정 위치가 없는 룰은 "후보" 다.
