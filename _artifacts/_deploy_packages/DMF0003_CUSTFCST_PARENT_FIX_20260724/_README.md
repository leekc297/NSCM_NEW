# DMF0003 (81) `└ EXCEL` 상위 메저 부재 fix — MAKE_CUST_FCST 배치 CI 등가 결함 — 2026-07-24

## 증상 (사용자 신고)
81 조회 시 `ACEN1063I-D1R000 / E63FR000 / FCA / WSF / E` 조합에서 상위 메저 없이 `└ EXCEL`
(Cust.FCST_EXCEL[P+P]) 만 표시.

## 원인 사슬 (실측 확정)
1. 상위 `CUST_FCST` 행은 GET SP가 만들지 않음 — **배치 `PR_DM_PLN_MKT_FCST_MAKE_CUST_FCST`**
   (EXCEL+EDI → CUST_FCST(P+P) 통합, CREATED_BY='MAKE_CUST_FCST')가 원천 테이블에 생성.
   (GET SP 의 승격 블록들은 AS-IS 에서도 전부 주석 — "[E20241030-000923] CUST_FCST 데이터를 생성하기 때문" 파리티 정확.)
2. 해당 EXCEL 4행은 **2026-07-10 TO-BE 업로드분**(minyonglee1) — 상위 미동반.
3. **배치 결함**: 소스 필터 `MEASURE IN ('Customer Fcst', 'CUST_FCST_EDI')` — 실데이터는 `'Customer FCST'`(대문자).
   MSSQL CI collation 에선 매칭, **Oracle CS 에선 불일치 → EXCEL 업로드분이 상위 통합에서 통째 제외**.
   (AS-IS 원문도 'Customer Fcst' 표기 — CI 전제의 1:1 복사가 CS에서 깨진 전형 함정, hook #116 계열.)

## 수정 (해당 라인 1곳만)
```sql
AND UPPER(MEASURE) IN ('CUSTOMER FCST', 'CUST_FCST_EDI')  -- MSSQL CI 등가
```

## 적용 (클라우드)
```
sp/PR_DM_PLN_MKT_FCST_MAKE_CUST_FCST_fix.sql   (standalone SP 재배포)
+ 적용 후 배치 1회 실행: EXEC SCM_MGR.PR_DM_PLN_MKT_FCST_MAKE_CUST_FCST('81');  (필요 division 별)
```

## 검증 (사내 OCGSCMD_P01, 2026-07-24 적용·실행 완료)
- SP VALID / errors 0. 배치 실행(81) → 상위 CUST_FCST **(WSF,FCA) 2행 생성**.
- GET 재호출: 해당 item = `CUST_FCST (sort 50, WSF/FCA)` + `└ Cust.FCST_EXCEL[P+P] (50.1, WSF/FCA)` **동반 표시** ✔.
- 전 오브젝트 sweep: `'Customer Fcst'` 소문자 리터럴 잔존 0 (fix 주석 제외).

## 잔여/참고
- 배치 트리거 체인(TO-BE 이관 확인): `PR_DM_PLN_CUST_FCST_TO_MKT_FCST` / `PR_DM_DNM_EDI_CALLOFF_MKT_FCST` → MAKE_CUST_FCST.
  향후 업로드는 체인 경유 시 자동 반영. (참고: `_CUTOFF` 변형 배치는 TO-BE 미이관 — 배치 보류 방침 여부 확인 대상.)
- 사내 배치 최근 실행이 2026-05-15 이었음 — TO-BE 배치 스케줄 등록 여부 점검 권장.
