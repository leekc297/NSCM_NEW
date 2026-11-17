# SSP0020 Oracle 전환 분석

## 1. 호출 SP 인벤토리

| SP | 호출 엔드포인트 | 용도(호출 위치 기준) | 참조 테이블/객체 | EXEC 체인 |
|---|---|---|---|---|
| `SSP0020_GET_DELEGATE` | SSP.SSP0020_GET_DELEGATE | 조회 (FindData_Main:268) | 동적 SQL(DYNAMIC@SSP0020_GET_DELEGATE). 참조 테이블은 정적 추출 불가 — **확인 필요** | 없음 |
| `SSP0020_SAVE_DELEGATE` | SSP.SSP0020_SAVE_DELEGATE | 위임 저장 (SaveData:507) | INSERT:SSP_MST_DELEGATE, INSERT:SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL | → PR_SCM_SYS_LOG_BATCH_CALL_TRAN |
| `SSP0020_SAVE_UNSET` | SSP.SSP0020_SAVE_UNSET | 위임 해제 (UnSet:657, 715) | UPDATE:SSP_MST_DELEGATE, INSERT:SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL | → PR_SCM_SYS_LOG_BATCH_CALL_TRAN |
| `UP_FX_GetSSPUserUseInfoList` | SSP.UP_FX_GetSSPUserUseInfoList | 사용자 조회 (UserName_Search:781) | SELECT:SCM_MST_SSO_DEPT_INFO, TB_FX_GROUPINFO, TB_FX_USERGROUPINFO, TB_FX_USER | 없음 |

### 1-1. 결과 컬럼 사용 (화면 측)
- `SSP0020_GET_DELEGATE`: 결과 셋 2개(Tables[0] → Delegate, Tables[1] → Delegated List). 시트 메타 컬럼은 CHK, DIVISION_ID, DELEGATEE/DELEGATOR, FROM_DATE, TO_DATE, VALID, LAST_UPDATED_BY, LAST_UPDATE_DATE. Validation_Check는 USER_ID, DELEGATEE_ID도 읽는다.
- `UP_FX_GetSSPUserUseInfoList`: UserID, UserName, UserName_E.

## 2. 공통코드 분기
- Fact Pack에 `code=X → 테이블` 형태의 공통코드 분기는 없다.
- Division 목록(clbDivision)은 `dtMyDivision`(UserInfoContext.Current.NowGroupID 기반)의 CODE/NAME으로 구성된다. dtMyDivision을 채우는 원천 SP/쿼리는 Fact Pack에 없어 **확인 필요**.

## 3. FoxQuery 미등록 / 직접 호출 SP
- 엔드포인트 4개 모두 `MATCH`(FoxQuery 키와 SP가 대응됨). 미등록·직접 호출 SP는 없다.
- 주석 처리된 호출: 0건.

## 4. 사용 테이블 요약

| 테이블 | 작업 | SP |
|---|---|---|
| SSP_MST_DELEGATE | INSERT | SSP0020_SAVE_DELEGATE |
| SSP_MST_DELEGATE | UPDATE | SSP0020_SAVE_UNSET |
| SCM_SYS_LOG_BATCH | INSERT | SSP0020_SAVE_DELEGATE, SSP0020_SAVE_UNSET |
| SCM_MST_SSO_DEPT_INFO, TB_FX_GROUPINFO, TB_FX_USERGROUPINFO, TB_FX_USER | SELECT | UP_FX_GetSSPUserUseInfoList |
| SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL | REF(함수/객체 참조) | SSP0020_SAVE_DELEGATE, SSP0020_SAVE_UNSET |

## 5. Oracle 전환 시 확인 포인트

1. **동적 SQL**: `SSP0020_GET_DELEGATE`는 DYNAMIC 표기가 있다. 원문 SQL 문자열 안의 MSSQL 구문(GETDATE/ISNULL/CONVERT 등)과 참조 테이블은 정적 추출로 확인되지 않았다. 원문을 열어 전수 확인해야 한다.
2. **결과 셋 2개 반환**: 화면이 Tables[0]/Tables[1]을 사용하므로, Oracle에서는 SYS_REFCURSOR 2개(또는 조회 2개로 분리)로 구현해야 한다.
3. **배열 분할 객체**: `SCM_ARR_SPL_CNT`, `SCM_ARR_SPL_VAL` 참조 → 구분자 문자열 파라미터(다건 Division 등)를 분할하는 로직이다. Oracle의 대응 함수/객체가 있는지 확인해야 한다.
4. **로그 체인**: `PR_SCM_SYS_LOG_BATCH_CALL_TRAN` → `SCM_SYS_LOG_BATCH` INSERT. 트랜잭션 경계(로그 커밋 분리 여부)를 확인해야 한다.
5. **UnSet 이중 호출**: `SSP0020_SAVE_UNSET`의 호출 지점이 2곳(657, 715)이다. 파라미터 차이를 확인해야 한다.
6. **공통 사용자 SP**: `UP_FX_GetSSPUserUseInfoList`는 프레임워크(TB_FX_*) 테이블을 조회한다. TO-BE 공통 사용자 조회 API와 중복되는지 확인해야 한다.
7. **파라미터 시그니처**: 4개 SP 모두 입력 파라미터 목록이 Fact Pack에 없어 **확인 필요**.

### 난이도 (사실 근거만)
| SP | 근거 | 판단 |
|---|---|---|
| SSP0020_GET_DELEGATE | 동적 SQL + 결과 셋 2개 | 원문 확인 전까지 상대적으로 높음 |
| SSP0020_SAVE_DELEGATE | 배열 분할 REF + 로그 EXEC 체인 + INSERT 1 테이블 | 중간 |
| SSP0020_SAVE_UNSET | 배열 분할 REF + 로그 EXEC 체인 + UPDATE 1 테이블 | 중간 |
| UP_FX_GetSSPUserUseInfoList | SELECT 4 테이블, EXEC 체인 없음 | 낮음 (공통 처리 여부에 따름) |
