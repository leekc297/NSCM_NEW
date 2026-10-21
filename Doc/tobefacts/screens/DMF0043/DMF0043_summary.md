# DMF0043 — To-Be Fact Pack 요약

- page_key: `master/contribute-view` · feature: master · As-is Fact Pack 없음(화면ID 미대응)
- 파일 16 · 엔드포인트 호출 10 (미해결 0, 주석 속 2) · 이벤트 21 · 컴포넌트 사용 48 · 하드코딩 컬럼 7 · 메시지 24
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 7건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/master/src/pages/contribute-view/components/ContributeViewForm.module.scss | component | 48 |
| features/master/src/pages/contribute-view/components/ContributeViewForm.tsx | component | 258 |
| features/master/src/pages/contribute-view/components/ContributeViewGrid.module.scss | component | 13 |
| features/master/src/pages/contribute-view/components/ContributeViewGrid.tsx | component | 187 |
| features/master/src/pages/contribute-view/components/modals/ContributeVersionModal.module.scss | component | 174 |
| features/master/src/pages/contribute-view/components/modals/ContributeVersionModal.tsx | component | 371 |
| features/master/src/pages/contribute-view/components/modals/contributeVersionModalStore.ts | store | 35 |
| features/master/src/pages/contribute-view/contribute-view.constants.ts | constants | 59 |
| features/master/src/pages/contribute-view/ContributeView.module.scss | style | 17 |
| features/master/src/pages/contribute-view/ContributeView.tsx | page | 293 |
| features/master/src/pages/contribute-view/hooks/useContributeViewExpression.ts | hook | 109 |
| features/master/src/pages/contribute-view/hooks/useContributeViewValidation.ts | hook | 47 |
| features/master/src/pages/contribute-view/index.ts | index | 2 |
| features/master/src/pages/contribute-view/types.ts | types | 58 |
| features/master/src/pages/contribute-view/useContributeViewStore.ts | store | 288 |
| features/master/src/pages/contribute-view/__asis-mapping__.md | mapping | 73 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| DMF0043/version//call-proc | hook | 1 | Y | ContributeViewForm.tsx:47 |
| /admin/menu/DMF0043/search-conditions | http | 1 | Y | ContributeViewForm.tsx:69 |
| (useTabComboQueries) | hook | 2 | Y | ContributeViewForm.tsx:100 ContributeVersionModal.tsx:110 |
| DMF0043/salesListTitle//call-proc | hook | 1 | Y | ContributeViewGrid.tsx:109 |
| (useTabLookupQueries) | hook | 1 | Y | ContributeVersionModal.tsx:122 |
| DMF0043/versionPopup//call-proc | hook | 1 | Y | ContributeVersionModal.tsx:150 |
| DMF0043/salesList//call-proc | hook | 1 | Y | ContributeView.tsx:95 |
| /admin/menu/DMF0043/column | http | 1 | Y | useContributeViewStore.ts:181 |
| DMF0043/titleSet/SEARCH/call-proc | http | 1 | Y | useContributeViewStore.ts:228 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | onSearch | jsx | features/master/src/pages/contribute-view/components/ContributeViewForm.tsx | 132 |
| CustomDropdown | onChange | <arrow> yearOptions.find,String,setSearchParams,String(opt?.NAME2??opt?.NAME??'').substring | jsx | features/master/src/pages/contribute-view/components/ContributeViewForm.tsx | 145 |
| InputField | onDoubleClick | onOpenVersionPopup | jsx | features/master/src/pages/contribute-view/components/ContributeViewForm.tsx | 185 |
| FunctionSearchIcon | onClick | onOpenVersionPopup | jsx | features/master/src/pages/contribute-view/components/ContributeViewForm.tsx | 180 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/master/src/pages/contribute-view/components/ContributeViewForm.tsx | 203 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/master/src/pages/contribute-view/components/ContributeViewForm.tsx | 217 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/master/src/pages/contribute-view/components/ContributeViewForm.tsx | 235 |
| Checkbox | onChange | <arrow> setSearchParams | jsx | features/master/src/pages/contribute-view/components/ContributeViewForm.tsx | 246 |
| DataGrid | formatItem | onFormatItem | jsx | features/master/src/pages/contribute-view/components/ContributeViewGrid.tsx | 183 |
| g.hostElement? | dblclick | onDbl | addEventListener | features/master/src/pages/contribute-view/components/modals/ContributeVersionModal.tsx | 233 |
| SearchArea | onSearch | onSearch | jsx | features/master/src/pages/contribute-view/components/modals/ContributeVersionModal.tsx | 263 |
| CustomDropdown | onChange | <arrow> setVersionType | jsx | features/master/src/pages/contribute-view/components/modals/ContributeVersionModal.tsx | 292 |
| PeriodField | onChange | <arrow> setPeriod,dayjs,start.slice,end.slice | jsx | features/master/src/pages/contribute-view/components/modals/ContributeVersionModal.tsx | 304 |
| InputField | onChange | <arrow> setDescription | jsx | features/master/src/pages/contribute-view/components/modals/ContributeVersionModal.tsx | 319 |
| Button | onClick | handleConfirm | jsx | features/master/src/pages/contribute-view/components/modals/ContributeVersionModal.tsx | 356 |
| Button | onClick | onClose | jsx | features/master/src/pages/contribute-view/components/modals/ContributeVersionModal.tsx | 363 |
| ContributeViewForm | onSearch | <arrow> handleSearch | jsx | features/master/src/pages/contribute-view/ContributeView.tsx | 209 |
| ContributeViewForm | onOpenVersionPopup | <arrow> setVersionPopupOpen | jsx | features/master/src/pages/contribute-view/ContributeView.tsx | 210 |
| ContributeVersionModal | onClose | <arrow> setVersionPopupOpen | jsx | features/master/src/pages/contribute-view/ContributeView.tsx | 227 |
| ContributeVersionModal | onSelect | handleVersionSelect | jsx | features/master/src/pages/contribute-view/ContributeView.tsx | 228 |
| ColumnLayoutModal | onSave | <arrow> clearGridOnSettingChange,applyColumnLayout,settings.map,settings.filter,saveTitleSet({menuId:MENU_ID,sheetName:TITLESET_SHEET,columnType:TITLESET_COLUMN_TYPE,rows:visible.map((s,i)=>({name:s.COLUMN_NAME,sortOrderNo:i+1,colWidth:s.COL_WIDTH,cellColor:s.CELL_COLOR,textColor:s.TEXT_COLOR,})),}).then,saveTitleSet | jsx | features/master/src/pages/contribute-view/ContributeView.tsx | 246 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 9 |
| FormItem | 9 |
| CustomDropdown | 5 |
| InputField | 3 |
| Button | 3 |
| SearchArea | 2 |
| DataGrid | 2 |
| FunctionSearchIcon | 1 |
| Checkbox | 1 |
| Label | 1 |
| CustomDialog | 1 |
| PeriodField | 1 |
| ProgressIndicator | 1 |
| ResultArea | 1 |
| ControlConfirmIcon | 1 |
| IcGridColumnSetup | 1 |
| MainTitle | 1 |
| ContributeViewForm | 1 |
| SubTitle | 1 |
| ContributeViewGrid | 1 |
| ContributeVersionModal | 1 |
| ColumnLayoutModal | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| leaf | m.binding | m.leaf | m.width | true |  |  | object | features/master/src/pages/contribute-view/components/ContributeViewGrid.tsx | 53 |
| VERSION_COLUMNS | VERSION_NO | Version | 220 |  |  |  | meta-shape | features/master/src/pages/contribute-view/components/modals/ContributeVersionModal.tsx | 89 |
| VERSION_COLUMNS | VERSION_DESCRIPTION | Description | 300 |  |  |  | meta-shape | features/master/src/pages/contribute-view/components/modals/ContributeVersionModal.tsx | 90 |
| VERSION_COLUMNS | VERSION_TYPE | Type | 117 |  |  |  | meta-shape | features/master/src/pages/contribute-view/components/modals/ContributeVersionModal.tsx | 91 |
| VERSION_COLUMNS | MAX(CREATED_BY) | Create By | 120 |  |  |  | meta-shape | features/master/src/pages/contribute-view/components/modals/ContributeVersionModal.tsx | 92 |
| VERSION_COLUMNS | MAX(CREATION_DATE) | Create Date | 150 |  |  |  | meta-shape | features/master/src/pages/contribute-view/components/modals/ContributeVersionModal.tsx | 93 |
| buildColumnMeta | DIVISION_ID:DIVISION_ID,END_CUSTOMER:END_CUSTOMER |  | 120\|80 |  |  |  | object | features/master/src/pages/contribute-view/hooks/useContributeViewExpression.ts | 55 |

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00112 | 1 |
| LBL00086 | 1 |
| LBL00606 | 1 |
| LBL00088 | 1 |
| LBL00087 | 1 |
| LBL00657 | 1 |
| LBL00654 | 1 |
| LBL00674 | 1 |
| LBL00664 | 1 |
| LBL00001 | 1 |
| LBL00795 | 1 |
| LBL00608 | 1 |
| LBL00716 | 1 |
| LBL00627 | 1 |
| MSG00283 | 2 |
| MSG00307 | 1 |
| MSG00631 | 1 |
| LBL00605 | 3 |
| LBL00764 | 1 |
| LBL00765 | 1 |
| MSG00618 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: DMF0043_01(3), DMF0082(1), DMF0043(1)
- SP/PKG: DMF0043_GET_SALES_LIST_SPREAD_TITLE(3), DMF0043_GET_CONTRIBUTION_SALES_LIST(2), DMF0043_GET_CONT_VIEW_VERSIONPOPUP(1), PKG_DMF0043(1), P_DMF0043_GET_CONT_VIEW_VERSIONPOPUP(1), P_DIVISION_ID(1), P_START(1), P_VERSION_TYPE(1), P_DESCRIPTION(1), P_DMF0043_SALES_LIST_GET(1), DMF0002_GET_TITLESET_POPUP(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | }); | features/master/src/pages/contribute-view/components/ContributeViewForm.tsx | 67 |
| code | DMF0043_VersionPopup popVersion = new DMF0043_VersionPopup(); | features/master/src/pages/contribute-view/components/modals/ContributeVersionModal.tsx | 25 |
| code | popVersion.Form_Load(true, "SP", sDivision, sStartDate, sEndDate); | features/master/src/pages/contribute-view/components/modals/ContributeVersionModal.tsx | 26 |
| code | popVersion.ShowDialog(); | features/master/src/pages/contribute-view/components/modals/ContributeVersionModal.tsx | 27 |
| code | if (popVersion.sVersions != "") txtVersion.Text = popVersion.sVersions; | features/master/src/pages/contribute-view/components/modals/ContributeVersionModal.tsx | 28 |
| endpoint | `useTabComboQueries(['MyDivision'])` 로 사용자 권한 기반 전체 Division 동적 lookup | features/master/src/pages/contribute-view/components/modals/ContributeVersionModal.tsx | 77 |
| code | const object — enum 대체 (NSCM 단일 cursor 표준 'o_rc1' 다수 중복 허용) | features/master/src/pages/contribute-view/contribute-view.constants.ts | 34 |
| endpoint | 화면 mount 시 admin SHEET_COLUMNS 동적 fetch (admin 변경 즉시 반영). | features/master/src/pages/contribute-view/ContributeView.tsx | 113 |
| code | const isHidden = !isBase && binding.indexOf('B_') > 0; | features/master/src/pages/contribute-view/hooks/useContributeViewExpression.ts | 49 |
| code | 저장된 컬럼 개인화(titleSet) 복원 — fetchStaticColumns 가 await 후 메타에 적용. 반환값 = 복원된 개인화(없으면 null). | features/master/src/pages/contribute-view/useContributeViewStore.ts | 71 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

