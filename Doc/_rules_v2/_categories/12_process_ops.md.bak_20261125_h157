# 카테고리 12 — 프로세스·운영·배포 / Process, Ops & Deploy

> **연다: 언제?** 작업 시작/종료 게이트, 사내 DB 적용, 이관 패키지, git, 로컬 환경, 이슈 관리 시.

## A. 공통 게이트 (모든 작업)
| # | Hook | 강도 | 계율 1줄 |
|---:|---|:--:|---|
| 38 | [pre-write](../hooks/pre-write.md) | 🅒 | 파일 작성 직전 체크리스트 |
| 36 | [post-write](../hooks/post-write.md) | 🅒 | 작성 직후 grep 검증 |
| 37 | [pre-submit](../hooks/pre-submit.md) | 🅒 | PR 제출 직전 통합 검증 (머지 게이트) |
| 46 | [screen-completion-gate](../hooks/screen-completion-gate.md) | ⭐⭐ | 화면 종료 선언 전 **8 게이트** + 보고 양식 + ⭐ **완료 선언 = ui_gate_runner 리포트 첨부 의무 (2026-08-07)** |
| 101 | [ui-work-entry-playbook](../hooks/ui-work-entry-playbook.md) | ⭐⭐⭐ | "보완"/"신규 생성" 진입 절차 (카테고리 01·11 공유) |
| 149 | [remediation-closure-symptom-reproduction](../hooks/remediation-closure-symptom-reproduction.md) | ⭐⭐⭐ | **보완요청 종결 게이트 (2026-08-31)** — 신고 증상 재현→정정→해소 실측 2축 의무·존재≠동작(실존 확인은 전이 근거 불인정)·클라우드 신고=사용자 실측 전 Y ⛔·원인 프레임 이월 금지 |

> ⭐ **실행 hook 7종 + 보조 검증 도구 3종 (2026-08-07)** — 단일 소스 = `RULESET_MASTER §6.1`:
> 실행 hook 에 `check-ui-gates.ps1`(G-A~**G-E** — G-E=모달 확정버튼 부재 의심) · `check-meta-sql.ps1`(SHEET_COLUMNS CTRL/INPUT_TP_CD 값 단언) 추가.
> 도구 = `_artifacts/_diagnostics/` `wiring_chain_check.py`(FE→BE→SP 체인+v2 액션·권한 축 L2A/L2P·`--all` 스윕) / `asis_mapping_gate.py`(EID 1:1
> +CRUD·모달 매트릭스 `--init` 선생성·`--check [--matrix-only]` 게이트) / `ui_gate_runner.py`(5섹션 일괄 → `_artifacts/_gate_reports/{MNU_ID}_{ts}.md`).
> 런타임 짝 = screen-completion-gate §0.5 **G6-6 모달별 CRUD 왕복** (2026-08-07 사용자 요구 "MAIN UI 와 모달의 CRUD 누락 0").

## B. 사내 DB 적용·이관 패키지
| # | Hook | 강도 | 계율 1줄 |
|---:|---|:--:|---|
| 11 | [db-corporate-apply](../hooks/db-corporate-apply.md) | ⭐ | 사내 적용 절차 (docker sqlplus + CRLF + Known error 분류) |
| 13 | [db-schema-divergence-check](../hooks/db-schema-divergence-check.md) | ⭐ | Docker vs 사내 8 schema 차이 PRE-CHECK |
| 14 | [deploy-package-completeness](../hooks/deploy-package-completeness.md) | ⭐ | 이관 패키지 PRE/POST 인벤토리 + 클라우드 PRECHECK·채번충돌 |
| 122 | [cloud-ui-db-object-fetch](../hooks/cloud-ui-db-object-fetch.md) | ⭐⭐ | 클라우드 생성 UI DB 객체 **역이관** 표준 — 발견 4축→DDL 원문→메타 INSERT-only 에미터→DISCOVER↔VERIFY 카운트 대조. 템플릿=SYS0016_CLOUD_FETCH_20260804 |
| 60 | [sp-patch-file-deploy](../hooks/sp-patch-file-deploy.md) | ⭐⭐ | patch 형식·의존순서 (카테고리 09 공유) |
| 148 | [cloud-deploy-silent-failure-gates](../hooks/cloud-deploy-silent-failure-gates.md) | ⭐⭐⭐ | 클라우드 이관 조용한-실패 5계보 — `40_GRANT_SYNONYM`·`22A` 종속 PROGRAM_ID 메타·`90_VERIFY` V11~V13·d.ts 블록 경계·NLS 스캔. 룰=생성기 코드 |
| 44 | [scmd-app-grant-mandatory](../hooks/scmd-app-grant-mandatory.md) | ⭐⭐ | GRANT+SYNONYM + 패키지 09_GRANT 필수 |
| 78 | [ui-category-setup-no-arbitrary-data](../hooks/ui-category-setup-no-arbitrary-data.md) | ⭐⭐⭐ | 메타 임의 생성 금지 (카테고리 08 공유) — DML=사용자 승인 후 |

## C. git·로컬 환경·문서 운영
| # | Hook | 강도 | 계율 1줄 |
|---:|---|:--:|---|
| 15 | [destructive-git-ops](../hooks/destructive-git-ops.md) | ⭐⭐ | reset --hard/force-push/filter-branch 전 사용자 승인 의무 |
| 79 | [local-server-startup-standard](../hooks/local-server-startup-standard.md) | ⭐ | 서버 기동 = gradlew.bat + vite.cmd 직접 (**pnpm 금지**) |
| 17 | [file-write-fallback](../hooks/file-write-fallback.md) | 🅒 | 파일 작성 실패 시 fallback 절차 |
| 77 | [claude-md-changelog-policy](../hooks/claude-md-changelog-policy.md) | ⭐⭐ | CLAUDE.md §15 직접 추가 금지 — monthly archive 1-line + work_reports 분리 |
| 86 | [issue-feed-rules](../hooks/issue-feed-rules.md) | 🅒 | 일일 이슈 → 룰 후보 append-only 피드 |
| 88 | [issue-log-daily-workflow](../hooks/issue-log-daily-workflow.md) | 🅒 | 이슈목록 정리 → 룰 승격 절차 |
| 125 | [ui-selfcheck-runtime-mandatory](../hooks/ui-selfcheck-runtime-mandatory.md) | ⭐⭐⭐ | **완료 선언 전 셀프 런타임 검증 의무** — SP 직접 CRUD 왕복 + HTTP E2E 러너(ui_http_e2e.py) 8축 + Division×역할 15계정 권한별 + 모달=MAIN 동등 5칸 + 3리포트 첨부 (주 소속 — 02·05 공유, 2026-08-07 사용자 지정) |
| 126 | [verification-completion-honesty](../hooks/verification-completion-honesty.md) | ⭐⭐⭐ | **검증 완료 선언 정직성 계약** — 보고 3값(PASS/**ERROR**/FAIL): 미실행·미확인·환경파손·미적용 = ERROR(PASS 아님). 완료 판정식 5조건(9섹션 전수 실행 + 리포트 3종 + **신선도** + 적용축 사내/QA/DEV + 사용자축 명시) · ERROR 5칸 양식 · **게이트 자기검증**(역재현·커버리지 실측·절단 고지) · 환경오류≠통과. #124→#125→**#126 출구** (주 소속 — 11·10 공유, 2026-08-08 사용자 지정) |

## Cross-ref
- 룰 v1 유지 8: 02(브랜치/커밋)/21(트러블슈팅)/**22(이관패키지)**/28(multi-remote)/29(CSV 적재)/30(백업/원복)/31(Figma)/32(Oracle 직결)
- 이관 패키지 의무 동봉: MSG/LBL/MNU 4분류(메모리 `feedback_deploy_package_msg_lbl_mnu_omission` — 393 중 323 누락 감사) + GTT/TYPE DDL 자급(`feedback_deploy_package_gtt_type_ddl`) + locales PATCH(#114 §5)
- git 업로드 = **요청 시에만 + 전체**(`feedback_git_upload_full_working_tree`) · 백업/원복: `feedback_backup_trigger`
