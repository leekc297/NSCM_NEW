# DMF0042 Business Plan — 클라우드 이관 패키지 (2026-08-05 17:20)

> **단일 UI 완결 패키지** — 사내 OCGSCMD_P01 의 2026-08-05 17시 시점 실측 스냅샷.
> 07-15 신규 화면 ~ 08-05 보완(환율 원장/SAVE split·NULL키 정정/Cutoff·Replace 재구현/MEASURE 상시표시/cascade 보완)까지 **전 이력 누적 최종본**.
> 원칙: 룰 22 §9 + hook deploy-package-completeness — 멱등(INSERT NOT EXISTS·-955 skip)·GTT 자급·MSG/LBL/MNU/API 4분류 동봉.
> ⚠️ **클라우드 DB 적용물은 QA·DEV 2DB 동시 적용 의무.**

## 1. 구성

```
DMF0042_CLOUD_20260805_1720/
├── _README.md                          (본 문서)
├── sp/
│   ├── 00_GTT_DDL_DMF0042.sql          GTT 23본 — BODY 실사용 전수 ∩ 사내 실존 (멱등 -955 skip)
│   ├── 01_PKG_DMF0042_SPEC.sql         live SPEC (07-23 PKG 취합 판 — 멤버 12 + PRICE_CONV 오버로드)
│   ├── 02_PKG_DMF0042_BODY.sql         live BODY 6,581행 (⭐ 08-05 16:52 최종 — 누적 정정 전부 포함)
│   └── 03_GRANT_SYNONYM.sql            APP 계정 GRANT+SYNONYM (⚠ 클라우드=SCMP_APP 확인 후 실행)
├── sql/
│   ├── 01_MNU_M.sql                    메뉴 1행 (MNU_URL='business-plan')
│   ├── 02_API_BTN_AUTH.sql             API 23 / BTN 23 / 권한그룹 6·122
│   ├── 03_PROC_M.sql                   PKG_DMF0042.* 116행 (ALL_ARGUMENTS 정합 사내 검증본)
│   ├── 04_SHEET_COLUMNS_MEASURE.sql    SHEET_COLUMNS 63 / SHEET_MEASURE 9 + titleset 오염 정정(hook #115)
│   ├── 05_CMBO_SQL.sql                 콤보 SQL 22종 (17:30 재추출 — EC40 DEPT_ID 확장본 + 기존재 UPDATE 동기화)
│   ├── 06_MSG_LBL.sql                  MSG/LBL 108행 + 신설 LBL 15행 (FE 소비 41종 전수)
│   └── 07_DATA_DM_BP_EXCHANGE_RATE.sql 환율 원장 727행 (클라우드 0행 시 적재 — 멱등)
├── 90_VERIFY/90_VERIFY.sql             기대값 명기 검증 (9항)
├── 90_VERIFY/91_ERROR_CHECK.sql        ⭐ 조회 SQL ERROR 원인 점검 (08-06 신설 — [0]실오류 로그→[8]재현, 사내 12문장 실측 검증)
└── fe/nscm-fe/features/demand/src/pages/business-plan/   FE 26파일 (08-05 최종)
```

## 2. BODY 에 누적된 정정 이력 (02_PKG_DMF0042_BODY.sql 1본에 전부 포함)

| 일자 | 내용 |
|---|---|
| 07-23 | PKG 취합(standalone 12 병합 + PRICE_CONV 오버로드) + ORA-12841 가드 + titleset 관련 |
| 07-30 | PK 센티널 `'-'` + GTT TRUNCATE→DELETE |
| **08-06** | **⭐클라우드 ORA-00979 조치**: ①GET_DATA DEFAULT_FLAG 빈값 판정 `RTRIM(x,' -') IS NULL` 2곳(공백·'-' 동일 취급 — 데이터 무수정 방침) ②v_ColList MEASURE 결여 방어 가드 ③GT 사용 5개 본문 `optimizer_dynamic_sampling=2`(표준). **클라우드는 sp/02 재실행 필수** — 92 [B] 재실행 시 MEASURE 포함 23행 기대 |
| 08-05 | ①EXCHANGE SAVE '^' split 2변수 복원(전 필드 NULL→INVALID 파손) ②GET_DM_MDF_VERSION `NVL(ATTRIBUTE1,NULL)` CHR(0) 정정 + Description 미입력 시 전행(Δ) ③메인 SAVE D삭제·중복제거 EXISTS B측 NVL 정규화(hook #119 — 재수정 silent 미반영 해소) |

## 3. 적용 순서 (SCM_MGR / [7]만 APP 계정)

| 순서 | 파일 | 비고 |
|---:|---|---|
| 0 | `90_VERIFY [8]` 공용 의존 6종 사전 확인 | FN_STRING_SPLIT 등 — 0행/INVALID 면 선행 이관 필요 |
| 1 | **클라우드 BE 정지** | live PKG 재배포 pin 방지. `ALTER SESSION SET DDL_LOCK_TIMEOUT=120` 권장 |
| 2 | `sp/00` → `sp/01` → `sp/02` | GTT → SPEC → BODY (의존순) |
| 3 | `sql/01` ~ `sql/06` 번호순 | 메타 (INSERT-only 멱등) |
| 4 | `sql/07` | 환율 원장 (0행 확인 후 — 멱등이라 재실행 무해) |
| 5 | `sp/03` | GRANT + SYNONYM (⚠ APP 계정명 = 클라우드 **SCMP_APP** 치환 확인) |
| 6 | **BE 재기동** → `90_VERIFY` [1]~[8] | 기대값 대조 |
| 7 | FE 배포 — `fe/` 폴더 **전체 checkout** (파일 단위 덮어쓰기 금지) | + §4 FE 참고 |
| 8 | 화면 E2E — 조회(40/81/82)·저장·환율/Cutoff/Replace 모달 | 저장 SP 직접 실행 금지 (hook #104) |

## 4. FE 참고 (fe/ 밖 의존 — 클라우드 셸 최신본 전제)

- **본 패키지 밖 공용**(클라우드 기존본 전제 — 구세대면 폴더 전체 checkout 원칙 적용):
  `features/master/src/components`(ColumnLayoutModal/ProjectByDivisionModal/ItemByDivisionModal/카탈로그 필드 7종),
  `configs/types/procedures.d.ts` 의 DMF0042 블록, viewRegistry/route-paths('business-plan' + SLUG_ALIAS 'dmf0042'), `@shared/*`.
- locales JSON 은 이관 제외 정책(2026-07-24) — `sql/06` 의 MSG_M 등록 후 클라우드 `gen:i18n` 재생성으로 반영.
- ⭐ 08-05 FE 최종 반영분: MEASURE 정적 마지막 상시표시+ColumnSetting 제외 / cascade 보완 5(F-1·F-2·F-4·G-1·G-2) /
  감사키(createdBy/lastUpdatedBy) FE 전달 4곳 / Cutoff·Replace 모달 재구현(조회 SP 스왑) / 환율 '0'=삭제 /
  Division 콤보 disabled(환율·Cutoff) / GRID_EDIT_COMBO `DMF0042CellProdSiteValid` 등재명 정정.

## 5. 미포함 / 주의

> ✅ **CMBO `EndCustomerByDivision40` DEPT_ID 확장 — 2026-08-05 17:26 사내 적용 완료·검증**(1,866행 중 DEPT_ID 937 채움,
> lookup UNION 행 NULL=공란 통과 규약) → `sql/05` 17:30 재추출 반영(신규 INSERT + 기존재 시 확장 UPDATE 동기화).
> FE 는 F-2(toOptions deptIds 필터)·G-1(cascade DEPT_ID40 키) 선반영분이 즉시 발효 — 40 EC 콤보/grid EC40 콤보에 Team 반영.

| 항목 | 사유 |
|---|---|
| 공용 SP/함수 6종 | 룰 22 §9.5 — 기존재 전제, 90_VERIFY [8] 로 확인 |
| lookup 마스터(BUCKET2_TYPE_CODE/ITEM_TYPE_CODE/DM_CELL_PROD_SITE/GET_ADMIN_GROUP/DM_LONG_PLAN 등) | 공용 마스터 — 기존재 전제 (colombo 05 의 SQL 이 참조. 결측 시 콤보 빈값으로 드러남) |
| 사용자 titleset 개인화 | 사용자 데이터 — 이관 대상 아님 (오염 정정 DELETE 만 04 에 동봉) |
