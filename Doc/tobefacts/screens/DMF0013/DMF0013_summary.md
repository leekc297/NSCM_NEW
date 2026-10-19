# DMF0013 — To-Be Fact Pack 요약

- page_key: `demand/cust-psi-upload` · feature: demand · As-is Fact Pack 있음
- 파일 11 · 엔드포인트 호출 9 (미해결 0, 주석 속 2) · 이벤트 27 · 컴포넌트 사용 45 · 하드코딩 컬럼 5 · 메시지 22
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 사용 · 하드코딩 컬럼 정의 5건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/demand/src/pages/cust-psi-upload/components/CustPsiTemplateModal.module.scss | component | 40 |
| features/demand/src/pages/cust-psi-upload/components/CustPsiTemplateModal.tsx | component | 274 |
| features/demand/src/pages/cust-psi-upload/components/CustPsiUploadForm.tsx | component | 258 |
| features/demand/src/pages/cust-psi-upload/components/CustPsiUploadGrid.tsx | component | 348 |
| features/demand/src/pages/cust-psi-upload/cust-psi-upload.constant.ts | constants | 206 |
| features/demand/src/pages/cust-psi-upload/cust-psi-upload.types.ts | types | 67 |
| features/demand/src/pages/cust-psi-upload/CustPsiUpload.tsx | page | 543 |
| features/demand/src/pages/cust-psi-upload/index.ts | index | 2 |
| features/demand/src/pages/cust-psi-upload/useCustPsiUploadStore.ts | store | 164 |
| features/demand/src/pages/cust-psi-upload/utils/cust-psi-upload.api.ts | api | 49 |
| features/demand/src/pages/cust-psi-upload/utils/cust-psi-upload.excelForm.ts | util | 193 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 2 | Y | CustPsiTemplateModal.tsx:61 CustPsiUploadForm.tsx:46 |
| DMF0013/PSI Upload//call-proc | hook | 1 | Y | CustPsiUpload.tsx:97 |
| DMF0013/spreadTitle//call-proc | hook | 1 | Y | CustPsiUpload.tsx:106 |
| DMF0013/dayRange//call-proc | hook | 1 | Y | CustPsiUpload.tsx:117 |
| /DMF0013/PSI Upload/SAVE/call-proc | http | 1 | Y | CustPsiUpload.tsx:364 |
| /DMF0013/PSI Upload/UPLOAD_SAVE/call-proc | http | 1 | Y | CustPsiUpload.tsx:516 |
| /admin/menu/DMF0013/column | http | 1 | Y | useCustPsiUploadStore.ts:132 |
| /DMF0013/PSI Upload/FORM_DATA/call-proc | http | 1 | Y | cust-psi-upload.api.ts:21 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| PSI Upload | divisionId deptId endCustomer scmSiteId plantSiteId projectCode itemId startYyyymmdd endYyyymmdd bucketType domExp createdBy userinfo sesUserId mnuId | o_rc1 | DMF0014_GET_SPREAD_TITLE PR_GET_DAY_RANGE P_DMF0013_SAVE_CUST_PSI_UPLOAD_DATA |
| spreadTitle | startYyyymmdd endYyyymmdd bucketType sesUserId mnuId | o_rc1 | DMF0014_GET_SPREAD_TITLE PR_GET_DAY_RANGE P_DMF0013_SAVE_CUST_PSI_UPLOAD_DATA |
| dayRange | createdBy month | o_rc1 o_rc2 | DMF0014_GET_SPREAD_TITLE PR_GET_DAY_RANGE P_DMF0013_SAVE_CUST_PSI_UPLOAD_DATA |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| g | formatItem | paint | addHandler | features/demand/src/pages/cust-psi-upload/components/CustPsiTemplateModal.tsx | 102 |
| SearchArea | onSearch | handleFind | jsx | features/demand/src/pages/cust-psi-upload/components/CustPsiTemplateModal.tsx | 214 |
| Button | onClick | handleExcel | jsx | features/demand/src/pages/cust-psi-upload/components/CustPsiTemplateModal.tsx | 257 |
| Button | onClick | modalClose | jsx | features/demand/src/pages/cust-psi-upload/components/CustPsiTemplateModal.tsx | 266 |
| SearchArea | onSearch | onSubmit | jsx | features/demand/src/pages/cust-psi-upload/components/CustPsiUploadForm.tsx | 58 |
| DivisionField | onChange | <arrow> setSearchParams,onDivisionChange | jsx | features/demand/src/pages/cust-psi-upload/components/CustPsiUploadForm.tsx | 65 |
| TeamField | onChange | <arrow> setSearchParams,v.join | jsx | features/demand/src/pages/cust-psi-upload/components/CustPsiUploadForm.tsx | 87 |
| EndCustomerField | onChange | <arrow> setSearchParams,values.join | jsx | features/demand/src/pages/cust-psi-upload/components/CustPsiUploadForm.tsx | 108 |
| SalesSiteField | onChange | <arrow> setSearchParams,values.join | jsx | features/demand/src/pages/cust-psi-upload/components/CustPsiUploadForm.tsx | 123 |
| PlantSiteField | onChange | <arrow> setSearchParams,v.join | jsx | features/demand/src/pages/cust-psi-upload/components/CustPsiUploadForm.tsx | 131 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/demand/src/pages/cust-psi-upload/components/CustPsiUploadForm.tsx | 164 |
| FunctionSearchIcon | onClick | <arrow> setOpenPrjByDivisionModal | jsx | features/demand/src/pages/cust-psi-upload/components/CustPsiUploadForm.tsx | 156 |
| PeriodField | onChange | <arrow> setSearchParams | jsx | features/demand/src/pages/cust-psi-upload/components/CustPsiUploadForm.tsx | 176 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/demand/src/pages/cust-psi-upload/components/CustPsiUploadForm.tsx | 186 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/demand/src/pages/cust-psi-upload/components/CustPsiUploadForm.tsx | 225 |
| FunctionSearchIcon | onClick | <arrow> setOpenModelByDivisionModal | jsx | features/demand/src/pages/cust-psi-upload/components/CustPsiUploadForm.tsx | 219 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/demand/src/pages/cust-psi-upload/components/CustPsiUploadForm.tsx | 243 |
| g | formatItem | formatHandler | addHandler | features/demand/src/pages/cust-psi-upload/components/CustPsiUploadGrid.tsx | 217 |
| g | beginningEdit | beginningEditHandler | addHandler | features/demand/src/pages/cust-psi-upload/components/CustPsiUploadGrid.tsx | 228 |
| g | cellEditEnded | cellEditEndedHandler | addHandler | features/demand/src/pages/cust-psi-upload/components/CustPsiUploadGrid.tsx | 237 |
| g | updatedLayout | onLayout | addHandler | features/demand/src/pages/cust-psi-upload/components/CustPsiUploadGrid.tsx | 291 |
| f | filterApplied | onFilterApplied | addHandler | features/demand/src/pages/cust-psi-upload/components/CustPsiUploadGrid.tsx | 321 |
| CustPsiUploadForm | onSubmit | handleSearch | jsx | features/demand/src/pages/cust-psi-upload/CustPsiUpload.tsx | 440 |
| CustPsiUploadForm | onDivisionChange | resetGrid | jsx | features/demand/src/pages/cust-psi-upload/CustPsiUpload.tsx | 441 |
| CustPsiUploadGrid | onCellEdited | handleCellEdited | jsx | features/demand/src/pages/cust-psi-upload/CustPsiUpload.tsx | 462 |
| FcstUploadModal | onSave | <arrow> useSessionStore.getState,apiClient.post,Number | jsx | features/demand/src/pages/cust-psi-upload/CustPsiUpload.tsx | 513 |
| FcstUploadModal | onUploaded | <arrow> queryClient.invalidateQueries | jsx | features/demand/src/pages/cust-psi-upload/CustPsiUpload.tsx | 535 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 5 |
| FormItem | 5 |
| Button | 4 |
| CustomDropdown | 3 |
| SearchArea | 2 |
| DataGrid | 2 |
| FileExceldownloadIcon | 2 |
| InputField | 2 |
| FunctionSearchIcon | 2 |
| CustomDialog | 1 |
| ResultArea | 1 |
| Tooltip | 1 |
| DivisionField | 1 |
| TeamField | 1 |
| EndCustomerField | 1 |
| SalesSiteField | 1 |
| PlantSiteField | 1 |
| PeriodField | 1 |
| FileExceluploadIcon | 1 |
| MainTitle | 1 |
| CustPsiUploadForm | 1 |
| SubTitle | 1 |
| CustPsiUploadGrid | 1 |
| ProjectByDivisionModal | 1 |
| ItemByDivisionModal | 1 |
| CustPsiTemplateModal | 1 |
| FcstUploadModal | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| mergedColumns | c.key | c.header | c.width ?? 100 | c.visible !== false |  |  | object | features/demand/src/pages/cust-psi-upload/components/CustPsiUploadGrid.tsx | 84 |
| mergedColumns | col.colNm | col.colLblNm \|\| fb?.header \|\| col.colNm | col.colWth ?? fb?.width ?? 100 | col.visible !== false |  |  | object | features/demand/src/pages/cust-psi-upload/components/CustPsiUploadGrid.tsx | 104 |
| mainStaticColumns | c.binding | c.header | c.width | true |  |  | meta-map | features/demand/src/pages/cust-psi-upload/components/CustPsiUploadGrid.tsx | 128 |
| leaf | r.COLUMN_NAME | r.COLUMN_LABEL \|\| r.COLUMN_NAME.slice(2) | 100 | true |  |  | object | features/demand/src/pages/cust-psi-upload/components/CustPsiUploadGrid.tsx | 157 |
| toPreviewColumns | col.key | col.isValueSlot && col.bucket ? `${col.header} (${col.bucket | 90\|130 | true |  |  | meta-map | features/demand/src/pages/cust-psi-upload/utils/cust-psi-upload.excelForm.ts | 153 |

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00674 | 1 |
| LBL00762 | 2 |
| LBL00664 | 1 |
| LBL00001 | 1 |
| LBL00763 | 1 |
| LBL00627 | 1 |
| LBL00112 | 1 |
| LBL00617 | 1 |
| LBL00710 | 1 |
| LBL00618 | 1 |
| LBL00091 | 1 |
| MSG00097 | 1 |
| MSG00108 | 1 |
| MSG00164 | 1 |
| MSG00429 | 1 |
| MSG00152 | 1 |
| MSG00719 | 1 |
| MSG00137 | 1 |
| MSG00002 | 1 |
| MSG00618 | 1 |
| LBL00346 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: DMF0014(17), DMF0013(8), DMF0082(3), DMF0048(2), DMF0043(1), DMF0020(1), DMF0003(1)
- SP/PKG: PR_GET_DAY_RANGE(8), DMF0014_GET_SPREAD_TITLE(7), DMF0013_GET_CUST_PSI_UPLOAD_DATA(5), DMF0013_SAVE_CUST_PSI_UPLOAD_DATA(3), FN_SCM_GET_WHERE_SQL(1), DMF0013_GET_EXCEL_FORM(1), PKG_DMF0013(1), P_DMF0013_GET_EXCEL_FORM_DATA(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| endpoint | 식별 컬럼 fallback — 정본은 admin 동적 fetch(fetchStaticColumns). 본 fallback 은 BE 메타 미응답 시 작동 보장용. | features/demand/src/pages/cust-psi-upload/cust-psi-upload.constant.ts | 77 |
| endpoint | ui-dynamic-property-management — Column 동적 fetch (SCM_MST_SHEET_COLUMNS, admin 즉시 반영) | features/demand/src/pages/cust-psi-upload/useCustPsiUploadStore.ts | 129 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

