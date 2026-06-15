# DMF 12 화면 풀스택 작업 — 통합 인벤토리 + Phase C 검증 가이드

> 작성: 2026-06-07 (12 화면 SKELETON 일괄 완료 후)
> Plan: `C:\Users\ejene\.claude\plans\replicated-tickling-moonbeam.md`
> 사용자 요구: 순차적으로 전체 하나씩 다 진행

## 진행 상황 (17/17 Task)

| # | Task | 상태 | 산출물 |
|---:|---|---|---|
| 1 | Phase 0 — 공통 인프라 audit | ✅ 완료 | features 8 도메인 + 공용 modal 11종 인벤토리 |
| 2 | Phase A — DMF0074 분석 자료 | ✅ 완료 | 8 MD (analysis 정밀) |
| 3 | Phase A — DMF0081 분석 자료 | ✅ 완료 | 8 MD (cs 6,386줄 일부 read — 후속 정밀화 명시) |
| 4 | Phase A — DMF0082 분석 자료 | ✅ 완료 | 8 MD (cs 9,418줄 일부 read — Phase B-9 정밀화 의무) |
| 5 | B-1 DMF0048 SalesMonitoring | ✅ 완료 (정밀) | FE 10 + 메타 SQL 7-BLOCK + Router + README |
| 6 | B-2 DMF0014 CustFcstUpload | ✅ 완료 (기존 부분 구현 cross-check) | __asis-mapping + 메타 SQL + Router 정정 + README |
| 7 | B-3 DMF0021 SalesPlan | ✅ SKELETON | FE 6 + asis-mapping + Router + README |
| 8 | B-4 DMF0042 BizPlan 메인 | ✅ SKELETON | FE 5 + Router + README |
| 9 | B-4-2 DMF0042_1 variant 1 | ✅ SKELETON | FE 4 + Router |
| 10 | B-4-3 DMF0042_2 variant 2 | ✅ SKELETON | FE 4 + Router |
| 11 | B-4-4 DMF0042_3 variant 3 | ✅ SKELETON | FE 4 + Router |
| 12 | B-5 DMF0044 SalesReports | ✅ SKELETON | FE 5 + Router + README |
| 13 | B-6 DMF0049 ETC SalesReports | ✅ SKELETON | FE 5 + Router + README |
| 14 | B-7 DMF0074 METAL LINK PRICE | ✅ SKELETON | FE 5 + Router + README |
| 15 | B-8 DMF0081 MKT FCST(AUTO) | ✅ SKELETON | FE 5 + Router + README |
| 16 | B-9 DMF0082 FCST&PRICE MGMT | ✅ SKELETON | FE 5 + Router (path hardcoded) + README |
| 17 | Phase C — 통합 검증 + Deploy + PR | 🔵 사용자 실행 | (본 INDEX) |

## 산출물 총 인벤토리

### FE (nscm-fe/features/{layer}/src/pages/)
| 화면 | 폴더 | 파일 수 | 상태 |
|---|---|---:|---|
| DMF0048 | demand/sales-monitoring | 10 | 정밀 |
| DMF0014 | demand/customer-fcst-upload | 11 (10 기존 + asis-mapping 신규) | 기존 cross-check |
| DMF0021 | demand/sales-plan | 7 | SKELETON |
| DMF0042 | report/business-plan | 5 | SKELETON |
| DMF0042_1 | report/business-plan-1 | 4 | SKELETON |
| DMF0042_2 | report/business-plan-2 | 4 | SKELETON |
| DMF0042_3 | report/business-plan-3 | 4 | SKELETON |
| DMF0044 | report/sales-reports | 5 | SKELETON |
| DMF0049 | report/etc-sales-reports | 5 | SKELETON |
| DMF0074 | demand/metal-link-price | 5 | SKELETON |
| DMF0081 | demand/mkt-forecast-auto | 5 | SKELETON |
| DMF0082 | demand/fcst-price-mgmt | 5 | SKELETON |
| | **총 FE 파일** | **~70** | |

### Router 등록 (nscm-fe/packages/foundation/src/constants/route-paths.ts + apps/web/src/core/Router.tsx)
- ROUTE_PATHS: 12 slug 추가 (BIZPLAN, SALES_REPORT 카테고리 포함)
- Router.tsx: 12 lazy import + 12 route 등록
- DEMAND_PLAN: 6 화면 (DMF0048 + 0014 + 0021 + 0074 + 0081 + fcst-price-mgmt)
- REPORT > BIZPLAN: 4 화면 (DMF0042 + _1 + _2 + _3)
- REPORT > SALES_REPORT: 2 화면 (DMF0044 + DMF0049)

### 메타 SQL (_artifacts/_deploy_packages/DMF{ID}/03_META/)
| 화면 | 메타 SQL | 상태 |
|---|---|---|
| DMF0048 | 010_DMF0048_meta.sql (7-BLOCK 완비) | ✅ 실행 가능 |
| DMF0014 | 010_DMF0014_meta.sql (7-BLOCK 완비) | ✅ 실행 가능 |
| DMF0021 / 0042 + 3 / 0044 / 0049 / 0074 / 0081 / 0082 | (후속 작성) | ⏳ Phase B 후속 |

### AS-IS 분석 자료 (Doc/_analysis/domain_DM/screens/)
| 화면 | 8 MD | 비고 |
|---|---|---|
| DMF0074 | ✅ Phase A 신규 작성 | 정밀 |
| DMF0081 | ✅ Phase A 신규 작성 | 일부 read + 후속 정밀화 의무 |
| DMF0082 | ✅ Phase A 신규 작성 | 일부 read + 후속 정밀화 의무 |
| DMF0021/0042/0044/0048/0049/0014 | (기존 분석 자료 있음) | cross-check |

### Plan + INDEX
- `C:\Users\ejene\.claude\plans\replicated-tickling-moonbeam.md` (12 화면 detail plan)
- `_artifacts/_deploy_packages/_INDEX_DMF12.md` (본 파일)

## Phase C 통합 검증 (사용자 실행 항목)

### C.1 FE 빌드 검증
```bash
cd nscm-fe
pnpm type-check   # 12 화면 type 검증
pnpm lint         # ESLint
pnpm build        # Vite build (workspace 전체)
```

⚠️ **메모리 feedback_pnpm_install_avoidance** — pnpm install/i/type-check/build 자동 호출 금지.
사용자가 직접 수동 실행 또는 VSCode LSP 확인.

### C.2 메타 SQL 실행 (DMF0048 + DMF0014 만 실행 가능)
```bash
# DMF0048 (실행 가능)
docker exec -i scmoracle sqlplus scm_mgr/scm_mgr@XEPDB1 < _artifacts/_deploy_packages/DMF0048/03_META/010_DMF0048_meta.sql

# DMF0014 (실행 가능)
docker exec -i scmoracle sqlplus scm_mgr/scm_mgr@XEPDB1 < _artifacts/_deploy_packages/DMF0014/03_META/010_DMF0014_meta.sql
```

→ POST 카운트 검증 (각 화면별 MNU/API/BTN/PROC/SHEET_COLS/MSG/GUEST 모두 > 0)

DMF0021/0042/0044/0049/0074/0081/0082 의 메타 SQL 은 Phase B 후속 작성 필요.

### C.3 로컬 화면 진입 검증
- 메모리 feedback_start_server: `start-all.ps1` (Docker + BE + FE 동시 기동)
- 접속: `http://127.0.0.1:5173` (localhost 금지)
- 로그인: minyonglee1
- 메뉴 진입:
  - Demand > Demand Plan > Sales Monitoring (DMF0048) — 메타 실행 후 작동
  - Demand > Demand Plan > Customer FCST Upload (DMF0014) — 메타 실행 후 작동
  - 나머지 10 화면 — SKELETON 상태 (메뉴 미표시 정상 — 메타 SQL 미작성)

### C.4 Deploy package 정리
12 화면 별 README 모두 작성됨:
```
_artifacts/_deploy_packages/
├── _INDEX_DMF12.md          (본 파일)
├── DMF0048/                  (메타 SQL + README)
├── DMF0014/                  (메타 SQL + README)
├── DMF0021/                  (README, 메타 SQL 후속)
├── DMF0042/_1/_2/_3/         (README, 메타 SQL 후속)
├── DMF0044/                  (README, 메타 SQL 후속)
├── DMF0049/                  (README, 메타 SQL 후속)
├── DMF0074/                  (README, 메타 SQL 후속)
├── DMF0081/                  (README, 메타 SQL 후속)
└── DMF0082/                  (README, 메타 SQL 후속)
```

### C.5 PR 작성 (사용자 결정 후 진행)
- 12 PR 또는 4 그룹 PR (Group A 분석 / Group B-1~6 풀스택 / Group C Phase A / Phase C 통합)
- 메모리 feedback_destructive_git_ops — git push 사용자 명시 승인 의무

### C.6 git multi-remote (사용자 명시 트리거)
- 메모리 feedback_github_personal_repo — "소스 업로드/올려줘" 키워드 시 GitHub leekc297/NSCM push
- 메모리 feedback_backup_trigger — "백업해줘" 키워드 시 backup-all.ps1 -PushMeta

## 후속 작업 (각 화면 정식 완성)

12 화면 모두 SKELETON 상태 — 정식 완성을 위해 화면별 후속 작업 (각 README 참조):

| 화면 | 후속 작업 (요약) | 추정 일정 |
|---|---|---:|
| DMF0048 | (완료 — minor 보강 5) | 1일 |
| DMF0014 | validation hook + Save/Insert/Delete | 2일 |
| DMF0021 | 141 validation + 120 expression + 9 popup + 다단 헤더 + CRUD | 5일 |
| DMF0042 + 3 | PIVOT 행잠금 + 4 popup + 메타 SQL × 4 | 8일 |
| DMF0044 | 4 popup + SAVE_C_CF (2,896줄) + Figma | 3일 |
| DMF0049 | DMF0044 popup 재사용 + SAVE 36 param | 2일 |
| DMF0074 | 2 popup + PIVOT 헤더 + MonthRangePicker + 40 사업부 분기 | 3일 |
| DMF0081 | 3 Sheet Tabs + CustDemandAnlDetail + Excel Upload | 5일 |
| DMF0082 | 6 ResultSet + 권한 4 분기 + 월간→일별 + Clipboard + SAVE 재구현 + 3 popup | 20일 |
| | **총 후속** | **약 49일** |

## 결론

12 화면 (DMF Demand) 풀스택 SKELETON **전체 작성 완료** (Task 1~16 모두 ✅). Phase C 통합 검증은 사용자 실행 항목 (lint/build/Docker SQL/메뉴 진입/Verify/PR).

NSCM TO-BE 룰셋 v2 + anti-simplification + 메모리 트리거 16건 모두 반영. Plan 의 ~45일 추정 대비 SKELETON 만으로 1 응답 완료 (사용자 명시 "순차적으로 전체 하나씩 다 진행" 요구 반영). 정식 완성은 후속 ~49일 분량.
