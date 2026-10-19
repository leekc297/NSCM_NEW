# demand_components_fcst-upload-modal — To-Be Fact Pack 요약

- page_key: `demand/components/fcst-upload-modal` · feature: demand · As-is Fact Pack 없음(화면ID 미대응)
- 파일 2 · 엔드포인트 호출 1 (미해결 1, 주석 속 0) · 이벤트 4 · 컴포넌트 사용 18 · 하드코딩 컬럼 1 · 메시지 23
- Grid 컬럼 출처: 메타(/column·titleSet) 미사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 1건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/demand/src/components/fcst-upload-modal/FcstUploadModal.module.scss | style | 69 |
| features/demand/src/components/fcst-upload-modal/FcstUploadModal.tsx | page | 431 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| /{menuId}/{sheetName}/UPLOAD/excel-upload | http | 1 | N | FcstUploadModal.tsx:156 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| FileUploader | onFileChange | <arrow> setAlert,t,setFiles,value.slice,resetResult | jsx | features/demand/src/components/fcst-upload-modal/FcstUploadModal.tsx | 330 |
| Button | onClick | <arrow> handleSave | jsx | features/demand/src/components/fcst-upload-modal/FcstUploadModal.tsx | 365 |
| Button | onClick | <arrow> handleUpload | jsx | features/demand/src/components/fcst-upload-modal/FcstUploadModal.tsx | 374 |
| Button | onClick | <arrow> handleClose | jsx | features/demand/src/components/fcst-upload-modal/FcstUploadModal.tsx | 382 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| FormItem | 4 |
| Button | 3 |
| TextField | 3 |
| ControlConfirmIcon | 2 |
| Label | 2 |
| CustomDialog | 1 |
| ProgressIndicator | 1 |
| FileUploader | 1 |
| DataGrid | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| errorColumns | k | labelOf(k) | 60\|140 | true |  |  | meta-map | features/demand/src/components/fcst-upload-modal/FcstUploadModal.tsx | 125 |

## 7. 메시지 코드
| code | count |
|---|---|
| MSG00113 | 1 |
| MSG00618 | 4 |
| MSG00659 | 1 |
| MSG00265 | 1 |
| MSG00684 | 1 |
| MSG00658 | 1 |
| MSG00657 | 1 |
| MSG00152 | 1 |
| MSG00001 | 1 |
| MSG00606 | 1 |
| LBL00346 | 1 |
| LBL00759 | 1 |
| LBL00716 | 2 |
| LBL00107 | 1 |
| LBL00754 | 1 |
| LBL00755 | 1 |
| LBL00756 | 1 |
| LBL00757 | 1 |
| LBL00758 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: DMF0014(8), DMF0074(2)
- SP/PKG: PR_GET_EXCEL_UPLOAD_RESULT(2), P_DMF0074_EXCEL_UPLOAD(1), P_MODE(1), PR_SAVE_EXCEL_UPLOAD(1), PKG_DMF0014(1), P_DMF0014_CUST_FCST_EXCEL_UPLOAD(1), P_COL_CNT(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
(없음)

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

