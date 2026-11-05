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
