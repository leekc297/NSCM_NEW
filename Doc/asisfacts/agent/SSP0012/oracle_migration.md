# SSP0012 Oracle 전환 분석

## 1. 호출 SP 인벤토리

| # | FoxQuery ID | SP | 호출 위치 | 참조 객체 | EXEC 체인 |
|---:|---|---|---|---|---|
| 1 | `SSP.SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL` | `SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL` | FindData_Main:418 (조회) | CREATE/SELECT `#TBLDYNAMICPIVOT_SSP0012`, REF `FN_GET_IN_STR`, REF `FN_SCM_SPLIT`, DYNAMIC SQL | EXEC:SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL → (동적 SQL `DYNAMIC@SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL`) |
| 2 | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | `SCM0001_GET_SCP_DAY_PERIOD` | GetDayRange:596 (Form_Load, Division 변경) | SELECT `SCM_SYS_CALENDAR_M`, SELECT `SCM_ADM_LOOKUP_MASTER_DETAIL`, REF `FN_MULTY_TIME`, REF `FN_WEEKOFDAY_DATE`, SELECT `CTE_DATE`(CTE) | EXEC:SCM0001_GET_SCP_DAY_PERIOD |

- 주석 처리됨: `SCP.GET_DATE_RANGE_1MONTH` (595행). 전환 대상에서 뺍니다.
- `SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL` 이 참조하는 **실 테이블**은 정적 추출 결과에 나타나지 않았습니다. 동적 SQL 안에서 참조할 가능성이 있으므로 SP 원문 확인이 필요합니다.

## 2. 공통코드 분기 (biz:CommonData.CommonDataList)

| 호출 | code | 분기 대상 | 참조 테이블 |
|---|---|---|---|
| `<field:dtFcstType>`:56 | LookupCommon | `UP_FX_GetCommonDataList` | `SCM_ADM_LOOKUP_MASTER`, `SCM_ADM_LOOKUP_MASTER_DETAIL` |
| `<field:dtBaseDay>`:57 | LookupCommon | `UP_FX_GetCommonDataList` | `SCM_ADM_LOOKUP_MASTER`, `SCM_ADM_LOOKUP_MASTER_DETAIL` |
| `SetChangedPeriod`:542 | `PERIOD_{p:value}` \|\| `PERIOD_DEFAULT` | **확인 필요** | **확인 필요** (결과 컬럼 `FROM_VALUE`, `TO_VALUE` 사용, 549~550행) |

- LookupCommon 의 lookup 그룹 코드값(dtFcstType / dtBaseDay 가 넘기는 키)은 미추출이므로 **확인 필요**입니다.

## 3. FoxQuery 미등록 / 직접 호출 SP

- 미등록(UNMATCH) 또는 직접 SQL 호출로 추출된 건은 **없습니다**. 두 FoxQuery 는 모두 `MATCH` 상태입니다.

## 4. Oracle 전환 시 확인 포인트

### 4-1. `SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL`
| # | 사실 | 전환 확인 포인트 |
|---:|---|---|
| 1 | `CREATE:#TBLDYNAMICPIVOT_SSP0012` 임시 테이블 생성 | MSSQL `#temp` → Oracle GTT(사전 생성) 또는 CTE/인라인 뷰로 바꿉니다. GTT 를 쓰면 세션 재사용 시 시작할 때 비우는지 확인합니다 |
| 2 | `DYNAMIC@...` 동적 SQL, 이름에 PIVOT 포함 | 동적 컬럼 생성 → Oracle `EXECUTE IMMEDIATE`/`OPEN ... FOR` + SYS_REFCURSOR. 결과 컬럼이 메타 47컬럼(`DAYS_MON`~`DAYS_SUN` 등)과 맞는지 확인합니다 |
| 3 | `REF:FN_GET_IN_STR`, `REF:FN_SCM_SPLIT` | 다중 선택 문자열(GetCheckedListValue 결과로 보임) 분해 함수 → Oracle 에 같은 함수가 있는지 확인하거나 `REGEXP_SUBSTR`/`CONNECT BY` 로 바꿉니다 |
| 4 | 입력 파라미터 | 미추출. FindData_Main 398~399행 CheckedList 값과 Period/Model/Sold To/Ship To 의 매핑은 **확인 필요**입니다 |

### 4-2. `SCM0001_GET_SCP_DAY_PERIOD`
| # | 사실 | 전환 확인 포인트 |
|---:|---|---|
| 1 | `SELECT:CTE_DATE` (CTE) | 재귀 CTE라면 Oracle 재귀 WITH 문법(컬럼 목록 필수)을 확인합니다 |
| 2 | `REF:FN_MULTY_TIME`, `REF:FN_WEEKOFDAY_DATE` | 이 함수들이 Oracle 에 있는지 확인합니다 |
| 3 | `SCM_SYS_CALENDAR_M`, `SCM_ADM_LOOKUP_MASTER_DETAIL` | Oracle 시노님/권한을 확인합니다 |
| 4 | SCP 도메인 공용 SP | 다른 화면과 공유하므로 수정할 때 영향 범위를 확인합니다 |

### 4-3. 난이도 (사실 근거)
| SP | 근거 | 평가 |
|---|---|---|
| `SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL` | 임시 테이블 + 동적 SQL + split 함수 2종 | 이 화면에서 상대적으로 높음 |
| `SCM0001_GET_SCP_DAY_PERIOD` | CTE + 함수 2종 + 테이블 2종, 공용 | 중간. 공용 SP 라 이미 전환되었는지 확인 필요 |

## 5. DB 메타 테이블 (화면 ID 행)

| 메타 테이블 | 행 수 | 전환 대상 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 47 | Grid 컬럼 메타 |
| dbo.TB_FX_SearchCondition | 46 | 조회조건 저장값 |
| dbo.SCM_MST_TITLESET_USER | 90 | 사용자 타이틀셋(컬럼 설정 추정, **확인 필요**) |
| dbo.TB_FX_GroupMenuAuth | 16 | 그룹별 메뉴 권한 |
| dbo.TB_FX_Favorite | 12 | 즐겨찾기 |
| dbo.TB_FX_MenuItemInfo | 4 | 메뉴 |
| dbo.TB_FX_ProgramInfo | 4 | 프로그램 |
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 7 | 스크립트 백업 이력(이관 대상 여부 **확인 필요**) |
