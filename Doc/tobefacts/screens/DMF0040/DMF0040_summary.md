# DMF0040 — To-Be Fact Pack 요약

- page_key: `demand/mkt-fcst-comparison` · feature: demand · As-is Fact Pack 없음(화면ID 미대응)
- 파일 14 · 엔드포인트 호출 12 (미해결 0, 주석 속 1) · 이벤트 34 · 컴포넌트 사용 60 · 하드코딩 컬럼 8 · 메시지 29
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 사용 · 하드코딩 컬럼 정의 8건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/demand/src/pages/mkt-fcst-comparison/components/ComparisonVersionModal.module.scss | component | 35 |
| features/demand/src/pages/mkt-fcst-comparison/components/ComparisonVersionModal.tsx | component | 325 |
| features/demand/src/pages/mkt-fcst-comparison/components/MktFcstComparisonForm.module.scss | component | 17 |
| features/demand/src/pages/mkt-fcst-comparison/components/MktFcstComparisonForm.tsx | component | 507 |
| features/demand/src/pages/mkt-fcst-comparison/components/MktFcstComparisonGrid.tsx | component | 642 |
| features/demand/src/pages/mkt-fcst-comparison/index.ts | index | 2 |
| features/demand/src/pages/mkt-fcst-comparison/mkt-fcst-comparison.constants.test.ts | test | 56 |
| features/demand/src/pages/mkt-fcst-comparison/mkt-fcst-comparison.constants.ts | constants | 106 |
| features/demand/src/pages/mkt-fcst-comparison/mkt-fcst-comparison.types.ts | types | 47 |
| features/demand/src/pages/mkt-fcst-comparison/MktFcstComparison.tsx | page | 300 |
| features/demand/src/pages/mkt-fcst-comparison/useMktFcstComparisonStore.ts | store | 449 |
| features/demand/src/pages/mkt-fcst-comparison/utils/mkt-fcst-comparison.api.ts | api | 51 |
| features/demand/src/pages/mkt-fcst-comparison/utils/mkt-fcst-comparison.searchCombos.ts | util | 70 |
| features/demand/src/pages/mkt-fcst-comparison/__asis-mapping__.md | mapping | 181 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 4 | Y | ComparisonVersionModal.tsx:87 MktFcstComparisonForm.tsx:79 MktFcstComparisonForm.tsx:90 MktFcstComparison.tsx:94 |
| DMF0040/version//call-proc | hook | 1 | Y | ComparisonVersionModal.tsx:139 |
| DMF0040/mktFcstComparison//call-proc | hook | 1 | Y | MktFcstComparison.tsx:65 |
| DMF0040/spreadTitle//call-proc | hook | 1 | Y | MktFcstComparison.tsx:72 |
| /admin/menu/DMF0040/search-conditions | http | 1 | Y | useMktFcstComparisonStore.ts:238 |
| /admin/menu/DMF0040/column | http | 1 | Y | useMktFcstComparisonStore.ts:319 |
| DMF0040/titleSet/SEARCH/call-proc | http | 1 | Y | useMktFcstComparisonStore.ts:348 |
| /admin/menu/DMF0040/measure | http | 1 | Y | useMktFcstComparisonStore.ts:404 |
| /DMF0040/titleSet/SAVE/call-proc | http | 1 | Y | mkt-fcst-comparison.api.ts:40 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| mktFcstComparison | divisionId scmSiteId plantSiteId teamId customer bizType projectCode itemId fromYyyymmdd toYyyymmdd sesUserId versionNo itemType owner diffOnly bucket userId mnuId | o_rc1 | PKG_DMF0040 P_DMF0040_GET_MKT_FCST_COMPARISON DMF0040_GET_SPREAD_TITLE PKG_SCM0002 P_SCM0002_GET_VERSIONBYWATERFALLPOPUP |
| spreadTitle | startYyyymmdd endYyyymmdd sesUserId divisionId bucket | o_rc1 | PKG_DMF0040 P_DMF0040_GET_MKT_FCST_COMPARISON DMF0040_GET_SPREAD_TITLE PKG_SCM0002 P_SCM0002_GET_VERSIONBYWATERFALLPOPUP |
| version | startYyyymmdd endYyyymmdd createdBy divisionId versionType versionNo | o_rc1 | PKG_DMF0040 P_DMF0040_GET_MKT_FCST_COMPARISON DMF0040_GET_SPREAD_TITLE PKG_SCM0002 P_SCM0002_GET_VERSIONBYWATERFALLPOPUP |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| g.hostElement? | dblclick | onDbl | addEventListener | features/demand/src/pages/mkt-fcst-comparison/components/ComparisonVersionModal.tsx | 183 |
| SearchArea | onSearch | handleFind | jsx | features/demand/src/pages/mkt-fcst-comparison/components/ComparisonVersionModal.tsx | 215 |
| CustomDropdown | onChange | <arrow> setDivisionId,String | jsx | features/demand/src/pages/mkt-fcst-comparison/components/ComparisonVersionModal.tsx | 228 |
| PeriodField | onChange | <arrow> setPeriodFrom,setPeriodTo | jsx | features/demand/src/pages/mkt-fcst-comparison/components/ComparisonVersionModal.tsx | 237 |
| Checkbox | onChange | <arrow> setChkDay | jsx | features/demand/src/pages/mkt-fcst-comparison/components/ComparisonVersionModal.tsx | 248 |
| Checkbox | onChange | <arrow> setChkWeek | jsx | features/demand/src/pages/mkt-fcst-comparison/components/ComparisonVersionModal.tsx | 253 |
| Checkbox | onChange | <arrow> setChkManual | jsx | features/demand/src/pages/mkt-fcst-comparison/components/ComparisonVersionModal.tsx | 258 |
| InputField | onChange | <arrow> setDescription | jsx | features/demand/src/pages/mkt-fcst-comparison/components/ComparisonVersionModal.tsx | 270 |
| Button | onClick | modalClose | jsx | features/demand/src/pages/mkt-fcst-comparison/components/ComparisonVersionModal.tsx | 307 |
| Button | onClick | handleApply | jsx | features/demand/src/pages/mkt-fcst-comparison/components/ComparisonVersionModal.tsx | 317 |
| CustomDropdown | onChange | <arrow> onPick,String(picked??'').split(',').filter,String(picked??'').split,String | jsx | features/demand/src/pages/mkt-fcst-comparison/components/MktFcstComparisonForm.tsx | 162 |
| SearchArea | onSearch | onSubmit | jsx | features/demand/src/pages/mkt-fcst-comparison/components/MktFcstComparisonForm.tsx | 243 |
| CustomDropdown | onChange | <arrow> String,setSearchParams,onDivisionChange | jsx | features/demand/src/pages/mkt-fcst-comparison/components/MktFcstComparisonForm.tsx | 258 |
| PeriodField | onChange | <arrow> setSearchParams | jsx | features/demand/src/pages/mkt-fcst-comparison/components/MktFcstComparisonForm.tsx | 315 |
| CustomDropdown | onChange | <arrow> setSearchParams,onBucketChange | jsx | features/demand/src/pages/mkt-fcst-comparison/components/MktFcstComparisonForm.tsx | 327 |
| ProjectField | onChange | <arrow> setSearchParams | jsx | features/demand/src/pages/mkt-fcst-comparison/components/MktFcstComparisonForm.tsx | 345 |
| ItemField | onChange | <arrow> setSearchParams | jsx | features/demand/src/pages/mkt-fcst-comparison/components/MktFcstComparisonForm.tsx | 356 |
| CustomDropdown | onChange | <arrow> setSearchParams,String(options??'').split(',').filter,String(options??'').split,String | jsx | features/demand/src/pages/mkt-fcst-comparison/components/MktFcstComparisonForm.tsx | 376 |
| OwnerField | onChange | <arrow> setSearchParams | jsx | features/demand/src/pages/mkt-fcst-comparison/components/MktFcstComparisonForm.tsx | 390 |
| InputField | onClick | <arrow> setOpenVersionModal | jsx | features/demand/src/pages/mkt-fcst-comparison/components/MktFcstComparisonForm.tsx | 436 |
| InputField | onKeyDown | <arrow> setOpenVersionModal | jsx | features/demand/src/pages/mkt-fcst-comparison/components/MktFcstComparisonForm.tsx | 437 |
| Button | onClick | <arrow> setOpenVersionModal | jsx | features/demand/src/pages/mkt-fcst-comparison/components/MktFcstComparisonForm.tsx | 443 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/demand/src/pages/mkt-fcst-comparison/components/MktFcstComparisonForm.tsx | 459 |
| Checkbox | onChange | <arrow> setSearchParams | jsx | features/demand/src/pages/mkt-fcst-comparison/components/MktFcstComparisonForm.tsx | 475 |
| Checkbox | onChange | <arrow> setSearchParams | jsx | features/demand/src/pages/mkt-fcst-comparison/components/MktFcstComparisonForm.tsx | 481 |
| ComparisonVersionModal | onApply | <arrow> setSearchParams | jsx | features/demand/src/pages/mkt-fcst-comparison/components/MktFcstComparisonForm.tsx | 495 |
| g | updatedLayout | applyHeaderHeight | addHandler | features/demand/src/pages/mkt-fcst-comparison/components/MktFcstComparisonGrid.tsx | 414 |
| g.hostElement? | dblclick | onDblClick | addEventListener | features/demand/src/pages/mkt-fcst-comparison/components/MktFcstComparisonGrid.tsx | 568 |
| g | formatItem | formatHandler | addHandler | features/demand/src/pages/mkt-fcst-comparison/components/MktFcstComparisonGrid.tsx | 618 |
| MktFcstComparisonForm | onSubmit | handleSubmit | jsx | features/demand/src/pages/mkt-fcst-comparison/MktFcstComparison.tsx | 219 |
| MktFcstComparisonForm | onDivisionChange | handleDivisionChange | jsx | features/demand/src/pages/mkt-fcst-comparison/MktFcstComparison.tsx | 220 |
| MktFcstComparisonForm | onBucketChange | handleBucketChange | jsx | features/demand/src/pages/mkt-fcst-comparison/MktFcstComparison.tsx | 221 |
| ColumnLayoutModal | onSave | <arrow> applyColumnLayout,settings.map,settings.filter,saveTitleSet,visible.map,clearData | jsx | features/demand/src/pages/mkt-fcst-comparison/MktFcstComparison.tsx | 254 |
| MeasureSelectModal | onApply | <arrow> staticMeasures.map,saveTitleSet,selected.map,clearData | jsx | features/demand/src/pages/mkt-fcst-comparison/MktFcstComparison.tsx | 287 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 10 |
| FormItem | 9 |
| CustomDropdown | 6 |
| Checkbox | 5 |
| Stack | 3 |
| Button | 3 |
| SearchArea | 2 |
| PeriodField | 2 |
| InputField | 2 |
| DataGrid | 2 |
| CustomDialog | 1 |
| ProgressIndicator | 1 |
| ResultArea | 1 |
| ControlConfirmIcon | 1 |
| ProjectField | 1 |
| ItemField | 1 |
| OwnerField | 1 |
| FunctionSearchIcon | 1 |
| ComparisonVersionModal | 1 |
| IcGridColumnSetup | 1 |
| MainTitle | 1 |
| MktFcstComparisonForm | 1 |
| SubTitle | 1 |
| MktFcstComparisonGrid | 1 |
| ColumnLayoutModal | 1 |
| MeasureSelectModal | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| VERSION_COLUMNS | VERSION_NO | Version | 240 |  |  |  | meta-shape | features/demand/src/pages/mkt-fcst-comparison/components/ComparisonVersionModal.tsx | 54 |
| VERSION_COLUMNS | VERSION_DESCRIPTION | Description | 300 |  |  |  | meta-shape | features/demand/src/pages/mkt-fcst-comparison/components/ComparisonVersionModal.tsx | 55 |
| VERSION_COLUMNS | VERSION_TYPE | Type | 90 |  |  |  | meta-shape | features/demand/src/pages/mkt-fcst-comparison/components/ComparisonVersionModal.tsx | 56 |
| VERSION_COLUMNS | CREATED_BY | Create By | 110 |  |  |  | meta-shape | features/demand/src/pages/mkt-fcst-comparison/components/ComparisonVersionModal.tsx | 57 |
| VERSION_COLUMNS | CREATION_DATE | Create Date | 150 |  |  |  | meta-shape | features/demand/src/pages/mkt-fcst-comparison/components/ComparisonVersionModal.tsx | 58 |
| dynColMetas | String(r.COLUMN_NAME) |  | widthOf(r.COLUMN_WIDTH) |  |  |  | object | features/demand/src/pages/mkt-fcst-comparison/components/MktFcstComparisonGrid.tsx | 176 |
| dynColMetas | b |  | widthOf('') |  |  |  | object | features/demand/src/pages/mkt-fcst-comparison/components/MktFcstComparisonGrid.tsx | 193 |
| dynamicColumns | m.binding | isOnlyWeekly ? 'SUM' : dailyVisible ? m.kind === 'D' ? m.lea | m.width | dynVisible(m.binding) | true |  | object | features/demand/src/pages/mkt-fcst-comparison/components/MktFcstComparisonGrid.tsx | 260 |

## 7. 메시지 코드
| code | count |
|---|---|
| MSG00283 | 2 |
| LBL00674 | 1 |
| LBL00664 | 1 |
| LBL00001 | 2 |
| LBL00852 | 1 |
| LBL00853 | 1 |
| LBL00854 | 1 |
| LBL00608 | 1 |
| LBL00627 | 1 |
| LBL00112 | 1 |
| LBL00502 | 1 |
| LBL00080 | 1 |
| LBL00506 | 1 |
| LBL00085 | 1 |
| LBL00005 | 1 |
| LBL00710 | 1 |
| LBL00031 | 1 |
| LBL00687 | 1 |
| MSG00097 | 1 |
| MSG00108 | 1 |
| MSG00164 | 1 |
| MSG00255 | 1 |
| MSG00013 | 1 |
| LBL00605 | 2 |
| LBL00764 | 1 |
| LBL00765 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: DMF0040(12), DMF0035(8), DMF0082(4), DMF0053(3), DMF0003(2), DMF0048(2), DMF0021(1)
- SP/PKG: DMF0040_GET_SPREAD_TITLE(5), PKG_DMF0040(4), P_DMF0040_GET_MKT_FCST_COMPARISON(2), PKG_SCM0002(1), P_SCM0002_GET_VERSIONBYWATERFALLPOPUP(1), DMF0003_GET_REPORT_BUCKET_TYPE_CODE(1), PR_GET_SHEET_COLUMN_LIST(1), SCM0002_GET_TITLESET_POPUP(1), SCM0002_SET_TITLESET_POPUP(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | const session = useSessionStore(state => state.session); // Ver. 자동설정 기능 주석처리(2026-09-09 사용자 지정)로 미사용 (구현은 아래 주석 참조) | features/demand/src/pages/mkt-fcst-comparison/components/MktFcstComparisonForm.tsx | 58 |
| code | const defaultVersionFilters = useMemo( | features/demand/src/pages/mkt-fcst-comparison/components/MktFcstComparisonForm.tsx | 193 |
| code | () => | features/demand/src/pages/mkt-fcst-comparison/components/MktFcstComparisonForm.tsx | 194 |
| code | ); | features/demand/src/pages/mkt-fcst-comparison/components/MktFcstComparisonForm.tsx | 212 |
| endpoint | const defaultVersionQuery = useTabProcQuery<MENU_ID, SHEETS.VERSION>({ | features/demand/src/pages/mkt-fcst-comparison/components/MktFcstComparisonForm.tsx | 213 |
| code | }); | features/demand/src/pages/mkt-fcst-comparison/components/MktFcstComparisonForm.tsx | 219 |
| code | useEffect(() => { | features/demand/src/pages/mkt-fcst-comparison/components/MktFcstComparisonForm.tsx | 220 |
| code | if (searchParams.version) return; | features/demand/src/pages/mkt-fcst-comparison/components/MktFcstComparisonForm.tsx | 221 |
| code | const rows = (defaultVersionQuery.data?.o_rc1 ?? []) as Array<{ VERSION_NO: string }>; | features/demand/src/pages/mkt-fcst-comparison/components/MktFcstComparisonForm.tsx | 222 |
| code | if (rows.length === 0) return; | features/demand/src/pages/mkt-fcst-comparison/components/MktFcstComparisonForm.tsx | 223 |
| code | .map(r => String(r.VERSION_NO ?? '')) | features/demand/src/pages/mkt-fcst-comparison/components/MktFcstComparisonForm.tsx | 225 |
| code | .filter(v => v && v.toUpperCase() !== 'CURRENT') | features/demand/src/pages/mkt-fcst-comparison/components/MktFcstComparisonForm.tsx | 226 |
| code | .slice(0, 2); | features/demand/src/pages/mkt-fcst-comparison/components/MktFcstComparisonForm.tsx | 227 |
| code | if (picked.length > 0) setSearchParams({ version: picked.join(',') }); | features/demand/src/pages/mkt-fcst-comparison/components/MktFcstComparisonForm.tsx | 228 |
| code | }, [defaultVersionQuery.data, searchParams.version, setSearchParams]); | features/demand/src/pages/mkt-fcst-comparison/components/MktFcstComparisonForm.tsx | 229 |
| code | onClick={() => setOpenVersionModal(true)} | features/demand/src/pages/mkt-fcst-comparison/components/MktFcstComparisonForm.tsx | 422 |
| code | onClick={() => setOpenVersionModal(true)} | features/demand/src/pages/mkt-fcst-comparison/components/MktFcstComparisonForm.tsx | 428 |
| code | onKeyDown={() => setOpenVersionModal(true)} // AS-IS txtVersion_KeyDown L1670 — 키 = 팝업 | features/demand/src/pages/mkt-fcst-comparison/components/MktFcstComparisonForm.tsx | 429 |
| code | 저장된 컬럼 개인화(titleSet 'C') 복원 — userColumnLayout 세팅. fetchStaticColumns 가 먼저 await 해 override 를 확보한 뒤 admin 메타에 적용한다(별도 effect 로 분리하면 응답 순서 경쟁 사고). | features/demand/src/pages/mkt-fcst-comparison/useMktFcstComparisonStore.ts | 57 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

