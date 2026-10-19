# DMF0005 조회 — Sold-To 행별 실행 제거 + Owner 이름 행별 재계산 차단 [E20261014-DMF0005SCONM]

- 대상 DB : 사내 ZIOUI1 (59.19.252.148:2521, SERVER_HOST=localhost) / SCM_MGR
- 사용자 승인 : 2026-10-14 "1, 2번 적용해주세요" (1 = 구조 보완, 2 = 힌트 `NO_PUSH_PRED(ONM)`)
- 선행 : `DMF0005_NOPUSH_20261014` (E20261014-DMF0005NOPUSH) — QA 적용 확인됨(11:38:25, C06 [P0])
- 클라우드 : 패치형 패키지 `_artifacts/_deploy_packages/DMF0005_SCONM_CLOUD_20261014/` — QA(OCGSCMQ_P01) 사용자 적용 · 속도 개선 사용자 확인 2026-10-14 (QA 측정 수치 미수령)

## 근거 (QA C06, NOPUSH 적용 뒤 2회차)

| 사업부 | 전체 | Sold-To(VW_DCL) 행별 | Owner 이름 행별 |
|---|---|---|---|
| 82 | 39.8s | 45,675회 · 23.8s | 45,675회 · 22.4s (인덱스 9,100만 행) |
| 81 | 36.8s | 48,229회 · 15.3s | 48,229회 · 32.4s (1억 3,800만 행) |
| 40 | 16.3s | 15,672회 · 12.5s | 15,672회 · 4.4s |

## 변경 (조회 프로시저 BASE, 2줄)

| 줄 | 전 | 후 |
|---|---|---|
| 140 | `        SELECT` | `        SELECT /*+ NO_PUSH_PRED(ONM) */    -- 2026.10.14 [마커] …` |
| 212 | `         AND (P_DIVISION_ID = '82' OR NVL(SC.VALID_YN, 'Y') = 'Y')` | 주석 처리 (`--` + 마커 원본) |

- 212행 제거 근거: 같은 ON 절 바로 위 `AND SC.VALID_YN = 'Y'` → 연결된 행에서 `NVL(SC.VALID_YN,'Y') = 'Y'` 는 항상 참 → OR 전체가 항상 참. 결과 동일.
  바인드가 섞인 이 조건 때문에 Sold-To 조인이 VW_DCL(행별 실행 형태)로 바뀌어 있었다 — 제거 뒤 사내 계획에서 VW_DCL 사라짐 확인.
- 140행 힌트: Owner 이름 구간은 QA 가 비용 판단으로 행별 반복을 고른 것 — 구문 변경으로 막을 근거 없음(hook #129 1~4 검토: 함수는 이미 Owner 종류별 1회 구조 · 인덱스 대상 아님).

## 실행 작업 ↔ 파일

| # | 시각 | 작업 | 파일 | 결과 |
|---|---|---|---|---|
| 1 | 12:11:30 | PKG_DMF0005 BODY 2줄 치환 | `01_PKG_DMF0005_BODY.sql` (`build_apply.py`, FRESH-GATE PASS · 기준 LAST_DDL 11:35:04) | VALID · 오류 0 · INVALID 63 → 63 |
| 2 | 12:13:41 | 클라우드 패치 리허설 — 99_ROLLBACK | 패키지 `A_DB/99_ROLLBACK_SCONM_PATCH.sql` | ROLLED BACK · VALID |
| 3 | 12:13:44 | 클라우드 패치 리허설 — 10_APPLY · 재실행 SKIP | 패키지 `A_DB/10_APPLY_SCONM_PATCH.sql` | APPLIED · VALID · 마커 2 |
| - | - | 원복 (미실행) | `00_BACKUP_PKG_DMF0005_BODY.sql` 또는 패키지 99 | - |

검증용 복제 패키지 PKG_DMF0005_V2A · V2B · V2C 는 생성 뒤 모두 DROP. 최종 DB 원문 = `01_PKG_DMF0005_BODY.sql` 일치 확인. SPEC · 권한 · 시노님 변경 없음.

## 검증

| 항목 | 결과 |
|---|---|
| 결과 동등성 (복제본 vs 적용 전 패키지, 사내 기본 설정) | **PASS** — 구조만(V2A) · 구조+힌트(V2C) 모두 시나리오 96 × 674,518행 행 · 값 · 순서 · 컬럼 동일, 0행 시나리오 0 (`_artifacts/_diagnostics/DMF0005_CLOUD_PERF_CHECK_20261014/_corp_equiv_V2A_out.txt` · `_corp_equiv_V2C_out.txt`) |
| 사내 90_VERIFY V3 | 82 0.64s · 81 0.77s · 40 0.61s |
| 사내 QA 조건 모사 | 82 2.08s · 81 1.82s · 40 0.91s · VW_DCL 0 (`_qa_condition_after_out.txt`) |
| 한계 | 사내는 QA 조건 모사에서도 두 구간을 해시 조인으로 처리 — QA 의 행별 반복은 재현되지 않음. QA 효과는 적용 뒤 C06 재측정으로 확인 |

## 남은 것

- ~~클라우드 QA 적용 (패치형)~~ — 사용자 적용 · 속도 개선 확인 (2026-10-14). QA C06 재측정 수치는 받지 못함
- 다른 클라우드 환경(DEV 등)에 같은 BODY 교체가 있었다면 NOPUSH → SCONM 순서로 같은 패치 필요
- 별건: QA BE 빌드에 `[E20260824-LOGPARAM]` 없음 — `SCM_COM_SQL_LOG.PARAMS` 조회 1회 15 ~ 39MB (QA C06 [P3])
