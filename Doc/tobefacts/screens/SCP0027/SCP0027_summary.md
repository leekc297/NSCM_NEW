# SCP0027 — To-Be Fact Pack 요약

- page_key: `supply/project-route-electrode` · feature: supply · As-is Fact Pack 있음
- 파일 11 · 엔드포인트 호출 12 (미해결 1, 주석 속 4) · 이벤트 16 · 컴포넌트 사용 25 · 하드코딩 컬럼 0 · 메시지 29
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/project-route-electrode/components/ProjectRouteElectrodeForm.tsx | component | 264 |
| features/supply/src/pages/project-route-electrode/components/ProjectRouteElectrodeGrid.tsx | component | 552 |
| features/supply/src/pages/project-route-electrode/hooks/useProjectRouteElectrodeValidation.ts | hook | 340 |
| features/supply/src/pages/project-route-electrode/index.ts | index | 2 |
| features/supply/src/pages/project-route-electrode/project-route-electrode.constants.ts | constants | 190 |
| features/supply/src/pages/project-route-electrode/project-route-electrode.types.ts | types | 17 |
| features/supply/src/pages/project-route-electrode/ProjectRouteElectrode.tsx | page | 364 |
| features/supply/src/pages/project-route-electrode/useProjectRouteElectrodeStore.ts | store | 141 |
| features/supply/src/pages/project-route-electrode/utils/projectRouteElectrode.derive.ts | util | 75 |
| features/supply/src/pages/project-route-electrode/utils/projectRouteElectrode.saveRequest.ts | util | 96 |
| features/supply/src/pages/project-route-electrode/__asis-mapping__.md | mapping | 107 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 5 | Y | ProjectRouteElectrodeForm.tsx:43 ProjectRouteElectrodeForm.tsx:60 ProjectRouteElectrodeForm.tsx:107 ProjectRouteElectrodeGrid.tsx:119 ProjectRouteElectrode.tsx:66 |
| (useTabLookupQueries) | hook | 2 | Y | ProjectRouteElectrodeForm.tsx:66 ProjectRouteElectrode.tsx:81 |
| {?{comboId:COMBO.CELL_PLANT_SITE,mnuId:MENU_ID,sheetName:SHEETS.MAIN,divisionId:`'} | http | 1 | N | ProjectRouteElectrodeGrid.tsx:161 |
| SCP0027/Main//call-proc | hook | 1 | Y | ProjectRouteElectrode.tsx:104 |
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
| grid | updatedLayout | attach | addHandler | features/supply/src/pages/project-route-electrode/components/ProjectRouteElectrodeGrid.tsx | 247 |
| grid | beginningEdit | beginningEditHandler | addHandler | features/supply/src/pages/project-route-electrode/components/ProjectRouteElectrodeGrid.tsx | 309 |
| grid | cellEditEnding | cellEditEndingHandler | addHandler | features/supply/src/pages/project-route-electrode/components/ProjectRouteElectrodeGrid.tsx | 381 |
| host? | keydown | keydownHandler | addEventListener | features/supply/src/pages/project-route-electrode/components/ProjectRouteElectrodeGrid.tsx | 382 |
| grid | formatItem | handler | addHandler | features/supply/src/pages/project-route-electrode/components/ProjectRouteElectrodeGrid.tsx | 425 |
| DataGrid | cellEditEnded | handleCellEdit | jsx | features/supply/src/pages/project-route-electrode/components/ProjectRouteElectrodeGrid.tsx | 546 |
| DataGrid | gotFocus | gotFocus | jsx | features/supply/src/pages/project-route-electrode/components/ProjectRouteElectrodeGrid.tsx | 548 |
| ProjectRouteElectrodeForm | onSearch | handleSearch | jsx | features/supply/src/pages/project-route-electrode/ProjectRouteElectrode.tsx | 316 |
| ProjectRouteElectrodeGrid | onItemCellDblClick | handleItemCellDblClick | jsx | features/supply/src/pages/project-route-electrode/ProjectRouteElectrode.tsx | 336 |

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
| MSG00002 | 1 |
| MSG00006 | 1 |
| MSG00133 | 1 |
| MSG00662 | 1 |
| MSG01222 | 1 |
| MSG01019 | 1 |
| MSG01129 | 1 |
| MSG01130 | 1 |
| MSG01131 | 1 |
| MSG01132 | 1 |
| MSG00700 | 1 |
| MSG01133 | 1 |
| MSG01134 | 1 |
| MSG00219 | 1 |
| MSG00048 | 1 |
| MSG01137 | 1 |
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
| code | if (text !== '' && !/^\d+$/.test(text.replace(/,/g, ''))) e.cancel = true; | features/supply/src/pages/project-route-electrode/components/ProjectRouteElectrodeGrid.tsx | 330 |
| code | const keydownHandler = (ev: KeyboardEvent) => { | features/supply/src/pages/project-route-electrode/components/ProjectRouteElectrodeGrid.tsx | 343 |
| code | if (ev.ctrlKey \|\| ev.metaKey \|\| ev.altKey \|\| ev.key.length !== 1) return; | features/supply/src/pages/project-route-electrode/components/ProjectRouteElectrodeGrid.tsx | 344 |
| code | if (col == null \|\| grid.columns[col]?.binding !== PRIORITY_COLUMN) return; | features/supply/src/pages/project-route-electrode/components/ProjectRouteElectrodeGrid.tsx | 346 |
| code | ev.preventDefault(); | features/supply/src/pages/project-route-electrode/components/ProjectRouteElectrodeGrid.tsx | 348 |
| code | ev.stopPropagation(); | features/supply/src/pages/project-route-electrode/components/ProjectRouteElectrodeGrid.tsx | 349 |
| code | }; | features/supply/src/pages/project-route-electrode/components/ProjectRouteElectrodeGrid.tsx | 351 |
| endpoint | 컬럼 메타 fetch(/admin/menu/SCP0027/column)의 sheetNm 은 SCM_MST_SHEET_COLUMNS.SHEET_NAME 과 정확히 일치해야 한다(BE 문자열 매칭). SCP0027 은 단일 시트(AS-IS spdMain)이며 DB SHEET_NAME 이 'Main'(31컬럼)으로 배포됨(design/03 §1, 2026-09-26 ora.py 실측). | features/supply/src/pages/project-route-electrode/project-route-electrode.constants.ts | 35 |
| code | TODO — AS-IS 도 메시지 없이 return). 전극(E) 전용 화면. | features/supply/src/pages/project-route-electrode/project-route-electrode.constants.ts | 48 |
| endpoint | useTabLookupQueries({ lookupType }) 규격(자매 working-time DAY_WEEK_LOOKUP 패턴). | features/supply/src/pages/project-route-electrode/project-route-electrode.constants.ts | 117 |
| code | const popupOperationGroupLabel = useMemo(() => { | features/supply/src/pages/project-route-electrode/ProjectRouteElectrode.tsx | 83 |
| code | if (!code) return t(LBL.ALL, '_ALL'); | features/supply/src/pages/project-route-electrode/ProjectRouteElectrode.tsx | 85 |
| code | const hit = (operationGroupsRaw ?? []).find( | features/supply/src/pages/project-route-electrode/ProjectRouteElectrode.tsx | 86 |
| code | r => safeString((r as Record<string, unknown>).CODE) === code | features/supply/src/pages/project-route-electrode/ProjectRouteElectrode.tsx | 87 |
| code | ); | features/supply/src/pages/project-route-electrode/ProjectRouteElectrode.tsx | 88 |
| code | return hit ? safeString((hit as Record<string, unknown>).NAME) : code; | features/supply/src/pages/project-route-electrode/ProjectRouteElectrode.tsx | 89 |
| code | }, [searchParams.operationGroup, operationGroupsRaw, t]); | features/supply/src/pages/project-route-electrode/ProjectRouteElectrode.tsx | 90 |
| endpoint | mount 1회 컬럼 메타 fetch(admin 즉시반영 baseline). | features/supply/src/pages/project-route-electrode/ProjectRouteElectrode.tsx | 125 |
| endpoint | 컬럼 메타는 admin(SCM_MST_SHEET_COLUMNS)에서 동적 fetch(ui-category hook, 하드코딩 금지). | features/supply/src/pages/project-route-electrode/useProjectRouteElectrodeStore.ts | 100 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

