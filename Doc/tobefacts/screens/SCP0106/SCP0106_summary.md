# SCP0106 — To-Be Fact Pack 요약

- page_key: `supply/capa-loss-plan` · feature: supply · As-is Fact Pack 있음
- 파일 21 · 엔드포인트 호출 7 (미해결 0, 주석 속 2) · 이벤트 30 · 컴포넌트 사용 58 · 하드코딩 컬럼 1 · 메시지 28
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 사용 · 하드코딩 컬럼 정의 1건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/capa-loss-plan/capa-loss-plan.constants.ts | constants | 504 |
| features/supply/src/pages/capa-loss-plan/capa-loss-plan.types.ts | types | 175 |
| features/supply/src/pages/capa-loss-plan/CapaLossPlan.tsx | page | 351 |
| features/supply/src/pages/capa-loss-plan/components/CapaLossPlanColumnModal.tsx | component | 79 |
| features/supply/src/pages/capa-loss-plan/components/CapaLossPlanForm.tsx | component | 446 |
| features/supply/src/pages/capa-loss-plan/components/CapaLossPlanGrid.module.scss | component | 26 |
| features/supply/src/pages/capa-loss-plan/components/CapaLossPlanGrid.tsx | component | 343 |
| features/supply/src/pages/capa-loss-plan/components/CapaLossPlanItemPopup.tsx | component | 56 |
| features/supply/src/pages/capa-loss-plan/hooks/useCapaLossPlanCellEdit.ts | hook | 162 |
| features/supply/src/pages/capa-loss-plan/hooks/useCapaLossPlanCombos.ts | hook | 315 |
| features/supply/src/pages/capa-loss-plan/hooks/useCapaLossPlanQuery.ts | hook | 159 |
| features/supply/src/pages/capa-loss-plan/hooks/useCapaLossPlanSave.ts | hook | 210 |
| features/supply/src/pages/capa-loss-plan/index.ts | index | 2 |
| features/supply/src/pages/capa-loss-plan/useCapaLossPlanStore.ts | store | 417 |
| features/supply/src/pages/capa-loss-plan/utils/capaLossPlan.combos.ts | util | 463 |
| features/supply/src/pages/capa-loss-plan/utils/capaLossPlan.dateColumns.ts | util | 176 |
| features/supply/src/pages/capa-loss-plan/utils/capaLossPlan.editLock.ts | util | 211 |
| features/supply/src/pages/capa-loss-plan/utils/capaLossPlan.recalc.ts | util | 424 |
| features/supply/src/pages/capa-loss-plan/utils/capaLossPlan.save.ts | util | 207 |
| features/supply/src/pages/capa-loss-plan/utils/capaLossPlan.sheetKey.ts | util | 115 |
| features/supply/src/pages/capa-loss-plan/__asis-mapping__.md | mapping | 249 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 1 | Y | useCapaLossPlanCombos.ts:81 |
| SCP0106/{?Exclude<SHEETS, SHEETS.SPREAD_TITLE>}//call-proc | hook | 1 | Y | useCapaLossPlanQuery.ts:78 |
| SCP0106/spreadTitle//call-proc | hook | 1 | Y | useCapaLossPlanQuery.ts:86 |
| /SCP0106/{?Exclude<SHEETS, SHEETS.SPREAD_TITLE>}/SAVE/call-proc | http | 1 | Y | useCapaLossPlanSave.ts:125 |
| /admin/menu/SCP0106/search-conditions | http | 1 | Y | useCapaLossPlanStore.ts:203 |
| /admin/menu/SCP0106/column | http | 1 | Y | useCapaLossPlanStore.ts:355 |
| /admin/menu/SCP0106/measure | http | 1 | Y | useCapaLossPlanStore.ts:382 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| CapaLossPlanForm | onSearch | handleSearch | jsx | features/supply/src/pages/capa-loss-plan/CapaLossPlan.tsx | 307 |
| CapaLossPlanForm | onOpenItemPopup | <arrow> setOpenItemPopup | jsx | features/supply/src/pages/capa-loss-plan/CapaLossPlan.tsx | 308 |
| CapaLossPlanGrid | onCellEditEnded | handleCellEditEnded | jsx | features/supply/src/pages/capa-loss-plan/CapaLossPlan.tsx | 337 |
| CapaLossPlanColumnModal | onClose | <arrow> setOpenColumnSetting | jsx | features/supply/src/pages/capa-loss-plan/CapaLossPlan.tsx | 342 |
| CapaLossPlanItemPopup | onClose | <arrow> setOpenItemPopup | jsx | features/supply/src/pages/capa-loss-plan/CapaLossPlan.tsx | 347 |
| ColumnLayoutModal | onSave | <arrow> applyColumnLayout,settings.map,Number,String,clearFilters,onClose | jsx | features/supply/src/pages/capa-loss-plan/components/CapaLossPlanColumnModal.tsx | 60 |
| SearchArea | onSearch | onSearch | jsx | features/supply/src/pages/capa-loss-plan/components/CapaLossPlanForm.tsx | 106 |
| CustomDropdown | onChange | <arrow> String,confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,setDivision | jsx | features/supply/src/pages/capa-loss-plan/components/CapaLossPlanForm.tsx | 123 |
| CustomDropdown | onChange | <arrow> setSearchCondition,String | jsx | features/supply/src/pages/capa-loss-plan/components/CapaLossPlanForm.tsx | 143 |
| CustomDropdown | onChange | <arrow> setSearchCondition,String | jsx | features/supply/src/pages/capa-loss-plan/components/CapaLossPlanForm.tsx | 158 |
| CustomDropdown | onChange | <arrow> setProgressStatus,String | jsx | features/supply/src/pages/capa-loss-plan/components/CapaLossPlanForm.tsx | 184 |
| CustomDropdown | onChange | <arrow> setSearchCondition,String | jsx | features/supply/src/pages/capa-loss-plan/components/CapaLossPlanForm.tsx | 201 |
| CustomDropdown | onChange | <arrow> setDivisionType,String | jsx | features/supply/src/pages/capa-loss-plan/components/CapaLossPlanForm.tsx | 226 |
| CustomDropdown | onChange | <arrow> setSearchCondition,String | jsx | features/supply/src/pages/capa-loss-plan/components/CapaLossPlanForm.tsx | 247 |
| CustomDropdown | onChange | <arrow> setSearchCondition,String | jsx | features/supply/src/pages/capa-loss-plan/components/CapaLossPlanForm.tsx | 273 |
| CustomDropdown | onChange | <arrow> setSearchCondition,String | jsx | features/supply/src/pages/capa-loss-plan/components/CapaLossPlanForm.tsx | 299 |
| CustomDropdown | onChange | <arrow> setSearchCondition,String | jsx | features/supply/src/pages/capa-loss-plan/components/CapaLossPlanForm.tsx | 323 |
| CustomDropdown | onChange | <arrow> setSearchCondition,String | jsx | features/supply/src/pages/capa-loss-plan/components/CapaLossPlanForm.tsx | 352 |
| CustomDropdown | onChange | <arrow> setSearchCondition,String | jsx | features/supply/src/pages/capa-loss-plan/components/CapaLossPlanForm.tsx | 376 |
| InputField | onChange | <arrow> setSearchCondition | jsx | features/supply/src/pages/capa-loss-plan/components/CapaLossPlanForm.tsx | 404 |
| InputField | onDoubleClick | onOpenItemPopup | jsx | features/supply/src/pages/capa-loss-plan/components/CapaLossPlanForm.tsx | 405 |
| FunctionSearchIcon | onClick | onOpenItemPopup | jsx | features/supply/src/pages/capa-loss-plan/components/CapaLossPlanForm.tsx | 413 |
| Checkbox | onChange | <arrow> setSearchCondition,Boolean | jsx | features/supply/src/pages/capa-loss-plan/components/CapaLossPlanForm.tsx | 435 |
| grid | formatItem | formatItemHandler | addHandler | features/supply/src/pages/capa-loss-plan/components/CapaLossPlanGrid.tsx | 192 |
| grid | beginningEdit | beginningEditHandler | addHandler | features/supply/src/pages/capa-loss-plan/components/CapaLossPlanGrid.tsx | 209 |
| grid | pastingCell | pastingCellHandler | addHandler | features/supply/src/pages/capa-loss-plan/components/CapaLossPlanGrid.tsx | 220 |
| grid | cellEditEnded | cellEditEndedHandler | addHandler | features/supply/src/pages/capa-loss-plan/components/CapaLossPlanGrid.tsx | 238 |
| grid.hostElement? | keydown | keyDownHandler | addEventListener | features/supply/src/pages/capa-loss-plan/components/CapaLossPlanGrid.tsx | 272 |
| CapaItemPopup | onClose | onClose | jsx | features/supply/src/pages/capa-loss-plan/components/CapaLossPlanItemPopup.tsx | 41 |
| CapaItemPopup | onSelect | <arrow> selectedAll.map(item=>sc.divisionType===DIVISION_TYPE.ELTR?toStr(item.itemId):toStr(item.nickName)).filter,selectedAll.map,toStr,Array.from(newSet(values)).join,Array.from,setSearchCondition | jsx | features/supply/src/pages/capa-loss-plan/components/CapaLossPlanItemPopup.tsx | 43 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 15 |
| FormItem | 15 |
| CustomDropdown | 12 |
| InputField | 2 |
| IcGridColumnSetup | 1 |
| MainTitle | 1 |
| CapaLossPlanForm | 1 |
| SubTitle | 1 |
| CapaLossPlanGrid | 1 |
| CapaLossPlanColumnModal | 1 |
| CapaLossPlanItemPopup | 1 |
| ColumnLayoutModal | 1 |
| SearchArea | 1 |
| Button | 1 |
| FunctionSearchIcon | 1 |
| Checkbox | 1 |
| DataGrid | 1 |
| CapaItemPopup | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| buildPeriodColumns | row.COLUMN_NAME | String(row.COLUMN_LABEL_NAME ?? row.COLUMN_NAME) | columnWidth | true |  |  | object | features/supply/src/pages/capa-loss-plan/utils/capaLossPlan.dateColumns.ts | 143 |

## 7. 메시지 코드
| code | count |
|---|---|
| MSG00667 | 1 |
| MSG01406 | 1 |
| MSG01454 | 1 |
| MSG00096 | 1 |
| MSG00672 | 1 |
| MSG00006 | 1 |
| MSG00133 | 1 |
| LBL00605 | 3 |
| LBL00764 | 1 |
| LBL00765 | 1 |
| LBL00038 | 1 |
| LBL01059 | 1 |
| LBL00112 | 1 |
| LBL00001 | 1 |
| LBL00053 | 1 |
| LBL00606 | 1 |
| LBL00014 | 1 |
| LBL00015 | 1 |
| LBL00030 | 1 |
| LBL00008 | 1 |
| LBL00010 | 1 |
| LBL00009 | 1 |
| LBL00056 | 1 |
| LBL00054 | 1 |
| LBL00669 | 1 |
| LBL01117 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0105(29), SCP0106(14), SCP0104(2), SCP0006(1), SCP0020(1)
- SP/PKG: PKG_SCP0106(7), PKG_SCP0104(3), P_SCP0104_GET_SPREAD_TITLE(3), P_SCP0106_GET_CAPA_LOSS_PLAN_(1), P_SCP0106_SAVE_CAPA_LOSS_PLAN_(1), PKG_NSCM_UI_COM_MENU(1), PR_GET_SHEET_COLUMN_LIST(1), SCP0104_GET_SPREAD_TITLE(1), SCP0106_SAVE_CAPA_LOSS_PLAN_(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| endpoint | 진입 자동조회 금지 — keep-alive 잔여 filters 무효화 + 메타 1회 fetch(nscm-patterns §5-7). | features/supply/src/pages/capa-loss-plan/CapaLossPlan.tsx | 117 |
| jsx | 개인화 조회조건 복원 (SubTitle F6 저장분 되불러오기, 1회) — basic-check #3, 자매 정본 `capa-speed-plan`/`capa-line-assign`. 저장측은 Page 가 `<SubTitle searchParam={sc}>` 로 이미 배선돼 있으나([[f6-save-needs-searchparam-prop]]), 복원측이 없으면 저장은 되는데 **새로고침/재진입 시 조건이 사라진다**(신규 스캐 | features/supply/src/pages/capa-loss-plan/useCapaLossPlanStore.ts | 172 |
| endpoint | Measure 메타 fetch(PIVOT 화면 의무) — 현재 시트분만. 코드 하드코딩 배열 금지. | features/supply/src/pages/capa-loss-plan/useCapaLossPlanStore.ts | 379 |

## 10. __asis-mapping__.md 상태
- 구현: 70
- 제외: 13
| design_id | summary | reason | status |
|---|---|---|---|
| D00-1-020 | §1 emptySpaceItem1 / EmptySpaceItem | DevExpress 레이아웃 여백 노드 — 00 §5 static 4행 "여백은 CSS". TO-BE 는 공용 SearchArea + `Grid size` 12분할이 간격을 담당해 대응 DOM 이 없다. 빈 래퍼 생성은 hook #132 위반 | 제외 |
| D00-1-021 | §1 emptySpaceItem2 / EmptySpaceItem | DevExpress 레이아웃 여백 노드 — 00 §5 static 4행 "여백은 CSS". TO-BE 는 공용 SearchArea + `Grid size` 12분할이 간격을 담당해 대응 DOM 이 없다. 빈 래퍼 생성은 hook #132 위반 | 제외 |
| D00-1-022 | §1 emptySpaceItem4 / EmptySpaceItem | DevExpress 레이아웃 여백 노드 — 00 §5 static 4행 "여백은 CSS". TO-BE 는 공용 SearchArea + `Grid size` 12분할이 간격을 담당해 대응 DOM 이 없다. 빈 래퍼 생성은 hook #132 위반 | 제외 |
| D00-1-023 | §1 imageList1 / ImageList | 비가시 리소스 컨테이너 — 00 §5 static "ImageList 는 미이식". 아이콘은 `@foundation/assets`·`@shared/lges-icons` 컴포넌트로 대체된다(CapaLossPlan.tsx:5, components/CapaLossPlanForm.tsx:6) | 제외 |
| D00-1-024 | §1 layoutControlGroup1 / LayoutControlGroup | 사장 노드 · 참조 0건(01 L-09) — 본 문서 §4 미이식 확정. 만들면 빈 래퍼 = hook #132 위반 | 제외 |
| D00-1-039 | §1 spdMain_Sheet1 / SheetView | Designer 가 만든 **빈 초기 시트**이고 런타임은 `AddSheet` 8시트로 대체된다(00 §1 #39, cs:1585~1588) — 설계시점 placeholder 라 이식 대상이 아니다. TO-BE 는 DataGrid 1개 + sheetName 스위치(03 R-01) | 제외 |
| D00-1-044 | §1 usrLayoutControl1 / UsrLayoutControl | 사장 노드 · 참조 0건(01 L-08) — 본 문서 §4 미이식 확정. 만들면 빈 래퍼 = hook #132 위반 | 제외 |
| D00-3-007 | §3 setColumnWidth / `(c, DEF_DATE_COL_WIDTH)` | `M_00`(개선율) 블록은 TVF 가 **0건 생성하는 전면 사문**이라 미이식 확정(03 §2.2 C-09, 본 문서 §4) — 토글 대상 컬럼이 없어 폭 전환이 발생하지 않는다 | 제외 |
| D00-3-008 | §3 setColumnWidth / `(c, 0)` | 위 D00-3-007 과 같은 `M_00` 사문 블록의 미체크 분기 — 대상 컬럼 0건이라 도달 불가(03 §2.2 C-09, 본 문서 §4) | 제외 |
| D00-3-011 | §3 IsLockCell / `(r, c)` | AS-IS 호출부 `spdMain_ClipboardPasting` 가 `InitEvent`(cs:1870~1878)에서 **주석 처리**된 데드 경로다(00 §2 주의). TO-BE 는 붙여넣기 자체를 차단하므로(components/CapaLossPlanGrid.tsx:217~220 `pastingCell` cancel) 잠금범위 검사에 도달할 수 없다 — 미지원이 파리티(03 R-17, decisions §A BLK-12) | 제외 |
| D00-3-013 | §3 LockRange2 / `(0, 0, rowCnt-1, _fixed_column_idx, true)` | `SetLockColumnsOneRow` 의 1행 갱신판이고 AS-IS 호출부가 속도개선 **주석 블록**(cs:2534)이라 발동하지 않는다(00 §3 #13). TO-BE 는 순수 판정 함수 1개(utils/capaLossPlan.editLock.ts:154 `isCellEditable`)가 `beginningEdit`/`formatItem` 에서 셀 단위로 매번 재계산하므로 1행 갱신 변형 자체가 불필요 | 제외 |
| D00-3-014 | §3 SwitchLock / `()` | EditButton 토글 어포던스 자체는 전 화면 미이식 결정(asis_to_tobe.md §11, 2026-09-23) — 단 기존행 재편집 시 잠금 범위 재현 여부는 별도 검증 필요 | 제외 |
| D00-3-019 | §3 SetBGColor2 / `(rowIndex, MEASURE_NAME colIdx, rowIndex, ColumnCount-1, mColor)` | `SetMeasureColorOneRow` 1행 갱신판 — AS-IS 호출부가 주석 블록(cs:2536)이고 `else{continue}` 누락으로 미매칭 measure 를 검정으로 칠하는 dead 코드다(03 R-13, 본 문서 §3 #4 미이식 확정). TO-BE `formatItem` 은 셀 단위로 매 렌더 재계산하므로 1행 갱신 변형이 불필요 | 제외 |

