# SCM0002 — To-Be Fact Pack 요약

- page_key: `supply/components/elecMaterialPopupStore.ts` · feature: supply · As-is Fact Pack 있음
- 파일 1 · 엔드포인트 호출 1 (미해결 0, 주석 속 0) · 이벤트 0 · 컴포넌트 사용 0 · 하드코딩 컬럼 0 · 메시지 0
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/components/elecMaterialPopupStore.ts | other | 44 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| /admin/menu/SCM0002/column | http | 1 | Y | elecMaterialPopupStore.ts:32 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| ModelPopup | divisionId projectCode scmSiteId itemId | o_rc1 |  |
| ElecPopup | divisionId companyId itemId | o_rc1 | P_SCM0002_GET_ITEM_ELEC |
| ProjectByDivPopup | divisionId projectCode | o_rc1 | P_SCM0002_GET_PROJECT_BY_DIVISION_POPUP |
| CapaItemPopup | divisionId itemId | o_rc1 | PKG_SCM0002 P_SCM0002_GET_CAPA_ITEM_POPUP |

## 4. 이벤트 배선
(없음)

## 5. 컴포넌트 사용 집계
(없음)

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
(없음)

## 8. 주석 속 As-is 참조
- 화면ID: SCM0002(2)
- SP/PKG: PR_GET_SHEET_COLUMN_LIST(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
(없음)

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

