# SYS0013 — To-Be Fact Pack 요약

- page_key: `admin/dynamic-query` · feature: admin · As-is Fact Pack 없음(화면ID 미대응)
- 파일 21 · 엔드포인트 호출 18 (미해결 0, 주석 속 0) · 이벤트 25 · 컴포넌트 사용 88 · 하드코딩 컬럼 6 · 메시지 45
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 6건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/admin/src/pages/dynamic-query/components/DynamicQueryColumnsGrid.tsx | component | 50 |
| features/admin/src/pages/dynamic-query/components/DynamicQueryForm.tsx | component | 85 |
| features/admin/src/pages/dynamic-query/components/DynamicQueryMainGrid.tsx | component | 149 |
| features/admin/src/pages/dynamic-query/components/DynamicQueryMetaForm.module.scss | component | 8 |
| features/admin/src/pages/dynamic-query/components/DynamicQueryMetaForm.tsx | component | 74 |
| features/admin/src/pages/dynamic-query/components/DynamicQueryModal.tsx | component | 653 |
| features/admin/src/pages/dynamic-query/components/DynamicQueryModalColumnsGrid.tsx | component | 43 |
| features/admin/src/pages/dynamic-query/components/DynamicQueryModalParametersGrid.tsx | component | 43 |
| features/admin/src/pages/dynamic-query/components/DynamicQueryParametersGrid.tsx | component | 52 |
| features/admin/src/pages/dynamic-query/components/DynamicQueryResultGrid.tsx | component | 119 |
| features/admin/src/pages/dynamic-query/components/DynamicQuerySQLViewer.module.scss | component | 19 |
| features/admin/src/pages/dynamic-query/components/DynamicQuerySQLViewer.tsx | component | 23 |
| features/admin/src/pages/dynamic-query/dynamic-query.constants.ts | constants | 27 |
| features/admin/src/pages/dynamic-query/dynamic-query.payload.ts | other | 100 |
| features/admin/src/pages/dynamic-query/dynamic-query.types.ts | types | 98 |
| features/admin/src/pages/dynamic-query/dynamic-query.utils.ts | other | 124 |
| features/admin/src/pages/dynamic-query/DynamicQuery.module.scss | style | 139 |
| features/admin/src/pages/dynamic-query/DynamicQuery.tsx | page | 782 |
| features/admin/src/pages/dynamic-query/index.ts | index | 2 |
| features/admin/src/pages/dynamic-query/useDynamicQueryStore.ts | store | 307 |
| features/admin/src/pages/dynamic-query/__asis-mapping__.md | mapping | 55 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 3 | Y | DynamicQueryForm.tsx:22 DynamicQueryMetaForm.tsx:19 DynamicQueryModal.tsx:166 |
| SYS0013/columns//call-proc | hook | 3 | Y | DynamicQueryModal.tsx:193 DynamicQuery.tsx:153 DynamicQuery.tsx:187 |
| SYS0013/parameters//call-proc | hook | 3 | Y | DynamicQueryModal.tsx:202 DynamicQuery.tsx:162 DynamicQuery.tsx:193 |
| SYS0013/main//call-proc | hook | 2 | Y | DynamicQuery.tsx:144 DynamicQuery.tsx:181 |
| SYS0013/result/EXECUTE/call-proc | hook | 1 | Y | DynamicQuery.tsx:170 |
| /admin/menu/SYS0013/column | http | 5 | Y | useDynamicQueryStore.ts:153 useDynamicQueryStore.ts:156 useDynamicQueryStore.ts:159 useDynamicQueryStore.ts:162 useDynamicQueryStore.ts:165 |
| /admin/menu/SYS0013/search-conditions | http | 1 | Y | useDynamicQueryStore.ts:183 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| main | reportName description role | o_rc1 |  |
| columns | dqId | o_rc1 |  |
| parameters | dqId | o_rc1 |  |
| popupColumns | dqId | o_rc1 |  |
| popupParameters | dqId | o_rc1 |  |
| result | sqlText | o_rc1 |  |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| DataGrid | gotFocus | gotFocus | jsx | features/admin/src/pages/dynamic-query/components/DynamicQueryColumnsGrid.tsx | 46 |
| SearchArea | onSearch | onSearch | jsx | features/admin/src/pages/dynamic-query/components/DynamicQueryForm.tsx | 29 |
| InputField | onChange | <arrow> setSearchCondition | jsx | features/admin/src/pages/dynamic-query/components/DynamicQueryForm.tsx | 41 |
| InputField | onChange | <arrow> setSearchCondition | jsx | features/admin/src/pages/dynamic-query/components/DynamicQueryForm.tsx | 55 |
| CustomDropdown | onChange | <arrow> setSearchCondition | jsx | features/admin/src/pages/dynamic-query/components/DynamicQueryForm.tsx | 73 |
| DataGrid | selectionChanged | handleSelectionChanged | jsx | features/admin/src/pages/dynamic-query/components/DynamicQueryMainGrid.tsx | 130 |
| DataGrid | cellEditEnded | handleCellEditEnded | jsx | features/admin/src/pages/dynamic-query/components/DynamicQueryMainGrid.tsx | 131 |
| DynamicQueryModal | onSaved | <arrow> gridRef.current?.collectionView.refresh,gridRef.current?.invalidate | jsx | features/admin/src/pages/dynamic-query/components/DynamicQueryMainGrid.tsx | 141 |
| InputField | onChange | <arrow> setReportNm | jsx | features/admin/src/pages/dynamic-query/components/DynamicQueryModal.tsx | 488 |
| InputField | onChange | <arrow> setDescription | jsx | features/admin/src/pages/dynamic-query/components/DynamicQueryModal.tsx | 503 |
| CustomDropdown | onChange | <arrow> setRole | jsx | features/admin/src/pages/dynamic-query/components/DynamicQueryModal.tsx | 522 |
| Button | onClick | <arrow> handleParsing | jsx | features/admin/src/pages/dynamic-query/components/DynamicQueryModal.tsx | 544 |
| textarea | onChange | <arrow> setSqlText | jsx | features/admin/src/pages/dynamic-query/components/DynamicQueryModal.tsx | 554 |
| Button | onClick | <arrow> handleColumnInsert | jsx | features/admin/src/pages/dynamic-query/components/DynamicQueryModal.tsx | 576 |
| Button | onClick | handleColumnDelete | jsx | features/admin/src/pages/dynamic-query/components/DynamicQueryModal.tsx | 584 |
| Button | onClick | <arrow> handleConditionInsert | jsx | features/admin/src/pages/dynamic-query/components/DynamicQueryModal.tsx | 607 |
| Button | onClick | handleConditionDelete | jsx | features/admin/src/pages/dynamic-query/components/DynamicQueryModal.tsx | 615 |
| Button | onClick | <arrow> handleSave | jsx | features/admin/src/pages/dynamic-query/components/DynamicQueryModal.tsx | 638 |
| Button | onClick | <arrow> modalClose | jsx | features/admin/src/pages/dynamic-query/components/DynamicQueryModal.tsx | 645 |
| DataGrid | gotFocus | gotFocus | jsx | features/admin/src/pages/dynamic-query/components/DynamicQueryParametersGrid.tsx | 48 |
| DataGrid | gotFocus | gotFocus | jsx | features/admin/src/pages/dynamic-query/components/DynamicQueryResultGrid.tsx | 114 |
| DynamicQueryForm | onSearch | handleSearch | jsx | features/admin/src/pages/dynamic-query/DynamicQuery.tsx | 670 |
| DynamicQueryColumnsGrid | gotFocus | <arrow> setFocusedViewSheet | jsx | features/admin/src/pages/dynamic-query/DynamicQuery.tsx | 715 |
| DynamicQueryParametersGrid | gotFocus | <arrow> setFocusedViewSheet | jsx | features/admin/src/pages/dynamic-query/DynamicQuery.tsx | 738 |
| DynamicQueryResultGrid | gotFocus | <arrow> setFocusedViewSheet | jsx | features/admin/src/pages/dynamic-query/DynamicQuery.tsx | 771 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 11 |
| FormItem | 9 |
| Panel | 7 |
| TitleArea | 7 |
| Button | 7 |
| DataGrid | 6 |
| InputField | 6 |
| PanelSeparator | 4 |
| CustomDropdown | 3 |
| PanelGroup | 3 |
| ControlAddIcon | 2 |
| EditDeleteIcon | 2 |
| ResultArea | 2 |
| TabItem | 2 |
| SearchArea | 1 |
| DynamicQueryModal | 1 |
| CustomDialog | 1 |
| OtherIdeaIcon | 1 |
| DynamicQueryModalColumnsGrid | 1 |
| DynamicQueryModalParametersGrid | 1 |
| ControlConfirmIcon | 1 |
| MainTitle | 1 |
| DynamicQueryForm | 1 |
| SubTitle | 1 |
| TabWrapper | 1 |
| DynamicQueryMainGrid | 1 |
| DynamicQueryMetaForm | 1 |
| DynamicQueryColumnsGrid | 1 |
| DynamicQueryParametersGrid | 1 |
| DynamicQuerySQLViewer | 1 |
| DynamicQueryResultGrid | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| veiwColumn | VIEW | View | 60 | true |  |  | meta-shape | features/admin/src/pages/dynamic-query/components/DynamicQueryMainGrid.tsx | 40 |
| defaultColums | COL1 | COL1 | 120 | true |  |  | meta-shape | features/admin/src/pages/dynamic-query/components/DynamicQueryResultGrid.tsx | 23 |
| defaultColums | COL2 | COL2 | 120 | true |  |  | meta-shape | features/admin/src/pages/dynamic-query/components/DynamicQueryResultGrid.tsx | 31 |
| defaultColums | COL3 | COL3 | 120 | true |  |  | meta-shape | features/admin/src/pages/dynamic-query/components/DynamicQueryResultGrid.tsx | 39 |
| defaultColums | COL4 | COL4 | 120 | true |  |  | meta-shape | features/admin/src/pages/dynamic-query/components/DynamicQueryResultGrid.tsx | 47 |
| cols | col.name | col.name | 120 | true |  |  | meta-map | features/admin/src/pages/dynamic-query/components/DynamicQueryResultGrid.tsx | 65 |

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00112 | 1 |
| LBL00718 | 3 |
| LBL00608 | 3 |
| LBL00720 | 3 |
| MSG00149 | 1 |
| MSG00150 | 9 |
| MSG00148 | 1 |
| LBL00760 | 1 |
| LBL00652 | 2 |
| LBL00359 | 1 |
| LBL00646 | 2 |
| LBL00621 | 2 |
| LBL00622 | 2 |
| LBL00726 | 2 |
| LBL00111 | 1 |
| LBL00107 | 1 |
| LBL00674 | 2 |
| MSG00628 | 1 |
| LBL00649 | 1 |
| MSG00630 | 1 |
| MSG00003 | 1 |
| MSG00617 | 1 |
| LBL00723 | 1 |
| LBL00724 | 1 |
| LBL00645 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCM0005(3), SYS0013(2), DMF0082(1)
- SP/PKG: PKG_SYS0013(4), P_SYS0013_SAVE_QUERY_LIST(2), P_SYS0013_VALIDATE_QUERY(1), P_SYS0013_GET_QUERY_LIST(1), P_SYS0013_GET_COLUMNS(1), P_SYS0013_GET_PARAMETERS(1), P_NICKNAME(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| jsx | 이 그리드는 <TabWrapper persist> 안에서 View 탭이 display:none 인 동안 먼저 마운트된다. | features/admin/src/pages/dynamic-query/components/DynamicQueryColumnsGrid.tsx | 34 |
| jsx | 이 그리드는 <TabWrapper persist> 안에서 View 탭이 display:none 인 동안 먼저 마운트된다. | features/admin/src/pages/dynamic-query/components/DynamicQueryParametersGrid.tsx | 36 |
| code | const setSaveColumnsAndParametersList = useDynamicQueryStore( | features/admin/src/pages/dynamic-query/DynamicQuery.tsx | 139 |
| code | ); | features/admin/src/pages/dynamic-query/DynamicQuery.tsx | 141 |
| code | const missingValue = parameters.some(item => item.isUse && !item.value.trim()); | features/admin/src/pages/dynamic-query/DynamicQuery.tsx | 327 |
| code | void setAlert({ type: 'alert', content: t('MSG00150', 'CONDITION에 해당하는 VALUE를 입력해 주세요.') }); | features/admin/src/pages/dynamic-query/DynamicQuery.tsx | 329 |
| code | const leftover = findParamTokens(sql); | features/admin/src/pages/dynamic-query/DynamicQuery.tsx | 340 |
| code | .map(n => `@${n}`) | features/admin/src/pages/dynamic-query/DynamicQuery.tsx | 347 |
| code | }); | features/admin/src/pages/dynamic-query/DynamicQuery.tsx | 350 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

