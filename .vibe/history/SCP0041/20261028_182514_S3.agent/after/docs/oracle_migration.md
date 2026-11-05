# SCP0041 Oracle 전환 분석

## 1. 호출 SP 인벤토리

| SP | 호출 엔드포인트 | 현행 도달 | 유형 | 참조 테이블 | EXEC/함수 체인 |
|---|---|---|---|---|---|
| `SCM0001_GET_LOOKUP_VALUES` | SCM.SCM0001_GET_LOOKUP_VALUES | 도달 (Form_Load) | 조회(공통) | SELECT: SCM_ADM_LOOKUP_MASTER_DETAIL | - |
| `SCP0041_GET_STOCK_OSP` | SCP.SCP0041_GET_STOCK_OSP | 도달 (FindButton) | 조회 | SELECT: SCM_DNM_STOCK_OSP, SCM_MST_SITE, SCM_MST_ITEM_SN | REF: FN_GET_ITEM_NICKNAME, STRING_SPLIT |
| `SCP0041_GET_PACK_HOLD_STOCK` | SCP.SCP0041_GET_PACK_HOLD_STOCK | 도달 (FindButton, 저장 후) | 조회 | SELECT: SCM_MST_SITE, SCM_DNM_STOCK_LOT_CONTROL, SCM_MST_ITEM_SN, SCM_MST_SSO_USER_INFO | REF: FN_GET_ITEM_NICKNAME, FN_GET_USER_NAME, STRING_SPLIT |
| `SCP0041_SAVE_PACKER_HOLD_STOCK` | SCP.SCP0041_SAVE_PACKER_HOLD_STOCK | 도달 (SaveButton) | 저장 | UPDATE: SCM_DNM_STOCK_LOT_CONTROL / INSERT: SCM_SYS_LOG_BATCH | EXEC: PR_SCM_SYS_LOG_BATCH / REF: SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL |
| `SCP0040_SAVE_CHARACTERISTIC_CAPA` | SCP.SCP0040_SAVE_CHARACTERISTIC_CAPA | **미도달** (SaveData, 진입점 없음) | 저장 | MERGE: SCP_MST_CHAR_CAPA / INSERT: SCM_SYS_LOG_BATCH, SCP_MST_CHAR_CAPA_H | EXEC: PR_SCM_SYS_LOG_BATCH_CALL_TRAN, PR_SCP_MST_CHARACTERISTIC_HIST / REF: SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL |

## 2. 공통코드 분기

| 호출 | code | 처리 | 참조 객체 |
|---|---|---|---|
| `biz:CommonData.CommonDataList` (Data.CallBizCommonData) | `PERIOD_DEFAULT` | UP_FX_GetCommonDataList 의 PERIOD_DEFAULT 분기 | SELECT: SCM_SYS_CALENDAR_M, REF: FN_MULTY_TIME |

- 결과 컬럼: FROM_VALUE, TO_VALUE (setPeriod:558–559) → 기간 기본값.

## 3. FoxQuery 미등록 / 직접 호출 SP

- 상태가 `MATCH`/`BIZ_MATCH` 가 아닌 엔드포인트(미등록·불일치)는 **0건**입니다.
- 직접 SQL 문자열 호출은 추출되지 않았습니다.
- 주석 처리된 호출: 0건.

## 4. Oracle 전환 확인 포인트

| # | 대상 | 확인 포인트 | 근거 |
|---:|---|---|---|
| 1 | `SCP0041_GET_STOCK_OSP`, `SCP0041_GET_PACK_HOLD_STOCK` | **`STRING_SPLIT`(MSSQL 전용) 참조** — Oracle 에서는 금지 키워드이므로 TO-BE 표준 분해 방식(공통 분해 함수/GTT 등)으로 바꿔야 함. 멀티선택 인자(Plant Site 등 GetCheckedListValue 결과)로 보임 | objects REF:STRING_SPLIT, GetCheckedListValue FindData_Main:639/640, FindData_Pack:712/713/718 |
| 2 | `SCP0041_SAVE_PACKER_HOLD_STOCK` | 배열 분해 함수 `SCM_ARR_SPL_CNT` / `SCM_ARR_SPL_VAL` 의 Oracle 대응 객체 존재 여부 | objects REF |
| 3 | `SCP0041_SAVE_PACKER_HOLD_STOCK` | `PR_SCM_SYS_LOG_BATCH` 하위 호출·SCM_SYS_LOG_BATCH INSERT — 트랜잭션/COMMIT 위치 | EXEC 체인 |
| 4 | `SCP0041_GET_PACK_HOLD_STOCK` | `FN_GET_USER_NAME`, `FN_GET_ITEM_NICKNAME` 이 행마다 호출되는 스칼라 함수 — Oracle 이관 여부와 성능 | REF |
| 5 | `SCP0041_GET_PACK_HOLD_STOCK` | `SCM_MST_SSO_USER_INFO` 의 Oracle 측 존재 여부와 시노님 | SELECT |
| 6 | `SCP0041_GET_STOCK_OSP` | `SCM_DNM_STOCK_OSP` Oracle 이관 여부 | SELECT |
| 7 | `SCM0001_GET_LOOKUP_VALUES` | 공통 SP — 기존 Oracle 이관본 재사용 여부. SCM_ADM_LOOKUP_MASTER_DETAIL 에 SCP0041 행 1건(+이력 8건) | dbmeta |
| 8 | `SCP0040_SAVE_CHARACTERISTIC_CAPA` | SCP0041 에서는 도달하지 않음 → SCP0041 이관 범위에서 빼도 되는지 결정 필요(SCP0040 화면 소관) | flow unreached |
| 9 | PERIOD_DEFAULT | UP_FX_GetCommonDataList 분기의 `FN_MULTY_TIME` Oracle 대응 | 코드분기 |
| 10 | 메타 | SCM_MST_SHEET_COLUMNS 29행(14+15), SCM_ADM_EXCEL_COLUMNS 1행, TB_FX_SearchCondition 34행의 TO-BE 메타 이관 | dbmeta |

## 5. 난이도 (사실 근거)

| SP | 근거 사실 | 판단 |
|---|---|---|
| `SCM0001_GET_LOOKUP_VALUES` | 단일 SELECT, 공통 SP | 낮음 |
| `SCP0041_GET_STOCK_OSP` | SELECT 3테이블 + STRING_SPLIT + 함수 1 | 중 (STRING_SPLIT 치환 필요) |
| `SCP0041_GET_PACK_HOLD_STOCK` | SELECT 4테이블 + STRING_SPLIT + 함수 2 | 중 (STRING_SPLIT 치환, 함수 2종) |
| `SCP0041_SAVE_PACKER_HOLD_STOCK` | UPDATE 1 + INSERT 로그 + EXEC 1 + 배열 분해 함수 2 | 중 |
| `SCP0040_SAVE_CHARACTERISTIC_CAPA` | MERGE + INSERT 2 + EXEC 2 + 배열 분해 함수 2 (미도달) | 범위 결정이 먼저 필요 |

※ SP 본문 줄 수·커서·동적 SQL 여부는 Fact Pack에 없습니다 → SP 원문을 보고 **확인 필요**.
