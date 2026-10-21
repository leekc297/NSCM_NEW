# SCP0019 — To-Be Fact Pack 요약

- page_key: `supply/working-time` · feature: supply · As-is Fact Pack 없음(화면ID 미대응)
- 파일 9 · 엔드포인트 호출 6 (미해결 0, 주석 속 1) · 이벤트 14 · 컴포넌트 사용 21 · 하드코딩 컬럼 3 · 메시지 18
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 3건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/working-time/components/WorkingTimeForm.tsx | component | 230 |
| features/supply/src/pages/working-time/components/WorkingTimeGrid.tsx | component | 325 |
| features/supply/src/pages/working-time/index.ts | index | 2 |
| features/supply/src/pages/working-time/useWorkingTimeStore.ts | store | 193 |
| features/supply/src/pages/working-time/working-time.constants.ts | constants | 130 |
| features/supply/src/pages/working-time/working-time.dynamic-columns.ts | other | 39 |
| features/supply/src/pages/working-time/working-time.types.ts | types | 84 |
| features/supply/src/pages/working-time/WorkingTime.tsx | page | 329 |
| features/supply/src/pages/working-time/__asis-mapping__.md | mapping | 149 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 1 | Y | WorkingTimeForm.tsx:49 |
| (useTabLookupQueries) | hook | 1 | Y | WorkingTimeForm.tsx:52 |
| /admin/menu/SCP0019/column | http | 1 | Y | useWorkingTimeStore.ts:144 |
| /admin/menu/SCP0019/search-conditions | http | 1 | Y | useWorkingTimeStore.ts:169 |
| SCP0019/Working Time//call-proc | hook | 1 | Y | WorkingTime.tsx:64 |
| /SCP0019/Working Time/SAVE/call-proc | http | 1 | Y | WorkingTime.tsx:197 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| CustomDropdown | onChange | <arrow> onPick,String(picked??'').split(',').filter,String(picked??'').split,String,v.toUpperCase | jsx | features/supply/src/pages/working-time/components/WorkingTimeForm.tsx | 108 |
| SearchArea | onSearch | onSubmit | jsx | features/supply/src/pages/working-time/components/WorkingTimeForm.tsx | 127 |
| CustomDropdown | onChange | <arrow> String,confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,setDivision,onDivisionChange | jsx | features/supply/src/pages/working-time/components/WorkingTimeForm.tsx | 141 |
| CustomDropdown | onChange | <arrow> setSearchParams,String | jsx | features/supply/src/pages/working-time/components/WorkingTimeForm.tsx | 177 |
| PeriodField | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/working-time/components/WorkingTimeForm.tsx | 189 |
| InputField | onChange | <arrow> e.target.value.replace,setSearchParams | jsx | features/supply/src/pages/working-time/components/WorkingTimeForm.tsx | 205 |
| Button | onClick | onInput | jsx | features/supply/src/pages/working-time/components/WorkingTimeForm.tsx | 220 |
| g | formatItem | formatHandler | addHandler | features/supply/src/pages/working-time/components/WorkingTimeGrid.tsx | 206 |
| g | beginningEdit | beginningEditHandler | addHandler | features/supply/src/pages/working-time/components/WorkingTimeGrid.tsx | 221 |
| g | updatedLayout | onLayout | addHandler | features/supply/src/pages/working-time/components/WorkingTimeGrid.tsx | 271 |
| f | filterApplied | onFilterApplied | addHandler | features/supply/src/pages/working-time/components/WorkingTimeGrid.tsx | 301 |
| WorkingTimeForm | onSubmit | handleSearch | jsx | features/supply/src/pages/working-time/WorkingTime.tsx | 305 |
| WorkingTimeForm | onDivisionChange | resetGrid | jsx | features/supply/src/pages/working-time/WorkingTime.tsx | 306 |
| WorkingTimeForm | onInput | handleInputValue | jsx | features/supply/src/pages/working-time/WorkingTime.tsx | 307 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 5 |
| FormItem | 4 |
| CustomDropdown | 3 |
| SearchArea | 1 |
| PeriodField | 1 |
| InputField | 1 |
| Button | 1 |
| DataGrid | 1 |
| MainTitle | 1 |
| WorkingTimeForm | 1 |
| SubTitle | 1 |
| WorkingTimeGrid | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| mergedColumns | col.colNm | col.colLblNm \|\| col.colNm | col.colWth ?? 100 | col.visible !== false |  |  | object | features/supply/src/pages/working-time/components/WorkingTimeGrid.tsx | 74 |
| mainStaticColumns | c.binding | c.header | c.width | true |  |  | meta-map | features/supply/src/pages/working-time/components/WorkingTimeGrid.tsx | 100 |
| leaf | dc.binding | dc.dayLabel \|\| dc.binding.slice(2) | 100 | true |  |  | object | features/supply/src/pages/working-time/components/WorkingTimeGrid.tsx | 126 |

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00112 | 1 |
| LBL00001 | 1 |
| LBL00005 | 1 |
| LBL00009 | 1 |
| LBL00010 | 1 |
| LBL01067 | 1 |
| LBL00013 | 1 |
| LBL01084 | 1 |
| LBL00872 | 1 |
| MSG00135 | 1 |
| MSG00004 | 1 |
| MSG00134 | 1 |
| MSG00050 | 1 |
| MSG00203 | 1 |
| MSG00137 | 1 |
| MSG00002 | 1 |
| MSG00618 | 1 |
| MSG00152 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: DMF0014(9), SCP0019(4), DMF0021(2), DMF0044(1), SCM0008(1), SCP0025(1), DMF0048(1)
- SP/PKG: PKG_SCP0019(8), P_SCP0019_GET_WORKING_TIME(4), P_SCP0019_SAVE_WORKING_TIME_ROW(3), P_USER_ID(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| endpoint | ui-dynamic-property-management — Column 동적 fetch (SCM_MST_SHEET_COLUMNS 14행, admin 즉시 반영). | features/supply/src/pages/working-time/useWorkingTimeStore.ts | 141 |

## 10. __asis-mapping__.md 상태
- 구현: 48
- 제외: 36
| design_id | summary | reason | status |
|---|---|---|---|
| D00-1-002 | §1 cboBucketType / UsrCombo | AS-IS `Visibility=Never` 정적 hidden(01_layout §3 lblBucket/cboBucketType, Designer 695) — 버킷 콤보 화면 비노출. TO-BE 는 hidden 실태 그대로 이식(렌더 안 함, Form:34 주석) — UI 신호 아님 | 제외 |
| D00-1-005 | §1 chkSum / UsrCheckBox | AS-IS `Visible=false`+`Visibility=Never` 정적 hidden(01_layout §3, Designer 434/668) — SUM 토글 컨트롤 화면 비노출, 실 SUM 표시는 기본값 고정. TO-BE hidden 그대로 이식(Form:34 미렌더) — UI 신호 아님 | 제외 |
| D00-1-010 | §1 components / Container | WinForms 디자이너 IContainer(비가시 컴포넌트 컨테이너) — UI 신호 아님 | 제외 |
| D00-1-012 | §1 emptySpaceItem1 / EmptySpaceItem | DevExpress 레이아웃 여백 스페이서 — UI 신호 아님 | 제외 |
| D00-1-013 | §1 emptySpaceItem10 / EmptySpaceItem | 레이아웃 여백 스페이서 — UI 신호 아님 | 제외 |
| D00-1-014 | §1 emptySpaceItem2 / EmptySpaceItem | 레이아웃 여백 스페이서 — UI 신호 아님 | 제외 |
| D00-1-015 | §1 emptySpaceItem3 / EmptySpaceItem | 레이아웃 여백 스페이서 — UI 신호 아님 | 제외 |
| D00-1-016 | §1 emptySpaceItem4 / EmptySpaceItem | 레이아웃 여백 스페이서 — UI 신호 아님 | 제외 |
| D00-1-017 | §1 emptySpaceItem5 / EmptySpaceItem | 레이아웃 여백 스페이서 — UI 신호 아님 | 제외 |
| D00-1-018 | §1 emptySpaceItem6 / EmptySpaceItem | 레이아웃 여백 스페이서 — UI 신호 아님 | 제외 |
| D00-1-019 | §1 emptySpaceItem9 / EmptySpaceItem | 레이아웃 여백 스페이서 — UI 신호 아님 | 제외 |
| D00-1-020 | §1 layoutControlGroup2 / LayoutControlGroup | DevExpress 레이아웃 그룹 컨테이너 — 표현 전용, TO-BE SearchArea/Grid 로 흡수(비즈니스 신호 아님) | 제외 |
| D00-1-021 | §1 layoutControlItem1 / LayoutControlItem | DevExpress 레이아웃 아이템(래퍼) — 실제 컨트롤은 §1 개별 행에 대사됨, 래퍼는 표현 전용 | 제외 |
| D00-1-022 | §1 layoutControlItem10 / LayoutControlItem | DevExpress 레이아웃 아이템 래퍼 — 표현 전용 | 제외 |
| D00-1-023 | §1 layoutControlItem11 / LayoutControlItem | DevExpress 레이아웃 아이템 래퍼 — 표현 전용 | 제외 |
| D00-1-024 | §1 layoutControlItem2 / LayoutControlItem | DevExpress 레이아웃 아이템 래퍼 — 표현 전용 | 제외 |
| D00-1-025 | §1 layoutControlItem3 / LayoutControlItem | DevExpress 레이아웃 아이템 래퍼(Building 라벨, 정적 hidden) — 표현 전용 | 제외 |
| D00-1-026 | §1 layoutControlItem4 / LayoutControlItem | DevExpress 레이아웃 아이템 래퍼 — 표현 전용 | 제외 |
| D00-1-027 | §1 layoutControlItem5 / LayoutControlItem | DevExpress 레이아웃 아이템 래퍼 — 표현 전용 | 제외 |
| D00-1-028 | §1 layoutControlItem7 / LayoutControlItem | DevExpress 레이아웃 아이템 래퍼 — 표현 전용 | 제외 |
| D00-1-029 | §1 layoutControlItem8 / LayoutControlItem | DevExpress 레이아웃 아이템 래퍼(chkSum 배치, 정적 hidden) — 표현 전용 | 제외 |
| D00-1-030 | §1 layoutControlItem9 / LayoutControlItem | DevExpress 레이아웃 아이템 래퍼 — 표현 전용 | 제외 |
| D00-1-031 | §1 lblBucket / LayoutControlItem | DevExpress 레이아웃 라벨 래퍼(Bucket, 정적 hidden) — 표현 전용 | 제외 |
| D00-1-035 | §1 usrButton1 / UsrButton | Designer 좌표 0/0·tab0·배선/표시 흔적 없는 미사용 버튼 — AS-IS 도 유령 노드(01_layout §4 #201: TO-BE 미이관, 이식 시 유령 버튼 발생) | 제외 |
| D00-1-037 | §1 usrLayoutControl2 / UsrLayoutControl | DevExpress 레이아웃 컨트롤 루트 컨테이너 = TO-BE SearchArea/Grid 로 대체(레이아웃 프리미티브는 화면 요소 아님) | 제외 |
| D00-2-002 | §2 cboBucketType / SelectedIndexChanged | cboBucketType 정적 hidden(D00-1-002) — 화면 비노출이라 사용자 변경 이벤트 도달 불가. 버킷은 Daily 고정(01_layout §3), TO-BE 미이식 | 제외 |
| D00-2-005 | §2 chkSum / CheckedChanged | chkSum 정적 hidden(D00-1-005) — 화면 비노출이라 토글 이벤트 도달 불가. SUM 표시는 기본값 고정(01_layout §3), TO-BE 미이식 | 제외 |
| D00-2-006 | §2 clbBuilding / SelectedIndexChanged | clbBuilding 정적 hidden(D00-1-006) — 화면 비노출이라 사용자 변경 이벤트 없음. Building 은 Line 필터축 데이터소스로만 존재(Form:60-71 client 필터로 대체) | 제외 |
| D00-2-009 | §2 spdMain / CellDoubleClick | SetDblClickColumnShowHide(컬럼 접기/펼치기) — AS-IS 부가기능(핵심 조회/편집/저장 무관), 전 화면 pivot 편의기능 미이식(D00-3-037 동일 신호). 향후 요구 시 재설계 | 제외 |
| D00-3-011 | §3 SwitchLock / () 편집모드 잠금 토글 | EditButton 토글 어포던스 자체는 전 화면 미이식 결정(asis_to_tobe.md §11, 2026-09-23) — 단 기존행 재편집 시 잠금 범위 재현 여부는 별도 검증 필요 | 제외 |
| D00-3-017 | §3 Visible= / Columns[iCol].Visible = chkSum.Checked (SUM 토글) | SUM 열은 chkSum 정적 hidden(D00-1-005)에 종속 — 컨트롤 비노출이라 토글 불가, SUM 표시는 기본값 고정(01_layout §3). TO-BE 미이식 | 제외 |
| D00-3-020 | §3 Visible= / Columns[iCol].Visible = chkSum.Checked (SUM 토글) | SUM 열은 chkSum 정적 hidden(D00-1-005)에 종속 — 컨트롤 비노출이라 토글 불가, SUM 표시 기본값 고정(01_layout §3). TO-BE 미이식 | 제외 |
| D00-3-023 | §3 LockColumn / (iCol, true) 정보시트 컬럼 잠금 | AS-IS spreadInfo(제목/헤더 시트) 편집 불가 = TO-BE 는 헤더가 columnGroups 표현 전용(편집 대상 아님, Grid:147-151) — 구조적으로 편집 불가 | 제외 |
| D00-3-027 | §3 SetBGColor / (i,j,i,j, InvalidColor) 검증 실패 셀 색(0~7) | AS-IS 셀 검증실패 배경색 표기 — TO-BE 는 범위 검증을 값입력 시점 alert(MSG00203 OUT_OF_RANGE, Page:260-263)로 선차단해 잘못된 값이 셀에 기입되지 않음. 사후 셀-색 검증 경로 불필요(무해 미이식) | 제외 |
| D00-3-028 | §3 SetBGColor / (i,j,i,j, InvalidColor) 검증 실패 셀 색(0~1440) | AS-IS 셀 검증실패 배경색 표기(분 단위 0~1440) — TO-BE 는 값입력 시점 범위 alert(Page:260-263 DAY_MIN~DAY_MAX)로 선차단. 사후 셀-색 검증 경로 불필요(무해 미이식) | 제외 |
| D00-3-037 | §3 SetDblClickColumnShowHide / (sender, e) 더블클릭 컬럼 토글 | 더블클릭 컬럼 접기/펼치기 — AS-IS 부가기능(핵심 조회/편집/저장 무관), 전 화면 pivot 편의기능 미이식(D00-2-009 동일 신호). 향후 요구 시 재설계 | 제외 |

