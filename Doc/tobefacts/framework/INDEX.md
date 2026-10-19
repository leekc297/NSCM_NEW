# To-Be 프레임워크·공통 카탈로그 (TobeFacts framework.js 2026-10-19)

원천: packages/foundation/src · packages/shared/src · features/master/src/components · apps/web/src/mdi — export 509건. 사용 수 = features/*/src/pages 의 import 등장 횟수. As-is 대응 = tools/Harness/rules 사전.

| 파일 | 종류 | 건수 | 많이 쓰는 것 |
|---|---|---|---|
| [components.md](components.md) | component | 69 | AtlasBridge, MDIContainer, MDITabs, RouterSync, ViewContainer, PeriodField, ItemByDivisionModal, MaterialByDivisionModal |
| [hooks.md](hooks.md) | hook | 26 | useTabActivation, useViewReload, useIsBusy, useCascadeFields, useTabComboQueries, useTabProcQuery, useTabBtnPermissions, useTabid |
| [stores.md](stores.md) | store | 27 | useMDIStore, useContributeVersionModalStore, useCustomerModalStore, useContributeRateModalStore, useItemByDivisionModalStore, useItemByPlantSiteModalStore, useMaterialByDivisionModalStore, useModelByDivisionPopupStore |
| [apis.md](apis.md) | namespace-object, class | 9 | EditTracker, CustomMergeManager, ColumnInsertMergeManager, GridUtils, GridAction, DynamicColumnManager, idbPersister, REQUEST_CHK_COLUMN |
| [utils.md](utils.md) | function, constant, value, enum | 270 | MAX_MOUNTED_TABS, MDI_TAB_MODE, resetView, resolveView, CRUD_TYPE, CRUD_MSG, API_CONFIG, CACHE_MAX_AGE |
| [types.md](types.md) | type | 108 | AnyPage, AnyTab, MdiTabMode, RawFlexGridColumnConfig, PageProps, HotkeyConfig, ComboResponse, FlexGridColumnConfig |

## 화면 개발 표준 (카탈로그 적용 규칙)

- 조회조건: `features/master/src/components/searchFields` 의 *Field 카탈로그(13종) 우선 → 없으면 `FormItem + CustomDropdown/InputField/DatePickerCalendar`(룰 25 §1.5.4). 직접 `<label>/<input>` 금지.
- 공통 모달: `features/master/src/components` 의 *Modal/*Popup(Item/Project/Owner/Customer/Team/Region/StorageLocation/Material…) 재사용 — 화면 종속 팝업만 `components/modals/`.
- 조회/저장: `useTabProcQuery<MENU_ID>` / `useProcMutation<MENU_ID>` / `useTabComboQueries` — `apiClient` 직접 호출 금지.
- 그리드: `DataGrid`(@shared/components) + `GridAction`(@foundation/utils) addRow/removeRow, 컬럼은 메타(/admin/menu/{MENU}/column) + `staticColumns`.
- 알림: `useMessageStore`(@shared/stores) setAlert/confirm — `window.alert` 금지. 세션: `useSessionStore`.
- 타이틀/버튼: `MainTitle` + `SubTitle hotkeyConfig`(search/save/insert/delete/upload/manual 명시, condition/resetCondition 는 UsrConditionPanel 유무).
