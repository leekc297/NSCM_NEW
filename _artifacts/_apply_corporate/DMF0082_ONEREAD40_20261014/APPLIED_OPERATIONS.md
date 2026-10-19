# DMF0082_ONEREAD40_20261014 — 40 수요·판가 원장 1회 읽기 (사내 적용)

- 마커: `[E20261014-DMF0082ONEREAD40]` (4곳) · 대상: `SCM_MGR.PKG_DMF0082` PACKAGE BODY → `P_DMF0082_GET_MAIN_DATA` 40 경로
- 사용자 승인: 2026-10-14 "네..진행해주세요" (조건 미지정 조회 병목 = 같은 원장 2회 읽기). 범위는 클라우드 상위 4문장인 40 수요·판가부터.

## 1. 실행한 작업 (전부)
| # | 시각 | 작업 | 파일 |
|---|---|---|---|
| 1 | 17:26 | 기준 원문 재조회 (localhost · BODY LAST_DDL 16:34:07 · RLXPRE 적용본) | `PKG_DMF0082_BODY.ASIS.sql` |
| 2 | 17:36 | build — 재조회 → 백업/적용본 (+27줄, 4구간) | `00_BACKUP_*` · `01_*` · `_fresh_state.json` · `_diff.txt` |
| 3 | 17:38~17:41 | 적용 전 기준값 15케이스 | `_before.pkl` · `_before.log` |
| 4 | 17:42:14 | **apply** — FRESH-GATE PASS → CREATE OR REPLACE | `build_apply.py apply` |
| 5 | 17:43~17:46 | 적용 후 15케이스 비교 | `_after.pkl` · `_after.log` |
| 6 | 17:52~17:53 | 클라우드 패키지 리허설(99 원복 17:52:56 → 10 재적용 17:53:02) — 최종 md5 = 적용본 `022632127b8baa04f7696b5c54b3674e` | `_deploy_packages/DMF0082_ONEREAD40_CLOUD_20261014/_rehearsal_out/` |
- 권한·시노님·통계·메타 변경 없음. 원장 DML 없음. 원복 = `00_BACKUP_PKG_DMF0082_BODY.sql`(LAST_DDL 16:34:07 본) 또는 클라우드 패키지 `99_ROLLBACK`.

## 2. 결과
- FRESH-GATE PASS · DB==TOBE · 마커 4 · VALID · USER_ERRORS 0 · SCM_MGR INVALID 63 → 63.
- **전후 15/15 PASS** (반환 커서 6개 전행 해시, RC3 시각 제외). 측정 사이 원장 변경 없음(감시 6원장).
- `T_LAST_DATA_SETUP_FCST` 행수: Current 케이스 전부 동일(실적 arm 이 읽는 GTT 보존). 40-MF-T 232 → 0 = 버전 조회는 이 GTT 를 쓰지 않아 적재 생략(설계대로, 결과 동일).
- 논리 읽기: 40 수요 20,616 → 10,453 (−49%) · 40 판가 81,641 → 53,367 (−35%).
- 벽시계(사내, 캐시 상태): 거의 같음 — 40-ALL 6.79 → 6.91s. 판가 문장 0.50 → 0.67s(윈도 정렬 CPU). **클라우드 판정 대기** (#129 §12.2: 클라우드 악화 시 원복).

## 3. 클라우드
- 패키지 `_artifacts/_deploy_packages/DMF0082_ONEREAD40_CLOUD_20261014/` — **클라우드 QA 적용 완료 (BODY LAST_DDL 17:59:06, 사용자 실행)**.
  - 90_VERIFY: V1 마커 4 PASS · V2 VALID·오류 0·의존 INVALID 0 · V3 5줄 PASS.
  - V4(18:02, 9회 평균): 40 수요 INSERT ALL 4.34s(IO 2.89) vs 적용 전 2문장 합 5.74s → **−1.40s(−24%)** · 40 판가 ONEREAD 3.81s(IO 1.78) vs 적용 전 3.79s → **변화 없음**(읽기 감소분을 넓은 읽기 구간·윈도 정렬이 상쇄). 합계 9.53 → 8.15s(−15%). 악화 아님 → 유지.
  - 비교 한계: 적용 직후 콜드 포함 9회 · 적용 전 값은 다른 시점 평균(G03) — 방향 판정용.
