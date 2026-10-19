# DMF0005 Model Code Change 팝업 저장 — 키 중복 사전 검증 추가 (클라우드 이관 · 패치형)

> 마커 `[E20261013-DMF0005MCDUP]` — PKG_DMF0005 BODY `P_DMF0005_SAVE_MODEL_CHANGE_POPUP` 에 내부 프로시저 `CHECK_DUP` 신설 + 호출 1줄. 기존 문장·데이터·메타·화면 변경 없음.

| 항목 | 값 |
|---|---|
| 요청 (2026-10-13) | Model Code Change 저장 실패 시 검증 메시지 추가 |
| 증상 | 클라우드 QA 10-13 13:17 · 13:21 저장이 `ORA-00001 (PK_SCM_MST_SITE_ITEM)` 로 실패, 화면에는 SQL ERROR 만 표시 |
| 원인 | 변경 전 Model 과 같은 키(Division·Project·Site)에 변경 후 Model 이 이미 등록돼 있어, ITEM_ID 를 바꾸는 순간 키가 겹친다 |
| 보완 | 테이블을 갱신하기 직전에 "갱신 뒤 키가 겹치는가"를 검사해 겹치면 검증 메시지로 차단(전체 ROLLBACK) |
| 메시지 | `변경 후 Model 코드가 같은 키로 이미 등록되어 있어 변경할 수 없습니다.` + `MODEL : 변경 전 -> 변경 후` + `TABLE : 테이블명` + `KEY : 컬럼=값, …` |
| 검사 대상 | 갱신 대상 38개 테이블 중 ITEM_ID 를 포함한 유일 인덱스가 있는 것 (사내 17개). 인덱스·키 컬럼은 실행 시 딕셔너리에서 읽는다 → 클라우드 키 구성이 사내와 달라도 동작 |
| AS-IS | `dbo.DMF0005_SAVE_MODEL_CHANGE_POPUP`(LGCE_SCMDEV, 2023-08-23)도 사전 검사 없이 갱신 → 중복이면 전체 ROLLBACK 후 `[2627]Violation of PRIMARY KEY…` 반환. 저장 불가 결과는 같고 안내 문구만 더한 것(의도적 추가) |
| 달라지지 않는 것 | 키가 겹치지 않는 변경의 결과 · 기존 검증 7종의 순서와 문구 · 이력 기록 |
| 사내 적용 | **완료** (ZIOUI1 2026-10-13 14:03 → 리허설 재적용 14:08:30) · [APPLIED_OPERATIONS.md](../../_apply_corporate/DMF0005_MCDUP_20261013/APPLIED_OPERATIONS.md) |
| 클라우드 | **미적용** |
| BE 재기동 · FE | 불요 |

## 실행 순서 (SCM_MGR, QA → DEV, 각 파일 전체 F5, 값 입력 없음)

| # | 파일 | 기대 |
|---|---|---|
| 1 | [A_DB/00_PRECHECK_CLOUD.sql](A_DB/00_PRECHECK_CLOUD.sql) | L1 앵커 3종 `N=1 PASS` · L2 마커 0 · L3 검사 대상 인덱스 목록 · L5 실행 중 세션 없음 |
| 2 | [A_DB/10_APPLY_MCDUP_PATCH.sql](A_DB/10_APPLY_MCDUP_PATCH.sql) | `APPLIED — PKG_DMF0005 BODY VALID · 마커 4곳` (이미 적용이면 `SKIP`, 앵커 ≠1 이면 ORA-2000x 로 중단·원문 무변경) |
| 3 | [A_DB/90_VERIFY.sql](A_DB/90_VERIFY.sql) | V1 PASS(4) · V2 VALID/오류 0 · V3 마커 4줄 · V4 `PASS — 검증 메시지로 차단` (또는 `N/A`) |

롤백: [A_DB/99_ROLLBACK_MCDUP_PATCH.sql](A_DB/99_ROLLBACK_MCDUP_PATCH.sql) — 되돌리면 키가 겹치는 변경은 다시 SQL ERROR 로 실패한다.

## 주의
- **패치형이다.** 클라우드 PKG_DMF0005 BODY 는 사내와 줄 수(1,906)는 같아도 내용이 다르다(10-13 지문 불일치). 10 은 클라우드 원문을 읽어 3곳에만 끼워 넣는다. 앵커가 맞지 않으면 원문을 건드리지 않고 중단한다 → 00 의 L1 결과를 회신.
- 00 의 L1 은 적용 뒤에도 1건으로 나온다(끼워 넣은 문구가 앵커 줄을 그대로 품고 있다). 적용 여부는 L2 마커로 본다.
- 90 의 V4 는 저장 SP 를 실제 호출한다. 시험 변경쌍은 SCM_MST_SITE_ITEM 에서 키가 겹치는 것만 고르므로 저장이 성공할 수 없고(검증 차단, 또는 미차단이어도 ORA-00001 로 전체 ROLLBACK) 데이터는 바뀌지 않는다. 호출 중 앞선 테이블 갱신이 잠깐 수행됐다 되돌려진다(사내 4~14초).
- 검사는 테이블별로 그 테이블을 갱신하기 직전에 한다. 뒤쪽 테이블에서 겹치면 앞쪽 테이블 갱신분은 ROLLBACK 된다(종전 ORA-00001 실패와 같은 경로).
- 10 은 패키지 BODY 재생성이라 DMF0005 조회·저장 실행 중이면 대기 — 00 L5 확인 뒤 한가할 때 실행.

## 남은 제약 (이번 범위 밖)
- 같은 배치에 `A→B` 와 `B→C` 를 함께 넣고 A 행과 B 행의 키가 같은 경우: 갱신 뒤 키는 겹치지 않아 검증은 통과하지만, 갱신이 행 단위로 수행되어 도중에 ORA-00001 이 날 수 있다(종전과 같은 SQL ERROR). AS-IS 는 한 문장 갱신이라 통과한다. 실사례 미확인.

## 리허설 (사내 ZIOUI1 2026-10-13 14:08, `_rehearsal_out/`)
99(`ROLLED BACK … 마커 0`) → 00(L1 3종 PASS · L2 0) → 90(V1 미적용 · V4 `SKIP`) → 10(`APPLIED … 마커 4곳`) → 10(`SKIP` 멱등) → 90(V1 PASS · V4 `PASS` — MPCBDIQRPJ1E -> MPCBDIQRPJ1V, DM_PLN_MKT_FCST 에서 차단, 행 수 2 → 2) → 00(L2 4).

## 작업 ↔ 파일 대조
| 사내에서 한 일 | 파일 |
|---|---|
| PKG_DMF0005 BODY 3곳 삽입 (이력 1줄 · CHECK_DUP · 호출 1줄) | A_DB/10_APPLY_MCDUP_PATCH.sql |
| 권한·시노님·메타·데이터 변경 | 없음 |
