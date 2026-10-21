# DMF0005 — To-Be Fact Pack 요약

- page_key: `master/sales-site-project-model` · feature: master · As-is Fact Pack 없음(화면ID 미대응)
- 파일 17 · 엔드포인트 호출 10 (미해결 3, 주석 속 0) · 이벤트 31 · 컴포넌트 사용 63 · 하드코딩 컬럼 3 · 메시지 20
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 3건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/master/src/pages/sales-site-project-model/componenets/ModelCodeChangeModal.module.scss | style | 37 |
| features/master/src/pages/sales-site-project-model/componenets/ModelCodeChangeModal.tsx | page | 211 |
| features/master/src/pages/sales-site-project-model/componenets/SalesSiteProjectModelForm.module.scss | style | 41 |
| features/master/src/pages/sales-site-project-model/componenets/SalesSiteProjectModelForm.tsx | page | 439 |
| features/master/src/pages/sales-site-project-model/componenets/SalesSiteProjectModelGrid.tsx | page | 459 |
| features/master/src/pages/sales-site-project-model/componenets/SalesSiteProjectModelPurchaseGrid.tsx | page | 125 |
| features/master/src/pages/sales-site-project-model/index.ts | index | 2 |
| features/master/src/pages/sales-site-project-model/sales-site-project-model.constants.ts | constants | 106 |
| features/master/src/pages/sales-site-project-model/sales-site-project-model.editBaseline.ts | other | 103 |
| features/master/src/pages/sales-site-project-model/sales-site-project-model.gridCombos.ts | other | 285 |
| features/master/src/pages/sales-site-project-model/sales-site-project-model.salesCompanyGuard.ts | other | 675 |
| features/master/src/pages/sales-site-project-model/sales-site-project-model.scpGuard.ts | other | 83 |
| features/master/src/pages/sales-site-project-model/sales-site-project-model.siteInfo.ts | other | 48 |
| features/master/src/pages/sales-site-project-model/SalesSiteProjectModel.module.scss | style | 21 |
| features/master/src/pages/sales-site-project-model/SalesSiteProjectModel.tsx | page | 320 |
| features/master/src/pages/sales-site-project-model/useSalesSiteProjectModelSave.ts | hook | 84 |
| features/master/src/pages/sales-site-project-model/useSalesSiteProjectModelStore.ts | store | 164 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 2 | Y | SalesSiteProjectModelForm.tsx:59 sales-site-project-model.gridCombos.ts:185 |
| {?{comboId,...rowParamValues(bindings,row)}} | http | 1 | N | sales-site-project-model.salesCompanyGuard.ts:311 |
| {?{comboId:SITE_INFO_COMBO_ID,divisionId:cellText(row.DIVISION_ID),scmSiteId:site,} | http | 1 | N | sales-site-project-model.salesCompanyGuard.ts:366 |
| DMF0005/production//call-proc | hook | 1 | Y | SalesSiteProjectModel.tsx:71 |
| DMF0005/purchase//call-proc | hook | 1 | Y | SalesSiteProjectModel.tsx:79 |
| DMF0005/{sheetName}/SAVE/call-proc | http | 1 | N | useSalesSiteProjectModelSave.ts:52 |
| /admin/menu/DMF0005/column | http | 2 | Y | useSalesSiteProjectModelStore.ts:125 useSalesSiteProjectModelStore.ts:129 |
| /admin/menu/DMF0005/search-conditions | http | 1 | Y | useSalesSiteProjectModelStore.ts:142 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| production | divisionId deptId endCustomer salesSite projectCode itemId activeFlag owner | production |  |
| purchase | divisionId salesSite projectCode activeFlag | purchase |  |
| modelChange |  | modelChange | PKG_DMF0005 P_DMF0005_SAVE_MODEL_CHANGE_POPUP P_DATA P_USER_ID |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| Button | onClick | <arrow> handleExcel | jsx | features/master/src/pages/sales-site-project-model/componenets/ModelCodeChangeModal.tsx | 172 |
| Button | onClick | handleInsert | jsx | features/master/src/pages/sales-site-project-model/componenets/ModelCodeChangeModal.tsx | 179 |
| Button | onClick | handleDelete | jsx | features/master/src/pages/sales-site-project-model/componenets/ModelCodeChangeModal.tsx | 186 |
| Button | onClick | handleSave | jsx | features/master/src/pages/sales-site-project-model/componenets/ModelCodeChangeModal.tsx | 196 |
| Button | onClick | modalClose | jsx | features/master/src/pages/sales-site-project-model/componenets/ModelCodeChangeModal.tsx | 203 |
| SearchArea | onSearch | onSubmit | jsx | features/master/src/pages/sales-site-project-model/componenets/SalesSiteProjectModelForm.tsx | 151 |
| CustomDropdown | onChange | <arrow> confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,setSearchParams,setOpenPurchaseGrid | jsx | features/master/src/pages/sales-site-project-model/componenets/SalesSiteProjectModelForm.tsx | 167 |
| CustomDropdown | onChange | <arrow> setSearchParams,setOpenPurchaseGrid | jsx | features/master/src/pages/sales-site-project-model/componenets/SalesSiteProjectModelForm.tsx | 208 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/master/src/pages/sales-site-project-model/componenets/SalesSiteProjectModelForm.tsx | 239 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/master/src/pages/sales-site-project-model/componenets/SalesSiteProjectModelForm.tsx | 271 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/master/src/pages/sales-site-project-model/componenets/SalesSiteProjectModelForm.tsx | 305 |
| FunctionSearchIcon | onClick | <arrow> setOpenProjectByDivisionModal | jsx | features/master/src/pages/sales-site-project-model/componenets/SalesSiteProjectModelForm.tsx | 299 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/master/src/pages/sales-site-project-model/componenets/SalesSiteProjectModelForm.tsx | 335 |
| FunctionSearchIcon | onClick | <arrow> setOpenItemByDivisionModal | jsx | features/master/src/pages/sales-site-project-model/componenets/SalesSiteProjectModelForm.tsx | 329 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/master/src/pages/sales-site-project-model/componenets/SalesSiteProjectModelForm.tsx | 364 |
| FunctionSearchIcon | onClick | <arrow> setOpenOwnerByDivisionModal | jsx | features/master/src/pages/sales-site-project-model/componenets/SalesSiteProjectModelForm.tsx | 358 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/master/src/pages/sales-site-project-model/componenets/SalesSiteProjectModelForm.tsx | 388 |
| Checkbox | onChange | <arrow> setActiveTab,setOpenPurchaseGrid | jsx | features/master/src/pages/sales-site-project-model/componenets/SalesSiteProjectModelForm.tsx | 401 |
| grid | copying | handleCopying | addHandler | features/master/src/pages/sales-site-project-model/componenets/SalesSiteProjectModelGrid.tsx | 165 |
| grid | pastedCell | handlePastedTeam | addHandler | features/master/src/pages/sales-site-project-model/componenets/SalesSiteProjectModelGrid.tsx | 166 |
| grid.hostElement | keydown | handleClearTeam | addEventListener | features/master/src/pages/sales-site-project-model/componenets/SalesSiteProjectModelGrid.tsx | 167 |
| DataGrid | gotFocus | handleFocus | jsx | features/master/src/pages/sales-site-project-model/componenets/SalesSiteProjectModelGrid.tsx | 391 |
| DataGrid | gotFocus | handleFocus | jsx | features/master/src/pages/sales-site-project-model/componenets/SalesSiteProjectModelPurchaseGrid.tsx | 104 |
| grid | cellEditEnded | handler | addHandler | features/master/src/pages/sales-site-project-model/sales-site-project-model.editBaseline.ts | 92 |
| grid | pastedCell | handler | addHandler | features/master/src/pages/sales-site-project-model/sales-site-project-model.editBaseline.ts | 93 |
| grid | cellEditEnding | editEndingHandler | addHandler | features/master/src/pages/sales-site-project-model/sales-site-project-model.salesCompanyGuard.ts | 661 |
| grid | pastingCell | pastingHandler | addHandler | features/master/src/pages/sales-site-project-model/sales-site-project-model.salesCompanyGuard.ts | 662 |
| grid | cellEditEnded | editEndedHandler | addHandler | features/master/src/pages/sales-site-project-model/sales-site-project-model.salesCompanyGuard.ts | 663 |
| grid | pastedCell | editEndedHandler | addHandler | features/master/src/pages/sales-site-project-model/sales-site-project-model.salesCompanyGuard.ts | 664 |
| grid | updatedLayout | updatedLayoutHandler | addHandler | features/master/src/pages/sales-site-project-model/sales-site-project-model.salesCompanyGuard.ts | 665 |
| SalesSiteProjectModelForm | onSubmit | handleSubmit | jsx | features/master/src/pages/sales-site-project-model/SalesSiteProjectModel.tsx | 277 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| FormItem | 9 |
| Button | 8 |
| Grid | 8 |
| CustomDropdown | 5 |
| DataGrid | 3 |
| InputField | 3 |
| FunctionSearchIcon | 3 |
| ItemByDivisionModal | 2 |
| OwnerModal | 2 |
| Panel | 2 |
| CustomDialog | 1 |
| ResultArea | 1 |
| FileExceldownloadIcon | 1 |
| ControlConfirmIcon | 1 |
| SearchArea | 1 |
| Checkbox | 1 |
| Label | 1 |
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
| MODEL_POPUP_COLUMNS | ITEM_TYPE_NAME\|ITEM_TYPE | Type | 80 |  |  |  | meta-shape | features/master/src/pages/sales-site-project-model/sales-site-project-model.constants.ts | 77 |

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00674 | 1 |
| MSG00014 | 1 |
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
| MSG00096 | 1 |
| MSG00003 | 2 |
| MSG00002 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: DMF0005(6), COM0008(3), DMF0006(2), DMF0007(2), COM0004(1), DMF0042(1)
- SP/PKG: PKG_DMF0005(3), SCM0001_GET_SITE_INFO_BY_DIVISION(2), P_DMF0005_SAVE_MODEL_CHANGE_POPUP(1), DMF0005_SAVE_MODEL_CHANGE_POPUP(1), P_DATA(1), P_USER_ID(1), PR_CHECK_MNU_BTN_AUTH(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| jsx | GRID_COMBO_PARAMS 에 선언된 컬럼의 셀 콤보를 파라미터로 좁혀 편집 시점에 적용한다. 상·하단 그리드가 같은 규칙을 쓰므로 두 컴포넌트에서 그대로 호출한다. 반환값을 `<DataGrid {...useGridCombos(...)} />` 로 펼쳐 넣는다 — grid.beginningEdit.addHandler 로 직접 붙이면 effect 가 도는 시점에 `gridRef.current` 가 아직 없을 수 있어 조용히 | features/master/src/pages/sales-site-project-model/sales-site-project-model.gridCombos.ts | 139 |
| code | ⭐ 이 화면 전용 저장 뮤테이션 — 공통 useProcMutation 을 쓰지 않는 이유. 저장이 실패했는데도 "성공적으로 저장되었습니다!" 토스트가 뜨고 재조회로 넘어가는 문제가 있다. 원인은 axios 에러 인터셉터가 HTTP 500 을 reject 가 아니라 **성공 응답으로 되돌려 보내는** 데 있다 (packages/foundation/src/apis/axios-interceptors.ts 의 `case 500: re | features/master/src/pages/sales-site-project-model/useSalesSiteProjectModelSave.ts | 8 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

