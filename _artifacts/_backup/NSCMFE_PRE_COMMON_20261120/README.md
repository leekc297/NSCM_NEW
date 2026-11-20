# 공통소스 다운로드 & 병합 회차 보고 — 2026-11-20 11:28

- 원천: remote `common` (https://gyucheollee297@github.com/eunjoo-hwang/nscm-fe.git) · push URL `no_push` 확인 — 푸시 없음
- 기준선 `06e7d22de` → **신규 기준선 `c62b4200c`** (c62b4200c 2026-11-20 11:16 Jeongyun Park fix(SCP0011): 입력 차단·편집 잠금·조회조건 AS-IS 패리티)
- 공통 신규 커밋 40건 · FE 대상(nscm-fe: apps·features·packages·public·configs) 변경 167건 (이름변경은 삭제+신규로 풀어 집계)
- BE(nscm-be) 미포함 — 이번 실행 대상 아님(BE 는 --areas be 로 따로 받는다)
- ⚠ **DB MODE — 로컬 소스 보호 안 함**: 공통 최신 트리 기준으로 다른 파일은 내 편집본도 공통 원문으로 덮어쓴다 · 공통이 지운 파일은 삭제 · 공통에 없는 로컬 전용 파일은 유지

## 분류·처리 결과

| 구분 | 건수 | 처리 |
|---|---:|---|
| 동일 | 2613 | 변경 없음 |
| 공통 변경분 — 공통 원문 적용(로컬 보호 안 함) | 161 | 공통 원문 적용 |
| 로컬 전용(공통에 없음) — 유지 | 102 | 로컬 유지 |
| 공통 파일 — 로컬 부재 | 2 | 공통 원문 적용 |

적용 폴더별: supply 59 / master 42 / shipping 25 / demand 19 / shared 11 / foundation 5 / apps 1 / admin 1

## ⚠️ 결정 대기 0건 (로컬 유지 상태 — 자동 적용 안 함)

- 없음

## 원복 자료
- `local_before/` — 덮어쓰거나 삭제한 로컬 원본
- `worktree_tracked.patch` — 적용 직전 nscm-fe 추적파일 전체 diff
- `git_status_before.txt` — 적용 직전 워킹트리 상태
- `local_before/nscm-be/` · `be_worktree_tracked.patch` · `be_git_status_before.txt` — BE(nscm-be) 분
- `conflicts/` — 결정 대기 파일의 base · common · merged(충돌 마커 포함) 사본

## 검증
- 공통 원문 적용 163건 — 개행 정규화 후 공통 원문과 불일치 0건
- 적용 파일 충돌 마커 잔존 0건
- 삭제 0건 — 잔존 0
- procedures.d.ts `declare global` 1건(기대 1)
- 정적검증(type-check/lint) **미수행** — 사용자 지시(요청 시만). 공통 신규 소스 ↔ 내 화면 소스 타입 불일치는 type-check 로 확인 필요
