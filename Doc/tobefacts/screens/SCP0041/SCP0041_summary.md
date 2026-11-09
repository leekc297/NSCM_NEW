# SCP0041 — To-Be Fact Pack 요약

- page_key: `supply/stock-osp` · feature: supply · As-is Fact Pack 있음
- 파일 15 · 엔드포인트 호출 9 (미해결 2, 주석 속 1) · 이벤트 23 · 컴포넌트 사용 50 · 하드코딩 컬럼 2 · 메시지 33
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 2건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/stock-osp/components/modals/ExcelUploadModal.module.scss | component | 47 |
| features/supply/src/pages/stock-osp/components/modals/ExcelUploadModal.tsx | component | 370 |
| features/supply/src/pages/stock-osp/components/OspStockGrid.tsx | component | 43 |
| features/supply/src/pages/stock-osp/components/PackHoldStockGrid.tsx | component | 173 |
| features/supply/src/pages/stock-osp/components/StockOspForm.tsx | component | 323 |
| features/supply/src/pages/stock-osp/hooks/useStockOspValidation.ts | hook | 46 |
| features/supply/src/pages/stock-osp/index.ts | index | 2 |
| features/supply/src/pages/stock-osp/stock-osp.constants.ts | constants | 124 |
| features/supply/src/pages/stock-osp/stock-osp.types.ts | types | 23 |
| features/supply/src/pages/stock-osp/StockOspPage.module.scss | style | 27 |
| features/supply/src/pages/stock-osp/StockOspPage.tsx | page | 365 |
| features/supply/src/pages/stock-osp/useStockOspStore.ts | store | 202 |
| features/supply/src/pages/stock-osp/utils/stock-osp.editLock.ts | util | 19 |
| features/supply/src/pages/stock-osp/utils/stock-osp.save.ts | util | 90 |
| features/supply/src/pages/stock-osp/__asis-mapping__.md | mapping | 165 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| /SCP0041/{ADMIN_SHEET_NAME[SHEETS.OSP]}/UPLOAD/excel-upload | http | 1 | N | ExcelUploadModal.tsx:167 |
| (useTabComboQueries) | hook | 1 | Y | StockOspForm.tsx:73 |
| (useTabLookupQueries) | hook | 1 | Y | StockOspForm.tsx:82 |
| SCP0041/Osp Stock//call-proc | hook | 1 | Y | StockOspPage.tsx:88 |
| SCP0041/Pack Hold Stock//call-proc | hook | 1 | Y | StockOspPage.tsx:95 |
| /SCP0041/{ADMIN_SHEET_NAME[SHEETS.OSP]}/UPLOAD_SAVE/call-proc | http | 1 | N | StockOspPage.tsx:339 |
| /admin/menu/SCP0041/column | http | 1 | Y | useStockOspStore.ts:149 |
| /admin/menu/SCP0041/search-conditions | http | 1 | Y | useStockOspStore.ts:180 |
| /SCP0041/Pack Hold Stock/SAVE/call-proc | http | 1 | Y | stock-osp.save.ts:66 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| FileUploader | onFileChange | <arrow> setAlert,t,setFiles,value.slice,resetResult | jsx | features/supply/src/pages/stock-osp/components/modals/ExcelUploadModal.tsx | 298 |
| Button | onClick | <arrow> handleSave | jsx | features/supply/src/pages/stock-osp/components/modals/ExcelUploadModal.tsx | 325 |
| Button | onClick | <arrow> handleClose | jsx | features/supply/src/pages/stock-osp/components/modals/ExcelUploadModal.tsx | 329 |
| g | beginningEdit | handler | addHandler | features/supply/src/pages/stock-osp/components/PackHoldStockGrid.tsx | 94 |
| g | cellEditEnding | onEnding | addHandler | features/supply/src/pages/stock-osp/components/PackHoldStockGrid.tsx | 130 |
| g | cellEditEnded | onEnded | addHandler | features/supply/src/pages/stock-osp/components/PackHoldStockGrid.tsx | 131 |
| g | formatItem | handler | addHandler | features/supply/src/pages/stock-osp/components/PackHoldStockGrid.tsx | 157 |
| InputField | onChange | <arrow> set | jsx | features/supply/src/pages/stock-osp/components/StockOspForm.tsx | 201 |
| Button | onClick | onItemSearch | jsx | features/supply/src/pages/stock-osp/components/StockOspForm.tsx | 197 |
| PeriodField | onChange | <arrow> set | jsx | features/supply/src/pages/stock-osp/components/StockOspForm.tsx | 218 |
| InputField | onChange | <arrow> set | jsx | features/supply/src/pages/stock-osp/components/StockOspForm.tsx | 231 |
| CustomDropdown | onChange | <arrow> set,pickMulti(picked).join,pickMulti | jsx | features/supply/src/pages/stock-osp/components/StockOspForm.tsx | 248 |
| SearchArea | onSearch | onSearch | jsx | features/supply/src/pages/stock-osp/components/StockOspForm.tsx | 260 |
| CustomDropdown | onChange | <arrow> onDivisionChange,str | jsx | features/supply/src/pages/stock-osp/components/StockOspForm.tsx | 275 |
| CustomDropdown | onChange | <arrow> set,pickMulti | jsx | features/supply/src/pages/stock-osp/components/StockOspForm.tsx | 296 |
| PeriodRangePicker | onChange | <arrow> set | jsx | features/supply/src/pages/stock-osp/components/StockOspForm.tsx | 313 |
| StockOspForm | onSearch | handleSearch | jsx | features/supply/src/pages/stock-osp/StockOspPage.tsx | 264 |
| StockOspForm | onItemSearch | <arrow> setOpenItem | jsx | features/supply/src/pages/stock-osp/StockOspPage.tsx | 265 |
| StockOspForm | onDivisionAuth | setDivisionAuth | jsx | features/supply/src/pages/stock-osp/StockOspPage.tsx | 266 |
| PackHoldStockGrid | onReversed | onReversed | jsx | features/supply/src/pages/stock-osp/StockOspPage.tsx | 305 |
| PackHoldStockGrid | onInvalidDate | onInvalidDate | jsx | features/supply/src/pages/stock-osp/StockOspPage.tsx | 306 |
| ExcelUploadModal | onUploaded | <arrow> setFilter | jsx | features/supply/src/pages/stock-osp/StockOspPage.tsx | 333 |
| ExcelUploadModal | onSave | <arrow> apiClient.post,Number | jsx | features/supply/src/pages/stock-osp/StockOspPage.tsx | 334 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| FormItem | 9 |
| Grid | 6 |
| Button | 3 |
| TextField | 3 |
| DataGrid | 3 |
| CustomDropdown | 3 |
| InputField | 2 |
| TabItem | 2 |
| CustomDialog | 1 |
| ProgressIndicator | 1 |
| FileUploader | 1 |
| ControlConfirmIcon | 1 |
| Label | 1 |
| FunctionSearchIcon | 1 |
| PeriodField | 1 |
| SearchArea | 1 |
| PeriodRangePicker | 1 |
| FileExceldownloadIcon | 1 |
| FileExceluploadIcon | 1 |
| MainTitle | 1 |
| StockOspForm | 1 |
| SubTitle | 1 |
| TabWrapper | 1 |
| OspStockGrid | 1 |
| PackHoldStockGrid | 1 |
| MaterialByDivisionModal | 1 |
| ExcelUploadModal | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| RESULT_COLUMNS | MESSAGE_TEXT | Check | 240 | true |  |  | meta-shape | features/supply/src/pages/stock-osp/components/modals/ExcelUploadModal.tsx | 83 |
| RESULT_COLUMNS | `ATTRIBUTE${i + 1}` | label | 110 | true |  |  | meta-map | features/supply/src/pages/stock-osp/components/modals/ExcelUploadModal.tsx | 92 |

## 7. 메시지 코드
| code | count |
|---|---|
| MSG00684 | 1 |
| MSG01385 | 1 |
| MSG00618 | 3 |
| MSG00657 | 1 |
| MSG00152 | 1 |
| MSG00659 | 1 |
| MSG00002 | 1 |
| MSG01273 | 1 |
| LBL00001 | 1 |
| LBL00005 | 1 |
| LBL00618 | 1 |
| LBL00013 | 1 |
| LBL01086 | 1 |
| LBL00014 | 1 |
| LBL00029 | 1 |
| LBL00112 | 1 |
| LBL00762 | 1 |
| LBL00346 | 1 |
| LBL00759 | 1 |
| LBL00716 | 1 |
| LBL00107 | 1 |
| LBL00754 | 1 |
| LBL00755 | 1 |
| LBL00756 | 1 |
| LBL00757 | 1 |
| MSG00097 | 1 |
| MSG00108 | 1 |
| MSG00611 | 1 |
| MSG00606 | 1 |
| MSG00006 | 1 |
| MSG00004 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0041(11), DMF0074(2), SCP0005(2), SSP0023(1), SCP0053(1), DMF0082(1), SCP0025(1)
- SP/PKG: PKG_SCP0041(6), P_SCP0041_STOCK_OSP_EXCEL_UPLOAD(3), P_SCP0041_GET_STOCK_OSP(3), P_SCP0041_GET_PACK_HOLD_STOCK(3), P_SCP0041_SAVE_PACKER_HOLD_STOCK(3), P_SCP0041_UPLOAD(3), P_MODE(1), P_CREATED_BY(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | const resetResult = () => setResult({ success: '', error: '', total: '' }); | features/supply/src/pages/stock-osp/components/modals/ExcelUploadModal.tsx | 118 |
| code | const handleClose = () => { | features/supply/src/pages/stock-osp/components/modals/ExcelUploadModal.tsx | 136 |
| code | setFiles([]); | features/supply/src/pages/stock-osp/components/modals/ExcelUploadModal.tsx | 137 |
| code | resetResult(); | features/supply/src/pages/stock-osp/components/modals/ExcelUploadModal.tsx | 138 |
| code | modalClose(); | features/supply/src/pages/stock-osp/components/modals/ExcelUploadModal.tsx | 139 |
| code | }; | features/supply/src/pages/stock-osp/components/modals/ExcelUploadModal.tsx | 140 |
| code | const saved = await onSave(); | features/supply/src/pages/stock-osp/components/modals/ExcelUploadModal.tsx | 204 |
| code | }); | features/supply/src/pages/stock-osp/components/modals/ExcelUploadModal.tsx | 209 |
| code | handleClose(); | features/supply/src/pages/stock-osp/components/modals/ExcelUploadModal.tsx | 213 |
| code | onConfirm: () => onUploaded(), | features/supply/src/pages/stock-osp/components/modals/ExcelUploadModal.tsx | 217 |
| code | }); | features/supply/src/pages/stock-osp/components/modals/ExcelUploadModal.tsx | 218 |
| code | onClick={() => void handleUpload()} | features/supply/src/pages/stock-osp/components/modals/ExcelUploadModal.tsx | 323 |
| endpoint | mount 1회 admin 컬럼 메타 fetch(양 시트) + keep-alive 탭 stale filters 자동발사 방지. | features/supply/src/pages/stock-osp/StockOspPage.tsx | 115 |
| code | hasButton 이 false 이므로 미노출. 등록되면 R4/R5 판정대로 NO-OP(() => undefined)로 노출된다 | features/supply/src/pages/stock-osp/StockOspPage.tsx | 201 |
| code | void GridAction.flatExcelDownload([], columns, 'StockOsp_ExcelForm'); | features/supply/src/pages/stock-osp/StockOspPage.tsx | 219 |

## 10. __asis-mapping__.md 상태
- 구현: 44
- 반영(iter-3): 3
- 해당없음: 2
- 제외: 4
| design_id | summary | reason | status |
|---|---|---|---|
| D00-1-013 | §1 layoutControlItem2 / LayoutControlItem | AS-IS formDown(Form Download) — iter-3 이식(사용자 지시 2026-10-14). SubTitle customButton 로 재현 | 반영(iter-3) |
| D00-1-014 | §1 formDown / UsrButton | Form Download 버튼 — iter-3 이식. FORM_DATA 버튼·권한 DB 등록(05_register.sql), hasButton('FORM_DATA') 게이트, 양식=flatExcelDownload 클라 생성(hook #135) | 반영(iter-3) |
| D00-1-021 | §1 emptySpaceItem1 / EmptySpaceItem | Designer 여백 아이템 — 시각 스페이서, TO-BE Grid 레이아웃에 상응 UI 없음(순수 여백) | 해당없음 |
| D00-1-027 | §1 usrButton1 / UsrButton | 어떤 Controls 컬렉션에도 add 안 된 dead control(01_layout §5-D) — 미표시 dead 라 미이식 | 제외 |
| D00-1-028 | §1 components / Container | Designer IContainer(컴포넌트 트레이) — 런타임 UI 아님, React 대응 없음 | 해당없음 |
| D00-2-005 | §2 formDown / Click | Form Download Click — iter-3 이식. GridAction.flatExcelDownload(EXCEL_FORM_HEADER 9컬럼 빈 양식, 'StockOsp_ExcelForm') | 반영(iter-3) |
| D00-3-003 | §3 SwitchLock / () — EditButton 편집토글 | EditButton 토글 어포던스 자체는 전 화면 미이식 결정(asis_to_tobe.md §11, 2026-09-23). 그리드 상시 편집 default ON(convert-core §2.1(11)) — 행 편집가부는 D00-3-005~010 코드게이트로 재현 | 제외 |
| D00-3-014 | §3 LockColumn / (1, GetMaxColumnIndex, true) — 조회 후 전열 잠금 | AS-IS 조회모드 전열잠금 = EditButton 모드토글의 일부(R12/R13). 그리드 상시 편집 default ON 이라 미이식(convert-core §2.1(11)) — Osp 시트는 메타 전건 INPUT_TP_CD='S' 로 실질 조회전용 | 제외 |
| D00-3-016 | §3 LockColumn / (1, GetMaxColumnIndex, true) — 조회 후 전열 잠금 | D00-3-014 와 동일 — 조회모드 전열잠금(R12/R13)은 EditButton 모드토글 미이식에 종속 | 제외 |

