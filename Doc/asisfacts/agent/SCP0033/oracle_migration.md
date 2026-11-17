# SCP0033 Oracle 전환 분석

## 1. 호출 SP 인벤토리

| SP | FoxQuery 키 | 호출 위치 | 참조 테이블 | EXEC 체인 |
|---|---|---|---|---|
| `SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY` | SCP.SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY | FindData_Main:258 | SELECT SCM_MST_ITEM_SN, SCP_MST_SHIPMENT_SEMI_DEPT_DAY, SCM_MST_DIVISION | REF FN_GET_DIVISION_DIV, REF STRING_SPLIT |
| `SCP0033_SAVE_SHIPMENT_SEMI_DEPT_DAY` | SCP.SCP0033_SAVE_SHIPMENT_SEMI_DEPT_DAY | SaveData_Main:380 | UPDATE/INSERT SCP_MST_SHIPMENT_SEMI_DEPT_DAY, INSERT SCM_SYS_LOG_BATCH, INSERT SCP_MST_SHIPMENT_SEMI_DEPT_DAY_H | EXEC PR_SCM_SYS_LOG_BATCH, EXEC PR_SCP_MST_SHIPMENT_SEMI_DEPT_DAY_HIST, REF SCM_ARR_SPL_CNT, REF SCM_ARR_SPL_VAL |

## 2. 공통코드 분기

| Biz 엔드포인트 | code | 처리 SP | 테이블 |
|---|---|---|---|
| biz:CommonData.CommonDataList | LookupCommon | UP_FX_GetCommonDataList | SCM_ADM_LOOKUP_MASTER, SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.YesOrNo | - | 확인 필요 | 확인 필요 |

- 두 엔드포인트 모두 필드 초기화(43·44줄) 지점이고, 진입점은 연결되지 않았습니다. LookupCommon의 Lookup 코드값은 확인 필요입니다.

## 3. FoxQuery 미등록 / 직접 호출 SP

- 없음. 두 SP 모두 상태가 MATCH(FoxQuery 등록)입니다.
- 주석 처리된 호출은 0건입니다.

## 4. Oracle 전환 시 확인 포인트

| # | 항목 | 근거 | 확인 내용 |
|---|---|---|---|
| 1 | `STRING_SPLIT` | GET SP의 REF | MSSQL 전용 함수이므로 Oracle 대체 구현이 필요합니다. 분리 대상 파라미터(Division 등)는 확인 필요 |
| 2 | `FN_GET_DIVISION_DIV` | GET SP의 REF | Oracle 측에 함수가 있는지, 시그니처가 같은지 확인 |
| 3 | `SCM_ARR_SPL_CNT`, `SCM_ARR_SPL_VAL` | SAVE SP의 REF | 배열(구분자 문자열) 분해 함수의 Oracle 대응 객체 확인 |
| 4 | `PR_SCP_MST_SHIPMENT_SEMI_DEPT_DAY_HIST` → `SCP_MST_SHIPMENT_SEMI_DEPT_DAY_H` | SAVE SP의 EXEC/INSERT | 이력 SP와 이력 테이블 전환, 호출 순서 보존 |
| 5 | `PR_SCM_SYS_LOG_BATCH` → `SCM_SYS_LOG_BATCH` | SAVE SP의 EXEC/INSERT | 공통 로그 SP의 Oracle 대응 확인 |
| 6 | UPDATE + INSERT on `SCP_MST_SHIPMENT_SEMI_DEPT_DAY` | SAVE SP | 신규/수정 분기 조건(키 구성)은 확인 필요. MERGE 전환 여부는 SP 원문을 보고 판단 |
| 7 | 저장 후 재조회 | SaveButton > SaveData_Main > FindData_Main | TO-BE에서도 저장 뒤 재조회 흐름 유지 |

- 난이도: Fact Pack 기준으로 SP 2개와 MSSQL 전용 함수 참조 1종(STRING_SPLIT)이 확인됩니다. SP 본문(파라미터·로직 길이)이 Fact Pack에 없어 정량 난이도는 확인 필요입니다.
