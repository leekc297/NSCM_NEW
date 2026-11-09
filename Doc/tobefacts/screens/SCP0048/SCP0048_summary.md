# SCP0048 — To-Be Fact Pack 요약

- page_key: `supply/project-route-warranty` · feature: supply · As-is Fact Pack 있음
- 파일 13 · 엔드포인트 호출 9 (미해결 0, 주석 속 3) · 이벤트 19 · 컴포넌트 사용 23 · 하드코딩 컬럼 0 · 메시지 30
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/project-route-warranty/components/ProjectRouteWarrantyForm.tsx | component | 247 |
| features/supply/src/pages/project-route-warranty/components/ProjectRouteWarrantyGrid.tsx | component | 363 |
| features/supply/src/pages/project-route-warranty/hooks/useProjectRouteWarrantyValidation.test.ts | test | 55 |
| features/supply/src/pages/project-route-warranty/hooks/useProjectRouteWarrantyValidation.ts | hook | 321 |
| features/supply/src/pages/project-route-warranty/index.ts | index | 2 |
| features/supply/src/pages/project-route-warranty/project-route-warranty.constants.ts | constants | 228 |
| features/supply/src/pages/project-route-warranty/project-route-warranty.types.ts | types | 15 |
| features/supply/src/pages/project-route-warranty/ProjectRouteWarranty.tsx | page | 386 |
| features/supply/src/pages/project-route-warranty/useProjectRouteWarrantyStore.ts | store | 173 |
| features/supply/src/pages/project-route-warranty/utils/projectRouteWarranty.date.ts | util | 31 |
| features/supply/src/pages/project-route-warranty/utils/projectRouteWarranty.derive.ts | util | 34 |
| features/supply/src/pages/project-route-warranty/utils/projectRouteWarranty.saveRequest.ts | util | 102 |
| features/supply/src/pages/project-route-warranty/__asis-mapping__.md | mapping | 108 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 5 | Y | ProjectRouteWarrantyForm.tsx:42 ProjectRouteWarrantyForm.tsx:47 ProjectRouteWarrantyForm.tsx:83 ProjectRouteWarrantyForm.tsx:115 ProjectRouteWarrantyGrid.tsx:106 |
| SCP0048/Main//call-proc | hook | 1 | Y | ProjectRouteWarranty.tsx:81 |
| /admin/menu/SCP0048/column | http | 1 | Y | useProjectRouteWarrantyStore.ts:129 |
| /admin/menu/SCP0048/search-conditions | http | 1 | Y | useProjectRouteWarrantyStore.ts:145 |
| /SCP0048/Main/SAVE/call-proc | http | 1 | Y | projectRouteWarranty.saveRequest.ts:80 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | noDivisionAuth ? undefined : onSearch | jsx | features/supply/src/pages/project-route-warranty/components/ProjectRouteWarrantyForm.tsx | 129 |
| CustomDropdown | onChange | <arrow> setSearchParams,String | jsx | features/supply/src/pages/project-route-warranty/components/ProjectRouteWarrantyForm.tsx | 149 |
| CustomDropdown | onChange | <arrow> setSearchParams,String | jsx | features/supply/src/pages/project-route-warranty/components/ProjectRouteWarrantyForm.tsx | 171 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/project-route-warranty/components/ProjectRouteWarrantyForm.tsx | 200 |
| Button | onClick | <arrow> setOpenItemModal | jsx | features/supply/src/pages/project-route-warranty/components/ProjectRouteWarrantyForm.tsx | 196 |
| CustomDropdown | onChange | <arrow> setSearchParams,String | jsx | features/supply/src/pages/project-route-warranty/components/ProjectRouteWarrantyForm.tsx | 215 |
| grid | updatedLayout | <arrow> attachDivisionDataMap | addHandler | features/supply/src/pages/project-route-warranty/components/ProjectRouteWarrantyGrid.tsx | 241 |
| grid | updatedLayout | applyDateColumnTypes | addHandler | features/supply/src/pages/project-route-warranty/components/ProjectRouteWarrantyGrid.tsx | 243 |
| grid | formatItem | formatItemHandler | addHandler | features/supply/src/pages/project-route-warranty/components/ProjectRouteWarrantyGrid.tsx | 245 |
| grid | beginningEdit | beginningEditHandler | addHandler | features/supply/src/pages/project-route-warranty/components/ProjectRouteWarrantyGrid.tsx | 246 |
| DataGrid | initialized | handleGridInitialized | jsx | features/supply/src/pages/project-route-warranty/components/ProjectRouteWarrantyGrid.tsx | 355 |
| DataGrid | cellEditEnded | handleCellEdit | jsx | features/supply/src/pages/project-route-warranty/components/ProjectRouteWarrantyGrid.tsx | 356 |
| DataGrid | pastedCell | handleCellEdit | jsx | features/supply/src/pages/project-route-warranty/components/ProjectRouteWarrantyGrid.tsx | 357 |
| DataGrid | gotFocus | gotFocus | jsx | features/supply/src/pages/project-route-warranty/components/ProjectRouteWarrantyGrid.tsx | 359 |
| ProjectRouteWarrantyForm | onSearch | handleSearch | jsx | features/supply/src/pages/project-route-warranty/ProjectRouteWarranty.tsx | 330 |
| ProjectRouteWarrantyGrid | onItemCellDblClick | handleItemCellDblClick | jsx | features/supply/src/pages/project-route-warranty/ProjectRouteWarranty.tsx | 348 |
| ProjectRouteWarrantyGrid | onSalesSiteCellDblClick | handleSalesSiteCellDblClick | jsx | features/supply/src/pages/project-route-warranty/ProjectRouteWarranty.tsx | 349 |
| ModelByDivisionPopup | onClose | <arrow> setPopupTarget | jsx | features/supply/src/pages/project-route-warranty/ProjectRouteWarranty.tsx | 357 |
| ModelByDivisionPopup | onSelect | <arrow> handleItemSelected | jsx | features/supply/src/pages/project-route-warranty/ProjectRouteWarranty.tsx | 358 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 4 |
| FormItem | 4 |
| CustomDropdown | 3 |
| SearchArea | 1 |
| InputField | 1 |
| Button | 1 |
| FunctionSearchIcon | 1 |
| MaterialByDivisionModal | 1 |
| DataGrid | 1 |
| MainTitle | 1 |
| ProjectRouteWarrantyForm | 1 |
| SubTitle | 1 |
| ProjectRouteWarrantyGrid | 1 |
| ModelByDivisionPopup | 1 |
| ItemByDivisionModal | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00632 | 1 |
| MSG00097 | 2 |
| MSG00002 | 1 |
| MSG00618 | 1 |
| MSG00004 | 1 |
| MSG00662 | 1 |
| MSG01222 | 1 |
| MSG01223 | 1 |
| MSG01224 | 1 |
| MSG01226 | 2 |
| MSG01227 | 1 |
| MSG01225 | 1 |
| MSG01134 | 1 |
| MSG01230 | 1 |
| MSG01080 | 1 |
| MSG01231 | 1 |
| MSG00429 | 1 |
| MSG01319 | 1 |
| LBL00112 | 1 |
| LBL00001 | 1 |
| LBL00005 | 1 |
| LBL00027 | 1 |
| LBL00618 | 1 |
| LBL00007 | 1 |
| LBL00414 | 1 |
| LBL00394 | 1 |
| MSG00009 | 1 |
| MSG00011 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0048(18), SCP0006(10), SCP0027(3), COM0008(2), SCM0002(1), SCP0039(1), SCP0101(1), SCM0019(1)
- SP/PKG: PKG_SCP0048(3), P_SCP0048_GET_PROJECTROUTE_WARRANTY(2), P_SCP0048_SAVE_PROJECTROUTE_WARRANTY(2), P_DEBUG_MODE(2), P_SCP0048_GET_PROJECTROUTE_(1), PKG_NSCM_UI_COM_AUTH(1), P_SHT_NM(1), FN_GET_ITEM_NICKNAME(1), P_FROM(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | ([gridRef])로 걸었으나, wijmo 비동기 mount 라 첫 pass 에 gridRef.current===undefined → early-return | features/supply/src/pages/project-route-warranty/components/ProjectRouteWarrantyGrid.tsx | 197 |
| code | (grid 미확정 early-return 으로 미등록되던 버그, 위 beginningEditHandler 주석 참고). | features/supply/src/pages/project-route-warranty/components/ProjectRouteWarrantyGrid.tsx | 238 |
| endpoint | 컬럼 메타 fetch(/admin/menu/SCP0048/column)의 sheetNm 은 SCM_MST_SHEET_COLUMNS.SHEET_NAME 과 정확히 일치해야 한다(BE 문자열 매칭). SCP0048 은 단일 시트(AS-IS spdMain)이며 DB SHEET_NAME 으로 'Main' 배포된 것으로 본다(design/03 §1). 라이브 확인필요(design/03 §6). | features/supply/src/pages/project-route-warranty/project-route-warranty.constants.ts | 38 |
| endpoint | mount 1회 컬럼 메타 fetch(admin 즉시반영 baseline) + F10 자가복구. reset()→initState() 가 | features/supply/src/pages/project-route-warranty/ProjectRouteWarranty.tsx | 105 |
| code | (자매 SCP0039 master-validation 패턴). fetchStaticColumns 가 GET await 전에 initialized 를 | features/supply/src/pages/project-route-warranty/ProjectRouteWarranty.tsx | 108 |
| endpoint | 컬럼 메타는 admin(SCM_MST_SHEET_COLUMNS)에서 동적 fetch(ui-category hook, 하드코딩 금지). | features/supply/src/pages/project-route-warranty/useProjectRouteWarrantyStore.ts | 125 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

