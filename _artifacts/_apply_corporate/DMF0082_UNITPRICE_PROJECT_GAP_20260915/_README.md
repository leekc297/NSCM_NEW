# DMF0082_UNITPRICE_PROJECT_GAP_20260915 — MKT FCST 저장 Unit Price 필수 검증 누락 보완 [E20260915-PRICEPJTGAP]

## 요구 (사용자 2026-09-15)
DMF0082 MKT FCST 수량 입력 시 Unit Price 필수. 예외 경로 조사 결과 4번(Project Code 불일치 품목 누락)을 **누락되지 않도록** 보완.
3번 제외(`SALES_PLAN_ADJUST_YN='N'`)는 **AS-IS 대로 유지**(사용자 선택 A).

## 원인 — AS-IS 동일 로직
| 검증 | AS-IS `dbo.DMF0082_SAVE_MAIN_DATA` | 판정 키 |
|---|---|---|
| #5 Site/Item Master Valid | L871-895 | Division+Site+Model (Project 미포함) |
| #10 Sales Price 52주 | L1185-1191 `INNER JOIN SCM_MST_SITE_ITEM Z` | Division+**Project**+Site+Model |
→ 다른 Project 로만 마스터가 등록된 품목은 #5 통과 후 #10 에서 조용히 제외 → Unit Price 없이 저장. AS-IS 부터 동일(AS-IS DEV 2026-09-15 13:19 조회).

## 3번 제외 AS-IS 확인 (2026-09-15 13:32, LESDFPSTO1C01/LGCE_SCMDEV, SCP_MGR_DEV)
- 코드 실재(L1191) · 화면 호출(`DMF0082_FcstNPrice_Mgmt.cs:2031`) · 설정 경로 DMF0005 "Sales Plan Sync"(`DMF0005_SAVE_SALES_SITE_MODEL_PRODUCTION`, 신규 기본 'Y')
- AS-IS 원장 'N' = **40·81 계열 0건**(전부 82). 사내 TO-BE 40·81 'N' 5건은 2026-09-04~09 minyonglee1 수정분(테스트 값 추정).

## 조치 — 동일 판정식 2곳 (쌍 치환)
1. `P_DMF0082_SAVE_MAIN_DATA` 검증 #10
2. `P_DMF0082_EXCEL_UPLOAD` 행별 ERROR 분류 (SAVE #10 복제 판정식 — Upload 통과/저장 차단 불일치 방지)

변경: `INNER JOIN SCM_MST_SITE_ITEM Z(Project 일치·조정 Y/NULL)` 제거 →
`WHERE ... AND NOT EXISTS (SITE_ITEM Division+Project+Site+Model, VALID_YN='Y', SALES_PLAN_ADJUST_YN='N')`
= 전 행 검사 기본, 조정 제외 'N' 명시 행만 제외. (SITE_ITEM PK = Division+Project+Site+Item 실측)

## 적용 (사내 ZIOUI1 — 2026-09-15 13:36 완료)
| 파일 | 결과 |
|---|---|
| 00_BACKUP_ASIS/PKG_DMF0082_BODY.ASIS.sql | 적용 직전 BODY (환율 모달 LASTUPDATE 반영본 기준) |
| 01_APPLY/PKG_DMF0082_BODY.sql | 게이트 통과 배포 — PACKAGE/BODY VALID · ERRORS 0 · 배포본==01_APPLY |
| apply_sp.py | backup / apply / verify |

## 검증 (ASIS·TOBE #10 SELECT 원문 추출 → 세션 GTT 적재 → 실행 비교, ROLLBACK)
| 케이스 | 키 | before | after |
|---|---|---|---|
| 4번 대상 (#5 통과·Project 불일치) | INFAC_KR_JCH/MCMMA38038A1-021, INFAC_KR_JCH/MCMMA38038A1T002, Eclipse Space_US_ELS/MCCM350415A1 | PASS | **BLOCK** |
| 기존 검사·단가 미충족 | INFAC_KR_JCH/MCMMA38038A1-016·017·020 | BLOCK | BLOCK |
| 기존 검사·52주 단가 완비 | ABS_US_LRP/MCCM348018A3, Airbus_FR_SCY/MCCH129520B1·MCCM134010A1 | PASS | PASS |
| 3번 제외 (조정 N) | Peopleworks_KR_SEL·KUM/ECE0074N5-01 | PASS | PASS |
Excel Upload 판정식은 SAVE 와 동일 텍스트 치환(실행 검증은 SAVE #10 로 대표).

⚠ AS-IS 대비 **의도적 강화** — `forecast-price/__asis-mapping__.md` 기록.

## 클라우드
01_APPLY 는 사내 BODY 전체본 — 클라우드 BODY 가 다르면 통째 덮어쓰기 금지. `apply_sp.py` 의 patch()(2곳 쌍 치환 · 2건 아니면 중단)를 클라우드 BODY 에 적용.

## 원복
`00_BACKUP_ASIS/PKG_DMF0082_BODY.ASIS.sql` 실행.
