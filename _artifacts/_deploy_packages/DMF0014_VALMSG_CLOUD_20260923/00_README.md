# DMF0014 Excel Upload — 검증 메시지 시인성 보완 클라우드 이관 패키지 (2026-09-23) [E20260923-DMF0014VALMSG]

## 무엇이 바뀌나 (사용자 요청 2026-09-23)
Excel Upload 검증 결과(Error Detail 그리드 MESSAGE_TEXT)가 **문제 컬럼과 실제 입력값**을 바로 보여준다.
- 규격: `<규칙명> [<헤더 라벨>: <입력값>]` — 예) `Invalid Sales Site [Sales Site*: ZZ_SITE]`
- 동적(기간) 구간은 **칸 단위**: `Invalid Numeric [20261005: abc]` / `Invalid Decimal [20261005: 130.2]` / **`Please Input QTY [20261005]`**(빈 칸, 입력가능 주차만)
- 한 원인이 여러 메시지로 번지지 않게 상위 검증 통과 행에만 하위 검증 적용(반려 집합은 그대로)
- `Invalid Customer Project` 분리 신설(종전엔 `Invalid Customer Model` 로 표기) · `Invalid Upload UOM (Customer FCST)` → `Invalid Measure` 개명
- 전/후 전체 비교 = `DMF0014_Excel_Upload_Validation_Rules_v3_20260923.xlsx` (21행)

**FE/BE 변경 없음** — DB 객체만. 패키지 상태변수 없음 → BE 재기동 불요.

## 포함 객체 (사내 ZIOUI1 원문 = 2026-09-23 검증본, `_MANIFEST.md` 참조)
| 파일 | 객체 | 비고 |
|---|---|---|
| `12_PKG_DMF0014_PACKAGE.sql` | PKG_DMF0014 SPEC | 무변경(2026-09-15) — BODY 와 쌍으로 동봉 |
| `13_PKG_DMF0014_PACKAGE_BODY.sql` | PKG_DMF0014 BODY | **이번 변경** — 메인 프로시저 `P_DMF0014_CUST_FCST_EXCEL_UPLOAD` 검증부 |
| `30_EXCEL_COLUMNS_DMF0014.sql` | SCM_ADM_EXCEL_COLUMNS | ⭐ **09-23 정정** — HEADER_CONTENT 동적 토큰(W27~W31) 제거, 식별 13토큰만 (클라우드 BE 가 전 토큰을 헤더와 대조해 `Invalid Column Header Title` 발생). 사내도 동일 값 적용·22/22 회귀 PASS |
| `31_ROLLBACK_EXCEL_COLUMNS_DMF0014.sql` | (원복) | Flashback Query 로 30_ 적용 직전 값 복원 — 필요 시만 |

## 적용 절차 (SCM_MGR 접속 · SQL*Plus/SQLcl/SQL Developer 스크립트 실행)
1. `@00_PRECHECK.sql` — 조회 전용. PKG_DMF0014 BODY 행의 `EXPECTED_MISSING` 에 `E20260923-DMF0014VALMSG` 가 있으면 미반영 상태.
   `CLOUD_ONLY_MARKERS` 가 비어 있지 않으면 **전체교체 전 결과 공유** (클라우드 단독 수정분 보존).
2. `@12_PKG_DMF0014_PACKAGE.sql` → `@13_PKG_DMF0014_PACKAGE_BODY.sql` (SPEC → BODY 순서)
3. `@30_EXCEL_COLUMNS_DMF0014.sql` (⭐ 09-23 정정본 — W27~W31 제거. 이미 구 30_ 을 적용했다면 이 정정본을 다시 실행)
4. `@90_VERIFY.sql` — PKG_DMF0014 VALID · USER_ERRORS 0 · INVALID 0 · SCMP_APP 시노님/EXECUTE 존재
5. 화면 DMF0014 → Excel Upload 로 `C_TESTDATA/` 케이스 확인

## 확인용 테스트 데이터 `C_TESTDATA/` (단일 시트 파일 22본 — BE 는 첫 시트만 읽음)
- `00_INDEX_통합본_대조용.xlsx` 의 `00_INDEX` 시트 = 케이스별 **기대 메시지**(사내 실측 기준) · 각 `NN_ID.xlsx` 를 그대로 업로드
- 사내 실측 결과 `DMF0014_excel_upload_cases_20260923_1059.md` — 22/22 PASS
- ⚠ **시효**: 기간 헤더 = 2026-09-28(월) 시작 4주. 2026-10-05 이후엔 첫 주가 과거 주차가 되어 회색 처리될 수 있음 → 생성기 재실행 필요
- ⚠ **앵커**: 기준행 = Division 81 · Sales Site `GM_US_BQN` · Customer Project `SGM Modified` / Model `N2.2` · Project `A17LG8001` / Model `ACEN4065I-A1` · Measure `Customer FCST`(WEEKLY/CELL)
  + 18_MDL 은 SITE_ITEM `D18GM0001 / DMAT_0000066`(ITEM_SN 미등재). 클라우드 원장에 이 조합이 없으면 00_OK 부터 마스터 오류 → 아래 ANCHOR 확인
  ```sql
  SELECT 'CUST_MODEL' K, COUNT(*) FROM DM_MST_CUSTOMER_MODEL WHERE DIVISION_ID='81' AND SCM_SITE_ID='GM_US_BQN' AND CUSTOMER_PROJECT_CODE='SGM Modified' AND CUSTOMER_MODEL='N2.2' AND VALID_YN='Y'
  UNION ALL SELECT 'CUST_FCST_WEEK', COUNT(*) FROM DM_MST_CUSTOMER_FCST WHERE DIVISION_ID='81' AND SCM_SITE_ID='GM_US_BQN' AND MEASURE='Customer FCST' AND UPLOAD_UOM='CELL' AND UPLOAD_BUCKET_TYPE='WEEKLY' AND VALID_YN='Y' AND SUMMARY_BUCKET_VALUE IN ('20260928','20261005','20261012','20261019')
  UNION ALL SELECT 'SITE_ITEM_MDL', COUNT(*) FROM SCM_MST_SITE_ITEM WHERE DIVISION_ID='81' AND SCM_SITE_ID='GM_US_BQN' AND PROJECT_CODE='D18GM0001' AND ITEM_ID='DMAT_0000066' AND VALID_YN='Y'
  UNION ALL SELECT 'ITEM_SN_ABSENT(0 이어야)', COUNT(*) FROM SCM_MST_ITEM_SN WHERE ITEM_ID='DMAT_0000066';
  ```
  (기대: 1 / 4 / 1 / 0)

## 원복
사내 적용 패키지 `_artifacts/_apply_corporate/DMF0014_VALIDATION_MSG_20260923/00_BACKUP_ASIS/PKG_DMF0014_BODY.ASIS.sql` (2026-09-15 21:01 원문) 실행.
