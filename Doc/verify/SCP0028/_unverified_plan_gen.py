"""SCP0028 미검증 2026-11-20 라운드(CheckList 07:38 원장) 행별 조치 표·결정 목록 생성, 이 라운드 기록용 일회성 스크립트"""
import csv
import os

HERE = os.path.dirname(os.path.abspath(__file__))
AT = '2026-11-20 08:24'
# 08:28 분류 갱신으로 S 묶음 8행(팝업 EG 행 이어받기)이 집계로 바뀜 → 07:48 기준 처리 대상 111행 = 집계 아닌 행 + 그 8행
S8 = {'V-aa6bec9e', 'V-6cb6bfa8', 'V-d816896f', 'V-c2d97238', 'V-d41bec0d', 'V-5123358d', 'V-180ef854', 'V-b2d03a00'}
r = [x for x in csv.DictReader(open(os.path.join(HERE, 'unverified_triage.csv'), encoding='utf-8-sig')) if x['actor'] != '집계' or x['row_id'] in S8]

# 묶음: (행, 원인(실측 근거), 고친 곳, 다음 CheckList 판정(미측정))
G = {
    'A 화면 단추 Delete 를 툴바 Delete 로 셈(T430)': (
        ['EG-7a88dc15', 'EG-1e23ee08', 'EG-b949a64b', 'EG-a0ea432d', 'EG-e6cfb2a1', 'EG-3e88650e', 'ES-b81c0f8c'],
        "SubTitle.tsx:397~468 화면 단추(customButtons 'Delete' 일괄삭제 팝업)가 툴바 'Delete(F9)' 앞에 그려짐. eg_auth.spec.ts:316 `/^Delete/`·nscm.subButton('Delete').first() 가 화면 단추를 잡음. AS-IS btnDelete ButtonAccessType None(Designer.cs:408)",
        'tools/E2E/lib/nscm.ts toolbarButton·subButtonVisible · tools/E2E/lib/authprobe.ts toolbarRe·customLike · Doc/e2e/specs/eg_auth.spec.ts EG369·EG374·EG411 · tools/E2E/lib/crud.ts 마커 정리 Delete',
        '툴바 Delete(F9) 기준 실측(SCM Viewer DELETE 권한 N → 비노출이면 PASS)'),
    'B Insert 무동작 화면 crud insert 경로(T431)': (
        ['ES-5b4cd8e1'],
        'AS-IS InsertButton→InsertRow 본문 비어 있음(cs:200~203, 571~573 · asisInsertNoop 실행 문장 0). crud.ts 가 Insert 단추가 보이면 마커 행 경로를 고름',
        'tools/E2E/lib/crud.ts insertNoop(AS-IS 사실 actions·actions_entries) → 기존 행 수정 저장 경로',
        "행 'E2E crud 저장 왕복(insert)' 대신 '(edit-save)' 행이 실측(통과 또는 오류)"),
    'C 숫자 칸 글자 누락을 재조회 미반영으로 적음(T432)': (
        ['V-4121e73d'],
        "results.json crud 기록: '12801' 입력 → 저장 요청 lotSize '1'·'12'·'1280' · 재조회 '1'·'12' 미반영. 후보 고르기가 표시값이 원값과 다르기만 하면 성공으로 봄",
        'tools/E2E/lib/crud.ts 숫자 칸 표시값 = 입력값 확인 · 다르면 typeCell 재입력 · 그래도 다르면 재조회로 입력 버리고 다음 후보',
        '저장 후 재조회 실측(통과 또는 오류). 입력 경로 실패면 [입력 경로 실패] 사유'),
    'D 정렬 키 NULL 가능 여부를 같은 이름 칸 전체로 봄(T433)': (
        ['EG-78281d4c'],
        'sort_ci_check.py nullable(k) = ALL_TAB_COLUMNS 같은 이름 칸 하나라도 NULL 가능이면 참. PKG_SCP0028 본문(ALL_SOURCE 300~382) 키 5개의 원본 = SCP_MST_SHIPMENT_LOT_SIZE A, NOT NULL(사내 오라클 08:0x 조회)',
        'tools/Harness/verify/sort_ci_check.py stmt_before·key_source(별칭 → 원본 표 · 바깥 조인은 NULL 가능) · 시험 21/21',
        '본 조회 SP 문자 키 5개 PASS 경로(TRANS_MODE_CODE 자료형 모름 1건 기록)'),
    'E 조회조건 Model 라벨·입력 경로(T434·T442)': (
        ['V-9058bd2c', 'V-9e2b9258', 'V-db17a330', 'V-93e5a09c', 'V-ed2ee896', 'V-6f2c58ff'],
        "TO-BE 라벨 'Model/Nickname'(ShipmentLotSizeForm.tsx:194). 기준표 search_cond.csv 에서 AS-IS 'Model' → 'Model/Nickname' 75/78행(CR-065). _verify G8·G9 는 body 에서 'Model' 글자(그리드 머리글)를 라벨로 잡아 다른 입력칸에 씀(조회 1940행 · 본문에 입력값 없음)",
        'tools/Harness/verify/judge.py H5 기준표 행 0 경로 표준 명칭 · tools/E2E/lib/labelalias.ts stdAlias · tools/E2E/lib/smoke-extra.ts findCond · Doc/e2e/specs/_verify.spec.ts findSearchBox·G8/G9 라벨(그리드·대화상자 안 글자 제외)',
        'H5 PASS(기준표 표준 명칭) · G1·G2·G8·G9·부분일치 실측(통과 또는 오류)'),
    'F 탭 이름 기대값 = 메뉴 메시지 코드 번역 글자(T435)': (
        ['V-b45d4015'],
        "menu.csv mnu_msg_id MNU00091, msg_master.csv KO·EN·CN 'SSP Lot Size'. 검사기는 mnu_desc 'Shipment Lot Size' 만 기대",
        'tools/E2E/lib/labeltrans.ts msgTexts · Doc/e2e/specs/_verify.spec.ts 탭 이름',
        'PASS 경로(탭 SSP Lot Size = MNU00091)'),
    'G 그룹 권한 동기화 = TO-BE 권한 설정 기준(T436 · CR-116)': (
        ['V-15f47ff2'],
        "menu_auth_sync.json FAIL 2건(CAPA Planner·SSP ADMIN EDIT: AS-IS 허용 ↔ TO-BE 불가). SCP0104 V-24ff60ab [사용자판정] 'TO-BE 의 설정된 권한과 일치하면 오류 아님'",
        'tools/Harness/rules/confirmed_requirements.csv CR-116 · tools/Harness/verify/judge.py J4 권한 동기화 · tobe_rule_registry --build/--check rc 0',
        'PASS(차이 2건 근거 기록) · 결정 목록 D8 에 권한 데이터 확인 여부'),
    'H 팝업 필수 알림을 화면 조회조건 G6 로 셈(T437)': (
        ['V-388e3fd3'],
        "G6 증거 'From Site 후보 없음 ← From Site 값은 필수'. 일괄입력 팝업 'I' Find 필수 알림(SCM0002_ShipmentLotSizePopup.cs:261~266)이 search() 중 떠 화면 기록에 섞임",
        'tools/E2E/lib/nscm.ts search 필수 알림 때 그리드 팝업이 열려 있으면 popupRequiredNotes 로 분리',
        '화면 조회조건 기록 기준 판정(팝업 알림 제외)'),
    'I 콤보 원천 추출(T438 · cboValid · 호출 없는 메서드)': (
        ['FACT-78289eda', 'FACT-4f8bca15', 'V-13254dec', 'V-02cca4b6', 'V-e3cbb602', 'V-fcba9999', 'V-e7534976', 'V-8c12aeea', 'V-4625c728', 'V-b9c4dc0d',
         'V-d081074c', 'V-2c13dbe7', 'V-602d9026', 'V-00ec53f0'],
        "facts_combosrc.py 가 cboValid.DataBind(Data.Type.YesOrNo, true)(cs:135 · UsrComboBox.cs:34~44 = Data.Common)를 원천으로 읽지 않음. 호출 없는 private ClearUsrCheckedList(cs:149~156) 안 setListBox 를 'control' 원천 미발견 행으로 기록. b7_check (a) '원천 미확인 1종: control' 이 B7 8행 판단 사유",
        'tools/Harness/verify/facts_combosrc.py DataBind 바인딩·dead_private · Doc/asisfacts/screens/SCP0028/combo_src.csv 재생성(control 행 빠짐 · cboValid STATIC YesOrNo 행 생김)',
        'B7 (a) 원천 미확인 0종 경로 · Valid B3·B4·G1·G7 원천 있음으로 실측(통과 또는 오류)'),
    'J 신규 행 결함 유형 = Insert 무동작 화면 대상 없음(T439)': (
        ['V-67a95082', 'V-e01416ce', 'V-5357957b'],
        "judge 'Insert 없음' 분기(_no_insert)가 Insert 단추는 있고 AS-IS 본문이 빈 화면을 보지 않음. 같은 원장 C2·C3 TRACE 4행 NA 'Insert 무동작 = AS-IS 파리티'",
        'tools/Harness/verify/judge.py _no_insert 에 AS-IS Insert 무동작 근거 행',
        'NA(신규 행 결함 유형 대상 없음)'),
    'K 병합 셀 Delete 가 화면 단추를 누름(T440)': (
        ['V-564a1ac4'],
        "_verify.spec.ts 병합 셀 Delete 가 nscm.subButton('Delete') 로 일괄삭제 팝업 단추를 누름(알림 글자 'SSP Lot Size - Delete Div …' = 팝업 제목). AS-IS Delete 는 신규(I) 행만 지움(asisDeleteNewOnly DeleteButton:223)",
        'Doc/e2e/specs/_verify.spec.ts 툴바 Delete · tools/E2E/lib/mergecheck.ts asisNewOnly(시험 35/35)',
        'NA(기존 병합 행 D 표시 대상 아님) 또는 서버 요청·일부 D 면 FAIL'),
    'L 조회 전 Delete 프로브 없음(T441)': (
        ['V-b48e5d97'],
        "_verify.spec.ts D4 조회 전 프로브가 Insert 만 구현('Delete 조회 전 프로브 미구현')",
        'Doc/e2e/specs/_verify.spec.ts 조회 전 툴바 Delete 프로브(쓰기 요청 차단)',
        '실측(행 수·D 표시·쓰기 요청 0 이면 PASS)'),
    'M 팝업 검사 호출 기록 없음(T443 · 다른 세션 T405)': (
        ['T-a9985ef6', 'T-f43dac0f', 'T-653f1a5d'],
        "eg_chain 이 CL_SELFTEST_BASE 로 실행돼 fixture 가 calls/*.json 을 남기지 않음(calls 폴더에 eg_* 파일 0). 팝업 조회 SCP0028/popup/SEARCH 는 _trace W4b 기록에 있음(07:55 judge T405 판정 경로)",
        'tools/E2E/fixtures/test.ts EG_CHAIN 이면 기록 · tools/Harness/verify/eg_chain.py EG_CHAIN=1',
        'F4 호출 기록 판정(T405). A6 T-653f1a5d 는 SQL 로그 기준이라 미측정'),
    'N 시나리오 단추·조건 라벨(T444)': (
        ['V-a1923fff', 'V-5a8ff1e6'],
        "시나리오 'btn Input' 은 영문만 찾음(측정 계정 KO '입력' LBL00872). 'iscombo Division' 은 TO-BE 라벨 'Div.' 를 못 찾음",
        'Doc/e2e/specs/_verify.spec.ts 시나리오 btn·iscombo 라벨 후보(labelVariants · Div↔Division · 명칭 변경 룰 · 기준표 표준 명칭)',
        '실측(통과 또는 오류)'),
    'O 신규 행 전제 시나리오(T445)': (
        ['V-0c97a0f1', 'V-93d3cad9', 'V-eeb010ff'],
        "증거 'Insert 뒤 행이 늘지 않음(1940→1940)' · 'insert:1940행·신규0' 이 T362 insert_noop_na 문구표에 없음",
        'tools/Harness/verify/judge.py NEWROW_MISS_RE·NEWROW_STEP_RE(대상 이름에 신규·Insert 가 있는 행만 · 단위 시험 2행 NA · 편집 중 Input 행 유지)',
        'NA(AS-IS 신규 행 없음)'),
    'P 원값 복원 숫자 칸 입력(T446)': (
        ['V-4b34e536'],
        "_verify.spec.ts 원값 복원이 편집기 주입만 써서 LOT_SIZE 값이 안 바뀜('12,800')",
        'Doc/e2e/specs/_verify.spec.ts 값이 안 바뀌면 typeCell 키보드 입력 · 원복도 같은 방식',
        '실측(통과 또는 오류)'),
    'Q 골든 인자 선언 기본값 빈 글자(T447)': (
        ['V-ee003a13'],
        "Doc/golden/SCP0028/SCP0028_GET_SHIPMENT_LOT_SIZE.md 06:14 '파라미터 값 미정' SKIP · @p_to_site NVARCHAR(max)='' 기본값을 넣고도 빈 값으로 셈",
        'tools/DbConn/golden.py 선언 기본값 빈 글자 = 의도된 빈 값',
        'A7 컬럼 비교 실측(통과 또는 오류)'),
    'R EditButton SwitchLock 문장(T448)': (
        ['V-b1aa0c11'],
        'AS-IS EditButton cs:229~235 SwitchLock 뒤 LockColumn. TO-BE 룰 CR-084·CR-093(편집 버튼 없이 진입 즉시 편집)',
        'tools/Harness/verify/judge.py CR-093 블록에 SwitchLock 문장 행',
        'NA(TO-BE 룰 CR-084·CR-093 · 편집 칸은 D1 컬럼 행)'),
    'S 팝업 EG 행 이어받기 = 집계(분류표)': (
        ['V-aa6bec9e', 'V-6cb6bfa8', 'V-d816896f', 'V-c2d97238', 'V-d41bec0d', 'V-5123358d', 'V-180ef854', 'V-b2d03a00'],
        "증거 'AS-IS 팝업 문장 … 규칙 H6·M3 실측 N행을 이어받음' = 팝업 EG 행 판정을 따라가는 행. 미분류였음",
        'tools/Harness/verify/unverified_classes.csv 11 집계 행',
        '하위 행(EG-6cc339e1·EG-273588ca 등)을 따라감'),
    'T 공용 권한 SP F4(T449)': (
        ['T-c770299c'],
        'PR_GET_MNU_BTN_AUTH 는 공용 권한 경로(useTabBtnPermissions.ts:57 GET /admin/menu/{menuId}/auth)로 불림. 검사기는 PROC_M 배선만 봄',
        'tools/Harness/verify/judge.py F4 공용 권한 SP = 같은 실행 EG374·EG411 버튼 권한 실측',
        'EG374·EG411 실측 따라 PASS 또는 FAIL'),
    'U 이번 라운드 미보완(엔진 확장 필요)': (
        ['V-4c3670c9', 'V-78baf3af', 'V-04302ccf', 'V-cbcda052', 'V-6cf2af49', 'V-729c8d58',
         'V-db0f51c6', 'T-a239a7e1', 'T-449b82ac', 'T-0855373f', 'T-c7a94f1d',
         'V-99331be4', 'T-247bdc3c', 'T-57afcab2', 'T-3dbd9fe5',
         'T-ba663c76', 'T-c5782dcb', 'T-8ef356b6', 'T-2a9cd623', 'T-5bb8509f', 'T-84c5ee4c', 'T-41bb3f1f',
         'V-86e7f1e2', 'V-a89007be', 'T-0caf6c62', 'T-4677b9e5', 'T-d6ad4a4e', 'T-6b9a8ce8', 'V-8da88867',
         'V-f3e94ee4', 'V-e9891c92', 'V-2611b990', 'V-9b370c0f', 'V-df3bcadf'],
        "K3 6행: 시험이 메인 그리드만 잼(증거 '미포함: 팝업 그리드'). H6·G5·M4 18행: 팝업 선택값 반영·팝업 칸 시나리오 실행 경로 없음(일괄입력 팝업은 From Site 필수 Find 뒤 행 생김). 팝업 Delete(FindDelete MSG00031·MSG00284)·btnDelete G4 5행: 팝업 Delete 시나리오 없음. F4 T-6b9a8ce8·A7 V-8da88867: 입력용 SP 는 일괄입력 팝업 확인 때만 불림(인자 = 선택 행 목록). C2 5행: 연쇄 결함 유형 대상 칸(AS From Site·Cust Group·Measure)과 이 화면 칸 이름이 겹침(지난 라운드 D7)",
        '이번 라운드 수정 없음. C2 5행은 지난 라운드 권장안 그대로 결정 목록 D9',
        '미검증 유지'),
    'W 다른 세션 보완분(SSP0014 T385)': (
        ['V-dd4f9db4'],
        "From Site 멀티선택 'AU000062_81-P' 1개 조회 → 0행 · 결과 칸 FROM_SITE_DESCRIPTION 값에서 후보를 못 찾아 임의 후보 선택. SSP0014 세션 T385(_trace.spec.ts:1491 · 07:54 · 결과 값 코드 ↔ 후보 이름 환산)와 같은 증상",
        '이번 라운드 수정 없음(다른 세션 보완분)',
        '실측(통과 또는 오류)'),
    'V 동시 실행 조건(재수행)': (
        ['V-ca2072cf', 'V-1f64fec6'],
        "시나리오 지정 계정 dana.robot 이라 언어 전용 계정(langacct)을 쓰지 않고, 같은 시각 다른 화면 E2E(SCP0005·SSP0005·SSP0014) 때문에 언어 전환을 건너뜀(T200 보호)",
        '수정 없음(다른 화면 E2E 와 같이 돌 때 계정 언어를 바꾸지 않는 보호 동작)',
        '다른 화면 E2E 가 없을 때 실측'),
}
D = [
    ('D1', ['V-d9f71764', 'V-d7cde174', 'V-a5e26726', 'V-fbb3bbaf'], "AS-IS SaveData(cs:583~609)는 한 칸만 비운 수정 행을 수정 건수에 세고 checkRequiredOfSpread 필수 안내로 막음. TO-BE 실측 '저장 요청·안내 모두 없음'. 공란 입력이 수정 상태(M)를 만들었는지 실측 없음", '화면 결함(필수 안내 없음)으로 FAIL 처리할지, 공란 입력 뒤 수정 상태 확인 검사를 먼저 넣을지'),
    ('D2', ['EG-ea38ffcb'], 'AS-IS 팝업 더블클릭 = 선택 후 닫기(SCM0002_ItembyDivisionPopup.cs:316~320). TO-BE 공용 모달(COM0013 MaterialByDivisionModal) 더블클릭 뒤 닫히지 않음(OK 경로는 반영)', '공용 모달 결함으로 볼지(다른 화면 공통), TO-BE 룰로 볼지'),
    ('D3', ['T-fad117f6', 'T-2c20a3fc'], "대조표 17행이 쓰지 않는 SP(P_SCM0002_GET_ITEM_BY_DIVISION_POPUP)를 적음. FE 가이드 FE_GUIDE_20261120_0817.md G1. 팝업 교체(COM0013)는 코드 주석 '사용자 지시 2026-10-08' 말고 등록 룰 없음(fixlist FX-SCP0028-018·019 AI 검토 실결함)", 'Model 팝업 COM0013 교체를 TO-BE 룰로 등록할지(등록하면 FX-018·019 오류 제외), AS-IS 팝업으로 되돌릴지'),
    ('D4', ['V-480372c9', 'V-86b2f489'], 'AS-IS 팝업 고정 플래그 _action_flag D·I 를 TO-BE 는 setBatchMode(I·D)로 전달(ShipmentLotSize.tsx:338~344). CR-096 은 공용 검색 모달 대상이라 화면 고유 일괄 팝업에는 직접 해당 안 함', '권장안 PASS(전달 방식 차이). 승인하면 판정 경로에 넣음'),
    ('D5', ['V-5d06fca9'], 'AS-IS cboValid.DataBind(Data.Type.YesOrNo, true)(cs:135) = 단일 콤보 + ALL. TO-BE 단일 + ALL(실측 다중=false · ALL=true). 조회조건 기준표 행 0', '권장안 PASS(AS-IS 원문과 같음). 승인하면 B6 기준표 없는 화면 경로를 AS-IS 사실(combo_src args)로 판정'),
    ('D6', ['EG-6cc339e1', 'EG-273588ca'], "일괄입력 팝업: 건수 문구 없음(DM-C8 기대) · 'I' 진입 자동 조회 없이 Find 때 From Site 필수 알림(AS-IS 같은 동작 cs:261~266)으로 행 0", '건수 표시는 CR-100 처럼 TO-BE 팝업 룰로 볼지. DATA 는 From Site 를 채운 뒤 재는 검사기 보완(다음 라운드) 승인'),
    ('D7', ['EG-bd80125c'], "화면 고정 한글 '{0}은 {1} 보다 클 수 없습니다.'(useShipmentLotSizeValidation.ts:52)", '메시지 코드 등록 뒤 FE 가이드 작성 여부(DB MODE)'),
    ('D8', ['V-15f47ff2'], 'CR-116 등록(사용자의견 SCP0104 V-24ff60ab 일반화). TO-BE 권한 설정에 SCP0028 EDIT 없는 그룹 2개(CAPA Planner, SSP ADMIN · AS-IS CRUD)', 'CR-116 등록 확인 · 두 그룹 EDIT 권한 데이터를 AS-IS 와 맞출지'),
    ('D9', ['V-f3e94ee4', 'V-e9891c92', 'V-2611b990', 'V-9b370c0f', 'V-df3bcadf'], '다른 화면 연쇄 결함 유형(DMF0003·DMF0082 AS From Site, DMF0005 Cust Group, Measure, 상위 셀 cascade). SCP0028 그리드 연쇄 칸 없음(C2 TRACE 2행 NA). 칸 이름(From Site·Active)만 겹침', '권장안 NA(대상 없음). 승인하면 판별 규칙 반영(지난 라운드 D7 과 같음)'),
    ('D10', ['V-a99ddb18'], 'H2 배경색 조건(M 행, LOT_SIZE와 INCREMENT 공란, VALID Y, SPLIT N)을 만족하는 행 0(Div 40 265행)', '저장하지 않고 편집으로 조건을 만드는 시험 허용 여부'),
    ('D11', ['T-6dc0e2d5', 'T-52d59336'], 'PR_GET_MNU_BTN_AUTH 정렬(A6)·시노님(DB-SYN). 공용 권한 SP(PKG_NSCM_UI_COM_AUTH)', '공용 SP 를 화면 단위 대상으로 둘지'),
]

ids = {x['row_id']: x for x in r}
placed = {}
for g, (rows, *_rest) in G.items():
    for i in rows:
        placed.setdefault(i, []).append(g)
for d, rows, *_ in D:
    for i in rows:
        placed.setdefault(i, []).append(d)
missing = [i for i in ids if i not in placed]
extra = [i for i in placed if i not in ids]
assert not missing, missing
assert not extra, extra

L = [f'# SCP0028 미검증 행별 조치 표 · 2026-11-20 라운드 · {AT}', '',
     f"- 입력: unverified_triage.csv(07:48:27), 원장 verify_ledger.csv(07:38). 처리 대상 {len(ids)}행(엔진 81, 판단 30), 집계 113행은 하위 행을 따라감",
     f'- 표 행 수 {len(ids)} = 처리 대상 {len(ids)}. 빠진 행 0, 목록 밖 행 0(생성 스크립트 _unverified_plan_gen.py 확인)', '',
     '## 묶음', '', '| 묶음 | 행 수 | 원인(실측) | 고친 곳 | 다음 CheckList 판정(미측정) |', '|---|---|---|---|---|']
for g, (rows, why, fix, nxt) in G.items():
    L.append(f'| {g} | {len(rows)} | {why} | {fix} | {nxt} |')
L += ['', '## 결정 목록으로 보낸 행', '', '| 결정 | 행 수 | 근거 |', '|---|---|---|']
for d, rows, why, ask in D:
    L.append(f'| {d} | {len(rows)} | {why} |')
L += ['', '## 행별', '', '| 행 ID | 담당 | 유형 | 규칙 | 대상 | 조치 |', '|---|---|---|---|---|---|']
for x in r:
    tg = (x['target'] or '').replace('|', '/')[:70]
    L.append(f"| {x['row_id']} | {x['actor']} | {x['class']} | {x['rule_id']} | {tg} | {' · '.join(placed[x['row_id']])} |")
open(os.path.join(HERE, '_unverified_plan.md'), 'w', encoding='utf-8').write('\n'.join(L) + '\n')

DL = [f'# SCP0028 결정 목록 · {AT}', '', '| 결정 | 행 ID | 정할 내용 | 근거 |', '|---|---|---|---|']
for d, rows, why, ask in D:
    DL.append(f"| {d} | {', '.join(rows)} | {ask} | {why} |")
open(os.path.join(HERE, '_unverified_decisions.md'), 'w', encoding='utf-8').write('\n'.join(DL) + '\n')
print('plan rows', len(ids), 'groups', len(G), 'decisions', len(D), 'decision rows', sum(len(x[1]) for x in D))
