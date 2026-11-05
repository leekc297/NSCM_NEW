# SCP0114 — To-Be Fact Pack 요약

- page_key: `supply/capa-line-master` · feature: supply · As-is Fact Pack 있음
- 파일 14 · 엔드포인트 호출 9 (미해결 1, 주석 속 2) · 이벤트 11 · 컴포넌트 사용 26 · 하드코딩 컬럼 1 · 메시지 13
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 1건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/capa-line-master/capa-line-master.constants.ts | constants | 320 |
| features/supply/src/pages/capa-line-master/capa-line-master.types.ts | types | 28 |
| features/supply/src/pages/capa-line-master/CapaLineMaster.module.scss | style | 64 |
| features/supply/src/pages/capa-line-master/CapaLineMaster.tsx | page | 517 |
| features/supply/src/pages/capa-line-master/components/CapaLineMasterForm.tsx | component | 133 |
| features/supply/src/pages/capa-line-master/components/CapaLineMasterLevelGrid.module.scss | component | 19 |
| features/supply/src/pages/capa-line-master/components/CapaLineMasterLevelGrid.tsx | component | 155 |
| features/supply/src/pages/capa-line-master/hooks/useCapaLineMasterValidation.ts | hook | 42 |
| features/supply/src/pages/capa-line-master/index.ts | index | 2 |
| features/supply/src/pages/capa-line-master/useCapaLineMasterStore.ts | store | 356 |
| features/supply/src/pages/capa-line-master/utils/capaLineMaster.editLock.test.ts | test | 238 |
| features/supply/src/pages/capa-line-master/utils/capaLineMaster.editLock.ts | util | 130 |
| features/supply/src/pages/capa-line-master/utils/capaLineMasterColumns.ts | util | 48 |
| features/supply/src/pages/capa-line-master/__asis-mapping__.md | mapping | 207 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| SCP0114/Level1//call-proc | hook | 1 | Y | CapaLineMaster.tsx:106 |
| SCP0114/Level2//call-proc | hook | 1 | Y | CapaLineMaster.tsx:113 |
| SCP0114/Level3//call-proc | hook | 1 | Y | CapaLineMaster.tsx:120 |
| SCP0114/Level4//call-proc | hook | 1 | Y | CapaLineMaster.tsx:127 |
| SCP0114/Level5//call-proc | hook | 1 | Y | CapaLineMaster.tsx:134 |
| /SCP0114/{SHEET_BY_LEVEL[level]}/SAVE/call-proc | http | 1 | N | CapaLineMaster.tsx:326 |
| (useTabComboQueries) | hook | 1 | Y | CapaLineMasterForm.tsx:48 |
| /admin/menu/SCP0114/column | http | 1 | Y | useCapaLineMasterStore.ts:303 |
| /admin/menu/SCP0114/search-conditions | http | 1 | Y | useCapaLineMasterStore.ts:326 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| CapaLineMasterLevelGrid | onDrillDown | <arrow> drillDown | jsx | features/supply/src/pages/capa-line-master/CapaLineMaster.tsx | 442 |
| CapaLineMasterLevelGrid | onFocus | <arrow> setActiveLevel | jsx | features/supply/src/pages/capa-line-master/CapaLineMaster.tsx | 443 |
| CapaLineMasterForm | onSearch | handleSearch | jsx | features/supply/src/pages/capa-line-master/CapaLineMaster.tsx | 455 |
| SearchArea | onSearch | onSearch | jsx | features/supply/src/pages/capa-line-master/components/CapaLineMasterForm.tsx | 80 |
| CustomDropdown | onChange | <arrow> String,confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,setDivision | jsx | features/supply/src/pages/capa-line-master/components/CapaLineMasterForm.tsx | 98 |
| CustomDropdown | onChange | <arrow> setSearchCondition,String | jsx | features/supply/src/pages/capa-line-master/components/CapaLineMasterForm.tsx | 119 |
| grid | formatItem | formatItemHandler | addHandler | features/supply/src/pages/capa-line-master/components/CapaLineMasterLevelGrid.tsx | 87 |
| grid | beginningEdit | beginningEditHandler | addHandler | features/supply/src/pages/capa-line-master/components/CapaLineMasterLevelGrid.tsx | 100 |
| grid | pastingCell | pastingCellHandler | addHandler | features/supply/src/pages/capa-line-master/components/CapaLineMasterLevelGrid.tsx | 112 |
| grid.hostElement | dblclick | dblClickHandler | addEventListener | features/supply/src/pages/capa-line-master/components/CapaLineMasterLevelGrid.tsx | 124 |
| DataGrid | gotFocus | onFocus | jsx | features/supply/src/pages/capa-line-master/components/CapaLineMasterLevelGrid.tsx | 150 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Panel | 7 |
| PanelSeparator | 4 |
| PanelGroup | 3 |
| Grid | 2 |
| FormItem | 2 |
| CustomDropdown | 2 |
| CapaLineMasterLevelGrid | 1 |
| MainTitle | 1 |
| CapaLineMasterForm | 1 |
| SubTitle | 1 |
| SearchArea | 1 |
| DataGrid | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| column | meta.key | meta.header | meta.width | meta.visible !== false |  |  | meta-map | features/supply/src/pages/capa-line-master/utils/capaLineMasterColumns.ts | 30 |

## 7. 메시지 코드
| code | count |
|---|---|
| MSG00672 | 1 |
| MSG00003 | 1 |
| MSG00004 | 1 |
| MSG00060 | 1 |
| MSG00097 | 1 |
| MSG00662 | 1 |
| LBL00414 | 2 |
| LBL00038 | 1 |
| LBL01059 | 1 |
| LBL00112 | 1 |
| LBL00001 | 1 |
| LBL00088 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0114(7), SCP0033(3), SSP0024(2), SCP0020(2), SCP0005(2), SSP0014(2), SSP0025(1), SCP0025(1)
- SP/PKG: PKG_SCP0114(5), P_SCP0114_GET_CAPA_LINE_MASTER(1), P_SCP0114_SAVE_CAPA_LINE_MASTER(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | (1) 활성 그리드에 'I'/'M' 행이 남아 있으면 return(미저장 편집 중 토글 차단, cs:478~486) | features/supply/src/pages/capa-line-master/CapaLineMaster.tsx | 222 |
| code | (2) 토글 후 편집중 레벨이 2개 이상이면 되돌리고 return(동시 1개만, cs:498~502) -> store 가 담당 | features/supply/src/pages/capa-line-master/CapaLineMaster.tsx | 223 |
| code | 선택행이 신규행('I')일 때만 로컬 제거한다. 기존행은 삭제 불가(메시지 없이 return, hook #138). | features/supply/src/pages/capa-line-master/CapaLineMaster.tsx | 261 |
| endpoint | ui-dynamic-property-management §2.3 — admin SCM_MST_SHEET_COLUMNS 동적 fetch(시트별). | features/supply/src/pages/capa-line-master/useCapaLineMasterStore.ts | 40 |
| code | Edit 토글 — 이미 다른 레벨이 편집중이면 무시(AS-IS editCnt>1 되돌림 후 return, cs:498~502). | features/supply/src/pages/capa-line-master/useCapaLineMasterStore.ts | 273 |
| endpoint | admin SCM_MST_SHEET_COLUMNS 동적 fetch(5시트) — 미등록/실패 시 빈 배열 유지(console 금지 룰). | features/supply/src/pages/capa-line-master/useCapaLineMasterStore.ts | 294 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

