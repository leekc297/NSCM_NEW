# SSP0014 Oracle 전환 분석

## 1. 호출 SP 인벤토리

| SP | 호출 지점 | 동작 | 참조 객체 | EXEC 체인 |
|---|---|---|---|---|
| `SSP0014_GET_SHIPMENT_MODEL_PIC` | FindData_Main:329 (조회 / 저장 후 재조회) | 조회 | SELECT: SCM_MST_SITE_ITEM, SCM_MST_SITE, SSP_MST_MODEL_USER, TB_FX_USER, SCM_MST_ITEM_SN / REF: FN_GET_ITEM_NICKNAME, STRING_SPLIT | 없음 |
| `SSP0014_SAVE_SHIPMENT_MODEL_PIC` | SaveData:497 | 저장 | MERGE: SSP_MST_MODEL_USER / INSERT: SCM_SYS_LOG_BATCH / REF: SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL | → `PR_SCM_SYS_LOG_BATCH` |
| `SSP0014_GET_USER_ID_CHECK` | GetUserIDChk:562 | 저장 전 사용자 ID 검사 | SELECT: TB_FX_USER, TB_FX_USERGROUPAUTHEXTENTION / REF: STRING_SPLIT | 없음 |

- 세 SP 모두 FoxQuery 키 `SSP.<SP명>` 이 등록되어 있습니다(상태 MATCH).
- 저장 대상 테이블: **SSP_MST_MODEL_USER**(MERGE). 저장 로그: SCM_SYS_LOG_BATCH(직접 INSERT + PR_SCM_SYS_LOG_BATCH EXEC).

## 2. 공통코드 분기

| 키 | 경로 | 원천 테이블 |
|---|---|---|
| `biz:CommonData.YesOrNo` | Data.Common[case Type.YesOrNo] > Data.CallBizData | Fact Pack에 없음 → 확인 필요 |
| GetSSPInnerTable (SetChangeControl:144, 149) | DataService.GetSSPInnerTable | 읽는 컬럼: CODE, COMPANY_ID, DEPT_ID, DIVISION_ID, END_CUSTOMER, LANGUAGE_CODE, NAME, PLANT_ID, SCM_SITE_ID. 어떤 code 값으로 어떤 테이블을 조회하는지는 확인 필요 |

- `code=X → 테이블` 형태의 분기 사실은 Fact Pack에 없습니다 → **확인 필요**.

## 3. FoxQuery 미등록 / 직접 호출 SP

- 미등록(NOT MATCH) 엔드포인트: 0건
- 직접 SQL 호출: 0건
- 주석 처리된 호출: 0건

## 4. Oracle 전환 확인 포인트 (Fact Pack 근거만)

| # | 대상 | 사실 | 확인 포인트 |
|---|---|---|---|
| 1 | SSP0014_GET_SHIPMENT_MODEL_PIC, SSP0014_GET_USER_ID_CHECK | `REF:STRING_SPLIT` 참조 | MSSQL `STRING_SPLIT` 은 Oracle에 없습니다. 프로젝트 금지 키워드(⑩)이므로 대체 구현이 필요합니다(REGEXP_SUBSTR/CONNECT BY, 공용 분할 함수 등. 방식은 확인 필요) |
| 2 | SSP0014_SAVE_SHIPMENT_MODEL_PIC | `REF:SCM_ARR_SPL_CNT`, `REF:SCM_ARR_SPL_VAL` | 배열 분할 함수입니다. Oracle 쪽에 같은 이름의 함수가 있는지 확인 필요 |
| 3 | SSP0014_SAVE_SHIPMENT_MODEL_PIC | `MERGE:SSP_MST_MODEL_USER` | MSSQL MERGE 문법(문장 끝 `;`, `WHEN NOT MATCHED BY SOURCE` 등)을 쓰는지 원문 확인 필요. Oracle MERGE 는 BY SOURCE 를 지원하지 않습니다 |
| 4 | SSP0014_SAVE_SHIPMENT_MODEL_PIC | `EXEC:PR_SCM_SYS_LOG_BATCH`, `INSERT:SCM_SYS_LOG_BATCH` | 로그 프로시저의 Oracle 이관 여부 확인 필요 |
| 5 | SSP0014_GET_SHIPMENT_MODEL_PIC | `REF:FN_GET_ITEM_NICKNAME` | 스칼라 함수의 Oracle 이관 여부 확인 필요 |
| 6 | SSP0014_GET_USER_ID_CHECK | `SELECT:TB_FX_USERGROUPAUTHEXTENTION` | 프레임워크 권한 테이블의 TO-BE 대응 테이블 확인 필요 |
| 7 | 공통 | TB_FX_USER 참조 (조회·검사 SP 2개) | TO-BE 사용자 테이블 매핑 확인 필요 |

### 난이도
- 사실 근거: SP 3개, EXEC 체인 1단계(PR_SCM_SYS_LOG_BATCH), MSSQL 전용 함수 STRING_SPLIT 2개 SP에서 참조, MERGE 1건.
- SP 원문 줄 수·동적 SQL 여부·임시테이블 사용은 Fact Pack에 없어 난이도 등급은 매기지 않았습니다 → **확인 필요**.
