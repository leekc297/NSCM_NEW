# SSP0019 Oracle 전환 분석

## 1. 호출 SP / SQL 인벤토리
| FoxQuery 키 | 유형 | 대상 | 참조 객체 / EXEC 체인 | 호출 위치 |
|---|---|---|---|---|
| SSP.SSP0019_GET_SHIPMENT_CHANGE_HISTORY | SP | `SSP0019_GET_SHIPMENT_CHANGE_HISTORY` | EXEC:SSP0019_GET_SHIPMENT_CHANGE_HISTORY → REF:FN_GET_IN_STR, REF:FN_SCM_SPLIT, DYNAMIC@SSP0019_GET_SHIPMENT_CHANGE_HISTORY | FindData_Main:409 |
| SCP.GET_DATE_RANGE_1MONTH | statement | foxquery_sql\SCP.GET_DATE_RANGE_1MONTH.sql | SELECT:SCM_SYS_CALENDAR_M | GetDayRange:522 |

- SP `SSP0019_GET_SHIPMENT_CHANGE_HISTORY` 의 테이블 참조는 추출되지 않았습니다(동적 SQL 내부). → **확인 필요**
- 주석 처리됨: `SCP.SCM0001_GET_SCP_DAY_PERIOD` (523줄). 전환 대상에서 제외합니다.

## 2. 공통코드 분기
| 호출 | code | 대상 테이블 | 반환 컬럼 사용 |
|---|---|---|---|
| biz:CommonData.CommonDataList (SetChangedPeriod:500) | `PERIOD_{p:value}` \|\| `PERIOD_DEFAULT` | 확인 필요(Biz 내부) | FROM_VALUE(507), TO_VALUE(508) |

- `{p:value}` 는 메서드 파라미터 값입니다. 어떤 값이 들어오는지와 호출 진입점은 **확인 필요**(정적 분석상 unreached).

## 3. FoxQuery 미등록 / 직접 호출 SP
- FoxQuery 미등록 건: 없음. 활성 FoxQuery 2건 모두 MATCH.
- 직접 호출 SP: 추출되지 않음.
- Biz 호출: `Data.CallBizCommonData` 경유 1건(위 2장).

## 4. 프레임워크 메타 의존 (Oracle 측 메타 이관 필요)
| 프레임워크 | 메타 원천 | 비고 |
|---|---|---|
| SpreadInfo.SetSheetHeaderColumn | SCM_MST_SHEET_COLUMNS (SSP0019, 47행) | 시트 `Shipment Change History` |
| DataService.GetSSPInnerTable | 확인 필요 | CODE, COMPANY_ID, DEPT_ID, DIVISION_ID, END_CUSTOMER, LANGUAGE_CODE, NAME, PLANT_ID, SCM_SITE_ID 읽음 |
| DataService.FP_Log2 | 확인 필요 | LOGTYPE, NOTE, USER_ID |
| 기타 메타 테이블 | TB_FX_SearchCondition 96행, TB_FX_Favorite 17행, TB_FX_GroupMenuAuth 16행, TB_FX_MenuItemInfo 4행, TB_FX_ProgramInfo 4행, SCM_ADM_DB_SCRIPT_BACKUP 26행 | |

## 5. Oracle 전환 시 확인 포인트
1. **SSP0019_GET_SHIPMENT_CHANGE_HISTORY**
   - 동적 SQL(DYNAMIC) 포함 → 문자열 조립 구문을 Oracle 문법(`||`, EXECUTE IMMEDIATE / OPEN cursor FOR)으로 바꿔야 합니다. 원문 확인 필요.
   - `FN_GET_IN_STR`, `FN_SCM_SPLIT` 함수 의존 → Oracle 에 같은 함수가 있는지, 반환 형식(IN 문자열 / 분할 테이블)이 같은지 확인해야 합니다.
   - 다건 입력 파라미터(SO No·Model·Confirm ID 멀티라인, CheckedList 값 5건)를 분할 함수로 처리하는 것으로 보이나, 파라미터와 함수의 대응은 **확인 필요**.
   - 결과 컬럼 46(+LAST_SEQ) 과 메타 컬럼의 일치 여부: grid 단계 미실행으로 **확인 필요**.
2. **SCP.GET_DATE_RANGE_1MONTH**: SCM_SYS_CALENDAR_M 단일 SELECT 입니다. 날짜 함수의 MSSQL→Oracle 변환 여부는 SQL 원문으로 확인해야 합니다.
3. **공통코드 PERIOD_***: CommonDataList 의 TO-BE 대응 API와 원천 테이블을 확인해야 합니다.

## 6. 난이도 (사실 근거)
| 대상 | 근거 | 판단 |
|---|---|---|
| SSP0019_GET_SHIPMENT_CHANGE_HISTORY | 동적 SQL + 함수 2종(FN_GET_IN_STR, FN_SCM_SPLIT) 참조, 테이블 미추출 | 중 이상 (원문 확인 전 확정 불가) |
| SCP.GET_DATE_RANGE_1MONTH | 단일 테이블 SELECT statement | 하 (원문 확인 필요) |
| CommonData PERIOD | Biz 경유, 원천 미확인 | 확인 필요 |
