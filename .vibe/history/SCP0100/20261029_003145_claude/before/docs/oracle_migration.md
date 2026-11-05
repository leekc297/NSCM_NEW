# SCP0100 Oracle 전환 분석

## 1. 호출 SP 인벤토리

| SP | FoxQuery 키 | 호출 메서드(줄) | 참조 객체 | EXEC 체인 |
|---|---|---|---|---|
| SCP0100_GET_SHEET_CALENDAR_3SPAN | SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN | GetSpdTitle(1326) | SELECT: SCM_SYS_CALENDAR_M | 자기 자신만 (하위 EXEC 없음) |
| SCP0100_GET_SITE | SCP.SCP0100_GET_SITE | GetSiteList(1342) | SELECT: SCP_RPT_GLOBAL_PSI_MD_MM, SCP_RPT_GLOBAL_PSI_MD_WW / REF: FN_SPLITSTRING | 자기 자신만 |
| SCP0100_GET_PLAN_DATE | SCP.SCP0100_GET_PLAN_DATE | GetPlanDate(1365) | INSERT/SELECT: #TMP_PLAN / SELECT: SCP_PLAN_VERSION_V, SCM_SYS_CALENDAR_M, SCP_PLN_INTERFACE_YN, SCP_RPT_GLOBAL_PSI_MD_MM, SCP_RPT_GLOBAL_PSI_MD_WW / REF: FN_CHAR_TO_DATE, FN_SPLITSTRING | 자기 자신만 |

- 참조 테이블과 뷰를 합친 목록(중복 제거): SCM_SYS_CALENDAR_M, SCP_RPT_GLOBAL_PSI_MD_MM, SCP_RPT_GLOBAL_PSI_MD_WW, SCP_PLAN_VERSION_V, SCP_PLN_INTERFACE_YN
- 참조 함수: FN_SPLITSTRING, FN_CHAR_TO_DATE
- 임시 테이블: #TMP_PLAN (SCP0100_GET_PLAN_DATE)

## 2. 공통코드 분기

| 호출 | code | 대상 테이블 |
|---|---|---|
| `biz:CommonData.CommonDataList_REPORT` (via `Data_REPORT.CallBizCommonData`) | `{?Data_REPORT.Type.PLAN_END_DATE}` | **확인 필요** — 사실 묶음에 SP·테이블 정보 없음 |

## 3. FoxQuery 미등록 / 직접 호출 SP

- FoxQuery 미등록 SP: 사실 묶음 기준 **0건**. 3개 모두 MATCH입니다.
- 직접 SQL 호출: **0건**
- Biz 경유 호출 1건: CommonDataList_REPORT. 내부 SP는 **확인 필요**입니다.
- 주석 처리된 호출: **0건**
- 메인 리포트 데이터 조회 SP: 추출되지 않았습니다(**확인 필요**). 아래 사실로 미루어 메인 조회 SP가 따로 있을 가능성이 높지만, SP명은 사실 묶음에 없습니다.
  - 리포트 원천 테이블 SCP_RPT_GLOBAL_PSI_MD_MM / _WW가 SITE·PLAN_DATE SP에서 참조됨
  - 기간 컬럼명 M_ / W_ 규칙이 있음

## 4. Oracle 전환 시 확인 포인트

| # | 대상 | 사실 | 확인 포인트 |
|---:|---|---|---|
| 1 | SCP0100_GET_PLAN_DATE | `#TMP_PLAN` INSERT 후 SELECT | MSSQL 로컬 임시테이블 → Oracle GTT(ON COMMIT 옵션) 또는 CTE/서브쿼리로 바꿈. GTT 쓰면 DDL 자급(배포 패키지 동봉) 필요 |
| 2 | SCP0100_GET_PLAN_DATE | REF: FN_CHAR_TO_DATE | Oracle 동등 함수(또는 TO_DATE) 존재 여부와 포맷 인자 확인 |
| 3 | SCP0100_GET_SITE, SCP0100_GET_PLAN_DATE | REF: FN_SPLITSTRING | 멀티선택 파라미터(Division·Site 등 `GetCheckedListValue` 결과) 분해 함수. Oracle 버전 존재 여부와 VARCHAR2 길이 한도 확인 |
| 4 | SCP0100_GET_SHEET_CALENDAR_3SPAN | SELECT: SCM_SYS_CALENDAR_M | 반환 컬럼 COLUMN_NAME, COLUMN_LABEL_NAME, LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME, DAY_CODE, SORT_ORDER_NO(프레임워크 소비 컬럼)를 Oracle 결과셋 컬럼명(대문자)과 맞춰야 함. 컬럼명 접두 M_ / W_ / B_ 규칙 유지 필요 |
| 5 | 전 SP | 결과셋 반환 | MSSQL SELECT 결과셋 → Oracle SYS_REFCURSOR OUT 변환 |
| 6 | SCP_PLAN_VERSION_V | 뷰 | Oracle 측 뷰 존재와 정의 확인 |
| 7 | 정렬 | SORT_ORDER_NO 소비 | 그리드 조회 SP에 ORDER BY 명시 여부 확인 |
| 8 | CommonDataList_REPORT (PLAN_END_DATE) | Biz 경유 | TO-BE 공통 콤보/코드 SP로 대체할 대상 확인 |

## 5. 난이도 (사실 근거)

| SP | 난이도 | 근거 |
|---|---|---|
| SCP0100_GET_SHEET_CALENDAR_3SPAN | 낮음 | 참조 테이블 1개(SCM_SYS_CALENDAR_M), 임시테이블·함수 참조 없음 |
| SCP0100_GET_SITE | 중간 | 테이블 2개 + FN_SPLITSTRING 의존 |
| SCP0100_GET_PLAN_DATE | 중간~높음 | #TMP_PLAN 임시테이블, 함수 2종(FN_CHAR_TO_DATE, FN_SPLITSTRING), 테이블·뷰 5종 참조 |

> SP 본문 원문은 사실 묶음에 없습니다. MSSQL 키워드(DATEADD, ISNULL 등)가 남아 있는지는 원문을 확보한 뒤 **확인 필요**입니다.
