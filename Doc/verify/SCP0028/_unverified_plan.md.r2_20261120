# SCP0028 미검증 행별 조치 표 · 2026-11-20 라운드 · 2026-11-20 08:24

- 입력: unverified_triage.csv(07:48:27), 원장 verify_ledger.csv(07:38). 처리 대상 111행(엔진 81, 판단 30), 집계 113행은 하위 행을 따라감
- 표 행 수 111 = 처리 대상 111. 빠진 행 0, 목록 밖 행 0(생성 스크립트 _unverified_plan_gen.py 확인)

## 묶음

| 묶음 | 행 수 | 원인(실측) | 고친 곳 | 다음 CheckList 판정(미측정) |
|---|---|---|---|---|
| A 화면 단추 Delete 를 툴바 Delete 로 셈(T430) | 7 | SubTitle.tsx:397~468 화면 단추(customButtons 'Delete' 일괄삭제 팝업)가 툴바 'Delete(F9)' 앞에 그려짐. eg_auth.spec.ts:316 `/^Delete/`·nscm.subButton('Delete').first() 가 화면 단추를 잡음. AS-IS btnDelete ButtonAccessType None(Designer.cs:408) | tools/E2E/lib/nscm.ts toolbarButton·subButtonVisible · tools/E2E/lib/authprobe.ts toolbarRe·customLike · Doc/e2e/specs/eg_auth.spec.ts EG369·EG374·EG411 · tools/E2E/lib/crud.ts 마커 정리 Delete | 툴바 Delete(F9) 기준 실측(SCM Viewer DELETE 권한 N → 비노출이면 PASS) |
| B Insert 무동작 화면 crud insert 경로(T431) | 1 | AS-IS InsertButton→InsertRow 본문 비어 있음(cs:200~203, 571~573 · asisInsertNoop 실행 문장 0). crud.ts 가 Insert 단추가 보이면 마커 행 경로를 고름 | tools/E2E/lib/crud.ts insertNoop(AS-IS 사실 actions·actions_entries) → 기존 행 수정 저장 경로 | 행 'E2E crud 저장 왕복(insert)' 대신 '(edit-save)' 행이 실측(통과 또는 오류) |
| C 숫자 칸 글자 누락을 재조회 미반영으로 적음(T432) | 1 | results.json crud 기록: '12801' 입력 → 저장 요청 lotSize '1'·'12'·'1280' · 재조회 '1'·'12' 미반영. 후보 고르기가 표시값이 원값과 다르기만 하면 성공으로 봄 | tools/E2E/lib/crud.ts 숫자 칸 표시값 = 입력값 확인 · 다르면 typeCell 재입력 · 그래도 다르면 재조회로 입력 버리고 다음 후보 | 저장 후 재조회 실측(통과 또는 오류). 입력 경로 실패면 [입력 경로 실패] 사유 |
| D 정렬 키 NULL 가능 여부를 같은 이름 칸 전체로 봄(T433) | 1 | sort_ci_check.py nullable(k) = ALL_TAB_COLUMNS 같은 이름 칸 하나라도 NULL 가능이면 참. PKG_SCP0028 본문(ALL_SOURCE 300~382) 키 5개의 원본 = SCP_MST_SHIPMENT_LOT_SIZE A, NOT NULL(사내 오라클 08:0x 조회) | tools/Harness/verify/sort_ci_check.py stmt_before·key_source(별칭 → 원본 표 · 바깥 조인은 NULL 가능) · 시험 21/21 | 본 조회 SP 문자 키 5개 PASS 경로(TRANS_MODE_CODE 자료형 모름 1건 기록) |
| E 조회조건 Model 라벨·입력 경로(T434·T442) | 6 | TO-BE 라벨 'Model/Nickname'(ShipmentLotSizeForm.tsx:194). 기준표 search_cond.csv 에서 AS-IS 'Model' → 'Model/Nickname' 75/78행(CR-065). _verify G8·G9 는 body 에서 'Model' 글자(그리드 머리글)를 라벨로 잡아 다른 입력칸에 씀(조회 1940행 · 본문에 입력값 없음) | tools/Harness/verify/judge.py H5 기준표 행 0 경로 표준 명칭 · tools/E2E/lib/labelalias.ts stdAlias · tools/E2E/lib/smoke-extra.ts findCond · Doc/e2e/specs/_verify.spec.ts findSearchBox·G8/G9 라벨(그리드·대화상자 안 글자 제외) | H5 PASS(기준표 표준 명칭) · G1·G2·G8·G9·부분일치 실측(통과 또는 오류) |
| F 탭 이름 기대값 = 메뉴 메시지 코드 번역 글자(T435) | 1 | menu.csv mnu_msg_id MNU00091, msg_master.csv KO·EN·CN 'SSP Lot Size'. 검사기는 mnu_desc 'Shipment Lot Size' 만 기대 | tools/E2E/lib/labeltrans.ts msgTexts · Doc/e2e/specs/_verify.spec.ts 탭 이름 | PASS 경로(탭 SSP Lot Size = MNU00091) |
| G 그룹 권한 동기화 = TO-BE 권한 설정 기준(T436 · CR-116) | 1 | menu_auth_sync.json FAIL 2건(CAPA Planner·SSP ADMIN EDIT: AS-IS 허용 ↔ TO-BE 불가). SCP0104 V-24ff60ab [사용자판정] 'TO-BE 의 설정된 권한과 일치하면 오류 아님' | tools/Harness/rules/confirmed_requirements.csv CR-116 · tools/Harness/verify/judge.py J4 권한 동기화 · tobe_rule_registry --build/--check rc 0 | PASS(차이 2건 근거 기록) · 결정 목록 D8 에 권한 데이터 확인 여부 |
| H 팝업 필수 알림을 화면 조회조건 G6 로 셈(T437) | 1 | G6 증거 'From Site 후보 없음 ← From Site 값은 필수'. 일괄입력 팝업 'I' Find 필수 알림(SCM0002_ShipmentLotSizePopup.cs:261~266)이 search() 중 떠 화면 기록에 섞임 | tools/E2E/lib/nscm.ts search 필수 알림 때 그리드 팝업이 열려 있으면 popupRequiredNotes 로 분리 | 화면 조회조건 기록 기준 판정(팝업 알림 제외) |
| I 콤보 원천 추출(T438 · cboValid · 호출 없는 메서드) | 14 | facts_combosrc.py 가 cboValid.DataBind(Data.Type.YesOrNo, true)(cs:135 · UsrComboBox.cs:34~44 = Data.Common)를 원천으로 읽지 않음. 호출 없는 private ClearUsrCheckedList(cs:149~156) 안 setListBox 를 'control' 원천 미발견 행으로 기록. b7_check (a) '원천 미확인 1종: control' 이 B7 8행 판단 사유 | tools/Harness/verify/facts_combosrc.py DataBind 바인딩·dead_private · Doc/asisfacts/screens/SCP0028/combo_src.csv 재생성(control 행 빠짐 · cboValid STATIC YesOrNo 행 생김) | B7 (a) 원천 미확인 0종 경로 · Valid B3·B4·G1·G7 원천 있음으로 실측(통과 또는 오류) |
| J 신규 행 결함 유형 = Insert 무동작 화면 대상 없음(T439) | 3 | judge 'Insert 없음' 분기(_no_insert)가 Insert 단추는 있고 AS-IS 본문이 빈 화면을 보지 않음. 같은 원장 C2·C3 TRACE 4행 NA 'Insert 무동작 = AS-IS 파리티' | tools/Harness/verify/judge.py _no_insert 에 AS-IS Insert 무동작 근거 행 | NA(신규 행 결함 유형 대상 없음) |
| K 병합 셀 Delete 가 화면 단추를 누름(T440) | 1 | _verify.spec.ts 병합 셀 Delete 가 nscm.subButton('Delete') 로 일괄삭제 팝업 단추를 누름(알림 글자 'SSP Lot Size - Delete Div …' = 팝업 제목). AS-IS Delete 는 신규(I) 행만 지움(asisDeleteNewOnly DeleteButton:223) | Doc/e2e/specs/_verify.spec.ts 툴바 Delete · tools/E2E/lib/mergecheck.ts asisNewOnly(시험 35/35) | NA(기존 병합 행 D 표시 대상 아님) 또는 서버 요청·일부 D 면 FAIL |
| L 조회 전 Delete 프로브 없음(T441) | 1 | _verify.spec.ts D4 조회 전 프로브가 Insert 만 구현('Delete 조회 전 프로브 미구현') | Doc/e2e/specs/_verify.spec.ts 조회 전 툴바 Delete 프로브(쓰기 요청 차단) | 실측(행 수·D 표시·쓰기 요청 0 이면 PASS) |
| M 팝업 검사 호출 기록 없음(T443 · 다른 세션 T405) | 3 | eg_chain 이 CL_SELFTEST_BASE 로 실행돼 fixture 가 calls/*.json 을 남기지 않음(calls 폴더에 eg_* 파일 0). 팝업 조회 SCP0028/popup/SEARCH 는 _trace W4b 기록에 있음(07:55 judge T405 판정 경로) | tools/E2E/fixtures/test.ts EG_CHAIN 이면 기록 · tools/Harness/verify/eg_chain.py EG_CHAIN=1 | F4 호출 기록 판정(T405). A6 T-653f1a5d 는 SQL 로그 기준이라 미측정 |
| N 시나리오 단추·조건 라벨(T444) | 2 | 시나리오 'btn Input' 은 영문만 찾음(측정 계정 KO '입력' LBL00872). 'iscombo Division' 은 TO-BE 라벨 'Div.' 를 못 찾음 | Doc/e2e/specs/_verify.spec.ts 시나리오 btn·iscombo 라벨 후보(labelVariants · Div↔Division · 명칭 변경 룰 · 기준표 표준 명칭) | 실측(통과 또는 오류) |
| O 신규 행 전제 시나리오(T445) | 3 | 증거 'Insert 뒤 행이 늘지 않음(1940→1940)' · 'insert:1940행·신규0' 이 T362 insert_noop_na 문구표에 없음 | tools/Harness/verify/judge.py NEWROW_MISS_RE·NEWROW_STEP_RE(대상 이름에 신규·Insert 가 있는 행만 · 단위 시험 2행 NA · 편집 중 Input 행 유지) | NA(AS-IS 신규 행 없음) |
| P 원값 복원 숫자 칸 입력(T446) | 1 | _verify.spec.ts 원값 복원이 편집기 주입만 써서 LOT_SIZE 값이 안 바뀜('12,800') | Doc/e2e/specs/_verify.spec.ts 값이 안 바뀌면 typeCell 키보드 입력 · 원복도 같은 방식 | 실측(통과 또는 오류) |
| Q 골든 인자 선언 기본값 빈 글자(T447) | 1 | Doc/golden/SCP0028/SCP0028_GET_SHIPMENT_LOT_SIZE.md 06:14 '파라미터 값 미정' SKIP · @p_to_site NVARCHAR(max)='' 기본값을 넣고도 빈 값으로 셈 | tools/DbConn/golden.py 선언 기본값 빈 글자 = 의도된 빈 값 | A7 컬럼 비교 실측(통과 또는 오류) |
| R EditButton SwitchLock 문장(T448) | 1 | AS-IS EditButton cs:229~235 SwitchLock 뒤 LockColumn. TO-BE 룰 CR-084·CR-093(편집 버튼 없이 진입 즉시 편집) | tools/Harness/verify/judge.py CR-093 블록에 SwitchLock 문장 행 | NA(TO-BE 룰 CR-084·CR-093 · 편집 칸은 D1 컬럼 행) |
| S 팝업 EG 행 이어받기 = 집계(분류표) | 8 | 증거 'AS-IS 팝업 문장 … 규칙 H6·M3 실측 N행을 이어받음' = 팝업 EG 행 판정을 따라가는 행. 미분류였음 | tools/Harness/verify/unverified_classes.csv 11 집계 행 | 하위 행(EG-6cc339e1·EG-273588ca 등)을 따라감 |
| T 공용 권한 SP F4(T449) | 1 | PR_GET_MNU_BTN_AUTH 는 공용 권한 경로(useTabBtnPermissions.ts:57 GET /admin/menu/{menuId}/auth)로 불림. 검사기는 PROC_M 배선만 봄 | tools/Harness/verify/judge.py F4 공용 권한 SP = 같은 실행 EG374·EG411 버튼 권한 실측 | EG374·EG411 실측 따라 PASS 또는 FAIL |
| U 이번 라운드 미보완(엔진 확장 필요) | 34 | K3 6행: 시험이 메인 그리드만 잼(증거 '미포함: 팝업 그리드'). H6·G5·M4 18행: 팝업 선택값 반영·팝업 칸 시나리오 실행 경로 없음(일괄입력 팝업은 From Site 필수 Find 뒤 행 생김). 팝업 Delete(FindDelete MSG00031·MSG00284)·btnDelete G4 5행: 팝업 Delete 시나리오 없음. F4 T-6b9a8ce8·A7 V-8da88867: 입력용 SP 는 일괄입력 팝업 확인 때만 불림(인자 = 선택 행 목록). C2 5행: 연쇄 결함 유형 대상 칸(AS From Site·Cust Group·Measure)과 이 화면 칸 이름이 겹침(지난 라운드 D7) | 이번 라운드 수정 없음. C2 5행은 지난 라운드 권장안 그대로 결정 목록 D9 | 미검증 유지 |
| W 다른 세션 보완분(SSP0014 T385) | 1 | From Site 멀티선택 'AU000062_81-P' 1개 조회 → 0행 · 결과 칸 FROM_SITE_DESCRIPTION 값에서 후보를 못 찾아 임의 후보 선택. SSP0014 세션 T385(_trace.spec.ts:1491 · 07:54 · 결과 값 코드 ↔ 후보 이름 환산)와 같은 증상 | 이번 라운드 수정 없음(다른 세션 보완분) | 실측(통과 또는 오류) |
| V 동시 실행 조건(재수행) | 2 | 시나리오 지정 계정 dana.robot 이라 언어 전용 계정(langacct)을 쓰지 않고, 같은 시각 다른 화면 E2E(SCP0005·SSP0005·SSP0014) 때문에 언어 전환을 건너뜀(T200 보호) | 수정 없음(다른 화면 E2E 와 같이 돌 때 계정 언어를 바꾸지 않는 보호 동작) | 다른 화면 E2E 가 없을 때 실측 |

## 결정 목록으로 보낸 행

| 결정 | 행 수 | 근거 |
|---|---|---|
| D1 | 4 | AS-IS SaveData(cs:583~609)는 한 칸만 비운 수정 행을 수정 건수에 세고 checkRequiredOfSpread 필수 안내로 막음. TO-BE 실측 '저장 요청·안내 모두 없음'. 공란 입력이 수정 상태(M)를 만들었는지 실측 없음 |
| D2 | 1 | AS-IS 팝업 더블클릭 = 선택 후 닫기(SCM0002_ItembyDivisionPopup.cs:316~320). TO-BE 공용 모달(COM0013 MaterialByDivisionModal) 더블클릭 뒤 닫히지 않음(OK 경로는 반영) |
| D3 | 2 | 대조표 17행이 쓰지 않는 SP(P_SCM0002_GET_ITEM_BY_DIVISION_POPUP)를 적음. FE 가이드 FE_GUIDE_20261120_0817.md G1. 팝업 교체(COM0013)는 코드 주석 '사용자 지시 2026-10-08' 말고 등록 룰 없음(fixlist FX-SCP0028-018·019 AI 검토 실결함) |
| D4 | 2 | AS-IS 팝업 고정 플래그 _action_flag D·I 를 TO-BE 는 setBatchMode(I·D)로 전달(ShipmentLotSize.tsx:338~344). CR-096 은 공용 검색 모달 대상이라 화면 고유 일괄 팝업에는 직접 해당 안 함 |
| D5 | 1 | AS-IS cboValid.DataBind(Data.Type.YesOrNo, true)(cs:135) = 단일 콤보 + ALL. TO-BE 단일 + ALL(실측 다중=false · ALL=true). 조회조건 기준표 행 0 |
| D6 | 2 | 일괄입력 팝업: 건수 문구 없음(DM-C8 기대) · 'I' 진입 자동 조회 없이 Find 때 From Site 필수 알림(AS-IS 같은 동작 cs:261~266)으로 행 0 |
| D7 | 1 | 화면 고정 한글 '{0}은 {1} 보다 클 수 없습니다.'(useShipmentLotSizeValidation.ts:52) |
| D8 | 1 | CR-116 등록(사용자의견 SCP0104 V-24ff60ab 일반화). TO-BE 권한 설정에 SCP0028 EDIT 없는 그룹 2개(CAPA Planner, SSP ADMIN · AS-IS CRUD) |
| D9 | 5 | 다른 화면 연쇄 결함 유형(DMF0003·DMF0082 AS From Site, DMF0005 Cust Group, Measure, 상위 셀 cascade). SCP0028 그리드 연쇄 칸 없음(C2 TRACE 2행 NA). 칸 이름(From Site·Active)만 겹침 |
| D10 | 1 | H2 배경색 조건(M 행, LOT_SIZE와 INCREMENT 공란, VALID Y, SPLIT N)을 만족하는 행 0(Div 40 265행) |
| D11 | 2 | PR_GET_MNU_BTN_AUTH 정렬(A6)·시노님(DB-SYN). 공용 권한 SP(PKG_NSCM_UI_COM_AUTH) |

## 행별

| 행 ID | 담당 | 유형 | 규칙 | 대상 | 조치 |
|---|---|---|---|---|---|
| V-564a1ac4 | 판단 | 판단 | F5 | SCP0028 병합 셀 Delete 범위 | K 병합 셀 Delete 가 화면 단추를 누름(T440) |
| V-4b34e536 | 엔진 | 검사기공백 | F5 | SCP0028 원값 복원 상태 해제 | P 원값 복원 숫자 칸 입력(T446) |
| V-ca2072cf | 엔진 | 검사기공백 | I1 | SCP0028 시나리오 KO 변경 없이 저장 → KO 수정사항 없음 알림 | V 동시 실행 조건(재수행) |
| V-1f64fec6 | 엔진 | 검사기공백 | E4 | SCP0028 시나리오 KO Increment > Lot Size 저장 → KO 검증 문구 | V 동시 실행 조건(재수행) |
| V-0c97a0f1 | 엔진 | 검사기공백 | D6 | SCP0028 시나리오 [자동] 선택 행 위로 Insert | O 신규 행 전제 시나리오(T445) |
| V-93d3cad9 | 엔진 | 검사기공백 | F3 | SCP0028 시나리오 [자동] VALID_YN 기존 행 셀 Copy → 신규 행 붙여넣기 — 후보 밖 값(비활성 등) 행에서 | O 신규 행 전제 시나리오(T445) |
| V-eeb010ff | 엔진 | 검사기공백 | F3 | SCP0028 시나리오 [자동] SPLIT_YN 기존 행 셀 Copy → 신규 행 붙여넣기 — 후보 밖 값(비활성 등) 행에서 | O 신규 행 전제 시나리오(T445) |
| V-a1923fff | 엔진 | 검사기공백 | H10 | SCP0028 시나리오 [자동] 편집 중 Input 실행 → MSG00680(DM-52 일반 규칙) | N 시나리오 단추·조건 라벨(T444) |
| V-5a8ff1e6 | 엔진 | 검사기공백 | B1 | SCP0028 시나리오 [자동] 조회조건 콤보 6종 = 콤보 | N 시나리오 단추·조건 라벨(T444) |
| V-d9f71764 | 판단 | 판단 | E3 | SCP0028 필수 공란 Shipment Lot Size.INCREMENT | D1 |
| V-d7cde174 | 판단 | 판단 | E3 | SCP0028 필수 공란 Shipment Lot Size.LOT_SIZE | D1 |
| V-a5e26726 | 판단 | 판단 | E3 | SCP0028 필수 공란 Shipment Lot Size.SPLIT_YN | D1 |
| V-fbb3bbaf | 판단 | 판단 | E3 | SCP0028 필수 공란 Shipment Lot Size.VALID_YN | D1 |
| V-ee003a13 | 엔진 | 검사기공백 | A7 | SCP0028_GET_SHIPMENT_LOT_SIZE | Q 골든 인자 선언 기본값 빈 글자(T447) |
| V-8da88867 | 엔진 | 검사기공백 | A7 | SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT | U 이번 라운드 미보완(엔진 확장 필요) |
| V-d081074c | 엔진 | 데이터전제 | B3 | 조회조건 Valid | I 콤보 원천 추출(T438 · cboValid · 호출 없는 메서드) |
| V-2c13dbe7 | 엔진 | 데이터전제 | B4 | 조회조건 Valid | I 콤보 원천 추출(T438 · cboValid · 호출 없는 메서드) |
| V-5d06fca9 | 판단 | 판단 | B6 | 조회조건 Valid | D5 |
| V-13254dec | 판단 | 판단 | B7 | 조회조건 Valid | I 콤보 원천 추출(T438 · cboValid · 호출 없는 메서드) |
| V-602d9026 | 엔진 | 검사기공백 | G1 | 조회조건 Valid | I 콤보 원천 추출(T438 · cboValid · 호출 없는 메서드) |
| V-00ec53f0 | 엔진 | 검사기공백 | G7 | 조회조건 Valid | I 콤보 원천 추출(T438 · cboValid · 호출 없는 메서드) |
| V-02cca4b6 | 판단 | 판단 | B7 | 조회조건 Division* | I 콤보 원천 추출(T438 · cboValid · 호출 없는 메서드) |
| V-9e2b9258 | 엔진 | 검사기공백 | G1 | 조회조건 Model | E 조회조건 Model 라벨·입력 경로(T434·T442) |
| V-db17a330 | 엔진 | 검사기공백 | G2 | 조회조건 Model | E 조회조건 Model 라벨·입력 경로(T434·T442) |
| V-99331be4 | 엔진 | 검사기공백 | G5 | 조회조건 Model | U 이번 라운드 미보완(엔진 확장 필요) |
| V-9058bd2c | 엔진 | 검사기공백 | H5 | 조회조건 Model | E 조회조건 Model 라벨·입력 경로(T434·T442) |
| V-93e5a09c | 엔진 | 미분류 | G8 | 조회조건 Model | E 조회조건 Model 라벨·입력 경로(T434·T442) |
| V-ed2ee896 | 엔진 | 미분류 | G9 | 조회조건 Model | E 조회조건 Model 라벨·입력 경로(T434·T442) |
| V-e3cbb602 | 판단 | 판단 | B7 | 조회조건 Operation Group | I 콤보 원천 추출(T438 · cboValid · 호출 없는 메서드) |
| V-fcba9999 | 판단 | 판단 | B7 | 조회조건 From Site | I 콤보 원천 추출(T438 · cboValid · 호출 없는 메서드) |
| V-dd4f9db4 | 엔진 | 미분류 | G1 | 조회조건 From Site | W 다른 세션 보완분(SSP0014 T385) |
| V-e7534976 | 판단 | 판단 | B7 | 조회조건 Trans Mode | I 콤보 원천 추출(T438 · cboValid · 호출 없는 메서드) |
| V-8c12aeea | 판단 | 판단 | B7 | 조회조건 To Site | I 콤보 원천 추출(T438 · cboValid · 호출 없는 메서드) |
| V-6f2c58ff | 판단 | 판단 | G1 | SCP0028 텍스트 부분일치 Model | E 조회조건 Model 라벨·입력 경로(T434·T442) |
| V-b1aa0c11 | 엔진 | 검사기공백 | D1 | siMain.SwitchLock | R EditButton SwitchLock 문장(T448) |
| V-86e7f1e2 | 엔진 | 검사기공백 | G1 | MSG00031 | U 이번 라운드 미보완(엔진 확장 필요) |
| V-a89007be | 엔진 | 검사기공백 | G1 | MSG00284 | U 이번 라운드 미보완(엔진 확장 필요) |
| V-a99ddb18 | 엔진 | 데이터전제 | H2 | siMain.SetBGColor | D10 |
| V-aa6bec9e | 집계 | 집계 | H6 | new SCM0002_ShipmentLotSizePopup() | S 팝업 EG 행 이어받기 = 집계(분류표) |
| V-180ef854 | 집계 | 집계 | M3 | new SCM0002_ShipmentLotSizePopup() | S 팝업 EG 행 이어받기 = 집계(분류표) |
| V-480372c9 | 판단 | 판단 | G5 | popItem.Form_Load("D", sDivision_id.ToString()) | D4 |
| V-6cb6bfa8 | 집계 | 집계 | H6 | popItem.Form_Load("D", sDivision_id.ToString()) | S 팝업 EG 행 이어받기 = 집계(분류표) |
| V-d816896f | 집계 | 집계 | H6 | popItem.ShowDialog() | S 팝업 EG 행 이어받기 = 집계(분류표) |
| V-c2d97238 | 집계 | 집계 | H6 | new SCM0002_ShipmentLotSizePopup() | S 팝업 EG 행 이어받기 = 집계(분류표) |
| V-b2d03a00 | 집계 | 집계 | M3 | new SCM0002_ShipmentLotSizePopup() | S 팝업 EG 행 이어받기 = 집계(분류표) |
| V-86b2f489 | 판단 | 판단 | G5 | popItem.Form_Load("I", sDivision_id.ToString()) | D4 |
| V-d41bec0d | 집계 | 집계 | H6 | popItem.Form_Load("I", sDivision_id.ToString()) | S 팝업 EG 행 이어받기 = 집계(분류표) |
| V-5123358d | 집계 | 집계 | H6 | popItem.ShowDialog() | S 팝업 EG 행 이어받기 = 집계(분류표) |
| V-b48e5d97 | 판단 | 판단 | D4 | DeleteButton 전제 fps | L 조회 전 Delete 프로브 없음(T441) |
| V-4c3670c9 | 엔진 | 미분류 | K3 | 전체 팝업 No. 컬럼·건수 · Contribution Sales Version 팝업 그리드 | U 이번 라운드 미보완(엔진 확장 필요) |
| V-78baf3af | 엔진 | 미분류 | K3 | 그리드 Ctrl+클릭 다중 선택(Version 팝업 포함) | U 이번 라운드 미보완(엔진 확장 필요) |
| V-f3e94ee4 | 엔진 | 검사기공백 | C2 | [DMF0005 결함 유형] Cust Group-End Customer-Sales Site 관계 · Active 컬럼 | U 이번 라운드 미보완(엔진 확장 필요) · D9 |
| V-e9891c92 | 엔진 | 검사기공백 | C2 | [DMF0003 결함 유형] AS From Site 입력 후 W35~W38 수량 | U 이번 라운드 미보완(엔진 확장 필요) · D9 |
| V-04302ccf | 엔진 | 미분류 | K3 | [DMF0049 결함 유형] 신규 입력 그리드(복사/붙여넣기·한글 입력·자동완성·병합 셀) | U 이번 라운드 미보완(엔진 확장 필요) |
| V-2611b990 | 엔진 | 검사기공백 | C2 | [DMF0082 결함 유형] Current 버전 입력 Measure(MKT_FCST·SCM_FCST·Unit Price·AS_ | U 이번 라운드 미보완(엔진 확장 필요) · D9 |
| V-9b370c0f | 엔진 | 검사기공백 | C2 | [DMF0082 결함 유형] AS From Site 활성·콤보, Measure 후보 | U 이번 라운드 미보완(엔진 확장 필요) · D9 |
| V-4625c728 | 판단 | 판단 | B7 | [DMF0005 결함 유형] Team 조회조건 후보 | I 콤보 원천 추출(T438 · cboValid · 호출 없는 메서드) |
| V-67a95082 | 엔진 | 검사기공백 | C2 | [SCP0007 결함 유형] Insert 행 Div 셀 / 하위 Site | J 신규 행 결함 유형 = Insert 무동작 화면 대상 없음(T439) |
| V-e01416ce | 엔진 | 검사기공백 | C3 | [SCP0007 결함 유형] Insert 행 To Site 콤보·City | J 신규 행 결함 유형 = Insert 무동작 화면 대상 없음(T439) |
| V-5357957b | 엔진 | 검사기공백 | C3 | [DMF0003 결함 일반화] 신규 행 Project 팝업(PROJECT_CODE → PROJECT_NAME·PROJECT_S | J 신규 행 결함 유형 = Insert 무동작 화면 대상 없음(T439) |
| V-b9c4dc0d | 판단 | 판단 | B7 | [결함 유형 묶음 B7-G01 · 3건] 저장 후 마스터 조회조건 콤보 후보 | I 콤보 원천 추출(T438 · cboValid · 호출 없는 메서드) |
| V-df3bcadf | 엔진 | 검사기공백 | C2 | [결함 유형 묶음 C2-G06 · 4건] 그리드 상위 셀 변경 시 하위 셀 cascade | U 이번 라운드 미보완(엔진 확장 필요) · D9 |
| V-cbcda052 | 엔진 | 미분류 | K3 | [결함 유형 묶음 K3-G01 · 1건] 그리드 Ctrl+클릭 다중 선택(팝업 그리드 포함) | U 이번 라운드 미보완(엔진 확장 필요) |
| V-6cf2af49 | 엔진 | 미분류 | K3 | [결함 유형 묶음 K3-G02 · 2건] 조회 단축키(F5) 실행 | U 이번 라운드 미보완(엔진 확장 필요) |
| V-729c8d58 | 엔진 | 미분류 | K3 | 그리드 Ctrl+클릭 다중 선택(Version 팝업 포함) | U 이번 라운드 미보완(엔진 확장 필요) |
| V-db0f51c6 | 엔진 | 검사기공백 | H6 | SCP0028 스냅샷 팝업 Model | U 이번 라운드 미보완(엔진 확장 필요) |
| T-a239a7e1 | 엔진 | 검사기공백 | H6 | txtItemId / Model / Item Id | U 이번 라운드 미보완(엔진 확장 필요) |
| T-ba663c76 | 판단 | 판단 | M4 | txtItemId / Model / Item Id | U 이번 라운드 미보완(엔진 확장 필요) |
| T-c5782dcb | 판단 | 판단 | M4 | btnItemId | U 이번 라운드 미보완(엔진 확장 필요) |
| T-2c20a3fc | 엔진 | 검사기공백 | A6 | PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP | D3 |
| T-653f1a5d | 엔진 | 검사기공백 | A6 | PKG_SCM0002.P_SCM0002_GET_MATERIAL_BY_DIVISION | M 팝업 검사 호출 기록 없음(T443 · 다른 세션 T405) |
| T-fad117f6 | 엔진 | 검사기공백 | F4 | PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP | D3 |
| T-a9985ef6 | 엔진 | 검사기공백 | F4 | PKG_SCM0002.P_SCM0002_GET_MATERIAL_BY_DIVISION | M 팝업 검사 호출 기록 없음(T443 · 다른 세션 T405) |
| T-6dc0e2d5 | 판단 | 판단 | A6 | PR_GET_MNU_BTN_AUTH | D11 |
| T-52d59336 | 엔진 | 검사기공백 | DB-SYN | PR_GET_MNU_BTN_AUTH | D11 |
| T-8ef356b6 | 판단 | 판단 | M4 | btnInput | U 이번 라운드 미보완(엔진 확장 필요) |
| T-2a9cd623 | 판단 | 판단 | M4 | btnDelete | U 이번 라운드 미보완(엔진 확장 필요) |
| T-449b82ac | 엔진 | 검사기공백 | H6 | clbFromSite / From Site | U 이번 라운드 미보완(엔진 확장 필요) |
| T-247bdc3c | 엔진 | 검사기공백 | G5 | clbFromSite / From Site | U 이번 라운드 미보완(엔진 확장 필요) |
| T-5bb8509f | 판단 | 판단 | M4 | clbFromSite / From Site | U 이번 라운드 미보완(엔진 확장 필요) |
| T-0855373f | 엔진 | 검사기공백 | H6 | clbToSite / To Site | U 이번 라운드 미보완(엔진 확장 필요) |
| T-57afcab2 | 엔진 | 검사기공백 | G5 | clbToSite / To Site | U 이번 라운드 미보완(엔진 확장 필요) |
| T-84c5ee4c | 판단 | 판단 | M4 | clbToSite / To Site | U 이번 라운드 미보완(엔진 확장 필요) |
| T-c7a94f1d | 엔진 | 검사기공백 | H6 | TRANS_MODE_CODE / Trans Mode | U 이번 라운드 미보완(엔진 확장 필요) |
| T-3dbd9fe5 | 엔진 | 검사기공백 | G5 | TRANS_MODE_CODE / Trans Mode | U 이번 라운드 미보완(엔진 확장 필요) |
| T-41bb3f1f | 판단 | 판단 | M4 | TRANS_MODE_CODE / Trans Mode | U 이번 라운드 미보완(엔진 확장 필요) |
| T-6b9a8ce8 | 엔진 | 검사기공백 | F4 | PKG_SCP0028.P_SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT | U 이번 라운드 미보완(엔진 확장 필요) |
| T-f43dac0f | 엔진 | 검사기공백 | F4 | PKG_SCP0028.P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP | M 팝업 검사 호출 기록 없음(T443 · 다른 세션 T405) |
| T-0caf6c62 | 엔진 | 검사기공백 | E4 | MSG00031 | U 이번 라운드 미보완(엔진 확장 필요) |
| T-4677b9e5 | 엔진 | 검사기공백 | E4 | MSG00284 | U 이번 라운드 미보완(엔진 확장 필요) |
| T-d6ad4a4e | 엔진 | 검사기공백 | G4 | btnDelete | U 이번 라운드 미보완(엔진 확장 필요) |
| EG-6cc339e1 | 판단 | 판단 | H6 | SCP0028 팝업 SCM0002_ShipmentLotSizePopup BTN:Input COUNT | D6 |
| EG-273588ca | 판단 | 판단 | M3 | SCP0028 팝업 SCM0002_ShipmentLotSizePopup BTN:Input DATA | D6 |
| EG-ea38ffcb | 판단 | 판단 | M4 | SCP0028 팝업 SCM0002_ItembyDivisionPopup COND:Model PICK_DBL | D2 |
| EG-bd80125c | 판단 | 판단 | MS1 | SCP0028 화면 고정 한글 {0}은 {1} 보다 클 수 없습니다. | D7 |
| V-4121e73d | 엔진 | AI검토:검사기오판 | F1 | SCP0028 화면 | C 숫자 칸 글자 누락을 재조회 미반영으로 적음(T432) |
| V-b45d4015 | 엔진 | AI검토:검사기오판 | J4 | SCP0028 탭 이름 | F 탭 이름 기대값 = 메뉴 메시지 코드 번역 글자(T435) |
| V-388e3fd3 | 엔진 | AI검토:검사기오판 | G6 | SCP0028 필수 조건 자동 채움(검사기 우회 기록) | H 팝업 필수 알림을 화면 조회조건 G6 로 셈(T437) |
| V-15f47ff2 | 엔진 | AI검토:검사기오판 | J4 | 그룹ID별 메뉴·버튼 권한(MENU AUTH · BTN AUTH) 운영데이터 동기화 | G 그룹 권한 동기화 = TO-BE 권한 설정 기준(T436 · CR-116) · D8 |
| T-c770299c | 엔진 | AI검토:검사기오판 | F4 | PR_GET_MNU_BTN_AUTH | T 공용 권한 SP F4(T449) |
| EG-7a88dc15 | 엔진 | AI검토:검사기오판 | J2 | SCP0028 EG374 DELETE 버튼 조회 전 SCP/40/SCM Viewer | A 화면 단추 Delete 를 툴바 Delete 로 셈(T430) |
| EG-a0ea432d | 엔진 | AI검토:검사기오판 | K4 | SCP0028 EG411 DELETE 버튼 조회 전 SCP/40/SCM Viewer | A 화면 단추 Delete 를 툴바 Delete 로 셈(T430) |
| EG-1e23ee08 | 엔진 | AI검토:검사기오판 | J2 | SCP0028 EG374 DELETE 버튼 조회 전 SCP/81/SCM Viewer | A 화면 단추 Delete 를 툴바 Delete 로 셈(T430) |
| EG-e6cfb2a1 | 엔진 | AI검토:검사기오판 | K4 | SCP0028 EG411 DELETE 버튼 조회 전 SCP/81/SCM Viewer | A 화면 단추 Delete 를 툴바 Delete 로 셈(T430) |
| EG-b949a64b | 엔진 | AI검토:검사기오판 | J2 | SCP0028 EG374 DELETE 버튼 조회 전 SCP/82/SCM Viewer | A 화면 단추 Delete 를 툴바 Delete 로 셈(T430) |
| EG-3e88650e | 엔진 | AI검토:검사기오판 | K4 | SCP0028 EG411 DELETE 버튼 조회 전 SCP/82/SCM Viewer | A 화면 단추 Delete 를 툴바 Delete 로 셈(T430) |
| EG-78281d4c | 엔진 | AI검토:검사기오판 | A6 | SCP0028 문자 정렬 PKG_SCP0028.P_SCP0028_GET_SHIPMENT_LOT_SIZE | D 정렬 키 NULL 가능 여부를 같은 이름 칸 전체로 봄(T433) |
| ES-b81c0f8c | 엔진 | AI검토:검사기오판 | F1 | SCP0028 E2E authcrud 저장 왕복(no-save) zhangjiali | A 화면 단추 Delete 를 툴바 Delete 로 셈(T430) |
| ES-5b4cd8e1 | 엔진 | AI검토:검사기오판 | F1 | SCP0028 E2E crud 저장 왕복(insert) | B Insert 무동작 화면 crud insert 경로(T431) |
| FACT-78289eda | 엔진 | AI검토:추출오류 |  | combo_src.csv cboValid | I 콤보 원천 추출(T438 · cboValid · 호출 없는 메서드) |
| FACT-4f8bca15 | 엔진 | AI검토:추출오류 |  | combo_src.csv ClearUsrCheckedList | I 콤보 원천 추출(T438 · cboValid · 호출 없는 메서드) |
