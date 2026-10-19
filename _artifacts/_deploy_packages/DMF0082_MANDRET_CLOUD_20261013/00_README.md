# DMF0082 조회 — 화면 필수 표시 컬럼은 Column Set 과 무관하게 항상 반환 (클라우드 이관 · 패치형)

> 마커 `[E20261013-DMF0082MANDRET]` — PKG_DMF0082 BODY 조회 프로시저 2종에 루프 1개씩 삽입. 기존 문장·데이터·메타·화면 변경 없음.

| 항목 | 값 |
|---|---|
| 증상 | AS From Site 를 필수 표시로 바꾼 뒤 컬럼은 보이는데 값이 빈칸 (QA 10-13, minyonglee1) |
| 원인 | 화면은 필수 컬럼을 항상 표시하는데, 조회 SP 는 사용자 Column Set 저장 내역에 있는 컬럼과 저장 키 12컬럼만 내려줬다 |
| 규칙 (사용자 확정) | Column Set 저장 내역에 없어도 `USER_SELECTABLE_FLAG = 'N'` 인 컬럼은 사업부만 맞으면 항상 조회 |
| 보완 | 컬럼 메타에서 필수 컬럼(`VALID_YN='Y'` · `USER_SELECTABLE_FLAG='N'` · `VISIBLE_FLAG='Y'` · 사업부 일치)을 읽어 결과에 항상 포함 |
| 달라지지 않는 것 | 그 컬럼을 이미 Column Set 에 넣은 사용자의 결과 · 대상 사업부가 아닌 조회(예: AS From Site 의 40) · 저장 |
| 사내 적용 | **완료** (ZIOUI1 2026-10-13 17:45 → 리허설 재적용 17:48:59) · [APPLIED_OPERATIONS.md](../../_apply_corporate/DMF0082_MANDRET_20261013/APPLIED_OPERATIONS.md) |
| 클라우드 | **미적용** |
| BE 재기동 · FE | 불요 |

## 실행 순서 (SCM_MGR, QA → DEV, 각 파일 전체 F5, 값 입력 없음)

| # | 파일 | 기대 |
|---|---|---|
| 1 | [A_DB/00_PRECHECK_CLOUD.sql](A_DB/00_PRECHECK_CLOUD.sql) | L1 앵커 `N=2 PASS` · L2 마커 0 · L3 필수 컬럼 목록 · L4 실행 중 세션 없음 |
| 2 | [A_DB/10_APPLY_MANDRET_PATCH.sql](A_DB/10_APPLY_MANDRET_PATCH.sql) | `APPLIED — PKG_DMF0082 BODY VALID · 마커 2곳` (이미 적용이면 `SKIP`, 앵커 ≠2 이면 ORA-20001 로 중단·원문 무변경) |
| 3 | [A_DB/90_VERIFY.sql](A_DB/90_VERIFY.sql) | V1 PASS(2) · V2 VALID/오류 0 · V3 삽입 줄 · V4 필수 컬럼 목록 |

롤백: [A_DB/99_ROLLBACK_MANDRET_PATCH.sql](A_DB/99_ROLLBACK_MANDRET_PATCH.sql) — 되돌리면 필수 컬럼이 저장 내역에 없는 사용자에게 다시 빈칸으로 나온다.

적용 뒤 화면 확인: Column Set 에 AS From Site 를 넣지 않은 계정으로 81 또는 82 를 조회해 값이 보이는지 본다. 원장에 값이 있는 품목으로 확인한다(값이 없는 품목은 빈칸이 정상).

## 주의
- **패치형이다.** 클라우드 원문을 읽어 저장 키 루프 뒤 2곳에만 끼워 넣는다. 앵커가 2건이 아니거나 두 조회 프로시저 순서와 다르면 원문을 건드리지 않고 중단한다 → 00 의 L1 결과를 회신.
- **컬럼 이름을 SP 에 적지 않았다.** 메타에서 다른 컬럼을 필수로 바꾸면 그 컬럼도 같은 규칙으로 항상 내려간다. 단 조회 결과의 원천 임시 테이블에 있는 컬럼만 대상이다(없는 컬럼은 건너뛴다 — 00 의 L3 `JUDGE` 로 확인).
- **행 묶음이 달라질 수 있다.** 결과에 들어간 컬럼은 묶음 기준에도 들어간다. AS From Site 값이 서로 다른 행은 따로 나온다 — 이 컬럼을 Column Set 에 넣은 사용자가 지금 보는 모습과 같다.
- 같은 BODY 를 고치는 `DMF0082_MANDCOL_CLOUD_20261012` · `DMF0082_SSPMNEW_CLOUD_20261013` · `DMF0082_ADJYNALL_CLOUD_20261013` 과는 구간이 달라 적용 순서 무관.
  오전에 사내에 적용한 `[E20261013-DMF0082DEFFLAGN]`(시스템 컬럼 DEFAULT_FLAG 내성)은 클라우드 패키지를 아직 만들지 않았다 — 이 패치와 무관하게 동작한다.
- 10 은 패키지 BODY 재생성이라 DMF0082 조회·저장 실행 중이면 대기 — 00 L4 확인 뒤 한가할 때 실행.

## 리허설 (사내 ZIOUI1 2026-10-13 17:48, `_rehearsal_out/`)
99(`ROLLED BACK … 마커 0`) → 00(L1 2건 PASS · L2 0) → 90(V1 미적용) → 10(`APPLIED … 마커 2곳`) → 10(`SKIP` 멱등) → 90(V1 PASS) → 00(L2 2).
리허설 뒤 전후 비교 12케이스 재실행 PASS.

## 작업 ↔ 파일 대조
| 사내에서 한 일 | 파일 |
|---|---|
| PKG_DMF0082 BODY 2곳 삽입 (조회 프로시저 2종) | A_DB/10_APPLY_MANDRET_PATCH.sql |
| 권한·시노님·메타·데이터 변경 | 없음 (AS From Site 메타를 필수로 바꾸는 것은 사용자가 사내·클라우드에 직접 완료) |
