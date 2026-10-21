# SCP0006 — To-Be Fact Pack 요약

- page_key: `supply/project-route` · feature: supply · As-is Fact Pack 없음(화면ID 미대응)
- 파일 18 · 엔드포인트 호출 11 (미해결 0, 주석 속 3) · 이벤트 37 · 컴포넌트 사용 58 · 하드코딩 컬럼 22 · 메시지 44
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 22건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/project-route/components/modals/project-route-list-save-modal.constants.ts | constants | 261 |
| features/supply/src/pages/project-route/components/modals/ProjectRouteListSaveModal.module.scss | component | 23 |
| features/supply/src/pages/project-route/components/modals/ProjectRouteListSaveModal.tsx | component | 357 |
| features/supply/src/pages/project-route/components/ProjectRouteBomGrid.tsx | component | 56 |
| features/supply/src/pages/project-route/components/ProjectRouteForm.tsx | component | 261 |
| features/supply/src/pages/project-route/components/ProjectRouteMainGrid.tsx | component | 70 |
| features/supply/src/pages/project-route/components/ProjectRoutePlantGrid.tsx | component | 239 |
| features/supply/src/pages/project-route/hooks/useProjectRouteValidation.ts | hook | 282 |
| features/supply/src/pages/project-route/index.ts | index | 2 |
| features/supply/src/pages/project-route/project-route.constants.ts | constants | 164 |
| features/supply/src/pages/project-route/project-route.types.ts | types | 33 |
| features/supply/src/pages/project-route/ProjectRoute.module.scss | style | 72 |
| features/supply/src/pages/project-route/ProjectRoute.tsx | page | 505 |
| features/supply/src/pages/project-route/useProjectRouteStore.ts | store | 251 |
| features/supply/src/pages/project-route/utils/projectRoute.calendar.ts | util | 45 |
| features/supply/src/pages/project-route/utils/projectRoute.plantDerive.ts | util | 28 |
| features/supply/src/pages/project-route/utils/projectRoute.plantSaveRequest.ts | util | 87 |
| features/supply/src/pages/project-route/__asis-mapping__.md | mapping | 126 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| /SCM0002_PROJECT_ROUTE_LIST_SAVE/mainList/SEARCH/call-proc | http | 1 | Y | ProjectRouteListSaveModal.tsx:118 |
| (useTabComboQueries) | hook | 4 | Y | ProjectRouteForm.tsx:39 ProjectRouteForm.tsx:46 ProjectRouteForm.tsx:62 ProjectRoute.tsx:96 |
| SCP0006/site//call-proc | hook | 1 | Y | ProjectRoute.tsx:101 |
| SCP0006/bom//call-proc | hook | 1 | Y | ProjectRoute.tsx:108 |
| SCP0006/plant//call-proc | hook | 1 | Y | ProjectRoute.tsx:115 |
| /admin/menu/SCP0006/column | http | 1 | Y | useProjectRouteStore.ts:207 |
| /admin/menu/SCP0006/search-conditions | http | 1 | Y | useProjectRouteStore.ts:225 |
| /SCP0006/plant/SAVE/call-proc | http | 1 | Y | projectRoute.plantSaveRequest.ts:70 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | <arrow> fetchList | jsx | features/supply/src/pages/project-route/components/modals/ProjectRouteListSaveModal.tsx | 280 |
| InputField | onChange | <arrow> setModelId | jsx | features/supply/src/pages/project-route/components/modals/ProjectRouteListSaveModal.tsx | 308 |
| InputField | onKeyDown | <arrow> fetchList | jsx | features/supply/src/pages/project-route/components/modals/ProjectRouteListSaveModal.tsx | 309 |
| InputField | onChange | <arrow> setItemId | jsx | features/supply/src/pages/project-route/components/modals/ProjectRouteListSaveModal.tsx | 322 |
| InputField | onKeyDown | <arrow> fetchList | jsx | features/supply/src/pages/project-route/components/modals/ProjectRouteListSaveModal.tsx | 323 |
| DataGrid | cellEditEnded | handleCellEdit | jsx | features/supply/src/pages/project-route/components/modals/ProjectRouteListSaveModal.tsx | 341 |
| Button | onClick | <arrow> handleSave | jsx | features/supply/src/pages/project-route/components/modals/ProjectRouteListSaveModal.tsx | 349 |
| Button | onClick | onClose | jsx | features/supply/src/pages/project-route/components/modals/ProjectRouteListSaveModal.tsx | 350 |
| DataGrid | gotFocus | gotFocus | jsx | features/supply/src/pages/project-route/components/ProjectRouteBomGrid.tsx | 52 |
| SearchArea | onSearch | noDivisionAuth ? undefined : onSearch | jsx | features/supply/src/pages/project-route/components/ProjectRouteForm.tsx | 107 |
| CustomDropdown | onChange | <arrow> setSearchParams,String | jsx | features/supply/src/pages/project-route/components/ProjectRouteForm.tsx | 121 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/project-route/components/ProjectRouteForm.tsx | 158 |
| FunctionSearchIcon | onClick | <arrow> setOpenProjectModal | jsx | features/supply/src/pages/project-route/components/ProjectRouteForm.tsx | 150 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/project-route/components/ProjectRouteForm.tsx | 189 |
| FunctionSearchIcon | onClick | <arrow> setOpenItemModal | jsx | features/supply/src/pages/project-route/components/ProjectRouteForm.tsx | 183 |
| PeriodField | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/project-route/components/ProjectRouteForm.tsx | 205 |
| CustomDropdown | onChange | <arrow> setSearchParams,String | jsx | features/supply/src/pages/project-route/components/ProjectRouteForm.tsx | 217 |
| DataGrid | gotFocus | gotFocus | jsx | features/supply/src/pages/project-route/components/ProjectRouteMainGrid.tsx | 66 |
| grid | beginningEdit | <arrow> editable.includes | addHandler | features/supply/src/pages/project-route/components/ProjectRoutePlantGrid.tsx | 159 |
| grid.hostElement | keydown | <arrow> /\d/.test,isPriority,ev.preventDefault | addEventListener | features/supply/src/pages/project-route/components/ProjectRoutePlantGrid.tsx | 166 |
| grid | prepareCellForEdit | <arrow> isPriority,editor.value.replace,editor.addEventListener,/\D/.test,ev.preventDefault,keepDigits | addHandler | features/supply/src/pages/project-route/components/ProjectRoutePlantGrid.tsx | 176 |
| editor | beforeinput | <arrow> /\D/.test,ev.preventDefault | addEventListener | features/supply/src/pages/project-route/components/ProjectRoutePlantGrid.tsx | 183 |
| editor | input | <arrow> keepDigits | addEventListener | features/supply/src/pages/project-route/components/ProjectRoutePlantGrid.tsx | 186 |
| editor | compositionend | keepDigits | addEventListener | features/supply/src/pages/project-route/components/ProjectRoutePlantGrid.tsx | 189 |
| DataGrid | initialized | handleInitialized | jsx | features/supply/src/pages/project-route/components/ProjectRoutePlantGrid.tsx | 232 |
| DataGrid | cellEditEnded | handleCellEdit | jsx | features/supply/src/pages/project-route/components/ProjectRoutePlantGrid.tsx | 233 |
| DataGrid | gotFocus | gotFocus | jsx | features/supply/src/pages/project-route/components/ProjectRoutePlantGrid.tsx | 235 |
| ProjectRouteForm | onSearch | handleSearch | jsx | features/supply/src/pages/project-route/ProjectRoute.tsx | 398 |
| ProjectRouteMainGrid | onRowDblClick | applySiteKey | jsx | features/supply/src/pages/project-route/ProjectRoute.tsx | 438 |
| ProjectRouteMainGrid | gotFocus | <arrow> setActiveSheet | jsx | features/supply/src/pages/project-route/ProjectRoute.tsx | 439 |
| ProjectRouteBomGrid | onRowDblClick | applyBomKey | jsx | features/supply/src/pages/project-route/ProjectRoute.tsx | 459 |
| ProjectRouteBomGrid | gotFocus | <arrow> setActiveSheet | jsx | features/supply/src/pages/project-route/ProjectRoute.tsx | 460 |
| ProjectRoutePlantGrid | onRowDblClick | handlePlantDblClick | jsx | features/supply/src/pages/project-route/ProjectRoute.tsx | 482 |
| ProjectRoutePlantGrid | gotFocus | <arrow> setActiveSheet | jsx | features/supply/src/pages/project-route/ProjectRoute.tsx | 483 |
| ProjectRouteListSaveModal | onClose | <arrow> setOpenInputAllModal | jsx | features/supply/src/pages/project-route/ProjectRoute.tsx | 492 |
| ProjectRouteListSaveModal | onSaved | handleSearch | jsx | features/supply/src/pages/project-route/ProjectRoute.tsx | 495 |
| CapaNewModelPopup | onClose | <arrow> setCapaPopupParams | jsx | features/supply/src/pages/project-route/ProjectRoute.tsx | 499 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 7 |
| FormItem | 7 |
| InputField | 4 |
| DataGrid | 4 |
| Button | 4 |
| Panel | 4 |
| CustomDropdown | 3 |
| TitleArea | 3 |
| SearchArea | 2 |
| FunctionSearchIcon | 2 |
| PanelGroup | 2 |
| PanelSeparator | 2 |
| CustomDialog | 1 |
| ProgressIndicator | 1 |
| ResultArea | 1 |
| PeriodField | 1 |
| MaterialByDivisionModal | 1 |
| ProjectByDivisionModal | 1 |
| MainTitle | 1 |
| ProjectRouteForm | 1 |
| SubTitle | 1 |
| ProjectRouteMainGrid | 1 |
| ProjectRouteBomGrid | 1 |
| ProjectRoutePlantGrid | 1 |
| ProjectRouteListSaveModal | 1 |
| CapaNewModelPopup | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| buildProjectRouteListSaveColumns | DIVISION_ID | Div | 60 | true |  |  | meta-map | features/supply/src/pages/project-route/components/modals/project-route-list-save-modal.constants.ts | 70 |
| buildProjectRouteListSaveColumns | SCM_SITE_ID | Sales Site Code | 140 | true |  |  | meta-map | features/supply/src/pages/project-route/components/modals/project-route-list-save-modal.constants.ts | 71 |
| buildProjectRouteListSaveColumns | SCM_SITE_NAME | Sales Site | 160 | true |  |  | meta-map | features/supply/src/pages/project-route/components/modals/project-route-list-save-modal.constants.ts | 78 |
| buildProjectRouteListSaveColumns | PROJECT_CODE | Project | 80 | true |  |  | meta-map | features/supply/src/pages/project-route/components/modals/project-route-list-save-modal.constants.ts | 85 |
| buildProjectRouteListSaveColumns | MODEL_ID | Model | 100 | true |  |  | meta-map | features/supply/src/pages/project-route/components/modals/project-route-list-save-modal.constants.ts | 92 |
| buildProjectRouteListSaveColumns | NICK_NAME | Nick Name | 120 | true |  |  | meta-map | features/supply/src/pages/project-route/components/modals/project-route-list-save-modal.constants.ts | 93 |
| buildProjectRouteListSaveColumns | OPERATION_GROUP_ID | OPERATION_GROUP_ID | 60 | true |  |  | meta-map | features/supply/src/pages/project-route/components/modals/project-route-list-save-modal.constants.ts | 94 |
| buildProjectRouteListSaveColumns | OPERATION_GROUP | Operation Group | 60 | true |  |  | meta-map | features/supply/src/pages/project-route/components/modals/project-route-list-save-modal.constants.ts | 101 |
| buildProjectRouteListSaveColumns | ITEM_ID | Item Code | 100 | true |  |  | meta-map | features/supply/src/pages/project-route/components/modals/project-route-list-save-modal.constants.ts | 108 |
| buildProjectRouteListSaveColumns | ITEM_NAME | Item | 120 | true |  |  | meta-map | features/supply/src/pages/project-route/components/modals/project-route-list-save-modal.constants.ts | 109 |
| buildProjectRouteListSaveColumns | PLANT_SITE_ID | Plant Site* | 220 | true |  |  | meta-map | features/supply/src/pages/project-route/components/modals/project-route-list-save-modal.constants.ts | 110 |
| buildProjectRouteListSaveColumns | VALID_YN | Valid* | 60 | true |  |  | meta-map | features/supply/src/pages/project-route/components/modals/project-route-list-save-modal.constants.ts | 132 |
| buildProjectRouteListSaveColumns | PRIORITY | Priority* | 60 | true |  |  | meta-map | features/supply/src/pages/project-route/components/modals/project-route-list-save-modal.constants.ts | 143 |
| buildProjectRouteListSaveColumns | FROM_YYYYMMDD | From* | 80 | true |  |  | meta-map | features/supply/src/pages/project-route/components/modals/project-route-list-save-modal.constants.ts | 153 |
| buildProjectRouteListSaveColumns | TO_YYYYMMDD | To* | 80 | true |  |  | meta-map | features/supply/src/pages/project-route/components/modals/project-route-list-save-modal.constants.ts | 163 |
| buildProjectRouteListSaveColumns | CREATED_BY | Created By | 80 | true |  |  | meta-map | features/supply/src/pages/project-route/components/modals/project-route-list-save-modal.constants.ts | 173 |
| buildProjectRouteListSaveColumns | CREATION_DATE | Creation Date | 170 | true |  |  | meta-map | features/supply/src/pages/project-route/components/modals/project-route-list-save-modal.constants.ts | 174 |
| buildProjectRouteListSaveColumns | LAST_UPDATED_BY | Last Updated By | 80 | true |  |  | meta-map | features/supply/src/pages/project-route/components/modals/project-route-list-save-modal.constants.ts | 181 |
| buildProjectRouteListSaveColumns | LAST_UPDATE_DATE | Last Update Date | 170 | true |  |  | meta-map | features/supply/src/pages/project-route/components/modals/project-route-list-save-modal.constants.ts | 188 |
| buildProjectRouteListSaveColumns | ORG_FROM_YYYYMMDD | ORG_FROM_YYYYMMDD | 80 | false |  |  | meta-map | features/supply/src/pages/project-route/components/modals/project-route-list-save-modal.constants.ts | 196 |
| buildProjectRouteListSaveColumns | ORG_TO_YYYYMMDD | ORG_TO_YYYYMMDD | 80 | false |  |  | meta-map | features/supply/src/pages/project-route/components/modals/project-route-list-save-modal.constants.ts | 203 |
| buildMonthColumns | `${DYN_MONTH_PREFIX}${ym}` | `${ym.slice(0, 4)}-${ym.slice(4, 6)}` | 75 | true |  |  | object | features/supply/src/pages/project-route/utils/projectRoute.calendar.ts | 35 |

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00664 | 1 |
| MSG01223 | 1 |
| MSG01224 | 1 |
| MSG01225 | 1 |
| MSG01226 | 1 |
| MSG01227 | 1 |
| MSG01228 | 1 |
| MSG01134 | 2 |
| MSG01135 | 2 |
| MSG01080 | 2 |
| MSG00611 | 2 |
| MSG01231 | 1 |
| MSG01091 | 1 |
| MSG01054 | 1 |
| MSG00429 | 1 |
| MSG00001 | 1 |
| LBL00001 | 2 |
| LBL00632 | 1 |
| LBL00112 | 1 |
| LBL00012 | 1 |
| LBL00618 | 1 |
| LBL00014 | 1 |
| MSG00097 | 1 |
| MSG00109 | 1 |
| MSG00002 | 1 |
| MSG00618 | 1 |
| MSG00004 | 1 |
| MSG01140 | 1 |
| MSG01236 | 1 |
| MSG01129 | 1 |
| MSG01130 | 1 |
| MSG01131 | 1 |
| MSG01132 | 1 |
| MSG00700 | 1 |
| MSG01133 | 1 |
| MSG01137 | 1 |
| LBL01082 | 1 |
| MSG00009 | 1 |
| MSG00011 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0006(20), SYS0004(1), SCP0020(1), SCP0049(1)
- SP/PKG: PKG_SCM0002(2), SCP0006_SAVE_PROJECT_ROUTE_PLANT(2), P_SCM0002_GET_PROJECT_ROUTE_LIST_FORSAVE_POPUP(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | 않는다(호출부 `//if (!checkValidN0()) return;`). SCP0006 본 화면의 N0 dead 상태(04_impl-gap-audit | features/supply/src/pages/project-route/components/modals/project-route-list-save-modal.constants.ts | 214 |
| code | import { type MutableRefObject, useEffect, useMemo } from 'react'; | features/supply/src/pages/project-route/components/ProjectRoutePlantGrid.tsx | 3 |
| code | useEffect(() => { | features/supply/src/pages/project-route/components/ProjectRoutePlantGrid.tsx | 75 |
| code | if (!grid) return; | features/supply/src/pages/project-route/components/ProjectRoutePlantGrid.tsx | 77 |
| code | const beginningEditHandler = ( | features/supply/src/pages/project-route/components/ProjectRoutePlantGrid.tsx | 78 |
| jsx | s: FlexGrid<PlantRow>, | features/supply/src/pages/project-route/components/ProjectRoutePlantGrid.tsx | 79 |
| code | ) => { | features/supply/src/pages/project-route/components/ProjectRoutePlantGrid.tsx | 81 |
| code | if (!editable.includes(binding)) e.cancel = true; | features/supply/src/pages/project-route/components/ProjectRoutePlantGrid.tsx | 88 |
| code | }; | features/supply/src/pages/project-route/components/ProjectRoutePlantGrid.tsx | 89 |
| code | grid.beginningEdit.addHandler(beginningEditHandler); | features/supply/src/pages/project-route/components/ProjectRoutePlantGrid.tsx | 90 |
| code | return () => { | features/supply/src/pages/project-route/components/ProjectRoutePlantGrid.tsx | 91 |
| code | grid.beginningEdit.removeHandler(beginningEditHandler); | features/supply/src/pages/project-route/components/ProjectRoutePlantGrid.tsx | 93 |
| code | }; | features/supply/src/pages/project-route/components/ProjectRoutePlantGrid.tsx | 97 |
| code | }, [gridRef, readOnly]); | features/supply/src/pages/project-route/components/ProjectRoutePlantGrid.tsx | 98 |
| code | useEffect(() => { | features/supply/src/pages/project-route/components/ProjectRoutePlantGrid.tsx | 102 |
| code | if (!grid) return; | features/supply/src/pages/project-route/components/ProjectRoutePlantGrid.tsx | 104 |
| code | const isPriority = (col: number) => grid.columns[col]?.binding === 'PRIORITY'; | features/supply/src/pages/project-route/components/ProjectRoutePlantGrid.tsx | 105 |
| code | // const truncText = (v: string) => { | features/supply/src/pages/project-route/components/ProjectRoutePlantGrid.tsx | 106 |
| code | // const n = Number(v.replace(/,/g, '')); | features/supply/src/pages/project-route/components/ProjectRoutePlantGrid.tsx | 107 |
| code | // return Number.isFinite(n) ? String(Math.trunc(n)) : v; | features/supply/src/pages/project-route/components/ProjectRoutePlantGrid.tsx | 108 |
| code | // }; | features/supply/src/pages/project-route/components/ProjectRoutePlantGrid.tsx | 109 |
| code | const truncText = (v: string) => v.split('.')[0].replace(/\D/g, ''); | features/supply/src/pages/project-route/components/ProjectRoutePlantGrid.tsx | 111 |
| code | // const blockDotKey = (ev: KeyboardEvent) => { | features/supply/src/pages/project-route/components/ProjectRoutePlantGrid.tsx | 112 |
| code | // if (ev.key !== '.' && ev.key !== 'Decimal') return; | features/supply/src/pages/project-route/components/ProjectRoutePlantGrid.tsx | 113 |
| code | // if (!isPriority(grid.selection.col)) return; | features/supply/src/pages/project-route/components/ProjectRoutePlantGrid.tsx | 114 |
| code | // ev.preventDefault(); | features/supply/src/pages/project-route/components/ProjectRoutePlantGrid.tsx | 115 |
| code | // }; | features/supply/src/pages/project-route/components/ProjectRoutePlantGrid.tsx | 116 |
| code | const blockNonDigitKey = (ev: KeyboardEvent) => { | features/supply/src/pages/project-route/components/ProjectRoutePlantGrid.tsx | 118 |
| code | if (ev.key.length !== 1 \|\| ev.ctrlKey \|\| ev.metaKey \|\| ev.altKey) return; | features/supply/src/pages/project-route/components/ProjectRoutePlantGrid.tsx | 119 |
| code | if (/\d/.test(ev.key) \|\| !isPriority(grid.selection.col)) return; | features/supply/src/pages/project-route/components/ProjectRoutePlantGrid.tsx | 120 |
| code | ev.preventDefault(); | features/supply/src/pages/project-route/components/ProjectRoutePlantGrid.tsx | 121 |
| code | }; | features/supply/src/pages/project-route/components/ProjectRoutePlantGrid.tsx | 122 |
| jsx | const truncOnCommit = (s: FlexGrid<PlantRow>, e: CellRangeEventArgs) => { | features/supply/src/pages/project-route/components/ProjectRoutePlantGrid.tsx | 123 |
| code | if (!isPriority(e.col)) return; | features/supply/src/pages/project-route/components/ProjectRoutePlantGrid.tsx | 124 |
| code | // if (!ed \|\| !ed.value.includes('.')) return; | features/supply/src/pages/project-route/components/ProjectRoutePlantGrid.tsx | 126 |
| code | if (!ed \|\| /^\d*$/.test(ed.value)) return; | features/supply/src/pages/project-route/components/ProjectRoutePlantGrid.tsx | 127 |
| code | ed.value = truncText(ed.value); | features/supply/src/pages/project-route/components/ProjectRoutePlantGrid.tsx | 128 |
| code | }; | features/supply/src/pages/project-route/components/ProjectRoutePlantGrid.tsx | 129 |
| jsx | const truncOnPaste = (_s: FlexGrid<PlantRow>, e: CellRangeEventArgs) => { | features/supply/src/pages/project-route/components/ProjectRoutePlantGrid.tsx | 130 |
| code | // if (!isPriority(e.col) \|\| typeof e.data !== 'string' \|\| !e.data.includes('.')) return; | features/supply/src/pages/project-route/components/ProjectRoutePlantGrid.tsx | 131 |
| code | if (!isPriority(e.col) \|\| typeof e.data !== 'string' \|\| /^\d*$/.test(e.data)) return; | features/supply/src/pages/project-route/components/ProjectRoutePlantGrid.tsx | 132 |
| code | e.data = truncText(e.data); | features/supply/src/pages/project-route/components/ProjectRoutePlantGrid.tsx | 133 |
| code | }; | features/supply/src/pages/project-route/components/ProjectRoutePlantGrid.tsx | 134 |
| code | // grid.hostElement.addEventListener('keydown', blockDotKey, true); | features/supply/src/pages/project-route/components/ProjectRoutePlantGrid.tsx | 135 |
| code | grid.hostElement.addEventListener('keydown', blockNonDigitKey, true); | features/supply/src/pages/project-route/components/ProjectRoutePlantGrid.tsx | 136 |
| code | grid.cellEditEnding.addHandler(truncOnCommit); | features/supply/src/pages/project-route/components/ProjectRoutePlantGrid.tsx | 137 |
| code | grid.pastingCell.addHandler(truncOnPaste); | features/supply/src/pages/project-route/components/ProjectRoutePlantGrid.tsx | 138 |
| code | return () => { | features/supply/src/pages/project-route/components/ProjectRoutePlantGrid.tsx | 139 |
| code | // grid.hostElement?.removeEventListener('keydown', blockDotKey, true); | features/supply/src/pages/project-route/components/ProjectRoutePlantGrid.tsx | 141 |
| code | grid.hostElement?.removeEventListener('keydown', blockNonDigitKey, true); | features/supply/src/pages/project-route/components/ProjectRoutePlantGrid.tsx | 142 |
| code | grid.cellEditEnding.removeHandler(truncOnCommit); | features/supply/src/pages/project-route/components/ProjectRoutePlantGrid.tsx | 143 |
| code | grid.pastingCell.removeHandler(truncOnPaste); | features/supply/src/pages/project-route/components/ProjectRoutePlantGrid.tsx | 144 |
| code | }; | features/supply/src/pages/project-route/components/ProjectRoutePlantGrid.tsx | 148 |
| code | }, [gridRef]); | features/supply/src/pages/project-route/components/ProjectRoutePlantGrid.tsx | 149 |
| endpoint | 컬럼 메타 fetch(/admin/menu/SCP0006/column)의 sheetNm 은 SCM_MST_SHEET_COLUMNS.SHEET_NAME 과 정확히 일치해야 한다(BE 문자열 매칭). AS-IS SpreadInfo 시트명(Main/BOM Explosion/Plant Assign)이 DB SHEET_NAME 으로 배포된 것으로 본다(design/03 §0). 라이브 확인필요(design/03 §6-2). | features/supply/src/pages/project-route/project-route.constants.ts | 30 |
| endpoint | ---- mount 1회 컬럼 메타 fetch(admin 즉시반영 baseline) ---- | features/supply/src/pages/project-route/ProjectRoute.tsx | 204 |
| endpoint | 컬럼 메타는 admin(SCM_MST_SHEET_COLUMNS)에서 동적 fetch(ui-category hook, 하드코딩 금지). | features/supply/src/pages/project-route/useProjectRouteStore.ts | 203 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

