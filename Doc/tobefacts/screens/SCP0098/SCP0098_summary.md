# SCP0098 — To-Be Fact Pack 요약

- page_key: `supply/capa-mobility-it` · feature: supply · As-is Fact Pack 없음(화면ID 미대응)
- 파일 20 · 엔드포인트 호출 10 (미해결 0, 주석 속 0) · 이벤트 31 · 컴포넌트 사용 38 · 하드코딩 컬럼 1 · 메시지 24
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 1건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/capa-mobility-it/capa-mobility-it.constants.ts | constants | 104 |
| features/supply/src/pages/capa-mobility-it/capa-mobility-it.types.ts | types | 18 |
| features/supply/src/pages/capa-mobility-it/CapaMobilityIt.module.scss | style | 6 |
| features/supply/src/pages/capa-mobility-it/CapaMobilityIt.tsx | page | 377 |
| features/supply/src/pages/capa-mobility-it/components/CapaMobilityItForm.tsx | component | 172 |
| features/supply/src/pages/capa-mobility-it/components/CapaMobilityItGrid.tsx | component | 333 |
| features/supply/src/pages/capa-mobility-it/components/modals/BulkUpdateModal.module.scss | component | 13 |
| features/supply/src/pages/capa-mobility-it/components/modals/BulkUpdateModal.tsx | component | 117 |
| features/supply/src/pages/capa-mobility-it/components/modals/CopySelectModal.module.scss | component | 47 |
| features/supply/src/pages/capa-mobility-it/components/modals/CopySelectModal.tsx | component | 100 |
| features/supply/src/pages/capa-mobility-it/components/modals/index.ts | index | 3 |
| features/supply/src/pages/capa-mobility-it/hooks/useCapaMobilityItValidation.ts | hook | 18 |
| features/supply/src/pages/capa-mobility-it/index.ts | index | 2 |
| features/supply/src/pages/capa-mobility-it/useCapaMobilityItStore.ts | store | 198 |
| features/supply/src/pages/capa-mobility-it/utils/capa-mobility-it.api.ts | api | 45 |
| features/supply/src/pages/capa-mobility-it/utils/capa-mobility-it.bulkInput.ts | util | 154 |
| features/supply/src/pages/capa-mobility-it/utils/capa-mobility-it.dynamicColumns.ts | util | 235 |
| features/supply/src/pages/capa-mobility-it/utils/capa-mobility-it.editLock.ts | util | 36 |
| features/supply/src/pages/capa-mobility-it/utils/capa-mobility-it.save.ts | util | 99 |
| features/supply/src/pages/capa-mobility-it/__asis-mapping__.md | mapping | 264 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| SCP0098/main//call-proc | hook | 1 | Y | CapaMobilityIt.tsx:91 |
| SCP0098/capaProductRate//call-proc | hook | 1 | Y | CapaMobilityIt.tsx:123 |
| SCP0098/capaMonth//call-proc | hook | 1 | Y | CapaMobilityIt.tsx:130 |
| SCP0098/capaWork//call-proc | hook | 1 | Y | CapaMobilityIt.tsx:137 |
| /SCP0098/copy/SAVE/call-proc | http | 1 | Y | CapaMobilityIt.tsx:210 |
| (useTabComboQueries) | hook | 1 | Y | CapaMobilityItForm.tsx:46 |
| /admin/menu/SCP0098/column | http | 1 | Y | useCapaMobilityItStore.ts:135 |
| /admin/menu/SCP0098/measure | http | 1 | Y | useCapaMobilityItStore.ts:153 |
| /admin/menu/SCP0098/search-conditions | http | 1 | Y | useCapaMobilityItStore.ts:175 |
| /SCP0098/titleSet/SAVE/call-proc | http | 1 | Y | capa-mobility-it.api.ts:34 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| main | todayYyyymmdd fromYyyymmdd toYyyymmdd divisionId plantId lineId operationId modelId itemId nickName bucket userId debugMode | o_rc o_result_cursor | PKG_SCP0098 P_SNAKE P_GET_CAPA_MOBILITYIT P_SAVE_SCP_CAPA_PRODUCT_RATE P_SAVE_SCP_CAPA P_SAVE_SCP_CAPA_WORK P_COPY_MONTH_WEEK |
| capaProductRate | activeFlag divisionId plantId factoryId operationId lineId startYyyymmdd endYyyymmdd productRate userId | row | PKG_SCP0098 P_SNAKE P_GET_CAPA_MOBILITYIT P_SAVE_SCP_CAPA_PRODUCT_RATE P_SAVE_SCP_CAPA P_SAVE_SCP_CAPA_WORK P_COPY_MONTH_WEEK |
| capaMonth | activeFlag divisionId plantId factoryId operationId lineId itemId yyyymm value userId | row | PKG_SCP0098 P_SNAKE P_GET_CAPA_MOBILITYIT P_SAVE_SCP_CAPA_PRODUCT_RATE P_SAVE_SCP_CAPA P_SAVE_SCP_CAPA_WORK P_COPY_MONTH_WEEK |
| capaWork | activeFlag divisionId plantId factoryId operationId lineId measure yyyymmdd value userId | row | PKG_SCP0098 P_SNAKE P_GET_CAPA_MOBILITYIT P_SAVE_SCP_CAPA_PRODUCT_RATE P_SAVE_SCP_CAPA P_SAVE_SCP_CAPA_WORK P_COPY_MONTH_WEEK |
| copy | userId dayType debugMode | o_result_cursor | PKG_SCP0098 P_SNAKE P_GET_CAPA_MOBILITYIT P_SAVE_SCP_CAPA_PRODUCT_RATE P_SAVE_SCP_CAPA P_SAVE_SCP_CAPA_WORK P_COPY_MONTH_WEEK |
| titleSet | programId sheetName columnType divisionId | o_rc1 | PKG_SCP0098 P_SNAKE P_GET_CAPA_MOBILITYIT P_SAVE_SCP_CAPA_PRODUCT_RATE P_SAVE_SCP_CAPA P_SAVE_SCP_CAPA_WORK P_COPY_MONTH_WEEK |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| CapaMobilityItForm | onSearch | <arrow> handleSearch | jsx | features/supply/src/pages/capa-mobility-it/CapaMobilityIt.tsx | 297 |
| BulkUpdateModal | onClose | <arrow> setBulkOpen | jsx | features/supply/src/pages/capa-mobility-it/CapaMobilityIt.tsx | 346 |
| BulkUpdateModal | onConfirm | handleBulkConfirm | jsx | features/supply/src/pages/capa-mobility-it/CapaMobilityIt.tsx | 347 |
| CopySelectModal | onClose | <arrow> setCopyOpen | jsx | features/supply/src/pages/capa-mobility-it/CapaMobilityIt.tsx | 350 |
| CopySelectModal | onConfirm | <arrow> handleCopy | jsx | features/supply/src/pages/capa-mobility-it/CapaMobilityIt.tsx | 350 |
| MeasureSelectModal | onApply | <arrow> staticMeasures.map,saveTitleSet('M',selected.map((name,i)=>({name,sortOrderNo:i+1}))).then,saveTitleSet,selected.map,setAlert,t | jsx | features/supply/src/pages/capa-mobility-it/CapaMobilityIt.tsx | 358 |
| CustomDropdown | onChange | <arrow> onPick,str(picked).split(',').filter,str(picked).split,str,v.toUpperCase | jsx | features/supply/src/pages/capa-mobility-it/components/CapaMobilityItForm.tsx | 76 |
| SearchArea | onSearch | onSearch | jsx | features/supply/src/pages/capa-mobility-it/components/CapaMobilityItForm.tsx | 94 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/capa-mobility-it/components/CapaMobilityItForm.tsx | 137 |
| InputField | onKeyDown | <arrow> onSearch | jsx | features/supply/src/pages/capa-mobility-it/components/CapaMobilityItForm.tsx | 138 |
| Button | onClick | <arrow> setOpenItem | jsx | features/supply/src/pages/capa-mobility-it/components/CapaMobilityItForm.tsx | 133 |
| PeriodRangePicker | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/capa-mobility-it/components/CapaMobilityItForm.tsx | 148 |
| editor | beforeinput | <arrow> /[^0-9.-]/.test,ev.preventDefault | addEventListener | features/supply/src/pages/capa-mobility-it/components/CapaMobilityItGrid.tsx | 236 |
| editor | input | <arrow> keepNumeric | addEventListener | features/supply/src/pages/capa-mobility-it/components/CapaMobilityItGrid.tsx | 239 |
| editor | compositionend | keepNumeric | addEventListener | features/supply/src/pages/capa-mobility-it/components/CapaMobilityItGrid.tsx | 242 |
| g | beginningEdit | beginningEditHandler | addHandler | features/supply/src/pages/capa-mobility-it/components/CapaMobilityItGrid.tsx | 245 |
| g | prepareCellForEdit | prepareCellForEditHandler | addHandler | features/supply/src/pages/capa-mobility-it/components/CapaMobilityItGrid.tsx | 246 |
| g | pastingCell | beginningEditHandler | addHandler | features/supply/src/pages/capa-mobility-it/components/CapaMobilityItGrid.tsx | 247 |
| g | cellEditEnded | cellEditEndedHandler | addHandler | features/supply/src/pages/capa-mobility-it/components/CapaMobilityItGrid.tsx | 248 |
| g | pastedCell | cellEditEndedHandler | addHandler | features/supply/src/pages/capa-mobility-it/components/CapaMobilityItGrid.tsx | 249 |
| g | formatItem | formatHandler | addHandler | features/supply/src/pages/capa-mobility-it/components/CapaMobilityItGrid.tsx | 250 |
| g | updatedLayout | applyHeaderHeight | addHandler | features/supply/src/pages/capa-mobility-it/components/CapaMobilityItGrid.tsx | 274 |
| g | updatedLayout | applyVisibility | addHandler | features/supply/src/pages/capa-mobility-it/components/CapaMobilityItGrid.tsx | 305 |
| CustomDropdown | onChange | <arrow> setType,String | jsx | features/supply/src/pages/capa-mobility-it/components/modals/BulkUpdateModal.tsx | 75 |
| InputField | onChange | <arrow> setValue | jsx | features/supply/src/pages/capa-mobility-it/components/modals/BulkUpdateModal.tsx | 89 |
| InputField | onKeyDown | <arrow> handleOk | jsx | features/supply/src/pages/capa-mobility-it/components/modals/BulkUpdateModal.tsx | 90 |
| Button | onClick | <arrow> handleOk | jsx | features/supply/src/pages/capa-mobility-it/components/modals/BulkUpdateModal.tsx | 102 |
| Button | onClick | onClose | jsx | features/supply/src/pages/capa-mobility-it/components/modals/BulkUpdateModal.tsx | 109 |
| input | onChange | <arrow> setDayType | jsx | features/supply/src/pages/capa-mobility-it/components/modals/CopySelectModal.tsx | 66 |
| Button | onClick | <arrow> onConfirm,onClose | jsx | features/supply/src/pages/capa-mobility-it/components/modals/CopySelectModal.tsx | 82 |
| Button | onClick | onClose | jsx | features/supply/src/pages/capa-mobility-it/components/modals/CopySelectModal.tsx | 92 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 7 |
| FormItem | 5 |
| Button | 5 |
| InputField | 3 |
| CustomDropdown | 2 |
| CustomDialog | 2 |
| MainTitle | 1 |
| CapaMobilityItForm | 1 |
| SubTitle | 1 |
| IcMeasureSelect | 1 |
| ProgressIndicator | 1 |
| CapaMobilityItGrid | 1 |
| BulkUpdateModal | 1 |
| CopySelectModal | 1 |
| MeasureSelectModal | 1 |
| SearchArea | 1 |
| FunctionSearchIcon | 1 |
| PeriodRangePicker | 1 |
| ItemByDivisionModal | 1 |
| DataGrid | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| buildDynamicColumns | m.binding | hasDaily ? (m.kind === 'D' ? m.leaf : m.small) : m.small | 80 | true |  |  | object | features/supply/src/pages/capa-mobility-it/utils/capa-mobility-it.dynamicColumns.ts | 110 |

## 7. 메시지 코드
| code | count |
|---|---|
| MSG00001 | 1 |
| MSG00002 | 1 |
| MSG00004 | 1 |
| MSG00618 | 1 |
| MSG00108 | 1 |
| LBL00001 | 1 |
| LBL00005 | 1 |
| LBL00010 | 1 |
| LBL00013 | 1 |
| LBL00618 | 1 |
| LBL00112 | 1 |
| LBL01064 | 1 |
| LBL00310 | 1 |
| LBL01066 | 1 |
| LBL01084 | 1 |
| LBL00716 | 1 |
| LBL00627 | 1 |
| MSG00000 | 7 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0098(9), DMF0082(1), SSP0060(1), SCP0009(1)
- SP/PKG: P_COPY_MONTH_WEEK(4), PKG_SCP0098(3), P_SAVE_SCP_CAPA_WORK(3), P_GET_CAPA_MOBILITYIT(1), P_SAVE_SCP_CAPA_PRODUCT_RATE(1), P_SAVE_SCP_CAPA(1), P_DAY_TYPE(1), SCM0001_GET_SCP_DAY_PERIOD(1), SCM0002_SET_TITLESET_POPUP(1), P_ACTIVE_FLAG(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
(없음)

## 10. __asis-mapping__.md 상태
- 구현: 84
- 제외: 14
- 해당없음: 14
| design_id | summary | reason | status |
|---|---|---|---|
| D00-1-006 | §1 cboBucketType / UsrCombo | To-Be 문서(SCP0098) Bucket 조회조건 삭제 — `DEFAULT_BUCKET`(DAILY) 고정 | 제외 |
| D00-1-010 | §1 chkDetail / UsrCheckBox | To-Be 문서(SCP0098) Detail 체크박스 삭제 — Daily 는 일(`D_`) 컬럼만 표시하고 월(`M_`)은 숨김(AS-IS Detail 체크 상태와 동일, `visibleKinds`), 2026-10-13 확정 | 제외 |
| D00-1-013 | §1 components / Container | 디자이너 컨테이너(WinForms IContainer) — React 컴포넌트 트리로 대체, 대사 대상 아님 | 해당없음 |
| D00-1-015 | §1 emptySpaceItem1 / EmptySpaceItem | LayoutControl 여백 — CSS/Grid 레이아웃으로 대체, 대사 대상 아님 | 해당없음 |
| D00-1-016 | §1 emptySpaceItem2 / EmptySpaceItem | LayoutControl 여백 — CSS/Grid 레이아웃으로 대체, 대사 대상 아님 | 해당없음 |
| D00-1-017 | §1 emptySpaceItem3 / EmptySpaceItem | LayoutControl 여백 — CSS/Grid 레이아웃으로 대체, 대사 대상 아님 | 해당없음 |
| D00-1-018 | §1 emptySpaceItem4 / EmptySpaceItem | LayoutControl 여백 — CSS/Grid 레이아웃으로 대체, 대사 대상 아님 | 해당없음 |
| D00-1-019 | §1 layoutControlGroup2 / LayoutControlGroup | WinForms 레이아웃 그룹 컨테이너 — SearchArea/Grid 구성으로 대체 | 해당없음 |
| D00-1-032 | §1 layoutControlItem9 / LayoutControlItem | To-Be 문서(SCP0098) Bucket 삭제 | 제외 |
| D00-1-033 | §1 lblBucket / LayoutControlItem | To-Be 문서(SCP0098) Bucket 삭제 | 제외 |
| D00-1-035 | §1 spdMain_Sheet1 / SheetView | 단일 그리드로 통합(spdInfo 별도 시트 미이식, §5 R8/C3) | 해당없음 |
| D00-1-038 | §1 txtNickName / TextBox | To-Be 문서(SCP0098) Nick Name 조회조건 삭제 — Model/Nickname 에 통합, `nickName` 은 '' 고정 전송 | 제외 |
| D00-1-039 | §1 usrButton1 / UsrButton | AS-IS x/y=0·tabIndex=0 용도불명 숨김 컨트롤(00_checklist §1 확인필요) — 실동작 없음, 미이식 | 제외 |
| D00-1-041 | §1 usrLayoutControl2 / UsrLayoutControl | WinForms 레이아웃 컨트롤 컨테이너 — React 레이아웃으로 대체 | 해당없음 |
| D00-2-005 | §2 cboBucketType / SelectedIndexChanged | To-Be 문서(SCP0098) Bucket 삭제 | 제외 |
| D00-2-006 | §2 cboDivision / SelectedIndexChanged | Division '40' 고정·비활성(AS-IS cs L182~183) — cascade 재적재 이벤트 발생 안 함 | 해당없음 |
| D00-2-007 | §2 chkDetail / CheckedChanged | To-Be 문서(SCP0098) Detail 삭제 | 제외 |
| D00-2-010 | §2 spdMain / CellClick | 셀 클릭 단독 파생 로직 없음(AS-IS 본문 NO-OP) — Wijmo 기본 선택 동작으로 등가 | 해당없음 |
| D00-2-011 | §2 spdMain / CellDoubleClick | AS-IS SetDblClickColumnShowHide(pivot 드릴 후보) 미이식 — 컬럼 show/hide 는 chkDetail/Column 설정으로 대체(§5 C2/04 기재) | 제외 |
| D00-2-014 | §2 spdMain / TopChange | FpSpread 가상스크롤 top 변경 배관 — Wijmo 네이티브 스크롤로 등가, 파생 로직 없음 | 해당없음 |
| D00-3-001 | §3 ChangeActiveSheet / 260 | FpSpread 다중시트 전환 — 단일 DataGrid 로 통합, 시트 전환 개념 부재 | 해당없음 |
| D00-3-002 | §3 SmartColMerge / 275 | spdInfo(정보시트) 컬럼 머지 — 별도 info 시트 미이식(§5 R8/C3, 04 기재) | 제외 |
| D00-3-013 | §3 SwitchLock / 430 | EditButton 토글 어포던스 자체는 전 화면 미이식 결정(asis_to_tobe.md §11, 2026-09-23) — 단 기존행 재편집 시 잠금 범위 재현 여부는 별도 검증 필요 | 제외 |
| D00-3-026 | §3 SetActiveCell / 766 | FpSpread 저장 후 선택셀 복원 배관 — Wijmo 편집 유지로 등가, 파생 로직 없음 | 해당없음 |
| D00-3-027 | §3 ShowCell / 767 | FpSpread 선택셀 스크롤 표시 배관 — Wijmo 네이티브 스크롤로 등가 | 해당없음 |
| D00-3-032 | §3 SwitchLockEx / 2405 | EditButton 토글 어포던스 자체는 전 화면 미이식 결정(asis_to_tobe.md §11, 2026-09-23) — 저장 후 잠금 토글 미이식(편집 기본 ON) | 제외 |
| D00-3-033 | §3 SwitchLockEx / 2744 | EditButton 토글 어포던스 자체는 전 화면 미이식 결정(asis_to_tobe.md §11, 2026-09-23) — 저장 후 잠금 토글 미이식(편집 기본 ON) | 제외 |
| D00-3-043 | §3 SetDblClickColumnShowHide / 3719 | 더블클릭 pivot 컬럼 show/hide 미이식 — chkDetail/Column 설정 모달로 대체(§5 C2, 04 기재) | 제외 |

