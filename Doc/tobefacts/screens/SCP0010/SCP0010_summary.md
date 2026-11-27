# SCP0010 — To-Be Fact Pack 요약

- page_key: `supply/shipment-plan-semi` · feature: supply · As-is Fact Pack 있음
- 파일 20 · 엔드포인트 호출 16 (미해결 1, 주석 속 1) · 이벤트 29 · 컴포넌트 사용 36 · 하드코딩 컬럼 3 · 메시지 38
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 3건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/shipment-plan-semi/components/FixReasonModal.tsx | component | 79 |
| features/supply/src/pages/shipment-plan-semi/components/ShipmentPlanSemiForm.tsx | component | 464 |
| features/supply/src/pages/shipment-plan-semi/components/ShipmentPlanSemiGrid.tsx | component | 599 |
| features/supply/src/pages/shipment-plan-semi/hooks/useShipmentPlanSemiValidation.ts | hook | 36 |
| features/supply/src/pages/shipment-plan-semi/index.ts | index | 2 |
| features/supply/src/pages/shipment-plan-semi/shipment-plan-semi.columns.ts | other | 48 |
| features/supply/src/pages/shipment-plan-semi/shipment-plan-semi.constants.ts | constants | 134 |
| features/supply/src/pages/shipment-plan-semi/shipment-plan-semi.types.ts | types | 44 |
| features/supply/src/pages/shipment-plan-semi/ShipmentPlanSemi.tsx | page | 679 |
| features/supply/src/pages/shipment-plan-semi/useShipmentPlanSemiStore.test.tsx | test | 122 |
| features/supply/src/pages/shipment-plan-semi/useShipmentPlanSemiStore.ts | store | 265 |
| features/supply/src/pages/shipment-plan-semi/utils/shipment-plan-semi.buildColumns.ts | util | 42 |
| features/supply/src/pages/shipment-plan-semi/utils/shipment-plan-semi.deptDayDistribute.ts | util | 59 |
| features/supply/src/pages/shipment-plan-semi/utils/shipment-plan-semi.editLock.test.ts | test | 77 |
| features/supply/src/pages/shipment-plan-semi/utils/shipment-plan-semi.editLock.ts | util | 249 |
| features/supply/src/pages/shipment-plan-semi/utils/shipment-plan-semi.headerMerge.ts | util | 58 |
| features/supply/src/pages/shipment-plan-semi/utils/shipment-plan-semi.insert.test.ts | test | 146 |
| features/supply/src/pages/shipment-plan-semi/utils/shipment-plan-semi.insert.ts | util | 242 |
| features/supply/src/pages/shipment-plan-semi/utils/shipment-plan-semi.save.ts | util | 251 |
| features/supply/src/pages/shipment-plan-semi/__asis-mapping__.md | mapping | 520 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 7 | Y | ShipmentPlanSemiForm.tsx:56 ShipmentPlanSemiForm.tsx:65 ShipmentPlanSemiForm.tsx:69 ShipmentPlanSemiForm.tsx:70 ShipmentPlanSemiForm.tsx:71 ShipmentPlanSemiForm.tsx:73 |
| SCP0010/main//call-proc | hook | 1 | Y | ShipmentPlanSemi.tsx:93 |
| SCP0010/calendar//call-proc | hook | 1 | Y | ShipmentPlanSemi.tsx:100 |
| /SCP0010/main/{action}/call-proc | http | 1 | N | ShipmentPlanSemi.tsx:243 |
| /SCP0010/main/SAVE_WEEKLY\|SAVE/call-proc | http | 1 | Y | ShipmentPlanSemi.tsx:463 |
| /admin/menu/SCP0010/column | http | 1 | Y | useShipmentPlanSemiStore.ts:202 |
| /admin/menu/SCP0010/measure | http | 1 | Y | useShipmentPlanSemiStore.ts:222 |
| /admin/menu/SCP0010/search-conditions | http | 1 | Y | useShipmentPlanSemiStore.ts:242 |
| /SCP0010/main/FIX/call-proc | propagated | 1 | Y | ShipmentPlanSemi.tsx:297 |
| /SCP0010/main/UNFIX/call-proc | propagated | 1 | Y | ShipmentPlanSemi.tsx:323 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| InputField | onChange | <arrow> setReason,e.target.value.replace(/\^/g,'').slice,e.target.value.replace | jsx | features/supply/src/pages/shipment-plan-semi/components/FixReasonModal.tsx | 55 |
| Button | onClick | onClose | jsx | features/supply/src/pages/shipment-plan-semi/components/FixReasonModal.tsx | 63 |
| Button | onClick | <arrow> onConfirm | jsx | features/supply/src/pages/shipment-plan-semi/components/FixReasonModal.tsx | 71 |
| CustomDropdown | onChange | <arrow> onPick,String(picked??'').split(',').filter,String(picked??'').split,String,v.toUpperCase | jsx | features/supply/src/pages/shipment-plan-semi/components/ShipmentPlanSemiForm.tsx | 235 |
| CustomDropdown | onChange | <arrow> onPick,String | jsx | features/supply/src/pages/shipment-plan-semi/components/ShipmentPlanSemiForm.tsx | 259 |
| SearchArea | onSearch | onSearch | jsx | features/supply/src/pages/shipment-plan-semi/components/ShipmentPlanSemiForm.tsx | 269 |
| CustomDropdown | onChange | <arrow> String,confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,setDivision | jsx | features/supply/src/pages/shipment-plan-semi/components/ShipmentPlanSemiForm.tsx | 290 |
| InputField | onChange | <arrow> set | jsx | features/supply/src/pages/shipment-plan-semi/components/ShipmentPlanSemiForm.tsx | 331 |
| Button | onClick | onItemSearch | jsx | features/supply/src/pages/shipment-plan-semi/components/ShipmentPlanSemiForm.tsx | 327 |
| PlanVersionCascade | onChange | <arrow> set,confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,clearFilters | jsx | features/supply/src/pages/shipment-plan-semi/components/ShipmentPlanSemiForm.tsx | 401 |
| PeriodRangePicker | onChange | <arrow> set | jsx | features/supply/src/pages/shipment-plan-semi/components/ShipmentPlanSemiForm.tsx | 435 |
| g | beginningEdit | beginningEditHandler | addHandler | features/supply/src/pages/shipment-plan-semi/components/ShipmentPlanSemiGrid.tsx | 383 |
| g | cellEditEnded | cellEditEndedHandler | addHandler | features/supply/src/pages/shipment-plan-semi/components/ShipmentPlanSemiGrid.tsx | 426 |
| g | pastedCell | cellEditEndedHandler | addHandler | features/supply/src/pages/shipment-plan-semi/components/ShipmentPlanSemiGrid.tsx | 427 |
| g | formatItem | formatItemHandler | addHandler | features/supply/src/pages/shipment-plan-semi/components/ShipmentPlanSemiGrid.tsx | 484 |
| g.hostElement | click | clickHandler | addEventListener | features/supply/src/pages/shipment-plan-semi/components/ShipmentPlanSemiGrid.tsx | 508 |
| grid | updatedLayout | applyHeaderHeight | addHandler | features/supply/src/pages/shipment-plan-semi/components/ShipmentPlanSemiGrid.tsx | 578 |
| DataGrid | initialized | handleGridInitialized | jsx | features/supply/src/pages/shipment-plan-semi/components/ShipmentPlanSemiGrid.tsx | 592 |
| DataGrid | gotFocus | onFocus | jsx | features/supply/src/pages/shipment-plan-semi/components/ShipmentPlanSemiGrid.tsx | 593 |
| ShipmentPlanSemiForm | onSearch | handleSearch | jsx | features/supply/src/pages/shipment-plan-semi/ShipmentPlanSemi.tsx | 539 |
| ShipmentPlanSemiForm | onItemSearch | <arrow> setOpenItem | jsx | features/supply/src/pages/shipment-plan-semi/ShipmentPlanSemi.tsx | 539 |
| Checkbox | onChange | <arrow> set | jsx | features/supply/src/pages/shipment-plan-semi/ShipmentPlanSemi.tsx | 579 |
| ShipmentPlanSemiGrid | onFocus | <arrow>  | jsx | features/supply/src/pages/shipment-plan-semi/ShipmentPlanSemi.tsx | 598 |
| ShipmentPlanSemiGrid | onBodCellClick | handleBodCellClick | jsx | features/supply/src/pages/shipment-plan-semi/ShipmentPlanSemi.tsx | 599 |
| MeasureSelectModal | onApply | <arrow> currentMeasures.map,saveTitleSet({menuId:MENU_ID,sheetName:MEASURE_SHEET_NAME[measureSheetGroup],columnType:TITLESET_MEASURE_TYPE,rows:selected.map((name,i)=>({name,sortOrderNo:i+1})),}).then,saveTitleSet,selected.map,setToast,t | jsx | features/supply/src/pages/shipment-plan-semi/ShipmentPlanSemi.tsx | 627 |
| NewPlanModal | onSaved | handleNewPlanSaved | jsx | features/supply/src/pages/shipment-plan-semi/ShipmentPlanSemi.tsx | 652 |
| FixReasonModal | onClose | <arrow> setOpenFixReason | jsx | features/supply/src/pages/shipment-plan-semi/ShipmentPlanSemi.tsx | 655 |
| FixReasonModal | onConfirm | handleFixReasonConfirm | jsx | features/supply/src/pages/shipment-plan-semi/ShipmentPlanSemi.tsx | 655 |
| BodMasterModal | onSelect | handleBodSelect | jsx | features/supply/src/pages/shipment-plan-semi/ShipmentPlanSemi.tsx | 674 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 6 |
| FormItem | 4 |
| Button | 3 |
| CustomDropdown | 3 |
| InputField | 2 |
| CustomDialog | 1 |
| Stack | 1 |
| SearchArea | 1 |
| FunctionSearchIcon | 1 |
| PlanVersionCascade | 1 |
| PeriodRangePicker | 1 |
| DataGrid | 1 |
| MainTitle | 1 |
| ShipmentPlanSemiForm | 1 |
| SubTitle | 1 |
| IcMeasureSelect | 1 |
| Checkbox | 1 |
| ShipmentPlanSemiGrid | 1 |
| MaterialByDivisionModal | 1 |
| MeasureSelectModal | 1 |
| NewPlanModal | 1 |
| FixReasonModal | 1 |
| BodMasterModal | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| toLeafConfig | l.binding | l.header | 90 | l.visible |  |  | object | features/supply/src/pages/shipment-plan-semi/components/ShipmentPlanSemiGrid.tsx | 205 |
| leaf | m.binding | m.kind === 'D' ? m.leaf : 'SUM' |  | isDynVisible(m.kind) |  |  | object | features/supply/src/pages/shipment-plan-semi/components/ShipmentPlanSemiGrid.tsx | 226 |
| buildColumns | c.key | c.header | c.width ?? 100 | c.visible !== false |  |  | meta-map | features/supply/src/pages/shipment-plan-semi/utils/shipment-plan-semi.buildColumns.ts | 29 |

## 7. 메시지 코드
| code | count |
|---|---|
| MSG00013 | 3 |
| MSG00665 | 2 |
| MSG00108 | 2 |
| MSG01046 | 1 |
| MSG01196 | 1 |
| MSG01438 | 1 |
| MSG01273 | 1 |
| MSG00002 | 1 |
| MSG00003 | 1 |
| MSG00225 | 1 |
| MSG00165 | 1 |
| MSG00004 | 1 |
| MSG01243 | 1 |
| MSG01262 | 1 |
| LBL01028 | 1 |
| LBL00771 | 1 |
| LBL00772 | 1 |
| LBL00627 | 1 |
| LBL00112 | 1 |
| LBL00001 | 1 |
| LBL00027 | 1 |
| LBL00039 | 1 |
| LBL01220 | 1 |
| LBL00040 | 1 |
| LBL00041 | 1 |
| LBL00013 | 1 |
| LBL00022 | 1 |
| LBL00023 | 1 |
| LBL00038 | 1 |
| LBL00669 | 1 |
| LBL00618 | 1 |
| LBL00710 | 1 |
| LBL00687 | 1 |
| LBL00310 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0010(22), SCP0013(17), SCP0009(16), SCP0011(3), COM0013(1), SCM0002(1)
- SP/PKG: PKG_SCP0010(11), P_SCP0010_SAVE_SEMI_DATASET(7), SCP0013_GET_PLAN_TYPE_SAVE_YN(4), PKG_COM0000(3), P_SCP0009_GET_SHEET_CALENDAR_3SPAN(3), P_DATA(3), P_SCP0010_GET_SHIP_PLAN_SEMI(2), P_SCP0010_SAVE_SEMI_WEEKLY(2), P_USER_ID(2), P_BIZ_TYPE(2), P_FIX_REASON(1), SCM0001_GET_SCP_DAY_PERIOD(1), P_SCP0010_SAVE_SEMI_FIX_DS(1), P_SCP0010_WEEKLY_SAVE(1), P_ITEM_ID(1), P_SHEET_NAME(1), P_ACTIVE_FLAG(1), P_LOAD_INPUT(1), P_SEMI_FIX_HIST_DS(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | {single(LBL.BUCKET, '_Bucket', sc.bucketType, bucketOptions, v => set({ bucketType: v as BUCKET_TYPE }) )} | features/supply/src/pages/shipment-plan-semi/components/ShipmentPlanSemiForm.tsx | 349 |
| jsx | 이전: 라벨 칸에 체크박스+Sum 글자를 To Site 라벨 시작선에 맞춤(2026-10-19). 다른 조회조건처럼 Sum 을 라벨로, 체크박스를 입력 칸으로 옮겼다(사용자 지시 2026-10-19). <Grid size={3}> <FormItem className={commonStyles.formItem} label='' labelAlign='right' render={() => ( <div style={{ display:  | features/supply/src/pages/shipment-plan-semi/components/ShipmentPlanSemiForm.tsx | 362 |
| code | set(next); | features/supply/src/pages/shipment-plan-semi/components/ShipmentPlanSemiForm.tsx | 412 |
| code | if (changed) clearFilters(); | features/supply/src/pages/shipment-plan-semi/components/ShipmentPlanSemiForm.tsx | 413 |
| jsx | 이전 위치: AS-IS row3 끝(Period 옆) — To Site 아래로 이동(2026-10-19). <Grid size={3}> <FormItem className={commonStyles.formItem} label='' labelAlign='right' render={() => ( <div style={{ display: 'flex', justifyContent: 'flex-end', paddingRight: '16 | features/supply/src/pages/shipment-plan-semi/components/ShipmentPlanSemiForm.tsx | 442 |
| code | const weekToDayBindings = useMemo(() => { | features/supply/src/pages/shipment-plan-semi/components/ShipmentPlanSemiGrid.tsx | 129 |
| code | const map = new Map<string, string[]>(); | features/supply/src/pages/shipment-plan-semi/components/ShipmentPlanSemiGrid.tsx | 130 |
| code | const dBindings = dynColMetas.filter(m => m.kind === 'D'); | features/supply/src/pages/shipment-plan-semi/components/ShipmentPlanSemiGrid.tsx | 131 |
| code | .filter(m => m.kind === 'W') | features/supply/src/pages/shipment-plan-semi/components/ShipmentPlanSemiGrid.tsx | 133 |
| code | .forEach(w => { | features/supply/src/pages/shipment-plan-semi/components/ShipmentPlanSemiGrid.tsx | 134 |
| code | const days = dBindings.filter(d => weekOrMonthStart.get(d.binding) === w.weekStart).map(d => d.binding); | features/supply/src/pages/shipment-plan-semi/components/ShipmentPlanSemiGrid.tsx | 135 |
| code | if (days.length > 0) map.set(w.binding, days); | features/supply/src/pages/shipment-plan-semi/components/ShipmentPlanSemiGrid.tsx | 136 |
| code | }); | features/supply/src/pages/shipment-plan-semi/components/ShipmentPlanSemiGrid.tsx | 137 |
| code | }, [dynColMetas, weekOrMonthStart]); | features/supply/src/pages/shipment-plan-semi/components/ShipmentPlanSemiGrid.tsx | 139 |
| code | Object.entries(distributed).forEach(([dBinding, value]) => { | features/supply/src/pages/shipment-plan-semi/components/ShipmentPlanSemiGrid.tsx | 412 |
| code | }); | features/supply/src/pages/shipment-plan-semi/components/ShipmentPlanSemiGrid.tsx | 414 |
| endpoint | const [planSeqRows] = useTabComboQueries({ filters: [COMBO.PLAN_SEQ] }); | features/supply/src/pages/shipment-plan-semi/ShipmentPlanSemi.tsx | 184 |
| code | void setAlert({ type: 'alert', content: t(MSG.SAVE_NOT_ALLOWED, '_This plan cannot be modified.') }); | features/supply/src/pages/shipment-plan-semi/ShipmentPlanSemi.tsx | 287 |
| code | void setAlert({ type: 'alert', content: t(MSG.SAVE_NOT_ALLOWED, '_This plan cannot be modified.') }); | features/supply/src/pages/shipment-plan-semi/ShipmentPlanSemi.tsx | 315 |
| code | if (sc.divisionId.startsWith('EE')) return; | features/supply/src/pages/shipment-plan-semi/ShipmentPlanSemi.tsx | 348 |
| code | void setAlert({ type: 'alert', content: t(MSG.SAVE_NOT_ALLOWED, '_This plan cannot be modified.') }); | features/supply/src/pages/shipment-plan-semi/ShipmentPlanSemi.tsx | 375 |
| code | const rows = buildSaveRows( | features/supply/src/pages/shipment-plan-semi/ShipmentPlanSemi.tsx | 415 |
| code | ); | features/supply/src/pages/shipment-plan-semi/ShipmentPlanSemi.tsx | 421 |
| code | void setAlert({ type: 'alert', content: String(result.RESULT_MSG ?? t(MSG.SAVE_FAIL, '_Save failed.')) }); | features/supply/src/pages/shipment-plan-semi/ShipmentPlanSemi.tsx | 487 |
| code | const { division, shipFrozen, bodToYyyymmdd, planStartYyyymmdd, queryToYyyymmdd } = params; | features/supply/src/pages/shipment-plan-semi/utils/shipment-plan-semi.editLock.ts | 83 |
| code | const blockStartDate = division === '40' \|\| division === '81' \|\| isDivision81Series(division) | features/supply/src/pages/shipment-plan-semi/utils/shipment-plan-semi.editLock.ts | 90 |
| code | if (!blockStartDate) return null; | features/supply/src/pages/shipment-plan-semi/utils/shipment-plan-semi.editLock.ts | 93 |
| code | return { from: blockStartDate, to: queryToYyyymmdd }; | features/supply/src/pages/shipment-plan-semi/utils/shipment-plan-semi.editLock.ts | 99 |
| code | return { from: blockStartDate, to: bodTo }; | features/supply/src/pages/shipment-plan-semi/utils/shipment-plan-semi.editLock.ts | 101 |
| code | const lockStart = findDuplicateWeekLockStart(ctx.weekBindingsAsc); | features/supply/src/pages/shipment-plan-semi/utils/shipment-plan-semi.editLock.ts | 223 |
| code | const lockStartIdx = ctx.weekBindingsAsc.indexOf(lockStart); | features/supply/src/pages/shipment-plan-semi/utils/shipment-plan-semi.editLock.ts | 225 |
| code | const thisIdx = ctx.weekBindingsAsc.indexOf(binding); | features/supply/src/pages/shipment-plan-semi/utils/shipment-plan-semi.editLock.ts | 226 |
| code | if (thisIdx >= 0 && thisIdx >= lockStartIdx) return false; | features/supply/src/pages/shipment-plan-semi/utils/shipment-plan-semi.editLock.ts | 227 |
| code | if (kind !== 'D') return; // 저장 대상은 D_ 셀뿐(W_ 입력은 deptDayDistribute 로 이미 D_ 로 분배됨) | features/supply/src/pages/shipment-plan-semi/utils/shipment-plan-semi.save.ts | 99 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

