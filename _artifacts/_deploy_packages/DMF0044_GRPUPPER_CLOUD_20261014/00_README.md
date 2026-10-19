# DMF0044 조회 SQL ERROR (ALL · CUTOFF DATA) 보완 (클라우드 이관 · 패치형)

> 마커 `[E20261014-DMF0044GRPUPPER]` — PKG_DMF0044 BODY 조회 프로시저의 GROUP BY 3줄만 변경. 데이터·메타·화면 변경 없음.

| 항목 | 값 |
|---|---|
| 증상 | DMF0044 조회 — Data Type 이 ALL · CUTOFF DATA 이면 SQL ERROR, ETC 는 정상 |
| 원인 | CUTOFF DATA 구간의 Model Type 식이 SELECT(`UPPER(…)` 있음)와 GROUP BY(없음)에서 달라 ORA-00979 |
| 보완 | GROUP BY 3줄을 SELECT 와 같은 식으로 맞춤 |
| 사내 적용 | **완료** (ZIOUI1 2026-10-14 09:28 → 리허설 재적용 09:30:23) · [APPLIED_OPERATIONS.md](../../_apply_corporate/DMF0044_GRPUPPER_20261014/APPLIED_OPERATIONS.md) |
| 클라우드 | **미적용** |
| BE 재기동 · FE | 불요 |

## 실행 순서 (SCM_MGR, QA → DEV, 각 파일 전체 F5, 값 입력 없음)

| # | 파일 | 기대 |
|---|---|---|
| 1 | [A_DB/00_PRECHECK_CLOUD.sql](A_DB/00_PRECHECK_CLOUD.sql) | **검증 쿼리.** L1 오류 기록이 `ORA-00979 … "SINGLE"."ITEM_CLASS_NAME"` · L2 식 4줄 중 1번째만 'UPPER 있음' · L3 마커 0 |
| 2 | [A_DB/10_APPLY_GRPUPPER_PATCH.sql](A_DB/10_APPLY_GRPUPPER_PATCH.sql) | `APPLIED — PKG_DMF0044 BODY VALID · GROUP BY 3줄 보완` (이미 적용이면 `SKIP`, 구조가 다르면 ORA-20001 로 중단·원문 무변경) |
| 3 | [A_DB/90_VERIFY.sql](A_DB/90_VERIFY.sql) | V1 PASS(1) · V2 VALID/오류 0 · V3 1·2번째 줄 'UPPER 있음' |

롤백: [A_DB/99_ROLLBACK_GRPUPPER_PATCH.sql](A_DB/99_ROLLBACK_GRPUPPER_PATCH.sql) — 되돌리면 오류가 다시 난다.

적용 뒤 화면 확인: ALL · CUTOFF DATA 로 조회 → 90 을 다시 실행해 V4 에 적용 시각 이후 오류 기록이 없는지 본다.

## 주의
- **00 의 결과가 기대와 다르면 10 을 실행하지 않는다.** L1 의 오류가 ORA-00979 가 아니거나 L2 의 줄 구성이 다르면 클라우드 원문이 사내와 다른 것이다 → L1 · L2 결과 회신.
  (10 을 실행해도 구조가 다르면 가드로 중단하고 원문을 건드리지 않는다.)
- 원인은 사내에서 재현해 확인했다. 클라우드의 실제 오류 기록은 직접 보지 못했다 — 00 L1 이 그 확인이다.
- SELECT 3줄에 UPPER 를 넣은 변경(대소문자 무시 판정)은 그대로 둔다. 이 패치는 GROUP BY 를 거기에 맞춘다.
- ETC 구간은 SELECT · GROUP BY 모두 UPPER 가 없는 그대로다(오류 없음 · 무변경).
- 10 은 패키지 BODY 재생성이라 DMF0044 조회·저장 실행 중이면 대기 — 00 L4 확인 뒤 실행.

## 리허설 (사내 ZIOUI1 2026-10-14 09:30, `_rehearsal_out/`)
99(`ROLLED BACK … 마커 0`) → 00(L1 ORA-00979 4건 · L2 1번째만 UPPER · L3 0) → 10(`APPLIED`) → 10(`SKIP` 멱등) → 90(V1 PASS · V3 1·2번째 UPPER).
리허설 뒤 조회 호출 6케이스 재확인 PASS.

## 작업 ↔ 파일 대조
| 사내에서 한 일 | 파일 |
|---|---|
| PKG_DMF0044 BODY GROUP BY 3줄 변경 | A_DB/10_APPLY_GRPUPPER_PATCH.sql |
| 권한·시노님·메타·데이터 변경 | 없음 |
