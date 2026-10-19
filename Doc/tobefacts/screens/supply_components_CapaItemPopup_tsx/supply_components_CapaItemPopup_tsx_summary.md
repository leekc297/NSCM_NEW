# supply_components_CapaItemPopup_tsx — To-Be Fact Pack 요약

- page_key: `supply/components/CapaItemPopup.tsx` · feature: supply · As-is Fact Pack 없음(화면ID 미대응)
- 파일 1 · 엔드포인트 호출 2 (미해결 0, 주석 속 0) · 이벤트 5 · 컴포넌트 사용 13 · 하드코딩 컬럼 0 · 메시지 4
- Grid 컬럼 출처: 메타(/column·titleSet) 미사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/components/CapaItemPopup.tsx | other | 290 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 1 | Y | CapaItemPopup.tsx:101 |
| SCM0002/CapaItemPopup//call-proc | hook | 1 | Y | CapaItemPopup.tsx:116 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | handleSearch | jsx | features/supply/src/components/CapaItemPopup.tsx | 211 |
| InputField | onChange | <arrow> setItemId | jsx | features/supply/src/components/CapaItemPopup.tsx | 235 |
| InputField | onKeyDown | <arrow> handleSearch | jsx | features/supply/src/components/CapaItemPopup.tsx | 236 |
| Button | onClick | handleSubmit | jsx | features/supply/src/components/CapaItemPopup.tsx | 275 |
| Button | onClick | onClose | jsx | features/supply/src/components/CapaItemPopup.tsx | 282 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 2 |
| FormItem | 2 |
| Button | 2 |
| CustomDialog | 1 |
| SearchArea | 1 |
| CustomDropdown | 1 |
| InputField | 1 |
| ProgressIndicator | 1 |
| ResultArea | 1 |
| DataGrid | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00674 | 1 |
| LBL00664 | 1 |
| LBL00001 | 1 |
| LBL01142 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCM0002(3), SCP0104(2), SCP0105(1)
- SP/PKG: SCM0002_GET_CAPA_ITEM_POPUP(1), FN_SCM0002_GET_CAPA_ITEM_POPUP(1), PKG_SCM0002(1), P_SCM0002_GET_CAPA_ITEM_POPUP(1), P_DIVISION_ID(1), P_ITEM_ID(1), SCM0001_GET_DIVISION(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
(없음)

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

