# 00_ENV — Vibe_Manager 환경 단일 출처 (2026-10-19 이관)

> 원천: `Doc/_rules_v2/hooks/local-server-startup-standard.md`(#79) · `.claude/hooks/block-dev-commands.ps1` · `Doc/_dev_rules/21_TROUBLESHOOTING.md §8.5` · `tools/*/\*.json` · 2026-10-19 실측.
> 이 파일과 `env.json` 이 Vibe_Manager·하네스·E2E 가 보는 **유일한 환경 정의**다. CLAUDE.md §8 의 `pnpm local` 표는 로컬 절차가 아니다(참조 금지).

## 1. 용어
- **Local** = 지금 쓰는 노트북(`C:\Projects\NSCM`). Claude 사용 가능, Git·Nexus 접근 불가, As-is MSSQL·To-Be Oracle 접속 가능(2026-10-16~).
- **클라우드** = LGES 클라우드. Git·Nexus·Oracle 전부 가능, Claude 사용 불가. `pnpm install/lint/type-check/build` 는 여기서만.

## 2. 로컬 서버 기동 (사용자 명시 2026-06-22 "local 에서는 pnpm 은 실행하지 않습니다")
| 서버 | 명령 | 주소 / 신호 |
|---|---|---|
| BE | `cd /d C:\Projects\NSCM\nscm-be && gradlew.bat bootRun --args="--spring.profiles.active=local"` | `http://localhost:8080` · `Started ScpApplication in ~24s` · dev-login(`/sso/dev-login?id=`)은 **local/dev 프로파일에서만** 활성 |
| FE | `cd /d C:\Projects\NSCM\nscm-fe\apps\web && node_modules\.bin\vite.cmd --port 5173 --host 127.0.0.1` | `http://127.0.0.1:5173/` · `VITE ready` · `/api` → 8080 프록시(`.env.local`) |
- 로그인 계정: `minyonglee1`. (E2E `forceAccount` 동일)
- 금지: `pnpm local|dev|start|install|i|lint|type-check|build|update|add|remove`, `pnpm run <위>`, `turbo run dev|lint`, `eslint <path>`, 저장소 안 `npm install`/`npx`, `nscm-fe` 루트에서 vite 시작, 프로파일 없는 `gradlew bootRun`(default → 사내 Oracle 미연결). 의도적 우회만 `ALLOW_PNPM=1` prefix.
- 로컬 FE 보강(21_TROUBLESHOOTING §8.5): `apps/web/.env.local` `VITE_API_TIMEOUT=600000`, BE `config-local.yml` HikariCP maxPoolSize 30. BE 재시작 후 브라우저는 시크릿 창 재로그인.

## 3. 정적 검증 (로컬·오프라인)
- 하네스 게이트 `check.js --final` 은 `nscm-fe\node_modules\typescript\bin\tsc` 와 `eslint\bin\eslint.js` 를 **node 로 직접 실행**한다(pnpm·turbo 미경유, 네트워크 0). tsc 24~156초.
- lint 최종 판정은 클라우드(사용자 2026-06-17). 로컬 L01 은 "참고 등급"이며 BLOCK 으로 올리지 않는다. BE 는 `gradlew spotlessApply/build/test` 도 클라우드에서.
- E2E 는 `tools\E2E\node_modules`(VM 에서 설치해 복사한 순수 JS) + 설치된 Chrome(`channel:'chrome'`, `E2E_CHANNEL=msedge` 대체). Playwright 브라우저 다운로드 금지.

## 4. DB
| 구분 | 접속 | 정책 |
|---|---|---|
| As-is MSSQL (GSCM) | `.env.asis` `ASIS_DB_*` | **readOnly**. Grid SP 실행은 트랜잭션 + 항상 ROLLBACK, 실패는 `grid_runs.csv` 기록 후 계속 |
| To-Be Oracle (ZIOUI1 / SCM_MGR) | `.env.asis` `TOBE_DB_*` | `run_sql.py` 기본 ROLLBACK, `--commit` 명시 시만 반영. PKG(DDL)는 미리보기도 생성됨. 등록은 `<ID>_registration.sql`, 되돌리기 `<ID>_revert.sql` |
| 로컬 Docker Oracle (XE, 12GB 한도) | 별도 | Vibe_Manager 대상 아님(21_TROUBLESHOOTING §8/§10 참조) |
- 비밀번호는 출력·저장·주석 금지(`describe()/mask()`). 운영 DB 적용은 사용자 승인 절차(T18)로만.

## 5. Claude 호출 (하네스)
- `claude -p` 프롬프트는 **stdin** 으로 전달(Windows 인용 깨짐 방지), `--allowedTools Read,Edit,Write,Glob,Grep,Bash(node *),Bash(dir *),Bash(ls *),Bash(type *),Bash(cat *)`, 45분 타임아웃, 환경변수 `VIBE_HARNESS=1`.
- `VIBE_HARNESS=1` 이면 `.claude/hooks/check-rules-read.ps1`·`attach-context.ps1` 은 통과(exit 0) — 대신 룰은 `tools/VibeManager/rules/10_RULES_KEEP.md` 로 프롬프트에 주입. `block-dev-commands` 등 차단 hook 은 그대로 유효.
- Git bash 기동 시 `add_item ... errno 1` 경고는 Git for Windows(Cygwin) 일회성 — 무시.

## 6. 경로
| 항목 | 경로 |
|---|---|
| 도구 | `tools\AsisFacts` · `tools\TobeFacts` · `tools\Recon` · `tools\Harness` · `tools\DbConn` · `tools\E2E` · `tools\VibeManager` |
| 산출 | `Doc\asisfacts` · `Doc\tobefacts`(framework·db 카탈로그) · `Doc\recon` · `Doc\gap` · `Doc\gen\<ID>` · `Doc\e2e` · `Doc\golden` |
| 설정 | `tools\Harness\harness.json` · `tools\E2E\e2e.config.json` · `tools\AsisFacts\asisfacts.json` · `tools\TobeFacts\tobefacts.json` · `.env.asis` |
| 이력 | `.vibe\runs.log` · `.vibe\reports\` · `Doc\gen\_repair_summary.csv` |
| 백업 | 수정 파일 옆 `*.bak_YYYYMMDD` |
