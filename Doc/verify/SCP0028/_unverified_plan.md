# SCP0028 미검증 행별 조치 · 2026-11-25 라운드 1(CheckList 02:10:34 원장)

- 입력: verify_ledger.csv(11-25 02:10:34), unverified_triage.*(02:10:34). 재생성 안 함(원장과 같은 시각)
- 원장 ERROR 71행 = 처리 대상 65행 + 집계 6행. AI 검토 2행(V-4633ca25 원장 판정필요, EG-ac06e957 원장 판정필요) 추가해 표 73행
- 지난 라운드 표 _unverified_plan.md.r7_20261121

## 묶음

| 묶음 | 행 수 | 원인(실측 근거) | 조치(고친 파일) |
|---|---|---|---|
| B1 팝업 조회 SP 짝 | 60 | sp_pair.csv 에 PKG_SCP0028.P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP 의 AS-IS 짝 없음. 원인: 화면 cs:270 이 다른 프로젝트 팝업 SCM0002_ShipmentLotSizePopup 을 new 로 열고 팝업 cs:284 가 SCM.SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP 을 부름. endpoints.csv(4행)에 팝업 SP 없음 | tools/Harness/verify/gen_param_map.py popup_class_sps (T529) |
| B2 팝업 SP 정렬 | 1 | sort_rules.csv 에 팝업 SP 정렬 규칙 0행(facts_sortrules 가 endpoints.csv SP 만 읽음). sort_check.csv 에 팝업 SP 행 없음 | tools/Harness/verify/facts_sortrules.py popup_sps (T529) |
| B3 계정 지정 시나리오 언어 단계 | 2 | 시나리오 계정 dana.robot 지정이라 adminPool 계정을 못 씀. 언어 단계가 다른 화면 E2E(SCP0005, SSP0005, SSP0014) 전부 끝나길 기다리다 생략(_verify.spec.ts 시나리오 lang 단계) | tools/E2E/lib/langacct.ts, nscm.ts, Doc/e2e/specs/_verify.spec.ts (T530) |
| B4 K2 무판정 | 1 | 원장 applicable=N(COLUMN_SETTING: actions.csv TitleSet|btnColumn 0건)인데 judge.py 무판정 단계가 ERROR 로 바꾸고 적용성 단계(NOT_RUN 만)가 건너뜀 | tools/Harness/verify/judge.py (T531) |
| B5 Item 팝업 SP | 1 | TO-BE SCP0028 은 PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP 을 부르지 않음(callProc = SCM0002, SCP0033, SSP0019). Model 팝업 COM0013 교체 룰 결정 전에는 대상 SP 를 정할 수 없음 | 처리 안 함, 결정 R4-D1 |
| B6 저장 중 로딩 AI 검토 | 1 | AI 검토 근거 'AS-IS SaveData 에 진행 창 없음' 이 원문과 다름. cs:661 new FoxAsyncProxy(this), ShowProgress=false 없음(조회 cs:344, 411 은 끔). T528 막음 작동해 판정필요 유지 | 검사기 수정 없음, 결정 R7-D1 |
| B7 Model 팝업 교체 룰 | 1 | 담당 결정 | 처리 안 함, 결정 R4-D1 |
| 집계 | 6 | 하위 행 판정을 따라감 | 따로 고치지 않음 |

## 행 목록

| 묶음 | 행 ID | 규칙 | 담당 | 유형 | 원장 판정 |
|---|---|---|---|---|---|
| B1 팝업 조회 SP 짝 | AD-16ed9f6d | A1 | 엔진 | 차등짝 | ERROR |
| B1 팝업 조회 SP 짝 | AD-176ef7aa | A1 | 엔진 | 차등짝 | ERROR |
| B1 팝업 조회 SP 짝 | AD-1a87a9b8 | A1 | 엔진 | 차등짝 | ERROR |
| B1 팝업 조회 SP 짝 | AD-2f776860 | A1 | 엔진 | 차등짝 | ERROR |
| B1 팝업 조회 SP 짝 | AD-31891e7c | A1 | 엔진 | 차등짝 | ERROR |
| B1 팝업 조회 SP 짝 | AD-4ada955f | A1 | 엔진 | 차등짝 | ERROR |
| B1 팝업 조회 SP 짝 | AD-6952e31a | A1 | 엔진 | 차등짝 | ERROR |
| B1 팝업 조회 SP 짝 | AD-854fc98d | A1 | 엔진 | 차등짝 | ERROR |
| B1 팝업 조회 SP 짝 | AD-89b11727 | A1 | 엔진 | 차등짝 | ERROR |
| B1 팝업 조회 SP 짝 | AD-9ce43e53 | A1 | 엔진 | 차등짝 | ERROR |
| B1 팝업 조회 SP 짝 | AD-b36657a8 | A1 | 엔진 | 차등짝 | ERROR |
| B1 팝업 조회 SP 짝 | AD-bd5d241e | A1 | 엔진 | 차등짝 | ERROR |
| B1 팝업 조회 SP 짝 | AD-cab0d67b | A1 | 엔진 | 차등짝 | ERROR |
| B1 팝업 조회 SP 짝 | AD-d81d48bb | A1 | 엔진 | 차등짝 | ERROR |
| B1 팝업 조회 SP 짝 | AD-e6233df3 | A1 | 엔진 | 차등짝 | ERROR |
| B1 팝업 조회 SP 짝 | AD-0a4372ab | A5 | 엔진 | 차등짝 | ERROR |
| B1 팝업 조회 SP 짝 | AD-0f45ca72 | A5 | 엔진 | 차등짝 | ERROR |
| B1 팝업 조회 SP 짝 | AD-1e8379a1 | A5 | 엔진 | 차등짝 | ERROR |
| B1 팝업 조회 SP 짝 | AD-2d4079e6 | A5 | 엔진 | 차등짝 | ERROR |
| B1 팝업 조회 SP 짝 | AD-35cdafc7 | A5 | 엔진 | 차등짝 | ERROR |
| B1 팝업 조회 SP 짝 | AD-81f9457d | A5 | 엔진 | 차등짝 | ERROR |
| B1 팝업 조회 SP 짝 | AD-886d8c26 | A5 | 엔진 | 차등짝 | ERROR |
| B1 팝업 조회 SP 짝 | AD-a87e4641 | A5 | 엔진 | 차등짝 | ERROR |
| B1 팝업 조회 SP 짝 | AD-adc62326 | A5 | 엔진 | 차등짝 | ERROR |
| B1 팝업 조회 SP 짝 | AD-b097262d | A5 | 엔진 | 차등짝 | ERROR |
| B1 팝업 조회 SP 짝 | AD-d7e8e8dc | A5 | 엔진 | 차등짝 | ERROR |
| B1 팝업 조회 SP 짝 | AD-d9428c6a | A5 | 엔진 | 차등짝 | ERROR |
| B1 팝업 조회 SP 짝 | AD-e4f51c47 | A5 | 엔진 | 차등짝 | ERROR |
| B1 팝업 조회 SP 짝 | AD-f2a6cb89 | A5 | 엔진 | 차등짝 | ERROR |
| B1 팝업 조회 SP 짝 | AD-fcd3cf86 | A5 | 엔진 | 차등짝 | ERROR |
| B1 팝업 조회 SP 짝 | AD-0e7943c1 | A6 | 엔진 | 차등짝 | ERROR |
| B1 팝업 조회 SP 짝 | AD-125dcd3f | A6 | 엔진 | 차등짝 | ERROR |
| B1 팝업 조회 SP 짝 | AD-13db7f49 | A6 | 엔진 | 차등짝 | ERROR |
| B1 팝업 조회 SP 짝 | AD-244b08bb | A6 | 엔진 | 차등짝 | ERROR |
| B1 팝업 조회 SP 짝 | AD-305c8e11 | A6 | 엔진 | 차등짝 | ERROR |
| B1 팝업 조회 SP 짝 | AD-36e52665 | A6 | 엔진 | 차등짝 | ERROR |
| B1 팝업 조회 SP 짝 | AD-6e5cd70c | A6 | 엔진 | 차등짝 | ERROR |
| B1 팝업 조회 SP 짝 | AD-7abe0c89 | A6 | 엔진 | 차등짝 | ERROR |
| B1 팝업 조회 SP 짝 | AD-84391a07 | A6 | 엔진 | 차등짝 | ERROR |
| B1 팝업 조회 SP 짝 | AD-9d1865fa | A6 | 엔진 | 차등짝 | ERROR |
| B1 팝업 조회 SP 짝 | AD-a75595d7 | A6 | 엔진 | 차등짝 | ERROR |
| B1 팝업 조회 SP 짝 | AD-afab4d83 | A6 | 엔진 | 차등짝 | ERROR |
| B1 팝업 조회 SP 짝 | AD-d1ba0b6b | A6 | 엔진 | 차등짝 | ERROR |
| B1 팝업 조회 SP 짝 | AD-d4749e15 | A6 | 엔진 | 차등짝 | ERROR |
| B1 팝업 조회 SP 짝 | AD-f8013ee3 | A6 | 엔진 | 차등짝 | ERROR |
| B1 팝업 조회 SP 짝 | AD-0d4ddf6c | A7 | 엔진 | 차등짝 | ERROR |
| B1 팝업 조회 SP 짝 | AD-1eb9cb71 | A7 | 엔진 | 차등짝 | ERROR |
| B1 팝업 조회 SP 짝 | AD-28da6f65 | A7 | 엔진 | 차등짝 | ERROR |
| B1 팝업 조회 SP 짝 | AD-42fb59be | A7 | 엔진 | 차등짝 | ERROR |
| B1 팝업 조회 SP 짝 | AD-44898b71 | A7 | 엔진 | 차등짝 | ERROR |
| B1 팝업 조회 SP 짝 | AD-5079c1a8 | A7 | 엔진 | 차등짝 | ERROR |
| B1 팝업 조회 SP 짝 | AD-51dde9b2 | A7 | 엔진 | 차등짝 | ERROR |
| B1 팝업 조회 SP 짝 | AD-7031951d | A7 | 엔진 | 차등짝 | ERROR |
| B1 팝업 조회 SP 짝 | AD-7f5c41f3 | A7 | 엔진 | 차등짝 | ERROR |
| B1 팝업 조회 SP 짝 | AD-88332dd0 | A7 | 엔진 | 차등짝 | ERROR |
| B1 팝업 조회 SP 짝 | AD-9e43972e | A7 | 엔진 | 차등짝 | ERROR |
| B1 팝업 조회 SP 짝 | AD-ce275074 | A7 | 엔진 | 차등짝 | ERROR |
| B1 팝업 조회 SP 짝 | AD-d8901eb3 | A7 | 엔진 | 차등짝 | ERROR |
| B1 팝업 조회 SP 짝 | AD-eca4c0ee | A7 | 엔진 | 차등짝 | ERROR |
| B1 팝업 조회 SP 짝 | AD-f377f227 | A7 | 엔진 | 차등짝 | ERROR |
| B2 팝업 SP 정렬 | T-c6aefa56 | A6 | 엔진 | 판단 | ERROR |
| B3 계정 지정 시나리오 언어 단계 | V-1f64fec6 | E4 | 엔진 | 검사기공백 | ERROR |
| B3 계정 지정 시나리오 언어 단계 | V-ca2072cf | I1 | 엔진 | 검사기공백 | ERROR |
| B4 K2 무판정 | V-b685dddf | K2 | 엔진 | 검사기공백 | ERROR |
| B5 Item 팝업 SP | T-fad117f6 | F4 | 엔진 | 검사기공백 | ERROR |
| B6 저장 중 로딩 AI 검토 | V-4633ca25 | H11 | 엔진 | AI검토:검사기오판 | 판정필요 |
| B7 Model 팝업 교체 룰 | EG-ac06e957 | G4 | 결정 | AI검토:룰등록 | PASS |
| 집계 | V-86208af2 | E4 | 집계 | 집계 | ERROR |
| 집계 | T-14732ce2 | F4 | 집계 | 집계 | ERROR |
| 집계 | T-80e70b77 | F4 | 집계 | 집계 | ERROR |
| 집계 | T-98554096 | F4 | 집계 | 집계 | ERROR |
| 집계 | T-f7a95dc6 | F4 | 집계 | 집계 | ERROR |
| 집계 | T-4cec401b | X-ROW | 집계 | 집계 | ERROR |

## 행 수 대조

- 원장 ERROR 71 = 표 ERROR 71행. 표 판정필요 1행은 AI 검토 행

## 처리 결과

| 묶음 | 처리 | 남은 사유 |
|---|---|---|
| B1 | gen_param_map.py 수정. 체인 diff 단계가 gen_param_map 을 먼저 돌려 짝 생성 | 없음. 짝이 생기면 diff_verify 가 AS-IS SP 를 실행함. R5-D2(AS-IS DEV DB 300초 초과 호출)는 그대로 |
| B2 | facts_sortrules.py 수정. 체인 1단계 facts_sortrules → sort_check 가 팝업 SP 정렬 2분기(61, 97행)를 TO-BE ORDER BY 와 대조 | 없음 |
| B3 | langacct.ts, nscm.ts, _verify.spec.ts 수정 | 다른 실행이 dana.robot 으로 로그인해 있으면 종전처럼 다른 화면 대기(T200) |
| B4 | judge.py 수정 | 없음. 적용성 N 근거로 NA(대상 없음) |
| B5 | 처리 안 함 | R4-D1 결정 필요(대상 SP 를 COM0013 조회 SP 로 바꿀지) |
| B6 | 처리 안 함 | R7-D1 결정 필요. 분류기가 담당 엔진으로 다시 올림(AI 검토 결론이 원문과 다른 경우를 결정으로 넘기는 분류 규칙 없음) |
| B7 | 처리 안 함 | R4-D1 |
| 집계 | 하위 행을 따라감 | V-86208af2 ← V-1f64fec6(E4). F4 행 집계 4행(T-98554096, T-14732ce2, T-80e70b77, T-f7a95dc6) ← mapping_trace_instances.csv 의 F4 요소 ERROR 1개 = T-fad117f6(R4-D1). T-4cec401b(checkValidSize 진입점 6검사 중 ERROR 1) 하위 검사 이름 미확인 |
