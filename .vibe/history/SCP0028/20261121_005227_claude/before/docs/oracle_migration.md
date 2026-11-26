# SCP0028 Oracle 전환 분석

## 1. 호출 SP 인벤토리

| SP | FoxQuery 키 | 호출 지점 | 참조 테이블/객체 | EXEC 체인 |
|---|---|---|---|---|
| `SCP0028_GET_SHIPMENT_LOT_SIZE` | `SCP.SCP0028_GET_SHIPMENT_LOT_SIZE` | FindData:349 (조회, 저장·삭제 후 재조회) | SCP_MST_SHIPMENT_LOT_SIZE, SCM_MST_FINAL_ITEM_V, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_SITE / 함수 FN_GET_SCM_SITE_DESCRIPTION, STRING_SPLIT | 없음 |
| `SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT` | `SCP.SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT` | FindInput:417 (Input 버튼) | SCM_MST_FINAL_ITEM_V, SCM_ADM_LOOKUP_MASTER_DETAIL, SCP_MST_BOD, SCM_MST_SITE, SCM_SYS_LOG_BATCH(INSERT) / 임시테이블 #TBLDYNAMIC_SCP0028IN_DIV·OPER·FROM·TO·ITEM·INPUT / 함수 UF_FX_STRING_SPLIT, FN_GET_LOOKUP_CODE_DESC, FN_GET_SCM_SITE_DESCRIPTION | PR_SCM_SYS_LOG_BATCH_CALL_TRAN |
| `SCP0028_SAVE_SHIPMENT_LOT_SIZE` | `SCP.SCP0028_SAVE_SHIPMENT_LOT_SIZE` | SaveData:659 (저장), FindDelete:511 (삭제) | SCP_MST_SHIPMENT_LOT_SIZE(MERGE, DELETE), SCP_MST_SHIPMENT_LOT_SIZE_H(INSERT), SCM_SYS_LOG_BATCH(INSERT) / SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL | PR_SCM_SYS_LOG_BATCH_CALL_TRAN, PR_SCP_MST_SHIPMENT_LOT_SIZE_HIST |

## 2. 공통코드 분기 (code=X → 테이블)

| 엔드포인트 | code | 분기 SP | 테이블 | 비고 |
|---|---|---|---|---|
| `biz:CommonData.CommonDataList` | FromSiteByDivision | UP_FX_GetCommonDataList, UP_FX_GetCommonDataList_SCP | SCM_MST_SITE, TB_FX_USERGROUPAUTHEXTENTION (+STRING_SPLIT) | `NowGroupID` 사용 (SetChangedControl:166) |
| `biz:CommonData.CommonDataList` | ToSiteByDivision | UP_FX_GetCommonDataList, UP_FX_GetCommonDataList_SCP | SCM_MST_SITE, TB_FX_USERGROUPAUTHEXTENTION (+STRING_SPLIT) | `NowGroupID` 사용 (SetChangedControl:169) |
| `biz:CommonData.CommonDataList` | LookupCommon | UP_FX_GetCommonDataList | SCM_ADM_LOOKUP_MASTER, SCM_ADM_LOOKUP_MASTER_DETAIL | 조회할 LOOKUP 유형 값은 **확인 필요** |
| `biz:CommonData.YesOrNo` | – | – | DB 보강 없음 | `Data.CallBizData` 경로 |

- `UP_FX_GetCommonDataList`와 `_SCP` 중 실제로 어느 쪽이 실행되는지 정하는 조건은 Fact Pack에 없어 **확인 필요**입니다.

## 3. FoxQuery 미등록 / 직접 호출 SP

- FoxQuery 엔드포인트 3개는 모두 `MATCH` 상태입니다. 미등록은 0건입니다.
- 직접 SQL 호출이나 미등록 SP 호출은 추출되지 않았습니다(0건).
- 주석 처리된 호출은 0건입니다.

## 4. Oracle 전환 확인 포인트 (Fact Pack 근거만)

| # | 대상 | 사실 | 확인 포인트 |
|---|---|---|---|
| 1 | SCP0028_GET_SHIPMENT_LOT_SIZE, UP_FX_GetCommonDataList(_SCP) | `REF:STRING_SPLIT` | MSSQL 전용 함수(CLAUDE.md 금지 ⑩)이므로 Oracle 분해 방식으로 바꿔야 함 |
| 2 | SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT | `#TBLDYNAMIC_SCP0028IN_*` 임시테이블 6종 INSERT/SELECT | Oracle GTT 또는 WITH절 전환. GTT를 쓰면 호출 시작 시 비우는지 확인(세션 재사용 시 잔존 위험) |
| 3 | SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT | `REF:UF_FX_STRING_SPLIT` | 사용자 함수의 Oracle 대응 객체가 있는지 확인 |
| 4 | SCP0028_SAVE_SHIPMENT_LOT_SIZE | `REF:SCM_ARR_SPL_CNT`, `SCM_ARR_SPL_VAL` | 배열 분해 함수의 Oracle 대응 객체가 있는지 확인 |
| 5 | SCP0028_SAVE_SHIPMENT_LOT_SIZE | `MERGE:SCP_MST_SHIPMENT_LOT_SIZE` + `DELETE` | Oracle MERGE 문법(ON 키, DELETE 절)으로 전환. 저장과 삭제가 한 SP에서 어떻게 분기하는지 **확인 필요** |
| 6 | SCP0028_SAVE_SHIPMENT_LOT_SIZE | `EXEC:PR_SCP_MST_SHIPMENT_LOT_SIZE_HIST` → `INSERT:SCP_MST_SHIPMENT_LOT_SIZE_H` | 이력 SP의 Oracle 존재 여부와 호출 순서(변경 전/후) |
| 7 | INPUT / SAVE SP | `EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN`, `INSERT:SCM_SYS_LOG_BATCH` | 로그 SP 대응. 트랜잭션 경계(자율 트랜잭션 여부) **확인 필요** |
| 8 | GET / INPUT SP | `FN_GET_SCM_SITE_DESCRIPTION`, `FN_GET_LOOKUP_CODE_DESC` | Oracle 함수가 있는지 확인 |
| 9 | 시노님/권한 | SCM_MST_FINAL_ITEM_V(뷰), SCP_MST_BOD 등 | 스키마 시노님 확인 |

## 5. 난이도 (사실 근거)

| SP | 근거 지표 | 판정 |
|---|---|---|
| SCP0028_GET_SHIPMENT_LOT_SIZE | 테이블 4개 + 함수 1개 + STRING_SPLIT. EXEC 체인 없음 | 3개 중 가장 단순 |
| SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT | 임시테이블 6종, 함수 3개, 테이블 5개, EXEC 1개 | 3개 중 참조 객체가 가장 많음 |
| SCP0028_SAVE_SHIPMENT_LOT_SIZE | MERGE+DELETE, 하위 EXEC 2개, 배열 함수 2개 | 쓰기 경로이며 이력·로그 연동 |

- 줄수나 동적 SQL 여부는 Fact Pack에 없어 판정에 반영하지 않았습니다.
