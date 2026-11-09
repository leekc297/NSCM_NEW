# 공통소스 다운로드 & 병합 회차 보고 — 2026-11-09 13:22

- 원천: remote `common` (https://gyucheollee297@github.com/eunjoo-hwang/nscm-fe.git) · push URL `no_push` 확인 — 푸시 없음
- 기준선 `eaeb29174` → **신규 기준선 `34052be28`** (34052be28 2026-11-09 13:21 eunjoo_hwang docs(memory): 조회조건 열거-vs-ALL 누수 패턴 reference 추가)
- 공통 신규 커밋 195건 · 대상(apps·features·packages·public·configs) 변경 397건 (이름변경은 삭제+신규로 풀어 집계)
- ⚠ **DB MODE — 로컬 소스 보호 안 함**: 공통 최신 트리 기준으로 다른 파일은 내 편집본도 공통 원문으로 덮어쓴다 · 공통이 지운 파일은 삭제 · 공통에 없는 로컬 전용 파일은 유지

## 분류·처리 결과

| 구분 | 건수 | 처리 |
|---|---:|---|
| 동일 | 2239 | 변경 없음 |
| 공통 변경분 — 공통 원문 적용(로컬 보호 안 함) | 320 | 공통 원문 적용 |
| 로컬 전용(공통에 없음) — 유지 | 98 | 로컬 유지 |
| 공통 파일 — 로컬 부재 | 92 | 공통 원문 적용 |
| 로컬만 다름 — 공통 원문으로 복원(로컬 보호 안 함) | 29 | 공통 원문 적용 |
| 공통 삭제 — 로컬 삭제(로컬 보호 안 함) | 1 | 삭제 |

적용 폴더별: supply 200 / demand 84 / shipping 71 / master 48 / shared 10 / report 7 / admin 6 / apps 5 / foundation 5 / configs 2 / authority 2 / spms-demand 1

## ⚠️ 결정 대기 0건 (로컬 유지 상태 — 자동 적용 안 함)

- 없음

## 삭제 1건

- `features/supply/src/pages/waterfall-shipment-plan-semi/utils/waterfall-shipment-plan-semi.api.ts`

삭제 파일을 가리키는 import 후보: 0건

## 원복 자료
- `local_before/` — 덮어쓰거나 삭제한 로컬 원본
- `worktree_tracked.patch` — 적용 직전 nscm-fe 추적파일 전체 diff
- `git_status_before.txt` — 적용 직전 워킹트리 상태
- `conflicts/` — 결정 대기 파일의 base · common · merged(충돌 마커 포함) 사본

## 검증
- 공통 원문 적용 441건 — 개행 정규화 후 공통 원문과 불일치 0건
- 적용 파일 충돌 마커 잔존 0건
- 삭제 1건 — 잔존 0
- procedures.d.ts `declare global` 1건(기대 1)
- 정적검증(type-check/lint) **미수행** — 사용자 지시(요청 시만). 공통 신규 소스 ↔ 내 화면 소스 타입 불일치는 type-check 로 확인 필요
