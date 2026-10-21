# SCP0048 — To-Be Fact Pack 요약

- page_key: `supply/project-route-warranty` · feature: supply · As-is Fact Pack 없음(화면ID 미대응)
- 파일 11 · 엔드포인트 호출 8 (미해결 0, 주석 속 3) · 이벤트 17 · 컴포넌트 사용 22 · 하드코딩 컬럼 0 · 메시지 30
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/project-route-warranty/components/ProjectRouteWarrantyForm.tsx | component | 218 |
| features/supply/src/pages/project-route-warranty/components/ProjectRouteWarrantyGrid.tsx | component | 372 |
| features/supply/src/pages/project-route-warranty/hooks/useProjectRouteWarrantyValidation.ts | hook | 276 |
| features/supply/src/pages/project-route-warranty/index.ts | index | 2 |
| features/supply/src/pages/project-route-warranty/project-route-warranty.constants.ts | constants | 171 |
| features/supply/src/pages/project-route-warranty/project-route-warranty.types.ts | types | 15 |
| features/supply/src/pages/project-route-warranty/ProjectRouteWarranty.tsx | page | 349 |
| features/supply/src/pages/project-route-warranty/useProjectRouteWarrantyStore.ts | store | 138 |
| features/supply/src/pages/project-route-warranty/utils/projectRouteWarranty.derive.ts | util | 31 |
| features/supply/src/pages/project-route-warranty/utils/projectRouteWarranty.saveRequest.ts | util | 89 |
| features/supply/src/pages/project-route-warranty/__asis-mapping__.md | mapping | 108 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 4 | Y | ProjectRouteWarrantyForm.tsx:37 ProjectRouteWarrantyForm.tsx:55 ProjectRouteWarrantyForm.tsx:87 ProjectRouteWarrantyGrid.tsx:73 |
| SCP0048/Main//call-proc | hook | 1 | Y | ProjectRouteWarranty.tsx:75 |
| /admin/menu/SCP0048/column | http | 1 | Y | useProjectRouteWarrantyStore.ts:99 |
| /admin/menu/SCP0048/search-conditions | http | 1 | Y | useProjectRouteWarrantyStore.ts:115 |
| /SCP0048/Main/SAVE/call-proc | http | 1 | Y | projectRouteWarranty.saveRequest.ts:72 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | noDivisionAuth ? undefined : onSearch | jsx | features/supply/src/pages/project-route-warranty/components/ProjectRouteWarrantyForm.tsx | 101 |
| CustomDropdown | onChange | <arrow> setSearchParams,String | jsx | features/supply/src/pages/project-route-warranty/components/ProjectRouteWarrantyForm.tsx | 121 |
| CustomDropdown | onChange | <arrow> setSearchParams,String | jsx | features/supply/src/pages/project-route-warranty/components/ProjectRouteWarrantyForm.tsx | 143 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/project-route-warranty/components/ProjectRouteWarrantyForm.tsx | 176 |
| FunctionSearchIcon | onClick | <arrow> setOpenItemModal | jsx | features/supply/src/pages/project-route-warranty/components/ProjectRouteWarrantyForm.tsx | 170 |
| CustomDropdown | onChange | <arrow> setSearchParams,String | jsx | features/supply/src/pages/project-route-warranty/components/ProjectRouteWarrantyForm.tsx | 191 |
| grid | updatedLayout | <arrow> attachDivisionDataMap | addHandler | features/supply/src/pages/project-route-warranty/components/ProjectRouteWarrantyGrid.tsx | 151 |
| grid | formatItem | formatPopupCell | addHandler | features/supply/src/pages/project-route-warranty/components/ProjectRouteWarrantyGrid.tsx | 153 |
| grid | beginningEdit | beginningEditHandler | addHandler | features/supply/src/pages/project-route-warranty/components/ProjectRouteWarrantyGrid.tsx | 236 |
| grid | formatItem | handler | addHandler | features/supply/src/pages/project-route-warranty/components/ProjectRouteWarrantyGrid.tsx | 267 |
| DataGrid | initialized | handleGridInitialized | jsx | features/supply/src/pages/project-route-warranty/components/ProjectRouteWarrantyGrid.tsx | 364 |
| DataGrid | cellEditEnded | handleCellEdit | jsx | features/supply/src/pages/project-route-warranty/components/ProjectRouteWarrantyGrid.tsx | 365 |
| DataGrid | pastedCell | handleCellEdit | jsx | features/supply/src/pages/project-route-warranty/components/ProjectRouteWarrantyGrid.tsx | 366 |
| DataGrid | gotFocus | gotFocus | jsx | features/supply/src/pages/project-route-warranty/components/ProjectRouteWarrantyGrid.tsx | 368 |
| ProjectRouteWarrantyForm | onSearch | handleSearch | jsx | features/supply/src/pages/project-route-warranty/ProjectRouteWarranty.tsx | 296 |
| ProjectRouteWarrantyGrid | onItemCellDblClick | handleItemCellDblClick | jsx | features/supply/src/pages/project-route-warranty/ProjectRouteWarranty.tsx | 315 |
| ProjectRouteWarrantyGrid | onSalesSiteCellDblClick | handleSalesSiteCellDblClick | jsx | features/supply/src/pages/project-route-warranty/ProjectRouteWarranty.tsx | 316 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 4 |
| FormItem | 4 |
| CustomDropdown | 3 |
| ItemByDivisionModal | 2 |
| SearchArea | 1 |
| InputField | 1 |
| Button | 1 |
| FunctionSearchIcon | 1 |
| DataGrid | 1 |
| MainTitle | 1 |
| ProjectRouteWarrantyForm | 1 |
| SubTitle | 1 |
| ProjectRouteWarrantyGrid | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00632 | 1 |
| MSG00097 | 2 |
| MSG00002 | 2 |
| MSG00006 | 1 |
| MSG00133 | 1 |
| MSG00662 | 1 |
| MSG01222 | 1 |
| MSG00212 | 1 |
| MSG00213 | 1 |
| MSG00215 | 2 |
| MSG00216 | 1 |
| MSG00214 | 1 |
| MSG00107 | 1 |
| MSG00219 | 1 |
| MSG00048 | 1 |
| MSG00220 | 1 |
| MSG01319 | 1 |
| LBL00112 | 1 |
| LBL00001 | 1 |
| LBL00005 | 1 |
| LBL00027 | 1 |
| LBL00669 | 1 |
| LBL00639 | 1 |
| LBL00414 | 1 |
| LBL00394 | 1 |
| MSG00009 | 1 |
| MSG00011 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0048(16), SCP0006(9), COM0008(2), SCP0027(1), SCP0005(1), SCP0002(1), SCP0007(1), SCP0039(1)
- SP/PKG: P_DEBUG_MODE(2), P_SCP0048_GET_PROJECTROUTE_(1), PKG_NSCM_UI_COM_AUTH(1), P_SHT_NM(1), P_SCP0048_GET_(1), FN_GET_ITEM_NICKNAME(1), P_SCP0048_GET_PROJECTROUTE_WARRANTY(1), P_FROM(1), P_SCP0048_SAVE_PROJECTROUTE_WARRANTY(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| endpoint | 컬럼 메타 fetch(/admin/menu/SCP0048/column)의 sheetNm 은 SCM_MST_SHEET_COLUMNS.SHEET_NAME 과 정확히 일치해야 한다(BE 문자열 매칭). SCP0048 은 단일 시트(AS-IS spdMain)이며 DB SHEET_NAME 으로 'Main' 배포된 것으로 본다(design/03 §1). 라이브 확인필요(design/03 §6). | features/supply/src/pages/project-route-warranty/project-route-warranty.constants.ts | 31 |
| endpoint | mount 1회 컬럼 메타 fetch(admin 즉시반영 baseline) + F10 자가복구. reset()→initState() 가 | features/supply/src/pages/project-route-warranty/ProjectRouteWarranty.tsx | 88 |
| code | (자매 SCP0039 master-validation 패턴). fetchStaticColumns 가 GET await 전에 initialized 를 | features/supply/src/pages/project-route-warranty/ProjectRouteWarranty.tsx | 91 |
| endpoint | 컬럼 메타는 admin(SCM_MST_SHEET_COLUMNS)에서 동적 fetch(ui-category hook, 하드코딩 금지). | features/supply/src/pages/project-route-warranty/useProjectRouteWarrantyStore.ts | 95 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

