# types (108)

사용 수 내림차순. **신규 화면은 여기 있는 것만 쓴다** — 없으면 사전(map_control.csv) 보완 제안이 먼저(룰 23).

## app-shell

| 이름 | import | 사용 | As-is 대응 | 설명 |
|---|---|---|---|---|
| **AnyPage** | `apps/web/src/mdi (앱 셸 — 화면에서 직접 import 하지 않음)` | 0 |  | PageProps<M> 의 본문은 M 에 의존하지 않으므로(구조가 동일) 하나로 취급한다. |
| **AnyTab** | `apps/web/src/mdi (앱 셸 — 화면에서 직접 import 하지 않음)` | 0 |  |  |
| **MdiTabMode** | `apps/web/src/mdi (앱 셸 — 화면에서 직접 import 하지 않음)` | 0 |  | MDI 탭 열기 모드. - 'multi' : 메뉴 클릭마다 새 탭 생성(고객 요구 — 현행). 같은 메뉴가 여러 탭으로 열림. - 'single': 메뉴 1개 ↔ 탭 1개. 이미 열린 메뉴를 다시 클릭하면 기존 탭으로 포커스. keep-alive 렌더 |

## foundation

| 이름 | import | 사용 | As-is 대응 | 설명 |
|---|---|---|---|---|
| **RawFlexGridColumnConfig** | `@foundation/models` | 383 |  |  |
| **PageProps** | `@foundation/models` | 145 |  |  |
| **HotkeyConfig** | `@foundation/models` | 134 |  |  |
| **ComboResponse** | `@foundation/models` | 95 |  |  |
| **FlexGridColumnConfig** | `@foundation/models` | 71 |  |  |
| **ComboParam** | `@foundation/models` | 27 |  |  |
| **LookupResponse** | `@foundation/models` | 6 |  |  |
| **SalesSite** | `@foundation/models` | 1 |  |  |
| **ApiResponse** | `@foundation/models` | 0 |  |  |
| **BizType** | `@foundation/models` | 0 |  |  |
| **Bucket** | `@foundation/models` | 0 |  |  |
| **ComboCascadeRule** | `@foundation/utils` | 0 |  | 화면이 코드로 든 cascade 표 1건 — 행 컬럼(rowKey) 값으로 콤보 응답 컬럼(comboKey)을 맞춘다. 두 이름은 다를 수 있다 (행 END_CUSTOMER40 <-> 콤보 END_CUSTOMER 등). |
| **DivisionId** | `@foundation/models` | 0 |  |  |
| **EndCustomer** | `@foundation/models` | 0 |  |  |
| **ForecastPriceData** | `@foundation/models` | 0 |  | 수요예측 가격 관련 타입 |
| **ForecastPriceRequest** | `@foundation/models` | 0 |  |  |
| **GridRowPlacement** | `@foundation/utils` | 0 |  |  |
| **I18nResponse** | `@foundation/models` | 0 |  |  |
| **LiveColumnExportMeta** | `@foundation/utils` | 0 |  | `collectLiveColumnExportMeta` 결과 — 컬럼을 갈아끼우기 전에 떠 둔 화면 상태. |
| **LookupParam** | `@foundation/models` | 0 |  |  |
| **Menu** | `@foundation/models` | 0 |  |  |
| **NumberInputRule** | `@foundation/utils` | 0 |  | 숫자 컬럼 입력 제한 규칙. 값이 없는 항목은 제한하지 않는다. |
| **ProcStreamHandlers** | `@foundation/models` | 0 |  |  |
| **ProcStreamLine** | `@foundation/models` | 0 |  | [E20261015-STREAMPROC] 대량 조회 스트리밍(call-proc-stream) 계약. BE 는 같은 메타(SCM_ADM_MNU_BTN_MPG_M → API_M → PROC_M)로 같은 프로시저를 실행하고, OUT 커서를 읽는 즉시 묶음  |
| **ProcStreamResult** | `@foundation/models` | 0 |  |  |
| **RowParamStaleResult** | `@foundation/utils` | 0 |  | findStaleRowParamComboCells 결과 — 지금 비울 셀과, 아직 판정 못 한(재조회 미도착) 하위 binding. |
| **StaleComboCell** | `@foundation/utils` | 0 |  | 상위 콤보를 바꾼 뒤 후보 밖으로 밀려난 하위 셀. 되돌릴 원본을 함께 돌려준다(EditTracker 기록용). |
| **Team** | `@foundation/models` | 0 |  |  |
| **UserSession** | `@foundation/models` | 0 |  |  |

## master-common

| 이름 | import | 사용 | As-is 대응 | 설명 |
|---|---|---|---|---|
| **ComboOption** | `features/master/src/components` | 28 |  | Filter 콤보 옵션 만들기 — AS-IS DataService.GetDMInnerTable 재현. 그 함수는 세션당 한 번 받아 둔 데이터셋(list_line_dm)을 메모리에서 거른다. TO-BE 는 등록 SQL(Filter*)이 같은 결과셋을  |
| **MeasureMeta** | `features/master/src/components` | 18 |  | 공용 Measure 선택 popup (2026-07-30 통합 — 화면별 5벌 중복 제거): // AS-IS DM0002_TitleSetForm_Popup.cs 의 measure 모드 동등 동작. ColumnSettingModal(컬럼 모드) 의 형제 |
| **ItemModalColumn** | `features/master/src/components` | 1 |  |  |
| **ItemModalCondition** | `features/master/src/components` | 1 |  |  |
| **ModelSelection** | `features/master/src/components` | 1 |  | AS-IS 반환값 (SCM0002_ItembyDivisionPopup: ItemID/ItemName/ItemType/NickName/ItemClassName). |
| **CapaAuthContext** | `features/master/src/components` | 0 |  |  |
| **CapaAuthListRow** | `features/master/src/components` | 0 |  |  |
| **CapaFpInstanceRow** | `features/master/src/components` | 0 |  |  |
| **CapaNewModelPopupParams** | `features/master/src/components` | 0 |  |  |
| **CapaNewModelRow** | `features/master/src/components` | 0 |  |  |
| **CapaRowEditability** | `features/master/src/components` | 0 |  |  |
| **CascadeFieldsProps** | `features/master/src/components` | 0 |  |  |
| **CascadeFilter** | `features/master/src/components` | 0 |  | 콤보 행의 컬럼명 -> 그 컬럼에 매칭할 값 목록. 컬럼명을 컴포넌트에 박지 않는 이유: 같은 필드라도 comboId 를 갈아끼우면 콤보 SQL 이 내려주는 cascade 컬럼이 달라진다 (예: 'SalesSite' 는 DEPT_ID/PROJECT_C |
| **CascadeLevelKey** | `features/master/src/components` | 0 |  |  |
| **CascadeLevelSpec** | `features/master/src/components` | 0 |  | levels 항목. 키만 주면 기본값을 쓰고, 객체로 주면 화면별로 덮는다. |
| **CascadeStepFilter** | `features/master/src/components` | 0 |  | cascade 한 단계 선언. 문자열 배열이면 관대 매칭, 객체면 strict 를 직접 고른다. 관대/엄격 판정 근거는 matchesCascade 주석 참조. |
| **ColumnSettingFallback** | `features/master/src/components` | 0 |  | 공용 Column Setting popup (사용자 명시 2026-06-03): // - AS-IS DM0002_TitleSetForm_Popup.cs 동등 동작 (Base/User dual list + 이동 + Sort) // - 화면별 props  |
| **ColumnSettingRow** | `features/master/src/components` | 0 |  |  |
| **ComboAxis** | `features/master/src/components` | 0 |  | 좁힐 축 하나. column 은 콤보가 내려주는 컬럼명, codes 는 화면의 선택값. |
| **ContributeRateModalSelection** | `features/master/src/components` | 0 |  |  |
| **FieldOf** | `features/master/src/components` | 0 |  | value 로 넘긴 스토어 객체의 문자열 키. field 를 이 union 으로 좁혀 두면 오타난 필드명이 컴파일 단계에서 잡힌다. 스토어 조회조건 타입은 대개 interface 라 Record<string, string> 에 대입되지 않는다 (imp |
| **FieldValue** | `features/master/src/components` | 0 |  | 조회조건 스토어 한 필드가 담을 수 있는 값. 배열은 다중선택 조회조건(MktFcst 계열)이다. |
| **ItemModalColumnSpec** | `features/master/src/components` | 0 |  | visibleColumns 항목. - 문자열: admin 컬럼 메타에서 그 colNm 을 찾아 쓴다. 없으면 그 컬럼은 빠진다. - 객체: 메타에 없을 때 쓸 정의(라벨·폭)까지 같이 준다 → 메타에 없어도 컬럼이 그려진다. 응답(o_rc1)에는 있는 |
| **ModelByDivisionPopupParams** | `features/master/src/components` | 0 |  | AS-IS Form_Load 인자 — 호출 화면에서 하드코딩/조회조건으로 넘긴다. |
| **PlantSiteModalColumn** | `features/master/src/components` | 0 |  | 결과 그리드 고정 컬럼(colNm → 라벨·폭). admin 컬럼 메타(SHEET_COLUMNS) 가 없을 때 쓰는 fallback. o_rc1 실측 컬럼(P_SCM0002_GET_ITEM_BY_PLANT_SITE_POPUP) 기준. AS-IS 컬럼  |
| **ProjectByDivisionPopupParams** | `features/master/src/components` | 0 |  |  |
| **ProjectByDivisionSelection** | `features/master/src/components` | 0 |  |  |
| **Row** | `features/master/src/components` | 0 |  | // helpers // |
| **UseCascadeFieldsOptions** | `features/master/src/components` | 0 |  | useCascadeFields / CascadeFields 공통 입력. |
| **VersionModalProps** | `features/master/src/components` | 0 |  |  |

## shared

| 이름 | import | 사용 | As-is 대응 | 설명 |
|---|---|---|---|---|
| **ColumnLayoutRow** | `@shared/components` | 11 |  |  |
| **DualListColumn** | `@shared/components` | 3 |  | 공용 Column Setting dual list (2026-06-20 신설 / 2026-07-01 디자인 개편 + 우측 D&D 순서이동): // AS-IS DM0002_TitleSetForm_Popup.cs 의 Base/User dual list 동 |
| **CascadeNode** | `@shared/components` | 1 |  | 계층 선택지 트리 노드 — value/label 과 선택 시 펼쳐질 하위(children). // children 이 없으면 잎(최종 선택)이다. |
| **ColumnMetaRow** | `@shared/components` | 1 |  | admin 컬럼 메타 1행 중 컬럼 설정 팝업이 쓰는 부분 (`/admin/menu/{mnuId}/column` = GridColumn DTO). |
| **SsoUserRow** | `@shared/components` | 1 |  | COM0010 ssoUser 응답 행 — multiCheckbox 모드의 setSelectedValues 가 그대로 넘긴다. |
| **WeekOfMonth** | `@shared/lib` | 1 |  | 수량/금액 Bucket 배분 공통 유틸 — 화면 recalc(표시) 배분용 순수 함수. // // 룰1 (월 → 주): 월 수량 입력 시 주별 "월내 기여 일수" Rate 산출 후 주별 배분. // 끝자리(rounding 잔여)는 마지막 주차에 +/- |
| **BaseTabState** | `@shared/stores` | 0 |  |  |
| **CascadeDropdownProps** | `@shared/components` | 0 |  |  |
| **CascadeLevel** | `@shared/components` | 0 |  | 단계 정의 — 다른 검색조건처럼 name(값이 담길 키)과 label(화면 표시)을 나눈다. // 예: { name: 'level1', label: '1단계' } → 선택값은 level1 키에 담기고 라벨은 '1단계'. |
| **ColorPickerButtonProps** | `@shared/components` | 0 |  |  |
| **ColumnSettingFallback** | `@shared/components` | 0 |  | BE 결과 없을 때 팝업 목록을 만들 fallback (FE column meta). |
| **CustomListboxProps** | `@shared/components` | 0 |  |  |
| **DayDistribution** | `@shared/lib` | 0 |  |  |
| **DayOfWeekCell** | `@shared/lib` | 0 |  | 주내 하루 (요일 포함) — dow: SUN-first (0=일 … 6=토, JS getUTCDay 규약) |
| **DialogNavigationPosition** | `@shared/components` | 0 |  |  |
| **DialogNavigationProps** | `@shared/components` | 0 |  |  |
| **DialogNavigationSize** | `@shared/components` | 0 |  |  |
| **DialogNavigationType** | `@shared/components` | 0 |  |  |
| **DirtyConfirmKind** | `@shared/stores` | 0 |  |  |
| **DropdownSortKey** | `@shared/components` | 0 |  | [2026-08-25 사용자 확정] 목록 정렬 - 옵트인. 기본은 서버 순서(등록 SQL 의 ORDER BY DISPLAY_SEQ)다. 기본을 정렬로 두지 않는 이유: DISPLAY_SEQ 가 업무 순서를 담은 콤보가 있다 (Measure / Inco |
| **FlexGridRowDnD** | `@shared/components` | 0 |  |  |
| **GridContextMenuContext** | `@shared/components` | 0 |  | 그리드 공통 컨텍스트(우클릭) 메뉴. DataGrid 가 초기화 시 자동 설치한다 — 화면 코드 무수정으로 전 화면 적용. 헤더 우클릭: Pin / Filter / Sort ↑↓ / Autosize This·All 바디 우클릭: Copy / Copy  |
| **GridContextMenuItem** | `@shared/components` | 0 |  |  |
| **GridContextMenuOptions** | `@shared/components` | 0 |  |  |
| **GridLayoutKey** | `@shared/components` | 0 |  | DataGrid 레이아웃 개인화 키 — 이 prop 을 준 그리드만 활성화(opt-in). ⚠️ sheetName 은 admin SHEET_NAME(컬럼 메타 조회 `sheetNm` 과 동일한 값)이어야 한다. FE 내부 시트 코드('main' 등)와 |
| **GridLayoutRow** | `@shared/components` | 0 |  | 그리드 적용용으로 파싱한 레이아웃 1행. |
| **InsertAnchorGrid** | `@shared/hooks` | 0 |  | FlexGrid 최소 구조 — wijmo 타입에 하드 의존하지 않기 위한 structural type (테스트에서 그리드 없이 anchor 동작을 검증할 수 있게 하는 목적도 겸한다). |
| **InsertAnchorGridRef** | `@shared/hooks` | 0 |  | 그리드 인스턴스 참조 — 페이지가 이미 들고 있는 `gridRef` 를 그대로 넘긴다. |
| **ListboxChild** | `@shared/components` | 0 |  |  |
| **ListboxGroupHeader** | `@shared/components` | 0 |  |  |
| **ListboxRow** | `@shared/components` | 0 |  |  |
| **OlapFieldDef** | `@shared/components` | 0 |  | OLAP 필드 정의 — PivotEngine 필드 바인딩 (binding = 데이터 행 키). |
| **OlapPivotGridProps** | `@shared/components` | 0 |  |  |
| **OlapPivotGridRef** | `@shared/components` | 0 |  |  |
| **PersistedStore** | `@shared/stores` | 0 |  |  |
| **ResultAreaDirection** | `@shared/components` | 0 |  | 배치 방향. 'column'/'row' 는 CSS 용어 하위호환('vertical'/'horizontal' 과 동일). |
| **ResultAreaGridRef** | `@shared/components` | 0 |  | ResultArea 내부에서 그리드 ref 를 노출해야 할 때 쓰는 헬퍼 타입(선택). |
| **ResultAreaGroupProps** | `@shared/components` | 0 |  |  |
| **ResultAreaProps** | `@shared/components` | 0 |  |  |
| **Rgb** | `@shared/components` | 0 |  |  |
| **SearchAreaProps** | `@shared/components` | 0 |  |  |
| **TitleSetSaveRow** | `@shared/components` | 0 |  | 컬럼 개인화 1행 — 저장 payload 로 변환되기 전의 화면 단위 표현. |
| **UseInsertedRowsResult** | `@shared/hooks` | 0 |  |  |
| **UseStreamProcQueryOptions** | `@shared/hooks` | 0 |  | [E20261015-STREAMPROC] 대량 조회 스트리밍 훅 — call-proc-stream 결과를 받는 즉시 그리드에 이어 붙인다. 왜: 기존 useTabProcQuery 는 결과 전량(예 SCP0030 28.9만 행·234MB)을 다 받은 뒤 |
| **ViewAction** | `@shared/stores` | 0 |  | viewActionRegistry — 화면(탭)이 노출하는 named action 을 tabId 로 모아 두는 레지스트리. // // SubTitle 이 조립한 buttonActions(툴바 액션 — search/save/insert/delete 등, |
| **WeekDistribution** | `@shared/lib` | 0 |  |  |
