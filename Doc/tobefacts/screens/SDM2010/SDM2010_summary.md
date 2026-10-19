# SDM2010 — To-Be Fact Pack 요약

- page_key: `spms-demand/production-request` · feature: spms-demand · As-is Fact Pack 없음(화면ID 미대응)
- 파일 14 · 엔드포인트 호출 9 (미해결 0, 주석 속 2) · 이벤트 21 · 컴포넌트 사용 17 · 하드코딩 컬럼 0 · 메시지 20
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/spms-demand/src/pages/production-request/components/SampleBuildPanel.module.scss | component | 74 |
| features/spms-demand/src/pages/production-request/components/SampleBuildPanel.tsx | component | 150 |
| features/spms-demand/src/pages/production-request/components/SampleDemandGrid.module.scss | component | 15 |
| features/spms-demand/src/pages/production-request/components/SampleDemandGrid.tsx | component | 191 |
| features/spms-demand/src/pages/production-request/components/SampleTree.module.scss | component | 36 |
| features/spms-demand/src/pages/production-request/components/SampleTree.tsx | component | 67 |
| features/spms-demand/src/pages/production-request/index.ts | index | 2 |
| features/spms-demand/src/pages/production-request/production-request.constants.ts | constants | 73 |
| features/spms-demand/src/pages/production-request/production-request.types.ts | types | 66 |
| features/spms-demand/src/pages/production-request/ProductionRequest.module.scss | style | 38 |
| features/spms-demand/src/pages/production-request/ProductionRequest.tsx | page | 374 |
| features/spms-demand/src/pages/production-request/useProductionRequestStore.ts | store | 133 |
| features/spms-demand/src/pages/production-request/utils/production-request.api.ts | api | 102 |
| features/spms-demand/src/pages/production-request/utils/production-request.tree.ts | util | 158 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabLookupQueries) | hook | 1 | Y | SampleBuildPanel.tsx:40 |
| (useTabComboQueries) | hook | 1 | Y | SampleDemandGrid.tsx:61 |
| SDM2010/tree//call-proc | hook | 1 | Y | ProductionRequest.tsx:90 |
| SDM2010/process//call-proc | hook | 1 | Y | ProductionRequest.tsx:97 |
| SDM2010/build//call-proc | hook | 1 | Y | ProductionRequest.tsx:105 |
| SDM2010/demand//call-proc | hook | 1 | Y | ProductionRequest.tsx:113 |
| /admin/menu/SDM2010/column | http | 1 | Y | useProductionRequestStore.ts:115 |
| /SDM2010/build/SAVEBUILD/call-proc | http | 1 | Y | production-request.api.ts:34 |
| /SDM2010/demand/SAVE/call-proc | http | 1 | Y | production-request.api.ts:66 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| tree | sesDivisionId | data | P_SDM2010_GET_PJT_SAMPLE_TREE P_SES_DIVISION_ID P_SES_USER_ID P_SDM2010_GET_PJT_SAMPLE_PROCESS P_DPJT_CODE P_DPJT_BUILD_NO P_SDM2010_GET_PJT_SAMPLE_BUILD PKG_SDM2010 P_SDM2010_SAVE_PJT_SAMPLE_BUILD P_DPJT_BUILD_SEQ P_DPJT_BIND_SEQ P_SDM2010_SAVE_PJT_SAMPLE_DEMAND |
| process | dpjtCode dpjtBuildNo sesDivisionId | data | P_SDM2010_GET_PJT_SAMPLE_TREE P_SES_DIVISION_ID P_SES_USER_ID P_SDM2010_GET_PJT_SAMPLE_PROCESS P_DPJT_CODE P_DPJT_BUILD_NO P_SDM2010_GET_PJT_SAMPLE_BUILD PKG_SDM2010 P_SDM2010_SAVE_PJT_SAMPLE_BUILD P_DPJT_BUILD_SEQ P_DPJT_BIND_SEQ P_SDM2010_SAVE_PJT_SAMPLE_DEMAND |
| build | dpjtCode dpjtBuildNo sesDivisionId | data | P_SDM2010_GET_PJT_SAMPLE_TREE P_SES_DIVISION_ID P_SES_USER_ID P_SDM2010_GET_PJT_SAMPLE_PROCESS P_DPJT_CODE P_DPJT_BUILD_NO P_SDM2010_GET_PJT_SAMPLE_BUILD PKG_SDM2010 P_SDM2010_SAVE_PJT_SAMPLE_BUILD P_DPJT_BUILD_SEQ P_DPJT_BIND_SEQ P_SDM2010_SAVE_PJT_SAMPLE_DEMAND |
| demand | dpjtCode dpjtBuildNo sesDivisionId | data | P_SDM2010_GET_PJT_SAMPLE_TREE P_SES_DIVISION_ID P_SES_USER_ID P_SDM2010_GET_PJT_SAMPLE_PROCESS P_DPJT_CODE P_DPJT_BUILD_NO P_SDM2010_GET_PJT_SAMPLE_BUILD PKG_SDM2010 P_SDM2010_SAVE_PJT_SAMPLE_BUILD P_DPJT_BUILD_SEQ P_DPJT_BIND_SEQ P_SDM2010_SAVE_PJT_SAMPLE_DEMAND |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| Button | onClick | onCancel | jsx | features/spms-demand/src/pages/production-request/components/SampleBuildPanel.tsx | 62 |
| Button | onClick | onInsert | jsx | features/spms-demand/src/pages/production-request/components/SampleBuildPanel.tsx | 70 |
| Button | onClick | onSave | jsx | features/spms-demand/src/pages/production-request/components/SampleBuildPanel.tsx | 80 |
| CustomDropdown | onChange | <arrow> onFormChange | jsx | features/spms-demand/src/pages/production-request/components/SampleBuildPanel.tsx | 105 |
| InputField | onChange | <arrow> onFormChange | jsx | features/spms-demand/src/pages/production-request/components/SampleBuildPanel.tsx | 111 |
| CustomDropdown | onChange | <arrow> onFormChange | jsx | features/spms-demand/src/pages/production-request/components/SampleBuildPanel.tsx | 117 |
| InputField | onChange | <arrow> onFormChange | jsx | features/spms-demand/src/pages/production-request/components/SampleBuildPanel.tsx | 123 |
| InputField | onChange | <arrow> onFormChange | jsx | features/spms-demand/src/pages/production-request/components/SampleBuildPanel.tsx | 139 |
| grid | formatItem | formatRowHeader | addHandler | features/spms-demand/src/pages/production-request/components/SampleDemandGrid.tsx | 118 |
| g | updatedLayout | applyDataMaps | addHandler | features/spms-demand/src/pages/production-request/components/SampleDemandGrid.tsx | 161 |
| DataGrid | initialized | restoreMultiRangeSelection | jsx | features/spms-demand/src/pages/production-request/components/SampleDemandGrid.tsx | 185 |
| DataGrid | loadedRows | handleLoadedRows | jsx | features/spms-demand/src/pages/production-request/components/SampleDemandGrid.tsx | 186 |
| DataGrid | formatItem | handleFormatItem | jsx | features/spms-demand/src/pages/production-request/components/SampleDemandGrid.tsx | 187 |
| Switch | onChange | <arrow> onToggleProgress | jsx | features/spms-demand/src/pages/production-request/components/SampleTree.tsx | 49 |
| Tree | onClick | <arrow> onNodeClick | jsx | features/spms-demand/src/pages/production-request/components/SampleTree.tsx | 59 |
| SampleTree | onToggleProgress | setInProgressOnly | jsx | features/spms-demand/src/pages/production-request/ProductionRequest.tsx | 324 |
| SampleTree | onNodeClick | handleNodeClick | jsx | features/spms-demand/src/pages/production-request/ProductionRequest.tsx | 325 |
| SampleBuildPanel | onFormChange | <arrow> setBuildForm | jsx | features/spms-demand/src/pages/production-request/ProductionRequest.tsx | 335 |
| SampleBuildPanel | onInsert | handleBuildInsert | jsx | features/spms-demand/src/pages/production-request/ProductionRequest.tsx | 336 |
| SampleBuildPanel | onCancel | handleBuildCancel | jsx | features/spms-demand/src/pages/production-request/ProductionRequest.tsx | 337 |
| SampleBuildPanel | onSave | handleBuildSave | jsx | features/spms-demand/src/pages/production-request/ProductionRequest.tsx | 338 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Button | 3 |
| InputField | 3 |
| CustomDropdown | 2 |
| DataGrid | 1 |
| Switch | 1 |
| Tree | 1 |
| MainTitle | 1 |
| SampleTree | 1 |
| SampleProcessFlow | 1 |
| SampleBuildPanel | 1 |
| SubTitle | 1 |
| SampleDemandGrid | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| LBL01022 | 1 |
| LBL00394 | 1 |
| LBL01028 | 1 |
| LBL00395 | 1 |
| LBL00873 | 1 |
| LBL01025 | 1 |
| LBL01026 | 1 |
| LBL01027 | 1 |
| LBL00674 | 1 |
| LBL01020 | 1 |
| LBL01021 | 2 |
| MSG00001 | 1 |
| MSG00002 | 1 |
| MSG00003 | 1 |
| MSG00004 | 1 |
| MSG00013 | 1 |
| MSG00014 | 1 |
| MSG00703 | 1 |
| LBL01023 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SDM2010(10), SDM1020(7), DMF0042(1), SDM1010(1), SDM5010(1)
- SP/PKG: PKG_SDM2010(4), P_DPJT_BUILD_SEQ(3), P_SDM2010_SAVE_PJT_SAMPLE_BUILD(3), P_SDM2010_GET_PJT_SAMPLE_TREE(2), P_DPJT_BIND_SEQ(2), P_SDM2010_SAVE_PJT_SAMPLE_DEMAND(2), P_SES_DIVISION_ID(2), SCM0001_GET_LOOKUP_VALUES(1), P_DPJT_CODE(1), P_DPJT_BUILD_NO(1), P_DPJT_BUILD_TYPE(1), P_DPJT_BIND_TYPE(1), P_NOTE(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | import { SampleProcessFlow } from './components/SampleProcessFlow'; | features/spms-demand/src/pages/production-request/ProductionRequest.tsx | 16 |
| endpoint | EVENT 0 = 성공 토스트 금지). 수요 그리드 저장 = 공통 useProcMutation (SP 등재 시 확정 — | features/spms-demand/src/pages/production-request/ProductionRequest.tsx | 47 |
| code | const treeRows = (treeData?.data ?? []) as unknown as TreeRow[]; | features/spms-demand/src/pages/production-request/ProductionRequest.tsx | 121 |
| code | const processRows = (processData?.data ?? []) as unknown as ProcessRow[]; | features/spms-demand/src/pages/production-request/ProductionRequest.tsx | 123 |
| code | const demandRows = (demandData?.data ?? []) as unknown as DemandRow[]; | features/spms-demand/src/pages/production-request/ProductionRequest.tsx | 126 |
| endpoint | ⭐ master hook §2.3 — Column 동적 fetch (SHEET_COLUMNS — 시트별. 하드코딩 fallback 금지) | features/spms-demand/src/pages/production-request/useProductionRequestStore.ts | 108 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

