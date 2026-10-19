# SDM2020 — To-Be Fact Pack 요약

- page_key: `spms-demand/plan-yield` · feature: spms-demand · As-is Fact Pack 없음(화면ID 미대응)
- 파일 15 · 엔드포인트 호출 10 (미해결 1, 주석 속 1) · 이벤트 16 · 컴포넌트 사용 9 · 하드코딩 컬럼 0 · 메시지 18
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/spms-demand/src/pages/plan-yield/components/RequestPlantPanel.module.scss | component | 137 |
| features/spms-demand/src/pages/plan-yield/components/RequestPlantPanel.tsx | component | 333 |
| features/spms-demand/src/pages/plan-yield/components/YieldLossGrid.module.scss | component | 40 |
| features/spms-demand/src/pages/plan-yield/components/YieldLossGrid.tsx | component | 218 |
| features/spms-demand/src/pages/plan-yield/index.ts | index | 2 |
| features/spms-demand/src/pages/plan-yield/plan-yield.constants.ts | constants | 87 |
| features/spms-demand/src/pages/plan-yield/plan-yield.types.ts | types | 27 |
| features/spms-demand/src/pages/plan-yield/PlanYield.module.scss | style | 54 |
| features/spms-demand/src/pages/plan-yield/PlanYield.tsx | page | 346 |
| features/spms-demand/src/pages/plan-yield/usePlanYieldStore.ts | store | 168 |
| features/spms-demand/src/pages/plan-yield/utils/plan-yield.api.ts | api | 64 |
| features/spms-demand/src/pages/plan-yield/utils/plan-yield.editLock.test.ts | test | 97 |
| features/spms-demand/src/pages/plan-yield/utils/plan-yield.editLock.ts | util | 83 |
| features/spms-demand/src/pages/plan-yield/utils/plan-yield.payload.test.ts | test | 158 |
| features/spms-demand/src/pages/plan-yield/utils/plan-yield.payload.ts | util | 97 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| SDM2020/tree//call-proc | hook | 1 | Y | PlanYield.tsx:74 |
| SDM2020/process//call-proc | hook | 1 | Y | PlanYield.tsx:81 |
| SDM2020/build//call-proc | hook | 1 | Y | PlanYield.tsx:88 |
| SDM2020/yield//call-proc | hook | 1 | Y | PlanYield.tsx:95 |
| /admin/menu/SDM2020/column | http | 1 | Y | usePlanYieldStore.ts:150 |
| /SDM2020/tree\|process\|build\|plant\|yield/{btnCd}/call-proc | http | 1 | N | plan-yield.api.ts:18 |
| SDM2020/plant/SAVEPLANT/call-proc | callProc | 1 | Y | plan-yield.api.ts:40 |
| SDM2020/yield/CONFIRM/call-proc | callProc | 1 | Y | plan-yield.api.ts:63 |
| /SDM2020/tree\|process\|build\|plant\|yield/SAVEPLANT/call-proc | propagated | 1 | Y | plan-yield.api.ts:40 |
| /SDM2020/tree\|process\|build\|plant\|yield/CONFIRM/call-proc | propagated | 1 | Y | plan-yield.api.ts:63 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| tree | sesDivisionId | data | PKG_SDM2020 P_SDM2020_GET_PJT_SAMPLE_TREE P_SDM2020_GET_PJT_YIELD P_SDM2020_SAVE_PJT_SAMPLE_BUILD P_OPERATION_ID P_SDM2020_SAVE_PJT_YIELD |
| process | dpjtCode dpjtBuildNo sesDivisionId | data | PKG_SDM2020 P_SDM2020_GET_PJT_SAMPLE_TREE P_SDM2020_GET_PJT_YIELD P_SDM2020_SAVE_PJT_SAMPLE_BUILD P_OPERATION_ID P_SDM2020_SAVE_PJT_YIELD |
| build | dpjtCode dpjtBuildNo sesDivisionId | data plant | PKG_SDM2020 P_SDM2020_GET_PJT_SAMPLE_TREE P_SDM2020_GET_PJT_YIELD P_SDM2020_SAVE_PJT_SAMPLE_BUILD P_OPERATION_ID P_SDM2020_SAVE_PJT_YIELD |
| yield | dpjtCode dpjtBuildNo operationGroup mgmtType sesDivisionId | data | PKG_SDM2020 P_SDM2020_GET_PJT_SAMPLE_TREE P_SDM2020_GET_PJT_YIELD P_SDM2020_SAVE_PJT_SAMPLE_BUILD P_OPERATION_ID P_SDM2020_SAVE_PJT_YIELD |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| g | formatItem | formatHandler | addHandler | features/spms-demand/src/pages/plan-yield/components/RequestPlantPanel.tsx | 195 |
| g | beginningEdit | beginningEditHandler | addHandler | features/spms-demand/src/pages/plan-yield/components/RequestPlantPanel.tsx | 208 |
| g | pastingCell | beginningEditHandler | addHandler | features/spms-demand/src/pages/plan-yield/components/RequestPlantPanel.tsx | 209 |
| g | selectionChanged | selectionHandler | addHandler | features/spms-demand/src/pages/plan-yield/components/RequestPlantPanel.tsx | 222 |
| Button | onClick | onSave | jsx | features/spms-demand/src/pages/plan-yield/components/RequestPlantPanel.tsx | 252 |
| DataGrid | initialized | handleGridInitialized | jsx | features/spms-demand/src/pages/plan-yield/components/RequestPlantPanel.tsx | 296 |
| g | formatItem | formatHandler | addHandler | features/spms-demand/src/pages/plan-yield/components/YieldLossGrid.tsx | 136 |
| g | beginningEdit | beginningEditHandler | addHandler | features/spms-demand/src/pages/plan-yield/components/YieldLossGrid.tsx | 149 |
| g | pastingCell | beginningEditHandler | addHandler | features/spms-demand/src/pages/plan-yield/components/YieldLossGrid.tsx | 150 |
| g.hostElement | click | clickHandler | addEventListener | features/spms-demand/src/pages/plan-yield/components/YieldLossGrid.tsx | 169 |
| g | formatItem | cornerHandler | addHandler | features/spms-demand/src/pages/plan-yield/components/YieldLossGrid.tsx | 175 |
| DataGrid | initialized | handleGridInitialized | jsx | features/spms-demand/src/pages/plan-yield/components/YieldLossGrid.tsx | 208 |
| SampleStatusTree | onToggleProgress | setInProgressOnly | jsx | features/spms-demand/src/pages/plan-yield/PlanYield.tsx | 282 |
| SampleStatusTree | onSelectBuild | handleSelectBuild | jsx | features/spms-demand/src/pages/plan-yield/PlanYield.tsx | 283 |
| RequestPlantPanel | onSave | handleSavePlant | jsx | features/spms-demand/src/pages/plan-yield/PlanYield.tsx | 301 |
| RequestPlantPanel | onSelectRow | handleSelectPlantRow | jsx | features/spms-demand/src/pages/plan-yield/PlanYield.tsx | 302 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| DataGrid | 2 |
| Button | 1 |
| MainTitle | 1 |
| SampleStatusTree | 1 |
| SampleProcessFlow | 1 |
| RequestPlantPanel | 1 |
| SubTitle | 1 |
| YieldLossGrid | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| MSG00001 | 1 |
| MSG00002 | 1 |
| MSG00003 | 1 |
| MSG00004 | 1 |
| MSG00014 | 1 |
| MSG00703 | 1 |
| MSG01024 | 1 |
| MSG01025 | 1 |
| MSG01026 | 1 |
| LBL00873 | 1 |
| LBL01025 | 1 |
| LBL01026 | 1 |
| LBL01027 | 1 |
| LBL00395 | 1 |
| LBL01034 | 1 |
| LBL01031 | 1 |
| LBL01032 | 1 |
| LBL01033 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SDM2020(13), SDM2010(6), DMF0044(2), SDM5010(1)
- SP/PKG: PKG_SDM2020(6), P_SDM2020_SAVE_PJT_SAMPLE_BUILD(4), P_OPERATION_ID(4), P_SDM2020_SAVE_PJT_YIELD(3), P_SDM2020_GET_PJT_YIELD(2), P_PLANT_ID(2), P_OPERATION_GROUP(2), P_MGMT_TYPE(2), P_SDM2020_GET_PJT_SAMPLE_BUILD(1), PKG_SDM2020_YIELD(1), P_DPJT_CODE(1), P_DPJT_BUILD_NO(1), P_CONFIRM_FLAG(1), P_SES_DIVISION_ID(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| endpoint | ⭐ master hook §2.3 — Column 동적 fetch (SHEET_COLUMNS — 시트별. 하드코딩 fallback 금지) | features/spms-demand/src/pages/plan-yield/usePlanYieldStore.ts | 143 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

