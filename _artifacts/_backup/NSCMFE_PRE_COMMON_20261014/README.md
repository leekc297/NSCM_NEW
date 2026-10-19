# 공통소스 다운로드 회차 보고 — 2026-10-14

- 원천: `https://github.com/eunjoo-hwang/nscm-fe.git` (remote `common`, push URL = `no_push` 유지 — 푸시 없음)
- 기준선: `2dc843467` (10-01 적용분) → **신규 기준선 `965d11de5`**
  (2026-10-14 08:54 YeongRog Kim "last")
- `2dc843467` 는 `965d11de5` 의 조상 — 이번 회차 force-push 재작성 없음
- 공통 신규 커밋 585건 / 전체 변경 3,133파일 중 **4폴더(apps·features·packages·public) + configs 대상 795건**
  (M 623 / A 146 / D 26, 이름변경은 삭제+신규로 풀어서 집계) — 나머지는 4폴더 밖 → 미반영

## 분류·처리 결과

| 구분 | 건수 | 처리 |
|---|---:|---|
| 수정(M) — 로컬 = 기준선(무편집) | 613 | 공통 채택 |
| 수정(M) — 내 편집이 따옴표 표기 1줄뿐 | 2 | 공통 채택 (`spms-demand` ProjectListGrid · ProjectMasterTab1Grid) |
| 신규(A) — 로컬 부재 | 146 | 공통 원문 신규 적용 (로컬 기존 파일 충돌 0) |
| 삭제(D) — 로컬 = 기준선 | 26 | 삭제 (supply 24 / shipping 2) — 남은 소스의 import 참조 0 확인 |
| 수정(M) — 3-way | 6 | 아래 |
| 수정(M) — d.ts 구조 병합 | 1 | `configs/types/procedures.d.ts` — 아래 |
| 수정(M) — 로컬 유지 | 1 | `metal-link-price.constants.ts` — 아래 |

채택 615 폴더별: supply 315 / shipping 147 / master 62 / demand 50 / shared 15 / foundation 9 / apps 6 /
admin 3 / spms-demand 3 / report 2 / locales 2 / configs(vite-env.d.ts) 1

### 신규·삭제 화면
- 신규(5본 이상): supply `capa-mobility-it`(20) · `production-plan`(14) · `plan-group-master`(12) · `shipment-plan-fg`(8) ·
  `components/newPlanModal`(8) · `production-plan-line`(6) / shipping `shipment-change-request`(11) · `shipment-plan`(8) ·
  `shipment-change-request-plan`(5) · `shipment-plan-auto-ess`(5)
- 삭제: supply `capa-report-small` 화면 전체(19본) · `shipment-plan-fg` 모달 2본·scss 1 · `shipment-plan-semi` scss 1 ·
  `integration-psi` Form scss 1 / shipping `shipment-semi-dept-day` ItemByDivisionModal 2본

### 3-way (base = 로컬이 실제 출발한 공통 판본)
| 파일 | base | 충돌 | 결과 |
|---|---|---:|---|
| `forecast-price/useForecastPriceStore.ts` | `e468c3d66` (09-08) | 5 | **5곳 모두 공통 채택** — 공통이 내 Excel Form 메타 조회(E20260921-XLSFORMASIS)를 가져가 요청 순번 가드를 더한 상위본. 병합본 = 공통 원문과 동일 |
| `forecast-price/forecast-price.constants.ts` | `936315877` (09-22) | 1 | 주석 1줄 충돌 → 로컬 주석 유지. 배열 값은 공통과 동일, 내 설명 주석만 남음 |
| `forecast-price/components/ForecastPriceGrid.tsx` | `2e07c5b36` (09-29) | 0 | 내 `comboParamExcludes={['CELL_PROD_SITE_ID']}` 유지 |
| `forecast-price/__asis-mapping__.md` | `badd49a07` (08-23) | 0 | 내 기록 유지 + 공통 1줄 |
| `etc-sales-reports/__asis-mapping__.md` | `0b294341a` (09-07) | 0 | 내 09-22 정정 기록 유지 + 공통 1줄 |
| `packages/foundation/src/utils/gridAction.ts` | `69abce34c` (09-30) | 0 | 내 `groupedHeaderExcelDownload` 유지 + 공통 18줄 |

### 로컬 유지 1 — `metal-link-price/metal-link-price.constants.ts`
공통(10-06 BeomJu)과 로컬이 같은 일을 따로 했다 — 업로드 토큰을 `그룹명_원소명` 으로 바꾼 것.
토큰 결과는 양쪽 동일하고, 로컬은 여기에 2단 헤더용 `group`·`width`·`TEMPLATE_SHEET_NAME` 을 더 갖고 있어
(로컬 `MetalLinkTemplateModal` 이 사용) 로컬을 그대로 뒀다.

### `procedures.d.ts` 병합 (RawProcedureMap 메뉴 키 블록 단위)
| 처리 | 메뉴 키 |
|---|---|
| 공통 신규 추가 (3) | `COM0014` · `SCP0024` · `SCP0128` |
| 공통 채택 — 로컬 = 기준선 (7) | `DMF0005` · `SCP0121` · `COM0010` · `SCP0085` · `SCP0124` · `SCP0127` · `SCP0129` |
| 로컬 유지 — 공통 무변경·내 편집 (9) | `DMF0035` · `SYS0016` · `SCM0002` · `DMF0049` · `DMF0044` · `SYS0017` · `SDM1010` · `SDM1020` · `SDM5010` |
| 블록 내부 3-way — 충돌 0 (1) | `DMF0082` — 공통 `buttonAuth` 시트 추가 + 내 `LAST_UPDATE_DATE`/`LAST_UPDATED_BY`·주석 |
| 로컬 전용 유지 (3) | `DMF0013` · `DMF0068` · `SCP0013` |
| 동일 (81) | — |

결과: 멤버 101 → 105 / 중복 키 0 / 로컬 키 유실 0 / 공통 키 유실 0 / 9,832행 → 10,326행.

#### ⚠️ 과거 회차 유실 2건 복구 (이번 회차 원인 아님)
1. **파일 끝 전역 타입 선언부 54줄 부재** — 로컬 `procedures.d.ts` 가 `interface RawProcedureMap` 닫는 `}` 에서 끝나 있었다
   (`type ProcessedProcedures` + `declare global { ProcedureMap / MenuId / SheetName / ProcRequest / ResponseKeys /
   ResponseData / ProcResponse / MutateRequest / MutateResponse }` 없음, 로컬 다른 파일에도 정의 없음).
   백업 대조: `20260917B` 까지 있음 → `20260922` 부터 없음. 공통은 기준선·최신 모두 동일 원문 → **공통 원문으로 복구**.
2. **`SYS0005` 블록 부재** — `20260928` 백업까지 있음 → `20261001` 백업부터 없음. 공통 기준선·최신 동일 → **공통 원문으로 복구**.
   (사용처: `features/admin/.../procedure-management`)

## ⚠️ 미해소
1. **d.ts 키 부재 42건** — 소스에 `MENU_ID = '…'` 상수는 있으나 `procedures.d.ts` 에 키가 없는 메뉴(공통 원본에도 없음 → 임의 작성 안 함):
   `DMF0043 DMF0045 DMF0072 SCP0002 SCP0006 SCP0009 SCP0010 SCP0011 SCP0019 SCP0020 SCP0025 SCP0027 SCP0031 SCP0033 SCP0037
   SCP0041 SCP0048 SCP0053 SCP0080 SCP0095 SCP0096 SCP0097 SCP0100 SCP0104 SCP0105 SCP0106 SCP0111 SCP0114 SCP0131 SCP0132
   SSP0012 SSP0019 SSP0020 SSP0023 SSP0024 SSP0025 SSP0045 SSP0200 SSP0201 SSP0202 SYS0012 SYS0015`
   (이번 신규 파일이 선언한 것 = `SCP0011` 1건. 집계 방식이 직전 회차와 달라 "34건" 과 직접 비교 불가)
2. **`comboParamExcludes` prop 고아 — 계속** — `ForecastPriceGrid.tsx:2068` 이 넘기지만 `DataGrid` 는 여전히 정의하지 않는다(10-01 보고와 동일).
3. **4폴더 밖 공통 변경 미반영** — `nscm-fe/package.json`(type-check 스크립트에 `--concurrency=4`) · `nscm-fe/.gitlab-ci.yml`.

## 원복 자료
- `local_before/` — 이번 회차에 덮어쓰거나 삭제한 로컬 원본 648본 (채택 615 + 삭제 26 + 3-way 6 + d.ts 1)
- `worktree_tracked.patch` — 적용 직전 `nscm-fe` 추적파일 전체 diff (62,698행)
- `git_status_before.txt` — 적용 직전 워킹트리 상태 (543행)

## 검증
- 채택 615·신규 146 **공통 원문과 개행 정규화 후 일치 — 불일치 0**, 삭제 26 잔존 0
- 적용 파일 충돌 마커 잔존 0건
- 삭제 파일을 가리키는 import 잔존 0건 (이름만 같은 타 화면 자체 모달은 제외 확인)
- 정적검증(type-check/lint) **미수행** — 사용자 지시(요청 시만) 유지. 따라서 내 화면 소스 ↔ 새 공통 소스 사이의 타입 불일치 여부는 미확인
