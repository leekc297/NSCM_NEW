# SCP0005 Oracle 전환 분석

## 1. 호출 SP 인벤토리

| SP | 호출 위치 | 유형 | 참조 테이블 | 참조 함수/REF | EXEC 체인 |
|---|---|---|---|---|---|
| SCP0005_GET_DISTRIBUTION_ROUTE | M FindDataMain:424 | 조회 | SCM_MST_CITY, SCP_MST_DISTRIBUTION_ROUTE, SCM_ADM_LOOKUP_MASTER_DETAIL (SELECT) | FN_GET_LOOKUP_CODE_DESC, STRING_SPLIT | — |
| SCP0005_GET_DISTRIBUTION_ROUTEID | M FindDataReceive:499 | 조회 | SCM_MST_CITY, SCP_MST_DISTRIBUTION_ROUTE, SCM_ADM_LOOKUP_MASTER_DETAIL (SELECT) | FN_GET_LOOKUP_CODE_DESC | — |
| SCP0005_SAVE_DISTRIBUTION_ROUTE | M SaveData:752 | 저장 | SCP_MST_DISTRIBUTION_ROUTE (UPDATE/INSERT/DELETE/SELECT), SCM_SYS_LOG_BATCH (INSERT), SCP_MST_DISTRIBUTION_ROUTE_H (INSERT) | SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL | EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN, EXEC PR_SCP_MST_DISTRIBUTION_ROUTE_HIST |
| SCP0005_GET_COUNTRY_CITY | M GetData_Country:916 | 조회 | SCM_MST_CITY (SELECT) | — | — |
| SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID | P FindData:171 | 조회(이력) | SCM_MST_CITY, SCP_MST_DISTRIBUTION_ROUTE_H, SCM_ADM_LOOKUP_MASTER_DETAIL (SELECT) | FN_GET_LOOKUP_CODE_DESC | — |

5개 SP 모두 FoxQuery 매칭 상태가 `MATCH` 입니다(`SCP.` 쿼리 ID 등록 확인).

### 1-1. EXEC 전이 체인 (SAVE)

```
SCP0005_SAVE_DISTRIBUTION_ROUTE
 ├─ REF  SCM_ARR_SPL_CNT / SCM_ARR_SPL_VAL       (배열 문자열 분해)
 ├─ DML  SCP_MST_DISTRIBUTION_ROUTE  UPDATE / INSERT / DELETE / SELECT
 ├─ EXEC PR_SCP_MST_DISTRIBUTION_ROUTE_HIST
 │        └─ (전이) INSERT SCP_MST_DISTRIBUTION_ROUTE_H
 └─ EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN
          └─ (전이) INSERT SCM_SYS_LOG_BATCH
```

> 전이 표시(└─)의 소속은 Fact Pack 의 objects 목록이 SP 단위로 평탄화되어 있어 객체명으로 대응시킨 것입니다. 실제로 어느 하위 프로시저가 INSERT 하는지는 원문에서 **확인 필요**입니다.
> 저장 결과는 화면에서 `dtErr.Rows[0]["ERR_MESSAGE"]`(SaveData:871)로 읽습니다. 따라서 오류 결과셋(ERR_MESSAGE 컬럼)을 반환하는 계약을 Oracle 쪽에서도 유지해야 합니다.

## 2. 공통코드 분기 (biz:CommonData)

| 호출 | code | 처리 SP | 참조 테이블 | 호출 위치 |
|---|---|---|---|---|
| `biz:CommonData.CommonDataList` | COUNTRY_MST | UP_FX_GetCommonDataList | SCM_MST_COUNTRY | dtFromCountry:44, dtToCountry:46 |
| `biz:CommonData.CommonDataList` | LookupCommon | UP_FX_GetCommonDataList | SCM_ADM_LOOKUP_MASTER, SCM_ADM_LOOKUP_MASTER_DETAIL | dtTransMode:49 |
| `biz:CommonData.CommonDataList` | FromSiteByDivision | UP_FX_GetCommonDataList / UP_FX_GetCommonDataList_SCP | SCM_MST_SITE, TB_FX_USERGROUPAUTHEXTENTION (+REF STRING_SPLIT) | GetFromSitebyDivision:1187 |
| `biz:CommonData.CommonDataList` | ToSiteByDivision | UP_FX_GetCommonDataList / UP_FX_GetCommonDataList_SCP | SCM_MST_SITE, TB_FX_USERGROUPAUTHEXTENTION (+REF STRING_SPLIT) | GetToSitebyDivision:1195 |
| `biz:CommonData.CommonDataList` | BodType | UP_FX_GetCommonDataList | SCM_ADM_LOOKUP_MASTER_DETAIL | GetBodType:1207 |
| `biz:CommonData.CommonDataList` | TransportMode | UP_FX_GetCommonDataList | SCM_ADM_LOOKUP_MASTER_DETAIL | GetTransMode:1217 |
| `biz:CommonData.YesOrNo` | — | (Data.CallBizData) | DB 보강 없음 — **확인 필요** | dtYesOrNo:48, dtValidYN:51 |

- LookupCommon 에 넘기는 LOOKUP 마스터 코드값(예: Trans Mode 그룹 코드)은 Fact Pack 에 없어 **확인 필요**입니다.
- FromSiteByDivision / ToSiteByDivision 와 GetBodType / GetTransMode 는 호출자가 확인되지 않았습니다(진입점 미연결). 전환 대상에 넣을지는 원문 확인 후 결정해야 합니다.

## 3. FoxQuery 미등록 / 직접 호출 SP

| 구분 | 건수 | 내용 |
|---|---:|---|
| FoxQuery 미등록 SP | 0 | 5개 SP 모두 MATCH |
| 직접 SQL / 직접 호출 | 0 | Fact Pack 에 없음 |
| 주석 처리됨 호출 | 0 | commented_calls 0건 |
| Biz 공통 호출 | 9 | biz:CommonData.CommonDataList 7건, biz:CommonData.YesOrNo 2건 |

## 4. Oracle 전환 시 확인 포인트

| # | 포인트 | 근거 | 대상 |
|---:|---|---|---|
| 1 | `STRING_SPLIT`(MSSQL 전용) 치환 필요 | REF:STRING_SPLIT | SCP0005_GET_DISTRIBUTION_ROUTE, UP_FX_GetCommonDataList(_SCP) |
| 2 | `FN_GET_LOOKUP_CODE_DESC` 함수의 Oracle 존재/동등성 | REF | GET_DISTRIBUTION_ROUTE / ROUTEID / HISTORY_ROUTEID |
| 3 | `SCM_ARR_SPL_CNT` / `SCM_ARR_SPL_VAL` 배열 분해 함수의 Oracle 구현 | REF | SAVE_DISTRIBUTION_ROUTE |
| 4 | 하위 프로시저 `PR_SCP_MST_DISTRIBUTION_ROUTE_HIST`, `PR_SCM_SYS_LOG_BATCH_CALL_TRAN` 이행 여부 | EXEC 체인 | SAVE_DISTRIBUTION_ROUTE |
| 5 | 저장 SP 의 트랜잭션 경계(본 테이블 DML + 이력 INSERT + 로그 INSERT) | 한 SP 안 DML 3종 + 하위 EXEC 2건 | SAVE_DISTRIBUTION_ROUTE |
| 6 | 오류 반환 결과셋(`ERR_MESSAGE`) 형식 | SaveData:871 | SAVE_DISTRIBUTION_ROUTE |
| 7 | 메인 조회 SP 2종(ROUTE / ROUTEID)의 출력 컬럼이 같은 시트(39컬럼 메타)와 맞는지 | 둘 다 같은 spdMain 에 SetSpreadColumn | GET_DISTRIBUTION_ROUTE, GET_DISTRIBUTION_ROUTEID |
| 8 | 이력 SP 출력 컬럼과 POPUP 메타 16컬럼의 일치 | grid 단계 SP 매칭 미실행 | GET_DISTRIBUTION_HISTORY_ROUTEID |
| 9 | 메타 행 이관: SCM_MST_SHEET_COLUMNS 55행(39+16), TB_FX_SearchCondition 32행, SCM_ADM_EXCEL_COLUMNS 1행, TB_FX_GroupMenuAuth 13행, TB_FX_MenuItemInfo 1행, TB_FX_ProgramInfo 1행, TB_FX_Favorite 16행 | Fact Pack 8장 | 메타 |
| 10 | SCM_ADM_DB_SCRIPT_BACKUP 20행 | 화면 ID 가 값으로 들어간 행. 내용(SP 변경 이력 여부)은 **확인 필요** | 참고 |
| 11 | 각 SP 의 파라미터 목록, 그리고 FindDataMain 의 CheckedList(CODE) 다중값을 STRING_SPLIT 으로 받는지 | GetCheckedListValue@404 + REF STRING_SPLIT | GET_DISTRIBUTION_ROUTE — 파라미터 원문 **확인 필요** |

## 5. 난이도 (사실 근거)

| SP | 근거 | 상대 난이도 |
|---|---|---|
| SCP0005_SAVE_DISTRIBUTION_ROUTE | 참조 객체 11개, DML 4종(UPDATE/INSERT/DELETE + 이력·로그 INSERT), 하위 EXEC 2건, 배열 분해 함수 2종 | 5개 중 가장 높음 |
| SCP0005_GET_DISTRIBUTION_ROUTE | 참조 6개, MSSQL 전용 STRING_SPLIT 포함 | 중간 |
| SCP0005_GET_DISTRIBUTION_ROUTEID | 참조 5개, MSSQL 전용 함수 없음 | 낮음~중간 |
| SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID | 참조 5개, MSSQL 전용 함수 없음 | 낮음~중간 |
| SCP0005_GET_COUNTRY_CITY | 참조 2개(SCM_MST_CITY 단일) | 낮음 |

> 위 순위는 Fact Pack 의 참조 객체 수와 MSSQL 전용 키워드 유무만으로 매긴 것입니다. SP 본문의 줄 수와 동적 SQL 여부는 Fact Pack 에 없어 **미측정**입니다.
