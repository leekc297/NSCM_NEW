# SCP0126 — To-Be Fact Pack 요약

- page_key: `supply/opt-capa` · feature: supply · As-is Fact Pack 있음
- 파일 24 · 엔드포인트 호출 12 (미해결 4, 주석 속 2) · 이벤트 42 · 컴포넌트 사용 64 · 하드코딩 컬럼 2 · 메시지 49
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 2건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/opt-capa/components/modals/NoWorkBatchModal.module.scss | component | 39 |
| features/supply/src/pages/opt-capa/components/modals/NoWorkBatchModal.tsx | component | 484 |
| features/supply/src/pages/opt-capa/components/modals/NoWorkExcelUploadModal.module.scss | component | 56 |
| features/supply/src/pages/opt-capa/components/modals/NoWorkExcelUploadModal.tsx | component | 350 |
| features/supply/src/pages/opt-capa/components/modals/NoWorkWeekModal.tsx | component | 73 |
| features/supply/src/pages/opt-capa/components/OptCapaForm.tsx | component | 229 |
| features/supply/src/pages/opt-capa/components/OptCapaGrid.tsx | component | 595 |
| features/supply/src/pages/opt-capa/hooks/useOptCapaActions.tsx | hook | 628 |
| features/supply/src/pages/opt-capa/hooks/useOptCapaSave.ts | hook | 69 |
| features/supply/src/pages/opt-capa/hooks/useOptCapaSheets.ts | hook | 193 |
| features/supply/src/pages/opt-capa/hooks/useOptCapaValidation.ts | hook | 424 |
| features/supply/src/pages/opt-capa/index.ts | index | 5 |
| features/supply/src/pages/opt-capa/opt-capa.constants.ts | constants | 684 |
| features/supply/src/pages/opt-capa/opt-capa.types.ts | types | 89 |
| features/supply/src/pages/opt-capa/OptCapa.module.scss | style | 9 |
| features/supply/src/pages/opt-capa/OptCapa.tsx | page | 426 |
| features/supply/src/pages/opt-capa/useOptCapaStore.ts | store | 275 |
| features/supply/src/pages/opt-capa/utils/optCapa.candidates.ts | util | 315 |
| features/supply/src/pages/opt-capa/utils/optCapa.editLock.ts | util | 115 |
| features/supply/src/pages/opt-capa/utils/optCapa.excelForm.ts | util | 21 |
| features/supply/src/pages/opt-capa/utils/optCapa.save.ts | util | 474 |
| features/supply/src/pages/opt-capa/utils/optCapa.sheetVisibility.ts | util | 125 |
| features/supply/src/pages/opt-capa/utils/optCapa.week.ts | util | 30 |
| features/supply/src/pages/opt-capa/__asis-mapping__.md | mapping | 438 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| /admin/menu/SCP0126/column | http | 2 | Y | NoWorkBatchModal.tsx:95 useOptCapaStore.ts:217 |
| /SCP0126/noWorkBatch/SAVE/call-proc | http | 1 | Y | NoWorkBatchModal.tsx:305 |
| /SCP0126/{ADMIN_SHEET_NAME[SHEETS.NO_WORK]}/UPLOAD/excel-upload | http | 1 | N | NoWorkExcelUploadModal.tsx:159 |
| /SCP0126/{sheet}/SAVE/call-proc | http | 1 | N | useOptCapaSave.ts:54 |
| (useTabComboQueries) | hook | 2 | Y | useOptCapaSheets.ts:57 useOptCapaSheets.ts:61 |
| SCP0126/init//call-proc | hook | 1 | Y | useOptCapaSheets.ts:98 |
| SCP0126/{?querySheet}//call-proc | hook | 1 | N | OptCapa.tsx:149 |
| /SCP0126/{ADMIN_SHEET_NAME[SHEETS.NO_WORK]}/UPLOAD_SAVE/call-proc | http | 1 | N | OptCapa.tsx:376 |
| /admin/menu/SCP0126/search-conditions | http | 1 | Y | useOptCapaStore.ts:251 |
| /SCP0126/noWorkWeek\|noWork\|dailyCapa\|sopEop\|rampUp\|rampUpItvl\|prepRt\|utilRt\|yldElec/SAVE/call-proc | propagated | 1 | Y | useOptCapaActions.tsx:398 |

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
| CustomDropdown | onChange | <arrow> onPick,String(picked??'').split(',').filter,String(picked??'').split,String | jsx | features/supply/src/pages/opt-capa/components/modals/NoWorkBatchModal.tsx | 368 |
| SearchArea | onSearch | handleSearch | jsx | features/supply/src/pages/opt-capa/components/modals/NoWorkBatchModal.tsx | 405 |
| InputField | onChange | <arrow> setWeeks | jsx | features/supply/src/pages/opt-capa/components/modals/NoWorkBatchModal.tsx | 434 |
| InputField | onKeyDown | <arrow> handleSearch | jsx | features/supply/src/pages/opt-capa/components/modals/NoWorkBatchModal.tsx | 435 |
| PeriodRangePicker | onChange | <arrow> setPeriod | jsx | features/supply/src/pages/opt-capa/components/modals/NoWorkBatchModal.tsx | 444 |
| Button | onClick | handleSave | jsx | features/supply/src/pages/opt-capa/components/modals/NoWorkBatchModal.tsx | 469 |
| Button | onClick | onClose | jsx | features/supply/src/pages/opt-capa/components/modals/NoWorkBatchModal.tsx | 476 |
| FileUploader | onFileChange | <arrow> setAlert,t,setFiles,value.slice,resetResult | jsx | features/supply/src/pages/opt-capa/components/modals/NoWorkExcelUploadModal.tsx | 275 |
| Button | onClick | <arrow> handleSave | jsx | features/supply/src/pages/opt-capa/components/modals/NoWorkExcelUploadModal.tsx | 299 |
| Button | onClick | <arrow> handleClose | jsx | features/supply/src/pages/opt-capa/components/modals/NoWorkExcelUploadModal.tsx | 303 |
| Popover | onClose | onClose | jsx | features/supply/src/pages/opt-capa/components/modals/NoWorkWeekModal.tsx | 37 |
| DatePickerCalendar | onChange | <arrow> setDate | jsx | features/supply/src/pages/opt-capa/components/modals/NoWorkWeekModal.tsx | 47 |
| Button | onClick | <arrow> onSelect,onClose | jsx | features/supply/src/pages/opt-capa/components/modals/NoWorkWeekModal.tsx | 56 |
| Button | onClick | onClose | jsx | features/supply/src/pages/opt-capa/components/modals/NoWorkWeekModal.tsx | 66 |
| CustomDropdown | onChange | <arrow> onPick,String | jsx | features/supply/src/pages/opt-capa/components/OptCapaForm.tsx | 92 |
| CustomDropdown | onChange | <arrow> onPick,String(picked??'').split(',').filter,String(picked??'').split,String | jsx | features/supply/src/pages/opt-capa/components/OptCapaForm.tsx | 122 |
| SearchArea | onSearch | onSearch | jsx | features/supply/src/pages/opt-capa/components/OptCapaForm.tsx | 135 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/opt-capa/components/OptCapaForm.tsx | 199 |
| InputField | onKeyDown | <arrow> onSearch | jsx | features/supply/src/pages/opt-capa/components/OptCapaForm.tsx | 200 |
| Button | onClick | onModelSearch | jsx | features/supply/src/pages/opt-capa/components/OptCapaForm.tsx | 195 |
| PeriodField | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/opt-capa/components/OptCapaForm.tsx | 214 |
| grid | formatItem | formatItemHandler | addHandler | features/supply/src/pages/opt-capa/components/OptCapaGrid.tsx | 360 |
| grid | beginningEdit | beginningEditHandler | addHandler | features/supply/src/pages/opt-capa/components/OptCapaGrid.tsx | 391 |
| grid | prepareCellForEdit | prepareCellForEditHandler | addHandler | features/supply/src/pages/opt-capa/components/OptCapaGrid.tsx | 406 |
| input? | beforeinput | guardNumberCellMaxOnInput | addEventListener | features/supply/src/pages/opt-capa/components/OptCapaGrid.tsx | 419 |
| grid | prepareCellForEdit | prepareNumberCellHandler | addHandler | features/supply/src/pages/opt-capa/components/OptCapaGrid.tsx | 421 |
| grid | cellEditEnded | cellEditEndedHandler | addHandler | features/supply/src/pages/opt-capa/components/OptCapaGrid.tsx | 489 |
| grid | pastingCell | pastingCellHandler | addHandler | features/supply/src/pages/opt-capa/components/OptCapaGrid.tsx | 508 |
| grid | pastedCell | pastedCellHandler | addHandler | features/supply/src/pages/opt-capa/components/OptCapaGrid.tsx | 534 |
| grid.hostElement | dblclick | dblClickHandler | addEventListener | features/supply/src/pages/opt-capa/components/OptCapaGrid.tsx | 563 |
| OptCapaForm | onSearch | actions.handleSearch | jsx | features/supply/src/pages/opt-capa/OptCapa.tsx | 280 |
| OptCapaForm | onModelSearch | <arrow> setOpenModelPopup | jsx | features/supply/src/pages/opt-capa/OptCapa.tsx | 281 |
| OptCapaGrid | onItemCellDblClick | actions.openItemPopup | jsx | features/supply/src/pages/opt-capa/OptCapa.tsx | 324 |
| OptCapaGrid | onWeekCellDblClick | actions.showWeekPopup | jsx | features/supply/src/pages/opt-capa/OptCapa.tsx | 325 |
| NoWorkBatchModal | onClose | actions.closeBatch | jsx | features/supply/src/pages/opt-capa/OptCapa.tsx | 340 |
| NoWorkBatchModal | onSaved | actions.refreshAfterExternalSave | jsx | features/supply/src/pages/opt-capa/OptCapa.tsx | 341 |
| NoWorkWeekModal | onClose | actions.closeWeekPopup | jsx | features/supply/src/pages/opt-capa/OptCapa.tsx | 363 |
| NoWorkWeekModal | onSelect | actions.handleWeekSelect | jsx | features/supply/src/pages/opt-capa/OptCapa.tsx | 364 |
| NoWorkExcelUploadModal | onUploaded | actions.refreshAfterExternalSave | jsx | features/supply/src/pages/opt-capa/OptCapa.tsx | 371 |
| NoWorkExcelUploadModal | onSave | <arrow> apiClient.post,Number | jsx | features/supply/src/pages/opt-capa/OptCapa.tsx | 372 |
| ModelByDivisionPopup | onClose | actions.closeItemPopup | jsx | features/supply/src/pages/opt-capa/OptCapa.tsx | 411 |
| ModelByDivisionPopup | onSelect | <arrow> actions.handleItemSelect,str | jsx | features/supply/src/pages/opt-capa/OptCapa.tsx | 413 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| FormItem | 10 |
| Grid | 7 |
| Button | 7 |
| CustomDropdown | 4 |
| DataGrid | 3 |
| TextField | 3 |
| CustomDialog | 2 |
| ProgressIndicator | 2 |
| SearchArea | 2 |
| InputField | 2 |
| PeriodRangePicker | 1 |
| ResultArea | 1 |
| FileUploader | 1 |
| ControlConfirmIcon | 1 |
| Label | 1 |
| Popover | 1 |
| DatePickerCalendar | 1 |
| FunctionSearchIcon | 1 |
| PeriodField | 1 |
| FileExceldownloadIcon | 1 |
| FileExceluploadIcon | 1 |
| MainTitle | 1 |
| OptCapaForm | 1 |
| SubTitle | 1 |
| TabWrapper | 1 |
| TabItem | 1 |
| OptCapaGrid | 1 |
| NoWorkBatchModal | 1 |
| MaterialByDivisionModal | 1 |
| NoWorkWeekModal | 1 |
| NoWorkExcelUploadModal | 1 |
| ModelByDivisionPopup | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| RESULT_COLUMNS | `ATTRIBUTE${i + 1}` | label | 110 | true |  |  | meta-map | features/supply/src/pages/opt-capa/components/modals/NoWorkExcelUploadModal.tsx | 77 |
| RESULT_COLUMNS | MESSAGE_TEXT | Message | 240 | true |  |  | meta-shape | features/supply/src/pages/opt-capa/components/modals/NoWorkExcelUploadModal.tsx | 86 |

## 7. 메시지 코드
| code | count |
|---|---|
| MSG00684 | 1 |
| MSG00618 | 3 |
| MSG00657 | 1 |
| MSG00152 | 1 |
| MSG00659 | 1 |
| MSG00002 | 1 |
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
| MSG00700 | 1 |
| MSG00108 | 1 |
| MSG00165 | 1 |
| MSG00330 | 1 |
| MSG00265 | 1 |
| MSG01068 | 1 |
| MSG01385 | 1 |
| MSG01190 | 1 |
| LBL00001 | 1 |
| LBL00002 | 1 |
| LBL00013 | 1 |
| LBL00030 | 1 |
| LBL00010 | 1 |
| LBL00767 | 1 |
| LBL00669 | 1 |
| LBL00618 | 1 |
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
- 화면ID: SCP0126(10), SCP0006(4), SCP0005(3), SCM0008(2), SCP0114(2), DMF0009(1), SCP0120(1), SSP0025(1), SCP0031(1), SCM0002(1), COM0008(1), SCP0025(1)
- SP/PKG: PKG_SCP0126(11), P_SPLIT(4), P_SCP0126_SAVE_NO_WORK_BATCH(2), P_RESULT_ERR(1), P_RESULT_OK(1), P_SCP0126_GET(1), P_LINE_ID(1), P_VALUE(1), PKG_SCM0002(1), P_PLANT_ID(1), P_DIVISION_ID(1), P_PRE_TYPE(1), P_SCP0126_SAVE_NO_WORK_WEEK(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| jsx | **버튼 가시성은 권한별이다** — 각 키에 `authorized && hasButton('<BTN_CD>')` 게이트를 곱한다. 권한(`SCM_ADM_USER_GR_MNU_BTN_MPG_M` → `/admin/menu/SCP0126/auth` → `hasButton`)이 있으면 실제 핸들러를, 없으면 `false` 를 둔다. 공용 `SubTitle` 은 값이 `false` 인 버튼을 렌더하지 않으므로 (`SubTitle.ts | features/supply/src/pages/opt-capa/hooks/useOptCapaActions.tsx | 511 |
| code | No Work **Week** — 라인·주 단위 Off Time 합계 7 초과 차단 (AS-IS `Save_NoWork_Week` cs:1719~1753). Week 모드에서만 돈다(`isWeekNoWork`). 그룹키는 AS-IS 와 동일하게 전극(`EE*`)이면 `LINE_TYPE` 포함, 아니면 제외(cs:1723·1728). 합계 대상은 삭제행을 뺀 저장행의 `OFF_TIME`(일 단위 — GET 이 초/86400 로  | features/supply/src/pages/opt-capa/hooks/useOptCapaValidation.ts | 366 |
| endpoint | admin `SCM_MST_SHEET_COLUMNS` 동적 fetch(8시트) — 미등록/실패 시 빈 배열 유지(hook #113 §1-3). | features/supply/src/pages/opt-capa/useOptCapaStore.ts | 36 |
| endpoint | 저장 payload 조립 — SAVE SP 8종의 `all_arguments`/`SCM_ADM_PROC_M` 실측 계약 이식(design 03 §4.3). 전 SP 가 `activeFlag` 로 시작하는 **컬럼별 `'^'`-결합 CLOB** + 마지막 `sesUserId`(VARCHAR) 규약이다. 키명은 `SCM_ADM_PROC_M.COL_NM` **camelCase** 그대로다 (메모리 `scp-proc-m-colnm-i | features/supply/src/pages/opt-capa/utils/optCapa.save.ts | 21 |
| code | #5 전송 정렬키 — AS-IS `saveData.OrderByDescending(x => x.Key)`(cs:1897) 의 복합키. `division^plant^line^operation^line_type^week_name(ISO)^type('-')` 로 **내림차순** 정렬해 보낸다. 복수 Type 이 같은 주/라인의 일별 용량(86400s)을 나눠 채우는 순서를 결정하므로(SP DML BODY:4621-4643) AS-I | features/supply/src/pages/opt-capa/utils/optCapa.save.ts | 425 |
| code | #5 AS-IS OrderByDescending(x => x.Key) 등가 — 복합키 내림차순(문자열 비교). | features/supply/src/pages/opt-capa/utils/optCapa.save.ts | 461 |

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

