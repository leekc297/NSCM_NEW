# SSP0020·SCP0104 미검증 0 작업 계획 (2026-11-16 09:10 실측 기준)

사용자 지시(11-16): 두 화면을 먼저 끝낸다. 기능 100% 점검, 미검증 0, 결과가 CheckList 에 나와야 한다. 오류 누락 금지, 오류 아닌 것이 미검증이나 검사엔진 결함으로 오류로 나오는 것도 금지.

## 원장 현황 (verify_ledger.csv, 11-14 03:37 SSP0020 · 11-15 SCP0104)
| 화면 | 행 | PASS | FAIL | ERROR | 판정필요 | NA | NA 근거칸 빈값 |
|---|---|---|---|---|---|---|---|
| SSP0020 | 1,398 | 206 | 16 | 294 | 12 | 870 | 88 |
| SCP0104 | 3,248 | 739 | 58 | 1,319 | 16 | 1,116 | 461 |

## ERROR·판정필요 원인 (evidence 문구 정규식 분류)
| 원인 | SSP0020 | SCP0104 | 해결 방식 |
|---|---|---|---|
| R01 조회 0행 | 120 | 4 | 시험 데이터. SSP0020 = minyonglee1 위임 행 VALID_YN 전부 N(TO-BE SSP_MST_DELEGATE 766행 중) |
| R02 Insert 버튼 없음·신규행 전제 | 24 | 88 | AS-IS 원문으로 행 추가 기능 유무 확정 후 해당없음 또는 측정 |
| R03 Division 콤보 읽기 실패 | 15 | 0 | 검사기 결함 후보. 콤보 읽기 경로 수정 |
| R04 차등 검증 짝·골든 케이스 없음 | 10 | 0 | sp_pair.csv 짝 등록 + 런처 관찰 인자(행 단위 정답 10건) |
| R05 집계 행 | 34 | 574 | 하위 행 해소 시 자동 해소 |
| R06 검사기 실행 경로 없음 | 61 | 151 | 검사기 연결 |
| R07 대조표 서술 보강 | 7 | 20 | 정적. 구현 위치 기입 |
| R08 팝업 관련 | 8 | 47 | 동적 |
| R09 편집 불가·잠금 | 0 | 17 | 정적 우선 |
| R10 스냅샷 골든 승인 전 | 5 | 5 | 사용자 승인(snap_approve.py) |
| R11 측정 경로 없음(그 밖) | 16 | 391 | 세부 분류 필요 |
| R99 그 밖 | 6 | 38 | 세부 분류 필요 |

## 순서
1. SSP0020 먼저(행 수 1/2.3). R01 해소가 120건.
2. 원인별로 검사기 수정은 묶어서 하고 화면 재실행은 끝에 1회(주기 방식).
3. FAIL 16·58건은 허위 FAIL 여부를 AS-IS 원문으로 전수 확인.
4. NA 근거칸 빈값 88·461건은 근거를 붙이거나 미검증으로 되돌림.
5. 두 화면 CheckList 생성, 미검증 0 확인.


## 진행 기록 (2026-11-16 10:00 기준 — 재개 시 여기부터)

### 사용자 지시
- 중간 질문 금지. 권장안으로 끝까지 진행. 판단은 Doc/verify/_TWO_SCREENS_DECISIONS.md 에 모아 완료 후 일괄 질의(화면 모습·양쪽 차이·선택별 결과 + 캡처, 내부 용어 금지).

### 끝낸 것
- CR-104(CHK 컬럼 ↔ 행 머리 선택기) · CR-105(차등 검증 값·행 집합 차이 판정 제외, 컬럼·정렬 차이 FAIL) 등록·반영.
- sp_pair.csv: SSP0020 4건 · SCP0104 13건 수동 등록(백업 .bak_20261116_ssp0020 / _scp0104).
- 폼 저장형 경로: tools/E2E/lib/formscen.ts · Doc/e2e/specs/_formfix.spec.ts · _trace.spec.ts W4 E4 연결 · run_verify.py 준비·정리 호출 · Doc/verify/SSP0020/form_scenarios.json 19건.
- 검사기 결함 수정: _trace.spec.ts G6(빈값 초기값 · 다중 선택 '+N' 전체 선택) · authprobe.ts divState(열기 버튼).
- SSP0020 화면 오류 확인: MSG00219 TO-BE SCM_ADM_MSG_M 미등록(영문 문구 노출) · 컬럼 메타 VALID 라벨 Valid 2건(CR-092).

### 진행 중
- SSP0020 전체 재실행 09:5x 시작(백그라운드 b9khumhrm · 로그 scratchpad rv_SSP0020_run1.log · 재실행 전 원장 사본 scratchpad SSP0020_ledger_before_20261116.csv). 끝나면 전후 비교 → 남은 ERROR·판정필요·FAIL·근거 없는 NA 를 다시 분류.

### SSP0020 남은 일(재실행 결과 본 뒤)
- F 계열 저장 검사(F1·F2·F4·F6·F7·F8·H10·H11 등)를 폼 저장형 시나리오(F09·F13) 결과로 잇기 또는 근거 있는 해당없음.
- 검사기 실행 경로 없음 33 · 팝업 7 · 스냅샷 승인 4 · 대조표 서술 10 · 근거칸 빈 NA 51 · 미분류 10.

### SCP0104 확인한 것(미착수)
- 탭 전환 실패 225행: 검사기가 시트 이름(SOP_ASSEMBLY 등)으로 탭을 찾음. TO-BE 는 바깥 탭 'Line Assign'·'SOP' + 사업부 유형(Cell·Module-Pack = ASSEMBLY / Electrode = ELTR)별 안쪽 탭. LINE·SOP_MODEL_* 는 팝업 그리드(P03 Line · P02 SOP Model). 화면별 시트 이동 사실 파일(sheet_nav.json)과 clickSheetTab 연결 필요. TO-BE nscm-fe/features/supply/src/pages/capa-line-assign/CapaLineAssign.tsx(833~870행 탭).
- AS-IS SP 17개 중 TO-BE 에 없는 2개: SCP0104_CHECK_CAPA_LINE_SOP_BY_ASSIGN_ASSEMBLY/_ELTR. GSCM/06.UIL *.cs 에 호출 문자열 0건(11-16 grep). 다른 계층 호출 여부 미확인.
- 그 밖: Insert 버튼 비활성·편집 가능 셀 없음(계정·수정 모드 조건) · 팝업 M4 23 · 집계 행 623.


## SSP0020 재실행 1회차 결과 (2026-11-16 09:48~10:17, 30.5분, 로그 scratchpad rv_SSP0020_run1.log)
| | 행 | PASS | FAIL | ERROR | 판정필요 | NA |
|---|---|---|---|---|---|---|
| 전(11-14) | 1,398 | 206 | 16 | 294 | 12 | 870 |
| 후(11-16 10:17) | 1,434 | 309 | 32 | 198 | 6 | 889 |
- 검증용 위임 행: 09:50:34 13건 저장 → 10:14:31 해제(TO-BE 조회 Y 0건).

### 남은 것 분류(원장 evidence 기준 · 처리 순서)
1. [완료] 차등 검증 실행 오류(AS-IS 인자 {}): 수동 짝 인자 행 없음 → 신규 gen_param_map_manual.py · param_map.csv 213행 추가(SSP0020 4짝 · SCP0104 13짝 전부 이름 일치, 백업 .bak_20261116_manual). 대상 ASIS_DIFF ERROR 28행 + golden ERR 1 + 골든 케이스 없음 판정필요 5.
2. 허위 FAIL D1 8행 '기존행 편집=false (AS-IS 편집 가능)': AS-IS cs:294·307 LockColumn(DIVISION_ID~끝, true) 로 조회 뒤 전 컬럼 잠금. edit_expect.csv existing_row=Y 는 사실 추출 누락(LockColumn(시작, 끝, true) 범위 형식).
3. 허위 FAIL A4·G1 2행(Division 재조회·다중 선택 조회): 이 화면 Div·Period·Delegatee 는 조회 인자가 아님(조회 SP 인자 = user_id·language 뿐). 조회조건 검사 대상에서 빼야 함. 관련 ERROR: G2 3 · G8 2 · G1 2 · C1 1 · SC1 1 · G3 1.
4. 허위 FAIL I1 1행(변경 없이 저장 → 수정사항 없음 알림): 폼 저장형 화면은 그리드 변경 저장 개념 없음.
5. 화면 오류 유지: E4 MSG00219 3행 · H5 Valid 라벨 1행.
6. 그리드 읽기 전용 화면의 편집·저장 계열 ERROR(F1·F2·F3·F4·F6·F7·F8·H10·H11·A2·E2·E4·D1 신규행·D3): 폼 저장형 시나리오 결과로 잇거나 원문 근거 해당없음.
7. EG A5 '기대 선택 · 실제 실패' 13행 · J1 콤보 후보 3행(다른 스펙 경로) · M3·M4·G5·H6 사용자 팝업 6행 · 스냅샷 승인 5행 · 대조표 서술 X-LOC 5·X-REASON 2 · K3 2 · J4 2 · H9 1 · L1 2 · A10 1 · K4 1 · G03-WIRE 1 · K-SA 1 · A6 정렬 5 · F4 3.
8. 정적 검사 FAIL: Delegate.tsx:483 SsoUserModal ssoUserYn 'N' ↔ AS-IS false(같은 뜻 · 허위) · SingleSelectYn 미전달(확인 대상).
9. 집계 행 FAIL 16·ERROR 33: 하위 해소 뒤 재집계.


## 재부팅 뒤 재개 절차 (2026-11-16 11:34 작성 — 사용자 재부팅)

### 재부팅 직전 상태
- SSP0020 3회차 전체 재실행(11:3x 시작)을 테스트 20건째에서 중지함(TaskStop). 검증용 위임 행 13건은 11:33 에 해제, TO-BE 조회로 검증 계정 유효 위임 행 0건 확인. 실행 잠금(verify SSP0020 · slot 0~3) 해제.
- 원장(Doc/verify/SSP0020/verify_ledger.csv)은 11:12 판정 재적용 값 그대로: PASS 339 · FAIL 6 · ERROR 129 · 판정필요 15 · NA 948. 3회차 결과는 반영 안 됨.
- 3회차에 처음 들어가는 변경(아직 전체 실행으로 확인 안 됨): static_verdicts.csv 63행 · form_scenarios.json 21건(B01·B02 · covers) · eg_popup.spec.ts openPopup 보조 메서드 진입점 · authprobe.ts divState 재시도 · judge.py(정적 판정 · 읽기 전용 그리드 · 조회 인자 없음 · EG Div 선택) · diff_ingest.py(저장 SP SKIP → NA) · asis_live_rows.py(계정 의존 SP).

### 재개 순서
1. 서버 확인: BE 8080 · FE 5173. 꺼져 있으면 기동(BE gradlew.bat bootRun · FE `cd nscm-fe/apps/web && node_modules/.bin/vite.cmd --port 5173 --host 127.0.0.1` — 메모리 feedback_local_startup_command). AS-IS 쪽 IIS Express 8086 은 이번 두 화면 작업에 필요 없음(asis_live_rows 는 기존 실구동 기록을 읽음).
2. `python tools/Harness/verify/engine_selfcheck.py` PASS 확인.
3. `python tools/Harness/verify/run_verify.py SSP0020` 전체 재실행(약 30분) → 원장 분포 · 정리 rc · TO-BE 유효 위임 행 0 확인.
4. 남은 행 재분류: 스냅샷 승인 대기 6 · EG-f6eeda7b(권한 없는 계정 직접 접근) · V-243d2510 G3 · V-57edea6b SC1 · T-4888b232 K-SA · V-84872cd5 L1 · T-dceb08cd G03-WIRE · EG-9fd40fb0 F1 · EG-013290ff J2 · 팝업 COUNT·GRID_KEYS·GRID_FILTER·MERGE · 권한 J1 4행(81·82 Planner).
5. SSP0020 CheckList 생성(미검증 0 확인).
6. SCP0104: Doc/verify/SCP0104/sheet_nav.json 을 clickSheetTab(tools/E2E/lib/smoke-extra.ts:616)에 연결 → 탭 전환 실패 225행 · 그 밖 원인 처리 → 재실행.
7. 완료 뒤 Doc/verify/_TWO_SCREENS_DECISIONS.md 판단 목록을 화면 캡처와 함께 일괄 질의(내부 용어 금지).

### 주의
- 폼 저장형 준비가 끝난 뒤 실행이 끊기면 검증용 위임 행이 남는다 → `cd tools/E2E && VERIFY_ID=SSP0020 node node_modules/@playwright/test/cli.js test _formfix --grep @formteardown --retries=0 --workers=1` 로 해제하고 TO-BE SSP_MST_DELEGATE 에서 VALID_YN='Y' 0건 확인.
- 단독 시험은 CL_RESULTS·FORM_SCEN_RESULTS·E2E_RESULTS 를 scratchpad 로 돌려 공식 결과를 덮지 않는다.
