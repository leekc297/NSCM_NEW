# 공통소스 다운로드 & 병합 회차 보고 — 2026-11-10 08:57

- 원천: remote `common` (https://gyucheollee297@github.com/eunjoo-hwang/nscm-fe.git) · push URL `no_push` 확인 — 푸시 없음
- 기준선 `34052be28` → **신규 기준선 `900ffd6e3`** (900ffd6e3 2026-11-09 18:14 yongjun_kang style(SSP0026): weekendColorRef use-before-define 근본 해소(prettier-proof))
- 공통 신규 커밋 23건 · 대상(apps·features·packages·public·configs) 변경 38건 (이름변경은 삭제+신규로 풀어 집계)
- ⚠ **DB MODE — 로컬 소스 보호 안 함**: 공통 최신 트리 기준으로 다른 파일은 내 편집본도 공통 원문으로 덮어쓴다 · 공통이 지운 파일은 삭제 · 공통에 없는 로컬 전용 파일은 유지

## 분류·처리 결과

| 구분 | 건수 | 처리 |
|---|---:|---|
| 동일 | 2642 | 변경 없음 |
| 로컬 전용(공통에 없음) — 유지 | 98 | 로컬 유지 |
| 공통 변경분 — 공통 원문 적용(로컬 보호 안 함) | 37 | 공통 원문 적용 |
| 공통 삭제 — 로컬 삭제(로컬 보호 안 함) | 1 | 삭제 |

적용 폴더별: supply 15 / shipping 14 / apps 6 / demand 2

## ⚠️ 결정 대기 0건 (로컬 유지 상태 — 자동 적용 안 함)

- 없음

## 삭제 1건

- `apps/web/src/pages/BackdoorLogin.tsx`

삭제 파일을 가리키는 import 후보: 0건

## 원복 자료
- `local_before/` — 덮어쓰거나 삭제한 로컬 원본
- `worktree_tracked.patch` — 적용 직전 nscm-fe 추적파일 전체 diff
- `git_status_before.txt` — 적용 직전 워킹트리 상태
- `conflicts/` — 결정 대기 파일의 base · common · merged(충돌 마커 포함) 사본

## 검증
- 공통 원문 적용 37건 — 개행 정규화 후 공통 원문과 불일치 0건
- 적용 파일 충돌 마커 잔존 0건
- 삭제 1건 — 잔존 0
- procedures.d.ts `declare global` 1건(기대 1)
- 정적검증(type-check/lint) **미수행** — 사용자 지시(요청 시만). 공통 신규 소스 ↔ 내 화면 소스 타입 불일치는 type-check 로 확인 필요
