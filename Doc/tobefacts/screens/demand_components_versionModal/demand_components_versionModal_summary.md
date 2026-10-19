# demand_components_versionModal — To-Be Fact Pack 요약

- page_key: `demand/components/versionModal` · feature: demand · As-is Fact Pack 없음(화면ID 미대응)
- 파일 5 · 엔드포인트 호출 8 (미해결 3, 주석 속 0) · 이벤트 15 · 컴포넌트 사용 22 · 하드코딩 컬럼 0 · 메시지 23
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/demand/src/components/versionModal/version-modal.api.ts | api | 85 |
| features/demand/src/components/versionModal/version-modal.constants.ts | constants | 77 |
| features/demand/src/components/versionModal/VersionModal.module.scss | style | 131 |
| features/demand/src/components/versionModal/VersionModal.tsx | page | 660 |
| features/demand/src/components/versionModal/versionModalStore.ts | store | 32 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| /{menuId}/unitedVersion/{btnCd}/call-proc | http | 1 | N | version-modal.api.ts:39 |
| /{?menuId}/ACTION/call-proc | callProc | 1 | N | version-modal.api.ts:73 |
| /{?menuId}/TRANSFER/call-proc | callProc | 1 | N | version-modal.api.ts:84 |
| (useTabLookupQuery) | hook | 1 | Y | VersionModal.tsx:155 |
| /admin/menu/DMF0044/column | http | 1 | Y | VersionModal.tsx:178 |
| DMF0044\|DMF0049/unitedVersion//call-proc | hook | 1 | Y | VersionModal.tsx:201 |
| /DMF0044\|DMF0049/ACTION/call-proc | propagated | 1 | Y | VersionModal.tsx:384 |
| /DMF0044\|DMF0049/TRANSFER/call-proc | propagated | 1 | Y | VersionModal.tsx:378 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| g | formatItem | formatHandler | addHandler | features/demand/src/components/versionModal/VersionModal.tsx | 307 |
| g | selectionChanged | selHandler | addHandler | features/demand/src/components/versionModal/VersionModal.tsx | 308 |
| Button | onClick | <arrow> runAction | jsx | features/demand/src/components/versionModal/VersionModal.tsx | 418 |
| SearchArea | onSearch | handleSearch | jsx | features/demand/src/components/versionModal/VersionModal.tsx | 445 |
| DivisionField | onChange | <arrow>  | jsx | features/demand/src/components/versionModal/VersionModal.tsx | 459 |
| CustomDropdown | onChange | <arrow> handleTypeChange,String | jsx | features/demand/src/components/versionModal/VersionModal.tsx | 471 |
| PeriodField | onChange | <arrow> setSdt,setEdt | jsx | features/demand/src/components/versionModal/VersionModal.tsx | 481 |
| InputField | onChange | <arrow> setDescription | jsx | features/demand/src/components/versionModal/VersionModal.tsx | 493 |
| Checkbox | onChange | handleIncludeResult | jsx | features/demand/src/components/versionModal/VersionModal.tsx | 512 |
| DatePickerCalendar | onChange | <arrow> setBasicDate,date?.format | jsx | features/demand/src/components/versionModal/VersionModal.tsx | 523 |
| Checkbox | onChange | handleIncludeMv | jsx | features/demand/src/components/versionModal/VersionModal.tsx | 539 |
| DatePickerCalendar | onChange | <arrow> setMvMonth,date?.format | jsx | features/demand/src/components/versionModal/VersionModal.tsx | 549 |
| Checkbox | onChange | setUpdateLatest | jsx | features/demand/src/components/versionModal/VersionModal.tsx | 565 |
| Button | onClick | <arrow> adopt,getSelectedRow | jsx | features/demand/src/components/versionModal/VersionModal.tsx | 643 |
| Button | onClick | modalClose | jsx | features/demand/src/components/versionModal/VersionModal.tsx | 652 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Button | 3 |
| Checkbox | 3 |
| Grid | 2 |
| FormItem | 2 |
| DatePickerCalendar | 2 |
| ProgressIndicator | 2 |
| CustomDialog | 1 |
| SearchArea | 1 |
| DivisionField | 1 |
| CustomDropdown | 1 |
| PeriodField | 1 |
| InputField | 1 |
| ResultArea | 1 |
| DataGrid | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| MSG00682 | 1 |
| MSG00683 | 1 |
| MSG00684 | 1 |
| MSG00685 | 1 |
| MSG00686 | 1 |
| MSG00687 | 1 |
| MSG00002 | 1 |
| MSG00618 | 1 |
| MSG00096 | 1 |
| LBL00013 | 1 |
| LBL00513 | 1 |
| LBL00664 | 1 |
| LBL00052 | 1 |
| LBL00608 | 1 |
| LBL00849 | 1 |
| LBL00850 | 1 |
| LBL00851 | 1 |
| LBL00844 | 1 |
| LBL00845 | 1 |
| LBL00846 | 1 |
| LBL00847 | 1 |
| LBL00848 | 1 |
| LBL00627 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: DMF0044(9), DMF0049(7), DMF0082(1)
- SP/PKG: PKG_DMF0044(3), P_DMF0044_GET_SALES_VERSION_POPUP(2), P_DMF0044_SAVE_SALES_PLAN_VERSION_COPY(1), P_DMF0044_MOBILE_REPORT_CREATE(1), P_ACTION_TYPE(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | onSelect(versionNo, `${versionNo} ${cellStr(row.VERSION_DESCRIPTION)}`.trim()); | features/demand/src/components/versionModal/VersionModal.tsx | 275 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

