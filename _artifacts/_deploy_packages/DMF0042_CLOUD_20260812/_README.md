# DMF0042 (Business Plan) — 클라우드 이관 패키지 (2026-08-12 재생성본)

> **성격**: 현행 전수 스냅샷 — 8/5 패키지 이후 사내 변경(08-09 AUTHUNION·E2E 배선 / 08-12 재점검
> 보완·Search 라벨 LBL00112 표준화)을 포함한 최종형. 재적용 무해(PK/논리키 실측 UPSERT).
> QA·DEV **2개 DB 각각** 적용.
>
> ⭐ **재생성(같은 날 2차) 사유 — measureSelectModal**: **클라우드에 기존 공용이 실재**(사용자 확인)
> 하므로 적용 대상에서 제외. 사내 신설본은 `B_FE/_reference_사내신설본_적용금지/` 에 계약 대사용으로만
> 격리 동봉했다. **클라우드 기존 공용을 유지**하고, `business-plan/components/BusinessPlanModals.tsx` 의
> `import { MeasureSelectModal } from 'features/master/src/components'` 가 클라우드 공용 barrel 에서
> 해석되는지(export 실재 + props 계약: `measures/visibleMeasures/onApply`)만 확인. 계약 상이 시 =
> 기존 공용에 **optional prop 병합**(파일 덮어쓰기 ⛔ — 클라우드 셸 신구 세대 혼재 계보).

## 담는 작업 (8/5 이후 누적)

08-09 게이트 마감(AUTHUNION·FCST_TYPE 셀 콤보 divisionId 배선) → **08-12 재점검**: ①hook #132 소급
(페이지/DataGrid 래퍼 div 제거·설정 저장=그리드 비움) ②게이트 §3 NLS — **PROC_M `PR_GET_DAY_RANGE.month`
VARCHAR→NUMBER** ③hook #133 UC-01(Insert 필터 clear)/UC-02(조회 MSG00703 confirm) ④Search 라벨
LBL00112(hook #120 §5) ⑤단위테스트 +27(spread/editLock).

## A_DB — 적용 순서 (sqlplus, `SET DEFINE OFF`, QA·DEV 각각)

| # | 파일 | 내용 | 방식 |
|---|---|---|---|
| 1 | `01_GTT_DDL.sql` | PKG 참조 GTT 23개 자급 | ORA-955 skip 멱등 |
| 2 | `02_PKG_DMF0042_SPEC.sql` | SPEC 현행 | CREATE OR REPLACE |
| 3 | `03_PKG_DMF0042_BODY.sql` | BODY 현행 6,600행(AUTHUNION·titleset 가드 누적 최종형) | CREATE OR REPLACE |
| 4 | `04_CMBO_SYNC.sql` | 소비 콤보 18종 전수(공유 콤보 포함 — 타 화면과 동일 원장) | MERGE (CLOB 청크) |
| 5 | `05_PROCM_SYNC.sql` | DMF0042 배선 + 공용 `PR_GET_DAY_RANGE`(month **NUMBER**) 121행 | MERGE — DELETE 금지 |
| 6 | `06_SHEET_META_SYNC.sql` **(v4)** | ⭐ hook #98 §9(2026-08-12 역전 확정) — **SHEET_NAME 단위 DELETE 후 사내 전 행 재적재**: 'Biz Plan' COLUMNS 63+MEASURE 9. 삭제=삽입 72행 일치·VERIFY 동봉(사내 드라이런 PASS) | DELETE+INSERT 완전 교체 |
| 7 | `07_LOOKUP_SYNC.sql` | GET_ADMIN_GROUP(_MEASURE) 6행 — **PK 6컬럼(SEG1~5)** MERGE + SEG5 변형 구행 선삭제 + 말미 VERIFY(논리키 중복 0) | DELETE(표적)+MERGE |
| 8 | `08_BTN_WIRING_SYNC.sql` | 버튼 배선+권한 145행 전수 | MERGE |
| 9 | `09_API_SYNC.sql` | API 23행 전수 | MERGE |
| 10 | `10_MSG_LBL_SYNC.sql` | MSG00675~680·400/401 + LBL 8종 3언어 33행 | MERGE |

(전 파일 = 사내 라이브 재추출본. 1차 생성분은 사내 드라이런 오류 0 실측 — 재생성분은 동일 생성기 재실행.)

## B_FE

| 경로 | 내용 |
|---|---|
| `B_FE/business-plan/` | 페이지 폴더 전체 27파일 — #132/#133 보완·LBL00112·대사표 279행·신설 테스트 2본 포함 현행 최종본(폴더 교체 — 룰22 §10) |
| `B_FE/gridAction.ts` | ⚠ 공용(`packages/foundation/src/utils/`) — Excel Download dataMap 승계(UC-05. 타 패키지와 동일 파일) |
| `B_FE/locales/` | ⚠ 공용 — 키 병합(덮어쓰기 금지) |
| `B_FE/_reference_사내신설본_적용금지/` | measureSelectModal 사내 신설본 + master index — **적용 금지, 클라우드 기존 공용과의 계약 대사용 참고 자료** |

## 검증 근거 (사내 2026-08-12)

대사표 279/279 + 인용 실재성 / 게이트 PASS 8·WARN 1(§7 사유형) `DMF0042_20260812_1538.md` /
E2E 15계정 PASS `DMF0042_http_e2e_20260812_1452.md` / demand 200 tests / tsc 0.
