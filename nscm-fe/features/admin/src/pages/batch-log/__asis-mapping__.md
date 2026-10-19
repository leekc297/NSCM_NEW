# SCM0016 Batch Log — AS-IS ↔ To-Be 매핑 매트릭스

AS-IS 정본: `GSCM/06.UIL/GSCM.SCM.Master.UIL/SCM0016_BatchLog.cs`(386L) + `.Designer.cs`(432L).
설계 입력: `.atlas/gscm-design/SCM0016/design/00~03` + `06_pkg_scm0016.sql`(§7 확정본).
성격: 조회 전용(read-only) 3그리드 + master→detail. 저장/편집 없음.

## 1. 컨트롤 / 레이아웃 (design 01_layout)

| AS-IS 노드 | AS-IS 근거 | To-Be | 상태 |
|---|---|---|---|
| Form SCM0016_BatchLog | Designer L379~380 | `BatchLog.tsx` | 이식 |
| usrConditionPanel1 (HidePanel) | Designer L91~99 | `<SearchArea>` + MainTitle openSearchArea 토글 | 이식 |
| clbRunStatus (UsrCheckedList, single, ALL_VIEW) | Designer L113~150, cs L43/L133 | `BatchLogForm` CustomDropdown(single, allOption) | 이식 |
| splitContainer1 (Horizontal=상/하) | Designer L237~253 | `PanelGroup orientation='vertical'` (상 Main / 하 Step·Hist) | 이식 |
| splitContainer2 (Vertical=좌/우) | Designer L255~270 | `PanelGroup orientation='horizontal'` (좌 Step / 우 Hist) | 이식 |
| spdMain / spdStep / spdHist (FpSpread) | Designer L186/272/323 | `BatchLogGrid` / `BatchStepGrid` / `BatchHistGrid` (DataGrid) | 이식 |
| usrLayoutControl1 / layoutControlGroup1 (orphan) | Designer L73~89 | 이관 제외(dead — Controls.Add 안 됨) | 제외(근거명시) |

## 2. 이벤트 (design 00_checklist §2-b)

| # | AS-IS 핸들러 | 근거 | To-Be | 상태 |
|---|---|---|---|---|
| E1 | Form_Load(InitForm→…→InitEvent) | cs L104/L107~114 | mount: 자동조회 없음. Run Status lookup 로드(useTabLookupQueries). filters 초기 undefined → 3그리드 빈상태 | 이식 |
| E2 | spdMain_CellDoubleClick | cs L142/L254~271 | `BatchLogGrid.handleDblClick` → 행 JOB_ID → `setDetailFilter(jobId)` → Step/Hist enabled 재조회 | 이식 |
| E3 | FindButton→FindData | cs L237/L273 | `hotkeyConfig.search = setListFilter` → filters.batchLog 참조 교체 → useTabProcQuery 자동발사(refetch 직접호출 금지) | 이식 |
| E4 | EditButton (MSG00109 후 return) | cs L242~247 | 편집 UI 미제공 — 3그리드 `isReadOnly`. Edit/Save/Insert/Delete hotkey=false | 이식(트리거 소멸) |

## 3. gridSignals / white-list (design 03 §3)

| # | AS-IS | 근거 | To-Be | 상태 |
|---|---|---|---|---|
| G1~G3 | LockColumn 전 컬럼 잠금 ×3 | cs L298/L332/L368 | 3그리드 `isReadOnly`(전 컬럼 읽기전용) | 이식 |
| R4 | master→detail 재조회 | cs L263~267 | E2 참조. Step/Hist 는 run_status 미전달(dead read 재현 = 미이식이 정합) | 이식 |
| R6 | VisibleAlternatingRow | cs L304 | DataGrid 기본 교대배경 | 공통 흡수 |
| (없음) | SetValue/LockRange/병합/조건부포맷 | — | 생성 안 함(과잉구현 방지) | 부재확정 |

## 4. SP / 데이터 계약 (design 03 §7 확정본)

| 그리드 | SHEET/응답키 | proc (PKG_SCM0016) | IN | AS-IS SP | 상태 |
|---|---|---|---|---|---|
| Main | batchLog | P_SCM0016_GET_BATCH_LOG | runStatus(+sesUserId/mnuId BE주입) | SCM.SCM0016_GET_BATCH_LOG(p_run_status) | 이식 |
| Step | stepInfo | P_SCM0016_GET_BATCH_STEP_INFO | jobId | SCM.SCM0016_GET_BATCH_STEP_INFO(p_job_id) | 이식 |
| Hist | batchLogHist | P_SCM0016_GET_BATCH_LOG_HIST | jobId | SCM.SCM0016_GET_BATCH_LOG_HIST(p_job_id) | 이식 |

데이터원: AS-IS msdb 시스템뷰 → TO-BE Oracle DBMS_SCHEDULER 뷰(사용자 확정 2026-09-10). 컬럼 alias = design 03 §1-a/b/c.

## 5. 컬럼셋 (design 03 §1 — FE 정의, SCM_MST_SHEET_COLUMNS 미등재)

| 그리드 | 바인딩 컬럼 수 | hidden | To-Be 상수 |
|---|---|---|---|
| spdMain | 13 | JOB_ID/STEP_ID/SCHEDULE_UID/RUN_STATUS (4), Freeze≤SCHEDULE_NAME | `BATCH_LOG_COLUMNS` |
| spdStep | 11 | JOB_ID/JOB_NAME/STEP_UID/STEP_ID/STEP_TYPE (5) | `STEP_INFO_COLUMNS` |
| spdHist | 6 | JOB_ID/RUN_STATUS (2), 최근 100건(PKG) | `BATCH_LOG_HIST_COLUMNS` |

헤더 라벨 = AS-IS InitSpread(cs L176~230) 영문 하드코딩 그대로. Retry Interval(Minutes) 등 소스 진실 채택(design 03 §1-b 주의).

## 6. validation (design 00 §2-b E4)

| AS-IS | To-Be |
|---|---|
| MSG00109 (EditButton 편집차단) | 편집 버튼 미제공으로 트리거 소멸(design 01 L-R2 권장안). 재현 불필요 |

## 7. 미이식/deferred (정직 보고)

- i18n LBL/MSG 코드: 헤더·검색라벨·pane 제목은 AS-IS 영문 유지. SCM_ADM_MSG_M 역조회 DB ERROR 라 임의 코드 배정 금지(Hook #114). 코드 등록 확정 후 t('LBL#####') 교체 — 04_react-gap.md 참조.
- BE 메타 배선(SCM_ADM_MNU_BTN_MPG_M/API_M — menuId+SHT_NM→proc): DB 미확인(ERROR). PKG/PROC_M 은 design 06 배포 완료. 04_react-gap.md 확인필요 참조.
