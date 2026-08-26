# DMF0082 (FCST&PRICE MGMT) 클라우드 이관 패키지 — 2026-08-20 취합

> **상태: 취합 완료 / 클라우드 미적용.** 직전 클라우드 패키지 = `DMF0082_CLOUD_20260818`.
> 본 패키지 = 그 이후 delta 전량 (기계 스윕 실측 — 메타 축 10종 `LAST_UPDATE_DATE >= 2026-08-18`
> + BODY 마커 스윕 + GTT 64종 존재 스윕 + git 워킹트리 diff). DB 원문은 전부 **사내 라이브
> 신선 덤프**(ALL_SOURCE·원장, 2026-08-20 — 파일 재사용 아님).
> ⭐ 사용자 지시: **데이터 UPDATE(중복 정리·정규화·AS From Site NULL 치환)는 제외** /
> **DDL 변경분(DEFAULT ON NULL)은 포함**.

## 담긴 정정 (전부 사내 적용·실증 완료)

| # | 정정 | 마커 (BODY 검증 카운트) |
|---|---|---|
| 1 | Excel 주간 업로드 전환 — 주 시작일 동적 헤더(V_TITLE 실측 해석)·주차값→일 전개, LOC 전용 | `XLSWEEKLY` 14 |
| 2 | Excel Form — 현재 조회조건 데이터 + 기존 LOC 원장 값 채움 | `XLSFORM2` 1 |
| 3 | Excel Form/Upload 81 전용 + LOC 한정 + LOC DAILY 적재 탈락 2지점 정정 + MSG01014 | `XLS81LOC` 16 |
| 4 | SENDER 무값 통과 폐기(GTT NOT EXISTS) | `SENDERJOIN` 5 |
| 5 | 인라인 분해 39지점 → GTT 선적재+IF 게이트 (성능) | `MULTIJOIN` 10 |
| 6 | Project 명 = SCM_MST_PROJECT 조인 + 코드 폴백 | `PJTNAME` 4 |
| 7 | SCM_FCST↔MKT_FCST 동시편집 제약 — GET 적재부 _CURRENT 완전 이식 | `LIMITMEAS` 5 |
| 8 | **저장 성능** — V81-04 검증의 `DM_MST_ITEM_SINGLE_V` 직조인 폐지 → T1 축 인라인 집계 등가 대체. 실측 407s → **0.016s** (Excel [OK] 전체 409s → 수 초) | `XLSSAVEPERF` 2 |
| 9 | **센티널 스키마 강제 전환** — 변형(' '/'-'/'--'/CHR(0)) 동일 처리 8문장 삭제(단순 등호), GTT NVL 정규화 UPDATE 3본 삭제, NVL(키,'-') 전량 제거. 전제 = 03 DDL + **원장 변형 0** (⛔ C4 게이트) | `SENTINELDDL` 12 |
| 10 | **AS From Site NULL 전환** — 판가 행 `'-'` 리터럴 8곳 → NULL, SAVE 의 NVL 보존 폐지(전달값 그대로 — 셀 비우면 삭제됨) | `AFSNULL` 11 |
| 11 | (0820 오전 세션) 메저 룰 정정 | `MEASRULE` 1 |
| 12 | **DDL** — 원장 4본 키 컬럼 `DEFAULT ON NULL '-'`(12/12/13/11) + `GT_PRDM1_T_MAIN` 키 13컬럼 NOT NULL 승격 (감사컬럼 제외 — 사용자 확정) | 03 파일 |
| 13 | FE — Excel 주간 양식/미리보기, Sender Name 등 **빈 셀 그룹 병합**(공용 `mergeManager` opt-in 지점 신설 — 타 화면 기본동작 불변), AS From Site 관련 표시 | B_FE |
| 14 | **(공용 ⚠) titleset 복원** — `c3669d9` 구세대 덮어쓰기로 소실된 컬럼 개인화 조회/저장 엔드포인트 4파일. 소실 시 **전 화면 Grid Column Setting 모달이 빈 목록** | C_BE |
| 15 | **조회조건 콤보 AS-IS 정합 (2026-08-20 사용자 확정)** — Team = `UserTeamByDivision` / End Customer = `EndCustomerByDivision` (AS-IS BigFilter 실경로 1:1 — 구 TeambyDivision/EndCustomer 는 경로 오매칭). 두 CMBO 는 기등록(사내·실측 정상) — 클라우드 CMBO 존재 확인은 90_VERIFY V5b | B_FE ForecastPriceForm |
| 16 | **Grid Column Setting 모달 정본 단일화 (2026-08-20 사용자 확정)** — 정본 = `packages/shared/.../templates/modals/column-layout-modal` 유일(HIDDEN_FROM_LIST fix 이식). master 사본은 재수출 스텁화, DMF0082 는 `@shared/components` 직행 import | B_FE shared-modals + master-columnLayoutModal-stub |

## ⛔ 적용 게이트 (00_CLOUD_PRECHECK C4)

신 BODY 는 변형 동일 처리가 **삭제된** 본문이다. 클라우드 원장(MKT_DEMAND_PLAN/SELLING_PRICE/
FUTURE_PRICE)에 PLANT_SITE_ID 변형이 실재하면(사내는 총 140만 행 실재했음) 조회 dedup·저장 MERGE
키가 갈라져 **중복/누락이 재발**한다. C4 결과 변형 > 0 이면:
1. 02(BODY) 적용 보류
2. 데이터 정리(사내 절차 = `_artifacts/_apply_corporate/DMF0082_SENTINEL_20260820/01_BACKUP.sql` +
   `02_DEDUP_NORMALIZE.sql` — 본 패키지에서 사용자 지시로 **제외**됨)를 클라우드 DBA 와 협의·선행
3. 변형 기록 배치(EXCHANGE_RATE/BATCH_CFM_TO_ALL/BALANCE_MAKE 계열)의 '-' 정규화 반영 확인
   (사내는 2026-08-20 배치 정정 완료)

## 파일 구성 / 적용 순서

```
00_CLOUD_PRECHECK.sql             C1 마커 기준선 / C2 GTT 12종 / C3 DDL 현황 / C4 ⛔변형 게이트 / C5 titleset SP
A_DB/01_PKG_DMF0082_SPEC.sql      94줄  (신선 덤프 — 기존재 시 재실행 무해)
A_DB/02_PKG_DMF0082_BODY.sql      14,686줄 (⭐ 본문 전체 교체 — 위 마커 10계보 일괄. C4 게이트 통과 후!)
A_DB/03_DDL_DEFAULT_ON_NULL.sql   멱등 가드형 (GTT ALTER 는 ORA-14450 시 BE 중지 후 재실행)
A_DB/04_CMBO_SYNC_20260820.sql    5본 MERGE (EndCustomer 는 공유 ⚠ / FcstType 2본 = 08-19 갱신)
A_DB/05_SHEET_META_SYNC_20260820.sql  시트 2본 전량 재적재 (hook #98 §9 — FcstNPrice 61 + Sales Price Save All 25)
A_DB/06_EXCEL_META_SYNC_20260820.sql  EXCEL_COLUMNS 1행 (0820 01:09 갱신분)
A_DB/07_MSG_SYNC_20260820.sql     MSG 10종 × 3언어 (MSG01001 재채번·MSG01014 신설·판가/RMA 문구 8종)
A_DB/90_VERIFY.sql                V1~V8 실측 + V9 런타임 스모크 4종
B_FE/forecast-price/              화면 폴더 전체 (부분 이관 금지 — resolveView 사고 계보)
                                  ⚠ 삭제 파일: utils/forecast-price.excelForm.test.ts — 클라우드에서 제거
B_FE/foundation-utils/mergeManager.ts   → nscm-fe/packages/foundation/src/utils/ (공용 ⚠ — opt-in 지점만 추가)
B_FE/configs-types/procedures.d.ts      → nscm-fe/configs/types/ (공용 타입 — 타 화면 선언 포함, 무해)
B_FE/shared-modals/column-layout-modal/ → nscm-fe/packages/shared/src/components/templates/modals/column-layout-modal/ (⭐ Column 모달 정본)
B_FE/master-columnLayoutModal-stub/     → nscm-fe/features/master/src/components/columnLayoutModal/ (재수출 스텁 2파일 — 기존 화면 호환)
C_BE/admin-menu/                  → nscm-be/src/main/java/com/lgcns/nscm/admin/menu/ (java 3)
                                  → nscm-be/src/main/resources/sql/admin/ (Menu.xml)
```

1. `00_CLOUD_PRECHECK.sql` (QA/DEV 각각) — **C4 변형 0 확인이 02 적용의 전제**
2. `A_DB/03` (DDL) → `A_DB/01` → `A_DB/02` (SPEC→BODY, 각각 단독 실행)
3. `A_DB/04`~`07` (메타)
4. B_FE 폴더 교체(삭제 파일 포함) + C_BE 4파일 교체 → 빌드·재기동
5. `A_DB/90_VERIFY.sql` + V9 런타임 스모크

> 참고: 05 SHEET 재적재의 DELETE 범위 = 삽입 범위(두 시트 전량) — 두 시트 모두 PROGRAM_ID='DMF0082'
> 전용이라 타 프로그램 행 소실 없음. C4 게이트·데이터 정리 협의 외 데이터 변경 없음.
