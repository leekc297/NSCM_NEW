# SCP0007 — To-Be Fact Pack 요약

- page_key: `supply/bod` · feature: supply · As-is Fact Pack 없음(화면ID 미대응)
- 파일 13 · 엔드포인트 호출 11 (미해결 0, 주석 속 1) · 이벤트 24 · 컴포넌트 사용 59 · 하드코딩 컬럼 0 · 메시지 25
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/bod/bod.constants.ts | constants | 154 |
| features/supply/src/pages/bod/Bod.tsx | page | 308 |
| features/supply/src/pages/bod/bod.types.ts | types | 30 |
| features/supply/src/pages/bod/bod.util.ts | other | 131 |
| features/supply/src/pages/bod/components/BodForm.tsx | component | 194 |
| features/supply/src/pages/bod/components/BodGrid.tsx | component | 615 |
| features/supply/src/pages/bod/components/modals/bod-distribution-route-popup.constants.ts | constants | 19 |
| features/supply/src/pages/bod/components/modals/BodDistributionRoutePopup.module.scss | component | 35 |
| features/supply/src/pages/bod/components/modals/BodDistributionRoutePopup.tsx | component | 326 |
| features/supply/src/pages/bod/components/modals/bodDistributionRoutePopupStore.ts | store | 63 |
| features/supply/src/pages/bod/index.ts | index | 2 |
| features/supply/src/pages/bod/useBodStore.ts | store | 110 |
| features/supply/src/pages/bod/__asis-mapping__.md | mapping | 228 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| SCP0007/bod//call-proc | hook | 1 | Y | Bod.tsx:50 |
| SCP0007/countryCity//call-proc | hook | 1 | Y | Bod.tsx:68 |
| /SCP0007/bod/SAVE/call-proc | http | 1 | Y | Bod.tsx:91 |
| (useTabComboQueries) | hook | 3 | Y | BodForm.tsx:34 BodGrid.tsx:155 BodDistributionRoutePopup.tsx:62 |
| SCP0007/routeCnt/SEARCH/call-proc | callProc | 1 | Y | BodGrid.tsx:339 |
| SCP0005/route//call-proc | hook | 1 | Y | BodDistributionRoutePopup.tsx:116 |
| /admin/menu/SCP0005/column | http | 1 | Y | bodDistributionRoutePopupStore.ts:50 |
| /admin/menu/SCP0007/column | http | 1 | Y | useBodStore.ts:80 |
| /admin/menu/SCP0007/search-conditions | http | 1 | Y | useBodStore.ts:91 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| bod | divisionId fromSite toSite incoterms incotermsSsp transMode inputStatus validYn | o_rc1 |  |
| countryCity | divisionId scmSiteId | o_rc1 | SCP0007_GET_COUNTRY_CITY PKG_SCP0007 P_SCP0007_GET_COUNTRY_CITY |
| routeCnt | fromCity toCity | o_rc1 | SCP0007_GET_ROUTE_CNT PKG_SCP0007 P_SCP0007_GET_ROUTE_CNT |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| BodGrid | onRouteCellDblClick | handleRouteCellDblClick | jsx | features/supply/src/pages/bod/Bod.tsx | 289 |
| BodDistributionRoutePopup | onSelect | handleRouteSelect | jsx | features/supply/src/pages/bod/Bod.tsx | 303 |
| SearchArea | onSearch | onSearch | jsx | features/supply/src/pages/bod/components/BodForm.tsx | 53 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/bod/components/BodForm.tsx | 74 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/bod/components/BodForm.tsx | 90 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/bod/components/BodForm.tsx | 106 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/bod/components/BodForm.tsx | 122 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/bod/components/BodForm.tsx | 138 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/bod/components/BodForm.tsx | 152 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/bod/components/BodForm.tsx | 168 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/bod/components/BodForm.tsx | 184 |
| g | updatedLayout | apply | addHandler | features/supply/src/pages/bod/components/BodGrid.tsx | 244 |
| g | updatedLayout | apply | addHandler | features/supply/src/pages/bod/components/BodGrid.tsx | 264 |
| grid | beginningEdit | handler | addHandler | features/supply/src/pages/bod/components/BodGrid.tsx | 448 |
| grid | formatItem | handler | addHandler | features/supply/src/pages/bod/components/BodGrid.tsx | 568 |
| DataGrid | cellEditEnded | handleCellEdit | jsx | features/supply/src/pages/bod/components/BodGrid.tsx | 609 |
| DataGrid | pastedCell | handleCellEdit | jsx | features/supply/src/pages/bod/components/BodGrid.tsx | 610 |
| g.hostElement? | dblclick | onDbl | addEventListener | features/supply/src/pages/bod/components/modals/BodDistributionRoutePopup.tsx | 148 |
| SearchArea | onSearch | handleSearch | jsx | features/supply/src/pages/bod/components/modals/BodDistributionRoutePopup.tsx | 172 |
| FunctionSearchIcon | onClick | <arrow> setRegionMode | jsx | features/supply/src/pages/bod/components/modals/BodDistributionRoutePopup.tsx | 209 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/bod/components/modals/BodDistributionRoutePopup.tsx | 230 |
| FunctionSearchIcon | onClick | <arrow> setRegionMode | jsx | features/supply/src/pages/bod/components/modals/BodDistributionRoutePopup.tsx | 261 |
| Button | onClick | handleApply | jsx | features/supply/src/pages/bod/components/modals/BodDistributionRoutePopup.tsx | 302 |
| Button | onClick | modalClose | jsx | features/supply/src/pages/bod/components/modals/BodDistributionRoutePopup.tsx | 309 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 13 |
| FormItem | 13 |
| CustomDropdown | 9 |
| InputField | 4 |
| Button | 4 |
| SearchArea | 2 |
| DataGrid | 2 |
| FunctionSearchIcon | 2 |
| MainTitle | 1 |
| BodForm | 1 |
| SubTitle | 1 |
| BodGrid | 1 |
| BodDistributionRoutePopup | 1 |
| CustomDialog | 1 |
| ProgressIndicator | 1 |
| ResultArea | 1 |
| ControlConfirmIcon | 1 |
| RegionModal | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| MSG00043 | 1 |
| MSG00159 | 1 |
| MSG00085 | 2 |
| MSG00165 | 1 |
| MSG00219 | 1 |
| MSG00355 | 2 |
| MSG00253 | 1 |
| LBL00112 | 1 |
| LBL00001 | 1 |
| LBL00022 | 1 |
| LBL00023 | 1 |
| LBL00024 | 1 |
| LBL00025 | 2 |
| LBL01083 | 1 |
| LBL00639 | 1 |
| LBL00026 | 1 |
| LBL00664 | 1 |
| LBL00074 | 1 |
| LBL00070 | 1 |
| LBL00075 | 1 |
| LBL00071 | 1 |
| LBL00627 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0007(7), SCP0005(2), DMF0020(1), COM0001(1)
- SP/PKG: SCP0007_GET_COUNTRY_CITY(2), SCP0005_GET_DISTRIBUTION_ROUTE(2), SCP0007_GET_BOD(1), PKG_SCP0007(1), P_SCP0007_GET_COUNTRY_CITY(1), P_SCP0007_SAVE_BOD(1), SCP0007_GET_ROUTE_CNT(1), P_TRANSPORT_MODE(1), PKG_SCP0005(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| endpoint | 보낸다. 공용 useProcMutation(callMutationProc)은 body 로 `{ data }` 배열 1개만 전송하는 | features/supply/src/pages/bod/Bod.tsx | 79 |
| code | AS-IS DeleteButton(SCP0007_BOD.cs L361-365) — action(CRUD_TYPE) != 'I' 이면 silent return. | features/supply/src/pages/bod/Bod.tsx | 173 |
| code | 저장 전 행 단위 업무 검증 — AS-IS SaveData_Main(SCP0007_BOD.cs L677-782) 중 필수값(공통 checkRequiredOfSpread 로 이미 커버되는 항목 제외) 이외의 BOD 고유 규칙만 이식한다. 첫 위반 1건만 반환(AS-IS 도 위반 즉시 return). Monday/Sunday 위반 시 AS-IS 처럼 해당 셀 값을 자동 보정(가까운 월/일요일)하고 실패를 반환 — 사용자가 보정된  | features/supply/src/pages/bod/bod.util.ts | 67 |

## 10. __asis-mapping__.md 상태
- 구현: 82
- 해당없음: 18
- 미구현: 17
- 구현(max 99 제외): 1
- 제외: 6
| design_id | summary | reason | status |
|---|---|---|---|
| D00-1-010 | §1 components / Container | WinForms 디자이너 전용 리소스 컨테이너 — React 대응 요소 없음(UI 동작과 무관) | 해당없음 |
| D00-1-011 | §1 emptySpaceItem1 / EmptySpaceItem | WinForms 레이아웃 여백 채움용 — MUI Grid 반응형 레이아웃이 자동 처리, 1:1 대응 요소 없음 | 해당없음 |
| D00-1-012 | §1 emptySpaceItem3 / EmptySpaceItem | 위와 동일 사유 | 해당없음 |
| D00-1-013 | §1 imageList1 / ImageList | ROUTE_ID 팝업 아이콘 리소스 컨테이너(cellTypeImage 배경, DefineProperty L197-204) — DataGrid 표준 셀 렌더로 대체, 별도 리소스 컨테이너 불필요 | 해당없음 |
| D00-1-014 | §1 layoutControlGroup1 / LayoutControlGroup | WinForms 레이아웃 컨테이너 — MUI `Grid` 컴포넌트 구조로 대체(레이아웃 컨테이너 자체는 일부 대응이나 개별 채번 대상 아님) | 해당없음 |
| D00-1-015 | §1 layoutControlGroup2 / LayoutControlGroup | 위와 동일 사유 | 해당없음 |
| D00-1-016 | §1 layoutControlItem1 / LayoutControlItem | 캡션 레이블 래퍼 — `FormItem label` prop 구조로 대체, 개별 채번 대상 아님 | 해당없음 |
| D00-1-017 | §1 layoutControlItem3 / LayoutControlItem | 위와 동일 사유 | 해당없음 |
| D00-1-018 | §1 layoutDivision / LayoutControlItem | Division 필드 레이아웃 래퍼 — `FormItem` 구조로 대체 | 해당없음 |
| D00-1-019 | §1 layoutFrom / LayoutControlItem | From Site 필드 레이아웃 래퍼 — 위와 동일 | 해당없음 |
| D00-1-020 | §1 layoutIncoterms / LayoutControlItem | Incoterms 필드 레이아웃 래퍼 — 위와 동일 | 해당없음 |
| D00-1-021 | §1 layoutSSPIncoterms / LayoutControlItem | SSP Incoterms 필드 레이아웃 래퍼 — 위와 동일 | 해당없음 |
| D00-1-022 | §1 layoutToSite / LayoutControlItem | To Site 필드 레이아웃 래퍼 — 위와 동일 | 해당없음 |
| D00-1-023 | §1 layoutTransMode / LayoutControlItem | Trans Mode 필드 레이아웃 래퍼 — 위와 동일 | 해당없음 |
| D00-1-024 | §1 usrLayoutControl1 / UsrLayoutControl | WinForms 커스텀 레이아웃 컨트롤(조건 영역 컨테이너) — `SearchArea`/`Grid` 구조로 대체 | 해당없음 |
| D00-1-025 | §1 usrLayoutControl2 / UsrLayoutControl | 위와 동일 사유(Division 권한체크 영역, `SetDivisionAuthCheck` L211-212 — 서버측 `MyDivision` 콤보 필터로 대체) | 해당없음 |
| D00-2-006 | §2 spdMain / EditChange | AS-IS `SpdMain_EditChange`(cs:1328-1353)의 2가지 동작 중 INCOTERMS_SSP 동기화(`BodGrid.tsx:237-244`)만 구현됨 — ROUTE_ID 직접편집 차단(`CancelCellEditing()`, cs:1330-1333)은 미구현(§D00-2-007과 동일 결함) | 미구현 |
| D00-2-007 | §2 spdMain / KeyPress | AS-IS `SpdMain_KeyPress`(cs:1322-1327)가 `ActiveColumnIndex==ROUTE_ID`일 때 `e.Handled=true`로 직접 키보드 입력을 막는다. TO-BE `BodGrid.tsx`에 ROUTE_ID 컬럼 편집 차단 로직이 없다(grep 0건) — 그리드 메타도 `CELL_CONTROL_OBJECT_TYPE_CODE` 미등록(ora.py 실측)이라 편집 자체를 막는 장치가 없다. ROUTE_ID는 팝업 선택으로만 채워져야 하는데 사용자가 직접 타이핑 가능한 상태 -- 중위험 — ROUTE_ID 직접 편집 시 Route 팝업 매칭 없는 값이 저장될 수 있음. `SpdMain_EditChange`의 `CancelCellEditing()`과 합쳐 재현 필요 | 미구현 |
| D00-3-005 | §3 VisibleTab / (true) | FarPoint Spread 탭(시트 선택 UI) 표시 옵션 — React 그리드는 단일 뷰라 탭 개념 자체가 없음(AS-IS도 시트 1개뿐이라 탭 자체는 무의미했을 가능성 높음) -- React 단일뷰 그리드, 시트탭 개념 없음 | 해당없음 |
| D00-3-009 | §3 SetCellTypeCombo / (DIVISION_ID, dtMyDivision) | **신규 발견**: 신규행에서 DIVISION_ID를 "내 division 목록" 콤보로 제한하는 로직이 TO-BE에 없다(`BodGrid.tsx` grep 0건). DB 메타도 `CELL_CONTROL_OBJECT_TYPE_CODE`/`CELL_COMBO_DATA_TYPE` 둘 다 공란(ora.py 실측) — `03_grid-columns.md:118`도 "코드 전용 배선 필요"로 이미 명시했으나 실제 구현이 안 됐다. 조회조건 division이 정확히 1개일 때는 자동세팅+잠금(D00-3-016/017 구현됨)되어 영향 없지만, 다중/미선택 division으로 조회 후 신규행을 추가하면 DIVISION_ID가 자유 텍스트 입력이 되어 권한 없는 division 코드를 입력할 수 있다 -- 중위험 — 신규 발견, 권한 밖 division 입력 가능 | 미구현 |
| D00-3-027 | §3 SwitchLock / () | EditButton 토글 어포던스 자체는 전 화면 미이식 결정(`asis_to_tobe.md §11`, 2026-09-23, SCP0007 G1 최초 확인) — R3 재질문 대상 아님. 단 기존행 재편집 시 잠금 범위 재현 여부는 별도 검증 필요(D00-3-034/036 참조) | 제외 |
| D00-3-028 | §3 LockColumn / (DIVISION_ID..INCOTERMS,true) | D00-3-027과 동일 근거(EditButton 진입 시 구간 재잠금 — 토글 어포던스 미이식 결정) | 제외 |
| D00-3-029 | §3 LockColumn / (ROUTE_CNT..TRANSPORT_MODE,true) | D00-3-027과 동일 근거. 인덱스 역순(AS-IS 해석 불가) 여부는 토글 자체가 없어져 더 이상 의미 없음 | 제외 |
| D00-3-030 | §3 LockColumn / (LT_TYPE..BOD_ID,true) | D00-3-027과 동일 근거 | 제외 |
| D00-3-031 | §3 LockColumn / (ROUTE_VALID..end,true) | D00-3-027과 동일 근거 | 제외 |
| D00-3-034 | §3 SetCellTypeCombo / (i,INCOTERMS_SSP, dtIncotermsEdit) | EditButton 진입 시 전행에 신규행 전용 콤보로 스왑하는 로직이나, TO-BE는 ATTRIBUTE9가 CRUD_TYPE='I'(신규행)에만 적용되고 기존행 재편집에는 적용되지 않는다. **토글 어포던스 미이식 결정(D00-3-027 등, §11)의 예외 대상 아님** — 이건 "어떤 컬럼이 잠겨야 하는가"라는 실질 잠금 범위 질문이라 계속 R1/R2 검증 대상(`kyr/screens/scp/bod-review-issues.md` #1과 동일 잔여 갭) — 기존행 재편집 시 dtIncotermsEdit 스왑 없음 | 미구현 |
| D00-3-036 | §3 SetCellTypeCombo / (i,INCOTERMS_SSP, dtIncoterms) | D00-3-034와 동일 근거(EditButton 진입 시 원래 콤보로 복귀) — TO-BE는 이 스왑 자체가 없음(콤보는 조회조건과 동일한 `Incoterms` SQL_ID 고정, 단 §G18 대소문자 결함 별도). **토글 어포던스 미이식 결정의 예외 대상 아님**(D00-3-034와 동일 이유) | 미구현 |
| D00-3-039 | §3 LockColumn / (0..max,true) | 조회 직후 그리드 전체 컬럼을 잠그는 로직(EditButton 클릭 전 초기상태) — D00-3-027과 동일 근거(토글 어포던스 미이식 결정, 잠금 해제가 아니라 최초 잠금 쪽 대응) | 제외 |
| D00-3-043 | §3 SetBGColor / (DIVISION_ID..INCOTERMS,InvalidColor) | **신규 발견**: 저장 실패(SP 응답 errCode 99010/99020/99030/99040)시 중복행의 DIVISION_ID~INCOTERMS 구간을 배경색으로 강조하는 로직(cs:900-916). TO-BE `Bod.tsx` `mutate()`(L78-103)는 서버 에러 메시지를 alert으로만 표시하고 셀 하이라이트는 전혀 없다(grep `99010`,`InvalidColor` 0건) — `04_react-gap.md §2 표 #23 "저장 실패 errCode별 강조색 4패턴 — 통과"는 오기재였다(이전 회차가 근거 없이 통과 처리)** -- 고위험, 오기재 정정 — 저장 실패 원인 컬럼이 시각적으로 구분되지 않아 사용자가 어느 행이 문제인지 알기 어려움 | 미구현 |
| D00-3-044 | §3 SetBGColor / (TRANSPORT_MODE..TO_YYYYMMDD,InvalidColor) | D00-3-043과 동일 결함(errCode 99030/99040 분기) -- 고위험, D00-3-043과 동일 사유 | 미구현 |
| D00-3-045 | §3 SetBGColor / (TRANSPORT_MODE,InvalidColor) | D00-3-043과 동일 결함(errCode 99010 분기) -- 고위험, D00-3-043과 동일 사유 | 미구현 |
| D00-3-046 | §3 SetBGColor / (PRIORITY,InvalidColor) | D00-3-043과 동일 결함(errCode 99020 분기) -- 고위험, D00-3-043과 동일 사유 | 미구현 |
| D00-3-065 | §3 SetActiveCell / (e.Row,e.Column) | Route 팝업 선택 후 커서를 해당 셀로 이동시키는 UX 동작 — `Bod.tsx handleRouteSelect`에 대응 로직 없음(`GridUtils.refreshRow`만 호출) -- 저위험, UX 커서이동 | 미구현 |
| D00-3-066 | §3 ShowCell / (0,0,e.Row,e.Column,Center,Right) | 위와 동일(선택 셀을 화면 중앙으로 스크롤) -- 저위험, D00-3-065와 동일 사유 | 미구현 |
| D00-3-067 | §3 SetCellTypeCombo / (e.Row,TO_SITE_CODE,dtToSiteOfSpd) | FROM_SITE_CODE 변경 시(`sFromSite=='E'`) TO_SITE 콤보를 `ToSiteBOD1_SCP_ALL` 계열로 교체 — TO-BE `BodGrid.tsx`는 TO_SITE_CODE 셀 콤보를 항상 고정(`ToSiteByDivision`)으로만 쓰고 FROM_SITE_CODE 값에 따른 3분기 전환이 없다(G16과 동일 축, `resolveToSiteBucket` 호출부 0건) -- 중위험, G16 | 미구현 |
| D00-3-068 | §3 SetCellTypeCombo / (e.Row,TO_SITE_CODE,dtToSiteOfSpd) | `sFromSite=='A' && OSP_YN=='Y'` 분기(`ToSiteByDivisionPlant1_SCP_ALL`) — 위와 동일 결함(G16) -- 중위험, G16 | 미구현 |
| D00-3-069 | §3 SetCellTypeCombo / (e.Row,TO_SITE_CODE,dtToSiteOfSpd) | 그 외 분기(`ToSiteByDivision1_SCP_ALL`) — 위와 동일 결함(G16) -- 중위험, G16 | 미구현 |
| D00-3-074 | §3 SetCellTypeCombo / (iRow,TO_SITE_CODE,dtToSiteOfSpd) | `SpdMain_ClipboardPasted`(붙여넣기)의 동일 3분기 — D00-3-067과 동일 결함(G16) -- 중위험, G16 | 미구현 |
| D00-3-075 | §3 SetCellTypeCombo / (iRow,TO_SITE_CODE,dtToSiteOfSpd) | 위와 동일(G16) -- 중위험, G16 | 미구현 |
| D00-3-076 | §3 SetCellTypeCombo / (iRow,TO_SITE_CODE,dtToSiteOfSpd) | 위와 동일(G16) -- 중위험, G16 | 미구현 |
| D00-3-083 | §3 GetViewRowFromModelRow / (nRow) | Wijmo는 FarPoint와 달리 모델행/뷰행 분리 API가 노출되지 않아 이 변환 자체가 불필요(프레임워크 차이) -- Wijmo 구조상 불필요 | 해당없음 |

