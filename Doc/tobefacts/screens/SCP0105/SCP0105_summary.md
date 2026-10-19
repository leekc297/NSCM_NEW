# SCP0105 — To-Be Fact Pack 요약

- page_key: `supply/capa-speed-plan` · feature: supply · As-is Fact Pack 있음
- 파일 23 · 엔드포인트 호출 8 (미해결 0, 주석 속 3) · 이벤트 27 · 컴포넌트 사용 52 · 하드코딩 컬럼 1 · 메시지 26
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 사용 · 하드코딩 컬럼 정의 1건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/capa-speed-plan/capa-speed-plan.constants.ts | constants | 281 |
| features/supply/src/pages/capa-speed-plan/capa-speed-plan.types.ts | types | 108 |
| features/supply/src/pages/capa-speed-plan/CapaSpeedPlan.tsx | page | 306 |
| features/supply/src/pages/capa-speed-plan/components/CapaSpeedPlanColumnModal.tsx | component | 69 |
| features/supply/src/pages/capa-speed-plan/components/CapaSpeedPlanForm.tsx | component | 370 |
| features/supply/src/pages/capa-speed-plan/components/CapaSpeedPlanGrid.module.scss | component | 8 |
| features/supply/src/pages/capa-speed-plan/components/CapaSpeedPlanGrid.tsx | component | 356 |
| features/supply/src/pages/capa-speed-plan/components/CapaSpeedPlanItemPopup.tsx | component | 47 |
| features/supply/src/pages/capa-speed-plan/hooks/useCapaSpeedPlanCellEdit.ts | hook | 95 |
| features/supply/src/pages/capa-speed-plan/hooks/useCapaSpeedPlanCombos.ts | hook | 303 |
| features/supply/src/pages/capa-speed-plan/hooks/useCapaSpeedPlanConditionEffects.ts | hook | 116 |
| features/supply/src/pages/capa-speed-plan/hooks/useCapaSpeedPlanSave.ts | hook | 160 |
| features/supply/src/pages/capa-speed-plan/index.ts | index | 2 |
| features/supply/src/pages/capa-speed-plan/useCapaSpeedPlanStore.ts | store | 427 |
| features/supply/src/pages/capa-speed-plan/utils/capaSpeedPlan.combos.test.ts | test | 174 |
| features/supply/src/pages/capa-speed-plan/utils/capaSpeedPlan.combos.ts | util | 411 |
| features/supply/src/pages/capa-speed-plan/utils/capaSpeedPlan.dateColumns.ts | util | 139 |
| features/supply/src/pages/capa-speed-plan/utils/capaSpeedPlan.editLock.test.ts | test | 164 |
| features/supply/src/pages/capa-speed-plan/utils/capaSpeedPlan.editLock.ts | util | 129 |
| features/supply/src/pages/capa-speed-plan/utils/capaSpeedPlan.recalc.test.ts | test | 169 |
| features/supply/src/pages/capa-speed-plan/utils/capaSpeedPlan.recalc.ts | util | 194 |
| features/supply/src/pages/capa-speed-plan/utils/capaSpeedPlan.save.ts | util | 160 |
| features/supply/src/pages/capa-speed-plan/__asis-mapping__.md | mapping | 470 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| SCP0105/ASSEMBLY//call-proc | hook | 1 | Y | CapaSpeedPlan.tsx:86 |
| SCP0105/ELTR//call-proc | hook | 1 | Y | CapaSpeedPlan.tsx:93 |
| SCP0105/spreadTitle//call-proc | hook | 1 | Y | CapaSpeedPlan.tsx:101 |
| (useTabComboQueryResults) | hook | 1 | Y | useCapaSpeedPlanCombos.ts:81 |
| /SCP0105/ASSEMBLY\|ELTR/SAVE/call-proc | http | 1 | Y | useCapaSpeedPlanSave.ts:74 |
| /admin/menu/SCP0105/search-conditions | http | 1 | Y | useCapaSpeedPlanStore.ts:197 |
| /admin/menu/SCP0105/column | http | 1 | Y | useCapaSpeedPlanStore.ts:359 |
| /admin/menu/SCP0105/measure | http | 1 | Y | useCapaSpeedPlanStore.ts:390 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| CapaSpeedPlanForm | onSearch | handleSearch | jsx | features/supply/src/pages/capa-speed-plan/CapaSpeedPlan.tsx | 265 |
| CapaSpeedPlanForm | onOpenItemPopup | <arrow> setOpenItemPopup | jsx | features/supply/src/pages/capa-speed-plan/CapaSpeedPlan.tsx | 266 |
| CapaSpeedPlanGrid | onCellEditEnded | handleCellEditEnded | jsx | features/supply/src/pages/capa-speed-plan/CapaSpeedPlan.tsx | 292 |
| CapaSpeedPlanColumnModal | onClose | <arrow> setOpenColumnSetting | jsx | features/supply/src/pages/capa-speed-plan/CapaSpeedPlan.tsx | 297 |
| CapaSpeedPlanItemPopup | onClose | <arrow> setOpenItemPopup | jsx | features/supply/src/pages/capa-speed-plan/CapaSpeedPlan.tsx | 302 |
| ColumnLayoutModal | onSave | <arrow> applyColumnLayout,settings.map,Number,String,clearFilters,onClose | jsx | features/supply/src/pages/capa-speed-plan/components/CapaSpeedPlanColumnModal.tsx | 50 |
| SearchArea | onSearch | onSearch | jsx | features/supply/src/pages/capa-speed-plan/components/CapaSpeedPlanForm.tsx | 76 |
| CustomDropdown | onChange | <arrow> setDivisionType,String | jsx | features/supply/src/pages/capa-speed-plan/components/CapaSpeedPlanForm.tsx | 93 |
| CustomDropdown | onChange | <arrow> String,confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,setDivision | jsx | features/supply/src/pages/capa-speed-plan/components/CapaSpeedPlanForm.tsx | 113 |
| CustomDropdown | onChange | <arrow> setSearchCondition,String | jsx | features/supply/src/pages/capa-speed-plan/components/CapaSpeedPlanForm.tsx | 133 |
| CustomDropdown | onChange | <arrow> setSearchCondition,String | jsx | features/supply/src/pages/capa-speed-plan/components/CapaSpeedPlanForm.tsx | 148 |
| CustomDropdown | onChange | <arrow> setSearchCondition,String | jsx | features/supply/src/pages/capa-speed-plan/components/CapaSpeedPlanForm.tsx | 173 |
| CustomDropdown | onChange | <arrow> setSearchCondition,String | jsx | features/supply/src/pages/capa-speed-plan/components/CapaSpeedPlanForm.tsx | 193 |
| CustomDropdown | onChange | <arrow> setSearchCondition,String | jsx | features/supply/src/pages/capa-speed-plan/components/CapaSpeedPlanForm.tsx | 219 |
| CustomDropdown | onChange | <arrow> setSearchCondition,String | jsx | features/supply/src/pages/capa-speed-plan/components/CapaSpeedPlanForm.tsx | 245 |
| CustomDropdown | onChange | <arrow> setSearchCondition,String | jsx | features/supply/src/pages/capa-speed-plan/components/CapaSpeedPlanForm.tsx | 274 |
| CustomDropdown | onChange | <arrow> setSearchCondition,String | jsx | features/supply/src/pages/capa-speed-plan/components/CapaSpeedPlanForm.tsx | 298 |
| CustomDropdown | onChange | <arrow> setSearchCondition,String | jsx | features/supply/src/pages/capa-speed-plan/components/CapaSpeedPlanForm.tsx | 322 |
| InputField | onChange | <arrow> setSearchCondition | jsx | features/supply/src/pages/capa-speed-plan/components/CapaSpeedPlanForm.tsx | 347 |
| InputField | onDoubleClick | onOpenItemPopup | jsx | features/supply/src/pages/capa-speed-plan/components/CapaSpeedPlanForm.tsx | 348 |
| FunctionSearchIcon | onClick | onOpenItemPopup | jsx | features/supply/src/pages/capa-speed-plan/components/CapaSpeedPlanForm.tsx | 356 |
| grid | formatItem | formatItemHandler | addHandler | features/supply/src/pages/capa-speed-plan/components/CapaSpeedPlanGrid.tsx | 198 |
| grid | beginningEdit | beginningEditHandler | addHandler | features/supply/src/pages/capa-speed-plan/components/CapaSpeedPlanGrid.tsx | 226 |
| grid | pastingCell | pastingCellHandler | addHandler | features/supply/src/pages/capa-speed-plan/components/CapaSpeedPlanGrid.tsx | 245 |
| grid | cellEditEnded | cellEditEndedHandler | addHandler | features/supply/src/pages/capa-speed-plan/components/CapaSpeedPlanGrid.tsx | 274 |
| CapaItemPopup | onClose | onClose | jsx | features/supply/src/pages/capa-speed-plan/components/CapaSpeedPlanItemPopup.tsx | 32 |
| CapaItemPopup | onSelect | <arrow> selectedAll.map(item=>sc.divisionType===DIVISION_TYPE.ELTR?toStr(item.itemId):toStr(item.nickName)).filter,selectedAll.map,toStr,Array.from(newSet(values)).join,Array.from,setSearchCondition | jsx | features/supply/src/pages/capa-speed-plan/components/CapaSpeedPlanItemPopup.tsx | 34 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 13 |
| FormItem | 13 |
| CustomDropdown | 11 |
| InputField | 2 |
| IcGridColumnSetup | 1 |
| MainTitle | 1 |
| CapaSpeedPlanForm | 1 |
| SubTitle | 1 |
| CapaSpeedPlanGrid | 1 |
| CapaSpeedPlanColumnModal | 1 |
| CapaSpeedPlanItemPopup | 1 |
| ColumnLayoutModal | 1 |
| SearchArea | 1 |
| Button | 1 |
| FunctionSearchIcon | 1 |
| DataGrid | 1 |
| CapaItemPopup | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| buildPeriodColumns | row.COLUMN_NAME | String(row.COLUMN_LABEL_NAME ?? row.COLUMN_NAME) | columnWidth | true |  |  | object | features/supply/src/pages/capa-speed-plan/utils/capaSpeedPlan.dateColumns.ts | 92 |

## 7. 메시지 코드
| code | count |
|---|---|
| MSG00667 | 1 |
| MSG00109 | 1 |
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

## 8. 주석 속 As-is 참조
- 화면ID: SCP0105(7), SCP0104(4), SCP0114(2), SCM0002(1), SCP0020(1)
- SP/PKG: PKG_SCP0105(7), PKG_SCP0104(3), P_SCP0104_GET_SPREAD_TITLE(3), P_SCP0105_GET_CAPA_SPEED_PLAN_(1), P_SCP0105_SAVE_CAPA_SPEED_PLAN_(1), SCP0104_GET_SPREAD_TITLE(1), SCP0105_GET_CAPA_SPEED_PLAN_CURRENT_ASSEMBLY(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| endpoint | (1) 진입 — 자동조회 금지. keep-alive 잔여 filters 무효화 + 메타 1회 fetch(nscm-patterns §5-7). | features/supply/src/pages/capa-speed-plan/hooks/useCapaSpeedPlanConditionEffects.ts | 44 |
| jsx | 개인화 조회조건 복원 (SubTitle F6 저장분 되불러오기, 1회) — 정본 `scp-bom`/자매 `capa-line-assign`. 저장측은 page 가 `<SubTitle searchParam={sc}>` 로 이미 배선돼 있으나([[f6-save-needs-searchparam-prop]]), 복원측이 없으면 저장은 되는데 **새로고침/재진입 시 조건이 사라진다**(basic-check #3 재발 함정, [[f6-re | features/supply/src/pages/capa-speed-plan/useCapaSpeedPlanStore.ts | 171 |
| endpoint | admin 컬럼 메타 fetch(2시트) — mount 1회 + **매 Search 마다** refetch(CLAUDE.md §2 체크3). `divisionId` 인자: division 변경 시 set() 커밋 뒤 새 값을 넘겨 호출한다. producer 안에서 `get()` 으로 읽으면 커밋 전 이전 division 이라 컬럼셋이 한 스텝 밀린다(nscm-patterns §5-5). | features/supply/src/pages/capa-speed-plan/useCapaSpeedPlanStore.ts | 349 |
| endpoint | Measure 메타 fetch(PIVOT 화면 의무) — ASSEMBLY 6행 / ELTR 1행. 코드 하드코딩 배열 금지. | features/supply/src/pages/capa-speed-plan/useCapaSpeedPlanStore.ts | 385 |

## 10. __asis-mapping__.md 상태
- 구현: 67
- 제외: 12
| design_id | summary | reason | status |
|---|---|---|---|
| D00-1-018 | §1 emptySpaceItem1 / EmptySpaceItem | DevExpress LayoutControl 의 여백 노드. TO-BE 는 CSS Grid(`Grid size`)가 폭을 배분해 대응 컨트롤이 없다(00 §1 static) | 제외 |
| D00-1-019 | §1 emptySpaceItem11 / EmptySpaceItem | DevExpress LayoutControl 의 여백 노드. TO-BE 는 CSS Grid(`Grid size`)가 폭을 배분해 대응 컨트롤이 없다(00 §1 static) | 제외 |
| D00-1-020 | §1 emptySpaceItem6 / EmptySpaceItem | DevExpress LayoutControl 의 여백 노드. TO-BE 는 CSS Grid(`Grid size`)가 폭을 배분해 대응 컨트롤이 없다(00 §1 static) | 제외 |
| D00-1-021 | §1 fpSpread1 / FpSpread | Designer 노드만 존재하고 code-behind 참조 0건 = 미사용 잔재(03 C-10). 실제 그리드는 `spdMain` 하나다 | 제외 |
| D00-1-022 | §1 imageList1 / ImageList | 비가시 리소스(아이콘 컨테이너). React 는 아이콘을 컴포넌트로 직접 import 한다(`IcGridColumnSetup`) | 제외 |
| D00-1-023 | §1 layoutControlGroup1 / LayoutControlGroup | `usrLayoutControl1` 의 Root 라 함께 사장 — `Items.AddRange` 0건(01 L-07) | 제외 |
| D00-1-037 | §1 spdMain_Sheet1 / SheetView | Designer 초기 시트. 런타임 `AddSheet` 2건(cs:1302·1303)이 대체하고 TO-BE 는 시트 전환을 `sheetName` prop 으로 한다 | 제외 |
| D00-1-041 | §1 usrLayoutControl1 / UsrLayoutControl | `Controls.Add(usrLayoutControl1)` grep 0건 = Form 에 붙지 않는 사장 노드(01 L-06) | 제외 |
| D00-3-007 | §3 SwitchLock / `()` | EditButton 토글 어포던스 자체는 전 화면 미이식 결정(`Doc/Doc_lgc_bak/rules/11_asis_parity/asis_to_tobe.md §11`, 2026-09-23). 다만 **잠금 범위**는 별개 축이라 `utils/capaSpeedPlan.editLock.ts:63~82` 로 전건 재현했고 `utils/capaSpeedPlan.editLock.test.ts` 13건으로 검증한다 | 제외 |
| D00-3-015 | §3 Insert / `()` | AS-IS `InsertButton()` 본문이 빈 구현이라 `Insert_Row`(cs:2367) 호출부 0건 = 도달 불가. TO-BE 는 버튼을 남기고 명시적 무동작(`CapaSpeedPlan.tsx:212`)이다 | 제외 |
| D00-3-016 | §3 SetValue / `(newCell, dic)` | 행 추가 경로가 없어 신규행 기본값 세팅에 도달할 수 없다(03 R-16) | 제외 |
| D00-3-017 | §3 SetValue / `(qtyRowIdx, i, base_qty)` | `SetBaseToDateColumns` 호출부 3건이 전부 주석이라 런타임 미발동(03 R-17) | 제외 |

