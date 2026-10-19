# master_components_versionModal — To-Be Fact Pack 요약

- page_key: `master/components/versionModal` · feature: master · As-is Fact Pack 없음(화면ID 미대응)
- 파일 5 · 엔드포인트 호출 11 (미해결 4, 주석 속 0) · 이벤트 19 · 컴포넌트 사용 31 · 하드코딩 컬럼 0 · 메시지 26
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/master/src/components/versionModal/version-modal.constants.ts | constants | 32 |
| features/master/src/components/versionModal/versionModal.api.ts | api | 71 |
| features/master/src/components/versionModal/VersionModal.module.scss | style | 137 |
| features/master/src/components/versionModal/VersionModal.tsx | page | 678 |
| features/master/src/components/versionModal/versionModalStore.ts | store | 33 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| /DMF0044/unitedVersion/{buttonCode}/call-proc | http | 1 | N | versionModal.api.ts:31 |
| ACTION/{?params}//call-proc | callProc | 1 | N | versionModal.api.ts:56 |
| ACTION_BP/{?params}//call-proc | callProc | 1 | N | versionModal.api.ts:63 |
| TRANSFER/{?params}//call-proc | callProc | 1 | N | versionModal.api.ts:70 |
| (useTabComboQueries) | hook | 2 | Y | VersionModal.tsx:102 VersionModal.tsx:106 |
| DMF0044/unitedVersion//call-proc | hook | 1 | Y | VersionModal.tsx:164 |
| /admin/menu/DMF0044/column | http | 1 | Y | versionModalStore.ts:19 |
| /DMF0044/unitedVersion/ACTION/call-proc | propagated | 1 | Y | versionModal.api.ts:56 |
| /DMF0044/unitedVersion/ACTION_BP/call-proc | propagated | 1 | Y | versionModal.api.ts:63 |
| /DMF0044/unitedVersion/TRANSFER/call-proc | propagated | 1 | Y | versionModal.api.ts:70 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| grid | formatItem | formatHandler | addHandler | features/master/src/components/versionModal/VersionModal.tsx | 288 |
| grid | selectionChanged | selectionHandler | addHandler | features/master/src/components/versionModal/VersionModal.tsx | 289 |
| SearchArea | onSearch | handleSearch | jsx | features/master/src/components/versionModal/VersionModal.tsx | 439 |
| CustomDropdown | onChange | <arrow> handleVersionTypeChange,String | jsx | features/master/src/components/versionModal/VersionModal.tsx | 459 |
| DatePickerCalendar | onChange | <arrow> setSdt | jsx | features/master/src/components/versionModal/VersionModal.tsx | 478 |
| DatePickerCalendar | onChange | <arrow> setEdt | jsx | features/master/src/components/versionModal/VersionModal.tsx | 490 |
| InputField | onChange | <arrow> setDescription | jsx | features/master/src/components/versionModal/VersionModal.tsx | 504 |
| Checkbox | onChange | <arrow> setIncludeActual,setResultDate,dayjs,setUpdateLatest | jsx | features/master/src/components/versionModal/VersionModal.tsx | 517 |
| DatePickerCalendar | onChange | <arrow> setResultDate | jsx | features/master/src/components/versionModal/VersionModal.tsx | 532 |
| Checkbox | onChange | <arrow> setMovePlan,setMovePlanMonth,dayjs().subtract,dayjs | jsx | features/master/src/components/versionModal/VersionModal.tsx | 545 |
| DatePickerCalendar | onChange | <arrow> setMovePlanMonth | jsx | features/master/src/components/versionModal/VersionModal.tsx | 559 |
| Checkbox | onChange | <arrow> setUpdateLatest | jsx | features/master/src/components/versionModal/VersionModal.tsx | 568 |
| Button | onClick | <arrow> runAction | jsx | features/master/src/components/versionModal/VersionModal.tsx | 588 |
| Button | onClick | <arrow> runAction | jsx | features/master/src/components/versionModal/VersionModal.tsx | 599 |
| Button | onClick | <arrow> runAction | jsx | features/master/src/components/versionModal/VersionModal.tsx | 607 |
| Button | onClick | <arrow> runAction | jsx | features/master/src/components/versionModal/VersionModal.tsx | 619 |
| Button | onClick | <arrow> runAction | jsx | features/master/src/components/versionModal/VersionModal.tsx | 627 |
| Button | onClick | <arrow> adopt,getGridSelectedRow | jsx | features/master/src/components/versionModal/VersionModal.tsx | 662 |
| Button | onClick | modalClose | jsx | features/master/src/components/versionModal/VersionModal.tsx | 670 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Button | 7 |
| Grid | 6 |
| FormItem | 4 |
| DatePickerCalendar | 4 |
| Checkbox | 3 |
| InputField | 2 |
| CustomDialog | 1 |
| SearchArea | 1 |
| CustomDropdown | 1 |
| ResultArea | 1 |
| DataGrid | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| MSG00002 | 1 |
| MSG00618 | 1 |
| MSG00682 | 1 |
| MSG00683 | 1 |
| MSG00684 | 1 |
| MSG00685 | 1 |
| MSG00686 | 1 |
| MSG00687 | 1 |
| MSG00429 | 3 |
| LBL00052 | 2 |
| MSG00665 | 1 |
| MSG00108 | 1 |
| LBL00674 | 1 |
| LBL00801 | 1 |
| LBL00803 | 1 |
| LBL00606 | 1 |
| LBL00664 | 1 |
| LBL00001 | 1 |
| LBL00013 | 1 |
| LBL00608 | 1 |
| LBL00417 | 1 |
| LBL00416 | 1 |
| LBL00418 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: DMF0082(1)
- SP/PKG: (없음)
## 9. 주석 처리된 코드 (현행 기능 아님)
(없음)

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

