# SCP0023 — To-Be Fact Pack 요약

- page_key: `supply/outsourcing-capacity` · feature: supply · As-is Fact Pack 없음(화면ID 미대응)
- 파일 12 · 엔드포인트 호출 5 (미해결 0, 주석 속 1) · 이벤트 13 · 컴포넌트 사용 18 · 하드코딩 컬럼 1 · 메시지 12
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 1건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/outsourcing-capacity/components/OutsourcingCapacityForm.tsx | component | 169 |
| features/supply/src/pages/outsourcing-capacity/components/OutsourcingCapacityGrid.tsx | component | 105 |
| features/supply/src/pages/outsourcing-capacity/hooks/useOutsourcingCapacityValidation.ts | hook | 69 |
| features/supply/src/pages/outsourcing-capacity/index.ts | index | 2 |
| features/supply/src/pages/outsourcing-capacity/outsourcing-capacity.constants.ts | constants | 67 |
| features/supply/src/pages/outsourcing-capacity/outsourcing-capacity.types.ts | types | 14 |
| features/supply/src/pages/outsourcing-capacity/OutsourcingCapacity.module.scss | style | 12 |
| features/supply/src/pages/outsourcing-capacity/OutsourcingCapacity.tsx | page | 172 |
| features/supply/src/pages/outsourcing-capacity/useOutsourcingCapacityStore.ts | store | 170 |
| features/supply/src/pages/outsourcing-capacity/utils/outsourcingCapacityColumns.ts | util | 65 |
| features/supply/src/pages/outsourcing-capacity/utils/outsourcingCapacityEditLock.ts | util | 33 |
| features/supply/src/pages/outsourcing-capacity/__asis-mapping__.md | mapping | 57 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 1 | Y | OutsourcingCapacityForm.tsx:50 |
| SCP0023/main//call-proc | hook | 2 | Y | OutsourcingCapacity.tsx:52 OutsourcingCapacity.tsx:59 |
| /admin/menu/SCP0023/column | http | 1 | Y | useOutsourcingCapacityStore.ts:120 |
| /admin/menu/SCP0023/search-conditions | http | 1 | Y | useOutsourcingCapacityStore.ts:149 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| main | divisionId plantSiteId itemId nickName valid debugMode | o_rc1 | SCP0023_GET_OUTSOURCING_CAPA PKG_SCP0023 |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | onSearch | jsx | features/supply/src/pages/outsourcing-capacity/components/OutsourcingCapacityForm.tsx | 77 |
| CustomDropdown | onChange | <arrow> String,confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,setDivision | jsx | features/supply/src/pages/outsourcing-capacity/components/OutsourcingCapacityForm.tsx | 91 |
| CustomDropdown | onChange | <arrow> set,String(picked??'').split(',').filter,String(picked??'').split,String,v.toUpperCase | jsx | features/supply/src/pages/outsourcing-capacity/components/OutsourcingCapacityForm.tsx | 120 |
| InputField | onChange | <arrow> set | jsx | features/supply/src/pages/outsourcing-capacity/components/OutsourcingCapacityForm.tsx | 158 |
| InputField | onKeyDown | <arrow> onSearch | jsx | features/supply/src/pages/outsourcing-capacity/components/OutsourcingCapacityForm.tsx | 159 |
| FunctionSearchIcon | onClick | onItemSearch | jsx | features/supply/src/pages/outsourcing-capacity/components/OutsourcingCapacityForm.tsx | 152 |
| g | beginningEdit | beginningEditHandler | addHandler | features/supply/src/pages/outsourcing-capacity/components/OutsourcingCapacityGrid.tsx | 56 |
| g | cellEditEnded | cellEditEndedHandler | addHandler | features/supply/src/pages/outsourcing-capacity/components/OutsourcingCapacityGrid.tsx | 79 |
| g | pastedCell | cellEditEndedHandler | addHandler | features/supply/src/pages/outsourcing-capacity/components/OutsourcingCapacityGrid.tsx | 80 |
| DataGrid | gotFocus | onFocus | jsx | features/supply/src/pages/outsourcing-capacity/components/OutsourcingCapacityGrid.tsx | 101 |
| OutsourcingCapacityForm | onSearch | handleSearch | jsx | features/supply/src/pages/outsourcing-capacity/OutsourcingCapacity.tsx | 128 |
| OutsourcingCapacityForm | onItemSearch | <arrow> setOpenItem | jsx | features/supply/src/pages/outsourcing-capacity/OutsourcingCapacity.tsx | 128 |
| OutsourcingCapacityGrid | onFocus | <arrow>  | jsx | features/supply/src/pages/outsourcing-capacity/OutsourcingCapacity.tsx | 148 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 3 |
| FormItem | 3 |
| CustomDropdown | 2 |
| SearchArea | 1 |
| InputField | 1 |
| Button | 1 |
| FunctionSearchIcon | 1 |
| DataGrid | 1 |
| MainTitle | 1 |
| OutsourcingCapacityForm | 1 |
| SubTitle | 1 |
| OutsourcingCapacityGrid | 1 |
| MaterialByDivisionModal | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| buildColumns | c.key | c.header | c.width ?? 100 | true |  |  | meta-map | features/supply/src/pages/outsourcing-capacity/utils/outsourcingCapacityColumns.ts | 49 |

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00112 | 1 |
| LBL00001 | 1 |
| LBL00005 | 1 |
| LBL00669 | 1 |
| LBL00767 | 1 |
| LBL00618 | 1 |
| MSG00429 | 1 |
| MSG00617 | 1 |
| MSG00002 | 1 |
| MSG00004 | 1 |
| MSG00085 | 1 |
| MSG00258 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0023(6), SCP0025(2), SCP0020(1)
- SP/PKG: SCP0023_GET_OUTSOURCING_CAPA(2), PKG_SCP0023(2), SCP0023_SAVE_OUTSOURCING_CAPA(1), SCM0001_GET_PLANT_SITE_BY_DIVISION_OSP(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| endpoint | ui-dynamic-property-management §2.3 — admin SCM_MST_SHEET_COLUMNS 동적 fetch (13행 등록됨, design 03 §0). | features/supply/src/pages/outsourcing-capacity/useOutsourcingCapacityStore.ts | 23 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

