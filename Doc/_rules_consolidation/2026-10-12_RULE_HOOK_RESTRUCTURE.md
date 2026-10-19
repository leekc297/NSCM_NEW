# NSCM 룰/Hook 체계 정리 보고서 — 2026-10-12 `[E20261012-RULES-RESTRUCTURE]`

> 목적: "간단한 질문은 빠르게, 복잡한 작업은 누락 0" 을 **구조**로 달성. 룰 내용은 1건도 삭제하지 않았다 — 로딩 시점(계층)만 바꿨다.
> 롤백: §6. 검증: `powershell -File scripts\rules\verify_hooks.ps1`.

## 1. 실측 인벤토리 (2026-10-12, C:\Projects\NSCM)

| 구분 | 실측 | 비고 |
|---|---:|---|
| 루트 `CLAUDE.md` (상시 로딩) | **20,153 B** | 매 턴 로드. 내용의 70% 가 "다른 파일을 Read 하라"는 포인터 + 변경 이력 |
| 매 작업 "필독" 지정 3파일 | anti-simplification 18,246 + **RULESET_MASTER 159,319** + **00_INDEX 152,297** = **329,862 B** | ≈ 한국어 혼합 기준 **110~160K 토큰**. CLAUDE.md §2 Step 1 이 "모든 작업" 에 요구 |
| 문서 hook `Doc/_rules_v2/hooks/*.md` | **153 파일 / 1,467,516 B** | MASTER 상단 표기 152, §4 헤더 142, hooks/README 69 — **4곳 모두 다른 수** |
| `_rules_v2` 전체 md | 3.4 MB (`_dictionary` 943KB 포함) | |
| 실행 hook 스크립트 `.claude/hooks/*.ps1` | **8종 → 9종**(신설 포함) | README 는 "5종" 표기 (drift) |
| `attach-context.ps1` 키워드 첨부량 | SQL/DB 키워드 ≈ 38KB · **화면/Grid/Form/import 키워드 ≈ 205KB** · 신규 화면 ≈ 275KB · 보완 ≈ 232KB | "화면"·"DB"·"import"·"Form"·"이벤트" 한 단어만 있어도 **MASTER 159KB 전문**이 매 프롬프트 주입 |
| `.claude/rules/`, `skills/`, 하위 `CLAUDE.md` | 없음 | 경로 한정 로딩 메커니즘 미사용 |
| `.claude/commands/단위테스트.md` | 1종 | 유지 |

### 느려진 원인 (정량)
"DMF0043 화면의 X 컬럼 타입이 뭐야?" 한 줄 질문 → ① CLAUDE.md 20KB (상시) + ② attach-context 가 "화면" 매칭 → MASTER 159KB + hook 2종 46KB 주입 + ③ CLAUDE.md 가 지시한 anti-simplification·MASTER·00_INDEX Read 330KB. **질문 1개에 500KB+ 컨텍스트** → 응답 지연. 동시에 룰이 많아져 개별 룰이 묻히는 역효과(누락 걱정의 실체).

## 2. 발견 사항 (정리 전 상태의 결함)

| # | 발견 | 영향 | 조치 |
|---|---|---|---|
| F1 | hook 카운트 drift: 디스크 153 / MASTER 상단 152 / MASTER §4 헤더 142 / README 69 | "카운트 단일 소스" 정책(R-2) 자체가 깨짐 | `build_router.py --check` 가 자동 검출. **MASTER 상단·§4 헤더·00_INDEX §B.3 를 153 으로 정정 필요(미수행 — 정본 수정은 사용자 확인 후)** |
| F2 | MASTER §0 "카운트 단일 소스" 문단이 **1단락 11KB** 의 변경 이력 덩어리 | 라우팅 정보(§2)가 이력에 묻힘 | §2/§2.5/§7 만 `TRIGGER_ROUTER.md` 로 추출 |
| F3 | attach-context 가 MASTER 전문을 키워드마다 첨부 | 속도 저하 주범 + lost-in-the-middle | v3: 추출본 14KB 로 교체, 120KB 상한 |
| F4 | 질의/작업 구분 없음 | 모든 프롬프트가 동일 비용 | LITE/FULL 모드 신설 (`!lite`/`!full` 강제) |
| F5 | "읽었는가" 를 강제하는 장치 없음 — 문서 hook 148종은 **AI 의지**에만 의존 | 누락의 구조적 원인 | `check-rules-read.ps1` (PreToolUse) 신설 — 미열람 시 Write 차단 |
| F6 | hooks/README "5 스크립트" ↔ settings.json 8 wiring | 유지보수 혼선 | README 재작성 (9 스크립트) |
| F7 | `.sh` parity: check-ui-gates / check-meta-sql / check-db-fresh-source / check-rules-read 는 ps1 전용, attach-context.sh 는 구 v2 로직 | Linux/클라우드 세션 강제력 저하 | 보고만 (Windows 가 실 wiring). 필요 시 후속 |
| F8 | **`settings.local.json` allow 목록에 `Bash(git push --force:*)`, `Bash(git filter-branch:*)`, `PowerShell(Remove-Item *)`** | `hooks/destructive-git-ops.md`(승인 의무)와 **정면 충돌** — 승인 프롬프트 없이 실행됨 | **미수정(사용자 판단)** — 제거 권고 |
| F9 | `settings.local.json` 에 1회성 명령 전문(수백 자) 수십 개 축적 | 로딩·가독성 | 정리 권고 (permissions 는 컨텍스트 미주입이므로 속도 영향은 없음) |
| F10 | `CLAUDE.md` Model Fallback 이 특정 버전 고정 표기 | 오래된 정보 | 아카이브로 이동, 루트에는 "단순 질의는 `/model` 로 가벼운 모델" 만 |
| F11 | `CLAUDE-rules-snippet.md`(2026-08-20) 가 제안한 `doc/asis/*.csv` 인덱스 기반 참조 규칙·`Check-Coverage.ps1` 완료 조건은 **채택 흔적 없음**(해당 경로 부재) | 미결 제안 | 보고만 — 채택 여부 결정 필요 |

## 3. 적용한 구조 (5계층)

| 계층 | 위치 | 로딩 시점 | 크기 |
|---|---|---|---:|
| T0 상시 | `CLAUDE.md` (신) | 매 턴 | 6,152 B |
| T1 경로 한정 | `.claude/rules/00-fe-screen.md` (`nscm-fe/**`) / `01-be.md` (`nscm-be/**`) / `02-db-sql.md` (`**/*.sql`, `_artifacts/**`, `To-be_v2_converted/**`) / `03-analysis-docs.md` (분석·설계·테스트 폴더) | 해당 경로 파일을 만질 때 | 1.8~3.8 KB 각 |
| T2 작업 진입 | `TRIGGER_ROUTER.md` (MASTER §2+§2.5+§7 추출) / `UI_MANDATORY_CHECKLIST.md` (§3 추출) | FULL 작업 시 Read / attach-context 가 첨부 | 14 KB / 19 KB |
| T3 상세 | `Doc/_rules_v2/hooks/*.md` 153종, `_tobe`, `_asis`, `_dev_rules` | T# 행이 지정한 것만 Read | 그대로 |
| T4 카탈로그·정본 | `RULESET_MASTER.md`, `00_INDEX.md` | **카탈로그가 필요할 때만** | 그대로 (수정 없음) |
| 강제 | `check-rules-read.ps1`(신) + 기존 8종 | 도구 실행 시 자동 | — |

### 구 CLAUDE.md → 신 위치 매핑 (누락 0 확인용)
| 구 섹션 | 신 위치 |
|---|---|
| Model Fallback / §8 도구 표 / §9 관련 문서 표 / §10 코드 위치 | `Doc/_archive/CLAUDE_md_full_2026-10-12.md` (전문 보존) · §9 표는 `TRIGGER_ROUTER.md` + `RULESET_MASTER §5` 가 대체 |
| §1 프로젝트 | `CLAUDE.md` §0 |
| §2 Step 1 룰셋 로드(3파일) | `CLAUDE.md` §3 (anti-simp + ROUTER + 행별 hook + CHECKLIST) — **MASTER·00_INDEX 전문 Read 는 "카탈로그 필요 시" 로 전환** |
| §2 Step 1.5 pre/post/pre-submit + 2대 통합 진입 + 3종 절대 누락 | `CLAUDE.md` §3 + `rules/00-fe-screen.md` A |
| §2 Step 2 카탈로그 위치 / 유지 룰 v1 표 | `TRIGGER_ROUTER.md` (§2 표 안에 `_dev_rules/NN` 참조) + `RULESET_MASTER §5.4` |
| §2 Step 3 기존 코드 참조 | `rules/00-fe-screen.md` B · `rules/01-be.md` A |
| §2 Step 3.5 features 폴더 5단계 | `rules/00-fe-screen.md` C |
| §2 Step 4 분석자료·카운트 일치·xlsx 불신 | `rules/00-fe-screen.md` D |
| §3 핵심 원칙 3 | `CLAUDE.md` §1-2~4 (+ 디자인 1순위 원칙 0 추가 — MASTER §1 승계) |
| §4 절대 금지 Top 11 | `CLAUDE.md` §4 (요약) + FE/BE/DB rules 에 분배 |
| §5 명명 / §6 표준 호출 | `rules/00-fe-screen.md` E · `rules/01-be.md` B·C |
| §7 자기 점검 | `rules/00-fe-screen.md` F → `hooks/post-write.md` |
| §11 폴더 매핑 / §12 v7.4 / §13 통계 | `rules/03-analysis-docs.md` B·C·D |
| §14 anti-simplification | `CLAUDE.md` §1-1 |
| §15 변경 이력 포인터 | `CLAUDE.md` §6 마지막 행 + `rules/03-analysis-docs.md` E |

## 4. 기대 효과 (산술)
- 질의 1건: 500KB+ → **CLAUDE.md 6KB + LITE 안내 0.5KB** (답에 필요한 hook 1개 추가 시 +5~20KB).
- 작업 1건(화면 수정): MASTER 159KB + 00_INDEX 152KB 전문 → ROUTER 14KB + CHECKLIST 19KB + 해당 행 hook 3~6종(60~120KB). **누락은 오히려 감소** — 읽어야 할 것이 명시적이고, 안 읽으면 Write 가 막힌다.

## 5. 사용법 변화 (사용자)
- 질문은 그냥 묻는다. 응답 첫 줄 `[LITE]` 확인. 룰 전문 적용을 원하면 `!full` 접두.
- 작업 요청 응답 첫 줄 `[T# 적용: … / Read: …]` 로 어떤 룰이 적용됐는지 즉시 확인 가능 — 빠졌다고 보이면 그 자리에서 지적.
- Write 가 `BLOCK [check-rules-read]` 로 막히면 Claude 가 안내된 hook 을 Read 후 재시도한다(정상 동작). 긴급 시 `$env:NSCM_SKIP_RULE_READ='1'`.
- MASTER §2/§3 를 고치면 `python scripts\rules\build_router.py` 재실행 (추출본 동기). `--check` 는 drift 만 점검.
- `/context` 로 상시 토큰을 확인하고, 단순 질의는 `/model` 로 가벼운 모델 사용 권장.

## 6. 롤백 (전부 사본 보존)
```
copy CLAUDE.md.bak_20261012                      CLAUDE.md
copy .claude\settings.json.bak_20261012          .claude\settings.json
copy .claude\hooks\attach-context.ps1.bak_20261012  .claude\hooks\attach-context.ps1
copy .claude\hooks\README.md.bak_20261012        .claude\hooks\README.md
rmdir /s .claude\rules      (선택 — 남겨도 무해: 경로 매칭 시만 로드)
```
신설 파일(삭제해도 무해): `TRIGGER_ROUTER.md`, `UI_MANDATORY_CHECKLIST.md`, `check-rules-read.ps1`, `scripts/rules/*`, 본 보고서.

## 7. 후속 권고 (미수행 — 사용자 결정 필요)
1. **F8** `settings.local.json` 의 `git push --force` / `filter-branch` / `Remove-Item *` allow 제거.
2. **F1** MASTER 상단·§4 헤더·00_INDEX §B.3 카운트를 153 으로 정정 (정본 수정이라 보류).
3. `.sh` 4종 parity (클라우드/Linux 세션을 쓸 경우에만).
4. `_rules_v2/hooks/` 153종 중 **같은 사고 계보를 다루는 중복 hook 통합** — 예: grid merge 계열 4종(wijmo-merge-*, grid-insert-*), SP 성능 계열 3종(oracle-perf-*, oracle-sp-perf-*). 통합은 룰 내용 변경이므로 별도 세션에서 1계열씩 cross-check 후 진행.
5. **옵시디언 도입 시점**: 위 4 가 끝난 뒤 `Doc/_rules_v2/` 를 vault 로 열어 frontmatter(`applies_to`, `trigger`) 로 그래프 관리. 루트 CLAUDE.md 나 attach-context 가 vault 전체를 끌어오는 구성은 금지.
6. `CLAUDE-rules-snippet.md` 의 CSV 인덱스·Check-Coverage 제안 채택 여부 결정 (F11).
