# SCP0095 — To-Be Fact Pack 요약

- page_key: `supply/global-psi-elec` · feature: supply · As-is Fact Pack 없음(화면ID 미대응)
- 파일 9 · 엔드포인트 호출 7 (미해결 0, 주석 속 2) · 이벤트 13 · 컴포넌트 사용 19 · 하드코딩 컬럼 1 · 메시지 12
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 1건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/global-psi-elec/components/GlobalPsiElecForm.tsx | component | 264 |
| features/supply/src/pages/global-psi-elec/components/GlobalPsiElecGrid.tsx | component | 160 |
| features/supply/src/pages/global-psi-elec/global-psi-elec.constants.ts | constants | 118 |
| features/supply/src/pages/global-psi-elec/global-psi-elec.types.ts | types | 20 |
| features/supply/src/pages/global-psi-elec/GlobalPsiElec.tsx | page | 185 |
| features/supply/src/pages/global-psi-elec/index.ts | index | 2 |
| features/supply/src/pages/global-psi-elec/useGlobalPsiElecStore.ts | store | 176 |
| features/supply/src/pages/global-psi-elec/utils/globalPsiElecColumns.ts | util | 137 |
| features/supply/src/pages/global-psi-elec/__asis-mapping__.md | mapping | 222 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 3 | Y | GlobalPsiElecForm.tsx:72 GlobalPsiElecForm.tsx:74 GlobalPsiElecForm.tsx:76 |
| SCP0095/globalPsiElec//call-proc | hook | 1 | Y | GlobalPsiElec.tsx:51 |
| SCP0095/calendar//call-proc | hook | 1 | Y | GlobalPsiElec.tsx:71 |
| /admin/menu/SCP0095/column | http | 1 | Y | useGlobalPsiElecStore.ts:124 |
| /admin/menu/SCP0095/search-conditions | http | 1 | Y | useGlobalPsiElecStore.ts:153 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| CustomDropdown | onChange | <arrow> onPick,String | jsx | features/supply/src/pages/global-psi-elec/components/GlobalPsiElecForm.tsx | 137 |
| CustomDropdown | onChange | <arrow> onPick,String | jsx | features/supply/src/pages/global-psi-elec/components/GlobalPsiElecForm.tsx | 166 |
| SearchArea | onSearch | onSearch | jsx | features/supply/src/pages/global-psi-elec/components/GlobalPsiElecForm.tsx | 177 |
| InputField | onChange | <arrow> set | jsx | features/supply/src/pages/global-psi-elec/components/GlobalPsiElecForm.tsx | 225 |
| InputField | onKeyDown | <arrow> onSearch | jsx | features/supply/src/pages/global-psi-elec/components/GlobalPsiElecForm.tsx | 226 |
| FunctionSearchIcon | onClick | onModelSearch | jsx | features/supply/src/pages/global-psi-elec/components/GlobalPsiElecForm.tsx | 220 |
| PeriodField | onChange | <arrow> set | jsx | features/supply/src/pages/global-psi-elec/components/GlobalPsiElecForm.tsx | 247 |
| g | formatItem | formatHandler | addHandler | features/supply/src/pages/global-psi-elec/components/GlobalPsiElecGrid.tsx | 132 |
| GlobalPsiElecForm | onSearch | handleSearch | jsx | features/supply/src/pages/global-psi-elec/GlobalPsiElec.tsx | 150 |
| GlobalPsiElecForm | onModelSearch | <arrow> setOpenModelPopup | jsx | features/supply/src/pages/global-psi-elec/GlobalPsiElec.tsx | 150 |
| GlobalPsiElecGrid | onCellDblClick | handleCellDblClick | jsx | features/supply/src/pages/global-psi-elec/GlobalPsiElec.tsx | 171 |
| ElecMaterialPopup | onClose | <arrow> setOpenModelPopup | jsx | features/supply/src/pages/global-psi-elec/GlobalPsiElec.tsx | 178 |
| ElecMaterialPopup | onSelect | <arrow> set | jsx | features/supply/src/pages/global-psi-elec/GlobalPsiElec.tsx | 179 |

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
| PeriodField | 1 |
| DataGrid | 1 |
| MainTitle | 1 |
| GlobalPsiElecForm | 1 |
| SubTitle | 1 |
| GlobalPsiElecGrid | 1 |
| ElecMaterialPopup | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| leafOf | c.columnName | c.columnLabel \|\| 'Qty' | 70 | true | true |  | object | features/supply/src/pages/global-psi-elec/utils/globalPsiElecColumns.ts | 95 |

## 7. 메시지 코드
| code | count |
|---|---|
| MSG00013 | 1 |
| MSG00097 | 1 |
| LBL00112 | 1 |
| LBL00001 | 1 |
| LBL00047 | 1 |
| LBL00669 | 1 |
| LBL00039 | 1 |
| LBL00013 | 1 |
| LBL00710 | 1 |
| LBL00682 | 1 |
| LBL00683 | 1 |
| LBL00684 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0095(5), SCP0013(3), SCP0100(2), SCP0025(2), SCP0111(1), SCP0031(1), SCP0053(1)
- SP/PKG: PKG_SCP0095(3), PKG_COM0000(2), SCP0095_GET_GLOBAL_PSI_ELEC(1), P_DIVISION_ID(1), P_SCP0095_GET_GLOBAL_PSI_ELEC(1), P_SCP0009_GET_SHEET_CALENDAR_3SPAN(1), P_SCM0001_GET_SCP_DAY_PERIOD(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| endpoint | mount — keep-alive 탭에 남은 stale filters 자동발사 차단(clearFilters) + admin 동적 메타 fetch(mount 1회). | features/supply/src/pages/global-psi-elec/GlobalPsiElec.tsx | 83 |
| endpoint | admin SCM_MST_SHEET_COLUMNS 동적 fetch(convert-core §2.4 하드코딩 금지). 미등록/실패 시 빈 배열. | features/supply/src/pages/global-psi-elec/useGlobalPsiElecStore.ts | 19 |

## 10. __asis-mapping__.md 상태
- 구현: 54
- 해당없음: 13
- 제외: 2
| design_id | summary | reason | status |
|---|---|---|---|
| D00-1-015 | §1 chkSum / UsrCheckBox | AS-IS Visible=false 미노출(기본 off) — SUM 컬럼 추가표시 없이 활성버킷 접두만(design 03 §2.2). 별도 체크박스 컨트롤 미도입 = AS-IS 패리티 | 해당없음 |
| D00-1-016 | §1 layoutControlItem9 / LayoutControlItem | chkSum(#015) 라벨 슬롯 — chkSum 미노출이라 라벨도 없음 | 해당없음 |
| D00-1-022 | §1 components / Container | WinForms Designer 컨테이너(런타임 컴포넌트 트레이) — React 무대응 | 해당없음 |
| D00-1-023 | §1 imageList1 / ImageList | WinForms 이미지 리소스 컨테이너 — React 아이콘(@shared/lges-icons)로 대체, 별도 리스트 불요 | 해당없음 |
| D00-1-024 | §1 emptySpaceItem1 / EmptySpaceItem | DevExpress LayoutControl 여백 정렬 요소 — CSS/Grid 레이아웃이 대신 처리 | 해당없음 |
| D00-1-025 | §1 emptySpaceItem2 / EmptySpaceItem | LayoutControl 여백 요소 — CSS/Grid 레이아웃 대체 | 해당없음 |
| D00-1-026 | §1 emptySpaceItem3 / EmptySpaceItem | LayoutControl 여백 요소 — CSS/Grid 레이아웃 대체 | 해당없음 |
| D00-1-027 | §1 emptySpaceItem6 / EmptySpaceItem | LayoutControl 여백 요소 — CSS/Grid 레이아웃 대체 | 해당없음 |
| D00-1-028 | §1 emptySpaceItem18 / EmptySpaceItem | LayoutControl 여백 요소 — CSS/Grid 레이아웃 대체 | 해당없음 |
| D00-1-029 | §1 emptySpaceItem19 / EmptySpaceItem | LayoutControl 여백 요소 — CSS/Grid 레이아웃 대체 | 해당없음 |
| D00-1-030 | §1 emptySpaceItem20 / EmptySpaceItem | LayoutControl 여백 요소 — CSS/Grid 레이아웃 대체 | 해당없음 |
| D00-1-031 | §1 emptySpaceItem21 / EmptySpaceItem | LayoutControl 여백 요소 — CSS/Grid 레이아웃 대체 | 해당없음 |
| D00-1-032 | §1 usrButton1 / UsrButton | DEAD — 어떤 컨테이너에도 미부모화(Designer), 이벤트 미배선(§3 dead 판정) — 미이관 | 제외 |
| D00-1-033 | §1 usrCheckBox1 / UsrCheckBox | DEAD/hidden — Visible=false + 이벤트 미배선(chkSum 중복명, §3 dead 판정) — 미이관 | 제외 |
| D00-2-004 | §2 chkSum / CheckedChanged | AS-IS chkSum Visible=false 미노출(기본 off) — SUM 토글 컨트롤 미도입, 활성버킷 접두만(design 03 §2.2) | 해당없음 |

