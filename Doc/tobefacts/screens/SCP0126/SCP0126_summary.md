# SCP0126 — To-Be Fact Pack 요약

- page_key: `supply/opt-capa` · feature: supply · As-is Fact Pack 있음
- 파일 22 · 엔드포인트 호출 10 (미해결 2, 주석 속 2) · 이벤트 28 · 컴포넌트 사용 54 · 하드코딩 컬럼 0 · 메시지 39
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/opt-capa/components/modals/NoWorkBatchModal.module.scss | component | 34 |
| features/supply/src/pages/opt-capa/components/modals/NoWorkBatchModal.tsx | component | 409 |
| features/supply/src/pages/opt-capa/components/modals/NoWorkExcelUploadModal.module.scss | component | 49 |
| features/supply/src/pages/opt-capa/components/modals/NoWorkExcelUploadModal.tsx | component | 218 |
| features/supply/src/pages/opt-capa/components/OptCapaForm.tsx | component | 217 |
| features/supply/src/pages/opt-capa/components/OptCapaGrid.tsx | component | 463 |
| features/supply/src/pages/opt-capa/hooks/useOptCapaActions.ts | hook | 520 |
| features/supply/src/pages/opt-capa/hooks/useOptCapaSave.ts | hook | 68 |
| features/supply/src/pages/opt-capa/hooks/useOptCapaSheets.ts | hook | 187 |
| features/supply/src/pages/opt-capa/hooks/useOptCapaValidation.ts | hook | 333 |
| features/supply/src/pages/opt-capa/index.ts | index | 5 |
| features/supply/src/pages/opt-capa/opt-capa.constants.ts | constants | 562 |
| features/supply/src/pages/opt-capa/opt-capa.types.ts | types | 86 |
| features/supply/src/pages/opt-capa/OptCapa.module.scss | style | 9 |
| features/supply/src/pages/opt-capa/OptCapa.tsx | page | 327 |
| features/supply/src/pages/opt-capa/useOptCapaStore.ts | store | 268 |
| features/supply/src/pages/opt-capa/utils/optCapa.candidates.ts | util | 298 |
| features/supply/src/pages/opt-capa/utils/optCapa.editLock.ts | util | 115 |
| features/supply/src/pages/opt-capa/utils/optCapa.excelForm.ts | util | 21 |
| features/supply/src/pages/opt-capa/utils/optCapa.save.ts | util | 341 |
| features/supply/src/pages/opt-capa/utils/optCapa.sheetVisibility.ts | util | 103 |
| features/supply/src/pages/opt-capa/__asis-mapping__.md | mapping | 438 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| /admin/menu/SCP0126/column | http | 2 | Y | NoWorkBatchModal.tsx:82 useOptCapaStore.ts:210 |
| /SCP0126/noWorkBatch/SAVE/call-proc | http | 1 | Y | NoWorkBatchModal.tsx:236 |
| /SCP0126/{ADMIN_SHEET_NAME[SHEETS.NO_WORK]}/UPLOAD/excel-upload | http | 1 | N | NoWorkExcelUploadModal.tsx:81 |
| /SCP0126/noWork\|dailyCapa\|sopEop\|rampUp\|rampUpItvl\|prepRt\|utilRt\|yldElec/SAVE/call-proc | http | 1 | Y | useOptCapaSave.ts:53 |
| (useTabComboQueries) | hook | 2 | Y | useOptCapaSheets.ts:53 useOptCapaSheets.ts:57 |
| SCP0126/init//call-proc | hook | 1 | Y | useOptCapaSheets.ts:94 |
| SCP0126/{?refSheet}//call-proc | hook | 1 | N | OptCapa.tsx:119 |
| /admin/menu/SCP0126/search-conditions | http | 1 | Y | useOptCapaStore.ts:244 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| init |  | o_rc1 o_rc2 o_rc3 o_rc4 o_rc5 o_rc6 | P_SCP0126_GET_CAPA_SEARCH_INFO P_SCP0126_SAVE_NO_WORK_BATCH |
| noWork | divisionId planGrId fromYyyymm toYyyymm plantId lineId nickName itemId | o_rc1 | P_SCP0126_GET_CAPA_SEARCH_INFO P_SCP0126_SAVE_NO_WORK_BATCH |
| noWorkWeek | divisionId planGrId fromYyyymm toYyyymm plantId lineId nickName itemId | o_rc1 | P_SCP0126_GET_CAPA_SEARCH_INFO P_SCP0126_SAVE_NO_WORK_BATCH |
| noWorkBatch | divisionId lineId startDate endDate seq offTime type desc sesUserId | o_rc1 | P_SCP0126_GET_CAPA_SEARCH_INFO P_SCP0126_SAVE_NO_WORK_BATCH |
| dailyCapa | divisionId planGrId fromYyyymm toYyyymm plantId lineId nickName itemId | o_rc1 | P_SCP0126_GET_CAPA_SEARCH_INFO P_SCP0126_SAVE_NO_WORK_BATCH |
| sopEop | divisionId planGrId fromYyyymm toYyyymm plantId lineId nickName itemId | o_rc1 | P_SCP0126_GET_CAPA_SEARCH_INFO P_SCP0126_SAVE_NO_WORK_BATCH |
| rampUp | divisionId planGrId fromYyyymm toYyyymm plantId lineId nickName itemId | o_rc1 | P_SCP0126_GET_CAPA_SEARCH_INFO P_SCP0126_SAVE_NO_WORK_BATCH |
| rampUpItvl | divisionId planGrId fromYyyymm toYyyymm plantId lineId nickName itemId | o_rc1 | P_SCP0126_GET_CAPA_SEARCH_INFO P_SCP0126_SAVE_NO_WORK_BATCH |
| prepRt | divisionId planGrId fromYyyymm toYyyymm plantId lineId nickName itemId | o_rc1 | P_SCP0126_GET_CAPA_SEARCH_INFO P_SCP0126_SAVE_NO_WORK_BATCH |
| utilRt | divisionId planGrId fromYyyymm toYyyymm plantId lineId nickName itemId | o_rc1 | P_SCP0126_GET_CAPA_SEARCH_INFO P_SCP0126_SAVE_NO_WORK_BATCH |
| yldElec | divisionId planGrId fromYyyymm toYyyymm plantId lineId nickName itemId | o_rc1 | P_SCP0126_GET_CAPA_SEARCH_INFO P_SCP0126_SAVE_NO_WORK_BATCH |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| CustomDropdown | onChange | <arrow> onPick,String(picked??'').split(',').filter,String(picked??'').split,String | jsx | features/supply/src/pages/opt-capa/components/modals/NoWorkBatchModal.tsx | 296 |
| InputField | onChange | <arrow> setWeeks | jsx | features/supply/src/pages/opt-capa/components/modals/NoWorkBatchModal.tsx | 351 |
| InputField | onKeyDown | <arrow> handleSearch | jsx | features/supply/src/pages/opt-capa/components/modals/NoWorkBatchModal.tsx | 352 |
| InputField | onChange | <arrow> setPeriod | jsx | features/supply/src/pages/opt-capa/components/modals/NoWorkBatchModal.tsx | 361 |
| InputField | onChange | <arrow> setPeriod | jsx | features/supply/src/pages/opt-capa/components/modals/NoWorkBatchModal.tsx | 366 |
| Button | onClick | handleSearch | jsx | features/supply/src/pages/opt-capa/components/modals/NoWorkBatchModal.tsx | 373 |
| Button | onClick | handleSave | jsx | features/supply/src/pages/opt-capa/components/modals/NoWorkBatchModal.tsx | 394 |
| Button | onClick | onClose | jsx | features/supply/src/pages/opt-capa/components/modals/NoWorkBatchModal.tsx | 401 |
| FileUploader | onFileChange | <arrow> setAlert,t,setFiles,value.slice,resetResult | jsx | features/supply/src/pages/opt-capa/components/modals/NoWorkExcelUploadModal.tsx | 153 |
| Button | onClick | <arrow> handleUpload | jsx | features/supply/src/pages/opt-capa/components/modals/NoWorkExcelUploadModal.tsx | 177 |
| Button | onClick | handleClose | jsx | features/supply/src/pages/opt-capa/components/modals/NoWorkExcelUploadModal.tsx | 181 |
| CustomDropdown | onChange | <arrow> onPick,String | jsx | features/supply/src/pages/opt-capa/components/OptCapaForm.tsx | 84 |
| CustomDropdown | onChange | <arrow> onPick,String(picked??'').split(',').filter,String(picked??'').split,String | jsx | features/supply/src/pages/opt-capa/components/OptCapaForm.tsx | 114 |
| InputField | onChange | <arrow> onChange | jsx | features/supply/src/pages/opt-capa/components/OptCapaForm.tsx | 139 |
| InputField | onKeyDown | <arrow> onSearch | jsx | features/supply/src/pages/opt-capa/components/OptCapaForm.tsx | 140 |
| SearchArea | onSearch | onSearch | jsx | features/supply/src/pages/opt-capa/components/OptCapaForm.tsx | 151 |
| PeriodField | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/opt-capa/components/OptCapaForm.tsx | 191 |
| grid | formatItem | formatItemHandler | addHandler | features/supply/src/pages/opt-capa/components/OptCapaGrid.tsx | 285 |
| grid | beginningEdit | beginningEditHandler | addHandler | features/supply/src/pages/opt-capa/components/OptCapaGrid.tsx | 316 |
| grid | cellEditEnded | cellEditEndedHandler | addHandler | features/supply/src/pages/opt-capa/components/OptCapaGrid.tsx | 380 |
| grid | pastingCell | pastingCellHandler | addHandler | features/supply/src/pages/opt-capa/components/OptCapaGrid.tsx | 389 |
| grid | pastedCell | pastedCellHandler | addHandler | features/supply/src/pages/opt-capa/components/OptCapaGrid.tsx | 415 |
| grid.hostElement | dblclick | dblClickHandler | addEventListener | features/supply/src/pages/opt-capa/components/OptCapaGrid.tsx | 433 |
| OptCapaForm | onSearch | actions.handleSearch | jsx | features/supply/src/pages/opt-capa/OptCapa.tsx | 233 |
| OptCapaGrid | onItemCellDblClick | actions.openItemPopup | jsx | features/supply/src/pages/opt-capa/OptCapa.tsx | 273 |
| NoWorkBatchModal | onClose | actions.closeBatch | jsx | features/supply/src/pages/opt-capa/OptCapa.tsx | 286 |
| NoWorkBatchModal | onSaved | actions.refreshAfterExternalSave | jsx | features/supply/src/pages/opt-capa/OptCapa.tsx | 287 |
| NoWorkExcelUploadModal | onUploaded | actions.refreshAfterExternalSave | jsx | features/supply/src/pages/opt-capa/OptCapa.tsx | 294 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| FormItem | 10 |
| Grid | 7 |
| InputField | 5 |
| Button | 5 |
| CustomDropdown | 3 |
| TextField | 3 |
| CustomDialog | 2 |
| ProgressIndicator | 2 |
| DataGrid | 2 |
| ResultArea | 1 |
| FileUploader | 1 |
| ControlConfirmIcon | 1 |
| Label | 1 |
| SearchArea | 1 |
| PeriodField | 1 |
| MainTitle | 1 |
| OptCapaForm | 1 |
| SubTitle | 1 |
| TabWrapper | 1 |
| TabItem | 1 |
| OptCapaGrid | 1 |
| NoWorkBatchModal | 1 |
| NoWorkExcelUploadModal | 1 |
| ItemByDivisionModal | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| MSG01340 | 1 |
| MSG01149 | 1 |
| MSG00667 | 1 |
| MSG00429 | 2 |
| MSG00672 | 1 |
| MSG00003 | 1 |
| MSG00703 | 1 |
| MSG00004 | 1 |
| MSG00428 | 1 |
| MSG01427 | 1 |
| MSG01081 | 1 |
| MSG01082 | 1 |
| MSG00105 | 1 |
| MSG00108 | 1 |
| MSG00165 | 1 |
| MSG00330 | 1 |
| MSG00265 | 1 |
| MSG01068 | 1 |
| MSG01385 | 1 |
| LBL00001 | 1 |
| LBL00002 | 1 |
| LBL00013 | 1 |
| LBL00030 | 1 |
| LBL00010 | 1 |
| LBL00767 | 1 |
| LBL00669 | 1 |
| LBL00112 | 1 |
| LBL00414 | 1 |
| LBL00346 | 1 |
| LBL00762 | 1 |
| LBL01056 | 1 |
| LBL00716 | 1 |
| LBL00107 | 1 |
| LBL00759 | 1 |
| LBL00754 | 1 |
| LBL00755 | 1 |
| LBL00756 | 1 |
| LBL00757 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0126(6), SCP0006(4), SCP0005(3), SCM0008(2), SCP0114(2), SCP0120(1), SSP0025(1), SCP0025(1)
- SP/PKG: PKG_SCP0126(5), P_SPLIT(4), P_SCP0126_SAVE_NO_WORK_BATCH(2), P_RESULT_ERR(1), P_RESULT_OK(1), P_LINE_ID(1), P_VALUE(1), P_PLANT_ID(1), P_DIVISION_ID(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| endpoint | admin `SCM_MST_SHEET_COLUMNS` 동적 fetch(8시트) — 미등록/실패 시 빈 배열 유지(hook #113 §1-3). | features/supply/src/pages/opt-capa/useOptCapaStore.ts | 35 |
| endpoint | 저장 payload 조립 — SAVE SP 8종의 `all_arguments`/`SCM_ADM_PROC_M` 실측 계약 이식(design 03 §4.3). 전 SP 가 `activeFlag` 로 시작하는 **컬럼별 `'^'`-결합 CLOB** + 마지막 `sesUserId`(VARCHAR) 규약이다. 키명은 `SCM_ADM_PROC_M.COL_NM` **camelCase** 그대로다 (메모리 `scp-proc-m-colnm-i | features/supply/src/pages/opt-capa/utils/optCapa.save.ts | 19 |

## 10. __asis-mapping__.md 상태
- 구현: 95
- 해당없음: 7
- 제외: 5
| design_id | summary | reason | status |
|---|---|---|---|
| D00-1-009 | §1 components / System.ComponentModel.Container | WinForms 디자이너 비가시 컨테이너(`System.ComponentModel.Container`) — React 대응 불필요 | 해당없음 |
| D00-1-010 | §1 emptySpaceItem1 / DevExpress.XtraLayout.EmptySpaceItem | DevExpress LayoutControl 여백 아이템 — MUI `Grid` 반응형 레이아웃이 자동 처리, 개별 React 대응 불필요 | 해당없음 |
| D00-1-011 | §1 emptySpaceItem2 / DevExpress.XtraLayout.EmptySpaceItem | D00-1-010 과 동일 사유 | 해당없음 |
| D00-1-014 | §1 layoutControlItem1 / DevExpress.XtraLayout.LayoutControlItem | DevExpress 개별 필드 wrapper — MUI `Grid`/`FormItem` 으로 대체, 1:1 대응 불필요 | 해당없음 |
| D00-1-015 | §1 layoutControlItem2 / DevExpress.XtraLayout.LayoutControlItem | D00-1-014 과 동일 사유 | 해당없음 |
| D00-1-016 | §1 layoutControlItem3 / DevExpress.XtraLayout.LayoutControlItem | D00-1-014 과 동일 사유 | 해당없음 |
| D00-1-017 | §1 layoutControlItem9 / DevExpress.XtraLayout.LayoutControlItem | D00-1-014 과 동일 사유 | 해당없음 |
| D00-1-018 | §1 lciBatchSave / DevExpress.XtraLayout.LayoutControlItem | 버튼을 SubTitle 로 올려 '래퍼 표시 = 버튼 표시' 로 흡수(C-25 와 동일) | 제외 |
| D00-1-019 | §1 lciExcelForm / DevExpress.XtraLayout.LayoutControlItem | C-23 과 동일 사유 | 제외 |
| D00-1-020 | §1 lciExcelUpload / DevExpress.XtraLayout.LayoutControlItem | C-21 과 동일 사유 | 제외 |
| D00-1-029 | §1 usrLayoutControl1 / GSCM.Windows.Forms.Controls.UsrLayoutControl | C-01 과 동일 — `this.Controls.Add` 없음, dead 컨트롤 | 제외 |
| D00-3-006 | §3 SwitchLock / `()` | EditButton 토글 어포던스 자체는 전 화면 미이식 결정(asis_to_tobe.md §11, 2026-09-23) — 단 기존행 재편집 시 잠금 범위 재현 여부는 별도 검증 필요 | 제외 |

