# 공통소스 다운로드 & 병합 회차 보고 — 2026-11-12 09:15

- 원천: remote `common` (https://gyucheollee297@github.com/eunjoo-hwang/nscm-fe.git) · push URL `no_push` 확인 — 푸시 없음
- 기준선 `0d7ec9fc7` → **신규 기준선 `1d476295b`** (1d476295b 2026-11-12 08:25 Youngho Ha fix(SCP0134): 그리드 버튼 액션 저장 시 전역 프로그래스 스피너 표시)
- 공통 신규 커밋 16건 · 대상(apps·features·packages·public·configs) 변경 25건 (이름변경은 삭제+신규로 풀어 집계)
- ⚠ **DB MODE — 로컬 소스 보호 안 함**: 공통 최신 트리 기준으로 다른 파일은 내 편집본도 공통 원문으로 덮어쓴다 · 공통이 지운 파일은 삭제 · 공통에 없는 로컬 전용 파일은 유지

## 분류·처리 결과

| 구분 | 건수 | 처리 |
|---|---:|---|
| 동일 | 2682 | 변경 없음 |
| 로컬 전용(공통에 없음) — 유지 | 98 | 로컬 유지 |
| 공통 변경분 — 공통 원문 적용(로컬 보호 안 함) | 25 | 공통 원문 적용 |

적용 폴더별: supply 16 / demand 6 / report 1 / shipping 1 / shared 1

## ⚠️ 결정 대기 0건 (로컬 유지 상태 — 자동 적용 안 함)

- 없음

## 원복 자료
- `local_before/` — 덮어쓰거나 삭제한 로컬 원본
- `worktree_tracked.patch` — 적용 직전 nscm-fe 추적파일 전체 diff
- `git_status_before.txt` — 적용 직전 워킹트리 상태
- `conflicts/` — 결정 대기 파일의 base · common · merged(충돌 마커 포함) 사본

## 검증
- 공통 원문 적용 25건 — 개행 정규화 후 공통 원문과 불일치 0건
- 적용 파일 충돌 마커 잔존 0건
- 삭제 0건 — 잔존 0
- procedures.d.ts `declare global` 1건(기대 1)
- 정적검증(type-check/lint) **미수행** — 사용자 지시(요청 시만). 공통 신규 소스 ↔ 내 화면 소스 타입 불일치는 type-check 로 확인 필요
