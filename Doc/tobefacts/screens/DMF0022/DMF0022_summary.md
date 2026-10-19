# DMF0022 — To-Be Fact Pack 요약

- page_key: `report/sales-plan-waterfall` · feature: report · As-is Fact Pack 있음
- 파일 8 · 엔드포인트 호출 4 (미해결 0, 주석 속 0) · 이벤트 34 · 컴포넌트 사용 64 · 하드코딩 컬럼 1 · 메시지 6
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 사용 · 하드코딩 컬럼 정의 1건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/report/src/pages/sales-plan-waterfall/components/SalesPlanWaterfallForm.module.scss | component | 17 |
| features/report/src/pages/sales-plan-waterfall/components/SalesPlanWaterfallForm.tsx | component | 526 |
| features/report/src/pages/sales-plan-waterfall/components/SalesPlanWaterfallGrid.tsx | component | 87 |
| features/report/src/pages/sales-plan-waterfall/index.ts | index | 2 |
| features/report/src/pages/sales-plan-waterfall/sales-plan-waterfall.constants.ts | constants | 15 |
| features/report/src/pages/sales-plan-waterfall/sales-plan-waterfall.types.ts | types | 26 |
| features/report/src/pages/sales-plan-waterfall/SalesPlanWaterfall.tsx | page | 127 |
| features/report/src/pages/sales-plan-waterfall/useSalesPlanWaterfallStore.ts | store | 140 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 1 | Y | SalesPlanWaterfallForm.tsx:58 |
| DMF0022/spreadTitle//call-proc | hook | 1 | Y | SalesPlanWaterfallGrid.tsx:31 |
| DMF0022/salesPlanWaterfall//call-proc | hook | 1 | Y | SalesPlanWaterfall.tsx:32 |
| /admin/menu/DMF0022/column | http | 1 | Y | useSalesPlanWaterfallStore.ts:126 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| salesPlanWaterfall | divisionId deptId endCustomer scmSiteId projectCode itemId itemType fromYyyymmdd nowYyyymmdd toYyyymmdd sesUserId plantSiteId bizType owner internalYn cellYn versionType bucket userDeptId groupId userId menuId | o_rc1 | PKG_DMF0022 P_DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL DMF0022_GET_SPREAD_TITLE |
| spreadTitle | divisionId bucket fromYyyymmdd toYyyymmdd sesUserId userId | o_rc1 | PKG_DMF0022 P_DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL DMF0022_GET_SPREAD_TITLE |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | onSubmit | jsx | features/report/src/pages/sales-plan-waterfall/components/SalesPlanWaterfallForm.tsx | 478 |
| DivisionField | onChange | <arrow> setSearchParams | jsx | features/report/src/pages/sales-plan-waterfall/components/SalesPlanWaterfallForm.tsx | 81 |
| TeamField | onChange | <arrow> setSearchParams,v.join | jsx | features/report/src/pages/sales-plan-waterfall/components/SalesPlanWaterfallForm.tsx | 96 |
| EndCustomerField | onChange | <arrow> setSearchParams,v.join | jsx | features/report/src/pages/sales-plan-waterfall/components/SalesPlanWaterfallForm.tsx | 115 |
| SalesSiteField | onChange | <arrow> setSearchParams,v.join | jsx | features/report/src/pages/sales-plan-waterfall/components/SalesPlanWaterfallForm.tsx | 133 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/report/src/pages/sales-plan-waterfall/components/SalesPlanWaterfallForm.tsx | 147 |
| InputField | onKeyDown | <arrow> setOpenVersionModal | jsx | features/report/src/pages/sales-plan-waterfall/components/SalesPlanWaterfallForm.tsx | 162 |
| InputField | onDoubleClick | <arrow> setOpenVersionModal | jsx | features/report/src/pages/sales-plan-waterfall/components/SalesPlanWaterfallForm.tsx | 163 |
| FunctionSearchIcon | onClick | <arrow> setOpenVersionModal | jsx | features/report/src/pages/sales-plan-waterfall/components/SalesPlanWaterfallForm.tsx | 156 |
| PeriodField | onChange | <arrow> setSearchParams,dayjs,start.slice,end.slice | jsx | features/report/src/pages/sales-plan-waterfall/components/SalesPlanWaterfallForm.tsx | 176 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/report/src/pages/sales-plan-waterfall/components/SalesPlanWaterfallForm.tsx | 196 |
| Checkbox | onChange | <arrow> setSearchParams | jsx | features/report/src/pages/sales-plan-waterfall/components/SalesPlanWaterfallForm.tsx | 210 |
| Checkbox | onChange | <arrow> setSearchParams | jsx | features/report/src/pages/sales-plan-waterfall/components/SalesPlanWaterfallForm.tsx | 215 |
| Checkbox | onChange | <arrow> setSearchParams | jsx | features/report/src/pages/sales-plan-waterfall/components/SalesPlanWaterfallForm.tsx | 221 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/report/src/pages/sales-plan-waterfall/components/SalesPlanWaterfallForm.tsx | 245 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/report/src/pages/sales-plan-waterfall/components/SalesPlanWaterfallForm.tsx | 267 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/report/src/pages/sales-plan-waterfall/components/SalesPlanWaterfallForm.tsx | 289 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/report/src/pages/sales-plan-waterfall/components/SalesPlanWaterfallForm.tsx | 307 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/report/src/pages/sales-plan-waterfall/components/SalesPlanWaterfallForm.tsx | 325 |
| InputField | onKeyDown | <arrow> setOpenProjectModal | jsx | features/report/src/pages/sales-plan-waterfall/components/SalesPlanWaterfallForm.tsx | 340 |
| InputField | onDoubleClick | <arrow> setOpenProjectModal | jsx | features/report/src/pages/sales-plan-waterfall/components/SalesPlanWaterfallForm.tsx | 341 |
| FunctionSearchIcon | onClick | <arrow> setOpenProjectModal | jsx | features/report/src/pages/sales-plan-waterfall/components/SalesPlanWaterfallForm.tsx | 334 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/report/src/pages/sales-plan-waterfall/components/SalesPlanWaterfallForm.tsx | 360 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/report/src/pages/sales-plan-waterfall/components/SalesPlanWaterfallForm.tsx | 384 |
| Checkbox | onChange | <arrow> setSearchParams | jsx | features/report/src/pages/sales-plan-waterfall/components/SalesPlanWaterfallForm.tsx | 397 |
| PlantSiteField | onChange | <arrow> setSearchParams,v.join | jsx | features/report/src/pages/sales-plan-waterfall/components/SalesPlanWaterfallForm.tsx | 413 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/report/src/pages/sales-plan-waterfall/components/SalesPlanWaterfallForm.tsx | 425 |
| InputField | onDoubleClick | <arrow> setOpenOwnerModal | jsx | features/report/src/pages/sales-plan-waterfall/components/SalesPlanWaterfallForm.tsx | 440 |
| FunctionSearchIcon | onClick | <arrow> setOpenOwnerModal | jsx | features/report/src/pages/sales-plan-waterfall/components/SalesPlanWaterfallForm.tsx | 434 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/report/src/pages/sales-plan-waterfall/components/SalesPlanWaterfallForm.tsx | 455 |
| InputField | onKeyDown | <arrow> setOpenItemModal | jsx | features/report/src/pages/sales-plan-waterfall/components/SalesPlanWaterfallForm.tsx | 470 |
| InputField | onDoubleClick | <arrow> setOpenItemModal | jsx | features/report/src/pages/sales-plan-waterfall/components/SalesPlanWaterfallForm.tsx | 471 |
| FunctionSearchIcon | onClick | <arrow> setOpenItemModal | jsx | features/report/src/pages/sales-plan-waterfall/components/SalesPlanWaterfallForm.tsx | 464 |
| SalesPlanWaterfallForm | onSubmit | handleSubmit | jsx | features/report/src/pages/sales-plan-waterfall/SalesPlanWaterfall.tsx | 107 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 13 |
| FormItem | 11 |
| CustomDropdown | 7 |
| InputField | 4 |
| Button | 4 |
| FunctionSearchIcon | 4 |
| Checkbox | 4 |
| Stack | 2 |
| SearchArea | 1 |
| DivisionField | 1 |
| TeamField | 1 |
| EndCustomerField | 1 |
| SalesSiteField | 1 |
| PeriodField | 1 |
| PlantSiteField | 1 |
| ProjectByDivisionModal | 1 |
| ItemByDivisionModal | 1 |
| OwnerByDivisionModal | 1 |
| DataGrid | 1 |
| MainTitle | 1 |
| SalesPlanWaterfallForm | 1 |
| SubTitle | 1 |
| SalesPlanWaterfallGrid | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| dynamicColumns | String(row.COLUMN_NAME) | String(row.COLUMN_LABEL_NAME ?? '') | row.COLUMN_WIDTH ? Number(row.COLUMN_WIDTH) : undefined | true |  |  | meta-map | features/report/src/pages/sales-plan-waterfall/components/SalesPlanWaterfallGrid.tsx | 46 |

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00112 | 1 |
| LBL00031 | 1 |
| LBL00032 | 1 |
| LBL00085 | 1 |
| LBL00618 | 1 |
| MSG00013 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: (없음)
- SP/PKG: (없음)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | TODO(S4): Freeze — frozenColumns = columns.findIndex(c => c.binding === 'MEASURE') + 1 | features/report/src/pages/sales-plan-waterfall/components/SalesPlanWaterfallGrid.tsx | 68 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

