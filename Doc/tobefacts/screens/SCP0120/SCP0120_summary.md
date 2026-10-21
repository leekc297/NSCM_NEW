# SCP0120 — To-Be Fact Pack 요약

- page_key: `supply/constraint-mgmt` · feature: supply · As-is Fact Pack 없음(화면ID 미대응)
- 파일 13 · 엔드포인트 호출 9 (미해결 0, 주석 속 0) · 이벤트 10 · 컴포넌트 사용 22 · 하드코딩 컬럼 0 · 메시지 14
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/constraint-mgmt/components/ConstraintMgmtDetailGrid.tsx | component | 63 |
| features/supply/src/pages/constraint-mgmt/components/ConstraintMgmtForm.tsx | component | 119 |
| features/supply/src/pages/constraint-mgmt/components/ConstraintMgmtMasterGrid.tsx | component | 89 |
| features/supply/src/pages/constraint-mgmt/constraint-mgmt.constants.ts | constants | 135 |
| features/supply/src/pages/constraint-mgmt/constraint-mgmt.types.ts | types | 26 |
| features/supply/src/pages/constraint-mgmt/ConstraintMgmt.module.scss | style | 59 |
| features/supply/src/pages/constraint-mgmt/ConstraintMgmt.tsx | page | 471 |
| features/supply/src/pages/constraint-mgmt/index.ts | index | 2 |
| features/supply/src/pages/constraint-mgmt/useConstraintMgmtStore.ts | store | 251 |
| features/supply/src/pages/constraint-mgmt/utils/constraintMgmt.editGuard.ts | util | 71 |
| features/supply/src/pages/constraint-mgmt/utils/constraintMgmt.restore.test.ts | test | 56 |
| features/supply/src/pages/constraint-mgmt/utils/constraintMgmt.utils.ts | util | 305 |
| features/supply/src/pages/constraint-mgmt/__asis-mapping__.md | mapping | 156 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 2 | Y | ConstraintMgmtForm.tsx:26 ConstraintMgmt.tsx:95 |
| SCP0120/lookupMaster//call-proc | hook | 2 | Y | ConstraintMgmt.tsx:104 ConstraintMgmt.tsx:179 |
| SCP0120/lookupDetail//call-proc | hook | 2 | Y | ConstraintMgmt.tsx:116 ConstraintMgmt.tsx:191 |
| /admin/menu/SCP0120/search-conditions | http | 1 | Y | useConstraintMgmtStore.ts:117 |
| /admin/menu/SCP0120/column | http | 2 | Y | useConstraintMgmtStore.ts:198 useConstraintMgmtStore.ts:201 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| lookupMaster | lookupType validYn adminYn | o_rc | PKG_SCP0120 P_SCP0120_GET_LOOKUP_MASTER P_SCP0120_GET_LOOKUP_DETAIL |
| lookupDetail | lookupType | o_rc | PKG_SCP0120 P_SCP0120_GET_LOOKUP_MASTER P_SCP0120_GET_LOOKUP_DETAIL |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| DataGrid | gotFocus | handleGotFocus | jsx | features/supply/src/pages/constraint-mgmt/components/ConstraintMgmtDetailGrid.tsx | 59 |
| SearchArea | onSearch | onSearch | jsx | features/supply/src/pages/constraint-mgmt/components/ConstraintMgmtForm.tsx | 34 |
| InputField | onChange | <arrow> setSearchParams,String | jsx | features/supply/src/pages/constraint-mgmt/components/ConstraintMgmtForm.tsx | 51 |
| CustomDropdown | onChange | <arrow> setSearchParams,String(picked??'').split(',').filter,String(picked??'').split,String,value.toUpperCase | jsx | features/supply/src/pages/constraint-mgmt/components/ConstraintMgmtForm.tsx | 81 |
| CustomDropdown | onChange | <arrow> setSearchParams,String | jsx | features/supply/src/pages/constraint-mgmt/components/ConstraintMgmtForm.tsx | 109 |
| DataGrid | gotFocus | handleGotFocus | jsx | features/supply/src/pages/constraint-mgmt/components/ConstraintMgmtMasterGrid.tsx | 84 |
| ConstraintMgmtForm | onSearch | handleSearch | jsx | features/supply/src/pages/constraint-mgmt/ConstraintMgmt.tsx | 423 |
| grid | formatItem | formatItemHandler | addHandler | features/supply/src/pages/constraint-mgmt/utils/constraintMgmt.editGuard.ts | 56 |
| grid | beginningEdit | beginningEditHandler | addHandler | features/supply/src/pages/constraint-mgmt/utils/constraintMgmt.editGuard.ts | 57 |
| grid | pastingCell | pastingCellHandler | addHandler | features/supply/src/pages/constraint-mgmt/utils/constraintMgmt.editGuard.ts | 58 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 3 |
| FormItem | 3 |
| DataGrid | 2 |
| CustomDropdown | 2 |
| Panel | 2 |
| SearchArea | 1 |
| InputField | 1 |
| MainTitle | 1 |
| ConstraintMgmtForm | 1 |
| SubTitle | 1 |
| PanelGroup | 1 |
| ConstraintMgmtMasterGrid | 1 |
| PanelSeparator | 1 |
| TitleArea | 1 |
| ConstraintMgmtDetailGrid | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00057 | 1 |
| LBL00002 | 1 |
| LBL00007 | 1 |
| LBL00637 | 1 |
| LBL00112 | 1 |
| MSG00672 | 1 |
| MSG00004 | 1 |
| MSG00429 | 1 |
| MSG00060 | 1 |
| MSG01092 | 1 |
| MSG00624 | 1 |
| MSG00096 | 1 |
| MSG00460 | 1 |
| MSG01059 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SYS0010(4), SCP0120(2), SCP0122(1)
- SP/PKG: P_SCP0120_SAVE_LOOKUP_(1), P_SCP0120_DELETE_LOOKUP_(1), P_SCP0120_GET_LOOKUP_DETAIL(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | 조회권한 게이트는 핸들러 안에 둔다 — SearchArea 의 조회 버튼에는 권한 검사가 없어 hotkeyConfig 만 막으면 그 버튼으로 그대로 조회된다(공용 컴포넌트라 경계 밖이라 못 고친다). AS-IS R-29 도 CanSelect 불통과 시 안내 후 return 이다. | features/supply/src/pages/constraint-mgmt/ConstraintMgmt.tsx | 230 |
| code | if (findDuplicateRow(payload, masterRows)) return alertDuplicate(); | features/supply/src/pages/constraint-mgmt/ConstraintMgmt.tsx | 328 |
| code | return alertDuplicate(); | features/supply/src/pages/constraint-mgmt/ConstraintMgmt.tsx | 331 |
| code | const buildDuplicateKey = (row: DuplicateCheckRow): string => | features/supply/src/pages/constraint-mgmt/utils/constraintMgmt.utils.ts | 120 |
| code | DUPLICATE_KEY_COLUMNS.map(col => String(row[col] ?? '').toUpperCase()).join('\|\|'); | features/supply/src/pages/constraint-mgmt/utils/constraintMgmt.utils.ts | 121 |
| code | const key = buildDuplicateKey(row); | features/supply/src/pages/constraint-mgmt/utils/constraintMgmt.utils.ts | 148 |
| code | if ((counts.get(buildDuplicateKey(row)) ?? 0) >= 2) return row; | features/supply/src/pages/constraint-mgmt/utils/constraintMgmt.utils.ts | 153 |
| code | if (isAdmin) return rows; | features/supply/src/pages/constraint-mgmt/utils/constraintMgmt.utils.ts | 208 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

