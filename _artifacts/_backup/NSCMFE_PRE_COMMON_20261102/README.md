# 공통소스 다운로드 & 병합 회차 보고 — 2026-11-02 09:48

- 원천: remote `common` (https://gyucheollee297@github.com/eunjoo-hwang/nscm-fe.git) · push URL `no_push` 확인 — 푸시 없음
- 기준선 `916e9cb3b` → **신규 기준선 `0b6b4a75b`** (0b6b4a75b 2026-11-02 09:37 Jeongyun Park docs(SCP0101): Inventory Trend 통합 설계서·테스트케이스 생성)
- 공통 신규 커밋 41건 · 대상(apps·features·packages·public·configs) 변경 111건 (이름변경은 삭제+신규로 풀어 집계)
- 판정 = 내용 대조(개행·BOM 정규화) · 로컬이 공통 이력본과 일치하면 공통 채택, 내 편집본이면 유지/3-way(base = 로컬이 실제 출발한 공통 판본)

## 분류·처리 결과

| 구분 | 건수 | 처리 |
|---|---:|---|
| 수정(M) — 로컬 = 공통 이력본(무편집) | 105 | 공통 원문 적용 |
| 3-way 병합 — 충돌 0 | 2 | 병합본 적용 |
| d.ts 구조 병합 | 1 | 병합본 적용 |
| 3-way 충돌 1 → 로컬 유지(결정 대기) | 1 | 로컬 유지 |
| 로컬 부재 — 공통 수정 파일(결정 대기) | 1 | 로컬 유지 |
| 신규(A) — 로컬 부재 | 1 | 공통 원문 적용 |

적용 폴더별: supply 61 / shipping 26 / demand 13 / master 5 / shared 2 / configs 1 / foundation 1

## ⚠️ 결정 대기 2건 (로컬 유지 상태 — 자동 적용 안 함)

| 파일 | 사유 | 비고 | 자료 |
|---|---|---|---|
| `features/shipping/src/pages/inventory-raw/InventoryRaw.tsx` | 3-way 충돌 1 → 로컬 유지(결정 대기) | base 1f9db4908 | `conflicts/features/shipping/src/pages/inventory-raw/InventoryRaw.tsx.*` |
| `features/supply/src/pages/demand-exception/components/DemandExceptionForm.tsx` | 로컬 부재 — 공통 수정 파일(결정 대기) |  |  |

## `procedures.d.ts` 병합 (RawProcedureMap 메뉴 키 블록 단위)

| 처리 | 메뉴 키 |
|---|---|
| 동일 (95) | — |
| 로컬 유지 — 공통 무변경·내 편집 (10) | `DMF0035` · `DMF0082` · `SYS0016` · `SCM0002` · `DMF0049` · `DMF0044` · `SYS0017` · `SDM1010` · `SDM1020` · `SDM5010` |
| 공통 채택 — 로컬 = 기준선 (1) | `SSP0017` |
| 로컬 전용 유지 (3) | `SCP0013` · `DMF0013` · `DMF0068` |

검사: 멤버 수(로컬→병합) 107 → 107 / 중복 키 0 / declare global 1 / 로컬 키 유실 [] / 공통 키 유실 []

## 병합 적용

| 파일 | 구분 | 비고 |
|---|---|---|
| `features/supply/src/pages/bod/Bod.tsx` | 3-way 병합 — 충돌 0 | base 기준선 |
| `packages/foundation/src/utils/gridAction.ts` | 3-way 병합 — 충돌 0 | base 기준선 |

## 원복 자료
- `local_before/` — 덮어쓰거나 삭제한 로컬 원본
- `worktree_tracked.patch` — 적용 직전 nscm-fe 추적파일 전체 diff
- `git_status_before.txt` — 적용 직전 워킹트리 상태
- `conflicts/` — 결정 대기 파일의 base · common · merged(충돌 마커 포함) 사본

## 검증
- 공통 원문 적용 106건 — 개행 정규화 후 공통 원문과 불일치 0건
- 적용 파일 충돌 마커 잔존 0건
- 삭제 0건 — 잔존 0
- procedures.d.ts `declare global` 1건(기대 1)
- 정적검증(type-check/lint) **미수행** — 사용자 지시(요청 시만). 공통 신규 소스 ↔ 내 화면 소스 타입 불일치는 type-check 로 확인 필요
