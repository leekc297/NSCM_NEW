"""SCP0005 미검증 2026-11-20 라운드 1(CheckList 07:35 원장 · 분류 08:24) 행별 조치 표·결정 목록 생성, 이 라운드 기록용 일회성 스크립트"""
import csv
import os

HERE = os.path.dirname(os.path.abspath(__file__))
AT = '2026-11-20 08:5x'
r = [x for x in csv.DictReader(open(os.path.join(HERE, 'unverified_triage.csv'), encoding='utf-8-sig')) if x['actor'] != '집계']
by = {x['row_id']: x for x in r}


def sel(pred):
    return [x['row_id'] for x in r if pred(x)]


ROUTE_D1 = sel(lambda x: x['rule_id'] == 'D1' and x['target'].startswith('[COLUMN] route.') or x['target'].startswith('route.') and x['rule_id'] == 'D1')
POPUP_D1 = sel(lambda x: x['rule_id'] == 'D1' and ('POPUP.' in x['target'][:20]))

# 묶음: (행, 원인(실측 근거), 고친 곳 또는 처리, 다음 CheckList 판정(미측정), 구분)
G = {
    'A 컬럼 메타 미조회 시트 route 중복 행(T451)': (
        ROUTE_D1 + ['V-0267c456', 'V-afc23080'],
        "TO-BE 메타 SCP0005 시트 3개(Distribution Route 39, route 33, POPUP 16 · Doc/tobefacts/db/sheet_columns.csv). 화면은 컬럼 메타를 'Distribution Route' 로만 조회(useDistributionRouteStore.ts:113~117, distribution-route.constants.ts:12~26). 화면 사실 dts_sheets 빈 값이라 ledger.py 가 세 시트 모두 행을 만들었고 'route' 는 AS-IS 시트(grid_columns_asis)에 없어 'AS-IS 편집 기대 없음' 판정필요",
        'tools/E2E/lib/nscm.ts recordMetaSheets(/admin/menu/<ID>/column 본문 sheetNm → Doc/verify/<ID>/meta_sheets.json) · tools/Harness/verify/ledger.py 기록에 없고 AS-IS 시트에도 없는 시트 제외',
        '첫 CheckList 에서 meta_sheets.json 생성, 그 다음 CheckList 원장부터 route 시트 행 생성 안 함(단위 시험: 기록 [Distribution Route] → route 제외, POPUP 유지)', '엔진'),
    'B 셀 규칙 시트 축(T450)': (
        ['FACT-4087be3b', 'FACT-54671821', 'FACT-a5b873a6', 'FACT-e47ec2b2', 'FACT-f5874cc4'],
        "facts_cellrules.py 가 컬럼 단위로 규칙을 모아 마지막 메타 행(POPUP)의 시트를 남김. SetReNumerCellType(cs:251~255)은 `if (spreadInfo.SheetName == SpdSheet.shtMain)`(cs:243, shtMain = 'Distribution Route' cs:78) 안인데 시트를 바꾸지 않았음",
        'tools/Harness/verify/facts_cellrules.py guard_sheets(감싼 SheetName 블록 상수 → 그 파일 SpdSheet 값) · Doc/asisfacts/screens/SCP0005/cell_rules.csv 재생성(LT 5칸 POPUP → Distribution Route)',
        '사실 검토(llm_facts) 다시 만들 때 5행 사라짐 · E1 숫자 칸 기대가 Distribution Route 시트에 붙음', '엔진'),
    'C 저장 왕복 행 식별(T452)': (
        ['V-4e4af2a4', 'V-26d2974c', 'V-7116d2aa', 'V-72fbb5b2'],
        "V-4e4af2a4 증거 'FROM_COUNTRY r359 CN→KR 재조회 (판독 안 함) · 재조회 행 식별 0건'. probe.rowIdentity 가 숫자 칸(ROUTE_ID)을 빼고 문자 칸만 대조해 업무 키(FROM_COUNTRY)를 바꾼 행을 잃음. 뒤 시험 3행은 '[측정 중단] 앞 단계 행 식별 실패'. DB 확인(사내 오라클 08:41): ROUTE_ID 7305 FROM_COUNTRY 'CN'·LAST_UPDATED_BY yangwon_kim 2021-02-24(복원됨)",
        'tools/E2E/lib/saveprobe.ts uniqueIdKey·rowsById(편집 전 값이 유일한 ID 칸으로 보조 식별)',
        '실측(통과 또는 오류). ID 칸도 겹치면 종전처럼 식별 실패 사유', '엔진'),
    'D 이력 팝업 미열림 판정 문구(T454)': (
        ['T-6d14c72c'],
        "AS-IS ROUTE_ID 더블클릭 → SCP0005_DistributionRoutePopup(cs:1093~1103, 팝업 SP SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID). TO-BE 그리드 더블클릭 처리는 FROM·TO 도시 칸만(DistributionRouteGrid.tsx:188~200). _trace.spec 이 '열림 감지 실패' FAIL 을 남기고 judge RX_TOOLFAIL 이 검사기 미검증으로 내림",
        "Doc/e2e/specs/_trace.spec.ts M3: 10초 동안 대화상자 0 · 서버 호출 0 · 편집기 없음이면 '팝업 열리지 않음' 실측 FAIL",
        'FAIL(화면 기능 누락 · FE 가이드 G1)', '엔진'),
    'E 화면 조회조건 검색 단추 팝업(T453)': (
        ['T-9b463365', 'T-88891164', 'T-6d65f303', 'T-90d2d30f', 'T-3d44d32d', 'T-47ab9353', 'T-ef2618be', 'T-26aaaaf4'],
        "_trace.spec W4d 분기(ROUTE_ID 더블클릭 → Distribution Route 선택 팝업 prefill, SCP0007 용)가 팝업이 안 열리면 txt* 조건 행 전부를 미검증으로 적음. SCP0005 txtFromCountry 등은 화면 자체 조회조건(cs:358~369 btnFromSrch·btnToSrch → SCM0002_CitybyCountry). TO-BE 조건 칸 돋보기 단추(DistributionRouteForm.tsx:82~87, 123~127)",
        'Doc/e2e/specs/_trace.spec.ts condPopup(조건 칸 검색 단추 → 팝업 → 첫 행 → 확인 → 조건 값 · 원복)',
        'G4 4행 = 팝업 열림 실측 · M4 4행 = 선택값 반영 실측(통과 또는 오류)', '엔진'),
    'F Division 조건 없는 화면 J1(T455)': (
        ['ES-0967e6d0', 'ES-fe8e48bc'],
        "증거 'Division 40 선택 못 함 · set=false rows=8036'. AS-IS controls.csv 컨트롤 이름에 Div 0건(SCP0005 Designer 조회조건 = From/To Country·City, Trans Mode, Valid)",
        'tools/Harness/verify/e2e_suite_ingest.py no_div(AS-IS 컨트롤에 Division 0건 + TO-BE 선택 실패 → NA 근거 기록)',
        'NA(Division 별 조회 대상 아님 · 근거 controls.csv)', '엔진'),
    'G 팝업 보조 입력 칸 FPTextBox(T456)': (
        ['V-5b44fefc', 'V-9a1db2df', 'V-1ff8658b', 'V-599dd774'],
        "ledger.py T114 분기가 CELL=- 만 일반 텍스트 셀로 봐 FROM_COUNTRY·FROM_CITY(CELL=FPTextBox)에 '직접 편집 차단' 기대를 만듦. 프레임워크는 CELL 빈 값을 FPTextBox 로 정함(SpreadInfo.cs:1387~1389) · AS-IS InsertRow 잠금 칸에 두 칸 없음(cs:950~954)",
        'tools/Harness/verify/ledger.py _plain 에 FPTextBox 포함',
        "D1 기대 '팝업 보조 입력(직접 입력 허용 + 더블클릭 팝업)' → 실측 편집=true 면 PASS", '엔진'),
    'H 미분류 유형 등록(분류표)': (
        ['V-28e296d5', 'EG-d5dc785f', 'EG-e6babac5', 'EG-334fdc63', 'T-b82f895f', 'T-5edb7122', 'T-38e03b62', 'T-653f2a16', 'EG-4cbe8d28', 'EG-df9c2d26', 'EG-a875887e', 'V-8fd091cc', 'EG-6a0f18bc', 'EG-f670f773', 'EG-75f112d6'],
        "증거 문구가 분류표 정규식에 없었음: '[검증엔진 무판정]', '실제 AS-IS 조회 SP 원문 없음()', '실제 AS-IS 원문을 찾지 못함', '[전제 미충족 T300]', '버튼 [..] 비노출', '미포함 항목은 수동 검수 대상'",
        'tools/Harness/verify/unverified_classes.csv 71·73·52 행(검사기공백·데이터전제). 측정 경로 보완은 하지 않음(U 묶음과 같이 다음 라운드)',
        '판정 그대로(미검증) · 담당 엔진으로 분류', '엔진'),
}

D = {
    'D1 ROUTE_ID 이력 팝업 미구현(선행 결함)': (
        POPUP_D1 + ['V-a882d140', 'T-336fa068', 'V-f574c4a3', 'T-ea530cd5', 'T-74b664fb', 'T-c65db01b', 'V-a46588cb', 'V-0e9099ba', 'V-4cfc72f5', 'EG-9c573043', 'EG-4041a815', 'T-fce350f2'],
        "AS-IS ROUTE_ID 더블클릭 → 이력 팝업(SCP0005_DistributionRoutePopup.cs:36 시트 'POPUP', :171 SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID). TO-BE 화면에 팝업 없음(대조표 R8 'AS-IS 에 해당 기능 부재 확인(2026-09-27)' 은 원문과 다름). TO-BE DB 는 준비됨(SCM_ADM_MNU_BTN_MPG_M SCP0005/history/SEARCH → P_SCP0005_GET_HIST, PKG_SCP0005.P_SCP0005_GET_ROUTE_HIST · 08:51 조회)",
        'FE 가이드 G1 반영 여부(팝업 구현 · 대조표 R8 정정). 반영 전까지 팝업 그리드 칸 33행(POPUP 시트 D1 32, E1 1)과 팝업 SP 행은 측정 경로 없음'),
    'D2 다른 화면에서 ROUTE_ID 를 넘겨 여는 진입 시나리오': (
        ['T-2f7778bd', 'V-fc7cfdc8', 'V-4d5799f3', 'T-719d403c', 'T-9374e9e4', 'T-94b3ad3d'],
        'AS-IS 는 다른 화면이 ROUTE_ID 를 넘겨 열 때만 SCP0005_GET_DISTRIBUTION_ROUTEID 를 부름(AI 검토 근거 cs:499~501). TO-BE 연결 SCP0005/route/SEARCH_ROUTEID → P_SCP0005_GET_ROUTEID(08:51 조회). 검사기에 화면 간 진입 시나리오와 골든 케이스(golden_cases.csv) 없음',
        '진입 시나리오(어느 화면에서 어떤 값으로 여는지)를 검사기에 넣을지, 수동 확인으로 둘지'),
    'D3 후보 밖 값 행이 데이터에 없음(F3 복사 붙여넣기)': (
        ['V-3d0ea655', 'V-5804ccc8', 'V-5a4e9648', 'V-6f2db8d3', 'V-753a87af', 'V-7ac42873', 'V-ba8f9817', 'V-cb7ed54f', 'V-d8ff8497'],
        "증거 '이 행 후보 1건(TRANSPORT_MODE 4건) 밖 값을 가진 기존 행 없음'(Div 40 조회 8036행)",
        '권장안 NA(조건 데이터 부재). 승인하면 데이터 부재 판정 경로에 넣음. 아니면 시험 데이터 준비'),
    'D4 저장 시험 흔적 ROUTE_ID 9917': (
        [],
        "사내 오라클 08:41 조회: ROUTE_ID 9917 LAST_UPDATED_BY minyonglee1 · 2026-11-19 21:26:21(CREATED_BY ohsun 2024-01-22). 11-19 저녁 CheckList 저장 시험이 감사 칸을 남긴 것으로 보임(값 원복 여부 미확인)",
        '감사 칸 원복 여부 확인 · 원래 값을 아는 기록이 있으면 복원'),
    'D5 AI 검토 TO-BE 룰 후보': (
        ['EG-b7b794bd', 'V-6e159871'],
        "EG-b7b794bd: 공용 RegionModal(제목 Region Popup)로 SCM0002_CitybyCountry 대체(DistributionRoute.tsx:315). V-6e159871: 공통 컬럼 5개 ''↔'/' 차이(a_port_name 8행, shipping_company 334행 등) = NOT NULL 빈 값 '/' 룰(메모리 2026-11-13) 해당 여부",
        '두 건을 전 화면 TO-BE 룰로 등록할지(등록 번호 · 판정 경로)'),
    'D6 판단 행(룰 근거 미확인)': (
        ['V-5bcb735c', 'V-82d97d20', 'T-1d878a60', 'T-0803d2d0', 'V-03851efe', 'V-63a7bd27', 'V-eab82e73', 'V-4ce029f5', 'V-4ad20009', 'V-3fa9771e',
         'T-24a1a8c9', 'V-18c565cc', 'T-d786155a', 'T-fd52bd41', 'T-50c6a15b', 'EG-2037a747', 'EG-60363cec', 'V-e458f301'],
        "B4 2행 = AS-IS 셀 콤보 후보 0건 추출(메타 ATTRIBUTE1 → Param1 미반영 · AI 검토). C3 5행 = 원천 칸 팝업 셀·LT 입력 실패. C6 3행 = 시작 값 0 이 되돌림 값 0 과 같아 대조군 없음. DAYS 2행 = 머리글 묶음. E6 = 첫 타건 IME. H6 2행 · I2 2행 · MS1 1행 = 판정필요",
        '행별 근거 확인 뒤 판정 경로 보완(다음 라운드) 또는 사람 판정'),
    'D7 스냅샷 승인': (
        ['V-5daefe3f'],
        "스냅샷 '버튼 Div 40' 재실측 승인 대기. snap_validate.py(08:5x) MISMATCH: AS-IS 기대 대비 누락 UPLOAD_SAVE, UPLOAD, SEARCH_ROUTEID, SEARCH_CITY(서버 연결 이름 · 화면 단추 아님 확인 필요). 자동 승인 대상 아님(MISMATCH 제외 규칙)",
        'MISMATCH 4건이 화면 단추 누락인지 서버 연결 이름 차이인지 확인 뒤 snap_approve 승인 여부(사람)'),
}

U = (
    sel(lambda x: x['row_id'] not in set(sum([v[0] for v in G.values()], [])) | set(sum([v[0] for v in D.values()], []))),
    '이번 라운드 미보완(엔진 확장 필요)',
)


def cause(rid):
    x = by[rid]
    ev = (x.get('evidence') or '').replace('|', '/').replace('\n', ' ')
    return ev[:150]


out = [f'# SCP0005 미검증 행별 조치 표 · 라운드 1 · {AT}', '',
       f'- 입력: unverified_triage.csv(08:24:15), 원장 verify_ledger.csv(08:12:16, CheckList 07:35). 처리 대상 {len(r)}행(엔진 153, 판단 103, 사람 1), 집계 95행은 하위 행을 따라감',
       f"- 표 행 수 {len(r)} = 처리 대상 {len(r)}. 생성 스크립트 _unverified_plan_gen.py", '',
       '## 이번 라운드에 고친 묶음', '', '| 묶음 | 행 수 | 원인(실측) | 고친 곳 | 다음 CheckList 판정(미측정) |', '|---|---|---|---|---|']
for k, (ids, c, fx, nxt, _) in G.items():
    out.append(f'| {k} | {len(ids)} | {c} | {fx} | {nxt} |')
out += ['', '## 결정 목록으로 보낸 묶음', '', '| 묶음 | 행 수 | 근거 | 정할 내용 |', '|---|---|---|---|']
for k, (ids, c, q) in D.items():
    out.append(f'| {k} | {len(ids)} | {c} | {q} |')
out += ['', f'## 이번 라운드 미보완 {len(U[0])}행(엔진 확장 필요 · 다음 라운드)', '',
        '- 원인은 행 증거와 AI 검토 처리 방법 칸 기준. 이번 라운드에 원문을 다시 확인하지 않은 행은 처리 방법 칸에 미확인으로 적음', '']
out += ['## 행별 조치', '', '| 행 ID | 규칙 | 유형 | 묶음 | 조치 |', '|---|---|---|---|---|']
seen = set()
for k, (ids, *_rest) in G.items():
    for i in ids:
        seen.add(i); x = by[i]
        out.append(f"| {i} | {x['rule_id']} | {x['class']} | {k.split(' ')[0]} | {k} |")
for k, (ids, *_rest) in D.items():
    for i in ids:
        seen.add(i); x = by[i]
        out.append(f"| {i} | {x['rule_id']} | {x['class']} | {k.split(' ')[0]} | 결정 목록 {k} |")
for i in U[0]:
    seen.add(i); x = by[i]
    out.append(f"| {i} | {x['rule_id']} | {x['class']} | U | 미보완: {cause(i)} |")
missing = [x['row_id'] for x in r if x['row_id'] not in seen]
dup = len(sum([v[0] for v in G.values()], [])) + len(sum([v[0] for v in D.values()], [])) + len(U[0]) - len(seen)
out.insert(4, f'- 대조: 표에 넣은 행 {len(seen)}, 빠진 행 {len(missing)}, 두 묶음에 겹친 행 {dup}')
open(os.path.join(HERE, '_unverified_plan.md'), 'w', encoding='utf-8').write('\n'.join(out) + '\n')

dl = [f'# SCP0005 결정 목록 · {AT}', '', '| 결정 | 행 ID | 정할 내용 | 근거 |', '|---|---|---|---|']
for k, (ids, c, q) in D.items():
    dl.append(f"| {k.split(' ')[0]} | {', '.join(ids) if ids else '(원장 행 없음)'} | {q} | {c} |")
open(os.path.join(HERE, '_unverified_decisions.md'), 'w', encoding='utf-8').write('\n'.join(dl) + '\n')
print('rows', len(r), 'seen', len(seen), 'missing', missing, 'dup', dup, 'U', len(U[0]))
for k, v in G.items():
    print(k, len(v[0]), [i for i in v[0] if i not in by])
for k, v in D.items():
    print(k, len(v[0]), [i for i in v[0] if i not in by])
