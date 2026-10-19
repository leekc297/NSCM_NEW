# DMF0052 EDI Summary 업무분석서

## 1. 업무 목적 및 범위
### 1.1 목적
ERP에서 전송한 EDI(Electronic Data Interchange) Call-off 데이터의 수신 현황을 요약하고, GSCM과 ERP 데이터 간 불일치를 검증하여 Master Data 정비가 필요한 항목을 식별합니다.

### 1.2 범위
- ERP → GSCM EDI 데이터 수신 현황 조회 (날짜별/프로젝트별/상태별)
- GSCM Master Data 검증 (Sales Site, SSPM, Incoterms 누락/비활성 체크)
- ERP 데이터 상세 조회 및 상태 확인
- 조회 전용 화면 (저장/수정/삭제 기능 없음)

## 2. 사용자 시나리오
### 시나리오 1: 전체 EDI 수신 현황 조회
**행위**: 사용자가 기간/EDI Sender/프로젝트/Model 조건을 선택하고 조회 버튼 클릭  
**시스템 처리**:  
- `DM.DMF0052_GET_SUMMARY_DATA` → `DMF0052_GET_SUMMARY_DATA` SP 호출하여 날짜별 ERP 전송 건수/GSCM 수신 건수 조회 (원천: `XIF_ERP_EDI_CALLOFF_ITEM_R_SN`)
- `DM.DMF0052_GET_PJT_DATA` → `DMF0052_GET_PJT_DATA` SP 호출하여 프로젝트별 정상/검증 필요 건수 집계 (원천: `DM_DNM_EDI_CALLOFF_ITEM`, 임시테이블 `#T_GSCM_DATA`, `#T_ERP_DATA`)
- `DM.DMF0052_GET_STATUS_DATA` → `DMF0052_GET_STATUS_DATA` SP 호출하여 상태별 통계 조회 (원천: `DM_DNM_EDI_CALLOFF_ITEM`)  
**결과**: SUMMARY 시트(날짜별 4컬럼), Summary Pjt 시트(프로젝트별 8컬럼), Summary Status 시트(상태별 4컬럼)에 데이터 표시

### 시나리오 2: GSCM Master Data 검증 상세 조회
**행위**: Summary Pjt 시트에서 "Master Data 정비 필요 건 수 (GSCM)" 컬럼 더블클릭  
**시스템 처리**:  
- `DM.DMF0052_GET_DETAIL_DATA` → `DMF0052_GET_DETAIL_DATA` SP 호출 (원천: `DM_DNM_EDI_CALLOFF_ITEM`, `SCM_MST_SITE_ITEM`, `SCM_MST_ITEM_SN`, 임시테이블 `#T_EDI`)
- spdData 시트를 "GSCM Data"로 전환  
**결과**: GSCM Data 시트(10컬럼)에 Sales Site 누락/Active, SSPM 누락/Active, EDI Incoterms 검증 결과 표시

### 시나리오 3: ERP Data 상세 조회
**행위**: Summary Pjt 시트에서 "ERP Data 확인 필요" 컬럼 더블클릭  
**시스템 처리**:  
- `DM.DMF0052_GET_ERP_DATA` → `DMF0052_GET_ERP_DATA` SP 호출 (원천: `DM_DNM_EDI_CALLOFF_ITEM`, `SCM_MST_ITEM_SN`, 임시테이블 `#T_EDI`)
- spdData 시트를 "ERP Data"로 전환  
**결과**: ERP Data 시트(10컬럼)에 Company/Sold to/Ship to/EDI_IF_SEQ/Status Detail 표시

### 시나리오 4: Refresh (GSCM Data 갱신)
**행위**: GSCM Data 시트 표시 중 btnRefresh 버튼 클릭  
**시스템 처리**: 시나리오 2와 동일 (`DM.DMF0052_GET_DETAIL_DATA` 재호출)  
**결과**: GSCM Data 최신 상태로 갱신

### 시나리오 5: 화면 초기 로드
**행위**: 화면 진입 (Form_Load 이벤트)  
**시스템 처리**:  
- `DM.DMF0052_GET_SPREAD_TITLE` → `DMF0052_GET_SPREAD_TITLE` SP 호출하여 시트별 컬럼 메타 조회 (원천: `SCM_MST_TITLESET_USER`, `SCM_MST_SHEET_COLUMNS`)
- `DM.UP_FX_GetCommonDataList_DM` → `UP_FX_GETCOMMONDATALIST_DM` SP 호출하여 EDI Sender 콤보 데이터 조회 (원천: `SCM_ADM_LOOKUP_MASTER_DETAIL` 등 복수 테이블)  
**결과**: 조회조건 컨트롤 초기화, 빈 그리드 표시

## 3. 업무 흐름도
```
1. [화면 진입] Form_Load
   → DMF0052_GET_SPREAD_TITLE (시트 컬럼 메타)
   → UP_FX_GETCOMMONDATALIST_DM (EDI Sender 콤보)
   → 조회조건 초기화

2. [조회 버튼 클릭] FindButton
   → DMF0052_GET_SUMMARY_DATA (SUMMARY 시트)
   → DMF0052_GET_PJT_DATA (Summary Pjt 시트)
   → DMF0052_GET_STATUS_DATA (Summary Status 시트)
   → 3개 시트 데이터 표시

3. [Summary Pjt 더블클릭] spdPjt_CellDoubleClick
   → 클릭 컬럼 = "CHECK_GSCM_CNT" && 값 != "0"
     → DMF0052_GET_DETAIL_DATA (GSCM Data)
     → spdData 시트 "GSCM Data"로 전환
   → 클릭 컬럼 = "CHECK_ERP_CNT" && 값 != "0"
     → DMF0052_GET_ERP_DATA (ERP Data)
     → spdData 시트 "ERP Data"로 전환

4. [Refresh 버튼 클릭] BtnRefresh_Click
   → 현재 spdData 활성 시트 = "GSCM Data"
     → DMF0052_GET_DETAIL_DATA 재호출

5. [spdData 시트 전환] spdData_ActiveSheetChanging
   → GSCM Data ↔ ERP Data 수동 전환 (각 시트 초기화 로직 실행 가능)

6. [spdData 더블클릭] spdData_CellDoubleClick
   → 팝업 호출 (조건 확인 필요 - Fact Pack에 본문 없음)
```

## 4. 업무 규칙
### 4.1 SP 분기 조건
| SP | 분기 조건 | 처리 |
|---|---|---|
| DMF0052_GET_PJT_DATA | Fact Pack에 코드 본문 없음 | 임시테이블 #T_GSCM_DATA, #T_ERP_DATA 생성/조인하여 프로젝트별 집계 (확인 필요) |
| DMF0052_GET_DETAIL_DATA | Fact Pack에 코드 본문 없음 | 임시테이블 #T_EDI 생성, DM_DNM_EDI_CALLOFF_ITEM 조인하여 Sales Site/SSPM 검증 (확인 필요) |
| DMF0052_GET_ERP_DATA | Fact Pack에 코드 본문 없음 | 임시테이블 #T_EDI 생성, DM_DNM_EDI_CALLOFF_ITEM 조인하여 ERP 상태 조회 (확인 필요) |
| DMF0052_GET_STATUS_DATA | Fact Pack에 코드 본문 없음 | DM_DNM_EDI_CALLOFF_ITEM에서 상태별 집계 (확인 필요) |

### 4.2 필수값
- 조회 조건: 모두 선택 사항 (기간/EDI Sender/프로젝트/Model 빈값 가능, 빈값 시 전체 조회 추정)
- chkToday 체크박스: 체크 시 오늘 날짜로 기간 필터 (chkToday_CheckedChanged 핸들러 본문 확인 필요)

### 4.3 검증 규칙
Fact Pack에 SP 본문/검증 로직 없음. 아래는 컬럼명 기반 추정:
- GSCM Data 시트: CHECK_SALES_SITE (Sales Site 누락 여부), CHECK_SALES_ACTIVE (Sales Site Active 여부), CHECK_SSPM (SSPM 누락 여부), CHECK_SSPM_ACTIVE (SSPM Active 여부), CHECK_INCOTERMS (EDI Incoterms 검증)
- 검증 로직 상세는 SP 원문 확인 필요

### 4.4 날짜/버킷 규칙
- drpPeriod (UsrDateRangePicker): 조회 기간 범위 선택
- chkToday: 체크 시 drpPeriod를 오늘 날짜로 설정 (추정)
- 버킷 규칙: 본 화면에 버킷 관련 컬럼 없음

## 5. 데이터 흐름 표
| 엔드포인트 | SP | 읽기 테이블 | 쓰기 테이블 | 비고 |
|---|---|---|---|---|
| DM.DMF0052_GET_SUMMARY_DATA | DMF0052_GET_SUMMARY_DATA | XIF_ERP_EDI_CALLOFF_ITEM_R_SN | - | 날짜별 ERP 전송/GSCM 수신 건수 |
| DM.DMF0052_GET_PJT_DATA | DMF0052_GET_PJT_DATA | DM_DNM_EDI_CALLOFF_ITEM, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_SITE_ITEM, SCM_MST_ITEM_SN | #T_GSCM_DATA, #T_ERP_DATA (임시) | 프로젝트별 검증 현황 |
| DM.DMF0052_GET_STATUS_DATA | DMF0052_GET_STATUS_DATA | DM_DNM_EDI_CALLOFF_ITEM | - | 상태별 통계 |
| DM.DMF0052_GET_DETAIL_DATA | DMF0052_GET_DETAIL_DATA | DM_DNM_EDI_CALLOFF_ITEM, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_SITE_ITEM, SCM_MST_ITEM_SN | #T_EDI (임시) | GSCM Master Data 검증 상세 |
| DM.DMF0052_GET_ERP_DATA | DMF0052_GET_ERP_DATA | DM_DNM_EDI_CALLOFF_ITEM, SCM_MST_ITEM_SN | #T_EDI (임시) | ERP 데이터 상세 |
| DM.DMF0052_GET_SPREAD_TITLE | DMF0052_GET_SPREAD_TITLE | SCM_MST_TITLESET_USER, SCM_MST_SHEET_COLUMNS | - | 시트 컬럼 메타 |
| DM.UP_FX_GetCommonDataList_DM | UP_FX_GETCOMMONDATALIST_DM | SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_SITE, TB_FX_USERGROUPAUTHEXTENTION, SCM_MST_SITE_ITEM, SCM_MST_SSO_USER_INFO, SCM_MST_SSO_DEPT_INFO, SCM_MST_SHEET_MEASURE, SCM_SYS_CALENDAR_M, SCM_ITEM_M_SN, SCM_MST_SITE_ITEM_PRIORITY, SCM_MST_ITEM_SN, SCM_LINE_HIERARCHY_V_SN, DM_MST_BUCKET_CONVERSION, SCM_MST_PLANT_SN | - | 공통 콤보 데이터 (EDI Sender 등) |

## 6. Division별 변형
현재 메타는 **division=81만** 정의되어 있습니다.
- 모든 시트(SUMMARY, Summary Pjt, Summary Status, GSCM Data, ERP Data, Site Popup)가 division=81 고정
- 다른 division(40, 82, EE 등)에 대한 메타 데이터 없음
- Division별 컬럼 표시 차이: 현재 확인 불가 (81만 존재)
- TO-BE에서 다른 division 지원 필요 시 메타 추가 작업 필요

## 7. 외부 인터페이스
- **ERP EDI 데이터 수신**: `XIF_ERP_EDI_CALLOFF_ITEM_R_SN` (뷰 또는 인터페이스 테이블, _R_SN 접미사로 추정)에서 ERP 전송 데이터 조회
- **GSCM 내부 테이블**: `DM_DNM_EDI_CALLOFF_ITEM`에 수신된 EDI 데이터 저장 (추정)
- 인터페이스 주기/방식: Fact Pack에 정보 없음 (확인 필요)

## 8. 미확정 및 확인 필요
1. **SP 본문**: Fact Pack에 SP 내부 로직 없음. 아래 사항 확인 필요:
   - DMF0052_GET_PJT_DATA: #T_GSCM_DATA, #T_ERP_DATA 임시테이블 생성/조인 로직
   - DMF0052_GET_DETAIL_DATA: Sales Site/SSPM/Incoterms 검증 조건
   - DMF0052_GET_ERP_DATA: ERP Status, Status Detail 계산 로직
   - DMF0052_GET_STATUS_DATA: 상태별 집계 기준
2. **chkToday_CheckedChanged 핸들러**: 이벤트는 등록되어 있으나 메서드 본문 없음
3. **spdData_CellDoubleClick 핸들러**: 팝업 호출 조건 확인 필요 (DMF0052_GSCMDataPopup 호출 추정)
4. **Site Popup 시트**: 메타에 정의되어 있으나 코드에서 참조 없음 (폐기 후보). DMF0052_GET_SITE_POPUP SP는 Form_Load:211에서 호출되나 화면 표시 여부 불명
5. **조회 조건 빈값 처리**: 기간/EDI Sender/프로젝트/Model 미선택 시 SP 내부 처리 방식 확인 필요 (STRING_SPLIT 함수 사용 → 빈값 시 전체 조회 추정)
6. **Division 확장**: 현재 메타가 81만 정의. 다른 division 지원 필요 여부 및 메타 추가 작업 범위 확인 필요
7. **권한**: TB_FX_GroupMenuAuth에 4행 메타 존재하나 C/R/U/D 권한 상세 미확인

---
