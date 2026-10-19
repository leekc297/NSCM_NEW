# DMF0082 저장 Validation 메시지 — '_' 길이맞춤 제거 (2026-09-22, 사내 ZIOUI1 적용 완료)

## 요청
저장 시 Unit Price 검증 팝업의 `End Customer________ : NT` 처럼 `_` 로 폭을 맞춘 표기를 제거 → `End Customer : NT`.
대상 = PKG_DMF0082 전체에서 같은 방식으로 쓴 곳 전부.

## 전수 검색 (사내 USER_SOURCE, SPEC+BODY)
- 검색식: `'__'` 포함 / `RPAD|LPAD(` / `'_'` 리터럴 / 정규식 `[A-Za-z]_{2,} *:`
- 해당 = `P_DMF0082_SAVE_MAIN_DATA` Unit Price 검증 블록 **9줄**뿐 (L13040~13051, 사내 원 줄번호)
- 비해당 = L119·120·3985 `LPAD(...,'0')` (주차 번호 0 채움 — 표시 폭 맞춤 아님), SPEC 0건, FE(forecast-price) 0건

| # | 변경 전 | 변경 후 |
|---|---|---|
| 1 | `End Customer________ : ` | `End Customer : ` |
| 2 | `Sales site_____________ : ` | `Sales site : ` |
| 3 | `Model________________ : ` | `Model : ` |
| 4 | `Customs Handbook__ : ` | `Customs Handbook : ` |
| 5 | `Fcst Type_____________ : ` | `Fcst Type : ` |
| 6 | `Incoterms____________ : ` | `Incoterms : ` |
| 7 | `Plant Site___________ : ` | `Plant Site : ` |
| 8 | `Cell Prod Site___________ : ` | `Cell Prod Site : ` |
| 9 | `YYYYMMDD_________ : ` | `YYYYMMDD : ` |

마커 `[E20260922-MSGUNDERSCORE]` 주석 1줄 추가. 로직 무변경 (문자열 리터럴만).

## 파일
- `00_backup/BACKUP_PKG_DMF0082_BODY_pre_msgunderscore_20260922.sql` — 적용 직전 사내 원문 (LAST_DDL 2026-09-22 10:52:58, TMAINFIX 적용본)
- `01_PKG_DMF0082_BODY.sql` — 적용본 (CREATE OR REPLACE)
- `_new_PKG_BODY.sql` — 작업본

## 적용 결과
- FRESH-GATE 통과 → 적용 → PACKAGE / BODY **VALID**, USER_ERRORS 0, LAST_DDL 2026-09-22 13:18:12
- 잔존 `[A-Za-z]_{2,} *:` = **0**, TMAINFIX 마커 10 유지, 사내 live = 01 파일 EQUAL
- 문구 모사: `End Customer : NT` / `Sales site : Huapu_CN_CGU` / … / `YYYYMMDD : 20270201 ~ 20270201`
- 화면 저장 재현(E2E)은 미실행

## 클라우드
- 미적용. `_deploy_packages/DMF0082_TMAINFIX_CLOUD_20260922/A_DB/01` 은 이 변경 **이전** BODY 이다.
