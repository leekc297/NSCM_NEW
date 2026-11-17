# SCP0096 Oracle 전환 분석

## 1. 호출 SP 인벤토리
| SP | 호출 키 | 용도(호출 위치) | 참조 테이블 / EXEC 체인 |
|---|---|---|---|
| `DM0003_GET_BUCKET_TYPE_CODE` | DM.DM0003_GET_BUCKET_TYPE_CODE | Form_Load > InitControls > GetBucketType(394) | SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| `SCP0009_GET_SHEET_CALENDAR_3SPAN` | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | GetSpdTitle(831). 3단 날짜 헤더 | SELECT:SCM_SYS_CALENDAR_M |
| `SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` | SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP | FindData_Main(457). 조회 | INSERT:#TBLDYNAMICPIVOT_SCP0096, SELECT:SCP_MST_SHIPMENT_WORKING_DAY_OSP, SCM_MST_SITE, SCM_SYS_CALENDAR_M, SCM_MST_LINE_OSP, SCP_MST_SHIPMENT_WORKING_DAY_DEFAULT, REF:STRING_SPLIT, DYNAMIC SQL |
| `SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP` | SCP.SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP | SaveData_Main(608). 저장 | MERGE:SCP_MST_SHIPMENT_WORKING_DAY_OSP, MERGE:SCP_MST_SHIPMENT_WORKING_DAY_DEFAULT, EXEC:PR_SCM_SYS_LOG_BATCH > INSERT:SCM_SYS_LOG_BATCH |

### 1-1. 저장 SP 파라미터 (SaveData_Main에서 구성한 DataRow 컬럼)
`p_division_id`, `p_plant_site_id`, `p_measure`, `p_user_id`, `p_yyyymmdd`, `p_shipment_yn`, `p_is_save_defalut`(원문 철자), `p_working_time_default`

- 행 상태 키는 `A`(558, 600)이고, 변경 행 추출은 `GetChanges(ROW_ID)`(609)입니다.
- `p_yyyymmdd`~`p_working_time_default`는 570~573과 578~581 두 블록에서 따로 설정됩니다. 분기 조건은 **확인 필요**입니다.

## 2. 공통코드 분기
| 호출 | code | 테이블 |
|---|---|---|
| `biz:CommonData.CommonDataList` | LookupCommon | UP_FX_GetCommonDataList → SCM_ADM_LOOKUP_MASTER, SCM_ADM_LOOKUP_MASTER_DETAIL (lookup 코드값은 **확인 필요**) |
| `biz:CommonData.YesOrNo` | YesOrNo | 묶음에 참조 테이블 없음(**확인 필요**) |
| `DM0003_GET_BUCKET_TYPE_CODE` | — | SCM_ADM_LOOKUP_MASTER_DETAIL |

## 3. FoxQuery 미등록·직접 호출 SP
- 활성 엔드포인트 4개 SP는 모두 **MATCH**(FoxQuery 등록 확인)입니다. 미등록이나 직접 호출은 없습니다.
- `PR_SCM_SYS_LOG_BATCH`는 화면이 직접 부르지 않습니다. SAVE SP 내부의 EXEC 체인으로만 호출됩니다.
- 주석 처리됨: `SCP.SCP0019_GET_WORKING_TIME`(456). 전환 대상이 아닙니다.

## 4. Oracle 전환 시 확인 포인트 (추출 사실 기반)
| # | 대상 SP | 사실 | 전환 포인트 |
|---|---|---|---|
| 1 | SCP0096_GET_SHIPMENT_WORKING_DAY_OSP | `REF:STRING_SPLIT` | MSSQL 전용 함수(금지 키워드 ⑩)입니다. Oracle 분할 방식으로 바꿔야 합니다. 구분자와 입력 파라미터(Plant Site 다중값 추정)는 원문 확인 필요 |
| 2 | SCP0096_GET_SHIPMENT_WORKING_DAY_OSP | `INSERT:#TBLDYNAMICPIVOT_SCP0096` | 로컬 임시 테이블입니다. GTT를 쓴다면 호출 시작 시 비우는 처리가 필요합니다(세션 상태 잔존 방지) |
| 3 | SCP0096_GET_SHIPMENT_WORKING_DAY_OSP | `DYNAMIC@...` | 동적 SQL 피벗입니다. 컬럼 이름 규칙(D_/W_/M_/B_ 접두어, 날짜 기반)이 FE 헤더(SCP0009 결과 COLUMN_NAME)와 같아야 합니다 |
| 4 | SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP | MERGE 2건 | MSSQL MERGE 문법(세미콜론, OUTPUT 등)을 Oracle MERGE로 바꿔야 합니다. 원문 확인 필요 |
| 5 | SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP | EXEC:PR_SCM_SYS_LOG_BATCH | 로그 프로시저의 Oracle 대응 객체가 있는지 확인해야 합니다 |
| 6 | SCP0009_GET_SHEET_CALENDAR_3SPAN | SCM_SYS_CALENDAR_M | 3단 헤더 결과 컬럼(COLUMN_NAME, COLUMN_LABEL_NAME, DAY_CODE, LARGE/SMALL_CLASS_LABEL_NAME)의 이름과 순서를 유지해야 합니다(GetSpdTitle·InitSpreadDateColumn 소비). 다른 화면(SCP0009)과 함께 쓰는 SP인지 확인해야 합니다 |
| 7 | DM0003_GET_BUCKET_TYPE_CODE | SCM_ADM_LOOKUP_MASTER_DETAIL | DM 도메인 공용 SP 여부를 확인해야 합니다. 이 화면에서 쓰는 소비 컨트롤이 확인 필요입니다 |

### 4-1. 난이도 근거
- 높은 쪽 요인(GET SP): 임시 테이블, 동적 SQL, STRING_SPLIT 세 가지가 함께 있고, 참조 테이블이 5개입니다.
- 보통 요인(SAVE SP): MERGE 2건과 로그 EXEC 체인이 있습니다.
- 낮은 쪽 요인(DM0003, SCP0009): 단일 SELECT 1테이블입니다.
- SP 본문 줄 수와 실행 결과는 묶음에 없습니다. 정량 난이도는 **미측정**입니다.
