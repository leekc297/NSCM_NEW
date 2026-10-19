# UI별 PKG 취합 대상 목록 (2026-09-15)

> 기준: 사내 ZIOUI1 (host ol9-db) · SCM_MGR standalone PROCEDURE 208개 · 조회만(DB 변경 없음)
> 범위: 활성 SCREEN 50화면(SDM 제외) + 화면이 여는 팝업 메뉴 13 · 판정 = FE 가 실제 호출하는 등록 API 기준
> 상세·필터: [TOBE_UI별_PKG전환대상_20260914.xlsx](TOBE_UI별_PKG전환대상_20260915.xlsx)

## 1. 요약

| 구분 | 건수 |
|---|---|
| PKG 취합 대상 | 43 |
| FE 미사용 등록 — 정리 후 DROP | 5 |
| 제외(공통) | 26 |
| 보류 | 9 |
| 참고(UI 미사용) | 125 |
| **합계 (standalone 전체)** | 208 |
| (별도) DROP 대상 — 위와 겹침 | 53 |

## 2. PKG 취합 대상 — 통합 대상 PKG별

### PKG_DMF0003 (기존) — 1건

| standalone SP | SP 상태 | 호출 구분 | 작업 유형 | PKG 멤버(안) | 재배선 대상 | 선행 작업 |
|---|---|---|---|---|---|---|
| SCM_ADM_MAIL_SEND | VALID | UI PKG 내부 호출 | 멤버 신규 추가 | PKG_DMF0003.P_SCM_ADM_MAIL_SEND (안) | 호출부 변경: PKG_DMF0003.P_DMF0003_SAVE_PRPOPUP,SCM_ADM_MAIL_SEND_BATCH,SCM_ADM_MAIL_SEND_DATA | - |

### PKG_DMF0006 (기존) — 1건

| standalone SP | SP 상태 | 호출 구분 | 작업 유형 | PKG 멤버(안) | 재배선 대상 | 선행 작업 |
|---|---|---|---|---|---|---|
| PR_DM_MST_CUSTOMER_MODEL_MAPPING_HIST | VALID | UI PKG 내부 호출 | 멤버 신규 추가 | PKG_DMF0006.P_PR_DM_MST_CUSTOMER_MODEL_MAPPING_HIST (안) | 호출부 변경: PKG_DMF0006.P_PR_DM_MST_SAVE_CUSTOMER_MODEL_MAPPING_DATA,PR_DM_MST_SAVE_CUSTOMER_MODEL_MAPPING_DATA | - |

### PKG_DMF0007 (기존) — 1건

| standalone SP | SP 상태 | 호출 구분 | 작업 유형 | PKG 멤버(안) | 재배선 대상 | 선행 작업 |
|---|---|---|---|---|---|---|
| PR_DM_MST_CUSTOMER_FCST_HIST | VALID | UI PKG 내부 호출 | 멤버 신규 추가 | PKG_DMF0007.P_PR_DM_MST_CUSTOMER_FCST_HIST (안) | 호출부 변경: PKG_DMF0007.P_DMF0007_SAVE_CUST_FCST_DATA | - |

### PKG_DMF0008 (기존) — 8건

| standalone SP | SP 상태 | 호출 구분 | 작업 유형 | PKG 멤버(안) | 재배선 대상 | 선행 작업 |
|---|---|---|---|---|---|---|
| DMF0008_GET_EDI_MST_REPAIR | VALID | 화면 API 직접 호출 | 기존 동일명 멤버로 재배선 | PKG_DMF0008.P_DMF0008_GET_EDI_MST_REPAIR (기존 — 본문 동일성 확인) | API_M: P_DMF0008_REPAIR_GET / PROC_M 9행 | PKG_DMF0008 SCMP_APP EXECUTE 권한 |
| DMF0008_GET_EDI_MST_SUMMARY | VALID | 화면 API 직접 호출 | 기존 동일명 멤버로 재배선 | PKG_DMF0008.P_DMF0008_GET_EDI_MST_SUMMARY (기존 — 본문 동일성 확인) | API_M: P_DMF0008_SUMMARY_GET / PROC_M 8행 | PKG_DMF0008 SCMP_APP EXECUTE 권한 |
| DMF0008_GET_SALES_SITE | VALID | 화면 API 직접 호출 | 기존 동일명 멤버로 재배선 | PKG_DMF0008.P_DMF0008_GET_SALES_SITE (기존 — 본문 동일성 확인) | API_M: P_DMF0008_SALES_SITE_GET,P_DMF0008_SITE_GET / PROC_M 5행 | PKG_DMF0008 SCMP_APP EXECUTE 권한 |
| DMF0008_GET_SALES_SITE_PROJECT_MODEL | VALID | 화면 API 직접 호출 | 기존 동일명 멤버로 재배선 | PKG_DMF0008.P_DMF0008_GET_SALES_SITE_PROJECT_MODEL (기존 — 본문 동일성 확인) | API_M: P_DMF0008_PROJECT_GET,P_DMF0008_SSPM_GET / PROC_M 7행 | PKG_DMF0008 SCMP_APP EXECUTE 권한 |
| DMF0008_GET_UPDATE_HISTORY | VALID | 화면 API 직접 호출 | 기존 동일명 멤버로 재배선 | PKG_DMF0008.P_DMF0008_GET_UPDATE_HISTORY (기존 — 본문 동일성 확인) | API_M: P_DMF0008_UPDATE_HISTORY,P_DMF0008_UPDATE_HISTORY_GET / PROC_M 3행 | PKG_DMF0008 SCMP_APP EXECUTE 권한 |
| DMF0008_SAVE_SALES_SITE_EDI_REPAIR | VALID | 화면 API 직접 호출 | 기존 동일명 멤버로 재배선 | PKG_DMF0008.P_DMF0008_SAVE_SALES_SITE_EDI_REPAIR (기존 — 본문 동일성 확인) | API_M: P_DMF0008_REPAIR_SAVE,P_DMF0008_SALES_SITE_SAVE / PROC_M 17행 | PKG_DMF0008 SCMP_APP EXECUTE 권한 |
| DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR | VALID | 화면 API 직접 호출 | 기존 동일명 멤버로 재배선 | PKG_DMF0008.P_DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR (기존 — 본문 동일성 확인) | API_M: P_DMF0008_PROJECT_SAVE,P_DMF0008_SSPM_SAVE / PROC_M 23행 | PKG_DMF0008 SCMP_APP EXECUTE 권한 |
| DMF0000_GET_UPDATE_HISTORY | VALID | UI PKG 내부 호출 | 멤버 신규 추가 (타 PKG 동일명 멤버 존재 — 재배선 대안) | PKG_DMF0008.P_DMF0000_GET_UPDATE_HISTORY (안) / 대안 PKG_DMF0000.P_DMF0000_GET_UPDATE_HISTORY | 호출부 변경: DMF0008_GET_UPDATE_HISTORY,PKG_DMF0008.P_DMF0008_GET_UPDATE_HISTORY | PKG_DMF0008 SCMP_APP EXECUTE 권한 |

### PKG_DMF0014 (기존) — 3건

| standalone SP | SP 상태 | 호출 구분 | 작업 유형 | PKG 멤버(안) | 재배선 대상 | 선행 작업 |
|---|---|---|---|---|---|---|
| PR_DM_CUST_ITEM_MAPPING | VALID | UI PKG 내부 호출 | 멤버 신규 추가 | PKG_DMF0014.P_PR_DM_CUST_ITEM_MAPPING (안) | 호출부 변경: PR_DM_PLN_CUST_FCST_TO_MKT_FCST,PR_DM_PLN_CUST_FCST_TO_MKT_FCST_40 | - |
| PR_DM_PLN_CUST_FCST_TO_MKT_FCST | VALID | UI PKG 내부 호출 | 멤버 신규 추가 | PKG_DMF0014.P_PR_DM_PLN_CUST_FCST_TO_MKT_FCST (안) | 호출부 변경: PKG_DMF0014.P_DMF0014_CUST_FCST_EXCEL_UPLOAD,PKG_DMF0014.P_DMF0014_SAVE_CUST_FCST_UPLOAD_DATA | - |
| PR_DM_PLN_CUST_FCST_TO_MKT_FCST_40 | VALID | UI PKG 내부 호출 | 멤버 신규 추가 | PKG_DMF0014.P_PR_DM_PLN_CUST_FCST_TO_MKT_FCST_40 (안) | 호출부 변경: PKG_DMF0014.P_DMF0014_CUST_FCST_EXCEL_UPLOAD,PKG_DMF0014.P_DMF0014_CUST_FCST_EXCEL_UPLOAD_SM | - |

### PKG_DMF0020 (기존) — 1건

| standalone SP | SP 상태 | 호출 구분 | 작업 유형 | PKG 멤버(안) | 재배선 대상 | 선행 작업 |
|---|---|---|---|---|---|---|
| PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_SINGLE | VALID | UI PKG 내부 호출 | 멤버 신규 추가 | PKG_DMF0020.P_PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_SINGLE (안) | 호출부 변경: DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL,DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP,PKG_DMF0020.P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL,PKG_DMF0020.P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP | - |

### PKG_DMF0040 (기존) — 1건

| standalone SP | SP 상태 | 호출 구분 | 작업 유형 | PKG 멤버(안) | 재배선 대상 | 선행 작업 |
|---|---|---|---|---|---|---|
| DMF0040_GET_SPREAD_TITLE | VALID | 화면 API 직접 호출 | 멤버 신규 추가 | PKG_DMF0040.P_DMF0040_GET_SPREAD_TITLE (안) | API_M: DMF0040_spreadTitle_SEARCH / PROC_M 7행 | - |

### PKG_DMF0043 (기존) — 10건

| standalone SP | SP 상태 | 호출 구분 | 작업 유형 | PKG 멤버(안) | 재배선 대상 | 선행 작업 |
|---|---|---|---|---|---|---|
| DMF0043_GET_CONTRIBUTE_MAIN_DATA | VALID | 화면 API 직접 호출 | 멤버 신규 추가 | PKG_DMF0043.P_DMF0043_GET_CONTRIBUTE_MAIN_DATA (안) | API_M: P_DMF0043_MAIN_GET / PROC_M 7행 | - |
| DMF0043_GET_CONTRIBUTE_RATE_POPUP | VALID | 화면 API 직접 호출 | 기존 동일명 멤버로 재배선 | PKG_DMF0043.P_DMF0043_GET_CONTRIBUTE_RATE_POPUP (기존 — 본문 동일성 확인) | API_M: P_DMF0043_RATE_POPUP / PROC_M 3행 | - |
| DMF0043_GET_CONTRIBUTE_YEAR_POPUP | VALID | 화면 API 직접 호출 | 기존 동일명 멤버로 재배선 | PKG_DMF0043.P_DMF0043_GET_CONTRIBUTE_YEAR_POPUP (기존 — 본문 동일성 확인) | API_M: P_DMF0043_YEAR_POPUP / PROC_M 3행 | - |
| DMF0043_GET_CONTRIBUTION_SALES_LIST | INVALID | 화면 API 직접 호출 | 멤버 신규 추가 | PKG_DMF0043.P_DMF0043_GET_CONTRIBUTION_SALES_LIST (안) | API_M: P_DMF0043_SALES_LIST_GET / PROC_M 12행 | standalone INVALID(ALL_ERRORS 0건) — 재컴파일로 정상 여부 먼저 확인 |
| DMF0043_GET_CONT_VIEW_VERSIONPOPUP | VALID | 화면 API 직접 호출 | 기존 동일명 멤버로 재배선 | PKG_DMF0043.P_DMF0043_GET_CONT_VIEW_VERSIONPOPUP (기존 — 본문 동일성 확인) | API_M: DMF0043_GET_CONT_VIEW_VERSIONPOPUP,P_DMF0043_VERSION_POPUP / PROC_M 8행 | - |
| DMF0043_GET_MAIN_SPREAD_TITLE | VALID | 화면 API 직접 호출 | 래퍼 로직을 기존 멤버로 흡수 | PKG_DMF0043.P_DMF0043_GET_MAIN_SPREAD_TITLE (기존) | API_M: P_DMF0043_MAIN_TITLE / PROC_M 8행 / 호출부 변경: DMF0043_GET_CONTRIBUTE_MAIN_DATA | - |
| DMF0043_GET_MAIN_VARSION_DATA | VALID | 화면 API 직접 호출 | 기존 동일명 멤버로 재배선 | PKG_DMF0043.P_DMF0043_GET_MAIN_VARSION_DATA (기존 — 본문 동일성 확인) | API_M: P_DMF0043_VERSION_GET / PROC_M 3행 | - |
| DMF0043_GET_SALES_LIST_SPREAD_TITLE | VALID | 화면 API 직접 호출 | 기존 동일명 멤버로 재배선 | PKG_DMF0043.P_DMF0043_GET_SALES_LIST_SPREAD_TITLE (기존 — 본문 동일성 확인) | API_M: P_DMF0043_SALES_LIST_TITLE / PROC_M 4행 | - |
| DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO | VALID | 화면 API 직접 호출 | 기존 동일명 멤버로 재배선 | PKG_DMF0043.P_DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO (기존 — 본문 동일성 확인) | API_M: P_DMF0043_MAIN_SAVE / PROC_M 14행 | - |
| DMF0043_SAVE_DM_MST_CONTRIBUTE_VER | VALID | 화면 API 직접 호출 | 기존 동일명 멤버로 재배선 | PKG_DMF0043.P_DMF0043_SAVE_DM_MST_CONTRIBUTE_VER (기존 — 본문 동일성 확인) | API_M: P_DMF0043_VERSION_SAVE / PROC_M 9행 | - |

### PKG_DMF0048 (기존) — 1건

| standalone SP | SP 상태 | 호출 구분 | 작업 유형 | PKG 멤버(안) | 재배선 대상 | 선행 작업 |
|---|---|---|---|---|---|---|
| DMF0048_GET_SPREAD_TITLE | VALID | 화면 API 직접 호출 | 기존 동일명 멤버로 재배선 | PKG_DMF0048.P_DMF0048_GET_SPREAD_TITLE (기존 — 본문 동일성 확인) | API_M: DMF0048_spreadTitle_SEARCH / PROC_M 6행 | - |

### PKG_DMF0072 (기존) — 5건

| standalone SP | SP 상태 | 호출 구분 | 작업 유형 | PKG 멤버(안) | 재배선 대상 | 선행 작업 |
|---|---|---|---|---|---|---|
| DMF0072_GET_DATA_TYPE_LIST | VALID | 화면 API 직접 호출 | 멤버 신규 추가 | PKG_DMF0072.P_DMF0072_GET_DATA_TYPE_LIST (안) | API_M: P_DMF0072_DATATYPE_GET / PROC_M 1행 | - |
| DMF0072_GET_END_CUSTOMER_LIST | INVALID | 화면 API 직접 호출 | 멤버 신규 추가 | PKG_DMF0072.P_DMF0072_GET_END_CUSTOMER_LIST (안) | API_M: P_DMF0072_ENDCUST_GET / PROC_M 3행 | standalone INVALID(ALL_ERRORS 0건) — 재컴파일로 정상 여부 먼저 확인 |
| DMF0072_GET_NNMASTER_MAPPING_WRAPPER | VALID | 화면 API 직접 호출 | 멤버 신규 추가 | PKG_DMF0072.P_DMF0072_GET_NNMASTER_MAPPING_WRAPPER (안) | API_M: DMF0072_MAIN_SEARCH / PROC_M 10행 | - |
| DMF0072_GET_SALES_SITE_LIST | INVALID | 화면 API 직접 호출 | 멤버 신규 추가 | PKG_DMF0072.P_DMF0072_GET_SALES_SITE_LIST (안) | API_M: P_DMF0072_SALESSITE_GET / PROC_M 3행 | standalone INVALID(ALL_ERRORS 0건) — 재컴파일로 정상 여부 먼저 확인 |
| DMF0072_GET_TEAM_LIST | VALID | 화면 API 직접 호출 | 멤버 신규 추가 | PKG_DMF0072.P_DMF0072_GET_TEAM_LIST (안) | API_M: P_DMF0072_TEAM_GET / PROC_M 2행 | - |

### PKG_DMF0082 (기존) — 3건

| standalone SP | SP 상태 | 호출 구분 | 작업 유형 | PKG 멤버(안) | 재배선 대상 | 선행 작업 |
|---|---|---|---|---|---|---|
| PR_SCM_MST_EXCHANGE_RATE_UI | VALID | 화면 API 직접 호출 | 멤버 신규 추가 | PKG_DMF0082.P_PR_SCM_MST_EXCHANGE_RATE_UI (안) | API_M: DMF0082_futurePriceInfo_IF / PROC_M 2행 | - |
| PR_DM_PLN_CFM_TO_MKT_FCST | VALID | UI PKG 내부 호출 | 멤버 신규 추가 | PKG_DMF0082.P_PR_DM_PLN_CFM_TO_MKT_FCST (안) | 호출부 변경: PKG_DMF0082.P_DMF0082_SAVE_MAIN_DATA | - |
| PR_SCM_MST_EXCHANGE_RATE | VALID | UI PKG 내부 호출 | 멤버 신규 추가 | PKG_DMF0082.P_PR_SCM_MST_EXCHANGE_RATE (안) | 호출부 변경: PR_SCM_MST_EXCHANGE_RATE_UI | - |

### PKG_SYS0012 (신규 생성) — 3건

| standalone SP | SP 상태 | 호출 구분 | 작업 유형 | PKG 멤버(안) | 재배선 대상 | 선행 작업 |
|---|---|---|---|---|---|---|
| P_SYS0012_APPROVE | VALID | 화면 API 직접 호출 | 멤버 신규 추가 | PKG_SYS0012.P_SYS0012_APPROVE (안) | API_M: API_SYS0012_APPROVE / PROC_M 3행 | PKG_SYS0012 신규 생성 + SCMP_APP EXECUTE 권한·시노님 |
| P_SYS0012_GET_APPROVAL_LIST | VALID | 화면 API 직접 호출 | 멤버 신규 추가 | PKG_SYS0012.P_SYS0012_GET_APPROVAL_LIST (안) | API_M: API_SYS0012_GET_APPROVAL_LIST / PROC_M 9행 | PKG_SYS0012 신규 생성 + SCMP_APP EXECUTE 권한·시노님 |
| P_SYS0012_REJECT | VALID | 화면 API 직접 호출 | 멤버 신규 추가 | PKG_SYS0012.P_SYS0012_REJECT (안) | API_M: API_SYS0012_REJECT / PROC_M 3행 | PKG_SYS0012 신규 생성 + SCMP_APP EXECUTE 권한·시노님 |

### PKG_SYS0014 (기존) — 4건

| standalone SP | SP 상태 | 호출 구분 | 작업 유형 | PKG 멤버(안) | 재배선 대상 | 선행 작업 |
|---|---|---|---|---|---|---|
| P_SYS0014_GET_AUTH_LIST_M | VALID | 화면 API 직접 호출 | 멤버 신규 추가 | PKG_SYS0014.P_SYS0014_GET_AUTH_LIST_M (안) | API_M: API_SYS0014_GET_AUTH_LIST / PROC_M 5행 | - |
| P_SYS0014_GET_GROUP_LIST_M | VALID | 화면 API 직접 호출 | 멤버 신규 추가 | PKG_SYS0014.P_SYS0014_GET_GROUP_LIST_M (안) | API_M: API_SYS0014_GET_GROUP_LIST / PROC_M 3행 | - |
| P_SYS0014_GET_USER_BY_GROUP_M | VALID | 화면 API 직접 호출 | 멤버 신규 추가 | PKG_SYS0014.P_SYS0014_GET_USER_BY_GROUP_M (안) | API_M: API_SYS0014_GET_USER_BY_GROUP / PROC_M 3행 | - |
| P_SYS0014_SAVE_GROUP_USER_M | VALID | 화면 API 직접 호출 | 멤버 신규 추가 | PKG_SYS0014.P_SYS0014_SAVE_GROUP_USER_M (안) | API_M: API_SYS0014_SAVE_GROUP_USER / PROC_M 3행 | - |

### PKG_SYS0017 (기존) — 1건

| standalone SP | SP 상태 | 호출 구분 | 작업 유형 | PKG 멤버(안) | 재배선 대상 | 선행 작업 |
|---|---|---|---|---|---|---|
| PR_SCM_ADM_RECIPIENT_ASSIGN_HIST | VALID | UI PKG 내부 호출 | 멤버 신규 추가 | PKG_SYS0017.P_PR_SCM_ADM_RECIPIENT_ASSIGN_HIST (안) | 호출부 변경: PKG_SYS0017.P_SYS0017_SAVE_RECIPIENT_ASSIGN | - |

## 3. DROP 대상

재배선 후 현재참조 전 축(API_M·PROC_M·EXCEL·콤보·호출객체·배치JOB·텍스트) 0 재확인 → 백업 DDL 보관 → DROP

| No | DROP 구분 | standalone SP | 관련 PKG/UI | DROP 전제 | 현재참조_API_M | 현재참조_PROC_M | 현재참조_호출객체 | SCMP_APP 시노님 |
|---|---|---|---|---|---|---|---|---|
| 1 | ① PKG 취합 후 DROP | SCM_ADM_MAIL_SEND | PKG_DMF0003 | PKG_DMF0003 재배선 완료 후 | 0 | 0 | 3 | Y(함께 DROP) |
| 2 | ① PKG 취합 후 DROP | PR_DM_MST_CUSTOMER_MODEL_MAPPING_HIST | PKG_DMF0006 | PKG_DMF0006 재배선 완료 후 | 0 | 0 | 2 | Y(함께 DROP) |
| 3 | ① PKG 취합 후 DROP | PR_DM_MST_CUSTOMER_FCST_HIST | PKG_DMF0007 | PKG_DMF0007 재배선 완료 후 | 0 | 0 | 1 | Y(함께 DROP) |
| 4 | ① PKG 취합 후 DROP | DMF0000_GET_UPDATE_HISTORY | PKG_DMF0008 | PKG_DMF0008 재배선 완료 후 | 0 | 0 | 2 | Y(함께 DROP) |
| 5 | ① PKG 취합 후 DROP | DMF0008_GET_EDI_MST_REPAIR | PKG_DMF0008 | PKG_DMF0008 재배선 완료 후 | 1 | 9 | 0 | Y(함께 DROP) |
| 6 | ① PKG 취합 후 DROP | DMF0008_GET_EDI_MST_SUMMARY | PKG_DMF0008 | PKG_DMF0008 재배선 완료 후 | 1 | 8 | 0 | Y(함께 DROP) |
| 7 | ① PKG 취합 후 DROP | DMF0008_GET_SALES_SITE | PKG_DMF0008 | PKG_DMF0008 재배선 완료 후 | 2 | 5 | 0 | Y(함께 DROP) |
| 8 | ① PKG 취합 후 DROP | DMF0008_GET_SALES_SITE_PROJECT_MODEL | PKG_DMF0008 | PKG_DMF0008 재배선 완료 후 | 2 | 7 | 0 | Y(함께 DROP) |
| 9 | ① PKG 취합 후 DROP | DMF0008_GET_UPDATE_HISTORY | PKG_DMF0008 | PKG_DMF0008 재배선 완료 후 | 2 | 3 | 0 | Y(함께 DROP) |
| 10 | ① PKG 취합 후 DROP | DMF0008_SAVE_SALES_SITE_EDI_REPAIR | PKG_DMF0008 | PKG_DMF0008 재배선 완료 후 | 2 | 17 | 0 | Y(함께 DROP) |
| 11 | ① PKG 취합 후 DROP | DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR | PKG_DMF0008 | PKG_DMF0008 재배선 완료 후 | 2 | 23 | 0 | Y(함께 DROP) |
| 12 | ① PKG 취합 후 DROP | PR_DM_CUST_ITEM_MAPPING | PKG_DMF0014 | PKG_DMF0014 재배선 완료 후 | 0 | 0 | 2 | Y(함께 DROP) |
| 13 | ① PKG 취합 후 DROP | PR_DM_PLN_CUST_FCST_TO_MKT_FCST | PKG_DMF0014 | PKG_DMF0014 재배선 완료 후 | 0 | 0 | 2 | Y(함께 DROP) |
| 14 | ① PKG 취합 후 DROP | PR_DM_PLN_CUST_FCST_TO_MKT_FCST_40 | PKG_DMF0014 | PKG_DMF0014 재배선 완료 후 | 0 | 0 | 2 | Y(함께 DROP) |
| 15 | ① PKG 취합 후 DROP | PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_SINGLE | PKG_DMF0020 | PKG_DMF0020 재배선 완료 후 | 0 | 0 | 4 | Y(함께 DROP) |
| 16 | ① PKG 취합 후 DROP | DMF0040_GET_SPREAD_TITLE | PKG_DMF0040 | PKG_DMF0040 재배선 완료 후 | 1 | 7 | 0 | Y(함께 DROP) |
| 17 | ① PKG 취합 후 DROP | DMF0043_GET_CONTRIBUTE_MAIN_DATA | PKG_DMF0043 | PKG_DMF0043 재배선 완료 후 | 1 | 7 | 0 | Y(함께 DROP) |
| 18 | ① PKG 취합 후 DROP | DMF0043_GET_CONTRIBUTE_RATE_POPUP | PKG_DMF0043 | PKG_DMF0043 재배선 완료 후 | 1 | 3 | 0 | Y(함께 DROP) |
| 19 | ① PKG 취합 후 DROP | DMF0043_GET_CONTRIBUTE_YEAR_POPUP | PKG_DMF0043 | PKG_DMF0043 재배선 완료 후 | 1 | 3 | 0 | Y(함께 DROP) |
| 20 | ① PKG 취합 후 DROP | DMF0043_GET_CONTRIBUTION_SALES_LIST | PKG_DMF0043 | PKG_DMF0043 재배선 완료 후 | 1 | 12 | 0 | Y(함께 DROP) |
| 21 | ① PKG 취합 후 DROP | DMF0043_GET_CONT_VIEW_VERSIONPOPUP | PKG_DMF0043 | PKG_DMF0043 재배선 완료 후 | 2 | 8 | 0 | Y(함께 DROP) |
| 22 | ① PKG 취합 후 DROP | DMF0043_GET_MAIN_SPREAD_TITLE | PKG_DMF0043 | PKG_DMF0043 재배선 완료 후 | 1 | 8 | 1 | Y(함께 DROP) |
| 23 | ① PKG 취합 후 DROP | DMF0043_GET_MAIN_VARSION_DATA | PKG_DMF0043 | PKG_DMF0043 재배선 완료 후 | 1 | 3 | 0 | Y(함께 DROP) |
| 24 | ① PKG 취합 후 DROP | DMF0043_GET_SALES_LIST_SPREAD_TITLE | PKG_DMF0043 | PKG_DMF0043 재배선 완료 후 | 1 | 4 | 0 | Y(함께 DROP) |
| 25 | ① PKG 취합 후 DROP | DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO | PKG_DMF0043 | PKG_DMF0043 재배선 완료 후 | 1 | 14 | 0 | Y(함께 DROP) |
| 26 | ① PKG 취합 후 DROP | DMF0043_SAVE_DM_MST_CONTRIBUTE_VER | PKG_DMF0043 | PKG_DMF0043 재배선 완료 후 | 1 | 9 | 0 | Y(함께 DROP) |
| 27 | ① PKG 취합 후 DROP | DMF0048_GET_SPREAD_TITLE | PKG_DMF0048 | PKG_DMF0048 재배선 완료 후 | 1 | 6 | 0 | Y(함께 DROP) |
| 28 | ① PKG 취합 후 DROP | DMF0072_GET_DATA_TYPE_LIST | PKG_DMF0072 | PKG_DMF0072 재배선 완료 후 | 1 | 1 | 0 | Y(함께 DROP) |
| 29 | ① PKG 취합 후 DROP | DMF0072_GET_END_CUSTOMER_LIST | PKG_DMF0072 | PKG_DMF0072 재배선 완료 후 | 1 | 3 | 0 | Y(함께 DROP) |
| 30 | ① PKG 취합 후 DROP | DMF0072_GET_NNMASTER_MAPPING_WRAPPER | PKG_DMF0072 | PKG_DMF0072 재배선 완료 후 | 1 | 10 | 0 | Y(함께 DROP) |
| 31 | ① PKG 취합 후 DROP | DMF0072_GET_SALES_SITE_LIST | PKG_DMF0072 | PKG_DMF0072 재배선 완료 후 | 1 | 3 | 0 | Y(함께 DROP) |
| 32 | ① PKG 취합 후 DROP | DMF0072_GET_TEAM_LIST | PKG_DMF0072 | PKG_DMF0072 재배선 완료 후 | 1 | 2 | 0 | Y(함께 DROP) |
| 33 | ① PKG 취합 후 DROP | PR_DM_PLN_CFM_TO_MKT_FCST | PKG_DMF0082 | PKG_DMF0082 재배선 완료 후 | 0 | 0 | 1 | Y(함께 DROP) |
| 34 | ① PKG 취합 후 DROP | PR_SCM_MST_EXCHANGE_RATE | PKG_DMF0082 | PKG_DMF0082 재배선 완료 후 | 0 | 0 | 1 | Y(함께 DROP) |
| 35 | ① PKG 취합 후 DROP | PR_SCM_MST_EXCHANGE_RATE_UI | PKG_DMF0082 | PKG_DMF0082 재배선 완료 후 | 1 | 2 | 0 | Y(함께 DROP) |
| 36 | ① PKG 취합 후 DROP | P_SYS0012_APPROVE | PKG_SYS0012 | PKG_SYS0012 재배선 완료 후 | 1 | 3 | 0 | Y(함께 DROP) |
| 37 | ① PKG 취합 후 DROP | P_SYS0012_GET_APPROVAL_LIST | PKG_SYS0012 | PKG_SYS0012 재배선 완료 후 | 1 | 9 | 0 | Y(함께 DROP) |
| 38 | ① PKG 취합 후 DROP | P_SYS0012_REJECT | PKG_SYS0012 | PKG_SYS0012 재배선 완료 후 | 1 | 3 | 0 | Y(함께 DROP) |
| 39 | ① PKG 취합 후 DROP | P_SYS0014_GET_AUTH_LIST_M | PKG_SYS0014 | PKG_SYS0014 재배선 완료 후 | 1 | 5 | 0 | Y(함께 DROP) |
| 40 | ① PKG 취합 후 DROP | P_SYS0014_GET_GROUP_LIST_M | PKG_SYS0014 | PKG_SYS0014 재배선 완료 후 | 1 | 3 | 0 | Y(함께 DROP) |
| 41 | ① PKG 취합 후 DROP | P_SYS0014_GET_USER_BY_GROUP_M | PKG_SYS0014 | PKG_SYS0014 재배선 완료 후 | 1 | 3 | 0 | Y(함께 DROP) |
| 42 | ① PKG 취합 후 DROP | P_SYS0014_SAVE_GROUP_USER_M | PKG_SYS0014 | PKG_SYS0014 재배선 완료 후 | 1 | 3 | 0 | Y(함께 DROP) |
| 43 | ① PKG 취합 후 DROP | PR_SCM_ADM_RECIPIENT_ASSIGN_HIST | PKG_SYS0017 | PKG_SYS0017 재배선 완료 후 | 0 | 0 | 1 | Y(함께 DROP) |
| 44 | ② FE 미사용 등록 정리 후 DROP | DMF0020_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP | PKG_DMF0020 | BTN_MPG·API_M 등록 정리 후 (FE 호출 없음) | 1 | 18 | 0 | Y(함께 DROP) |
| 45 | ② FE 미사용 등록 정리 후 DROP | DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP | PKG_DMF0020 | BTN_MPG·API_M 등록 정리 후 (FE 호출 없음) | 1 | 17 | 0 | Y(함께 DROP) |
| 46 | ② FE 미사용 등록 정리 후 DROP | SCM0002_SET_DEFAULT_TITLESET_POPUP | PKG_DMF0048 | BTN_MPG·API_M 등록 정리 후 (FE 호출 없음) | 1 | 5 | 1 | Y(함께 DROP) |
| 47 | ② FE 미사용 등록 정리 후 DROP | DMF0072_GET_ITEM_POPUP_LIST | PKG_DMF0072 | BTN_MPG·API_M 등록 정리 후 (FE 호출 없음) | 1 | 8 | 0 | Y(함께 DROP) |
| 48 | ② FE 미사용 등록 정리 후 DROP | DMF0072_GET_PROJECT_POPUP_LIST | PKG_DMF0072 | BTN_MPG·API_M 등록 정리 후 (FE 호출 없음) | 1 | 7 | 0 | Y(함께 DROP) |
| 49 | ③ 동일명 PKG 멤버가 실사용 — standalone DROP | DMF0020_GET_SCM_MST_FUTURE_PRICE |  | 실사용 = PKG_DMF0020.P_DMF0020_GET_SCM_MST_FUTURE_PRICE | 0 | 20 | 0 | Y(함께 DROP) |
| 50 | ③ 동일명 PKG 멤버가 실사용 — standalone DROP | DMF0020_GET_SPREAD_TITLE_DATE |  | 실사용 = PKG_DMF0020.P_DMF0020_GET_SPREAD_TITLE_DATE | 0 | 0 | 0 | Y(함께 DROP) |
| 51 | ③ 동일명 PKG 멤버가 실사용 — standalone DROP | DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL |  | 실사용 = PKG_DMF0020.P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL | 0 | 19 | 0 | Y(함께 DROP) |
| 52 | ③ 동일명 PKG 멤버가 실사용 — standalone DROP | DMF0020_SAVE_SCM_MST_FUTURE_PRICE_CONVERSION |  | 실사용 = PKG_DMF0020.P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_CONVERSION | 0 | 0 | 0 | Y(함께 DROP) |
| 53 | ③ 동일명 PKG 멤버가 실사용 — standalone DROP | PR_DM_MST_SAVE_CUSTOMER_MODEL_MAPPING_DATA |  | 실사용 = PKG_DMF0006.P_PR_DM_MST_SAVE_CUSTOMER_MODEL_MAPPING_DATA | 0 | 0 | 0 | Y(함께 DROP) |

## 4. 제외 — 공통 SP (취합하지 않음)

| standalone SP | 분류 | 제외 사유 | 사용 UI | 배치 JOB 수 |
|---|---|---|---|---|
| DMF0002_GET_TITLESET_POPUP | 공통SP | 여러 UI 에서 사용 | DMF0003,DMF0020,DMF0021,DMF0040,DMF0042,DMF0043,DMF0044,DMF0048,DMF0049,DMF0053,DMF0068,DMF0082 | 0 |
| DMF0073_GET_VERSION_SALESPRICE | 공통SP | 여러 UI 에서 사용 | DMF0020,DMF0035,DMF0074,DMF0082 | 0 |
| PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_MKT_FCST_SAVE | 공통SP | 여러 UI 에서 사용 | DMF0003,DMF0082 | 0 |
| PR_DM_MST_SITE_CUSTOMER_HIST | 공통SP | 여러 UI 에서 사용 | DMF0008,SCP0001 | 0 |
| PR_DM_PLN_VERSION_CREATE | 공통SP | 여러 UI 에서 사용 | DMF0042,DMF0082 | 14 |
| PR_DM_SYS_LOG_BATCH | 공통SP | 여러 UI 에서 사용 | DMF0003,DMF0014,DMF0044,DMF0049,DMF0082 | 20 |
| PR_GET_DAY_RANGE | 공통SP | 여러 UI 에서 사용 | DMF0003,DMF0014,DMF0021,DMF0042,DMF0048,SDM1020 | 0 |
| PR_SCM_ADM_RECIPIENT_LIST_HIST | 공통SP | 여러 UI 에서 사용 | SCM0007,SYS0017 | 0 |
| PR_SCM_ADM_RECIPIENT_MESSAGE_HIST | 공통SP | 여러 UI 에서 사용 | SCM0007,SYS0017 | 0 |
| PR_SCM_SYS_LOG_BATCH | 공통SP | 여러 UI 에서 사용 | COM0008,COM0013,DMF0003,DMF0006,DMF0007,DMF0008,DMF0014,DMF0020,DMF0021,DMF0022,DMF0035,DMF0040,DMF0042,DMF0043,DMF0044,DMF0048,DMF0049,DMF0053,DMF0068,DMF0072,DMF0074,DMF0082,SCM0007,SCP0001,SCP0006,SCP0007,SDM1010,SDM1020,SDM2010,SDM2020,SDM5010,SYS0010,SYS0013,SYS0016,SYS0017 | 41 |
| SCM0001_GET_DIVISION | 공통SP | 여러 UI 에서 사용 | DMF0008,DMF0072 | 0 |
| SCM0002_SET_TITLESET_POPUP | 공통SP | 여러 UI 에서 사용 | DMF0003,DMF0021,DMF0040,DMF0042,DMF0044,DMF0048,DMF0049,DMF0053,DMF0082 | 0 |
| SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG | 공통SP | 여러 UI 에서 사용 | DMF0003,DMF0082 | 15 |
| PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW | 공통SP(UI+배치) | UI 1개 + 스케줄러 JOB 에서도 호출 — UI PKG 로 옮기면 배치 영향 | DMF0082 | 13 |
| PR_DM_DNM_CREATE_C_WS_RTF | 공통SP(UI+배치) | UI 1개 + 스케줄러 JOB 에서도 호출 — UI PKG 로 옮기면 배치 영향 | DMF0082 | 10 |
| PR_DM_DNM_CREATE_WS_RTF | 공통SP(UI+배치) | UI 1개 + 스케줄러 JOB 에서도 호출 — UI PKG 로 옮기면 배치 영향 | DMF0082 | 10 |
| PR_DM_IRREGULAR_SALES_PLAN_CUTOFF_MAIL_SEND | 공통SP(UI+배치) | UI 1개 + 스케줄러 JOB 에서도 호출 — UI PKG 로 옮기면 배치 영향 | DMF0082 | 13 |
| PR_DM_MST_EXCHANGE_RATE_CUTOFF | 공통SP(UI+배치) | UI 1개 + 스케줄러 JOB 에서도 호출 — UI PKG 로 옮기면 배치 영향 | DMF0082 | 13 |
| PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE | 공통SP(UI+배치) | UI 1개 + 스케줄러 JOB 에서도 호출 — UI PKG 로 옮기면 배치 영향 | DMF0082 | 10 |
| PR_DM_PLN_MKT_FCST_MAKE_CUST_FCST | 공통SP(UI+배치) | UI 1개 + 스케줄러 JOB 에서도 호출 — UI PKG 로 옮기면 배치 영향 | DMF0014 | 1 |
| PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE | 공통SP(UI+배치) | UI 1개 + 스케줄러 JOB 에서도 호출 — UI PKG 로 옮기면 배치 영향 | DMF0082 | 10 |
| PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE | 공통SP(UI+배치) | UI 1개 + 스케줄러 JOB 에서도 호출 — UI PKG 로 옮기면 배치 영향 | DMF0082 | 13 |
| PR_SCM_MST_FUTURE_PRICE_CUTOFF | 공통SP(UI+배치) | UI 1개 + 스케줄러 JOB 에서도 호출 — UI PKG 로 옮기면 배치 영향 | DMF0082 | 13 |
| PR_SSP_ANL_ESS_REQ | 공통SP(UI+배치) | UI 1개 + 스케줄러 JOB 에서도 호출 — UI PKG 로 옮기면 배치 영향 | DMF0003 | 1 |
| PR_SSP_ANL_ESS_REQ_NET | 공통SP(UI+배치) | UI 1개 + 스케줄러 JOB 에서도 호출 — UI PKG 로 옮기면 배치 영향 | DMF0003 | 1 |
| PR_GET_MENU_LIST_V2 | 프레임워크공통(BE 매퍼 직접호출) | BE 매퍼(sql/*.xml)가 직접 호출하는 공용 |  | 0 |

## 5. 보류

| standalone SP | 분류 | 보류 사유 | 등록 메뉴 |
|---|---|---|---|
| PR_SCM_MST_LOCATION_HIST | FE 화면 미구현 메뉴 사용(전환 보류) | 등록 메뉴의 FE 화면이 아직 없음 — 화면 구현 후 재판정 | SCP0001 |
| PR_SCM_MST_LOCATION_OSP_HIST | FE 화면 미구현 메뉴 사용(전환 보류) | 등록 메뉴의 FE 화면이 아직 없음 — 화면 구현 후 재판정 | SCP0001 |
| PR_SCM_MST_SITE_HIST | FE 화면 미구현 메뉴 사용(전환 보류) | 등록 메뉴의 FE 화면이 아직 없음 — 화면 구현 후 재판정 | SCP0001 |
| PR_SCM_SYS_LOG_BATCH_CALL_TRAN | FE 화면 미구현 메뉴 사용(전환 보류) | 등록 메뉴의 FE 화면이 아직 없음 — 화면 구현 후 재판정 | SCP0007 |
| PR_SCP_MST_BOD_HIST | FE 화면 미구현 메뉴 사용(전환 보류) | 등록 메뉴의 FE 화면이 아직 없음 — 화면 구현 후 재판정 | SCP0007 |
| PR_SCP_MST_BOD_ITEM | FE 화면 미구현 메뉴 사용(전환 보류) | 등록 메뉴의 FE 화면이 아직 없음 — 화면 구현 후 재판정 | SCP0007 |
| PR_DM_DNM_EDI_CALLOFF_STATUS | 등록됐으나 FE 미사용(타 UI·배치 사용 — 보류) | FE 호출은 없으나 다른 UI 등록·배치 JOB 도달 | DMF0008 |
| P_SYS0015_GET_PROGRAM_LIST_M | 범위외메뉴전용 | SDM·비활성 화면 등 조사 범위 밖 메뉴만 사용 | SYS0015 |
| P_SYS0015_SAVE_PROGRAM_M | 범위외메뉴전용 | SDM·비활성 화면 등 조사 범위 밖 메뉴만 사용 | SYS0015 |

## 6. 동일명 중복 (standalone ↔ PKG 멤버)

| standalone SP | 동일명 PKG 멤버 | 래퍼 | 판정 |
|---|---|---|---|
| DMF0000_GET_UPDATE_HISTORY | PKG_DMF0000.P_DMF0000_GET_UPDATE_HISTORY | N | standalone 만 FE 사용 / PKG 멤버 미사용 — standalone→멤버 재배선 후 standalone 삭제(멤버 본문 동일성 확인) |
| DMF0002_GET_TITLESET_POPUP | PKG_DMF0002.P_DMF0002_GET_TITLESET_POPUP | N | standalone = 프레임워크(BE 매퍼 직접 호출) 사용 / PKG 멤버 미사용 — 멤버 삭제 가능(BE 매퍼 전환 시에는 반대) |
| DMF0008_GET_EDI_MST_REPAIR | PKG_DMF0008.P_DMF0008_GET_EDI_MST_REPAIR | N | standalone 만 FE 사용 / PKG 멤버 미사용 — standalone→멤버 재배선 후 standalone 삭제(멤버 본문 동일성 확인) |
| DMF0008_GET_EDI_MST_SUMMARY | PKG_DMF0008.P_DMF0008_GET_EDI_MST_SUMMARY | N | standalone 만 FE 사용 / PKG 멤버 미사용 — standalone→멤버 재배선 후 standalone 삭제(멤버 본문 동일성 확인) |
| DMF0008_GET_SALES_SITE | PKG_DMF0008.P_DMF0008_GET_SALES_SITE | N | standalone 만 FE 사용 / PKG 멤버 미사용 — standalone→멤버 재배선 후 standalone 삭제(멤버 본문 동일성 확인) |
| DMF0008_GET_SALES_SITE_PROJECT_MODEL | PKG_DMF0008.P_DMF0008_GET_SALES_SITE_PROJECT_MODEL | N | standalone 만 FE 사용 / PKG 멤버 미사용 — standalone→멤버 재배선 후 standalone 삭제(멤버 본문 동일성 확인) |
| DMF0008_GET_UPDATE_HISTORY | PKG_DMF0008.P_DMF0008_GET_UPDATE_HISTORY | N | standalone 만 FE 사용 / PKG 멤버 미사용 — standalone→멤버 재배선 후 standalone 삭제(멤버 본문 동일성 확인) |
| DMF0008_SAVE_SALES_SITE_EDI_REPAIR | PKG_DMF0008.P_DMF0008_SAVE_SALES_SITE_EDI_REPAIR | N | standalone 만 FE 사용 / PKG 멤버 미사용 — standalone→멤버 재배선 후 standalone 삭제(멤버 본문 동일성 확인) |
| DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR | PKG_DMF0008.P_DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR | N | standalone 만 FE 사용 / PKG 멤버 미사용 — standalone→멤버 재배선 후 standalone 삭제(멤버 본문 동일성 확인) |
| DMF0020_GET_SCM_MST_FUTURE_PRICE | PKG_DMF0020.P_DMF0020_GET_SCM_MST_FUTURE_PRICE | N | PKG 멤버만 FE 사용 / standalone 미사용 — standalone 삭제 가능 |
| DMF0020_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP | PKG_DMF0020.P_DMF0020_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP | N | PKG 멤버만 FE 사용 / standalone 미사용 — standalone 삭제 가능 (standalone 은 FE 미사용 시트에 등록 잔존 → 배선 정리) |
| DMF0020_GET_SPREAD_TITLE_DATE | PKG_DMF0020.P_DMF0020_GET_SPREAD_TITLE_DATE | N | PKG 멤버만 FE 사용 / standalone 미사용 — standalone 삭제 가능 |
| DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL | PKG_DMF0020.P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL | N | PKG 멤버만 FE 사용 / standalone 미사용 — standalone 삭제 가능 |
| DMF0020_SAVE_SCM_MST_FUTURE_PRICE_CONVERSION | PKG_DMF0020.P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_CONVERSION | N | PKG 멤버만 FE 사용 / standalone 미사용 — standalone 삭제 가능 |
| DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP | PKG_DMF0020.P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP | N | PKG 멤버만 FE 사용 / standalone 미사용 — standalone 삭제 가능 (standalone 은 FE 미사용 시트에 등록 잔존 → 배선 정리) |
| DMF0043_GET_CONTRIBUTE_RATE_POPUP | PKG_DMF0043.P_DMF0043_GET_CONTRIBUTE_RATE_POPUP | N | standalone 만 FE 사용 / PKG 멤버 미사용 — standalone→멤버 재배선 후 standalone 삭제(멤버 본문 동일성 확인) |
| DMF0043_GET_CONTRIBUTE_YEAR_POPUP | PKG_DMF0043.P_DMF0043_GET_CONTRIBUTE_YEAR_POPUP | N | standalone 만 FE 사용 / PKG 멤버 미사용 — standalone→멤버 재배선 후 standalone 삭제(멤버 본문 동일성 확인) |
| DMF0043_GET_CONT_VIEW_VERSIONPOPUP | PKG_DMF0043.P_DMF0043_GET_CONT_VIEW_VERSIONPOPUP | N | standalone 만 FE 사용 / PKG 멤버 미사용 — standalone→멤버 재배선 후 standalone 삭제(멤버 본문 동일성 확인) |
| DMF0043_GET_MAIN_SPREAD_TITLE | PKG_DMF0043.P_DMF0043_GET_MAIN_SPREAD_TITLE | Y | standalone 이 PKG 멤버를 감싸는 래퍼(FE 사용) — 래퍼 로직을 PKG 멤버로 흡수 후 재배선·standalone 삭제 |
| DMF0043_GET_MAIN_VARSION_DATA | PKG_DMF0043.P_DMF0043_GET_MAIN_VARSION_DATA | N | standalone 만 FE 사용 / PKG 멤버 미사용 — standalone→멤버 재배선 후 standalone 삭제(멤버 본문 동일성 확인) |
| DMF0043_GET_SALES_LIST_SPREAD_TITLE | PKG_DMF0043.P_DMF0043_GET_SALES_LIST_SPREAD_TITLE | N | standalone 만 FE 사용 / PKG 멤버 미사용 — standalone→멤버 재배선 후 standalone 삭제(멤버 본문 동일성 확인) |
| DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO | PKG_DMF0043.P_DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO | N | standalone 만 FE 사용 / PKG 멤버 미사용 — standalone→멤버 재배선 후 standalone 삭제(멤버 본문 동일성 확인) |
| DMF0043_SAVE_DM_MST_CONTRIBUTE_VER | PKG_DMF0043.P_DMF0043_SAVE_DM_MST_CONTRIBUTE_VER | N | standalone 만 FE 사용 / PKG 멤버 미사용 — standalone→멤버 재배선 후 standalone 삭제(멤버 본문 동일성 확인) |
| DMF0048_GET_SPREAD_TITLE | PKG_DMF0048.P_DMF0048_GET_SPREAD_TITLE | N | standalone 만 FE 사용 / PKG 멤버 미사용 — standalone→멤버 재배선 후 standalone 삭제(멤버 본문 동일성 확인) |
| PR_DM_MST_SAVE_CUSTOMER_MODEL_MAPPING_DATA | PKG_DMF0006.P_PR_DM_MST_SAVE_CUSTOMER_MODEL_MAPPING_DATA | N | PKG 멤버만 FE 사용 / standalone 미사용 — standalone 삭제 가능 |
| SCM0002_SET_DEFAULT_TITLESET_POPUP | PKG_SCM0002.P_SCM0002_SET_DEFAULT_TITLESET_POPUP | N | 둘 다 FE 사용 미확인 — 참조 확인 후 삭제 판단 |
| SCM0002_SET_TITLESET_POPUP | PKG_SCM0002.P_SCM0002_SET_TITLESET_POPUP | N | standalone = 프레임워크(BE 매퍼 직접 호출) 사용 / PKG 멤버 미사용 — 멤버 삭제 가능(BE 매퍼 전환 시에는 반대) |

## 7. 취합 작업 시 절차 (참고 — 이번에는 실행하지 않음)

1. 작업 직전 이 목록을 사내·클라우드에서 다시 조회(객체 차이·신규 등록 확인)
2. 신규 PKG(PKG_DMF0008·PKG_SYS0012): SPEC/BODY 생성 + SCMP_APP EXECUTE 권한·시노님
3. standalone 본문 무수정으로 PKG 멤버 추가 (동일명 멤버가 있으면 본문 동일성 확인 후 재배선만, 래퍼는 로직 흡수)
4. 재배선: API_M.API_URL · PROC_M(PROC_NM) · EXCEL STORAGE_SQL_ID · 호출부 본문을 PKG 한정명으로
5. FE 미사용 등록(시트 표기)은 BTN_MPG·API_M 정리
6. 화면 실측(조회·저장) → 참조 0 재확인 → 백업 DDL 보관 → standalone·SCMP_APP 시노님 DROP
7. INVALID standalone(DMF0008 4건·DMF0043_GET_CONTRIBUTION_SALES_LIST)은 먼저 재컴파일로 정상 여부 확인
8. 클라우드: 멱등 SQL 이관 패키지(사내 전값 WHERE 금지·MERGE)

## 8. 판정 한계

- DB Link·외부 IF·클라우드 전용 객체는 확인 불가
- 스케줄러 JOB 은 패키지 단위 의존 폐포라 넓게 잡힘(제외 쪽으로 보수적)
- FE 시트 확인은 문자열 리터럴 기준 — 동적으로 만든 시트명은 FE 미사용으로 보일 수 있음(해당 행은 시트 1·2 에 표기)
