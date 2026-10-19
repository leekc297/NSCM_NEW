# SCP0049 — To-Be Fact Pack 요약

- page_key: `supply/capa` · feature: supply · As-is Fact Pack 있음
- 파일 19 · 엔드포인트 호출 13 (미해결 1, 주석 속 0) · 이벤트 36 · 컴포넌트 사용 77 · 하드코딩 컬럼 13 · 메시지 63
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 13건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/capa/capa.constants.ts | constants | 182 |
| features/supply/src/pages/capa/Capa.module.scss | style | 25 |
| features/supply/src/pages/capa/Capa.tsx | page | 479 |
| features/supply/src/pages/capa/capa.types.ts | types | 72 |
| features/supply/src/pages/capa/components/CapaForm.tsx | component | 329 |
| features/supply/src/pages/capa/components/CapaGrid.tsx | component | 364 |
| features/supply/src/pages/capa/components/modals/CapaExcelUploadModal.module.scss | component | 41 |
| features/supply/src/pages/capa/components/modals/CapaExcelUploadModal.tsx | component | 192 |
| features/supply/src/pages/capa/components/modals/NewVersionConfirmModal.tsx | component | 180 |
| features/supply/src/pages/capa/components/modals/VersionInfoModal.tsx | component | 204 |
| features/supply/src/pages/capa/index.ts | index | 2 |
| features/supply/src/pages/capa/useCapaStore.ts | store | 258 |
| features/supply/src/pages/capa/utils/capa.combos.ts | util | 48 |
| features/supply/src/pages/capa/utils/capa.derive.ts | util | 137 |
| features/supply/src/pages/capa/utils/capa.editLock.test.ts | test | 92 |
| features/supply/src/pages/capa/utils/capa.editLock.ts | util | 90 |
| features/supply/src/pages/capa/utils/capa.excelForm.ts | util | 103 |
| features/supply/src/pages/capa/utils/capa.save.ts | util | 183 |
| features/supply/src/pages/capa/__asis-mapping__.md | mapping | 159 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| {?{comboId:COMBO.VERSION,divisionId:`'${divId}'`}} | http | 1 | N | Capa.tsx:88 |
| (useTabComboQueries) | hook | 3 | Y | Capa.tsx:101 CapaForm.tsx:45 NewVersionConfirmModal.tsx:45 |
| /SCP0049/dayRange/SEARCH/call-proc | http | 1 | Y | Capa.tsx:123 |
| SCP0049/capa//call-proc | hook | 1 | Y | Capa.tsx:154 |
| SCP0049/calendar//call-proc | hook | 1 | Y | Capa.tsx:161 |
| /SCP0049/capa/SAVE/call-proc | http | 1 | Y | Capa.tsx:267 |
| /SCP0049/CAPA/UPLOAD/excel-upload | http | 1 | Y | CapaExcelUploadModal.tsx:68 |
| /SCP0049/newVersion/SAVE/call-proc | http | 1 | Y | NewVersionConfirmModal.tsx:85 |
| SCP0049/newVersion//call-proc | hook | 1 | Y | VersionInfoModal.tsx:98 |
| /admin/menu/SCP0049/search-conditions | http | 1 | Y | useCapaStore.ts:114 |
| /admin/menu/SCP0049/column | http | 1 | Y | useCapaStore.ts:225 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| capa | todayYyyymmdd fromYyyymm toYyyymm divisionId group plantId factoryId versionId lineId operationId modelId itemId nickName bucket checkLoss checkLine checkTact checkYield checkEmpty userAuth searchType debugMode | o_rc o_rc2 o_rc3 | PKG_SCP0049 P_GET_CAPA P_SAVE_CAPA P_GET_SHEET_USER_TITLE P_GET_SHEET_CALENDAR P_GET_DAY_RANGE P_GET_NEW_VERSION_INFO P_SAVE_NEW_VERSION |
| userTitle | programId sheetName userId | o_rc | PKG_SCP0049 P_GET_CAPA P_SAVE_CAPA P_GET_SHEET_USER_TITLE P_GET_SHEET_CALENDAR P_GET_DAY_RANGE P_GET_NEW_VERSION_INFO P_SAVE_NEW_VERSION |
| calendar | todayYyyymmdd fromYyyymm toYyyymm bucket | o_rc | PKG_SCP0049 P_GET_CAPA P_SAVE_CAPA P_GET_SHEET_USER_TITLE P_GET_SHEET_CALENDAR P_GET_DAY_RANGE P_GET_NEW_VERSION_INFO P_SAVE_NEW_VERSION |
| dayRange | createdBy month | o_rc | PKG_SCP0049 P_GET_CAPA P_SAVE_CAPA P_GET_SHEET_USER_TITLE P_GET_SHEET_CALENDAR P_GET_DAY_RANGE P_GET_NEW_VERSION_INFO P_SAVE_NEW_VERSION |
| newVersion | fromDate toDate versionName chkBp chkRp chkScp | o_rc | P_GET_NEW_VERSION_INFO P_SAVE_NEW_VERSION PKG_SCP0049 P_GET_CAPA P_SAVE_CAPA P_GET_SHEET_USER_TITLE P_GET_SHEET_CALENDAR P_GET_DAY_RANGE |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| CapaForm | onSearch | <arrow> handleSearch | jsx | features/supply/src/pages/capa/Capa.tsx | 384 |
| VersionInfoModal | onClose | <arrow> setVersionInfoOpen | jsx | features/supply/src/pages/capa/Capa.tsx | 430 |
| ColumnLayoutModal | onSave | <arrow> settings.filter,saveTitleSet({menuId:MENU_ID,sheetName:ADMIN_SHEET_NAME,columnType:TITLESET_COLUMN_TYPE,rows:visible.map((s,index)=>({name:s.COLUMN_NAME,sortOrderNo:index+1,colWidth:s.COL_WIDTH,cellColor:s.CELL_COLOR,textColor:s.TEXT_COLOR,})),}).then,saveTitleSet,visible.map,setAlert,t | jsx | features/supply/src/pages/capa/Capa.tsx | 448 |
| CustomDropdown | onChange | <arrow> onPick,String(picked??'').split(',').filter,String(picked??'').split,String,v.toUpperCase | jsx | features/supply/src/pages/capa/components/CapaForm.tsx | 105 |
| InputField | onChange | <arrow> onChange | jsx | features/supply/src/pages/capa/components/CapaForm.tsx | 145 |
| InputField | onKeyDown | <arrow> onSearch | jsx | features/supply/src/pages/capa/components/CapaForm.tsx | 146 |
| Button | onClick | onOpenPopup | jsx | features/supply/src/pages/capa/components/CapaForm.tsx | 141 |
| SearchArea | onSearch | onSearch | jsx | features/supply/src/pages/capa/components/CapaForm.tsx | 160 |
| CustomDropdown | onChange | <arrow> String,confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,changeDivision | jsx | features/supply/src/pages/capa/components/CapaForm.tsx | 176 |
| CustomDropdown | onChange | <arrow> changeVersion,String | jsx | features/supply/src/pages/capa/components/CapaForm.tsx | 195 |
| CustomDropdown | onChange | <arrow> setSearchParams,String | jsx | features/supply/src/pages/capa/components/CapaForm.tsx | 210 |
| PeriodField | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/capa/components/CapaForm.tsx | 259 |
| CustomDropdown | onChange | <arrow> String(picked??'').split,String,setSearchParams,codes.includes | jsx | features/supply/src/pages/capa/components/CapaForm.tsx | 275 |
| Checkbox | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/capa/components/CapaForm.tsx | 289 |
| Checkbox | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/capa/components/CapaForm.tsx | 294 |
| g | beginningEdit | beginningEdit | addHandler | features/supply/src/pages/capa/components/CapaGrid.tsx | 320 |
| g | pastingCell | pastingCell | addHandler | features/supply/src/pages/capa/components/CapaGrid.tsx | 321 |
| g | cellEditEnded | cellEditEnded | addHandler | features/supply/src/pages/capa/components/CapaGrid.tsx | 322 |
| g | formatItem | formatItem | addHandler | features/supply/src/pages/capa/components/CapaGrid.tsx | 323 |
| g.hostElement | dblclick | dblclick | addEventListener | features/supply/src/pages/capa/components/CapaGrid.tsx | 324 |
| g.hostElement | click | click | addEventListener | features/supply/src/pages/capa/components/CapaGrid.tsx | 325 |
| FileUploader | onFileChange | <arrow> setAlert,t,setFiles,value.slice,resetResult | jsx | features/supply/src/pages/capa/components/modals/CapaExcelUploadModal.tsx | 133 |
| Button | onClick | <arrow> handleUpload | jsx | features/supply/src/pages/capa/components/modals/CapaExcelUploadModal.tsx | 157 |
| Button | onClick | handleClose | jsx | features/supply/src/pages/capa/components/modals/CapaExcelUploadModal.tsx | 161 |
| Checkbox | onChange | <arrow> setChkBp | jsx | features/supply/src/pages/capa/components/modals/NewVersionConfirmModal.tsx | 133 |
| Checkbox | onChange | <arrow> setChkRp | jsx | features/supply/src/pages/capa/components/modals/NewVersionConfirmModal.tsx | 138 |
| Checkbox | onChange | <arrow> setChkScp | jsx | features/supply/src/pages/capa/components/modals/NewVersionConfirmModal.tsx | 143 |
| CustomDropdown | onChange | <arrow> setVersionDivision,String | jsx | features/supply/src/pages/capa/components/modals/NewVersionConfirmModal.tsx | 156 |
| InputField | onChange | <arrow> setVersionName | jsx | features/supply/src/pages/capa/components/modals/NewVersionConfirmModal.tsx | 170 |
| SearchArea | onSearch | handleSearch | jsx | features/supply/src/pages/capa/components/modals/VersionInfoModal.tsx | 138 |
| PeriodField | onChange | <arrow> setFromDate,setToDate | jsx | features/supply/src/pages/capa/components/modals/VersionInfoModal.tsx | 145 |
| InputField | onChange | <arrow> setVersionName | jsx | features/supply/src/pages/capa/components/modals/VersionInfoModal.tsx | 159 |
| InputField | onKeyDown | <arrow> handleSearch | jsx | features/supply/src/pages/capa/components/modals/VersionInfoModal.tsx | 160 |
| Checkbox | onChange | <arrow> setChkBp | jsx | features/supply/src/pages/capa/components/modals/VersionInfoModal.tsx | 173 |
| Checkbox | onChange | <arrow> setChkRp | jsx | features/supply/src/pages/capa/components/modals/VersionInfoModal.tsx | 178 |
| Checkbox | onChange | <arrow> setChkScp | jsx | features/supply/src/pages/capa/components/modals/VersionInfoModal.tsx | 183 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 13 |
| FormItem | 13 |
| Checkbox | 8 |
| CustomDropdown | 6 |
| InputField | 3 |
| Button | 3 |
| Stack | 3 |
| CustomDialog | 3 |
| TextField | 3 |
| ProgressIndicator | 2 |
| SearchArea | 2 |
| PeriodField | 2 |
| MaterialByDivisionModal | 2 |
| DataGrid | 2 |
| IcGridColumnSetup | 1 |
| MainTitle | 1 |
| CapaForm | 1 |
| SubTitle | 1 |
| CapaGrid | 1 |
| VersionInfoModal | 1 |
| ColumnLayoutModal | 1 |
| FunctionSearchIcon | 1 |
| FileUploader | 1 |
| ControlConfirmIcon | 1 |
| Label | 1 |
| ResultArea | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| periodColumns | DIVISION_ID:DIVISION_ID,END_CUSTOMER:END_CUSTOMER | c.COLUMN_LABEL_NAME | 70 | isDay ? drilledMonthsRef.current.has(month) : true |  |  | object | features/supply/src/pages/capa/components/CapaGrid.tsx | 137 |
| dynamicColumns | REQUEST_CHK | Mail REQ | 60 |  |  | DataType.Boolean | object | features/supply/src/pages/capa/components/CapaGrid.tsx | 152 |
| INFO_COLUMN_DEFS | VERSION_ID | Version Id | 90 |  |  |  | meta-shape | features/supply/src/pages/capa/components/modals/VersionInfoModal.tsx | 28 |
| INFO_COLUMN_DEFS | DIVISION_ID | Div | 60 |  |  |  | meta-shape | features/supply/src/pages/capa/components/modals/VersionInfoModal.tsx | 29 |
| INFO_COLUMN_DEFS | VERSION_WEEK | Week | 60 |  |  |  | meta-shape | features/supply/src/pages/capa/components/modals/VersionInfoModal.tsx | 30 |
| INFO_COLUMN_DEFS | VERSION_DATE | Date | 90 |  |  |  | meta-shape | features/supply/src/pages/capa/components/modals/VersionInfoModal.tsx | 31 |
| INFO_COLUMN_DEFS | VERSION_TIME | Time | 70 |  |  |  | meta-shape | features/supply/src/pages/capa/components/modals/VersionInfoModal.tsx | 32 |
| INFO_COLUMN_DEFS | VERSION_NAME | Version Name | 150 |  |  |  | meta-shape | features/supply/src/pages/capa/components/modals/VersionInfoModal.tsx | 33 |
| INFO_COLUMN_DEFS | BP_USE_FLAG | BP | 40 |  |  |  | meta-shape | features/supply/src/pages/capa/components/modals/VersionInfoModal.tsx | 34 |
| INFO_COLUMN_DEFS | RP_USE_FLAG | RP | 40 |  |  |  | meta-shape | features/supply/src/pages/capa/components/modals/VersionInfoModal.tsx | 42 |
| INFO_COLUMN_DEFS | SCP_USE_FLAG | SCP | 40 |  |  |  | meta-shape | features/supply/src/pages/capa/components/modals/VersionInfoModal.tsx | 50 |
| INFO_COLUMN_DEFS | CONFIRMED_BY | Confirmed By | 535 |  |  |  | meta-shape | features/supply/src/pages/capa/components/modals/VersionInfoModal.tsx | 58 |
| column | LANE_QTY | Lane |  | true |  |  | meta-shape | features/supply/src/pages/capa/utils/capa.editLock.test.ts | 68 |

## 7. 메시지 코드
| code | count |
|---|---|
| MSG00096 | 1 |
| MSG01314 | 1 |
| MSG00672 | 1 |
| MSG00003 | 1 |
| MSG00133 | 1 |
| MSG01335 | 1 |
| MSG01288 | 2 |
| MSG01054 | 1 |
| MSG00002 | 1 |
| MSG00265 | 1 |
| MSG00108 | 1 |
| MSG01348 | 1 |
| MSG01323 | 1 |
| MSG01327 | 1 |
| MSG01326 | 1 |
| MSG00097 | 1 |
| MSG01385 | 1 |
| MSG01023 | 1 |
| MSG00337 | 1 |
| MSG00203 | 1 |
| MSG00107 | 1 |
| MSG00193 | 1 |
| MSG00072 | 1 |
| LBL00001 | 1 |
| LBL00027 | 1 |
| LBL00030 | 1 |
| LBL00008 | 1 |
| LBL00010 | 1 |
| LBL00009 | 1 |
| LBL00606 | 1 |
| LBL00013 | 1 |
| LBL00618 | 1 |
| LBL00021 | 1 |
| LBL00710 | 1 |
| LBL00852 | 1 |
| LBL01089 | 1 |
| LBL00769 | 1 |
| LBL01123 | 1 |
| LBL01133 | 1 |
| LBL00645 | 1 |
| LBL01076 | 1 |
| LBL00112 | 1 |
| LBL00757 | 1 |
| LBL01053 | 1 |
| LBL01121 | 1 |
| LBL01074 | 1 |
| LBL01098 | 1 |
| LBL01096 | 1 |
| LBL01095 | 1 |
| LBL01132 | 1 |
| LBL01091 | 1 |
| LBL00605 | 1 |
| LBL01034 | 1 |
| LBL01094 | 1 |
| LBL00346 | 1 |
| LBL00762 | 1 |
| LBL00759 | 1 |
| LBL00716 | 1 |
| LBL00107 | 1 |
| LBL00754 | 1 |
| LBL00755 | 1 |
| LBL00756 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0049(10), SCM0002(1)
- SP/PKG: P_SAVE_CAPA(4), P_GET_CAPA(3), PKG_SCP0049(3), P_GET_SHEET_CALENDAR(2), P_GET_NEW_VERSION_INFO(2), P_SAVE_NEW_VERSION(2), P_CAPA_EXCEL_UPLOAD(2), P_GET_SHEET_USER_TITLE(1), P_GET_DAY_RANGE(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | SCP0049 CAPA (Capacity) — 편집형 동적 pivot 화면(신규 전환 2026-09-26). 조회 = PKG_SCP0049.P_GET_CAPA / 저장 = P_SAVE_CAPA(^-bulk). EDIT 모드 토글 미이식(편집=beginningEdit 종합식). INSERT/DELETE = 명시적 무동작(() => undefined, R4·R5). 헤더 요약 5종 = o_rc2/o_rc3(R14). | features/supply/src/pages/capa/Capa.tsx | 42 |
| jsx | WijmoRowItem 확장(전역 index = WijmoPrimitive) — DataGrid<CapaRow>/EditTracker<CapaRow> 제약 충족. | features/supply/src/pages/capa/capa.types.ts | 6 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

