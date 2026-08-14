# DMF0082 (Fcst&Price MGMT) — 클라우드 이관 패키지 (2026-08-12)

> **기준선**: 클라우드 = 선행 통합 `DMF0082_20260804_1032` 적용 상태(2026-08-04). 본 패키지 = 그 이후
> 사내 변경분 **현행 스냅샷** — 구 `DMF0082_CLOUD_20260808_1830`(A UICATEGORY / B UPFX / C I18N)의 내용을
> **현행본이 포괄·대체**하며, 08-10~12 분(아이콘 순서·TESTFIX·Excel Upload 5-arg·버튼 순서·40 게이트)을 추가.
> QA·DEV **2개 DB 각각** 적용. (⚠ 08-08 패키지를 이미 적용한 DB 여도 본 패키지 재적용 무해 — 전수 UPSERT/REPLACE)

## 담는 작업 (8/4 이후 누적)

08-07 UICATEGORY(81 편집/82 조회 확장) → 08-08 UP_FX 정합 → 08-10 아이콘 순서(hook #120) →
08-11 TESTFIX(대사표·주배분/LOC 복원 등) → **08-12**: ①**Excel Upload 2-Step 완성** — validProc **5-arg 정정**
(구 3-arg = 호출 즉시 PLS-00306)·STORAGE_SQL_ID PKG 표기 정정·FE 판정키 RESULT_CODE ②**Excel 버튼 division 게이트
40 전용 정정**(SP 'Invalid Division(40 Only)' 실측 — 구 81 게이트는 SP 와 충돌) ③버튼 순서
Excel Form→**Excel Upload**→Price Batch→환율→Grid→메저(Upload 를 customButtons 로 이동) ④공통 C1/C2.

## A_DB — 적용 순서 (sqlplus, `SET DEFINE OFF`)

| # | 파일 | 내용 | 방식 |
|---|---|---|---|
| 1 | `01_GTT_DDL.sql` | PKG 참조 GTT 56개 자급 | ORA-955 skip 멱등 |
| 2 | `02_PKG_DMF0082_SPEC.sql` | SPEC 현행 — **P_DMF0082_EXCEL_UPLOAD 5-arg** 포함 | CREATE OR REPLACE |
| 3 | `03_PKG_DMF0082_BODY.sql` | **BODY 현행 13,271행** — UICATEGORY+AUTHUNION+DS2+EXCEL_UPLOAD 5-arg 누적 최종형 | CREATE OR REPLACE |
| 4 | `04_CMBO_SYNC.sql` | 소비 콤보 중 기준선 후 변경 10종(FcstPriceEditMeasure/Auth 계열 등) | MERGE (CLOB 청크) |
| 5 | `05_PROCM_SYNC.sql` | PROC_M 105행 전수(EXCEL_UPLOAD programId/sheetName 5-arg 반영) | MERGE — DELETE 금지 |
| 6 | `06_SHEET_META_SYNC.sql` **(v4)** | ⭐ hook #98 §9(2026-08-12 역전 확정) — **SHEET_NAME 단위 DELETE 후 사내 전 행 재적재**: 'FcstNPrice' COLUMNS 61+MEASURE 22 / 'Sales Price Save All' COLUMNS 49(공유분 포함 전량). 삭제=삽입 132행 일치·VERIFY 동봉(사내 드라이런 PASS) | DELETE+INSERT 완전 교체 |
| 7 | `07_LOOKUP_SYNC.sql` **(v2)** | `GET_ADMIN_GROUP_MEASURE`(DMF0082 28행) — **PK 6컬럼(SEG1~5)** MERGE + SEGMENT5 상이 구행 선삭제(DMF0021 적용 중 발생한 ORA-00001 계보 선제 정정) + VERIFY | DELETE(표적)+MERGE |
| 8 | `08_BTN_WIRING_SYNC.sql` | 버튼 배선+권한 112행 전수(UPLOAD/UPLOAD_SAVE/UPLOAD_DATA 포함) | MERGE |
| 9 | `09_API_SYNC.sql` | API 16행 전수 | MERGE |
| 10 | `10_EXCEL_COLUMNS.sql` | Excel Upload 헤더 매핑 + **validProc = PKG 표기 정정** | MERGE |
| 11 | `11_MSG00705.sql` | Excel Form 조회 0건 안내 메시지 3언어 (08-12 오후 신설) | MERGE |

> ⭐ **08-12 오후 추가분(BODY 재동기화 완료)**: Excel Form **조회 구현** — 근본원인 = 업로드 검증 SP 의
> ANSI JOIN **ON 절 상관조건 유실**(`L.SEGMENT4=A.ATTRIBUTE10`)로 측정코드 오배정 → GET 필터 전멸(업로드
> 성공인데 조회 0행). BODY 패치(measureOnFix — 백업 `_apply_corporate/BACKUP_PKG_DMF0082_BODY_beforeMeasureOnFix_20260812.sql`)
> + FE 모달 조회(UPLOAD_DATA — Daily PIVOT o_rc2)·Excel Download 조회값 복원. **BUCKET 연동 = SP 내부 자동**
> (DM_MST_BUCKET_CONVERSION 일할 분배 + DEFAULT_BUCKET_DAY lookup — FE 파라미터 아님, AS-IS 계약).
> Upload 헤더는 M4~M16 월간 고정이 원문 계약(주간/일간 변형 부재).

## B_FE

| 경로 | 내용 |
|---|---|
| `B_FE/forecast-price/` | 페이지 폴더 전체 30파일 — 폴더 교체(룰22 §10). Excel 게이트 40·버튼 순서·판정키·TemplateModal 실월 병기 포함 |
| `B_FE/fcst-upload-modal/` | ⚠ 공용(`features/demand/src/components/`) — 2-Step 업로드 모달 |
| `B_FE/gridAction.ts` | ⚠ 공용 — Excel dataMap 승계(전 화면 공통) |
| `B_FE/locales/` | ⚠ 공용 — 키 병합(덮어쓰기 금지) |

## 적용 후 기대치 (사내 실측)

| 축 | 값 |
|---|---|
| PKG | SPEC/BODY VALID + EXCEL_UPLOAD 5-arg |
| Excel Upload [Upload] | multipart → 검증 8종 분류(O_CUR_CNT/O_CUR_LIST — 40 Only/EC/Site/Model/Incoterms/FcstType/Handbook/CellProdSite/Measure/Currency/숫자/음수/0) |
| Excel Upload [OK] | UPLOAD_SAVE(mode=1) → `RESULT_CODE 0 / 'SUCCESS=n, ERROR=n'` |
| Excel 버튼 | division **40 에서만** 노출 (Form → Upload → Price Batch → 환율 → Grid → 메저 순) |
