# DMF0003 (MKT FCST) — 클라우드 이관 패키지 (2026-08-12)

> **기준선**: 클라우드는 `DMF0003_CLOUD_SQLPLUS_ALL_20260805.sql` 까지 기적용 상태(2026-08-05).
> 본 패키지 = **기준선 이후 사내 변경분 전수** — 사내 라이브 DB 감사컬럼(LAST_UPDATE_DATE ≥ 2026-08-05)
> 실측으로 추출한 스냅샷(추측 0). QA·DEV **2개 DB 각각** 적용.

## 이 패키지가 담는 작업 (2026-08-10~12 사내 세션)

1. **정본 재대사** — AS-IS 정본(`GSCM.DM.Forms.UIL/Plan/DMF0003_MktFcst/` 7,143줄) 기준 대사표 159행 재생성
   + 갭 7건 보완(CA-04/07·CD-02/10·CE-02/04·CG-05).
2. **SAVE 권한·시간창 게이트(AUTHGATE)** — SCP Planner 가 SAVE 를 서버 통과하던 결함 이식 정정
   (BODY L10111~, `GET_ADMIN_GROUP_MEASURE` lookup 소비 — 실 CRUD 로 차단·회귀 검증 완료).
3. **통합테스트 사전점검 1st No.50~57 (8건)** — 미충족 4건 보완
   (No.52 lookup 82 제외 마킹 / No.54·56-①·57 FE / No.60-① 공용 Excel dataMap 승계).
4. 진단 3축 결과: 대사표 345… (DMF0003 은 159/159) PASS + 게이트 9섹션 FAIL 0 + E2E 15계정 FAIL 0
   (M축 전용 키 probe 포함) — 리포트 `_artifacts/_gate_reports/DMF0003_*_20260812_*.md`.

## A_DB — 적용 순서 (sqlplus, `SET DEFINE OFF`)

| # | 파일 | 내용 | 방식/멱등성 |
|---|---|---|---|
| 1 | `01_GTT_DDL.sql` | PKG 참조 GTT **65개 전량** DDL 자급 | EXECUTE IMMEDIATE + ORA-955 skip (기존재 무해) |
| 2 | `02_PKG_DMF0003_SPEC.sql` | SPEC 현행 (사내 0723 본) | CREATE OR REPLACE |
| 3 | `03_PKG_DMF0003_BODY.sql` | **BODY 현행 15,014행** — AUTHGATE(저장 게이트) 포함 최종형 | CREATE OR REPLACE |
| 4 | `04_CMBO_SYNC.sql` | DMF0003 소비 콤보 8종 현행 스냅샷 (PlantSiteByItem 신설 + Division/DefaultBucketDay/Auth 계열 3종/40 계열 2종) | MERGE (CLOB 청크) |
| 5 | `05_PROCM_CURSOR_FIX.sql` | PROC_M 커서 정정 15행 (0812 — PSI/CAR 계열 o_rc·owner IN 정정) | MERGE — **DELETE 금지 규약** |
| 6 | `06_LOOKUP_MKT_FCST_MEASURE_82_EXCLUDE.sql` | (No.52) 82 편집 measure 4종 ATTRIBUTE2='Y' 제외 마킹 | UPDATE 조건 가드·멱등 |
| 7 | `07_SHEET_COLUMNS_SYNC.sql` | 'Mkt Fcst' 0805 이후 변경 3행(TEAM_ID/END_CUSTOMER/END_CUSTOMER40) 현행값 | MERGE — DELETE 절대 금지 |
| 8 | `08_MSG00703.sql` | 공통 재조회 확인 MSG 3언어 (0811 신설) | MERGE |
| 9 | `90_VERIFY.sql` | 검증 6항목 — **기대치 주석 명기** | SELECT only |

⚠ 제외분(다른 화면 패키지 소관 — 누락 아님): `GET_ADMIN_GROUP_MEASURE` 'DM Planner (W/S)' DMF0082 행(0807/0811)
= DMF0082 패키지 / `SalesPlanItemId`·`MSG00704` = DMF0021 패키지 / `QtyType`·`ReportBucketType`·LBL00852~854·MNU00691
= DMF0035 Waterfall 패키지 / `FcstTypeByUserGroupDMF0082`·`FcstPriceEditMeasure`·`SalesFuturePriceEditableDivision`·DMF0044_* = 각 해당 화면.

## B_FE — FE 반영분

| 경로 | 내용 |
|---|---|
| `B_FE/mkt-fcst/` | 페이지 폴더 **전체 26파일** (대사표·단위테스트 16 포함) — 폴더 교체(룰22 §10 폐포) |
| `B_FE/gridAction.ts` | ⚠ **공용**(`packages/foundation/src/utils/`) — Excel Download 콤보 컬럼 dataMap 승계 (No.60-① — "★ 모든 화면" 요구. 전 화면 수혜, dataMap 없는 컬럼 무영향) |
| `B_FE/locales/{KO,EN,CN}.json` | ⚠ **공용**(`nscm-fe/public/locales/`) — MSG00703/MSG00704 키 포함 현행본. 클라우드 locales 가 더 최신 키를 갖고 있으면 **파일 덮어쓰기 금지, 키 병합**(클라우드 셸 신·구 세대 혼재 규약) |

## 적용 후 기대치 (사내 실측과 동일해야 함)

| 축 | 값 |
|---|---|
| PKG | SPEC/BODY 모두 VALID + BODY 에 AUTHGATE 블록 |
| 82 편집 measure 콤보 | `AS_In_Req / MKT_FCST_RP / VMI_In_Req` 3종 |
| SCP Planner 82 SAVE | 결과커서 CODE -1 "SCP Planner 권한사용자의 수정 가능한 시간이 아닙니다" |
| 82 SEARCH | code 0 (사내 626행 — 데이터 상이 가능) |

관련 문서: `Doc/화면분석서/DMF0003_테스트시나리오_체크리스트_20260812.md`(T1~T12) ·
`DMF0003_단위테스트결함_대조_20260812.md`(No.50~57 판정) · 대사표 `B_FE/mkt-fcst/__asis-mapping__.md`
