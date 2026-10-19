# SCP0005 — To-Be Fact Pack 요약

- page_key: `shipping/distribution-route` · feature: shipping · As-is Fact Pack 있음
- 파일 18 · 엔드포인트 호출 8 (미해결 2, 주석 속 1) · 이벤트 31 · 컴포넌트 사용 47 · 하드코딩 컬럼 3 · 메시지 31
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 3건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/shipping/src/pages/distribution-route/components/DistributionRouteForm.tsx | component | 187 |
| features/shipping/src/pages/distribution-route/components/DistributionRouteGrid.tsx | component | 270 |
| features/shipping/src/pages/distribution-route/components/modals/ExcelUploadModal.module.scss | component | 47 |
| features/shipping/src/pages/distribution-route/components/modals/ExcelUploadModal.tsx | component | 296 |
| features/shipping/src/pages/distribution-route/distribution-route.constants.ts | constants | 281 |
| features/shipping/src/pages/distribution-route/distribution-route.excelForm.ts | other | 70 |
| features/shipping/src/pages/distribution-route/distribution-route.types.ts | types | 25 |
| features/shipping/src/pages/distribution-route/DistributionRoute.module.scss | style | 12 |
| features/shipping/src/pages/distribution-route/DistributionRoute.tsx | page | 363 |
| features/shipping/src/pages/distribution-route/hooks/useDistributionRouteValidation.ts | hook | 53 |
| features/shipping/src/pages/distribution-route/index.ts | index | 2 |
| features/shipping/src/pages/distribution-route/useDistributionRouteStore.ts | store | 163 |
| features/shipping/src/pages/distribution-route/utils/distributionRoute.cityLookup.ts | util | 56 |
| features/shipping/src/pages/distribution-route/utils/distributionRoute.columns.ts | util | 37 |
| features/shipping/src/pages/distribution-route/utils/distributionRoute.derive.ts | util | 40 |
| features/shipping/src/pages/distribution-route/utils/distributionRoute.editLock.ts | util | 28 |
| features/shipping/src/pages/distribution-route/utils/distributionRoute.saveRequest.ts | util | 114 |
| features/shipping/src/pages/distribution-route/__asis-mapping__.md | mapping | 82 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 1 | Y | DistributionRouteForm.tsx:44 |
| /SCP0005/{ADMIN_SHEET_NAME[SHEETS.ROUTE]}/UPLOAD/excel-upload | http | 1 | N | ExcelUploadModal.tsx:133 |
| SCP0005/route//call-proc | hook | 1 | Y | DistributionRoute.tsx:74 |
| /SCP0005/{ADMIN_SHEET_NAME[SHEETS.ROUTE]}/UPLOAD_SAVE/call-proc | http | 1 | N | DistributionRoute.tsx:334 |
| /admin/menu/SCP0005/column | http | 1 | Y | useDistributionRouteStore.ts:115 |
| /admin/menu/SCP0005/search-conditions | http | 1 | Y | useDistributionRouteStore.ts:136 |
| /SCP0005/route/SEARCH_CITY/call-proc | http | 1 | Y | distributionRoute.cityLookup.ts:37 |
| /SCP0005/route/SAVE/call-proc | http | 1 | Y | distributionRoute.saveRequest.ts:90 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| route | fromCountry fromCity toCountry toCity transportMode validYn | o_rc1 | PKG_SCP0005 P_SCP0005_GET_DISTRIBUTION_ROUTE |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | onSearch | jsx | features/shipping/src/pages/distribution-route/components/DistributionRouteForm.tsx | 53 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/distribution-route/components/DistributionRouteForm.tsx | 66 |
| InputField | onKeyDown | <arrow> onSearch | jsx | features/shipping/src/pages/distribution-route/components/DistributionRouteForm.tsx | 67 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/distribution-route/components/DistributionRouteForm.tsx | 93 |
| InputField | onKeyDown | <arrow> onSearch | jsx | features/shipping/src/pages/distribution-route/components/DistributionRouteForm.tsx | 94 |
| FunctionSearchIcon | onClick | onFromSearch | jsx | features/shipping/src/pages/distribution-route/components/DistributionRouteForm.tsx | 88 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/distribution-route/components/DistributionRouteForm.tsx | 110 |
| InputField | onKeyDown | <arrow> onSearch | jsx | features/shipping/src/pages/distribution-route/components/DistributionRouteForm.tsx | 111 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/distribution-route/components/DistributionRouteForm.tsx | 137 |
| InputField | onKeyDown | <arrow> onSearch | jsx | features/shipping/src/pages/distribution-route/components/DistributionRouteForm.tsx | 138 |
| FunctionSearchIcon | onClick | onToSearch | jsx | features/shipping/src/pages/distribution-route/components/DistributionRouteForm.tsx | 132 |
| CustomDropdown | onChange | <arrow> set | jsx | features/shipping/src/pages/distribution-route/components/DistributionRouteForm.tsx | 157 |
| CustomDropdown | onChange | <arrow> set,String | jsx | features/shipping/src/pages/distribution-route/components/DistributionRouteForm.tsx | 177 |
| g | beginningEdit | beginningEditHandler | addHandler | features/shipping/src/pages/distribution-route/components/DistributionRouteGrid.tsx | 102 |
| g | cellEditEnded | cellEditEndedHandler | addHandler | features/shipping/src/pages/distribution-route/components/DistributionRouteGrid.tsx | 185 |
| g | pastedCell | cellEditEndedHandler | addHandler | features/shipping/src/pages/distribution-route/components/DistributionRouteGrid.tsx | 186 |
| g.hostElement | dblclick | dblclickHandler | addEventListener | features/shipping/src/pages/distribution-route/components/DistributionRouteGrid.tsx | 201 |
| g | formatItem | formatItemHandler | addHandler | features/shipping/src/pages/distribution-route/components/DistributionRouteGrid.tsx | 213 |
| g | updatedLayout | applyLeafHeaderHeight | addHandler | features/shipping/src/pages/distribution-route/components/DistributionRouteGrid.tsx | 240 |
| DataGrid | gotFocus | onFocus | jsx | features/shipping/src/pages/distribution-route/components/DistributionRouteGrid.tsx | 266 |
| FileUploader | onFileChange | <arrow> setAlert,t,setFiles,value.slice,resetResult | jsx | features/shipping/src/pages/distribution-route/components/modals/ExcelUploadModal.tsx | 226 |
| Button | onClick | <arrow> handleUpload | jsx | features/shipping/src/pages/distribution-route/components/modals/ExcelUploadModal.tsx | 251 |
| Button | onClick | handleClose | jsx | features/shipping/src/pages/distribution-route/components/modals/ExcelUploadModal.tsx | 255 |
| DistributionRouteForm | onSearch | handleSearch | jsx | features/shipping/src/pages/distribution-route/DistributionRoute.tsx | 284 |
| DistributionRouteForm | onFromSearch | <arrow> setRegionMode | jsx | features/shipping/src/pages/distribution-route/DistributionRoute.tsx | 285 |
| DistributionRouteForm | onToSearch | <arrow> setRegionMode | jsx | features/shipping/src/pages/distribution-route/DistributionRoute.tsx | 286 |
| DistributionRouteGrid | onFromCellDblClick | <arrow> openCellRegion | jsx | features/shipping/src/pages/distribution-route/DistributionRoute.tsx | 309 |
| DistributionRouteGrid | onToCellDblClick | <arrow> openCellRegion | jsx | features/shipping/src/pages/distribution-route/DistributionRoute.tsx | 310 |
| DistributionRouteGrid | onFocus | <arrow>  | jsx | features/shipping/src/pages/distribution-route/DistributionRoute.tsx | 311 |
| ExcelUploadModal | onUploaded | <arrow> refetch | jsx | features/shipping/src/pages/distribution-route/DistributionRoute.tsx | 328 |
| ExcelUploadModal | onSave | <arrow> apiClient.post,Number | jsx | features/shipping/src/pages/distribution-route/DistributionRoute.tsx | 329 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| FormItem | 10 |
| Grid | 6 |
| InputField | 4 |
| Button | 4 |
| TextField | 3 |
| FunctionSearchIcon | 2 |
| CustomDropdown | 2 |
| DataGrid | 2 |
| SearchArea | 1 |
| CustomDialog | 1 |
| ProgressIndicator | 1 |
| FileUploader | 1 |
| ControlConfirmIcon | 1 |
| Label | 1 |
| FileExceldownloadIcon | 1 |
| FileExceluploadIcon | 1 |
| MainTitle | 1 |
| DistributionRouteForm | 1 |
| SubTitle | 1 |
| DistributionRouteGrid | 1 |
| RegionModal | 1 |
| ExcelUploadModal | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| RESULT_COLUMNS | MESSAGE_TEXT | Check | 240 | true |  |  | meta-shape | features/shipping/src/pages/distribution-route/components/modals/ExcelUploadModal.tsx | 78 |
| RESULT_COLUMNS | `ATTRIBUTE${i + 1}` | label | 110 | true |  |  | meta-map | features/shipping/src/pages/distribution-route/components/modals/ExcelUploadModal.tsx | 87 |
| buildColumns | c.key | c.header | c.width ?? 100 | true |  |  | meta-map | features/shipping/src/pages/distribution-route/utils/distributionRoute.columns.ts | 15 |

## 7. 메시지 코드
| code | count |
|---|---|
| MSG00113 | 1 |
| MSG00618 | 4 |
| MSG00657 | 1 |
| MSG00152 | 1 |
| MSG00265 | 2 |
| LBL00112 | 1 |
| LBL00074 | 1 |
| LBL00070 | 1 |
| LBL00075 | 1 |
| LBL00071 | 1 |
| LBL00025 | 1 |
| LBL00639 | 1 |
| LBL00762 | 1 |
| LBL00346 | 1 |
| LBL00759 | 1 |
| LBL00754 | 1 |
| LBL00755 | 1 |
| LBL00756 | 1 |
| LBL00757 | 1 |
| LBL00716 | 1 |
| LBL00107 | 1 |
| MSG00429 | 1 |
| MSG00002 | 1 |
| MSG00004 | 1 |
| MSG00043 | 1 |
| MSG01134 | 1 |
| MSG01220 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0005(19), SCM0002(2), DMF0004(2), SCP0006(2), SCP0020(2), DMF0014(2), DMF0074(1), SCM0008(1), DMF0082(1), SSP0014(1)
- SP/PKG: PKG_SCP0005(6), P_SCP0005_EXCEL_UPLOAD(3), SCP0005_GET_DISTRIBUTION_ROUTE(2), P_SCP0005_SAVE_ROUTE(2), PR_GET_EXCEL_UPLOAD_RESULT(1), P_SCP0005_GET_DISTRIBUTION_ROUTE(1), SCP0005_SAVE_DISTRIBUTION_ROUTE(1), P_PROGRAM_ID(1), P_SHEET_NAME(1), P_CREATED_BY(1), SCP0005_GET_COUNTRY_CITY(1), P_SCP0005_GET_COUNTRY_CITY(1), P_SPLIT(1), P_USER_ID(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| endpoint | ui-dynamic-property-management — admin SCM_MST_SHEET_COLUMNS 동적 fetch (미등록 시 빈 배열 → | features/shipping/src/pages/distribution-route/useDistributionRouteStore.ts | 21 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

