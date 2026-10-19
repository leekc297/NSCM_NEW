# DMF0082 저장 — 신규 행은 Sales Site Project Model(SSPM) 4키 등록 필수 (클라우드 이관 · 패치형)

> 마커 `[E20261013-DMF0082SSPMNEW]` — PKG_DMF0082 BODY `P_DMF0082_SAVE_MAIN_DATA` 의 검증 #5 뒤에 5-1 블록 1개 삽입. 기존 문장·데이터·메타·화면 변경 없음.

| 항목 | 값 |
|---|---|
| 요청 (2026-10-13) | DMF0082 신규 ROW 추가·저장 시 SSPM 기준 VALIDATION. 대상 = 신규 행만 (사용자 확정) |
| 종전 | 검증 #5·#17 은 마스터(`SCM_MST_SITE_ITEM`)를 Division + Sales Site + Model 3키로만 본다. Project 미검사 — 다른 Project 로만 등록된 조합도 신규 입력·저장됨. AS-IS `DMF0082_SAVE_MAIN_DATA`(LGCE_SCMDEV 06-12 본) 도 같은 3키 |
| 보완 | 신규 행(`ACTION='I'`)은 Division · Project · Sales Site · Model 4키가 `VALID_YN='Y'` 로 등록돼 있어야 저장. 없으면 아래 메시지로 차단. AS-IS 대비 신규 행 한정 의도적 강화 |
| 메시지 | `Project : … / Sales Site : … / Model : …` + `Sales Site Project Model 에 등록되지 않은 조합입니다.` + `Sales Site Project Model 에 등록 후 입력하시기 바랍니다.` |
| 달라지지 않는 것 | 기존 행 수정·삭제 저장 (종전 #5 3키 그대로) · 조회 · Excel Upload 경로 (별도 SP — 이번 범위 밖) |
| Project 빈값 표기 | 마스터 `'-'`(기존)·`'/'`(신규 기본값), 저장 입력 기본값 `'-'` — 표기만 다른 것은 같은 값으로 본다. 실값끼리는 등호 |
| 적용 Division | 저장 SP 가 처리하는 전 Division (40 · 81 계열). 82 는 원래 저장 불가 |
| 사내 적용 | **완료** (ZIOUI1 2026-10-13 00:18 → 리허설 재적용 00:22:20) · 검증 9케이스 + 저장 SP 실호출 차단 확인 · [APPLIED_OPERATIONS.md](../../_apply_corporate/DMF0082_SSPMNEW_20261013/APPLIED_OPERATIONS.md) |
| 클라우드 | **미적용** |
| BE 재기동 · FE | 불요 |

## 실행 순서 (SCM_MGR, QA → DEV, 각 파일 전체 F5, 값 입력 없음)

| # | 파일 | 기대 |
|---|---|---|
| 1 | [A_DB/00_PRECHECK_CLOUD.sql](A_DB/00_PRECHECK_CLOUD.sql) | L1 앵커 `N=1 PASS` · L2 마커 0 · L5 실행 중 세션 없음 |
| 2 | [A_DB/10_APPLY_SSPMNEW_PATCH.sql](A_DB/10_APPLY_SSPMNEW_PATCH.sql) | `APPLIED — PKG_DMF0082 BODY VALID · 마커 1곳` (이미 적용이면 `SKIP`, 앵커 ≠1 이면 ORA-20001 로 중단·원문 무변경) |
| 3 | [A_DB/90_VERIFY.sql](A_DB/90_VERIFY.sql) | V1 PASS · V2 VALID/오류 0 · V4 `PASS — 5-1 검증으로 차단 · 원장 0 → 0` |

롤백: [A_DB/99_ROLLBACK_SSPMNEW_PATCH.sql](A_DB/99_ROLLBACK_SSPMNEW_PATCH.sql)

## 주의
- **적용 순서**: 같은 BODY 를 고치는 `DMF0082_MANDCOL_CLOUD_20261012` 와는 서로 다른 구간이라 순서 무관. 각각 자기 앵커만 본다.
- 90 의 V4 는 저장 SP 를 실제로 1회 호출한다. 마스터에 없는 Project(`ZZ_SSPMNEW_TEST`)의 신규 행이라 검증에서 막혀 저장되지 않는다. 마커가 없으면(미적용) 호출하지 않는다. 호출 전후 원장 건수를 확인해 출력한다.
- V4 가 `CHECK` 면 저장은 막혔지만 5-1 보다 앞선 검증(#1~#5)에서 먼저 걸린 것 — 출력된 문구를 회신.
- 00 의 L3 는 참고용이다. 신규 행만 검증하므로 기존 원장 키는 수정·삭제 저장이 막히지 않는다.
- 10 은 패키지 BODY 재생성이라 조회·저장 실행 중이면 대기 — 00 L5 확인 뒤 한가할 때 실행.

## 리허설 (사내 ZIOUI1 2026-10-13 00:22, `_rehearsal_out/`)
99(역치환 → 마커 0 · VALID) → 00(L1 PASS · L2 0) → 10(`APPLIED … 마커 1곳`) → 00(L2 1) → 90(V1 PASS · V4 PASS 원장 0 → 0). 미적용 상태의 90 은 `V4 SKIP` 확인.
첫 리허설에서 00 의 L1 판정문이 사내 실행기에서 오류(문자열 안의 `--` 를 주석으로 잘라 문장이 합쳐짐) → 판정문에서 `--` 리터럴을 없애 재검증했다.

## 작업 ↔ 파일 대조
| 사내에서 한 일 | 파일 |
|---|---|
| PKG_DMF0082 BODY 5-1 블록 삽입 | A_DB/10_APPLY_SSPMNEW_PATCH.sql |
| 권한·시노님·메타·데이터 변경 | 없음 |
