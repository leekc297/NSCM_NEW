# `_local_setup` — 클라우드 → 로컬 이관 직후 환경설정 자동화

> **트리거 명령** (Claude Code 대화 입력): `nscm-fe 일관 이관 후 local 환경설정`
> **수동 실행**: `powershell -ExecutionPolicy Bypass -File _artifacts\_local_setup\nscm-fe-post-import-setup.ps1`
> **작성일**: 2026-06-19

## 1. 배경 — 왜 이 자동화가 필요한가

사용자가 클라우드 (사내 GitLab/Nexus) 에서 `nscm-fe` 폴더를 **일괄 다운로드 (zip 또는 git pull)** 후 로컬에서 BE+FE 를 기동할 때, 다음 3 가지 환경 mismatch 사고가 항상 동일하게 재현되어 매번 수동 수정해야 했음:

| # | 사고 (브라우저/Vite 에러) | 원인 | fix |
|---|---|---|---|
| 1 | `Pre-transform error: _lruCache is not a constructor` | pnpm `shamefully-hoist=true` 가 root `node_modules\lru-cache\` 에 **v11.2.6** 을 hoist. `@babel/helper-compilation-targets@7.28.6` 가 `lru-cache@5.1.1` 의 default constructor 를 require 했으나 v11 의 named export `LRUCache` 만 노출돼 호출 실패 | `node_modules\@babel\helper-compilation-targets\node_modules\lru-cache\` 에 v5.1.1 (이미 `.pnpm` 캐시에 존재) 디렉터리 복사 → Node CommonJS resolve 가 nested 를 root hoisted 보다 먼저 찾음 |
| 2 | `Pre-transform error: jsTokens is not a function or its return value is not iterable` | 같은 hoist 패턴. root `js-tokens@4.0.0` (legacy default export 함수) 가 hoist. `strip-literal@3.1.0` 은 v9.0.1 의 named export `jsTokens` 기대 | `node_modules\strip-literal\node_modules\js-tokens\` 에 v9.0.1 (`.pnpm` 캐시) 복사 |
| 3 | 브라우저 콘솔: `localhost:3000/api/user/login` → `net::ERR_CONNECTION_REFUSED`. 로그인 fail | `apps/web/.env` 의 `VITE_PROXY_BASE_URL=http://localhost:3000/api` 가 **절대 URL hardcode**. Vite 를 5173 으로 띄우면 apiClient 가 3000 으로 호출 → vite proxy 우회 + 3000 listen 없음 | `apps/web/.env.local` (gitignored) 에 `VITE_PROXY_BASE_URL=/api` 상대경로 override. vite.config 의 `server.proxy` 가 `/api → http://localhost:8080` forward |

## 2. 이 자동화가 처리하지 않는 것

- `pnpm install` 자체 (Nexus 필요 — 그 시점엔 Nexus 가 살아있을 가능성). 위 fix 는 **`node_modules/` 가 이미 존재한다는 전제** 에서만 동작.
- BE (`nscm-be/`) 환경 변경 — BE 는 변경 절대 금지 룰 (`feedback_be_no_modification_rule.md`).
- Docker Oracle / 사내 Oracle 자체 (BE config 의 활성 jdbc-url 이 이미 사내 Oracle `121.162.245.167:2521/OCGSCMD_P01`).

## 3. 적용 후 확인

스크립트 종료 직후 BE + FE 기동 명령이 콘솔에 안내됨. 그대로 복붙해서 두 터미널에서 실행.

| 검증 | 기대값 |
|---|---|
| FE: `http://127.0.0.1:5173/` | 메인 페이지 렌더 (transform 에러 0) |
| FE log: `Pre-transform error` | 부재 |
| 브라우저 로그인 (ID `minyonglee1`) | 200 OK, 메뉴 트리 로드 |
| BE log: `PR_GET_NSCM_USER` | 호출 + `menus found` |
| BE log: `SCM_COM_SYS_LOG` LOGIN INSERT | 정상 audit |

## 4. 멱등 (idempotent) 동작

- v5.1.1 / v9.0.1 이 이미 nested 위치에 있으면 `[SKIP]`
- `.env.local` 이 이미 `VITE_PROXY_BASE_URL=/api` 를 포함하면 `[SKIP]`, 다른 값 포함 시 `.bak-yyyyMMdd-HHmmss` 백업 후 갱신
- 따라서 여러 번 실행해도 안전

## 5. 향후 fix 가 정식 해결되는 시점

이 자동화는 **임시 우회**이다. 정식 해결은 다음 중 하나 후 불필요:
- pnpm 의 `shamefully-hoist=true` 제거 (다른 deps 영향 검토 필요)
- `pnpm.overrides` 로 `lru-cache@5.1.1` 강제 + `@babel/helper-compilation-targets` 최신 (v7.29+: lru-cache v11 호환) 업그레이드
- `apps/web/.env` 의 `VITE_PROXY_BASE_URL` 을 상대경로 `/api` 로 정식 commit (Nexus 외부 빌드/배포 영향 검토 필요)

## 6. 파일 목록

| 파일 | 역할 |
|---|---|
| `nscm-fe-post-import-setup.ps1` | 메인 자동화 스크립트 (PowerShell) |
| `README.md` | 본 문서 (배경 + 검증 절차) |
