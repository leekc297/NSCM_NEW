# SSP0023 — To-Be Fact Pack 요약

- page_key: `shipping/shipment-plan-electrode` · feature: shipping · As-is Fact Pack 있음
- 파일 15 · 엔드포인트 호출 13 (미해결 0, 주석 속 3) · 이벤트 60 · 컴포넌트 사용 84 · 하드코딩 컬럼 3 · 메시지 44
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 3건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/shipping/src/pages/shipment-plan-electrode/components/RequestorModal.tsx | component | 120 |
| features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeDetailBar.tsx | component | 247 |
| features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeDetailGrid.tsx | component | 256 |
| features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeForm.module.scss | component | 29 |
| features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeForm.tsx | component | 414 |
| features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeMainGrid.tsx | component | 373 |
| features/shipping/src/pages/shipment-plan-electrode/index.ts | index | 2 |
| features/shipping/src/pages/shipment-plan-electrode/shipment-plan-electrode.constants.ts | constants | 295 |
| features/shipping/src/pages/shipment-plan-electrode/shipment-plan-electrode.types.ts | types | 77 |
| features/shipping/src/pages/shipment-plan-electrode/ShipmentPlanElectrode.module.scss | style | 70 |
| features/shipping/src/pages/shipment-plan-electrode/ShipmentPlanElectrode.tsx | page | 543 |
| features/shipping/src/pages/shipment-plan-electrode/useShipmentPlanElectrodeStore.ts | store | 489 |
| features/shipping/src/pages/shipment-plan-electrode/utils/shipment-plan-electrode.editLock.ts | util | 116 |
| features/shipping/src/pages/shipment-plan-electrode/utils/shipment-plan-electrode.save.ts | util | 130 |
| features/shipping/src/pages/shipment-plan-electrode/__asis-mapping__.md | mapping | 301 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 2 | Y | RequestorModal.tsx:42 ShipmentPlanElectrodeForm.tsx:66 |
| (useTabLookupQueries) | hook | 2 | Y | ShipmentPlanElectrodeDetailBar.tsx:57 ShipmentPlanElectrode.tsx:110 |
| SSP0023/main//call-proc | hook | 1 | Y | ShipmentPlanElectrode.tsx:124 |
| SSP0023/calendar//call-proc | hook | 1 | Y | ShipmentPlanElectrode.tsx:131 |
| SSP0023/planDetail//call-proc | hook | 1 | Y | ShipmentPlanElectrode.tsx:138 |
| SSP0023/stockDetail//call-proc | hook | 1 | Y | ShipmentPlanElectrode.tsx:145 |
| SSP0023/shipmentResult//call-proc | hook | 1 | Y | ShipmentPlanElectrode.tsx:152 |
| /SSP0023/main/SAVE/call-proc | http | 1 | Y | ShipmentPlanElectrode.tsx:279 |
| /admin/menu/SSP0023/column | http | 1 | Y | useShipmentPlanElectrodeStore.ts:414 |
| /admin/menu/SSP0023/measure | http | 1 | Y | useShipmentPlanElectrodeStore.ts:438 |
| /admin/menu/SSP0023/search-conditions | http | 1 | Y | useShipmentPlanElectrodeStore.ts:466 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| InputField | onChange | <arrow> setKeyword | jsx | features/shipping/src/pages/shipment-plan-electrode/components/RequestorModal.tsx | 92 |
| InputField | onKeyDown | <arrow> handleSearch | jsx | features/shipping/src/pages/shipment-plan-electrode/components/RequestorModal.tsx | 93 |
| Button | onClick | handleSearch | jsx | features/shipping/src/pages/shipment-plan-electrode/components/RequestorModal.tsx | 95 |
| Button | onClick | handleSelect | jsx | features/shipping/src/pages/shipment-plan-electrode/components/RequestorModal.tsx | 108 |
| Button | onClick | modalClose | jsx | features/shipping/src/pages/shipment-plan-electrode/components/RequestorModal.tsx | 111 |
| PeriodField | onChange | onShipChange | jsx | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeDetailBar.tsx | 82 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeDetailBar.tsx | 98 |
| InputField | onKeyDown | <arrow> onDetailSearch | jsx | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeDetailBar.tsx | 99 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeDetailBar.tsx | 130 |
| InputField | onKeyDown | <arrow> onDetailSearch | jsx | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeDetailBar.tsx | 131 |
| FunctionSearchIcon | onClick | onItemSearch2 | jsx | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeDetailBar.tsx | 125 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeDetailBar.tsx | 149 |
| InputField | onKeyDown | <arrow> onDetailSearch | jsx | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeDetailBar.tsx | 150 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeDetailBar.tsx | 181 |
| InputField | onKeyDown | <arrow> onDetailSearch | jsx | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeDetailBar.tsx | 182 |
| FunctionSearchIcon | onClick | onRequestorSearch | jsx | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeDetailBar.tsx | 176 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeDetailBar.tsx | 200 |
| InputField | onKeyDown | <arrow> onDetailSearch | jsx | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeDetailBar.tsx | 201 |
| CustomDropdown | onChange | <arrow> set,str(picked).split(',').filter,str(picked).split,str | jsx | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeDetailBar.tsx | 225 |
| Button | onClick | onDetailSearch | jsx | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeDetailBar.tsx | 240 |
| g | beginningEdit | beginningEditHandler | addHandler | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeDetailGrid.tsx | 101 |
| g | pastingCell | pastingCellHandler | addHandler | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeDetailGrid.tsx | 112 |
| g | formatItem | formatItemHandler | addHandler | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeDetailGrid.tsx | 127 |
| g | cellEditEnded | cellEditEndedHandler | addHandler | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeDetailGrid.tsx | 188 |
| g | pastedCell | cellEditEndedHandler | addHandler | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeDetailGrid.tsx | 189 |
| DataGrid | gotFocus | <arrow> setActiveGrid | jsx | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeDetailGrid.tsx | 249 |
| SearchArea | onSearch | onSearch | jsx | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeForm.tsx | 133 |
| CustomDropdown | onChange | <arrow> str,confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,setDivision | jsx | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeForm.tsx | 150 |
| CustomDropdown | onChange | <arrow> setCompany,str | jsx | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeForm.tsx | 172 |
| CustomDropdown | onChange | <arrow> set,str(picked).split(',').filter,str(picked).split,str | jsx | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeForm.tsx | 194 |
| CustomDropdown | onChange | <arrow> set,str | jsx | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeForm.tsx | 212 |
| CustomDropdown | onChange | <arrow> handlePlanDateChange,str | jsx | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeForm.tsx | 229 |
| PeriodField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeForm.tsx | 243 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeForm.tsx | 256 |
| InputField | onKeyDown | <arrow> onSearch | jsx | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeForm.tsx | 257 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeForm.tsx | 286 |
| InputField | onKeyDown | <arrow> onSearch | jsx | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeForm.tsx | 287 |
| FunctionSearchIcon | onClick | onItemSearch | jsx | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeForm.tsx | 281 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeForm.tsx | 303 |
| InputField | onKeyDown | <arrow> onSearch | jsx | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeForm.tsx | 304 |
| input | onChange | <arrow> setBohRadio | jsx | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeForm.tsx | 327 |
| Checkbox | onChange | <arrow> setChkSum | jsx | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeForm.tsx | 356 |
| Checkbox | onChange | <arrow> setChkPastPeriod | jsx | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeForm.tsx | 361 |
| Checkbox | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeForm.tsx | 390 |
| Checkbox | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeForm.tsx | 395 |
| Checkbox | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeForm.tsx | 400 |
| Checkbox | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeForm.tsx | 405 |
| g | updatedLayout | applyMerge | addHandler | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeMainGrid.tsx | 239 |
| g | beginningEdit | beginningEditHandler | addHandler | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeMainGrid.tsx | 255 |
| g | formatItem | formatItemHandler | addHandler | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeMainGrid.tsx | 307 |
| g | pastingCell | pastingCellHandler | addHandler | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeMainGrid.tsx | 325 |
| g | cellEditEnded | onEdited | addHandler | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeMainGrid.tsx | 330 |
| g | pastedCell | onEdited | addHandler | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeMainGrid.tsx | 331 |
| g.hostElement | click | clickHandler | addEventListener | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeMainGrid.tsx | 339 |
| ShipmentPlanElectrodeForm | onSearch | handleSearch | jsx | features/shipping/src/pages/shipment-plan-electrode/ShipmentPlanElectrode.tsx | 419 |
| ShipmentPlanElectrodeForm | onItemSearch | <arrow> setOpenItem | jsx | features/shipping/src/pages/shipment-plan-electrode/ShipmentPlanElectrode.tsx | 419 |
| ShipmentPlanElectrodeDetailBar | onDetailSearch | handleDetailSearch | jsx | features/shipping/src/pages/shipment-plan-electrode/ShipmentPlanElectrode.tsx | 457 |
| ShipmentPlanElectrodeDetailBar | onItemSearch2 | <arrow> setOpenDetailItem | jsx | features/shipping/src/pages/shipment-plan-electrode/ShipmentPlanElectrode.tsx | 458 |
| ShipmentPlanElectrodeDetailBar | onRequestorSearch | <arrow> setOpenRequestor | jsx | features/shipping/src/pages/shipment-plan-electrode/ShipmentPlanElectrode.tsx | 459 |
| ColumnSettingModal | onSave | <arrow> setOpenMeasure,refetchMain | jsx | features/shipping/src/pages/shipment-plan-electrode/ShipmentPlanElectrode.tsx | 535 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| FormItem | 15 |
| Grid | 11 |
| InputField | 9 |
| Stack | 7 |
| Button | 7 |
| CustomDropdown | 6 |
| Checkbox | 6 |
| DataGrid | 3 |
| FunctionSearchIcon | 3 |
| PeriodField | 2 |
| ItemByDivisionModal | 2 |
| CustomDialog | 1 |
| TabWrapper | 1 |
| TabItem | 1 |
| SearchArea | 1 |
| IcMeasureSelect | 1 |
| MainTitle | 1 |
| ShipmentPlanElectrodeForm | 1 |
| SubTitle | 1 |
| ShipmentPlanElectrodeMainGrid | 1 |
| ShipmentPlanElectrodeDetailBar | 1 |
| ShipmentPlanElectrodeDetailGrid | 1 |
| RequestorModal | 1 |
| ColumnSettingModal | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| POPUP_COLUMNS | CODE | User ID | 140 |  |  |  | meta-shape | features/shipping/src/pages/shipment-plan-electrode/components/RequestorModal.tsx | 28 |
| POPUP_COLUMNS | NAME | User Name | 200 |  |  |  | meta-shape | features/shipping/src/pages/shipment-plan-electrode/components/RequestorModal.tsx | 29 |
| dynamicColumns | m.binding | m.bucket === 'D' ? m.leaf \|\| 'SUM' : 'SUM' | 80 | isVisible(m) |  |  | object | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeMainGrid.tsx | 157 |

## 7. 메시지 코드
| code | count |
|---|---|
| MSG01401 | 1 |
| MSG00429 | 1 |
| MSG01291 | 1 |
| MSG01289 | 1 |
| MSG00013 | 1 |
| MSG01244 | 1 |
| MSG00284 | 1 |
| MSG01185 | 1 |
| MSG00225 | 1 |
| MSG01201 | 1 |
| MSG00133 | 1 |
| MSG00703 | 1 |
| MSG00003 | 2 |
| MSG00002 | 1 |
| LBL00001 | 1 |
| LBL00047 | 1 |
| LBL00022 | 1 |
| LBL00039 | 1 |
| LBL00710 | 1 |
| LBL00021 | 1 |
| LBL00669 | 1 |
| LBL00767 | 1 |
| LBL00013 | 1 |
| LBL01093 | 1 |
| LBL01101 | 1 |
| LBL01124 | 1 |
| LBL01070 | 1 |
| LBL01109 | 1 |
| LBL01108 | 1 |
| LBL00112 | 1 |
| LBL00664 | 1 |
| LBL00783 | 1 |
| LBL01028 | 1 |
| LBL00627 | 1 |
| LBL00716 | 1 |
| LBL00310 | 1 |
| LBL01115 | 1 |
| LBL00687 | 1 |
| LBL01126 | 1 |
| LBL01059 | 1 |
| LBL01099 | 1 |
| LBL01090 | 1 |
| LBL01127 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SSP0060(5), SSP0023(4), SCP0048(3), SCP0001(1), SCP0025(1)
- SP/PKG: PKG_SSP0023(6), P_SHIP_PLAN_SIMU_ETD(5), P_SSP0023_GET_SHIPMENT_PLAN(2), P_MODEL_ID(2), P_ITEM_ID(2), P_NICK_NAME(2), P_SSP0023_GET_SHEET_CALENDAR_3SPAN(1), P_MY_MODEL_CHK(1), P_PART_LEADER_CHK(1), P_TEAM_LEADER_CHK(1), P_DELEGATEE_CHK(1), P_LOT_ID(1), P_REQUESTOR(1), P_DBL_FLAG(1), P_NON_CHK(1), P_SSP0023_SAVE_SHIPMENT_PLAN_SIMU(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | - 툴바: Find/Insert/Save = 실동작, Delete = NO-OP `() => undefined`(03 §3.5 — 노출 유지·행삭제 불가), Edit = SwitchLock 미이식(edit default ON). | features/shipping/src/pages/shipment-plan-electrode/shipment-plan-electrode.constants.ts | 12 |
| code | 툴바: Find/Save/Insert = 실동작, Delete = NO-OP `() => undefined`(03 §3.5 — 노출 유지, false 숨김 금지), | features/shipping/src/pages/shipment-plan-electrode/ShipmentPlanElectrode.tsx | 45 |
| endpoint | SP 배포 시 useProcMutation<MENU_ID, SHEETS.PLAN_DETAIL>({ onSuccess: clearChanges+toast+refetch }) 을 | features/shipping/src/pages/shipment-plan-electrode/ShipmentPlanElectrode.tsx | 173 |
| endpoint | ── mount — keep-alive 잔여 filters 무효화 + 컬럼/measure 메타 1회 fetch (np §5-7) ── | features/shipping/src/pages/shipment-plan-electrode/ShipmentPlanElectrode.tsx | 184 |
| endpoint | admin SCM_MST_SHEET_COLUMNS fetch (mount + Search — ui-dynamic-property-management §2.3). | features/shipping/src/pages/shipment-plan-electrode/useShipmentPlanElectrodeStore.ts | 408 |

## 10. __asis-mapping__.md 상태
- 구현: 51
- 제외: 34
- 해당없음: 32
| design_id | summary | reason | status |
|---|---|---|---|
| D00-1-002 | §1 Requestor / LayoutControlItem | Requestor 라벨 아이템 — UserInfoPopup(txtRequestor) 미이식으로 필드 미노출(04 excluded, 2026-09-27) | 제외 |
| D00-1-003 | §1 btnExcelUpload / UsrButton | Excel Upload UI 미이식 — AS-IS 엑셀 업로드 affordance(R15b)는 iter-1 범위 외(04 excluded 계열, upload SP 배선 후속). hotkeyConfig.upload=false, SHEETS.EXCEL 조회 배선만 | 제외 |
| D00-1-004 | §1 btnItemId / UsrButton | SCM0002_ItembyDivisionPopup 미이식 — Item 검색 팝업/버튼 미배치(04 excluded, §6) | 제외 |
| D00-1-005 | §1 btnItemId2 / UsrButton | SCM0002_ItembyDivisionPopup 미이식 — Item 검색 팝업/버튼 미배치(04 excluded, §6) | 제외 |
| D00-1-007 | §1 btnRequestor / UsrButton | UserInfoPopup(btnRequestor) 공통 사용자검색 팝업 미이식(04 excluded, §6) | 제외 |
| D00-1-012 | §1 chkDelegateeModel / UsrCheckBox | 검색 SP 파라미터 체크박스 — iter-1 UI 미배치(범위 외, 04 §6 My Model auto-check(R09) 그룹 보류) | 제외 |
| D00-1-013 | §1 chkMyModel / UsrCheckBox | 검색 SP 파라미터 체크박스 — iter-1 UI 미배치(범위 외, 04 §6 R09 auto-check 보류) | 제외 |
| D00-1-014 | §1 chkPartLeader / UsrCheckBox | 검색 SP 파라미터 체크박스 — iter-1 UI 미배치(범위 외, 02 §1 검색 파라미터 그룹) | 제외 |
| D00-1-017 | §1 chkTeamLeader / UsrCheckBox | 검색 SP 파라미터 체크박스 — iter-1 UI 미배치(범위 외, 02 §1 검색 파라미터 그룹) | 제외 |
| D00-1-022 | §1 components / Container | Designer IContainer(WinForms 컴포넌트 컨테이너) — React 대응 없음 | 해당없음 |
| D00-1-026 | §1 emptySpaceItem1 / EmptySpaceItem | Designer 여백 스페이서 — React 대응 없음 | 해당없음 |
| D00-1-027 | §1 emptySpaceItem3 / EmptySpaceItem | Designer 여백 스페이서 — React 대응 없음 | 해당없음 |
| D00-1-028 | §1 emptySpaceItem4 / EmptySpaceItem | Designer 여백 스페이서 — React 대응 없음 | 해당없음 |
| D00-1-029 | §1 emptySpaceItem5 / EmptySpaceItem | Designer 여백 스페이서 — React 대응 없음 | 해당없음 |
| D00-1-030 | §1 formDown / UsrButton | Excel Download 폼 버튼 UI 미이식 — AS-IS 엑셀양식 다운로드(R15a·SP22 GET_..._EXCEL 은 배포됨)이나 iter-1 범위 외(04 excluded 계열, 다운로드 UI 후속) | 제외 |
| D00-1-031 | §1 imageList1 / ImageList | Designer ImageList(WinForms 아이콘 리소스) — React 대응 없음 | 해당없음 |
| D00-1-032 | §1 layoutControlGroup2 / LayoutControlGroup | Designer 레이아웃 그룹 컨테이너 — React 는 SearchArea/Grid 레이아웃으로 흡수 | 해당없음 |
| D00-1-033 | §1 layoutControlGroup3 / LayoutControlGroup | Designer 레이아웃 그룹 컨테이너 — React 는 DetailBar 레이아웃으로 흡수 | 해당없음 |
| D00-1-034 | §1 layoutControlItem1 / LayoutControlItem | Designer 레이아웃 아이템 래퍼 — 실 컨트롤은 별도 채번, 래퍼 자체 대응 없음 | 해당없음 |
| D00-1-035 | §1 layoutControlItem10 / LayoutControlItem | Designer 레이아웃 아이템 래퍼 — 실 컨트롤은 별도 채번, 래퍼 자체 대응 없음 | 해당없음 |
| D00-1-036 | §1 layoutControlItem12 / LayoutControlItem | Designer 레이아웃 아이템 래퍼 — 실 컨트롤은 별도 채번, 래퍼 자체 대응 없음 | 해당없음 |
| D00-1-037 | §1 layoutControlItem15 / LayoutControlItem | Designer 레이아웃 아이템 래퍼 — 실 컨트롤은 별도 채번, 래퍼 자체 대응 없음 | 해당없음 |
| D00-1-038 | §1 layoutControlItem16 / LayoutControlItem | Designer 레이아웃 아이템 래퍼 — 실 컨트롤은 별도 채번, 래퍼 자체 대응 없음 | 해당없음 |
| D00-1-039 | §1 layoutControlItem18 / LayoutControlItem | Designer 레이아웃 아이템 래퍼 — 실 컨트롤은 별도 채번, 래퍼 자체 대응 없음 | 해당없음 |
| D00-1-040 | §1 layoutControlItem19 / LayoutControlItem | Designer 레이아웃 아이템 래퍼 — 실 컨트롤은 별도 채번, 래퍼 자체 대응 없음 | 해당없음 |
| D00-1-041 | §1 layoutControlItem2 / LayoutControlItem | Designer 레이아웃 아이템 래퍼 — 실 컨트롤은 별도 채번, 래퍼 자체 대응 없음 | 해당없음 |
| D00-1-042 | §1 layoutControlItem21 / LayoutControlItem | Designer 레이아웃 아이템 래퍼 — 실 컨트롤은 별도 채번, 래퍼 자체 대응 없음 | 해당없음 |
| D00-1-043 | §1 layoutControlItem22 / LayoutControlItem | Designer 레이아웃 아이템 래퍼 — 실 컨트롤은 별도 채번, 래퍼 자체 대응 없음 | 해당없음 |
| D00-1-044 | §1 layoutControlItem23 / LayoutControlItem | Designer 레이아웃 아이템 래퍼 — 실 컨트롤은 별도 채번, 래퍼 자체 대응 없음 | 해당없음 |
| D00-1-045 | §1 layoutControlItem3 / LayoutControlItem | Designer 레이아웃 아이템 래퍼 — 실 컨트롤은 별도 채번, 래퍼 자체 대응 없음 | 해당없음 |
| D00-1-046 | §1 layoutControlItem4 / LayoutControlItem | Designer 레이아웃 아이템 래퍼 — 실 컨트롤은 별도 채번, 래퍼 자체 대응 없음 | 해당없음 |
| D00-1-047 | §1 layoutControlItem5 / LayoutControlItem | Designer 레이아웃 아이템 래퍼 — 실 컨트롤은 별도 채번, 래퍼 자체 대응 없음 | 해당없음 |
| D00-1-048 | §1 layoutControlItem6 / LayoutControlItem | Designer 레이아웃 아이템 래퍼 — 실 컨트롤은 별도 채번, 래퍼 자체 대응 없음 | 해당없음 |
| D00-1-049 | §1 layoutControlItem7 / LayoutControlItem | Designer 레이아웃 아이템 래퍼 — 실 컨트롤은 별도 채번, 래퍼 자체 대응 없음 | 해당없음 |
| D00-1-050 | §1 layoutControlItem8 / LayoutControlItem | Designer 레이아웃 아이템 래퍼 — 실 컨트롤은 별도 채번, 래퍼 자체 대응 없음 | 해당없음 |
| D00-1-051 | §1 layoutLotId / LayoutControlItem | Lot ID 상세 텍스트필터 라벨 — 초기 Never(숨김)·spdDetail 활성시트 조건부 상세필터(02 §275), iter-1 UI 미배치(범위 외) | 제외 |
| D00-1-052 | §1 layoutMaterialBtn / LayoutControlItem | Item(Material) 팝업 버튼 래퍼 — ItembyDivisionPopup 미이식(04 excluded, §6) | 제외 |
| D00-1-053 | §1 layoutMaterialDetail / LayoutControlItem | Material 상세 텍스트필터 라벨 — spdDetail 활성시트 조건부 상세필터(02 §377), iter-1 UI 미배치(범위 외) | 제외 |
| D00-1-054 | §1 layoutModelDetail / LayoutControlItem | Model 상세 텍스트필터 라벨 — spdDetail 활성시트 조건부 상세필터(02 §377), iter-1 UI 미배치(범위 외) | 제외 |
| D00-1-055 | §1 layoutNickNameDetail / LayoutControlItem | Nick Name 상세 텍스트필터 라벨 — spdDetail 활성시트 조건부 상세필터(02 §377), iter-1 UI 미배치(범위 외) | 제외 |
| D00-1-056 | §1 layoutRequestorBtn / LayoutControlItem | Requestor 팝업 버튼 래퍼 — UserInfoPopup 미이식(04 excluded, §6) | 제외 |
| D00-1-062 | §1 lblCombo1 / LayoutControlItem | Designer 정적 라벨(콤보 헤더) — 실 콤보 FormItem label 로 흡수, 별도 대응 없음 | 해당없음 |
| D00-1-063 | §1 lblItemId / LayoutControlItem | Item ID 라벨 — Item 텍스트 필터/팝업 미노출(04 excluded, §6) | 제외 |
| D00-1-072 | §1 spdSub / FpSpread | siSub 엑셀 다운로드 버퍼 그리드 — AS-IS 엑셀 폼(R15a/b) UI 미이식, iter-1 범위 외(SHEETS.EXCEL 조회 배선만) | 제외 |
| D00-1-073 | §1 spdSub_Sheet1 / SheetView | siSub 엑셀 버퍼 시트 — AS-IS 엑셀 폼 UI 미이식, iter-1 범위 외(SHEETS.EXCEL 조회 배선만) | 제외 |
| D00-1-075 | §1 textNickName / UsrMultiLineEditor | Nick Name 상세 텍스트필터 에디터 — spdDetail 조건부 상세필터(02 §72), iter-1 UI 미배치(범위 외) | 제외 |
| D00-1-076 | §1 txtItem2 / LayoutControlItem | Item 텍스트 필터 라벨 — Item 검색필터/팝업 미노출(04 excluded, §6) | 제외 |
| D00-1-077 | §1 txtItem3 / LayoutControlItem | Item 텍스트 필터 라벨 — Item 검색필터/팝업 미노출(04 excluded, §6) | 제외 |
| D00-1-078 | §1 txtItemId / UsrMultiLineEditor | Item ID 텍스트 검색필터 — Item 필터/팝업 미노출(04 excluded, §6) | 제외 |
| D00-1-079 | §1 txtItemId2 / UsrMultiLineEditor | Item ID 텍스트 검색필터 — Item 필터/팝업 미노출(04 excluded, §6) | 제외 |
| D00-1-080 | §1 txtLotID / UsrMultiLineEditor | Lot ID 상세 텍스트필터 에디터 — 초기 Never(숨김)·spdDetail 활성시트 조건부(02 §275), iter-1 UI 미배치(범위 외) | 제외 |
| D00-1-081 | §1 txtModel2 / UsrMultiLineEditor | Model 상세 텍스트필터 에디터 — spdDetail 조건부 상세필터(02 §377), iter-1 UI 미배치(범위 외) | 제외 |
| D00-1-082 | §1 txtModelId / UsrMultiLineEditor | Model 상세 텍스트필터 에디터 — spdDetail 조건부 상세필터(02 §377), iter-1 UI 미배치(범위 외) | 제외 |
| D00-1-083 | §1 txtNickName2 / UsrMultiLineEditor | Nick Name 상세 텍스트필터 에디터 — spdDetail 조건부 상세필터(02 §72), iter-1 UI 미배치(범위 외) | 제외 |
| D00-1-084 | §1 txtRequestor / UsrTextBox | Requestor 텍스트박스 — UserInfoPopup 결과 채움용, 팝업 미이식으로 미노출(04 excluded, §6) | 제외 |
| D00-1-085 | §1 usrButton1 / UsrButton | Designer 미사용/dead 버튼 — 이벤트 인벤토리(§2)에 핸들러 없음, 대응 없음 | 해당없음 |
| D00-1-087 | §1 usrLabel1 / UsrLabel | Designer 정적 라벨 — 실 라벨은 FormItem 으로 흡수, 별도 대응 없음 | 해당없음 |
| D00-1-088 | §1 usrLayoutControl2 / UsrLayoutControl | Designer 레이아웃 컨트롤 컨테이너 — SearchArea/Form 레이아웃으로 흡수 | 해당없음 |
| D00-2-001 | §2 btnExcelUpload / Click | Excel Upload Click 핸들러 — AS-IS 엑셀 업로드 UI(R15b) 미이식, iter-1 범위 외(D00-1-003 짝) | 제외 |
| D00-2-002 | §2 btnItemId / Click | ItembyDivisionPopup 미이식 — Item 팝업 열기 핸들러 없음(04 excluded, §6) | 제외 |
| D00-2-003 | §2 btnItemId2 / Click | ItembyDivisionPopup 미이식 — Item 팝업 열기 핸들러 없음(04 excluded, §6) | 제외 |
| D00-2-005 | §2 btnRequestor / Click | UserInfoPopup 미이식 — Requestor 팝업 열기 핸들러 없음(04 excluded, §6) | 제외 |
| D00-2-014 | §2 dsdm / Changed | AS-IS DataSet DataMember 바인딩 이벤트 — React SSOT(React Query) 로 대체, 대응 이벤트 없음 | 해당없음 |
| D00-2-015 | §2 formDown / Click | Excel Download Click 핸들러 — AS-IS 엑셀양식 다운로드 UI(R15a) 미이식, iter-1 범위 외(D00-1-030 짝) | 제외 |
| D00-2-020 | §2 spdDetail / CellDoubleClick | Detail 그리드 셀 더블클릭 드릴다운 — AS-IS 는 Main→Detail 방향(setDetailFilter dblFlag='Y', store 55-61); Detail 셀 자체 더블클릭 파생 없음 | 해당없음 |
| D00-2-028 | §2 spdMain / TopChange | AS-IS FpSpread 스크롤 TopChange(가상 스크롤 상단행 동기) — Wijmo DataGrid 가상화 내장, 화면 재현 불요 | 해당없음 |

