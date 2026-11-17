# DMF0005 — To-Be Fact Pack 요약

- page_key: `master/sales-site-project-model` · feature: master · As-is Fact Pack 있음
- 파일 17 · 엔드포인트 호출 10 (미해결 3, 주석 속 0) · 이벤트 40 · 컴포넌트 사용 68 · 하드코딩 컬럼 3 · 메시지 26
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 3건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/master/src/pages/sales-site-project-model/componenets/ModelCodeChangeModal.module.scss | style | 37 |
| features/master/src/pages/sales-site-project-model/componenets/ModelCodeChangeModal.tsx | page | 223 |
| features/master/src/pages/sales-site-project-model/componenets/SalesSiteProjectModelForm.module.scss | style | 41 |
| features/master/src/pages/sales-site-project-model/componenets/SalesSiteProjectModelForm.tsx | page | 461 |
| features/master/src/pages/sales-site-project-model/componenets/SalesSiteProjectModelGrid.tsx | page | 664 |
| features/master/src/pages/sales-site-project-model/componenets/SalesSiteProjectModelPurchaseGrid.tsx | page | 131 |
| features/master/src/pages/sales-site-project-model/index.ts | index | 2 |
| features/master/src/pages/sales-site-project-model/sales-site-project-model.constants.ts | constants | 148 |
| features/master/src/pages/sales-site-project-model/sales-site-project-model.editBaseline.ts | other | 103 |
| features/master/src/pages/sales-site-project-model/sales-site-project-model.gridCombos.ts | other | 285 |
| features/master/src/pages/sales-site-project-model/sales-site-project-model.salesCompanyGuard.ts | other | 675 |
| features/master/src/pages/sales-site-project-model/sales-site-project-model.scpGuard.ts | other | 83 |
| features/master/src/pages/sales-site-project-model/sales-site-project-model.siteInfo.ts | other | 48 |
| features/master/src/pages/sales-site-project-model/SalesSiteProjectModel.module.scss | style | 36 |
| features/master/src/pages/sales-site-project-model/SalesSiteProjectModel.tsx | page | 328 |
| features/master/src/pages/sales-site-project-model/useSalesSiteProjectModelSave.ts | hook | 84 |
| features/master/src/pages/sales-site-project-model/useSalesSiteProjectModelStore.ts | store | 187 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 2 | Y | SalesSiteProjectModelForm.tsx:71 sales-site-project-model.gridCombos.ts:185 |
| {?{comboId,...rowParamValues(bindings,row)}} | http | 1 | N | sales-site-project-model.salesCompanyGuard.ts:311 |
| {?{comboId:SITE_INFO_COMBO_ID,divisionId:cellText(row.DIVISION_ID),scmSiteId:site,} | http | 1 | N | sales-site-project-model.salesCompanyGuard.ts:366 |
| DMF0005/production//call-proc | hook | 1 | Y | SalesSiteProjectModel.tsx:71 |
| DMF0005/purchase//call-proc | hook | 1 | Y | SalesSiteProjectModel.tsx:79 |
| DMF0005/{sheetName}/SAVE/call-proc | http | 1 | N | useSalesSiteProjectModelSave.ts:52 |
| /admin/menu/DMF0005/column | http | 2 | Y | useSalesSiteProjectModelStore.ts:148 useSalesSiteProjectModelStore.ts:152 |
| /admin/menu/DMF0005/search-conditions | http | 1 | Y | useSalesSiteProjectModelStore.ts:165 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| production | divisionId deptId endCustomer salesSite projectCode itemId activeFlag owner endCustReportYn projectInfoYn | production |  |
| purchase | divisionId salesSite projectCode activeFlag | purchase |  |
| modelChange |  | modelChange | PKG_DMF0005 P_DMF0005_SAVE_MODEL_CHANGE_POPUP P_DATA P_USER_ID |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| Button | onClick | <arrow> handleExcel | jsx | features/master/src/pages/sales-site-project-model/componenets/ModelCodeChangeModal.tsx | 180 |
| Button | onClick | handleInsert | jsx | features/master/src/pages/sales-site-project-model/componenets/ModelCodeChangeModal.tsx | 189 |
| Button | onClick | handleDelete | jsx | features/master/src/pages/sales-site-project-model/componenets/ModelCodeChangeModal.tsx | 196 |
| Button | onClick | handleSave | jsx | features/master/src/pages/sales-site-project-model/componenets/ModelCodeChangeModal.tsx | 206 |
| Button | onClick | modalClose | jsx | features/master/src/pages/sales-site-project-model/componenets/ModelCodeChangeModal.tsx | 215 |
| SearchArea | onSearch | onSubmit | jsx | features/master/src/pages/sales-site-project-model/componenets/SalesSiteProjectModelForm.tsx | 163 |
| CustomDropdown | onChange | <arrow> confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,setSearchParams,setOpenPurchaseGrid | jsx | features/master/src/pages/sales-site-project-model/componenets/SalesSiteProjectModelForm.tsx | 179 |
| CustomDropdown | onChange | <arrow> setSearchParams,setOpenPurchaseGrid | jsx | features/master/src/pages/sales-site-project-model/componenets/SalesSiteProjectModelForm.tsx | 220 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/master/src/pages/sales-site-project-model/componenets/SalesSiteProjectModelForm.tsx | 251 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/master/src/pages/sales-site-project-model/componenets/SalesSiteProjectModelForm.tsx | 283 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/master/src/pages/sales-site-project-model/componenets/SalesSiteProjectModelForm.tsx | 313 |
| Button | onClick | <arrow> setOpenProjectByDivisionModal | jsx | features/master/src/pages/sales-site-project-model/componenets/SalesSiteProjectModelForm.tsx | 309 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/master/src/pages/sales-site-project-model/componenets/SalesSiteProjectModelForm.tsx | 339 |
| Button | onClick | <arrow> setOpenItemByDivisionModal | jsx | features/master/src/pages/sales-site-project-model/componenets/SalesSiteProjectModelForm.tsx | 335 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/master/src/pages/sales-site-project-model/componenets/SalesSiteProjectModelForm.tsx | 364 |
| Button | onClick | <arrow> setOpenOwnerByDivisionModal | jsx | features/master/src/pages/sales-site-project-model/componenets/SalesSiteProjectModelForm.tsx | 360 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/master/src/pages/sales-site-project-model/componenets/SalesSiteProjectModelForm.tsx | 388 |
| Checkbox | onChange | <arrow> setActiveTab,setOpenPurchaseGrid | jsx | features/master/src/pages/sales-site-project-model/componenets/SalesSiteProjectModelForm.tsx | 401 |
| Checkbox | onChange | <arrow> setSearchParams | jsx | features/master/src/pages/sales-site-project-model/componenets/SalesSiteProjectModelForm.tsx | 420 |
| Checkbox | onChange | <arrow> setSearchParams | jsx | features/master/src/pages/sales-site-project-model/componenets/SalesSiteProjectModelForm.tsx | 427 |
| grid | copying | handleCopying | addHandler | features/master/src/pages/sales-site-project-model/componenets/SalesSiteProjectModelGrid.tsx | 172 |
| grid | pastedCell | handlePastedTeam | addHandler | features/master/src/pages/sales-site-project-model/componenets/SalesSiteProjectModelGrid.tsx | 173 |
| grid.hostElement | keydown | handleClearTeam | addEventListener | features/master/src/pages/sales-site-project-model/componenets/SalesSiteProjectModelGrid.tsx | 174 |
| grid | cellEditEnded | handleEditEnded | addHandler | features/master/src/pages/sales-site-project-model/componenets/SalesSiteProjectModelGrid.tsx | 274 |
| grid | pasted | handlePasted | addHandler | features/master/src/pages/sales-site-project-model/componenets/SalesSiteProjectModelGrid.tsx | 275 |
| grid | cellEditEnded | handleVmiEditEnded | addHandler | features/master/src/pages/sales-site-project-model/componenets/SalesSiteProjectModelGrid.tsx | 355 |
| grid | pasted | handleVmiPasted | addHandler | features/master/src/pages/sales-site-project-model/componenets/SalesSiteProjectModelGrid.tsx | 356 |
| grid | beginningEdit | cancelIfLocked | addHandler | features/master/src/pages/sales-site-project-model/componenets/SalesSiteProjectModelGrid.tsx | 574 |
| grid | pastingCell | cancelIfLocked | addHandler | features/master/src/pages/sales-site-project-model/componenets/SalesSiteProjectModelGrid.tsx | 575 |
| grid | formatItem | unmarkLocked | addHandler | features/master/src/pages/sales-site-project-model/componenets/SalesSiteProjectModelGrid.tsx | 576 |
| DataGrid | gotFocus | handleFocus | jsx | features/master/src/pages/sales-site-project-model/componenets/SalesSiteProjectModelGrid.tsx | 596 |
| DataGrid | gotFocus | handleFocus | jsx | features/master/src/pages/sales-site-project-model/componenets/SalesSiteProjectModelPurchaseGrid.tsx | 110 |
| grid | cellEditEnded | handler | addHandler | features/master/src/pages/sales-site-project-model/sales-site-project-model.editBaseline.ts | 92 |
| grid | pastedCell | handler | addHandler | features/master/src/pages/sales-site-project-model/sales-site-project-model.editBaseline.ts | 93 |
| grid | cellEditEnding | editEndingHandler | addHandler | features/master/src/pages/sales-site-project-model/sales-site-project-model.salesCompanyGuard.ts | 661 |
| grid | pastingCell | pastingHandler | addHandler | features/master/src/pages/sales-site-project-model/sales-site-project-model.salesCompanyGuard.ts | 662 |
| grid | cellEditEnded | editEndedHandler | addHandler | features/master/src/pages/sales-site-project-model/sales-site-project-model.salesCompanyGuard.ts | 663 |
| grid | pastedCell | editEndedHandler | addHandler | features/master/src/pages/sales-site-project-model/sales-site-project-model.salesCompanyGuard.ts | 664 |
| grid | updatedLayout | updatedLayoutHandler | addHandler | features/master/src/pages/sales-site-project-model/sales-site-project-model.salesCompanyGuard.ts | 665 |
| SalesSiteProjectModelForm | onSubmit | handleSubmit | jsx | features/master/src/pages/sales-site-project-model/SalesSiteProjectModel.tsx | 285 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 9 |
| FormItem | 9 |
| Button | 8 |
| CustomDropdown | 5 |
| DataGrid | 3 |
| InputField | 3 |
| FunctionSearchIcon | 3 |
| Checkbox | 3 |
| Label | 3 |
| ItemByDivisionModal | 2 |
| OwnerModal | 2 |
| Panel | 2 |
| CustomDialog | 1 |
| ResultArea | 1 |
| FileExceldownloadIcon | 1 |
| ControlConfirmIcon | 1 |
| SearchArea | 1 |
| ProjectByDivisionModal | 1 |
| OwnerByDivisionModal | 1 |
| TeamModal | 1 |
| ProjectModal | 1 |
| MainTitle | 1 |
| SalesSiteProjectModelForm | 1 |
| SubTitle | 1 |
| PanelGroup | 1 |
| SalesSiteProjectModelGrid | 1 |
| SalesSiteProjectModelPurchaseGrid | 1 |
| ModelCodeChangeModal | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| MODEL_CHANGE_COLUMNS | ITEM_ID_BEFORE | BEFORE | 250 |  |  |  | meta-shape | features/master/src/pages/sales-site-project-model/componenets/ModelCodeChangeModal.tsx | 44 |
| MODEL_CHANGE_COLUMNS | ITEM_ID_AFTER | AFTER | 250 |  |  |  | meta-shape | features/master/src/pages/sales-site-project-model/componenets/ModelCodeChangeModal.tsx | 45 |
| MODEL_POPUP_COLUMNS | ITEM_TYPE_NAME\|ITEM_TYPE | Type | 80 |  |  |  | meta-shape | features/master/src/pages/sales-site-project-model/sales-site-project-model.constants.ts | 94 |

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00674 | 1 |
| MSG00014 | 1 |
| MSG00004 | 2 |
| LBL00121 | 1 |
| LBL00108 | 1 |
| LBL00111 | 1 |
| LBL00627 | 1 |
| LBL00112 | 1 |
| LBL00001 | 1 |
| LBL00044 | 1 |
| LBL00080 | 1 |
| LBL00011 | 1 |
| LBL00617 | 1 |
| LBL00618 | 1 |
| LBL00082 | 1 |
| LBL00007 | 1 |
| LBL00316 | 1 |
| MSG01192 | 1 |
| MSG01148 | 1 |
| MSG00096 | 1 |
| MSG00613 | 1 |
| MSG00614 | 1 |
| MSG00003 | 2 |
| MSG00002 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: DMF0005(7), COM0008(3), DMF0006(2), DMF0007(2), DMF0042(1)
- SP/PKG: PKG_DMF0005(5), SCM0001_GET_SITE_INFO_BY_DIVISION(2), P_DMF0005_SAVE_MODEL_CHANGE_POPUP(1), DMF0005_SAVE_MODEL_CHANGE_POPUP(1), P_DATA(1), P_USER_ID(1), PR_CHECK_MNU_BTN_AUTH(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| jsx | GRID_COMBO_PARAMS 에 선언된 컬럼의 셀 콤보를 파라미터로 좁혀 편집 시점에 적용한다. 상·하단 그리드가 같은 규칙을 쓰므로 두 컴포넌트에서 그대로 호출한다. 반환값을 `<DataGrid {...useGridCombos(...)} />` 로 펼쳐 넣는다 — grid.beginningEdit.addHandler 로 직접 붙이면 effect 가 도는 시점에 `gridRef.current` 가 아직 없을 수 있어 조용히 | features/master/src/pages/sales-site-project-model/sales-site-project-model.gridCombos.ts | 139 |
| code | ⭐ 이 화면 전용 저장 뮤테이션 — 공통 useProcMutation 을 쓰지 않는 이유. 저장이 실패했는데도 "성공적으로 저장되었습니다!" 토스트가 뜨고 재조회로 넘어가는 문제가 있다. 원인은 axios 에러 인터셉터가 HTTP 500 을 reject 가 아니라 **성공 응답으로 되돌려 보내는** 데 있다 (packages/foundation/src/apis/axios-interceptors.ts 의 `case 500: re | features/master/src/pages/sales-site-project-model/useSalesSiteProjectModelSave.ts | 8 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

