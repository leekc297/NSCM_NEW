# DMF0052 EDI Summary 단위테스트

## 테스트 케이스
| TC-ID | 구분 | 사전조건 | 절차 | 입력값 | 기대결과 | 근거 |
|---|---|---|---|---|---|---|
| TC-DMF0052-001 | 초기화 | 화면 미진입 | 화면 진입 | - | EDI Sender 콤보 데이터 로드, 조회조건 초기화, 빈 그리드 표시 | Form_Load, DM.UP_FX_GetCommonDataList_DM, UP_FX_GETCOMMONDATALIST_DM |
| TC-DMF0052-002 | 초기화 | 화면 진입 | - | - | 6개 시트(SUMMARY, Summary Pjt, Summary Status, GSCM Data, ERP Data, Site Popup) 컬럼 메타 로드 | Form_Load, DM.DMF0052_GET_SPREAD_TITLE, DMF0052_GET_SPREAD_TITLE |
| TC-DMF0052-003 | 조회 | 화면 진입 완료 | 조회 버튼 클릭 | 기간: 2026-01-01~2026-01-31, EDI Sender: 전체, 프로젝트: 빈값, Model: 빈값 | SUMMARY 시트에 날짜별 ERP 전송/GSCM 수신 건수 표시 | FindButton, DM.DMF0052_GET_SUMMARY_DATA, DMF0052_GET_SUMMARY_DATA, SUMMARY 시트 |
| TC-DMF0052-004 | 조회 | 화면 진입 완료 | 조회 버튼 클릭 | 기간: 2026-01-01~2026-01-31, EDI Sender: 전체, 프로젝트: 빈값, Model: 빈값 | Summary Pjt 시트에 프로젝트별 정상/검증 필요 건수 표시 | FindButton, DM.DMF0052_GET_PJT_DATA, DMF0052_GET_PJT_DATA, Summary Pjt 시트 |
| TC-DMF0052-005 | 조회 | 화면 진입 완료 | 조회 버튼 클릭 | 기간: 2026-01-01~2026-01-31, EDI Sender: 전체, 프로젝트: 빈값, Model: 빈값 | Summary Status 시트에 상태별 통계 표시 | FindButton, DM.DMF0052_GET_STATUS_DATA, DMF0052_GET_STATUS_DATA, Summary Status 시트 |
| TC-DMF0052-006 | 조회 | 조회 완료 | Summary Pjt 시트에서 CHECK_GSCM_CNT 컬럼(값 != "0") 더블클릭 | - | spdData 시트가 "GSCM Data"로 전환되고 Master Data 검증 상세 표시 (10컬럼) | spdPjt_CellDoubleClick, DM.DMF0052_GET_DETAIL_DATA, DMF0052_GET_DETAIL_DATA, GSCM Data 시트 |
| TC-DMF0052-007 | 조회 | 조회 완료 | Summary Pjt 시트에서 CHECK_ERP_CNT 컬럼(값 != "0") 더블클릭 | - | spdData 시트가 "ERP Data"로 전환되고 ERP 데이터 상세 표시 (10컬럼) | spdPjt_CellDoubleClick, DM.DMF0052_GET_ERP_DATA, DMF0052_GET_ERP_DATA, ERP Data 시트 |
| TC-DMF0052-008 | 이벤트 | spdData "GSCM Data" 시트 표시 중 | btnRefresh 버튼 클릭 | - | GSCM Data 시트 데이터 재조회 및 갱신 | BtnRefresh_Click, DM.DMF0052_GET_DETAIL_DATA, DMF0052_GET_DETAIL_DATA, GSCM Data 시트 |
| TC-DMF0052-009 | 이벤트 | 조회조건 입력 중 | chkToday 체크박스 체크 | chkToday: checked | drpPeriod가 오늘 날짜로 설정됨 (추정) | chkToday_CheckedChanged |
| TC-DMF0052-010 | 이벤트 | 조회조건 입력 중 | btnProject 버튼 클릭 | - | 프로젝트 선택 팝업 표시, 선택값 txtProject에 반영 (추정) | btnProject_Click |
| TC-DMF0052-011 | 이벤트 | 조회조건 입력 중 | btnItemId 버튼 클릭 | - | Model 선택 팝업 표시, 선택값 txtItemId에 반영 (추정) | btnItemId_Click |
| TC-DMF0052-012 | 그리드 | spdData 표시 중 | GSCM Data ↔ ERP Data 시트 수동 전환 | - | 시트 전환 성공, 각 시트 초기화 로직 실행 (추정) | spdData_ActiveSheetChanging |
| TC-DMF0052-013 | 그리드 | spdData 표시 중 | spdData 셀 더블클릭 | - | 팝업 호출 (조건 확인 필요) | spdData_CellDoubleClick |
| TC-DMF0052-014 | 그리드 | Summary Pjt 시트 표시 중 | CHECK_GSCM_CNT 컬럼(값 = "0") 더블클릭 | - | 동작 없음 (더블클릭 조건: 값 != "0") | spdPjt_CellDoubleClick, Summary Pjt 시트 |
| TC-DMF0052-015 | division | 화면 진입 | 조회 버튼 클릭 (division=81) | - | SUMMARY 시트 4컬럼 표시 (날짜, Status, ERP전송 데이터 수, GSCM 수신한 데이터 수) | SUMMARY 시트, division=81 메타 |
| TC-DMF0052-016 | division | 화면 진입 | 조회 버튼 클릭 (division=81) | - | Summary Pjt 시트 8컬럼 표시 (EDI Sender, EDI Sender Code, Project Code, 수신한 데이터 수, 정상, Master Data 정비 필요 건 수 (GSCM), ERP Data 확인 필요, 최종 수신일) | Summary Pjt 시트, division=81 메타 |
| TC-DMF0052-017 | division | 화면 진입 | 조회 버튼 클릭 (division=81) | - | Summary Status 시트 4컬럼 표시 (Status GSCM, Status ERP, Qty, %) | Summary Status 시트, division=81 메타 |
| TC-DMF0052-018 | division | GSCM Data 시트 표시 | - | - | 10컬럼 표시 (EDI Sender, EDI Sender Code, Project Code, Model, Nickname, Sales Site 누락, Sales Site Active, SSPM 누락, SSPM Active, EDI Incoterms(SSPM)) | GSCM Data 시트, division=81 메타 |
| TC-DMF0052-019 | division | ERP Data 시트 표시 | - | - | 10컬럼 표시 (EDI Sender, Company, Sold to, Ship to, EDI_IF_SEQ, Model, Nickname, Status, (ERP) Status, Status Detail) | ERP Data 시트, division=81 메타 |
| TC-DMF0052-020 | 조회 | 화면 진입 완료 | 조회 버튼 클릭 | 기간: 빈값, EDI Sender: 빈값, 프로젝트: 빈값, Model: 빈값 | 전체 데이터 조회 (빈값 시 전체 조회 추정) | FindButton, DM.DMF0052_GET_SUMMARY_DATA, DM.DMF0052_GET_PJT_DATA, DM.DMF0052_GET_STATUS_DATA |
| TC-DMF0052-021 | 조회 | 조회 완료 | - | - | SUMMARY 시트에 데이터 0건 표시 (조회 결과 없을 경우) | DM.DMF0052_GET_SUMMARY_DATA, DMF0052_GET_SUMMARY_DATA, SUMMARY 시트 |
| TC-DMF0052-022 | 조회 | 조회 완료 | - | - | Summary Pjt 시트에 데이터 0건 표시 (조회 결과 없을 경우) | DM.DMF0052_GET_PJT_DATA, DMF0052_GET_PJT_DATA, Summary Pjt 시트 |
| TC-DMF0052-023 | 조회 | 조회 완료 | - | - | Summary Status 시트에 데이터 0건 표시 (조회 결과 없을 경우) | DM.DMF0052_GET_STATUS_DATA, DMF0052_GET_STATUS_DATA, Summary Status 시트 |
| TC-DMF0052-024 | 조회 | GSCM Data 시트 표시 요청 | - | - | GSCM Data 시트에 데이터 0건 표시 (조회 결과 없을 경우) | DM.DMF0052_GET_DETAIL_DATA, DMF0052_GET_DETAIL_DATA, GSCM Data 시트 |
| TC-DMF0052-025 | 조회 | ERP Data 시트 표시 요청 | - | - | ERP Data 시트에 데이터 0건 표시 (조회 결과 없을 경우) | DM.DMF0052_GET_ERP_DATA, DMF0052_GET_ERP_DATA, ERP Data 시트 |
| TC-DMF0052-026 | 그리드 | 화면 진입 | - | - | Site Popup 시트 메타 존재하나 화면 표시 안 됨 (미사용 추정, 확인 필요) | Site Popup 시트, DM.DMF0052_GET_SITE_POPUP |
| TC-DMF0052-027 | 팝업 | spdData 셀 더블클릭 (PopupType = "CHECK_SALES_SITE" 추정) | - | - | EDI Summary GSCM DATA Popup 표시, 5개 컬럼 표시 (SENDER_NAME, COMPANY_ID, SOLDTO_CODE, SHIPTO_CODE, Message) | spdData_CellDoubleClick, EDI Summary GSCM DATA Popup 시트 |
| TC-DMF0052-028 | 팝업 | spdData 셀 더블클릭 (PopupType != "CHECK_SALES_SITE" 추정) | - | - | EDI Summary GSCM DATA Popup 표시, 9개 컬럼 표시 (SENDER_NAME, COMPANY_ID, SOLDTO_CODE, SHIPTO_CODE, SCM_SITE_ID, VALID_YN, GSCM_CODE, CODE_VALID_YN, Message) | spdData_CellDoubleClick, EDI Summary GSCM DATA Popup 시트 |

---
