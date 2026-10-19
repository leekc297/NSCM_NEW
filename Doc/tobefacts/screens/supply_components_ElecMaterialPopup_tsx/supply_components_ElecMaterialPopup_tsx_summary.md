# supply_components_ElecMaterialPopup_tsx — To-Be Fact Pack 요약

- page_key: `supply/components/ElecMaterialPopup.tsx` · feature: supply · As-is Fact Pack 없음(화면ID 미대응)
- 파일 1 · 엔드포인트 호출 3 (미해결 0, 주석 속 0) · 이벤트 6 · 컴포넌트 사용 16 · 하드코딩 컬럼 0 · 메시지 4
- Grid 컬럼 출처: 메타(/column·titleSet) 미사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/components/ElecMaterialPopup.tsx | other | 266 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 2 | Y | ElecMaterialPopup.tsx:89 ElecMaterialPopup.tsx:91 |
| SCM0002/ElecPopup//call-proc | hook | 1 | Y | ElecMaterialPopup.tsx:114 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | handleSearch | jsx | features/supply/src/components/ElecMaterialPopup.tsx | 178 |
| CustomDropdown | onChange | <arrow> setCompanyId | jsx | features/supply/src/components/ElecMaterialPopup.tsx | 205 |
| InputField | onChange | <arrow> setItemId | jsx | features/supply/src/components/ElecMaterialPopup.tsx | 218 |
| InputField | onKeyDown | <arrow> handleSearch | jsx | features/supply/src/components/ElecMaterialPopup.tsx | 219 |
| Button | onClick | handleSubmit | jsx | features/supply/src/components/ElecMaterialPopup.tsx | 251 |
| Button | onClick | onClose | jsx | features/supply/src/components/ElecMaterialPopup.tsx | 258 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 3 |
| FormItem | 3 |
| CustomDropdown | 2 |
| Button | 2 |
| CustomDialog | 1 |
| SearchArea | 1 |
| InputField | 1 |
| ProgressIndicator | 1 |
| ResultArea | 1 |
| DataGrid | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00664 | 1 |
| LBL00001 | 1 |
| LBL00047 | 1 |
| LBL00021 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCM0002(3), SCP0095(1), SCP0001(1)
- SP/PKG: PKG_SCM0002(1), P_SCM0002_GET_ITEM_ELEC(1), SCM0001_GET_DIVISION(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
(없음)

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

