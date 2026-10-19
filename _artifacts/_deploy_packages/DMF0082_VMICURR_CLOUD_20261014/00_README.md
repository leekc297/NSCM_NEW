# DMF0082 조회 — VMI 메저도 LOC 의 Currency 를 표시 (클라우드 이관 · 패치형)

> 마커 `[E20261014-DMF0082VMICURR]` — PKG_DMF0082 BODY 조회 프로시저 2종에서 VMI 통화 제외 조건 6곳만 치환. 다른 문장·원장·저장·메타·화면 변경 없음.

| 항목 | 값 |
|---|---|
| 요청 | VMI 메저일 때도 MKT_FCST 처럼 LOC 의 CURRENCY 를 가져와 같이 쓰고 셀 병합이 되게 (2026-10-14) |
| 종전 | VMI 계열(VMI_In_Req · VMI_Inv · VMI_DIO 등)만 Currency 빈칸 → 같은 품목의 LOC · MKT_FCST 행(USD 등)과 달라 셀 병합이 끊김 (AS-IS 도 VMI 는 빈칸) |
| 보완 | ① LOC 통화 백필 MERGE 의 `NOT LIKE 'VMI%'` 4곳 주석 처리 ② CURRNORM 의 VMI 공백 강제 2곳 제거 |
| 통화 원천·규칙 | 다른 수량 메저와 동일 — 같은 키 LOC 행의 통화, 비어 있는 행만 채움 |
| 사내 적용 | **완료** (ZIOUI1 2026-10-14 11:33:14 → 리허설 재적용 11:50:01, 직접 적용본과 BODY 완전 동일) · [APPLIED_OPERATIONS.md](../../_apply_corporate/DMF0082_VMICURR_20261014/APPLIED_OPERATIONS.md) |
| 클라우드 | **미적용** |
| BE 재기동 · FE | 불요 |

## 실행 순서 (SCM_MGR, QA → DEV, 각 파일 전체 F5, 값 입력 없음)

| # | 파일 | 기대 |
|---|---|---|
| 1 | [A_DB/00_PRECHECK_CLOUD.sql](A_DB/00_PRECHECK_CLOUD.sql) | L1 대상줄 3행 모두 `PASS` (MAIN 형 3 · CURRENT 형 1 · CURRNORM 2) · L2 마커 0 · L4 실행 중 세션 없음 |
| 2 | [A_DB/10_APPLY_VMICURR_PATCH.sql](A_DB/10_APPLY_VMICURR_PATCH.sql) | `APPLIED — PKG_DMF0082 BODY VALID · 마커 6곳` (이미 적용이면 `SKIP`, 건수 불일치면 ORA-20001 로 중단·원문 무변경) |
| 3 | [A_DB/90_VERIFY.sql](A_DB/90_VERIFY.sql) | V1 PASS(6) · V2 VALID/오류 0/의존 INVALID 0 · V3 3행 모두 `PASS (잔존 0)` · V4 화면 확인 대상 |

롤백: [A_DB/99_ROLLBACK_VMICURR_PATCH.sql](A_DB/99_ROLLBACK_VMICURR_PATCH.sql)

적용 뒤 화면 확인: 90 의 V4 `SAMPLE_SITE`(예: 81 BMW_MX_MEX · 82 DeltaX_KR_SEL)로 조회해, VMI 메저 행의 Currency 가 같은 품목의 LOC · MKT_FCST 행과 같고 셀이 병합되는지 본다.

## 주의
- **패치형이다.** 클라우드 원문을 읽어 6곳만 치환한다. L1 이 하나라도 FAIL 이면 10 을 실행하지 말고 00 결과를 회신 (10 도 같은 조건이면 원문을 건드리지 않고 중단한다).
- 적용 **뒤** 00 을 다시 돌리면 L1 이 FAIL 로 나오는 것이 정상이다 (치환 대상 줄이 없어졌으므로). 적용 여부는 L2 마커 6 / 90 으로 본다.
- **AS-IS 와 다르게 가는 변경이다.** AS-IS 는 VMI 메저 Currency 를 항상 빈칸으로 내려준다.
- VMI_DIO(비율 메저)에도 같은 키 LOC 통화가 표시된다 (VMI 계열 전체 공통 조건).
- 화면 조회 버튼은 `P_DMF0082_GET_MAIN_DATA` 만 쓴다. 같이 고친 `P_DMF0082_GET_MAIN_DATA_CURRENT`(SEARCH_CURRENT, FE 미호출)는 원래부터 계획 행 통화를 `'/'` 로 넣어 백필이 동작하지 않는다 — MKT_FCST 도 빈칸이고 VMI 도 계속 빈칸이다(기존 결함, 이번 범위 밖).
- 저장에는 영향 없다 — 수량 메저 원장(DM_PLN_MKT_FCST)에는 Currency 컬럼이 없다.
- 같은 BODY 를 고치는 `DMF0082_AFSSHARE_CLOUD_20261013` · `DMF0082_MANDRET_CLOUD_20261013` 등과 구간이 달라 순서 무관.
- 10 은 패키지 BODY 재생성이라 DMF0082 조회·저장 실행 중이면 대기 — 00 L4 확인 뒤 실행.

## 사내 검증
- 전후 비교(조회 SP 만 호출, rollback) 12케이스: GET_MAIN_DATA 6케이스 PASS — 40 acer_CN_CKG VMI_In_Req 빈칸→USD(LOC 와 같음) · 81 Ford_MX_CTN 3행 빈칸→USD · 비VMI 행과 행 수 전후 동일.
- MKT_FCST 를 같이 띄운 비교(메저 선택 임시 추가 후 rollback): 40 LOC·MKT_FCST·VMI_In_Req 모두 USD · 81 같은 키 VMI_In_Req = MKT_FCST 3건 · 82 VMI_Inv KRW = LOC KRW.
- 미확인: 82 VMI_DIO 실데이터 · 화면 셀 병합 육안.

## 리허설 (사내 ZIOUI1 2026-10-14 11:49~11:50, `_rehearsal_out/`)
99(`ROLLED BACK … 마커 0`) → 00(L1 3행 PASS · L2 0) → 90(V1 미적용 · V3 잔존 6줄) → 10(`APPLIED … 마커 6곳`) → 10(`SKIP` 멱등) → 90(V1 PASS · V2 VALID · V3 잔존 0) → 00(L2 6).
리허설 뒤 사내 BODY = 직접 적용본과 완전 동일(918,699자) · 전후 비교 재실행 결과 동일.

## 작업 ↔ 파일 대조
| 사내에서 한 일 | 파일 |
|---|---|
| PKG_DMF0082 BODY 6곳 치환 (조회 프로시저 2종) | A_DB/10_APPLY_VMICURR_PATCH.sql |
| 권한·시노님·메타·데이터 변경 | 없음 |
