# SCM0016 — To-Be Fact Pack 요약

- page_key: `admin/batch-log` · feature: admin · As-is Fact Pack 없음(화면ID 미대응)
- 파일 10 · 엔드포인트 호출 5 (미해결 0, 주석 속 1) · 이벤트 7 · 컴포넌트 사용 23 · 하드코딩 컬럼 30 · 메시지 1
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 30건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/admin/src/pages/batch-log/batch-log.constants.ts | constants | 80 |
| features/admin/src/pages/batch-log/BatchLog.module.scss | style | 98 |
| features/admin/src/pages/batch-log/BatchLog.tsx | page | 168 |
| features/admin/src/pages/batch-log/components/BatchHistGrid.tsx | component | 44 |
| features/admin/src/pages/batch-log/components/BatchLogForm.tsx | component | 68 |
| features/admin/src/pages/batch-log/components/BatchLogGrid.tsx | component | 63 |
| features/admin/src/pages/batch-log/components/BatchStepGrid.tsx | component | 42 |
| features/admin/src/pages/batch-log/index.ts | index | 2 |
| features/admin/src/pages/batch-log/useBatchLogStore.ts | store | 130 |
| features/admin/src/pages/batch-log/__asis-mapping__.md | mapping | 67 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| SCM0016/batchLog//call-proc | hook | 1 | Y | BatchLog.tsx:43 |
| SCM0016/stepInfo//call-proc | hook | 1 | Y | BatchLog.tsx:51 |
| SCM0016/batchLogHist//call-proc | hook | 1 | Y | BatchLog.tsx:59 |
| (useTabLookupQueries) | hook | 1 | Y | BatchLogForm.tsx:23 |
| /admin/menu/SCM0016/column | http | 1 | Y | useBatchLogStore.ts:110 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| batchLog | runStatus | batchLog | PKG_SCM0016 |
| stepInfo | jobId | stepInfo | PKG_SCM0016 |
| batchLogHist | jobId | batchLogHist | PKG_SCM0016 |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| BatchLogForm | onSearch | setListFilter | jsx | features/admin/src/pages/batch-log/BatchLog.tsx | 108 |
| BatchLogGrid | onSelectJob | handleSelectJob | jsx | features/admin/src/pages/batch-log/BatchLog.tsx | 128 |
| DataGrid | gotFocus | handleFocus | jsx | features/admin/src/pages/batch-log/components/BatchHistGrid.tsx | 40 |
| SearchArea | onSearch | onSearch | jsx | features/admin/src/pages/batch-log/components/BatchLogForm.tsx | 30 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/admin/src/pages/batch-log/components/BatchLogForm.tsx | 57 |
| DataGrid | gotFocus | handleFocus | jsx | features/admin/src/pages/batch-log/components/BatchLogGrid.tsx | 58 |
| DataGrid | gotFocus | handleFocus | jsx | features/admin/src/pages/batch-log/components/BatchStepGrid.tsx | 38 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Panel | 4 |
| DataGrid | 3 |
| PanelGroup | 2 |
| PanelSeparator | 2 |
| TitleArea | 2 |
| MainTitle | 1 |
| BatchLogForm | 1 |
| SubTitle | 1 |
| BatchLogGrid | 1 |
| BatchStepGrid | 1 |
| BatchHistGrid | 1 |
| SearchArea | 1 |
| Grid | 1 |
| FormItem | 1 |
| CustomDropdown | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| BATCH_LOG_COLUMNS | JOB_ID | JOB_ID | 40 | false |  |  | meta-shape | features/admin/src/pages/batch-log/batch-log.constants.ts | 41 |
| BATCH_LOG_COLUMNS | JOB_NAME | JobName | 300 | true |  |  | meta-shape | features/admin/src/pages/batch-log/batch-log.constants.ts | 42 |
| BATCH_LOG_COLUMNS | JOB_DESCRIPTION | Job Description | 200 | true |  |  | meta-shape | features/admin/src/pages/batch-log/batch-log.constants.ts | 43 |
| BATCH_LOG_COLUMNS | STEP_ID | STEP_ID | 160 | false |  |  | meta-shape | features/admin/src/pages/batch-log/batch-log.constants.ts | 44 |
| BATCH_LOG_COLUMNS | STEP_NAME | Step Name | 120 | true |  |  | meta-shape | features/admin/src/pages/batch-log/batch-log.constants.ts | 45 |
| BATCH_LOG_COLUMNS | SCHEDULE_UID | SCHEDULE_UID | 160 | false |  |  | meta-shape | features/admin/src/pages/batch-log/batch-log.constants.ts | 46 |
| BATCH_LOG_COLUMNS | SCHEDULE_NAME | Schedule Name | 170 | true |  |  | meta-shape | features/admin/src/pages/batch-log/batch-log.constants.ts | 47 |
| BATCH_LOG_COLUMNS | RUN_DATE | Last Run Date | 150 | true |  |  | meta-shape | features/admin/src/pages/batch-log/batch-log.constants.ts | 48 |
| BATCH_LOG_COLUMNS | RUN_STATUS | RUN_STATUS | 80 | false |  |  | meta-shape | features/admin/src/pages/batch-log/batch-log.constants.ts | 49 |
| BATCH_LOG_COLUMNS | RUN_STATUS_NAME | Last Run Status | 80 | true |  |  | meta-shape | features/admin/src/pages/batch-log/batch-log.constants.ts | 50 |
| BATCH_LOG_COLUMNS | RUN_DURATION | Last Run Duration | 80 | true |  |  | meta-shape | features/admin/src/pages/batch-log/batch-log.constants.ts | 51 |
| BATCH_LOG_COLUMNS | RUN_STATUS_MESSAGE | Last Run Status Message | 250 | true |  |  | meta-shape | features/admin/src/pages/batch-log/batch-log.constants.ts | 52 |
| BATCH_LOG_COLUMNS | NEXT_RUN_DATE | Next Run Date | 150 | true |  |  | meta-shape | features/admin/src/pages/batch-log/batch-log.constants.ts | 53 |
| STEP_INFO_COLUMNS | JOB_ID | JOB_ID | 40 | false |  |  | meta-shape | features/admin/src/pages/batch-log/batch-log.constants.ts | 58 |
| STEP_INFO_COLUMNS | JOB_NAME | JOB_NAME | 300 | false |  |  | meta-shape | features/admin/src/pages/batch-log/batch-log.constants.ts | 59 |
| STEP_INFO_COLUMNS | STEP_UID | STEP_UID | 200 | false |  |  | meta-shape | features/admin/src/pages/batch-log/batch-log.constants.ts | 60 |
| STEP_INFO_COLUMNS | STEP_ID | STEP_ID | 160 | false |  |  | meta-shape | features/admin/src/pages/batch-log/batch-log.constants.ts | 61 |
| STEP_INFO_COLUMNS | STEP_NAME | Step Name | 120 | true |  |  | meta-shape | features/admin/src/pages/batch-log/batch-log.constants.ts | 62 |
| STEP_INFO_COLUMNS | STEP_TYPE | Step Type | 160 | false |  |  | meta-shape | features/admin/src/pages/batch-log/batch-log.constants.ts | 63 |
| STEP_INFO_COLUMNS | EXEC_COMMAND | Command | 170 | true |  |  | meta-shape | features/admin/src/pages/batch-log/batch-log.constants.ts | 64 |
| STEP_INFO_COLUMNS | ON_SUCCESS_ACTION | OnSuccessAction | 200 | true |  |  | meta-shape | features/admin/src/pages/batch-log/batch-log.constants.ts | 65 |
| STEP_INFO_COLUMNS | RETRY_ATTEMPTS | Retry Attempts | 100 | true |  |  | meta-shape | features/admin/src/pages/batch-log/batch-log.constants.ts | 66 |
| STEP_INFO_COLUMNS | RETRY_INTERVAL | Retry Interval(Minutes) | 100 | true |  |  | meta-shape | features/admin/src/pages/batch-log/batch-log.constants.ts | 67 |
| STEP_INFO_COLUMNS | ON_FAILURE_ACTION | OnFailureAction | 200 | true |  |  | meta-shape | features/admin/src/pages/batch-log/batch-log.constants.ts | 68 |
| BATCH_LOG_HIST_COLUMNS | JOB_ID | JOB_ID | 40 | false |  |  | meta-shape | features/admin/src/pages/batch-log/batch-log.constants.ts | 73 |
| BATCH_LOG_HIST_COLUMNS | RUN_DATE | RUN_DATE | 150 | true |  |  | meta-shape | features/admin/src/pages/batch-log/batch-log.constants.ts | 74 |
| BATCH_LOG_HIST_COLUMNS | RUN_STATUS | RUN_STATUS | 200 | false |  |  | meta-shape | features/admin/src/pages/batch-log/batch-log.constants.ts | 75 |
| BATCH_LOG_HIST_COLUMNS | RUN_STATUS_NAME | Run Status | 80 | true |  |  | meta-shape | features/admin/src/pages/batch-log/batch-log.constants.ts | 76 |
| BATCH_LOG_HIST_COLUMNS | RUN_DURATION | Run Duration | 80 | true |  |  | meta-shape | features/admin/src/pages/batch-log/batch-log.constants.ts | 77 |
| BATCH_LOG_HIST_COLUMNS | RUN_STATUS_MESSAGE | Run Status Message | 250 | true |  |  | meta-shape | features/admin/src/pages/batch-log/batch-log.constants.ts | 78 |

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00112 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCM0016(2)
- SP/PKG: PKG_SCM0016(2)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | layoutAppliedColumns.filter(c => c.display) 로 빌드하므로 display 가 없으면(undefined=falsy) | features/admin/src/pages/batch-log/batch-log.constants.ts | 34 |
| endpoint | admin 등록 컬럼 3시트 동적 fetch(마운트 1회). 미등록/실패는 constants fallback(tact-time 패턴). | features/admin/src/pages/batch-log/useBatchLogStore.ts | 40 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

