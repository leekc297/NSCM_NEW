# 검증엔진 총괄 원장 (3개 문서 전체 확인 — 누락 0)

> **작업 재개 시 이 파일부터 읽는다.** 대화가 잘려도 이 원장으로 이어간다. 완료 표시는 증빙(파일·실행 시각)이 있을 때만 한다.
> 사용자 지시(2026-10-31): 감·예측 금지 · 실검사로 확인 · 필요한 검증엔진은 전부 생성 · 며칠이 걸려도 하나씩 누락 없이 · 전체를 잊지 말 것 · 실저장 진행 승인.

## 목표(합격 기준)
1. `Doc/verify/defects_classified.csv` 대상 732행(DEFECT·공란·REQ·OPEN)이 전부 **입증** — `python tools/Harness/verify/doc_proof.py` 의 입증 비율이 유일한 진행율.
2. 규칙마다 ① 결함을 FAIL 로 잡는 증거(실제 결함 또는 변이 주입) ② 정상을 PASS 로 두는 증거.
3. 기계 검출 불가 행은 사유와 함께 사용자 확인.
4. 사용자 판정 회귀(`regress.py`) 위반 0 · 오라클 위반 0 · 면제 없는 커버리지 게이트.

## 진행율 기록(doc_proof 출력만 · 추정 금지)
| 측정 시각 | 입증 | 반쪽 | 미입증 | 불가 | 원장 메뉴 |
|---|---|---|---|---|---|
| 10-31 12:53 | 247 (33.7%) | 301 (41.1%) | 176 (24.0%) | 8 (1.1%) | 45 중 4 |

## 작업 순서(사용자 지시 10-31: 없는 검사엔진을 먼저 일괄 생성 → 그 뒤 전 메뉴 실행)
1. **W0 엔진 갭 전수 조사·신설을 먼저** — 끝나기 전에는 일괄(W1) 재시작 금지. 엔진을 고치면 일괄 결과가 무효가 된다.
2. W1·W2 전 메뉴 실저장 실행 → W3~W6 잔여 처리 → W7 마무리.

## 작업 목록

### W0. 검사엔진 갭 전수 조사·일괄 신설(최우선)
- [x] 규칙별 코드 존재 조사 `engine_audit.py` → `Doc/verify/_engine_audit.csv`(10-31 14:57: OK 88 · 대상 생성 없음 12 · 둘 다 없음 1). 패턴 탐지라 '있음'이 하위 요구 충족을 뜻하지 않음
- [x] 문서 하위 항목 ↔ 코드 대조 → **`Doc/verify/_engine_gap.csv`(EG001~EG461)** · 10-31 15:29 규칙 91개 누락 0 · 없음 269 · 부분 135 · 상속만 12 · 있음 45
- [x] P0 측정 없이 판정하던 코드 교정(10-31 15:36): I3 무조건 PASS · M1·J4·B8 고정 판정 → ERROR[측정 코드 없음] · F5 CR-057 반대 판정 · A9 전용 행 · 타 대상 PASS 상속 제거(SCP0111 PASS 455→251, SCP0100 532→351, 회귀 위반 0)
- [~] 미충족 416항목 신설·보강 — **항목 상태는 `_engine_gap.csv` build_status 가 원장** · 현황 `python tools/Harness/verify/engine_gap_cluster.py` · 묶음 목록 `... E05`
  - 순서 = 문서 행 많은 묶음부터(E05 저장 세부 → E02 팝업 → E03 Division·권한 → E10 조회조건 → E11 편집 잠금 → E04 값 계산 → E09 다국어 → E12 정렬·형식 → E01 Excel → E06 행 조작 → E08 레이아웃 → E07 컬럼 설정 → E99)
  - 항목 완료 조건 = 코드 재확인 → 구현 → 변이 주입 FAIL·정상 PASS 입증
- [ ] 사용자 확인 필요: Reset Condition 기준 충돌 — 문서 SSP45REQ-12(초기값 복원) ↔ 10-30 사용자 결정(AS-IS 대로 서버 저장본만 삭제·화면값 유지)
- [ ] A9 '둘 다 없음' 원인 확인(구현 보고한 규칙) · D2·B5 상속 별칭만 있음 · A8 측정 코드 확인
상태: [ ] 미착수 · [~] 진행 중 · [x] 완료(증빙 기재)

### W1. 전 메뉴 실행
- [ ] 문서 메뉴 39개 실행 — `run_docs_batch.py`(10-31 14:57 사용자 지시로 중단 · W0 완료 뒤 전체 재실행. 진행 중이던 DMF0005·DMF0082·DMF0044 는 저장·원복 보호를 위해 끝까지 둠 — 결과는 참고용)
- [ ] 실행 불가 메뉴 5개(COMMON 56·DMF0043_01 10·COM0007·SYS0005·SYS0006, 문서 70행)를 대표 화면 검사로 연결 — 메뉴 ID 공란 행도 확인
- [ ] 1차 실행의 rc≠0·테스트 타임아웃·검증엔진 미기동 메뉴를 메뉴별로 해소

### W2. 실저장(사용자 승인 10-31)
- [x] 메뉴별 정리 정의 자동 생성 `gen_cleanup_spec.py`(저장 SP 깊이 3 · 기반 테이블 제외 · 화면 키만) + 잔존 실측 `save_residue.py` — 10-31 13:40: keyset 자동 18 · editonly 18(신규행 안 만듦, 기존행 수정·원복만) · 수기 3
- [ ] 메뉴별 `save_residue.csv` 잔존 0 확인 · 잔존 시 원복 · 미해석 테이블 처리
- [ ] editonly 18개 메뉴의 신규행 저장 경로 입증 방법 결정(키를 화면에서 읽지 못함)
- [ ] 실저장 일괄 실행(W0 뒤) · 정리 결과 확인(`Doc/verify/<ID>/cleanup/`)
- 사용자 10-31: 이 DB(59.19.252.148 ZIOUI1)는 ERP 전송·메일 발송 걱정 불필요 → 제외 사유 아님(DMF0005 Div 제한 해제)

### W3. 실측 0 규칙(19개) — 대상 화면 측정 또는 검사기 신설
B5 · D2 · M1 · H6 · F7 · F8 · M4 · H3 · J3 · J4 · A8 · A3 · C5 · L2 · A9 · E6 · F9 · E7 · K5

### W4. PASS 만 실측된 규칙(29개) — 결함 검출 입증(변이 시험 확장)
A7 · G4 · N1 · H4 · K2 · K1 · I1 · H5 · J2 · C1 · I2 · K4 · M2 · B6 · K3 · J1 · H7 · E2 · E5 · G7 · H11 · A4 · I3 · DB-SYN · H9 · I4 · A10 · H12 · K6
- [ ] `mutate.ts` 주입 종류 확장(현재 A5·H5·D1·H3·G1·G5·C2 7종) · `checklist_selftest.py` KINDS/TESTS 확장
- [ ] `doc_proof.py` 가 selftest JSON 을 읽도록 수정(현재 CSV 만 읽어 변이 증명이 반영되지 않음)

### W5. FAIL 만 실측된 규칙(7개) — 정상 판정 입증 + 허위 FAIL 점검
E4 · C2 · B8 · F3 · D6 · G10 · F10

### W6. 판정 근거 재점검(제가 완화·단정한 항목)
- [ ] 커버리지 면제 사유 전수 점검(`coverage.py benign`) — 근거 없는 면제 제거
- [ ] E1 BOH: `FAIL_OR_BLOCKED` 로 완화됨 — BOH 정수 입력 실측 경로
- [ ] SCP0041 E3: 날짜 칸을 비워도 이전 날짜로 조회 — AS-IS `UsrDateRangePicker3` 공란 가능 여부 원문 확인 후 판정
- [ ] SCP0096 E1 FAIL→PASS 원인 미확인 — 뷰포트 영향 여부 실측
- [ ] SCP0111 Plan Date 지정 조건이 실제 조회에 반영됐는지 실측(`results.json` 에 값 없음)
- [ ] SCP0100 G2 교정 미측정(6차 W4c 타임아웃) · W4c 타임아웃 원인
- [ ] 문서 기반 재현: `_doc_proof_rows.csv` 행별로 해당 메뉴 원장의 대응 판정 연결(규칙 단위 입증과 구분)

- [ ] CRUD edit-save 재조회 행 식별 오류(SCP0111 v22 '행 찾기 0 · 0→1 · 재조회 1,249') — 키 셀 3개로 행이 유일하지 않음
- [ ] 동시 실행 부하: 체인 5개 동시에 로그인 픽스처 360s 타임아웃(SCP0041 r12 H12 테스트) — 상한 3 지키기
- [ ] DMF0003 smoke 1800s 초과 원인(상한 7200s 로 올림 · 소요 구간 실측)

- [~] E1 유효값 대조군 완료(10-31 17:33 SCP0096 PASS · SCP0111 동적 FAIL 근거 강화) · E5 대조군 남음: 규칙 밖 값 '거부 OK' 를 믿으려면 유효값이 들어가는지 먼저 확인 — 입력 경로가 값을 못 넣어도 거부로 보이는 거짓 PASS 가능(SCP0096 '1.5'→'1' 사례)

- [x] SCP0096 WORKING_TIME_DEFAULT 입력 실패 = 프로브 문제(10-31 17:37 순수 키보드 진단: 1→2→3→2→4 전부 정상) → typeCell 키보드 우선
- [x] DMF0005·DMF0082 13:07 이후 잔존 0건(10-31 17:16 save_residue)

### W7. 마무리
- [ ] SCP0111 / SCP0100 / SCP0041 / SCP0096 / SCP0007 / DMF 전 화면 regress 위반 0
- [ ] `_checker_defects.md` · `README` · 메모리 최종 반영
- [ ] VM 메뉴에 `doc_proof` · 일괄 실행 연결 여부 확인
- [ ] 사용자에게 "CheckList 다시 작성" 보고는 위 전부 완료 뒤에만

### W8. 새 화면 누락 해소(사용자 지시 2026-11-04 13:5x — 권장 2~5번 진행 · 1번 블라인드 시험은 최종 작업 뒤 사용자가 수행)
배경(11-04 13:45 실측): 새 화면은 공통 규칙 검사는 돌지만, 화면별 손 기대 파일 12종(scenario_expect 87 · doc_ui 9 · source 9 · text 8 · sum_toggle 5 · num_format 4 · period_color 4 · zero_display 2 · removed_buttons·cond_equiv·display_sort·excel_form 각 1)은 0행 → 그 결함 유형은 새 화면에서 측정되지 않는다.
- [ ] **W8-2 기대 행 자동 생성기** `gen_expect.py <ID>` — AS-IS/TO-BE 사실(actions·lock_rules·cell_clear·edit_expect·combo_src·grid_rule·dyn_columns·sheet_columns·btn_auth·msg_master) → `Doc/verify/<ID>/auto_expect/<원본 파일명>.csv`(손 파일과 같은 열 + pattern_id·basis). 소비자(ledger.py·_verify.spec.ts)는 손 행 ∪ 자동 행(손 행 우선·같은 패턴 키 중복 제거). 실행 시점 = CheckList(prereq) 때 사실이 생성본보다 새로우면 재생성 + 파싱(S1.packone) 뒤에도 생성. 자동 행은 실저장(realsave) 금지(가로채기만).
  - 합격 기준(재현율): 손 행이 있는 화면에서 생성기가 같은 패턴·같은 대상의 행을 만든 비율 = `gen_expect_recall.py` 출력만 인용. 패턴화 불가 행은 사유와 함께 목록화.
  - **[~] 11-04 14:35 중단(사용자 지시: 다른 세션 검사엔진 작업 마무리 뒤 재개)** — 지금까지:
    - 신설 `tools/Harness/verify/expect_rows.py`(손∪자동 로더·패턴 키) · `gen_expect.py`(패턴 P01~P25, 17함수 · scenario_expect 만) · `gen_expect_recall.py` · `Doc/verify/scenario_env_override.csv`(DMF0042/44/49=40)
    - 생성 결과(14:29:39): 37화면 자동 1,012행(손 중복 31 제외 소비용 981) → `Doc/verify/<ID>/auto_expect/scenario_expect.csv` · 전체본 `_all/` · 보고서 `_gen_report.json`
    - 재현율(14:29:39): 손 기대 행 136 중 재현 33 · 미재현 4 · 패턴 없음 51 · 다른 11종 파일 미생성 48 (패턴 키 있는 손 행 85 중 38.8%)
    - 소비자 연결: `ledger.py` 9블록 `_EXP` · `_verify.spec.ts` 8곳 `readExpect` · 시나리오 시험 제한 시간 행 수×150초 · `smoke-extra.ts setCondOther`(`cond:라벨=@other`) — tsc rc=0 · **자동 행은 `VERIFY_AUTO=1` 일 때만 사용(기본 꺼짐 · 다른 세션 CheckList 영향 0)** · 백업 `*.bak_20261104`
    - 남은 것: ① 자동 행 실측(VERIFY_AUTO=1 로 화면 1개 CheckList → 허위 FAIL·측정 경로 ERROR 점검) 뒤 기본값 켜기(사용자 확인) ② prereq/S1.packone 연결(사실이 새로우면 재생성) ③ 11종 파일 생성기(doc_ui·num_format·sum_toggle·period_color = 사실 있음 / source·removed·cond_equiv·display_sort·excel_form = 문서 결정 → 사유 목록) ④ 패턴 없음 51행 추가 유형화(편집 구간 lock_rules·버킷 저장 합계·자릿수·조건 순서·팝업 Close 폐기 등) ⑤ 미재현 4(SYS0006 AS-IS 사실 없음 · DMF0005 팝업 칸 붙여넣기 · DMF0004/0021 실저장 행) ⑥ W8-3~5
  - **[~] 11-04 23:05 재개(사용자 지시)** — 다른 세션 실행 중(23:02 이 파일 · 22:59 measure.py PKG_DMF0082) → DMF0042/0008/0082 피함 · 자동 행 기본 꺼짐 유지
    - ① 실측: SCP0111 `VERIFY_AUTO=1 run_verify.py` 23:08 시작(폴더 백업 = scratchpad `SCP0111_before_auto` · 끝나면 자동 행 결과만 뽑고 공식 결과 복원) — 원장에 자동 10행 반입 확인(23:17:03 원장) · E2E 결과 대기
    - ② `run_verify.py` 사실 보강(facts_*) 직후 `gen_expect.py <ID> --asis <AS-IS>` 호출 — 실패 시 기본 = 경고만 · VERIFY_AUTO=1 = 중단(exit 6). S1.packone 연결은 하지 않음(자동 행 소비자 = CheckList 하나 · 매번 최신 사실로 재생성)
    - 결함 수정: 생성기가 AS-IS 사실을 TO-BE ID 폴더로 읽음 → `map_screen.csv` tobe→asis(SYS 19화면 · SYS0002=GSCM_USERINFO 등) · 파일 근거에서 variant shared/legacy(복사본·_T_ 사본) 제외 · 키 별칭 Div=Division · `search0` 도 조회 횟수 · 전환+colvis 행은 별도 키(`F4|toggle|div|colvis`)
    - ③ 파일별 출력(`FILE_COLS` · 행의 `_file`) + 신규 패턴: **P26** 칸 노출 Division 조건(grid_code set:Visible 계열 · 부모 조건 사슬 Division 술어만 계산 · 다른 술어 섞인 칸·핸들러 간 상충 칸 전체 제외 · 보임/숨김 짝 있을 때만 = 허위 PASS 방지) doc_ui 46행/7화면 · **P27** 버튼 노출 Division 조건(TO-BE btn_auth 에 같은 코드 있을 때만) 0행(DMF0020 Upload·Excel Form = TO-BE 원장 없음) · **P28** Sum 체크 = 재조회 없이 합계 칸 토글(원문 `.Visible = chkSum.Checked` · flow 서버 경로 없음 · AS-IS 첫 상태 해제 · Bucket 분기면 cond Bucket=Weekly) sum_toggle 16행 · **P30** AS-IS 메타 DIVISION_ID 일부 칸 → Div A→B→A colvis(주 시트·TO-BE 숨김 불가 칸 · Division 고정 화면 제외) 13행
    - ③ 만들지 않음(사유): num_format = 칸 단위는 공통 COLUMN H8/E1(ledger 492·527)과 중복 · Measure 행 단위는 문서 결정(GAP-12 · AS-IS 원문 DecimalPlaces 0건) / period_color·text·zero_display·source·removed·cond_equiv·display_sort·excel_form = 문서 결정 / 저장 외 동작 버튼 서버 실패 응답(M2) = FE 원문에서 버튼 글자 확정 4건뿐(DMF0008 손 행 있음 · DMF0042 다른 세션 작업 중) → 보류
    - 재현 불가(문서 결정 — AS-IS 사실과 반대): doc_ui 손 9행(예 DMF0082 AS FROM SITE = AS-IS 메타 40 포함인데 문서 Div 40 숨김 DM-47) · sum_toggle DMF0035 absent·DMF0043 immediate(AS-IS usrHis = InitSpread 만, 재조회 없음)
    - 재측정(23:54:53 `gen_expect_recall.py`): 손 기대 행 144 · 재현 37 · 미재현 16 · 패턴 없음 57 · 생성기 없는 파일 34 → 패턴 키 있는 87 중 42.5% · 생성 56화면 시나리오 1,166(소비용 1,135) · doc_ui 46 · sum_toggle 16(소비용 14)
    - ① 실측 결과(11-05 00:58:51 종료 · `VERIFY_AUTO=1 run_verify.py SCP0111` · 원장 1,715행 중 자동 10행): PASS 2(I1 KO 무변경 저장 · H10 로딩) · FAIL 4 · ERROR 4
      - FAIL 실결함 3: I1 CN 건수 'Total1,714rows'(CR-063 위반) · D6 Insert 가 선택 행 3 아닌 1714 위치(CR-015 위반) · E3 빈 신규 행 저장 요청 나감·안내 없음(AS-IS SCP0111_IntegrationPSI.cs:1226-1233 공백 검사 MSG00001 → 중단) — 저장 요청은 가짜 응답(_verify.spec.ts:2222 rt.fulfill)이라 DB 무변경
      - FAIL 허위 1 = 생성기 결함: F1 Delete → AS-IS `DeleteButton()` 본문 비어 있음(:536) — P06 이 근거 없이('삭제 문장 미확인') 생성 → `_empty_override` 로 생성 안 함(영향 6화면 DMF0008·DMF0043·SCP0111·SSP0021·SSP0200·SSP0201)
      - 생성기 결함 2(허위 판정 위험): P13 기대 문구에 성공('개의 데이터가 저장되었습니다')·중복 문구 섞임 — 바깥 guard(nowGroupID IsNullOrEmpty)까지 빈값 검사로 봄 → 가장 안쪽 조건만 · 성공·확인 문구 제외 / P21 AS-IS 라벨('Division*')로 찾아 ERROR → SCP·SSP 는 조회조건 기준표 TO-BE 이름·유형 '선택'만(14화면), 그 외 '*' 제거·정규식 이스케이프
      - ERROR 3 남음(측정 경로): E4 BOH_QTY 입력 안 됨 · H2 W_ 동적 칸 없음 · D2 편집 가능 동적 칸 없음 — 허위 FAIL 아님(미검증) · 원인 미확인
      - 공식 결과 복원 01:03:29(폴더 백업과 동일 확인) · 실행 산출물 보존 = scratchpad `SCP0111_auto_run`·`SCP0111_auto_run_checklist`(v23) · CheckList v22 를 old 에서 되돌림 · 공용 `_user_verdicts.csv`(수집 323건)·`_regress_report.md` 는 이 실행이 갱신함
    - 재생성(01:04 · 56화면): 시나리오 1,170(소비 1,138) · doc_ui 46 · sum_toggle 16(14) · 재현율 01:04:54 = 87 중 37(변동 없음)
    - **11-05 자동 행 기본 켜짐(사용자 지시)** — ledger.py:149 · run_verify.py:111(생성 실패 시 중단) · _verify.spec.ts:52 = `VERIFY_AUTO` 없으면 켜짐 · `VERIFY_AUTO=0` 이면 손 행만
    - **11-05 권한 필터(사용자 지시 'INSERT 권한이 실제로 있는 행에만')** — gen_expect `auth_filter`: Insert·Save·Delete 단계 행은 시험 계정 그룹(행 user 열 그룹 · 없으면 기본 계정 minyonglee1 소속 9그룹 합집합, 대소문자 무시)에 btn_auth use_yn=Y 일 때만. 실측 05:44 = Insert 단계 814행 중 70행(11화면 · P07~P10·P14·P15)이 INSERT=Y 그룹 0 화면 → 05:47 재생성 제외 70 일치 · 시나리오 1,100(소비 1,068) · 재현율 37/87 유지 · 제외 사유 = `_gen_report.json` auth_drop
- [x] **W8-3 문서 행 → 결함 패턴 연결** `Doc/verify/doc_patterns.csv`(문서 749행 각각 = pattern_id · 적용 조건(사실 술어) · 검사 경로(공통 규칙/자동 기대/손 기대)) + `pattern_coverage.py <ID>`(새 화면 적용 패턴 수 · 생성된 시험 수 · 측정 결과)
  - **11-05 완료(06:05)** — `gen_expect.PATTERN_INFO`(P01~P30 · 29개 · 규칙·적용 조건 단일 출처) · `doc_patterns.py` → `Doc/verify/doc_patterns.csv`(문서 749행 = doc_proof 대상과 같은 분모) · `pattern_coverage.py <ID>` → `Doc/verify/<ID>/pattern_coverage.csv`
    - 연결 근거: 손 기대 행 source 의 문서 번호 토큰(DM-84 등 · 일치 165 · 문서 아닌 토큰 4 = CR-095·데이터 'C-24') → 그 손 행 키를 자동 행이 재현하면 AUTO(P##) · 아니면 HAND · rule_ids 에 공통 검사기 있으면 RULE
    - 새 화면 검출 등급(06:00:06 실측 · 규칙 검사기 존재만으로 '검출'로 세지 않음): AUTO 31(4.1%) · RULE 212(28.3% · 문서 general_rule=Y + 규칙 실측 이력 D·E·F·F* · 규칙 단위) · 공통·미측정 18(2.4% · H6·K2·M4·H3·B5·F9·J3·M3 등급 C → W8-4 대상) · 화면고유 480(64.1% · general_rule=N) · 기계검출불가 8
    - 화면 적용표(06:05:01 · 56화면 × 29패턴): 적용·미측정 531 · 손행대체 27 · 권한 제외 15 · 미적용 1,051 — 측정 0 = 원장이 05:47 재생성보다 이전(38) 또는 원장 없음(18) · 다음 CheckList 부터 채워짐 · P27·P29 적용 화면 0
    - 검증 중 발견 판정 결함 **T55**(judge META I1/I4 가 E2E 실측 행을 덮어씀 → SCP0111 [자동] CN 건수 FAIL 이 CheckList v23 PASS) → judge.py META 대입을 method META 행에만 · 격리 사본 재판정으로 FAIL 유지 확인 · `_checker_defects.md` T55
- [ ] **W8-4 검출 입증 채우기** doc_proof 가 변이 시험(selftest) 결과를 읽게 수정 · C 등급(측정 0) 34개 규칙 실측 또는 사유
  - **11-05 진행(06:09~)** — ① doc_proof 가 selftest 를 못 읽던 결함: `selftest/*.csv` 만 찾았는데 실제 결과 = `checklist_selftest.json`(report[].kind·verdict) → 읽도록 교정 · 화면 주입 '미검출' 규칙 경고(C2 · SCP0007 10-28)
    ② 검사기 함수 변이(`_engine_gap.csv` build_status=변이입증 174항목) 반영 = **Fm**: 규칙 세부 항목(해당없음 제외) 전부 변이입증 + 실측 PASS 일 때만 — 처음 1개만 있어도 Fm 로 세던 판(입증 418행)을 폐기 · 일부 입증 32규칙은 D 유지(func_mutation k/n 열)
    ③ 실측(06:09:11): 입증 120→140행(18.7%) · 반쪽 422 · 미입증 179 · 불가 8 · Fm 7규칙(C1 K3 B1 L2 H11 DB-SYN A10) · C 15규칙
    ④ C 등급 원인 자동 분류 `_doc_proof_c.csv`(미실행·대상없음·경로오류·검사기없음·집계행·자동행대기) — 핵심: 미실행 = 공식 원장 E2E 가 규칙 행보다 낡음(00:58 SCP0111 새 실행본에선 H3·M3·M4·H6·A8·A9 PASS · J3 PASS+FAIL 실측됨) · B5 = 자동 검사기 없음(허용 목록 룩업) · K2(P30 12화면)·D2(P19 17화면) = 자동 행 대기
    ⑤ SCP0111 CheckList 정식 재실행 06:11 시작(자동 행 기본 켜짐·생성기 수정·judge T55 수정 첫 실측 겸 C 규칙 실측) — 결과 대기
- [ ] **W8-5 데이터 전제 프로필** `Doc/verify/<ID>/scenario_env.json`(사용 가능 Division·필수 조회조건·버전 팝업 · grid_rule/search 사실에서 생성) → 생성기의 user·cond 기본값 + 0행 ERROR 진단에 전제 표기
  - **11-05 구현(06:14)** — `scenario_env.py <ID>` → `Doc/verify/<ID>/scenario_env.json`(Division 조건·division.csv·users.json 영역 계정 Division·Division 고정·생성기 기본 Division·기본 계정 그룹/버튼 권한·필수 조회조건(기준표 O / AS-IS 라벨 *)·팝업 조건·Bucket·마지막 E2E 관측 최대 행/조회 0행 목록) · run_verify 가 gen_expect 직후 호출(실패 = 경고) · 시나리오 '조회 0행' ERROR 근거에 `[전제]` 한 줄(_verify.spec.ts envLine · 구문 검사 0) · 56화면 생성 · 관측 있는 화면 10(46 = e2e_results 없음)
    - 생성기 조건 기본값에는 미반영(필수 조건 공란이 0행 원인이라는 실측 없음 — 진단 근거 용도만) · 0행 사례 쌓이면 판단
  - **11-05 08:01 SCP0111 정식 CheckList v23 실측(06:11~08:01 · exit 10)** — 자동 9행 PASS 4 · FAIL 3(P02 CN 건수 'Total1,714rows' · P05 Insert 맨 끝 · P13 빈 행 저장 요청 1건 = 실결함 · T55 수정 뒤 CN FAIL 유지 확인) · ERROR 3(P12 BOH_QTY 입력 안 됨 · P18 W_ 칸 없음 · P19 편집 동적 칸 없음 = 생성 조건 정밀화 대상) · exit 10 = 회귀 오라클 위반 3(C4·H13·E1, 00:58 실행과 같은 3건 = 기존)
  - **08:02 doc_proof** 입증 277(37.0%) · 반쪽 367 · 미입증 97 · 불가 8 · C 규칙 15→8(K2·B5·D2·M2·C5·A3·F9·K5) — 변화 출처 = SCP0111 07:58·SCP0084 07:51(다른 세션) 새 원장
  - **13:30 남은 일 진행** — ① P12 `값@~edit`(편집기가 실제 열리는 첫 기존 행 · 행 단위 편집 칸 BOH_QTY=INV 행) ② P19 조건 없는 @DYN = 기존 행이면 다음 기존 행 50개까지 탐색(첫 행만 보고 ERROR) ③ P18 = AS-IS W_ 가드 아래 Visible 대입이 전부 false 면 제외(_w_hidden · SCP0111 cs:392 · 57화면 재생성 13:13 영향 SCP0111 1화면) ④ 회귀 오라클 3건(C4·H13·E1) = 10-30 등록 뒤 TO-BE 보완(백업 10-28→11-05)·07:58 실측 PASS → NOT_FAIL 회귀 감시로 전환(원 기대·비고 보존 · 백업 scratchpad) → regress 위반 3→0 ⑤ P12/P19 단독 재측정 = 동적 포트 고갈(13:26 TCP 16,552 · SMSNotifier 16,151)로 Chromium BE 연결 실패 → 미측정 · 회복 대기 자동 재실행 걸어 둠
  - **13:36** 회복 대기 1차가 netstat(Bound 미포함 184줄)로 잘못 통과 → 13:28 재측정도 ERR_CONNECTION_FAILED · run_verify 게이트 동일 결함 = T58 → Get-NetTCPConnection(Bound 포함 16,530) 기준으로 수정 · 대기 재설정(45회)

## 작업 로그(시각은 `date` 실측)
- 10-31 12:53 doc_proof 신설 · 감·예측 금지 룰 등록
- 10-31 12:59 SCP0111 저장 판정 근거 교정 확인(격리 실행: 202610 1,477→1478 Save call-proc 0건)
- 10-31 13:03 다중 탭 실측·ensureRows 메모 키 교정
- 10-31 13:07 문서 메뉴 일괄 + SCP0111 v22 + SCP0041 r12 시작
- 10-31 13:26 DMF0082 rc=6 → 원인 ledger.py F9 블록의 정의 전 sdir 참조(내가 WP9 에서 넣은 버그 · Bucket+저장 화면 원장 생성 불가) → 13:40 수정 · DMF0082 원장 1683행·F9 행 생성 확인
- 10-31 13:40 사용자 지시 반영: 실저장 진행 · 이 DB 는 ERP·메일 걱정 불필요 · 시간 무관 · 필요한 검증엔진 전부 생성
- 10-31 14:35 SCP0111 v22 오라클 9/9 위반 0(저장 FAIL 근거 = 기존행 수정) · SCP0041 r12 오라클 2/2 · Pack Hold 0행 원인 = 기간 칸 2개(Cutoff 미확대) → ensureRows 전 기간 칸 2년→5년
- 10-31 14:57 사용자 지적: 안 만들어진 엔진 일괄 생성이 먼저 → 일괄 중단 · engine_audit 신설 · 하위 항목 대조 착수
- 10-31 15:36 P0 교정 완료 · doc_proof 는 규칙 단위라 엔진 진행율 분모를 _engine_gap.csv(461항목)로 변경 · 측정 중 DMF 원장 재생성으로 doc_proof 값 변동(확정값 아님)
- 10-31 15:41 crudCycle 행 식별 교정: 앞 3칸 키는 유일하지 않아 원복이 다른 행에 들어갈 위험 → 행 전체 값 식별, 1건 아니면 원복 중단·보고
- 10-31 15:50 E05 기반 신설: db_snapshot.py · lib/savecheck.ts(변이 9/9) · F6/F7/F8 전용 행 · 저장 행 생성 조건을 golden → PROC_M 으로 교정(F7·F8 미생성 원인) · SCP0096 실저장: 행 수 불변 PASS · 감사 PASS · 원복 확인 · 잔존 = 수정 행 1건(감사 컬럼만 해당 여부 미확인)
- 10-31 17:05 저장 세부 프로브 신설(컬럼별 왕복·0 값) · SCP0096 D_ 왕복 OK · CL_FAKE_SAVE 변이로 값 불일치 검출 입증 · WORKING_TIME_DEFAULT 저장 요청 없음은 입력 경로 의심 → 키보드 입력 보강
- 10-31 17:10 사용자 결정 CR-094(Reset = 서버 저장본만 삭제·화면값 유지, SSP45REQ-12 예외) 등록 · 저장 세부 프로브 SCP0096 실저장: D_ 왕복 OK · 0 값 PASS · DB 값 원복 직접 조회 확인(WORKING_TIME_DEFAULT 1.0 · 20261031 N · 20261101 N, 감사 컬럼만 잔존)
- 10-31 17:28 잔존 측정: DMF0005·DMF0082 13:07 이후 0건 · judge 정지 원인 = asisMapping 빈 값 → nscm-fe 전체(node_modules) 탐색 → routePath 로 페이지 폴더(DMF0005 judge 70초 완료) · 빈 키 저장 생략 → 기존행 수정 저장 폴백 · E1 유효값 대조군
- 10-31 17:55 저장 세부: 컬럼 탐색 뒤 재조회(탐색이 남긴 상태가 입력을 막음 — 화면 결함 아님) · 왕복 2컬럼 PASS · 0·빈값 PASS · 2행 저장 구현(SCP0096 조회 1행이라 실측 대기) · judge 정지 해소 · 다음 = 2행 실측 화면 확보 → E05 나머지 → E02
- 10-31 19:32 SCP0028 저장 세부 잔존 사고 정리: 빈칸 셀 저장이 새 행 생성(LOT_SIZE·_H 각 1건) → 백업 후 삭제(cleanup_20261031_probe.sql · 이후 변경 0) · 빈칸 왕복 금지 · 사용자 지시: 오래 걸리는 것 분리 → run_verify --tier fast|slow(W4c = SCP0100 66분 중 33분·DMF0082 92분 중 31분 실측) · 자동 재개 설정
- 10-31 20:05 SCP0028 저장 요청 없음 4건 = 값 0 행 선택으로 화면 업무 검증에 막혔을 가능성(validateRows) → 사유 분류·0 아닌 값 우선·대기 20초 · 재측정 대기
- 10-31 20:46 사용자 승인 병렬 착수: 에이전트 E02·E03(새 파일만·실저장 금지·공용 변경은 Doc/verify/_parallel/E0x/integration.md 로 통합) · 메인 = E05·공용 통합 · 동시 E2E 상한 3 · 사용자 지시: 부하로 문제 시 병렬 중지(신호 = 로그인 401·ERR_CONNECTION·curl 000·HikariPool 타임아웃·Oracle 10055·부하 시간 초과)
- 10-31 21:20 SCP0028 저장 세부 완료: 실저장 왕복 4컬럼·0값·빈값·2행 PASS(21:10~21:15 · 원장 2행 원복 DB 확인 · 이력 12건은 왕복 기록) · CL_FAKE_SAVE 변이 왕복·2행 FAIL(21:15~21:19 · 잔존 0) · 교정: 알림 닫기 전 읽기·이전 토스트 제외·빈칸/0 칸 적은 행 우선·차단 시 재조회 대기 제거(테스트 13.9분→4분대) · 0·빈값 거부 판정 = AS-IS 저장 경로 같은 컬럼 메시지 대조 · 명령 경유 역슬래시 축약 주의(패치 파일은 역슬래시 없이)
- 10-31 22:40 저장 경로 시험 신설(가짜 응답·DB 무변경 · 저장 구간 요청 전부 가로채기 · 잔존 0 측정): 실패 문구·취소·붙여넣기 입증 · 로딩은 대조군 추가 · 교정: 저장 뒤 재조회까지 가짜로 끊어 오류 알림 발생 → 읽기 요청 통과 · 탐색 전 고정 해제 · 표본을 Node 왕복 → 브라우저 내 50ms
- 10-31 23:12 병렬 E2E 중지(사용자 지시 '부하로 문제 시 중지'): 22:48~23:01 E02 DMF0005 로그인 360초 초과 실패 · 23:10 CPU 100·chrome 32 · 원인 미확정(CPU 포화와 시각 겹침만 확인) · BE 응답 0.03초·HikariPool 8건 불변 · 앞으로 E2E 는 메인 1개 순차 · 에이전트는 코드·정적만 · 주의: 22:51~ 메인 DMF0005 신규행 시험과 E02 DMF0005 가 같은 화면 동시 실행(양쪽 쓰기 없음, 잠금 미사용 — 재발 금지) · E02 보고: 변이입증 4·구현 16·미완 45(Doc/verify/_parallel/E02/status.csv) · 통합 대기 · 팝업 ORDER 차이 = 기존 결정대로 ORDER BY 없음만 FAIL·기준 차이 판정필요로 통합
- 10-31 23:25 E03 보고: 변이입증 1·구현 21·불가 2·미완 16(_parallel/E03/status.csv) · E02·E03 의 구현·변이입증 42항목 = build_status 통합대기(공용 통합·메인 재측정 전 입증 아님) · 결함 후보 PKG_SYS0011 본체 INVALID 직접 확인(PLS-00323 P_SYS0011_GET_AUTH_DATA · LAST_DDL 10-31 21:52:43 · 원인 미확인 · 보완 금지 단계) · 에이전트 종료 후 CPU 100→30(23:24) · 병렬 재개 금지 유지
- 11-01 00:02 신규행 검증(EG158·EG162): DMF0005 Division 시트 5개 전환·필수 입력 OK · 대조군 막힘(Team 라벨→TEAM_NAME 채워도 같은 문구 · Project Code 그리드 라벨 없음) → ERROR 사유 기록 · 시간 28.1→5.3분 · 팝업 입력 경로는 E02 통합 때 재측정 · DMF0004·DMF0048 로 검사기 검증
- 11-01 00:55 공용 closeAlert 정지 결함 교정: isVisible 뒤 알림이 닫히면 시간 제한 없는 click 이 시험 제한까지 정지(DMF0004 30분) → click 5초 제한 · 신규행 검증에 셀 팝업 채우기·탭 탐색·다른 컬럼 문구 ERROR 추가
- 11-01 01:15 E02·E03 체인 통합: eg_chain.py(--tier all|slow 화면 잠금 안에서 팝업·권한 실행) + eg_ingest.py(결과 → 원장 EG- 행·e2e_results) · DMF0005 시험 반입 108행 → judge 통과(복원) · 판정필요는 기존 지시대로 W7 NA · 정렬 차이만 판정필요 유지 · EG109 FAIL 2건 재측정 전 불신(E03: 대기 부족 의심) · facts 출력 위치 _parallel 유지(이전은 후속)
- 11-01 02:25 SCP0028 전체 체인 1회 완주(01:14~02:16 · rc 10 E3 SUSPECT · FAIL 179 · EG 행 229 · 회귀 위반 0) · 허위 FAIL 공통 원인 교정: findCond 표시 잔존 '칸 없음' · Insert 대화상자 = ERROR · 표본 업무 검증 차단 = ERROR · 콤보 표시↔코드 대응 · 팝업 Division 이름 대조 · 대상 칸 대응 없는 PICK_OK = ERROR · 전용 행 규칙 집계 제외 · 재측정 대기. 실제 결함 후보: Reset 화면값 삭제(G3 CR-094)·Viewer Delete 노출(J2 CR-070)·MSG00031 재사용(MS1)·저장 중 로딩 0회(H11)
- 11-01 03:35 입력 검증 저장 신설(inputcheck.ts · 쓰기 전부 가짜 응답): SCP0096 음수 PASS · DMF0005 콤보 키인·붙여넣기 18 PASS·56 NA(다른 Division) · 18.9분 · Division 순회·클립보드 되읽기 보강 · DB 대조 EG235·237·240 변이입증
- 11-01 03:58 기간 동적 컬럼(EG043) dynperiod.ts · 경계값 EG210 · 응답 시간 EG415 · SP 문구 대조 EG161 · 허위 교정: 접두별 판정·주 번호 순서 제외
- 11-01 04:58 EG006 a1_live.py · EG255 텍스트 필터(SCP0028 Model 요청 값 없음 FAIL 후보) · EG096 C4 확장(SCP0111 Plan Date FAIL 재현) · 사고: a1_live 가 golden.py import → 스크립트 전체 실행 · GET 만 실행(저장 SKIP) · Doc/golden/_summary·SCP0007 산출물 재생성 · 함수 내장으로 교정 · 재발 금지: import 전 모듈 최상위 실행 확인
- 11-01 06:53 ⛔ 실행 중단: 소켓 고갈 재발 — WinError 10055 · TCP 16,553 중 SMSNotifier(PID 9336) 16,167 · Bound 16,276 · BE curl 000(06:53:15) · HikariPool 로그 8→98 · 임의 종료 금지(사내 보안 에이전트, reference_socket_exhaustion_smsnotifier) → 사용자에게 재시작·재부팅 요청 · 그동안 E2E·DB 불가 · 복구 뒤 BE·FE 기동 확인 후 재개
- 11-01 19:41 재부팅(19:12) 후 복구: TCP 1,050 · BE 401·FE 200·DB 응답 · run_verify E2E 전 소켓 수 점검(14,000 이상 rc 5) · SCP0028 --tier all 재실행으로 그간 수정 통합 확인
- 11-01 21:29 신설: 합계 값 EG018 · Division 컬럼 EG029 · 조회조건 겹침 EG270·321·324 · Excel EG420·421 · SP 쓰기 대조 EG238·230·223 · 다국어 정적 EG451·356·364 · SCP0028 전체 체인 FAIL 179→76(19:43~20:40 · 회귀 위반 0 · 원장 2행 원복 DB 확인) · 결함 후보: INCREMENT 음수 저장 요청·Viewer Delete 노출·Reset 값 삭제·저장 중 로딩 0·Model 조건 미전송·1366 폭 넘침·DMF0005 Div 컬럼 누락

- 2026-11-01 23:17 EG085 변이입증 — DMF0003 셀 초기화 14건 PASS 8·ERROR 6 · DMF0004 8건 ERROR · probe.pickGrid(하위 시트 그리드 지정)·seedCell(표시 전용 칸 이전 값) 신설 · 메타 시트·Division 순회. EG059 DMF0005 기존행 PASS 9·판정필요 5(22:34).

- 2026-11-01 23:52 EG092 변이입증 — C3 채운 값 대조(AS-IS 칸 복사·같은 원천 기존 행) · DMF0005 PASS 15·ERROR 5·판정필요 4 · SCP0007 PASS 6·판정필요 2 · 그리드 컬럼 프로브 시험 제한 480→900초(DMF0005 시간 초과 실측 8.9분).

- 2026-11-02 00:05 EG066 변이입증 — lookup_check.py 신설(코드=SEGMENT1 · 다른 원천 섞이면 ERROR) · DMF0082 PASS 1·ERROR 2 · DMF0005 ERROR 2 · 원장 B5 행 반입 확인.

- 2026-11-02 00:27 EG392·EG021 변이입증 — 컬럼 설정 팝업 K2 전용 3행 · DMF0082 PASS 3 · SCP0028·DMF0005 는 AS-IS 기능 없음(대상 제외).

- 2026-11-02 00:33 EG055 변이입증 — Active 정책 판정 · DMF0005·SCP0007 셀 콤보 PASS · 조회조건 판정을 확정 규칙 대상으로 한정(From/To Site 허위 FAIL 교정).

- 2026-11-02 00:38 EG034 변이입증 — sort_ci_check.py · 5개 화면 실측 · 판정필요 태그 · _trace cmp 대소문자 무시.

- 2026-11-02 00:51 EG361 변이입증 — 언어 전환 문구 대조 · DMF0082 CN 'Condition' 미번역 후보(결함 기록만) · LANG_CD 원복 확인.

- 2026-11-02 01:02 EG084 변이입증·EG106·EG020 구현 — 대조표 핸들러 탐색 결함 교정(events.csv this. 접두 · 결함 유형 후보: 사실 파일 간 표기 차이로 조건 전부 비어 재요청만 판정).

- 2026-11-02 01:22 EG081·EG057 변이입증 — 상위 값별 하위 후보 AS-IS 대조 · DMF0005 PASS 3·판정필요 3.

- 2026-11-02 01:38 EG088 구현(변이 입증 미완) — 셀 연쇄 후보 AS-IS 대조 · 분기 선택 미평가 한계 기록.

- 2026-11-02 01:51 EG012·EG227 변이입증 — 편집기 표시값·다른 셀 편집 값 유지 · SCP0007 PASS · DMF0005 ERROR(대상 칸 없음).

- 2026-11-02 02:08 EG019 구현(실측 대상 화면 0 — 미측정) · 검사 경로만 준비.

- 2026-11-02 02:41 EG453 구현 — Measure 기준 코드 유사 표기·미사용 점검(화면·전역) · 전역 결과 CheckList 미연결.

- 2026-11-02 03:10 EG040 구현 — golden 복합 키 값 대조 · SCP0007 REVIEW 33컬럼(일련번호 키 데이터 차이 의심 · 미확인).

- 2026-11-02 03:41 EG179 구현 — 저장 SP 분기 리터럴 대조 · DMF0082 SAVE_MAIN_DATA 22건 확인 대상 · 분기 실행 비교 미구현.

- 2026-11-02 04:13 EG187 구현 — 월 Bucket 합계 시험 · DMF0082 편집 가능 월 칸 없음 ERROR · 실저장 경로 미실측.

- 2026-11-02 04:55 EG100·EG139·EG388·EG201 구현 — 필터 상태 Insert PASS · 정렬·붙여넣기 측정 경로 미해결(ERROR) · 붙여넣기 대조군으로 허위 PASS 제거.

- 2026-11-02 05:16 EG410 변이입증 — K4 여분 기능 버튼 · SCP0028·SCP0100 PASS.

- 2026-11-02 05:48 EG245 변이입증 — 텍스트 조건 부분일치 · DMF0005 Model/Nickname·Owner PASS · 한글·영문명 동수 미측정.

- 2026-11-02 07:17 통합 점검 SCP0028 전체 체인(06:13~07:15 · rc=10 SUSPECT_NA100 · FAIL 76·ERROR 85·PASS 576·NA 919·판정필요 26 · 회귀 위반 0) · 잔존 LOT_SIZE 수정 2·_H 신규 14 · 전용 행 FAIL 계약 근거(결함원장) 교정 · 언어 버튼 클릭 재시도.

- 2026-11-02 08:29 SCP0028 2차 체인(07:23~08:25 · rc=10 · FAIL 83·ERROR 72·PASS 582·NA 918·판정필요 26 · 회귀 위반 0 · 잔존 30) · 전용 FAIL 10 중 허위 2(D6 Insert 빈 구현·L1 덮어쓰기) 교정(재측정 대기) · EG 행 근거 추가 · T28~T32 등재.

- 2026-11-02 08:38 EG456·EG352 변이입증 · EG027 구현 — 표시 묶음 · 3화면 센티널·천단위 PASS · 컬럼 순서 2화면 확인 대상.

- 2026-11-02 08:55 통합대기 승격 — E02·E03 검사기 체인 연결 확인(SCP0028 2차 체인) · {'구현': 37, '체인 판정 없음': 42, '변이입증': 5} · 전 화면 재측정은 W 단계.

- 2026-11-02 08:56 승격 근거 교정 — 체인 판정 있음 20/42 · 나머지는 SCP0028 대상 아님 또는 미측정(W 단계에서 재측정).

- 2026-11-02 09:08 EG142·EG143 변이입증 — PKG_DMF0082·PKG_DMF0003 TB_FX_USER 참조 후보.

- 2026-11-02 09:20 EG379·EG332·EG381·EG272 변이입증 — 화면 틀 · 돋보기 입력칸 밖 2화면 후보.

- 2026-11-02 09:27 사고·복원 — 컬럼 설정 시험이 minyonglee1 DMF0082 개인화 40→20행 덮어씀(09:24) · flashback 09:21 기준 40행 복원·차이 0 · 복원 전 백업 scratchpad · 시험 수정: 개인화 있으면 저장 미실행 · T33.

- 2026-11-02 09:35 2차 사고·복원 — 컬럼 설정 시험 재실행이 09:33:27 다시 40→20행 덮어씀 · flashback 09:30 기준 40행 복원 · 시험: 개인화 있으면 Save 일절 미실행으로 교정.

- 2026-11-02 10:28 EG260·EG070·EG262 변이입증 — 선택 조회 · DMF0005·SCP0007 PASS 6 · 시간 초과 전 읽기 허위 FAIL 3 교정.

- 2026-11-02 10:55 EG013·EG345·EG343·EG346·EG350 변이입증 — Excel 다운로드 파일 내용 대조.

- 2026-11-02 11:31 EG363 구현 — 언어 전환 뒤 그리드 칸 한글(DMF0005 3언어 15,674행). 11:02 'CN 한글 0 PASS' 는 0행 측정에 의한 허위였음 → 행 수 기록·0행 ERROR. Wijmo 평가판 문구가 언어 버튼을 덮어 좌표 클릭 실패 → DOM 클릭.

- 2026-11-02 12:07 EG318·EG099·EG317·EG314·EG219 변이입증 · EG215·EG203 구현 — 병합 셀 시험(저장 없음·Delete 요청 차단). 후보 결함: DMF0049 병합 칸 입력이 21행 중 2행에만 반영. 붙여넣기 경로 미확인.

- 2026-11-02 12:32 EG174·EG108 변이입증 · T35(헤드리스 Ctrl+V 이벤트 0건 → probe.pasteText 통일). 붙여넣기 그리드 API 로도 DMF0049 콤보 칸 미반영(원인 미확인 · 후보).

- 2026-11-02 12:38 EG399 변이입증 · EG025 구현 — titleset_check(읽기 전용). DMF0082·DMF0021 이관 누락 후보(개발 DB 기준 · 원천 일치 미확인).

- 2026-11-02 13:05 EG009·EG017·EG390 변이입증 · EG458 구현 · D6 정렬 경로 교정(F3 스위치 · CR-034). 붙여넣기 API 진단: DMF0049 부서 칸 pasting 받고도 값 유지(원인 미확인 후보).

- 2026-11-02 13:20 EG201·EG405·EG326·EG327·EG459·EG254·EG263·EG419 변이입증 — 붙여넣기 경로 교정(T35·T36)·레이아웃 묶음.

- 2026-11-02 13:45 EG328·EG333·EG325·EG252·EG291·EG386·EG387 변이입증 · EG371·EG400 구현 — 후보 결함: DMF0040 소분류·대분류 라벨 'Spec' 잘림 · DMF0003 Project(S Report).

- 2026-11-02 T37 SQL 주석 제거기 교정(6개 도구) · PKG_DMF0082·PKG_DMF0003 TB_FX 후보 허위로 철회 · EG076·EG247 구현(Team 원천 정적).

- 2026-11-02 15:46 SCP0028 체인(13:50~15:22 rc=10 · 회귀 위반 0 · FAIL 90·ERROR 70) 뒤 교정: 전용 행 TAG 우선 병합(T32 재발) · 쓰기 차단 공용화(probe.blockWrites) · E3 수정 저장형 경로(숫자 칸 빈 값 미인식 = 측정 불가 표기) · save_residue 15:29 이후 0.

- 2026-11-02 15:51 EG191 변이입증 · EG358·EG461·EG236 구현 — F10 전 깊이 추적·사전 중복 전역 스윕.

- 2026-11-02 원장 대조: 코드에 번호가 있는데 미착수로 남은 63건을 구현으로 정정(E02 팝업·E03 권한 병렬 작업분) · 항목 단독 입증은 W 단계 재측정. 현황 {'미착수': 167, '구현': 161, '변이입증': 86, '해당없음': 47}.

- 2026-11-02 16:31 EG153 변이입증 · T38 · 후보 결함: DMF0014 필수 칸 빈 업로드 ORA-01403(HTTP 500) · 시험 스테이징 행 자동 정리 도구 excel_stage_clean. 현황 {'미착수': 157, '구현': 164, '변이입증': 93, '해당없음': 47}.

- 2026-11-02 17:06 EG283·EG344·EG385·EG404·EG416·EG274 변이입증 · EG149·EG151·EG439·EG443 구현 · 현황 {'미착수': 147, '구현': 168, '변이입증': 99, '해당없음': 47}.

- 2026-11-02 17:37 EG206 변이입증·EG014 구현 · 현황 {'미착수': 137, '구현': 177, '변이입증': 100, '해당없음': 47}. 체인 회귀 확인 DMF0005 시작.

- 2026-11-02 20:02 사고 복원: 저장 세부 시험이 타 사용자 행(40·Peopleworks_KR_KUM·ECE0074N5-01) CUST_GROUP·SALES_PLAN_ADJUST_YN 변경 후 원복 실패 → 18:58 flashback 값으로 복원·시험 이력 1건 삭제 · T39. 같은 시각 SITE_ITEM 68행(82·ABB_US_4CP 17:53)은 로컬 BE 로그에 없음 — 다른 PC 저장으로 보여 미변경.

- 2026-11-02 21:40 restore_touched 신설(selftest 4/4 · DMF0005 실저장 뒤 행 완전 복원·잔존 0 · run_verify 연결) · DMF0005 체인 17:39~21:17 rc=10 회귀 위반 0 · 체인 시간 3h38m(_verify·_trace 120.6분 · 나머지 대부분 eg_chain) — 39메뉴 일괄 전 단축 검토 필요.

- 2026-11-02 22:34 잠금 조건식 정규화 강화(CAppSetting 상수·IsNullOrEmpty·==true · DMF0005 RAW 1094→128) · 하단 그리드 시트 측정 경로(Purchase 218행 탭 실패 0). 현황 {'미착수': 134, '구현': 180, '변이입증': 100, '해당없음': 47}.

- 2026-11-02 23:01 EG454·EG428·EG110 변이입증 · EG348·EG105 구현 · 현황 {'미착수': 129, '구현': 182, '변이입증': 103, '해당없음': 47}.

- 2026-11-02 23:05 EG282 구현(고정 플래그 대조) · 현황 {'미착수': 128, '구현': 183, '변이입증': 103, '해당없음': 47}.

- 2026-11-02 23:22 EG409 변이입증 · EG026·EG246·EG435 구현 · 문서 노출 기준표 doc_ui_expect.csv · 현황 {'미착수': 120, '구현': 190, '변이입증': 104, '해당없음': 47}.

- 2026-11-02 23:36 T40 템플릿 정규식 소실 3곳 교정·lint_tpl_regex · EG458·EG026 변이입증 · 현황 {'미착수': 120, '구현': 188, '변이입증': 106, '해당없음': 47}.

- 2026-11-03 00:33 EG455 master_sweep 신설·체인 연결(17/17) · EG003·EG037 a1_live 행 구성(13/13)·실사용자 직접 실행·인자별 전체 값 해석 · 결함 후보: PKG_DMF0003 5845~5847 P_AS_YN 을 권한 값으로 덮어써 체크박스 무시(2026-08-25 주석 · Y/N 모두 1738행 · AS-IS Y 6행/N 1041행) · 현황 {'미착수': 117, '변이입증': 109, '구현': 188, '해당없음': 47}.

- 2026-11-03 02:13 EG310·EG002·EG393·EG077·EG016 변이입증 · EG005 구현 · 후보: DMF0021 Daily 지난 칸 머리글 구분 없음 · SMSNotifier Bound 소켓 10,966(01:49) · 현황 {'미착수': 111, '변이입증': 114, '구현': 189, '해당없음': 47}.

- 2026-11-03 02:56 EG351·EG053·EG213 변이입증 · EG183·EG241 구현 · 신규 도구 display_sort_check·all_cols_check · 후보: DMF0048 전 칸 선택 ORA-00960 · 현황 {'미착수': 106, '변이입증': 117, '구현': 191, '해당없음': 47}.

- 2026-11-03 03:38 EG423 변이입증 · EG209·EG165·EG207 구현 · EG208·EG329·EG331 변이입증 · excel_stage_clean Division 접미 PROGRAM_ID 교정 · 현황 {'미착수': 99, '변이입증': 121, '구현': 194, '해당없음': 47}.

- 2026-11-03 04:11 공용 문서 시나리오 시험(scenario.ts · scenario_expect.csv) · EG094·EG120 변이입증 · EG150·EG155 구현 · 후보: DMF0042 신규 행 있어도 Bucket 변경됨 · DMF0020 MSG01430 FE 부재 · 현황 {'미착수': 93, '변이입증': 125, '구현': 196, '해당없음': 47}.

- 2026-11-03 04:51 EG305 변이입증 · EG156·EG305 DMF0082 측정 경로 미해결 · EG167·EG157 변이입증(source_expect.csv) · 현황 {'미착수': 89, '변이입증': 128, '구현': 197, '해당없음': 47}.

- 2026-11-03 05:25 EG398·EG349·EG047 변이입증 · T42(getCellData≠화면 글자) · 현황 {'미착수': 86, '변이입증': 131, '구현': 197, '해당없음': 47}.

- 2026-11-03 05:42 EG258·EG279·EG249 변이입증 · 시나리오 reqhas·dbl:@FIRST 추가 · 현황 {'미착수': 83, '변이입증': 134, '구현': 197, '해당없음': 47}.

- 2026-11-03 06:10 EG048·EG429·EG438 변이입증 · EG211 구현 · 현황 {'미착수': 79, '변이입증': 137, '구현': 198, '해당없음': 47}.

- 2026-11-03 07:05 사용자: 버튼 GROUP MENU 데이터를 클라우드 운영데이터로 UPDATE 함 · 버튼 노출 판정은 재측정 대상 · EG121·EG130 대조군 실패로 구현 유지 · 현황 {'미착수': 77, '변이입증': 137, '구현': 200, '해당없음': 47}.

- 2026-11-03 07:48 EG354 변이입증 · pickFromPopup(Version 팝업 조건) · DMF0040 실적 구간 색 PASS · DMF0049 viewRange c-1 프로브 한계 ERROR · 현황 {'미착수': 76, '변이입증': 138, '구현': 200, '해당없음': 47}.

- 2026-11-03 08:07 EG041·EG098·EG417 변이입증 · 현황 {'미착수': 73, '변이입증': 141, '구현': 200, '해당없음': 47}.

- 2026-11-03 08:18 EG276 변이입증 · EG306 구현 · 시나리오 labelorder·popopen 추가 · 현황 {'미착수': 71, '변이입증': 142, '구현': 201, '해당없음': 47}.

- 2026-11-03 08:26 EG080·EG233·EG241·EG052 변이입증(소스 대조 포함) · 후보: PKG_DMF0003 OWNER→SSO DEPT 경유 후보 2곳 · 현황 {'미착수': 68, '변이입증': 146, '구현': 200, '해당없음': 47}.

- 2026-11-03 08:52 EG234 변이입증 · EG192·EG189 구현 · 현황 {'미착수': 65, '변이입증': 147, '구현': 202, '해당없음': 47}.

- 2026-11-03 08:59 사용자 지시 CR-095 등록: DM Excel Form = 팝업 조회 없이 다운로드만 · EG426 PASS 철회 · 현황 {'미착수': 64, '변이입증': 147, '구현': 203, '해당없음': 47}.

- 2026-11-03 09:03 CR-095 교정(사용자): Excel Form 팝업 기본 · 팝업 없이 양식 생성 후 자동 조회도 오류 아님 = 사용자 판정 · judge 표식 보존.

- 2026-11-03 09:09 EG426 변이입증(CR-095) · DMF0082 팝업 PASS · DMF0074·DMF0014 사용자 판정 · 현황 {'미착수': 64, '변이입증': 148, '구현': 202, '해당없음': 47}.

- 2026-11-03 09:47 EG118·EG131·EG046 변이입증 · EG045 구현(과거 버전 측정 불가) · 현황 {'미착수': 60, '변이입증': 151, '구현': 203, '해당없음': 47}.

- 2026-11-03 10:05 E2E 차단: 09:44 공통 소스 병합 적용 뒤 packages/shared/src/hooks/useTabBtnPermissions.ts 가 3-way 충돌 → 로컬 유지(결정 대기)라 hasButtonDef 없음 · DataGrid.tsx:697 호출에서 화면 오류(DMF0020 09:53 실측) · 09:45 이후 E2E 결과는 무효로 본다(EG045 09:46) · 검증 단계라 FE 미수정 · 현황 {'미착수': 60, '변이입증': 151, '구현': 203, '해당없음': 47}.

- 2026-11-03 10:17 사용자 승인으로 useTabBtnPermissions.ts 공통본 수동 병합(로컬 divisionId + 공통 hasButtonDef·시트 단위) · DMF0020 정상 복구 실측 · BE 에 mnuBtnDefs·mnuBtnAuthSheets 없음(git grep 0) → hasButtonDef 항상 false 라 SAVE 자동 잠금·버튼 게이트 미작동 · 사용자 지시: 이전 측정은 다시 돌리지 않고 엔진 생성 뒤 필요 시 전체 검사 · 현황 {'미착수': 59, '변이입증': 152, '구현': 203, '해당없음': 47}.
- 11-03 11:38 시나리오 단계 신설 exists/noload/tab/gridcols/seek/anyhas/val/gridcands + 표 user 열(명부 계정 전환): EG413 변이입증(SYS0016 리치 편집기) · EG302 구현(DMF0014 로딩 토스트 0) · EG127 변이입증(DMF0004 Rep 기본값 Y/N 양쪽) · EG083 측정 중(DMF0082 FCST Type 후보 Div 40 W/S 제외 · Div 81 W/S 계정 서버 콤보 대조) · BE 로그 HikariPool-2(MSSQL 165.244.95.223:1433) 'Pool is empty' 09:12 부터 65초 간격 124회 = AS-IS MSSQL 접속 시간 초과(Oracle 풀 아님 · E2E 영향 없음 · 보고)
- 11-03 12:06 데이터 계층: EG015/EG430 DM-204 복합 문구 9분할(SYS0017·SCM0007, ledger SPLIT 제외) · EG031 DD-212(SYS0002 Group 미추가 확정)·DM-196 재분류 · E2E 묶음 실행 중(DMF0005 GAP-72·samekey 변이 → DMF0042/DMF0068 insertat → SYS0015 M+I → DMF0082 W/S 재측정: 문서 'W/S' ≠ DB 명칭 'WS(Chargeable)' 검사기 정규식 교정)
- 11-03 12:52 묶음 2·3 결과: EG204·EG141·EG011·EG083·EG075 변이입증 / EG090·EG089·EG196·EG154 구현 · 신설 combo_live_check.py(B7) · 단계 추가 type@조건/cell/samekey/insertat/clickrow/fmt/review/setcell/nonehas/nomsg/weekedge · 표 user 열 · SYS0015 메뉴 USE_YN=N 확인(화면 진입 불가)
- 11-03 13:02 묶음 4: EG114(GAP-38 경계)·EG090 변이입증 · EG154 판정필요 경로 확인 · 신설 dynlock(D2 Bucket×Measure · 조회 응답 부가셋 O_RC2.M3_CUTOFF_DATE 경계)·paste·@cand/@row 토큰 · 묶음 5 실행(SCP0007 조회 전 Insert · DMF0005 Team 붙여넣기 · SYS0017 Receiver/Message · DMF0082 dynlock 3건)
- 11-03 13:35 신설 measure_by_site_check.py(B5 · EG068 변이입증)·dbq.py+dbcell 단계(DB 원천 대조) · EG132 구현 · 묶음 5: SCP0007 City FAIL 은 검사기 기대 오류(마스터 CITY NULL) → dbcell 로 교정 · 묶음 6 실행 중(SCP0007·DMF0005 붙여넣기·SYS0017 Receiver·DMF0003 값 있는 셀·DMF0044 dynlock·DMF0082 dynlock)
- 11-03 14:06 신설 bg_style_check.py(H2 정적 존재 게이트 · EG312) · _trace E4 인자 전개(EG164) · download(EG347)·rail(EG311) 단계 · EG355/EG226 은 전용 시험 계정 승인 필요(미착수 유지) · EG163 다음 단계 · 묶음 6 실행 중
- 11-03 14:18 묶음 6: SCP0007 City=DB PASS · DMF0003 값 있는 셀 PASS(EG107/117) · DMF0005 Team 붙여넣기 코드 미동반 FAIL(DM-18 결함 후보) · SYS0017 Receiver 탭 버튼 오인(사이드 메뉴) → 정규식 교정 · DMF0044 조회 0행 → Year 조건 추가 · DMF0082 dynlock 부가셋 수집 위치(j 최상위)·W 주 경계 모드 교정 · 묶음 7 실행
- 11-03 15:45 묶음 8: DMF0005 DM-70 PASS(EG172) · DMF0021 rail PASS · DMF0004 다운로드 PASS(EG347) · DMF0042 FAIL 은 @row 토큰이 신규 빈 행을 읽은 측정 오류 → 토큰 교정(값 있는 기존 행) · DMF0082 drop1 미수집(100행 상한) → 상한 2000·3행 보관 · 부하: CPU 100%(보안 에이전트 ASDSvc 등 · 15:10) 원장 재생성 화면당 4~8분
- 11-03 재부팅 중단: 묶음 10(DMF0042 자동 입력·SYS0002 SSO 부서·SYS0017 Receiver·DMF0082 M+3/판가) 실행 중 중지 — 결과 없음, 재개 시 scratchpad run_batch10.sh 와 같은 4건부터 재실행 · 시나리오 저장은 route 가짜 응답이라 DB 잔존 없음 · 원장 집계(15:45) 미착수 27 · 구현 222 · 변이입증 165 · 해당없음 47 · 재부팅 뒤 BE(gradlew.bat bootRun)·FE(vite.cmd 5173) 기동 필요
- 11-03 17:21 재부팅 후 묶음 10·11: DMF0042 DM-92 Team·End Customer 자동 PASS · Energy(WH) 빈값 ≠ DB 19.100 FAIL(결함 후보) · DMF0082 Monthly MKT_FCST 행 3 표본 5칸 전부 잠김 → dynlock 판정을 '전부 잠김 = 확인 대상'으로 교정(행 단위 잠금 가능성 · 허위 FAIL 방지) · SYS0002 팝업 로딩 대기·SYS0017 라벨 다음 입력칸 교정 · M+3 경계는 drop1 스트림 미수집으로 당월+3 계산 대체
- 11-03 17:33 SYS0017 DM-234 Receiver PASS(EG217·EG097 구현) · SYS0002 DM-189 SSO 부서 자동 없음 FAIL(결함 후보 · EG103) · DMF0082 dynlock 표본 전부 잠김 → 확인 대상 ERROR(EG112 구현 · 다음: measureAuth EDIT_AUTH_YN=Y 행 표본)
- 11-03 17:42 realsave 단계 신설(EG216 구현) · 1차 자동 복원 실패(키당 2행 · T43) → ROWID 수동 복원·잔존 0 → restore_touched 다행 복원 보강 → 재실행 PASS·자동 복원·잔존 0
- 11-03 18:13 DMF0003 기존 행 수정 저장 Project Code 필수 오탐 FAIL(EG168 구현 · DB 빈 행 0/200000) — 이 차단으로 일자 분배 저장 본문(GAP-7·GAPPI-4) 구조 확인 불가 · @DYN 토큰 = 편집 가능 첫 동적 칸으로 교정 · 행 조건 &칸=정규식 추가 · savedump 단계
- 11-03 18:38 savechk 단계 신설 — DMF0082 Div 40 DM Admin: Weekly 주 입력 → 월요일 1일 전량 PASS·변이 FAIL(EG243 변이입증) · Monthly 3100 → 5일 분배 합계 보존 PASS(EG228 구현 · T44 교정) · EG198 구현 · 시험 계정 minyonglee1 은 Div 40 Weekly MKT_FCST 40행 편집 칸 0(18:26) — 명부 DM Admin 계정 사용
- 11-03 18:45 GAP-443 LOC 월 칸: 저장 본문에 월요일 이전 일자(20261101) 포함이나 저장 SP 13571행 월요일 이전 제외 식 → 본문 기준 FAIL 철회·판정필요(DB 실저장 대조 필요) · VMI_In_Req Div 40 행 없음 ERROR · savechk min/@thismon 추가
- 11-03 19:14 restore_touched 명부 계정(E2E_RESTORE_ACCOUNT)·생성 행 삭제 보강 · save_residue --account · dbcount 단계 · GAP-443 실저장 PASS(월요일 이전 0·이후 5 · 복원·잔존 0)
- 11-03 19:18 DM-218 LOC 실저장 → Sales Price 15행 동기화 PASS(EG232·EG180 구현) · 복원·잔존 0
- 11-03 20:10 realsave 신규 행 지원(키 채워진 행만 · 복원기 AS OF 부재+시험 계정 생성 행 삭제) · restore_touched 표별 키(table_keys) · DMF0004 cleanup_spec 사이트 원장 6표 추가(백업 scratchpad cleanup_spec.bak.json) · combohas 단계 · DM-10~12 PASS·잔존 0
- 11-03 21:13 formsave 단계 신설 · DMF0082 Div 81 Excel Form 템플릿 조회 0건(본 조회 388행) → 양식 다운로드 불가 · 확인 대상(P_DMF0082_GET_EXCEL_FORM_DATA 직접 실행 예정) · 업로드 실저장 경로(EG185·EG424·EG250) 여기서 막힘
- 11-03 21:40 DMF0082 Excel Form 0건 원인 = 81 계열 최신 SP_W 컷오프 스냅샷(DM_PLN_SALES_PLAN_C) 0행(SP_W_20261028~30) · 마지막 적재 SP_W_20260827_V001 5,709행 — 데이터 원인(화면 결함 아님) · 업로드 실저장(EG185·EG424·EG250) 데이터 적재 전 측정 불가
- 11-03 22:18 EG001 구현 — DMF0004 GAP-49 PASS(비활성·소문자 국가 키 이름 표시·대소문자 다른 키 거래처 2행) · rowcnt·rowhas 단계 · anyhas 행 상한 500→5000 교정
- 11-03 23:15 EG205 DMF0049 조회 0행(SP Version R_S_20260823_V003)으로 측정 불가 · 루프 중단 — 남은 16건은 데이터 적재(81 계열 컷오프 스냅샷·DMF0044/0049 조회 0행)·전용 시험 계정·업무 결정(GAP-265)·editonly 화면 복원 키(DMF0021/0042/0043/0044/0074) 필요
- 11-04 06:03 정정(사용자 지시: DMF0042·DMF0044·DMF0049 = Division 40 전용) — 11-03 23:15 'DMF0044/0049 조회 0행 = 데이터 적재 필요' 보고는 원인 오인. 실측: ① 세 화면 시나리오가 기본 계정(다른 Division)으로 돌았음 → scenario_expect user=`Div=40;DM Admin`(hongjae.kim) 10행 지정 ② Div 40 에서도 0행이던 원인 = 필수 Version 미선택(DMF0044 BP Version·DMF0049 SP Version) + DMF0044 팝업 최근 BP 버전(R_B_20261028_V002 등 12개) 리포트 표 2026 데이터 0행(DM_PLN_SALES_PLAN_REPORT_C · 데이터 있는 최근 = R_B_20260814_V001 94,045행 · 06:01 DB). DMF0042 Div 40 7,568행 조회 · 결과 동일(GAP-265 FAIL 결정 대기 · DM-92 Energy 결함 후보). DMF0044·0049 재실행 06:02~.
- 11-04 06:15 EG115 변이입증(DMF0044 Div 40 Business_Plan·LOC 전 구간 편집 PASS · 변이 FAIL · MKT_FCST 대조군 표본 0) · EG205 구현(DMF0049 BIZ_TYPE 붙여넣기 미반영 FAIL · 직접 입력·후보 밖 거부 대조 PASS → DM-99 결함 후보) · 시나리오 = 필수 Version 팝업 선택 단계 추가(DMF0044 BP·DMF0049 SP)
- 11-04 06:25 EG144 변이입증 — 신설 srvblock(서버 검증 차단 실측: 본문 한계 초과 값 있을 때만 서버 전송) · DMF0044 21자리 → PKG 자릿수 차단 문구 PASS · 변이 FAIL · 잔존 0 · 한계: Max 값 실저장·계산값 초과 문구 미측정
- 11-04 06:55 EG457 구현(DM-143 Div 40 판가 없는 주차 저장 차단 PASS · 대조 판가 있는 행 저장=FAIL 검출) · 시험 오류 1건: 행 조건에 PROJECT_CODE 없어 판가 있는 GREENWAY LEV 행을 실저장 → 파생 행 2건 잔존 → 즉시 삭제(06:50 잔존 0) · 복원기 T45 교정(생성자 기준 포함)
- 11-04 07:04 EG450 구현(GAP-286(a) DMF0043 합계 실패 덧붙임 PASS·변이 FAIL) · EG307 GAP-286 부분 실측 기록(GAP-265 결정 대기) · 검사기 T46(@DYN 칸 이름 형식)
- 11-04 07:36 EG427 구현(GAP-266 Replace 자료 없는 범위 사전 중단 PASS·변이 FAIL · 원장 0) · 신설 poprow·srvguard · 검사기 T47(가로채기 정규식 확장) · 현황 미착수 10
- 11-04 08:21 EG163 구현(GAP-175 DMF0020 52주 안 수량 키 판가 삭제 차단 PASS · 원장 0) · 신설 griddump · 검사기 T48(응답 대기)·행 탐색 상한 3,000→30,000 · 현황 미착수 9
- 11-04 09:35 사용자 지시 반영(81 컷오프 0행이 DMF0042/44/49 대상이면 무시 · 명부 계정 저장 허용 · 복원 키 없어도 실저장·미복원만 보고 · EG307 = AS-IS 기준 → GAP-265 FAIL 확정 DD-214) · 키 없는 복원(restore_touched keyless — 감사 칸 기준 ROWID flashback · 저장이 지운 행은 한계) · DMF0003 재측정 불가: PKG_DMF0003 BODY INVALID(GT_ANLO_TMP 30칼럼 ↔ DM_PLN_MKT_FCST_C 33칼럼 · 11-03 19:11 칼럼 추가) — 보완 대상(검증 단계라 미수정)
- 11-04 11:45 마무리 집계 {'구현': 243, '변이입증': 168, '해당없음': 47, '미착수': 3} — 오늘 처리: EG307(AS-IS 기준 GAP-265 FAIL 확정 DD-214)·EG355(CN 건수 'Total N rows' FAIL · KO 알림 PASS · 언어 복원 KO)·EG226(필수 칸 자동 표시 PASS · 개인화 40행 원복 · 저장 부분 81 편집 칸 없음)·EG122(기존 ETC Team 표시 PASS · 신규 행 Project→Team 「Project 필수」 오탐 FAIL · 연쇄 초기화로 저장 미도달)·EG185(DMF0074 업로드 행별 오류 사유 4종 실측 · C19 컷오프 0행으로 저장 미도달)·EG184(SCP0007 조회 전 Insert 허용 = AS-IS 차이 · 저장 Div 필수 차단) · 남은 3 = EG244(PKG_DMF0003 BODY INVALID · GT_ANLO_TMP 30↔33칼럼 · 11:42 재확인)·EG250/EG424(81·82 최근 SP_W 컷오프 DM_PLN_SALES_PLAN_C 0행) · 미복원 = SCM_ADM_EXCEL_UPLOAD jiwon.park DMF0074 12행(업로드 검증 스테이징) · 신설 단계 lang·pagetext·widen·upload·condval·griddump·poprow·srvguard·srvblock·rowhas 확장 · 복원기 keyless · 검사기 결함 T45~T49

- 11-04 12:54 PKG_DMF0003 BODY 재확인 = INVALID 유지(LAST_DDL 10:47:57 · 984/1001 ORA-00913 · GT 30칼럼 ↔ 원본 33칼럼) → EG244 미착수 유지 · EG250·EG424 = 사용자 SKIP(실운영 정상) → 해당없음
- 11-04 12:58 사용자 지시 GT_ANLO_TMP_DM_PLN_MKT_FCST_C·RESULT_C 칼럼 3개 추가(Doc/cloud_sql/gt_anlo_tmp_mkt_fcst_addcol_20261104.sql) → BODY VALID · EG244 weeksplit 신설·실측 PASS 2(V-376702d8·V-1ca8c968) · 13:25 사용자 지시로 칼럼 제거(…_rollback.sql) → 30칼럼·BODY INVALID 복귀 · EG244 구현(변이입증은 GT 반영 뒤) · 집계 구현 244·변이입증 168·해당없음 49·미착수 0
- 11-04 13:55 EG102 GAP-171 묶음 통화 전파·재환산 curprop 신설 PASS·변이 FAIL · T50(dbq 50행 잘림) 교정 · 14:20 EG226 DM-61 저장 부분 Div 40 hongjae.kim CELL_PROD_SITE_ID 개인화 임시 제외 → PASS·변이 FAIL · 개인화 19행 원복 → 변이입증
- 11-04 14:31 EG163 DM-148 Cutoff 미완료 RTF 저장 차단 srvguard PASS·변이 FAIL · 원장 변경 0
- 11-04 15:11 EG163/EG427 DM-93 Version Create 실측 → 보고서 원장 0행 FAIL(결함 후보 · 08-24 이후 R_B 15건 동일) · 생성분 원복 잔존 0 · T51 교정 · 수동 시나리오 목록 신설(scenario_manual.csv)
- 11-04 15:16 EG355 SCPSSP-8 KO Lot Size 문구 PASS·변이 FAIL → 변이입증
- 11-04 15:24 중간 집계 구현 242·변이입증 170·해당없음 49·미착수 0 · 남은 부분 공백: GAP-366(신규 행 월 칸 편집 불가로 막힘)·GAP-286(b)·GAP-175 실삭제·GAP-266 자료 있는 Replace·DM-56·GAP-138·GAP-267·컬럼설정 저장/타 Div·SP 분기 실행·EG244 변이
- 11-04 15:51 EG021/EG392 컬럼 설정 저장 후 반영·타 Div 실측 PASS(6+1)·변이 FAIL · titleset_guard.py · colvis 단계 · T52 교정 · 개인화 복원 동일
- 11-04 15:55 EG161 DM-214 구코드 Sold-To/Ship-To 서버 차단 srvguard PASS·변이 FAIL · 원장 변경 0
- 11-04 15:59 EG161 DM-75 AS-IS 근거 없음 확인(사용자 확인 필요) · GAP-175 실삭제 경로·하류 금액 재계산 확인(복원 설계 필요) · 집계 구현 242·변이입증 170·해당없음 49
- 11-04 16:16 사용자 판정 3건 반영(DM-75 PASS · DM-58 PASS · DM-P13 SKIP=개발필요 유지) · _user_verdicts_direct.csv + judge 반입 경로 신설 · DMF0005/0044/0082 judge 재실행
- 11-04 16:38 EG163 GAP-175 실삭제 허용 PASS · keyset_guard.py(키 범위 스냅샷 복원) 신설 · 복원 동일 · srvguard @resp: · EG163 → 변이입증
- 11-04 17:03 EG427 GAP-266 자료 있는 버전 Replace PASS · 원장 복원 동일
- 11-04 17:20 EG427 DM-56 BPS I/F PASS · 환율 복원 동일 · SAVE_RE IF 추가 · GAP-138·GAP-267 = 대량 원장 전체 재계산(승인 필요)
- 11-04 17:2x GAP-286(b) 데이터 조건 부재(12개월 미만 행 0 · 화면 경로로 생성 불가) 기록
- 11-04 18:1x GAP-267 백업 표 생성(ZV_BPFCST40_BK20261104) · Set Price 실행은 자동 권한 판정 차단 → 미실행 · GAP-366 진단 기록
- 11-04 21:1x~21:37 GAP-366 원인 확정(T54 · 고정 칸 1,930px > 가시 폭 → 동적 칸 미렌더) · viewport·setcells·fiberprops 단계 신설 · GAP-366 V-a5fb5833 PASS/변이 FAIL · GAP-286(b) V-80971212 PASS/변이 FAIL · EG450 변이입증 · EG244 BODY VALID 재측정 PASS·WEEKSPLIT_MUTATE 변이 FAIL → 변이입증 · GAP-267 Set Price 재시도 자동 권한 판정 차단(미실행)
- 11-04 21:40 T54 검사기 보정 — dynlock 등 startEditing 탐침 3곳: 편집 실패 + 셀 요소 없음 = null(측정 불가) · FHD 재측정 DMF0049 = ERROR(칸 미렌더) 확인 · tsc 0 · 진단 시나리오 행 제거
- 11-04 22:1x~22:35 GAP-138 가짜 응답 실측(mockresp 신설): CODE -1 PASS·변이 FAIL / SUCCESS PASS / HTTP 500 → 완료 표시 FAIL(결함 후보 · FE 500 미처리) · 상태 프로시저 무실행(로그 0) · GAP-267 사용자 실행 스크립트 gap267_setprice_run.py(--dry 22:33 불일치 5 · 복원 SQL parse OK)
- 11-04 23:0x GAP-267 PASS(사용자 실행 · 불일치 5→0 · 소실 0 · 복원 same=true · 23:02 재확인) → EG427 변이입증
- 11-04 23:15~23:42 보완: 백업 표 2개 삭제 · DM-93 = 결함 아님(현재 코드 큰 원천 724,795행 · 원천 20행 데이터 조건) · GAP-138 PKG_DMF0008 래퍼 예외 처리 사내 적용 + FE 가이드 + 클라우드 패키지 · DMF0049 MEASURE FIXED_FLAG N(AS-IS 일치) 사내 적용 + 클라우드 패키지 · FHD 재측정 OK

### W8. 방향 전환(2026-11-06 사용자 승인 플랜 — AS-IS 직접 비교 1순위 · 판정 계약 · 스냅샷) — W0 은 병행 유지(사용자 결정)
정본 플랜: `C:\Users\LG\.claude\plans\serene-moseying-kazoo.md` · 백업 `*.bak_w8_20261106` · 기준선 `Doc/verify/_w8_baseline/`(골든 SCP0127 1,614행·SCP0016 2,071행 · doc_proof S0)
- [x] 11-06 19:44 Playwright 1.49.1 → 1.64.1(tools/E2E) · 회귀 run_verify SCP0127 --tier fast 20:38 종료(3,173s · 악화 4·개선 2·변경 145 = tier/judge 버전/실행 변동 · G1 SCM Site '선택 확인 실패' 재시험 8/8 PASS) → 업그레이드 확정
- [x] 11-06 19:51 W8-A 신규: `oracle_class.py` → `Doc/verify/_oracle_class.csv`(104 규칙 = ASIS 60·RULE 27·RUNTIME 17·HOLD 0 · 초기값 = detect_rules oracle 열 기계 분류 · 11개는 파일:줄 근거로 분류) · `rules/expected_source_rank.csv` · `rules/rule_applicability.csv`+`applicability.py`(SCP0127 Y 849·N 114·UNKNOWN 17 / SCP0016 Y 936·N 337·UNKNOWN 22) · `precision.py`(SCP0016 v2 0.118 → v14 1.000)
- [x] 11-06 20:4x~21:1x W8-A 원장·판정 반영 완료: ledger.py COLS 25열(+oracle_class·expect_src·evidence_ref·precond·applicable·applicable_why)·스냅샷 행 · judge.py derive/evidence_gate/applicable N→NA · make_verify_docs 미검증 사유 4종·정밀도 행·3-증거 열 · checker_regress received/--approve/--only/--strict·사용자판정 자동 승인·승인 스냅샷 악화 exit 2 · regress direct 병합 · doc_proof 적용불가 — 실측(SCP0127 skip-e2e 체인 21:1x): APPLICABLE_N 83 · EVIDENCE_GATE 1(F2 전제 미충족) · 조치필요 2(G1 Plan Group·E7 팝업 Key-in) 전부 3-증거 비공란 · 미검증 사유 측정못함 139·상속생략 515·시험검사 5·대상불명 1·적용 불가 96 제외
- [x] 11-06 19:56~20:10 W8-B 신규: `golden.py` main() 리팩터(import 무실행 · SCP0127 요약 전후 동일) + compare(keys/norm/alias/rs_map)·KEYPROF · `gen_param_map.py` → `rules/sp_pair.csv`(SCP0127 3 · SCP0016 4) · `rules/param_map.csv`(32+16 OK) · `rules/{key_map,norm_rules,col_alias,diff_rule_map}.csv` · `diff_verify.py` · `diff_ingest.py`
  - 실측: SCP0127 DIFF(공통 533/534 · 불일치 4셀 전부 LAST_UPDATED_BY/DATE = E2E 실저장 잔존 → 감사 컬럼 compare=N) · AS-IS DEV ↔ 사내오라클 `SCP_OPMZ_PRECEDE_SAFETY_STOCK_DAY` Div 별 건수 동일 · 'ALL'→'' 번역은 SP 의 DECLARE 별칭까지 판독해야 함 · SCP0016 AS-IS 0행(원인 조사 중)
- [x] 11-06 20:4x W8-B 체인 배선 완료: run_verify STAGES 8(diff 단계·oracle_class --check·precision) · nscm.ts allCalls·GET 무절단 · fixtures calls/*.json · _verify _grid_main.json — 실측: G1 재시험이 남긴 calls 3건 → diff → ASIS_DIFF 12행(PASS 6·판정필요 5·NA 1) · SCP0016 diff_replay.json(versionNo SP_W_20260608)+key_map(KEY_IDX,MEASURE) → 공통 452/452 · 불일치 452셀 = DEPT_NAME_KO(AS-IS '-' ↔ TO-BE 팀명) · 발견 TO-BE PKG_SCP0016 ORA-01722@SP_W_20260615(판정필요 후보)
- [x] 11-06 20:2x W8-C 신규: `tools/E2E/lib/snap.ts` · `Doc/e2e/specs/_snap.spec.ts`(tsc 0) · `snap_expect.py`(SCP0127 8조건·SCP0016 9조건) · `snap_validate.py` · `snap_approve.py` · `snap_parallel.py`
- [x] 11-06 21:0x W8-C 배선 완료: ledger 스냅샷 행 8종(조회조건·버튼 ×Div · 헤더 ×시트 · 팝업 ×조건 · 화면샷 1920/1366) · check_maturity CM-SNAP trial · run_verify `_snap` · playwright.config snapshotPathTemplate · checker_regress 승인 스냅샷 악화 exit 2 — _snap 실행·승인 PoC 는 아래
- [x] 11-06 21:3x~22:0x W8-C PoC(SCP0127): `_snap` 6회 실측으로 locator 3건 교정(SearchArea 클래스·form 0개 → _formItem_ 최소 공통 조상 태깅 · 버튼 바 = 핫키 버튼의 콤보 없는 조상 · 화면샷 경로 = 배열 세그먼트+Wijmo 배너 마스크) → 수신 6종(조회조건 29줄·버튼 11줄·헤더 1행·팝업 226줄·화면샷 2) · snap_validate: 버튼 OK(SEARCH 는 조회영역 경고)·헤더 OK(META 숨김 2 경고)·**조회조건 시각 순서 ≠ 기준표**(Div > SCM Site > Type > Stage > Plan Group… vs Div > Plan Group > SCM Site… — SC1 사용자 확인 사안) · 임시 승격(--force --no-verdict) → 재실행 **6/6 MATCH(29.9s)** → 버튼 골든 1줄 변이 → **DIFF 검출(4줄)** → 복원·임시 골든 제거(사용자 승인 대기 = CheckList '승인대기(스냅샷)' 6) — G4 입증
- [x] 11-06 22:0x W8-C PoC(SCP0016): 수신 7종(팝업 PJT·Model/Nickname 2) · validate: 조회조건 시각 순서 ≠ 기준표(Ver. 위치) · 헤더 누락 **Team**(TO-BE 헤더에 없음 — diff 의 DEPT_NAME_KO 와 연결) · 화면샷 첫 캡처 제거(승인 대기)
- [x] 11-06 22:1x 사용자 결정 반영: 1-c 스냅샷 승인(SCP0127 버튼·헤더·팝업·화면샷 2 = 5 · SCP0016 버튼·팝업 2·화면샷 2 = 5 · 조회조건 순서(SC1)·SCP0016 헤더(Team 차후확인) 제외 · _user_verdicts_direct.csv 기록) · 3-a G1 Plan Group FAIL · 3-b E7 팝업 Key-in FAIL · 2-a DEPT_NAME_KO 결함 아님(PASS) → judge·CheckList SCP0127 v12 / SCP0016 v16 · 정밀도 SCP0127 2/2=1.000 · SCP0016 2/2=1.000(precision.py EG- 행 누락 결함 수정)
- [ ] 남은 사용자 확인: 조회조건 시각 순서 ≠ 기준표(두 화면 · 기준표 갱신 vs 화면 수정) · SCP0016 헤더 Team 누락(2-b) · CM-SNAP confirmed 전환(2화면 확인 뒤)
- [x] 11-06 22:2x 2-c 보완 적용(DB MODE): 원인 = 재고 뷰 2종의 `TO_NUMBER(REGEXP_SUBSTR(A.OPT_PLAN_ID,'[^-]+$'))` 구포맷 ID 변환(M.PLAN_ID 가드만 있음) → `DEFAULT NULL ON CONVERSION ERROR`(SALES 1곳·PLANT 2곳) · hook #152 절차(기준본 백업·FRESH-GATE) · 22:23:44/45 적용 · VALID·ALL_ERRORS 0·의존 16 재컴파일 INVALID 0 · PKG_SCP0016 0615 호출 454행 OK · 기록 `_artifacts/_apply_corporate/ONHAND_V_SEQ_GUARD_20261106/` · 클라우드 패키지 `_artifacts/_deploy_packages/SCP0016_CLOUD_DB_MOD_20261106_2230/`(22:30 · 리허설 OK 경고 0 · `A_DB/25_SHARED_SCP_PLN_SALES_ONHAND_V_SEQGUARD_SCP0016.sql`·`25_SHARED_SCP_OPT_PLANT_ONHAND_V_SEQGUARD_SCP0016.sql` 포함 — cloud_pkg.py 1.1.0 에 동적 SQL 문자열 참조 수집(DYN=Y) 추가: PKG_SCP0016 은 두 뷰를 동적 SQL 안에서만 써서 ALL_DEPENDENCIES 에 없어 첫 빌드(2225)에서 누락 → 폐기) · README 의 '공용 객체 변경 감지 FN_GET_SCP_ANL_BOH_QTY 22:23:46' 은 의존 재컴파일(ALTER COMPILE)로 LAST_DDL 만 갱신된 것, 소스 변경 없음
- [x] 11-06 23:0x~23:47 사용자 "4-1(SC1 조회조건 순서) 현재 유지·나머지 진행" 반영: ① CM-SNAP confirmed(SCP0127;SCP0016) ② SCP0016 11번 K1 → CR-097(재조회 시 필터 초기화 = 공용 동작) + filterkeep.ts → PASS · 17번 C4 → CR-078(Div 단일 변경 시 그리드 초기화) 적용 → PASS · 20번 ROW = COND 상속(W4d · 단독 실행 NA) · AD DEPT_NAME_KO norm_rules compare=N → diff PASS 2(main 452행) · diff 팝업 시트 오매핑(ROWS_ONLY 9행) 수정 · **회귀 오라클 위반 4→0** · CheckList v17 정밀도 2/2 ③ SCP0127 G1 = 검사기 결함(코드 PG0002 ↔ 명칭 E161A 비교 + SELECT ALL 선택 수 포함) 수정 → 23:40 재측정 PASS("E161A 조건 1행 = 전체 조회 그 값 1행") → **사용자 3-a 판정 재확인 필요**(현재 USER_VERDICT FAIL 유지 · 상속 2행 악화 표시는 이 판정 때문) ④ SCP0127 E7 = DB 보완 `PKG_SCP0127` SAVE 품목 검증(23:16:32 VALID · `_artifacts/_apply_corporate/SCP0127_SAVE_ITEM_VALID_20261106` · 클라우드 `_deploy_packages/SCP0127_CLOUD_DB_MOD_20261106_2326`) — 그러나 BE(code 0)·FE(saveRequest.ts:113)가 O_RESULT_CURSOR RESULT_CODE 를 안 읽어 거부된 저장을 성공 토스트로 표시(23:38 BE 직접 호출 실측 · AS-IS .cs:824-838 은 'S' 아니면 오류창) → FE 가이드 `Doc/gen/SCP0127/E7_FE_GUIDE.md`(보완1 결과코드 판독 · 보완2 저장 전 MSG00458) · E7 조치 필요 유지(FE 보완 전) · CheckList v13 정밀도 2/2 ⑤ 2-b SCP0016 헤더 Team = minyonglee1 개인화(TITLESET_USER 'C' 19행 · 11-02 17:57:57 생성 · Team 제외·To Site 5번째)로 TO-BE 정상 → snap_expect 가 PR_GET_SHEET_COLUMN_LIST 출력으로 기대 생성(개인화 초기화 여부는 사용자 결정) · 검사기 결함 T117~T122 기록
- [x] 11-07 00:1x 사용자 '3-1 철회 · 3-2 개인화 삭제': V-a6593ee3 직접 판정 제거(백업 `_user_verdicts_direct.csv.bak_20261107_3a`) → SCP0127 v14 조치필요 1(E7) · 정밀도 1/1 · checker_regress 악화 0 개선 3 · TITLESET_USER minyonglee1 SCP0016 'C' 19행 삭제(00:11:56 · `_artifacts/_apply_corporate/SCP0016_TITLESET_RESET_20261107`) → 화면 오픈 시 기본 21행 재적재(00:12:21) · 헤더 스냅샷 재채취 = 메타 순서·Team 포함 20컬럼 기대 일치(승인 대기)
- [x] 11-07 00:29~07:06 W8 PoC 6화면 전체 체인(chain6 · SCP0037 v16 → SCP0084 v17 → SCP0122 v6 → SCP0131 v6 → SCP0127 v15 → SCP0016 v18 · 화면당 51~90분 · diff 호출 15/7/11/17/28/21건): 결과 봉투 FAIL 15/13/2/28/13/14 · 조치필요 3/9/1/8/3/9 · 정밀도 SCP0127 1.000(v14) SCP0016 0.500(v17) · 감사 → 검사기 결함 T129~T140(`_checker_defects.md`): L1 벽시계 재발 원인 = MAIN_SHEETS 가 FE 시트 키 'main' 미포함(6화면 전부 64초) · E4↔F1 순서 · 편집 셀 DOM 순번≠컬럼(SCP0084 F1 허위+MEMO 잔존) · K3 빈 셀 Copy · PICK_DBL/G8/G2 측정 실패→ERROR · diff 'ALL'→'' 미번역(SCP0037 14건 0행) · DD-218/219 · I2 AS-IS 동일 고정 라벨→판정필요 · F5 FlagI · 화면샷 FAIL=개인화 삭제 영향(사용자 재승인) · DB 보완(ZIOUI1): PKG_SCP0131 SAVE 품목 검증 07:38:34(VALID·ALL_ERRORS 0·ORA-20010 재현·212/212) · SCP0131 PRIO_RANK DATA_SCALE_NUMBER 0(07:40:05) · E2E 잔존 복원 4셀(07:38 SCP0084 MEMO 3·SCP0127 VALID_YN 1) · 패키지 `SCP0131_CLOUD_DB_MOD_20261107_0740` · FE 가이드 Doc/gen/{SCP0037,SCP0131,SCP0016}/*_FE_GUIDE.md · tsc 신규 0 · py_compile OK · 재판정(SCP0037 --skip-e2e · SCP0122 _trace W4d) 배경 실행
- [x] 11-07 07:4x~08:0x 재판정(--skip-e2e): SCP0037 v17→v19(diff 14 ROWS_ONLY → PASS 8·ROWS_ONLY 6·DIFF 0 · FAIL 15→7 · 조치필요 3 = F5·L1(검사기 수정분, E2E 재실행 대상)·E1(FE 가이드) · regress 위반 15→13 = E4 묶음(T130, E2E 재실행 대상)) · SCP0084 v18(diff DIFF 4 → PASS 7 · 조치필요 9→5 · I2 EN 4건 → NA/W7 수동 검수) · SCP0122 _trace W4d 단독: L1 269ms PASS(T129 검증) · 신규 T141 INV_FLAG ''↔NULL 환경 차이 → golden EMPTY_DEFAULT 클래스 + norm_rules(특정 컬럼 규칙은 `.*` 앞)
- [x] 2026-11-07 08:22 사용자 '5번 진행' → 6화면 전체 체인 재실행(chain6b · SCP0037→SCP0084→SCP0122→SCP0131→SCP0127→SCP0016 · 배경 bqzip8qrn · 로그 scratchpad/chain6b.log) — 검사기 수정분 T129~T141 E2E 재측정 · 완료 후 화면별 결과·회귀·정밀도 보고 → **14:05:57 종료(5h43m · exit 0 ×6)**
  - 결과: SCP0037 v20 조치필요 1(E1 FE가이드) · regress 위반 0(T130 해소) · diff PASS 8 | SCP0084 v19 조치필요 7(F1·K3×2·A7×3·SC1) | SCP0122 v7 조치필요 0 | SCP0131 v7 조치필요 3(G9·D1·E7) | SCP0127 v16 조치필요 1(사용자 FAIL) | SCP0016 v19 조치필요 6(I4·K3×3·G6×2) · L1 6화면 PASS(T129) · PICK_DBL/G8 → ERROR(T133/T134) · F5 PASS(T140)
  - 감사(14:0x~14:2x · `_checker_defects.md` T142~T146): 스냅샷 행 @trace 덮어쓰기(승인대기 과소) · SCP0084 F1 편집 컬럼 PIC 오인→MEMO '1' 잔존 복원(14:1x) · K3 빈 열 · SCP0131 G8/G9 textarea 미입력 · PRIO_RANK 메타 0 → 신규행 편집기 'Number expected' → 14:18:13 NULL 원복 · 패키지 `SCP0131_CLOUD_DB_MOD_20261107_1421`
- [x] 2026-11-07 14:2x chain6c(배경): SCP0131 컬럼 프로브 단독 재실행 → SCP0131·SCP0037·SCP0084·SCP0122 `--skip-e2e` 재판정(T142 judge 가드·T146 원복 효과) — 완료 후 새 판 수치 보고 → 14:55 종료: SCP0131 v8(D1 PASS · 조치필요 5) · SCP0037 v21(1) · SCP0084 v20(diff PASS 7 · 4) · SCP0122 v8(0) · SNAP_GUARD 3/화면
- [x] 2026-11-07 14:5x chain6d(14:55~15:04 종료 · SCP0131 v9 조치필요 4 · E7 EG 행 → W7 NA '[서버 검증 미측정]') / [x] chain6e(15:04~15:31 · 승인대기 6/5/5/6 복귀 · 기준선 재저장) · T148 팝업 rowHeaders 체크박스(15:4x 단독 실측 · FE 정상·검사기 수정) · ⭐ 사용자 15:1x '목적 = 정합성 향상이지 판 생성 아님' → 추가 재판정 없음(T142~T148 효과는 다음 정규 실행에서 측정): SCP0131 eg_popup 단독 재실행(T147) → --skip-e2e → 4화면 checker_regress 기준선 · 이어서 chain6e: 4화면 `_snap` 단독 재실행(T142 ② 화면샷 승인 가드) → --skip-e2e → 기준선 재생성
- [x] 2026-11-07 17:16 chain6f(사용자 '재실행해주세요' 17:1x · 배경 · 로그 scratchpad/chain6f.log): 6화면 전체 체인(E2E 포함 · chain6b 와 동일 순서 SCP0037→0084→0122→0131→0127→0016 · tier all) — 목적 = T142~T148 효과 측정(허위 FAIL 제거·측정 실패→ERROR/판정필요·승인대기 유지). 종료 후 정합성 지표(검사기 결함·허위 조치필요·regress 위반·checker_regress 악화)로 보고
- [ ] 2026-11-07 18:07 chain6f SCP0037 종료(51분 · v23 조치필요 1=E1 · 위반 0 · 악화 0 · 승인대기 6 · DB 잔존 LT_DAY 복원·이력 삭제 2 실측 18:11) → 감사에서 T149(SC1 기대원천 GENERAL → 실제 순서 불일치 FAIL 이 ERROR 로 은폐 · SCP0037/SCP0016) · T150(smoke 요약 행 precond 공란 → smoke FAIL 전부 ERROR · H7 조회 0행 알림 구분) · T151(0 값 저장 때 화면 사전검증 모달이 Save 클릭 차단 → 테스트 중단 · nscm.save 클릭 전 알림 처리) · T152(touched_rows 가 편집 후 값 기록 → 기록 시점 편집 전으로) · T153(게이트 '신규0·호출' regex 가 모든 시나리오를 조회 0행으로 오인 · F2 FAIL 2건 은폐) — 18:14~18:3x 수정 · py_compile OK · tsc 기존 1건 외 0 · 1화면 입증 chain6g(SCP0037 --skip-e2e · 18:2x 배경) · chain6f 는 SCP0122 부터 새 nscm.ts/saveprobe.ts, SCP0084 판정 단계부터 새 judge.py 사용
- [x] 2026-11-07 18:57 chain6f SCP0084 종료(50분 · v22): 조치필요 7→**1**(SC1 사용자) · F1·K3 허위 FAIL 제거(T143·T144 입증) · H7 조회 0행 알림 ERROR(T150) · 정밀도 1.000 · 위반 0 · 악화 0/개선 4 · 승인대기 5 · diff PASS 7 · DB MEMO 잔존 없음(18:5x) · restore_touched 미지원 한계 기록
- [x] 2026-11-07 19:43 chain6f SCP0122 종료(46분 · v10): E2E 76 passed(T151 로 저장 세부 테스트 중단 0 · 빈값 입력 = '저장 전 화면 검증 거부' 기록) · T152 입증(touched_rows 19:09 OPMZ_ACTV_SEQ=1 편집 전 값 · DB 복원 LUD 11-06 13:09:51) · 조치필요 0→**1**(J2 — T150 으로 드러난 뒤 감사: 허위 = T154 저장 판정이 SEARCH 호출까지 셈 · T155 errors 미병기) → 수정 · 승인대기 5 · 위반 0 · 악화 1(J2 복귀행)
- [x] 2026-11-07 20:32 chain6f SCP0131 종료(49분 · v11): T145/T146/T148 허위 제거 입증(G9 3·G8·G1·PICK_OK PASS · D1 정상) · T150/T153 으로 G3(CR-029 기간 키 저장)·F2(저장 요청 없음) 실제 FAIL 복귀 · 조치필요 5 · 승인대기 6 · 위반 0 · E3 'Date expected' 중단 원인 조사 예정
- [x] 2026-11-07 21:40 chain6f SCP0127 종료(68분 · v17): 조치필요 3(F2 복귀·E7 사용자·F6 = T157 허위) · 개선 7 · 위반 0 · 정밀도 1.000 → 감사에서 T157(원복 입력 경로 비대칭 → '수정한 내용이 없습니다')·T158(restore_touched 날짜 키 ISO ↔ 'YYYYMMDD' · 신 키 DB 1행 실증) 수정 · 부수 발견: FE 알림 '_수정한 내용이 없습니다.'(MSG00004 는 사전에 있음 → 메시지 사전 미적재 가능성 · 사용자 확인 대상)
- [x] 2026-11-07 22:0x T159(조회조건 순서 판정 일원화 — SCP0127 은 smoke 기준표 순서 FAIL 이 원장 어디에도 없고 G4 가 구 'AS-IS 배치 PASS' 규칙으로 덮음 ↔ SCP0037/0016 은 Excel 기준 FAIL · 11-06 사용자 지시와 불일치): ledger SCREEN_RULES+SC1 · detect_rules SC1 · judge order_rule() 함수화·smoke 반입 뒤 재호출·G4 정적 FAIL 은 SC1 행 위임·TRACE/RULE_SCREEN 중복 방지 → 입증 chain6h(SCP0127 --skip-e2e · 배경 · chain6h.log) · chain6f SCP0016 E2E 진행 중(21:40~) → chain6h 21:45~21:52 입증: SCP0127 v18 SC1 행 FAIL(Excel 기준) · G4 NA 위임 · 조치필요 4 · 위반 0
- [x] 2026-11-07 22:57 chain6f 전체 종료(17:16:10~22:57:45 · 5h41m · 6화면 exit 0) · SCP0016 v20: 조치필요 9(I4·K3×3 FE가이드 · G6×2 사용자 · H4 화면샷 2 = T139 골든 재승인 대기(5704px ratio 0.01) · SC1 Excel 순서 사용자 결정) · 위반 2 = H4 승인 골든 ↔ 재실측(같은 T139) · 개선 23 · 정밀도 0.500(사용자 검토 4건 중 허위 2 = H4) · 조회 전용(복원 기록 없음)
- 정합성 총괄(chain6f+6g+6h · 11-07): 검사기 결함 수정 T149~T159(11건 · 게이트 은폐 3종 T149/T150/T153 · 저장 판정 T154/T157 · 사유 병기 T155 · 중단 가드 T151/T156 · 안전망 T152/T158 · 순서 일원화 T159) · 입증 완료 T142~T153·T156·T159 · 다음 정규 E2E 측정 T154/T155(authcrud)·T157(SCP0127 F6)·T158(복원 실행) · 드러난 실제 결함 후보: SCP0131 G3(CR-029 기간 키 저장)·F2, SCP0127 F2(알림 없이 저장 호출 없음), SC1 Excel 순서 3화면(SCP0037·SCP0127·SCP0016 · SCP0084 는 사용자 FAIL) · 사용자 판정 위반 6화면 합 2(= SCP0016 H4 골든 재승인 대기) · 검사기 악화 = 전부 은폐 FAIL 복귀 행
- [x] 2026-11-08 10:0x~10:2x 사용자 'UI 각각 테스트 말고 검사엔진 자체 재검증': `Doc/verify/_engine_selfcheck_20261108.md` — engine_audit 101 규칙 OK 96 · doc_proof F 41/D 38/E 2/C 5 · py_compile 98종 0 오류 · 멱등성 6화면 변동 0(원복 md5 동일) · 변이 5종(스냅샷·사용자판정·기대원천·전제·보류) → T163 수정 후 5/5 차단 · 매트릭스 표본 → T160(align_check 시트명)·T161(db_snapshot 날짜 키) · T162 smoke 컬럼 가상화(잠복) · FAIL 3-증거 결손 0 · 화면 ID 분기 0 · 미시험 = 브라우저 필요 자기검증(checklist_selftest·eg) · §5 생성·자동보정 연계 의견(사양 표 공유 · --static 게이트 · fix_recipes · judge --only)
- [x] 2026-11-08 11:3x~12:0x 사용자 '순차적으로 진행' — 생성·자동보정 연계 (a)~(d): (a) 사양 표 공유 = gen-e2e smoke 라벨 후보에 `label_alias.csv`(검사기와 동일) · `new_screen.md` §입력 8(검사기 사양 표 7종) + DoD 정적 게이트 · `run_verify.py --static`(브라우저·AS-IS SP 없음 · CheckList 판 생성 안 함 · static_gate.md/json · exit 2=정적 FAIL) → SCP0122 실측 1.9분 · 정적 판정 948행 · 직접 FAIL 0 · 36 규칙 / (b) `run_verify.py --only <규칙,…>` 부분 재판정 = judge.test_ownership + 제목 토큰으로 테스트 선택 · smoke 규칙은 smoke 재실행 · 이전 E2E 결과 행 단위 병합 보존 · eg/diff 건너뜀 → SCP0122 --only K3 실행 중 / (c) `rules/fix_recipes.csv`(24행 · 규칙×계층 · 변경 요지·대상 패턴·검증 --only·auto_apply) + make_verify_docs 보완대상 '변경 요지·검증 방법' 자동 채움 + `repair_plan.py <ID>` → SCP0131 5행 레시피 5/5 / (d) `check.js --final` DoD S01 = run_verify --static 직접 FAIL 0(--no-static 으로 해제) → SCP0037 실행 중
- [x] 2026-11-08 11:49 (d) 실증: `check.js --page operation-lt --id SCP0037 --final` → DOD.md `S01 ✅ 정적 게이트 직접 FAIL 0(정적 판정 1004행 · ERROR 57)`(기존 BLOCK 12 는 M04 미구현 등 종전 항목) · static_gate 에 'E2E 유래 FAIL(직전 실행 · 범위 밖)' 절 추가(SCP0037 2행 = SC1·E1 노출 · 숨기지 않음) · run_mode.json + CheckList 요약 '실행 모드: 부분 재판정 --only …' 표기
- [x] 2026-11-08 12:0x (b) 실증: `run_verify.py SCP0122 --only K3` → 테스트 1개('그리드 조작(K3) …') 23.1s 재실행 · e2e_results 612행 중 K3 14행 갱신·598행 보존 · eg/diff 건너뜀 · 전체 7.5분(docs 4.7분이 대부분 — 다음 개선 후보) · CheckList v11 조치필요 **1→0**(J2 허위가 T155 로 ERROR 전환 — SCP0122 에서 T154/T155 중 T155 입증) · run_mode.json 표기는 다음 실행부터(이번 실행은 코드 반영 전 시작)
- [x] 2026-11-08 12:1x~16:1x 사용자 '남은 것 진행': ① docs 병목 = regress --harvest 270s → 캐시로 0s(결과 동일) · master_sweep 36s 는 DB GROUP BY(보류) ② 효과 측정 최소 실행 — SCP0016 --static → T160 입증(H1 NA 29 → PASS 8) · SCP0127 --only F1,F2,F6,F7,F8 실행 중(T157·T158·T161) · 예정 SCP0122 --only J2(T154) · SCP0084 --only A5(T162) ③ 레시피 자동 적용기(dry-run 기본) 예정 · 부수: run_verify run_mode 블록 NameError(mid 선언 순서) 즉시 수정 — 영향 실행 2건은 시작 직후 중단이라 산출물 변경 없음
- [x] 2026-11-08 16:2x ③ 레시피 자동 적용기 `repair_apply.py <ID> [--apply]`: dry-run 기본 · auto_apply=Y + sql_template 있는 DB 레시피만(현재 LB1 라벨 Valid→Active 메타 UPDATE 1종 · DB-SYN 은 syn_fix 가 이미 자동) · hook #152 절차(원문 재조회 가드 = 정확히 1행 · before/after 백업 · APPLIED_OPERATIONS.md · 재판정은 --only 안내만) · selftest 8/8 · dry-run SCP0131/SCP0016 후보 0건(현재 조치필요에 자동 대상 없음) · 비자동 레시피(FE/COMMON/HUMAN·PKG) 는 repair_plan.md 가이드
- [x] 2026-11-08 16:3x 효과 측정: SCP0127 --only F* → T157(F6 허위 소거)·T158(복원 키 1행 RESTORE)·T161(F7/F8 PASS) 입증 · 조치필요 4→3 / SCP0122 --only J2 1회차: authcrud 여전히 saved=Y·found=N(사내 SQL 로그 SAVE 0건 · 원인 미확정) → crud.ts 에 '마커 저장 응답' 노트 계측 추가 후 재실행 중 / SCP0084 --only A5(T162) 실행 중
- [x] 2026-11-08 16:4x --only 결함 수정: J1/J2/C1 은 auth·authcrud 스펙으로 판정되는데 smoke 재실행만 해 요약의 authcrud 행이 이전 실행 것 그대로였다(계측 노트 부재로 확인) → kinds = smoke + auth·authcrud · SCP0122 --only J2 3회차 실행 중(T154 측정)
- [x] 2026-11-08 16:5x SCP0122 --only J2 3회차(14.1분) → T154 입증(saved=N · 마커 저장은 필수 검증에 막힘 = 시험 한계) · T164 발견·수정(J2 집계 ERROR 가 PASS 에 덮임) → --skip-e2e 재판정 J2 ERROR · 조치필요 0 · 남은 측정 = SCP0084 --only A5(T162) 실행 중
- [x] 2026-11-08 17:0x SCP0084 --only A5 → T162 입증(헤더 46/누락 0) · 부수 발견 T165(사용자 SC1 FAIL 증발 — 생성 경로 변경) → ledger 이월 + judge 기준선 재매핑 → --skip-e2e v25 USER_REMAP 1 · 조치필요 1 복귀 · **11-07~08 수정분 T142~T165 전부 입증 완료**(T154·T155·T157·T158·T160·T161·T162·T164·T165 오늘) · 남은 것 = '다음 엔진 개선 후보(2026-11-08)' 4건 + 사용자 결정(SC1 Excel 기준 3화면 · 스냅샷 승인 22건 · SCP0016 화면샷 재승인 · SCP0131 G3/F2 · SCP0127 F2)
- [x] 다음 엔진 개선 후보(2026-11-08) — 17:2x 사용자 '보완 진행': ① T166 필수 칸 자동 채움(실측 중) ② T167 F6 숫자 칸 키보드 입력(실측 중) ③ master_sweep 캐시 69s→23s ④ 설계상 정상(T165 로 보완) · 원문: ① authcrud 마커 행이 keyColumns 만 채워 필수(M) 컬럼 검증에 막힘 → sheet_columns 필수 메타로 마커 행 자동 채움(J2 허용 계정 CRUD 실측 가능) ② F6 '다른 셀 편집 값 유지' TYPE_APPLY_DAY '7'→'0' 입력 미반영(SCP0127) 원인 ③ master_sweep 36s(DB GROUP BY) ④ SC1 TRACE 행이 SCP0037 재생성 원장에서 사라진 경로 확인(RULE_SCREEN SC1 만 남음 — 중복 방지는 됨)
- [x] 2026-11-08 17:4x ② T167 입증(SCP0127 --only F6: '다른 셀 편집 값 유지' ERROR→PASS) · ① T166 1차: 필수 칸 채움 동작하나 연동 콤보가 마커 키를 덮어 '중복 데이터' → 채움 순서 변경(필수 먼저·마커 마지막) 2차 실측 중
- [x] 2026-11-08 18:0x~22:0x ① T166 4차례 실측으로 FE 중복 차단 2종(신규↔기존 키 · PRS_CD+PLAN_GR+ACTV_SEQ)을 피하는 채움(미사용 콤보 후보 · 숫자 최대+1) 확정 · 4차에서 1회차 시도가 실제 저장됐으나 마커 비영속으로 정리 누락 → 잔존 1행 가드 DELETE(APPLIED_OPERATIONS 20261108) · T168 시그니처 식별 추가 → 5차 실측 중
- [x] 2026-11-08 22:0x 엔진 개선 후보 4건 완료: ① T166+T168 입증(SCP0122 authcrud 허용 계정 CRUD PASS · DB 잔존 0) ② T167 입증(SCP0127 F6 PASS) ③ master_sweep 캐시 69s→23s ④ 설계상 정상 기록 · 이번 세션 누계 검사기 결함 T142~T168(27건) 전부 수정·입증(T154/T155/T157/T158/T160~T168 은 오늘) · 남은 것 = 사용자 결정 목록(SC1 Excel 기준 3화면 · 스냅샷 승인 22건 · SCP0016 화면샷 재승인 · SCP0131 G3/F2 · SCP0127 F2 · SCP0127 F6 빈값 저장 AS-IS 검증 근거)

### M1. '추측 대신 실행' 플랜(2026-11-11 사용자 승인 · C:/Users/LG/.claude/plans/groovy-skipping-sprout.md) — 진행 기록

원장: 추측 지점 `Doc/verify/_guess_registry.csv`(guess_scan.py) · TO-BE 룰 `tools/Harness/rules/tobe_rule_registry.csv` · 통합 MD `Doc/_rules_consolidation/TOBE_RULES_DIFF.md`·`TOBE_RULES_DEV.md`

| 엔진 | 도구 | selftest | 실화면 실측(2026-11-11) | VM 연결 |
|---|---|---|---|---|
| EN-00 변경 게이트 | engine_selfcheck.py | 9/9 | 전체 PASS 18.5초 · selftest JS 26·PY 31 · 제어 문자 0x08 혼입 1건 차단 | run_verify 시작 시 자동 |
| EN-01 보완 증명 | repair_close.py (--snapshot/--compare) | 7/7 | SSP0021 --rows 1행 988초(종결 0·미종결 1·회귀 0) · SSP0005 스냅샷·비교 0초 | 🚒 체인 S8.repairSnapshot → S8.repairCompare |
| EN-23 영향 범위 | repair_scope.py | 5/5 | SSP0060 FE 2파일 변경 감지 | repair_close 기본 동작 · S8.repairClose |
| EN-24 원인 계층 | diagnose_layer.py | 9/9 | 4개 화면 55행 중 23행 확정 · 32행 미확정 표시 | 🚒 체인 S8.diagnose · 🧯 프롬프트 |
| EN-03 메타 실측 | meta_live_check.py | 9/9 | 6개 화면 · SSP0060 MKT_OWNER↔MTK_OWNER FAIL 1 | 🧾 proofTasks S8.metaLive · pipeline 8b |
| EN-22 생성물 DB 확인 | pipeline.js 8단계 | - | SSP0060 8a·8b 실행 | 새 화면 체인 8/8 |
| EN-05 PKG 게이트 | pkg_gate.py | 10/10 | SSP0005·SCP0028 G2·G3 PASS(G4 는 --no-diff 미측정) | 🩺·🔗 proofTasks S8.pkgGate |
| EN-04 FE 게이트 | fe_gate.py | 9/9 | SSP0005 실제 smoke 68초 통과(F4 세부 FAIL 1 은 참고) | 새 화면 체인 S8.feGate |
| EN-25 사전 점검 | new_screen_precheck.py | 9/9 | SCP0028 READY · SSP0060·SCP0108 NOT_READY · SSP0005 UNKNOWN | 🚀·🧩 체인 S8.precheck |
| EN-02 ② 짝 | pkg_asis_map.py + gen_param_map | 7/7 | 짝 있는 SP 154→165(pkgsrc 39/183) | run_verify 차등 단계 |
| EN-02 ③ 저장 SP | save_diff_targets.py | 12/12 | 저장 SP 짝 61건: 실행 대상 19(ROLLBACK 18·스냅샷 1) · 제외 42 — **실행기 미구현**(저장 인자 포착 경로 없음) | - |
| EN-17 콤보 증명 보강 | facts_combosrc SSP_INNER · combo_oracle | - | 콤보 원천 미해석 108→62행 · SSP0060 B4 PASS 0→1 | CheckList 안 |

미완·한계(추측으로 메우지 않음): EN-02 ③ 실행기 · EN-17 생성기(콤보 SQL 은 번역이 필요해 기계 생성 불가 → AI 제안·combo_oracle 증명) · 차등 검증 잔여 SKIP 사유(인자 미해결·행 키 미확정) · SSP 공통 콤보 원천 마스터 미등록 · 🧯 단독 실행 시 증명 단계 미연결.

### M1+. AS-IS 기능 목록(2026-11-11 17:0x — 사용자 목적 "TO-BE 룰을 지키면서 AS-IS 기능을 완벽하게 구현")
- `tools/Harness/verify/feature_inventory.py`(selftest 10/10): Roslyn 문장 사실(actions.csv·events.csv·lock_rules·cell_rules)에서 기능 단위 목록 `Doc/asisfacts/screens/<ID>/features.csv` 생성 — 유형 VALIDATION·CONFIRM·EXPRESSION·ASSIGN·STATE·LOCK·CELL_RULE·DATA_CALL·CASCADE.
- 실측(17:0x): SSP0060 786건(VALIDATION 28·EXPRESSION 15·STATE 68·CASCADE 6·의미 미확인 외부 호출 111) · SSP0015 866 · SSP0023 510 · SCP0028 65 · SSP0025 58.
- **다음(미구현)**: ① 기능 ↔ CheckList 원장 행 연결(원장 TRACE 행은 대조표 ID `D00-1-001` 체계 — 파일:행과 잇는 대응 확인 필요) → 화면별 "기능 N 중 증명 M·미증명 K" 완성 판정표 ② 의미 미확인 외부 호출(분모 밖) 해소 ③ VALIDATION·EXPRESSION 전용 실행 검사 ④ 전 화면 일괄 생성.
- 판정 기준 CR-101(11-11): 차등 검증 값 불일치 = 판정필요 · TO-BE 조회 실패만 FAIL. 컬럼 ID 만 다른 메타 = 조치 필요(FAIL) 유지(사용자 결정).

### M1++. 남은 일 전수 목록(2026-11-11 17:09 — 사용자 지시 "누락 없이 순차로 · 누락한 채 완료 보고 금지")
- 정정: AS-IS 기능 전수 목록은 이미 있었다(`__asis-actions__.md` · `mapping_trace.py` 2026-10-26). `feature_inventory.py` 는 중복 — 분모로 쓰지 않는다(건수 대조용).
- 정본: `tools/Harness/verify/proof_backlog.py`(selftest 8/8 · 분류 합 = 분모 강제) → `Doc/verify/_proof_backlog.md` · 추이 `_proof_backlog_history.csv`.
- 17:09 실측(E2E 판정 25개 화면): 검사 단위 16,866 · 증명됨 3,764 · 조치 필요 651 · 그 밖 12,451(B02 미실행 2,083 · B13 1,950 · B06 1,535 · B12 1,181 · B08 1,136 · B16 1,005 · B09 846 · B01 566 · B14 449 · B07 380 · B10 331 · B04 300 · B15 254 · B11 219 · B05 137 · B03 79).
- 진행 규칙: 분류 하나씩 처리 → proof_backlog 재실행 → 건수 변화로만 보고. 증명됨 = 분모 전에는 완료라고 쓰지 않는다.

### M1+++. 전수 목록 처리 경과(2026-11-11 17:1x~17:3x) — 다음 세션은 여기부터
- 17:17 재분류: 원장 승계 해당없음의 실제 사유를 읽음 → N1(실측 근거 해당없음) 1,123 · B09(기계 판정 불가 — 수동 확인) 846→2,251 · 상세 `Doc/verify/_proof_backlog_detail.csv`.
- 실행 중(17:16~): `run_verify` SCP0007·SSP0024 → DMF0005·SSP0200 (2개씩 병렬 · 로그 scratchpad/rerun/b02_*.log) — B02 미실행 2,083 중 2,062 가 이 4화면. 끝나면 `proof_backlog.py` 재실행해 변화 기록.
- 수정 T243(효과 미측정): E4 저장 경로 판별을 호출 경로 사실로(_trace.spec.ts saveReach) — B09 E4 424건 대상.
- **다음 작업 1 — AS-IS 잠금 해석(facts_lockrules.py → edit_expect.csv)**: 32개 화면 edit_expect 2,517행 중 (신규,기존) 둘 다 UNKNOWN 709 · 한쪽 UNKNOWN 762. 해석 못 한 호출 형태(건수): `LockRange(v,v,v,v,v)` 변수 범위 1,459 · `LockColumn(v,v,v)` 663 · `LockRange(ActiveRowIndex, GetColumnIndex(DefColumns.X)…)` 444 · `LockRange(i, GetColumnIndex(DefColumns.X)…)` 423+151 · `LockRange2(i,0,i,GetMaxColumnIndex(),b)` 289 · `LockRange2(iRow, GetColumnIndex(DefColumns.X)…)` 263 · `LockRange(i,0|1,i,GetMaxColumnIndex(),b)` 151+136. 컬럼 상수가 명시된 형태·전체 행 형태부터 해석 → 편집 가능 기대값 UNKNOWN 감소 → 연쇄(C3·C6 '원천 편집 불가' 218)·입력(D1·D3) 미판정 해소.
- **다음 작업 2 — 연쇄 원천 분기 해석**(_verify.spec.ts resolveSrc): '원천 컬럼 분기 해석 불가' C3 122·C6 79 — 조건이 `switch (e.Type) case …CellsUpdated ▸ if (e.C…` · `if (si.ActiveSheet.SheetName == …) ▸ if (e.Type == …` 형태.
- **다음 작업 3 — 팝업**(H6 157·M3 70·G5 49 '검사기가 이 대상을 실행하지 못함') · **작업 4** — B01 경로 없음 566 · B04 신규행 전제 307 · B08 대조표 서술 1,136 · B16 해당없음 그 밖 988 재분류.
- 사용자 지시(17:2x): 병렬 가능한 것은 병렬로 · 마무리까지 계속 · 결정이 필요하면 작업을 계속하면서 질문 폼(AskUserQuestion)으로 묻는다.

### M1++++. 2026-11-11 21:1x 상태(세션이 4회 끊김 — 재개 시 프로세스·로그부터 확인)
- CheckList 재실행: SSP0024 18:22 완료 · SCP0007 19:10 완료 · SSP0200 20:50 완료 · **DMF0005 20:50 단독 재실행 중**(18:22 실행분은 18:58 이후 무응답이라 중지 — 원인 미확인 · 멈춘 로그 scratchpad/rerun/b02_DMF0005_hung_1822.log). 끝나면 `proof_backlog.py` 실행해 25개 화면 수치 갱신.
- 20:50 전수 목록(24개 화면 · DMF0005 제외): 검사 단위 15,460 · 증명됨 4,634 · 조치 필요 685 · N1 1,353 · B02 미실행 22(2,083에서) · B09 2,177 · B06 1,163 · B08 1,136 · B16 937 · B01 523 · B14 514 · B07 405 · B04 395.
- 화면별 증명됨: SCP0007 220→821/1,119 · SSP0024 167→354/747 · SSP0200 57→154/1,338.
- 수정(효과 미측정 — 다음 실행부터 반영): T243 E4 저장 경로 판별 · T244~T246 잠금 해석(UNKNOWN 칸 2,180→955) · T247 색·표시 여부 대입을 H2·A5 로 등록.
- **다음**: ① DMF0005 완료 확인 → 전수 목록 ② 오늘 수정 반영을 위해 나머지 화면 CheckList 재실행(2개씩 병렬 · 실행 전 프로세스 중복 확인) ③ B09 잔여: 팝업 H6 157·M3 70·G5 49 '검사기가 이 대상을 실행하지 못함' · E4 위반 입력 115 · 연쇄 '원천 편집 불가' 218(잠금 해석 개선 뒤 재측정) ④ 대상 컬럼 미추출 값 대입 527행(동적 날짜 열 변수) ⑤ 잠금 미해석 62건(DMF 날짜 비교 잠금).

### M1+++++. 2026-11-11 22:40 상태
- DMF0005 22:17 완료(86.7분 · FAIL 149 · 판정필요 18 · 미검증 2,307 — T248 '미검증 표시' 첫 반영 · '문서 시나리오' 84행은 21:20 무응답으로 작업자 중지 → 미검증 · 원인 미확인 · 다음 실행부터 시나리오 이름이 로그에 찍힘 T249).
- 22:37 전수 목록(25개 화면): 검사 단위 16,857 · 증명됨 4,681(17:17 3,764) · 조치 필요 775 · N1 1,482 · B09 2,594 · B06 1,248 · B08 1,136 · B16 966 · B14 943 · B01 555 · B13 423 · B07 407 · B04 402.
- 화면별 증명됨: SCP0007 821/1,119 · SSP0024 354/747 · SSP0200 154/1,338 · DMF0005 47/1,397.
- 22:40 2차 묶음 시작: 나머지 21개 화면 `run_verify` 2개씩 병렬(xargs — 세션이 끊겨도 계속 돈다 · 로그 scratchpad/rerun/b03_run.log·b03_<ID>.log · 화면마다 끝나면 proof_backlog 재생성). 재개 시 프로세스 목록과 b03_run.log 먼저 확인 · 같은 화면 중복 실행 금지.
- 다음 엔진 작업(미착수): 팝업 H6·M3·G5 실행 경로 · E4 위반 입력 확장 · 동적 날짜 열 대상 추적(527행) · 잠금 미해석 62건 · DMF0005 시나리오 무응답 원인.

### M1++++++. 2026-11-12 09:50 상태
- 2차 묶음(21개 화면 · 11-11 22:38 시작): 09:46 기준 17개 종료(전부 rc=0) · SSP0015·SSP0021 실행 중 · SSP0023·SSP0025·SSP0060 대기. 로그 scratchpad/rerun/b03_run.log.
- 09:05 전수 목록(25개 화면): 검사 단위 16,861 · 증명됨 4,490(11-11 22:37 4,681 → **191 감소 · 원인 미확인**). 화면별 직전 수치를 남기지 않아 어느 화면에서 줄었는지 가르지 못함 → 다음 작업 1.
- 09:37 SCP0111 저장 시험이 남긴 DB 세션 5개 종료(T250) · `db_orphan_sessions.py` 신설 · `run_verify.py` 사후 단계 연결 · engine_selfcheck PASS(PY selftest 36).
- SCP0111 저장 PROC 가 사내 DB 에서 끝나지 않음(GT_SCP0111_YIELD_P INSERT 가 SCM_YIELD_VER_H 3.2억 행 전체 읽기) — 화면 결함 후보 · 미조치.
- 다음 작업(순서): ① proof_backlog 에 화면별 수치 추이 저장 + 증명됨 감소 원인(SSP0005 34/425 · 병합 셀 테스트 420초 초과 · Div 선택 측정 경로 실패부터) ② 남은 화면 종료 후 최종 수치 ③ 팝업 H6·M3·G5 실행 경로 ④ E4 위반 입력 확장 ⑤ 동적 날짜 열 대상 추적(527행) ⑥ 잠금 미해석 62건 ⑦ DMF0005 시나리오 무응답 원인.
- 09:55 PKG_SCP0111 보완 적용([E20261112-YIELDP] 수율 임시표 적재를 저장 품목으로 한정 1줄 · VALID · `_artifacts/_apply_corporate/SCP0111_YIELDP_ITEM_20261112/`) → 09:55 SCP0111 CheckList 재시험 시작(로그 scratchpad/rerun/b04_SCP0111.log). 통과하면 클라우드 이관 패키지 생성.
- 10:0x T251 언어 오염(9개 화면 80행 허위 판정) 원인 = 끊긴 언어 전환 미원복 → 전환 기록·자동 복구 추가. SCP0041·SCP0127·SCP0131 재실행 예약(2차 묶음 종료 대기 · b05_*.log · b03_run.log 에 '3차' 줄).
- proof_backlog: 화면별 추이 `_proof_backlog_screen_history.csv` 추가(증명됨 감소 화면 경고). 22:37 → 09:05 감소 191 의 화면별 원인은 직전 수치가 없어 가르지 못함 — 대신 Git 11-09 원장 대비 전환 집계(scratchpad/ledger_regress.py)로 확인: PASS→미검증 678 · PASS→해당없음 467 · PASS→FAIL 107 · 새 PASS 4,020 (14개 화면).
- 남은 다음 작업: ① 3차 재실행·SCP0111 재시험 결과 반영 ② SSP0005 '병합 셀 입력' 420초 초과·Div 선택 측정 경로 실패 원인 ③ 시나리오 테스트 15~22분 초과 5개 화면 원인(로그에 시나리오 이름 있음) ④ 팝업 H6·M3·G5 실행 경로 ⑤ E4 위반 입력 확장 ⑥ 동적 날짜 열 대상 추적(527행) ⑦ 잠금 미해석 62건.
- 10:20~10:27 DB 상시 감시(T253·T254 · 사용자 상시 지시): `db_orphan_sessions.py --watch` 5분 경고·30분 종료 · 대상 = 이 PC + 이 OS 사용자 세션만 · 기록 `Doc/verify/_db_watch.log` · 체인 시작 때 `--ensure-watch`. 1시간 정기 보고 예약(세션 한정 · 재연결 시 다시 등록).
- 11:14 SCP0111 보완 후 재시험 끝: 저장 테스트 3종 통과 · 문서 시나리오 완주 · DB 세션 잔여 0 · 클라우드 패키지 `SCP0111_CLOUD_DB_MOD_20261112_1115`. 단 10:15 전후·10:31 로컬 BE 재기동(내가 한 것 아님)으로 SCP0111 테스트 8개 · SSP0021 테스트 7개 접속 실패 · SSP0015 문서 시나리오 10:31:15 에서 멈춰 22.5분 초과(증명됨 112 → 76).
- 재측정 예약: SCP0111 `--only`(11:16 시작 · b06) → 3차 SCP0041·SCP0127·SCP0131(2차 묶음 종료 대기 · b05) → 4차 SSP0021 `--only` + SSP0015 전체(3차 종료 대기 · b07). b03_run.log 에 각 시작·끝 줄.
- T255 병합 셀 테스트 제한 시간(조회 속도 비례) 반영.

## 주기 방식 (2026-11-12 12:4x 사용자 합의 · 이후 모든 작업의 절차)
기준 실행 1회 → 오류는 고치지 않고 아래 표에 등록 → 전체를 본 뒤 유형별 일괄 보완(확인 = 자기 시험·engine_selfcheck·`--skip-e2e` 재판정만) → 전체 재실행 1회 → 화면별 증명됨 전후 비교.
수정 확인 목적의 화면 재실행(전체·--only) 금지. 즉시 수정 예외 = 나머지 측정을 무효로 만들거나 피해를 내는 것만.

### 주기 1
- 기준 실행 = 2차 묶음(11-11 22:38 시작 · 21개 화면) + 그 전 4개 화면(DMF0005·SCP0007·SSP0024·SSP0200). 12:40 현재 잔여 SSP0021(실행 중)·SSP0025(실행 중)·SSP0060(대기). 3차·4차 재실행은 12:4x 취소.
- 기준 수치는 잔여 3개가 끝난 뒤 `proof_backlog.py` 출력으로 확정(그 전 수치는 실행 중 화면이 빠져 비교 불가).

#### 주기 1 보완 대상 (상태: 대기 | 보완 중 | 보완됨(확인 수단) | 다음 주기 확인)
| # | 유형 | 실측 근거 | 건수(출처) | 상태 |
|---|---|---|---|---|
| C1-01 | 신규행 전제 미충족 — 검사기가 AS-IS Insert 전제(활성 시트·편집 잠금 해제)를 못 맞춤 | SSP0015 InsertRow:7694 `IsLock == false && ActiveSheet == shtBolckStock` · 증거 '[측정 경로 없음] 조회 후 Insert 했으나 신규행 없음' | 원장 1,518행(13:1x 실측 — SSP0015 508 · SSP0060 312 · SSP0021 269 · SSP0023 236 · SSP0200 193) · 전수 목록 B04 386(12:22) | 보완 중 — 13:1x 분석: 시트 선택은 T190 으로 이미 동작(로그 '[Insert 전제] 시트 … 선택' 37회). 5개 화면 전제가 모두 `IsLock(시트) == false && ActiveSheet == 특정 시트`(SSP0200 은 + RowCount > 0). 빠진 것 = 편집 잠금 해제 상태 만들기. TO-BE SSP0015 `ShipmentPlanMobilityIt.tsx:1329-1357` 은 추가로 canEditPlan(최신 Plan·EDIT 권한)·Confirm Detail 은 선택 행 Status C 를 요구 → 다음: 화면별 AS-IS 잠금 해제 경로(EditButton·Plan 조건)를 facts 로 뽑아 검사기가 그 상태를 만든 뒤 Insert |
| C1-02 | 팝업 검사 실행 경로 없음(H6·M3·G5) · 팝업 값 반영 위치 확인 불가 | 증거 '[미검증] 검사기(… smoke popup)가 이 대상을 실행하지 못함' | B05 179 · B01 중 팝업분(미분리) | 대기 |
| C1-03 | 검증 메시지(E4) 위반 입력 생성 부족 | 11-11 M1+++++ 절 | 미측정 | 대기 |
| C1-04 | 값 대입 문장의 동적 날짜 열 대상 추적 불가 | T247 '대상 칸이 siMain.SetText 인 행 527' | 527행 | 대기 |
| C1-05 | 잠금 규칙 미해석 | T246 뒤 잔여 | 62건 | 대기 |
| C1-06 | 기계 판정 불가(수동 확인으로 남김) | 전수 목록 B09 | 2,014(11:14) | 대기 — 사유별 분해부터 |
| C1-07 | 진입점 집계 — 하위 검사 미실행 | 전수 목록 B06 | 1,374(11:14) | 대기 — 사유별 분해부터 |
| C1-08 | 측정 실패·판정 못 함(그 밖) | 전수 목록 B14 | 1,022(11:14) | 대기 — 사유별 분해부터 |
| C1-09 | 대조표 서술 보강(구현 위치·제외 사유) | 전수 목록 B08 | 980 | 대기 |
| C1-10 | 차등 검증 인자 미정·케이스 없음 | 전수 목록 B07 | 256 | 대기 |
| C1-11 | 해당없음 재분류(근거 없는 것 → 미검증) | 전수 목록 B10~B13·B16 | 1,519 | 대기 |
| C1-12 | SSP0005 Division 선택 '측정 경로 실패'(EG022·EG271) | b03_SSP0005.log | 6건 이상(미집계) | 대기 |
| C1-13 | DMF0005 '문서 시나리오' 무응답(11-11 18:58·21:20) | b02 로그 | 시나리오 84행 미판정 | 대기 — 원인 미확인 |
| C1-14 | SSP0023 증명됨 221 → 217 · 검사 단위 1,347 → 1,315 | 화면별 추이 12:22 | 4건 | 대기 — 원인 미확인 |
| C1-15 | SCP0111 차등 대조 요약 21 → 20행(증명됨 49 → 47) | 11:14 ↔ 11:42 | 2건 | 대기 — 원인 미확인 |
| C1-16 | 같은 수율 뷰를 Division 조건만으로 쓰는 SCP0111 저장 PROC 5곳 · 1번 수율 구간 INDEX SKIP SCAN | APPLIED_OPERATIONS 5절 | 6곳 · 실행 시간 미측정 | 대기(DB 객체) |
| C1-17 | 언어 오염 허위 판정(T251) — 오염 행은 원장에 남아 있음 | SCP0041·SCP0127·SCP0131 FAIL(H6·G1) · 그 밖 6개 화면 미검증 | 80행(10:0x 집계 · SCP0111 26행은 11:14 재실행으로 해소) | 보완됨(selftest 11/11) · 다음 주기 확인 |
| C1-18 | 시나리오 언어 대기로 '문서 시나리오' 시간 초과(T252) | SCP0084·SSP0003·SSP0005·SSP0014·SSP0015·SSP0021 | 6개 화면 시나리오 행 | 보완됨(게이트) · 다음 주기 확인 |
| C1-19 | BE 재기동 중 접속 거부(T256) | SSP0021 테스트 7개 · SSP0015 문서 시나리오 | 2개 화면 | 보완됨(게이트) · 다음 주기 확인 |
| C1-20 | '병합 셀' 테스트 제한 시간(T255) | SSP0005·SSP0003·SSP0021(SCP0111 은 11:38 재측정 통과) | 3개 화면 | 보완됨(게이트) · 다음 주기 확인 |
| C1-21 | 부분 재측정이 차등 검증 행을 지움(T257) | SSP0060 원장 ASIS_DIFF 0행(요약 30행) | 120행 | 보완됨(SCP0111 --skip-e2e 복구 확인) · SSP0060 은 기준 실행에서 복구 |
| C1-22 | 조치 필요(FAIL) = 화면 결함 보완 대상(DB 객체 우선 · FE 는 가이드) | 전수 목록 A2 | 715(12:22 · 언어 오염분 포함) | 대기 — 일괄 보완 뒤 유형별 분해 |
| C1-23 | 셀 편집이 연 선택 팝업(User Popup)이 닫히지 않아 Save 버튼 클릭 10초 초과 → 저장 테스트 2개 실패 | SSP0025 13:20 기준 실행: '저장 세부(F1·F6)'·'저장 경로' `locator.click Save` 초과(nscm.ts:673) · 화면샷 test-failed-1.png 에 User Popup 열림 · 증명됨 212 → 162 | 50건(화면별 추이) | 대기 |
| C1-24 | SSP0021 기준 실행(13:02 종료) 미측정분 — BE 재기동 중 테스트 7개 · 병합 셀 7.0분 초과 · 문서 시나리오 27.6분 초과 | b03_SSP0021.log | 실패 테스트 10개 | 보완됨(T252·T255·T256 게이트) · 다음 주기 확인 |

#### 주기 1 작업량 — 보완 유형별(2026-11-12 13:44 · `backlog_types.py` → `Doc/verify/_backlog_types.md` · 입력 = 24개 화면 13:20 집계의 '아직 증명 안 됨' 8,817 · SSP0060 종료 뒤 다시 집계)
건수는 대조표 검사 단위(원장 행 수와 다름). 위 C1 표의 큰 분류(B09·B06·B14)를 '무엇을 고치면 풀리나' 로 다시 묶은 것 — 이후 일괄 보완은 이 유형 순서로 한다.
- 엔진 보완 유형 14개: Y09 검사기가 대상을 실행하지 못함 631(H6 206 · D1 109 · H2 103 …) · Y19 대상 실행 경로 없음 505(B4·B3·G5·DB-SYN·G4 …) · Y02 검증 메시지가 Save 경로 밖 382 · Y04 행 조건식 계산 불가 361 · Y01 신규행 전제 305 · Y05 연쇄 원천 칸 열 수 없음 275 · Y18 팝업 값 반영 위치 199 · Y06 연쇄 분기 해석 불가 142 · Y21 실행됐으나 판정 못 함 127 · Y03 위반 입력 생성 불가 124 · Y10 현재 화면에 대상 없음 114 · Y08 팝업 검사기 실행 못 함 77 · Y12 차등 인자·짝 70 · Y07 콤보 아님 37 = 3,349
- 따라 풀리는 것: Y11 집계 행 2,375(하위 검사 보완 뒤 재집계)
- 분류·문서 작업: Y13 대조표 서술 보강 819 · Y17 해당없음 근거 재확인 766 · Y15 원장 승계 사유 미해석 516 · Y20 설계 결정 근거 확인 168 · Y14 프레임워크 공통 오류 37 = 2,306
- 미분류 787(유형 규칙 추가 대상 — 상위 사유는 _backlog_types.md 끝)
- 유형당 보완 소요 시간은 실측 없음 — 첫 유형들을 끝내며 잰다.

#### 주기 1 기준 수치 확정 (2026-11-12 14:11 · 기준 실행 종료 14:08 '2차 묶음 끝')
- 25개 화면 · 검사 단위 **16,815** · 증명됨 **4,376** · 조치 필요 836 · 근거 있는 해당없음 1,527 · 아직 증명 안 됨 10,076. 사본: `_cycle1_baseline_backlog.csv`(화면×분류) · `_cycle1_baseline_types.csv`(유형).
- 화면별 증명됨/검사 단위(조치 필요): DMF0005 47/1397(90) · SCP0005 204/565(12) · SCP0007 821/1119(79) · SCP0016 245/654(9) · SCP0020 162/555(31) · SCP0028 97/393(14) · SCP0033 233/445(5) · SCP0037 127/335(5) · SCP0041 101/417(41) · SCP0084 84/212(2) · SCP0108 106/543(0) · SCP0111 47/269(11) · SCP0122 176/283(2) · SCP0127 53/169(18) · SCP0131 153/365(17) · SSP0003 51/365(12) · SSP0005 34/425(5) · SSP0014 214/495(2) · SSP0015 76/996(43) · SSP0021 234/1172(95) · SSP0023 217/1315(45) · SSP0024 354/747(8) · SSP0025 162/457(7) · SSP0060 224/1784(140) · SSP0200 154/1338(143)
- 이 기준에는 오늘 확인된 측정 오염이 들어 있다(언어 오염 C1-17 · 시나리오 시간 초과 C1-18 · BE 재기동 C1-19 · 병합 셀 C1-20 · 팝업 미닫힘 C1-23) — 주기 끝 재실행과의 비교 때 이 화면들의 증가는 '오염 해소분' 으로 따로 본다.
- 유형별(10,076): 엔진 보완 14유형 = Y09 668 · Y19 581 · Y02 474 · Y01 387 · Y04 387 · Y05 322 · Y18 231 · Y06 166 · Y03 162 · Y21 145 · Y10 130 · Y08 84 · Y12 82 · Y07 37 = 3,856 / 따라 풀림 Y11 2,673 / 분류·문서 Y13 990 · Y17 894 · Y15 555 · Y20 187 · Y14 40 = 2,666 / 미분류 881.

#### 진행 지점 (10분 작업 호출이 여기서 이어받는다 — 끝낼 때마다 아래에 한 줄 추가)
- 14:12 기준 확정 완료. 다음 = Y01 신규행 전제: ① 5개 화면(SSP0015·SSP0021·SSP0023·SSP0060·SSP0200)의 AS-IS 잠금 해제 경로를 사실로 뽑기(Insert guard 의 `IsLock(시트) == false` 가 참이 되는 조건 — EditButton·조회 뒤 Lock 호출·Plan 조건 문장을 actions.csv/lock_rules.csv 에서) → ② TO-BE 에서 그 상태를 만드는 조작(Edit 버튼·최신 Plan 선택·행 선택) 확인 → ③ `_verify.spec.ts:405-413` 신규행 준비에 '신규 행이 안 생기면 전제 조작 후 재시도' 추가 + selftest. Y01 착수 시각 = 13:05(분석) · 수정 착수 = 미착수.
- 14:2x **Y01 방향 정정(사용자 지적)**: 'TO-BE Edit 버튼을 눌러 편집 잠금 해제' 가설 폐기 — TO-BE 는 편집 버튼이 없고 조회 즉시 상시 편집(CR-084·CR-093 기존 룰). AS-IS guard 의 `IsLock == false` 는 TO-BE 에서 이미 충족. 남은 원인 후보 = TO-BE Insert 의 다른 조건(SSP0015 `ShipmentPlanMobilityIt.tsx:187 canEditPlan = canEdit && isLatestPlan` · :1339-1343 Confirm Detail 은 선택 행 Status C · Hold stock 분기는 미확인) → 다음: 5개 화면 TO-BE handleInsert 조건을 읽어 '검사기가 만들 상태'(최신 Plan 조회 · 행 선택)와 'TO-BE 가 AS-IS 보다 좁게 막는 것(화면 결함 후보)'을 가른다.
- 14:2x 권한 합집합 룰 = CR-102 신규 등록(`confirmed_requirements.csv` 102행 · 룰 원장 재생성). 보완 대상 C1-25 추가: 권한 기대값이 '보유 권한 합집합'(CR-102) 기준인지 — J1~J4·K4·D1 검사기의 기대 계산 점검(검사기 실제 계산 방식 미확인 · 미집계 · 대기).
- 14:29 **Y01(C1-01) 1차 보완 반영**(T259): 행 선택 후 Insert 재시도 + AS-IS 상태 값 조건 사실. selftest 13/13 · 게이트 PASS. 소요: 종료 14:29(`date` 실측) · 기준 확정 14:11 · 방향 정정 기록 14:21(파일 시각) — 구현 착수 시각은 기록하지 않아 유형 소요 시간은 '14:21 이후 8분 안'으로만 말할 수 있다(분석은 13:05 보고 이전부터). 다음 유형부터는 착수·종료를 `date` 로 찍어 이 절에 남긴다. 남은 하위 작업 2건(다른 Insert 6곳 연결 · 시험 계정의 EDIT 권한/SSP 사용자/최신 Plan 조건 확인)은 T259 행에 기록 → 다음 작업 호출에서 ① 6곳 연결을 먼저 하고 Y01 을 '보완됨 · 다음 주기 확인' 으로 닫는다. 그 다음 유형 = Y02 검증 메시지가 Save 경로 밖(474).
- 14:34 **Y01 닫음(보완됨 · 다음 주기 확인)** — 2차: Insert 를 누르는 검사 24곳(_verify 13 · _trace 10 · crud 1)을 `nscm.clickInsert()` 한 곳으로 모음(클릭 뒤 대화상자도 신규 행도 없으면 행 선택 후 재시도 · 시도 내역 `lastInsertTrail`). 착수 14:31:51 → 종료 14:34:35(`date` 실측 · 게이트 1회 실패(TS 옵션 타입) 후 통과). Y01 전체 실측 구간: 1차 종료 14:29 + 2차 2분 44초. 미해결로 남기는 것 = 시험 계정이 TO-BE canEdit(EDIT 권한·SSP 사용자·최신 Plan)을 못 채우는 경우(재실행 증거로 확인).
- 다음 = **Y02 검증 메시지가 Save 경로 밖(474건 · 규칙 E4)**: 증거 '~ 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오에서 판정'. 착수 시 `date` 기록. 볼 곳: `_trace.spec.ts` E4 판정(saveReach — T243) · `Doc/asisfacts/screens/<ID>/actions_entries.csv`(메시지 문장이 어느 진입점에서 닿는지) → 진입점 종류별(셀 변경·버튼·더블클릭) 건수부터 센다.
- 14:49 **Y02 1차**(T260 · 착수 14:41:10 → 14:49:20 `date` 실측 8분 10초 · 질문 폼 대기 포함): 469건을 진입 동작별로 분해(클릭 275 · 버튼 117 · 셀 변경 26 · 붙여넣기 9 · 조회 6 · 더블클릭 3 · 그 밖 33). 편집 버튼 전용 105건 = 사용자 결정으로 해당없음(CR-103 신규) → 검사기 반영.
- Y02 남은 364건(다음 작업): 화면 전용 버튼 경로 — BtnMeasure_Click 120(SSP0060 78 · SSP0021 41 · SSP0023 1) · BtnCancel_Click 94(SSP0200) · BtnApproval_Click 35(SSP0003) · 그 밖 버튼 → '그 버튼을 눌러(쓰기 요청 차단) 위반 상태에서 메시지 확인' 경로가 필요. 기존 `_verify.spec.ts` 화면 전용 버튼 클릭 검사(judgeBtnClick · EG428)가 있으니 거기에 메시지 대조를 붙일 수 있는지부터 확인. 셀 클릭·변경·붙여넣기 경로(약 60건)는 Y05·Y21 과 묶어 본다.
- C1-26 추가: CR-103 의 뒤쪽 절반(조회 때 편집 가능 상태면 편집 가능 컬럼 배경색 변경·편집 가능 / 불가면 조회만)을 검사하는 항목이 D1·H2 에 실제로 있는지 점검 — 미확인 · 대기.
- 14:5x 사용자 추가 지시: **권한이 있는 사람이 조회했을 때 편집이 불가하면 오류** → CR-103 에 병기. C1-26 을 올림: 편집 권한 계정으로 조회 → AS-IS 편집 가능 컬럼(편집 모드 ON 기준 · CR-093)이 TO-BE 에서 편집되는지·배경색이 편집색인지 측정하고 안 되면 FAIL — D1·H2 가 지금 이 판정을 내는지, 시험 계정이 '권한 있는 사람' 인지(예 SSP 화면 `hasButton('EDIT') && isSspUser`)부터 확인. Y01 의 '시험 계정이 canEdit 을 못 채우는 경우' 도 이 기준으로 본다(권한 있는데 Insert·편집이 안 되면 화면 결함).
- 14:5x Y02 조사 중 발견(미해결 · 다음 작업에서 계속): SSP0060 'BtnMeasure_Click 경로 메시지' 78건은 실제로는 서로 다른 메시지(MSG00098·MSG00004·MSG00284 …)의 검사 단위가 **모두 MSG00007 원장 행 하나의 사유를 물려받은 것** — 대조표 추적(mapping_trace)이 E4 검사 단위를 엉뚱한 원장 행에 연결한다(연결 키가 느슨함). Y02 의 '버튼 경로 364건' 은 실제 버튼 경로 메시지 수가 아니라 이 연결 오류가 부풀린 수일 수 있다 → 먼저 mapping_trace 의 E4 연결 규칙(메시지 ID 일치)을 확인·보정하고 건수를 다시 센다. 착수 14:52:05.
- 15:02 **T261 반영**(착수 14:52:05 → 15:02:18 `date` 실측 · 10분 13초 · 사용자 질의 응답 포함): mapping_trace E4 연결 규칙 보정(`e4_scope`) + 자기 시험 8/8. Y02 는 '보완됨(1차 CR-103 · 2차 T261) · 건수는 다음 주기 재실행 뒤 재집계' 로 둔다 — 실제 버튼 경로 메시지(각 화면 고유 메시지 수)는 재집계 뒤에 남는 것만 보완.
- 다음 = **C1-26**(사용자 지시 '권한 있는 사람이 조회했을 때 편집 불가면 오류'): ① D1·H2 검사가 편집 권한 계정으로 '편집 안 됨' 을 FAIL 로 내는지 `_verify.spec.ts`·`judge.py` 에서 확인 ② 시험 계정이 화면별로 편집 권한자인지(명부 users.json · SSP 는 isSspUser 조건) 확인 → 그 다음 Y04 행 조건식 계산 불가(387 · D3).
- 15:06 **C1-26 반영**(T262 · 착수 15:03:54 → 15:06:36 `date` 실측 2분 42초): ① D1 은 'AS-IS 편집 가능 ↔ TO-BE 편집=false' 를 이미 FAIL 로 냄(기준 실행 9건 — SCP0111 6 · SCP0020 3) ② 화면 단위 검사에 '권한 계정 조회 후 편집 0 = FAIL' 분기 추가(AS-IS 편집 가능 시트를 열어 재측정) ③ 시험 계정 minyonglee1 은 SSP 5개 화면 모두 권한자(사내 DB 실측) — 따라서 재실행에서 SSP 화면이 편집·행 추가가 안 되면 화면 결함 쪽으로 본다(최신 Plan 조건 제외).
- 기준 실행의 D1 미검증 큰 덩어리(참고 · 원장 행): 신규행 없음 745(Y01 로 해소 예정) · AS-IS 편집 기대 없음 202 · 조건 평가 불가 134(Y04) · 검사기 미실행 193+63+41(DMF0005 — C1-13 시나리오 무응답과 같은 실행).
- 다음 = **Y04 행 조건식을 행 값으로 풀지 못함(387 · D3)**: 증거 '조건 계산 불가(검사기가 ~ 조건식을 행 값으로 풀지 못함)' — 조건식 꼴별 건수부터(메서드 호출 `GetText(iRow, GetColumnIndex(...))` · `RAW(sErpStatus…)` 지역 변수 · 열 번호). 볼 곳: `tools/E2E/lib/condeval.ts` · `facts_lockrules.py`.
- 15:12 **Y04 1차**(T263 · 착수 15:10:51 → 15:12:02 `date` 실측 · 게이트 포함 약 2분): 조건 평가 불가 817행을 꼴별로 분해(RAW 토큰 330 · 'GetText(iRow…)+else of' 273 · 'else of' 108 · 컬럼 없음 63 · 그 밖 43) → RAW 최다 토큰(상수 우변 171행) 해석 추가.
- Y04 다음(같은 유형 계속): ① 다중 시트 컨트롤 `siDetail.ActiveSheet.SheetName == SpdSheet.shtX` → 평가 가능한 원자 `SHEET=="값"` 로 내보내고 `condeval.ts` 가 지금 재는 시트로 평가 ② `Rows.Count > 0` = 행이 있는 측정에서는 TRUE ③ `bEdit_Mode`(편집 모드 플래그 — TO-BE 상시 편집 CR-093 → ON) · `bEdit_Auth`(권한 계정 기준 CR-103 → TRUE) 접기 ④ DMF0005 391행('GetValue(iRow, …EditFlag…)' 줄 잘림 · 'else of' 중첩 · `COL(E) 없음`) — 원문 조건이 잘린 채 평가기로 가는지 확인.
- 15:24 **Y04 2차**(T264 · 착수 15:20:51 → 15:24:59 `date` 실측 4분 8초): 조건 꼴 4종 해석(행 수 · 편집 모드 토글 · AUTH · SHEET) + 평가기 자기 시험 신설. SSP 5개 화면 사실 재생성 — 남은 미해석: SSP0200 13(`sDivisionID == "40"/"EE"` 지역 변수 · `e.Column == GetColumnIndex(…)` 이벤트 열) · SSP0015 4(`ds.Tables[1].Rows.Count` · 컬럼 Visible) · 헤더 텍스트 비교(SUM 열).
- Y04 다음: ① SSP0200 `sDivisionID`(조회조건 Division 값 → DIV 원자) · 이벤트 열 조건(`e.Column == 열` → 그 컬럼에만 적용) ② DMF0005 391행(GetValue(iRow, …EditFlag…) 줄 잘림 · else of 중첩 · `COL(E) 없음` — 컬럼 이름이 한 글자로 잘려 들어감) ③ SCP0007 `strSel_InputStatus == "C"` 23. 그 뒤 Y05 연쇄 원천 칸.
- 15:34 **Y04 3차**(T265 · 착수 15:31:28 → 15:33:51 `date` 실측 2분 23초): 대소문자 혼합 컬럼 상수 잘림 수정(facts_lockrules). 보완 대상 **C1-27** 추가: 같은 정규식 `DefColumns\.([A-Z0-9_]+)` 이 ledger.py·mapping_trace.py·facts_popup.py 12곳에 있음 — 실측 15:34(scratchpad/mixcase.py): 검증 대상 화면 48개 AS-IS 원문에 대소문자 혼합 컬럼 상수 참조 8,209곳(DMF0003 3,250 · DMF0082 897 · DMF0004 475 · DMF0020 328 · DMF0021 297 … · 이름 상위 Measure 575 · Division 414 · FcstType 375 · DomExp 318 · ItemId 284 — 스타일 속성 이름 등 컬럼이 아닌 것도 섞임) → 다음 작업에서 공용 함수로 모아 일괄 교체.
- Y04 남은 것: SSP0200 `sDivisionID`·이벤트 열 조건 · DMF0005 `columnValue != "LGC…"`(30) · `NowGroupID == "DM Planner"`(8 → GROUP 원자) · `IsEditMode`(3) · 'else of' 중첩 108행 · SCP0007 `strSel_InputStatus`.
- 15:42 **C1-27 반영**(T266 · 착수 15:40:51 → 15:42:51 `date` 실측 2분): 컬럼 상수 이름 정규화 도구 `facts_defcols.py` 신설 · 체인 사실 단계 맨 앞 연결. 읽는 도구들은 손대지 않음. 영향이 큰 화면 = DM 계열(DMF0003 8,265곳) — 기준 실행 25개 화면 중에는 DMF0005(504)·SSP0025(151) 등.
- 주의(다음 주기 비교 때): 이 정규화로 DM 화면의 컬럼 연결이 크게 달라질 수 있다 — 검사 단위 수(분모) 자체가 바뀔 수 있으니 전후 비교는 화면별 분모·증명됨을 함께 본다.
- 다음: Y04 남은 꼴(SSP0200 `sDivisionID`·이벤트 열 · DMF0005 `columnValue != "…"` 30 · `NowGroupID == "DM Planner"` 8 → GROUP 원자 · 'else of' 중첩 108행) → Y05 연쇄 원천 칸(322).
- 15:51 **Y04 4차**(T267 · 착수 15:50:51 → 15:51:53 `date` 실측 1분 2초): e.Row 행 인자 · 세션 그룹 직접 비교 해석. Y04 누적(T263~T267) 뒤 남은 미해석 토큰(15:51 사실 재생성 기준): SSP0023 2 · SSP0060 0 · SSP0021 1 · SSP0200 5 · SSP0015 4 · DMF0005 33 · SCP0007 46.
- Y04 는 여기서 '보완됨(1~4차) · 남은 꼴은 재실행 뒤 재집계' 로 두고 다음 유형으로: **Y05 연쇄 원천 칸을 열 수 없음(322 · C6 202 · C3 107 · C2 13)** — 증거 '원천 ~ 기존행 편집 불가'. 볼 것: 원천 칸이 신규행에서만 편집되는지(그렇다면 Y01 로 신규행이 생기면 해소) vs 검사기가 편집 가능한 행을 못 고르는지. 착수 시 `date`.
- 남은 Y04 꼴(다음 주기 후보): DMF0005 `columnValue != "LGC…"`(지역 변수 columnValue 의 출처) · SCP0007 `strSel_InputStatus`(선택 행 값) · `IsEditMode` 단독 3 · 'else of' 중첩.
- 16:01 **Y05 반영**(T268 · 착수 15:59:55 → 16:01:18 `date` 실측 1분 23초): 연쇄 원천 칸이 열리는 행 찾기(신규행 → 기존행 → 앞 40행). Y05 = '보완됨 · 다음 주기 확인'.
- 주기 1 엔진 유형 진행(16:01): 보완됨 = Y01 신규행 전제 · Y02 저장 경로 밖 메시지(CR-103 + 연결 오류 T261) · Y04 행 조건식(1~4차 · 남은 꼴 있음) · Y05 연쇄 원천 칸 = **4 / 14**. 그 밖에 반영: C1-26(권한 계정 편집 불가 = FAIL) · C1-27(컬럼 상수 정규화).
- 다음 유형(건수 순): **Y09 검사기가 대상을 실행하지 못함(668 · H6 215 · H2 119 · D1 111 · G5 54 · C6 50 …)** → Y19 대상 실행 경로 없음(581) → Y18 팝업 값 반영 위치(231) → Y06 연쇄 분기 해석(166) → Y03 위반 입력(162) → Y21(145) → Y10(130) → Y08(84) → Y12(82) → Y07(37). Y09 는 규칙별로 사유가 달라 H6(팝업 표준)부터 사유를 쪼갠다. 착수 시 `date`.
- 16:12 **Y09 1차**(T269 · 착수 16:02:55 → 16:12:03 `date` 실측 9분 8초 · 그중 DMF0005 `--skip-e2e` 재판정 5분 34초): Y09 668 을 규칙별로 분해 — H6 215 · H2 119(SCP0005 104) · D1 111(DMF0005 104) · G5 54 · C6 50 · C2 33 · A5 29(SCP0037) · B2 13 · B4 12 · B1 10 … **DMF0005 가 477** 을 차지. H6·M3 팝업 문장 → 팝업 실측 상속 추가.
- DMF0005 재판정에서 본 것(주기 끝 비교 때 참고): 사실 단계의 컬럼 상수 정규화(504곳)로 원장 행이 4,634 → 4,470 으로 바뀌고 E2E 결과 190~210건이 '조건 변경(E2E_STALE)' 로 미검증이 됨 — 정규화 뒤 첫 실행은 E2E 를 다시 돌려야 맞는 수치가 나온다(예상된 동작 · 주기 끝 전체 재실행에서 해소).
- Y09 다음: ① H2 119(SCP0005 104 — '실적 구간 색' 계열인지 사유 확인) ② D1 111(DMF0005 — edit_expect 경로 '증거 부족') ③ G5 54(popup_args_check) ④ C6·C2 83(DMF0005 — T268 로 일부 해소 예상) ⑤ A5 29(SCP0037 smoke columns).
- 16:14 **집계 도구 보정**(착수 16:13:36 → 16:14:15 `date` 실측): `_proof_backlog_detail.csv` 는 사유를 전 화면 합쳐 세고 '대표 화면' 1개만 적는다 — 16:12 에 그 대표 화면으로 "Y09 668 중 DMF0005 477" 이라고 적은 것은 **근거가 틀린 수치**(대표 화면 합이지 화면별 건수가 아님). → `proof_backlog.py` 가 `_proof_backlog_detail_by_screen.csv`(분류·규칙·사유·화면·건수)를, `backlog_types.py` 가 `_backlog_types_by_screen.csv`(유형·화면·규칙·건수)를 함께 쓰도록 보완. 화면별 수치는 이 파일로만 말한다.
- 16:14 현재 집계(주의: DMF0005 는 16:10 `--skip-e2e` 재판정본 · SCP0111 은 11:42 재판정본이라 14:11 기준과 다름 — 기준 사본은 `_cycle1_baseline_*.csv` 그대로): 검사 단위 16,840 · 증명됨 4,399 · 조치 필요 792 · 아직 증명 안 됨 10,240. 유형×화면 실측: Y09 875(DMF0005 500 · SSP0023 74 · SSP0015 64 · SSP0060 37 · SSP0021 35 · SSP0200 29 — 규칙 D3 211 · H6 202 · H2 119 · D1 111 · G5 54) · Y02 474(SSP0200 109 · SSP0060 92 · SSP0015 75 · SSP0021 55 · SSP0003 48) · Y01 387(SSP0200 94 · SSP0023 83 · SSP0060 82 · SSP0015 63 · SSP0021 51 · SCP0028 14) · Y05 322(SSP 5개 화면 290 · SCP0037 16) · Y04 189(DMF0005 60 · SSP0200 43 …).
- Y09 다음(화면별 실측 기준): DMF0005 500 을 규칙별로(`_backlog_types_by_screen.csv` type=Y09·menu_id=DMF0005) 쪼개 큰 것부터 — D3 가 211 로 가장 큼(조건부 잠금 검사 미실행).
- 16:22 **Y09 2차**(T270 · 착수 16:20:58 → 16:22:37 `date` 실측 1분 39초): DMF0005 500건의 원인 = 결과 파일을 스펙 끝에 한 번만 써서 11-11 강제 종료 때 앞 테스트 결과가 소실 → 테스트마다 기록하도록 수정. Y09 에서 DMF0005 를 빼면 375(SSP0023 74 · SSP0015 64 · SSP0060 37 · SSP0021 35 · SSP0200 29 · SCP0016 17 …).
- Y09 다음: DMF0005 외 375 를 `_backlog_types_by_screen.csv` 로 규칙별 분해(SSP 화면 D3·H2 가 큰지) → 팝업 인자 G5 · A5(SCP0037 smoke columns). 그 뒤 Y19 대상 실행 경로 없음(581).
- 16:33 **Y19 1차**(T271 · 착수 16:31:29 → 16:33:14 `date` 실측 1분 45초): 콤보 검사의 적용성(콤보가 아닌 칸 = 근거 있는 해당없음). SSP0060 표본 76 → 48.
- Y19 다음(진짜 연결 누락): ① 콤보 원천(combo_src.csv)이 있는 그리드 컬럼·조회조건인데 원장 B4·B3·B1·B2 행이 없는 것 — `ledger.py` 의 콤보 행 생성 조건 확인(조회조건은 만들고 그리드 컬럼은 일부만) ② DB-SYN 61(SP 대상) ③ G4 60(BTN) ④ G5 63 · H6 45(COL) ⑤ E5 23. 남은 유형: Y18 팝업 값 반영 위치 231 · Y06 166 · Y03 162 · Y21 145 · Y10 130 · Y08 84 · Y12 82 · Y07 37.
- 16:42 **Y19 2차**(T272 · 착수 16:40:51 → 16:42:03 `date` 실측 1분 12초): 원장 COLUMN 행 ↔ 검사 단위 연결이 여러 단어 시트 이름에서 끊기던 결함 수정(영향 원장 행 10,675 — SSP·DM 화면). 이 수정 뒤에는 '연결 없음 = 해당없음' 으로 가려졌던 단위가 원장 행 상태를 따라가므로 미검증이 일시 늘어 보인다(SSP0060 +27) — 악화가 아니라 연결 복구.
- 주기 끝 비교 때 유의(누적): ① 컬럼 상수 정규화(T266) ② 시트 이름 공백 연결(T272) ③ 결과 유실 방지(T270) 는 분모·연결 자체를 바꾼다 — 화면별 '검사 단위' 수와 '증명됨' 을 함께 비교.
- Y19 남은 것: DB-SYN 61(SP) · G4 60(BTN) · G5 63 · H6 45 · E5 23 · 콤보 원천은 있는데 원장 행이 없는 조회조건(clbResultType 류). 다음 작업에서 G4(버튼)·DB-SYN(SP) 사유 확인 → 그 뒤 Y18.
- 16:52 **Y19 3차**(T273 · 착수 16:50:50 → 16:52:13 `date` 실측 1분 23초): DB 접근 검사 ↔ AS-IS SP 대상을 짝 표로 연결. SSP0060 표본의 '실행 경로 없음' 누적: 76 → 48(T271) → 42(T272) → 41(T273). 남은 41 = G4 7(조회 영역 버튼 btnMeasure·btnItemId … — 조회조건 표시 검사를 버튼에 붙인 것) · B4 6 · DB-SYN 6(짝 없음 → Y12) · H6 5 · G5 5 · B1 4 · B2 4 · B3 3 · G03-WIRE 1.
- Y19 는 여기까지(보완됨 1~3차). 남긴 것: G4×BTN 적용성(조회 영역 버튼에 조회조건 표시 검사가 맞는지 — 규칙 정의 확인 필요) · 진짜 콤보인데 원장 행이 없는 조회조건(clbResultType 류) · 팝업 대상 H6·G5(→ Y18·Y08 과 함께).
- 다음 = **Y12 짝 미매칭(82 + DB-SYN 잔여)**: sp_pair.csv 에서 tobe_proc 가 빈 AS-IS SP 목록(화면별)과 사유 — 콤보 SQL 로 대체된 것(DM0003_GET_BUCKET_TYPE_CODE 류 = sp_replaced.csv 대상)과 진짜 미매칭을 가른다. 그 뒤 Y18.
- 17:02 **Y12 확인 + Y18 반영**(착수 17:00:51 → 17:02:14 `date` 실측 1분 23초 · T274):
  - Y12: 짝 표(sp_pair.csv 212행)에서 25개 화면의 TO-BE 미매칭 = 25행 · AS-IS SP 17종 — DM0003_GET_BUCKET_TYPE_CODE(5) · SSP0200_GET_SHIPMENT_DIVISION(2) · PR_SCM_SYS_LOG_BATCH(2) · SCM0001_GET_LOOKUP_VALUES(2) · SSP0002_GET_NERP_CODE(2) · SSP0200_GET_ITEM_FROM_BOD · SCP0005_GET_DISTRIBUTION_ROUTEID · SCP0005_SAVE_DISTRIBUTION_ROUTE · SCP0084_GET_MONTH_RANGE · SCP0040_SAVE_CHARACTERISTIC_CAPA · SCP0111_SAVE_INTEGRATION_PSI_ADMIN · SSP0021_SAVE_HOLD_STOCK_DATA · SSP0021/SSP0060_DELETE_SHIPMENT_REQUEST_DRAFTING · UP_FX_GETCOMMONDATALIST_DM · SCM0001_GET_SITE_INFO_BY_DIVISION(+ 대체 목록 1). 각각의 TO-BE 대응(콤보 SQL 대체 · 다른 PKG · 미구현)은 이름으로 추정하지 않는다 — **사용자 확인 대기 목록**(정기 보고에 올림). Y12 의 나머지(파라미터 미정)는 차등 검증 인자 문제로 별도.
  - Y18: 팝업 값 반영 검사가 트리거 칸의 그리드·행을 찾도록 보완.
- 엔진 유형 진행(17:02): 손댄 유형 8 / 14 — Y01 · Y02 · Y04 · Y05 · Y09 · Y19 · Y18 · (Y12 확인만). 남은 유형: Y06 연쇄 분기 해석 166 · Y03 위반 입력 162 · Y21 실행됐으나 판정 못 함 145 · Y10 현재 화면에 대상 없음 130 · Y08 팝업 검사기 실행 못 함 84 · Y07 37.
- 다음 = Y08(M3 84 — 팝업 내부 조회 검사가 팝업을 못 여는 것 · T274 와 같은 원인인지) → Y10 → Y21 → Y06 → Y03.
- 17:11 **주기 1 전체 재실행 시작**(16:30 정기 보고에서 예고 — 이견 없음): `scratchpad/cycle1_rerun.sh` · 로그 `scratchpad/rerun/b10_run.log` · 화면별 `b10_<ID>.log`. ① 시험 화면 SCP0028 1개 먼저(오늘 고친 스펙이 실제로 도는지 — 스펙 예외 0 · 통과 테스트 30 이상 · rc 0) → ② 통과하면 나머지 24개 2개씩 병렬 → 끝에 유형 재집계. 미달이면 '중단' 줄을 남기고 멈춘다.
- ⚠ 재실행 중에는 검증엔진 파일을 고치지 않는다(10분 작업 호출 해제 · 1시간 정기 보고만 유지). 그 사이 발견한 것은 아래 '주기 2 보완 대상' 에만 적는다.
- 주기 1 에서 손대지 않고 넘긴 유형(주기 2 후보): Y08 팝업 내부 조회 70 · Y10 현재 화면에 대상 없음 110 · Y21 실행됐으나 판정 못 함 168 · Y06 연쇄 분기 해석 166 · Y03 위반 입력 162 · Y07 37 · Y19 잔여(G4×BTN 적용성 · 원장 행 없는 조회조건 콤보) · Y04 잔여 꼴 · Y12 짝 미매칭 17종(사용자 확인 대기) · C1-13 DMF0005 시나리오 무응답 원인 · C1-16 SCP0111 수율 뷰 나머지 5곳.

### 주기 2 보완 대상(재실행 중 발견분 — 여기에만 적는다)

## AS-IS Live — AS-IS 런처 실구동 연결 (2026-11-12 · 승인 플랜 `~/.claude/plans/velvet-conjuring-lake.md`)
AS-IS WinForms 를 이 PC 에서 실제로 구동해(호스트 `tools/AsisLive/host` · 프로세스 안 구동 · AS-IS 소스 무수정) 화면 열기·조회 → 덤프·캡처·서버 호출(DbProfile)을 모은다.

| 단계 | 내용 | 상태(실측 시각) |
|---|---|---|
| P0 | 시범 SSP0021 게이트(열림·그리드 덤프·캡처·호출 기록) | 통과 11-12 17:13 — 그리드 7시트·주 그리드 108행 = 상태바 Total 108 · 화면 호출 98건 |
| P1 | VM 작업 `S1.live`·`S1.liveCheck` · 메뉴 🎥·🧪 · 환경 도구 `tools/AsisLocal` | 완료 11-12 17:37 (VS Code 창 메뉴 클릭은 미검증) |
| P2 | `asis_live_ingest.py` → `Doc/verify/<ID>/asis_live/`(live_calls · live_vs_static · live_vs_diff · param_hint) · `run_verify.py` diff 단계 끝에 연결 | 완료 11-12 17:4x — engine_selfcheck PASS · SSP0021 ingest rc 0 |
| P3 | 문서에 AS-IS 실측 시트 — 공통 `asis_live_doc.py`(개요·캡처·호출 SP·조회조건·그리드) → 테스트 결과서 'AS-IS 실측' · 화면설계서·UI분석서 '부록.AS-IS 실측'(번호 붙은 표준 시트 8·10 은 불변 · 실측 없으면 시트 없음) | 완료 11-12 17:5x — SSP0021 임시 폴더 생성 확인(설계서 9시트·분석서 11시트 · 캡처 2 · 호출 98(화면 고유 7) · 조회조건 21 · 그리드 7). 정식 문서 폴더 새 판은 만들지 않음(다음 문서 생성 때 반영) |
| P4 | 체인 5종(full·docs·new-asis-full·autofix-full·testreport)에 `S1.live` 선택 단계(실측 없을 때만) · 보완·변환 프롬프트 5종에 [AS-IS 실측 참고] 문단 | 완료 11-12 — quick.json JSON·형식 확인 · VS Code 창 체인 실행은 미검증 |
| P5 | 전 화면 일괄 · 조건 시나리오(같은 조건 실측) · 저장 인자 포착 | 미착수 |

- **P2 에서 하지 않은 것(사유)**: ① 원장 행(source=ASIS_LIVE) 미생성 — 실측 조건이 AS-IS 화면 기본값이라 TO-BE E2E 조건과 같다는 보장이 없어 판정 기대값·전제가 성립하지 않는다(허위 FAIL·분모 왜곡 방지). 같은 조건 실측(P5 조건 시나리오) 뒤에 추가. ② `diff_verify.py` 인자 자동 주입 안 함 — SSP0021 실측에서 미해결 인자 3건 모두 '실측 호출 없음'이라 채울 값이 없었고, 사용자·세션성 인자를 다른 계정 실측값으로 채우면 권한 범위 차이가 DIFF 로 나올 수 있다. 후보는 `param_hint.csv` 로만 제시.
- **SSP0021 실측이 드러낸 것(11-12 17:36 실측 · 17:4x ingest)**: 주 조회 `SSP0021_GET_SHIPMENT_PLAN` 은 차등 검증 12건 전부 SKIP(kind=SAVE — SP 안 DML 이라 직접 실행 금지) → 주 그리드 결과가 대조되지 않고 있었다. AS-IS 실측에는 108건·인자 11개가 있다(`live_vs_diff.csv` gap=LIVE_CAN_FILL). `SSP0021_GET_SHIPMENT_FROM_SITE`(2026-02 변경 E20260206-001938)는 실측에만 있고 정적 사실 endpoints.csv·sp_pair.csv 에 없다(LIVE_ONLY — Fact Pack 재생성·TO-BE 짝 확인 대상).
- 실행: `python tools/AsisLive/asis_live_run.py <ID>`(동시 실행 잠금 `Doc/asislive/_run.lock`) → `python tools/Harness/verify/asis_live_ingest.py <ID>`.
- 17:52 **T275 즉시 보완(측정 무효 예외)**: 시험 화면 SCP0028 에서 결과 파일 쓰기 실패 4건(UNKNOWN: unknown error, open) 실측 → `tools/E2E/playwright.config.ts` 에 fs 쓰기 재시도. 나머지 24개 시작 전에 반영(17:52 시점 SCP0028 은 E2E 팝업·권한 단계). SCP0028 자체는 재시도 없이 돈 구간이 있어 C1·C4 · 팝업 PICK #2 결과가 빠졌을 수 있음 → 비교 때 구분.
- 주기 2 대상 추가: (a) Python 도구 쪽 파일 쓰기도 같은 실패가 나는지 b10_*.log 의 'Errno 22|OSError' 로 집계 후 공용 쓰기 함수 검토 (b) SCP0028 '[Insert 전제] … 신규 행 없음' 12줄 — 행 선택 재시도로도 신규 행이 안 생김(원인 미확인) (c) AS-IS 실행(다른 세션 · tools/AsisLive) 산출물이 정해지면 Y06·Y03·Y21·Y04 잔여는 그 실측을 기준으로 다시 나눈다 — 이 세션에서 원문 해석 엔진을 먼저 늘리지 않는다.
- 18:22 정기 확인: SCP0028 끝(17:12:00~17:54:09 · rc 0 · 통과 86 · 실패 5 · 스펙 예외 0) → 검사 단위 393 그대로 · 증명됨 97 → 109(+12) · 조치 필요 14 → 12 · N1 18 → 24 · B09 41 → 21 · B14 20 → 27. 24개는 17:54:11 시작(DMF0005 · SCP0005 가 4/8 단계). T275 동작 실측: DMF0005 로그 '[파일 쓰기 재시도]' 3줄 · 쓰기 실패 0(SCP0028 은 재시도 전 구간에서 쓰기 실패 문구 10줄). DB 감시 5분 경고 0 · 30분 종료 0.
- 주기 2 대상 추가: (d) SCP0028 B14 '측정 실패·판정 못 함' 20 → 27 — 쓰기 실패로 빠진 결과(C1·C4 · 팝업 PICK)인지 다른 원인인지 행 단위 확인 (e) SCP0028 실패 테스트 5건 중 쓰기 실패가 아닌 것(권한 계정 순회 등) 원인 확인.
- 20:22 정기 확인: 끝 2/25(SCP0028 · SCP0005 565→569 · 증명됨 204→205 · 조치 필요 12→8) · 도는 중 DMF0005(4/8 · 통과 55) · SCP0007(4/8 · 통과 54). DB 감시 경고 0 · 종료 0 · 스펙 예외 0 · 시간 초과 0.
- 주기 2 대상 추가: (f) **DMF0005 시나리오 무응답 재현(C1-13)** — 시나리오 테스트 19:28:13 시작 · 72번째 줄 '[자동] ATTRIBUTE9 기존 행 셀 Copy → 신규 행 붙여넣기 — 후보 밖 값(비활성 등) 행에서 복사' 19:53:39 시작 뒤 20:22 까지 로그 갱신 없음(28분) · 작업 프로세스 4368 살아 있음. 테스트 상한 = max(900초, 행 수×150초)(_verify.spec.ts:2420)라 스스로 끝날 때까지 둔다(개입 안 함). 시나리오 1건당 상한이 없어 한 건이 전체 상한을 다 쓴다 → 건당 상한 + 건너뛰고 미검증 기록 필요 (g) SCP0005 증명됨 +1 뿐 — 오늘 보완이 이 화면에서 효과가 작은 이유를 유형별로 확인.

- (11-12 21:16) AS-IS Live P5 1차 일괄: 238 화면 OK 225 · NA 6 · FAIL 4 · ERROR 3 (`Doc/asislive/_summary.csv`). 조회까지 된 화면 = 상태바 신호 101. 2차 대상 84행 = `Doc/asislive/_pass2_targets.csv` (필수 조건 미입력 대화상자 50 · 신호 없음 30 · 열기 실패 4). 2차 채움 규칙은 사용자 확인 대기.
- 22:22 정기 확인: 끝 3/25(SCP0028 · SCP0005 · SCP0007 19:22:03~21:35:00 rc 0 · 통과 88 · 실패 0) · 도는 중 DMF0005(시나리오 무응답 계속 · 작업 프로세스 CPU 1705초 그대로 · 상한 22:58 전후) · SCP0016(4/8 · 통과 66). DB 감시 경고 0 · 종료 0.
- 주기 2 대상 추가 — **(h) ⚠ SCP0007 증명됨 감소 821 → 714(−107)** · 검사 단위 1119 → 1118 · 조치 필요 79 그대로. 분류 이동(기준 → 재실행): B06 하위 검사 미실행 4 → 33 · B09 기계 판정 불가 2 → 30 · N1 해당없음(실측 근거) 115 → 140 · B14 측정 실패 31 → 52 · B12 21 → 28. B14 사유 상위: '시트의 그리드를 화면에서 찾지 못함 — 표시 여부 미측정(T203)' 18 · '조건부(행 값으로 계산 불가)' 14+. 오늘 보완 중 어느 것이 원인인지 미확인(후보로 볼 것: T272 시트명 연결 변경 · T266 Def 정규화 · T263~T267 잠금 조건 해석 · 탭/그리드 선택 변경). 종전 PASS 가 잘못된 대상을 잰 허위 PASS 였는지, 이번 측정이 퇴행인지 행 단위(verify_ledger 전후 · e2e_results)로 가른다. 주기 2 의 1순위.

- (11-12 23:20) AS-IS Live P5 2차(최근 값 채움) 1회차: 대상 84 중 76 측정 · 대화상자→조회 완료 16 · 행 있음 0→13 화면 · 8개 미측정(DB 부하로 메뉴 조회 30초 초과 → 런처 세션 실패). 결함 수정: 조회 완료 판정이 25초 넘는 조회를 '호출 없음'으로 오판(호출 기록은 끝나야 남음) → 실행 중 요청 확인(db_inflight) + 다음 화면 전 종료 대기(wait_db_clear) 추가. 보충 43개(_pass2b_targets.csv) 재측정 중. DMF0022 Version 팝업 = 개발 DB 열 제목 0행(DMF0073·Division 40/81/82)으로 예외 창. 표 = Doc/asislive/_summary.csv · 1회차 보존 _summary_pass2a.csv
- (11-13 00:55) AS-IS Live P5 2차 종료(보충 43개 · 94분 · 세션 1회 · 중단 없음): 전체 238 = OK 226 · NA 6 · FAIL 4 · ERROR 2 / OK 중 조회 완료 154(1차 101) · 완료 신호 없음 54(75) · 대화상자 18(49) · 행 있는 화면 127(94). 2차 대상 84 중 조회 완료로 바뀐 것 53. 남은 31 = 대화상자 18(Plan ID 목록 빔 7·Material 4·시스템 오류 2·Plan date 빔 2·DMF0022 팝업 예외·기타 2) · 완료 신호 없음 7 · 열기 실패 4 · 헤더 미측정 2. DMF Version 팝업 7/8 성공(맨 위 행 기록). 표 보존 _summary_pass2b.csv
- 11-13 01:22 정기 확인: 끝 8/25 — 검사 단위 5,463 → 5,493 · 증명됨 1,936 → 2,050(+114) · 조치 필요 245 → 260. 화면별 증명됨: SCP0028 97→109 · SCP0005 204→205 · SCP0007 821→714 · SCP0016 245→260 · DMF0005 47→200(기준 실행은 결과 저장 소실분 포함) · SCP0020 162→173 · SCP0033 233→252 · SCP0037 127→137(조치 필요 5→8). 도는 중 SCP0041 · SCP0084.
- DB 5분 경고 1건(_db_watch.log): 00:50:56 sid=836,40484 SCMP_APP 357초째(시작 00:44:59) · 대기 'Allocate UGA memory from OS' · SQL 'SELECT A.DIVISION_ID, A.SCM_SITE_ID, B.SITE_DESCRIPTION, A.ITEM_ID, FN_GET_ITEM_NICKNAME(…) …'. 30분 종료 없음 · 01:22:31 조회에서 10분 이상 세션 0. 주기 2 대상 (i): 이 조회가 어느 화면·PROC 인지(그 시각 도는 화면 = SCP0037 · SCP0041) 확인하고 5분 넘는 조회를 조치 필요로 올릴지 판단.
- 11-13 02:22 정기 확인: 끝 10/25(로그 기준) — SCP0084 01:01:54~01:36:31(검사 단위 212→240 · 증명됨 84→99 · 조치 필요 2→2) · SCP0108 01:36:33~01:47:25 **E2E 미실행으로 끝남**. E2E 를 돈 9개 합: 검사 단위 5,675→5,733 · 증명됨 2,020→2,149(+129) · 조치 필요 247→262. 도는 중 SCP0041(4/8) · SCP0111(4/8). DB 경고 추가 없음(누계 1) · 종료 0.
- **SCP0108 E2E 건너뜀(사용자 확인 대기)**: syn_check 가 '메뉴 메타 없음(또는 USE_YN=N)' · 'PROC_M 배선 없음' 2건으로 차단 → 4·5단계 건너뜀. 근거(Doc/tobefacts/db/menu.csv · 내보낸 시각 11-12 22:23:20): 메뉴 행 SCP0108 이 USE_YN=N(최종 수정 minyonglee1 2026-11-12 16:25:15 · 종전 커밋본은 Y) · 같은 화면 경로(supply/capa-lob-report)의 새 메뉴 행 MNU_ID='LOB Report'(상위 'Capa Plan' · 생성 minyonglee1 2026-11-12 16:25:52 · USE_YN=Y). proc_meta.csv 에는 SCP0108 행 9개가 있는데 'PROC_M 배선 없음' 으로 나온 이유는 미확인. 기준 실행(11:04)은 변경 전이라 E2E 가 돌았다(증명됨 106). DB 는 건드리지 않았다.
- 주기 2 대상 추가: (j) SCP0108 — 메뉴 메타 변경이 의도인지 사용자 확인 후 재측정 · proc_meta 9행인데 배선 없음 판정이 난 경로 확인 (k) SCP0108 이 _proof_backlog.csv 에서 0행으로 빠짐(기준 543) · 화면 이력에도 줄 없음 — E2E 건너뛴 화면이 남은 일 목록에서 사라지는 것은 누락이므로 proof_backlog 가 '미검증' 으로 유지하게 한다.
- (11-13 05:10) AS-IS Live P5 2차 잔여 처리: 채움 규칙 보완(FP 고유 달력·계획일 12개 순차·Rel. 체크·Division 체크 목록) + 로컬 조회 정의 인자 2건 추가(_asis_local SCP.foxml: SCP0015_GET_PLAN_MST p_group_id · SCP0085_GET_ENDING_INVENTORY p_profit_center · 원본 미수정). 재측정으로 FP00609·FP00621·FP00622·FP00634·SSP0017·SCP0015·SCP0085 조회 완료. 개발 DB 상태로 남김: DMF0022(DMF0073 열 제목 0행) · DMF0081(DMF0081_GET_SPREAD_TITLE 없음) · SCP0115(Plant Date 0건). 표 보존 _summary_pass2c.csv
- (11-13 05:23) AS-IS Live P5 실측 → 엔진 반영 전 화면 1회차: asis_live_ingest 를 238 화면에 실행(표 Doc/asislive/_ingest_summary.csv) = 반영 222 · 미측정 12(실측 없음·FAIL·ERROR) · 제외 4(Material 필수 FP02510·FP02800N·SCP0008·SCP0038 — 사용자 결정 11-13). SP 대조: 일치 395 · 정적에만(기본 조회로 안 불림) 649 · 실측에만 204(110 화면) · 프레임워크 1371 · 인라인 654 · 정적 사실 파일 없음 23 화면(FP). 차등 검증 연계: 실측으로 채울 수 있음 2(SCP0005·SSP0021) · 인자 후보 180건(14 화면). 결함 보정: ingest 가 FP 인라인 SQL·로그 기록·분배 프로시저를 SP 로 오인(LIVE_ONLY 490→204). 미해결: 'SELECT' 이름 15건 분류, 원장 행은 조건 시나리오 전이라 미생성.
- (11-13 05:25) 사용자 결정: FP 화면 전체를 이번 AS-IS Live 대상에서 제외(11-13). 이후 집계·조건 시나리오·원장 반영은 DMF·SCP·SSP·SCM 만. FP 실측 산출물(Doc/asislive/FP*)은 삭제하지 않고 보존.
- (11-13 05:35) AS-IS Live P5 조건 시나리오 1회차(FP 제외 · TO-BE 호출 기록 있는 24 화면): 도구 신설 asis_live_cond.py(조건 대조 · 대표 TO-BE 조건 고정 cond_target.json) · asis_live_scen.py(값으로 컨트롤 찾아 시나리오 생성) · 일괄 --scenario-tobe. 대조 = 같은 조건 4(SCP0005·SCP0084·SCP0131·SSP0023) · 조건 다름 17 · 이름 다른 인자 1 · 짝 없음 2. 시나리오 8 화면 재측정 → 조건이 맞춰진 것 1(SSP0200 · 사용자 인자만 다름) · 부분 7. 남은 결함 4: ① 시트가 여럿인 화면은 시트별 대표 조건이 서로 다른 시험에서 뽑힘(한 번의 조회로 못 맞춤) ② 채움 규칙이 시나리오 값을 덮음(SSP0015 Division 40→81) ③ run.json 의 시나리오 기록이 채움 기록으로 덮임 ④ 값을 넣으면 딸린 목록(Version 등)이 바뀌어 반복 필요(SCP0016). 원장 행 미생성 유지.
- (11-13 05:53) AS-IS Live P5 조건 시나리오 2회차(결함 4건 수정 후 · 17 화면 · 기본 재측정 → 최대 3회 반복): 조건이 완전히 맞춰진 화면 0. 끝 상태 = 같은 조건 3(SCP0005·SCP0084·SCP0131) · 이름 다른 인자 1 · 조건 다름 16 · 짝 없음 4. 막힌 원인(실측): ① 차이 대부분이 "전체" 표현 차이(AS-IS 전체 목록/빈값 ↔ TO-BE ALL/빈값) — 같은 조건인지 판단 규칙 없음 ② TO-BE 값이 AS-IS 개발 DB 에 없음(SSP0015 Division 40 = AS-IS Plan date 0건 · SCP0016 Version SP_W_20260824 미적용) ③ 값을 넣어도 조회 인자에 반영 안 됨(SCP0111 Plan date · SCP0041 기간). 원장 행 미생성 유지. 다음 결정 필요.
- (11-13 05:57) 사용자 결정 반영: AS-IS 전체 목록·빈값 ↔ TO-BE ALL·빈값 = 같은 조건(asis_live_cond.py equiv · ALL_SAME/ORDER_SAME). 재대조(--repin · 24 화면) = 같은 조건 6 · 이름 다른 인자 3 · 조건 다름 13 · 짝 없음 2. 주의: 같은 조건인데 건수 차이가 큰 화면 있음(SCP0037 328/3345 · SCP0033 54/111) — 원인 미확인.
- (11-13 06:29) AS-IS Live 건수 차이 원인 확인: ① TO-BE 호출 기록(calls/*.json)의 rows 는 결과 행 수가 아님 — 차등 검증 tobe_rows 대비 화면마다 일정 수 초과(대부분 +1 · SCP0037 +3017 · SCP0033 +56 · 20 화면 실측) → asis_live_cond.py 가 건수 비교를 diff_summary.csv 의 tobe_rows 로 하도록 수정(rows_cmp 열). ② 주 조회 시트 조건이 같은 13 화면: 건수 같음 9(SCP0005·0037·0084·0127·0131·SSP0023·0024·0025·0200) · 다름 3 · TO-BE 행 수 없음 1(SCP0108). ③ 다름 3: SCP0028 = 런처 실측 1735(사이트·공정 목록 전송) ↔ 차등 검증 AS-IS 1940(빈값 가정)=TO-BE 1940 → 차등 검증의 AS-IS 인자 가정이 실제 화면과 다름(결함 후보 · 계정 차이 가능 jaeuk.shin↔minyonglee1 미확인) · SCP0007 = 실측 15317 ↔ 차등 AS-IS 14254 / TO-BE 16439 · SCP0033 = 54 ↔ TO-BE 55(차등 검증 기존 DIFF 와 동일).
- (11-13 06:40) SCP0028 건수 차이 원인 확정(AS-IS DB 실측): 차이 205행은 전부 p_to_site 때문(from_site·operation_group 은 빈값으로 바꿔도 1735 그대로 · to_site 만 빈값 → 1940). 205행의 to_site 10종(Daimler_DE_KAZ 45 · WA 40 · Ford_MX_CUT 30 · HZP 25 · Audi_BE_BRU 20 · Forsee_FR_MCR 15 · OC 10 · Volvo_FR_HRB 10 · Porsche_DE_SSN 5 · Audi_HU_GYO 5)은 화면 To Site 목록(ToSiteByDivision · 81 · 475건)에 없음. 계정 차이 아님(jaeuk.shin·minyonglee1 둘 다 475건 · 겹침 0). 결론: AS-IS 화면은 전체 선택이어도 목록에 없는 도착 사이트 205행을 보여 주지 않고, TO-BE(ALL)는 1940행을 보여 줌 → 화면 동작 차이 후보. 차등 검증의 PASS(AS-IS 인자 빈값 가정)는 실제 화면 인자와 달라 허위 PASS 후보. 보완은 하지 않음(검증 단계).
- (11-13 06:47) 사용자 결정: 조건이 같아도 AS-IS·TO-BE DB 가 달라 건수가 다를 수 있음 → 오류·결함 아님, **판정필요**로 둔다(CR-101 과 같은 취지). asis_live_cond.py rows_cmp '다름' → '판정필요'. 위 SCP0028·SCP0007·SCP0033 건수 차이도 판정필요(결함 후보 표현 정정).
- (11-13 06:52) 플랜 확장 P6(사용자 지시): 동적 시나리오를 소스 분기에서 직접 도출 — 조회용·조회저장·권한별·Division별. 1차 분류(146 화면 · _scenario_types.csv) = 조회용 33 · 조회·저장 112(권한 분기 흔적 56 · Division 분기 흔적 100) · 정적 사실 없음 1. 다음 = P6-1 도출기.
- (11-13 06:56) P6-3 권한별 실행 방법 확정: 호스트 명령 group 추가·실측(jaeuk.shin 그룹 9개 · ADMIN 273 → SCP Planner 163 → SSP Viewer 45 메뉴). 다른 user_id 로그인은 비밀번호 입력이 필요해 자동화 대상 아님 — 사용자가 런처에서 해당 계정으로 로그인해 둔 뒤 실행.
- (11-13 07:00) P6-1 소스 기반 시나리오 도출 1회차: tools/AsisLive/asis_live_scen_src.py 신설 — actions.csv 의 '관찰 동작에 이르는 분기 사슬(메서드+guard)'마다 시나리오 1개. 145 화면 = 분기 사슬 8,448(분모) · 도출 7,822 · 도달 경로 없음 626(버리지 않고 UNREACHED 로 보존). 유형 = 조회 1,735 · 저장 2,404 · 연쇄 2,096 · 초기 955 · 팝업 493 · 기타 765. 축(중복 집계) = DIVISION 1,198 · AUTH 265 · COND 716 · DATA 3,460 · SHEET 2,539 · STATE 2,834 · 조건 없음 2,355 · 미분류 1,048. 화면별 Doc/asislive/<ID>/scenarios_src.csv · 요약 _scenarios_src_summary.csv. 미완: 분기를 타게 하는 입력값 결정·실행 순서는 아직 없음(실행 불가 상태) · 축 분류는 조건식 문자열 규칙 기반(검증 안 함). 권한별 실행 = jaeuk.shin 한 계정 + group 명령(사용자 결정).
- (11-13 07:06) P6 연결 1(검사 단위): asis_live_scen_src.py 가 Doc/verify/<ID>/asis_live/scen_link.csv 생성 — mapping_trace.csv 의 AS-IS 문장·진입점 행(row_id = ACT:클래스.메서드[:줄:문장번호])에 분기 사슬 시나리오 ID 연결. 검사 단위가 있는 106 화면: 행 138,681 중 연결 33,124 · 미해결(미검증·ERROR·REVIEW·NOPATH) 행 115,603 중 연결 27,035 · 진입점 행 6,709 중 연결 2,823. 미연결 = 관찰 동작이 아닌 문장(LOCAL·EXPR·BRANCH·CALL_LOCAL 등)과 관찰 동작이 없는 메서드 — 같은 분기 사슬 소속으로 묶는 보완 필요. mapping_trace.py 본체는 수정하지 않음(읽기만). VM 단계 등록 미완.
- (11-13 07:16) P6 연결 1 보완 + VM 등록: 모든 문장을 소속 분기 사슬로 연결(같은 사슬 → 바깥 사슬 → 부르는 쪽 → 불리는 쪽 · 그리드 구성 동작도 관찰점으로) — 145 화면 분기 사슬 12,240(도출 11,347 · 도달 경로 없음 893) · 검사 단위 106 화면 138,681행 중 연결 132,095(95.3%) · 미해결 115,507행 중 109,832 · 미연결 6,586(생성자·Dispose·합계 계산 등). 검사 단위가 예전 정적 사실 기준인 화면 2개(줄 번호 불일치 3,708행 → 문장 번호로 맞춤). VM 2.0.8: steps S1.liveFill·liveCond·liveScen·liveScenSrc + 메뉴 4종. 미완: 분기 사슬 → E2E 단계 형식 내보내기(분기를 타게 하는 입력값 결정 필요) · 단위테스트 xlsx 연결.
- 11-13 07:22 정기 확인: b10_run.log '재실행 끝' 07:13:58 — 그러나 **SSP 8개(SSP0014·0015·0021·0023·0024·0025·0060·0200)는 rc=3 으로 각 20초 안에 끝남 = 미실행**. 원인(b10_SSP0014.log): 엔진 변경 게이트 FAIL — `tools/Harness/verify/asis_live_ingest.py:48` 제어 문자 0x08(파일 수정 시각 11-13 05:22:24 · 이 세션이 만든 파일 아님 — AS-IS Live 세션 것). 정규식 끝 단어 경계(백슬래시 b)가 0x08 로 들어간 꼴. 실제로 돈 화면 = 17/25(SCP0108 은 E2E 건너뜀): 그중 E2E 를 돈 16개 합 검사 단위 7,968→8,090 · 증명됨 2,635→2,825(+190) · 조치 필요 353→351. SSP0005 425→425 · 34→35 · 5→5(04:30:06~07:06:54) · SSP0003 365→371 · 51→59 · 12→12(04:18:15~07:13:56).
- 07:23 조치: 0x08 → 단어 경계로 1바이트 정정(사본 scratchpad/asis_live_ingest.py.bak_ctrl08) → engine_selfcheck PASS(07:23:33) → 미실행 8개 이어가기 시작(scratchpad/cycle1_rerun_rest.sh · 같은 b10_run.log · 차단 로그는 b10_<ID>.gate_blocked.txt 로 보존). 주기 2 대상 (l): 다른 세션이 검증 도구 폴더에 파일을 넣을 때 게이트를 먼저 돌리도록 안내 · 게이트 차단(rc=3)을 재실행 스크립트가 '끝' 으로 세지 않게 한다.
- (11-13 07:29) P6 실행 1단계: asis_live_scen_cov.py(분기 시나리오 실행 현황) — 145 화면 분기 12,240 중 서버 호출이 관찰점인 분기 998 → 실행됨 314 · 실행됨(분기 미특정) 45 · 미실행 639 / 호출 기록으로 판정 불가 10,349 · 도달 경로 없음 893. 호스트 명령 act(버튼 누르기·메서드·탭 · 팝업 기록 후 닫기) 추가. asis_live_scen_run.py(화면 안 버튼으로 조회·팝업 분기 실행) — 계획: 106 화면 버튼 423개(대상 분기 2,046) · 누르지 않는 버튼 178(저장 계열 125 · 상태 변경 가능 이름 48 · 파일 5). SCP0028 시범 = btnInput·btnItemId 실행(팝업 2종 기록·닫힘). 105 화면 일괄 실행 중(백그라운드). VM: S1.liveScenCov · S1.liveScenRun + 메뉴 2종.

- 11-13 08:50 **사용자 지시: 다른 세션이 AS-IS 런처를 실행해 AS-IS 데이터를 수집 중 — 이것까지 고려해 진행.** 실측(08:48): 그쪽 실행 중 = `asis_live_scen_run.py`(07:29 시작 · AsisLive.Host.exe · IIS Express 8086) · 산출물 `Doc/asislive/<ID>/` · `Doc/verify/<ID>/asis_live/` · 요약 `Doc/asislive/_summary.csv` · `_ingest_summary.csv`. 그쪽이 재실행 중에 바꾼 공용 파일: `run_verify.py`(11-12 17:46 · 차등 단계 끝에 asis_live_ingest 연결 · 원장 행은 만들지 않음) · `make_test_report.py` · `cleanup_spec.json` · VM quick/steps.json. → 시험 화면 SCP0028(17:12 시작)만 연결 전 체인으로 돌았다(원장 영향 없음).
- 이 세션이 지킬 것(검증엔진·주기 작업): ① 8086·런처·AS-IS 호스트를 건드리지 않는다(종료·재기동·같은 계정 로그인 금지) ② 이 문서는 **끝에 덧붙이기만**(전체 다시 쓰기 금지 — 두 세션이 같이 쓴다) ③ 그쪽 파일(tools/AsisLive · asis_live_*.py)은 게이트 차단처럼 검증 전체를 막을 때만 최소 정정하고 바로 알린다(07:23 0x08 1건) ④ AS-IS 개발 DB 는 그쪽 시나리오가 저장·삭제하므로 차등 검증 값 차이는 종전대로 판정필요(CR-101) ⑤ 재실행이 느려져도 부하 입장 규칙에 맡긴다.
- 주기 2 방향 변경: AS-IS 화면 동작을 원문 해석으로 푸는 엔진(Y06 연쇄 분기 해석 · Y03 위반 입력 · Y04 행 조건식 잔여 · Y21 일부)은 이 세션에서 늘리지 않고, 그쪽 분기 사슬(asis_live_scen_src — 145 화면 8,448)·조건 시나리오 실측이 원장 ASIS_LIVE 행으로 들어오는 형식에 맞춰 연결한다. 이 세션 주기 2 는 AS-IS 실측과 무관한 것부터: (h) SCP0007 증명됨 감소 · (k) E2E 건너뛴 화면의 집계 누락 · (f) 시나리오 건당 상한 · (b) Insert 전제 재시도 효과 · Y08 팝업 내부 조회 · Y10 · Y19 잔여.
- 25개 화면의 AS-IS 실측 반영 현황(08:50 · _ingest_summary.csv × 기준 B07): 반영 25/25(SSP0060 은 NA) · 조회 완료 신호 있는 화면 20 · 신호 없음 4(DMF0005 · SSP0015 · SSP0021 · SSP0200). 차등 검증 인자 미정(B07) 277 단위에 대해 실측이 바로 채울 수 있다고 표시된 것(LIVE_CAN_FILL)은 2(SCP0005 1 · SSP0021 1) · 인자 힌트 180건(SCP0020 72 · DMF0005 61 · SCP0007 23 …). 즉 B07 의 대부분은 '같은 조건 실측'(그쪽 조건 시나리오)이 되어야 풀린다 — 지금 값으로 채우지 않는다.
- 11-13 09:22 정기 확인(이어가기): SSP0014 07:23:47~08:24:33 rc 0 · 통과 112 · 실패 1(저장 세부 F1·F6 — locator.click 10초 초과) → 검사 단위 495→501 · 증명됨 214→236(+22) · 조치 필요 2→7. 도는 중 SSP0015(6/8 차등 검증 · 통과 120 · Insert 전제 31줄) · SSP0021(4/8 · 통과 24 · 실패 1 · Insert 전제 17줄). 게이트 차단 재발 0 · DB 감시 경고 추가 0.
- 주기 2 대상 추가: (m) DB 감시(5분 경고·30분 종료)가 Oracle 만 본다 — 차등 검증이 AS-IS MSSQL 에서 실행하는 SP 는 감시 밖(09:22:42 조회: 이 PC·Python·SSP0015_GET_SHIPMENT_PSI 1건 실행 중 · 경과 0초). 같은 규칙을 AS-IS 쪽 '이 PC + Python' 요청에도 적용할지 사용자 확인(그쪽 세션의 .Net SqlClient 요청은 대상에서 제외해야 함) (n) SSP0014 조치 필요 2→7 · SSP0111 11→23 — 늘어난 FAIL 이 화면 결함인지 검사 오판인지 분류.
- 11-13 13:22 정기 확인(이어가기): 끝 22/25 — SSP0023 09:51:05~11:29:34(1315→1317 · 증명됨 217→232 · 조치 필요 45→58) · SSP0024 11:29:36~13:01:34(747→783 · 354→354 · 8→12 · 통과 97 · 실패 0) · SSP0021 08:24:34~13:09:22(1172→1202 · 234→253 · 95→119 · 통과 99 · 실패 9 · E2E 239.9분). 도는 중 SSP0025(4/8 · 실패 2 = 저장 세부·저장 경로) · SSP0060(4/8). 남음 SSP0200. E2E 를 돈 21개 합: 검사 단위 12,693→12,912 · 증명됨 3,730→4,007(+277) · 조치 필요 546→590.
- 주기 2 대상 추가: (o) **스펙 예외 2건(SSP0021)** `_verify.spec.ts:252` afterEach — 로그인 픽스처가 시간 초과로 없을 때(nscm = null) `requiredNotes` 를 읽다 TypeError(11-06 코드 · 이번 보완과 무관). null 보호 필요 (p) SSP0021 실패 9건 · 테스트 시간 초과 문구 7줄 · '[ensureRows] 시도 → 0행' 20회 — 0행 조회와 실패의 대응, 그 사이 데이터 변화 여부 확인 (q) 조치 필요 증가 화면 분류: SSP0021 95→119 · SSP0023 45→58 · SCP0111 11→23 · DMF0005 90→110 · SSP0014 2→7 · SSP0024 8→12 · SCP0037 5→8.

## 2026-11-13 13:3x (VM 세션) — CheckList '설명' 열 새 형식 · 덧붙임
- 사용자 지시(11-13): "설명은 먼저 어떤 부분이 오류인지를 정의하고, 하단에 설명 — 정확한 대상·증상, AS-IS 에는 어떻게 되어 있는데 TO-BE 에는 어떻게 되어 있어 다른지를 쉽게".
- 신규 `tools/Harness/verify/plain_detail.py`(문구 전용 · 판정 불변) + `make_verify_docs.py` 연결(`_explain` → `lrow` '설명' 열 · import 실패·예외 시 종전 한 줄 설명). 백업 `make_verify_docs.py.bak_20261113_plain`.
- 조치 필요·판정 필요 행만 새 형식: `[오류]/[확인 필요] 대상 — 무엇이 잘못됐는지` → `· AS-IS` `· TO-BE` `· 설명` `· AS-IS 실행 확인(Doc/asislive/<ID>/run_*/grids.json 이 있으면 컬럼 표시·폭·잠금)` `· 참고`.
- 규칙별 풀이 11종(A5·D1·G6·H5·A10·I2·K3·J4·C2·E3·A1) + 묶음 요약 + 'AS-IS … ↔ TO-BE …' 분리. 그 밖 규칙은 증거 원문을 용어만 바꿔 '측정 기록' 으로 둠(지어내지 않음).
- 자기 시험(13:36): 8항목 PASS · 전 화면 fixlist 2,896행 예외 0 — 규칙별 풀이 210 · AS-IS/TO-BE 분리 444 · 묶음 요약 1,319 · 측정 기록 그대로 923(상위 A6 79 · D1 69 · F4 54 · G1 51 · M1 49 · J3 48 → 다음 풀이 추가 대상).
- 미리보기: `Doc/CheckList/_설명개선_미리보기_SSP0020_SCP0104_20261113.xlsx`. CheckList 재실행은 하지 않음.

- 11-13 13:57 AS-IS Live P6-2 버튼 분기 실행 — **창 쌓임 결함 보정 + Excel 기록·종료**. (1) 결함: 첫 105화면 실행 중 자동화 런처에 창 61개 실측(09:41 · 닫음 표시 149/169 인데 실제 잔류) → 실행 중단·기록 59화면 무효(폴더 앞 x). 보정 = 호스트 `sweep` 명령(닫힘 확인·늦게 뜬 창 포함·남으면 런처 재시작) + 메시지 상자 재누름(단추 직접 누르기·닫기 메시지). (2) 재실행 104화면(09:52~13:30) + 중단 7화면·SSP0023 재실행(13:33~13:51 · 재시작 0): 창 수 30초 간격 430회 중 3개 이하 428회. 버튼 372(실행 322 · 컨트롤 없음 50 → Doc/asislive/_scen_run_fail.csv) · 팝업 244(34종) · 열기 실패 DMF0081·SCP0095·SCP0100(+제외 대상 SSP0060 이 목록에 섞임 — 다음부터 제외). (3) 분기 실행 현황(13:51 asis_live_scen_cov): 실행됨 343 · 분기 미특정 57 · 미실행 598 · 호출 기록 판정 불가 10,349 · 도달 경로 없음 893 (실행 전 314/45/639). (4) Excel: tools/AsisLive/asis_live_excel.py + excel_guard.ps1 — 버튼 전 떠 있던 Excel·문서는 유지, 새로 뜬 것만 기록(파일 경로·크기·시트별 행/열 = 파일 직접 읽기) 후 닫음. SSP0023 formDown 실측 2회 닫힘 확인. 사용자가 쓰던 Excel 안에 열린 경우(12:57 실측)의 문서 단위 닫기는 실행 미확인(수동 시험은 권한 차단). 미해결: 컨트롤 없음 50건 원인 분류 · 팝업/대화상자 기록으로 분기 판정 · 메시지 상자가 처음 누름에 안 닫힌 원인.

## 2026-11-13 14:3x (VM 세션) — AS-IS 실구동 자동 구동·건수 판정·다중 메뉴 화면 · 덧붙임
- 사용자 지시(11-13): ① 실구동 건수 차이 소량 = 판정필요 · 아예 다르거나 없음 = 조치 필요 ② CheckList 실행 시 AS-IS 런처 자동 구동·취합 ③ SSP0020 = 사용 화면 ④ 한 UI_ID 가 여러 메뉴에 있으면 사용 가능한 메뉴 기준.
- 신규 `asis_live_auto.py`(diff 단계 · asis_live_ingest 앞): 대상 아님(FP·Material 4·asis_live_batch.EXCLUDED) 건너뜀 → 최근 정상 실측(24h) 있으면 재사용 → 없으면 IIS(8086) 확인·기동 + ClientConfig 주소 확인 + `asis_live_run.py`. 새 실측이 실패하면 직전 정상 latest.json 을 되살림. 끄기 = `VERIFY_ASIS_LIVE=off`.
- 신규 `asis_live_rows.py`(post 단계 · a1_live 뒤): `asis_live_cond.one()` 의 주 그리드 짝이 '같은 조건' 일 때만 AS-IS 실구동 건수 ↔ 차등 검증 TO-BE 건수(+diff_summary 키 대조)로 판정해 a1_live.csv 에 '<시트> · AS-IS 실구동' 행 반입(eg_ingest A1). 같음 PASS · TO-BE 0건/공통 키 0/소량 초과 FAIL · 소량 차이·키 일부 차이 REVIEW. 소량 기준 기본 max(10건, 5%) — `VERIFY_LIVE_ROWS_ABS/PCT`. 조건이 다르면 행을 만들지 않고 asis_live/live_rows.csv 에 사유만.
- `run_verify.py`: 위 2개 호출 추가 · STAGES diff 5→6 · post 30→31. 백업 `run_verify.py.bak_20261113_live`.
- `asis_live_batch.py` EXCLUDED 에서 SSP0020 제거(사용자 정정). 백업 `.bak_20261113_ssp0020`.
- `syn_check.py`: 화면(MNU_ID) 행이 USE_YN=N 이어도 같은 ROUTE_PATH 의 다른 메뉴 행이 USE_YN=Y 면 사용 화면으로 봄(메뉴·배선 META_MISSING 아님 · INFO 출력). 백업 `.bak_20261113_alias`. 14:36 재검사 SCP0105 문제 0(종전 차단) · SCP0104 0 · SSP0020 0.
- 시험(14:28): 분류 14사례 PASS · SCP0005 실데이터 PASS 행 1개(8,036 ↔ 8,036 · 키 공통 8,036) · SCP0104 = 조건 다름(sheet_name 인자)이라 판정 안 함.
- ⚠ 실구동 실제 실행 14:28 SSP0020 · 14:31 SCP0104 모두 exit 2 '메뉴 목록이 비어 있음'(계정 jaeuk.shin · 다른 런처 34700 떠 있음) — 원인 미확인. SCP0104 latest.json 은 11-12 20:25 정상 실측으로 되돌림. 14:32:50 부터 다른 세션의 scen_run SCP0028 이 런처 사용 중이라 추가 실행 안 함.

- 11-13 14:42 AS-IS Live — **화면별 CheckList 에 런처 실측 묶음 연결**(사용자: 전 화면 일괄 실행은 지금 하지 않음 · 데이터 취합·기준 설정은 화면별 CheckList 때 구동). 신규 tools/AsisLive/asis_live_screen.py <ID> [--after-basic]: 기본 실측(앞 단계 asis_live_auto 실측에 행이 있으면 재사용 · 0행이면 필수 조건 최근 값으로 재측정) → 소스 분기 시나리오 → 버튼 분기 실행(팝업·메시지·Excel 기록 후 닫기) → 실행 현황 → TO-BE 조건 대조 → Doc/asislive/<ID>/screen_bundle.json(OK|PARTIAL|ERROR|NA). run_verify.py 차등 검증 단계의 asis_live_auto.py(다른 세션이 14:28 추가) 바로 뒤에 한 줄 연결(세부 6 → 7 · engine_selfcheck PASS). 기준 = VERIFY_ASIS_LIVE·VERIFY_ASIS_LIVE_MAX_AGE_H(24h) 공유 · 화면 단위 잠금 _screen.lock. VM 단계 S1.liveScreen·메뉴 🧩 추가. 확인: 제외 화면 NA(SSP0060·FP02510) · SSP0020 은 대상(다른 세션 정정 반영) · SCP0028 묶음 2회 실행 = 버튼 단계만 rc 3(PARTIAL): 14:33 다른 세션 실측과 겹침 · 14:36 메뉴 조회 SP UP_FX_GetGSCMAuthenticationMenuList 30초 시간 초과(DbProfile EXCEPTION · 13:51 정상 때 약 6초) — AS-IS 개발 DB 지연. **버튼 단계까지 통과한 묶음 실행은 아직 없음(미확인)**. 미구현: 대조표 행 단위 시나리오를 AS-IS·TO-BE 양쪽에서 같은 ID 로 실행해 결과를 대조하는 부분(P6-4) — 지금은 AS-IS 쪽 관찰(호출·팝업·메시지·Excel)과 대조표 연결(scen_link.csv)까지.

## 2026-11-13 14:4x (VM 세션) — AS-IS 실구동 '메뉴 목록이 비어 있음' 원인 · 덧붙임
- 실측(GSCM.DataService.WSL DbProfile 로그): 메뉴 목록 SP `UP_FX_GetGSCMAuthenticationMenuList`(UserID=jaeuk.shin · GroupID=ADMIN) — 12:02~13:51 5회 6.2~28.5초 · 273행 → 14:29·14:32·14:34·14:36 4회 모두 30.0초(서비스 명령 제한) · 0행. 0행이면 런처 메뉴가 비어 화면을 열 수 없다(asis_live_run exit 2).
- 데이터는 정상(14:42 조회: 사용자-그룹 ADMIN Y · ADMIN 메뉴 권한 391행 · 메뉴 항목 282 사용 · SP 수정 09-02). 직접 실행도 14:43 에 75초 제한 초과.
- 같은 시각 AS-IS DB 에 다른 PC(P2605LN0024 · 로그인 zionex)의 대량 집계 쿼리가 실행 중(14:37 시작 세션 72 · 434초째 · 병렬 대기) — 이 세션이 띄운 것이 아니라 건드리지 않음. 14:29 시점의 부하 원인은 미확인.
- 조치: `asis_live_auto.menu_slow()` — 런처를 띄우기 전에 메뉴 SP 를 25초 제한으로 재서, 못 끝내면 띄우지 않고 '미측정 — AS-IS DB 응답 지연' 으로 넘긴다(실패한 실측이 생기지 않음 · 서버 쪽 실행도 함께 취소).
- 14:38 내 진단 쿼리가 클라이언트 종료 뒤에도 서버에 남아 있어(세션 53 · LEE-03 · SCP_MGR_DEV · Python · 214초) 본인 세션임을 확인하고 KILL. 이후 진단은 제한 시간으로 서버 취소까지 되게 실행.

- 11-13 15:08 AS-IS Live P6-4 1차 — **분기별 AS-IS↔TO-BE 대조 + TO-BE 룰 조회 + 수정 모드 재실행 + 그룹 지정**. (1) tools/AsisLive/asis_live_scen_cmp.py <ID> → Doc/asislive/<ID>/scenario_compare.csv: 소스 분기마다 AS-IS 관찰(호출·팝업·메시지·Excel) ↔ 연결된 대조표 행 판정(scen_link.csv)·호출 대조(diff_summary.csv). 판정 8종(양쪽 확인·TO-BE 룰 차이·판정필요·차이(오류 후보)·TO-BE 미검증·AS-IS 미실행·연결 없음·도달 경로 없음). **TO-BE 룰로 정의된 차이 = 오류 아님**(사용자 11-13): AS-IS 관찰 문구 → 룰 대응표 tools/AsisLive/asis_obs_rule_map.csv(1행: 수정모드 → CR-093;CR-084) · 검사 규칙 코드로 걸리는 TOBE_DIFF 룰(tobe_rule_registry.csv)은 후보로만 표시(판정필요). 건수·값 차이 = 판정필요(CR-101). 판정 행·원장은 만들지 않음. 실측 15:0x: SCP0028 분기 25 = 판정필요 1·TO-BE 미검증 5·AS-IS 미실행 18·도달 경로 없음 1 / SCP0019 분기 47 = TO-BE 룰 차이 8·TO-BE 미검증 3·AS-IS 미실행 32·도달 경로 없음 4. (2) 수정 모드: asis_live_scen_run.py <ID> --edit — 직전 실행에서 '수정모드가 아니므로…' 를 낸 버튼만 BaseForm.OnClickEditButton 뒤 다시 누름 · 화면 닫기 창 MSG00013('작업중인 데이터가 있습니다. 이 화면을 닫으시겠습니까?')에만 예(저장 없이 닫기) = 호스트 대화상자 정책 close/no 신설. SCP0019 15:08 실측: 수정 모드 켜짐 · BtnInput/btnInput 실행(팝업·호출·메시지 0 — 화면 안 값만 바뀜 → 그리드 전후 비교 기능 필요) · 닫기 창 예 · 남은 화면 0. (3) 그룹: --group <이름>(공백 허용) · --groups-list(15:00 실측 jaeuk.shin 9개 · 현재 ADMIN). (4) 실측 묶음 asis_live_screen.py 단계 = 기본 → 분기 도출 → 현황 → 버튼 → 수정 모드 재실행 → 현황 → 조건 대조 → 분기별 대조. SCP0028 묶음 15:00~15:02 OK(6단계 · 97초 · 대조·수정 모드 단계 추가 전). VM: S1.liveScenCmp·S1.liveScenRunGroup·S1.liveGroups + 메뉴 3. 미구현: 같은 조작의 TO-BE 재실행(지금 TO-BE 쪽은 CheckList 가 낸 대조표 판정) · 그리드 전후 비교 · 저장 시나리오 · Division 별 반복.

### 주기 1 결과 (재실행 11-12 17:12:00 ~ 11-13 15:04:48 · 집계 15:07 · 파일 `_cycle1_result_by_screen.csv` · `_cycle1_result_by_type.csv` · 사본 `_cycle1_result_backlog.csv` · `_cycle1_result_types.csv`)
- 실행: 25개 중 24개 E2E 실행(rc 0) · SCP0108 은 메뉴 메타 변경으로 E2E 건너뜀(집계에서 빠짐 — 누락 · 주기 2 (k)). SSP 8개는 게이트 차단(다른 세션 파일 0x08)으로 1차에 미실행 → 07:23 정정 후 이어가기로 실행.
- **같은 24개 화면 비교**(SCP0108 제외 · 이 세션 밖에서 돈 SCP0104·SSP0020 제외): 검사 단위 16,272 → 16,580 · **증명됨 4,270 → 4,616(+346)** · 조치 필요 836 → 939(+103) · 해당없음(실측 근거) 1,436 → 1,578(+142) · 미증명 9,730 → 9,447(−283).
- 화면별 증명됨(기준→재실행): DMF0005 47→200(기준은 결과 저장 소실 포함) · SCP0005 204→205 · **SCP0007 821→714(−107)** · SCP0016 245→260 · SCP0020 162→173 · SCP0028 97→109 · SCP0033 233→252 · SCP0037 127→137 · SCP0041 101→116 · SCP0084 84→99 · SCP0111 47→52 · SCP0122 176→184 · SCP0127 53→63 · SCP0131 153→167 · SSP0003 51→59 · SSP0005 34→35 · SSP0014 214→236 · SSP0015 76→107 · SSP0021 234→253 · SSP0023 217→232 · SSP0024 354→354 · SSP0025 162→214 · SSP0060 224→231 · SSP0200 154→164. 감소 1(SCP0007) · 그대로 1(SSP0024) · 증가 22.
- 조치 필요 증가 화면: SSP0200 143→193 · SSP0021 95→119 · DMF0005 90→110 · SSP0023 45→58 · SCP0111 11→23 · SSP0014 2→7 · SSP0025 7→12 · SSP0024 8→12 · SSP0060 140→144 · SCP0037 5→8. 감소: SCP0131 17→5 · SCP0127 18→9 · SCP0041 41→33 · SCP0005 12→8 · SCP0020 31→29 · SCP0028 14→12.
- 유형별(전체 집계 — SCP0104·SSP0020 포함 · SCP0108 빠짐이라 화면 구성이 기준과 다름 · 참고용): 줄어든 것 Y09 실행 못 함 668→324 · Y19 실행 경로 없음 581→379 · Y02 저장 경로 밖 메시지 474→275 · Y08 팝업 검사기 84→4 · Y01 신규행 전제 387→316 · Y14 40→6. 늘어난 것 Y99 미분류 881→1,331 · Y11 집계 행 2,673→3,112 · Y03 위반 입력 162→366 · Y10 대상 없음 130→207 · Y05 연쇄 원천 칸 322→397 · Y18 팝업 값 반영 231→290 · Y15 555→646.
- 재실행 중 사건: T275 파일 쓰기 실패(즉시 보완 · 이후 쓰기 실패 0 · 재시도 로그 확인) · DMF0005 시나리오 무응답 3.5시간(상한으로 종료) · DB 5분 경고 1건(00:50 · 30분 종료 0) · 게이트 차단 8화면 · 스펙 예외 2건(SSP0021 · 252행) · 이 세션 밖 실행 SSP0020·SCP0104.
- 오늘 보완의 실동작(로그 줄): Insert 전제 재시도 = 여러 화면(SSP0060 37 · SSP0015 31 · SSP0021 30 · SSP0023 23 · SSP0200 16 · SCP0028 12 …) · 병합 셀 = 대부분 화면 1~2 · 파일 쓰기 재시도 = 7화면 · 연쇄 원천 행 = SSP0200 1 · **언어 복구 0 · BE 대기 0 · [M4] 0 줄**(M4 탭 순회 보완은 로그 문구가 한 번도 안 찍힘 — 동작 여부 미확인).
- **주기 2 순서(이 세션 · AS-IS 실측과 무관한 것부터)**: ① (h) SCP0007 −107 원인 ② 조치 필요 +103 분류(q) ③ Y99 미분류 +450 · Y03 +204 · Y10 +77 의 정체(유형 분류기 문제인지 실제 이동인지) ④ (k) 건너뛴 화면 집계 누락 ⑤ (f) 시나리오 건당 상한 ⑥ (o) 252행 null 보호 ⑦ M4 미동작 확인 ⑧ (b) Insert 재시도 뒤에도 신규 행 없음. AS-IS 동작 해석 유형은 AS-IS Live 연결 대기.

## 2026-11-13 15:1x (엔진 점검 세션) — 생성·검사 엔진 전체 점검(사용자: "UI 를 구동할 때마다 다른 종류의 오류") · 덧붙임
- 범위 = 엔진 코드 오류 점검·보완(문서·카탈로그 정리는 다른 세션). FE·BE·DB 객체 무수정. CheckList 재실행 없음(확인 = 자기 시험·engine_selfcheck·`--static` 1회).
- **오류 실증(이번 실측만)**: 화면별 `_timing.csv` 28개 9,736행 · VM 로그(11-06 이후 · claude 대화 로그 제외) 74개 · 주기 1 재실행 로그 114개 · `.vibe/runs.log` 1,846줄. 수집 한계 = 터미널 직접 실행분 중 로그를 남기지 않은 것 · 11-06 이전 VM 로그는 문구 분류에 넣지 않음(종료코드만 집계).
- 도구 종료코드 ≠ 0(`_timing.csv` 전 기간): coverage.py rc2 114/162(설계상 경고 — 측정 0 규칙 표시) · oracle_class.py rc2 81/157(**결함 T280**) · Playwright rc1 54/102(테스트 실패 = 판정 반입 · 설계) · restore_touched.py rc1 39/129(복원 불가 — 아래) · regress.py rc2 31/188(사용자 '오류 아님' 판정을 검사기 원판정이 아직 FAIL — 검사기 결함 잔존 신호 · 8화면) · asis_live_ingest rc3 3(미측정 — 다른 세션 범위) · syn_fix rc2 2(SCP0104 ORA-01720 grant option 없음 — DB 권한) · sqllog_calls rc3 1 · combo_oracle rc1 1(SSP0020 콤보 원천 0 = 대상 없음).
- **확인된 엔진 결함 8종 → 보완**(`Doc/verify/_checker_defects.md` T276~T283):
  | # | 결함 | 실측 | 수정 파일 | 확인 |
  |---|---|---|---|---|
  | T276 | 자동 시나리오 버튼 글자가 정규식으로 해석(예외·오일치) | SCP0104 11-13 12:23 SyntaxError 1 · 대기 SSP0200 1행 | gen_expect.py · _verify.spec.ts(btnRe) | 단위 시험 11/11 · SCP0104 재생성 `btn:\+` |
  | T277 | afterEach null 참조 | 8회 · 3화면 | _verify.spec.ts | tsc(자기 점검) |
  | T278 | 화면샷 첫 실행이 테스트 실패로 집계 | 30회 · 15화면 | _snap.spec.ts | tsc — 실제 동작은 다음 전체 실행에서 확인(미실행) |
  | T279 | STAGES 세부 수 불일치 경고 | 28회 | run_verify.py(facts 15 · --static sub) | `--static SCP0104` 경고 0 |
  | T280 | 복합 규칙 ID → '오라클 분류 마스터 누락' 경고 | 81회 · 28화면 | oracle_class.py | `--check` 전 화면 통과(15:0x) |
  | T281 | 결과 파일 일시 잠금 → 기록 누락 | 11줄 · 2화면 | _verify.spec.ts · _trace.spec.ts(재시도) | tsc — 잠금 재현 시험은 미실행 |
  | T282 | 팝업 없는 화면 'No tests found' | 10회 | eg_chain.py | 옵션 지원 확인(Playwright 1.64.1 `--pass-with-no-tests`) — 실제 실행은 미실행 |
  | T283 | 팝업에 가려진 Save 10초 시간 초과(사유 없음) | 24회 · 6화면 | nscm.ts(사유 문구로 즉시 종료) | tsc — 팝업 처리 자체는 미구현(C1-01 에 합침) |
- 백업 = 각 파일 `.bak_20261113_audit`(8개 + _trace.spec.ts). run_verify.py 는 같은 시각 다른 세션이 머리 설명을 덧붙임 — 두 수정이 함께 들어간 것 확인(ast 통과).
- **확인(15:06~15:10)**: `engine_selfcheck.py` 전체 PASS(15:06 · PY_COMPILE·PY_UNDEF·CTRL_CHARS·JS_SYNTAX·SPEC_SIZE·TSC·SELFTEST JS 29·PY 40·RULE_REGISTRY 모두 0) · `run_verify.py SCP0104 --static` rc 0(15:08~15:10 · 세부 15/10/31 경고 0 · 정적 FAIL 0) · 원장 전후 비교 3,240행 판정 변화 0(H10 자동 행 1개는 단계 문구가 바뀌어 행 ID 교체 — ERROR 그대로 · 다음 E2E 에서 측정). `--static` 이 덮어쓴 SCP0104 run_mode.json·run_verify.result.json 은 12:24 전체 실행 것으로 되돌림.
- **정적 전수 점검**: steps.json 작업 107 · quick.json 작업 참조 38종(미정의 0) · 체인 6 · 스크립트 57개(없음 0 · 구문 오류 0) · 작업이 넘기는 플래그 47개(스크립트 미수용 0) · quick 경로(열기·cwd) 없음 0. 체인의 `okCodes: [10]`(S8.verify) 은 11-06 이후 run_verify 가 10 을 내지 않아 쓰이지 않는 값(무해 · 미수정).
- **엔진 결함이 아닌 것으로 분류(미수정)**: ① 로그인 실패·픽스처 360초 초과·ERR_CONNECTION_REFUSED(11-12 SCP0111·SSP0021 · 11-13 SCP0104·SSP0020·SSP0021·SSP0023) — BE 상태·동시 실행 부하 쪽 · 원인 미측정(그 시각 BE 로그·동시 실행 수 대조 필요) ② 테스트 시간 초과 35줄 · 13화면 — 화면별 조회 속도·데이터에 의존(유형 분해 미실시) ③ 11-13 07:07 8화면 rc3 = 다른 세션이 고치던 asis_live_ingest.py:48 제어 문자를 엔진 변경 게이트가 막은 것(게이트 정상 동작 · 07:23 재개) ④ 11-10 NameError 'DOC'·acquireLangExclusive·11-09 asis_variant 모듈 없음 — 현재 코드에서 해소 확인.
- **주기 2 보완 대상에 추가**(여기서 고치지 않음): (r) CR-100 대표 규칙 칸 `H5;H6;K3` — 26화면에서 '[미검증] 자동 검사기 없음' · 대표 규칙 지정은 사용자 결정 (s) 동적 정규식 74곳 중 값 출처 미확인분 낱개 점검 (t) regress 위반 8화면(SCP0007·SCP0016·SCP0020·SCP0108·SCP0111·SCP0127·SSP0024·SSP0025) — 사용자 판정으로 최종 결과는 바로잡히지만 검사기 원판정이 그대로 (u) 시험 행 미복원 = SCP0007 SCP_MST_DISTRIBUTION_ROUTE ROUTE_ID 6516(11-11 18:08 기록 · cleanup_spec 표 없음) · SCP0084 SCP_ANL_LONG_TERM_STOCK·SSP0060 SSP_MST_SEND_MAIL_REQ(감사 칸 없어 변경 여부 확인 불가) · SSP0025 SSP_MST_MODEL_USER_EE 1행(flashback ORA-01555 · 최종 대조는 '저장 전과 같음') — 사람 확인 필요 (v) combo_cascade.json·popup_results.json·eg e2e.json 쓰기 실패(각 1회 · SCP0028 11-12) 재발 관찰 (w) STAGES 수 ↔ run() 수 일치를 자기 점검에 넣기.
- **전체 재실행 대상(자동 실행하지 않음 — 사용자 확인 뒤)**: 이번 수정이 E2E 측정에 영향을 주는 화면 = SCP0104(T276·T283) · SSP0200(T276 대기 행) · SSP0014·SSP0025·SSP0060·SCP0037·DMF0005(T283 사유 문구) · SSP0020·SSP0021(T277) · 화면샷 골든이 없는 화면(T278 — 다음 실행 때 후보 저장). 나머지 화면은 판정 영향 없는 수정(T279·T280·T282 = 경고·문구).

## 2026-11-13 15:1x (룰·하네스 전수 점검 세션) — 등록 정합 보완 · 덧붙임
- 사용자 승인 묶음 ①②④ 적용(③ 보관 이동 · ⑤ `S6.regen` 삭제는 미적용). 근거·수치 = `Doc/_rules_consolidation/2026-11-13_INVENTORY_정리안.md`.
- `run_verify.py`: `--static` 분기에 `asis_live_rows` 건너뜀 표시 추가(post 30 ≠ 31 해소 · `--static` 실행으로는 미측정) · 머리말에 "현재 실행 단계" 추가(주석). `facts` 14 → 15 는 같은 시각 다른 세션이 먼저 반영. 백업 `.bak_20261113_inv`.
- `engine_selfcheck.py`: 감시 범위에 `tools/AsisLive/*.py` · `tools/Docs/*.py` 추가 · 전체 검사에 `RULE_REGISTRY`(`tobe_rule_registry.py --check`) 편입. 15:14 전체 검사 PASS(26.7초 · selftest JS 29 · PY 40 · RULE_REGISTRY 0).
- 주의(AS-IS Live 세션): 이제 `tools/AsisLive/*.py` 를 고치면 다음 CheckList 가 엔진 변경 게이트 전체 검사를 1회 돌린다. 그 폴더에 컴파일 오류·미정의 이름·제어 문자가 있으면 CheckList 가 rc 3 으로 막힌다(추가 시점 0건).
- 도구 등록 단일 출처 = `tools/Harness/README.md` "도구 등록부"(204개 · 자동 생성). 새 도구를 넣으면 `python scripts/rules/inventory_check.py --write-registry` 후 `python scripts/rules/inventory_check.py` PASS 확인(15:13 PASS — hook 연결 13 · 문서 hook 156 · VM 작업 110 · 체인 도구 참조 105).

### 조치 필요(FAIL) 대량 건 점검 — 사용자 지시 11-13 15:1x("사용자 테스트 중인 화면에서 50~100건 이상은 검사엔진 오류로 추정 · 신중하게 점검") → **주기 2 의 1순위로 올림**(종전 ①~⑧ 보다 먼저)
- 점검 1차(15:14~15:17 실측 · 분류 파일 `Doc/verify/_cycle1_fail_classified.csv` 936행 · 스크립트 scratchpad/fail_cls.py):
  - 보고한 '조치 필요 939(24화면 936 + 반올림 아님 — SCP0104·SSP0020 제외 전 998)' 는 **검사 단위 수**이고 결함 수가 아니다. 24화면 936 중 **572(61%)가 집계 행**(대조표 행·진입점 단위 묶음 — 아래 요소 FAIL 1개가 있으면 그 행도 FAIL 로 한 번 더 셈). 요소 단위는 364.
  - **확정 엔진 결함 F-1(G4 조회조건 라벨 오귀속)**: `mapping_trace.py:499·688` — smoke 라벨 요약이 '누락 N(≥1)' 이면 그 화면의 **모든 조회조건**에 FAIL 을 붙인다(컬럼 쪽 689행은 이름이 누락 목록에 있을 때만 FAIL 인데 조건 쪽은 구분 없음). 요소 FAIL 364 중 93이 이 꼴(SSP0015 20 · SSP0021 14 · SSP0023 14 · SSP0060 11 · SSP0200 9 · SCP0028 7 · DMF0005 6 · SCP0041 5 · SSP0003 4 · SCP0111 3). 실제 누락으로 적힌 라벨은 화면당 1~4개(예 SSP0200 'Request No, Item Id' · SSP0015 'Result Type, Lot ID' · SCP0028 'Division*'). 그중에도 기준표에 없는 조건(CR-071 → 검사 대상 아님)·필수 표시 '*'(CR-077 → 생략 허용)가 섞여 있다. 같은 원장 행이 '[근거 불충분] 출처 이름만 — FAIL 로 쓰지 않음' 이라고 적는데 검사 단위는 FAIL 로 남는 불일치도 있음(SSP0060 cboChangeReason). G4 집계 행도 이 요소들 때문에 FAIL(예 SSP0200 원장 G4 집계 FAIL 17행).
  - **대조표 '미구현' 표기 47**(X-NOTIMPL: SCP0007 32 · SSP0200 13 · SCP0005 1 · SSP0060 1): 설계 대조표 문서가 그 동작을 '미구현' 으로 적어 둔 것을 그대로 FAIL 로 센 것 — 화면을 재서 나온 FAIL 이 아니다. 문서가 지금 화면과 맞는지 미확인.
  - 나머지 요소 224 — 아직 건별 확인 전. 의심 꼴(확인 필요 · 단정 아님): ⓐ 편집 가능 여부 D1·J3·D3('신규행 편집=false (AS-IS 편집 가능)' · J3 '기본(편집 모드 전체 해제)' = 11-12 T264~T267 해석이 들어간 판정) ⓑ 권한 K4·D1('기대 PR_GET_MNU_BTN_AUTH_DIV(Div 40)' 인데 계정은 Div 81 · CR-102 합집합 미반영 C1-25) ⓒ 시나리오 F2·F3·F6·E4('저장 요청 없음 · 편집기 null · search:0행' — 조작이 성립하지 않았는데 FAIL) ⓓ F10 저장 PROC 'EXECUTE IMMEDIATE ALTER SE…' 를 암묵 확정으로 본 것(10화면 19행) ⓔ K3 Hide Column 12화면 동일 문구 ⓕ A5 '[측정 경로 없음]' 이 FAIL 요소로 집계.
  - 사용자에게 보이는 보완 목록(fixlist.csv action_needed=Y)은 24화면 합 310(DMF0005 66 · SSP0200 56 · SCP0007 20 · SSP0023 20 · SCP0020 17 · SSP0060 15 · SCP0005 14 · SCP0111 14 · SSP0015 11 …) — 이것도 건별 확인 대상.
- 다음(이 순서 · 화면 재실행 없이 원장·결과 파일·AS-IS 원문으로): ① F-1 수정(조건별 귀속 + 근거 없는 요약 FAIL 은 미검증) + 자기 시험 ② 집계 행을 '조치 필요' 계수에서 분리(요소 수와 따로 표기 — proof_backlog) ③ 나머지 224 + fixlist Y 310 을 꼴별로 원문 대조해 [엔진 오판 / 중복 / 실제 차이] 로 가름 — 꼴 ⓐ~ⓕ 부터 ④ SCP0007 증명됨 −107. 그 뒤 종전 ③~⑧.

- 11-13 15:17 (엔진 점검 세션) **CR-100 대표 규칙 = H6 로 정정**(사용자 결정 15:16 "H6 로 지정"): `tools/Harness/rules/confirmed_requirements.csv` CR-100 rule_id `H5;H6;K3` → `H6`(rule_ids `H5;H6;K3` 그대로 · 백업 `.bak_20261113_cr100`). tobe_rule_registry.csv 의 detect_rules 칸은 복수 값이 정상이라 무수정. 확인 = oracle_class --check 통과 · engine_selfcheck 전체 PASS(15:17 · RULE_REGISTRY 0). 원장은 다음 실행 때 다시 만들어지므로 기존 28개 원장의 `H5;H6;K3` 행은 그때 바뀜(CheckList 재실행 안 함). 현재 원장으로 잰 상속 영향(15:18 · 대상 28화면): 같은 화면 H6 실측에 미검증·판정필요 있음 22 · H6 실측 없음 3 · PASS/NA 만 2 · **FAIL 있음 1 = SCP0016**(스냅샷 팝업 PJT 차이 — 대상 글자가 맞지 않으면 CR-100 행이 이 FAIL 을 이어받을 수 있음 → 다음 SCP0016 실행 때 확인 대상).
- (11-13 15:18 · 전수 점검 세션) 승인 묶음 ③ 보관 이동: 145건(파일 154) → `Doc/_archive/`(목록 `_moved_20261113.csv` · 삭제 0). 검증 도구에서는 `verify/cr_harness_gap.py`(→ `tobe_rule_registry.py` 로 대체) · `tools/Harness/tmp_strip_asis.js` · 2026-10-30 이전 `.bak` 만 빠짐. 이동 뒤 engine_selfcheck 전체 PASS(15:18) · inventory_check PASS(도구 202).
- (11-13 15:30 · 전수 점검 세션) 승인 묶음 ⑤: steps.json 의 S6.regen(gap.js 재실행 · GAP 분석 10-30 폐지) 삭제 — 작업 110 → 109 · 백업 steps.json.bak_20261113_s6regen · inventory_check · engine_selfcheck 전체 PASS(15:30).
- 11-13 15:21 **F-1 수정(T276)**: `mapping_trace.py` `label_summary_hit()` — 라벨 요약 FAIL 은 누락 목록에 이름·라벨이 있는 조건에만 FAIL · 그 밖(제외 목록·목록에 없음)은 이 요약으로 판정하지 않음 · 요약 PASS 는 종전대로. 자기 시험 28/28(T276 7건) · engine_selfcheck PASS(15:21:17) · 사본 scratchpad/mapping_trace.py.bak_t276. 효과 확인 = `run_verify.py SSP0015 --skip-e2e`(15:21:27 시작 · 10분 넘어 백그라운드 b2riumwva · 로그 scratchpad/rerun/c2_SSP0015_skip.log) — 결과 대기. 수정 시점에 이 세션 밖 실행 SCP0028 · DMF0042(--static) 가 돌고 있었음(판정 도구는 단계마다 새로 읽힘).
- 의심 꼴 ⓓ F10 확인(15:32 기록 · 24화면 원장): F10 FAIL 15행 중 **ALTER SESSION 을 암묵 확정으로 본 것은 1행**(DMF0005 P_DMF0005_SAVE_SALES_SITE_MODEL_PRODUCTION:77 `EXECUTE IMMEDIATE 'ALTER SESSION SET optimizer_dynamic_sampling…'` — 세션 설정은 확정을 일으키지 않으므로 검사 오판 · f10_check 수정 대상). 나머지 14행은 저장 PROC 안의 COMMIT/ROLLBACK 문장을 근거로 든 것 — 문장은 실재하고, 이것을 FAIL 로 볼지는 종전부터 사용자 결정 대기인 'F10 표준' 항목(AS-IS 저장 SP 도 대부분 COMMIT 보유 — 플랜 문서 EN-02 ③ 실측 337/352).
- 11-13 15:40 의심 꼴 ⓒ(조작 불성립 표식이 있는 원장 FAIL · 요소 행만 · 24화면): 33행 — SCP0020 8 · DMF0005 5 · SCP0007 5 · SCP0005 4 · SSP0200 3 · SCP0111 2 · SCP0127 2 · SCP0131 2 · SCP0041 1 · SSP0023 1. 규칙별 F3 14 · F2 4 · E4 5 · C3 2 · E3 2 · H10 2 · F1 1 · F6 1 · I1 1 · D6 1. 증거의 'search:0행' 은 시나리오 첫 단계(조회 전) 기록이고 뒤 단계에서 행이 생긴 경우가 많아(예 DMF0005 'insert:15675행 → paste:15676행·신규1') **표식만으로 불성립이라 할 수 없다** → 건별 확인 필요. 확인된 것 1건: SCP0005 V-9e134918 F3 '기존 행 셀 Copy → 신규 행 붙여넣기(후보 밖 값)' 가 복사한 원값이 '/'(빈 값 센티널)인데 '값이 비어 있지 않아야' 로 판정 = 검사 오판(센티널 과도기 규칙 — 빈 값 비교는 '-'·'/' 허용). 같은 시나리오 꼴(F3 '후보 밖 값 행에서 복사' 14행)은 기대 자체(AS-IS 가 후보 밖 값을 붙여넣기에서 받는가)를 AS-IS 실측으로 확인해야 함 → AS-IS Live 연결 대상 후보.
- 11-13 15:43 **F-1 효과 확인(SSP0015 --skip-e2e · rc 0 · 21.5분 중 차등 검증 단계 15.1분)**: 검사 단위 FAIL 43 → 22(집계 14 · 요소 8) · G4 요소 FAIL 20 → 2 · 결과 봉투 FAIL 41 · 판정필요 63 · 미검증 1,560. 남은 G4 2건: clbResultType(실측 문구는 CR-071 '검사 대상 아님' 인데 요약 FAIL 이 우선) · txtBefore_Qty(조회조건 아닌 칸에 누락 라벨 연결). _checker_defects.md T284 기록(이 수정의 코드 주석 표기는 T276 — 대장 번호는 다른 세션이 T276~T283 를 먼저 써서 T284). 다음: (1) 검사 대상 아님(CR-071) 판정이 있으면 요약 FAIL 보다 우선 (2) 집계 행을 조치 필요 계수에서 분리(proof_backlog) (3) f10_check ALTER SESSION 제외 (4) 빈 값 센티널 '/'·'-' 를 F3 붙여넣기 기대에서 제외 → 그 뒤 24화면 일괄 재판정(--skip-e2e · 화면당 약 20분 실측이라 순차 실행 시간 큼 — mapping_trace·judge·proof_backlog 만 다시 도는 가벼운 경로가 있는지 run_verify --only 옵션 확인 후 결정).
- 11-13 15:47 확인: `_checker_defects.md` 에 다른 세션이 T276~T283 을 기록(자동 시나리오 버튼 값 정규식 · afterEach null 픽스처(= 이 문서 주기 2 (o) — **그쪽에서 처리됨 · 이 세션 ⑥ 항목에서 제외**) · 화면샷 첫 실행 집계 · 진행 표시 세부 수 · 복합 규칙 ID · 결과 파일 일시 잠금(T275 와 같은 현상) · 팝업 없는 화면 'No tests found' · 선택 팝업 열린 채 Save 시간 초과). 즉 검증엔진 파일을 고치는 세션이 이 세션 말고도 있다 → 엔진 파일 수정 직전에 그 파일의 최신 내용을 다시 읽고, 대장 번호는 쓰기 직전 마지막 번호를 확인해 다음 번호를 쓴다(이번 라벨 귀속 수정 = 대장 T284 · 코드 주석 표기 T276).
- (11-13 15:58 · 전수 점검 세션) 정리안 §6 미확인 항목 측정: engine_audit 규칙 101 = OK 96 · 대상 생성 없음 5(11-08 과 동일) · run_verify 모의 실행(--static · --skip-e2e) 단계 수 경고 0 · 룰 문서 180개 본문 대조 지적 490(확실 240 · 검토 250 — Doc/_rules_consolidation/2026-11-13_RULE_BODY_FINDINGS.csv). 본문은 고치지 않음.

- 11-13 15:59 AS-IS Live — **실측 묶음이 연결된 CheckList 전체 실행 1회 확인(SCP0028 · 15:02:53~15:58 · 전체 55.3분 · rc 0 · CheckList v10)**. 차등 검증 단계 세부 7개가 순서대로 실행됨: asis_live_auto(최근 실측 사용 · rc 0) → asis_live_screen(15:00 묶음 재사용 · rc 0 · 0.1초) → asis_live_ingest(rc 0). 즉 **재사용 경로만 확인됨 — 체인 안에서 런처를 새로 띄우는 경로는 미확인**(단독 실행은 15:00~15:02 확인). 보정: 묶음을 재사용할 때도 런처를 쓰지 않는 단계(분기·대조표 연결 갱신 → 실행 현황 → 조건 대조 → 분기별 대조)는 매번 다시 실행(15:5x 단독 확인: SCP0028 분기 25 = 판정필요 4·TO-BE 미검증 2·AS-IS 미실행 18·도달 경로 없음 1). 같은 실행에서 발견: diff_ingest.py:82 가 e2e_results.json 을 'w' 로 열다 Errno 22(rc 1) → 차등 검증 행 반입 누락 — 엔진 점검 세션에 전달(이 세션은 수정 안 함). asis_live_rows rc 3 = 조건 불일치로 판정 안 함(의도된 미측정).
- 11-13 16:01 **조치 필요 분리(대장 T285 · 코드 주석 T285)**: proof_backlog 가 FAIL 을 A2 요소 / A3 집계 행 / A4 대조표 미구현 표기로 나눠 센다(분모 불변). 자기 시험 16/16 · 게이트 PASS · 재집계(16:01) 24화면 = **요소 293 · 집계 행 567 · 문서 표기 47**. 화면별 요소: SSP0200 42 · SSP0060 33 · DMF0005 48 · SSP0021 23 · SCP0007 22 · SSP0023 22 · SCP0020 21 · SCP0111 14 · SCP0041 12 · SSP0015 8(T284 재판정 뒤) · SSP0003 8 · SSP0014 6 · SCP0005 5 · SCP0028 5 · SCP0037 4 · SCP0127 4 · SSP0024 4 · SCP0131 3 · SSP0025 3 · SCP0033 2 · SCP0122 2 · SCP0084 1 · SSP0005 1 · SCP0016 0(다른 세션 실행 중 값). ⚠ 화면 이력 파일의 '조치 필요' 열은 16:01 부터 요소만 센다(이전 값과 직접 비교 금지). 남은 것: (1) CR-071 '검사 대상 아님' 이 요약 FAIL 보다 우선 (3) f10_check ALTER SESSION (4) F3 빈 값 센티널 → 23화면 일괄 재판정 → 요소 293 의 건별 대조(ⓐ 편집 가능 여부 · ⓑ 권한 · ⓔ Hide Column · ⓕ 측정 경로 없음).

- 11-13 16:03 (엔진 점검 세션) **T284 결과 파일 'w' 재열기 Errno 22 → 반입 누락**(다른 세션 전달 15:5x): 실측 = `.vibe/logs/run_verify_SCP0028_asislive_20261113_150253.log` 15:57:14 `diff_ingest.py:82 open(e2e_results.json, 'w')` → `OSError [Errno 22]` rc 1 → SCP0028 이번 판에 ASIS_DIFF 행 반입 빠짐. 로그 전체에서 Errno 22 는 이 1건(.vibe/logs + 재실행 로그 검색). 파일을 잡은 프로세스 = 미확인(측정 방법: 재발 시각에 handle/Process Monitor 로 그 경로를 연 프로세스 확인).
  - 같은 꼴 전수: e2e_results.json 을 파이썬에서 다시 쓰는 도구 = diff_ingest.py · eg_ingest.py 2개(둘 다 원장 csv 도 'w'). 추가 위험 1건 확인 — diff_ingest 가 읽기 OSError 를 '이전 결과 없음([])' 으로 처리해, 읽기만 실패하고 쓰기가 성공하면 E2E 판정 전체가 차등 행만으로 덮일 수 있었음.
  - 보완: 신규 `tools/Harness/verify/safe_io.py`(쓰기 = 'w' 최대 5회 → 'r+b' 덮어쓰기 · 읽기 = 없으면 [] / 있는데 못 읽으면 예외) + diff_ingest·eg_ingest 의 원장·e2e_results 쓰기 4곳 교체. 백업 `.bak_20261113_audit`.
  - 확인: safe_io 자기 시험 6/6(Errno 22 5회 흉내 → 'r+b' 기록 포함) · 신·구판 출력 바이트 동일(SCP0104 — diff_ingest·eg_ingest 각각 원장·e2e_results 4개 파일 동일 · 시험 뒤 원복 확인) · engine_selfcheck 전체 PASS(16:02).
  - ⚠ 작업 중 사고: 16:02:00~16:02:38 약 38초 동안 두 파일에 깨진 문자열 리터럴이 들어가 있었음(셸 인용이 역슬래시를 바꿈 → SyntaxError · 자기 점검이 바로 검출 → 복구). 그 사이 실행 잠금은 SCP0016(E2E 단계 · 두 도구 미호출)뿐이라 실행 영향 0.
  - 남은 것(주기 2 대상 (x)): verify 도구 138개 중 'w' 로 파일을 여는 도구 73개 — 이번엔 실제 오류가 난 공용 결과 파일 경로 2개만 교체. judge.py·mapping_trace.py·ledger.py 등은 Errno 22 가 나면 rc≠0 으로 체인이 멈춰 드러나지만(조용한 누락 아님) 재시도는 없음. SCP0028 은 ASIS_DIFF 행이 빠진 판이므로 `diff_ingest.py SCP0028` + 재판정 필요(다른 세션 화면이라 실행하지 않음).

- 11-13 16:07 AS-IS Live — **수정 모드 버튼 전후 그리드 비교**(asis_live_scen_run.py --edit · grid_snap/grid_diff · 앞 300행 · 바뀐 셀 60개까지 기록+나머지 건수). SCP0019 16:05~16:07 실측: 수정 모드 켜짐 → BtnInput = spdMain/Working Time 1행에서 Action ''→'M' + 일자 컬럼 값이 빈 값으로 바뀜(바뀐 셀 361) · btnInput(같은 이름 다른 대소문자 항목) 변화 없음 · 닫기 창 예(저장 없이 닫기) · 남은 화면 0. 분기별 대조 증거 열에 그리드 변화 요약 반영. 한계: 덤프한 앞쪽 행만 비교 · 색·잠금 변화는 미기록.
- 11-13 16:21 수정 2건(대장 T286·T287 · 코드 주석 T286·T287): (1) `mapping_trace.py cr071_na()` — 기준표 제외(CR-071) '검사 대상 아님' 판정이 조회조건 검사 단위에서 다른 증거의 FAIL 보다 우선 · 자기 시험 32/32 (3) `f10_check.py` — ALTER SESSION 은 암묵 확정 검출에서 제외 · 자기 시험 13/13 · engine_selfcheck PASS 16:21:41. 화면 반영 확인은 일괄 재판정 때(미검증). 참고: f10_check 는 최종 COMMIT·예외부 COMMIT 은 이미 허용(T71)이고 FAIL 은 반복 안·중간 COMMIT 만 — F10 14행은 그 꼴. 남은 판정 쪽 수정: (4) F3 '기존 행 셀 Copy → 신규 행 붙여넣기' 에서 원값이 빈 값 센티널('/'·'-')인 경우(스펙 쪽 — 다른 세션 실행이 없을 때) · txtBefore_Qty 처럼 조회조건이 아닌 칸에 라벨이 이어지는 경로. 그 뒤 23화면 일괄 재판정.

- 11-13 16:58 (엔진 점검 세션) **SCP0016 CheckList 전체 실행(사용자 요청 · 15:28:15~16:57:59 · rc 0 · 89.5분 · v23)** — CR-100 대표 규칙 H6 정정 뒤 상속 확인: CR-100 행(V-dcd7d880 · rule H6) = **NA '규칙 판정 상속 생략(대상 불일치)'** — H6 FAIL 1건(V-1e39e729 스냅샷 팝업 PJT)을 이어받지 않음(허위 FAIL 없음 · 종전 = ERROR '[미검증] 자동 검사기 없음'). 이번 수정분 실동작: 단계 세부 수 경고 0 · 오라클 분류 검사 통과 · 'No tests found'·'snapshot doesn't exist'·requiredNotes·정규식 예외 0줄 · Playwright @verify/@trace 76 passed · eg 12+9 passed.
  - 전후 원장(2,186행): 판정 바뀐 행 18 — 그중 14행이 조회조건 'Ver.' 계열(이번 실행에서 라벨이 '_Ver.' 로 표시 → I2 FAIL "'_' 폴백 노출: _Ver." 1 · 'Ver.' 조건을 못 찾아 PASS→ERROR 11 등). 11-12 21:35 실행에서는 PASS — 그 사이 무엇이 바뀌었는지(메시지 메타·FE) 미확인 → 화면 쪽 보완 대상 후보(엔진 수정과 무관한 경로 · 확인 방법: SCM_ADM_MSG_M 의 Ver. 라벨 키 조회).
  - smoke 단계: 3건 중 1 failed + `Error: UNKNOWN: unknown error, open …Doc/e2e/results/SCP0016/results.json`(Playwright JSON 리포터가 결과 파일을 못 씀 — T281·T284 와 같은 증상 · 우리 코드 밖 경로라 재시도 미적용) → 주기 2 대상 (y).
  - regress 위반 3(사용자 판정 46건 대조) — 경고로 표시됨.

### 2026-11-13 17:06 덧붙임 — 상시 문서 정정(룰·하네스 전수 점검 세션)
- CLAUDE.md(React 19→18 · 8→11 게이트) · `.claude/rules/00-fe-screen.md`(게이트 수 · 작업 모드 · 화면 등록 확인 절차 · lint 실행 방법) · RULESET_MASTER 게이트 수 5곳(+추출본 2개 재생성) · 10_RULES_KEEP E15 대체 표기. 엔진 코드 변경 없음.
- 확인: inventory_check PASS 17:06:28 · engine_selfcheck 전체 PASS. 도구 등록부에 `safe_io.py` 반영(203). 상세 `Doc/_rules_consolidation/2026-11-13_INVENTORY_정리안.md` §11.
- 11-13 17:07 가벼운 재판정 경로 확인: `run_verify --only` 는 E2E 재실행용이라 --skip-e2e 와 같이 못 쓴다(rc 3 실측). --skip-e2e 는 화면당 21.5분(SSP0015 실측 — 차등 검증 diff_verify 549초 + AS-IS 실측 asis_live_screen 251초 포함)이라 판정만 다시 보기엔 무겁고 AS-IS 런처도 움직인다 → 사후 단계와 같은 도구·같은 순서(f10_check → mapping_trace --to-ledger → judge → mapping_trace --to-ledger → judge → mapping_trace)만 화면별로 직접 실행하는 `scratchpad/c2_rejudge.sh` 로 24화면 판정 재실행 시작(백그라운드 btx17yjbr · 로그 scratchpad/rerun/c2_rejudge.log · 다른 실행이 도는 화면은 건너뜀 · 끝에 proof_backlog·backlog_types). 반영 대상 = T284·T286·T287(코드 주석 T276·T286·T287).
- 의심 꼴 ⓐ 편집 가능 여부 D1(원장 COLUMN·ASIS 행 · 17:07 조회): D1 FAIL 이 있는 화면 7 — DMF0005 9 · SCP0020 5 · SCP0111 4 · SSP0014 4 · SSP0200 24 · SCP0037 1 · SCP0127 1. 내용별: (가) '편집=false / AS-IS 편집 가능(기본(편집 모드 전체 해제))' = 11-12 T264~T267 의 편집 모드 해석을 기대값으로 쓴 판정(DMF0005 DEPT_ID · SCP0020 LINE_ID · SCP0111 NICK_NAME·ITEM_ID) — 기대값이 AS-IS 원문과 맞는지 건별 확인 필요(엔진이 만든 기대) (나) SSP0200 기존행 잠김 18 · SSP0014 기존행 잠김 4 — 같은 꼴 (다) SCP0037 LT_DAY · SCP0127 TYPE_APPLY_DAY = '[화면 오류] 셀 편집 시작 시 편집기 생성 오류 — Wijmo Assertion: Number expected' → 화면에서 실제로 난 오류 문구(실제 결함 후보 · 사용자 재현 확인 대상) (라) SSP0200 INCOTERMS 2 = 'To Site 후보 0 — 조건부 잠금 재현 불가' → 재현을 못 했는데 FAIL(미검증이어야 함 · 검사 오판).

- 11-13 17:08 AS-IS Live — **그룹(권한) 지정 버튼 분기 실행 확인**: asis_live_scen_run.py SCP0028 --group SCP Planner (17:05~17:07) = 그룹 SCP Planner 로 전환 뒤 btnInput(팝업 SCM0002_ShipmentLotSizePopup)·btnItemId(팝업 SCM0002_ItembyDivisionPopup + ExceptionDialog) 실행 · 재시작 0 · acts.json 에 group 기록. 실행 뒤 새 세션의 그룹 = ADMIN(17:07 --groups-list 실측 — 전환이 다음 세션에 남지 않음). 미구현: 그룹별 결과를 서로 맞대는 표 · Division 별 반복.

- 11-13 17:06 (엔진 점검 세션) **SCP0016 '_Ver.' 원인 확인**(사용자: "'_' 표기는 다국어 JSON 이 정상 생성되지 않았거나 다국어가 없을 때") — 실측: FE `WaterfallShipmentPlanFgForm.tsx:259` `t('LBL01275', '_Ver.')`(작업 폴더 수정본 · 파일 시각 11-13 09:24) · 사내 DB `SCM_ADM_MSG_M` LBL01275 = KO/EN/CN 모두 'Ver.' 등록됨(17:05:57 조회) · `nscm-fe/public/locales/{KO,EN,CN}.json` 생성 시각 10-28 11:22 · LBL 최대 LBL01200 · LBL01275 없음. → **다국어는 DB 에 있고 JSON 이 재생성되지 않은 경우**. JSON ↔ DB 차이: DB 에만 있는 키 KO 158 · EN 166 · CN 167.
  - 의미: SCP0016 v23 의 I2 FAIL 1·'Ver.' 계열 PASS→ERROR 11 등 14행은 화면 결함이 아니라 시험 환경(낡은 다국어 JSON) 탓. 같은 JSON 을 쓰는 다른 화면도 10-28 이후 등록된 라벨을 쓰면 같은 허위 판정이 난다(화면별 영향 수 미측정).
  - 조치 없음(FE 산출물이라 이 세션 범위 밖): 재생성 = VM 'S2.genI18n'(`python tools/Env/fe_gen_i18n.py` · 로컬 BE 필요). 주기 2 대상 (z): CheckList 사전 작업(prereq)에 '다국어 JSON 이 DB 보다 낡음' 점검을 넣어 낡은 채 측정하지 않게.

- 11-13 17:1x (엔진 점검 세션) **FE Start 때 다국어 JSON 자동 재생성**(사용자 지시 17:0x: "시간이 많이 걸리지 않으면 별도 요청 없이 서버 기동 시 생성 — FE START 시").
  - 소요 실측: `python tools/Env/fe_gen_i18n.py` 17:10:26~17:10:28 = 2초(메시지 5,234건 · 키 KO 1618→1772 · EN 1572→1731 · CN 1571→1731 · LBL01275 3개 언어 'Ver.' 반영 확인). 산출물(public/locales/*.json · generated-keys.d.ts)은 nscm-fe/.gitignore 대상.
  - 신규 `tools/Env/fe_start_i18n.py`(로컬 BE 8080 이 열릴 때까지 최대 300초 대기 → fe_gen_i18n 실행 · 메시지 API 준비 전이면 4회까지 재시도 · BE 가 안 뜨면 파일 변경 없이 사유 1줄 · 끄기 VIBE_FE_I18N=off · 출력 '[i18n]' 접두) + `tools/Env/fe_start.cmd`(다국어 생성을 뒤에서 띄우고 vite 를 앞에서 실행 — vite 기동을 막지 않음 · python 이 PATH 에 없으면 건너뜀).
  - `tools/VibeManager/quick.json` '🎨 FE Start' cmd = `..\..\..	ools\Enve_start.cmd`(종전 `node_modules\.binite.cmd --port 5173 --host 127.0.0.1` · 백업 `.bak_20261113_i18n` · 달라진 값 1곳 확인). 메뉴·E2E 선행 자동 기동(ensureServers)·명령 팔레트 모두 이 항목을 쓴다(cmd /c · PowerShell 터미널 양쪽에서 도는 형태).
  - 확인: 자기 시험 9/9 · 래퍼 실기동(시험 포트 5199 · 17:13) — '[i18n] 다국어 JSON 재생성 완료(1초)' + 'VITE ready in 6491 ms · Local: http://127.0.0.1:5199/' 출력 뒤 시험 서버만 종료(5173 은 건드리지 않음) · engine_selfcheck PASS.
  - ⚠ 작업 중 사고: quick.json 을 r+b 로 덮어쓰는 중 truncate 가 `PermissionError [Errno 13]` 로 막혀 17:12:4x~17:13:10 약 30초 동안 꼬리가 남은(파싱 불가) 상태였음 → 백업에서 다시 만들어 복구(JSON 정상·본문 일치 확인). 그 사이 VM 이 메뉴를 읽었다면 'quick.json 파싱 실패' 경고가 1회 떴을 수 있음(확인 못 함).
  - 미확인: VM 화면에서 FE Start 버튼을 눌러 본 것은 아님(같은 명령을 cmd /c 로 실행해 확인) · BE 가 꺼진 상태로 FE 만 기동하는 실제 경우는 자기 시험으로만 확인. 설치 폴더·VSIX 는 손대지 않음(quick.json 은 작업 폴더 것을 우선 읽음 — prompt-panel.js loadQuick). SCP0016 '_Ver.' 14행은 재판정해야 바로잡힘(미실행).

- 11-13 17:18 AS-IS 품목 팝업 조회 SP 진단(사용자: "AS-IS 의 DB 품목 조회 SP 확인 … 조회불가면 비교대상이 조회가 안되어서 문제") — **SCM0002_GET_ITEM_BY_DIVISION_POPUP**(LGCE_SCMDEV · 수정 09-02). 실측 17:12~17:17(전부 조회만 · 객체 변경 없음): 런처 호출 15:02(Div 81)·17:07(Div 40) 30초 시간 초과 / 09:48 8.7초 60,187행 / 직접 실행 17:13 Div 81 2.9초·Div 40 3.1초. 캐시 계획 1개(11-06 생성 · 완료 실행 151회 · 최소 77ms·최대 232,720ms · 최대 물리 읽기 17,774). 논리 읽기 Div 81 = 1,453,431 · Div 40 = 840,734 · ALL = 2,890,474(행 15.7만). 구조: SCM_MST_SITE_ITEM(127,577행) → 행마다 SCM_MST_ITEM_SN(= 시노님 → LGCE_FPDEV_TR.dbo.SCM_ITEM_M 796,166행 · 클러스터 61,830쪽 · PK ITEM_ID,COMPANY_ID,DIVISION_ID,SITE_ID) 클러스터 탐색 · 계획 추정 85행 vs 실제 6만 행. 버퍼 점유 FPDEV_TR 169MB(SCMDEV 3,368MB) · max server memory 8,192MB · PLE 1,353초. 후보 측정: OPTION(RECOMPILE) = 악화(읽기 606만·11.8초) / 임시표 분리 = 읽기 78만(Div 81)·68만(ALL) · 집합 동일 / **(DIVISION_ID, ITEM_ID) 포함 인덱스 모형(세션 임시표 16,090쪽 ≈125MB)** = 읽기 28만(Div 81)·27만(ALL) · 물리 0 · 집합 동일(따뜻할 때 소요는 비슷 — 2.9 → 3.4초 · 7.1 → 6.3초). 시간 초과 2회의 직접 원인(그 시각 디스크·다른 부하)은 미측정 — 읽기량이 많아 캐시가 식었을 때 느려지는 구조라는 것까지만 확인. 조치: ① 도구(DB 변경 없음) = 버튼 실행에서 서버 호출 시간 초과 시 창 정리 → DB 대기 → 한 번 더 누름 · 다시 초과면 '조회 불가'로 기록하고 분기 대조에서 AS-IS 미실행 처리(asis_live_scen_run.py·asis_live_scen_cmp.py) ② 인덱스 추가·SP 수정은 구조 변경이라 사용자 승인 대기(계정 SCP_MGR_DEV 에 ALTER 권한 있음 실측).
- 11-13 17:25 **의심 꼴 ⓑ 권한 — 확정·수정(대장 T288 · 코드 주석 T288)**: 원장 FAIL 16행(DMF0005 10 · SCP0028 6)이 '선택 Division 에 권한 없음 → 버튼 비노출' 기대. 원문 확인: FE `packages/shared/src/hooks/useTabBtnPermissions.ts:57` 는 `GET /admin/menu/${menuId}/auth`(menuId 만) · BE `MenuController.java:67-69` 는 `retrieveMenuBtnAuth(userId, mnuId)` — Division 을 받지 않는다 = USER_ID 권한 합집합(CR-102). 기대값 쪽이 틀림 → `eg_auth.spec.ts:306 divAxis = false`. engine_selfcheck PASS(17:25:17). 스펙 수정이라 지금 도는 판정 재실행에는 반영되지 않는다 — 이 16행은 다음 전체 재실행 전까지 FAIL 로 남으니 건별 대조 표에서 '엔진 오판(수정됨 · 재측정 대기)' 으로 센다. 판정 재실행 진행 14/24(17:25).

- 11-13 17:25 **AS-IS 개발 DB 인덱스 추가(사용자 승인 "인덱스 추가")** — LGCE_FPDEV_TR.dbo.SCM_ITEM_M IX04_SCM_ITEM_M (DIVISION_ID, ITEM_ID) INCLUDE (ITEM_NAME, ITEM_TYPE, NICK_NAME, ITEM_CLASS_NAME) · 17:24:59~17:25:10 생성 10.7초 · 17,451쪽 · SQL = tools/AsisLocal/sql/20261113_IX04_SCM_ITEM_M.sql(되돌리기 DROP INDEX 포함) · SP 원문 불변. SCM0002_GET_ITEM_BY_DIVISION_POPUP 전→후(같은 접속 · 17:24~17:25): Div 81 논리 읽기 1,635,926 → 275,885(3.0 → 3.4초) · Div 40 840,738 → 275,440(1.7 → 1.2초) · ALL 2,890,473 → 275,440(7.3 → 5.7초) · 81+'E63' 1,073,286 → 275,440(1.1 → 0.5초) · Div 82 1,349,342 → 275,440(3.8 → 2.6초) · 물리 읽기 후 0~7. 결과: 5조건 모두 행 집합 동일 · 행 순서는 다름(ORDER BY 키가 겹치는 행들의 순서 — 아래 확인 줄 참조). 캐시가 식은 상태의 소요는 미측정.
- 11-13 17:28 **의심 꼴 ⓔ K3 Hide Column — 엔진 오판 아님(별도 실측으로 재현)**: 원장 K3 화면 행 FAIL 12(DMF0005 · SCP0005 · SCP0007 · SCP0020 · SCP0033 · SCP0037 · SCP0127 · SCP0131 · SSP0015 · SSP0023 · SSP0024 · SSP0025 — 전부 'Hide Column → 컬럼 여전히 표시') · 같은 검사 PASS 8화면. 임시 진단 스펙(저장 없음 · 실행 17:27:52~17:28:29 · 1 passed · 실행 후 삭제)으로 SCP0037 를 따로 잼: 헤더 'Div'(DIVISION_ID · index 0)·'Plant Site Code'(index 1) 우클릭 → 메뉴에 'Hide Column' 있음 → 클릭 → 컬럼 12개 전부 visible=true · 폭 그대로(바뀐 컬럼 0) · 같은 binding 중복 0. 즉 이 화면에서는 Hide Column 을 눌러도 숨겨지지 않는다 = 화면에서 실제로 나는 동작(12화면 공통 문구 → 공통 원인 1건 후보 · 숨겨지는 8화면과의 차이는 미확인). 사용자 재현 확인 대상(SCP0037 헤더 우클릭 → Hide Column). DB MODE 라 FE 는 고치지 않는다 — 원인 위치 확인은 보완 단계.

- 11-13 17:29 인덱스 추가 뒤 확인 — 같은 SP 를 두 번 실행하면 행 순서 동일(Div 81·40 · 17:25) · ORDER BY 키(DIVISION_ID, SCM_SITE_ID, SITE_DESCRIPTION, ITEM_ID, ITEM_NAME)가 겹치는 행 = Div 81 17,310행(7,635키)·Div 40 15,448행(7,633키) → 인덱스 전후 순서 차이는 이 겹치는 묶음 안쪽(SQL 이 순서를 정하지 않는 부분 · 전후 키 순서 직접 대조는 못 함 — 집합 동일 + 같은 정렬 식에서 따라 나옴). 런처 재확인 17:27: SCM0002_GET_ITEM_BY_DIVISION_POPUP Div 81 = 2,413ms · 60,187행 · 예외 창 없음. 호스트 보정: 팝업 행 수를 팝업이 뜬 직후가 아니라 행이 채워지거나 6초가 지난 뒤 읽음(17:29 실측 SCM0002_ItembyDivisionPopup 행 0 → 60,187). 미확인: 캐시가 식었을 때의 소요 · 이전 실행분 팝업 244개의 행 수는 이른 시점 값(재실행 전까지 신뢰 불가).
- 11-13 17:38 **판정 재실행 끝(17:07:42~17:37:55 · 24화면 · 전 도구 rc 0 · 건너뜀 0 · 화면 테스트·AS-IS 실행 없음)** — 반영 = T284·T286·T287(코드 주석 T276·T286·T287). 결과 파일 `Doc/verify/_cycle2_rejudge_by_screen.csv`. 24화면 합: FAIL 검사 단위 936 → 803 = 집계 행 523 + 대조표 미구현 표기 47 + **요소 233**(재실행 전 요소 317) · 증명됨 4,616 → 4,627. 화면별 요소(전 → 후): SSP0015 27→7 · SSP0023 22→8 · SSP0021 23→10 · SSP0060 33→23 · SSP0200 42→33 · DMF0005 48→43 · SCP0041 12→8 · SSP0003 8→4 · SCP0111 14→11 · SCP0028 7→5 · 나머지 14화면 변동 없음(SCP0007 22 · SCP0020 21 · SSP0014 6 · SCP0005 5 · SCP0037 4 · SCP0127 4 · SSP0024 4 · SCP0016 3 · SCP0131 3 · SSP0025 3 · SCP0033 2 · SCP0122 2 · SCP0084 1 · SSP0005 1). 참고: SCP0016 증명됨 260 → 250 · SCP0028 FAIL 단위 9 → 10 은 이 세션 밖 실행(11-13 15:35~16:08 무렵 SCP0016·SCP0028 run_verify)이 원장을 바꾼 화면이라 판정 수정 효과와 섞임(구분 미측정).
- 요소 233 중 이미 가른 것(재측정 대기 포함): 권한 기대값 오판 16 원장 행(DMF0005·SCP0028 — T288 수정 · 전체 재실행 전까지 FAIL 로 남음) · F10 ALTER SESSION 1(반영됨) · SCP0005 F3 '/' 1 · SSP0200 INCOTERMS 재현 불가 2 = 엔진 오판 / K3 Hide Column 12화면 = 실제 동작(별도 실측) / SCP0037·SCP0127 편집기 생성 오류 2 = 실제 결함 후보. 나머지는 건별 대조 전 — 다음: ⓕ '측정 경로 없음' 이 FAIL 요소로 집계되는 경로 · 편집 가능 여부 기대값(편집 모드 전체 해제) 원문 대조 · F3 후보 밖 붙여넣기 기대 · SCP0007 −107.

- 11-13 17:38 AS-IS Live P6 잔여 1차 — **Division 지정·반복 + 그룹·Division 비교표 + TO-BE 팝업 실행 결과 연결**. (1) asis_live_scen_run.py <ID> --division 81,40|all: 조회 전 Division 조건을 바꾸고(채움 규칙이 되돌리지 않게 잠금) 눌렀던 버튼을 그 Division 으로 다시 실행 · 실행 폴더 뒤 _div<코드>. SCP0028 17:33~17:36 실측 Division 40·82: 품목 팝업 SP 인자·행 수 = 29,575 / 65,906(직접 실행 값과 일치) · 재시작 0. (2) asis_live_scen_matrix.py <ID> → scenario_matrix.csv: 버튼 × (그룹, Division, 수정 모드) 관찰을 나란히 · 모양(팝업 종류·메시지·호출 SP·성공 여부) 차이만 '조건에 따라 다름'. SCP0028 = 조건 4개 · 버튼 2 · 같음 1 · 다름 1(다름의 원인 = SCP Planner 실행이 인덱스 추가 전 시간 초과분 — 재실행 필요) · 부수 관찰: 기본 Division 이 ADMIN 81 / SCP Planner 40(사이트 호출 447 vs 1,294행). (3) asis_live_scen_cmp.py 에 TO-BE 팝업 검사기 결과(eg/popup/popup_rowsets.json·popup_results.json — 같은 AS-IS 버튼으로 TO-BE 팝업을 실제로 연 결과) 연결 · 같은 버튼끼리만 대응. SCP0028: 품목 팝업 AS-IS 60,187행 ↔ TO-BE 'Material by Division' 9,616행 = 판정필요(CR-101) / 입력 팝업은 TO-BE 가 btnDelete 로 연 기록뿐 → TO-BE 미검증. 미구현: 저장 시나리오 · 팝업 외 분기의 TO-BE 동일 조작 실행 · VM 등록(--division·비교표).

- 11-13 17:40 AS-IS Live — VM 등록 S1.liveScenRunDiv·S1.liveScenMatrix(+메뉴 2) · 실측 묶음에 비교표 단계 추가(재사용 경로 5단계 실행 확인) · engine_selfcheck PASS. **저장 시나리오 = 미착수(타당성만 확인)**: SCP0028 저장 = SCP.SCP0028_SAVE_SHIPMENT_LOT_SIZE(SaveData:659 · FindDelete:511) → SCP_MST_SHIPMENT_LOT_SIZE MERGE/DELETE(키 division_id·operation_group·from_site·to_site·item_id · SP 안에서 COMMIT). 필요한 것: ① 호스트 셀 값 입력 + 화면의 변경 표시(Action 열)까지 일으키는 방법(FarPoint 는 코드로 값을 넣으면 Change 이벤트가 나지 않음 — BaseForm 의 변경 추적 경로 확인 필요) ② 저장 버튼(OnClickSaveButton)과 저장 확인 창에만 '예' ③ 저장 전 대상 행 기록 → 저장 인자 포착 → 키로 원래 값 복원·대조. DB 쓰기가 따르므로 한 화면 시범부터.

### 2026-11-13 17:42 덧붙임 — 룰 본문 정정(확실 240건 · 룰·하네스 전수 점검 세션)
- 정정 203 · 보류 36 · 지적 오류 1. 변경 룰 문서 82개(hooks·_tobe·_dev_rules). 엔진 코드 변경 없음. inventory_check·engine_selfcheck PASS.
- 목록 `Doc/_rules_consolidation/2026-11-13_RULE_BODY_FIX_RESULT.csv` · 상세 정리안 §12.
- 11-13 17:42 **편집 가능 여부(D1) 추적 검사 오판 — 원인 확정·수정(대장 T289 · 코드 주석 T289)**: 요소 FAIL 233 중 D1 이 47(검사 종류 1위). 원장 TRACE D1 FAIL 30행(DMF0005 16 · SSP0200 11 · SCP0007 1 · SCP0020 1 · SCP0111 1) 중 14행은 같은 컬럼의 @verify 행이 'AS-IS 잠금' PASS 로 정반대. 원인 = `mapping_trace.py:411` 이 edit_expect.csv 를 컬럼 이름으로 dict 화 → 같은 컬럼의 컨트롤별 행(''·siMain·siSub…) 중 마지막 행이 이겨 보조 그리드 기대가 주 그리드 판정에 쓰임(예 DMF0005 LAST_UPDATE_DATE: siMain new_row=N · siSub new_row=Y → 'AS-IS 편집 가능' 으로 판정). 수정 = `pick_edit_expect()` — 컨트롤마다 기대가 다른 칸은 AMBIG(→ 판정필요). 자기 시험 36/36 · 게이트 PASS 17:42:35. 영향 컬럼: DMF0005 41 · SCP0020 16 · SSP0003 54 · SSP0015 70 · SSP0021 72 · SSP0023 71 · SSP0060 71 · SSP0200 68. E2E 때 읽는 값이라 기존 FAIL 은 전체 재실행 전까지 남는다 → 건별 표에서 '엔진 오판(수정됨 · 재측정 대기)' 30행으로 센다(그중 정반대 증거가 있는 확정 14 · 나머지 16 은 재측정 후 판단). 같은 기대값을 쓰는 H2(편집 칸 색) 추적 판정도 영향 가능 — 재측정 때 함께 확인.

## 2026-11-13 17:4x 문장 규칙 3개(수식어 금지 · 아는 주어 생략 · 번역투 금지) — 문서 생성기 반영 (VM 세션)
- 사용자 상시 지시. 정본 tools/VibeManager/rules/50_DOC_STYLE.md · 검사기 tools/Docs/doc_style.py.
- 바꾼 파일(문구만 · 판정·열 구성 불변 · 백업 *.bak_20261113_style): make_verify_docs.py(문구 5 + 저장 뒤 검사 2곳) · plain_detail.py(6) · make_test_report.py(1 + 검사) · asis_live_doc.py(제목 2).
- 생성기에 문장을 넣거나 고치면 `python tools/Docs/doc_style.py <그 파일>` 로 위반 0 확인.
- 미반영: 검사 엔진(JS spec · judge.py · eg_*.py)이 만드는 측정 기록 문구 — 문서에 그대로 실리는 행은 규칙 검사에 집계만 된다.

- 11-13 17:52 **AS-IS 저장 시나리오 시범 통과(SCP0028 · 사용자 승인 "네, 시범 진행")** — tools/AsisLive/asis_live_save.py + 호스트 `cell`(셀 선택 → 편집 상태 → 값 → 편집 끝 = 사용자 편집 경로) + 화면별 정의 Doc/asislive/SCP0028/save_scenario.json(테이블·키·대상 행 조건·고칠 열 — 소스/SP 원문 근거로 사람이 작성). 연습(--dry) 17:50~17:51: LOT_SIZE 12,800 → 12,801 · 변경 표시 '' → 'M' · 저장 없이 닫음 · DB 그대로. 실행 17:51~17:52: 저장 버튼 → SCP0028_SAVE_SHIPMENT_LOT_SIZE 1회(인자 p_active_flag=M · p_operation_group=A · p_lot_size=12801 · p_increment=12800 · p_user_id=jaeuk.shin 등 13개 포착 · 235ms) · 메시지 '1개의 데이터가 저장되었습니다.' · DB LOT_SIZE 12800 → 12801(LAST_UPDATED_BY ssp → jaeuk.shin) → 복원 UPDATE 1문(키 6컬럼) → 복원 뒤 전 기록과 전 컬럼 동일. 남는 흔적: SP 가 쓰는 배치 로그(scm_sys_log_batch)·접속 로그는 지우지 않음. EN-02 ③ '저장 인자 포착 경로 없음' 의 AS-IS 쪽 경로가 생김(TO-BE 저장과의 대조·신규 행·삭제·다른 화면은 미구현). VM: S1.liveSaveDry·S1.liveSave + 메뉴 2.
- 11-13 17:56 **정렬 순서 A6 — 오판 2종 수정(대장 T290·T291 · 코드 주석 T290·T291)**: ① sort_check 가 `FN_ASIS_SORT_KEY(col)` 를 풀지 않고 · 한 컬럼의 보정 식 2개를 키 2개로 셈 → 수정 후 24화면 정렬 대조 FAIL 73 → 59(17:55 재실행 실측) ② 문장 대조 FAIL 이 실측 순서 일치(PASS)보다 우선하던 것 → `a6_measured_wins()`(실측 PASS·공통 2행 이상·DIFF 없음이면 문장 FAIL 은 참고). 자기 시험 sort_check 5/5 · mapping_trace 41/41 · 게이트 PASS 17:56:43. 남은 정렬 대조 FAIL 59 의 구조: FAIL 이 남은 SP 36개 중 21개가 AS-IS ORDER BY 2개 이상(여러 결과셋·내부 정렬을 TO-BE 마지막 ORDER BY 하나와 비교) — 실측이 없는 것은 건별 확인 대상으로 남음(예 SCP0127 GET_PRECEDE_SAFETY_STOCK_DAY 는 분기 1개·7번째 키부터 다름 = 실제 차이 후보).

### 2026-11-13 17:57 덧붙임 — 룰 본문 보류 건 권장안 반영(룰·하네스 전수 점검 세션)
- 보류 36건 중 29건 확정(문서 15개 · 치환 33곳) · 남은 보류 6. 엔진 코드 변경 없음. inventory_check·engine_selfcheck PASS.
- 룰과 코드가 다른 곳 3종(공용 SubTitle 기본 버튼 동작 · 메타 대체 컬럼 6곳 · measure divisionId 미전송 4화면)은 정리안 §14 에 보완 후보로 기록.
- 11-13 18:02 **업무 메시지 E4 — 오판 수정(대장 T292 · 코드 주석 T292)**: E4 FAIL 원장 31행 = 저장 성공 메시지가 F1 실패를 승계한 것 25(SCP0020 9 · SCP0111 5 · SSP0060 11 — 근원 F1 FAIL 은 화면당 1행) + SCP0005 '저장 실패 시 오류 행·셀 표시 없음(대조표 D00-3-043~ 미구현)' 5 + DMF0005 MSG00097 '신규행 편집 불가 — 위반 입력 경로 없음' 1(= T289 편집 기대 오판에 딸린 것). 수정 = `judge.py e4_from_f1()` · 자기 시험 7/7 · 게이트 PASS 18:02:30 · 판정 재실행 2차에 반영(SCP0020 부터).
- ⚠ **확인 필요(우선)**: 근원 F1 FAIL 중 SCP0111 '컬럼별 저장 왕복 — 202609 r0 2→3 재조회 2 NG'(BOH_QTY 는 3 으로 저장됨). 11-12 09:55 에 이 세션이 `PKG_SCP0111.P_SCP0111_SAVE_INTEGRATION_PSI` 의 수율 INSERT 에 ITEM_ID 조건을 추가했다 — 월 칸 저장 누락이 그 변경 때문인지, 변경 전부터인지 미확인. 확인 방법: 변경 전 원문(_artifacts/_apply_corporate/SCP0111_YIELDP_ITEM_20261112/PKG_SCP0111_BODY.ASIS.sql)과 대조해 월 칸(202609) 저장 경로가 수율 임시표에 의존하는지 읽고, E2E 저장 요청 본문(Doc/verify/SCP0111/e2e 결과)의 값·응답을 확인. SSP0060 'D_20261009 r8 71,344 → 71345 재조회 71,344' 도 같은 방식으로 확인.
- 11-13 18:03 SCP0111 저장 확인(원문 대조 · `_artifacts/_apply_corporate/SCP0111_YIELDP_ITEM_20261112/PKG_SCP0111_BODY.TOBE.sql`): 11-12 변경은 1727행 `INSERT INTO GT_SCP0111_YIELD_P` 1곳(1751~1752행 ITEM_ID 조건 추가)뿐이고, 그 뒤 이 임시표를 읽는 3곳(1761·1787·1849 블록)은 모두 `…ITEM_ID(+) = UPPER(V_ITEM_ID)` 로 같은 품목만 읽는다 → 적재 범위를 그 품목으로 줄인 것은 읽는 결과를 바꾸지 않는다(원문 기준 · 실행 대조는 안 함). 1389행의 다른 적재문(1439 에서 읽음)은 손대지 않았다. 따라서 '202609 r0 2→3 재조회 2 NG' 의 원인을 이 변경으로 볼 근거는 없다 — 실제 원인은 미확인(F1 실제 차이 후보로 유지 · 저장 요청 본문·응답 확인이 다음 단계).

### 2026-11-13 18:03 덧붙임 — 룰 본문 보류 건 DB 실측(룰·하네스 전수 점검 세션)
- 사내 ZIOUI1 읽기 전용 조회로 3건 정정(빈 문자열 비교 2 · 미선택 필터 전송값 1) · 남은 보류 3. 엔진 코드·DB 객체 변경 없음.
- 사내 PKG 원문에 빈 문자열 부등 비교 170줄/78객체 · NOT IN 빈 문자열 8줄/8객체(정규식 일치 수 · 영향 미확인) — 정리안 §15-1.
- 11-13 18:09 **조건부 잠금 D3 대조(원장 D3 FAIL 13행 · 요소 22 는 이 행들을 가리킴)**: 엔진 오판으로 볼 근거가 있는 것 2 · 실제 차이 후보 11.
  - 엔진 오판(미수정) 2: DMF0005 ATTRIBUTE1 등 'GROUP=="DM Planner" → AS-IS 잠금 · TO-BE 편집=true' — 시험 계정이 ADMIN 을 포함한 여러 그룹 보유. AS-IS 는 그룹 하나로 판정, TO-BE 는 보유 권한 합집합(CR-102)이라 다른 보유 권한으로 허용되는 차이는 오류 아님. `tools/E2E/lib/condeval.ts:40` 의 GROUP 원자는 '보유 그룹 중 하나라도 일치하면 참' — 잠금 규칙에 쓰이면 합집합 룰과 반대로 작동. 수정은 잠금 규칙을 평가하는 호출 쪽(잠금은 보유 그룹 전부가 잠금 대상일 때만)에서 해야 해 스펙·lib 수정 + 재측정 필요 → 다음 스펙 수정 묶음에 넣는다. 같은 꼴(그룹 조건이 들어간 편집 FAIL) 원장 16행: DMF0005 D1 2 · D3 2 · SCP0111 D1 6 · J3 6.
  - 그중 SCP0111 12행은 방향이 반대(TO-BE 편집=false · AS-IS 가능)이고 한 건의 반복: 'BOH_QTY r1 편집=false / AS-IS 가능(EditButton:652 !(GROUP=="ADMIN") && DIV!="82" && DIV!="40" …)' 6셀 중 1셀 불일치가 검사 ID 4개(EG123·124·377·378)×계정으로 복제 → 실제 차이 후보 1건(중복 11).
  - 실제 차이 후보: SCP0007 INCOTERMS·INCOTERMS_SSP 6행(To Site 유형 PLANT/SALES 에 따른 잠금이 AS-IS SetCityCode:1423·EditButton:496 과 다름 — 행 값까지 적힌 실측) · SCP0041 3행(DIR=='HOLD' 행의 QTY·DATE_FORECAST_START·DATE_FORECAST_FINISH 가 TO-BE 편집 가능 · AS-IS EditButton 잠금) · SCP0020 1행(Div 82 에서 DAILY_CAPACITY·UOM_CONVERT_VALUE 편집 가능 · AS-IS 는 Div 42·44 만 해제) · DMF0005 OWNER 1행(Div 40 · EDIT_FLAG=='Y' 행에서 편집 가능 · AS-IS EditButton 잠금). 이 넷은 AS-IS 의 'Edit 버튼을 눌렀을 때 거는 잠금' 규칙이 기대값 — TO-BE 는 조회 즉시 편집(CR-084·093·103)이므로 그 잠금이 그대로 적용돼야 하는지는 AS-IS 원문(EditButton 핸들러)·AS-IS 실측으로 확인할 대상(AS-IS Live 연결 후보).

- 11-13 18:09 AS-IS 저장 시나리오 확대 + 저장 인자 대조. (1) **asis_live_save_cmp.py** — AS-IS 저장 인자(save.json) ↔ TO-BE 저장 호출 인자(Doc/verify/<ID>/sqllog_calls.json kind=SAVE) 이름 맞춤 대조 → save_compare.csv. SCP0028: 수정 저장 ↔ TO-BE 15:17:09 호출 = 같음 11 · 다름 1(debug_mode F↔N) · 한쪽에만 0. 없는 행 입력 저장은 TO-BE 에 같은 조작이 없어 가장 가까운 호출과 다름 4(lot_size·increment·transport_mode·debug_mode) — 조작이 다른 짝. (2) 저장 정의 확장: scenarios(여러 개 · 하나씩 새 세션) · expect_before(0 = 없던 행이 생김 → 복원 DELETE) · side(저장 SP 가 덧붙이는 표 — 이번 실행분만 삭제). SCP0028 두 시나리오 18:06~18:08 전체 실행 = update OK(복원 UPDATE 1 · 이력 1행 삭제) · insert OK(행 0 → 1 · 인자 p_active_flag=M·lot 1·increment 1 · 복원 DELETE 1 · 이력 1행 삭제) · 끝 상태 = 원래 행(SEA 12800 · ssp) 그대로 · 내 이력 행 0 · 열린 트랜잭션 0. (3) **사고·조치 18:00~18:02**: insert 첫 실행에서 저장 SP 가 30초 시간 초과(30,016ms) → 서비스 접속(세션 63 · 이 PC · .Net SqlClient)에 트랜잭션이 열린 채 남고 대상 표에 X 잠금 → 이 PC·열린 트랜잭션·마지막 문장 = 그 저장 SP·시작 시각 일치 확인 뒤 KILL 63(미커밋 되돌림) → 잠금 0 확인. 같은 시각대 다른 PC(P2605LN0024 · pymssql)의 집계 조회가 103초 실행 중이었음(14:38 메뉴 SP 시간 초과 때도 같은 호스트의 조회가 실행 중) — 상관만 관찰 · 원인 단정 아님. 재발 대비: 저장 중 대기 상태 기록(save_wait) + 시간 초과 시 자기 세션만 종료(kill_own_open_tran) → 판정 SAVE_TIMEOUT. 앞선 두 실행이 남긴 이력 2행(HISTORY_SEQ 1387·1389)은 키로 삭제. VM: S1.liveSaveCmp + 메뉴.

## 2026-11-13 18:1x 문장 규칙 4~18 — 저장 직전 기호 정리 + '설명' 칸 개조식 (VM 세션)
- make_verify_docs.py(2곳) · make_test_report.py · make_docs.py · make_testcases.py · md2xlsx.py 의 wb.save 직전에 `doc_style.before_save(wb)`.
- 바뀌는 것: 셀 글의 ' — ' → ': ' 또는 ', ' · ' · ' → ', ' · ⇒·이모지·굵은 글씨 삭제 · '설명' 칸 '~습니다' → '~음'. 사용자의견·사용자판정 칸, 검증 ID, 결과 값은 그대로(기존 CheckList 1건 18,946셀 대조 다름 0).
- 주의: ledger·evidence 원문은 바꾸지 않았다. 생성기 안 정규식·split(' — ') 는 종전대로 동작한다. Excel 을 다시 읽어 글을 대조하는 코드를 새로 만들면 정리된 글 기준으로 맞춘다.
- 끄기: 해당 생성기의 before_save 3줄 삭제. 백업 *.bak_20261113_style.

- 11-13 18:18 AS-IS Live — **관찰 문구→TO-BE 룰 대응표 보강**(1행 → 자동 생성): tools/AsisLive/asis_live_rule_map.py = 룰 원장(TOBE_DIFF 255 · 보류·N 제외) 본문의 AS-IS 메시지 코드 + AS-IS 메시지 사전(UP_FX_GetMessageInfoList 470개 → Doc/asislive/_asis_messages.json) → asis_obs_rule_map.csv(pattern·rule_ids·scope·level·source·msg_id). level confirmed(오류 아님) = 룰 본문이 '오류가 아니다/정상/없어도 된다' 고 적은 것 + 편집 모드 계열 중 소스 경로 확인분(MSG00008·9·10·135·115·139·162 — BaseForm.cs) / candidate(판정필요) = 룰이 메시지를 언급만 했거나 경로 미확인 편집 계열 / unusable = 메시지 사전에 코드 없음. 분기 대조(asis_live_scen_cmp.py)가 scope·level 을 따름. 수동 행은 asis_obs_rule_map_manual.csv(있으면 합침). 한계: 코드에서 직접 조립한 문장·메시지 코드가 없는 룰은 못 잡음.
- 11-13 18:17 **판정 재실행 2차 끝(17:57:19~18:17:25 · 24화면 · 전부 rc 0 · 건너뜀 0)** — 요소 233 → 170 · 그러나 **증명됨 4,627 → 4,419(−208)**. 감소 화면: SSP0200 167→103 · SSP0060 234→182 · SCP0020 173→127 · SSP0021 257→237 · SSP0003 62→43 · DMF0005 200→188 · SSP0015 110→103.
- 18:18 **원인 = 이 세션의 T289 수정 부작용**: 편집 기대(editExpect)가 컬럼 대상의 모든 검사 조건(JSON)에 실려 있어(`mapping_trace.py` 1212행), 선택을 바꾸자 D1 이 아닌 검사(A5·H5·H2·D5·M4·E4·E1 …)의 조건 해시까지 바뀌고 judge 가 그 E2E 결과를 '재측정 필요(검사 조건이 바뀐 뒤 아직 재실행되지 않음)' 로 돌림 — SSP0200 165 · SSP0060 174 · SCP0020 62 검사 단위. 스펙에서 editExpect 를 읽는 것은 D1 뿐(_trace.spec.ts:458·495). 측정 결과 원본은 `Doc/verify/<ID>/e2e_results.json` 에 남아 있어 조건을 되돌리면 다시 반입된다.
- 18:19 **보정(대장 T289 행에 덧붙임 대상 · 코드 주석 'T289 보정')**: `edit_expect_for()` — 새 선택은 D1 조건에만, 그 밖의 검사에는 종전 값(파일 마지막 행)을 실어 해시 보존. 자기 시험 44/44 · 게이트 PASS. SCP0020 로 확인(18:19:20~18:20:02): PASS 127 → 178 · '재측정 필요' 는 D1 7개만 남음. 나머지 영향 화면 7개(DMF0005 · SSP0003 · SSP0015 · SSP0021 · SSP0023 · SSP0060 · SSP0200) 재판정 시작(백그라운드 · 로그 c2_rejudge.log 'T289 보정 반영'). 교훈: 검사 조건에 실리는 사실 값을 바꾸는 수정은 그 값을 읽지 않는 검사의 조건까지 바꾸는지 먼저 확인(재판정 전후 '증명됨' 을 반드시 대조 — 이번에 그 대조로 발견).
- 18:20 **⇒ 주기 1 의 SCP0007 증명됨 −107(주기 2 순서 ①)도 같은 기제일 가능성 확인 대상**: 11-12 의 T263~T267(잠금 조건 해석 변경 → lock_rules·edit_expect 내용 변경)·T266(Def 정규화)이 컬럼 검사 조건 해시를 바꿨다면, 재실행에서 다시 재지 못한 검사 단위가 '재측정 필요' 로 남았을 수 있다 → SCP0007 mapping_trace_instances.csv 의 '재측정 필요' 수와 기준 대비 감소분을 대조해 확인.
- 11-13 18:22 **주기 2 순서 ① SCP0007 증명됨 821 → 714(−107) — 위치 확정**: 감소는 AS-IS 시트 'Distribution Route'(grid_effective.csv 33컬럼 · 주 시트 BOD 39컬럼과 별개)의 18개 컬럼(VALID_YN · FROM_CITY_NAME · DAYS · D_PORT_NAME · D_COUNTRY · D_PORT_CODE · A_PORT_NAME · A_COUNTRY · A_PORT_CODE · SHIPPING_COMPANY · TO_CITY_NAME · SHIP_DOC_PREPARATION_DATE · LT_DEPARTURE_INLAND · LT_WAIT_SHIPPING · LT_VOYAGE · LT_LAY_OFF_CLEARANCE · LT_ARRIVAL_INLAND · LT_SUM)에 몰려 있다. 현재 그 컬럼의 요소 검사 단위 94 = ERROR 45(A5 18 · H5 18 · C2 5 · C6 3 · C3 1 — 'AS-IS 시트 Distribution Route 의 TO-BE 그리드를 화면에서 찾지 못함 — 표시 여부 미측정(T203)' 등) · NA 45(H2 18 · D5 18 …) · PASS 4, 그리고 그 요소를 묶는 집계 단위 18(A5 6 · H5 6 · D1 3 · D3 3 — 'A5 47요소: PASS:29 · ERROR:18')이 통과가 아니다 → 90 + 18 = 108 ≈ 감소 107. '재측정 필요'(조건 변경) 단위는 0 이라 T289 부작용과는 다른 기제.
  - 확인된 것: 이 18컬럼의 검사가 지금은 시트 'Distribution Route' 의 그리드를 찾아 재려다 못 찾아 미측정으로 남는다. 11-12 에 시트 이름 연결(T272 — 원장 행 10,675개 영향)을 고친 뒤의 재실행에서 생긴 변화.
  - 확인 못 한 것: 기준 실행에서 이 단위들이 어떤 근거로 PASS 였는지(기준 원장 사본 없음). 주 그리드(BOD)에 없는 컬럼이므로 그 PASS 가 올바른 대상을 잰 것이었는지 의심되지만 단정할 자료가 없다.
  - 할 일(엔진): TO-BE 에서 'Distribution Route' 시트가 어디에 뜨는지(AS-IS SCP0007_DistributionRoutePopup 대응 모달/탭)를 열고 그 그리드에서 재는 경로 — 보조 시트 그리드 탐색. 그 전까지 이 108 단위는 '미측정' 이 정직한 상태.

- 11-13 18:27 AS-IS 저장 시나리오 확대(삭제·여러 행·검증 메시지) — asis_live_save.py 새 구조(edits 여러 개 · expect=message · kind=delete_popup) + 호스트 명령의 팝업 대상 지정(form=<폼 형식>: set·cell·act·dump) + 체크 상자 열 값 입력. SCP0028 18:23~18:26 실측 3종: ① invalid_zero = Lot Size 0 → 메시지 '0보다 큰 정수를 입력하십시오.'(MSG00084 · checkValidSize:751) · 저장 호출 0 · DB 그대로 → MESSAGE_OK ② multi = 두 행(+1씩) 한 번에 저장 → 저장 SP 1회 · 인자가 '^' 로 묶임(p_active_flag=M^M · p_lot_size=12801^5761 …) · '2개의 데이터가 저장되었습니다.' → 복원 UPDATE 2 · 이력 2행 삭제 → OK ③ delete = btnDelete → 팝업(From Site 조건 지정 → 조회 60행 → 대상 체크) → '삭제 하시겠습니까?' 예 → 저장 SP 1회(p_active_flag=D · transport_mode=X · lot 0) · '삭제 하였습니다.' · DB 1 → 0행 → 복원 INSERT 1 · 이력 1행 삭제 → OK. 끝 상태: 내 계정으로 남은 본 표 행 0 · 이력 행 0 · 열린 트랜잭션 0. 정의 = Doc/asislive/SCP0028/save_scenario.json 시나리오 5개(update·insert·multi·invalid_zero·delete).

- 11-13 18:29 **분기 시나리오 명세(전 분기)** — 사용자: "각 화면별 시나리오는 저장뿐만 아니라 소스 분기의 모든 케이스에 대해서 시나리오 작성되어야 합니다". tools/AsisLive/asis_live_scen_spec.py → Doc/asislive/<ID>/scenarios_spec.csv(분기 1개 = 1줄: trigger·precond·guard·driver·AS-IS 결과·TO-BE E2E 검사 실행 수·TO-BE 팝업·tobe_steps) + _scenarios_spec_summary.csv. 실측 18:28 전 화면: 화면 145 · 분기 12,240(빠짐 0) = 실행기 있음 1,332 · 실행기 있음(전제 값 지정 필요) 2,595 · 정의 필요(저장 계열 — save_scenario.json) 4,074 · 명령만 있음 1,891 · 건너뜀 규칙 57 · 드라이버 없음 1,398 · 경로 없음 893. AS-IS 실행 518 · 미실행 11,722. TO-BE E2E 근거 있음 6,341(연결된 대조표 검사 중 E2E 로 실제 실행된 것 — '팝업 외 분기의 TO-BE 실행'은 이 연결로 채움 · 같은 조작을 새로 일으킨 것은 아님). tobe_steps 는 조회·행 추가·저장만(그 밖은 TO-BE 화면 요소 대응이 없어 비움). trigger·precond 는 진입점 이름·조건식 문자열 규칙 판독 — 분기를 타게 하는 구체 값은 자동으로 정하지 않음(guard 가 기준). VM: S1.liveScenSpec·S1.liveRuleMap + 메뉴 2 · 실측 묶음에 명세 단계 추가.
- 11-13 18:30 **보정 반영 재판정 끝(18:20:28~18:29:44 · 7화면 rc 0) — 24화면 현재값**(`Doc/verify/_cycle2_rejudge3_by_screen.csv`): FAIL 검사 단위 723 = 집계 행 495 + 대조표 미구현 표기 47 + **요소 181** · **증명됨 4,655**(주기 1 끝 4,616 → 1차 4,627 → 2차 4,419(부작용) → 보정 4,655) · '재측정 필요' 123(D1 — T289 로 기대가 바뀐 단위: DMF0005 44 · SSP0200 23 · SSP0023 13 · SSP0060 12 · SSP0021 11 · SSP0015 9 · SCP0020 7 · SSP0003 4). 대장 T293(부작용·보정). 요소 181 의 검사 종류: D1 28 · D3 22 · A6 13 · A5 11 · H10 9 · C6 8 · E4 7 · G4 6 · F3 6 · F1 6 · J2 5 · B3 5 · F2 5 · M3 5 · X-LOC 4 · F5 4 · I1 4 · K4 3 · C2 3 · A1 3 · 그 밖 16종 24. 화면별 요소(주기 1 → 지금): SSP0200 42→27 · DMF0005 48→28 · SCP0007 22→22 · SCP0020 21→16 · SSP0060 33→14 · SSP0021 23→10 · SCP0041 12→7 · SCP0111 14→6 · SSP0014 6→6 · SSP0023 22→6 · SCP0005 5→5 · SCP0028 7→5 · SSP0015 27→5 · SCP0037 4→4 · SSP0003 8→4 · SCP0127 4→3 · SCP0131 3→3 · SCP0016 3→2 · SCP0122 2→2 · SSP0024 4→2 · SCP0033 2→1 · SCP0084 1→1 · SSP0005 1→1 · SSP0025 3→1.
- 11-13 18:35 **사용자 지시: '전체 종료되면 종료되었다고 알려주세요.'** → 종료 알림 조건(이 문서 기준): (가) 조치 필요 요소 전부를 [엔진 오판 / 중복 / 실제 차이 후보 / 사용자 결정 대기] 로 가른 표 완성 (나) 주기 2 순서 ①~⑧ 처리 또는 사유와 함께 이월 (다) 스펙 쪽 수정 묶음 반영 (라) 사용자에게 먼저 알린 뒤 전체 재실행 1회 + 전후 비교 기록. (가)가 끝나면 '점검 종료', (라)까지 끝나면 '전체 종료' 라고 첫 줄에 적어 알린다. 그 전에는 종료라고 쓰지 않는다.

- 11-13 18:38 AS-IS Live — **조건 값 변경 분기 실행기**(asis_live_scen_run.py <ID> --conds): 소스 분기 중 조건 컨트롤의 값 변경 이벤트(SelectedIndexChanged·ComboSelChange·CheckedChanged 등)로 타는 것 → 콤보 = 다음 항목으로 바꿨다 되돌림 · 체크 상자 = 뒤집었다 되돌림 · 체크 목록 = 첫 항목만 체크 → 서버 호출·메시지·다른 컨트롤 변화(항목 수·체크 수·활성·값) 기록 · 저장 없음 · 기록 폴더 run_*_acts_cond. 실측 18:35~18:37: SCP0028 cboDivision 0→1 = From Site 목록 27→29 · To Site 475→500(덤프 상한 500) / SCP0019 cboDivision = clbLine 65→500 · clbPlantSite 1→18 · clbOperation·clbPlantSite 체크 = 4·7개 컨트롤 변화 · 건너뜀 2(화면에 보이지 않는 컨트롤). 분기 대조 증거·명세 반영(명세 '조건 값 변경' = 실행기 있음으로). 전 화면 명세 18:38: 실행기 있음 1,572 · 값 지정 필요 3,317 · 정의 필요 4,074 · 명령만 있음 929 · 건너뜀 57 · 드라이버 없음 1,398 · 경로 없음 893 · AS-IS 실행 525(실행기는 2개 화면에서만 돌림 — 다른 화면은 화면별 CheckList 때 묶음으로 실행). 한계: 날짜·글자 입력 조건은 값 선택 규칙이 없어 건너뜀 · 체크 목록은 되돌리지 않음(화면을 닫음) · 변화 기록의 항목 수는 덤프 상한(500)에 걸림. VM: S1.liveScenRunCond + 메뉴 · 실측 묶음에 단계 추가.

### 2026-11-13 18:4x 덧붙임 — 룰 본문 남은 보류 3건 반영(룰·하네스 전수 점검 세션)
- SQL 단일본 · 진입 페이지 강제 400/권장 300 · 모달 키 표준 CELL_COMBO_DATA_TYPE. 240건 보류 0. 엔진 코드·DB 변경 없음. 상세 정리안 §17.
- 11-13 18:41 **확인창 H10 — 8화면 전부 엔진 오판 · 수정(대장 T294 · 코드 주석 T294)**: 지목된 FE 파일 10개 원문 확인 — 6개는 주석 안 문구만, 4개는 파일이 선언한 메시지 도우미 `alert(MSG.…)`, window.alert/confirm 0. `raw_browser_dialog()` 로 교체 · 자기 시험 53/53 · 실제 파일 10개 전부 False · 게이트 PASS 18:41:39. (H10 9번째 SCP0111 은 사유가 'alert/confirm 직접 호출 0 · 공용 메시지 API 사용' 인데 FAIL — 다른 증거의 FAIL 이 붙은 것 · 미확인.)
- 미확정으로 남긴 것(18:33 조회): A5 11 중 컬럼 이름이 'E' 로 잡힌 '[측정 경로 없음] AS-IS 시트 ? 의 TO-BE 그리드 못 찾음' — 'E' 는 컬럼 사실에 있는 이름인지(가짜 이름이면 추출 오판) 확인 필요 · 나머지는 메타 표시 여부 차이(CELL_TYPE AS-IS 표시↔TO-BE 숨김 · TO_SITE AS-IS 숨김↔TO-BE 표시 — 실제 차이 후보). C6 8(SCP0007): 'To Site·From Site 셀을 열었다 값 변경 없이 닫음(더블클릭+Esc) → Incoterms·SSP Incoterms 'DAP'→''' — 실측 문구 · 실제 결함 후보(같은 현상이 원장 행 여러 개로 반복).

- 11-13 19:02 AS-IS Live 셀 클릭·더블클릭 분기 실행기(asis_live_scen_run.py <ID> --cells). 호스트 act 에 cell=행,열 · double=1 추가(그리드에 마우스 메시지 전송, 새로 열린 MDI 화면은 이름 기록 후 닫음). 대상 열 = 분기 조건식에 이름이 나온 열, 없으면 앞쪽 보이는 열 6개, 행 = 첫 행. 조건식에 IsLock·IsEditMode 가 있으면 수정 모드에서 한 번 더 실행(닫을 때 저장 안 함). SCP0007 18:45~18:47 실측: 일반 모드 ROUTE_ID 더블클릭 = 팝업 0, 호출 0 / 수정 모드 = 팝업 SCP0007_DistributionRoutePopup(행 1), 호출 SCP0005_GET_DISTRIBUTION_ROUTE. 소스 SCP0007_BOD.cs spdMain_CellDoubleClick 의 조건(!IsLock, 열 = ROUTE_ID)과 일치. 분기 대조·명세 반영(TO-BE 팝업 검사 표기 CELL:열 과 열 이름으로 대응). 전 화면 명세 19:01: 실행기 있음 1,570, 값 지정 필요 4,339, 정의 필요 4,074, 명령만 있음 922, 건너뜀 57, 드라이버 없음 385, 경로 없음 893, AS-IS 실행 530. 셀 클릭 분기가 있는 화면 95개(CellClick 508, CellDoubleClick 882) 중 실행은 SCP0007 1개. 한계: 첫 행만 누름, 어느 행이어야 하는지는 조건식 기준으로 사람이 정해야 함. 19:01 IIS Express(8086) 종료 상태 확인(백그라운드 작업 종료 코드 4, 원인 미확인) 후 재기동, 응답 403 확인. VM: S1.liveScenRunCell, 메뉴 1, 실측 묶음 단계 추가.
- 11-13 19:06 컬럼 표시 A5 의 이름 'E' 원인 확정, 수정(대장 T295, 코드 주석 T295). 원장 COLUMN 대상 'Shipment Plan Detail.Expected_Shipping_Date' 를 `mapping_trace.py` 392행이 'E' 로 잘라 읽음. SSP0060 에서 이름 'E' 검사 단위 416개가 생겨 있었음. 수정 후 SSP0060 재판정(19:04:15~19:06:05): 단위 1,791 → 1,787, 증명됨 240 → 241, FAIL 117 → 114, 재측정 필요 12 그대로. T294(H10), T295 를 나머지 23화면에 반영하는 재판정 시작(백그라운드, 로그 c2_rejudge.log 'T294·T295 반영'). A5 나머지 8건은 메타 표시 여부 차이로 실제 차이 후보: SSP0200 NEW_LT_DAY, NEW_ETD, NEW_ETA, NEW_TRANSPORT_MODE, NEW_SHIPMENT_DATE, CHANGE_REQ_NO(AS-IS Div 40 숨김, TO-BE 표시), SSP0060 TO_SITE(AS-IS Div 82 숨김, TO-BE 표시), SSP0025 CELL_TYPE(AS-IS Div 81 표시, TO-BE 숨김).
- 11-13 19:10 분류표 1차(scratchpad/classify_fail.py → `Doc/verify/_cycle2_fail_classified.csv`, T294·T295 재판정 진행 중 값): 요소 180 = 엔진 오판(수정됨, 재측정 대기) 20, 엔진 오판(미수정) 6, 문서 표기 4, 실제 차이 후보 74, 미분류 76. 미분류 검사 종류: D1 9, H10 9(T294 반영 전 값), F3 6, J2 5, G4 5, F2 5, C2 3, F1 3, A1 3, 그 밖 19종 28. 새로 확인한 꼴: B3 5(콤보 후보 순서, DMF0005 clbEndCustomer 128번째부터, clbTeam, SCM_SITE_ID, SSP0003 cboStatus, cboChangeType), M3 5(SSP0023, SSP0060 TitleSet 팝업 목록 0건, SSP0060 ItembyDivision 팝업 열림 실패, SSP0200 OrderDetail 팝업 열림 실패), F5 4(SCP0028, SCP0037, SCP0111, SCP0122 CRUD 상태 표시), I1 3(SSP0021, SSP0060 MSG00251 미등록, SSP0200 MSG00050 미등록), X-LOC 4(대조표가 적은 구현 파일 없음: SCP0020 modals/ItemSearchModal.tsx, SSP0200 MainGrid.tsx, SubGrid.tsx). 다음: 재판정 끝난 뒤 분류표 다시 생성, 미분류 76 건별 확인.
- 11-13 19:21 분류표 2차(재판정 14/23 진행 중 값): 요소 174 = 엔진 오판(수정됨, 재측정 대기) 20, 엔진 오판(미수정) 11, 문서 표기 6, 실제 차이 후보 77, AS-IS 실측, 추가 측정 대상 14, 미분류 46. 새 분류 'AS-IS 실측, 추가 측정 대상' 14 = D1 'AS-IS 편집 가능(기본(편집 모드 전체 해제))' 기대값(11-12 해석에서 나온 값, DMF0005 END_CUSTOMER, SCM_SITE_ID, SCP0020 LINE_ID, TACT_TIME, SCP0111 ITEM_ID), F3 '후보 밖 값 붙여넣기'(SCP0007, SCP0020, SCP0127, SCP0131: AS-IS 가 후보 밖 값을 받는지 미확인), F2 '기존행 수정 + 신규행 동시 Save: 저장 요청 없음'(SCP0005, SCP0007, SCP0127, SCP0131, SSP0024: 시험 입력값 ITEM_ID=E2E_SCN_I 등으로 저장이 막힌 이유 문구가 증거에 없음). 엔진 오판(미수정)에 추가: A1 'AS-IS 0행, TO-BE N행'(SSP0015 90행, SSP0021 6행, SSP0060 3행: CR-101 상 데이터 차이는 오류 아님), F3 SSP0200 FCST_TYPE 원값 '-' 복사. 실제 차이 후보에 추가: D1 DMF0005 OWNER, ITEM_ID 신규행 편집 가능(AS-IS InsertRowLockRangeMain40:2939 잠금), SCP0020 DAILY_CAPACITY 신규행 편집 가능(AS-IS InsertButton:806 잠금), F3 DMF0005 Team 붙여넣기 시 DEPT_ID 미채움. 미분류 46: J2 5, G4 5, H10 4(T294 반영 대기), F1 3, 그 밖 20종 29.
- 11-13 19:26 T294, T295 반영 재판정 끝(19:06:29~19:26:35, 23화면 rc 0, 건너뜀 0). 24화면 전후(19:04 → 19:26): 검사 단위 16,580 → 16,563, 증명됨 4,655 → 4,662, FAIL 검사 단위 723 → 680, 재측정 필요 123 → 124. FAIL 단위가 는 화면은 SSP0200 160 → 164(대소문자 섞인 컬럼 이름이 제대로 연결되며 생긴 변화, 건별 미확인). 분류표 3차(`Doc/verify/_cycle2_fail_classified.csv`): 요소 171 = 엔진 오판(수정됨, 재측정 대기) 20, 엔진 오판(미수정) 11, 문서 표기 6, 실제 차이 후보 77, AS-IS 실측, 추가 측정 대상 14, 미분류 43. 미분류 검사 종류: J2 5, G4 5, F1 3, H10 3, C3 2, E2 2, G6 2, H4 2, F6 2, E1 2, B6 2, C1 2, 그 밖 11종 각 1. H10 은 T294 뒤에도 3건 남음(원인 미확인).
- 11-13 19:41 분류표 미분류 0(`Doc/verify/_cycle2_fail_classified.csv` 171행, 분류 규칙 사본 `Doc/verify/_cycle2_fail_classify.py`). 요소 171 = 엔진 오판(수정됨, 재측정 대기) 20, 엔진 오판(미수정) 11, 문서 표기 7, 실제 차이 후보 101, AS-IS 실측, 추가 측정 대상 32. 실제 차이 후보 근거 상위: 행 값 조건 잠금 18, ORDER BY 문장 차이(실측 없음) 9, 값 변경 없이 닫아도 하위 값 지워짐 8, 메타 표시 여부 8, 콤보 후보 순서 5, 저장 실패 시 오류 행, 셀 표시 없음 5, 팝업 5, 실측 행 순서 4, CRUD 상태 표시 4. 추가 측정 대상 32 = crud, authcrud, auth 테스트 전체 FAIL 을 화면 단위 F1, J2, K4 에 귀속한 것 8(SCP0007 'SAVE call-proc 없음', 시간 초과 540초, SCP0122 시간 초과 300초, SSP0023, SSP0060 'Insert 후 행 증가 없음', SSP0015 클릭 20초 초과: `mapping_trace.py` 498, 503행이 테스트 상태를 그대로 씀), smoke 라벨 누락 5, D1 편집 모드 해석 기대값 5, 동시 저장 5, 후보 밖 값 붙여넣기 4, 화면샷 차이 2, 그 밖 3. 점검 종료 조건 (가)는 네 분류(엔진 오판, 중복, 실제 차이 후보, 사용자 결정 대기)로 가르는 것이라, 추가 측정 대상 32건이 남은 지금은 점검 종료가 아니다. 32건은 전체 재실행(스펙 수정 묶음 반영)이나 AS-IS 실측이 있어야 가를 수 있다.
- 11-13 20:07 테스트 전체 상태 귀속 수정(대장 T296, 코드 주석 T296). crud, authcrud, auth 테스트가 시간 초과, 화면 닫힘, Insert 후 행 증가 없음으로 끝난 FAIL 을 화면 단위 F1, J2 에서 ERROR(미검증)로 둠. 6화면 재판정(20:01:30~20:06:49): 증명됨, 재측정 필요 변화 없음. FAIL 검사 단위 SCP0007 79 → 74, SSP0023 13 → 4, SSP0015 16 → 8, SCP0122 2 → 1. 나머지 18화면 재판정과 분류표 재생성 시작(백그라운드, 로그 c2_rejudge.log 'T296 반영').
- 11-13 20:15 T296 반영 재판정 끝(20:07:10~20:15:11, 18화면 rc 0). 24화면: 검사 단위 16,563, 증명됨 4,662(변화 없음), FAIL 검사 단위 680 → 657, 재측정 필요 124(변화 없음). 분류표 4차: 요소 165 = 엔진 오판(수정됨, 재측정 대기) 20, 엔진 오판(미수정) 11, 문서 표기 7, 실제 차이 후보 101, AS-IS 실측, 추가 측정 대상 26, 미분류 0.

- 11-13 20:20 AS-IS Live 전제 값 도출(asis_live_scen_values.py). 분기 조건식의 Division 마디에서 코드 모양 값(숫자 2자리, 숫자 2자리_영문 2자리), 그룹 마디에서 계정 보유 그룹 이름을 뽑아 실행 계획(scenario_values.csv, scenario_values_plan.json)을 만들고 --run 으로 실행. 전 화면 19:10 실측: Division 축 분기 1,492 = 실행 대상 712, 값 미도출 760, 화면 목록에 없는 Division 20 / 그룹 축 분기 291 = 실행함 42, 실행 대상 81, 계정에 없는 그룹 19, 값 미도출 149. 실행 대상이 있는 화면 42개, 남은 Division 실행 106회, 그룹 실행 9회, Division 목록 미확인 화면 48개. 시범 19:12~19:17: SCP0020 Division 82(조회 호출 8, 버튼 1) → 대상 2개 실행함 / SCP0121 그룹 SCM PI Admin(조회 호출 4, 버튼 2개는 컨트롤 없음 실패) → 대상 1개 실행함. Division, 그룹을 바꾼 실행은 조회 호출도 기록(누를 버튼이 없는 화면 포함). 한계: 값으로 화면을 실행했다는 뜻이고 분기가 탔는지는 실행 현황과 분기별 대조가 판단. 조회 조건, 데이터 상태, 화면 상태 축 값은 미도출. VM: S1.liveScenValues, 메뉴 1, 실측 묶음 단계 추가. 명세에 '실행기 있음(값 도출됨)' 상태 추가.
- 11-13 20:29 A1 'AS-IS 만 0행' 판정 수정(대장 T297, 코드 주석 T297). 3화면 재판정(20:21:12~20:29:12): 증명됨, 재측정 필요 변화 없음. FAIL 검사 단위 SSP0015 8 → 6, SSP0021 77 → 42, SSP0060 114 → 87. 분류표 5차: 요소 162 = 엔진 오판(수정됨, 재측정 대기) 20, 엔진 오판(미수정) 8, 문서 표기 7, 실제 차이 후보 101, AS-IS 실측, 추가 측정 대상 26. 엔진 오판(미수정) 8 의 남은 꼴: 잠금 규칙의 그룹 조건(CR-102, 스펙 쪽), 빈 값 표시 복사(스펙 쪽), 조건부 잠금 재현 불가를 FAIL 로 처리(스펙 쪽), SCP0028 필수 표시 라벨(smoke 스펙 쪽).

- 11-13 20:33 AS-IS 저장 정의 초안(asis_live_save_draft.py). foxml 호출 정의 1,437개에서 SP 이름 → SP 원문의 쓰기 대상 테이블(EXEC 1단계 포함) → 주 테이블 키(sys.indexes) ↔ 그리드 열 Tag 이름 대응 → 고칠 열 후보(키가 아닌 숫자 컬럼). 전 화면 20:25 실측: 저장 호출이 있는 화면 98, 저장 호출 285 = 키 일부 미대응 84, 고칠 열 후보 없음 55, 주 테이블 미확정 42, 키 대응 완료 38, SP 원문 없음 30, 키가 없는 테이블 21, 그리드 덤프 없음 15. 화면 기준 키 대응 완료 23. SCP0028 초안 = 손으로 쓴 정의와 테이블, 키, 고칠 열, 이력 표 일치, OPERATION_GROUP, TRANSPORT_MODE 는 그리드 열 이름이 달라 미대응으로 표시. 초안 연습 실행(asis_live_save.py <ID> --draft --dry, 저장 안 함, 20:26~20:32) 6화면: DRY_OK 3(SCP0007 PRIORITY, SCP0005 PRIORITY, SCP0122 OPMZ_ACTV_SEQ) / 중단 3(SCP0037 화면 표시 값이 DB 키 값과 다름: SCM_SITE_ID 에 설명이 보임, SCP0131 날짜 표시 형식과 빈 키 값, SCP0026 대상 행 없음). SCP0007 첫 후보 SAFETY_STOCK 은 잠긴 열이라 다음 후보로 넘어감. 초안으로는 연습 실행만 허용(실제 저장은 save_scenario.json 필요). 명세에 '정의 초안 있음', '정의 초안 연습 통과' 상태 추가. VM: S1.liveSaveDraft, S1.liveSaveDraftDry, 메뉴 2, 실측 묶음 단계 2.
- 11-13 20:41 주기 2 순서 ④ 처리(대장 T298, 코드 주석 T298). proof_backlog 가 PASS, FAIL 행 200개 이하 화면을 빼던 조건 때문에 SCP0108(193행)이 집계에서 빠졌음. 이력에 오른 화면은 남기도록 수정. 자기 시험 19/19, 게이트 PASS. 재집계: SCP0108 543 검사 단위 복귀(증명됨 31, 기준은 106), 집계 화면 27개(주기 대상 25 + 이 세션 밖 실행 SCP0104, SSP0020). SCP0108 의 증명됨 106 → 31 은 E2E 미실행 때문이고 메뉴 메타 변경 의도 회신 대기.
- 11-13 21:01 주기 2 순서 ③ 확인(유형 집계 재생성 21:00, `_backlog_types.csv`, `_backlog_types_by_screen.csv`). 기준(11-12 14:11) → 지금: Y99 미분류 881 → 1,477, Y03 위반 입력 162 → 378, Y10 대상 없음 130 → 252. 지금 값의 화면 구성: Y99 는 24화면 1,236 + 그 밖 화면(SCP0104, SCP0108, SSP0020) 241. 24화면 상위 DMF0005 212, SSP0200 124, SSP0015 122, SSP0060 97. 재측정 필요 124(D1)도 Y99 에 들어감. Y03 은 DMF0005 64, SSP0060 62, SSP0200 54, SSP0015 38, SSP0021 33. Y10 은 DMF0005 103, SSP0060 30, SCP0007 23(Distribution Route 시트 건). 확인된 것: (1) 기준 유형 집계에는 화면별 파일이 없어 화면별 전후 대조는 할 수 없다 (2) 집계 화면이 25 → 27 로 바뀌어 전체 수치는 직접 비교할 수 없다 (3) DMF0005 는 기준 실행에서 결과가 저장되지 않아 Y09 '실행하지 못함' 에 몰려 있었고(기준 668 중 DMF0005 500, 11-12 기록) 이번에 실행 결과가 생기며 다른 유형으로 옮겨감. 미확인: Y99 1,236 의 사유별 구성(유형 분류 규칙에 없는 사유 문구). 다음 주기 유형 작업의 입력으로 남긴다. 이번 점검 범위(조치 필요 요소)와는 별개.
- 11-13 21:30 P32 시나리오 판정 수정(대장 T299, 코드 주석 T299). 후보 밖 값 행에서 복사한 붙여넣기 시나리오의 FAIL 을 판정필요로, 원값이 '/', '-' 이면 NA 로 둠. 근거는 gen_expect.py 324행 주석('결과를 드러내 사용자 판정'). 재판정(21:21:26 시작, SSP0200 진행 중): 6화면 증명됨, 재측정 필요 변화 없음. 화면을 재는 쪽 수정으로 남은 것: 잠금 규칙의 그룹 조건(CR-102), INCOTERMS 조건부 잠금 재현 불가를 FAIL 로 처리(_trace.spec.ts:1835), 동시 저장 시나리오 차단 문구 기록, 시나리오 건당 상한(주기 2 순서 ⑤), M4(⑦), Insert 재시도(⑧).
- 11-13 21:32 P32 수정 재판정 끝(21:21:26~21:32:10, 7화면). 분류표 6차: 요소 157 = 엔진 오판(수정됨, 재측정 대기) 20, 엔진 오판(미수정) 7, 문서 표기 7, 실제 차이 후보 101, AS-IS 실측, 추가 측정 대상 22, 미분류 0.
- 11-13 21:41 전제 미충족 FAIL 수정(대장 T300, 코드 주석 T300). `_trace.spec.ts` 1509, 1829, 1835, 1851행의 후보 입력 실패 기록을 FAIL → ERROR 로. 게이트 PASS 21:41:07. 재실행 전까지 기존 3행(SSP0200 2, SCP0111 1)은 FAIL 로 남음. 주기 2 순서 ⑤ 확인: 문서 시나리오 반복문(_verify.spec.ts 2423행부터)은 시나리오 1건의 본문이 반복문 안에 길게 들어 있고 continue 를 쓴다. 건당 상한을 넣으려면 본문을 함수로 떼어 시간 제한과 경합시켜야 한다(Playwright 1.64.1, test.step 의 timeout 옵션 사용 가능). 구조 변경이 커서 다른 세션의 스펙 수정(11-13 15:05)과 겹치지 않게 별도 작업으로 남긴다. 현재 상한은 max(900초, 행 수 × 150초).

### 2026-11-13 21:48 덧붙임, 룰 본문 검토 등급 250건 정정(룰·하네스 전수 점검 세션)
- 정정 132, 보류 66, 지적 오류 46, 이력 줄 5, 이미 반영 1. 변경 룰 문서 97개. 엔진 코드와 DB 변경 없음. 상세 정리안 §18.
- 11-13 22:02 주기 2 순서 ⑦, ⑧ 확인(주기 1 재실행 로그 b10_*.log, 24화면 원장). ⑦ M4: T274 수정은 동작했다. 원장 M4 증거에 새 문구('시도 행 r0, r45, r89', '보이는 그리드·탭 순회에서도 그 칸 없음')가 찍혀 있다. '[M4]' 로그가 0줄인 것은 탭 순회로 그리드를 찾은 경우가 없었기 때문. 결과: TRACE M4 요소 PASS 50, ERROR 203, NA 25. ERROR 사유: 셀 위치 확인 불가 78, 더블클릭 → 팝업 열림 감지 실패 37 이상. 화면별 ERROR SSP0060 32, SSP0015 24, DMF0005 23, SSP0021 18, SSP0023 17, SSP0024 17, SCP0005 16, SSP0200 15. 팝업이 열리지 않는 원인은 미확인. ⑧ Insert 재시도: '행 선택 후 재시도' 가 신규 행을 만든 경우 0. '첫 행 선택 후 Insert → 신규 행 없음' SSP0060 27, SSP0023 18, SSP0021 17, SSP0015 15, SSP0200 14, SCP0028 12. '행이 있는 그리드 없음' 6. 원인 확인용 진단(Insert 직후 대화상자, 요청, 행 수 기록)을 SCP0028, SSP0023 로 시도했으나 로컬 FE(127.0.0.1:5173), BE(8080)가 내려가 있어 미측정(22:01 curl 000, LISTEN 포트 없음). 이 세션이 내린 것이 아니다. 임시 진단 스펙은 삭제함.
- 로컬 FE, BE 가 내려가 있는 동안은 화면을 여는 측정과 전체 재실행을 할 수 없다. 내린 주체와 사유 미확인이라 임의로 기동하지 않았다. 사용자 확인 대상.

### 2026-11-13 22:15 덧붙임, AS-IS Live P6 잔여분(AS-IS Live 세션)
- 저장 실제 실행 3화면(21:48~21:53): SCP0122 OK, SCP0005 OK(저장 1행, 복원 뒤 전 기록과 같음, 이력 1행 삭제). SCP0007 은 AS-IS 가 "저장에 실패하였습니다." 를 냄. 원인 = PR_SCP_MST_BOD_HIST 의 SCP_MST_BOD_H PK 중복(scm_sys_log_batch 21:52:50). 시퀀스 SEQ1_SCP_MST_BOD_H 현재 값 25729, 표의 최대 HISTORY_SEQ 25825, 25729 보다 큰 행 94. DB 는 저장 전과 같음. 시퀀스는 손대지 않음(구조 변경, 사용자 확인 대상).
- asis_live_save.py: related(저장 SP 가 함께 고치는 표를 대상 범위 전부 기록 후 행 단위 복원, SCP0007 의 SCP_MST_BOD_ITEM), 값이 같은 행은 복원에서 건드리지 않음, ASIS_SAVE_FAILED 판정(SP 오류 로그 인용), 표시 글자로 DB 행이 없으면 셀 원래 값으로 다시 찾기(raw_key_used), 정의의 열이 주 그리드 활성 시트에 없으면 사유를 적고 중단.
- AsisLiveHost.cs: dump raw=1 이면 셀 원래 값(values)도 낸다. 빌드 통과. SCP0037(SCM_SITE_ID 설명 → 코드, LT_OPERATION), SCP0131(OPMZ_PLAN_GR_ID 빈 표시 → PG0031, 날짜 yyyy-MM-dd → yyyymmdd) 연습 실행 DRY_OK.
- 초안 연습 실행 17화면(21:56~22:09): DRY_OK 6(DMF0006, SCP0001, SCP0030, SCP0127, SCP0128, SCP0132), 조회 결과 행 없음 7(SCP0020, SCP0022, SCP0125, SSP0003, SSP0013, SSP0201, SSP0202), 셀이 바뀌지 않음 1(SCP0097), 다른 시트의 열 2(SCP0126, SSP0023), DB 대상 행 0 1(SCP0133).
- asis_live_save_draft.py: 이름이 다른 키는 SP 원문(컬럼 = @인자, @인자 AS 컬럼)과 화면 소스(인자 ← GetColumnIndex(열)) 두 고리가 다 있을 때만 대응(match_basis). 재집계 22:13: 키 대응 완료 38 → 42(화면 23 → 27), 키 일부 미대응 84 → 80. 미대응 키 254개 사유: SP 에 그 꼴 없음 178, 인자가 그리드 열에서 오지 않음 61, 소스의 열이 그리드 덤프에 없음 15. 앞서 한 연습 실행 결과는 정의가 같을 때 유지.
- 신규 asis_live_scen_input.py: 셀 값 입력 분기(수정 모드 첫 행, 조건식에 나온 열 먼저, 저장 없이 닫음)와 시트 전환 분기(ActiveSheetIndex). 시범 SCP0028 입력 4열, SCP0113 시트 3개. SheetTabClick 은 마우스 클릭 이벤트라 대상에서 뺌.
- 신규 asis_live_scen_unreached.py: 진입 경로 없는 분기 893 = 호출 없음 292, 주석 안에서만 호출 418, 같은 파일에서 호출 180, 이벤트·대리자 연결 2, 다른 파일에서 호출 1(22:02, 이름 검색 기준).
- asis_live_scen_spec.py: 셀 값 입력, 시트 전환 실행기 상태 반영, 부르는 메서드의 진입점 물려받기, 실행 대상 아님 상태. 22:13 전 분기 12,240 = 실행기 있음 1,624, 값 도출됨 173, 전제 값 지정 필요 4,951, 정의 초안 연습 통과 133, 정의 초안 있음 556, 정의 필요 3,377, 명령만 있음 123, 건너뜀 58, 드라이버 없음 418, 경로 없음 117, 실행 대상 아님 710. AS-IS 실행 530(전 화면 실행은 하지 않아 변동 없음).
- 실측 묶음(asis_live_screen.py)에 셀 값 입력·시트 전환, 진입 경로 없는 분기 분류 단계 추가. VM S1.liveScenInput, S1.liveScenUnreached 등록. engine_selfcheck PASS(22:14). 등록부 갱신.
- 11-13 22:23 잠금 규칙의 그룹 합집합 평가 수정(대장 T301, 코드 주석 T301). `tools/E2E/lib/condeval.ts evalRules()` 가 그룹 둘 이상인 계정을 그룹 하나씩 평가해 합집합으로 판정. 자기 시험 21/21, 게이트 PASS 22:23:25. 화면 쪽 수정 묶음 현황: 반영 = T288(버튼 권한 기대값), T289(편집 기대값), T300(전제 미충족), T301(그룹 합집합). 남음 = 동시 저장 시나리오 차단 문구 기록, 시나리오 건당 상한(⑤), 팝업 열림(⑦), Insert(⑧). 뒤 둘은 화면을 열어 원인을 재야 하는데 로컬 FE, BE 가 22:22 에도 응답 없음.

### 2026-11-13 22:30 덧붙임, AS-IS 개발 DB 시퀀스 재설정(AS-IS Live 세션, 사용자 승인)
- LGCE_SCMDEV.dbo.SEQ1_SCP_MST_BOD_H 25729 → 25826(SCP_MST_BOD_H 최대 HISTORY_SEQ 25825 + 1, 22:28). 적용·되돌리기 SQL = tools/AsisLocal/sql/20261113_SEQ1_SCP_MST_BOD_H_restart.sql.
- SCP0007 실제 저장 재실행 22:28~22:30 OK: "1개의 데이터가 저장되었습니다.", SCP_MST_BOD 1행과 SCP_MST_BOD_ITEM 8행 복원 뒤 전 기록과 같음, 이력 1행 삭제. 다른 시퀀스·구조 변경은 건별 확인.

### 2026-11-13 22:44 덧붙임, 주기 2 화면 쪽 수정(검증엔진 세션)
- T302 반영(22:43:04 게이트 PASS): `_verify.spec.ts` savehas 단계가 저장 요청 0건일 때 화면 문구 끝 2건을 증거에 기록. 대상 = F2 '저장 요청 없음' SCP0005, SCP0007, SCP0127, SCP0131, SSP0024 와 F6 SCP0020. 원장 반영은 전체 재실행 때.
- 화면 쪽 수정 묶음 현황: 반영 = T288, T289, T300, T301, T302. 남음 = 시나리오 건당 상한(⑤), 팝업 열림(⑦), Insert(⑧). ⑦⑧은 화면을 열어 원인을 재야 함. 로컬 FE(5173), BE(8080) 22:40:25 응답 없음(curl 000).
- 22:45:44 분류표 재생성(`Doc/verify/_cycle2_fail_classified.csv` 157행, 24화면). 엔진 오판(수정됨, 재측정 대기) 26, 엔진 오판(미수정) 0, 문서 표기 7, 실제 차이 후보 101, AS-IS 실측·추가 측정 대상 23, 미분류 0. 옮긴 행 = DMF0005 ATTRIBUTE1, ATTRIBUTE2 5건(T301), SCP0111 INCOTERMS 1건(T300), SCP0028 G4 cboDivision 1건(추가 측정 대상. smoke 후보 Div., Division 로 못 찾음. 원인 미확인, 화면을 열어야 확인됨).
- 종료 조건 (가) 분류표 = 미분류 0, 미수정 오판 0. (나) 중 ⑤ 건당 상한, ⑦ 팝업 열림, ⑧ Insert 는 미처리. ⑦⑧과 SCP0028 G4 는 로컬 FE, BE 가 떠야 잴 수 있음.
- 22:46 점검 종료((가) 충족). 사용자에게 알림. 이월 = ⑤ 시나리오 건당 상한(구조 변경 필요, 미구현), ⑦ 팝업 열림 원인, ⑧ Insert 재시도 원인, SCP0028 G4 라벨. 남은 단계 = (라) 전체 재실행 1회와 전후 비교. 로컬 FE, BE 가 22:45:52 에도 응답 없어 사용자 회신 뒤 시작.
- 23:00:24 작업 호출: run_verify, playwright 프로세스 0. 로컬 FE(5173), BE(8080) 응답 없음(curl 000). 화면 없이 할 수 있는 항목은 22:46 까지 처리됨. 남은 ⑤⑦⑧, SCP0028 G4, (라) 전체 재실행은 서버 기동과 사용자 회신 대기. 변경 없음.

### 2026-11-13 23:24 덧붙임, 주기 2 순서 ⑧ Insert 재시도(검증엔진 세션, 소스와 로그 대조. 화면 실측 없음)
- 로그(scratchpad rerun/b10_<ID>.log, 주기 1): 재시도 문구는 6화면 전부 "'그리드 N' 첫 행 선택 후 Insert → 신규 행 없음" 이고 알림 문구 없음. SSP0060 27, SSP0023 18, SSP0021 17, SSP0015 15, SSP0200 14, SCP0028 12.
- SSP0021 원인 확인: 검사기 `insertpre.ts asisInsertSheet` 가 AS-IS InsertRow(SSP0021_ShipmentPlan.cs:2191)의 첫 분기 'Hold stock' 만 전제 시트로 고름. AS-IS 는 분기 2개(2191 Hold stock, 2210 Plan Detail). TO-BE `ShipmentPlanAutoEss.tsx:672` 는 Plan Detail 에서만 Insert. Hold stock 은 표시 전용으로 닫힌 항목(`__asis-mapping__.md` 510행, 저장 SP 본문 없음 = sp_pair.csv 105행). 검사기가 Hold stock 탭을 열고 Insert 를 눌러 신규 행이 안 생김. 검사기 쪽 결함(전제 시트를 분기 하나로 고정). 미수정.
- SSP0060: AS-IS 분기 2개(cs 2539 Hold stock, 2558 Plan Detail)인데 검사기는 Hold stock 만 엶. TO-BE `ShipmentPlan.tsx:853-910` 의 Hold stock 분기 조건 = detailEditable(EDIT 버튼 권한, isSspUser, realFlag 최신 Plan) + 메인 그리드 선택 행. 어느 조건에서 멈췄는지는 미측정.
- SSP0015: TO-BE `ShipmentPlanMobilityIt.tsx:1339-1376` 조건 = canEditPlan + 활성 시트(Confirm Detail 또는 Hold stock) + 메인 선택 행. 멈춘 조건 미측정.
- SSP0200: TO-BE `ShipmentChangeRequestPlan.tsx:337-339` 조건 = canEditMain + 기준 행. 멈춘 조건 미측정.
- SSP0023: FE Insert 처리 위치 미확인(shipment-plan-electrode 폴더에 `const handleInsert` 없음).
- SCP0028: AS-IS InsertRow 빈 구현(newrow.ts 33행 주석, 11-01 확인). 신규 행 없음이 AS-IS 와 같음. 재시도 기록만 남고 판정은 NA 경로.
- 서버가 뜨면 잴 것: 화면별 편집 가능 플래그(EDIT 버튼 노출, 최신 Plan 여부)와 활성 시트. 검사기 수정 대상: asisInsertSheet 가 분기 전부를 돌려주고 TO-BE 가 편집 시트로 둔 분기에서 Insert 를 누르도록.
- 23:20:24 로컬 FE(5173), BE(8080) 응답 없음(curl 000). run_verify, playwright 프로세스 0(23:00:24 확인).

### 2026-11-13 23:38 덧붙임, 저장 실제 실행 8화면과 이력 시퀀스 조회(AS-IS Live 세션, 사용자 승인 "8개 화면 진행")
- 저장 SP 원문 확인 뒤 save_scenario.json 8건 작성(DMF0006, SCP0001, SCP0030, SCP0037, SCP0127, SCP0128, SCP0131, SCP0132). 23:22~23:34 실행: OK 7(SCP0127, SCP0128, SCP0131, SCP0132, SCP0037, DMF0006, SCP0001), ASIS_SAVE_FAILED 1(SCP0030).
- SCP0132: SP 444줄이 같은 DIVISION_ID, OPMZ_PLAN_GR_ID, MDL_GR_NM 묶음의 다른 행도 고침. 묶음 2행 기록, 저장 뒤 1행 복원, 전 기록과 같음. SCP0001: SCM_MST_VENDOR, SCM_PLANT_M_SN 대상 0행(변화 없음), 메시지 "개의 데이터가 저장되었습니다."(건수 빠짐, AS-IS 원문 그대로).
- SCP0030 실패 원인: PR_SCP_MST_BOD_ITEM_HIST 의 SCP_MST_BOD_ITEM_H PK 중복(27874). 시퀀스 SEQ1_SCP_MST_BOD_ITEM_H 27874, 표 최대 28017. DB 는 저장 전과 같음. 재설정 안 함(사용자 확인 대상).
- 이력 시퀀스 전수 조회(23:37, 조회만, Doc/asislive/_seq_behind.csv): SEQ1_*_H 112개 중 같은 이름 표의 최대 HISTORY_SEQ 보다 현재 값이 작은 것 33개. 시퀀스와 표의 대응은 이름 기준(SCP0007, SCP0030 2건은 SP 원문으로 확인).
- asis_live_save.py: 함께 고쳐지는 표의 조건을 주 테이블과 같은 값 형태(원래 값)로 생성, 저장 확인의 숫자 비교(31.0000000000 = 31). DMF0006 1차 실행은 이 비교 때문에 SAVE_NOT_CONFIRMED 로 찍혔고 저장·복원은 정상이었음. 정정 뒤 재실행 OK.
- 저장 인자 대조(asis_live_save_cmp.py): TO-BE 저장 호출 기록이 있는 화면 SCP0005 같음 34, SCP0037 같음 7, SCP0122 같음 4, SCP0127 같음 18, SCP0131 같음 17(다름은 고른 행·값 차이). SCP0007 은 TO-BE 기록의 인자 이름이 비어 같음 1. DMF0006, SCP0001, SCP0128, SCP0132 는 TO-BE 저장 호출 기록 없음.
- 명세 23:35: 저장 정의가 있는 화면 12. 실행기 있음(전제 값 지정 필요) 5,082, 정의 초안 연습 통과 0(정의로 옮겨짐), 나머지 22:13 과 같음. engine_selfcheck PASS.
- 23:42 T303 반영(게이트 PASS 23:42:20): `insertpre.ts` 에 asisInsertSheets 추가, retryInsertWithRow 가 AS-IS Insert 분기 시트 탭을 하나씩 열어 재시도. 자기 시험 `tools/E2E/lib/insertpre.selftest.js` 8/8. SSP0021 대응. SSP0060, SSP0015 도 분기 2개면 같은 경로를 탐. 결과는 전체 재실행 때 확인.
- 23:40:27 로컬 FE(5173) 200, BE(8080) 000. BE 가 없어 화면 측정은 아직 못 함. 화면 쪽 수정 묶음 = T288, T289, T300, T301, T302, T303.
- 11-14 00:01 T304 반영(게이트 PASS 00:01:35): `insertpre.ts` 재시도에 2차 시도 추가. SSP0023 TO-BE Insert 조건 확인 = `ShipmentPlanElectrode.tsx:592-601` detailEditable + Plan Detail 탭 + 그 그리드의 선택 행. 멈춘 조건은 미측정.
- 11-14 00:00:23 로컬 FE(5173) 200, BE(8080) 000, run_verify·playwright 프로세스 0. 화면 쪽 수정 묶음 = T288, T289, T300~T304. ⑧은 검사기 쪽 수정 2건 반영, 화면별 멈춘 조건 측정은 BE 기동 뒤.

### 2026-11-14 00:23 덧붙임, 주기 2 순서 ⑦ M4(검증엔진 세션, 원장과 코드 대조. 화면 실측 없음)
- 집계(`mapping_trace_instances.csv` 전 화면, 집계 행 제외, 00:2x): M4 = NOT_RUN 475, NA 137, ERROR 151, REVIEW 76, PASS 50, BLOCKED 2.
- ERROR 151 구성: 'SHIPMENT_DATE 셀 위치 확인 불가' 58(SSP0060 26, SSP0023 17, SSP0021 15) / 'FIGURE 더블클릭 → 팝업 열림 감지 실패' 18(SSP0015) / 'ITEM_ID … 감지 실패' 19(SSP0200 11, SCP0033 7 외) / 'USER_ID 셀 위치 확인 불가(탭 순회에서도 없음)' 15 이상(DMF0005, 상위 12유형까지 센 값) / 'PLANT_SITE_ID … 감지 실패' 6(SSP0024) / 'ROUTE_ID … 감지 실패' 9(SCP0005). 나머지는 미집계.
- T305 반영(게이트 PASS 00:22:16): `_trace.spec.ts` M4 가 트리거 그리드 0행이면 다른 그리드 첫 행을 눌러 하위 시트를 채운 뒤 다시 셈. 대상 58건. 0행이었는지는 미측정이라 재실행 증거 문구로 가름.
- '팝업 열림 감지 실패' 유형(SSP0015, SSP0200, SCP0033, SSP0024, SCP0005)은 원인 미확인. 화면을 열어야 잴 수 있음.
- 00:20:26 로컬 FE(5173) 200, BE(8080) 000. 화면 쪽 수정 묶음 = T288, T289, T300~T305.

### 2026-11-14 00:43 덧붙임, 주기 2 순서 ⑤ 시나리오 건당 상한(검증엔진 세션)
- 로그 확인(scratchpad rerun/b10_DMF0005.log): '문서 시나리오' 3.5h 의 마지막 시작 기록은 19:53:39 P32 시나리오(ATTRIBUTE9 후보 밖 값 행에서 복사). 스택 = test.ts:46 waitForTimeout ← take ← 시나리오 단계. 대기 1건이 끝나지 않은 이유는 미확인.
- 시나리오 소요 실측(b10_*.log 시작 기록 간격 536건): 최대 489초(KO 언어 시나리오), 중앙값 10초, 600초 초과 0건.
- T306 반영(게이트 PASS 00:42:49): `_verify.spec.ts` 문서 시나리오에 건당 감시 타이머 1,200초(SCN_CAP_MS 로 조정). 초과 시 해당 시나리오와 미기록 시나리오 행을 ERROR 로 남기고 페이지를 닫아 테스트 종료. 발동 동작은 화면 실행 전이라 미확인.
- 00:40:27 로컬 FE(5173) 200, BE(8080) 000. 화면 쪽 수정 묶음 = T288, T289, T300~T306. 주기 2 순서 ①~⑧ 중 남은 것 = ⑦ '팝업 열림 감지 실패' 유형 원인, ⑧ 화면별 멈춘 조건 측정, SCP0028 G4 라벨(셋 다 BE 필요).

### 2026-11-14 01:03 덧붙임, 주기 2 순서 ⑦ M4 트리거 컬럼(검증엔진 세션)
- 원인 확인(actions.csv 전 화면 대조, scratchpad m4_trig_dry.py): M4 트리거를 핸들러의 첫 'e.Column ==' 에서 가져와 팝업 문장의 guard 컬럼과 다른 핸들러 13개. SSP0021·23·15 SpdDetail_CellDoubleClick 의 팝업은 ERP_SO_NO 에서 열리는데 SHIPMENT_DATE 로 시도. SSP0015 FIGURE 는 하위 시트 드릴이고 팝업이 아님(`ShipmentPlanMobilityIt.tsx:762`).
- T307 반영: `mapping_trace.py m4_popups()`. 자기 시험 76/76, 게이트 PASS 01:02. 00:23 에 적은 T305(트리거 그리드 0행 대응)는 그대로 둠. 58건의 원인은 0행이 아니고 트리거 컬럼 오선정으로 확인됨.
- 판정 재적용 01:02:37 시작(백그라운드, 로그 scratchpad rerun/c7_rejudge.log): DMF0005, SSP0015, SSP0021, SSP0023, SSP0060, SSP0200, SSP0201, SCP0126. 전후 수치는 끝난 뒤 덧붙임.
- 01:14:21 T307 판정 재적용 끝(로그 scratchpad rerun/c7_rejudge.log). 6화면 rc 0: DMF0005, SSP0015, SSP0021, SSP0023, SSP0060, SSP0200. 증명됨 전후 같음(200, 110, 257, 237, 241, 168), 조치 필요 전후 같음(85, 6, 42, 4, 87, 163), M4 ERROR 전후 같음(22, 19, 16, 19, 31, 13). DMF0005 만 미검증 779 → 780, 해당없음 316 → 315(바뀐 1행 미확인). M4 미검증 행의 증거 문구는 종전 트리거로 잰 값이라 전체 재실행 때 바뀜.
- SSP0201, SCP0126 은 원장(verify_ledger.csv)이 없는 화면이라 judge rc 2. mapping_trace 산출물 5개씩이 현재 엔진으로 다시 만들어져 수치가 바뀌었음(대상 선정 실수). 재적용 전 수치가 커밋본과 같음을 확인한 뒤 커밋본 내용(`git cat-file --filters HEAD:<파일>`)으로 그 10개 파일만 되돌림(01:15:04, git status 에서 변경 표시 사라짐). `.git/index.lock`(21:25:39 생성, 0바이트)이 남아 있어 git checkout 은 실패. 잠금 파일은 건드리지 않음. 두 화면은 24화면 집계 밖.

### 2026-11-14 01:19 덧붙임, 룰 본문 검토 등급 보류 건 권장안 반영(룰·하네스 전수 점검 세션)
- 문서 정정 33건, 변경 없이 확정 20건, 남은 보류 13. 엔진 코드와 DB 변경 없음. 상세 정리안 §19, §20.

### 2026-11-14 01:23 덧붙임, SCP0028 G4 라벨과 서버 상태(검증엔진 세션)
- 01:20:26 로컬 FE(5173) 200, BE(8080) 401(응답함). 이 세션이 기동한 것 아님. 다른 세션 `run_verify.py DMF0042 --static` 실행 중(pid 28308, 화면 실행 없는 단계).
- SCP0028 G4 원인 확인(진단 스펙 1건 실행 01:21, 실행 후 삭제): 화면 라벨 'Div', smoke 후보 'Div.', 'Division'. LBL00001 문구가 KO 'Div', EN 'Div.' 로 다르고 생성기가 EN 만 후보로 씀. T308 반영(`tools/E2E/gen-e2e.js`), SCP0028 스펙 4종과 plan.json 재생성. 분류표의 이 1건은 엔진 오판(수정됨, 재측정 대기)에 해당.
- DMF0005 판정 재적용에서 M4 20행이 '[재측정 필요] 검사 조건이 바뀐 뒤 아직 재실행되지 않음' 으로 표시됨(T307 조건 변경 반영 확인).
- 남은 것: ⑦ 'ITEM_ID, PLANT_SITE_ID, ROUTE_ID 더블클릭 → 팝업 열림 감지 실패' 원인, ⑧ SSP0060·0015·0200·0023 Insert 멈춘 조건. 서버가 떴으므로 진단 스펙으로 잴 수 있음. 전체 재실행은 사용자에게 먼저 알린 뒤.

### 2026-11-14 01:25 덧붙임, AS-IS 개발 DB 이력 시퀀스 32개 재설정(AS-IS Live 세션, 사용자 승인 "33개 재설정")
- 적용 01:20:47 LGCE_SCMDEV. 32개 재설정, 적용 뒤 current_value 32개 일치. 적용·되돌리기 SQL `tools/AsisLocal/sql/20261114_SEQ1_HIST_32_restart.sql`. 목록과 재설정 값 `Doc/asislive/_seq_behind.csv`.
- 대응 확인(01:12~01:20, sys.sql_modules 원문): 32개는 그 시퀀스로 자기 표에 INSERT 하는 SP 가 있음. SEQ1_SCP_ANL_PRODUCTION_PLAN_FIX_H 는 SCP_ANL_SHIPMENT_PLAN_FIX_H 에도 값을 넣어(PR_SCP_ANL_SHIPMENT_PLAN_FG_FIX_HIST_DATASET 48줄, PR_SCP_XLS_ADD_SMALL 370줄) 두 표 최대값 877307721 의 다음 값으로 맞춤.
- 제외 1: SEQ1_SCP_ANL_SHIPMENT_PLAN_FIX_H. 이 시퀀스를 쓰는 SP·기본값 제약 0개, current_value 1 그대로.
- SCP0030 실제 저장 재실행 01:20:57~01:24:30 OK. SAFETY_STOCK 0 → 1, 메시지 '1개의 데이터가 저장되었습니다.', 복원 1문, 이력 1행 삭제, 복원 뒤 전 기록과 같음. 산출 `Doc/asislive/SCP0030/run_20261114_012057_save_update`. 실제 저장 통과 화면 12개.
- 한계: SP 가 변수에 받은 시퀀스 값을 넣는 표 1곳(PR_DM_ANL_SALES_PLAN_HIST 73줄 @n_history_seq)은 INSERT 대상 미확인. DM_PLN_SALES_PLAN_H 65909, DM_PLN_SALES_ETC_PLAN_H 6438 둘 다 재설정 값 65910 보다 작음.

### 2026-11-14 01:31 덧붙임, 룰 본문 남은 보류 13건 반영(룰·하네스 전수 점검 세션)
- 룰 본문 지적 490건 처리 종료. 정정 415, 변경 없이 확정 22, 이미 반영 1, 지적 오류 47, 이력 줄 5, 보류 0. 엔진 코드와 DB 변경 없음. 상세 정리안 §21, §22.

### 2026-11-14 01:44 덧붙임, 주기 2 순서 ⑦ M4 신규 행 조건(검증엔진 세션)
- 01:40:27 다른 세션 실행 중: `run_verify.py SSP0020`(pid 34788), `run_verify.py SCP0104`(pid 20596), 둘 다 화면 테스트 단계. 여유 메모리 2,252MB(기준 3,072MB 미만)라 진단 스펙은 실행하지 않음. 스펙과 E2E lib 수정도 미룸.
- 원문 확인(actions.csv): '팝업 열림 감지 실패' 중 ITEM_ID(SSP0200, SCP0033), PLANT_SITE_ID(SSP0024)는 AS-IS 팝업이 신규 행에서만 열리거나(== "I", FlagI) 다른 컬럼(MATERIAL_ID)에서 열리는 경우. 검사기가 기존 행, 다른 컬럼에서 시도함.
- T309 반영(게이트 PASS 01:43:11): `mapping_trace.py m4_popups()` 가 else 조각을 빼고 트리거를 고르고 newRow 를 실음. 자기 시험 81/81.
- 남은 것: ① `_trace.spec.ts` M4 가 newRow 항목을 신규 행(Insert 뒤)에서 시도하도록 수정 ② SCP0005 ROUTE_ID 팝업 열림 실패 원인(조건 없는 더블클릭, 화면 측정 필요) ③ ⑧ Insert 멈춘 조건 측정 ④ T307, T309 대상 화면 판정 재적용. 넷 다 다른 세션 실행이 끝난 뒤.

### 2026-11-14 01:53 덧붙임, P6 잔여 항목 진행(AS-IS Live 세션)
- 새 실행기 `tools/AsisLive/asis_live_scen_event.py`: 스크롤(TopChange, LeftChange), 키 입력(KeyDown, KeyUp, KeyPress), 붙여넣기(ClipboardPasted, ClipboardPasting) 분기. 대상 분기 스크롤 91(79화면), 키 입력 303(32화면), 붙여넣기 431(36화면). 저장 계열 호출이 있는 분기 0.
- 호스트 명령 2개 추가(`AsisLiveHost.cs`, 백업 `.bak_20261114_raise`): `act scroll=<행> target=<그리드>`(보이는 첫 행 이동), `act raise=<이벤트> target=<컨트롤> row col key char`(컨트롤의 On<이벤트> 를 불러 화면 처리기 실행). 빌드 OK 01:52.
- 시험 SCP0132 01:46~01:48: 조작 8개 실행, 실패 0. 산출 `Doc/asislive/SCP0132/run_20261114_014809_acts_event`. 다른 화면은 화면별 묶음(`asis_live_screen.py`)에서 실행됨.
- 한계: 키 입력과 붙여넣기는 처리기를 직접 부른다. 컨트롤 기본 동작(글자 입력, 셀 지우기, 실제 붙여넣기)은 일어나지 않고 사용자 클립보드는 쓰지 않는다. 이벤트 인자는 행, 열, 키 말고는 0 또는 빈 값. 어느 분기를 탔는지는 관찰(메시지, 호출, 그리드 변화)로만 본다.
- 명세 재집계 01:52(12,240): 실행기 있음 1,624 → 1,719, 전제 값 지정 필요 5,082 → 5,304, 정의 초안 있음 556 → 638, 정의 필요 3,377 → 3,295, 드라이버 없음 418 → 101. AS-IS 실행 530 은 분기별 대조를 다시 돌리지 않아 그대로.
- 저장 도구 `asis_live_save.py`(백업 `.bak_20261114_div`, `.bak_20261114_date`): 기본 조건 조회가 0행이면 ① 저장 대상 테이블에 행이 있는 Division 을 DB 에서 읽어 화면 목록 값으로 다시 조회 ② 조회 SP 원문의 '컬럼 >= @기간 시작 인자' 에서 컬럼을 찾아 그 최댓값 앞 30일로 기간을 옮겨 다시 조회(오늘 + 2년 넘는 값 제외, 날짜 속성 DateTime → Value → EditValue 순).
- 조회 0행 7화면 연습 실행 01:33~01:51(저장 없음): 연습 통과 0. SSP0202 는 기간 20260927~20261027, Division 40 으로 23행이 나왔고 초안 열(CONFIRM_ID, NEW_YN, ROUTE_ID)이 주 시트에 없어 멈춤. SCP0020, SCP0022, SCP0125, SSP0003, SSP0013, SSP0201 은 Division 과 기간을 바꿔도 0행. SSP0013 조회 인자 p_myModelChk='Y', SSP0201 은 SP 원문에 '컬럼 >= @p_from_yyyymmdd' 꼴 없음. 나머지 원인 미확인.
- 초안 생성기 `asis_live_save_draft.py`(백업 `.bak_20261114_var`): 인자에 지역 변수를 넣는 화면은 '변수 = …GetColumnIndex(열)' 또는 '변수 = dr[열]' 줄까지 따라간다. 그리드에 있는 열이 1개일 때만 대응. 61건 분류: 그리드 셀 11, 여러 행을 이어 붙인 글 9, 대입 줄 못 찾음 9, 그 밖 32. 재생성 25화면 결과 변수 경유 대응 7건, 키 대응 완료 42 → 43, 그리드 열에서 오지 않음 61 → 40.
- 시퀀스 후속 확인 01:34: PR_DM_ANL_SALES_PLAN_HIST 76줄 MERGE INTO DM_PLN_SALES_PLAN_H 로 자기 표 확인. 시퀀스를 쓰는 SP 의 MERGE 대상 가운데 자기 표가 아닌 이력 표(_H) 0개.
- 연결: `asis_live_scen_spec.py`(이벤트 종류 evt), `asis_live_screen.py`(묶음 단계 1개 추가), VM `steps.json` 작업 `S1.liveScenEvent`, CHANGELOG 2.0.9 덧붙임. engine_selfcheck PASS 01:52.
- 남은 것: 드라이버 없음 101(시트 탭 마우스 클릭 33, 셀 안 단추·항목 클릭 27, 그 밖), 전제 값 지정 필요 5,304 의 조건·데이터 값 도출, 다른 시트·그리드 저장, 신규·삭제·검증 저장 시나리오.

### 2026-11-14 02:03 덧붙임, SCP0005 ROUTE_ID 더블클릭 팝업(검증엔진 세션, 화면 실측 1건)
- 화면 실측(진단 스펙 02:01, 실행 후 삭제, 저장 없음): SCP0005 조회 8,036행, 0행 ROUTE_ID('9917') 더블클릭 뒤 0.5초, 2초, 5초 시점에 대화상자 0, 서버 호출 증가 0, 콘솔 오류 0.
- AS-IS 원문: `SCP0005_DistributionRoute.cs` spdMain_CellDoubleClick 1091~1103행이 ROUTE_ID 더블클릭에서 `SCP0005_DistributionRoutePopup` 을 띄움. 팝업은 `SCP.SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID` 를 p_route_id 로 조회(팝업 cs 171~173행), csproj 213행에 포함. 행 조건 없음(기존 행에서도 열림).
- TO-BE: `DistributionRoute.tsx` 의 더블클릭 처리는 From, To 셀뿐(309~310행). `__asis-mapping__.md` 29행은 'R8 ROUTE_ID 링크/이력팝업 기능 없음 … AS-IS 에 해당 기능 부재 확인(2026-09-27)' 로 적혀 있어 AS-IS 원문과 다름.
- 판단: 검사기 오판 아님. 실제 차이 후보(이력 팝업 미구현). 작업 모드 DB_ONLY 라 FE 는 수정하지 않고 사용자에게 알림. 주기 1 원장의 M4 9행은 '팝업 열림 감지 실패(검사기 미검증)' ERROR 로 남아 있음.
- 검사기 결함 후보 1건 관측: `probe.cellCenter(page, 4018, 'ROUTE_ID')` 가 y=-78609(화면 밖 좌표)를 돌려줌. 가운데 행 시도는 화면 밖을 누른 것. 다른 세션 실행이 끝난 뒤 lib 수정 대상.
- 02:00:23 다른 세션 `run_verify.py SSP0020`, `SCP0104` 화면 테스트 중. T309 판정 재적용 02:00 시작(백그라운드, 로그 scratchpad rerun/c8_rejudge.log).
- 02:09:15 T309 판정 재적용 끝(로그 scratchpad rerun/c8_rejudge.log). 8화면 rc 0: SSP0024, SCP0033, SSP0200, SSP0060, SSP0021, SSP0023, SSP0015, DMF0005. 증명됨 전후 같음(355, 256, 168, 241, 257, 237, 110, 200), 조치 필요 전후 같음(6, 0, 163, 87, 42, 4, 6, 85), M4 ERROR 전후 같음(15, 7, 13, 31, 16, 19, 19, 22). M4 행은 조건 변경으로 '재측정 필요' 표시. 새 트리거 측정은 전체 재실행 때.

### 2026-11-14 02:21 덧붙임, P6 조회 조건 값 도출(AS-IS Live 세션)
- `asis_live_scen_values.py`(백업 `.bak_20261114_cond`): 조회 조건 축(COND) 분기의 값 도출 추가. 조건식에서 조건 컨트롤(cbo, cmb, chk, clb, rdo 로 시작) 값 비교를 찾고, 체크 상자는 켬·끔, 콤보는 화면 덤프 항목마다 1회, 체크 목록은 항목마다 그 항목만 체크로 실행 계획을 만든다. 항목 8개 초과분은 '상한 밖'(--all-values 로 전부). Division 컨트롤은 Division 축이 다룬다.
- `asis_live_scen_run.py`(백업 `.bak_20261114_preset`): `--preset "이름=iN;이름=cT;이름=kN"`. 조건 값을 정해 놓고 화면을 새로 열어 조회와 버튼 분기를 다시 실행하고, 적용 뒤 컨트롤의 값과 글자를 acts.json 의 preset 에 적는다. "(조회)" 항목을 버튼으로 다시 누르던 오류 수정.
- 전 화면 도출 02:20: COND 축 행 1,311 = 실행 대상 662, 실행함 1, 값 미도출 581, 화면에 없는 컨트롤 67. 미도출·없음 내역 조건식에 조건 컨트롤 값 비교 없음 522, 화면 덤프에 없음 67, 숨김 상태 30, 컨트롤 형식 미지원 29. 실행할 조건 값 236개, 50화면.
- 시험 SCP0102 02:13~02:20: cboAccuracy 항목 5개(ALL, 91/100, 81/90, 51/80, 0/50) 실행, 설정 5회 성공. 조회 SP SCP0102_GET_BOD_VALIDATION_REPORT 5회 모두 0행. 나머지 49화면은 화면별 묶음의 '도출한 값으로 실행' 단계에서 실행됨.
- 명세 재집계 02:20(12,240): 값 도출됨 175 → 297, 전제 값 지정 필요 5,304 → 5,182. engine_selfcheck PASS.
- 한계: 그 값으로 화면을 실행했다는 뜻이고 분기를 탔는지는 관찰로 본다. 조건식의 상수 이름이 어느 항목인지는 실행 때 읽은 값으로만 맞춘다. 입력 상자·날짜 조건, 데이터(DATA) 축 2,567, 화면 상태(STATE) 축 2,230, 시트(SHEET) 축 1,915 는 도출하지 않음.

### 2026-11-14 02:23 덧붙임, 주기 2 순서 ⑧ Insert 화면 실측(검증엔진 세션, 진단 스펙 1건, 저장 없음, 실행 후 삭제)
- 실측 02:21(SSP0060, SSP0023, 계정은 스펙 기본 계정): 조회 뒤 보이는 그리드 2개 = 메인(SSP0060 13행, SSP0023 308행)과 하위 그리드 0행. role=tab 요소 0개. Insert(F8) 버튼 보임, 활성. 행 선택 없이 Insert, 메인 첫 행 선택 뒤 Insert 둘 다 신규 행 0, 알림 0. 메인 첫 행을 눌러도 하위 그리드는 0행 그대로.
- TO-BE 소스: 하위 시트 전환과 조회는 메인 그리드 셀 더블클릭(드릴다운)으로만 일어남(`ShipmentPlan.tsx:648-673` handleMainDrilldown, 활성 시트 기본값 PLAN_DETAIL = `useShipmentPlanStore.ts:147`). Insert 는 Plan Detail 그리드의 선택 행이 있어야 함(853-910행). AS-IS InsertRow 도 Plan Detail 분기는 행 0이면 return(cs 2560행).
- 원인: 검사기가 드릴다운 없이 Insert 를 눌러 하위 그리드가 0행인 상태에서 잼. 탭으로 시트를 여는 경로(role=tab, T303 포함)는 이 화면들에 탭이 없어 동작하지 않음. TO-BE 화면 결함으로 볼 근거는 없음.
- 검사기 결함 추가 확인: `asisInsertSheets('SSP0060')` 가 ['Hold stock'] 만 반환. 둘째 삽입 문장(cs 2641행)의 시트 조건이 2558행에 있어 위쪽 80줄 범위 밖. 범위를 메서드 시작까지로 넓혀야 함.
- 수정 대상(다른 세션 `run_verify.py SSP0020`, `SCP0104` 가 02:20:24 에도 화면 테스트 중이라 미룸): ① Insert 전에 하위 그리드가 0행이면 메인 셀 드릴다운으로 채우기 ② T303 탭 순회를 clickSheetTab 방식으로 ③ sheetConstAbove 범위 ④ M4 newRow 를 스펙에서 사용 ⑤ cellCenter 화면 밖 좌표.

### 2026-11-14 02:44 덧붙임, 주기 2 순서 ⑧ 영향 범위와 드릴다운 실측(검증엔진 세션)
- 원장 집계(02:4x, `mapping_trace_instances.csv`, 집계 행 제외): 사유에 '신규 행 없음' 이 든 검사 단위 = SSP0060 79, SSP0023 80, SSP0021 49, SSP0015 60, 전부 ERROR(미검증). FAIL 로 기록된 것은 0. ⑧은 조치 필요(FAIL)를 부풀린 원인이 아니고 미검증 268건의 원인.
- 드릴다운 실측(진단 스펙 02:40~02:42, 저장 없음, 실행 후 삭제): SSP0060 메인 8행의 D_20261009, D_20261010, BOH_QTY 셀을 더블클릭(24회). 서버 호출은 12회에서 늘었으나 2.5초 뒤 둘째 그리드는 24회 모두 0행. r6 SHIP_PLAN D_20261009 값 71344 에서도 0행. 하위 조회가 0건인지, 2.5초 안에 안 그려진 것인지는 미확인.
- SSP0023 은 기간 컬럼 이름이 X_D_yyyymmdd 라 진단 스펙의 기간 컬럼 조건에 안 걸림(시도 컬럼 TOT_BOH_QTY 만, 8회 모두 호출 0, 0행). 기간 셀 드릴은 미측정.
- 02:40:22 다른 세션 `run_verify.py SSP0020`, `SCP0104` 실행 중. 스펙과 E2E lib 수정은 계속 미룸.
- 03:00:22 다른 세션 `run_verify.py SSP0020`(pid 34788) 화면 테스트 중, SCP0104 는 끝남. 스펙과 E2E lib 은 수정하지 않음.
- 미룬 수정의 패치 스크립트 2개를 만들어 둠(미적용, 대상 문자열 일치 확인): scratchpad fix_t310.py = `probe.cellCenter` 화면 밖 좌표 차단 + `insertpre.sheetConstAbove` 탐색 범위 80 → 400줄(자기 시험 2건 추가). fix_t311.py = `_trace.spec.ts` M4 가 newRow 항목을 신규 행에서 시도. SSP0020 실행이 끝나면 적용하고 자기 시험, 게이트로 확인. 대장 번호 T310, T311 은 적용 때 기록.

### 2026-11-14 03:22 덧붙임, SSP0060 드릴다운 응답 실측(검증엔진 세션, 진단 스펙 1건, 저장 없음, 실행 후 삭제)
- 실측 03:21(로그 scratchpad dbg_drill2.log): 메인 r6 SHIP_PLAN D_20261009(값 71344) 더블클릭 → `/SSP0060/planDetail/SEARCH/call-proc` status 200, 응답 길이 70바이트(행 없음), 6초 뒤에도 하위 그리드 0행. r1 SHIP_PLAN_DETAIL D_20261010(값 0)도 같은 호출, 70바이트. r2 BOH_QTY(값 98, BOH_TYPE oWMS) 더블클릭 → `/SSP0060/owmsDetail/SEARCH/call-proc` status 200, 70바이트, oWMS Detail 그리드 0행. 요청 값 = divisionId 82, fromSite VP_GM01-A, itemId ECE1592F1-01-H0x, planStartYyyymmdd 20261009, dblFlag Y.
- 02:44 에 미확인으로 둔 항목 해소: 하위 그리드 0행은 늦게 그려진 것이 아니고 서버 응답이 0행.
- 해석 보류: 메인 값 98(oWMS 재고)인데 oWMS Detail 0행, 메인 값 71344 인데 Plan Detail 0행이 AS-IS 와 같은지는 미확인. AS-IS 같은 조건 실행(AS-IS Live 또는 차등 검증)으로 가릴 대상. 이 계정·조건에서는 Plan Detail 행이 없어 Insert 를 잴 수 없음(측정 전제 부족).
- 03:20:22 다른 세션 `run_verify.py SSP0020`(pid 34788) 화면 테스트 중. fix_t310.py, fix_t311.py 는 미적용 그대로.

### 2026-11-14 03:51 덧붙임, T310·T311 적용(검증엔진 세션)
- 03:40:23 run_verify, playwright 프로세스 0 확인 뒤 적용. T310(`probe.ts` cellCenter, `insertpre.ts` sheetConstAbove), T311(`_trace.spec.ts` M4 newRow). 게이트 PASS 03:50:10.
- cellCenter 는 화면 측정으로 확인(진단 스펙, 저장 없음, 실행 후 삭제): 4화면 72건 전부 대상 셀, null 0. 1차 보정 뒤 고정 컬럼이 null 이 되는 부작용을 같은 진단으로 찾아 3회 더 보정(scratchpad fix_t310b~e.py). 고정 컬럼 셀 요소의 top 이 스크롤 양만큼 한 번 더 밀리는 것은 화면 표시가 아니고 요소 좌표 값의 문제로 관측됨(같은 좌표의 맨 위 요소로 판별).
- 영향: cellCenter 를 쓰는 모든 검사. 종전에는 스크롤된 상태의 고정 컬럼 셀, 가운데·끝 행 셀에서 다른 곳을 눌렀을 수 있음. 어느 검사 결과가 그 영향을 받았는지는 미집계. 전체 재실행 전후 비교로 드러남.
- 남은 수정: ① Insert 전 하위 그리드 0행이면 측정 전제 부족으로 기록(SSP0060 은 03:21 실측에서 상세 조회 응답 0행) ② T303 탭 순회를 탭 없는 화면에서도 동작하게. 화면 쪽 수정 묶음 = T288, T289, T300~T311.
- 04:01 T312 반영(게이트 PASS): `insertpre.ts` 재시도 실패 증거 앞에 그리드 행 수와 탭 수 기록. 04:00:26 run_verify, playwright 프로세스 0.
- 화면 쪽 수정 묶음 = T288, T289, T300~T312. 주기 2 순서 ①~⑧ 은 처리 또는 사유와 함께 이월 상태: ⑧ 의 Insert 는 하위 그리드에 행이 있는 조건(계정, 품목, 일자)을 찾아야 잴 수 있음(조건 탐색은 미착수). ⑦ SSP0015 SpdMain 팝업(WH_IN 코멘트)은 컬럼 조건이 없어 M4 조건에서 빠짐(재현 경로 없음).
- 다음 = (라) 전체 재실행 1회와 전후 비교. 사용자에게 먼저 알린 뒤 시작.
- 04:20 전체 재실행 전 기준 저장: `Doc/verify/_cycle2_before_rerun_by_screen.csv`(24화면, 집계 행 제외 검사 단위 12,697 = 증명됨 3,899, 조치 필요 204, 미검증 3,703, 판정필요 694, 해당없음 3,794, 그 밖 403. 조치 필요 집계 행 381, 재측정 필요 250), `_cycle2_before_rerun_backlog.md`(proof_backlog.py 04:20 출력 사본). 이 파일의 수치는 집계 행을 뺀 값이라 22:08 기록(집계 행 포함 증명됨 4,662)과 기준이 다름.
- 04:20:24 다른 세션 실행 0. 엔진 변경 없음. (라) 전체 재실행은 사용자 회신 대기.

### 2026-11-14 04:42 덧붙임, SSP0060 oWMS Detail 양쪽 실행(검증엔진 세션, 조회만)
- 04:41:11 실행(scratchpad ssp0060_detail_e3.py, golden.py run_asis 사용, golden_cases.csv 미수정): AS-IS `SSP0060_GET_OWMS_DETAIL` 을 화면 실전송값(p_division_id 82, p_company_id GM00, p_from_site VP_GM01-A, p_item_id ECE1592F1-01-H00, p_product_level1 '-', p_plan_start_yyyymmdd 20261009, p_dbl_flag Y, p_sheet_name 'oWMS Detail')으로 실행 → 결과셋 1개, 25컬럼, 0행, 9.0초.
- TO-BE 는 03:21 화면 실측에서 같은 값으로 0행(응답 70바이트). 스크립트의 TO-BE 직접 호출은 반환값 처리 오류로 미실행(run_tobe 반환 형식이 예상과 다름).
- 결과: 이 조건에서 oWMS Detail 은 AS-IS 0행, TO-BE 0행. 차이 없음. AS-IS 개발 DB 와 TO-BE DB 는 데이터가 달라(CR-101) 메인 값 98 과의 관계는 이 실행으로 가릴 수 없음. Plan Detail 은 요청 인자 전체를 확보하지 못해 미실행(진단 로그가 260자에서 잘림).
- 기존 실행 대조 결과: `Doc/golden/SSP0060/_summary.csv` 에서 OWMS_DETAIL = SKIP(인자 값 없음), PLAN_DETAIL = DIFF(양쪽 0행). 두 건 다 화면 실전송값이 아닌 기본 인자로 실행된 것.

### 2026-11-14 05:02 덧붙임, 주기 2 전체 재실행 시작(검증엔진 세션)
- 시작 근거: 일괄 보완 끝(T288, T289, T300~T312), 게이트 PASS 05:01:37, 05:00:32 다른 세션 실행 0, 로컬 FE 200, BE 401. 사용자에게는 11-13 22:46 부터 재실행 예정을 알렸고(이후 정기 보고마다 반복) 회신은 없음. '작업은 계속 진행' 지시와 '일괄 보완 뒤 먼저 알리고 1회' 합의에 따라 시작. 사용자 테스트와 겹칠 때 멈추는 방법을 함께 알림.
- 실행: scratchpad cycle2_rerun.sh(주기 1 과 같은 절차). 시험 화면 SCP0028 1개 → 건전성 통과 시 나머지 24개를 2개씩. 로그 scratchpad rerun/c9_run.log, 화면별 c9_<ID>.log.
- 멈추는 방법: scratchpad rerun/c9_STOP 파일을 만들면 아직 시작하지 않은 화면은 건너뜀(도는 중인 화면은 끝까지 감).
- 전 기준: `Doc/verify/_cycle2_before_rerun_by_screen.csv`(04:20 저장). 끝나면 같은 방식으로 다시 세어 전후 비교를 덧붙임. 화면별 rc 를 확인(rc 3 = 미실행).
- 05:52:55 시험 화면 SCP0028 끝(rc 0, 통과 테스트 91, 실패 0, 스펙 예외 0). 05:52:57 나머지 24개 시작(DMF0005, SCP0005 부터 2개씩).
- 06:40:27 재실행 진행: SCP0028 끝, DMF0005(통과 25, 실패 0), SCP0005(통과 43, 실패 0) 도는 중, 스펙 예외 0, 시나리오 상한 발동 0.
- 06:41 20분 작업 호출 예약(06fb3efa)을 지움. 재실행 중에는 스펙·엔진을 고치지 않아 호출마다 할 일이 없음. 매시 7분 정기 보고(09b3211c)와 재실행 종료 알림은 유지. 재실행이 끝나 고칠 것이 생기면 다시 등록.

### 2026-11-14 22:54 덧붙임, 사용자 지시와 작업 순서(AS-IS Live 세션이 받아 적음, 검증엔진 세션도 읽을 것)
- 사용자 지시 22:50 무렵: ① AS-IS 와 TO-BE 의 데이터가 달라 생긴 차이는 판정필요, 오류로 판단하지 않음 ② 검사기 결함은 보완해야 하는 항목, 필요한 작업은 충분히 진행 ③ 전체 화면으로 확대하지 않음. `_proof_backlog.md` 의 27화면에서 미검증·미판단이 없도록 먼저 작업 ④ 검증 작업을 다 한 뒤에 필요한 보완 ⑤ 그 뒤 화면 확대. 나머지는 권장 순서로 진행하라는 회신 22:5x.
- 기준 수치(`_proof_backlog.md` 22:31): 27화면, 검사 단위 18,711 = 증명됨 4,892, 조치 필요 187, 그 밖 13,632. `doc_proof.py` 22:46: 대상 749행 = 입증 439, 반쪽 266, 미입증 36, 기계검출불가 8. 주입 시험 미검출 규칙 C2(SCP0007).
- 22:53 실행 중: `run_verify.py SSP0015`(21:23 시작), `run_verify.py SSP0021`(22:31 시작), `asis_live_scen_run.py SSP0201 --preset`(AS-IS Live 세션). 이 실행들이 도는 동안 AS-IS Live 세션은 검사기·스펙·E2E lib 을 고치지 않음.
- AS-IS Live 쪽 27화면 현황(`_scenarios_spec_summary.csv` 02:20 기준): 분기 2,594, AS-IS 실행 107, 전제 값 지정 필요 1,229, 정의 필요 542. SSP0060 은 런처 제외 목록(asis_live_batch.EXCLUDED), SSP0020 은 런처 기본 실행 FAIL.
- AS-IS Live 세션이 맡는 순서: (1) 조건 값 실행 49화면 종료 뒤 분기 대조·명세 재집계 (2) 27화면의 B04 신규행 전제 451, B05 팝업 반영 위치 232, B07 인자 미정 351, B09 수동 확인 2,040 가운데 AS-IS 런처 실행으로 정답을 줄 수 있는 것을 화면별로 연결 (3) 27화면의 데이터·화면 상태·시트 축 값 도출과 실행 (4) 같은 조작의 TO-BE 실행·대조(P6-4). 146화면 대상 도출·실행은 27화면이 끝난 뒤로 미룸.
- 검사기 쪽(B01 376, B02 671, B06 2,564, B08 1,226, B14 1,320, C2 주입 시험)은 재실행이 끝난 뒤 착수. 두 세션이 같은 파일을 고치지 않도록 착수 전에 이 문서 끝을 다시 읽는다.

### 2026-11-14 23:04 덧붙임, 조건 값 49화면 실행 결과(AS-IS Live 세션)
- 실행 11:16:43 ~ 23:00:47(`Doc/asislive/_cond_run_20261114.csv`, `.log`). 49화면 종료코드 전부 0. 조건 값 231개 중 설정 223, 설정 실패 1(SCP0015 cboPlanWeek, 실행 때 콤보 항목 0개, 원인 미확인), 화면 열기 시간 초과 7(DMF0081, open 180초 무응답). DMF0081 은 23:04 다시 실행.
- `asis_live_scen_values.py` 완료 판정 결함 수정: 실행 기록 토큰의 값 부분(cT, cF)을 소문자로 바꾸지 않아 체크 상자 실행 26개가 남은 것으로 잡혔음. 수정 뒤 남은 조건 값 34 → 8(DMF0081 7, SCP0015 1).
- 재집계 23:01~23:02(145화면, 분기 12,240): COND 실행함 1 → 580, 실행 대상 83, 값 미도출 581, 화면에 없는 컨트롤 67. 분기 실행 여부(scen_cov) 실행됨 364, 분기 미특정 62, 미실행(호출 있는 분기) 572, 호출 기록으로 판정 불가 10,349. 명세 AS-IS 실행 530 → 1,772.
- 대조(scen_cmp) 145화면: 양쪽 확인 13, TO-BE 룰 차이 43, 판정필요 157, 차이(오류 후보) 63, TO-BE 미검증 1,390, AS-IS 미실행 9,531. 27화면 부분합: 분기 2,594, 양쪽 확인 13, TO-BE 룰 차이 9, 판정필요 155, 차이(오류 후보) 50, TO-BE 미검증 303, AS-IS 미실행 1,921, 도달 경로 없음 143.
- 27화면 부분합 AS-IS 실행: 107(02:20) → 530(23:01). 전체 145화면 수치(530 → 1,772)와 값이 우연히 같으니 혼동 주의.
- 새 도구 `tools/AsisLive/asis_live_proof_targets.py`(22:55): 증명 목록 미증명 11,225건을 사유 글로 나눔. 검사기 쪽 6,020, 런처 2,889, 미분류 2,316. 출력 `Doc/asislive/_proof_live_targets.csv`. engine_selfcheck PASS 23:02.

### 2026-11-14 23:30 덧붙임, AS-IS 런처 잠금 결함과 호출 기록 오염(AS-IS Live 세션)
- 증상: DMF0081 조건 값 재실행(23:04~23:22)이 '화면 열기 실패: no response within 180s' 2회 뒤 '런처 다시 시작 실패: host exited (code 1)' 로 rc 3. 같은 때 run_verify SSP0015 의 화면 묶음(asis_live_screen.py, 23:18 시작)이 런처를 따로 띄워 돌고 있었음(pid 23124).
- 원인: `asis_live_scen_run.py` 는 실행 잠금 `Doc/asislive/_run.lock` 을 잡은 뒤 시각을 갱신하지 않음. `acquire_lock` 은 15분 넘게 갱신 없는 잠금을 죽은 것으로 보고 지움. 15분 넘게 도는 시나리오 실행 중에 다른 실행이 잠금을 지우고 런처를 하나 더 띄움. 조건 값 일괄 실행(scen_run 직접 호출)은 화면 묶음의 화면 잠금(`_screen.lock`, PID 기준)을 잡지 않아 막지 못함.
- 오염 실측: SCP0033 `run_20261114_120619_acts_cell/calls.json` 에 DMF0022 실행의 호출 `DMF0002_GET_TITLESET_POPUP`(p_program_id='DMF0022') 이 들어 있음. 호출 기록은 DbProfile 로그를 시간 구간으로 잘라 만들기 때문.
- 범위(`tools/AsisLive/asis_live_overlap.py` 새 도구, 호출 시각 구간 기준, 23:25): 11-12 이후 실행 폴더 856 중 다른 화면 실행과 겹친 것 55, 화면 17. 27화면에 드는 것 SCP0033, SCP0037, SCP0041, SCP0108, SCP0122, SCP0127, SCP0131, SSP0003, SSP0005, SSP0021, SSP0023. 겹친 폴더에 overlap.json 을 남기고 목록은 `Doc/asislive/_overlap_runs.csv`.
- 수정: ① `asis_live_run.Host.send` 가 명령마다, 대기 중 60초마다 잠금 시각 갱신(백업 `.bak_20261114_lock`) ② `asis_live_scen_cov.py`, `asis_live_scen_cmp.py`, `asis_live_scen_values.py` 가 overlap.json 있는 폴더를 증거에서 뺌(백업 `.bak_20261114_overlap`) ③ `asis_live_scen_values.py --run` 이 화면 잠금을 잡음.
- 뺀 뒤 재집계 23:25: 145화면 AS-IS 실행 1,775, 양쪽 확인 13 → 7, 판정필요 157 → 163. 27화면 부분합 AS-IS 실행 530 → 488, 양쪽 확인 13 → 7, 차이(오류 후보) 50, TO-BE 미검증 303 → 261, AS-IS 미실행 1,921 → 1,963. 조건 값 남은 것 28(10화면).
- 다시 실행 23:26:38 시작(SSP0015 묶음이 끝날 때까지 화면 잠금 대기, scratchpad overlap_rerun.py, 기록 `Doc/asislive/_overlap_rerun_20261114.csv`·`.log`): 27화면 묶음 9개(asis_live_screen.py --force) → 조건 값 27화면 먼저, 그 밖 화면 뒤(SCP0015 는 콤보 항목 0개라 뺌). 화면 잠금을 잡고 돌아 검증엔진 쪽 묶음과 차례로 실행됨.
- 검증엔진 세션 참고: 지금 도는 run_verify(SSP0015, SSP0021) 프로세스는 고치기 전 코드를 읽어 잠금 갱신을 안 함. 그 묶음이 15분 넘게 돌면 다른 실행이 잠금을 지울 수 있으나, 이번 다시 실행은 화면 잠금을 먼저 잡으므로 겹치지 않음.

### 2026-11-15 01:52 덧붙임, 겹친 실행 다시 하기 결과(AS-IS Live 세션)
- 실행 11-14 23:26:38 ~ 11-15 01:50:20(`Doc/asislive/_overlap_rerun_20261114.csv`): 27화면 묶음 9개 rc 0 8개, SSP0003 rc 2(저장 정의 초안 연습 단계 rc 3, 조회 0행). 조건 값 SSP0021 3, SSP0023 1, DMF0022 2, DMF0035 3, SCP0013 3, SSP0008 2, SSP0022 5, SSP0046 2 rc 0. DMF0081 6개는 화면 열기 180초 무응답 6회(이번에는 다른 실행과 겹치지 않음, 원인 미확인. 27화면 밖이라 뒤로 미룸).
- 화면 잠금 확인: 검증엔진의 SSP0023 묶음(01:22:50 시작)이 화면 잠금을 기다렸다가 01:50:21 에 런처를 띄움. 11-14 23:26 이후 실행 폴더의 겹침 0(asis_live_overlap.py 01:50).
- 재집계 01:51(145화면): AS-IS 실행 1,835, 양쪽 확인 13, TO-BE 룰 차이 43, 판정필요 158, 차이(오류 후보) 77, TO-BE 미검증 1,439, AS-IS 미실행 9,459. 남은 조건 값 7(DMF0081 6, SCP0015 1).
- 27화면 부분합 01:51: 분기 2,594, AS-IS 실행 548(겹침 뺀 뒤 488 → 다시 실행 뒤 548), 양쪽 확인 13, TO-BE 룰 차이 9, 판정필요 156, 차이(오류 후보) 64, TO-BE 미검증 306, AS-IS 미실행 1,903, 도달 경로 없음 143.
- 다음(AS-IS Live 쪽): 27화면 미증명 가운데 런처 2,889건(`_proof_live_targets.csv`)을 실행기에 연결. 팝업 값 반영 865건은 팝업 행 선택 → 바뀐 셀 기록 기능이 호스트에 없어 새로 만든다.

### 2026-11-15 06:30 덧붙임, 런처 몫 미증명 연결 1차(AS-IS Live 세션)
- 호스트 명령 추가(`tools/AsisLive/host/AsisLiveHost.cs`, 04:47·06:10 컴파일): `cellstate`(행별 셀 잠금·배경색·글자색, GetStyleInfo 우선), `popup_ok`(팝업의 ButtonList OK·Confirm 버튼), `act`·`cellstate` 의 `grid`·`sheet` 인자(PickSpread, 시트 탭을 누른 것과 같은 ActiveSheetIndex 변경).
- 실행기 방식 추가(`asis_live_scen_run.py`, 백업 `.bak_20261115_*`): `--states`(조회 직후·수정 모드 셀 상태), `--pick`(셀 더블클릭 → 팝업 → 첫 행 고름 → 바뀐 셀), `--insert`(행 추가 → 새 행 셀 상태), `--violate`(빈 새 행 저장 → 검증 메시지, 저장 확인은 아니오).
- 05:56 27화면 1차 일괄(`Doc/asislive/_run27_states_pick_20261115.csv`) 뒤 찾은 실행기 결함과 수정:
  - 수정 모드 잠금이 안 풀림: 화면 EditButton 이 BaseForm.fps(셀 클릭 때 채움, BaseForm.cs:2860)로 잠금을 품(SSP0014_ShipmentModelPIC.cs:267). 수정 버튼 전 첫 보이는 셀 1회 클릭 추가(focus_grid). SSP0014 수정 모드 더블클릭 8열 모두 UserInfoPopup 열림·값 반영(06:20).
  - 빈 목록 팝업(UserInfoPopup.cs:158, 조회 버튼을 눌러야 목록이 참)을 팝업으로 세지 않음: 팝업 FindButton 호출 뒤 고름.
  - 첫 시트가 빈 화면을 '조회 결과 없음'으로 건너뜀(SCP0020 Packer 855행, SCP0104 ELTR 275행): 행이 있는 시트를 골라 grid·sheet 를 넘김(data_sheet).
  - 0행 누름: 분기 조건식의 그리드·시트·열·행 조건을 읽어 맞는 셀을 누름(dbl_plan·resolve_target). 시나리오 표의 잘린 조건(…)은 원문에서 src 줄 이전 가장 가까운 위치로 복원(expand_guard). 예: SSP0023 spdMain MEASURE='P_SHIP_CONFIRM_ETD' 행의 MEASURE 다음 열, spdDetail PlanDetail 시트 ERP_SO_NO 값 있는 행. SSP0021 BOH_TYPE ERP·oWMS·HOLD·MES 4행.
  - 팝업 내부: 팝업이 뜨면 고르기 전 조건 컨트롤·그리드 덤프와 팝업 조회 1회 호출 기록(popup_inside).
- 조회 0행 화면 데이터 조건(AS-IS LGCE_SCMDEV 실측, `Doc/asislive/<ID>/data_cond.json`, prefill 뒤 적용): SSP0005 Company AA00 → HQ00(16번, 06:17 SP 3행), SSP0003 Status Drafting → Approved·기간 2026-10-01~10-26(06:18 SP 543행). SSP0015 는 SSP_ANL_SHIP_PLAN_40 이 사업부 40·SP·1차만 5,480,002건, 기본 사업부 81 이라 0행 → 사업부 40 SP 직접 실행 06:24 시작(5분 넘음, 결과 미확인).
- 새 도구: `tools/AsisLive/asis_live_proof_answers.py`(런처 몫 사유 종류별 정답 연결, 04:55 기준 2,922건 = 정답 있음 1,205·실행·관찰 없음 192·미실행 1,525), `tools/AsisLive/asis_live_cell_facts.py`(열 단위 AS-IS 사실표 `Doc/asislive/<ID>/cell_facts.csv`: 조회 직후·수정 모드 잠금, 배경색, 더블클릭 팝업, 고른 뒤 바뀐 열, 새 행 잠금). 등록부 갱신 06:29(inventory_check PASS).
- 검증엔진 쪽 할 일(엔진 실행이 끝난 뒤): `cell_facts.csv` 를 asis_live_ingest 에서 읽어 편집 불가 셀·행 조건 계산(D3) 검사 단위와 열 이름으로 짝짓기. 이 세션은 엔진 파일을 고치지 않았음.
- 2차 일괄 `--states --pick` 06:20 시작, SCP0028 `--violate` 시범 06:21 시작(결과 미확인).

### 2026-11-15 09:08 덧붙임, 주기 2 전체 재실행 결과(검증엔진 세션) = 전체 종료
- 재실행: 11-14 05:01:39 ~ 11-15 08:54:23(로그 scratchpad rerun/c9_run.log). 25화면 전부 rc 0. 스펙 예외 0. 시나리오 상한(T306) 발동 1회(DMF0005, 07:48:35 시작 시나리오, 문서 시나리오 테스트 40.2분에 끝남. 주기 1 은 3.5h 무응답).
- 실패 테스트 10건: SCP0041 I2 언어 전환(시간 제한), SCP0108 C1·C4·M2·D6/F3(시간 제한 3), SSP0014 F1·F6 저장 세부·저장 경로, SSP0021 C1·C4, SSP0025 저장 세부·저장 경로, SSP0060 저장 경로. 저장 경로 3화면 중 SSP0014·SSP0025 오류 = 'User Popup' 이 Save 버튼을 가림(nscm.ts:700). 팝업을 연 조작은 미확인.
- 결과 점검 중 내가 만든 결함 1건(T313): T305 문구 '트리거 그리드 0행' 이 M4 FAIL 54건으로 집계. judge.py RX_TOOLFAIL 에 추가 후 SSP0015·0021·0023·0060 판정 재적용(08:56~09:05:57, rc 0).
- 전후(24화면, 집계 행 제외, 전 = `_cycle2_before_rerun_by_screen.csv` 11-14 04:20, 후 = `_cycle2_after_rerun_by_screen.csv` 11-15 09:07): 검사 단위 12,697 → 12,693, 증명됨 3,899 → 3,917(+18), 조치 필요 204 → 218(+14), 미검증 3,703 → 3,605(−98), 판정필요 694 → 693, 해당없음 3,794 → 3,861(+67), 재측정 필요 250 → 0, 조치 필요 집계 행 381 → 419.
- 조치 필요가 늘어난 화면: DMF0005 +3, SSP0003 +3, SSP0060 +3, SSP0200 +3, SSP0021 +2, SSP0023 +2, SSP0015 +1. 줄어든 화면: SCP0028 −1(G4 Div 라벨 T308), SCP0111 −1, SSP0024 −1. 늘어난 행의 원인은 미분류. K-SA(조회영역 토글) FAIL 이 1화면(SSP0021) → 5화면(SSP0003, SSP0021, SSP0023, SSP0060, SSP0200).
- M4: T307·T309·T311 로 트리거를 바꿨으나 SSP0015·0021·0023·0060 은 새 트리거(ERP_SO_NO 등)가 있는 하위 그리드가 0행이라 여전히 미측정(T312·03:21 실측과 같은 이유).
- proof_backlog.py 09:07: 대상 27화면, 검사 단위 18,711, 증명됨 4,954, 조치 필요 요소 195.
- 종료 조건 (라) 충족: 전체 재실행 1회 + 전후 비교 기록. 사용자에게 '전체 종료' 알림. 다음 주기 입력: 늘어난 조치 필요 행 분류, K-SA 5화면, 저장 경로 User Popup, 시간 제한 실패 6건, 하위 그리드 0행 조건 탐색.

### 2026-11-15 11:50 덧붙임, AS-IS Live 세션
- 결함 수정: `tools/AsisLive/asis_live_screen.py` 화면 잠금 교착. 묶음이 157행에서 화면 잠금을 잡은 뒤 [실측 10] `asis_live_scen_values.py --run`(197행)이 같은 잠금을 60분 기다려 단계 제한 3600초로 끝남(SSP0020 10:47~11:47 실측, rc=124, 묶음 PARTIAL). 화면 묶음을 쓰는 CheckList 체인도 화면마다 같은 대기가 생김. 잠금 재진입 추가(환경변수 ASIS_LIVE_LOCK_HOLDER = 부모 pid·화면, 같은 화면 자식만 통과, 자식은 잠금 파일을 지우지 않음). 자기 시험: 같은 화면 0.0초 통과 · 다른 화면 대기 · 부모 해제 뒤 파일 삭제. 백업 `.bak_20261115_reentrant`.
- 행 추가 실행기(`asis_live_scen_run.py --insert/--violate`): 셀 클릭 → 수정 → 행 추가. 화면 원문 InsertButton·InsertRow 를 읽어 행 추가 기능 없음(8화면: SCP0016·SCP0028·SCP0041·SCP0084·SCP0108·SSP0003·SSP0005·SSP0014, SSP0020)과 상세 시트 대상(SSP0015·SSP0021·SSP0023)을 구분. 원문 파일은 메뉴 ClassName 기준(GSCM/_build_logs/menu_jaeuk_admin.csv).
- 정답 연결(`asis_live_proof_answers.py`) 10:43: 2,922건 = 정답 있음 2,055 · 실행·관찰 없음 438 · 미실행 429. "수정모드가 아니므로" 메시지만 받은 행 추가는 정답에서 제외.
- AS-IS 개발 DB 행 단위 시험 데이터: SSP_MST_DELEGATE 2행(ATTRIBUTE10='ASISLIVE_TEST_20261115', 되돌리기 tools/AsisLocal/sql/20261115_SSP0020_DELEGATE_TEST_ROWS.sql). SSP0020 실행 폴더에 GSCM.SSP.Plan.UIL.dll 을 SSP0020_Delegate.UIL.dll 이름으로 복사(Doc/asislive/SSP0020/env_fix_20261115.txt).
- 조건 데이터: SSP0023 품목 APCCA3122A(상세 SP 48행), SSP0015 사업부 40 계획 버전 없음(최근 20260822 < 기준 20261005) · 사용자 판단 대기.


## 2026-11-15 19:57 덧붙임 (AS-IS Live 경로 메시지 · 사용자 결정 반영)
- 사용자 결정(11-15): SSP0003 승인·반려·자체 반려, SSP0200 변경 요청·취소 경로 실행 안 함. 등록 Doc/asislive/_user_decisions.csv 13개 처리기. 대조 상태 '미실행(사용자 결정)' 74행.
- 실행기 asis_live_scen_run.py: 버튼 처리기 연결 컨트롤을 원문 '+=' 연결로 찾음(wired_controls · SSP0200 BtnChangeRe_Click → btnChangeRe2). --msgcell 모드 신설(Doc/asislive/_msg_cell_spec.json · 단계 cell/insert/click/act/method · pre_set). 저장하지 않음.
- 호스트 AsisLiveHost.cs: cell 명령 grid·sheet 지정, 숫자형 칸 SetValue 재시도. 빌드 19:5x 성공.
- 대조기 asis_live_msg_cover.py 결함 수정: 문구만 맞으면 다른 처리기 메시지도 '실측 관찰'로 셈 → 처리기 일치(msgcell handler, msgbtn control, 시나리오 ID → scenarios_src.method, OnClick<X>Button → <X>Button)만 '실측 관찰', 나머지 '문구 관찰(다른 경로)'. 도달 불가 근거 Doc/asislive/_msg_unreachable.csv 반영.
- 실측(19:57): 경로 메시지 458행 = 미관찰 155, 메시지 코드 아님 79, 미실행(사용자 결정) 74, 런처 제외 72, 실측 관찰 52, 문구 관찰(다른 경로) 20, 도달 불가 6.
- SSP0200 셀 분기 3건 관찰(MSG00098 Div 없음 FROM_SITE 클릭, MSG00002 Incoterms 없음 TRANSPORT_MODE 클릭, MSG00287 Reason Code 없음 Detail 입력).
- 도달 불가: DMF0005 MSG00177(현행 spdMain 에 CELL_PER_CAR·CELL_PER_MODULE 열 없음), SCP0131 MSG00049(원문 979~987행 항상 참).
- 미해결: SCP0005 LT_ARRIVAL_INLAND SetValue ArgumentException(숫자 재시도도 실패), SCP0020 시트 전환 후에도 Packer 조회(Plant SP SCP0020_GET_TACT_TIME 미호출), SCP0041 Pack 시트 날짜 역전 입력 메시지 없음(처리기 연결 시트 = InitEvent 시점 활성 시트 · 확정 미확인).
- 런처 정답 연결(19:57): 2,922 = 정답 있음 2,335, 런처 제외 389, 실행·관찰 없음 188, 미실행 10.


## 2026-11-15 21:20 덧붙임 (SSP0015 시험 데이터 · 실행기 결함 2종)
- 사용자 승인(11-15 '넣기'): AS-IS 개발 DB 사업부 40 계획 버전 1건 적용 20:08. scm_mst_plan 20,530→20,531 · scm_mst_plan_detail 14,597→14,598. plan_id 145790(DAILY 채번 끝자리 01~07 밖 · 문자열 MAX 145807 미만) · plan_name 20261009 · ATTRIBUTE15='ASISLIVE_TEST_20261115'. SSP_PLAN_VERSION_V 사업부 40 = 20261009-SP-01 1건. 되돌리기 tools/AsisLocal/sql/20261115_SSP0015_PLAN_VERSION_40.sql.
- SSP0015 조건 Doc/asislive/SSP0015/data_cond.json: 사업부 40 · Plan date 2026-10-09 · post_find(MEASURE=SHIP_CONFIRM 행 D_ 칸 더블클릭 → 상세 조회, 원문 8133~8150행).
- 실행기 결함 수정 1: 수정 모드 판정이 BaseForm.IsEditMode 만 봄 → SpreadInfo.SwitchLockEx(SpreadInfo.cs:9708)는 IsEditMode 를 바꾸지 않음. Action 열 표시로 보완(edit_by_action · 6곳).
- 실행기 결함 수정 2: popup_buttons 가 msgbtn·msgcell 기록의 문자열 팝업 목록에서 AttributeError(20:35 --pickbtn 중단) → 문자열 허용.
- 실행기 기능: post_find(조회 뒤 상세 채우기) 추가.
- SSP0015 실측(20:40~21:18): 셀 상태 40행×60열 수정 모드 열림 96 · 행별 잠금 차이 D_20261009~D_20261020 12열 · 팝업 버튼 4개 고름 · 상세 Shipment Confirm Detail 1행 · 행 추가 늘어난 행 0.
- SSP0015 정답(21:19): 341건 = 정답 있음 231 · 실행·관찰 없음 110(신규행 전제 72 · 검증 위반 입력 38). 원인: InsertRow(7692~7716행) 조건 siDetail 잠금 해제 + 활성 시트 미충족. 상세 그리드 잠금 상태 미확인.
- 27화면 런처 정답(21:19): 2,922 = 정답 있음 2,335 · 런처 제외 389 · 실행·관찰 없음 188 · 미실행 10.


## 2026-11-15 21:50 덧붙임 (SSP0015 상세 행 추가 · 검증 위반 저장 안전장치)
- SSP0015 상세 행 추가 해결(21:47): Hold stock 새 행 1(잠김 8·열림 5) · Shipment Confirm Detail 새 행 2(첫 행 잠김 60·열림 8).
  - 원인 1: 행 없는 상세 시트는 셀 클릭을 건너뛰어 BaseForm fps 가 spdDetail 이 아님(EditButton 1861행 fps.Name == "spdDetail") → 실행기에서 그 그리드 CellClick 이벤트 발생으로 보완.
  - 원인 2: InsertRow 7795행 SHIPMENT_STATUS != "C" 면 return · 품목 미지정 시 고른 상세 행 상태 P → 조건 txtItemId=MCCH114030L1 · post_find(MEASURE=SHIP_CONFIRM, FROM_SITE=NJ01-A, D_20261009) · 상세 SP 직접 실행으로 C 상태 1행 확인(21:47, 5.5초).
- 사고 예방(21:27~21:29): SSP0015 SaveData_Detail 은 확인 창 없이 SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40 호출(5841행) · 새 행이 원래 행 값을 복사해 필수값 검증을 통과할 수 있어 검증 위반 실행을 중단. 확인: 21:27 이후 서버 호출 17건 중 저장 SP 0 · SSP_ANL_SHIP_CONFIRM·CHG_REQ_DE 21:00 이후 변경 0. 11-14~15 실행 기록 전수 저장 계열 호출 = TH_UIS_SQL_LOG 와 11-14 SCP0030 저장 시나리오 1건뿐.
- BaseForm.OnClickSaveButton 에는 저장 확인 창이 없음(권한 → CheckValidation(Save) → 변경 행 확인 → 화면 SaveButton). 검증 위반 모드 안전장치 save_unconfirmed: SaveButton 부터 깊이 4 안에서 저장 SP 요청이 확인 창(DialogResult)보다 먼저 나오면 저장 버튼을 누르지 않고 '저장 확인 창 없음 · 실저장 위험 · 저장 미실행' 기록. 26화면 중 19화면 해당.
- 잠금 보완: asis_live_run.acquire_lock 이 소유 프로세스가 없는 _run.lock 을 바로 정리(_pid_alive). 21:40 중단 실행이 남긴 잠금으로 rc=3 발생 후 보완.
- 정답(21:48): SSP0015 341 = 정답 있음 303 · 실행·관찰 없음 38(검증 위반 입력, 저장 안전장치로 미실행). 27화면 2,922 = 정답 있음 2,407 · 런처 제외 389 · 실행·관찰 없음 116 · 미실행 10.


## 2026-11-16 04:49 덧붙임 (런처 정답 판정 단위 정정 · DMF0005·SCP0084 경로 메시지)
- 정답 판정 단위 정정(asis_live_proof_answers.py · 백업 .bak_20261116_spobs):
  - 팝업·셀 이벤트 호출, 차등 검증 인자 = 원장 행의 대상 SP 가 런처 호출 기록(기본 실행 포함)에 있어야 정답. TO-BE 대상(PKG_X.P_NAME)은 P_ 를 떼어 AS-IS 이름으로, 잘린 이름은 골든 파일·golden_cases 이름으로 펼침.
  - 저장 밖 경로 메시지 = _msg_cover.csv 원장 행 대조. 미관찰·다른 경로 문구 0 이고 실측 관찰 1건 이상일 때만 정답.
  - 11-15 21:48 보고 2,407 은 화면 단위 연결(그 화면에 해당 종류 실행이 1건이라도 있으면 정답)로 부풀려진 값. 정정 값(04:48) 2,098.
- asis_live_msg_cover.py: 화면 지정 실행은 그 화면 행만 교체(04:48 SCP0084 단독 실행이 _msg_cover.csv 를 1화면으로 덮어 정답 2,218 로 잘못 나온 일 재발 방지).
- 호스트(빌드 04:36): act select="r0,r1"(그리드 행 범위 선택) · 대화상자 정책 cancel(취소 우선). 실행기 msgcell: 항목 group(권한 분기) · dialogs · 단계 keep_popup · popup_ok · sleep.
- DMF0005 경로 메시지(04:45): 원장 30행 = 실측 관찰 19 · 도달 불가(원문) 5 · 도달 불가(계정 권한 데이터) 3 · 메시지 코드 아님 3 · 미관찰 0. 저장 SP 호출 0.
  - MSG00130 양방향 · MSG00128 · MSG00471(Item 팝업 2행 선택) · MSG00430 주·상세(Owner 팝업 2명).
  - MSG00096 = Division 81·82 + SCP Planner 그룹 조건. 측정 계정 SCP Planner 그룹의 DMF0005 Division 목록 = 40 하나(04:32) → _msg_unreachable.csv 등록.
- SCP0084(04:47): Excel 버튼 MSG00100 실측(취소 눌러 Excel 미기동) · 경로 메시지 3행 실측 관찰. 월 범위 SP SCP0084_GET_MONTH_RANGE 는 11-12 기본 실행 load 단계 호출(p_month=12 · 1행)로 정답.
  - 분기 해석 4건(LONG_TERM_STOCK_QTY·AMOUNT·*_XLS, C3 연쇄 자동 채움, asis_ref 614행) = Excel 내보내기 복사 시트 열 숨김 문장 · 값 연쇄 아님 → 검사기 결함 후보(Doc/asislive/_launcher_not_target.csv).


## 2026-11-16 05:31 덧붙임 (실저장 경로 분류 · SCP0020·SCP0041·SCP0005)
- 실저장 경로 분류: asis_live_msg_cover.save_path(메시지가 쓰기 SP 요청 뒤 · QueryInfo AfterExecuteSQLProc 등록형 포함 · 주석 코드 제외) → '미실행(실저장 경로)' 20행(SCP0028 FindDelete 2 · SCP0104 AfterSaveData 6 · SSP0023 Simulation 7 · SSP0200 GetErpIFCheck 5). proof_answers.sp_save_only(쓰기 SP 이름 또는 Save 이름 메서드에서만 닿는 SP) · SSP0014·SSP0025 GET_USER_ID_CHECK = SaveButton 경로.
- 조회 단계 SP 기록: open_and_find 가 acts.json find_calls 남김(그전 셀 시나리오 실행은 조회 SP 를 남기지 않아 '조회 시트' 판단 근거 없음).
- SCP0041(05:00): Pack 시트 조회 SCP0041_GET_PACK_HOLD_STOCK 1,332행 관찰. MSG00108(날짜 역전) 미관찰 유지.
- SCP0020(05:08~05:17): Plant 시트 = SetSpreadInit 442행 Visible=false(2021-09-13) · ActiveSheetIndex=0 지정 뒤에도 1 유지 → GET_TACT_TIME·GET_TACT_TIME_EXCEPT·MSG00203 도달 불가 등록(_sp_unreachable.csv · _msg_unreachable.csv). 예외 그리드 MSG00161 · MSG00002('Line') 관찰(주 그리드 새 행 더블클릭 → 주 수정 모드 끔 → 예외 그리드 수정·행 추가, 659행 MSG00199 우회 순서).
- SCP0005(05:22~05:30): MSG00265(업로드 창 닫은 뒤) · MSG00209(600+600 편집 입력, 1000 입력은 값 0 유지) · 이력 팝업 SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID · 외부 진입 SCP0102(사업부 81·2026-06, ROUTE_ID 10243 더블클릭) → SCP0005_GET_DISTRIBUTION_ROUTEID 1행. 실행기 msgcell 항목 open(다른 화면에서 시작).
- 정답(05:30): 2,922 = 정답 있음 2,129 · 런처 제외 389 · 실행·관찰 없음 329 · 미실행(사용자 결정) 36 · 미실행(실저장 경로) 20 · 도달 불가 10 · 관찰 대상 없음 5 · 검사기 결함 후보 4.


## 2026-11-16 07:21 덧붙임 (런처 정답 판정 보강 · SCP0028·SCP0104·SSP0003·SSP0024·SSP0200·SSP0021·SSP0023·SCP0007·SCP0122·SCP0041)
- 판정 보강(asis_live_proof_answers.py):
  - AS-IS 경로 SP 집합 = 화면 원문(공용 폴더면 그 화면 파일만) + new 로 여는 Popup·Form 클래스(class 선언 색인 Doc/asislive/_cache_class_index.json) · 따옴표 안 SP 이름 전부(변수 대입·QueryId·이어 붙이기 앞부분). 여기 없는 SP = '검사기 결함 후보(AS-IS 경로에 없는 SP)' 23건(SCP0028 SCM0002_GET_MATERIAL_BY_DIVISION · SSP0023 GET_PLAN_DETAIL 등 5개는 AS-IS 원문 0·DB 프로시저 0).
  - 시작 메서드 계산: 호출 = '이름(' 만 · += 연결·new EventHandler(처리기) 전달(디자이너 파일 포함)은 시작점 · 호출부 없는 비 override 메서드는 죽은 코드로 제외(SSP0015 GetNewERPInterface 호출 주석). Save 이름 시작점만 = 실저장 경로 · 사용자 결정 처리기만 = 미실행(사용자 결정).
  - 등록 파일: _sp_unreachable.csv(SCP0020 Plant SP 2 · SCP0028 입력 조회 실저장 · SCP0104 CHECK_NAME_ON_DUMMY_CODE = 셀 입력만으로 MERGE INTO SCP_MST_CAPA_DUMMY_CODE) · _launcher_manual_answers.csv(셀 상태 관찰: SCP0007 INCOTERMS_SSP 수정 켬 잠금 0 / 끔 잠금 1 · SCP0122 CellClick 행 기준 콤보 변경 재채움).
- 실행기(asis_live_scen_run.py): 조회·조회 뒤 동작·수정 단계 SP 기록(find_calls·edit_calls) · msgcell 단계 setc·values·cellstate·row_where(!값·found)·col_tag·open(다른 화면 시작)·post_find(항목별) · 잠긴 칸 값 지정 단계가 있으면 non_user_path 표시(대조기는 실측 관찰로 세지 않음, 11-15 이전 기록 6건 소급 표시).
- 관찰(07:20 기준): SCP0028 입력 팝업 조회 SP · SSP0003 상세·결재선 SP(543행) · SSP0024 EditButton SSP0002_GET_USER_INFO_LIST · SSP0200 MSG00293(+SSP0026_GET_BOD_ITEM)·MSG00194·MSG00050·MSG00098(From Site·Model) · SSP0021 상세 6시트 SP · SSP0023 상세 3시트 SP·MSG00265·MSG00278 2경로·MSG00287(ERP_STATUS != C 15행).
- 도달 불가 등록(실측+원문): SCP0041 MSG00108(처리기가 열림 시 활성 시트 0 에 연결, 날짜 열은 시트 1) · SSP0200 MSG00189·SSP0023 MSG00189(ERP_STATUS C 행 수정 잠금) · SSP0200 CellClick MSG00098(새 행 Division 복사·잠금, 0행이면 행 추가 안 됨).
- 막힌 것: SSP_PLAN_VERSION_V 기준일 FN_GET_BUCKET_YYYYMMDD(-5)=20261012(11-16 05:56) > 개발 DB 최근 계획(사업부 81 20261009 · 시험 행 20261009) → 뷰 0행 · SSP0015 조회 불가 · SSP0021 주 조회 SP 미호출(원인 미확인). 이어 가려면 기준일 안 계획 버전 + 출하 계획 데이터 추가 필요(사용자 확인 대상).
- 정답(07:20): 2,922 = 정답 있음 2,137 · 런처 제외 389 · 미실행(실저장 경로) 155 · 실행·관찰 없음 155(SSP0015 110 · SSP0023 35 · SSP0021 10) · 미실행(사용자 결정) 41 · 검사기 결함 후보 27 · 도달 불가 10 · 관찰 대상 없음 8.

## 2026-11-16 09:05 덧붙임 (사용자 지시: 정적 우선 · 런처는 동적 항목만 · TO-BE 룰은 준수만 확인 / 런처 정답 재연결)
- 사용자 지시(08:5x): 정적으로 되는 항목은 정적으로, 동적으로 필요한 항목만 런처, TO-BE 룰로 바뀐 부분은 룰 준수만. 메모리 feedback_static_first_launcher_dynamic_only_20261116.
- proof_backlog.py 27화면 지정 재계산 09:02: 검사 단위 18,711 · 증명됨 4,954 · 조치 필요 195 · 그 밖 13,562(11-15 09:07 과 같음. 27화면 원장 변경 없음. DMF0042 원장 09:00 변경은 대상 밖이라 뺌).
- asis_live_proof_targets.py 09:02(이전 11-15 01:52 판은 옛 증명 목록 기준): 미증명 11,080 = 검사기 쪽 6,072 · 런처 3,254 · 미분류 1,662 · 확정 후보 92. 이전 판 백업 _proof_live_targets.bak_20261115_0152.csv.
- asis_live_proof_answers.py 09:03: 런처 몫 3,254 = 정답 있음 2,393 · 런처 제외 424 · 실행·관찰 없음 196 · 미실행(실저장 경로) 155 · 미실행(사용자 결정) 41 · 검사기 결함 후보 27 · 도달 불가 10 · 관찰 대상 없음 8. 이전 판 백업 _proof_live_answers.bak_20261116_0720.csv.
- 신규 tools/AsisLive/asis_live_proof_join.py → Doc/asislive/_proof_live_join.csv 09:04: 정답 있음 2,393 중 행 단위 판정 177(경로 메시지 61 · 차등 검증 인자 87 · 팝업·셀 이벤트 호출 29), 화면 단위 판정 2,216(11종. 그 화면에 같은 종류 실행 1건 이상만 확인. 원장 행별 근거 아님). 해결 방식별: 정적 220 · 정적 우선 1,504 · 동적 1,530.
- 한계: 정답 있음 = AS-IS 관찰 있음. TO-BE 대조 전이라 증명됨 증가 0. 원장 행은 만들지 않음.
- 다음: 정적·정적 우선 1,724건을 원문 대조로 판정(런처 대상에서 빼기) → 행 단위 177건 TO-BE 대조 → 동적 화면 단위 907건 행 연결.

## 2026-11-16 09:12 덧붙임 (사용자 지시: SSP0020·SCP0104 2화면 먼저 · 미검증 0 · CheckList)
- 계획·원인 표 Doc/verify/_TWO_SCREENS_PLAN.md. 원장 실측: SSP0020 1,398행(ERROR 294 · 판정필요 12 · FAIL 16) · SCP0104 3,248행(ERROR 1,319 · 판정필요 16 · FAIL 58).
- SSP0020 조회 0행 원인(09:08 TO-BE 조회): SSP_MST_DELEGATE 766행, 검증 계정 minyonglee1 행은 VALID_YN 전부 N. P_GET_DELEGATE 는 VALID_YN='Y' AND USER_ID 조건 → 0행. 원장 ERROR 120건이 이 원인.

## 2026-11-16 09:40 덧붙임 (SSP0020 미검증 0 작업 1차: 전수 작업 목록 · SP 짝 등록)
- Doc/verify/SSP0020/_two_screens_worklist.csv 410행(ERROR 294 · 판정필요 12 · FAIL 16 · 근거칸 빈 NA 88)에 원인·해결 방식·조치 기입. 원인별: 폼 저장형 화면 경로 115 · 시험 데이터 74 · 집계 행 67 · 해당없음 근거 보강 51 · 검사기 실행 경로 33 · SP 짝 19 · 대조표 서술 10 · 미분류 10 · 콤보 읽기 8 · 사용자 판정 7 · 팝업 7 · 스냅샷 승인 4 · 읽기 전용 확정 2 · 허위 FAIL 2 · 화면 오류 1.
- tools/Harness/rules/sp_pair.csv SSP0020 4행 수동 등록(source=manual, 백업 .bak_20261116_ssp0020): GET_DELEGATE·SAVE_DELEGATE·SAVE_UNSET → PKG_SSP0020 동명, UP_FX_GetSSPUserUseInfoList → P_USER_CHECK. 근거 ALL_ARGUMENTS 09:2x 실측 + __asis-mapping__.md §4. 차등 검증 재실행은 아직 안 함.
- 허위 FAIL 확인 2건(원문): T-a82deb6b G6 Division 초기값. AS-IS SSP0020_Delegate.cs:176 chkAll.CheckState=Checked → 전체 선택이 초기값, TO-BE 전체 선택과 같음. T-78284f60 G6 Delegatee 초기값 양쪽 빈값인데 불일치 판정. 검사기 수정 대상.
- 화면 구조(Delegate.tsx 전문 확인): 그리드 2개 읽기 전용, 저장 = 조회영역 입력(Division·Period·Delegatee) + Save, 해제 = 행 선택 + UnSet. 그리드 셀 편집 기준 검사(E4·F1~F8 등 115행)는 이 화면에서 측정 경로가 없음 → 폼 저장형 경로 필요.
- CHK: AS-IS 는 CHK 컬럼+머리글 체크(cs:216~218), TO-BE 는 행 선택기(useCheckbox). SSP0003 은 CHK 컬럼 표시로 PASS. 사용자 판정 대기.

## 2026-11-16 09:55 덧붙임 (CR-104 행 선택용 CHK 컬럼 ↔ 행 머리 선택기 = TO-BE 룰)
- 사용자 판정 09:4x '룰로 인정'. confirmed_requirements.csv CR-104 추가(백업 .bak_20261116_cr104) · tobe_rule_kind.csv · tobe_rule_registry --build.
- Doc/e2e/specs/_trace.spec.ts A5 COL 분기: 컬럼 CHK 가 AS-IS 표시·TO-BE 미표시일 때 화면의 input.wj-column-selector(보이는 것) 1개 이상이면 PASS([CR-104]), 0개면 FAIL 유지. 화면 실측 전(선택자 근거 = @mescius/wijmo.grid.selector 소스 문자열 + 공용 DataGrid useCheckbox). 재실행 때 확인.
- judge.py O2 구간: col == 'CHK' 는 판정필요로 낮추지 않음(백업 .bak_20261116_cr104).
- engine_selfcheck 결과는 아래 줄.
- engine_selfcheck 09:5x: PASS(full 23.9초 · 신규 0).
- 폼 저장형 경로 설계(다음 작업): _trace.spec.ts W3(738~) 는 조회 0행이면 E4 전부 '조회 0행' 으로 끝내고, 위반 입력을 그리드 셀에만 넣는다. SSP0020 E4 45행(메시지 17종 × ASIS·TRACE)은 조회영역 입력 기준. 계획: 화면별 Doc/verify/<ID>/form_scenarios.json(근거 = AS-IS guard 원문 행·대조표 1절) + 스펙의 공용 실행기(조회영역 값 설정 → 버튼 → 알림 문구 대조, 위반 건은 SAVE 요청 차단, 정상 저장 1건으로 위임 행 생성 후 끝에 UnSet). 미구현.

## 2026-11-16 09:30 덧붙임 (CR-105 차등 검증 판정 기준 · 사용자 지시: 중간 질문 금지)
- 사용자 결정 '그렇게 판정': diff_rule_map.csv verdict_map 변경(백업 .bak_20261116_cr105). KEYSET ROWS_ONLY·ASIS_ONLY·TOBE_ONLY → NA, VALUES DIFF·ROWS_ONLY → NA, COLSET COLS → FAIL, ORDER DIFF → FAIL. diff_ingest.py 가 NA 에 [CR-105] 근거 문구를 붙임(백업 .bak_20261116_cr105). confirmed_requirements.csv CR-105(TOBE_DEV) · 룰 원장 재생성. engine_selfcheck 09:28 PASS.
- 영향: 룰 파일이 공용이라 다음 판정부터 전 화면에 적용. CR-101 의 판정필요 부분과 차등 검증 정렬 판정필요를 대체.
- 사용자 지시 09:3x: 중간에 질문하지 말고 권장안으로 끝까지 진행, 판단은 모아서 완료 후 일괄 질의. 판단 목록 Doc/verify/_TWO_SCREENS_DECISIONS.md.

## 2026-11-16 09:45 덧붙임 (폼 저장형 화면 경로 구현 · SSP0020 입력 검증 59행)
- 신규 tools/E2E/lib/formscen.ts(조회영역 입력 + 버튼 시나리오 실행기 · 결과 누적 · 원장 행 연결) · Doc/e2e/specs/_formfix.spec.ts(@formsetup 검증용 행 저장 · @formteardown 해제 + 합산 기록) · Doc/verify/SSP0020/form_scenarios.json 19건(동적 10 · 도달 불가 3 · 오류 분기 6. 근거 = SSP0020_Delegate.cs 원문 행 + TB_FX_MessageInfo 문구).
- _trace.spec.ts 'W4 E4 업무 검증 메시지': form_scenarios.json 이 있으면 phase 없는 시나리오를 저장·해제 요청 차단 상태로 실행하고 E4 TRACE·ASIS 행에 합산 결과를 적음. 걸린 행은 종전 그리드 셀 위반 경로에서 뺌.
- run_verify.py: E2E 앞 @formsetup, finally 에서 @formteardown(백업 .bak_20261116_formfix). 결과 폴더는 본 E2E 와 분리(formfix).
- 단독 시험 09:39~09:43(결과는 임시 파일, 공식 e2e_results.json 미변경): 준비 F09 PASS(13행 저장) → 검증 8건 중 PASS 7 · FAIL 1 → 정리 F13 PASS(그리드 0행). TO-BE SSP_MST_DELEGATE minyonglee1: 시험 전 N 67 · Y 0 → 3회 시험 뒤 Y 0(매회 13행 생성·해제).
- 화면 오류 1건 확인: MSG00219(From > To) TO-BE SCM_ADM_MSG_M 에 행 없음(09:3x 조회 0행) → 화면에 영문 기본 문구 'The start date can not be later than the end date.' 표시. AS-IS 문구 '시작일자가 종료일자보다 늦을 수 없습니다.'.
- 원문 근거 도달 불가 3건: MSG00298(cs:372) · MSG00296(cs:440) · MSG00297(cs:454). 사유는 form_scenarios.json basis.
- 정적 모의: E4 TRACE·ASIS 59행 중 시나리오 연결 53, 나머지 6행은 AS-IS 메시지 문장 없음(e4None) 해당없음. ERROR·판정필요 0(실행 확인은 재실행 때).
- engine_selfcheck 09:3x PASS.

## 2026-11-16 10:00 덧붙임 (검사기 결함 2종 · SCP0104 SP 짝 · SSP0020 재실행 시작)
- _trace.spec.ts G6: ① AS-IS 초기값이 빈 문자열이면 TO-BE 빈값과 같음으로 판정(T-78284f60) ② 다중 선택 칸 '첫 항목 +N' 에서 1+N = 후보 수면 전체 선택(T-a82deb6b · AS-IS cs:176 chkAll Checked).
- authprobe.ts divState: 입력칸 클릭으로 목록이 안 열리면 열기 버튼(aria-label Open)으로 다시 연다(백업 .bak_20261116_divopen). 진단 실측 09:5x SSP0020 minyonglee1 후보 14개(전체 선택 항목 포함) 읽힘. 종전 0개 → EG365·EG366 ERROR 원인.
- sp_pair.csv SCP0104 13건 수동 등록(AS-IS sys.procedures 17개 ↔ TO-BE PKG_SCP0104 15개 이름 일치 실측, 백업 .bak_20261116_scp0104).
- engine_selfcheck 09:5x PASS. SSP0020 run_verify 전체 재실행 시작(백그라운드).
- 재개 정보: Doc/verify/_TWO_SCREENS_PLAN.md '진행 기록'.

## 2026-11-16 09:50 덧붙임 (폼 저장형 정리 안전장치 · 재실행 계정)
- run_verify SSP0020 재실행 계정 = jinhuannj(테스트 모드 single, 로그 rv_SSP0020_run1.log). 단독 시험 계정은 minyonglee1. 09:48 조회: jinhuannj 는 SSP_MST_DELEGATE 행 0건(위임·수임 모두).
- 정리 시나리오 F13 을 '전체 행 선택'에서 '검증용 행만 선택'으로 변경: formscen.ts checkrows(조건 = DELEGATEE_ID·FROM_DATE·TO_DATE) · countRows · matchAfter. 준비 가드도 검증용 행 기준. 계정에 실제 위임 행이 있어도 건드리지 않음.
- 단독 시험 09:49~09:50(minyonglee1, 결과 파일 분리 FORM_SCEN_RESULTS): 준비 13건 생성 → 정리 뒤 조건 행 0건.
- 시각 정정: 앞 덧붙임의 '09:5x' 표기 중 SSP0020 재실행 시작은 로그 기준 09:4x(정확한 시작 시각은 rv_SSP0020_run1.log 첫 줄).

## 2026-11-16 10:30 덧붙임 (SSP0020 재실행 1회차 결과 · 수동 짝 인자 행)
- run_verify SSP0020 09:48~10:17(30.5분 · rc 0). 원장 1,398 → 1,434행: PASS 206 → 309 · FAIL 16 → 32 · ERROR 294 → 198 · 판정필요 12 → 6 · NA 870 → 889. 폼 저장형 준비 09:50:34 13건 저장 · 정리 10:14:31 해제 rc 0 · 합산 기록 53행.
- 신규 tools/Harness/verify/gen_param_map_manual.py: sp_pair source=manual 짝의 param_map 행 생성(이름 정규화 일치만 MANUAL_OK). 실행: 17짝 213행 추가, 미해결 0. 원인 = 수동 짝 인자 행이 없어 diff_verify 가 AS-IS SP 를 인자 없이 호출('expects parameter @p_user_id').
- 남은 분류와 처리 순서: Doc/verify/_TWO_SCREENS_PLAN.md 'SSP0020 재실행 1회차 결과'.

## 2026-11-16 10:45 덧붙임 (잠금 사실 규칙: 조회 후 범위 잠금)
- facts_lockrules.py build_exp(백업 .bak_20261116_searchlock): 조회 결과 바인딩(GRID_BIND)과 같은 메서드·guard 의 컬럼 범위 잠금(ALL 아님)이고 EditButton 경로에 SwitchLock 이 없으면 그 컬럼의 기존행 기대 = 잠금. 행 선택용 CHK 는 제외.
- SSP0020 edit_expect.csv: 7컬럼 existing_row Y → N(근거 FindData_Main:294·307). 종전 D1 FAIL 8행 '기존행 편집=false (AS-IS 편집 가능)' 과 D3 '조건 계산 불가 RAW(Rows.Count > 0)' 의 원인.
- 영향 실측(27화면 edit_expect 재생성 비교): SSP0003 1화면 54컬럼 변화. SSP0003 파일은 종전 값으로 되돌림(그 화면 재실행 때 다시 생성됨 · 원문 확인 대상으로 판단 목록 6번).

## 2026-11-16 10:35 덧붙임 (SSP0020 판정 재적용 · 저장 측면 연결 · 읽기 전용 그리드 · FE 재기동)
- 판정 재적용(run_verify --skip-e2e 10:26~10:27, 1.4분): PASS 322 · FAIL 13 · ERROR 178 · 판정필요 15 · NA 907(1,435행). D1 허위 FAIL 8 → 미검증(재실행 대기) · A4·G1 → NA.
- formscen.ts: 저장 측면(single·noerror·noconfirm·time·loading·reflect·count·audit) 측정 + coverRows(화면 규칙 RULE_SCREEN 행 ↔ 시나리오 covers). _formfix teardown 이 합산 기록. form_scenarios.json F09·F13 에 checks·covers 추가(F1·F2·F4·F6 화면 · F8 저장 감사 필드 · H10 저장 취소 요청 없음 · H11 저장 중 로딩 · L1 저장 응답 시간).
- 단독 시험 10:3x(minyonglee1, 결과 파일 분리): F09 PASS(저장 요청 1건 · 지연 1500ms 동안 로딩 표시 보임 · 문구 13건 = 생긴 행 13건 · 감사 칸 13/13) · F13 PASS(문구까지 340ms) → 화면 규칙 8행 PASS.
- judge.py: 읽기 전용 그리드 판별(edit_expect 전 컬럼 N · 신규행 NONE) → 검사기가 편집 가능한 칸·Insert 버튼이 없어 못 잰 행은 NA(근거 = 잠금 원문 행). @form 결과는 건드리지 않음.
- FE 개발 서버(5173)가 10:30 에 내려가 있었음(원인 미확인 · 내가 종료한 것 아님). 메모의 표준 명령(vite.cmd --port 5173 --host 127.0.0.1)으로 10:31 재기동(백그라운드 b8wm71k9h) · 10:31:47 HTTP 200.
- engine_selfcheck PASS.

## 2026-11-16 11:15 덧붙임 (SSP0020 2회차 결과 · 판정 규칙 4종 · 정적 판정 구조)
- run_verify SSP0020 2회차 10:3x~11:0x(rc 0): PASS 338 · FAIL 7 · ERROR 143 · 판정필요 15 · NA 932(1,435행). 폼 저장형 준비·정리 rc 0, 합산 기록 61행, 정리 뒤 오늘 기간 유효 위임 행 0(TO-BE 조회).
- diff_ingest.py: 차등 검증 SKIP 사유가 kind=SAVE 면 NA(저장 SP 는 조회 결과 대조 대상 아님).
- asis_live_rows.py: AS-IS 조회 SP 입력 인자가 전부 세션·언어류면 건수 차이를 판정 제외(NA). eg_ingest.py 가 NA 를 받음. 대상 EG-52f23308('TO-BE 에 데이터가 없음' 허위 FAIL · AS-IS 실구동 계정 ≠ TO-BE 시험 계정).
- golden_cases.csv SSP0020 4건 tobe_proc 수동 지정(백업 .bak_20261116_ssp0020).
- judge.py NO_SEARCH_ARG: 'EG### Div 선택' 화면 규칙 행도 대상 아님(Div 가 조회 인자가 아닌 화면).
- judge.py 정적 판정: Doc/verify/<ID>/static_verdicts.csv(row_id·result·basis·fail_override·by·at) 반영, 표시 '[정적 판정]'. 사용자 판정과 별개. 판단 목록 7번.
- 진단 실측 11:0x: Division 후보 읽기 hoseoknam ['82'] · jinhuannj ['40'] · kijung03.kim(SSP Viewer)은 진입 시 '권한을 가진 Division이 없습니다' 알림, 후보 0.
- engine_selfcheck PASS.

## 2026-11-16 11:30 덧붙임 (SSP0020 남은 행 원문 대조 · 동작 시나리오 · 팝업 검사기)
- 판정 재적용 11:10~11:12: PASS 339 · FAIL 6 · ERROR 129 · 판정필요 15 · NA 948(1,437행). 집계 행 아닌 남은 행 103건 목록 Doc/verify/SSP0020/_left_rows.csv.
- Doc/verify/SSP0020/static_verdicts.csv 63행 작성(PASS 31 · NA 32, 생성 스크립트 scratchpad sv_ssp0020.py): Delegated List 편집 불가 7 · 잠금 조건 2 · 대조표 구현 위치 5 · 공통 UC 2 · 버튼 4 · 정렬 9 · 계정 의존 조회 4 · 저장 SP 골든 3 · 타 화면 결함 유형 대상 없음 12 · 권한 3 · 폭 1 · 저장 연계·감사·행 수 6 · 그 밖 5. 근거는 AS-IS·TO-BE 원문 행과 11-16 DB·화면 실측.
- formscen.ts: 단계 tab·expectButton·selectAllToggle, 기대 불일치는 FAIL 로 집계, 측면 pass, covers 를 TRACE·ASIS 행에도 적용. form_scenarios.json 21건(B01 시트 탭 전환 · B02 머리글 전체 선택 추가, F09·F13·F02 에 F4 covers).
- 단독 시험 11:1x: B01 PASS · B02 PASS · X-ROW 2행 · F4 4행 PASS.
- eg_popup.spec.ts openPopup: 이름 관례 밖 메서드(UserPopup)는 actions_entries.csv 의 depth 1 버튼 Click 진입점으로 버튼 → 조회영역 팝업형 칸 아이콘 순서로 연다. 단독 실행 11:2x: 사용자 찾기 팝업 열림 · 제목 'User Popup' · 버튼 Search·OK·Close · No. 칸 있음 · 조건 인자 전달 PASS · 건수 표시 없음 FAIL(COUNT) · ↓ 키 행 이동 없음 FAIL(GRID_KEYS) · 필터 UI 조작 시간 초과 ERROR(GRID_FILTER) · 병합 판정필요(MERGE).
- authprobe.ts divState: 후보 0개면 대화상자를 닫고 1.5초 뒤 재시도.
- engine_selfcheck PASS.

## 2026-11-16 11:34 덧붙임 (사용자 재부팅 · 3회차 중지 · 정리)
- 사용자가 PC 재부팅을 알림. SSP0020 3회차 재실행(백그라운드 bjc5dsfov)을 테스트 20건째에서 TaskStop 으로 중지. 남은 run_verify·playwright 프로세스 0(Get-CimInstance 확인).
- runlock release verify SSP0020 · slot 0~3. @formteardown 단독 실행 11:33(결과 파일은 scratchpad): F13 PASS · 정리 뒤 그리드 0행. TO-BE 조회 11:33: 오늘 기간 위임 행 minyonglee1 N 130 · Y 0, 검증 계정 유효 행 0.
- 원장은 11:12 판정 재적용 값 그대로(3회차 미반영). 재개 절차: Doc/verify/_TWO_SCREENS_PLAN.md '재부팅 뒤 재개 절차'.
- FE 개발 서버(백그라운드 b8wm71k9h)는 재부팅으로 종료됨. 재개 때 다시 기동 필요.

## 2026-11-16 11:47 덧붙임 (재부팅 뒤 재개 · 서버 기동)
- 재부팅 뒤 FE 5173·BE 8080 모두 꺼져 있었음. FE = vite.cmd 표준 명령 기동(11:4x HTTP 200).
- BE = 표준 명령은 compileJava 실패(SsoService.java 가 com.initech.eam 패키지를 참조, build.gradle 의 SSO jar 6줄은 주석 — 11-12 BE 공통소스 반영 뒤 상태). 메모(reference_repo_upload_download_commands 46행)의 절차 `gradlew.bat bootRun --offline -I ..	ools\CommonSynce_sso.init.gradle --args="--spring.profiles.active=local"` 로 11:46:24 기동(Started ScpApplication 67.6초).
- cmd 에서 gradlew.bat 을 현재 폴더에서 찾지 못함('not recognized') → .\gradlew.bat 로 경로 명시.
- TO-BE 검증 계정 유효 위임 행 0건(11:38 조회).

## 2026-11-16 12:55 덧붙임 (SSP0020 3회차 결과 · smoke · 팝업 시나리오 · 계정 언어 복원)
- run_verify SSP0020 3회차 11:47~12:2x(rc 0): PASS 430 · FAIL 13 · ERROR 36 · 판정필요 10 · NA 979(1,468행). 정적 판정 반영 45행. 준비·정리 rc 0, 검증 계정 유효 위임 행 0.
- nscm.ts setDivision(백업 .bak_20261116_setdiv): 라벨이 Div·Div.·Division 인 칸의 콤보를 먼저 찾고 다중 선택 칸은 비운 뒤 선택. 종전은 '보이는 첫 콤보'(SSP0020 에서 날짜 입력칸)를 눌러 smoke 3건이 20초 시간 초과. smoke 재실행 12:29~12:31: 3건 중 공통 기능 PASS, 나머지 2건은 조회조건 All(체크박스)·Period 동작(이 화면 조회 인자 아님).
- 판정 재적용 12:4x: PASS 433 · FAIL 13 · ERROR 33 · 판정필요 10. G3·SC1·K-SA 가 smoke 반입으로 해소.
- formscen.ts: asis_text_alt(다른 언어 문구 대조 · 한자 유지) · 팝업 단계(fieldButton·expectDialogInput·dialogPickFirst·expectField). form_scenarios.json 22건(P01 Delegatee 찾기 팝업 · covers M4·G5). 단독 시험 12:4x P01 PASS.
- golden_cases.csv UP_FX_GetSSPUserUseInfoList 인자 = 화면 실전송값(Search jiangguoping · Language KO · UseYN Y). 종전 기본값 UseYN '' 로 AS-IS 0행 ↔ TO-BE 7,281행 FAIL(V-1caff776).
- static_verdicts.csv 67행(+4: SAVE_UNSET ELSE 분기 도달 불가 NA · 팝업 병합 PASS · 팝업 표준 H6 PASS · 팝업 No.·건수 K3 PASS).
- 정정: 11:3x 보고의 '팝업 건수 표시 없음·↓ 키 행 이동 없음 = 오류 후보'는 틀림. 원장에서 TO-BE 룰 CR-100 으로 PASS(EG-ca88cc3a · EG-d64810bf). 단독 실행 결과 파일만 보고 룰 원장을 확인하지 않았음.
- 계정 설정 사고·복원: minyonglee1 SCM_ADM_USER_M.LANG_CD 가 CN 으로 남아 있었음(12:5x 조회). 재부팅 전 3회차를 TaskStop 으로 끊을 때 언어 전환 검사가 원복 전에 끊긴 것으로 판단되나 확인은 못 함(로그 미확인). 12:5x UPDATE 1행으로 KO 복원. 다른 검증 계정 5개는 변경 흔적 없음(값만 조회).
- engine_selfcheck PASS.

## 2026-11-16 13:25 덧붙임 (SSP0020 4회차 결과 · 5회차 전 보완)
- run_verify SSP0020 4회차 12:5x~13:1x(rc 0): PASS 451 · FAIL 2 · ERROR 27 · 판정필요 10 · NA 978(1,468행). 정리 뒤 유효 위임 행 0 · 계정 언어 minyonglee1 KO 유지(언어 복원 보완 뒤 첫 전체 실행).
- 결함 수정(내가 만든 것): formscen.ts 다른 언어 문구 대조(asis_text_alt)가 KO 화면에서도 적용돼 MSG00219 영문 기본 문구가 AS-IS En 문구와 맞아 PASS 로 가려짐 → 머리글 언어가 KOR 이 아닐 때만 대체 문구 대조. 5회차에서 MSG00219 가 FAIL 로 돌아오는지 확인 대상.
- form_scenarios.json 24건: F09b(다음 날 기간으로 2회차 저장 · 그리드 26행) · F13b(그 행만 해제). 방향키 반복 이동 검사(disp2.ts judgeKeyTrend)가 20회 이상을 요구하는데 13행이라 12회만 측정됐음.
- judge.py 조회 인자 없음 대상에 'EG### CR-070 공통버튼 Div' · 'Division 컬럼 <Div>/<시트>' 화면 규칙 행 추가.
- static_verdicts.csv 69행(+2: G03-WIRE 이벤트 6건 연결 PASS · P_USER_CHECK 골든 표시 PASS).
- 미해결: 사용자 찾기 팝업 필터 편집기 조작 시간 초과(EG-153fcc99). 진단 13:1x: 첫 컬럼 필터 아이콘은 편집기가 열리고 Apply·Cancel·Clear 버튼이 보임 · 두 번째 컬럼 아이콘은 편집기가 잡히지 않음. 원인 미확인.
- engine_selfcheck PASS.

## 2026-11-16 14:35 덧붙임 (SSP0020 5·6회차 · 집계 행 · 7회차 시작)
- 5회차 13:14~13:38(24.0분): PASS 444 · FAIL 6 · ERROR 25 · 판정필요 9. MSG00219 FAIL 복귀(대체 문구 대조를 KO 화면에서 끔). F09b 가 준비 가드(첫날 행 존재)에 걸려 건너뜀 → _formfix.spec.ts 가드 기준을 시나리오별 matchAfter.where 로 수정.
- 6회차 13:4x~14:0x(rc 0): PASS 452 · FAIL 6 · ERROR 17 · 판정필요 10. F09b·F13b PASS(26행) · 방향키 누적 지연 해소 · 정리 뒤 유효 위임 행 0 · minyonglee1 언어 KO.
- mapping_trace.py(백업 .bak_20261116_staticverdict): ev_ledger 가 static_verdicts.csv 를 TRACE 행에 먼저 입히고, main 은 '[정적 판정]'·'[사용자판정]' 행의 판정을 그 요소의 다른 증거보다 우선. 종전엔 원장 행만 바뀌고 행·진입점 집계는 예전 REVIEW·ERROR 를 계속 셈.
- judge.py 정적 판정: row_id 가 're:' 로 시작하면 '출처|규칙|대상' 정규식(호출 번호가 바뀌는 AD- 행용).
- static_verdicts.csv 74행. 판정 재적용 14:2x: PASS 464 · FAIL 6 · ERROR 15 · 판정필요 0(1,47x행). 남은 개별: 화면 오류 4(MSG00219 3 · Valid 라벨 1) · 스냅샷 승인 대기 6 · 팝업 필터 조작 1 · 주소 직접 접근 1. 나머지는 집계 행.
- 판단 목록 9~13번 추가(All 체크박스 → 선택 칸 전체 선택 · 해제 SP 분기 · 주소 직접 접근 · 스냅샷 · 팝업 필터).
- engine_selfcheck PASS. 7회차 전체 재실행 시작.

## 2026-11-16 15:20 덧붙임 (SSP0020 7회차 · CheckList v21 · SCP0104 착수)
- run_verify SSP0020 7회차 14:3x~15:01(rc 0): PASS 467 · FAIL 6 · ERROR 12 · 판정필요 0 · NA 988(1,473행). CheckList 생성 Doc/CheckList/SSP0020_Delegate_CheckList_v21.xlsx · ActionItemList_v21.xlsx(15:01). 정리 뒤 유효 위임 행 0 · minyonglee1 언어 KO.
- SSP0020 남은 것: 화면 오류 4행(MSG00219 3 · Valid 라벨 1)+집계 2 · 스냅샷 승인 대기 6 · 팝업 필터 조작 1 · 주소 직접 접근 1 · 집계 4(H5 3요소 ERROR:2 표기 3행은 mapping_trace_instances.csv 에서는 PASS — 원장 집계 행이 따라오지 않는 원인 미확인 · SpdMain_TopChange 는 H4 스냅샷 종속).
- smoke-extra.ts(백업 .bak_20261116_sheetnav): sheetNav(화면별 Doc/verify/<ID>/sheet_nav.json) + clickSheetTab 이 조회조건 값 → 탭 순서로 이동. _verify.spec.ts 그리드 컬럼 프로브는 시트 이동 사실이 있으면 첫 시트에도 적용.
- SCP0104 진단 15:1x(minyonglee1, 조회만): ASSEMBLY 전환·608행 · SOP_ASSEMBLY 전환·0행 · ELTR 전환·275행 · SOP_ELTR 전환·0행 · LINE(팝업) 전환 불가. 진단 6.5분.
- engine_selfcheck PASS. SCP0104 1회차 전체 재실행 시작(재실행 전 원장 사본 scratchpad SCP0104_ledger_before_20261116.csv).

- 정정(11-16 15:14 · date 실측): 위 덧붙임의 CheckList 경로는 Doc/UI_CHECKLIST/SSP0020_Delegate_CheckList_v21.xlsx · ActionItemList_v21.xlsx 임(Doc/CheckList 는 11-16 폐지). 덧붙임 제목 시각 15:20 은 실측값 아님. SCP0104 1회차는 15:13:41 정적 단계 종료, 15:13 E2E 단계 진입(rv_SCP0104_run1.log).

## 2026-11-16 16:57 덧붙임 (SCP0104 1회차 결과 · 검사기 보완 · 2회차 시작)
- run_verify SCP0104 1회차 15:11~16:33(rc 0 · 81.8분): 3,308행 PASS 854 · FAIL 60 · ERROR 1,248 · 판정필요 16 · NA 1,130(실행 전 3,248행 ERROR 1,319). CheckList v4 생성(Doc/UI_CHECKLIST). 직접 미검증 823행을 463유형으로 분류 → Doc/verify/SCP0104/_left_rows_run1.csv.
- 원인 실측: ① SOP 데이터는 Division 81_HG·81_ST 에만 있는데 81·40 으로 조회(0행) ② SOP Insert 는 선택 팝업(P02)을 열고 OK 로 행 추가 ③ LINE·SOP_MODEL_* 는 팝업 안 그리드 ④ Line Assign 셀 더블클릭이 CAPA Line Search 팝업을 열어 편집·Save 가 막힘 ⑤ edit_expect.csv 가 ELTR 1시트뿐이고 기존행 UNKNOWN.
- 보완(백업 .bak_20261116_scp0104p1 · ledger.py.bak_20261116_eemanual): nscm.ts navFact·dismissDblPopup·pickFromInsertPopup(중복이면 팝업 조건 다른 후보로 재시도) · saveprobe.ts typeRaw · smoke-extra.ts openSheetPopup · _verify.spec.ts 팝업 시트 분기 · sheet_nav.json(SOP Div 81_HG · popup base/open · cell_dblclick_popup) · ledger.py edit_expect_manual.csv(139행) 우선. engine_selfcheck PASS(16:55).
- 따로 실행 확인: LINE 팝업 그리드 126행 측정 · SOP_ASSEMBLY·SOP_ELTR Insert 뒤 신규 행 6건. 2회차 전체 재실행 16:5x 시작(rv_SCP0104_run2.log). 실행 전 행 수: LINE_SOP 52 · ELTR_LINE_SOP 12 · LINE_ASSIGN 52,925 · ELTR_LINE_ASSIGN 22,359 · LINE_MDL 1,909 · ELTR_LINE_MDL 796.

## 2026-11-16 17:12 덧붙임 (조치 필요 중복 — K3 조작 항목 · 연결 판정 · 조회조건 후보 대조)
- 사용자 지적(SCP0104 v4 조치 필요에 Hide 3건): V-6af7fe19(화면 행) · V-79b744aa(결함 일반화 DM-P26) · V-5d83a36f(DM-P28)가 같은 실측 'hide FAIL: 헤더(DIVISION_ID) 우클릭 → Hide Column → 컬럼 여전히 표시' 1회를 각자 적음. 묶음 키가 (규칙, 대상, 증거 앞 120자)라 대상·앞머리가 달라 안 묶임. make_verify_docs.py _core_key 에 K3 전용 키(실패한 조작 항목 집합 · 대상 무관) 추가. 1회차 원장 3행이 같은 키로 묶이는 것 확인 · engine_selfcheck PASS(17:10).
- judge.py 연결 판정(static_verdicts.csv result = LINK + link 정규식) 추가 · run_verify.py 추적표 재계산·반입을 원장이 안 바뀔 때까지 최대 3회 · _snap.spec.ts 헤더 스냅샷이 탭·팝업 시트도 돎 · eg_popup.spec.ts 필터 시험 컬럼 = 값 종류가 가장 적은 컬럼 · popupprobe.ts Apply 대기 20초.
- SCP0104 static_verdicts.csv 57행: AS-IS 잠금 문장 연결 18 · 대상 없음 9 · 조회조건 10개 × B3·B4·G7 30행(PASS 28 · FAIL 2 — Plant B4: 전극 모드 SHOP_GROUP_ID 필터 없음으로 MI03 추가 표시 / Line Type B4: 코드 '-' 후보 누락 · 근거 Doc/verify/SCP0104/_search_cond_static_20261116.csv · ScpCapaBL.cs:201·370~401 · useCapaLineCascade.ts:145·266 원문 직접 확인).

## 2026-11-16 18:15 덧붙임 (SCP0104 2회차 결과 · 저장 시험 잔여 · 남은 유형)
- run_verify SCP0104 2회차 16:55~18:01(rc 0): 3,296행 PASS 1,183 · FAIL 47 · ERROR 889 · 판정필요 19 · NA 1,158(1회차 PASS 854 · FAIL 60 · ERROR 1,248). 직접 미검증 365행 259유형 → Doc/verify/SCP0104/_left_rows_run2.csv · 집계 524행. 원장 사본 scratchpad SCP0104_ledger_run2.csv.
- 저장 시험 잔여: restore_touched rc=1(ORA-01555 · undo_retention 900초 · 저장 17:19~17:24 · 복원 18:00). 시험 계정이 바꾼 행 = SCP_MST_CAPA_ELTR_LINE_ASSIGN 29행(Div 81 · DMY_3801 · APCAN2364C · E2000 · 202611~2031) + SCP_MST_CAPA_ELTR_LINE_MDL 1행. 값 대조(18:1x): ASSIGN_PRIORITY·LANE_QTY·VALID_YN 이 저장 직전 기록(touched_rows.done.json 17:18:31)·BAK20260927·CUTF 202609 와 같음(2031 = 0). 남은 차이 = LAST_UPDATED_BY·LAST_UPDATE_DATE(minyonglee1 · 11-16 17:19~17:24). 감사 칸 원래 값은 미확인(09-27 백업 뒤 변경 여부를 알 수 없음) → 되돌리지 않고 결정 목록 19번에 올림. 테이블 행 수는 실행 전과 같음.
- 보완 과제: ① 복원을 flashback 대신 저장 직전 DB 행 사본으로(undo 15분 한계) ② '컬럼별 저장 왕복' Y_2031 값 불일치 1 뒤 중단(빈값·0값·2행 저장 3행 미검증) ③ mapping_trace D1 이 edit_expect_manual 미사용(9행) ④ 팝업 M4·G5·H6 67행 ⑤ 진입점 시나리오 필요 X-ROW 53행 ⑥ 연쇄 C2·C6 36행 ⑦ X-LOC 18행 ⑧ Insert 뒤 신규 행 없음 E3 18행 ⑨ Div 40 조회 0행 A5 21행.

## 2026-11-16 18:45 덧붙임 (Hide Column 허위 FAIL = 검사기 결함 · 2회차 뒤 보완)
- Hide Column 'DIVISION_ID 컬럼 여전히 표시' FAIL 3행(SCP0104 v4·2회차)은 검사기 오판. 공용 그리드는 필수 컬럼(_requiredMark · INPUT_TP_CD M/IM)의 Hide Column 을 비활성으로 둔다(packages/shared/src/components/organisms/data-grid/gridContextMenu.ts:226~234 · 321~325). 비활성 항목은 disabled 속성 없이 글자색 #b0b0b0 · cursor default 로만 표시(:124~126). 검사기 K3 hide 단계가 첫 컬럼(Div* = 필수)의 비활성 항목을 누르고 '안 숨겨짐'으로 적음. 화면 재현(18:3x): DIVISION_ID 숨김 안 됨 · LINE_NAME·VALID_YN 숨김 됨.
- 보완: _verify.spec.ts K3 hide 단계 — 항목이 비활성이면 그 컬럼은 숨김 금지로 적고 숨길 수 있는 다음 컬럼으로 시험. 따로 실행(18:4x) 결과 hide PASS(헤더 SITE_NAME · 필수 DIVISION_ID,SITE_ID 비활성 기록). 첫 컬럼이 필수인 다른 화면의 K3 hide FAIL 도 같은 오판 후보(해당 화면 재실행 때 확인).
- 그 밖 2회차 뒤 보완: 필수 공란 검사(E3) 시트 이동 뒤 재조회 · Division 컬럼(A5) 검사 시트 이동 뒤 Division 재지정·재조회·팝업 시트 열기. engine_selfcheck PASS(18:4x).
- 원문 대조 조사 4건 진행 중(진입점 53 · 대조표 요약 20 · 연쇄·편집 92 · 팝업 79 → Doc/verify/SCP0104/_static_out_*.csv). SSP0020 8회차 18:2x 시작(rv_SSP0020_run8.log).

## 2026-11-16 18:30 덧붙임 (SCP0104 원문 대조 조사 4건 반영 · 화면 재현 2건)
- 조사 산출물 Doc/verify/SCP0104/_static_out_{doc,popup,entry,cascade}.csv(20·79·53·92행) → static_verdicts.csv 294행(PASS 177 · NA 57 · FAIL 45 · LINK 15). 보류(미판정): T-5490cd8f · T-ef832529 · T-724f3211 · T-a8e20ad5 · V-2d7e7ee0 · V-572595d7 · T-228fc738.
- 조사 FAIL 근거를 직접 확인한 것: Item 팝업 OK 버튼·다건 분기(SCM0002_CAPAItemPopup.cs:344~397 · SCP0104_CAPA_Line_Assign.cs:5713~5733) · 팝업 조건 전달(cs:5953~5975 · SCP0104_CAPA_Line.cs:405~437 ↔ CapaLineModal.tsx:123~126) · 셀 콤보 필터(ScpCapaBL.cs GetFilterDummyFactory·GetFilterDummyLine ↔ gridCombos.ts:51·130~151) · 붙여넣기 처리기(CapaLineAssignGrid.tsx:209~218 pastingCell = 잠금 검사만).
- 화면 재현(18:25 · 저장 요청 미전송 모드): ① 신규 행 SITE_ID 칸 F2 → Esc 또는 Enter(값 변경 없음) → COMPANY_ID~LINE_NAME 8칸 빈 값(CapaLineAssignGrid.tsx:184~195 cellEditEnded 가 변경 여부를 보지 않고 clearSubCodes) ② 신규 행 NICK_NAME 칸에 목록 밖 명칭 입력 → 값 미반영(DataMap isEditable false · 후보 3,891건) → Dummy 코드 채번 경로 미도달.
- 결정 목록 20~24 추가. SSP0020 8회차 진행 중(18:25 E2E 70번째). 끝나면 SCP0104 3회차 시작.

- 정정(18:26 · date 실측): 위 덧붙임 제목의 '18:15'·'18:45' 와 결정 목록 19~24번 일시('18:1x'·'19:0x'·'19:2x')는 실측 시각이 아님. 실측 근거: SCP0104 2회차 종료 18:01:35(작업 출력) · 화면 재현 진단 시작 18:24:41 · 이 정정 18:26. 그 사이 작업 순서는 본문 순서와 같음.

## 2026-11-16 18:41 덧붙임 (SSP0020 8회차 · SCP0104 3회차 시작 · 저장 전 스냅샷)
- run_verify SSP0020 8회차 18:05~18:37(rc 0): 1,473행 PASS 468 · FAIL 6 · ERROR 9 · 판정필요 1 · NA 989(7회차 ERROR 12). 해소: 집계 3행(추적표 재계산 반복) · 헤더 Delegated List 측정됨(승인 대기로 바뀜). 남은 ERROR 9 = 스냅샷 승인 대기 6 · SpdMain_TopChange 집계 1(스냅샷 종속) · 직접 접근 EG-f6eeda7b 1 · 팝업 필터 EG-153fcc99 1. 새 판정필요 1 = V-9e99f124 '저장 중 로딩'(시험 검사 CM-003 FAIL 승격 전). 계정 언어 minyonglee1 KO.
- 팝업 필터 EG-153fcc99 진단(18:4x): DEPT_NM 값 1,593종 · Select All 해제 뒤 둘째 값 체크 칸 클릭 10초 초과 → 체크 0개 → Apply 비활성. popupprobe.ts filterByF4 에 '체크 0개면 보이는 값의 체크 칸을 요소 클릭' 추가 · engine_selfcheck PASS(18:40). 확인은 다음 SSP0020 실행.
- SCP0104 3회차 18:38 시작(rv_SCP0104_run3.log). 저장 시험 전 값 보관: Doc/verify/SCP0104/applied/_pre_run3_snapshot_20261116.pkl(18:38:35 · 테이블 8개 전 행 · rowid 포함) — restore_touched 가 ORA-01555 로 실패하면 이 파일과 대조해 시험 계정 변경 행을 되돌린다.

## 2026-11-16 19:52 덧붙임 (SCP0104 3회차 결과 · A5 허위 FAIL 원인 · 재실행 시작)
- run_verify SCP0104 3회차 18:38~19:45(rc 0): 3,312행 PASS 1,579 · FAIL 232 · ERROR 226 · 판정필요 44 · NA 1,231(2회차 ERROR 889). FAIL 232 내역: 집계 130 · 실측 48 · 정적 판정 24 · 규칙 상속 30. CheckList v6 생성.
- 저장 시험 흔적: 2회차와 같은 행(ELTR_LINE_ASSIGN 29 · ELTR_LINE_MDL 1)의 LAST_UPDATE_DATE 만 다시 바뀜(저장 전 보관본 _pre_run3_snapshot 대조 · 다른 칸 차이 0 · 새 행 0). restore_touched rc=1(ORA-01555 반복). 결정 19번 대상과 같은 행.
- 'Division 컬럼(A5)' 15행 FAIL 은 검사기 결함: TO-BE 메타를 시트 구분 없이 컬럼 이름으로만 찾아 다른 시트(SOP_MODEL_* COMPANY_ID 등 VISIBLE N) 값이 덮음. _verify.spec.ts byCol 을 이 시트 메타로 제한 → 따로 실행(19:5x) 21행 PASS. 남은 문제: SOP 시트 증거 문구 '개인화로 뺀 것'은 틀린 사유 — 실제는 TO-BE 코드가 AS-IS 조회 상태대로 8컬럼 숨김(capaLineAssignColumns.ts:143~148 · AS-IS EditButton SOP 분기에 SetVisibleSheetColumns 없음 cs:4080~4093 확인 · minyonglee1 SOP 개인화 22컬럼 전부 포함). 판정 결과는 같음, 사유 문구 보완 대상.
- SSP0020 9회차 → SCP0104 4회차 연속 실행 시작(19:52).

## 2026-11-16 22:3x 덧붙임 (SSP0020 9회차 · SCP0104 4회차 결과 · 검사기 결함 4종 수정)
- SSP0020 9회차 19:51~20:24(rc 0 · 32.5분): 1,473행 PASS 467 · FAIL 8 · ERROR 8 · 판정필요 1 · NA 989. 팝업 필터(EG-153fcc99)가 측정되어 FAIL(필터 적용 뒤 행 8,612 → 8,612 · 건수 문구 빈칸). 화면 결함·검사기 결함 구분 미확인.
- SCP0104 4회차 20:24~21:36(rc 0 · 71.7분): 3,312행 PASS 1,593 · FAIL 218 · ERROR 226 · 판정필요 44 · NA 1,231. 3회차 대비 FAIL→PASS 16(A5 Division 검사기 수정분) · PASS→FAIL 2(F1 V-24aa4bc5 · F2 V-ea2314b3 = ORA-01840).
- ORA-01840 = TO-BE 저장 SP 결함 후보(결정 25번): PKG_SCP0104 P_SCP0106_CHK_LOSS_ASGN_ELTR(3113~3120)·_ASM(1796~1797)·P_SCP0105_CHK_SPEED_ASGN_ELTR(429) 가 바뀐 행 0건이면 V_VERSION NULL 로 TO_DATE(NULL||'01'). AS-IS 는 NULL+'01'=NULL 로 통과. BE 로그 ORA-01840 6회(월 값 전부 빈 저장 요청).
- 정적 판정 추가: T-d778907f fail_override Y(판정 단계 순서상 FAIL 상태에서 건너뛰던 것) · T-4cd7217e(ELTR 시트 Equipment Type AS-IS·TO-BE 폭 0 숨김). --skip-e2e 재판정 21:42~21:46: 판정필요 44 → 18 · PASS 1,619.
- 검사기 결함(_trace A5): AS-IS 기대(grid_effective)가 메타 폭 0 을 '기본'으로 둠 · TO-BE 메타를 컬럼 이름으로 찾아 다른 시트 값 사용 — 정적 판정으로 처리, 생성기(AsisFacts GridMerge.cs) 수정은 미착수.
- 검사기 결함(신규행 E3 대조군 21행 ERROR) 수정 _verify.spec.ts: ① 차단 문구가 라벨 대신 컬럼 ID('[COMPANY_ID] 값은 필수 입력 항목입니다.' · CapaLineAssign.tsx:549~553)라 컬럼을 못 찾음 → '[바인딩]' 인정 ② 셀 더블클릭 팝업이 고른 라인을 새 행으로 추가(AS-IS InsertAssignLine cs:2437~2476 · TO-BE handleLinePopupConfirm:703~744 같음)인데 현재 행 채우기로 가정 → 팝업 행을 대조군으로 채택하고 빈 Insert 행은 Delete ③ 채워진 칸에도 편집기를 열었다 닫아 하위 키 칸이 지워짐(결함 후보 9 재현) → 채워진 칸은 건너뜀 ④ 콤보 필수 칸을 팝업으로만 채우려 함 → 후보 값 입력. 단독 실행 22:26: ELTR 대조군 저장 요청까지 도달(저장은 시험이 가로챔).
- 22:4x 추가 검사기 결함 수정: ① master_sweep.py 기준정보 키 대조 범위 = 화면 PKG 문자열 상수(LOOKUP_TYPE 등) — 공용 기준표 전체 대조로 다른 화면 코드 65건이 SCP0104 N1 미검증이 되던 것(자기 시험 21/21 · SCP0104 재실행 PASS 5) ② eg_auth EG126 정렬 검사 F3 정렬 스위치 켠 뒤 재시도(CR-034) ③ eg_auth EG160 컬럼 설정 팝업 고정 컬럼 = 빨간 라벨(keyLabel · ColumnLayoutModal.tsx:398~404) — '*' 문구로 판별해 Div* 를 고정으로, Lane Number 등을 미표시로 잡던 것 ④ newrow.ts judgeRequired 연쇄 비움 차단 PASS(자기 시험 통과).
- SCP0104 스냅샷 9건 골든 승격(snap_approve --no-verdict · 승인자 검증엔진세션): 헤더 5건 대조 OK · SOP 헤더 2건(조회 상태 숨김 3컬럼 = AS-IS 와 같음) · 조회조건(순서만 차이 · CR-098) · 버튼(EDIT CR-084·093 / EXCEL AS-IS 에도 없음 / CHECK_NAME_ON_DUMMY_CODE 버튼 아님). 화면샷 2건 미승인 — 골든 후보(11-13 10:45)에 조회조건 라벨 '_Ver.'(LBL01275 기본 문구) 표시, 현재 화면 확인 뒤 판단.
- 정적 판정 추가: EG 버튼 권한 6행 PASS(SCP Tester 권한 데이터 AS-IS C·U·D = TO-BE INSERT·SAVE·DELETE·EDIT Y) · V-7e7c50fd NA(신규 행 Division = 양쪽 글자 입력 칸). 결정 27(상위 메뉴 Capa Plan 권한 ADMIN 만) · 28(CAPA Planner EDIT 권한 행 없음) 추가.
- 22:5x SSP0020 팝업 필터(EG-153fcc99) 원인 = 검사기 결함: 필터 편집기에 '전체 선택' 칸이 없어 '전체 해제'로 누른 칸이 첫 값이었음 → 적용 직전 1,592/1,592 전부 선택(ListBox checkedItems 실측) → 필터 무동작. popupprobe.ts filterByF4 가 ListBox checkedItems 를 값 1개로 맞추도록 수정 → 단독 실행 PASS(8,612→1→8,612행). EG-5f17da99(필터 후 건수 표시)는 AS-IS UserInfoPopup·TO-BE SsoUserModal 모두 건수 표시 요소 없음 → SSP0020 정적 판정 NA.
- SCP0104 정적 판정 추가: 컬럼 설정 목록 Model 행 8건 PASS(AS-IS SCM002_CAPAColumnPopup.cs:346~359 와 TO-BE COLUMN_SETTING_HIDDEN_COLUMNS 같은 9컬럼 숨김) · V-6f9e4547 PASS(같은 키 신규 행 = 양쪽 기존 행 갱신, AS-IS MERGE ↔ TO-BE UPDATE 후 INSERT).
- engine_selfcheck full PASS 22:58(JS 30·PY 42). SSP0020 10회차 → SCP0104 5회차 연속 재실행 시작 22:58.
- 23:2x~23:3x 정적·실행 대조 판정 추가(SCP0104 static_verdicts 332행): A6 정렬 2(PASS · Line Type 정렬 방식 차이는 결정 29) · MS1 MSG00109 PASS · E4 저장 후 문구 2 PASS · G1·G2·G8·G9 Material 4 FAIL(결정 30 ELTR 비교 컬럼 NICK_NAME · 결정 31 ASSEMBLY LIKE) · I3 NA · A7 GET_SPREAD_TITLE PASS(실행 대조 5건) · A7 CHECK_NAME_ON_DUMMY_CODE FAIL(결정 32 대소문자) · F7·F8 저장 감사·연계 3 PASS · 이력 2 NA · A1 ELTR 실전송 PASS(실행 대조 275행) · C1 Plan Month·Version 2 PASS. eg_popup 버튼 트리거 = 이름 접두 일치 추가(TO-BE 아이콘 버튼 'Column Setting').
- 정정: 이 세션 판정 근거·결정 목록에 시각을 '22:5x'(실제 22:4x · 8행)·'23:5x'·'23:59'·'11-17 00:0x'(실제 11-16 23:2x~23:3x · 9행)로 잘못 적어 23:38 에 고침(date 실측 23:37:21 기준).
- 23:5x~00:0x SSP0020 10회차 결과(22:58~23:23 · 24.2분): 팝업 필터 FAIL→PASS · 건수 표시 FAIL→NA. 스냅샷 5건 골든 승격(조회조건 All = Division 전체 선택 이동 · 버튼 USER_CHECK = 버튼 아님 · 팝업 · 화면샷 2) · 헤더 2건은 Valid 잔존(CR-092)이라 정적 판정 FAIL(결정 34). EG-f6eeda7b URL 직접 접근 정적 FAIL(결정 35) · T-a84c38dc NA(플래그 끄고 켜기 두 줄). 저장 중 로딩 판정필요(결정 36).
- 검사기 결함 수정 judge.py derive_evidence_ref: 정적 판정 FAIL 의 증거 경로 = static_verdicts.csv#행 — 증거 관문이 '[증거 부족: 증거 경로 없음]' ERROR 로 되돌리던 것(SCP0104 정적 FAIL 도 같은 원인). SSP0020 --skip-e2e 재판정 00:05: 1,473행 PASS 468 · FAIL 9 · ERROR 4(스냅샷 재대조 대기) · 판정필요 1 · NA 991.
- 00:4x 정정 기록: SCP Tester 계정(lucky-alex) 버튼 권한을 프로시저로 조회할 때 결과를 앞 12~14건만 잘라 출력해 INSERT·SAVE 가 없다고 잘못 볼 뻔함 — 전체 확인 결과 PR_GET_MNU_BTN_AUTH·_DIV(Div 40·81) 모두 INSERT·SAVE·DELETE·EDIT 포함(31행). 판정 변경 없음(버튼 비노출은 화면 미진입 · EG366).
- 00:3x~00:4x SCP0104 5회차(23:23~00:36 · 73.1분) 결과: 3,334행 PASS 1,729 · FAIL 233 · ERROR 105 · 판정필요 7 · NA 1,260(4회차 ERROR 226·판정필요 44). 추가 정적 판정 V-b4816525 PASS · T-228fc738 FAIL(결정 38) · V-cc74e5aa FAIL(결정 37) · V-6199b2ef PASS(저장 SP 248건 최대 2,395ms) · V-7a990e9c NA · V-7ca34c31 PASS · V-cc6cf8fa NA · 시나리오 H10 2·E2 1 NA. 검사기 수정: saveprobe 저장 DB 오류 뒤 중단하지 않음 · F6 숫자 칸 = 값이 숫자인 글자 칸 허용. 화면샷 후보(11-13 '_Ver.')는 낡아 .bak 로 보관 — 다음 회차가 새 후보 생성.
- 01:2x SSP0020 11회차(00:55~01:20 · 24.6분): 1,473행 PASS 470 · FAIL 11 · 미검증 0 · 판정필요 0 · NA 992. 저장 중 로딩 판정필요→PASS(10회차 0회 ↔ 11회차 보임 — 측정 흔들림 · 결정 36 정정) · 스냅샷 조회조건·버튼 PASS · 화면샷 2건 FAIL = 11-13 기준본이 그리드 0행 상태(배치 차이 없음) → 11회차 실측으로 기준본 교체·승인(snap_approve 실측본 탐색 위치에 Doc/verify/<ID>/e2e/artifacts 추가 — 검사 도구 결함 수정) · 팝업 크기 조절 PASS→NA(손잡이 없음 · 회차마다 다름). SSP0020 12회차 시작 01:2x(SCP0104 6회차와 동시).
- 02:3x SSP0020 12회차(01:22~02:00 · SCP0104 6회차와 동시 · 36.8분): 1,462행 PASS 466 · FAIL 9 · ERROR 2 · NA 985. 화면샷 2건 새 기준본과 일치 PASS · 남은 ERROR 2 = 언어 전환 KO·EN(다른 화면 동시 실행이라 검사기가 전환 생략 · T200).
- 02:3x SCP0104 6회차(00:55~02:31 · 71.1분): 3,334행 PASS 1,780 · FAIL 252 · ERROR 38 · 판정필요 7 · NA 1,257. 저장 세부 3건은 Y_2031 저장 실패(01:46:10 ORA-01840)를 검사기가 저장 오류로 못 잡아 다시 중단 → saveprobe saveReload 오류 조건에 '저장에 실패'·RESULT_CODE F 추가. 화면샷 새 후보(Ver. 정상) 승인. 추가 판정: V-912ca6bd NA(달력 편집기) · EG-b372f76e FAIL(SCP Planner 화면 진입 불가 = 결정 27 · 진단 02:3x: /view/home 잔류·조회조건 0) · T-5490cd8f PASS(isSopCellEditable). 검사기 수정 nscm.ts openScreen: Home 잔류를 진입 실패로.
- SSP0020 13회차(단독 · 언어 전환) → SCP0104 7회차 연속 실행 시작 02:38.
- 03:1x SSP0020 13회차(02:37~03:04 · 단독): 언어 전환 2건 PASS. 조회영역 접기 스위치가 첫 클릭 무반응(true→true→false · 스모크 재실행에서도 재현) → smoke-extra.ts 첫 클릭 무반응이면 대화상자 닫고 한 번 더(스위치 자체 무반응이면 그대로 결함) → 스모크 OK(true→false→true). --skip-e2e 재판정 03:13: SSP0020 1,473행 PASS 473 · FAIL 9 · 미검증 0 · 판정필요 0 · NA 991.
- 04:5x SCP0104 7회차(03:04~04:18): 3,316행 PASS 1,770 · FAIL 253 · ERROR 27 · 판정필요 8. 판정기 수정 judge.py ① sort_review 가 정적 판정 FAIL 을 판정필요로 되돌리지 않게 ② 대조표 행 정적 판정 FAIL 기대 원천 = ASIS:정적 판정. 재판정 04:46 판정필요 6(새 AD 3건은 같은 시각 단독 저장 시험이 DMY_3801 행을 바꾸던 중 차등 검증이 돌아 생긴 오염).
- 저장 세부 검사기 결함 2건 수정(saveprobe.ts): 저장 실패 알림이 save() 반환 뒤에 떠 문구를 못 읽음(진단 called=true · msg='') → 재조회 전 2초 알림 읽기 · 0·빈값 대상 = 값이 숫자인 글자 칸 허용. 단독 실행 04:41~04:54: 컬럼별 왕복 FAIL(Y_2031) · 0 값 PASS · 빈 값 FAIL(Lane Number '' → ORA-01840 04:51:08) · 2행 PASS. 결정 25·37 정정(원인 추정 확정 아님) · 결정 40 추가.
- run_verify SCP0104 --only F1,F6 시작 04:5x(원장 병합).

- 11-17 05:43 SCP0104 재판정(--skip-e2e): judge.py 규칙 판정 상속을 연결 판정(LINK) 뒤 재계산(INHERIT_RECALC 1 · V-09495773 ERROR → PASS). 결과 3,310행 PASS 1,772 · FAIL 316 · NA 1,221 · 판정필요 1 · 미검증 0. CheckList v18 생성. 일괄 질의 Doc/verify/_TWO_SCREENS_QUESTIONS.html 28문항 생성. selftest quick PASS.

- 11-17 07:56 사용자 일괄 질의 확정 반영: CR-106~108 등록(tobe_rule_registry --build · --check 0). H11 저장 로딩 검사 보완(_verify.spec.ts offsetParent → 크기·visibility·opacity + MutationObserver). SCP0104 단독 저장 경로 시험 07:47~07:49 → V-ab913b0f PASS(34회 관측). 재판정 07:49~07:56: 3,313행 PASS 1,774 · FAIL 316 · NA 1,223 · 판정필요 0 · 미검증 0. CheckList v19.

- 11-17 08:22 Q17 확정(요청 변경 인정): CR-109 등록. judge.py 규칙 상속이 이번 실행 정적 판정 행(tobe_ref 정적 판정)을 덮지 않게 수정(V-6a37ba39 FAIL → PASS · 다른 변화 0). 재판정 SCP0104 08:19: 3,314행 PASS 1,775 · FAIL 316 · NA 1,223 · 판정필요 0 · 미검증 0(CheckList v22). SSP0020 08:22: 1,475행 PASS 474 · FAIL 9 · NA 992 · 판정필요 0 · 미검증 0(CheckList v31) · 변화 = CR-106·107 확정 행 2개 NA 추가, T-9808d603 진입점 집계 NA → PASS(8검사 PASS 8).

- 11-17 09:20 사용자 지시(SSP0020 v31 조치 필요 3번 = 2번 중복 제거): make_verify_docs.py 조치 필요 묶음에 근거의 '같은 결함 <행 ID>' 참조 묶기 추가. SSP0020 v32 조치 필요 4 → 3(V-db5fae91 → V-d1f0e5dc 에 묶임). SCP0104 v23 조치 필요 51 → 51(변화 0). 판정 결과 변화 0.

- 11-17 11:49 SCP0104 사용자의견 반영 마감: DB 보완(PKG_SCP0104 10구간 09:44·09:47 · 메뉴 권한 7행 · 컬럼 정렬 3행 09:47) · 클라우드 패키지 SCP0104_USERFIX_CLOUD_20261117 · 전체 재검증 10:14~11:24 · 결과 3,339행 PASS 1,840 · FAIL 272 · NA 1,227 · 미검증 0 · 판정필요 0 · CheckList v27 조치 필요 14건(전부 FE) · 설명 = action_summary.csv(오류명·위치·AS-IS·TO-BE·GAP·묶음). 검사기 수정: A5 폭 0 · H8 공용 건수(CR-110 · 총 N건) · F1 불일치 앞 배치 · F6 원복 행 식별 실패 = ERROR · EG032 정렬 사실 선택 · eg 직접 접근 새 세션 · openScreen 주소 안정 대기. 시험 부작용: 화면 첫 진입 시 TITLESET_USER 87행 자동 생성(lucky-alex · zhangjiali) → 삭제 261행(백업 logs/titleset_autocreated_deleted.json). 데이터 잔존(보관본 11-16 18:38 대비) 값 변경 0 · 새 행 0.
  - 정정: 칸 설정 삭제 261행 중 백업 파일에 든 것은 10:08 생성분 174행. 11:31 재측정 때 생긴 87행(lucky-alex)은 백업 없이 삭제(그 시험이 만든 행).

## 2026-11-17 20:20 덧붙임 (SCP0111 미검증 250 → 0 착수 · 사용자 지시)
- 사용자(11-17 20:1x): "CheckList 생성 시 미검증 0 이어야 함 · CheckList 로직 보완 · SCP0111 미검증 제거".
- 기준: CheckList v30(run_verify 19:02~19:52) 미검증(ERROR) 250 = 원 오류 128 + 집계·상속 122. 분류표 Doc/verify/SCP0111/_unverified_250.csv.
- 원 오류 분류: F 기계 판정 불가 26(D1 조건부 잠금 GROUP 조건 11) · E 검사기 미실행 23 · B 연쇄 원천 해석 불가 22 · A 대조표 구현 위치 없음 20 · G 측정 경로·코드 없음 10 · J 기타 10(계정 명부 3 포함) · C 스냅샷 승인 전 6 · D 전제 미충족·측정 중단 6 · H 확인 대상 5.
- 순서: C 스냅샷 대조·승인 → A 대조표 구현 위치 → F/D1 GROUP 조건 계산 → B 연쇄 원천 → D 전제·저장 행 식별 → E·G 검사기 연결 → H 판정 → 재판정(--skip-e2e) → 전체 재실행 1회.
- 사용자 결정 필요(완료 후 일괄 질의): 비관리자·권한 없는 계정 명부 등록(J3·J4·A6).
- 2026-11-17 20:34 SCP0111 미검증 보완 1차(재판정 전 · 화면 재실행 없음):
  - C 스냅샷 6: snap_validate 버튼 대조 결함 수정(EXCEL = SubTitle 아이콘 버튼 · EDIT = CR-084·093 · SAVEDETAIL = 대조표 Save 매핑일 때만) · SCP0111 6건 골든 승격(--no-verdict · 검증엔진세션 · 화면샷 SEQ_FLAG·MEASURE 보임 = AS-IS 편집 모드 표시 cs:1064). 회귀: SCP0104 버튼 행 누락 목록만 줄어듦 · SSP0020 변화 0.
  - CheckList 흐름: run_verify post 에 snap_expect·snap_validate 연결(세부 31 → 33 · 백업 run_verify.py.bak_20261117_snapchain).
  - A 대조표 구현 위치 20: mapping_trace X-LOC 에 코드 식별자 실재 확인(loc_by_identifier · hotkeyConfig 키 · '(제거)' · 공용 Excel) → SCP0111 X-LOC 20/20 PASS. SCP0104 X-LOC 92 PASS · 16 NA(일반 단어 근거 제외 뒤).
  - F/D1 조건부 잠금 11: _trace.spec judgeD1 이 RULES 형식(facts_lockrules v2)을 condeval.evalRules 로 계산(계정 그룹·Div·행 값) · tsc 0 · 백업 _trace.spec.ts.bak_20261117_d1rules · 다음 E2E 에서 확인.
  - 발견: C2·C3·C6 '연쇄 원천 해석 불가' 22 중 ITEM_ID·CELL_CF·SEQ_FLAG·MEASURE·TO_PRODUCT·VALUE_TYPE 는 AS-IS _defaultDataModel_Changed(cs:1945~) 가 읽기만 함(값 대입 없음) → 연쇄 대상 아님 판정 근거 있음 · 미수정.
  - 병행: 20:27 다른 세션 run_verify SSP0020 --only D1,H2,E4 실행 중 — 공용 엔진 파일(_trace.spec.ts 등) 추가 수정은 그 실행 종료 뒤.
- 2026-11-17 21:14 SCP0111 보완 2차 + 전체 재실행 시작:
  - mapping_trace.py: AS-IS 컬럼 상수 'DefColumns.' 고정 19곳 → 'Def[A-Z]\w*.'(Def* 클래스 전부 · SCP0111 = DefMain). SCP0111 인스턴스 +6(C3 2·E4 2·D3 1·D1 1) · SCP0104·SSP0020 변화 0. 백업 mapping_trace.py.bak_20261117_defcls.
  - C2·C6 noAssign(이 컬럼에 값·후보를 쓰는 AS-IS 문장 없음 = 읽기만): ITEM_ID·CELL_CF·TO_PRODUCT·VALUE_TYPE·SEQ_FLAG·MEASURE 12 → 검사 엔진 NA(근거 원문 _defaultDataModel_Changed cs:1945~). C2 원천 보강: 같은 메서드에서 읽은 행 값(LINE_ID ← PLANT_ID·OPERATION_GROUP·COMPANY_ID · spdMain_CellClick cs:1770~1790). _trace.spec C2·C6 noAssign 처리 · tsc 0.
  - 21:1x run_verify SCP0111 전체 실행 시작(로그 scratchpad scp0111_run1.log) — 결과로 3차 범위 결정.
- 2026-11-17 22:10 SCP0111 v31 결과(21:14:45~22:07:25 · 52.1분): 1,871행 PASS 739 · FAIL 51 · 판정필요 8 · 미검증 171(v30 250) · NA 902. 원 오류 128 → 74(A 구현 위치 0 · C 스냅샷 0 · B 연쇄 22 → 1) · 집계 상속 97. 분류 Doc/verify/SCP0111/_unverified_v31.csv.
  - 회귀 오라클 위반 5(_regress_report.md): D1 BOH_QTY·월 칸 '놓친 결함(FAIL)' 기대 ↔ 실측 PASS(_verify.spec judgeCond · 그룹 ADMIN 기준 편집 가능) — 10-30 사용자 지적 이후 해소 여부 판정 필요(결정 목록) · F1·F4·G3 는 저장·조건 저장 경로 미측정(ERROR)·PASS.
  - 3차 보완: _trace.spec judgeD1 RULES 조건이 원장 JSON 에서 400자로 잘려(mapping_trace editExpect [:400]) 옛 분기로 빠지던 것 → 원천 edit_expect.csv 전문 복원(fullCond) · tsc 0.
  - 계정: gen-e2e.js users.json screens[<메뉴>].extra(화면별 추가 계정) 지원 · SCP0111 extra = lucky-alex(사용자 지정 · SCP Tester · 메뉴 접근 Y · 기대 버튼 SEARCH·EXCEL) → plan 계정 2(jooyong026·lucky-alex). 백업 users.json.bak_20261117_extra.
  - 남은 원 오류 74: E 검사기 미실행 23(DB-SYN 5 · A7 golden 3 · G1·G2·G5 조회조건 6 · H2 2 · 기타) · F 기계 판정 불가 18 · G 측정 경로 없음 16(저장 시험 '편집 가능 셀 없음' 6 포함) · J 7 · D 5 · H 4 · B 1.
  - 결정 필요: ① D1 BOH_QTY·월 칸 회귀 오라클(놓친 결함) 해소 인정 여부 ② J4 권한 없는(GUEST 전용) 계정 · A6 Titleset 보유·미보유 계정 쌍(lucky-alex 는 SCP0111 권한 있음 — J4 대상 아님) ③ H4 헤더 글자 잘림 5칸(SCP0016 선례: 오류 아님·판정필요) ④ K4 Delete 버튼 노출(AS-IS 버튼 목록 Search·Insert·Save).
- 2026-11-17 22:39 SCP0111 4주기 보완(재실행 전):
  - 저장 시험 묶음: 'Insert 버튼 비활성' 문구 = 실제 원인 cleanup_spec SCP0111 mode=editonly(_verify.spec:966) · 수정 저장 경로 '편집 가능 셀 24개 시도 — 값이 바뀌는 셀 없음' 원인 조사 중(읽기 전용 조사 에이전트).
  - DB-SYN 5: mapping_trace 에 API 등록 ID → proc_meta api_id → 프로시저 시노님 결과(P_SCP0111_GET·SAVE·SAVE_ADMIN PASS) · sp_pair 수동 짝 SCP0111_SAVE_INTEGRATION_PSI_ADMIN ↔ PKG_SCP0111.P_SCP0111_SAVE_PSI_ADMIN(cs:1379) PASS · DM0003_GET_BUCKET_TYPE_CODE = TO-BE 대응 없음(AS-IS dtBucketType 미사용 cs:244·62) NA. SCP0104·SSP0020 변화 0. 백업 sp_pair.csv.bak_20261117_scp0111.
  - A7 golden 3: golden_cases.csv SCP0111 수동 지정(메인 조회 인자 = AS-IS 런처 실측 11-17 19:01:58 Div 81·20260817·202608~202701 · ESS Pack Line tobe_proc · ADMIN 저장 짝) → 22:37 golden: 메인 1712↔1712 공통 1708 DIFF · ESS 32↔50(TO-BE 전용 82 남경 피플웍스 18행) DIFF = 데이터 차이(CR-101 판정필요) · judge.py A7: 짝 표 'TO-BE 대응 없음' = NA. 백업 golden_cases.csv.bak_20261117_scp0111.
  - A6 주석 코드: facts_sortrules.py C# 파일에 SQL 용 주석 제거(-- 만)를 쓰던 결함 → C# 주석 제거(facts_combosrc) · SCP0111 1행(cs:214)·SCP0104 5행(cs:1397~1449 //DBUtils.Sort) 제거 · SSP0020 0. 백업 facts_sortrules.py.bak_20261117_cscomment.
- 2026-11-17 22:48 저장 시험 조사 결과(읽기 전용 조사 에이전트 · TO-BE SELECT 만 · 22:46 조회):
  - edit-save '24셀 값 변화 없음' = 검사기 결함: 고정 칸 18개 폭 1415/1543px(92%) · Wijmo 고정 복제층 아래 DOM 셀을 nth 위치로 클릭 → 시간 초과(시험 271,016ms ≈ 후보 24 × 10s). 보완안 crud.ts edit-save 앞 probe.unfreezeIfNeeded · binding 기준 typeCell.
  - 저장 세부 'BOH 47→48 재조회 빈 값' = TO-BE 저장 결함(FE_GUIDE_20261117_1759.md G1 미반영): 21:33:26 P_SCP0111_SAVE_PSI_ADMIN(LOG_SEQ 6414880) 이 202610 행 QTY 47→1 · BOH 47→48 로 덮음(22:05~22:10 restore_touched 원복 · AS OF 확인). 가이드 '반영 전 ADMIN 저장 시험 금지' 를 v31 실행이 어김.
  - 검사기 결함 2 추가: saveprobe.ts:108 행 식별 실패 시 재조회 값 '' 를 판독값처럼 기록 · db_snapshot.py:33~37 OPERATION_GROUP 표시명(Pack)을 코드(P) 대신 WHERE 에 넣어 0행 → '변화 0' 허위.
  - 조치: 저장 경로 검사기 3건 보완은 FE G1 반영 뒤 저장 시험과 함께. 이번 전체 재실행은 VERIFY_NO_SAVE=1(저장 요청 가짜 응답 · 사내 DB 미기록) — 저장 행은 '[저장 미실행]' 미검증으로 남음.
  - 22:48 run_verify SCP0111 전체(VERIFY_NO_SAVE=1) 시작 · 로그 scratchpad scp0111_run2.log.
- 2026-11-17 23:37 SCP0111 v32(22:48~23:32 · VERIFY_NO_SAVE=1 · 43.8분) 미검증 159 · 재판정 v33(23:33~23:36 · --skip-e2e) 미검증 155 · FAIL 55 · 원 오류 61(_unverified_v33.csv).
  - 반영 확인: D1 대부분 PASS(ITEM_ID 신규행 FAIL) · DB-SYN 전부 PASS/NA · A7 PASS 2·NA 1 · J3 lucky-alex 등 그룹별 편집 실측(BOH 불일치 FAIL).
  - 사용자 지시(23:3x): 'FE 는 수정 대상 아님 — 오류는 오류로 표기하고 가이드만'. 저장 정적 판정 static_verdicts.csv 6행(F1·F6 FAIL 4 · F4·F6 PASS 2 · 근거 LOG_SEQ 6414880 + AS OF 21:40 직접 재조회) · judge.py 정적 판정 적용 시 실행 측정 전제(mctx rows -1)를 정적 판정 참조로 교체(증거 관문이 FAIL 을 ERROR 로 되돌리던 것).
  - 남은 원 오류 61: 실저장 필요 약 15(FE G1 반영 전 ADMIN 실저장 금지 — 측정 불가) · Period 칸 찾기 4 · 팝업 SCM0002 6 · LINE_ID 연쇄 2 · 조회조건 G2·G5 3 · 계정(J4 GUEST · A6 Titleset 쌍) 2 · 판정 기준 결정 필요(H4 글자 잘림 · K4 Delete · A2 FCA · F5 · D1 Div) 등.
- 2026-11-17 23:39 사용자 지시 '실제 저장도 동작': SCP0111 ADMIN 실저장 시험 허용(FE_GUIDE G1 '반영 전 ADMIN 저장 시험 금지' 를 이번 실행에 한해 사용자가 해제). 실행 중 사내 행이 저장 결함으로 일시 변경 → 체인 끝 restore_touched 원복 · 끝난 뒤 원복 여부 직접 확인.
  - 저장 경로 검사기 보완 3: crud.ts edit-save 앞 고정 폭 85% 초과 시 고정 해제(마지막 칸 기준 unfreezeIfNeeded) · saveprobe.ts 재조회 행 식별 ≠1 이면 got='(판독 안 함)' + 후보 행 값 기록 · db_snapshot.py 키 조회 0행 = skipped(사유: 표시값↔DB 코드). tsc 0 · py_compile OK.
  - run_verify SCP0111 전체(실저장) 시작 · 로그 scratchpad scp0111_run3.log.
- 2026-11-18 00:26 SCP0111 v34(실저장 · 23:39:40~00:24:31 · 44.3분): 미검증 153 · FAIL 55 · 판정필요 14. 수정 저장 경로 첫 성공(F2 저장 메시지 PASS · F4 SQL 오류 없음 PASS · 고정 18칸 해제 노트 확인). 저장 호출 2(23:49:31 · 23:51:52 P_SCP0111_SAVE_PSI_ADMIN). restore_touched 2행 원복 · 00:24 조회 SCP_ANL_PSI_INTEGRATION 23:39 이후 수정 행 0.
  - 보완: db_snapshot 0행이면 키 하나씩 빼고 재조회(표시값≠코드 키 제외 · dropped_keys 기록 · 시험 OPERATION_GROUP=Pack → 13행) · saveprobe 재조회 행 식별 2건 이상 = 그 칸만 판독 불가·다음 칸 계속(0건만 중단). tsc 0. 이어서 실저장 전체 재실행.
- 2026-11-18 01:11 SCP0111 v35(실저장 · 00:26:12~01:10:34): 미검증 152 · FAIL 55 · 판정필요 14. 저장 호출 4 · restore_touched 3행 원복 · 01:10 조회 00:26 이후 수정 행 0.
  - F8 수정 감사 컬럼 판정됨 · DB 스냅샷 비교 동작(변경 1). 남은 저장 미검증 7: 빈값·0값·2행(202610 원복 뒤 행 0건 = ADMIN 저장 결함으로 행 값 변경 → 중단) · F7 이력 표 없음 2 · F7 2회 저장 · F8 이력 행 값 · F7·F8 save_audit 미연결 2.
  - 판단: 남은 저장 행은 대부분 ADMIN 저장 결함(FE G1)의 결과로 측정이 끊김 — G1 반영 뒤 재측정이 정답 경로. 비저장 묶음(Period·팝업 SCM0002·LINE_ID·G2·G5·결정 필요)은 별도 주기.
- 2026-11-18 05:19 SCP0111 비저장 묶음 보완(재실행 전 · 단독 측정은 조회·Insert 만 · 저장 없음):
  - Period 칸 찾기: smoke-extra findCond 가 달력 전용 칸(입력칸 없음)에서 target null → 예외 → '칸을 찾지 못함' 허위 ERROR · 월 표시('2026-10') 읽기 실패 '초기 기간 빈값' 허위 FAIL → 수정. gen-e2e: 라벨 '~'(AS-IS cmbToMonth) = 기간 칸에 포함(제외 사유 기록).
  - G1 Period: _trace 기간 칸 실측 추가(periodShiftEnd: 끝 값 한 달 당김 → 요청 toYyyymm·결과 월 칸 범위 대조). 단독 확인 202703 → 202702 · 요청 toYyyymm 202702 · 월 칸 202610~202702. AS-IS MSG00344(기간 역전) = periodReverseTry(달력이 역전 입력 거부) · G2 Period = 단일 범위 NA.
  - G8/G9: 기간 칸에서 옆 Model 입력칸을 잡던 결함 수정(칸 종류 먼저) · 재료 값에서 센티널 '-'·'/' 제외(Cell Model G9 '-,ACEF…' 허위 FAIL).
  - G1 Model/Nickname·Cell Model: _trace 'NA(콤보 아님)' 가 _verify 텍스트 실측을 덮던 결함 수정. judge: 텍스트 다중 칸 G2 ← 같은 칸 G9 실측 상속.
  - G5: popup_args_check host_label(함수 인자로 넘긴 onItemSearch · 모달 파일 안 setter 만) 보완 → Model/Nickname 연결(SCP0104·SSP0020 popup_args 변화 0). Cell Model = TO-BE 팝업 없음 · AS-IS btnCellItem_Id 이벤트 등록 주석(cs:361) → NA.
  - H2 SetBGColor2: facts_lockrules 에 color_rules.csv(조건부 배경색 · 가드 정규형 · DBUtils.Filter 존재 검사 → EXISTS) · condeval EXISTS · _trace 'H2 조건부 배경색' 시험 신설(조건 만족 계정·Division 선택 → 값 있는 기간 칸 편집색 대조). 단독 확인 V-48220ccc PASS(lucky-alex · Div 82 · 1,281행 중 93행) · V-51c1bd06 PASS(53행 · 직접 센 53행과 일치). bg_style_check SetBGColor2 누락 수정.
  - C3 LINE_ID: mapping_trace — 화면 전체에서 값 대입 문장 없음(후보 설정·읽기만) → noAssign NA(근거 원문 5건). C2 LINE_ID: 원천 값이 다른 기존 행에서 Insert → 원천 입력 → 후보 비교(신규행은 표식으로 식별) → PASS(MI00/Pack 15 · WA00/Pack 64 · WA00/Cell 37).
- 2026-11-18 06:33 SCP0111 v36(실저장 전체 · 05:43:07~06:32 · 49.0분): 미검증 95(v35 152) · FAIL 59 · 판정필요 15 · PASS 804 · NA 902. restore_touched 3행 원복 · 06:33 조회 SCP_ANL_PSI_INTEGRATION 05:43 이후 수정 0행 · 생성 0행. 원 행 목록 Doc/verify/SCP0111/_unverified_v36.csv.
  - 새 FAIL 후보: ESS Pack Line SP 진입 미호출(AS-IS Form_Load cs:178 · TO-BE IntegrationPsi.tsx:499 essPackLineRows={[]} · SP 직접 실행 50행 오류 0) — FE 가이드 대상.
  - 결함 발견·수정(06:3x): 새 D3 계정 전환 시험이 동적 월 칸을 펼치지 않아 ASIS D3 10행 '조건 만족 0' ERROR → 월 칸 펼침·COL(SELF) 대입. judge G5 host 라벨 '/' 포함 전체 비교 누락. facts_auth insertStmts 에 프레임워크 siMain.Insert() 포함(EG126). python 치환으로 들어간 백스페이스 문자(\b) 2곳 정정(eg_auth.spec · facts_auth.py).
  - 결정 목록 Doc/verify/SCP0111/_decisions_20261118.md(판정 기준 8 · 계정 3).
- 2026-11-18 07:02 SCP0111 eg_chain + --only D3,L1,E3,A2(06:45~07:02 · 실저장 · restore 3행 · 07:02 조회 06:34 이후 수정 0 · 생성 0): 미검증 83 · FAIL 68 · 판정필요 17.
  - 새 FAIL 검토: EG126 Insert 위치(신규행 r1259 · 선택 r2 · CR-015·CR-074 불일치) + 그 집계 8행 · ESS Pack Line 진입 미호출(T-236699af) · E3 빈 신규 행 저장 안내 'Operation 은 Pack / Cell / Electrode 중 하나로 입력하세요.' ↔ AS-IS MSG00001(SaveData:1237) · G4 스냅샷 Div 40(골든에 Period 빠짐 = 골든 생성 때 검사기 결함 → 07:05 재승인 --no-verdict).
  - Cell Model G9 FAIL 유지 근거: TO-BE PKG_SCP0111 BODY 301~302 단일 LIKE · AS-IS 도 단일 LIKE(같음) · 그러나 TO-BE 룰 CR-040(텍스트 조회조건 콤마 다중) + 기준표 '텍스트/다중' → FAIL(DB 보완 후보 · 정합검증 단계라 미보완).
  - 검사기 결함 수정: _verify 콤보 G1 시험이 텍스트 칸(Cell Model)에서 다른 칸 콤보를 잡아 판정필요를 쓰던 것 → 칸 종류 먼저 · judge G2←G9 상속 근거 형식 [V-…] (증거 경로 게이트).
  - 07:0x --only J2,G1,G2,G8,G9,F1,L1 실행(권한 auth·authcrud 포함 · 실저장).
- 2026-11-18 07:29 SCP0111 --only J2,G1,G2,G8,G9,F1,L1(07:05~07:28 · 실저장 restore 3행 · 07:29 조회 07:03 이후 수정 0 · 생성 0): 미검증 69 · FAIL 71 · 판정필요 17. G1 Model/Nickname·Cell Model PASS · G2 Model/Nickname PASS(G9 상속) · G2 Cell Model FAIL(CR-040) · G5 Model/Nickname PASS.
  - J2 미검증 유지: authcrud 마커 행 신규 저장이 화면 검증(Operation 필수)에 막힘 · 버튼 권한 기대 불일치 0 · cleanup_spec editonly 화면이라 신규 행 왕복 방식 부적합 — 검사기 확장 대상.
  - L1: 판정 코드가 저장 세부 시험 안에 있는데 그 시험 본문에 rule_id 비교가 없어 --only 가 고르지 못함 → 비교문 추가 · 07:3x --only L1 재실행.
- 2026-11-18 07:51 SCP0111 --only L1(07:41~07:51 · 실저장 restore 2행 · 07:51 조회 07:41 이후 수정 0 · 생성 0): 미검증 65 · FAIL 71 · 판정필요 17 · PASS 818 · NA 904. L1 PASS(저장 3회 105·93·108ms · 기준 3000ms) — 판정 코드를 저장 세부 시험 중단 지점(stopped return) 앞으로 옮김.
  - judge: 다른 화면 결함 유형 C2·C3·C6 행 중 대상 컬럼(영문 컬럼명)이 이 화면 그리드 COLUMN 행 106개에 하나도 없으면 NA(V-c0dd9dff Team·Owner · V-bad017f3 Team · V-c95a03b1 Team·End Customer·Energy).
  - 남은 원 행 40(Doc/verify/SCP0111/_unverified_v38.csv): K3 7·E6 1(일부 범위 실측) · 저장 F1/F6/F7/F8 8(ADMIN 저장 결함 G1 · 이력 표 없음) · D1 INCOTERMS T300 3 · J4 3·A6 Titleset·A1(계정) · F4 SAVE 일반 계정 경로 2 · G4 팝업 조건 구성 2·H4·K4·F5·A2·B4·MS1·I1(결정 목록) · J2 · E4 · D3 1 · A6 P_SCP0111_GET 정렬 · G03-WIRE.
- 2026-11-18 08:0x [공용 검사기 변경 알림] mapping_trace.py: 게이트 G03 'AS-IS 이벤트 … 매핑표 §2 에 없음' WARN → G03-WIRE FAIL(FE __asis-mapping__.md 이벤트 매핑 누락 · CLAUDE.md 절대 금지 ⑪). DMF0042 CHECK.md 에 G03 WARN 23건 — 다음 실행부터 G03-WIRE FAIL 로 나옴(백업 mapping_trace.py.bak_20261118_g03). judge.py: K3 '미포함' 항목을 eg 팝업·K1·동적 칸 정렬·붙여넣기 실측으로 보완 · API 별칭 TRACE 행 → 실제 프로시저 행 상속 · C2/C3/C6 결함 유형 대상 컬럼 부재 NA. _trace W4d INCOTERMS(TO_SITE_CODE PLANT/SALES) 분기는 TO_SITE_CODE 칸이 없고 edit_expect 규칙이 있는 화면에서 판정하지 않음.
- 2026-11-18 08:22 SCP0111 --only D1(08:00~08:12) + 재판정 2회(08:13 · 08:17 --skip-e2e): 미검증 49 · FAIL 72 · 판정필요 12 · PASS 835. 원 행 24(Doc/verify/SCP0111/_unverified_v43.csv).
  - 닫힘: K3 7(미포함 항목 eg 팝업·K1·동적 칸·붙여넣기 실측 연결) · A6 P_SCP0111_GET(API 별칭 상속) · D1 INCOTERMS 3(W4d SCP0007 분기 제외 + COLUMN ← TRACE D1 상속) · G03-WIRE FAIL(매핑 문서 이벤트 10개 누락 · FE 가이드 G4) · F7/F8 이력 2 NA(AS-IS 저장 SP 2개 쓰는 표 = SCP_ANL_PSI_INTEGRATION 뿐).
  - 남음: 결정·계정 14(_decisions_20261118.md) · 저장 결함 연동 6(F1·F6 2·F7 2회 저장·F7/F8 save_audit 2 — FE G1 반영 뒤) · 검사기 확장 4(J2 authcrud editonly · E4 필수 메타 없음 · D3 MULTI_CHILD_ITEM 공통 코드 · E6 IME 해석).
- 2026-11-18 09:06 SCP0111 검사기 확장 4건(사용자 지시 '검사기 확장 4건 이어서'):
  - D3 V-a8b7a10e: facts_lockrules 공통 코드 존재 검사(Data.Common(LookupCommon,"TYPE") 반복 비교 cs:622~642) → INLOOKUP(COL(ITEM_ID),"MULTI_CHILD_ITEM","NAME") · lookups.json(TO-BE LookupCommon 조건 SEGMENT2 · 2건) · condeval INLOOKUP + useScreenLookups. 다른 화면 edit_expect 변화 0(SCP0104·SSP0020·DMF0042).
  - E4 V-7039bfc6: 메타 필수 컬럼 없는 화면 = 기존 행 값을 신규 행 표시 칸에 그대로 입력(동적 기간 칸 제외) → Save(시험 route 가 서버 미전송) → judgeDup.
  - E6 V-148a468d: IME 항목 NA(CDP 모사 한계 · 사용자 2026-10-28) · '미포함'(붙여넣기) = K3 와 같은 실측 연결.
  - J2 V-7c5a2756: editonly 화면 — 권한 없는 계정 authcrud 실측(Save·Insert·Delete 비노출·편집기 안 열림) + 버튼 노출 기대 일치 + @verify 실저장 F2 PASS 결합. authcrud 허용 계정 수정 저장 강제(crud.ts)는 시험 계정이 달라 restore_touched 가 원복하지 못하고 ADMIN 저장 결함(G1)으로 원복 저장도 틀릴 수 있어 되돌림(백업 crud.ts.bak_20261118_editonly).
  - --only D3,E4 실행 시작(시각은 scp0111_only13.log 첫 줄).
- 2026-11-18 09:25 SCP0111 --only D3,E4(09:06~09:24 · restore 1행 · 09:25 조회 09:06 이후 수정 0 · 생성 0): 미검증 38 · FAIL 72 · 판정필요 14 · PASS 849. J2 PASS · D3 V-a8b7a10e PASS(INLOOKUP) · E6 PASS(IME NA + 붙여넣기 실측). E4 '[차단 사유 확인 필요] Model 값은 필수 입력 항목입니다.' — Model 은 팝업 전용 칸이라 값 복사에서 빠짐 → 필수 안내 칸 팝업·입력 후 재저장(최대 4회) 보완 · --only E4 재실행.
- 2026-11-18 09:48 [공용 검사기 변경 정정] mapping_trace.py G03 '매핑표 §2 에 없음' WARN: 08:0x 에 FAIL 로 바꾼 것을 사용자 판정(11-18 SCP0111 CheckList 의견 'TO BE RULE 로 오류 아님')으로 NA 로 정정 — DMF0042 도 FAIL 아님(NA). FE 가이드 G4 삭제.
- 2026-11-18 09:5x SCP0111 사용자의견 15건(CheckList v4x · _user_verdicts.csv 반입) 엔진 보완 — 사용자 지시 '오류아님 제외 · 판정 엔진 보완 · 중복 제거':
  - D1 ITEM_ID·NICK_NAME 3 · H2 같은 칸 2(오류 아님): 편집기 안 열려도 더블클릭 입력 팝업이 열리면 편집 가능(CR-072) — probe.popupOnDblclick · _trace judgeD1·W5 H2 · _verify D1·H2.
  - G9·G2 Cell Model 2('AS-IS 도 멀티선택 안됨'): judge — G9 FAIL 이라도 AS-IS 조회 SP 원문이 그 조건 파라미터를 나누지 않으면 PASS(AS-IS 동일) · 매칭 plan 칸 key ↔ @p_<이름> · SCP0111 @p_cellitem_id 단일 · @p_item_id·@p_nick_name split.
  - G03-WIRE 1(TO-BE RULE): mapping_trace G03 '매핑표 §2 에 없음' WARN → NA(08:0x FAIL 변경 정정) · FE 가이드 G4 삭제.
  - 스냅샷 4(Div 40·화면샷 2·팝업): snap.ts aria 그리드 데이터 행 접기(collapseGridRows) · '총 N건' 정규화 · _snap 화면샷 mask 에 .wj-colheaders(컬럼 폭 비율 제외) → 재촬영 뒤 골든 승인(사용자 의견).
  - 중복 제거(T-40ab485f): judge — 같은 화면 Insert 위치 FAIL(D6 TRACE·D6 시나리오·EG126 D4)을 '같은 결함 <시나리오 행>' 으로 묶음.
  - 확인 필요 2: V-daa3f0ba D6 = FAIL 유지(AS-IS SpreadInfo.Insert 활성 행 위치 · TO-BE 아래·끝 · CR-015) · V-2eed0400 E3 = FAIL 유지(AS-IS 빈 Operation 은 cs:1206 건너뛰고 cs:1237 MSG00001 · TO-BE Operation 무효 문구) → FE 가이드 G5.
  - E4 정적 판정 근거에 AS-IS MSG00260 화면 차단(cs:1226~1230) 추가.
- 2026-11-18 10:17 SCP0111 사용자 지시 '설명 형식'(저장 항목은 현재 유지): make_verify_docs _summary_text — 저장 외 행 = '[분류 / 유형 / 판정] 요약' + ' - AS-IS : ' · ' - TO-BE : ' · ' - GAP : '(위치·조치 줄 없음, 계정 차이는 GAP) · 저장 분류 행은 종전 형식. Doc/verify/SCP0111/action_summary.csv 신설(묶음 BOH_EDIT_PIADMIN 12행 · INSERT_POS 4행 · ESS_PACK_LINE · L2 재렌더 · E3 문구).
  - 10:08 --only D1,H2,H4,H6,G4(09:52~10:08 · restore 1행 · 10:09 조회 09:52 이후 수정 0 · 생성 0): D1 ITEM_ID·NICK_NAME 3·H2 2 = 엔진 보완만으로 PASS(더블클릭 'Material by Division' 팝업 · CR-072) · Div 40 스냅샷 PASS. 팝업·화면샷 3 골든 승인(사용자 의견 · snap_approve --force). 재판정 10:15: 미검증 37 · FAIL 51 · 판정필요 13.
  - BOH 편집 12행(SCM PI Admin · EG123/124/377/378 · Div 40·81): AS-IS cs:560~567·652 와 TO-BE integrationPsiEditLock.ts:24·140 모두 SCM PI Admin BOH 편집 허용인데 실측 편집 불가 — FAIL 유지(원인 미확인 · 계정 그룹 판정 경로 확인 필요).

- 2026-11-18 10:48 SCP0111 v50(--only H10 10:31~10:41): V-0184021b H10 FAIL → 해당없음(_verify.spec.ts 확인창 경로 판정: ADMIN 가드 else·action I 전용 확인창 제외, 공용 동작 변경 · 다른 화면 H10 도 같은 기준). 봉투 FAIL 40 · 판정필요 16 · 미검증 38. 판정필요 증가 1 = EG-b8d1f0aa B7 DATE_WEEKLY1_SCP_ALL 응답 23 ↔ DB 24(20261116): SCM_MST_PLAN 981116·991116 CREATED_BY CLONE_PLAN_VER 11-18 10:42:03 생성(이 세션 아님, 실행 중 데이터 변경) · 결함 아님 판정 대기. SCP_ANL_PSI_INTEGRATION 10:30 이후 변경 0.
- 2026-11-18 10:52 공용 변경(다른 세션 알림): 권한 검사 계정을 화면별로 지정하는 설정 추가. tools/E2E/users.json screens.<ID>.accounts {역할: 계정} 이 있으면 영역 명부 대신 그 계정만 씀(key SCR/<ID>/<역할>). 반영 파일 facts_auth.py(account_facts·btn_auth_div), facts_auth_combo.py(uid_of), lib/authprobe.ts(accountId). 설정 없는 화면은 기존과 같음. SCP0111 = SYSTEM ADMIN minyonglee1, SCM PI Admin dwhong1012, SCP Planner bottle(사용자 지정). 백업 *.bak_20261118_scracct.
- 2026-11-18 11:09 정정: 11-18 10:17 기록 'TO-BE integrationPsiEditLock.ts 도 SCM PI Admin BOH 편집 허용 · 원인 미확인' 은 호출부를 안 본 판단. 원인 = IntegrationPsi.tsx:182~183 isPiAdmin·isPlanner false 고정. FE_GUIDE_20261118_0636.md G6 추가(FE 수정 안 함 · DB MODE). 11-17 FE_GUIDE_20261117_1759 G1(ADMIN 저장)도 FE 미반영(integrationPsiSave.ts 수정 시각 11-03 10:18 · unfoldAdminModifyCells 0건).
- 2026-11-18 11:23 공용 변경(다른 세션 필독): CheckList 설명 칸 = SCP0104 틀 전 화면 적용(사용자 지시). ① 규칙 tools/VibeManager/rules/50_DOC_STYLE.md 'CheckList 설명 칸 틀' 신설(작성 절차 1~5: 조치 필요·판정 필요 행 전부 Doc/verify/<ID>/action_summary.csv 작성 → --resume-docs → '[설명 정리 필요] 0건' 확인). ② make_verify_docs.py 끝에 '[설명 정리 필요] N건 · 행 ID' 출력, 판정 필요 시트도 group 묶음. ③ plain_detail.build_gap: 정리 파일 없는 행도 ' - AS-IS / - TO-BE / - GAP' 틀로 채움(임시). 저장 분류 행은 종전 틀(위치·AS-IS·TO-BE·GAP·조치). 백업 *.bak_20261118_gapfmt, 50_DOC_STYLE.md.bak_20261118_cldesc. SCP0111 v56 설명 정리 필요 0건.

## 2026-11-18 16:24 미검증 자동 해소 라운드 1 (SCP0096)
- CheckList 뒤 미검증 해소 기능(unverified_resolve.py · VM 체인 checklist) 첫 실측. SCP0096 원장 미검증 270 → 186.
- 공용 엔진 보완 5: gen_param_map(프레임워크 경유 AS-IS SP 짝 · SP 선언 기본값) · diff_verify(이름 없는 AS-IS 컬럼 위치 대응) · diff_ingest(DIFF 호출 ORDER 판정) · ensureRows minRows + _verify K3·K1 대안 조회. 기록 Doc/verify/SCP0096/_unverified_work.md
- 다른 화면 영향(대응표 기준 실측): SP 선언 기본값으로 풀리는 인자 11개(SCP0005·SCP0007·SCP0020·SCP0096 @debug_mode 등). 다른 화면 재실행은 안 함.

## 2026-11-18 16:45 미검증 자동 해소 라운드 2 (SCP0096)
- 원장 미검증 186 → 133(v30) · FAIL 15 유지. 공용 엔진 보완: findSearchBox(메뉴 글자 제외) · combo_oracle local_rhs(지역 변수 대입식) · judge(결함 유형 대상 컬럼·Insert 없음 → NA 근거) · golden.py(SP 선언 기본값·빈 값=전체·실측 인자) · gen_param_map asis_result_unused(AS-IS 결과 미사용 SP) · 신규 asis_sp_src.py · K3·K1 시간 제한 600초. 기록 Doc/verify/SCP0096/_unverified_work.md

## 2026-11-18 18:19 미검증 해소 라운드 1 (SCP0111)
- 입력: CheckList 16:34~17:44 결과 원장 미검증 47(처리 대상 26 · 사람 3 · 집계 18). 행별 조치 Doc/verify/SCP0111/_unverified_plan.md · 결정 목록 _unverified_decisions.md(D 10 · A 3) · 기록 _unverified_work.md
- 공용 엔진 보완(검사기 결함 T314~T319): save_audit 기존 행 수정형 저장 판정(restore_touched save_trace.json) · AS-IS 저장 SP 대상 표 주석·별칭 해석 · run_verify I2 언어 전환 재실행(lang_retry · langRetryMaxMin 기본 45분) · 분리형 월 기간 칸(smoke-extra isSplitPeriod·pickSplitMonth · _verify E2·M2) · crud 가상화 그리드 Insert 판정·editonly 저장 보류 · menu_auth_sync.py 신설(체인 post · post 예정 단계 40) · judge J4 결함원장 연결·K4 CR-070
- 분류표 unverified_classes.csv: 저장보류(45, 사람) · 판단(95, '기계 판정 불가 — 수동 검수 대상')
- 다른 화면 영향: editonly 화면 신규 행 저장 시험 보류(최근 결과 신규 행 모드 SCP0111·SSP0023·SSP0060, 셋 다 종전에도 inserted=N) · AS-IS 저장 SP 대상 표 74개 중 10개 바뀜(SSP0003 주석 안 SSP_ANL_SHIP_PLAN 제외 등) · I2 생략 화면은 다음 실행부터 재실행 대기
- 재측정: VM 체인 CheckList 전체 1회(묶음별 --only 안 함). engine_selfcheck 18:16 PASS

## 2026-11-18 19:51 미검증 해소 라운드 2 (SCP0111)
- --only 재측정 4회(18:23~19:50). 원장 미검증 47 → 32 · 처리 대상 26 → 13(판단 8 · 엔진 4 · 대조표 1) · 사람 5 · 집계 14
- 추가 보완 T320~T322: _verify E2 asisGuard DateTime.Compare 형태 · restore_touched --keep-trace(--only 때 지난 저장 기록 유지) · _trace W4 E4 판정 넘김이 앞 실행 확정 판정을 덮지 않음(PREV)
- 화면 결함: 기간 역전 조회 미차단(V-c73d3323 · V-ce8459b6) → FE_GUIDE_20261118_1859.md G8 · fixlist 보류(가이드)

### 2026-11-18 20:1x 공용 변경 · 미검증 해소 반복 · 재실행 행 넘김 (VM 세션)
- unverified_resolve.py: 앞선 원장에서도 재실행이던 행 = 담당 엔진. triage.json continue·stalled·prev_actionable·ledger_mtime 추가. 체인 checklist 가 continue>0 동안 보완·재수행을 최대 3회 반복(quick.json).
- 다른 세션 영향: triage.json 키 추가만(기존 키 유지). 백업 *.bak_20261118_loop.

### 2026-11-18 20:2x 공용 검사기 3곳 · SCP0096 판단 행 확인 결과 반영 (VM 세션)
- db_ref_check.py: 화면 ID 가 이름에 없는 공용 패키지(PKG_COM0000 등)는 proc_meta 의 화면 호출 프로시저 구간만 검사. 구간을 못 찾으면 ERROR(측정 경로 없음).
- i18n_static.py: 같은 문구 다른 코드 = 화면이 묶음 중 코드 1개만 쓰고 그 KO 문구가 나머지와 다르면 제외.
- master_sweep.py: AS-IS 표의 ATTRIBUTE* 값이 'ASISLIVE_TEST%' 인 시험 행은 키 대조에서 제외, 제외 행 수를 why 에 기록.
- 다른 화면 영향: 공용 패키지 기반 EG 행(EMPTY_EQ·LIKE_NULL·TEAM_SRC 등) 건수가 줄 수 있음. selftest 65/65 · 21/21 · engine_selfcheck PASS(20:26). 백업 *.bak_20261118_judge13.

## 2026-11-18 23:0x 계정 미검증 해소(SCP0096 EG032 · EG380 · 공용)
- facts_auth.py: 화면별 SCM_MST_TITLESET_USER 행 수(TO-BE·AS-IS)·PKG 참조 수를 사실 파일 db.titleset 에 기록. users.json guestAccount(공용 GUEST 전용 계정)를 계정 풀에 key GUEST/-/GUEST 로 추가
- authprobe.ts: accountId 가 GUEST 키 처리 · distinctAccounts 는 GUEST 키 제외(계정 순회 결과 불변)
- eg_auth.spec.ts EG032: AS-IS·TO-BE 칸 설정 0행이면 NA(근거 행 수). EG380: 게스트 안내창이 있으면 확인 뒤 화면까지 재고 안내 문구를 근거에 남김 · '권한 신청' 문구 일치 판정 제거(안내 문구로 허위 PASS 방지)
- users.json: guestAccount = Guest(사내 ZIOUI1 GUEST 그룹만 · BE 로그인 200)
- 확인: SCP0096 단독 실행 EG032 NA · EG380 FAIL · 변이 guest_home FAIL(23:07~23:08). 백업 *.bak_20261118_acct2


## 2026-11-19 00:0x~00:2x SCP0096 미검증 해소 라운드 4(VM 체인 · 일괄 보완)
- restore_touched.py: 키 있는 복원도 save_trace.json 기록(T323) · prereq.py: 골든에 빠진 AS-IS 호출 SP 있으면 재생성(T324 · SCP0096·SSP0005)
- tools/E2E/lib/smoke-extra.ts findRowAcrossDivisions(T325) · inputcheck.ts asisBlankDefault·judgeBlankReject(T326) · scenario.ts NOT_APPLICABLE_TAG(T327) · Doc/e2e/specs/_verify.spec.ts 경계값·빈값·@DYNVAL 연결
- judge.py _meta_req_none(T328) · mapping_trace.py commented_only_sps(T329)·기준표 제외 정적 NA 우선(T330)·reason_fact(T331) · menu_auth_sync.py empty_overrides(T331) · combo_oracle.py resolve_names · a1_live.py 사용자 인자 없는 SP NA(T332) · unverified_classes.csv 72·78
- 다른 화면 영향: 주석 호출 SP 추출 제외 · 기준표 제외 NA 우선 · 빈값 거부 판정(SCP0037·SCP0122·SCP0127 같은 증상)이 다음 CheckList 부터 반영
- 확인: 자기 시험 inputcheck 17/17 · scenario 33/33 · menu_auth_sync 9/9 · a1_live 17/17 · restore_touched 8/8 · 단위 함수 시험(resolve_names · golden_missing_sps · commented_only_sps · reason_fact · judge_trace) · engine_selfcheck PASS. 백업 *.bak_20261119_unvr4

### 2026-11-19 01:0x SCP0096 미검증 해소 라운드 5
- recheck 결과 51 → 18. 처리 대상 1행(F6 빈값) · inputcheck.ts judgeBlankReject pathOk · _verify.spec.ts 빈값 판정 보강(T333). 자기 시험 19/19 · engine_selfcheck PASS(01:05)

### 2026-11-19 07:1x 체인 반복 중단 보완(SCP0096 · 공용)
- _verify.spec.ts flushRt 부분 실행 합침(T334) · unverified_resolve.py progress()·DB MODE 대조표 행 가이드 담당(T335). selftest OK · engine_selfcheck PASS(07:18). 백업 *.bak_20261119_unvr6

### 2026-11-19 09:0x 사람 확인 행 권장안 판정(사용자 승인 · 공용)
- mapping_trace.py X-REASON 근거 없음 = FAIL · judge.py 선행 결함 종속 = FAIL(T337) · harness.json snapAutoApprove=true + run_verify 사후 snap_approve(OK·NA). engine_selfcheck PASS(09:09). 다른 화면 X-REASON 사람 확인 행(66화면)이 다음 CheckList 부터 FAIL

## 2026-11-19 10:4x SCP0111 미검증 해소 라운드 3(VM 🧪 · 일괄 보완)
- 입력: 분류 라운드 9(10:24) 원장 미검증 32 · 처리 대상 12(판단 8 · 엔진 4) · 가이드 1 · 사람 5 · 집계 14. 원장은 11-18 19:50 그대로(재실행 없음)
- 공용 엔진 보완 T338~T342: disp2 judgeCodeShown 값=표시값 칸 · nscm.ts fieldExistsAny NFKC · i18n_static·eg_ingest PROC 문구 출력 경로 판정 · mergecheck AS-IS 빈 Delete 근거 NA · judge.py H4 칸 폭·G4 팝업 구성 판정필요 유지
- 다른 화면 영향(11-19 10:3x 원장 기준 건수): MS1 PROC 한글 ERROR 30행(9화면) → FAIL 또는 판정필요 · G4 팝업 COND_LIST ERROR 19행(14화면) → 판정필요 · H4 칸 폭 ERROR 7행(7화면) → 판정필요. 다음 CheckList 부터 반영
- 확인: disp2 selftest 56/56 · mergecheck 32/32 · i18n_static --selftest 7/7 · engine_selfcheck PASS(10:40). 백업 *.bak_20261119_t338 · t340 · t341 · t342

### 2026-11-19 10:5x 공용 변경 · 미검증 해소 뒤 보완 전 CheckList 건수 숨김(사용자 지시)
- 사용자: 미검증 해소 뒤에는 이전 CheckList 건수를 보여 주지 않는다. 보여 줄 때는 보완 뒤 다시 수행한 CheckList 건수만
- 판단 = 보완 표식 Doc/verify/<ID>/_unverified_fix.json(fixed_at)이 원장 verify_ledger.csv 보다 뒤면 'CheckList 재수행 전'. CheckList 재수행으로 원장이 새로 써지면 풀림. 표식은 🧪 세션이 검사기를 고쳤을 때 pending_recheck.py <ID> --mark 로 남김
- 반영: 신규 tools/Harness/verify/pending_recheck.py · tools/VibeManager/recheck.js. 건수 숨김 = VM 트리 CheckList 묶음·하위(extension.js), 흐름 패널·현황 타일(flow-panel.js·workbench.js), 미검증 게이트 문구(workbench.js unverifiedOpen), Console 현황판(screen_status.py), 미검증 분류 출력·triage.md(unverified_resolve.py · json 값은 체인 판단용 유지 + pending_recheck 키)
- quick.json 🧪 프롬프트 [5]: 보고에 보완 전 건수를 쓰지 않음 · 표식 남기기 추가
- _unverified_work.md 수정 시각은 판단에 쓰지 않음(SCP0096 10:03 재수행 결과 기록도 그 파일에 붙어 오판 실측)
- 확인: pending_recheck --selftest 4/4 · node --check 4파일 · SCP0111 표식 10:58 → 현황판·분류 출력 건수 없음 · SCP0096 표식 없음 → 종전 표시 · engine_selfcheck PASS(10:58). VM 확장 변경은 창 다시 로드 뒤 반영. 백업 *.bak_20261119_recheck

## 2026-11-19 12:4x SCP0111 미검증 해소 라운드 4(일괄 보완)
- 입력: CheckList 재수행 원장(12:23) 미검증 10 · 처리 대상 4(F4 2 · B4 2) · 가이드 1 · 사람 2 · 집계 3
- combo_oracle.py 필터식 이어 붙이기·반복문 누적 목록 해석(T343). 같은 유형 combo_src 24행(SCP0016·SCP0020·SCP0037·SCP0041·SCP0111). 종전엔 글자 비교로 0행
- _verify.spec.ts CRUD 시험 끝 세션 그룹 재현(T344): 저장 경로가 FE 세션 그룹으로 갈리는 화면에서 같은 계정·그룹 1개 제외로 같은 수정 저장. 다른 화면 T210 행에도 적용
- 확인: combo_oracle --selftest 8/8 · 단위 함수 시험(SCP0111 분기 12건·13건) · engine_selfcheck PASS(12:43). 백업 *.bak_20261119_t343 · t344

## 2026-11-19 13:4x SCP0111 CheckList v64 사용자의견 반영(공용 · 전 화면)
- 사용자의견 21행: 오류 아님·TO-BE RULE 14 · 중복 제거 2 · 확인 필요 3 · 질문 2
- judge.py 사용자의견 문구 인식(T345) · CR-113 기간 역전 조회 허용(T346) · 앱 공통 범위 제외(T347, app_level_scope.csv, 결과는 _app_level_results.csv) · snap.ts·_snap.spec 형상 정규화와 화면샷 차이 제외(T348, CR-114·CR-115·CR-100)
- TO-BE 룰 원천 confirmed_requirements.csv CR-113~CR-115 등록, tobe_rule_registry --build/--check 위반 0
- 확인 필요 재점검: V-daa3f0ba(Insert 위치) 화면 결함 유지 · FE_GUIDE_20261119_1340.md G9 / V-2eed0400(빈 신규 행 안내) 화면 결함 유지 · 기존 G5 / EG-42d53d53 PKG_SCP0111 C_MSG_DUP = MSG00428 사내 적용(13:37:58) · 이관 SCP0111_CLOUD_DB_MOD_20261119_1338
- 확인: snap.selftest 9/9 · engine_selfcheck PASS(13:41) · inventory_check 등록부 갱신. 백업 *.bak_20261119_t345 · t348 · cr113 · v64op

## 2026-11-19 14:2x CheckList 전처리 = 파싱 없으면 먼저 수행(공용)
- 사용자 지시: "파싱이 없으면 무조건 파싱부터 · 실측은 필요하면 먼저, 필요 없으면 차후 · 멈추지 말고 먼저 수행하고 CheckList 진행".
- 확인: prereq.py 는 Fact Pack 핵심 4파일(controls·actions·files·endpoints)이 없으면 pack.ps1(화면 1개 재생성)만 돌리고, 그래도 없으면 rc 6 으로 CheckList 중단했음(파서 전체 실행은 사람 몫).
- 보완: pack 뒤에도 없으면 파서 전체 실행(tools/AsisFacts/run.ps1 · _bin 있으면 -SkipBuild · 잠금 asisfacts_parse · 최대 90분) → pack 다시 → 생기면 DONE 으로 계속. 그래도 없으면 종전처럼 FAIL(파서 결과에 화면 없음).
- AS-IS 실측: 실측을 읽는 검사(asis_live_auto·ingest·rows·doc·plain_detail)는 전부 diff 단계 이후. diff 단계 첫머리 asis_live_auto 가 24시간 지난 실측을 다시 잼 → 앞으로 당길 필요 없음(변경 없음).
- 확인: py_compile OK. 파서 전체 실행 경로 실제 실행은 미측정(4화면 CheckList 진행 중 · 공용 결과 재생성이라 시험 실행 안 함). 백업 prereq.py.bak_20261119_parse.

## 2026-11-19 15:1x CheckList 서버 자동 기동(공용 · server_guard.py)
- 사용자 지시: "CheckList 중 FE·BE 서버가 기동 중이 아니면 기동시켜 진행 · 죽어 있는데 대기만 하면 진행 안 됨 · 응답이 없으면 서버 기동 프로세스 가동".
- 확인: VM ensureServers 는 작업 시작 때 1회·포트 LISTEN 만 봄(멈춘 서버도 정상). CheckList 안 run-e2e.cmd 는 서버가 죽어 있으면 rc 5 로 E2E 를 건너뛰기만 함. 검증엔진·팝업권한(eg_chain)·차등 검증은 서버 확인 없음.
- 신설 tools/Harness/verify/server_guard.py: HTTP 응답(상태코드 무관)으로 판정 · 포트 열림+무응답은 20초 간격 3회 재확인 뒤 멈춤 판정 → java·node·cmd 만 종료(VPN·시스템 보호) → quick.json BE/FE Start 명령 그대로 창 없이 기동(출력 Doc/e2e/logs/_server_<port>.log) → 응답까지 대기(BE 300·FE 120초) · 포트별 잠금으로 동시 CheckList 중 한 실행만 기동. 끄기 VERIFY_SERVER_GUARD=off.
- 연결: run-e2e.cmd(서버 확인 직전) · run_verify.py guard_servers()(E2E 검증엔진·팝업권한·차등 검증 단계 시작 · 세부 수에 넣지 않음).
- 확인(15:10): selftest OK · --check rc 0(BE java 20928 · FE node 34956 응답) · 빈 포트 18999 시험 서버로 '응답 없음 → 기동 → 응답' 4.6초 · 잠금 해제 확인. 실제 BE·FE 를 내려 놓은 상태의 기동은 미측정(4화면 CheckList 진행 중).
- 백업 run-e2e.cmd.bak_20261119_guard · run_verify.py.bak_20261119_guard.

## 2026-11-19 15:1x 동시 E2E 대기 원인 분석 · BE 대기 중 서버 기동 연결
- 사용자 지시: "여러 화면 E2E 동시 실행 시 다른 화면 실행 중이라 대기 · 각 세션별로 대기 없이 진행" · 이어서 "부하 기준 초과 대기는 인정".
- 13:48~ 4화면(SCP0005·SSP0014·SCP0028·SSP0005) 로그 실측: ① BE 포트 닫힘 대기([BE 대기] 300초 · 화면당 3~6회) ② 부하 입장 대기(SSP0014 3분 30초 · 인정) ③ 언어 잠금(I2 · 4화면 모두 6.1분 = acquireLangExclusive 6분 상한 → [측정 경로 없음] 미검증).
- ① 보완: nscm.ts waitBeUp 이 BE 포트 닫힘을 보면 server_guard.py --ports 8080 을 띄우고 기다림(포트 잠금으로 한 번만 기동 · 끄기 VERIFY_SERVER_GUARD=off). 백업 nscm.ts.bak_20261119_guard. tsc nscm.ts 오류 0.
- ③ 원인: 언어 = 서버 계정 설정(SCM_ADM_USER_M.LANG_CD) · 모든 화면이 같은 계정(minyonglee1)이라 I2 는 다른 화면 E2E 가 끝날 때까지 기다림(T200 · 이미 연 화면의 측정이 바뀌는 허위 FAIL 방지). 대기 없이 하려면 I2 를 다른 계정으로 재야 함 → 후보 test001(ADMIN·SPMS ADMIN · 사업부 81) · testa(ADMIN·GUEST · 사업부 40 없음) — 측정 계정·사업부가 바뀌는 판정 조건 변경이라 사용자 결정 대기.

## 2026-11-19 15:4x 언어 전환 시험 = 전용 ADMIN 계정(다른 화면 대기 제거 · 공용)
- 사용자 지시: "minyonglee1 과 사업부 권한이 같은 40명을 ADMIN 권한자로 목록 관리 · 언어 전환 시험 때 다른 세션이 쓰지 않는 사용자로 로그인".
- users.json adminPool(40명 · 사내 ZIOUI1 15:21 추출 · 로그인 200 · 근거 Doc/e2e/role_users/system_admin_users_20261119.csv).
- 신설 tools/E2E/lib/langacct.ts: 후보 = adminPool − 기본 계정 − users.json 의 다른 시험 계정(영역 명부·화면 지정·GUEST) = 35명 · 계정별 잠금 Doc/e2e/_run.langacct.<USER>.lock(주인 생존 시 다른 실행은 건너뜀) · 잠금에 원래 언어 기록 · 못 되돌리면 잠금을 남겨 다음 실행이 언어 설정 API 로 먼저 되돌림.
- _verify.spec.ts: I2(언어 전환 문구 덤프) = 시작 때 전용 계정 로그인 → 다른 화면 대기(acquireLangExclusive 6분) 없음 → 끝에 원래 언어로 되돌린 뒤(실패 시 API 재시도) 기본 계정 재로그인. 언어 단계가 있는 시나리오도 시작부터 전용 계정. 계정을 못 받으면 종전 방식(기본 계정 + 대기).
- 확인: tsc(langacct.ts · _verify.spec.ts · nscm.ts) 오류 0 · 모듈 단독 시험(다른 실행 잡은 계정 건너뜀 · 원복 뒤 잠금 삭제 · 낡은 잠금의 원래 언어 EN 넘겨받음 · 못 되돌림 잠금 유지). 실제 I2 동시 실행은 미측정(다음 CheckList).
- 백업 users.json.bak_20261119_adminpool · _verify.spec.ts.bak_20261119_langacct.

## 2026-11-19 15:5x 동시 다른 계정·다른 언어 격리 실측(언어 시험 계정 분리의 전제 확인)
- 사용자 지시: "하나의 PC 에서 동시에 다른 계정으로 각각의 언어 설정으로 테스트를 동시에 진행할 때 문제가 없는지 다시 확인".
- 코드: BE 언어 = 로그인 세션의 사용자 정보(UserSession·CustomUserDetails) → 프로시저 인자 sesLangCd. 전역(static)·캐시에 언어 없음(BaseService sessionDefaults 는 호출마다 지역 생성).
- DB 원문(ZIOUI1 15:45): 언어를 접속 단위로 남기는 코드 0(세션 컨텍스트 설정 0 · SYS_CONTEXT 언어 조회 0 · 패키지 전역 LANG 변수 0). LANG 컬럼 임시표 7개 = EDI·메일 연계(화면 언어 무관).
- 실측(15:50 · E2E 의 실제 Nscm.loginAs·openScreen·search): A=bindy122678→CN · C=brightboy→EN · B=minyonglee1 그대로 · 화면 SCP0096.
  세션 언어 20회(3계정 동시 요청) A CN 20 · C EN 20 · B KO 20 · 메시지 응답 언어 20회 같음 · 세 계정 동시 화면 열기·조회 성공 · 머리글 CHN/ENG/KOR · B 라벨 전후 같음(Div) · A·C 라벨은 'Div.'(언어 반영).
  원복 뒤 DB LANG_CD 3계정 KO 확인(15:51) · 잠금·임시 스펙 0.
- 실측 중 발견·정정: takeLangAccount 가 같은 프로세스에서 두 번 부르면 같은 계정을 돌려줌 → 자기 잠금도 건너뛰게 고침(langacct.ts).
- 남는 주의: 후보 35명은 실제 사용자 계정 — 시험하는 동안(화면당 몇 분) 그 사람이 TO-BE 에 접속하면 화면 언어가 바뀌어 보임(끝나면 원복).

## 2026-11-19 16:4x 덧붙임 — AI 검토(CheckList 단계별 Claude Code 활용)
- 사용자(11-19): "CheckList 의 각각의 단계별 판단을 할 때 필요하면 클로드코드를 활용하도록 기능 보완". 결정: 근거 확인되면 판정 반영 · 대상 FAIL·판정필요·미검증 · 오판은 체인 안에서 엔진까지 수정 · 4단계(판정 검토, 설명 문장, 사용자의견 처리, AS-IS 사실 추출 검토) · 문서 열 이름 'CheckList Remark'.
- 신규(tools/Harness/verify): llm_call.py(공용 호출기 · 읽기 전용 · 인용 확인 · 캐시 · 사용량 Doc/verify/_llm_usage.csv) · llm_review.py(판정 검토) · opinion_intake.py(사용자의견 처리) · llm_facts.py(사실 추출 검토) · llm_desc.py(설명 문장).
- 수정: judge.py(AI 검토 되돌리기 + 반입 + 사실 검토 후보 note) · run_verify.py(pre opinion_intake · facts llm_facts · post llm_review 뒤 변경 시 추적·판정 재반입 · docs llm_desc · STAGES facts 16·post 41·docs 5) · make_verify_docs.py('CheckList Remark' 열 · 근거 등급 · no_summary.json) · unverified_resolve.py(AI 검토가 가린 엔진 보완 대상을 처리 대상에 합류) · harness.json llmReview* 키 · quick.json 🧪 프롬프트 · steps.json 제목.
- 반영 규칙: 인용(경로:줄 + 원문)이 evidence_check 로 확인된 답만. FAIL→PASS·NA 는 AS-IS 원문(GSCM/ · DB_DDL/ · Doc/asisfacts/db/modules/) 인용 또는 등록 룰 번호 필요. 미검증(ERROR) 행은 반영하지 않음. 사용자판정·정적 판정·재실측 행은 덮지 않음. 꺼져 있으면 지난 검토 결과도 반입하지 않음.
- 시범 실측(SCP0096 · 원장 11-19 10:02 · 16:18~16:41): 대상 38행 중 검토 13행(제외 25 = 사용자 판정·집계·스냅샷·선행 종속). 호출 3회 · 12.086 USD · 1,381초(Doc/verify/SCP0096/llm_usage.csv · 모델 claude-fable-5-1 · effort high). 인용 확인 13/13. 분류 검사기오판 8 · 추출오류 1 · 실결함 2 · 데이터차이 2. 판정 반영 9행.
  - 반입 시험(16:43~16:44 · mapping_trace --to-ledger → judge 2회): FAIL 25→21 · 판정필요 13→6 · 2회차도 같은 결과(AI_RESET 6 · AI_REVIEW 8 · STALE 0 · T-a8c0dab9 는 하위 행 PASS 로 사라짐). 시험 뒤 원장은 시험 전 판으로 복원(cmp 일치).
  - 확인된 검사기 결함 후보(엔진 보완 대상 9행 · 미수정): ① gen_expect p_sumtoggle 이 chkSum.Visible=false(Designer.cs:346 · layoutSum Visibility Never :573)를 보지 않아 숨긴 체크박스에 토글 기대 생성 → V-eb856b69 FAIL 과 선행 종속 2행(V-d8f314e2 · V-9e29a0e2)·FE 가이드 1번이 허위(원문 직접 확인 16:42) ② _trace.spec W4b F5 값 주입 뒤 반영 확인 없음 ③ H11 저장 중 로딩 기대가 AS-IS 원문 아님 ④ facts_sortrules 가 변수 대입문의 ORDER BY 를 결과 정렬로 추출 ⑤ judge sort_check 매칭 키에 줄 번호 없음 ⑥ sort_check 가 ORDER BY 를 300자로 잘라 sort_ci_check 가 오독 ⑦ 대조표 D00-3-020 · D00-3-032 사유 문구 오류(FE 폴더 · DB MODE 가이드).
- 호출 비용: 기본 호출은 세션 기본 문맥 약 12만 토큰이 실려 한 줄 읽기 1.245 USD · 76초 → --safe-mode --strict-mcp-config --tools Read,Glob,Grep 로 0.120 USD · 17초(16:14 실측 · llmReviewLean). Sonnet 같은 시험 0.016 USD(판정 품질 미측정).
- 상태: harness.json llmReview = false(꺼 둠 — 비용 확인 뒤 사용자 결정). 미실측: opinion_intake · llm_facts · llm_desc 의 실제 Claude 호출, run_verify 전체 체인에서의 동작, VM Flow 보드 표시. VM 환경설정 화면 항목 없음(harness.json 직접 수정).
- 확인: 5개 도구 --selftest OK · engine_selfcheck PASS(16:45) · tobe_rule_registry --check 0 · 추측 지점 원장 MANUAL 4행 등록 · README 등록부 갱신.
- 되돌리기: make_verify_docs.py.bak_20261119_llm · quick.json.bak_20261119_llm · 설치 폴더 steps.json.bak_20261119_llm · 신규 5개 파일 삭제 + judge.py·run_verify.py·unverified_resolve.py 의 '2026-11-19 AI' 블록 제거.
- 16:49 사용자 지시 "AI 검토 OPUS 로 켜기": harness.json llmReview = true · llmReviewModel = claude-opus-5-5(effort high). 호출 1회 확인(한 줄 읽기 · 0.044 USD · 11.5초 · 인용 확인됨 · Doc/verify/_SELFTEST/llm_usage.csv). Opus 로 한 판정 검토는 아직 없음.
- 16:5x 사용자 지시 "WORKBENCH 가 사용하고 있는 MODEL 그대로 사용": harness.json llmReviewModel = 빈 값(llmReview true 유지). 모델 = VM 워크벤치가 체인 작업에 넘기는 CLAUDE_MODEL(workbench.js:1256 getState().model || claudeModel · llm_call.claude_cmd). 워크벤치 모델이 비어 있으면 CLI 기본값. VM 체인에서의 실제 전달은 미실측.

## 2026-11-19 16:5x SSP0014 미검증 해소 라운드 1(일괄 보완)
- 입력: CheckList 13:49~16:17 원장 미검증 293 · 처리 대상 143(엔진 115 · 판단 28) · 가이드 4 · 사람 1 · 집계 145. 행별 조치 Doc/verify/SSP0014/_unverified_plan.md · 결정 _unverified_decisions.md(D1~D8) · 기록 _unverified_work.md · FE 가이드 FE_GUIDE_20261119_1647.md(4건)
- 원인 실측: BE 14:33~15:07 중단(nscm.log 0줄)으로 36행 미측정(15:1x server_guard 반영분이 다음 실행 처리) · 언어 계정 4행(15:4x langacct 반영분)
- 공용 엔진 보완 T349~T358: 필수 칸 채워진 기존행 우선 · 팝업 입력 칸 = 다른 행 실제 값(probe.ts · crud.ts · saveprobe.ts) · 더블클릭 입력 팝업 일반 닫기(nscm.ts · saveprobe.ts) · 팝업 아이콘 CSS ::after(eg_popup.spec.ts) · G5 원천 칸 0개 PASS · F6 숫자 칸 0 NA(_verify.spec.ts) · D4 AS-IS Insert 무동작 NA · 멀티선택 재시도(_trace.spec.ts) · C3 자기 칸 대입 NA(mapping_trace.py · _trace.spec.ts) · G03 게이트 결과 생성(mapping_trace.py) · sp_pair 짝·kind(gen_golden_cases.py · sort_check.py) · unverified_classes.csv order 55
- 다른 화면 영향: 같은 증상 원장 행 C3 119(15화면) · 멀티선택 67(10) · A6 97(13) · D5 27(11) · G5 22(2) · F6 12(12) · D4 14(3). 골든 kind 13건(9화면) sp_pair 값으로 바뀜(파일 재생성은 SSP0014 만). 다음 CheckList 부터 반영
- 확인: tsc 오류 0 · mapping_trace selftest 81/81 · sort_check 5/5 · 단위 함수 시험 8/8 · 5/5 · engine_selfcheck PASS(16:44). 실제 E2E 동작은 미측정. 백업 *.bak_20261119_ssp14u
- 16:5x 사용자 지시 "VM 환경설정에 AI 검토 켜고 끄는 항목": 신규 tools/Harness/verify/set_llm_review.py(ON·OFF·현재 값 · harness.json 의 llmReview 줄만 바꿈 · --selftest 7건 OK · 켜고 끄기 왕복 뒤 파일 cmp 일치) · steps.json S8.llmReview(입력 선택 목록 ON/OFF/STATUS) · quick.json 환경설정 그룹 "🧠 AI 검토 (켜기 / 끄기)"(🧭 작업 모드 뒤). workbench.js 는 고치지 않음(다른 세션이 수정 중 · 작업 항목의 선택 목록 입력 = extension.js collectInputs). steps.json 설치 폴더 반영(cmp 일치). VS Code 화면에서 메뉴 실행은 미확인. 16:54 engine_selfcheck FAIL = TSC nscm.ts TS7023 openScreen(다른 세션 16:52 수정분 · 이 작업과 무관 · 미수정).

### 2026-11-19 17:1x SSP0014 미검증 해소 라운드 2(라운드 1 미보완 2묶음)
- 원장 16:17 그대로(재수행 없음) · 라운드 1 보완 되풀이 안 함
- T359 mapping_trace.py AS-IS 칸 상수 이름 → 원문 상수 값 칸(DIVISION → DIVISION_ID · 원장 COLUMN 칸으로 가는 것만). 대응 생기는 화면 6
- 팝업 대조표 오기 4행: 화면 팝업 = COM0013(2026-10-12 사용자 지시 교체), 대조표는 SCM0002 그대로 → FE_GUIDE_20261119_1647.md G5 · 출발 사이트 인자 차이 결정 D7
- 확인: mapping_trace selftest 81/81 · engine_selfcheck PASS(17:07:12)

## 2026-11-19 17:1x SCP0028 미검증 해소 라운드 1(일괄 보완)
- 입력: CheckList 원장 16:34 미검증 278 · 처리 대상 141 · 집계 137. 행별 조치 Doc/verify/SCP0028/_unverified_plan.md · 결정 _unverified_decisions.md(D1~D19 70행) · 기록 _unverified_work.md
- 공용 엔진 보완 T360~T366: openScreen BE 정지 구분·재시도(nscm.ts) · ensureRows 대안 0건 메모 금지(smoke-extra.ts) · AS-IS Insert 빈 본문 = 신규 행 시나리오 없음(facts_lockrules.py · judge.py insert_noop_na) · 조회조건 별칭 라벨 찾기(_verify.spec.ts findSearchBox · CR-092) · 기준표 행 0 화면 H5·SC1(judge.py) · C2 연쇄 표기 대상 칸 판별(judge.py) · 버튼 다른 언어 라벨(labeltrans.ts 신규 · eg_popup.spec.ts)
- 확인: 단위 시험(insert_noop_na 26행 · cascade_entities 6/10 · labelVariants) · tsc 0 · engine_selfcheck PASS. 실제 E2E 동작은 미측정(다음 CheckList)
- 겹침 확인: SSP0014 세션 T354(_trace D4 Insert 비노출)와 대상 다름. T355·T357 은 SCP0028 D5·D17 과 같은 증상

## 2026-11-20 08:2x SCP0028 미검증 해소(CheckList 07:38 원장 · 일괄 보완)
- 입력: 원장 미검증 208 · 처리 대상 111(엔진 81 · 판단 30) · 집계 113. 조치 표 Doc/verify/SCP0028/_unverified_plan.md(111행 · 23묶음) · 결정 _unverified_decisions.md(D1~D11 · 22행) · 기록 _unverified_work.md · FE 가이드 FE_GUIDE_20261120_0817.md(1건)
- 공용 엔진 보완 T430~T449: 툴바 단추 판별(nscm.ts toolbarButton · authprobe.ts toolbarRe · eg_auth EG369·EG374·EG411 · crud.ts) · crud Insert 빈 본문 = 수정 저장 경로 · 숫자 칸 입력 글자 누락 확인 · 정렬 키 원본 표 NOT NULL(sort_ci_check.py) · 기준표 표준 명칭(judge H5 · labelalias.ts stdAlias · findCond · findSearchBox) · 탭 이름 메뉴 메시지 코드 · CR-116(그룹 권한 동기화 = TO-BE 권한 설정 기준 · 사용자의견 SCP0104 V-24ff60ab) · 팝업 필수 알림 분리(G6) · facts_combosrc DataBind 바인딩·호출 없는 private 메서드 제외 · C2·C3 신규 행 결함 유형 Insert 빈 본문 · 병합 셀 Delete 툴바·AS-IS 신규 행만 · 조회 전 Delete 프로브 · G8·G9 라벨 그리드 글자 제외 · eg_chain 호출 기록(EG_CHAIN) · 시나리오 btn·iscombo 라벨 후보 · 시나리오 신규 행 문구 · 원값 복원 키보드 입력 · golden 선언 기본값 '' · SwitchLock 문장 CR-093 · 공용 권한 SP F4 = EG374·EG411 실측
- 확인: sort_ci_check selftest 21/21 · mergecheck selftest 35/35 · insert_noop_na 단위 시험 · classify 시험 · combo_src 재생성 diff 2행 · tobe_rule_registry --check rc 0 · tsc 0 · engine_selfcheck PASS(08:23:18). 실제 E2E 동작은 미측정(다음 CheckList)
- 겹침: SSP0014 세션 T385(멀티선택 후보 이름 환산)·T405(F4 다른 시나리오 호출 기록)는 SCP0028 V-dd4f9db4·T-f43dac0f 와 같은 증상 · judge.py 동시 수정(수정 직전 다시 읽음)

## 2026-11-20 08:3x SSP0014 미검증 해소 라운드 3(일괄 보완)
- 입력: CheckList 원장 07:33 ERROR 127(집계 77) + AI 검토 24. 행별 조치 Doc/verify/SSP0014/_unverified_plan.md · 결정 _unverified_decisions.md(8건) · 기록 _unverified_work.md · FE 가이드 FE_GUIDE_20261120_0800.md
- 공용 엔진 보완 T370~T376(저장 전 검증 알림 읽기·검증 차단 뒤 통과 값 재시도·저장 경로 검증 호출 통과·E3·CELL_BADKEY·BigFilter 분기 필터 신규 combo_branch_filter.py) · T380~T385(b7_check SSP_BIGFILTER·judge G9·K3·sort 잘림·G1 코드↔이름) · T390~T393(사실 추출: 잠금 범위 상수·NewRow 항목·조건부 셀·여러 줄 ORDER BY) · T400~T406(mapping_trace 부록 표·구현 위치·미배치·인자 전용 조회조건·F4 호출 기록·CR-096)
- 확인: 단위·selftest 통과 · tsc 0 · engine_selfcheck PASS(08:32:54). 실제 E2E 동작은 미측정(다음 CheckList)
- 겹침: SCP0028 세션 T430~T432(crud.ts·nscm.ts·eg_auth.spec.ts)와 같은 파일, 다른 위치. 다른 화면 sort_rules.csv 157개 원복(상세 _unverified_work.md)

## 2026-11-20 08:5x SCP0005 미검증 해소 라운드 1(CheckList 07:35 원장 · 일괄 보완)
- 입력: 원장 미검증 308 · 처리 대상 257(엔진 153 · 판단 103 · 사람 1) · 집계 95. 조치 표 Doc/verify/SCP0005/_unverified_plan.md(257행) · 결정 _unverified_decisions.md(D1~D7 · 80행) · 기록 _unverified_work.md · FE 가이드 FE_GUIDE_20261120_0854.md(1건)
- 공용 엔진 보완 T450~T456: 셀 규칙 시트 = 감싼 SheetName 블록 상수(facts_cellrules.py) · 컬럼 메타 조회 시트 기록(nscm.ts recordMetaSheets → meta_sheets.json) + 미조회·AS-IS 에 없는 시트 원장 제외(ledger.py) · 저장 왕복 ID 칸 보조 식별(saveprobe.ts) · 화면 조회조건 검색 단추 팝업 실측(_trace.spec.ts condPopup) · 대화상자 0·호출 0 = 팝업 열리지 않음 FAIL(_trace.spec.ts M3) · AS-IS Division 컨트롤 없는 화면 J1 NA(e2e_suite_ingest.py) · FPTextBox = 일반 텍스트 칸(ledger.py T114) · 분류표 3행
- 화면 결함 확인: ROUTE_ID 더블클릭 이력 팝업 미구현(AS-IS cs:1093~1103 · TO-BE DB 연결 history/SEARCH → PKG_SCP0005.P_SCP0005_GET_ROUTE_HIST 있음 · 대조표 R8 '기능 부재' 기재 오류) → FE 가이드 G1
- 확인: 필터 단위 시험 3건 · 정규식 시험 5건 · cell_rules 재생성 diff(LT 5칸 시트) · 분류 문구 시험 8종 · engine_selfcheck PASS(08:56:04 · TSC 0). 실제 E2E 동작은 미측정(다음 CheckList). T451 원장 제외는 meta_sheets.json 이 생긴 다음 CheckList 부터
- 다른 화면 영향: Division 컨트롤 없는 AS-IS 화면 87/417(J1 NA 경로) · 컬럼 메타 시트가 여럿인 화면(meta_sheets 기록 생긴 뒤 미조회·AS-IS 에 없는 시트만 제외)
- 백업 *.bak_20261120_scp05u

## 2026-11-20 10:0x SCP0005 미검증 해소 라운드 2(재검 원장 미완료 · 재검 E2E 결과 근거)
- 재검 08:59 시작 → 09:56:56 시나리오 실행 중 멈춤(원장 NOT_RUN 1,758/1,996). 재검 E2E 로 라운드 1 T450·T452·T453·T454 동작 확인
- 보완 T457~T460: 저장 왕복 ID 칸 먼저·파생 칸 제외(saveprobe.ts) · 조회조건 같은 묶음 단추(_trace.spec.ts condPopup) · G4 BTN 라벨 = 인자 원천 컨트롤 이름(_trace.spec.ts) · IsNullOrEmpty(그리드 칸 변수) 조건(facts_lockrules.py)
- 데이터: 재검 저장 시험 잔존 ROUTE_ID 7305(FROM_COUNTRY KR·FROM_CITY KRCOJ) → restore_touched 10:04 복원 · DB 확인 10:04:50
- 확인: engine_selfcheck PASS(10:06:51) · color_rules 재생성 diff 2행. 실제 E2E 동작 미측정(다음 CheckList)

## 2026-11-20 10:1x SSP0005 미검증 해소 라운드 1(CheckList 09:29 원장 · 일괄 보완)
- 공용 엔진 보완 T470~T475: 대조표 TO-BE 칸 사유 판독(mapping_trace.py reason_claim) · 입력 시험 'Invalid Date' 호출 원장 행 생략(diff_ingest.py) · 대입 SELECT 정렬 제외(facts_sortrules.py) · 실전송 건수 호출 선택(_verify.spec.ts) · 다중 선택 Division 선택(authprobe.ts selectDiv) · ensureRows Division 칸 선택 수정 + Division 외 단일 선택 조건 후보 순회(smoke-extra.ts sweepCondCombos)
- 실측 근거: SSP_MST_SHIP_CALENDAR Company 7종(AA00 0행) · E2E 조회 본문 AA00 153건 · 대조표 파서 사유 판독 17/17 실패
- 확인: mapping_trace selftest 91/91 · diff_ingest 4/4 · facts_sortrules 3/3 · tsc 0 · engine_selfcheck PASS(09:4x). E2E 동작 미측정(10:07 재수행 VS Code 종료로 끊김)
- 다른 화면 영향: 첫 조회조건이 Division 이 아닌 화면(ensureRows Division 순회) · 기본값에 데이터 없는 단일 선택 조건이 있는 화면 · 사유 칸 없는 대조표 · 피벗 대입 SELECT 가 있는 AS-IS SP · 다중 선택 Division 화면(EG022·EG271)
- 백업 *.bak_20261120_ssp05u · 결정 목록 Doc/verify/SSP0005/_unverified_decisions.md 10건

## 2026-11-20 10:35 AI 적용 지점 재배치(사용자 지시 '판단·정리가 필요한 곳에만 AI · 불필요한 AI 제거 · 기준 원장 정리부터 · UI/DB MODE 개발·보완 포함')
- 근거(11-20 09:25~09:36 실측): 판정 검토 455행 중 348행이 미검증 행(반영 불가) · 호출 89회 중 50회 반영 0건 · 미검증 AI 전후 동일 · 재점검 3화면 모두 전체 재수행 · 기준(기대값) 저장소 없음 · 다른 문서 행이 요소에 안 붙음
- A 호출 축소: llm_review 재측정 대상 미검증 제외(unverified_classes 분류 재사용) · 판정 대기 미검증 = 판정필요와 같이 반영(judge 반입 조건 포함) · 그 밖 미검증은 근거 확인된 NA 만 · 같은 규칙·같은 증거 행 함께 묻기(llm_solo.json) · 행 기억 키 = 행 내용 + 그 규칙 룰(종전 키도 찾음) · 답 1건마다 기억 저장 · dedup_screen 미측정 행 있는 규칙만 · 문서 1회 생성(make_verify_docs --plan-only → llm_desc → 생성) · llm_desc 동시 호출 · 종류 dedup·delta·criteria·port·repair 켜고 끔 · 종류별 effort · 효과 기록 llm_effect.csv
- 측정(호출 없이 --dry · 기억 없는 첫 실행 가정): SCP0028 판정 검토 묶음 13 → 6 · SSP0014 5 → 2 · 중복 정리 AI 대상 규칙 SCP0028 91 → 23 · SSP0014 90 → 12. 기억된 답 반영 SCP0028 5 → 27행
- B 기준 원장 criteria_build.py(신설): 요소 목록(코드) · 원장 행 → 요소 연결(코드) · AS-IS 실측 연결(코드) · 다른 문서 행 정리와 TO-BE 룰 결합(AI · 대상 아님 = 검색어 0건 기계 확인 · 룰 = 인용이 룰 원문에 있음) · judge 판정 끝에 반영 · CheckList '기준' 시트(사용자의견 고정)
- SCP0028 시범(04:40 원장 사본 1,612행): 기준 항목 1,465 · 다른 문서 행 840 중 합침 147 · 대상 아님 450 · 판단 대기 69 · 룰 결합 376. AI 묶음 44개 첫 실행 뒤 같은 입력 재실행 = 호출 0(2초). 원장 사본 반영 측정: ERROR 1,314 → 914 · 적용 여부 미정 136 → 29
- C: 판단 행 중 AI 검토로 결론 안 난 행 = 담당 '결정'(처리 대상 아님) · 재점검 = 미검증 규칙 --only + 필요한 단계(eg·suite·diff · VERIFY_DELTA_STAGES) · 🧪 프롬프트 전 행 이번 라운드 처리·하위 에이전트 묶음 분할·결정 목록 한 표 · C6(중지 = user.stop)은 다른 세션이 반영해 둔 상태 확인
- D: port_review.py(--plan 이식 목록 · --review 개발 뒤 독립 검토 · --diag 보완 진단) · new_screen.md 이식 목록 행 단위 · 🧯 프롬프트 진단·정해진 보완 먼저·수정분 재점검
- 공통: tools/Harness/rules/ai_points.csv(AI 지점 원장) · ai_usage.py(취합) · guess_scan LLM 탐지에 llm_call.ask 추가(원장 78건 등록)
- 확인: engine_selfcheck PASS(10:14:23) · VM test 33파일 PASS 402 FAIL 0(10:16:40) · 실제 CheckList 동작 미측정(사용자 실행)
- 남은 것: 행 ID 규칙 변경(승인 결정 3)은 하지 않음 — 11-20 SCP0028 ID 변동 221건의 원인이 줄 번호가 아니라 다른 문서 행 묶음 변경이라 기준 원장(내용 기반 번호)으로 대신함. UI/DB MODE 실화면 시범 미실행(현재 DB MODE)
- 백업 *.bak_20261120_aipts · 사본·패치 tools/Harness/_verify_next/
