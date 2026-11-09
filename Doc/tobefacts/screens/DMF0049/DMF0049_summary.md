# DMF0049 — To-Be Fact Pack 요약

- page_key: `demand/etc-sales-reports` · feature: demand · As-is Fact Pack 있음
- 파일 18 · 엔드포인트 호출 15 (미해결 1, 주석 속 3) · 이벤트 32 · 컴포넌트 사용 22 · 하드코딩 컬럼 2 · 메시지 22
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 사용 · 하드코딩 컬럼 정의 2건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsForm.module.scss | component | 12 |
| features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsForm.tsx | component | 176 |
| features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsGrid.tsx | component | 899 |
| features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsModals.tsx | component | 189 |
| features/demand/src/pages/etc-sales-reports/etc-sales-reports.constants.ts | constants | 133 |
| features/demand/src/pages/etc-sales-reports/etc-sales-reports.types.ts | types | 34 |
| features/demand/src/pages/etc-sales-reports/EtcSalesReports.module.scss | style | 148 |
| features/demand/src/pages/etc-sales-reports/EtcSalesReports.tsx | page | 664 |
| features/demand/src/pages/etc-sales-reports/index.ts | index | 2 |
| features/demand/src/pages/etc-sales-reports/useEtcSalesReportsStore.ts | store | 323 |
| features/demand/src/pages/etc-sales-reports/utils/etc-sales-reports.api.ts | api | 86 |
| features/demand/src/pages/etc-sales-reports/utils/etc-sales-reports.division.ts | util | 8 |
| features/demand/src/pages/etc-sales-reports/utils/etc-sales-reports.editLock.ts | util | 114 |
| features/demand/src/pages/etc-sales-reports/utils/etc-sales-reports.gridCombos.ts | util | 150 |
| features/demand/src/pages/etc-sales-reports/utils/etc-sales-reports.merge.ts | util | 236 |
| features/demand/src/pages/etc-sales-reports/utils/etc-sales-reports.save.ts | util | 212 |
| features/demand/src/pages/etc-sales-reports/utils/etc-sales-reports.validate.ts | util | 19 |
| features/demand/src/pages/etc-sales-reports/__asis-mapping__.md | mapping | 266 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 5 | Y | EtcSalesReportsForm.tsx:58 EtcSalesReportsGrid.tsx:173 EtcSalesReportsGrid.tsx:205 EtcSalesReports.tsx:80 EtcSalesReports.tsx:99 |
| DMF0049/MDF Reports//call-proc | hook | 1 | Y | EtcSalesReports.tsx:118 |
| DMF0049/spreadTitle//call-proc | hook | 1 | Y | EtcSalesReports.tsx:127 |
| DMF0049/measure//call-proc | hook | 1 | Y | EtcSalesReports.tsx:152 |
| /admin/menu/DMF0049/search-conditions | http | 1 | Y | useEtcSalesReportsStore.ts:164 |
| /admin/menu/DMF0049/column | http | 1 | Y | useEtcSalesReportsStore.ts:260 |
| /admin/menu/DMF0049/measure | http | 1 | Y | useEtcSalesReportsStore.ts:278 |
| /DMF0049/titleSet/SAVE/call-proc | http | 1 | Y | etc-sales-reports.api.ts:25 |
| /DMF0049/{sheet}/{btnCd}/call-proc | http | 1 | N | etc-sales-reports.api.ts:67 |
| DMF0049/MDF Reports/SAVE/call-proc | callProc | 1 | Y | etc-sales-reports.api.ts:83 |
| /DMF0049/MDF Reports/SAVE/call-proc | propagated | 1 | Y | etc-sales-reports.api.ts:83 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| MDF Reports | divisionId mdfType yyyy spVersionNo userGroup userId mnuId | data |  |
| spreadTitle | divisionId startDt endDt userId mnuId | data |  |
| measure | divisionId userId mnuId | data |  |
| unitedVersion | divisionId sdt edt versionType description userId mnuId | data |  |
| titleSet | programId sheetName columnType divisionId | o_rc1 |  |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | onSearch | jsx | features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsForm.tsx | 70 |
| DivisionField | onChange | <arrow> confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,set,dayjs().format,dayjs | jsx | features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsForm.tsx | 77 |
| CustomDropdown | onChange | <arrow> set,String,onReportTypeChange | jsx | features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsForm.tsx | 102 |
| YearField | onChange | <arrow> set | jsx | features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsForm.tsx | 120 |
| CustomDropdown | onChange | <arrow> set,String,onPlanResultChange | jsx | features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsForm.tsx | 134 |
| VersionField | onOpenPopup | onOpenVersionModal | jsx | features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsForm.tsx | 155 |
| VersionField | onValueChange | <arrow> set | jsx | features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsForm.tsx | 160 |
| g | formatItem | formatHandler | addHandler | features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsGrid.tsx | 533 |
| g | beginningEdit | beginningEditHandler | addHandler | features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsGrid.tsx | 581 |
| g | pastingCell | beginningEditHandler | addHandler | features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsGrid.tsx | 582 |
| g | cellEditEnded | cellEditEndedHandler | addHandler | features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsGrid.tsx | 685 |
| g | pastedCell | cellEditEndedHandler | addHandler | features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsGrid.tsx | 686 |
| g | pastedCell | propagatePasteToSet | addHandler | features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsGrid.tsx | 737 |
| g.hostElement | dblclick | dblclickHandler | addEventListener | features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsGrid.tsx | 754 |
| g.hostElement | mousedown | mouseDownCapture | addEventListener | features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsGrid.tsx | 767 |
| g.hostElement | keydown | keyDownCapture | addEventListener | features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsGrid.tsx | 779 |
| g | scrollPositionChanged | handleScrollInvalidate | addHandler | features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsGrid.tsx | 787 |
| g | updatedLayout | applyHeaderHeight | addHandler | features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsGrid.tsx | 837 |
| f | filterApplied | onFilterApplied | addHandler | features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsGrid.tsx | 859 |
| ColumnLayoutModal | onSave | <arrow> applyColumnLayout,settings.map,settings.filter,saveTitleSet,visible.map,onClose | jsx | features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsModals.tsx | 131 |
| MeasureSelectModal | onApply | <arrow> onGridReset,applyVisibleMeasures,staticMeasures.map,saveTitleSet('M',selected.map((name,i)=>({name,sortOrderNo:i+1}))).then,saveTitleSet,selected.map | jsx | features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsModals.tsx | 163 |
| VersionModal | onSelect | onVersionSelect | jsx | features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsModals.tsx | 184 |
| EtcSalesReportsForm | onSearch | handleSearch | jsx | features/demand/src/pages/etc-sales-reports/EtcSalesReports.tsx | 607 |
| EtcSalesReportsForm | onDivisionChange | handleDivisionChange | jsx | features/demand/src/pages/etc-sales-reports/EtcSalesReports.tsx | 608 |
| EtcSalesReportsForm | onReportTypeChange | handleReportTypeChange | jsx | features/demand/src/pages/etc-sales-reports/EtcSalesReports.tsx | 609 |
| EtcSalesReportsForm | onPlanResultChange | handlePlanResultChange | jsx | features/demand/src/pages/etc-sales-reports/EtcSalesReports.tsx | 610 |
| EtcSalesReportsForm | onOpenVersionModal | <arrow> setOpenModal | jsx | features/demand/src/pages/etc-sales-reports/EtcSalesReports.tsx | 611 |
| EtcSalesReportsGrid | onProjectCellDblClick | handleProjectCellDblClick | jsx | features/demand/src/pages/etc-sales-reports/EtcSalesReports.tsx | 642 |
| EtcSalesReportsModals | onClose | <arrow> setOpenModal | jsx | features/demand/src/pages/etc-sales-reports/EtcSalesReports.tsx | 653 |
| EtcSalesReportsModals | onGridReset | clearGridOnSettingChange | jsx | features/demand/src/pages/etc-sales-reports/EtcSalesReports.tsx | 654 |
| EtcSalesReportsModals | onProjectSelect | applyPopupSelection | jsx | features/demand/src/pages/etc-sales-reports/EtcSalesReports.tsx | 656 |
| EtcSalesReportsModals | onVersionSelect | <arrow> setSearchCondition | jsx | features/demand/src/pages/etc-sales-reports/EtcSalesReports.tsx | 657 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 2 |
| FormItem | 2 |
| CustomDropdown | 2 |
| SearchArea | 1 |
| DivisionField | 1 |
| YearField | 1 |
| VersionField | 1 |
| DataGrid | 1 |
| ProjectByDivisionModal | 1 |
| ColumnLayoutModal | 1 |
| MeasureSelectModal | 1 |
| VersionModal | 1 |
| IcMeasureSelect | 1 |
| MainTitle | 1 |
| EtcSalesReportsForm | 1 |
| SubTitle | 1 |
| EtcSalesReportsGrid | 1 |
| ProgressIndicator | 1 |
| EtcSalesReportsModals | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| mainDynamicColumns | m.binding | m.label | 90 | true |  | DataType.Number | object | features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsGrid.tsx | 315 |
| buildGroupKeyOf | column?.binding ?? '' |  |  | column?.visible !== false |  |  | object | features/demand/src/pages/etc-sales-reports/EtcSalesReports.tsx | 301 |

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00112 | 1 |
| LBL00795 | 1 |
| LBL00086 | 1 |
| LBL00094 | 1 |
| LBL00797 | 1 |
| LBL00798 | 1 |
| MSG00283 | 1 |
| MSG00688 | 1 |
| MSG00096 | 1 |
| MSG00429 | 1 |
| MSG00002 | 1 |
| MSG00004 | 1 |
| MSG00676 | 1 |
| MSG00618 | 1 |
| MSG00682 | 1 |
| MSG00683 | 1 |
| MSG00684 | 1 |
| MSG00685 | 1 |
| MSG00686 | 1 |
| MSG00687 | 1 |
| LBL00310 | 2 |

## 8. 주석 속 As-is 참조
- 화면ID: DMF0044(31), DMF0049(20), DMF0003(10), DMF0042(3), SCM0002(3), DMF0040(2), DMF0072(1), DMF0074(1), DMF0021(1)
- SP/PKG: PKG_DMF0049(3), P_DMF0044_GET_SALES_REPORTS_DATA(3), P_DMF0049_GET_SPREAD_TITLE(2), DMF0044_GET_SPREAD_TITLE(2), P_DMF0044_GET_MEASURE(2), P_CREATED_BY(2), P_USER_GROUP(2), DMF0049_SAVE_SALES_ETC_REPORT_C(2), DMF0049_GET_SPREAD_TITLE(1), P_RESULT_MONTH(1), PKG_DMF0044(1), SCM0002_SET_TITLESET_POPUP(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| endpoint | const [mdfType, calendarYyyy] = useTabComboQueries({ | features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsForm.tsx | 55 |
| code | }); | features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsForm.tsx | 57 |
| code | const openSetForEdit = (row: number, col: number): void => { | features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsGrid.tsx | 376 |
| code | if (!staticBindingSet.has(binding)) return; // 수치(M_) 셀은 병합 대상이 아니다 | features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsGrid.tsx | 378 |
| code | if (!item) return; | features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsGrid.tsx | 380 |
| code | if (!staticEditableByMeta(inputTpRef.current.get(binding), item)) return; | features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsGrid.tsx | 383 |
| code | const key = mergeCtxRef.current.setKeys?.get(item); | features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsGrid.tsx | 384 |
| code | if (!key \|\| mergeCtxRef.current.activeSetKey === key) return; | features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsGrid.tsx | 385 |
| code | const merged = g.getMergedRange(g.cells, row, col); | features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsGrid.tsx | 388 |
| code | if (!merged \|\| merged.row === merged.row2) return; | features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsGrid.tsx | 389 |
| code | if (other && mergeCtxRef.current.setKeys?.get(other) !== key) spansOtherSet = true; | features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsGrid.tsx | 393 |
| code | if (!spansOtherSet) return; | features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsGrid.tsx | 395 |
| code | if (g.activeEditor) g.finishEditing(); | features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsGrid.tsx | 398 |
| code | g.refresh(false); | features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsGrid.tsx | 404 |
| code | }; | features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsGrid.tsx | 405 |
| code | const closeActiveSet = (): void => { | features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsGrid.tsx | 482 |
| code | if (mergeCtxRef.current.activeSetKey == null) return; | features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsGrid.tsx | 483 |
| code | g.invalidate(); | features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsGrid.tsx | 485 |
| code | }; | features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsGrid.tsx | 486 |
| code | 편집 중인 셀(editRange 가드로 조기 return)과 정적/동적 어디에도 안 걸리는 컬럼 | features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsGrid.tsx | 496 |
| code | const clears = cascadeClearColumns(binding, row, lockCtxRef.current.division); | features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsGrid.tsx | 619 |
| code | clears.forEach(col => { | features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsGrid.tsx | 622 |
| code | }); | features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsGrid.tsx | 624 |
| code | s.invalidate(); | features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsGrid.tsx | 625 |
| code | syncInsertSet(s, row, [binding, ...clears]); | features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsGrid.tsx | 627 |
| code | · clbType(Report Type) `.cs:1530~1539` — InitSpread(); txtSPVersion.Text = null; | features/demand/src/pages/etc-sales-reports/EtcSalesReports.tsx | 247 |
| code | *주석 처리돼 있다**(`//if (GetText(ActiveRowIndex, Action) != "I") return;`) — 즉 AS-IS 는 | features/demand/src/pages/etc-sales-reports/EtcSalesReports.tsx | 368 |
| jsx | `SubTitle.tsx` 가 `{buttonActions.save === false \|\| (<Button .../>)}` 로 그린다. | features/demand/src/pages/etc-sales-reports/EtcSalesReports.tsx | 558 |
| jsx | action: () => setOpenModal('COLUMN'), iconComponent: <IcGridColumnSetup />, | features/demand/src/pages/etc-sales-reports/EtcSalesReports.tsx | 580 |
| code | 가드(if (sc.divisionId) return)에 걸려 자동선택이 발화하지 않고, '40' 권한이 없는 사용자에게도 | features/demand/src/pages/etc-sales-reports/useEtcSalesReportsStore.ts | 101 |
| endpoint | ⭐ master hook §2.3 — Column 동적 fetch (SHEET_COLUMNS 46건 'MDF Reports', hook #113 서버 직접 비교) | features/demand/src/pages/etc-sales-reports/useEtcSalesReportsStore.ts | 257 |
| endpoint | ⭐ master hook §5 — Measure 동적 fetch (SHEET_MEASURE 18건 — Measure Select 팝업 대상) | features/demand/src/pages/etc-sales-reports/useEtcSalesReportsStore.ts | 275 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

