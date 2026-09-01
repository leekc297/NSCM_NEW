# DMF0082_AUTHGATE_CLOUD_20260826 — 권한별 편집 통제 (SCP Planner 시간창 / DM Viewer 전면 차단)

> 지시 (2026-08-26): ① SCP Planner = MKT_FCST·LOC 편집 불가(AS-IS 시간창 + MSG00477) + 권한 없으면
> Batch Price Input / Excel Form / Excel Upload 숨김 ② DM Viewer = 편집·INSERT·DELETE 전면 불가 + 동일 3버튼 숨김.
> **전제: DMF0082_CLOUD_20260826_PENDING (v4) 기적용** — 04 는 그 이후 누적본.

## 적용 순서: A_DB `01` → `02` → `03` → `04` → `90` → B_FE 4본 배포

| # | 파일 | 방식 | 내용 |
|---|---|---|---|
| 01 | 01_LOOKUP_SCPWINDOW.sql | UPDATE 42행 | 81계열 GET_ADMIN_GROUP_MEASURE AS-IS 원형 복원 — SCP MKT_FCST TUE+시간창 6 / DM 계열 A4='SCP Planner' 18 / SCM_FCST A4 해제 18 |
| 02 | 02_BTN_AUTH_SCP_EXCEL.sql | UPDATE ≤4행 | SCP Planner 의 FcstNPrice FORM_DATA/UPLOAD/UPLOAD_DATA/UPLOAD_SAVE 회수 (USE_YN='N') |
| 03 | 03_PKG_NSCM_UI_COM_AUTH_BODY.sql | 전체 교체 | [BTNUSEYN] GET/CHECK 버튼권한 SP 에 USE_YN 필터 — 회수 행 실효화 (⚠ 전 화면 공통 — 기존 N 행 11건도 이때부터 실효) |
| 04 | 04_PKG_DMF0082_BODY.sql | 전체 교체 (**v6**) | [AUTHVIEW 3] drop3 'T'(시간창 사유 — MSG00477 대상) / LOC 강제개방 DM Viewer 제외 / VMI DM Viewer 단독 차단 + **[SCPVMI 1] VMI 개방에서 SCP Planner 단독 제외** (사용자 확정 2026-08-26: 시간 밖 = 수정·INSERT/DELETE 전면 불가·AS-IS 40 VMI 룩업에 SCP 없음) |
| 90 | 90_VERIFY.sql | 검증 | 마커·룩업·버튼 5축 |

## B_FE (실경로 4본 — hook §1.8)
- ForecastPrice.tsx — 편집 3버튼 hasEditAuth 게이트·Price Batch Input=LOC 권한 게이트·**Insert 초기 MEASURE = MKT_FCST 권한 없으면 'Y' 첫 메저 폴백(SCP 월요일 창=SCM_FCST)**
- forecast-price.constants.ts — MSG00477(SCP_TIME_WINDOW, locales 기등재 재사용)
- useForecastPriceStore.ts — measureTimeGate('T') 맵
- components/ForecastPriceGrid.tsx — 시간창 잠금 편집 시도 시 MSG00477 알림(2s 억제)

## 검증 (사내 2026-08-26 실측)
- O_RC4 매트릭스 5그룹×81/40: SCP 81 MKT='T'·LOC N / Viewer 전 N (40 LOC·VMI Y→N 정정) / ADMIN·Planner 회귀 0
- 버튼 SP: SCP 에서 FORM_DATA/UPLOAD* 소멸·CHECK 게이트 N / ADMIN 불변 / Viewer 불변
