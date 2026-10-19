# master_components_searchFields — To-Be Fact Pack 요약

- page_key: `master/components/searchFields` · feature: master · As-is Fact Pack 없음(화면ID 미대응)
- 파일 10 · 엔드포인트 호출 10 (미해결 0, 주석 속 0) · 이벤트 26 · 컴포넌트 사용 54 · 하드코딩 컬럼 0 · 메시지 23
- Grid 컬럼 출처: 메타(/column·titleSet) 미사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/master/src/components/searchFields/bigFilterCombo.ts | other | 101 |
| features/master/src/components/searchFields/CascadeFields.tsx | page | 176 |
| features/master/src/components/searchFields/CascadeFields.utils.ts | other | 233 |
| features/master/src/components/searchFields/index.ts | index | 5 |
| features/master/src/components/searchFields/SearchFields.debug.ts | other | 205 |
| features/master/src/components/searchFields/SearchFields.module.scss | style | 89 |
| features/master/src/components/searchFields/SearchFields.tsx | page | 1396 |
| features/master/src/components/searchFields/SearchFields.utils.ts | other | 113 |
| features/master/src/components/searchFields/useCascadeFields.tsx | hook | 175 |
| features/master/src/components/searchFields/yearField.util.ts | other | 40 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 10 | Y | SearchFields.tsx:288 SearchFields.tsx:342 SearchFields.tsx:412 SearchFields.tsx:511 SearchFields.tsx:617 SearchFields.tsx:742 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| InputField | onFocus | <arrow> onFocus | jsx | features/master/src/components/searchFields/SearchFields.tsx | 250 |
| InputField | onBlur | <arrow> setText | jsx | features/master/src/components/searchFields/SearchFields.tsx | 254 |
| InputField | onChange | <arrow> setText,onValueChange | jsx | features/master/src/components/searchFields/SearchFields.tsx | 258 |
| Button | onClick | <arrow> onOpenPopup | jsx | features/master/src/components/searchFields/SearchFields.tsx | 269 |
| CustomDropdown | onChange | <arrow> onChange,String | jsx | features/master/src/components/searchFields/SearchFields.tsx | 311 |
| CustomDropdown | onChange | <arrow> onChange,String(options??'').split(',').filter,String(options??'').split,String | jsx | features/master/src/components/searchFields/SearchFields.tsx | 359 |
| CustomDropdown | onChange | <arrow> onChange,String(options??'').split(',').filter,String(options??'').split,String | jsx | features/master/src/components/searchFields/SearchFields.tsx | 447 |
| CustomDropdown | onChange | <arrow> onChange,String(options??'').split(',').filter,String(options??'').split,String | jsx | features/master/src/components/searchFields/SearchFields.tsx | 568 |
| CustomDropdown | onChange | <arrow> onChange,String(options??'').split(',').filter,String(options??'').split,String | jsx | features/master/src/components/searchFields/SearchFields.tsx | 674 |
| CustomDropdown | onChange | <arrow> onChange,String(opts??'').split(',').filter,String(opts??'').split,String | jsx | features/master/src/components/searchFields/SearchFields.tsx | 797 |
| CustomDropdown | onChange | <arrow> onChange,String(options??'').split(',').filter,String(options??'').split,String | jsx | features/master/src/components/searchFields/SearchFields.tsx | 846 |
| PopupSearchInput | onValueChange | <arrow> onChange,v.split(',').map(s=>s.trim()).filter,v.split(',').map,v.split,s.trim | jsx | features/master/src/components/searchFields/SearchFields.tsx | 893 |
| PopupSearchInput | onOpenPopup | <arrow> setOpen | jsx | features/master/src/components/searchFields/SearchFields.tsx | 901 |
| PopupSearchInput | onValueChange | <arrow> onChange,v.split(',').map(s=>s.trim()).filter,v.split(',').map,v.split,s.trim | jsx | features/master/src/components/searchFields/SearchFields.tsx | 970 |
| PopupSearchInput | onOpenPopup | <arrow> setOpen | jsx | features/master/src/components/searchFields/SearchFields.tsx | 978 |
| PopupSearchInput | onValueChange | <arrow> onChange,v.split(',').map(s=>s.trim()).filter,v.split(',').map,v.split,s.trim | jsx | features/master/src/components/searchFields/SearchFields.tsx | 1045 |
| PopupSearchInput | onOpenPopup | <arrow> setOpen | jsx | features/master/src/components/searchFields/SearchFields.tsx | 1053 |
| DatePickerCalendar | onChange | <arrow> onChange,date?.format | jsx | features/master/src/components/searchFields/SearchFields.tsx | 1160 |
| DatePickerCalendar | onChange | <arrow> onChange,date?.format | jsx | features/master/src/components/searchFields/SearchFields.tsx | 1177 |
| DatePickerCalendar | onChange | <arrow> yearValueOf,onChange | jsx | features/master/src/components/searchFields/SearchFields.tsx | 1245 |
| CustomDropdown | onChange | <arrow> onChange,String | jsx | features/master/src/components/searchFields/SearchFields.tsx | 1293 |
| PopupSearchInput | onValueChange | onValueChange ?? (() => { /* 미전달 = popup 선택 전용, 직접 입력 안 함 */ }) | jsx | features/master/src/components/searchFields/SearchFields.tsx | 1353 |
| PopupSearchInput | onFocus | unlabelOnFocus | jsx | features/master/src/components/searchFields/SearchFields.tsx | 1359 |
| PopupSearchInput | onOpenPopup | onOpenPopup | jsx | features/master/src/components/searchFields/SearchFields.tsx | 1360 |
| input | onChange | <arrow> onChange | jsx | features/master/src/components/searchFields/SearchFields.tsx | 1388 |
| CustomDropdown | onChange | <arrow> handleChange,String | jsx | features/master/src/components/searchFields/useCascadeFields.tsx | 159 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 16 |
| FormItem | 16 |
| CustomDropdown | 9 |
| PopupSearchInput | 4 |
| DatePickerCalendar | 3 |
| InputField | 1 |
| Button | 1 |
| FunctionSearchIcon | 1 |
| ProjectByDivisionModal | 1 |
| ItemByDivisionModal | 1 |
| OwnerByDivisionModal | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00001 | 2 |
| LBL00502 | 2 |
| LBL00080 | 2 |
| LBL00506 | 2 |
| LBL00081 | 2 |
| LBL00005 | 2 |
| LBL00085 | 2 |
| LBL00090 | 1 |
| LBL00507 | 1 |
| LBL00618 | 1 |
| LBL00510 | 1 |
| LBL00505 | 1 |
| LBL00086 | 1 |
| LBL00511 | 1 |
| LBL00513 | 1 |
| LBL00512 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: DMF0003(4), DMF0048(3), DMF0020(2), DMF0043(1), DMF0074(1), SCP0006(1), SSP0015(1), DMF0044(1)
- SP/PKG: P_COM0006(1), P_COM0008(1), P_OWNER_ID(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | onChange={(next, changed) => { | features/master/src/components/searchFields/CascadeFields.tsx | 120 |
| code | if (changed === 'division') return setSearchParams({ ...next, projectCode: '', owner: '' }); | features/master/src/components/searchFields/CascadeFields.tsx | 122 |
| code | setSearchParams(next); | features/master/src/components/searchFields/CascadeFields.tsx | 123 |
| code | const cascade = useCascadeFields({ comboId, levels, value: sc, onChange: ... }); | features/master/src/components/searchFields/CascadeFields.tsx | 131 |
| jsx | <Grid size={3}>{/* Project popup */}</Grid> | features/master/src/components/searchFields/CascadeFields.tsx | 136 |
| jsx | <Grid size={3}>{/* Model / Nickname popup */}</Grid> | features/master/src/components/searchFields/CascadeFields.tsx | 137 |
| code | } from '@master/searchFields'; | features/master/src/components/searchFields/SearchFields.tsx | 12 |
| jsx | <SearchArea conditions={<> | features/master/src/components/searchFields/SearchFields.tsx | 14 |
| jsx | <DivisionField value={sc.divisionId} onChange={v => set({ divisionId: v })} /> | features/master/src/components/searchFields/SearchFields.tsx | 15 |
| jsx | <TeamField value={sc.deptIds} onChange={v => set({ deptIds: v })} division={sc.divisionId} /> | features/master/src/components/searchFields/SearchFields.tsx | 16 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

