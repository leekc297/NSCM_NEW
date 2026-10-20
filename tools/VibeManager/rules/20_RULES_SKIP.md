# 20_RULES_SKIP — 이관하지 않은 룰·프로세스와 이유 (2026-10-19)

> 기준: ①Vibe_Manager 파이프라인(AsisFacts → 카탈로그 → 생성 → 게이트 → 수선 → 등록 → E2E)이 **같은 목적을 기계적으로 대체**하는 것, ②대화형 Claude Code 세션 운영 규칙이라 `claude -p` 하네스에서 **발목을 잡는** 것, ③현재 범위(DM/SCP, 로컬 환경) 밖인 것. "제외" 는 룰 원문을 지운다는 뜻이 아니라 **Vibe_Manager 가 로드·강제하지 않는다**는 뜻이다. 원문은 그대로 `Doc/_rules_v2/…` 에 남아 있고, 사람이 Claude Code 를 직접 쓸 때는 기존대로 동작한다.

## A. 대화형 세션 운영 규칙 → 하네스에서는 끔 (`VIBE_HARNESS=1`)
| 항목 | 출처 | 이유 / 대체 |
|---|---|---|
| LITE/FULL 응답 모드, `!full/!lite`, 첫 줄 `[T# 적용: …/Read: …]` 표기 | CLAUDE.md §2~3 | `claude -p` 는 1회 실행·산출물만 본다. 모드 판별·헤더는 의미 없음. 대체: 프롬프트가 룰 파일을 직접 지정 |
| `TRIGGER_ROUTER.md` 4단계 라우팅, T00~T21 선택, 핵심 hook 전문 Read 의무(⭐⭐⭐ 생략 불가) | TRIGGER_ROUTER, RULESET_MASTER §0 | 매 호출 150K+ 토큰·수십 파일 Read 가 수선 루프 3회 × 화면 수백 개에 곱해진다. 대체: `10_RULES_KEEP.md`(포인터+요지, 23KB) 1개 주입 + 게이트 코드 |
| `check-rules-read.ps1` (transcript 에서 Read 흔적 검사 후 Write 차단) | `.claude/hooks` | 하네스 Claude 는 템플릿 골격을 "채우는" 역할이라 Read 없이도 룰이 코드에 박혀 있음. transcript 검사가 Edit 를 차단하면 루프가 BLOCK 그대로 끝남. **하네스 실행 중에만** 통과(`VIBE_HARNESS=1`), 대화형 세션엔 그대로 |
| `attach-context.ps1` (프롬프트 키워드 → 룰 자동 첨부, LITE 판별) | `.claude/hooks` | 같은 이유. 하네스 프롬프트는 자체 컨텍스트(`harness-gen-context.ps1`)를 쓴다 |
| `ui-work-entry-playbook`(#101) "보완" 트리거 전면 점검표, `pinpoint-request-scope-first`(#153), `request-ledger-and-subclause-mapping`(#139), `remediation-closure-symptom-reproduction`(#149) | hooks | 보완요청(사람 대화) 처리 절차. Vibe 에서는 "보완" = 게이트 BLOCK 목록이 곧 원장. 종결 = 게이트 PASS + E2E |
| `pre-write` / `post-write` / `pre-submit` 체크리스트 수행·보고 양식 | #36~#38 | 항목 자체는 `check.js` R/B/M 게이트와 DoD 로 옮김(10_RULES_KEEP §J). 사람이 읽는 체크리스트 의식은 제외 |
| `verification-completion-honesty`(#126) 보고 3-상태 양식, `ui_gate_runner.py` 9섹션 리포트 경로 첨부 의무, `asis_mapping_gate --check`, `wiring_chain_check`, `regression-impact.ps1` | #126, UI체크 3.4, G5 | 원칙(검증 없으면 PASS 아님)은 이관(§A-6). 러너 자체는 `check.js --final`·`DOD.md`·`PIPELINE.md`·E2E 요약이 대체. 기존 파이썬 러너는 `_artifacts/_diagnostics` 에 그대로(병행 가능, 필수 아님) |
| `claude-md-changelog-policy`(#77), `issue-feed-rules`(#86), `issue-log-daily-workflow`(#88) | hooks | 문서 운영 정책. Vibe 산출물은 `Doc/gen`·`.vibe/` 에 기록 |
| `file-write-fallback`(#17) | hook | 하네스는 파일 쓰기 실패 = exit 1 → NEEDS_HUMAN |
| CLAUDE.md 절대 원칙 #8 "**보완 = DB 객체 수정 우선, FE/BE 는 직접 수정하지 않고 가이드만**"(2026-10-15) | CLAUDE.md §1-8 | **사용자 확정(2026-10-19)**: 이 원칙은 대화형 Claude Code 세션에만 적용되고 Vibe_Manager 에는 해당하지 않는다. 하네스는 FE 페이지·PKG 를 직접 생성·수선한다 |

## B. As-is 분석 산출물 체계 → AsisFacts Fact Pack 이 대체
| 항목 | 출처 | 이유 / 대체 |
|---|---|---|
| v7.4 화면 분석서 xlsx 13시트(filled cells 30+), `screen-analysis-workbook-standard`(#105) UI분석서 10시트/설계서 8시트, `/단위테스트` 커맨드 TestCases xlsx | `.claude/rules/03`, #105, `.claude/commands` | 산출물 형식 규칙. Vibe 의 분석 정본은 `Doc/asisfacts/screens/<ID>/*.csv` + `_summary.md`(파서 추출·교차검증). xlsx 는 보고용으로 필요할 때만 별도 생성 |
| `popup-asis-analysis`(#33) 9 category deep read, `screen-asis-pre-analysis-mandatory`(#124) 4영역 md 세트, `screen-modal-cascade-filter-analysis`(#123) md | hooks | 사람이 읽는 md 작성 의무. 팝업·이벤트·검증·표현식은 Fact Pack 이 전수 추출(`popups.csv`, `events.csv`, `validations.csv`, `expressions.csv`). "모달=MAIN 동등 점검" 원칙은 `DoD:B10/B11`+매핑 `D00-P` 로 이관 |
| `Doc/_analysis/domain_*/screens/{ID}/` 8 MD, `_analysis/_screens/*.xlsx` 11_Validation/12_Expression, 카운트 일치 의무, "xlsx 1~10시트 불신" | `.claude/rules/00 §D` | 원천이 소스 파싱으로 바뀜. 카운트 일치는 `G:V01/V02`(validation/expression 100%) 로 유지. 기존 md/xlsx 는 참고 자료 |
| `search-condition-asis-tobe-catalog`(#112) 953행 md 전 행 대조, `ui-meta-dictionary-mandatory`(#142), `_rules_v2/_dictionary` | hooks | 사람 대조 절차. 내용은 `rules/map_field.csv`·`map_control.csv`(mined) 로 기계화됐고, 미매핑은 `G:G02` + `_candidates.csv` 로 드러남. md 카탈로그는 참고 링크로만(10_RULES_KEEP E4) |
| `figma-layout-parity-mandatory`(#90), `Doc/_figma/screens/{ID}.md`, `31_FIGMA_DESIGN_INTEGRATION`, T11 | hooks, dev_rules | 대상 화면에 Figma MD 가 없음(DMF0052 등 신규 6화면). 디자인 원천이 생기면 `P:` 입력으로 추가 |
| `Screen_POPUP_SP_Tables_Matrix.xlsx`, `_analysis/_phase1~4` 통계·폴더 매핑 | `.claude/rules/03 §C/D` | 보고 자료. Recon 대사표(`Doc/recon`)가 화면/SP/시트 축으로 대체 |

## C. 환경·배포·운영 절차 → 범위 밖 또는 수동
| 항목 | 출처 | 이유 |
|---|---|---|
| CLAUDE.md §8 `pnpm local/build/lint/type-check/test` 표 | archive | 로컬 절차 아님(사용자 2026-06-22). `00_ENV.md` 가 대체 |
| 사내 DB 적용 T18(`db-corporate-apply` docker sqlplus+CRLF 우회, `db-schema-divergence-check` 8 schema PRE-CHECK, `corp-meta-integrity` §7 채번, `cloud-ui-db-object-fetch` 역이관, `APPLIED_OPERATIONS.md`) | #11, #13, #98, #122 | 운영/사내 적용은 사람 승인 절차. Vibe 는 **개발 DB(ZIOUI1)** 에만 `run_sql.py --commit` 하고 되돌리기(`<ID>_revert.sql`)를 둔다. 메타 무결성 규칙(NOT NULL·채번 대역·INSERT NOT EXISTS)만 이관(10_RULES_KEEP H13) |
| DBeaver 4파일 SQL 세트, `*_DBeaver*.sql` SQL*Plus 토큰 금지, `check-dbeaver-sql.ps1` | `.claude/rules/02`, hook | Vibe 는 SQL*Plus 문법(`DEFINE`/`/`)을 `run_sql.py` 가 직접 실행. DBeaver 변형은 만들지 않음. hook 은 해당 파일명에만 반응하므로 켜 둬도 무해 |
| 이관 패키지 T16(`22_PACKAGE_ARTIFACTS`, `deploy-package-completeness` §1.0-B/C, `sp-patch-file-deploy` 조립 3계약, `cloud-deploy-silent-failure-gates`, `fe-cloud-type-lint-readiness`) | #14, #60, #148, #16 | 클라우드 이관 zip 작성 절차. 아직 범위 밖. 화면 단위 산출(`Doc/gen/<ID>/*.sql`)은 그대로 패키지 입력이 되며, 필요 시 S6 에 "이관 패키지 생성" 작업 추가 |
| Git multi-remote(`28_GIT_MULTI_REMOTE`), 로컬 백업/복원(`30_`), 로컬 Docker Oracle CSV 적재(`29_`), 21_TROUBLESHOOTING §8/§10 로컬 Docker 사고 | dev_rules | 노트북은 Git 접근 불가, Docker Oracle 은 Vibe 대상 아님(To-Be Oracle 직결) |
| `sdm-domain-development-standard`(#134) | hook | SDM(SPMS/샘플 수요) 도메인 — 현재 범위 DM/SCP 밖. 범위 확장 시 이관 |
| `excel-form-upload-standard`(#135), `excel-upload-nls-safe-parsing`(#147) | hooks | Excel 업로드 보유 화면에만 해당 — 참고(REF)로 유지, 해당 화면 생성 시 `P:` 지시 |
| `local-server-startup-standard` §4 (Claude Bash run_in_background 로 서버 기동) | #79 | 서버 기동은 사용자가 한다(사용자 방침). 명령만 `00_ENV.md` 에 이관 |
| Model Fallback / `/model` 가벼운 모델 권장 | archive | 하네스는 CLI 기본 모델 |
| `hooks/README` OS parity(.sh 5종) | `.claude/hooks` | 노트북 Windows 고정 |

## D. 보류 (자동화 후보 — 지금은 `M:` 사람 확인)
- `db-source-refresh-before-work`(#152) 24h `SOURCE-FRESH` 스탬프·FRESH-GATE: 신규 PKG 생성엔 해당 없음. **기존 PKG 수정** 작업이 생기면 `gen-pkg` 가 `ALL_SOURCE` 를 먼저 당겨오도록 확장(후보).
- Measure 메타(SYS0004), PIVOT 동적 컬럼·titleset 캐시·CLOB 버퍼(#106/#115/#32): PIVOT 화면이 대상에 들어올 때 템플릿·게이트 추가.
- `ui-meta-consumption-and-crud-path-coverage`(#130), `ui-common-testitem-mapping-axis`(#133 UC-01~06): E2E crud 스펙에 공통 6항목 축 추가(후보).
- `check-ui-gates.ps1` G-A~G-G 는 Claude Code 의 Write 후에만 돈다. 하네스 `check.js` R-시리즈가 같은 항목(자체 행상태/call-proc 판정/감사키/모달 확정버튼)을 덮지만, 콤보 빈 catch·quoting(G-F/G-G)은 미이관 → R17/R18 후보.
