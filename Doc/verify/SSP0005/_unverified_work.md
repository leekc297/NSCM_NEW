# SSP0005 미검증 해소 작업 기록

## 라운드 1, 2026-11-20 09:42 ~ 10:20

- 입력: 원장 verify_ledger.csv(09:29, ERROR 278행), unverified_triage.csv(09:36:54, 313행 = ERROR 278 + AI 검토 35), 처리 목록 _unverified_plan.md
- 경위: 1회차 세션이 09:57:06 중지됨. 체인 3단계 CheckList 재수행(09:57:11 시작)이 10:07:48 'VS Code 종료'로 끊김(events.jsonl proc.end exit 1). 10:02:23 원장은 끊긴 실행의 중간 상태(NOT_RUN 975행)라 이번 보완 효과 판정 근거로 쓰지 않음
- 재측정: 묶음별 재측정 안 함(지시 [4]). 확인은 자기 시험과 engine_selfcheck 로만 함. 판정 변화는 다음 CheckList 에서 확인 필요

### 묶음 1, 조회 0행 데이터전제 77행 + 0행 파생 검사기공백(F1, F2, F4, F6, F7, F8, A2, K1, L1, N1, E6, H4, H10, H11, I1, I2, J1, K2, K3, D1, D2, D3, D6, C3, E4, E5, G1, G8)
- 원인(실측): E2E 조회 본문 companyId 'AA00', divisionId 8개, 기간 20261120~20271114(sqllog_calls.json 04:45~04:52, 153건). 사내 ZIOUI1 SSP_MST_SHIP_CALENDAR 의 Company 는 GM00, HQ00, MI00, NA00, NB00, NJ00, WA00 뿐이고 AA00 행 0건(10:0x 조회)
- 원인(검사기): smoke-extra.ts ensureRows divSweep 이 '보이는 첫 콤보'를 Division 으로 봄. SSP0005 첫 콤보는 Company 라 Division 순회 0회(증거 문구 시도 목록에 Div 항목 없음). Division, 기간 외 조건(Company)을 바꾸는 단계 없음
- 고친 곳: tools/E2E/lib/smoke-extra.ts:651 sweepCondCombos 신설, :740 divSweep 라벨 Div, Division 칸 우선, :765 기간 확대 전 조건 후보 순회, Doc/e2e/specs/_verify.spec.ts:2189 Division 컬럼(A5) 0행 때 순회 (T475)
- 확인: tsc 0, engine_selfcheck PASS. E2E 동작 미측정(10:07 재수행이 첫 대안 조회 2회 뒤 끊김)

### 묶음 2, X-REASON 17행(AI검토:검사기오판)
- 원인(실측): 대조표 표 머리글 '# | AS-IS | 근거 | TO-BE | 상태' 에 사유 칸 없음. 17행 사유가 TO-BE 칸에 있고 RX_REASON 낱말과 맞지 않음(파서 실측 RX=False 17/17)
- 고친 곳: tools/Harness/verify/mapping_trace.py:827~850 reason_claim, :1146 X-REASON 분기 (T470)
- 확인: selftest 91/91(T470 7건, 음성 3건), SSP0005 17행 reason_claim 근거 17건

### 묶음 3, 차등짝 12행(A1, A5, A6, A7 ASIS_DIFF)
- 원인(실측): diff_summary.csv 호출 #19~#21 = E2E 입력 시험 'Invalid Date' 호출 SKIP. 같은 프로시저 호출 #2(calendar 434행 PASS), #3 이후(ROWS_ONLY)가 따로 판정됨
- 고친 곳: tools/Harness/verify/diff_ingest.py:28~55, :75 (T471)
- 확인: selftest 4/4

### 묶음 4, 정렬 A6 5행(AI검토:검사기오판)
- 원인(실측): dbo.SSP0005_GET_SHIPMENT_WORKING_DAY.sql 85줄 ORDER BY sort_order_no 는 SELECT @mQuery = @mQuery + … 대입문 정렬. 결과 정렬은 96줄 동적 SQL ORDER BY division_id, company_id
- 고친 곳: tools/Harness/verify/facts_sortrules.py:64 assign_select, :114 (T472)
- 확인: selftest 3/3, 재추출 시 85줄 depth ASSIGN, 96줄 depth 0
- 남은 사유: T-c7d508e6(GET_SCP_PERIOD 버튼코드 연결) 미처리. 결정 목록 D-09

### 묶음 5, 재실행 9행(EG022 Div 선택 8, EG271 1)
- 원인(코드 확인): authprobe.ts selectDiv 가 다중 선택 Division 에서 옵션을 눌러 기존 선택을 바꾸고, 칩 칸의 빈 입력값으로 선택 확인
- 고친 곳: tools/E2E/lib/authprobe.ts:116~133 (T474)
- 확인: tsc 0. E2E 동작 미측정

### 묶음 6, 실전송 건수 A1 1행(EG-57ab9048)
- 원인(실측): a1_live.json calls 1건 = calendar 호출인데 rows 0, cols COMPANY_ID, DIVISION_ID, D_* 는 본 그리드 값. 조회 1회에 본 조회와 calendar 가 함께 나가 마지막 호출을 기록함
- 고친 곳: Doc/e2e/specs/_verify.spec.ts:2135 (T473)
- 확인: tsc 0. E2E 동작 미측정

### 묶음 7, 저장 감사 F7, F8 6행
- 원인(실측): save_audit.json 'CRUD 실제 저장 정리 기록 없음(E2E 저장 미실행)'. 조회 0행이라 저장 시험이 돌지 않음. 묶음 1 보완으로 함께 측정됨
- 고친 곳: 없음(묶음 1)

### 미처리, 결정 목록으로 넘긴 묶음
- Plant Site 9행, Insert/Delete 비노출 15행, 기준정보 대조 범위 4행, 초기값, 후보 2행, MSG00135 1행, 스냅샷 2행, 대조표 X-LOC 2행: _unverified_decisions.md
- 추출기 미착수 12행(FACT 8, B7 4), 검사기 미착수 11행(A6 TRACE 1, A1 TRACE 2, J2 1, E4 ASIS 2, B3 1, A7 1, E2 1, G1 2): 결정 목록 D-08, D-09
