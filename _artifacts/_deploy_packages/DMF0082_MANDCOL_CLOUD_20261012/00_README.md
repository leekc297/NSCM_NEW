# DMF0082 조회 — 필수 컬럼은 '숨긴 컬럼' 으로 보지 않는다 (클라우드 이관 · 패치형)

> 마커 `[E20261012-DMF0082MANDCOL]` — PKG_DMF0082 BODY `P_DMF0082_GET_MAIN_DATA` 의 숨김 판정 2곳 뒤에 보정 블록 삽입. 기존 문장·데이터·메타·화면 변경 없음.

| 항목 | 값 |
|---|---|
| 증상 (클라우드 QA 10-12) | k0101 로 조회하면 Cell Prod Site `HQ06-A` 에 LOC 가 안 나온다 (minyonglee1 은 나옴). Column Set 을 Default 로 다시 저장하면 나온다 |
| 원인 | 화면과 SP 의 '숨김' 판정 불일치. 화면은 필수 컬럼(Cell Prod Site)을 사용자 컬럼 저장 내역에 없어도 항상 표시하는데, SP(`[E20260918-KEYCOLGRAIN]`)는 저장 내역에 행이 없으면 숨김으로 보고 메저별로 값을 하나로 합친다 → 판가 `HQ06-A` 888 + `NJ01-A` 777 이 `NJ01-A` 한 줄(832.5)로 합쳐지고 수요는 `HQ06-A` 에 남음 |
| 조치 (사용자 승인 A안) | 저장 내역에 없더라도 메타상 필수 컬럼(`SCM_MST_SHEET_COLUMNS` `USER_SELECTABLE_FLAG='N'` · `VISIBLE_FLAG='Y'` · 해당 division)이면 표시 중으로 판정. `CELL_PROD_SITE_ID` 와 `PLANT_SITE_ID` 2곳 동일 보정 |
| 달라지는 것 | 컬럼 저장 내역에 `CELL_PROD_SITE_ID` 가 없는 사용자의 **40** 조회, `PLANT_SITE_ID` 가 없는 사용자의 **81 계열** 조회 — 합쳐져 나오던 줄이 사이트별로 나뉜다. 그 외 사용자·division 은 결과 동일 |
| 사내 적용 | **완료** (ZIOUI1 2026-10-12 18:16 → 패키지 리허설로 재적용 18:23:13) · 전후 비교 4케이스 통과 · [APPLIED_OPERATIONS.md](../../_apply_corporate/DMF0082_MANDCOL_20261012/APPLIED_OPERATIONS.md) |
| 클라우드 | **미적용** |
| 왜 패치형인가 | 클라우드 BODY(10-12 13:27 변경)와 사내 BODY 는 타 작업자 수정분이 다르다. 사내 전체본을 올리면 그 차이까지 덮으므로, 클라우드의 `USER_SOURCE` 를 읽어 앵커 2곳 뒤에 블록만 넣는다 |
| BE 재기동 · FE | 불요 |

## 실행 순서 (SCM_MGR, QA → DEV, 각 파일 전체 F5, 값 입력 없음)

| # | 파일 | 기대 |
|---|---|---|
| 1 | [A_DB/00_PRECHECK_CLOUD.sql](A_DB/00_PRECHECK_CLOUD.sql) | L1 앵커 2줄 모두 `N=1 PASS` · L2 마커 0 · L3 두 컬럼 `필수 컬럼` · L5 실행 중 세션 없음 |
| 2 | [A_DB/10_APPLY_MANDCOL_PATCH.sql](A_DB/10_APPLY_MANDCOL_PATCH.sql) | `APPLIED — PKG_DMF0082 BODY VALID · 마커 2곳` (이미 적용이면 `SKIP`, 앵커 ≠1 이면 ORA-20001/20002 로 중단·원문 무변경) |
| 3 | [A_DB/90_VERIFY.sql](A_DB/90_VERIFY.sql) | V1 마커 2 PASS · V2 VALID/오류 0 · V3 보정 블록 2개 · V4 `OK` 3줄 · V5 `PASS — 합치지 않음` |

롤백: [A_DB/99_ROLLBACK_MANDCOL_PATCH.sql](A_DB/99_ROLLBACK_MANDCOL_PATCH.sql) (보정 블록 2개 제거, 마커 0 확인 후 재생성).

## 주의
- 00 의 L1 이 `N=1` 이 아니면 10 을 실행하지 말고 결과를 회신 — 클라우드 원문의 그 구간이 사내와 다른 것.
- 00 의 L3 에서 `필수 아님` 이 나오면 그 컬럼·division 은 보정이 동작하지 않는다(메타 차이) — 결과 회신.
- 10 은 패키지 BODY 재생성이라 조회·저장 실행 중이면 대기한다 — 00 L5 로 확인 뒤 한가할 때 실행.
- V5 는 컬럼 저장 내역에 `CELL_PROD_SITE_ID` 가 없는 사용자 1명으로 40 을 조회해 판정한다. 그런 사용자가 없으면 `SKIP`, 기간 내 원자료에 사이트가 갈리는 키가 없으면 `N/A`.

## 리허설 (사내 ZIOUI1 2026-10-12 18:22~18:23, `_rehearsal_out/`)
99(역치환 → 마커 0 · VALID) → 00(L1 2줄 PASS · L2 0) → 90(V1 0 · V5 `합쳐짐(적용 전 상태)` 189→0) → 10(`APPLIED … 마커 2곳`) → 90(V1 2 PASS · V4 40/81/82 OK · V5 `PASS` 189→189) → 00(L1 0 · L2 2 = 적용 상태).

## 작업 ↔ 파일 대조
| 사내에서 한 일 | 파일 |
|---|---|
| PKG_DMF0082 BODY 보정 블록 2개 삽입 | A_DB/10_APPLY_MANDCOL_PATCH.sql |
| 권한·시노님·메타·데이터 변경 | 없음 |
