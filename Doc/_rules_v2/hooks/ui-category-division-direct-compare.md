# Hook #113 — UI Category DIVISION_ID 가시성 = 서버 직접 비교 (attr 우회·하드코딩·화이트리스트 금지)

> 제정: 2026-07-15 (사용자 지정 — DMF0021 Sales Plan Grid Column 표시 사고).
> 트리거: 화면 신규/수정에서 **그리드 정적 컬럼(SHEET_COLUMNS) 표시** 를 다루는 모든 작업.

## §0. 배경 (사용자 지시 원문)

> "Grid Column 관련 Hard Coding or WhiteList 있으면 안됩니다."
> "UI Category Setup 에서 Division_id Column 을 DTO Division 필드와 비교하는 부분을 Rule 로 적용해서
>  attr1 or attr3 으로 비교하지 않고 Division_id 를 직접 비교하도록 해주세요."

사고: DMF0021 초기 구현이 ① MEASURE 강제표시 하드코딩(실측하니 VISIBLE_FLAG='Y' 로 예외 자체가 불필요)
② MEASURE_FALLBACK 31코드 하드코딩 degrade ③ ATTRIBUTE3/ATTRIBUTE1 콤마토큰 클라 비교(mkt-fcst #41 계보)
를 갖고 있었고, 사용자 Column Setup(DISPLAY_FLAG)은 미반영이었다.

## §1. 룰 (Hard Rules)

1. **DIVISION_ID 가시성 판정은 서버가 수행** — `PKG_NSCM_UI_COM_MENU.PR_GET_SHEET_COLUMN_LIST /
   PR_GET_SHEET_MEASURE_LIST` 는 `divisionId` 파라미터를 받아 SHEET_COLUMNS/SHEET_MEASURE 의
   **DIVISION_ID 를 직접(콤마토큰) 비교**해 필터한 결과만 반환한다 (실측 2026-07-15: DMF0021
   'Sales Plan' — divisionId '40'=46행 / '81'=32행 / ''=62행 전체).
   → FE 는 `/admin/menu/{MNU_ID}/column|measure` 호출 시 **divisionId 를 반드시 전송**하고,
   division 변경 시 **재fetch** 한다. 이것이 "DIVISION_ID 직접 비교"의 구현이다.
2. ❌ **ATTRIBUTE1/ATTRIBUTE3 로 division 가시성 클라 비교 금지** (구 mkt-fcst handoff #41 방식 —
   신규 화면 채택 금지, 기존 화면은 후속 정리 대상).
3. ❌ **컬럼/measure 목록의 하드코딩·화이트리스트·fallback 상수 금지** — 특정 컬럼 강제표시 예외,
   `*_FALLBACK` 코드 목록, MAIN_COLUMNS 류 degrade 전부 금지. 메타 미적재 = 빈 그리드가 정답
   (admin 적재가 정본 — hook ui-dynamic-property-management).
4. **FE 표시 필터는 2개 boolean 만**: `visible`(VISIBLE_FLAG — admin 관리 노출) &&
   `display`(DISPLAY_FLAG — 사용자 Column Setup 선택). BE GridColumn DTO 가 'Y'/'N' 을 boolean 으로
   직렬화한다 (GridColumn.java 실측). ColumnSettingModal 로컬 반영은 **display** 를 갱신한다
   (visible 을 사용자 조작으로 덮어쓰지 않는다).

## §2. 정본

- FE: `features/demand/src/pages/sales-plan/components/SalesPlanGrid.tsx` visibleColumns (2026-07-15 판)
  + `useSalesPlanStore.ts` fetchStaticColumns(divisionId 전송)/applyColumnVisibility(display 갱신)
- BE(참조만): `admin/menu/dto/GridColumn.java` (visible/display boolean 직렬화, DIVISION_ID 미직렬화 —
  서버 필터 완결이므로 DTO 에 divisionId 추가 불필요)

## §3. 점검 체크 (PRE-WRITE)

- [ ] fetch 에 divisionId 포함 + division 변경 deps 재fetch?
- [ ] 필터 = `visible !== false && display !== false` 뿐인가? (컬럼명 분기 0건)
- [ ] `FALLBACK|MAIN_COLUMNS|강제표시` grep 0건?
- [ ] attribute1/attribute3 division 비교 0건?
