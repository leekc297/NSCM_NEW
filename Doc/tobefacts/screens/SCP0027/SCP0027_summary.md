# SCP0027 — To-Be Fact Pack 요약

- page_key: `supply/project-route-electrode` · feature: supply · As-is Fact Pack 있음
- 파일 11 · 엔드포인트 호출 11 (미해결 1, 주석 속 4) · 이벤트 14 · 컴포넌트 사용 25 · 하드코딩 컬럼 0 · 메시지 29
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/project-route-electrode/components/ProjectRouteElectrodeForm.tsx | component | 258 |
| features/supply/src/pages/project-route-electrode/components/ProjectRouteElectrodeGrid.tsx | component | 449 |
| features/supply/src/pages/project-route-electrode/hooks/useProjectRouteElectrodeValidation.ts | hook | 340 |
| features/supply/src/pages/project-route-electrode/index.ts | index | 2 |
| features/supply/src/pages/project-route-electrode/project-route-electrode.constants.ts | constants | 190 |
| features/supply/src/pages/project-route-electrode/project-route-electrode.types.ts | types | 17 |
| features/supply/src/pages/project-route-electrode/ProjectRouteElectrode.tsx | page | 331 |
| features/supply/src/pages/project-route-electrode/useProjectRouteElectrodeStore.ts | store | 141 |
| features/supply/src/pages/project-route-electrode/utils/projectRouteElectrode.derive.ts | util | 40 |
| features/supply/src/pages/project-route-electrode/utils/projectRouteElectrode.saveRequest.ts | util | 96 |
| features/supply/src/pages/project-route-electrode/__asis-mapping__.md | mapping | 107 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 5 | Y | ProjectRouteElectrodeForm.tsx:43 ProjectRouteElectrodeForm.tsx:60 ProjectRouteElectrodeForm.tsx:107 ProjectRouteElectrodeGrid.tsx:90 ProjectRouteElectrode.tsx:63 |
| (useTabLookupQueries) | hook | 1 | Y | ProjectRouteElectrodeForm.tsx:66 |
| {?{comboId:COMBO.CELL_PLANT_SITE,mnuId:MENU_ID,sheetName:SHEETS.MAIN,divisionId:`'} | http | 1 | N | ProjectRouteElectrodeGrid.tsx:132 |
| SCP0027/Main//call-proc | hook | 1 | Y | ProjectRouteElectrode.tsx:77 |
| /admin/menu/SCP0027/column | http | 1 | Y | useProjectRouteElectrodeStore.ts:104 |
| /admin/menu/SCP0027/search-conditions | http | 1 | Y | useProjectRouteElectrodeStore.ts:115 |
| /SCP0027/Main/SAVE/call-proc | http | 1 | Y | projectRouteElectrode.saveRequest.ts:79 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | noDivisionAuth ? undefined : onSearch | jsx | features/supply/src/pages/project-route-electrode/components/ProjectRouteElectrodeForm.tsx | 121 |
| CustomDropdown | onChange | <arrow> setSearchParams,String | jsx | features/supply/src/pages/project-route-electrode/components/ProjectRouteElectrodeForm.tsx | 142 |
| CustomDropdown | onChange | <arrow> setSearchParams,String | jsx | features/supply/src/pages/project-route-electrode/components/ProjectRouteElectrodeForm.tsx | 164 |
| CustomDropdown | onChange | <arrow> String,setSearchParams | jsx | features/supply/src/pages/project-route-electrode/components/ProjectRouteElectrodeForm.tsx | 181 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/project-route-electrode/components/ProjectRouteElectrodeForm.tsx | 212 |
| Button | onClick | <arrow> setOpenItemModal | jsx | features/supply/src/pages/project-route-electrode/components/ProjectRouteElectrodeForm.tsx | 208 |
| CustomDropdown | onChange | <arrow> setSearchParams,String | jsx | features/supply/src/pages/project-route-electrode/components/ProjectRouteElectrodeForm.tsx | 227 |
| grid | updatedLayout | attach | addHandler | features/supply/src/pages/project-route-electrode/components/ProjectRouteElectrodeGrid.tsx | 218 |
| grid | beginningEdit | beginningEditHandler | addHandler | features/supply/src/pages/project-route-electrode/components/ProjectRouteElectrodeGrid.tsx | 280 |
| grid | formatItem | handler | addHandler | features/supply/src/pages/project-route-electrode/components/ProjectRouteElectrodeGrid.tsx | 322 |
| DataGrid | cellEditEnded | handleCellEdit | jsx | features/supply/src/pages/project-route-electrode/components/ProjectRouteElectrodeGrid.tsx | 443 |
| DataGrid | gotFocus | gotFocus | jsx | features/supply/src/pages/project-route-electrode/components/ProjectRouteElectrodeGrid.tsx | 445 |
| ProjectRouteElectrodeForm | onSearch | handleSearch | jsx | features/supply/src/pages/project-route-electrode/ProjectRouteElectrode.tsx | 289 |
| ProjectRouteElectrodeGrid | onItemCellDblClick | handleItemCellDblClick | jsx | features/supply/src/pages/project-route-electrode/ProjectRouteElectrode.tsx | 309 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 5 |
| FormItem | 5 |
| CustomDropdown | 4 |
| MaterialByDivisionModal | 2 |
| SearchArea | 1 |
| InputField | 1 |
| Button | 1 |
| FunctionSearchIcon | 1 |
| DataGrid | 1 |
| MainTitle | 1 |
| ProjectRouteElectrodeForm | 1 |
| SubTitle | 1 |
| ProjectRouteElectrodeGrid | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| MSG00097 | 2 |
| MSG00004 | 1 |
| MSG00006 | 1 |
| MSG00133 | 1 |
| MSG00662 | 1 |
| MSG01222 | 1 |
| MSG00257 | 1 |
| MSG00212 | 1 |
| MSG00213 | 1 |
| MSG00214 | 1 |
| MSG00215 | 1 |
| MSG00216 | 1 |
| MSG00217 | 1 |
| MSG00107 | 1 |
| MSG00219 | 1 |
| MSG00048 | 1 |
| MSG00220 | 1 |
| LBL00112 | 1 |
| LBL00001 | 1 |
| LBL00005 | 1 |
| LBL00027 | 1 |
| LBL00618 | 1 |
| LBL00007 | 1 |
| LBL00632 | 1 |
| LBL00414 | 1 |
| LBL00394 | 1 |
| MSG00009 | 1 |
| MSG00011 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0048(20), SCP0027(14)
- SP/PKG: FN_STRING_SPLIT(3), PKG_SCP0027(2), P_DEBUG_MODE(2), PKG_NSCM_UI_COM_AUTH(1), P_SHT_NM(1), P_SCP0027_GET_PROJECTROUTE_ELECTRODE(1), FN_GET_ITEM_NICKNAME(1), P_SNAKE_CASE(1), P_ACTIVE_FLAG(1), P_VALID_YN(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| endpoint | 컬럼 메타 fetch(/admin/menu/SCP0027/column)의 sheetNm 은 SCM_MST_SHEET_COLUMNS.SHEET_NAME 과 정확히 일치해야 한다(BE 문자열 매칭). SCP0027 은 단일 시트(AS-IS spdMain)이며 DB SHEET_NAME 이 'Main'(31컬럼)으로 배포됨(design/03 §1, 2026-09-26 ora.py 실측). | features/supply/src/pages/project-route-electrode/project-route-electrode.constants.ts | 35 |
| code | TODO — AS-IS 도 메시지 없이 return). 전극(E) 전용 화면. | features/supply/src/pages/project-route-electrode/project-route-electrode.constants.ts | 48 |
| endpoint | useTabLookupQueries({ lookupType }) 규격(자매 working-time DAY_WEEK_LOOKUP 패턴). | features/supply/src/pages/project-route-electrode/project-route-electrode.constants.ts | 117 |
| endpoint | mount 1회 컬럼 메타 fetch(admin 즉시반영 baseline). | features/supply/src/pages/project-route-electrode/ProjectRouteElectrode.tsx | 98 |
| endpoint | 컬럼 메타는 admin(SCM_MST_SHEET_COLUMNS)에서 동적 fetch(ui-category hook, 하드코딩 금지). | features/supply/src/pages/project-route-electrode/useProjectRouteElectrodeStore.ts | 100 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

