# SCP0002 — To-Be Fact Pack 요약

- page_key: `supply/line-master` · feature: supply · As-is Fact Pack 없음(화면ID 미대응)
- 파일 14 · 엔드포인트 호출 7 (미해결 0, 주석 속 4) · 이벤트 12 · 컴포넌트 사용 18 · 하드코딩 컬럼 1 · 메시지 17
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 1건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/line-master/components/LineMasterForm.tsx | component | 270 |
| features/supply/src/pages/line-master/components/LineMasterMainGrid.tsx | component | 213 |
| features/supply/src/pages/line-master/index.ts | index | 2 |
| features/supply/src/pages/line-master/line-master.constants.ts | constants | 162 |
| features/supply/src/pages/line-master/line-master.types.ts | types | 24 |
| features/supply/src/pages/line-master/LineMaster.tsx | page | 231 |
| features/supply/src/pages/line-master/useLineMasterStore.ts | store | 196 |
| features/supply/src/pages/line-master/utils/line-master.api.ts | api | 45 |
| features/supply/src/pages/line-master/utils/lineMasterColumns.ts | util | 46 |
| features/supply/src/pages/line-master/utils/lineMasterDerive.test.ts | test | 53 |
| features/supply/src/pages/line-master/utils/lineMasterDerive.ts | util | 33 |
| features/supply/src/pages/line-master/utils/lineMasterEditLock.test.ts | test | 56 |
| features/supply/src/pages/line-master/utils/lineMasterEditLock.ts | util | 20 |
| features/supply/src/pages/line-master/__asis-mapping__.md | mapping | 192 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 2 | Y | LineMasterForm.tsx:54 LineMasterMainGrid.tsx:61 |
| SCP0002/Plant//call-proc | hook | 1 | Y | LineMaster.tsx:53 |
| SCP0002/Packer//call-proc | hook | 1 | Y | LineMaster.tsx:60 |
| /admin/menu/SCP0002/column | http | 1 | Y | useLineMasterStore.ts:145 |
| /admin/menu/SCP0002/search-conditions | http | 1 | Y | useLineMasterStore.ts:175 |
| /SCP0002/Packer/SAVE/call-proc | http | 1 | Y | line-master.api.ts:35 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| CustomDropdown | onChange | <arrow> onPick,String(picked??'').split(',').filter,String(picked??'').split,String,v.toUpperCase | jsx | features/supply/src/pages/line-master/components/LineMasterForm.tsx | 171 |
| SearchArea | onSearch | onSearch | jsx | features/supply/src/pages/line-master/components/LineMasterForm.tsx | 190 |
| CustomDropdown | onChange | <arrow> confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,set,String,clearFilters | jsx | features/supply/src/pages/line-master/components/LineMasterForm.tsx | 210 |
| CustomDropdown | onChange | <arrow> set,String | jsx | features/supply/src/pages/line-master/components/LineMasterForm.tsx | 260 |
| g | updatedLayout | attach | addHandler | features/supply/src/pages/line-master/components/LineMasterMainGrid.tsx | 118 |
| g | beginningEdit | beginningEditHandler | addHandler | features/supply/src/pages/line-master/components/LineMasterMainGrid.tsx | 134 |
| g | pastingCell | beginningEditHandler | addHandler | features/supply/src/pages/line-master/components/LineMasterMainGrid.tsx | 135 |
| g | cellEditEnded | cellEditEndedHandler | addHandler | features/supply/src/pages/line-master/components/LineMasterMainGrid.tsx | 176 |
| g | pastedCell | cellEditEndedHandler | addHandler | features/supply/src/pages/line-master/components/LineMasterMainGrid.tsx | 177 |
| DataGrid | gotFocus | onFocus | jsx | features/supply/src/pages/line-master/components/LineMasterMainGrid.tsx | 209 |
| LineMasterMainGrid | onFocus | <arrow>  | jsx | features/supply/src/pages/line-master/LineMaster.tsx | 193 |
| LineMasterForm | onSearch | handleSearch | jsx | features/supply/src/pages/line-master/LineMaster.tsx | 205 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 3 |
| FormItem | 3 |
| CustomDropdown | 3 |
| TabItem | 2 |
| SearchArea | 1 |
| DataGrid | 1 |
| LineMasterMainGrid | 1 |
| MainTitle | 1 |
| LineMasterForm | 1 |
| SubTitle | 1 |
| TabWrapper | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| buildColumns | c.key | c.header | c.width ?? 100 | true |  |  | meta-map | features/supply/src/pages/line-master/utils/lineMasterColumns.ts | 25 |

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00728 | 1 |
| LBL00729 | 1 |
| LBL00112 | 1 |
| LBL00001 | 1 |
| LBL00005 | 1 |
| LBL00030 | 1 |
| LBL00008 | 1 |
| LBL00009 | 1 |
| LBL00010 | 1 |
| LBL00007 | 1 |
| LBL00632 | 1 |
| MSG00109 | 1 |
| MSG00429 | 1 |
| MSG00097 | 1 |
| MSG00004 | 1 |
| MSG00002 | 1 |
| MSG00043 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0002(4), SCP0114(1)
- SP/PKG: SCP0002_GET_LINE_MASTER(2), SCP0002_GET_LINE_MASTER_OSP(2), SCP0002_SAVE_LINE_MASTER_OSP(1), PR_CHECK_MNU_BTN_AUTH(1), P_SHT_NM(1), PKG_SCP0002(1), P_SCP0002_SAVE_LINE_MASTER_OSP(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | => 신규전용(필수) SCM_SITE_ID/LINE_ID/RACK_YN=IM, 상시(필수) LINE_NAME/VALID_YN=M, 상시(선택) SCS_PROD_AMEND=O, | features/supply/src/pages/line-master/line-master.constants.ts | 146 |
| endpoint | SAVE 는 CLOB '^' bulk proc 라 useProcMutation(행 배열) 불가 → savePackerOsp 로 폴딩 POST. | features/supply/src/pages/line-master/LineMaster.tsx | 69 |
| endpoint | ui-dynamic-property-management §2.3 — admin SCM_MST_SHEET_COLUMNS 동적 fetch (미등록 시 빈 배열 → | features/supply/src/pages/line-master/useLineMasterStore.ts | 29 |
| endpoint | 'Line Master' 중복 sheetNm 은 제외 — Plant/Packer 2종만 fetch (design 03 §화면구조전제). | features/supply/src/pages/line-master/useLineMasterStore.ts | 138 |
| endpoint | useProcMutation(행 배열 그대로 전송)으로는 저장되지 않는다 — BE makeProcedure 가 PROC_M 의 | features/supply/src/pages/line-master/utils/line-master.api.ts | 2 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

