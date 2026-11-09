# DMF0014 — To-Be Fact Pack 요약

- page_key: `demand/customer-fcst-upload` · feature: demand · As-is Fact Pack 있음
- 파일 13 · 엔드포인트 호출 11 (미해결 0, 주석 속 1) · 이벤트 24 · 컴포넌트 사용 45 · 하드코딩 컬럼 4 · 메시지 30
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 사용 · 하드코딩 컬럼 정의 4건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/demand/src/pages/customer-fcst-upload/components/CustomerFcstTemplateModal.module.scss | component | 44 |
| features/demand/src/pages/customer-fcst-upload/components/CustomerFcstTemplateModal.tsx | component | 303 |
| features/demand/src/pages/customer-fcst-upload/components/CustomerFcstUploadForm.module.scss | component | 70 |
| features/demand/src/pages/customer-fcst-upload/components/CustomerFcstUploadForm.tsx | component | 396 |
| features/demand/src/pages/customer-fcst-upload/components/CustomerFcstUploadGrid.tsx | component | 329 |
| features/demand/src/pages/customer-fcst-upload/customer-fcst-upload.constant.ts | constants | 102 |
| features/demand/src/pages/customer-fcst-upload/customer-fcst-upload.types.ts | types | 68 |
| features/demand/src/pages/customer-fcst-upload/CustomerFcstUpload.tsx | page | 627 |
| features/demand/src/pages/customer-fcst-upload/index.ts | index | 2 |
| features/demand/src/pages/customer-fcst-upload/useCustomerFcstUploadStore.ts | store | 260 |
| features/demand/src/pages/customer-fcst-upload/utils/customer-fcst-upload.api.ts | api | 52 |
| features/demand/src/pages/customer-fcst-upload/utils/customer-fcst-upload.excelForm.ts | util | 223 |
| features/demand/src/pages/customer-fcst-upload/__asis-mapping__.md | mapping | 108 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 2 | Y | CustomerFcstTemplateModal.tsx:70 CustomerFcstUploadForm.tsx:63 |
| DMF0014/FCST Upload//call-proc | hook | 1 | Y | CustomerFcstUpload.tsx:98 |
| DMF0014/spreadTitle//call-proc | hook | 1 | Y | CustomerFcstUpload.tsx:107 |
| DMF0014/dayRange//call-proc | hook | 1 | Y | CustomerFcstUpload.tsx:131 |
| /DMF0014/FCST Upload/SAVE/call-proc | http | 1 | Y | CustomerFcstUpload.tsx:377 |
| DMF0014/spreadTitle/SEARCH/call-proc | callProc | 1 | Y | CustomerFcstUpload.tsx:415 |
| /DMF0014/FCST Upload/UPLOAD_SAVE/call-proc | http | 1 | Y | CustomerFcstUpload.tsx:600 |
| /admin/menu/DMF0014/search-conditions | http | 1 | Y | useCustomerFcstUploadStore.ts:127 |
| /admin/menu/DMF0014/column | http | 1 | Y | useCustomerFcstUploadStore.ts:225 |
| /DMF0014/FCST Upload/FORM_DATA/call-proc | http | 1 | Y | customer-fcst-upload.api.ts:24 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| FCST Upload | divisionId deptId endCustomer scmSiteId plantSiteId projectCode itemId startYyyymmdd endYyyymmdd bucketType domExp createdBy userinfo sesUserId mnuId | o_rc1 | PKG_DMF0014 PR_GET_DAY_RANGE P_DMF0014_SAVE_CUST_FCST_UPLOAD_DATA |
| spreadTitle | startYyyymmdd endYyyymmdd bucketType sesUserId mnuId | o_rc1 | PKG_DMF0014 PR_GET_DAY_RANGE P_DMF0014_SAVE_CUST_FCST_UPLOAD_DATA |
| dayRange | createdBy month | o_rc1 o_rc2 | PKG_DMF0014 PR_GET_DAY_RANGE P_DMF0014_SAVE_CUST_FCST_UPLOAD_DATA |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| g | formatItem | paint | addHandler | features/demand/src/pages/customer-fcst-upload/components/CustomerFcstTemplateModal.tsx | 118 |
| SearchArea | onSearch | handleFind | jsx | features/demand/src/pages/customer-fcst-upload/components/CustomerFcstTemplateModal.tsx | 243 |
| Button | onClick | handleExcel | jsx | features/demand/src/pages/customer-fcst-upload/components/CustomerFcstTemplateModal.tsx | 286 |
| Button | onClick | modalClose | jsx | features/demand/src/pages/customer-fcst-upload/components/CustomerFcstTemplateModal.tsx | 295 |
| CustomDropdown | onChange | <arrow> onPick,String | jsx | features/demand/src/pages/customer-fcst-upload/components/CustomerFcstUploadForm.tsx | 135 |
| SearchArea | onSearch | onSubmit | jsx | features/demand/src/pages/customer-fcst-upload/components/CustomerFcstUploadForm.tsx | 151 |
| CustomDropdown | onChange | <arrow> confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,String,logSearchReset,setSearchParams | jsx | features/demand/src/pages/customer-fcst-upload/components/CustomerFcstUploadForm.tsx | 165 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/demand/src/pages/customer-fcst-upload/components/CustomerFcstUploadForm.tsx | 306 |
| Button | onClick | <arrow> setOpenPrjByDivisionModal | jsx | features/demand/src/pages/customer-fcst-upload/components/CustomerFcstUploadForm.tsx | 300 |
| PeriodField | onChange | <arrow> setSearchParams | jsx | features/demand/src/pages/customer-fcst-upload/components/CustomerFcstUploadForm.tsx | 318 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/demand/src/pages/customer-fcst-upload/components/CustomerFcstUploadForm.tsx | 328 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/demand/src/pages/customer-fcst-upload/components/CustomerFcstUploadForm.tsx | 363 |
| Button | onClick | <arrow> setOpenModelByDivisionModal | jsx | features/demand/src/pages/customer-fcst-upload/components/CustomerFcstUploadForm.tsx | 359 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/demand/src/pages/customer-fcst-upload/components/CustomerFcstUploadForm.tsx | 381 |
| g | formatItem | formatHandler | addHandler | features/demand/src/pages/customer-fcst-upload/components/CustomerFcstUploadGrid.tsx | 188 |
| g | beginningEdit | beginningEditHandler | addHandler | features/demand/src/pages/customer-fcst-upload/components/CustomerFcstUploadGrid.tsx | 204 |
| g | cellEditEnded | cellEditEndedHandler | addHandler | features/demand/src/pages/customer-fcst-upload/components/CustomerFcstUploadGrid.tsx | 213 |
| g | updatedLayout | onLayout | addHandler | features/demand/src/pages/customer-fcst-upload/components/CustomerFcstUploadGrid.tsx | 269 |
| f | filterApplied | onFilterApplied | addHandler | features/demand/src/pages/customer-fcst-upload/components/CustomerFcstUploadGrid.tsx | 296 |
| CustomerFcstUploadForm | onSubmit | handleSearch | jsx | features/demand/src/pages/customer-fcst-upload/CustomerFcstUpload.tsx | 521 |
| CustomerFcstUploadForm | onDivisionChange | resetGrid | jsx | features/demand/src/pages/customer-fcst-upload/CustomerFcstUpload.tsx | 522 |
| CustomerFcstUploadGrid | onCellEdited | handleCellEdited | jsx | features/demand/src/pages/customer-fcst-upload/CustomerFcstUpload.tsx | 543 |
| FcstUploadModal | onSave | <arrow> useSessionStore.getState,apiClient.post,Number | jsx | features/demand/src/pages/customer-fcst-upload/CustomerFcstUpload.tsx | 595 |
| FcstUploadModal | onUploaded | <arrow> queryClient.invalidateQueries | jsx | features/demand/src/pages/customer-fcst-upload/CustomerFcstUpload.tsx | 619 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 7 |
| FormItem | 7 |
| CustomDropdown | 5 |
| Button | 4 |
| SearchArea | 2 |
| DataGrid | 2 |
| FileExceldownloadIcon | 2 |
| InputField | 2 |
| FunctionSearchIcon | 2 |
| CustomDialog | 1 |
| ResultArea | 1 |
| Tooltip | 1 |
| PeriodField | 1 |
| FileExceluploadIcon | 1 |
| MainTitle | 1 |
| CustomerFcstUploadForm | 1 |
| SubTitle | 1 |
| CustomerFcstUploadGrid | 1 |
| ProjectByDivisionModal | 1 |
| ItemByDivisionModal | 1 |
| FcstUploadModal | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| mergedColumns | col.colNm | col.colLblNm \|\| col.colNm | col.colWth ?? 100 | col.visible !== false |  |  | object | features/demand/src/pages/customer-fcst-upload/components/CustomerFcstUploadGrid.tsx | 68 |
| mainStaticColumns | c.binding | c.header | c.width | true |  |  | meta-map | features/demand/src/pages/customer-fcst-upload/components/CustomerFcstUploadGrid.tsx | 95 |
| leaf | r.COLUMN_NAME | r.COLUMN_LABEL \|\| r.COLUMN_NAME.slice(2) | 100 | true |  |  | object | features/demand/src/pages/customer-fcst-upload/components/CustomerFcstUploadGrid.tsx | 123 |
| toPreviewColumns | col.key | col.isValueSlot && col.bucket ? `${col.header} (${col.bucket | 90\|130 | true |  |  | meta-map | features/demand/src/pages/customer-fcst-upload/utils/customer-fcst-upload.excelForm.ts | 176 |

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00674 | 1 |
| LBL00762 | 2 |
| LBL00664 | 1 |
| LBL00001 | 2 |
| LBL00763 | 1 |
| LBL00627 | 1 |
| LBL00112 | 1 |
| LBL00044 | 1 |
| LBL00080 | 1 |
| LBL00011 | 1 |
| LBL00005 | 1 |
| LBL00617 | 1 |
| LBL00710 | 1 |
| LBL00618 | 1 |
| LBL00091 | 1 |
| MSG00667 | 1 |
| MSG01135 | 1 |
| MSG00164 | 1 |
| MSG00429 | 1 |
| MSG01169 | 1 |
| MSG00001 | 1 |
| MSG00380 | 1 |
| MSG00265 | 1 |
| MSG00719 | 1 |
| MSG00137 | 1 |
| MSG00002 | 1 |
| MSG00618 | 1 |
| LBL00346 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: DMF0048(6), DMF0082(5), DMF0014(3), DMF0007(3), DMF0021(3), DMF0003(2), DMF0020(2)
- SP/PKG: PKG_DMF0014(12), PR_GET_DAY_RANGE(10), P_DMF0014_GET_SPREAD_TITLE(5), P_DMF0014_GET_CUST_FCST_UPLOAD_DATA(4), DMF0014_GET_EXCEL_FORM(2), P_DMF0014_GET_EXCEL_FORM_DATA(2), P_DMF0014_SAVE_CUST_FCST_UPLOAD_DATA(2), P_DMF0014_CUST_FCST_EXCEL_UPLOAD(1), FN_SCM_GET_WHERE_SQL(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | import { CustomerFcstTemplateModal } from './components/CustomerFcstTemplateModal'; | features/demand/src/pages/customer-fcst-upload/CustomerFcstUpload.tsx | 19 |
| code | const [openTemplateModal, setOpenTemplateModal] = useState<boolean>(false); | features/demand/src/pages/customer-fcst-upload/CustomerFcstUpload.tsx | 92 |
| code | const handleInsert = () => { | features/demand/src/pages/customer-fcst-upload/CustomerFcstUpload.tsx | 460 |
| code | }); | features/demand/src/pages/customer-fcst-upload/CustomerFcstUpload.tsx | 464 |
| code | }; | features/demand/src/pages/customer-fcst-upload/CustomerFcstUpload.tsx | 465 |
| code | const handleDelete = () => undefined; | features/demand/src/pages/customer-fcst-upload/CustomerFcstUpload.tsx | 469 |
| code | if (!filters[SHEETS.MAIN]) setFilters(); | features/demand/src/pages/customer-fcst-upload/CustomerFcstUpload.tsx | 492 |
| code | setOpenTemplateModal(true); | features/demand/src/pages/customer-fcst-upload/CustomerFcstUpload.tsx | 493 |
| endpoint | ⭐ ui-dynamic-property-management — Column 동적 fetch (SCM_MST_SHEET_COLUMNS 15행, admin 즉시 반영) | features/demand/src/pages/customer-fcst-upload/useCustomerFcstUploadStore.ts | 220 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

