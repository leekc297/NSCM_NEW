# 카테고리 12 — 프로세스·운영·배포 / Process, Ops & Deploy

> **연다: 언제?** 작업 시작/종료 게이트, 사내 DB 적용, 이관 패키지, git, 로컬 환경, 이슈 관리 시.

## A. 공통 게이트 (모든 작업)
| # | Hook | 강도 | 계율 1줄 |
|---:|---|:--:|---|
| 38 | [pre-write](../hooks/pre-write.md) | 🅒 | 파일 작성 직전 체크리스트 |
| 36 | [post-write](../hooks/post-write.md) | 🅒 | 작성 직후 grep 검증 |
| 37 | [pre-submit](../hooks/pre-submit.md) | 🅒 | PR 제출 직전 통합 검증 (머지 게이트) |
| 46 | [screen-completion-gate](../hooks/screen-completion-gate.md) | ⭐⭐ | 화면 종료 선언 전 **8 게이트** + 보고 양식 |
| 101 | [ui-work-entry-playbook](../hooks/ui-work-entry-playbook.md) | ⭐⭐⭐ | "보완"/"신규 생성" 진입 절차 (카테고리 01·11 공유) |

## B. 사내 DB 적용·이관 패키지
| # | Hook | 강도 | 계율 1줄 |
|---:|---|:--:|---|
| 11 | [db-corporate-apply](../hooks/db-corporate-apply.md) | ⭐ | 사내 적용 절차 (docker sqlplus + CRLF + Known error 분류) |
| 13 | [db-schema-divergence-check](../hooks/db-schema-divergence-check.md) | ⭐ | Docker vs 사내 8 schema 차이 PRE-CHECK |
| 14 | [deploy-package-completeness](../hooks/deploy-package-completeness.md) | ⭐ | 이관 패키지 PRE/POST 인벤토리 + 클라우드 PRECHECK·채번충돌 |
| 122 | [cloud-ui-db-object-fetch](../hooks/cloud-ui-db-object-fetch.md) | ⭐⭐ | 클라우드 생성 UI DB 객체 **역이관** 표준 — 발견 4축→DDL 원문→메타 INSERT-only 에미터→DISCOVER↔VERIFY 카운트 대조. 템플릿=SYS0016_CLOUD_FETCH_20260804 |
| 60 | [sp-patch-file-deploy](../hooks/sp-patch-file-deploy.md) | ⭐⭐ | patch 형식·의존순서 (카테고리 09 공유) |
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

## Cross-ref
- 룰 v1 유지 8: 02(브랜치/커밋)/21(트러블슈팅)/**22(이관패키지)**/28(multi-remote)/29(CSV 적재)/30(백업/원복)/31(Figma)/32(Oracle 직결)
- 이관 패키지 의무 동봉: MSG/LBL/MNU 4분류(메모리 `feedback_deploy_package_msg_lbl_mnu_omission` — 393 중 323 누락 감사) + GTT/TYPE DDL 자급(`feedback_deploy_package_gtt_type_ddl`) + locales PATCH(#114 §5)
- git 업로드 = **요청 시에만 + 전체**(`feedback_git_upload_full_working_tree`) · 백업/원복: `feedback_backup_trigger`
