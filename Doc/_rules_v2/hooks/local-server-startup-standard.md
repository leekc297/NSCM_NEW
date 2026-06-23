# Hook — 로컬 서버 기동 표준 (pnpm 금지)

> **트리거**: 사용자가 "서버 기동" / "FE 띄워" / "로컬 시작" / "BE 띄우기" 등 요청 시
> **PR 차단 강도**: ⭐ (운영 안전 + 사용자 워크플로 정합)
> **신설일**: 2026-06-22 (사용자 명시 — "local 에서는 pnpm 은 실행하지 않습니다")

작성: 2026-06-22
상위 룰: `anti-simplification.md` — 표준 명령 cross-check 의무
관련 메모리: `feedback_local_startup_command.md` / `feedback_nscm_fe_post_import_local_setup.md`

---

## §0. 사용자 명시 (2026-06-22)

> "local 에서는 pnpm 은 실행하지 않습니다."

CLAUDE.md §8 의 일반 가이드 표 (`pnpm local`) 는 **로컬 실제 절차 아님** — 참조 금지.

---

## §1. 로컬 표준 기동 명령

```
BE: cd /d C:\Projects\NSCM\nscm-be && gradlew.bat bootRun --args="--spring.profiles.active=local"

FE: cd /d C:\Projects\NSCM\nscm-fe\apps\web && node_modules\.bin\vite.cmd --port 5173 --host 127.0.0.1
```

접속: `http://127.0.0.1:5173/` (사용자 ID: `minyonglee1`)

단일 출처: `_artifacts/_local_setup/nscm-fe-post-import-setup.ps1` L126-127

---

## §2. 금지 행위

| # | 금지 | 사유 |
|---:|---|---|
| 1 | ❌ `pnpm local` / `pnpm dev` / `pnpm start` (FE) | turbo daemon + shamefully-hoist 사이드이펙트 → lru-cache / js-tokens transform error 재현 위험 |
| 2 | ❌ `cd nscm-fe && ...` (root 에서 시작) | FE 는 `apps/web/` 안에서 직접 vite 실행이 표준 |
| 3 | ❌ `./gradlew bootRun` (profile 미지정) | `--spring.profiles.active=local` 미지정 시 default profile → 사내 Oracle 미연결 |
| 4 | ❌ CLAUDE.md §8 의 `pnpm local` 표 인용 | 일반 가이드 — 로컬 실제 절차 아님 |

---

## §3. 사용자 요청 패턴별 응답

| 사용자 입력 | AI 응답 |
|---|---|
| "서버 기동해주세요" | FE/BE 어느 쪽인지 확인 후 §1 명령 그대로 제시 |
| "둘 다" / "BE+FE" | §1 의 2 명령 (BE + FE) 동시 안내 |
| "FE 만" / "프론트만" | §1 의 FE 명령만 |
| "BE 만" / "백엔드만" | §1 의 BE 명령만 |
| "로컬 환경설정" / "nscm-fe 일관 이관 후 local 환경설정" | `_artifacts/_local_setup/nscm-fe-post-import-setup.ps1` 실행 안내 (선행) |

---

## §4. 백그라운드 실행 (Claude Code 도구 활용)

`Bash` 도구의 `run_in_background: true` 로 두 명령 동시 시작 가능:

```bash
# Background BE
cd /c/Projects/NSCM/nscm-be && ./gradlew.bat bootRun --args="--spring.profiles.active=local"

# Background FE
cd /c/Projects/NSCM/nscm-fe/apps/web && ./node_modules/.bin/vite.cmd --port 5173 --host 127.0.0.1
```

각각 background ID 부여 → 로그 file path 통해 `Tomcat started on port 8080` / `VITE ready` 신호 확인.

---

## §5. 사고 카탈로그 (회귀 방지)

### 5.1 2026-06-22 — CLAUDE.md §8 인용 사고

AI 가 CLAUDE.md §8 의 `pnpm local` 일반 표만 보고 추천 → 사용자 명시 거부 ("local 에서는 pnpm 은 실행하지 않습니다") → 강력 룰 요청.

**근본 원인**: AI 가 일반 가이드와 로컬 실제 절차 (`_artifacts/_local_setup/` 표준) 를 구분하지 않음.

**Fix**: 본 hook 으로 격리 + `feedback_local_startup_command.md` 메모리 등재.

---

## §6. 사후 검증

기동 후 다음 신호 확인:

| 서버 | 신호 | 시간 |
|---|---|---|
| BE | `Tomcat started on port 8080 (http)` | ~50초 (사내 Oracle 연결 포함) |
| FE | `VITE v6.4.1 ready in XXXXms` + `http://127.0.0.1:5173/` | ~3초 |

브라우저 → `http://127.0.0.1:5173/` → 로그인 (`minyonglee1`) → 메뉴 트리 로드 정상 시 기동 완료.

---

## §7. 관련 자동화

- `_artifacts/_local_setup/nscm-fe-post-import-setup.ps1` — 클라우드 → 로컬 이관 직후 환경설정 (3 fix 멱등)
- `_artifacts/_local_setup/regression-impact.ps1` — 작업 종료 직전 의무 실행 (룰 #62)
