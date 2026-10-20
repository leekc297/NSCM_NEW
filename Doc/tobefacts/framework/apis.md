# apis (9)

사용 수 내림차순. **신규 화면은 여기 있는 것만 쓴다** — 없으면 사전(map_control.csv) 보완 제안이 먼저(룰 23).

## foundation

| 이름 | import | 사용 | As-is 대응 | 설명 |
|---|---|---|---|---|
| **EditTracker** | `@foundation/utils` | 239 |  | TODO: binding 속성 fallback 고려..? - binding 속성 없는 column 없을듯 - 강민재 |
| **CustomMergeManager** | `@foundation/utils` | 14 |  |  |
| **ColumnInsertMergeManager** | `@foundation/utils` | 2 |  | 지정한 컬럼(binding)만은 Insert 행(CRUD_TYPE='I')도 계속 병합한다. SYS0017/SCM0007 메시지 설정 탭처럼 Category 가 항상 같은 조회 컨텍스트로 고정되는 화면에서는 F8 로 새 행을 추가해도 Category  |
| **GridUtils** | `@foundation/utils` | 123 |  |  |
| **GridAction** | `@foundation/utils` | 89 |  |  |
| **DynamicColumnManager** | `@foundation/utils` | 0 |  |  |
| **idbPersister** | `@foundation/lib` | 0 |  |  |

## master-common

| 이름 | import | 사용 | As-is 대응 | 설명 |
|---|---|---|---|---|
| **REQUEST_CHK_COLUMN** | `features/master/src/components` | 0 |  | Mail Req(REQUEST_CHK) 체크박스 — AS-IS InitSpread(cs L538)는 이 컬럼을 동적 월 컬럼 "뒤"(맨 끝)에 // 둔다. DataGrid 는 [정적..., 동적...] 순서로 렌더하므로, 정적(buildCapaNewM |
| **REQUIRED_FIELD_CHECKS_LABEL** | `features/master/src/components` | 0 |  | Save/Request 시 전송(AS-IS SaveData L1153-1168 payload 필드명 그대로, ^-delim 은 // utils/capaNewModelPopup.saveRequest.ts 가 조립). |
