"""SCP0028 미검증 라운드 1(2026-11-19) 행별 조치 표·결정 목록 생성, 이 라운드 기록용 일회성 스크립트"""
import csv
import os

HERE = os.path.dirname(os.path.abspath(__file__))
r = [x for x in csv.DictReader(open(os.path.join(HERE, 'unverified_triage.csv'), encoding='utf-8-sig')) if x['actor'] != '집계']
G = {
    'A': (['V-5a8ff1e6', 'V-c428fc08', 'V-ed697b1a', 'V-904e7990', 'V-477a4f36', 'V-1f9a60bb', 'V-1f325f76', 'V-cbc2cee2', 'V-eeb010ff', 'V-a1923fff', 'V-ca2072cf', 'V-1f64fec6'],
          'BE 정지 중 측정(results.json 05:30Z~06:21Z 문서 시나리오: 로그인 BE 대기 300초 실패 3회, 화면 열기 Home 이동 10회). Home 이동을 화면 권한 없음으로 기록함',
          'tools/E2E/lib/nscm.ts openScreen(BE 포트 확인, 대기, 재로그인, 1회 재시도, beDown), Doc/e2e/specs/_verify.spec.ts 시나리오 실패 문구, unverified_classes.csv 재실행 유형',
          '다음 CheckList 에서 실측(통과 또는 오류). BE 가 다시 멈추면 [BE 응답 없음] 재실행 유형'),
    'B': (['V-394a3941', 'V-0c97a0f1', 'V-c0ff12d4', 'V-eac62d82', 'V-eb42dcc1', 'V-de7a1fc2', 'V-93d3cad9'],
          '앞 테스트(05:27Z 버튼 경로 메시지)가 From Site 후보 0개 상태에서 대안 0건으로 조회 0행 메모를 남김. 뒤 문서 시나리오가 메모 때문에 재시도 생략',
          'tools/E2E/lib/smoke-extra.ts ensureRows 메모 조건(대안 시도 0건, BE 포트 닫힘, 5xx 있으면 메모 안 함)',
          '다음 CheckList 에서 Division 순회로 행 확보 뒤 실측. 행을 못 만들면 시도 내역을 붙인 미검증'),
    'C': (['EG-2ae4d809', 'EG-ab8129bb', 'EG-cfe1f9a1', 'ES-e9b7d3ac', 'V-16d1b2ea', 'V-19c73c57', 'V-19dbf57f', 'V-1b10da7b', 'V-2a373e9a', 'V-49b74e1a', 'V-4edb4ebc', 'V-5349b028', 'V-59056cd1', 'V-5ee103c5', 'V-807ce196', 'V-954df2e5', 'V-9b9267ff', 'V-9fb9cc94', 'V-a005cb70', 'V-a75b28d5', 'V-c06b9a84', 'V-c70d377f', 'V-e9ab7986', 'V-eba2b607', 'V-fc3bd077', 'V-fd77aa3c'],
          'AS-IS InsertButton → InsertRow() 본문 비어 있음(SCP0028_Shipment_Lot_Size.cs:200~203, 571~573). TO-BE 도 Insert 뒤 신규 행 없음(실측). 검사기가 잠금 해석 실패, 측정 경로 없음으로 기록함',
          'tools/Harness/verify/facts_lockrules.py insert_noop(신규 행 기대 NONE), tools/Harness/verify/judge.py _asis_insert_noop, insert_noop_na',
          '해당없음(근거 AS-IS 실행 문장 0, TO-BE 신규 행 없음). D1 컬럼 15행은 원장 재생성 때 신규 행 행이 만들어지지 않음'),
    'D': (['V-b9707c91', 'V-af96562f', 'V-d081074c', 'V-2c13dbe7', 'V-5d06fca9', 'V-602d9026', 'V-00ec53f0', 'V-e91ea18c'],
          'TO-BE 조회조건 라벨 Active(LBL00007 EN Active, 원장 V-cd32453c 실측). _verify 검사기가 AS-IS 라벨 Valid 로만 찾아 칸을 못 찾음. 명칭 변경 룰 CR-092 는 _trace 에만 연결돼 있었음',
          'Doc/e2e/specs/_verify.spec.ts findSearchBox(label_alias.csv 별칭 라벨로 다시 찾음)',
          '다음 CheckList 에서 콤보 덤프, B2, B3, B4, B6, G1, G7 실측. H5 는 기준표 없는 화면 경로에서 CR-092 로 판정'),
    'E': (['V-98ff27f3', 'V-9058bd2c', 'V-73f41143', 'V-617fdf8b', 'V-e7e611bb', 'V-d4c01cb9', 'V-119cf5cb'],
          '조회조건 기준표(SCP_DM_화면별 조회조건 정리_260122_v0.4.xlsx 6시트, search_cond.csv)에 SCP0028 행 0. 정적 H5, SC1 판정이 행을 건드리지 않음',
          'tools/Harness/verify/judge.py 기준표 없는 화면 경로(AS-IS 라벨 대조, SC1 해당없음)',
          'H5 6행: TO-BE 라벨이 있으면 통과, 없으면 사유를 붙인 미검증. SC1: 해당없음(기준표 행 0)'),
    'F': (['V-66cb7b8f', 'V-c0e2f43c', 'V-e50e09ac', 'V-61dc6e5f', 'V-becafb26', 'V-0b63cd50'],
          '다른 화면(DMF0004, DMF0005) 결함 유형. 대상 칸(End Customer, Sold-to Customer, Sales Company, Sales Plant, Cust Group, Sales Site)이 SCP0028 그리드 98행, 조회조건 7개에 없음. 대상 칸 판별 함수가 컬럼이라는 말이 있는 대상만 읽음',
          'tools/Harness/verify/judge.py cascade_entities, _absent_ents(C2)',
          '해당없음(대상 칸 없음)'),
    'G': (['V-180ef854', 'V-b2d03a00', 'EG-5ca14a48'],
          '측정 계정 언어 KO. 버튼 라벨 LBL00872 EN Input, KO 입력(사내 오라클 SCM_ADM_MSG_M 16:5x 조회). 검사기가 영문 Input 만 찾음',
          'tools/E2E/lib/labeltrans.ts(신규), Doc/e2e/specs/eg_popup.spec.ts 버튼 이름 후보',
          '다음 CheckList 에서 Input 팝업 열림 실측. V-180ef854, V-b2d03a00 은 EG-5ca14a48 을 이어받음'),
    'H': (['EG-874e9a91', 'EG-393dff7e'],
          '다른 화면 E2E 동시 실행으로 언어 전환 생략(T200). 11-19 15:4x 언어 전환 전용 계정(langacct.ts, adminPool)으로 보완됨',
          '이번 라운드 수정 없음(다른 세션 보완분)',
          '다음 CheckList 에서 전용 계정으로 실측'),
}
D = [
    ('D1', ['V-4121e73d', 'V-970e2243', 'V-899509b0', 'V-7a589536'], '저장 표본 값이 저장 전 검증에 막힘(F1, F2, F4, F6). 같은 실행이 BE 정지 구간과 겹쳐 원인 미확인', '다음 CheckList(BE 정상) 저장 세부 행으로 원인 확인. 같은 결과면 표본 값 선택 규칙 보완'),
    ('D2', ['V-d9f71764', 'V-d7cde174', 'V-a5e26726', 'V-fbb3bbaf'], '기존 행 필수 칸 공란 저장. TO-BE 는 공란 뒤 수정 상태 없음 또는 M, 안내 수정한 내용이 없습니다. AS-IS SaveData 는 M 행이 LOT_SIZE, INCREMENT 공란이고 VALID_YN Y, SPLIT_YN N 이면 수정 취소(cs:583~590). 한 칸만 비운 경우 AS-IS 동작 미확인', 'AS-IS 한 칸 공란 저장 동작을 AS-IS Live 로 확인할지 결정'),
    ('D3', ['V-13254dec', 'V-02cca4b6', 'V-e3cbb602', 'V-fcba9999', 'V-e7534976', 'V-8c12aeea', 'V-4f2b09d7', 'V-81f7459d', 'V-3625f78e', 'V-4625c728'], '콤보 재조회(B7). 저장 SP SCP0028_SAVE_SHIPMENT_LOT_SIZE 대상 표 SCP_MST_SHIPMENT_LOT_SIZE 가 콤보 원천 9종과 겹치지 않음. 재진입 때 admin/combo 12건 재조회 실측 통과. 원천 미확인 1종', '권장안 통과(저장이 콤보 원천을 바꾸지 않음, 재진입 재조회 실측). 승인하면 판정 경로에 넣음'),
    ('D4', ['V-9e2b9258', 'V-db17a330', 'V-99331be4', 'V-93e5a09c', 'V-ed2ee896', 'V-6f2c58ff'], '조회조건 Model. TO-BE Model 칸은 팝업 연결 텍스트(MaterialByDivisionModal, ShipmentLotSize.tsx:362~371). 검사기 입력값이 조회 요청 본문에 실리지 않음(G8, G9 측정 실패). CEP2065I-B 조회 결과에 ITEM_ID 밖 값 268종(다른 칸 검색 여부 미확인)', '다음 라운드 검사기 보완 대상(팝업 연결 텍스트 칸 입력 경로). 268종은 조회 SP 의 Model 조건 대상 칸 확인 필요'),
    ('D5', ['V-dd4f9db4', 'V-ff037ad7'], 'From Site 후보 0~1개. combo_oracle 실측은 Division 81 에서 30개. 같은 실행의 B 묶음(팝업 필수 알림, 메모)과 시각이 겹침', 'SSP0014 세션 T355(멀티선택 후보 1개 재시도, 16:4x)와 같은 증상. 다음 CheckList 재측정 결과로 확인'),
    ('D6', ['V-db0f51c6', 'T-a239a7e1', 'T-449b82ac', 'T-0855373f', 'T-c7a94f1d', 'T-247bdc3c', 'T-57afcab2', 'T-3dbd9fe5', 'T-ba663c76', 'T-c5782dcb', 'T-8ef356b6', 'T-2a9cd623', 'T-5bb8509f', 'T-84c5ee4c', 'T-41bb3f1f', 'EG-ea38ffcb', 'T-2c20a3fc', 'T-653f1a5d', 'T-fad117f6', 'T-a9985ef6', 'T-f43dac0f', 'T-d6ad4a4e'], '팝업 계열(H6, G5, M4, A6, F4, G4). 화면 진입, 조회 중 팝업 SP 호출 0건. 팝업 선택값 반영 시나리오 실행 경로 없음. TO-BE Model 팝업은 사용자 지시(2026-10-08)로 COM0013 MaterialByDivisionModal 이라 PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP 을 TO-BE 에서 부르지 않음. AS-IS btnDelete_Click(cs:288~300)은 Form_Load("D") 뒤 ShowDialog 가 없어 팝업을 띄우지 않음', '팝업 시나리오 검사기 확장은 다음 라운드. A6 2행은 대조표 Model 팝업 SP 표기 정정 필요(DB MODE 라 FE 폴더 대조표는 가이드 대상). btnDelete 는 AS-IS 무동작인데 TO-BE 는 삭제 팝업을 띄움, 차이 인정 여부 결정'),
    ('D7', ['V-f3e94ee4', 'V-e9891c92', 'V-2611b990', 'V-9b370c0f'], '다른 화면 결함 유형 중 칸 이름이 SCP0028 칸과 겹침(AS From Site 와 From Site, Site, Active). 이름만으로 같은 칸인지 판별 불가', '권장안: DMF0003, DMF0082 의 AS From Site, DMF0005 Cust Group 관계는 SCP0028 대상 아님(해당없음). 승인하면 판별 규칙에 반영'),
    ('D8', ['V-480372c9', 'V-86b2f489'], 'AS-IS 팝업 호출 고정 플래그 _action_flag D, I 를 TO-BE 팝업에 넘기지 않음. TO-BE 는 setBatchMode(I, D)로 모드 전달(ShipmentLotSize.tsx:338~344)', '권장안: 모드 전달 방식 차이로 통과. 승인 여부'),
    ('D9', ['V-86e7f1e2', 'V-a89007be', 'T-0caf6c62', 'T-4677b9e5'], 'MSG00031, MSG00284 는 FindDelete 경로 메시지. Delete 팝업 조회 시나리오 경로 없음', '팝업 Delete 시나리오 검사기 확장(다음 라운드)'),
    ('D10', ['V-ee003a13', 'V-8da88867'], 'golden.py 가 두 조회 SP 를 실행하지 못함. 실행 기록 미확인', '다음 라운드에 golden_cases.csv 짝, 인자 확인'),
    ('D11', ['T-6dc0e2d5', 'T-52d59336'], 'PR_GET_MNU_BTN_AUTH 정렬(A6), 시노님(DB-SYN) 검사 경로 없음. 공통 권한 SP', '공통 SP 라 화면 단위 대상 여부 결정'),
    ('D12', ['V-b1aa0c11'], 'AS-IS EditButton SwitchLock(cs:229~235) 편집 모드. TO-BE 룰 CR-084, CR-093(편집 버튼 없음, 조회 즉시 편집)', '권장안: CR-084, CR-093 적용 통과. 판정 경로 연결 여부'),
    ('D13', ['V-b48e5d97'], 'AS-IS DeleteButton 은 활성 스프레드가 spdMain 이고 신규(I) 행일 때만 삭제(cs:211~227). 조회 전 프로브 미구현', 'InsertRow 무동작이라 신규 행이 생기지 않음. 권장안: 해당없음'),
    ('D14', ['V-564a1ac4'], 'DIVISION_ID 병합 37행 Delete 뒤 D 표시 0, 알림 표시. AS-IS DeleteButton 은 신규 행만 삭제', '권장안: 통과(기존 행 삭제 불가가 AS-IS 동작). 승인 여부'),
    ('D15', ['V-a99ddb18'], 'H2 배경색 조건(M 행, LOT_SIZE, INCREMENT 공란, VALID Y, SPLIT N)을 만족하는 행 0. Div 40 조회 265행', '저장 전 편집으로 조건을 만드는 시험 허용 여부(저장 요청은 차단)'),
    ('D16', ['V-d629e9b7'], 'I3 언어 전환 명칭 비교 검사기 없음', '검사기 신설 여부'),
    ('D17', ['T-522ba284'], 'check.js G03 화면 이벤트 배선 검사를 원장 행에 연결하는 경로 없음', 'SSP0014 세션 T357(mapping_trace ev_gates 가 check.js --page 실행, 16:4x)로 연결됨. 다음 CheckList 재측정 결과로 확인'),
    ('D18', ['EG-bd80125c'], '화면 고정 한글 문구 useShipmentLotSizeValidation.ts:52 {0}은 {1} 보다 클 수 없습니다.', '메시지 코드 등록 뒤 FE 가이드 작성 여부'),
    ('D19', ['EG-f71f5543'], 'PKG_SCP0028 264줄 V_TOKEN_TAB 단건 SELECT INTO 빈 결과 처리 없음', 'DB 객체 보완 대상 여부(NO_DATA_FOUND 처리)'),
]
ids = [x['row_id'] for x in r]
covered = [i for v in G.values() for i in v[0]] + [i for d in D for i in d[1]]
assert sorted(ids) == sorted(covered), set(ids) ^ set(covered)
grp = {i: k for k, v in G.items() for i in v[0]}
grp.update({i: d[0] for d in D for i in d[1]})
L = ['# SCP0028 미검증 행별 조치 표 · 라운드 1 · 2026-11-19 17:05', '',
     '- 입력: unverified_triage.csv(16:35:20), 원장 verify_ledger.csv(16:34:49). 원장 미검증 278행 = 처리 대상 141, 집계 137',
     f'- 표 행 수 {len(covered)} = 처리 대상 {len(ids)}. 집계 137행은 하위 행을 따라감',
     '', '## 고친 묶음', '', '| 묶음 | 행 수 | 원인(실측) | 고친 곳 | 다음 CheckList 판정(미측정) |', '|---|---|---|---|---|']
for k, (ids_, c, f, n) in G.items():
    L.append(f'| {k} | {len(ids_)} | {c} | {f} | {n} |')
L += ['', '## 결정 목록으로 보낸 묶음', '', '| 결정 | 행 수 | 원인 |', '|---|---|---|']
for d in D:
    L.append(f'| {d[0]} | {len(d[1])} | {d[2]} |')
L += ['', '## 행별', '', '| 행 | 규칙 | 유형 | 묶음 |', '|---|---|---|---|']
for x in sorted(r, key=lambda x: (grp[x['row_id']], x['rule_id'], x['row_id'])):
    L.append(f"| {x['row_id']} | {x['rule_id']} | {x['class']} | {grp[x['row_id']]} |")
open(os.path.join(HERE, '_unverified_plan.md'), 'w', encoding='utf-8').write('\n'.join(L) + '\n')
M = ['# SCP0028 결정 목록 · 2026-11-19 17:05', '', '| 결정 | 행 ID | 정할 내용 | 근거 |', '|---|---|---|---|']
for d in D:
    M.append(f"| {d[0]} | {', '.join(d[1])} | {d[3]} | {d[2]} |")
open(os.path.join(HERE, '_unverified_decisions.md'), 'w', encoding='utf-8').write('\n'.join(M) + '\n')
print(len(covered), sum(len(v[0]) for v in G.values()), sum(len(d[1]) for d in D))
