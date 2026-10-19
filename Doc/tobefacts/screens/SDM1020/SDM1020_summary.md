# SDM1020 — To-Be Fact Pack 요약

- page_key: `spms-demand/project-list` · feature: spms-demand · As-is Fact Pack 없음(화면ID 미대응)
- 파일 16 · 엔드포인트 호출 12 (미해결 1, 주석 속 2) · 이벤트 23 · 컴포넌트 사용 26 · 하드코딩 컬럼 0 · 메시지 29
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/spms-demand/src/pages/project-list/components/ProjectListForm.module.scss | component | 47 |
| features/spms-demand/src/pages/project-list/components/ProjectListForm.tsx | component | 197 |
| features/spms-demand/src/pages/project-list/components/ProjectListGrid.module.scss | component | 40 |
| features/spms-demand/src/pages/project-list/components/ProjectListGrid.tsx | component | 432 |
| features/spms-demand/src/pages/project-list/index.ts | index | 2 |
| features/spms-demand/src/pages/project-list/project-list.constants.ts | constants | 124 |
| features/spms-demand/src/pages/project-list/project-list.types.ts | types | 28 |
| features/spms-demand/src/pages/project-list/ProjectList.tsx | page | 378 |
| features/spms-demand/src/pages/project-list/useProjectListStore.ts | store | 195 |
| features/spms-demand/src/pages/project-list/utils/project-list.api.test.ts | test | 126 |
| features/spms-demand/src/pages/project-list/utils/project-list.api.ts | api | 64 |
| features/spms-demand/src/pages/project-list/utils/project-list.editLock.test.ts | test | 112 |
| features/spms-demand/src/pages/project-list/utils/project-list.editLock.ts | util | 41 |
| features/spms-demand/src/pages/project-list/utils/project-list.validate.test.ts | test | 185 |
| features/spms-demand/src/pages/project-list/utils/project-list.validate.ts | util | 84 |
| features/spms-demand/src/pages/project-list/utils/project-list.value.ts | util | 3 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 3 | Y | ProjectListForm.tsx:42 ProjectListForm.tsx:47 ProjectList.tsx:146 |
| (useTabLookupQueries) | hook | 1 | Y | ProjectListForm.tsx:50 |
| SDM1020/Project List//call-proc | hook | 1 | Y | ProjectList.tsx:78 |
| /admin/menu/SDM1020/column | http | 1 | Y | useProjectListStore.ts:122 |
| /admin/menu/SDM1020/search-conditions | http | 1 | Y | useProjectListStore.ts:145 |
| /SDM1020/{sheet}/{btnCd}/call-proc | http | 1 | N | project-list.api.ts:20 |
| SDM1020/Project List/REQ/call-proc | callProc | 1 | Y | project-list.api.ts:50 |
| SDM1020/Project List/AUTHREQ/call-proc | callProc | 1 | Y | project-list.api.ts:63 |
| /SDM1020/Project List/REQ/call-proc | propagated | 1 | Y | project-list.api.ts:50 |
| /SDM1020/Project List/AUTHREQ/call-proc | propagated | 1 | Y | project-list.api.ts:63 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| Project List | divisionId endCustomer dpjtAuthType dpjtRegStatus regCompDateFr regCompDateTo | data | PKG_SDM1020 P_SDM1020_GET_PJT_LIST PR_GET_DAY_RANGE P_FR_BUCKET P_SDM1020_BTN_REQ_PJT_REG P_SDM1020_REQ_PJT_AUTH |
| period | createdBy month | o_rc1 o_rc2 | PKG_SDM1020 P_SDM1020_GET_PJT_LIST PR_GET_DAY_RANGE P_FR_BUCKET P_SDM1020_BTN_REQ_PJT_REG P_SDM1020_REQ_PJT_AUTH |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | onSearch | jsx | features/spms-demand/src/pages/project-list/components/ProjectListForm.tsx | 65 |
| CustomDropdown | onChange | <arrow> set,String,onDivisionChange | jsx | features/spms-demand/src/pages/project-list/components/ProjectListForm.tsx | 79 |
| CustomDropdown | onChange | <arrow> set,String | jsx | features/spms-demand/src/pages/project-list/components/ProjectListForm.tsx | 101 |
| CustomDropdown | onChange | <arrow> set,String | jsx | features/spms-demand/src/pages/project-list/components/ProjectListForm.tsx | 121 |
| CustomDropdown | onChange | <arrow> set,String | jsx | features/spms-demand/src/pages/project-list/components/ProjectListForm.tsx | 141 |
| DatePickerCalendar | onChange | <arrow> set,date?.format | jsx | features/spms-demand/src/pages/project-list/components/ProjectListForm.tsx | 165 |
| DatePickerCalendar | onChange | <arrow> set,date?.format | jsx | features/spms-demand/src/pages/project-list/components/ProjectListForm.tsx | 181 |
| grid | formatItem | formatRowHeader | addHandler | features/spms-demand/src/pages/project-list/components/ProjectListGrid.tsx | 162 |
| g | formatItem | formatHandler | addHandler | features/spms-demand/src/pages/project-list/components/ProjectListGrid.tsx | 273 |
| g | beginningEdit | beginningEditHandler | addHandler | features/spms-demand/src/pages/project-list/components/ProjectListGrid.tsx | 297 |
| g | pastingCell | beginningEditHandler | addHandler | features/spms-demand/src/pages/project-list/components/ProjectListGrid.tsx | 298 |
| g.hostElement | click | clickHandler | addEventListener | features/spms-demand/src/pages/project-list/components/ProjectListGrid.tsx | 346 |
| g | formatItem | cornerHandler | addHandler | features/spms-demand/src/pages/project-list/components/ProjectListGrid.tsx | 353 |
| g | updatedLayout | applyHeaderHeight | addHandler | features/spms-demand/src/pages/project-list/components/ProjectListGrid.tsx | 400 |
| DataGrid | initialized | handleGridInitialized | jsx | features/spms-demand/src/pages/project-list/components/ProjectListGrid.tsx | 426 |
| DataGrid | loadedRows | handleLoadedRows | jsx | features/spms-demand/src/pages/project-list/components/ProjectListGrid.tsx | 427 |
| ProjectListForm | onSearch | <arrow> handleSearch | jsx | features/spms-demand/src/pages/project-list/ProjectList.tsx | 292 |
| ProjectListForm | onDivisionChange | handleDivisionChange | jsx | features/spms-demand/src/pages/project-list/ProjectList.tsx | 293 |
| ProjectListGrid | onAuthMgmtClick | handleAuthMgmt | jsx | features/spms-demand/src/pages/project-list/ProjectList.tsx | 317 |
| ProjectListGrid | onAuthReqClick | handleAuthReq | jsx | features/spms-demand/src/pages/project-list/ProjectList.tsx | 318 |
| ColumnLayoutModal | onSave | <arrow> settings.filter,saveTitleSet({menuId:MENU_ID,sheetName:SHEETS.MAIN,columnType:'C',rows:visible.map((setting,index)=>({name:setting.COLUMN_NAME,sortOrderNo:index+1,colWidth:setting.COL_WIDTH,cellColor:setting.CELL_COLOR,textColor:setting.TEXT_COLOR,})),}).then,saveTitleSet,visible.map,setAlert,t | jsx | features/spms-demand/src/pages/project-list/ProjectList.tsx | 338 |
| AuthManagementPopup | onClose | closeAuthRegModal | jsx | features/spms-demand/src/pages/project-list/ProjectList.tsx | 372 |
| AuthManagementPopup | onSaved | refreshMain | jsx | features/spms-demand/src/pages/project-list/ProjectList.tsx | 373 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 5 |
| FormItem | 5 |
| CustomDropdown | 4 |
| DatePickerCalendar | 2 |
| SearchArea | 1 |
| TagLayer | 1 |
| DataGrid | 1 |
| IcGridColumnSetup | 1 |
| MainTitle | 1 |
| ProjectListForm | 1 |
| SubTitle | 1 |
| ProjectListGrid | 1 |
| ColumnLayoutModal | 1 |
| AuthManagementPopup | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00112 | 1 |
| LBL00001 | 1 |
| LBL01003 | 1 |
| LBL00879 | 1 |
| LBL00878 | 1 |
| LBL00857 | 1 |
| LBL00674 | 1 |
| LBL00875 | 1 |
| LBL01002 | 1 |
| MSG00097 | 1 |
| MSG00108 | 1 |
| MSG00004 | 1 |
| MSG01019 | 1 |
| MSG00709 | 1 |
| MSG00712 | 1 |
| MSG00711 | 1 |
| MSG00703 | 1 |
| MSG01002 | 1 |
| MSG01003 | 1 |
| MSG01004 | 1 |
| MSG01005 | 1 |
| MSG01006 | 1 |
| LBL00605 | 3 |
| LBL01008 | 1 |
| LBL00764 | 1 |
| LBL00765 | 1 |
| MSG00618 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SDM1010(18), SDM1020(12), DMF0044(1)
- SP/PKG: PKG_SDM1020(2), P_ACTIVE_FLAG(2), P_SDM1020_GET_PJT_LIST(1), SCM0001_GET_LOOKUP_VALUES(1), PR_GET_DAY_RANGE(1), P_SDM1020_BTN_REQ_PJT_REG(1), P_SDM1020_REQ_PJT_AUTH(1), P_SOP_DATE(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| endpoint | mount 시 persist filters 무효화 + admin 메타 fetch (master hook §2.3) | features/spms-demand/src/pages/project-list/ProjectList.tsx | 96 |
| jsx | setSearchParams: (p: Partial<SearchParamProps>) => void; | features/spms-demand/src/pages/project-list/useProjectListStore.ts | 40 |
| endpoint | ⭐ master hook §2.3 — Column 동적 fetch (SHEET_COLUMNS — 시트별. hook #113 서버 직접 비교. | features/spms-demand/src/pages/project-list/useProjectListStore.ts | 114 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

