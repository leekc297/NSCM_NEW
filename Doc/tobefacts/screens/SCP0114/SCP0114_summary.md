# SCP0114 — To-Be Fact Pack 요약

- page_key: `supply/capa-line-master` · feature: supply · As-is Fact Pack 있음
- 파일 16 · 엔드포인트 호출 9 (미해결 1, 주석 속 2) · 이벤트 12 · 컴포넌트 사용 24 · 하드코딩 컬럼 1 · 메시지 12
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 1건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/capa-line-master/capa-line-master.constants.ts | constants | 320 |
| features/supply/src/pages/capa-line-master/capa-line-master.types.ts | types | 28 |
| features/supply/src/pages/capa-line-master/CapaLineMaster.module.scss | style | 77 |
| features/supply/src/pages/capa-line-master/CapaLineMaster.tsx | page | 573 |
| features/supply/src/pages/capa-line-master/components/CapaLineMasterForm.tsx | component | 119 |
| features/supply/src/pages/capa-line-master/components/CapaLineMasterLevelGrid.module.scss | component | 19 |
| features/supply/src/pages/capa-line-master/components/CapaLineMasterLevelGrid.tsx | component | 185 |
| features/supply/src/pages/capa-line-master/components/CapaLineMasterProductGroupBar.module.scss | component | 44 |
| features/supply/src/pages/capa-line-master/components/CapaLineMasterProductGroupBar.tsx | component | 63 |
| features/supply/src/pages/capa-line-master/hooks/useCapaLineMasterValidation.ts | hook | 42 |
| features/supply/src/pages/capa-line-master/index.ts | index | 2 |
| features/supply/src/pages/capa-line-master/useCapaLineMasterStore.ts | store | 333 |
| features/supply/src/pages/capa-line-master/utils/capaLineMaster.editLock.test.ts | test | 234 |
| features/supply/src/pages/capa-line-master/utils/capaLineMaster.editLock.ts | util | 136 |
| features/supply/src/pages/capa-line-master/utils/capaLineMasterColumns.ts | util | 48 |
| features/supply/src/pages/capa-line-master/__asis-mapping__.md | mapping | 207 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| SCP0114/Level1//call-proc | hook | 1 | Y | CapaLineMaster.tsx:109 |
| SCP0114/Level2//call-proc | hook | 1 | Y | CapaLineMaster.tsx:116 |
| SCP0114/Level3//call-proc | hook | 1 | Y | CapaLineMaster.tsx:123 |
| SCP0114/Level4//call-proc | hook | 1 | Y | CapaLineMaster.tsx:130 |
| SCP0114/Level5//call-proc | hook | 1 | Y | CapaLineMaster.tsx:137 |
| /SCP0114/{SHEET_BY_LEVEL[level]}/SAVE/call-proc | http | 1 | N | CapaLineMaster.tsx:383 |
| (useTabComboQueries) | hook | 1 | Y | CapaLineMasterForm.tsx:50 |
| /admin/menu/SCP0114/column | http | 1 | Y | useCapaLineMasterStore.ts:280 |
| /admin/menu/SCP0114/search-conditions | http | 1 | Y | useCapaLineMasterStore.ts:303 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| CapaLineMasterLevelGrid | onDrillDown | <arrow> handleDrillDown | jsx | features/supply/src/pages/capa-line-master/CapaLineMaster.tsx | 506 |
| CapaLineMasterLevelGrid | onFocus | <arrow> setActiveLevel | jsx | features/supply/src/pages/capa-line-master/CapaLineMaster.tsx | 507 |
| CapaLineMasterForm | onSearch | handleSearch | jsx | features/supply/src/pages/capa-line-master/CapaLineMaster.tsx | 520 |
| CapaLineMasterProductGroupBar | onChangeShopGroup | handleChangeShopGroup | jsx | features/supply/src/pages/capa-line-master/CapaLineMaster.tsx | 556 |
| SearchArea | onSearch | onSearch | jsx | features/supply/src/pages/capa-line-master/components/CapaLineMasterForm.tsx | 81 |
| CustomDropdown | onChange | <arrow> String,confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,setDivision,setDivComboKey | jsx | features/supply/src/pages/capa-line-master/components/CapaLineMasterForm.tsx | 102 |
| grid | formatItem | formatItemHandler | addHandler | features/supply/src/pages/capa-line-master/components/CapaLineMasterLevelGrid.tsx | 88 |
| grid | beginningEdit | beginningEditHandler | addHandler | features/supply/src/pages/capa-line-master/components/CapaLineMasterLevelGrid.tsx | 112 |
| grid | pastingCell | pastingCellHandler | addHandler | features/supply/src/pages/capa-line-master/components/CapaLineMasterLevelGrid.tsx | 129 |
| grid.hostElement | dblclick | dblClickHandler | addEventListener | features/supply/src/pages/capa-line-master/components/CapaLineMasterLevelGrid.tsx | 154 |
| DataGrid | gotFocus | onFocus | jsx | features/supply/src/pages/capa-line-master/components/CapaLineMasterLevelGrid.tsx | 180 |
| input | onChange | <arrow> onChangeShopGroup | jsx | features/supply/src/pages/capa-line-master/components/CapaLineMasterProductGroupBar.tsx | 54 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Panel | 7 |
| PanelSeparator | 4 |
| PanelGroup | 3 |
| CapaLineMasterLevelGrid | 1 |
| MainTitle | 1 |
| CapaLineMasterForm | 1 |
| SubTitle | 1 |
| CapaLineMasterProductGroupBar | 1 |
| SearchArea | 1 |
| Grid | 1 |
| FormItem | 1 |
| CustomDropdown | 1 |
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
| MSG01210 | 1 |
| LBL00112 | 1 |
| LBL00001 | 1 |
| LBL00038 | 1 |
| LBL01059 | 1 |
| LBL00027 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0114(10), SCP0033(3), SSP0024(2), SCP0020(2), SSP0023(2), SCP0005(2), SSP0014(2), SSP0025(1), SCP0104(1), SCP0025(1)
- SP/PKG: PKG_SCP0114(6), P_SCP0114_GET_CAPA_LINE_MASTER(1), P_SCP0114_SAVE_CAPA_LINE_MASTER(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | 미조회(applied 없음) 상태 삽입 차단 — AS-IS 는 무언 return, TO-BE 는 동작 동일 + 안내만 더한다. | features/supply/src/pages/capa-line-master/CapaLineMaster.tsx | 301 |
| code | 선택행이 신규행('I')일 때만 로컬 제거한다. 기존행은 삭제 불가(메시지 없이 return, hook #138). | features/supply/src/pages/capa-line-master/CapaLineMaster.tsx | 318 |
| code | 않는다(useAutocomplete.js: focused && !valueChange → 조기 return). 그래서 편집중 Div 를 바꿔 | features/supply/src/pages/capa-line-master/components/CapaLineMasterForm.tsx | 41 |
| endpoint | ui-dynamic-property-management §2.3 — admin SCM_MST_SHEET_COLUMNS 동적 fetch(시트별). | features/supply/src/pages/capa-line-master/useCapaLineMasterStore.ts | 38 |
| endpoint | admin SCM_MST_SHEET_COLUMNS 동적 fetch(5시트) — 미등록/실패 시 빈 배열 유지(console 금지 룰). | features/supply/src/pages/capa-line-master/useCapaLineMasterStore.ts | 271 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

