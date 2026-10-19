# 로컬 검증 가이드 — UI별 standalone SP → PKG 취합 (2026-09-15)

> 대상 DB = 사내 ZIOUI1 (로컬 BE 가 붙는 DB). 사내에는 PKG 취합(STEP 2)·META 전환(STEP 3)이 **적용 완료**, standalone 삭제(STEP 4)는 **미적용**.
> 즉 지금 로컬 화면은 **PKG 멤버를 호출**한다. 문제가 생기면 해당 PKG `03_meta/<PKG>/39_META_ROLLBACK.sql` 로 즉시 standalone 호출로 되돌릴 수 있다.

## 1. 기동
```
cd C:\Projects\NSCM\nscm-be   → .\gradlew.bat bootRun   (local 프로파일)
cd C:\Projects\NSCM\nscm-fe   → vite.cmd --port 5173 --host 127.0.0.1
```
- BE 재기동 불요(META 는 호출 때마다 DB 조회). 이미 떠 있으면 그대로 사용.
- 로그인 후 아래 메뉴 순서대로 확인. BE 로그 `nscm-be/logs/nscm.log` 에서 `{call PKG_…` 로 호출 이름 확인 가능.

## 2. 호출 경로 확인 (선택 · DB)
```sql
-- 화면 버튼이 어떤 객체를 부르는지 (전환 후 = PKG_X.P_…)
SELECT T1.MNU_ID, T1.SHT_NM, T1.MNU_BTN_CD, T2.API_URL FROM SCM_ADM_MNU_BTN_MPG_M T1 JOIN SCM_ADM_API_M T2 ON T1.API_ID = T2.API_ID
 WHERE T2.API_URL LIKE 'PKG_DMF0008.%' OR T2.API_URL LIKE 'PKG_DMF004_.%' OR T2.API_URL LIKE 'PKG_DMF0072.%' OR T2.API_URL LIKE 'PKG_DMF0082.P_PR_%' OR T2.API_URL LIKE 'PKG_SYS001_.%'
 ORDER BY 1, 2, 3;
```

## 3. 화면별 체크리스트
| # | 메뉴 | 화면(경로) | 확인 동작 | 호출 객체(전환 후) | 기대 | 결과 |
|---:|---|---|---|---|---|---|
| 1 | DMF0008 | ERP EDI MASTER 정비 (`/erp-edi-master`) | 내부 호출 경로: PKG_DMF0008.P_DMF0008_GET_UPDATE_HISTORY (Update History 조회) | `PKG_DMF0000.P_DMF0000_GET_UPDATE_HISTORY` | 오류 토스트/SQL ERROR 없음 · 데이터 표시(전환 전과 동일) | ☐ |
| 2 | DMF0008 | ERP EDI MASTER 정비 (`/erp-edi-master`) | 시트 `main` — 조회 | `PKG_DMF0008.P_DMF0008_GET_EDI_MST_SUMMARY` | 오류 토스트/SQL ERROR 없음 · 데이터 표시(전환 전과 동일) | ☐ |
| 3 | DMF0008 | ERP EDI MASTER 정비 (`/erp-edi-master`) | 시트 `project` — 저장(테스트 데이터로 1건 수정 후 저장 → 재조회로 반영 확인) | `PKG_DMF0008.P_DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR` | 오류 토스트/SQL ERROR 없음 · 데이터 표시(전환 전과 동일) | ☐ |
| 4 | DMF0008 | ERP EDI MASTER 정비 (`/erp-edi-master`) | 시트 `project` — 조회 | `PKG_DMF0008.P_DMF0008_GET_SALES_SITE_PROJECT_MODEL` | 오류 토스트/SQL ERROR 없음 · 데이터 표시(전환 전과 동일) | ☐ |
| 5 | DMF0008 | ERP EDI MASTER 정비 (`/erp-edi-master`) | 시트 `repair` — 저장(테스트 데이터로 1건 수정 후 저장 → 재조회로 반영 확인) | `PKG_DMF0008.P_DMF0008_SAVE_SALES_SITE_EDI_REPAIR` | 오류 토스트/SQL ERROR 없음 · 데이터 표시(전환 전과 동일) | ☐ |
| 6 | DMF0008 | ERP EDI MASTER 정비 (`/erp-edi-master`) | 시트 `repair` — 조회 | `PKG_DMF0008.P_DMF0008_GET_EDI_MST_REPAIR` | 오류 토스트/SQL ERROR 없음 · 데이터 표시(전환 전과 동일) | ☐ |
| 7 | DMF0008 | ERP EDI MASTER 정비 (`/erp-edi-master`) | 시트 `salesSite` — 저장(테스트 데이터로 1건 수정 후 저장 → 재조회로 반영 확인) | `PKG_DMF0008.P_DMF0008_SAVE_SALES_SITE_EDI_REPAIR` | 오류 토스트/SQL ERROR 없음 · 데이터 표시(전환 전과 동일) | ☐ |
| 8 | DMF0008 | ERP EDI MASTER 정비 (`/erp-edi-master`) | 시트 `salesSite` — 조회 | `PKG_DMF0008.P_DMF0008_GET_SALES_SITE` | 오류 토스트/SQL ERROR 없음 · 데이터 표시(전환 전과 동일) | ☐ |
| 9 | DMF0008 | ERP EDI MASTER 정비 (`/erp-edi-master`) | 시트 `site` — 조회 | `PKG_DMF0008.P_DMF0008_GET_SALES_SITE` | 오류 토스트/SQL ERROR 없음 · 데이터 표시(전환 전과 동일) | ☐ |
| 10 | DMF0008 | ERP EDI MASTER 정비 (`/erp-edi-master`) | 시트 `sspm` — 저장(테스트 데이터로 1건 수정 후 저장 → 재조회로 반영 확인) | `PKG_DMF0008.P_DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR` | 오류 토스트/SQL ERROR 없음 · 데이터 표시(전환 전과 동일) | ☐ |
| 11 | DMF0008 | ERP EDI MASTER 정비 (`/erp-edi-master`) | 시트 `sspm` — 조회 | `PKG_DMF0008.P_DMF0008_GET_SALES_SITE_PROJECT_MODEL` | 오류 토스트/SQL ERROR 없음 · 데이터 표시(전환 전과 동일) | ☐ |
| 12 | DMF0008 | ERP EDI MASTER 정비 (`/erp-edi-master`) | 시트 `summary` — 조회 | `PKG_DMF0008.P_DMF0008_GET_EDI_MST_SUMMARY` | 오류 토스트/SQL ERROR 없음 · 데이터 표시(전환 전과 동일) | ☐ |
| 13 | DMF0008 | ERP EDI MASTER 정비 (`/erp-edi-master`) | 시트 `updateHistory` — 조회 | `PKG_DMF0008.P_DMF0008_GET_UPDATE_HISTORY` | 오류 토스트/SQL ERROR 없음 · 데이터 표시(전환 전과 동일) | ☐ |
| 14 | DMF0040 | MKT FCST Comparison (`/mkt-fcst-comparison`) | 시트 `spreadTitle` — 조회 | `PKG_DMF0040.P_DMF0040_GET_SPREAD_TITLE` | 오류 토스트/SQL ERROR 없음 · 데이터 표시(전환 전과 동일) | ☐ |
| 15 | DMF0043 | Contribution Rate Reg. (`/contribute-main`) | 시트 `ContributeMain` — 저장(테스트 데이터로 1건 수정 후 저장 → 재조회로 반영 확인) | `PKG_DMF0043.P_DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO` | 오류 토스트/SQL ERROR 없음 · 데이터 표시(전환 전과 동일) | ☐ |
| 16 | DMF0043 | Contribution Rate Reg. (`/contribute-main`) | 시트 `ContributeMain` — 조회 | `PKG_DMF0043.P_DMF0043_GET_CONTRIBUTE_MAIN_DATA` | 오류 토스트/SQL ERROR 없음 · 데이터 표시(전환 전과 동일) | ☐ |
| 17 | DMF0043 | Contribution Rate Reg. (`/contribute-main`) | 시트 `ContributeMain` — 버전 관리 팝업 조회 | `PKG_DMF0043.P_DMF0043_GET_CONT_VIEW_VERSIONPOPUP` | 오류 토스트/SQL ERROR 없음 · 데이터 표시(전환 전과 동일) | ☐ |
| 18 | DMF0043 | Contribution Rate Reg. (`/contribute-main`) | 시트 `mainTitle` — 조회 | `PKG_DMF0043.P_DMF0043_GET_MAIN_SPREAD_TITLE` | 오류 토스트/SQL ERROR 없음 · 데이터 표시(전환 전과 동일) | ☐ |
| 19 | DMF0043 | Contribution Rate Reg. (`/contribute-main`) | 시트 `ratePopup` — 조회 | `PKG_DMF0043.P_DMF0043_GET_CONTRIBUTE_RATE_POPUP` | 오류 토스트/SQL ERROR 없음 · 데이터 표시(전환 전과 동일) | ☐ |
| 20 | DMF0043 | Contribution Rate Reg. (`/contribute-main`) | 시트 `salesList` — 조회 | `PKG_DMF0043.P_DMF0043_GET_CONTRIBUTION_SALES_LIST` | 오류 토스트/SQL ERROR 없음 · 데이터 표시(전환 전과 동일) | ☐ |
| 21 | DMF0043 | Contribution Rate Reg. (`/contribute-main`) | 시트 `salesListTitle` — 조회 | `PKG_DMF0043.P_DMF0043_GET_SALES_LIST_SPREAD_TITLE` | 오류 토스트/SQL ERROR 없음 · 데이터 표시(전환 전과 동일) | ☐ |
| 22 | DMF0043 | Contribution Rate Reg. (`/contribute-main`) | 시트 `version` — 저장(테스트 데이터로 1건 수정 후 저장 → 재조회로 반영 확인) | `PKG_DMF0043.P_DMF0043_SAVE_DM_MST_CONTRIBUTE_VER` | 오류 토스트/SQL ERROR 없음 · 데이터 표시(전환 전과 동일) | ☐ |
| 23 | DMF0043 | Contribution Rate Reg. (`/contribute-main`) | 시트 `version` — 조회 | `PKG_DMF0043.P_DMF0043_GET_MAIN_VARSION_DATA` | 오류 토스트/SQL ERROR 없음 · 데이터 표시(전환 전과 동일) | ☐ |
| 24 | DMF0043 | Contribution Rate Reg. (`/contribute-main`) | 시트 `versionPopup` — 조회 | `PKG_DMF0043.P_DMF0043_GET_CONT_VIEW_VERSIONPOPUP` | 오류 토스트/SQL ERROR 없음 · 데이터 표시(전환 전과 동일) | ☐ |
| 25 | DMF0043 | Contribution Rate Reg. (`/contribute-main`) | 시트 `yearPopup` — 조회 | `PKG_DMF0043.P_DMF0043_GET_CONTRIBUTE_YEAR_POPUP` | 오류 토스트/SQL ERROR 없음 · 데이터 표시(전환 전과 동일) | ☐ |
| 26 | DMF0043_01 | Contribution Sales (`/contribute-view`) | 시트 `main` — 조회 | `PKG_DMF0043.P_DMF0043_GET_CONTRIBUTION_SALES_LIST` | 오류 토스트/SQL ERROR 없음 · 데이터 표시(전환 전과 동일) | ☐ |
| 27 | DMF0043_01 | Contribution Sales (`/contribute-view`) | 시트 `mainTitle` — 조회 | `PKG_DMF0043.P_DMF0043_GET_SALES_LIST_SPREAD_TITLE` | 오류 토스트/SQL ERROR 없음 · 데이터 표시(전환 전과 동일) | ☐ |
| 28 | DMF0043_01 | Contribution Sales (`/contribute-view`) | 시트 `ratePopup` — 조회 | `PKG_DMF0043.P_DMF0043_GET_CONTRIBUTE_RATE_POPUP` | 오류 토스트/SQL ERROR 없음 · 데이터 표시(전환 전과 동일) | ☐ |
| 29 | DMF0043_01 | Contribution Sales (`/contribute-view`) | 시트 `version` — 조회 | `PKG_DMF0043.P_DMF0043_GET_MAIN_VARSION_DATA` | 오류 토스트/SQL ERROR 없음 · 데이터 표시(전환 전과 동일) | ☐ |
| 30 | DMF0043_01 | Contribution Sales (`/contribute-view`) | 시트 `versionPopup` — 조회 | `PKG_DMF0043.P_DMF0043_GET_CONT_VIEW_VERSIONPOPUP` | 오류 토스트/SQL ERROR 없음 · 데이터 표시(전환 전과 동일) | ☐ |
| 31 | DMF0048 | Sales Monitoring (`/sales-monitoring`) | 시트 `spreadTitle` — 조회 | `PKG_DMF0048.P_DMF0048_GET_SPREAD_TITLE` | 오류 토스트/SQL ERROR 없음 · 데이터 표시(전환 전과 동일) | ☐ |
| 32 | DMF0072 | N: N Master Mapping (`/nn-master-mapping`) | 시트 `dataType` — 조회 | `PKG_DMF0072.P_DMF0072_GET_DATA_TYPE_LIST` | 오류 토스트/SQL ERROR 없음 · 데이터 표시(전환 전과 동일) | ☐ |
| 33 | DMF0072 | N: N Master Mapping (`/nn-master-mapping`) | 시트 `endCustomer` — 조회 | `PKG_DMF0072.P_DMF0072_GET_END_CUSTOMER_LIST` | 오류 토스트/SQL ERROR 없음 · 데이터 표시(전환 전과 동일) | ☐ |
| 34 | DMF0072 | N: N Master Mapping (`/nn-master-mapping`) | 시트 `main` — 조회 | `PKG_DMF0072.P_DMF0072_GET_NNMASTER_MAPPING_WRAPPER` | 오류 토스트/SQL ERROR 없음 · 데이터 표시(전환 전과 동일) | ☐ |
| 35 | DMF0072 | N: N Master Mapping (`/nn-master-mapping`) | 시트 `salesSite` — 조회 | `PKG_DMF0072.P_DMF0072_GET_SALES_SITE_LIST` | 오류 토스트/SQL ERROR 없음 · 데이터 표시(전환 전과 동일) | ☐ |
| 36 | DMF0072 | N: N Master Mapping (`/nn-master-mapping`) | 시트 `team` — 조회 | `PKG_DMF0072.P_DMF0072_GET_TEAM_LIST` | 오류 토스트/SQL ERROR 없음 · 데이터 표시(전환 전과 동일) | ☐ |
| 37 | DMF0082 | Fcst MGMT (`/forecast-price`) | 내부 호출 경로: PKG_DMF0082.P_DMF0082_SAVE_MAIN_DATA (Fcst MGMT 저장) | `PKG_DMF0082.P_PR_DM_PLN_CFM_TO_MKT_FCST` | 오류 토스트/SQL ERROR 없음 · 데이터 표시(전환 전과 동일) | ☐ |
| 38 | DMF0082 | Fcst MGMT (`/forecast-price`) | 내부 호출 경로: P_PR_SCM_MST_EXCHANGE_RATE_UI (환율 모달 BPS I/F) | `PKG_DMF0082.P_PR_SCM_MST_EXCHANGE_RATE` | 오류 토스트/SQL ERROR 없음 · 데이터 표시(전환 전과 동일) | ☐ |
| 39 | DMF0082 | Fcst MGMT (`/forecast-price`) | 시트 `futurePriceInfo` — 환율 모달 BPS I/F | `PKG_DMF0082.P_PR_SCM_MST_EXCHANGE_RATE_UI` | 오류 토스트/SQL ERROR 없음 · 데이터 표시(전환 전과 동일) | ☐ |
| 40 | SYS0012 | Auth Approval (`/auth-approval`) | 시트 `main` — 승인(테스트 요청 1건) | `PKG_SYS0012.P_SYS0012_APPROVE` | 오류 토스트/SQL ERROR 없음 · 데이터 표시(전환 전과 동일) | ☐ |
| 41 | SYS0012 | Auth Approval (`/auth-approval`) | 시트 `main` — 반려(테스트 요청 1건) | `PKG_SYS0012.P_SYS0012_REJECT` | 오류 토스트/SQL ERROR 없음 · 데이터 표시(전환 전과 동일) | ☐ |
| 42 | SYS0012 | Auth Approval (`/auth-approval`) | 시트 `main` — 조회 | `PKG_SYS0012.P_SYS0012_GET_APPROVAL_LIST` | 오류 토스트/SQL ERROR 없음 · 데이터 표시(전환 전과 동일) | ☐ |
| 43 | SYS0014 | Group User (`/group-user`) | 시트 `Division` — 조회 | `PKG_SYS0014.P_SYS0014_GET_AUTH_LIST_M` | 오류 토스트/SQL ERROR 없음 · 데이터 표시(전환 전과 동일) | ☐ |
| 44 | SYS0014 | Group User (`/group-user`) | 시트 `GroupInfo` — 저장(테스트 데이터로 1건 수정 후 저장 → 재조회로 반영 확인) | `PKG_SYS0014.P_SYS0014_SAVE_GROUP_USER_M` | 오류 토스트/SQL ERROR 없음 · 데이터 표시(전환 전과 동일) | ☐ |
| 45 | SYS0014 | Group User (`/group-user`) | 시트 `GroupInfo` — 조회 | `PKG_SYS0014.P_SYS0014_GET_GROUP_LIST_M` | 오류 토스트/SQL ERROR 없음 · 데이터 표시(전환 전과 동일) | ☐ |
| 46 | SYS0014 | Group User (`/group-user`) | 시트 `UserInfo` — 조회 | `PKG_SYS0014.P_SYS0014_GET_USER_BY_GROUP_M` | 오류 토스트/SQL ERROR 없음 · 데이터 표시(전환 전과 동일) | ☐ |
| 47 | SYS0014 | Group User (`/group-user`) | 시트 `customer` — 조회 | `PKG_SYS0014.P_SYS0014_GET_AUTH_LIST_M` | 오류 토스트/SQL ERROR 없음 · 데이터 표시(전환 전과 동일) | ☐ |
| 48 | SYS0014 | Group User (`/group-user`) | 시트 `division` — 조회 | `PKG_SYS0014.P_SYS0014_GET_AUTH_LIST_M` | 오류 토스트/SQL ERROR 없음 · 데이터 표시(전환 전과 동일) | ☐ |
| 49 | SYS0014 | Group User (`/group-user`) | 시트 `main` — 저장(테스트 데이터로 1건 수정 후 저장 → 재조회로 반영 확인) | `PKG_SYS0014.P_SYS0014_SAVE_GROUP_USER_M` | 오류 토스트/SQL ERROR 없음 · 데이터 표시(전환 전과 동일) | ☐ |
| 50 | SYS0014 | Group User (`/group-user`) | 시트 `main` — 조회 | `PKG_SYS0014.P_SYS0014_GET_GROUP_LIST_M` | 오류 토스트/SQL ERROR 없음 · 데이터 표시(전환 전과 동일) | ☐ |
| 51 | SYS0014 | Group User (`/group-user`) | 시트 `plant` — 조회 | `PKG_SYS0014.P_SYS0014_GET_AUTH_LIST_M` | 오류 토스트/SQL ERROR 없음 · 데이터 표시(전환 전과 동일) | ☐ |
| 52 | SYS0014 | Group User (`/group-user`) | 시트 `userInfo` — 조회 | `PKG_SYS0014.P_SYS0014_GET_USER_BY_GROUP_M` | 오류 토스트/SQL ERROR 없음 · 데이터 표시(전환 전과 동일) | ☐ |
| 53 | DMF0003 | MKT FCST (`/mkt-fcst`) | 내부 호출 경로: PKG_DMF0003.P_DMF0003_SAVE_PRPOPUP (MKT FCST 의 PR 팝업 저장 → 메일 발송) | `PKG_DMF0003.P_SCM_ADM_MAIL_SEND` | 오류 토스트/SQL ERROR 없음 · 데이터 표시(전환 전과 동일) | ☐ |
| 54 | DMF0006 | Customer Model Mapping (`/customer-model-mapping`) | 내부 호출 경로: PKG_DMF0006.P_PR_DM_MST_SAVE_CUSTOMER_MODEL_MAPPING_DATA (저장 → 이력 적재) | `PKG_DMF0006.P_PR_DM_MST_CUSTOMER_MODEL_MAPPING_HIST` | 오류 토스트/SQL ERROR 없음 · 데이터 표시(전환 전과 동일) | ☐ |
| 55 | DMF0007 | Customer FCST Master (`/customer-fcst-master`) | 내부 호출 경로: PKG_DMF0007.P_DMF0007_SAVE_CUST_FCST_DATA (저장 → 이력 적재) | `PKG_DMF0007.P_PR_DM_MST_CUSTOMER_FCST_HIST` | 오류 토스트/SQL ERROR 없음 · 데이터 표시(전환 전과 동일) | ☐ |
| 56 | DMF0014 | Customer FCST Upload (`/customer-fcst-upload`) | 내부 호출 경로: P_DMF0014_CUST_FCST_EXCEL_UPLOAD(mode=1) (Div 40 저장) | `PKG_DMF0014.P_PR_DM_PLN_CUST_FCST_TO_MKT_FCST_40` | 오류 토스트/SQL ERROR 없음 · 데이터 표시(전환 전과 동일) | ☐ |
| 57 | DMF0014 | Customer FCST Upload (`/customer-fcst-upload`) | 내부 호출 경로: P_DMF0014_CUST_FCST_EXCEL_UPLOAD(mode=1)·P_DMF0014_SAVE_CUST_FCST_UPLOAD_DATA (Div 81/82 저장) | `PKG_DMF0014.P_PR_DM_PLN_CUST_FCST_TO_MKT_FCST` | 오류 토스트/SQL ERROR 없음 · 데이터 표시(전환 전과 동일) | ☐ |
| 58 | DMF0014 | Customer FCST Upload (`/customer-fcst-upload`) | 내부 호출 경로: P_PR_DM_PLN_CUST_FCST_TO_MKT_FCST(_40) 내부 (Excel Upload [OK] 저장 → MKT FCST 반영) | `PKG_DMF0014.P_PR_DM_CUST_ITEM_MAPPING` | 오류 토스트/SQL ERROR 없음 · 데이터 표시(전환 전과 동일) | ☐ |
| 59 | DMF0020 | Sales Price (`/sales-future-price`) | 내부 호출 경로: PKG_DMF0020.P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL·_POPUP (Sales Price 저장 → 금액 재계산) | `PKG_DMF0020.P_PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_SINGLE` | 오류 토스트/SQL ERROR 없음 · 데이터 표시(전환 전과 동일) | ☐ |
| 60 | SYS0017 | Mail Setup (`/mail-setup`) | 내부 호출 경로: PKG_SYS0017.P_SYS0017_SAVE_RECIPIENT_ASSIGN (수신자 지정 저장 → 이력) | `PKG_SYS0017.P_PR_SCM_ADM_RECIPIENT_ASSIGN_HIST` | 오류 토스트/SQL ERROR 없음 · 데이터 표시(전환 전과 동일) | ☐ |

## 4. 이상 시 확인 순서
1. 화면 오류 메시지 / BE 로그 `nscm.log` 의 `ORA-` · `PLS-` 전문
2. `PLS-00306`(인자 개수/유형) → PROC_M 행과 멤버 인자 불일치 → `03_meta/<PKG>/38_META_VERIFY.sql` 결과 확인
3. `PLS-00201`(식별자 없음) → SCMP_APP 권한/시노님 → `02_apply/<PKG>/20·21` (DMF0008·SYS0012)
4. 호출문에 빈 인자 `, ,` → PROC_M DATA_TP_CD 가 VARCHAR/NUMBER/CLOB/CURSOR 이외(예: VARCHAR2)
5. 급하면 그 PKG 만 `03_meta/<PKG>/39_META_ROLLBACK.sql` 실행 → 화면이 standalone 호출로 복귀(standalone 은 아직 삭제 안 됨)

## 5. 사내 사전 실측 (19:07~19:12)
- BE 실호출(SEARCH) 17 API 성공: DMF0072 dataType 3 · team 107 · endCustomer 153 · salesSite 475 / DMF0043 version 8 · yearPopup 9 · ratePopup 1 · mainTitle 125 / DMF0040 spreadTitle 448 / DMF0048 spreadTitle 87 / DMF0008 summary 10 · salesSite · updateHistory 1 / SYS0012 main / SYS0014 main 19 · UserInfo · division
- 저장(SAVE)·승인/반려·I/F 는 데이터를 바꾸므로 사전 실측하지 않음 → 위 체크리스트로 로컬 확인 필요
