# TO-BE 룰 — AS-IS 와 달라도 오류가 아닌 항목 (정합검증 예외 기준)

> **자동 생성 문서 — 직접 고치지 않는다.** 원천을 고친 뒤 `python tools/Harness/verify/tobe_rule_registry.py --build` 로 다시 만든다.
> 원천: `tools/Harness/rules/confirmed_requirements.csv`(CR) · `design_decisions.csv`(DD) · `sp_replaced.csv` · `allowed_gaps.csv` · `label_alias.csv` · 종류 지정 `tobe_rule_kind.csv`
> 생성 2026-11-18 20:34:26 · 통합 원장 `tools/Harness/rules/tobe_rule_registry.csv`

- 전 화면·영역 룰(CR) **23**건 · 화면별 설계 결정(DD) **219**건 · SP 통합 대체 1건 · 생성 단계 허용 차이 21건
- 쓰임: 정합검증(CheckList)에서 이 표의 항목과 맞는 AS-IS↔TO-BE 차이는 FAIL 로 올리지 않는다. 새 판정이 나오면 원천 CSV 에 행을 추가하고 다시 생성한다.
- '강제 지점' 열은 그 룰 번호가 실제로 나오는 코드 위치(실측)다. 비어 있으면 판정 코드에 아직 연결되지 않은 것이다.

## 1. 전 화면·영역 룰 (CR)

| 룰 | 범위 | 대상 | 내용 | 분류 근거 | 강제 지점(실측) | 출처 |
|---|---|---|---|---|---|---|
| CR-029 | ALL | Condition(F6) 저장 · Sales Report ETC Insert 기능 | 조회조건 저장(Condition F6)에는 Period 를 포함하지 않는다(전 화면). 판정(2026-11-09 사용자 판정 SCP0131 1번): 기간(Period·From/To) 조건은 Condition 저장·복원 대상에서 제외되는 조건이므로 저장 데이터에 기간 키가 들어 있는 것만으로는 결함이 아니며(조치 필요 아님) 재진입 복원 비교 대상도 아니다. | 문구 '결함이 아니' (자동(문구 기준)) | smoke-extra.ts:416;smoke-extra.ts:421;smoke-extra.ts:422;smoke-extra.ts:436;judge.py:1331;judge.py:1354;judge.py:1355 | DM-74 Sales Price |
| CR-071 | SCP;SSP | SCP·SSP 조회조건(순서·사용여부·라벨) | SCP·SSP 화면의 조회조건은 조회조건 기준표(tools/Harness/rules/search_cond.csv · 40_SEARCH_COND.md)에 USE 로 정의된 조건만, 기준표 라벨(tobe_name)로 사용한다(순서는 판정 대상 제외 — CR-098). 기준표 라벨이 AS-IS 명칭과 달라도(Division→Div, Input Status→Status, Valid→Active 등) 결함이 아니라 PASS 다. 기준표가 제외·이동(DROP/SUNSET/MERGED/BUTTON_AREA/IN_CALENDAR 등)한 AS-IS 조건이 조회영역에 없는 것도 결함이 아니다(NA). 결함 = 기준표 조건 누락 · 기준표에 없는 조건 노출 · 라벨이 기준표와 다름(순서 다름은 결함 아님 — CR-098, 20 | 문구 '달라도' (자동(문구 기준)) | _trace.spec.ts:431;gen_expect.py:552;judge.py:315;judge.py:320;judge.py:323;judge.py:610;judge.py:961;judge.py:970 …(+22) | 사용자 지시 2026-10-26 (SCP·SSP 조회조건 = 기준표 정의 항목·순서·LABEL 만 — TO-BE 룰이면 PASS) · 2026- |
| CR-072 | ALL | 팝업 입력 셀(FPModal · 더블클릭 팝업으로 값이 채워지는 셀, 예 BOD Route Id) | 팝업으로 값을 바꾸는 셀(SHEET_COLUMNS CELL=FPModal)은 사용자가 수정할 수 있는 셀이므로 편집 가능 셀과 같이 노랑으로 표시한다. 셀 에디터가 직접 열리지 않아도 노랑은 정상이다. | 문구 '정상이다' (자동(문구 기준)) | _trace.spec.ts:503;_trace.spec.ts:504;_trace.spec.ts:583;_trace.spec.ts:584;_verify.spec.ts:382;_verify.spec.ts:383;_verify.spec.ts:700;_verify.spec.ts:704 …(+9 | 사용자 의견 2026-10-27 (SCP0007 ROUTE_ID "수정 COLUMN — 판정오류") |
| CR-073 | ALL | 그리드 셀 세로 병합 대상 컬럼 | TO-BE 그리드의 셀 세로 병합은 화면이 정한 키(그룹) 컬럼만 적용한다(예 BOD: BodGrid MERGE_COLUMNS 9개 — Division·Customer·From Site·From City·To Site·To City·To Site VMI·Incoterms·Trans Mode). 값 컬럼(Priority·Route Id·Lead Time·Valid 등)은 AS-IS 가 메타 기본(FPMerge.Restricted)으로 전부 병합하더라도 병합하지 않는다. 공용 CustomMergeManager 는 왼쪽 컬럼이 병합된 범위 안에서만 병합하므로, 비병합 컬럼 오른쪽에 둔 병합 대상 컬럼은 실제로 병합되지 않아도 오류가 아니다(설계 확인 권고만). | 문구 '오류가 아니' (자동(문구 기준)) | _trace.spec.ts:1107;_trace.spec.ts:1108;_trace.spec.ts:1111;_trace.spec.ts:1112;judge.py:1876;judge.py:1882;judge.py:1884;make_verify_docs.py:296 | 사용자 판정 2026-10-27 (SCP0007 정합검증서 v51 조치 필요 "셀병합 적용되어 있음 — 실제 오류 아님") |
| CR-074 | ALL | 그리드 Insert 신규행 위치 | 세트(그룹) 구조가 없는 목록 그리드에서 Insert 한 새 행은 맨 위에 생긴다(공용 DataGrid 기본). AS-IS 가 활성 행 위치에 삽입하더라도 오류가 아니다. 세트 구조가 있는 화면(DMF0044/DMF0049 류)은 hook #144 "포커스 행 세트 바로 위" 가 우선한다. | 문구 '오류가 아니' (자동(문구 기준)) | _trace.spec.ts:1354;eg_auth.spec.ts:508;eg_auth.spec.ts:509;judge.py:1868;judge.py:1871;judge.py:1875 | 사용자 판정 2026-10-27 (SCP0007 정합검증서 v51 D6 "판단오류 — 정상 확인") |
| CR-077 | ALL | 그리드 컬럼 필수 표시(라벨 *) | TO-BE 는 컬럼 라벨에 필수 표시 '*' 를 붙이지 않아도 오류가 아니다. AS-IS 라벨과 TO-BE 라벨(SHEET_COLUMNS COLUMN_LABEL_NAME)에서 '*' 를 뺀 문구가 같으면 PASS(예: AS-IS 'Line*' ↔ TO-BE 'Line'). '*' 를 뺀 문구가 다르면 기존대로 판정한다. 저장 시 필수 공란 검증(checkRequiredOfSpread 동작)은 이 룰과 별개로 E3 저장 검증 행에서 판정한다. | 문구 '오류가 아니' (자동(문구 기준)) | e2e_suite_ingest.py:129;gen_expect.py:570;mapping_trace.py:902;mapping_trace.py:903;snap_expect.py:6 | 사용자 판정 2026-10-29 SCP0020 CheckList v12 조치 필요 6번 ("TO-BE 에서는 * 빼도 오류 아니므로, 오류항목에 |
| CR-092 | SCP;SSP | SCP·SSP 컬럼·조회조건 라벨 Valid→Active | SCP·SSP 화면의 컬럼(그리드·팝업 그리드) 명칭과 조회조건 명칭 'Valid' 는 'Active' 로 변경한다(일괄 적용). ① AS-IS 라벨 'Valid'(또는 'Valid*') 이 TO-BE 에서 'Active' 로 바뀐 것은 오류가 아니라 PASS 다. ② 실제 개발·보완 시 TO-BE 에 'Valid' 로 남아 있는 라벨(메타 SHEET_COLUMNS.COLUMN_LABEL_NAME · 조회조건 기준표 tobe_name · Form 라벨 · 화면 실측 헤더)은 'Active' 로 변경해야 한다(잔존 = FAIL · 보완 대상). 비교는 '*'·대소문자·공백을 무시한 전체 일치('Valid From/To'·'Route Valid' 등 복합 명칭은 대상이 아님 — 사용자 확인 뒤 label_ali | 문구 '오류가 아니' (자동(문구 기준)) | _trace.spec.ts:19;_trace.spec.ts:428;_trace.spec.ts:729;_trace.spec.ts:1440;labelalias.ts:1;gen-e2e.js:280;new_screen.md:19;e2e_suite_ingest.py:129 …(+8) | 사용자 지시 2026-10-30 |
| CR-093 | ALL | 편집 모드 버튼(Edit F2) 없이 셀 직접 편집 | TO-BE 는 Edit(F2) 버튼으로 편집 모드를 켜지 않고 셀을 바로 편집한다 — K4 버튼 구성에서 Edit 누락은 오류가 아니며(사용자 결정 2026-10-30 SCP0111) D1 편집 기대는 AS-IS 편집 모드 ON 상태(SwitchLock 뒤 LockColumn/LockRange 결과)를 기준으로 판정한다. | 문구 '오류가 아니' (자동(문구 기준)) | griddisp.ts:29;griddisp.ts:32;griddisp.ts:44;griddisp.ts:49;insertpre.ts:95;facts_lockrules.py:258;judge.py:2692;judge.py:2699 …(+5) | 사용자 결정 2026-10-30(SCP0111 CheckList) |
| CR-095 | ALL | Excel Form 버튼 | Excel Form 은 팝업이 기본이다. 사용자 요구에 따라 팝업 없이 양식 생성 후 다운로드·자동 조회로 바꾼 화면도 오류가 아니며 사용자 판정 항목으로 분류한다(FAIL 금지). 버튼을 눌러도 아무 동작이 없을 때만 FAIL. | 문구 '오류가 아니' (자동(문구 기준)) | scenario.ts:4;scenario.ts:47;scenario.ts:52;scenario.ts:53;gen_expect.py:280;gen_expect.py:1127;judge.py:275 | 사용자 결정 2026-11-03(2회차 교정) |
| CR-096 | ALL | 검색 팝업(공용 모달) 호출 인자 | TO-BE 공용 검색 모달은 Division·입력값 등 모달이 받는 인자만 연동하고 그 밖의 AS-IS 인자(scp_module_type 고정값·SCM_SITE_ID 필터·셀 더블클릭 자동 조회 등)는 TO-BE 룰로 바뀐 것이라 오류가 아니다(사용자 결정 2026-11-06 SCP0037 10번 · SCP0127 8·9·10번). 팝업이 열리지 않거나 선택값이 칸에 반영되지 않는 것만 결함(M4·G5 선택값 반영 행). | 문구 '오류가 아니' (자동(문구 기준)) | judge.py:2944;judge.py:2951;judge.py:2952 | 사용자 결정 2026-11-06 |
| CR-097 | ALL | 그리드 필터 유지 재조회 | 재조회(Search) 시 그리드 필터는 공용 그리드 동작을 따른다 — 필터가 초기화되어 전체 행이 다시 표시되는 것은 공통 기능이며 화면 결함이 아니다(필터 유지도 허용). 건수 표시는 표시 행과 일치해야 한다. | 문구 '결함이 아니' (자동(문구 기준)) | filterkeep.ts:9;filterkeep.ts:12 | 사용자 판정 2026-11-06 SCP0016 11번(필터 유지 재조회 — 공통 기능·오류 아님) |
| CR-098 | SCP;SSP | 조회조건 순서(Excel 조회조건 정리 대조 범위) | Excel 조회조건 정리(search_cond.csv) 대조는 사용여부(USE 조건 누락 · 기준표 제외 조건 잔존)와 EDIT 형태(입력 유형: 선택/텍스트 · 단일/다중 · 검색/달력)까지만 판정한다. 조회조건 순서는 판정 대상에서 제외한다 — 화면 순서가 Excel List 시트 순서(tobe_seq)·정렬원칙 순서(tobe_order)·AS-IS 배치 어느 것과 달라도 FAIL·판정필요로 쓰지 않고 NA(실측 순서는 참고 증거로만 보존). CR-071 의 '순서 다름 = 결함' 항목을 대체한다. 생성(gen.js) 시 기준표 순서 배치는 설계 기본값으로 유지(판정 아님). | 문구 '달라도' (자동(문구 기준)) | smoke-extra.ts:358;smoke-extra.ts:359;judge.py:412;judge.py:414;judge.py:415;judge.py:418;judge.py:461;judge.py:462 …(+5) | 사용자 지시 2026-11-09 (SCP0084 CheckList 조치 필요 1건 SC1 조회조건 순서 — 오류 아닌 정상) |
| CR-099 | ALL | 그리드·팝업 그리드 컬럼 가로 정렬 | AS-IS 에서 Center 였던 컬럼이 TO-BE 에서 Left 인 것은 TO-BE 룰로 정렬 방식이 바뀐 것이라 결함이 아니다(조치필요·판정필요에 올리지 않음 · PASS 로 근거 표시). 그 밖의 정렬 차이(Right↔Left·Left→Center 등 숫자 칸 정렬 깨짐 포함)는 종전대로 FAIL. | 문구 '결함이 아니' (자동(문구 기준)) | align_check.py:21;align_check.py:109 | 사용자 판정 2026-11-09 SSP0024 CheckList 조치필요 2·3번(ItembyDivision 팝업 MODEL_ID·NICK_NA |
| CR-100 | ALL | TO-BE 메타 공통 셀 팝업(SCM_MST_SHEET_COLUMNS CELL_CONTROL_OBJECT_T | TO-BE 메타 공통 셀 팝업은 TO-BE 팝업 룰을 따른다 — 제목 없음 · 조회 건수 표시 없음 · ↓ 키 행 이동 없음은 결함이 아니다(PASS 로 근거 표시). 같은 팝업의 버튼 순서(OK→CLOSE)·No. 컬럼·'_' 폴백/코드 노출 제목은 종전대로 검사하고 화면 고유 팝업(조회조건 돋보기 팝업 등)은 대상이 아니다. | 문구 '결함이 아니' (자동(문구 기준)) | _verify.spec.ts:160;_verify.spec.ts:917;_verify.spec.ts:920;eg_ingest.py:51;eg_ingest.py:54;eg_ingest.py:69;eg_ingest.py:206;eg_ingest.py:230 …(+3) | 사용자 판정 2026-11-10 SSP0024 CheckList v4 조치필요 2번(MATERIAL_ID 셀 팝업 제목 없음) · SSP0025 |
| CR-101 | ALL | 차등 검증(같은 인자로 AS-IS SP ↔ TO-BE PROC 실행 대조)의 결과 판정 | 값 불일치는 AS-IS DEV DB 와 사내(TO-BE) DB 의 데이터 차이로 생길 수 있으므로 오류가 아니라 판정필요로 둔다. 오류(FAIL)로 도출하는 것은 TO-BE 조회 자체가 되지 않는 경우(실행 오류)뿐이다. | 문구 '오류가 아니' (자동(문구 기준)) | diff_verify.py:386;diff_verify.py:409;mapping_trace.py:788;mapping_trace.py:790 | 사용자 지시 2026-11-11 16:5x '재고수량은 AS-IS 와 TO-BE 의 DB 데이터 차이로 발생할 수 있으니 판정필요 항목으로 이관 |
| CR-102 | ALL | 화면·버튼·편집 권한 판정(로그인 사용자의 권한 그룹) | TO-BE 는 특정 권한 하나만 쓰지 않고 USER_ID 기준으로 그 사용자가 가진 권한을 합집합으로 사용한다. AS-IS 가 한 권한만으로 판정해 막던 것이 TO-BE 에서 다른 보유 권한으로 허용되는 차이는 오류가 아니라 TO-BE 에서 바뀐 룰이다. 검사기의 권한 기대값도 보유 권한 합집합 기준으로 계산한다. | 문구 '오류가 아니' (자동(문구 기준)) | eg_auth.spec.ts:323;condeval.ts:114;condeval.ts:124 | 사용자 결정 2026-11-12 14:2x('권한도 특정 하나의 권한만 사용하는 것이 아니라 USER_ID 기준의 권한을 합집합으로 사용하도록  |
| CR-103 | ALL | AS-IS 편집(Edit) 버튼 경로의 안내 메시지(EditButton 진입점에서만 닿고 Save 진입점에서 | TO-BE 는 편집 버튼이 없다. 화면을 조회할 때 편집 가능한 상태면 자동으로 편집 모드가 적용되어 편집 가능 컬럼의 배경색이 바뀌고 편집 가능 상태로 동작하면 된다. 편집 불가일 때는 조회만 되면 된다. AS-IS 편집 버튼 경로의 안내 메시지는 TO-BE 에 없어도 정상이다(메시지 유무를 오류로 판정하지 않는다). 검사는 메시지가 아니라 편집 가능 상태일 때 편집 가능 컬럼의 배경색·편집 가능 여부, 편집 불가 상태일 때 편집이 막히는지를 본다. 반대로 편집 권한이 있는 사용자가 화면을 열고 조회했는데 편집이 불가하면 그것은 오류(FAIL)다. | 문구 '정상이다' (자동(문구 기준)) | _trace.spec.ts:875;_trace.spec.ts:882;_trace.spec.ts:883;_verify.spec.ts:2531;griddisp.ts:38;griddisp.ts:49 | 사용자 결정 2026-11-12 14:4x(질문 폼 — '화면을 조회할 때 편집 가능한 상태일 때만 편집모드로 자동으로 적용되어 편집 가능 CO |
| CR-104 | ALL | 그리드 행 선택용 체크 컬럼(AS-IS CHK 컬럼 + 머리글 전체 체크) | AS-IS 의 CHK 컬럼이 TO-BE 그리드 컬럼에 없어도 행 머리 선택기와 머리글 전체 선택이 있으면 오류가 아니라 TO-BE 룰이다(PASS 로 근거 표시). 선택기가 없으면 종전대로 FAIL. CHK 컬럼을 그대로 표시한 화면(SSP0003 등)도 정상이다. | 문구 '오류가 아니라 TO-BE 룰' (사용자 판정) | _trace.spec.ts:443;_trace.spec.ts:446;judge.py:1589 | 사용자 판정 2026-11-16 SSP0020('룰로 인정') · AS-IS SSP0020_Delegate.cs:216~218 · TO-BE D |
| CR-106 | ALL | 컬럼 설정 팝업 버튼 구성 | TO-BE 공용 컬럼 설정 팝업의 Default·Save 버튼과 제목 줄 닫기 아이콘을 TO-BE 표준으로 본다. OK·Cancel 버튼이 없어도 오류 아님(PASS 로 근거 표시). | 문구 '오류 아님' (자동(문구 기준)) | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | 사용자 확정 2026-11-17 일괄 질의 Q11 '권장안대로 확정' · 결정 24 · AS-IS SCM002_CAPAColumnPopup.de |
| CR-109 | SCP0104 | ASSEMBLY 시트 조회조건 Material 비교 방식 | TO-BE 는 Model(ITEM_ID) 또는 Nickname(NICK_NAME)을 대소문자 무시 부분 일치(LIKE)로 비교한다. AS-IS NICK_NAME 정확 일치와 달라도 오류 아님. 2026-11-13 기준 'LIKE 는 AS-IS 가 LIKE 일 때만'의 예외로 이 화면 ASSEMBLY 시트에만 적용한다. ELTR 시트(결정 30)는 해당 없음. | 문구 '달라도' (자동(문구 기준)) | judge.py:2806 | 사용자 확정 2026-11-17 일괄 질의 Q17 '요청 변경 인정' · 결정 31 · AS-IS SCP0104_GET_CAPA_LINE_ASS |
| CR-110 | ALL | 조회 총 건수 표시 | 총 건수 표시는 TO-BE 공용 건수 영역(Total N rows)이 활성 그리드 행 수를 보여 주면 오류 아님(PASS 로 근거 표시). AS-IS 상태바 Total 위치·문구와 달라도 같은 취급. 공용 건수 영역이 없거나 숫자가 그리드 행 수와 다르면 FAIL. | 문구 '오류 아님' (자동(문구 기준)) | _trace.spec.ts:1745;_trace.spec.ts:1750 | 사용자의견 2026-11-17 SCP0104 v22 11번 '총건수 표기 부분은 TO-BE RULE 로 TO-BE 일반과 동일하면 오류 아님'  |
| CR-111 | SCP0104 | 화면 첫 진입 때 사용자 칸 설정 자동 생성 | TO-BE 는 화면을 처음 열면 그 사용자의 칸 설정 행(SCP0104 87행)을 자동으로 만든다. AS-IS 와 생성 시점이 달라도 오류 아님(TO-BE 동작 인정). 시험이 만든 행은 시험 뒤 지운다. | 문구 '달라도' (자동(문구 기준)) | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | 사용자 확정 2026-11-17 'TO-BE 동작 인정' · 실측 lucky-alex 10:08·11:31 87행 생성 |
| CR-112 | SCP0096 | 조회조건 Day of the week · Input Value 위치 | AS-IS 조회조건 영역의 Day of the week · Input Value · Input 버튼은 TO-BE 에서 버튼 영역 '입력'(Bulk Update) 팝업 안으로 옮긴다. 조회조건 라벨 대조에서 이 2개가 조회 영역에 없어도 오류 아님(PASS 로 근거 표시). 팝업 안 두 칸의 라벨·후보·일괄 입력 동작은 기존 검사대로 판정한다. | 문구 '오류 아님' (사용자 확정) | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | 사용자 확정 2026-11-18 'G4 는 TO-BE 룰로 등록' · TO-BE ShipmentWorkingDayOspInputModal.tsx |

## 2. 화면별 설계 결정 (DD) — AS-IS 기능을 TO-BE 에서 제외·변경하기로 한 결정

### ALL (3건)

| 결정 | 검사 규칙 | 대상 | AS-IS → TO-BE · 사유 | 확인 상태 | 출처 |
|---|---|---|---|---|---|
| DD-215 | I1 | 조회 건수 총/건 표기 — CN(중국어) 언어 | AS-IS: CN 언어 총/건 표기 검사 대상 → TO-BE: 검사 대상 제외(NA) · 사유 사용자 결정 2026-11-06(SCP0122 CheckList 조치 필요 항목) — 이 항목과 동일 케이스는 대상에서 제외 | 확인(사용자 지시 2026-11-06) | USER#1  |
| DD-216 | I2 | 언어 전환 CN — 화면 문구(라벨·버튼·헤더)가 CN 등록 문구인지 | AS-IS: CN 언어 화면 문구 검사 대상 → TO-BE: 검사 대상 제외(NA) · 사유 사용자 결정 2026-11-06(SCP0122 CheckList 조치 필요 항목) — 이 항목과 동일 케이스는 대상에서 제외 | 확인(사용자 지시 2026-11-06) | USER#2  |
| DD-217 | K1 | 필터 유지 재조회 — 그리드 필터 적용 뒤 재조회 시 필터 유지 여부 | AS-IS: 화면별 검사 대상 → TO-BE: 검사 대상 제외(NA) · 사유 사용자 결정 2026-11-06(SCP0016 CheckList 11번) — 공통 기능(공용 DataGrid)이라 화면별 오류 아님 | 확인(사용자 지시 2026-11-06) | USER#3  |

### DMF0003 (19건)

| 결정 | 검사 규칙 | 대상 | AS-IS → TO-BE · 사유 | 확인 상태 | 출처 |
|---|---|---|---|---|---|
| DD-001 | B5;A5 | Measure 설정 팝업 후보 · 신규 행 Measure 콤보(BNPIn · MKT_FCST_MEASURE · SCM_MST_SHEET_MEAS | AS-IS: BNP In 기본 표시·신규 입력·수정 가능(기준 코드 MKT_FCST_MEASURE 82 BNPIn 입력 Y·편집 Y·사용 Y) · 82 기본 표시 Measure 4개 → TO-BE: BNP In 이 Measure 목록·신규 행 후보에서 빠짐(입력 N·편집 N·사용 N) · 82 기본 표시 Measure 3개 · 사유 처리 내역: TO-BE에서는 BNP In Measure는 사용하지 않음(제외) | 확인(원천 제외) | GAP#3 F-04 |
| DD-002 | K2;A5 | 컬럼·Measure 셋팅 개인화(SCM_MST_TITLESET_USER · Column Setting · Measure) | AS-IS: 사용자가 켜 둔 칸·Measure 설정 유지(이관) → TO-BE: 사용자별 화면 설정 이관분 없음 — 새 시스템에서 생성된 행만 · Division 별 Default Measure 설정 일치로 갈음 · 사유 처리 내역: 사용자별로 Measure 설정은 다를 수 있음, Division별 Default Measure 설정이 일치하는지 확인하면 문제 없음(동일) — 제외 | 확인(원천 제외) | GAP#9 F-10 |
| DD-003 | E3;A5 | Project Code 컬럼(PROJECT_CODE) 필수 검사 MSG00429 · 필수 컬럼 조회 결과 포함 | AS-IS: Project Code 필수 검사 없음 → TO-BE: Project Code 필수(수정 행 포함) — 비면 MSG00429 「{0} 값은 필수 입력 항목입니다.」 차단 · UI Category User Selected Flag N 필수컬럼 · 사유 처리 내역: UI Category 정보에서 Project Code 컬럼의 User Selected Flag 값이 N(필수컬럼) — 조회·저장 시 필수 체크, 개인화 정보는 초기화 또는 Default 저장으로 처리(제 | 확인(원천 제외) | GAP#10 F-11 |
| DD-004 | A6 | 그리드 결과 행 정렬(ORDER BY Team·Owner 빈 값 위치·대소문자 — DEPT_ID·OWNER) | AS-IS: 빈 값 먼저 · 대소문자 무시 정렬 → TO-BE: 빈 값 맨 뒤 · 대문자 먼저(Oracle 기본 정렬) · 사유 처리 내역: MSSQL 과 Oracle 정렬 규칙 차이, AS-IS 동일화는 NULLS FIRST·자료형 판단 필요라 제외(정렬이 큰 문제는 아님) | 확인(원천 제외) | GAP#14 F-16 |
| DD-005 | G6 | 조회조건 Bucket 콤보(BUCKET · bucketType) 초기값 | AS-IS: 진입 시 82 = Daily, 그 밖 = Weekly → TO-BE: 조회조건 초기값·사업부 변경·Team 변경 모두 Weekly · 사유 처리 내역: Division 82도 Default 로 Weekly 로 표시하기로 함(제외) | 확인(원천 제외) | GAP#15 F-17 |
| DD-006 | C4;MS1 | 조회조건 Bucket 콤보(BUCKET) 변경 시 Insert 행 존재 검사 MSG00227 | AS-IS: Bucket 목록을 누르면 MSG00227 「INSERT 모드에서는 저장 후 Bucket 변경이 가능합니다.」 안내 후 변경 가능(칸 재구성) → TO-BE: 선택을 되돌리고 MSG00227 「Insert 된 행이 있어 Bucket 을 변경할 수 없습니다.」 차단 · 사유 처리 내역: AS-IS 는 Edit 모드가 있으나 TO-BE 에는 없어 차단 메시지가 맞음(제외) | 확인(원천 제외) | GAP#20 F-22 |
| DD-007 | E3;D1 | 40 저장 필수 검사 키 칸 이름(CUSTOMER_40·SCM_SITE_ID_40·ITEM_ID_40 ↔ END_CUSTOMER40·SCM_SI | AS-IS: 40 은 End Customer40·Sales Site40·Model40 칸 값으로 저장 → TO-BE: 40 편집 불가(다른 화면에서 입력) — 화면 필수 검사 키 칸 이름 수정하지 않음 · 사유 처리 내역: Division 40 은 다른 화면에서 입력하고 있어 따로 수정 불필요(제외) | 확인(원천 제외) | GAP#23 F-25 |
| DD-008 | A7;G1 | 그리드 MKT FCST[R+P]·RTF[R+P]·Balance 수량(MKT_FCST_RP·RTF_SYS_RP·BALANCE) — invalidE | AS-IS: 원장 수량 그대로 표시(82 는 해제 경로에 들어가지 않음) → TO-BE: 해제 분기 수량 결합의 일자 조건 미수정(AS-IS 로직 유지) · 화면이 82 는 invalidExec 'Y' 고정 전송으로 분기 미진입 · 사유 처리 내역: Division 82 조회 시 InvalidExe = Y 고정 전달 수정 완료, 결합 일자 조건 추가는 수정에서 제외(AS-IS 로직 유지) — 제외 | 확인(원천 제외) | GAP#24 F-26 |
| DD-009 | D5;E7 | 신규 행 Project Code·Model 칸(PROJECT_CODE·ITEM_ID) 에디터 FPTextModal(입력 + 팝업) | AS-IS: Project Code·Model 칸 더블클릭 → 팝업에서 고른 값이 칸에 입력(FPTextBox) → TO-BE: 입력 가능한 팝업 Modal(FPTextModal) — 더블클릭 시 입력 상자도 열림, Key-in 오류는 저장 프로시저 Validation · 사유 처리 내역: TO-BE 는 입력 가능한 팝업 Modal 로 기능 변경, 잘못된 Key-in 값은 저장 프로시저 Validation 처리라 문제없음(제외) | 확인(원천 제외) | GAP#25 F-27 |
| DD-010 | H10 | 저장 실행 오류 공통 응답(-9994 「Sql Error」 · RAISE_APPLICATION_ERROR -20001 · P_DMF0003_SA | AS-IS: 저장 프로시저가 「[오류 번호]_O + 원인 문구」 를 결과로 돌려주고 화면이 그대로 알림 → TO-BE: 서버 공통 처리가 코드 -9994 · 「Sql Error」 로 바꿔 응답, 화면은 응답 문구만 알림 · 사유 처리 내역: 공통 메시지라 보안적으로 오류 내용을 알려주면 안 됨(제외) | 확인(원천 제외) | GAP#28 F-30 |
| DD-011 | H10 | 저장 검증 실패 반환 문구 머리말 「ERR_RTN: - Validation Check : 」(P_DMF0003_SAVE_MKT_FCST 결과 코 | AS-IS: 검사 실패 시 문구만 결과로 반환(예 「[모델] BOM does not exist !」) → TO-BE: 결과 코드 -1 과 「ERR_RTN: - Validation Check : 」 + 검사 문구 반환, 화면이 그대로 알림 · 사유 처리 내역: 머리말 제거 요청이 없어 유지(제외) | 확인(원천 제외) | GAP#30 F-32 |
| DD-012 | K4;J2 | Insert·Delete·Save 버튼 노출(편집 불가 사업부 DM_UI_EDITABLE_DIVISION · MSG00448) | AS-IS: Edit 를 누르면 MSG00448 「해당 사업부 편집은 Demand - Demand Plan - FcstPrice MGMT 에서 할 수 있습니다.」 안내 → TO-BE: Insert·Delete·Save 단추 숨김, 안내 없음 · 사유 처리 내역: 입력은 Division 82 만 가능하므로 버튼 미표시가 맞음(제외) | 확인(원천 제외) | GAP#34 F-36 |
| DD-013 | K4 | 그리드 우클릭 PR 메뉴(Request PR·View PR·Add History·View History) | AS-IS: 82 BNP In 행에서 PR 요청·조회·이력(우클릭 메뉴) → TO-BE: 우클릭 메뉴 등록이 막혀 진입 불가(유지) · 사유 처리 내역: To-be 에서는 사용하지 않기로 현업 결정(제외) | 확인(원천 제외) | GAP#35  |
| DD-014 | G4;H2 | 조회조건 Color 체크박스(ADMIN·DM ADMIN) · 현재 월·주 헤더 녹색 강조(Color) | AS-IS: 과거 회색·이번 달 흰색 ↔ 현재 주 녹색 테두리 전환(Color 체크) → TO-BE: 체크 상자 없음, 현재 월·주 헤더 녹색 강조와 당주 녹색 세로선 고정 · 사유 처리 내역: 항상 초록색을 표시하기로 하여 checkbox 는 사용하지 않음(제외) | 확인(원천 제외) | GAP#36  |
| DD-015 | J2;K4;D1 | 81 계열 Insert·Delete·Save 버튼 · 셀 편집(DM_UI_EDITABLE_DIVISION DMF0003 81 편집 N) | AS-IS: DM·ADMIN 그룹 편집, SCP Planner 화요일 시간창 → TO-BE: 편집 불가(조회 전용, Insert·Delete·Save 단추 숨김) · 사유 근거 81 입력 DMF0082 이전 확정 2026-08-20 · 처리 내역: TO-BE 에서는 Division 82 만 입력(제외) | 확인(원천 제외) | GAP#37  |
| DD-016 | E3;J3 | 저장 필수 검사 AS From Site(AS_FROM_SITE · FCST_TYPE AS/WS · MSG00476) 적용 그룹 | AS-IS: DM Planner (W/S) 만 AS From Site 필수 검사 → TO-BE: 편집 가능 전 그룹(유지) — MSG00476 「… AS FROM SITE는 필수로 입력이 필요합니다.」 · 사유 근거: 2026-08-14 사용자 확정, 화면 소스 저장 검사·입력 허용 판정에 그룹 조건 없음 — 처리 상태 제외 | 확인(원천 제외) | GAP#39  |
| DD-017 | C2 | 신규 행 키 칸(SCM_SITE_ID·PROJECT_CODE·ITEM_ID) 변경 시 기간 수량 칸 유지 | AS-IS: 키 칸을 바꾸면 입력한 수량 전부 지움 → TO-BE: 수량 유지 — 팝업으로 Project·Model 을 바꿔도 수량 유지 · 사유 처리 내역: TO-BE 에서는 수량을 초기화하지 않는 것으로 기능 변경(PI 요청사항, 2026-08-27 제거 결정) — 제외 | 확인(원천 제외) | GAP#41  |
| DD-018 | B5;C2 | 신규 행 Measure 콤보 후보(MktFcstEditMeasure · MEASURE) — 일반/VMI/비축 사이트 · Sales Site 변경 | AS-IS: 비축 사이트 = AS_In_Req 만, 그 외 = MKT_FCST_RP, BNP In 입력 가능 · Sales Site 변경 시 Measure 자동 변경(비축 → AS_In_Req) → TO-BE: 후보는 선택 목록(MktFcstEditMeasure)이 정함 · 일반/VMI/비축별 후보 · 자동 변경 없이 기본값 MKT FCST[R+P] 에서 사용자가 선택 · 사유 처리 내역: TO-BE 는 PI 요청(결함원장 37·135)으로 반영된 기준이 맞음, BNP In Measure 사용 안 함(제외) | 확인(원천 제외) | GAP#42  |
| DD-019 | A6 | 그리드 조합 내 Measure 행 순서(RTF_SYS_RP → VMI_In_Plan → VMI_In_Req → VMI_Inv → MKT_FCST | AS-IS: 종속 Measure 순번 동률로 순서 미정 → TO-BE: RTF_SYS_RP → VMI_In_Plan → VMI_In_Req → VMI_Inv → MKT_FCST_RP 고정(순번 소수 자리 .1~.9) · 사유 처리 내역: 개인화 Measure 에서 지정한 순번대로 조회 처리되게 수정(제외 — 의도된 고정 순서) | 확인(원천 제외) | GAP#43  |

### DMF0004 (4건)

| 결정 | 검사 규칙 | 대상 | AS-IS → TO-BE · 사유 | 확인 상태 | 출처 |
|---|---|---|---|---|---|
| DD-020 | D4 | Sales Customer 신규 행 Rep(REP_YN) · Sales Site 신규 행 Ship Plan Auto(SHIP_PLAN_AUTO) | AS-IS: Sales Customer 신규 행 Rep = Y · Active = Y. Sales Site 신규 행 Ship Plan Auto 빈 값(미선택 저장 시 MSG00002 「{0} 값은 필수 입력입니다」) → TO-BE: Sales Customer 신규 행 Rep = N, Sales Site 신규 행 Ship Plan Auto = N 자동 입력(필수값 기본 채움) — 화면 확인 VMI_YN N · VALID_YN Y · REP_YN N · SHIP_PLAN_AUTO N · 사유 처리 상태 제외 — 처리 내역 「필수값처리되어있는 값을 자동으로 채워주는거라 결함인지..? YN값 처리 방식은 확인해보는게 맞을거 같지만 저 두 값은 현재 필수값으로 되어있음」 | 확인(원천 제외) | GAP#51 F-07 |
| DD-021 | N1 | 81_ST End Customer 기준 코드(SCM_ADM_LOOKUP_MASTER_DETAIL LOOKUP_TYPE END_CUSTOMER · | AS-IS: 81_ST 기준 코드의 코드 'LG ENERGY SOLUTION, LTD.'(이름 LGE) — 사이트 테이블 End Customer 값과 같음 → TO-BE: 코드 'LGE'(이름 LG ENERGY SOLUTION, LTD.) — 코드·이름 뒤바뀜. 결정 : 데이터를 LGE 로 통일, 콤마 포함 문자열은 제외하고 정리(PI 확인) · 사유 처리 상태 제외 — 처리 내역 「현재 DB의 데이터에 LGE와 LG ENRGYSOLUTION, LTD. 가 혼용… LGE로 통일하는게 제일 깔끔 → PI와 콤마로 된 문자열은 빼고 정리하기로 했다고 함(조이사님확인사 | 확인(원천 제외) | GAP#53 F-09 |
| DD-209 | C4;H10 | 하단 그리드 Insert 후 조회(Search) 시 미저장 변경 알림 메시지 | AS-IS: 미저장 변경이 있을 때 조회하면 알림 메시지 후 처리 → TO-BE: 동일 — 미저장 변경 알림 표시(현 동작 유지, 결함 미재현) · 사유 처리 상태 제외 · 처리 내역 "로컬, 개발, 품질 다 확인했으나 재현되지 않음" | 확인(원천 제외) | GAPSELF#8  |
| DD-210 | K3 | F5 조회 단축키(F5 · SEARCH) | AS-IS: F5 = 조회 단축키 → TO-BE: 동일 — F5 조회 단축키 유지(현 동작, 결함 미재현) · 사유 처리 상태 제외 · 처리 내역 "로컬, 개발, 품질 다 확인했으나 재현되지 않음(혹시 개발자도구를 킨 상태가 아니었는지)" | 확인(원천 제외) | GAPSELF#11  |

### DMF0005 (16건)

| 결정 | 검사 규칙 | 대상 | AS-IS → TO-BE · 사유 | 확인 상태 | 출처 |
|---|---|---|---|---|---|
| DD-022 | A5;E4 | Production 그리드 컬럼 구성(SCM_MST_SHEET_COLUMNS production_82) 25개 · 누락 17칸(Cell Type | AS-IS: 보이는 칸 41개·편집 칸 17개(Sales Sync·Cell Type·Currency·CONSENSUS·INVENTORY DAY·CHANGE REASON·Partial Plan YN·Cell Name 등) + 저장 전 검사(Inventory Days·CONSENSUS → TO-BE: 보이는 칸 25개 — 17칸 없음(칸 설정 production_82 에 행 없음, 저장 전달값·검사 없음) · 사유 처리 내역: UI Category 정보 상이, 조회 컬럼 구성은 UI Category 기준(25개) — 갭의 17개는 UI Category 에 없음(제외) | 확인(원천 제외) | GAP#63 F-02 |
| DD-023 | A5;E4 | Production 그리드 컬럼 구성(SCM_MST_SHEET_COLUMNS production_81) 32개 · 누락 12칸(Cell Type | AS-IS: 보이는 칸 42개·편집 칸 12개(Cell Type·Currency·Org.Name(Report)·End Customer(Report)·Project(S&OP Report)·양극재·Module Variant·대체/유사모델·Liablity(Week)·Description → TO-BE: 보이는 칸 32개 — 12칸 없음(칸 설정 production_81 에 행 없음, 저장 전달값 없음) · 사유 처리 내역: UI Category 정보 상이, 조회 컬럼 구성은 UI Category 기준 — 제외 | 확인(원천 제외) | GAP#64 F-03 |
| DD-024 | A5;E4 | Production 그리드 컬럼 구성(SCM_MST_SHEET_COLUMNS production_40) 31개 · 누락 15칸(APPLICATI | AS-IS: 보이는 칸 44개·편집 칸 15개(Application·Currency·Report Group 1~6·End Cust.(Report)·Cust Group Detail·Channel·대체/유사모델·Liablity(Week)·EDI Incoterms·EDI Leadtime → TO-BE: 보이는 칸 31개 — 15칸 없음(칸 설정 production_40 에 행 없음, 저장 전달값 없음) · 사유 처리 내역: UI Category 정보 상이, 조회 컬럼 구성은 UI Category 기준 — 제외 | 확인(원천 제외) | GAP#65 F-04 |
| DD-025 | A5;E4 | Purchase 그리드 컬럼 구성(SCM_MST_SHEET_COLUMNS purchase_81 23개 · purchase_82 16개) · 누락 | AS-IS: 보이는 칸 81 30개·82 22개 — Cell Type·Sales Sync·Currency·Liablity(Week)·Project Status·81 양극재·Module variant·82 Customer Model → TO-BE: 보이는 칸 81 23개·82 16개 — 위 칸 누락 · 사유 처리 내역: UI Category 정보 상이, 조회 컬럼 구성은 UI Category 기준 — 제외 | 확인(원천 제외) | GAP#66 F-05 |
| DD-026 | D4;F1 | 신규 행 저장 원장 칸 기록(CURRENCY·ATTRIBUTE10 Cell Type CELL_TYPE_00·ATTRIBUTE9 Cell Name | AS-IS: 신규 행 저장 시 Currency·Liability·Application·Channel·Report Group·Cell Type(81·82 CELL_TYPE_00 고정)·Consensus·Inventory Day·Cell Name(같은 모델 다른 사이트 값 상속) 기록 → TO-BE: 신규 저장 칸에 위 칸 없음 → 빈 값 (PI 회신으로 제외) · 이후 81·82 신규 Currency·Cell Type·Cell Name·Liability 는 반영, 40 Currency·Report Group 은 칸 구성 결정 대기 · 사유 처리 내역: PI 요청사항으로 AS-IS 신규행 저장 시 들어가는 컬럼들은 제외되는 것이 맞다(SSPM ERRC 영향도 PI 회신) — 제외 · 확인사항 판정 미반영(40) | 확인(원천 제외) | GAP#67 F-06 |
| DD-027 | A1 | 81 하위 사업부(81_UC·81_HD) 조회 결과 행 — H·P 품목 유형 필터(ITEM_TYPE) | AS-IS: 하위 사업부는 품목 유형(H·P) 필터 없이 전 행 표시(81_UC 644 · 81_HD 393) → TO-BE: 81 과 같은 H·P 필터 적용(81_UC 327 · 81_HD 243) · 사유 처리 내역: 품목원장 데이터 이슈라 기능 이슈가 아니어서 제외 | 확인(원천 제외) | GAP#74 F-14 |
| DD-028 | E3 | 저장 필수 검사 Owner(PM)(PRJ_OWNR_ID)·Team(DEPT_ID) INPUT_TP_CD M · MSG00429 | AS-IS: Owner(PM)·Team 필수 검사 없음(Owner(PM) 라벨 * 표시만, Team 은 저장 전달값 없음) → TO-BE: Owner(PM)·Team 필수(입력 구분 M) → 빈 기존 행은 MSG00429 로 차단 · 사유 처리 내역: To-be 에서는 Team 이 필수항목임(제외) | 확인(원천 제외) | GAP#76 F-16 |
| DD-029 | B8 | 그리드 Team 컬럼(DEPT_ID) 표시·조회 원천 — 원장 SCM_MST_SITE_ITEM.DEPT_ID | AS-IS: Team = Owner 첫 담당자의 부서 → TO-BE: Team = 사이트·모델 행(원장 DEPT_ID) 부서 — 원장 부서 빈 행은 Team 빈칸 · 사유 근거 부서 축 아이템 원장 통일(2026-08~09 결정) · 처리 내역: PI 요청으로 Team 목록 표시기준 정의하여 처리 완료(제외) | 확인(원천 제외) | GAP#88  |
| DD-030 | C1 | 조회조건 End Customer(END_CUSTOMER) → Sales Site(SCM_SITE_ID) 후보 cascade — 40 · 아이템  | AS-IS: 40 End Customer → Sales Site 연계 없음 → TO-BE: End Customer 로 Sales Site 후보 좁힘 + 아이템 없는 사이트 허용 · 사유 근거 2026-09-07 P13 지시 · 처리 내역: TO-BE 기준이 맞음(제외) | 확인(원천 제외) | GAP#90  |
| DD-031 | C3;C2 | 신규 행 Sales Site(SCM_SITE_ID) → Sales Company(SALES_COMPANY)·Plant(SALES_PLANT) 자 | AS-IS: Company 선택 시 Plant 첫 값 → TO-BE: Site 입력 → Company·Plant 자동, Company 변경 → Plant 초기화·후보 밖 입력 취소 · 사유 근거 결함 원장 48(P11)·70번 · 처리 내역: TO-BE 에 해당 기능 이미 존재(제외) | 확인(원천 제외) | GAP#91  |
| DD-032 | D4;F1 | 40 신규 행 Active(VALID_YN) 저장 값 = 화면값 | AS-IS: 40 신규 Active 'Y' 고정 → TO-BE: 화면값(N 가능) — 저장 프로시저 2026-08-28 Y 하드코딩 수정 · 사유 처리 내역: 기능적으로 문제 있는 것이 아니라서 제외 | 확인(원천 제외) | GAP#92  |
| DD-033 | E4;B4 | Owner 저장 검사 사용자 사용 여부(USE_YN) — Owner 팝업(P_COM0004_GET_OWNERINFO_POPUP) 후보에서 체크 | AS-IS: 저장 검사 사용자 UseYN='Y' 만 → TO-BE: 저장 검사 사용 여부 조건 제외 — Owner 팝업 후보(P_COM0004_GET_OWNERINFO_POPUP) 에서 USE_YN='Y' 체크 · 사유 근거 결함 원장 130번 · 처리 내역: Owner 팝업 프로시저에서 USE_YN 체크(제외) | 확인(원천 제외) | GAP#93  |
| DD-034 | B4;M3 | Owner 팝업 후보 목록(P_COM0004_GET_OWNERINFO_POPUP · OWNER) — 사용자 원장 전체 | AS-IS: SSPM 등록 Owner 만 → TO-BE: 사용자 원장 전체 · 사유 근거 결함 원장 130번 · 처리 내역: PI 요청으로 Owner 팝업 목록 기준 정의하여 개발 완료(제외) | 확인(원천 제외) | GAP#97  |
| DD-035 | B4;M3 | Team 팝업 후보 목록(DEPT_ID) — SSO 부서 전체 | AS-IS: 사용자 소속 Team 만 → TO-BE: SSO 부서 전체 조회(Admin 무관) · 사유 근거 결함 원장 13번 · 처리 내역: PI 요청으로 Team 팝업 목록 기준 정의하여 개발 완료(제외) | 확인(원천 제외) | GAP#98  |
| DD-201 | M4 | 그리드 Model 칸(ITEM_ID) 팝업 다중 선택 처리 — 첫 모델만 입력(MSG01443 미표시) | AS-IS: 팝업에서 여러 모델을 고르면 MSG00471 「Model은 한개만 선택하여 입력해주세요.」 안내 후 입력하지 않음 → TO-BE: 여러 모델을 고르면 첫 모델만 입력하고 안내 없음(화면 주석 「2026-10-13 사용자 요청」) · 사유 처리 내역: 하나만 입력되게 동작하므로 메시지 표시 불필요로 판단해 제외 · 확인사항 판정 확인필요(AS-IS 와 다름, PI 항목 없음) | 확인(원천 제외) | GAP#489 F-28 |
| DD-211 | D5 | 그리드 컬럼 에디터 유형 = UI Category(SHEET_COLUMNS · CELL_CONTROL_OBJECT_TYPE_CODE) | AS-IS: AS-IS 는 소스 코드에 컬럼 유형 고정(UI Category 미참조 의심) → TO-BE: UI Category(SHEET_COLUMNS) 설정값대로 그리드 컬럼 유형 구성(현 구현 그대로) · 사유 처리 상태 제외 · 처리 내역 "여러번 확인했으나 ui category 세팅값대로 작동해서 그려지고 있음" | 확인(원천 제외) | GAPSELF#13  |

### DMF0006 (5건)

| 결정 | 검사 규칙 | 대상 | AS-IS → TO-BE · 사유 | 확인 상태 | 출처 |
|---|---|---|---|---|---|
| DD-036 | A6 | 조회 결과 Team(DEPT_ID·TEAM_NAME) 빈 행의 정렬 위치 | AS-IS: Team(상위 부서) 빈 행이 맨 앞 → TO-BE: Team 빈 행이 맨 뒤(Oracle 빈 값 정렬) · 사유 처리 내역 : MSSQL과 오라클의 정렬규칙이 다름 컬럼 데이터유형에 따라 선언해야하는 부분이 달라서 이부분은 제외 | 확인(원천 제외) | GAP#106 F-08 |
| DD-037 | B2;N1 | End Customer 콤보 후보(END_CUSTOMER 기준 코드 81_ST 행 SEGMENT2·SEGMENT3) 중복 표시 | AS-IS: END_CUSTOMER 기준 코드 81_ST 행 코드 'LG ENERGY SOLUTION, LTD.' · 이름 'LGE' → TO-BE: 같은 행 코드 'LGE' · 이름 'LG ENERGY SOLUTION, LTD.'(뒤바뀜) → 사이트 원장 값과 연결 끊김, End Customer 목록에 같은 고객 두 줄 · 사유 처리 내역 : 데이터 확인(운영에서 사용하는 데이터 그대로 넘어오면 문제가 될 부분이 아님) — 제외 | 확인(원천 제외) | GAP#107 F-09 |
| DD-038 | B8 | Team 표시·조회 기준(DEPT_ID 원천 — 아이템 원장 OWNER 첫 담당자 부서 → SCM_MST_SITE_ITEM.DEPT_ID) | AS-IS: 아이템 원장 Owner 첫 담당자의 부서 → TO-BE: 아이템 원장 DEPT_ID — 82 1행(Jofemar SA_ES_PAA · em048126P3S7) Team 빈칸 · 사유 근거 : 부서 축 아이템 원장 통일(2026-08-28 지시) · 처리 내역 : 성능을 목적으로 튜닝한 변경사항, 주석에 남아있음 — 제외 | 확인(원천 제외) | GAP#109  |
| DD-039 | G8;G1 | 조회조건 Project(PROJECT_CODE·PJT 명) 텍스트 조건 — 부분 일치·대소문자 무시 | AS-IS: 코드 정확 일치 → TO-BE: 코드·PJT 명 부분 일치, 대소문자 무시 — 'A17LG' AS-IS 0 ↔ TO-BE 7행 · 사유 처리 내역 : 오라클 자체가 대소문자를 구분하여 조회하는 일부로 대소문자 상관없이 기능은 넣은거라 생각해 제외 | 확인(원천 제외) | GAP#110  |
| DD-040 | K4;D1 | 툴바 Edit 버튼(EDIT) 없음 · 입력 구분(INPUT_TP_CD) 컬럼 상시 편집 | AS-IS: Edit 로 편집 모드 전환 후 입력 → TO-BE: 상시 편집(입력 구분 칸만) · 사유 처리 내역 : TO-BE는 Edit버튼이 없음 · 근거 : TO-BE 공통 화면 구성(전 화면 Edit 버튼 없음) | 확인(원천 제외) | GAP#111  |

### DMF0007 (8건)

| 결정 | 검사 규칙 | 대상 | AS-IS → TO-BE · 사유 | 확인 상태 | 출처 |
|---|---|---|---|---|---|
| DD-041 | D4;E5 | Insert 행 Measure 셀(MEASURE) 기본값 — CUST_FCST_MEASURE 목록 값 'Customer FCST'(Custfcs | AS-IS: Insert 행 Measure 빈 칸 — 사업부별 목록(CUST_FCST_MEASURE)에서 선택해야 저장(빈 값 MSG00002) → TO-BE: Insert 행 Measure 자동 입력 — 목록 값 'Customer FCST' 로 교정(사업부별 목록 @divisionId) · 사유 처리 내역 「Customer Fcst --> Customer FCST(code : CUST_FCST_MEASURE) … 이이사님께 해당값만 들어가는게 맞다고 확인받음」 | 확인(원천 제외) | GAP#112 F-01 |
| DD-042 | A5;K4 | Customer PSI 시트(P_DMF0007_GET_CUST_PSI_DATA · Group 'PSI' · CUSTOMER_PSI_TYPE) 없 | AS-IS: 시트 2개(Customer FCST · Customer PSI) — PSI 시트 Group 'PSI' 행 조회·신규·Active 변경 저장 → TO-BE: 시트 1개(Customer FCST) — PSI 조회 버튼·칸 설정·저장 매핑 사용 안 함 · 사유 처리 내역 「TOBE로 넘어오면서 삭제」 | 확인(원천 제외) | GAP#115 F-04 |
| DD-043 | D4 | Insert 행 날짜 칸(D_YYYYMMDD · Weekly 131칸) 기본값 'Y' 전 구간 | AS-IS: 빈 칸 — 사용자가 Y 로 지정한 칸만 저장 → TO-BE: 131칸 전부 'Y' 자동 입력 · 사유 처리 내역 「Y값 다 들어가는게 괜찮다고 하셔서 그냥 두기로 결정」 | 확인(원천 제외) | GAP#116 F-05 |
| DD-044 | B4 | Measure 콤보(CUST_FCST_MEASURE · 81) 'Cutomer FCST' 항목 미포함(11건 → 10건) | AS-IS: 11건 — 'Cutomer FCST' 포함 → TO-BE: 10건 — 'Cutomer FCST' 없음(기준 코드 행 누락) · 사유 처리 내역 「해당화면은 measure customer fcst로 고정되어있는 화면이라 무관」 | 확인(원천 제외) | GAP#119 F-08 |
| DD-045 | A5 | EDI FCST Y/N 컬럼(EDI_FCST_YN) 숨김·입력 불가 — 신규 항상 Y | AS-IS: 칸 표시 · Insert 행 기본 Y · 선택 변경 가능 → TO-BE: 칸 숨김·입력 불가 — 신규 항상 Y · 사유 처리 내역 「ui category setup에서 해당값 설정 변경하면 나옴, 결함이 아님」 | 확인(원천 제외) | GAP#121 F-10 |
| DD-046 | A5 | Plan Week(PLAN_WEEK)·Bucket Type(SUMMARY_BUCKET_TYPE)·Group(GROUP_ID) 컬럼 숨김 | AS-IS: Plan Week · Bucket Type · Group 칸 표시(입력 불가) → TO-BE: 세 칸 숨김(2026-04-13) · 사유 처리 내역 「ui category setup에서 해당값 설정 변경하면 나옴, 결함이 아님」 | 확인(원천 제외) | GAP#122 F-11 |
| DD-047 | G6 | 조회조건 Division 콤보(DIVISION_ID) 초기 기본값 — 81 계열 우선, 없으면 권한 목록 첫 행 | AS-IS: 권한 사업부 목록 첫 행 → TO-BE: 81 계열 우선, 없으면 첫 행 · 사유 처리 내역 「ASIS와 동일하게 작동중. 단 공통규칙인 사업부 콤보리스트 첫 값 자동선택이 아니므로 추후 문제가 된다면 그때 수정」 | 확인(원천 제외) | GAP#128  |
| DD-048 | K4;D1 | Edit 버튼 없음 — 조회 즉시 편집 가능 셀 바로 입력(공통 그리드 방식) | AS-IS: Edit 로 편집 잠금 해제 후 입력 → TO-BE: 조회 즉시 입력(공통 방식) · 사유 근거 「TO-BE 공통 그리드 방식」 · 처리 내역 「TO-BE에서는 Edit모드가 없음」 | 확인(원천 제외) | GAP#130  |

### DMF0008 (6건)

| 결정 | 검사 규칙 | 대상 | AS-IS → TO-BE · 사유 | 확인 상태 | 출처 |
|---|---|---|---|---|---|
| DD-049 | K4;D1 | 하단 Sales Site 그리드(salesSite) 편집·Insert·Save 버튼 — 읽기 전용 · 툴바 Save·Insert·Edit 없음( | AS-IS: 수정 모드에서 기존 행 10칸(End Customer · Sold-To Customer · Company · VMI · Site Active · Customer Active · Rep Active · Country Name · City Name · Ship Plan A → TO-BE: 툴바에 Save · Insert · Edit 버튼 없음(저장 단축키 2026-08-24 비활성, 신규 단축키 최초 반영본부터 비활성). 하단 그리드 읽기 전용(2026-09-16). 저장 프로시저 · 서버 호출 등록(salesSite SAVE → PKG_DMF0008. · 사유 처리 내역 : 해당화면 입력로직 의도적으로 제거함 — 제외 | 확인(원천 제외) | GAP#131 F-01 |
| DD-050 | K4;D1 | SSPM 그리드(sspm) 편집 3칸(Sales Plant·EDI Incoterms·Active) · Insert · Save 버튼 — 읽기 전 | AS-IS: 수정 모드에서 기존 행 Sales Plant · EDI Incoterms · Active 3칸 수정(노란색). Sales Company 선택 시 Sales Plant 첫 값 자동 입력, Sales Plant 선택 시 Sales Company 자동 입력, Project → TO-BE: 툴바에 Save · Insert 없음, 그리드 읽기 전용(F-01 과 같은 시점 · 같은 변경). 편집 3칸 정의(Sales Plant · EDI Incoterms · Active)는 소스에 남아 있으나 미동작 · 사유 처리 내역 : 해당화면 입력로직 의도적으로 제거함 — 제외 | 확인(원천 제외) | GAP#132 F-02 |
| DD-051 | A5;A7 | 40 SSPM 탭(sspm) 보고용 컬럼 ATTRIBUTE1·ATTRIBUTE2·CUST_GROUP_DTL·APPLICATION·ROUTE 표시 | AS-IS: 표시 : Sold To Cust.(Report)(ATTRIBUTE1) · End Cust.(Report)(ATTRIBUTE2) · Cust Group Detail · Application · Channel(ROUTE), Application Gr. 등 REPORT_GR → TO-BE: 칸 설정 응답에 위 5칸 없음. REPORT_GROUP 칸은 있으나 조회 프로시저에서 주석 처리돼 빈 값. 저장 이력의 REPORT_GROUP 복사도 주석 처리(반영 내역 : 5칸 칸 설정은 2026-10-15 복원, REPORT_GROUP 조회는 주석 그대로) · 사유 처리 내역 : PI요청으로 해당 컬럼 사용하지 않기로 했다고 함.(이규철이사님 확인내용) — 제외 · 현재 40 EDI 원장 0행 → 영향 0 | 확인(원천 제외) | GAP#139 F-09 |
| DD-052 | B8 | Sales Site 조회 Team(TEAM_ID·TEAM_NAME) 연결 원천 — SCM_MST_SITE.DEPT_ID → SCM_MST_SIT | AS-IS: 사이트 원장 DEPT_ID 로 팀 연결 → TO-BE: 아이템 원장 부서 축(ATTRIBUTE4)으로 연결 → 사이트 원장 부서가 비어 Team 빈 값 · 사유 처리 내역 : Team(=DEPT_ID) 정보가 SCM_MST_SITE ---> SITE_MST_SITE_ITEM 으로 변경 됨 · 근거 2026-09-03 부서 축 전환 — 제외 | 확인(원천 제외) | GAP#140  |
| DD-053 | L1 | SSPM 탭(sspm) 조회 성능 — PKG_DMF0008.P_DMF0008_GET_SALES_SITE_PROJECT_MODEL(아이템 테이블  | AS-IS: 연결 조건 없는 아이템 테이블(789,140행) 곱 · 결과 미사용 임시 테이블 적재 → TO-BE: 두 부분 제거 · 사유 처리 내역 : 성능때문에 수정한 것으로 보여 제외 · 근거 2026-09-06 조치(결과 전건 일치) · 표본 12.61초 → 7.00초 | 확인(원천 제외) | GAP#144  |
| DD-054 | H2;I1 | 정비 목록 확인필요 셀(Sales Site·SSPM) 색 표시 + 마우스 오버 안내 MSG00445·MSG00446 | AS-IS: 색 표시만 → TO-BE: 색 표시 + 마우스 올리면 MSG00445 「Sales Site UI에서 Sales Site를 추가하시기 바랍니다.」 / MSG00446 「Sales Site Project Model UI에서 데이터를 추가하시기 바랍니다.」 안내 · 사유 처리 내역 : 추가된 기능이라 제외 · 근거 TO-BE 추가 | 확인(원천 제외) | GAP#146  |

### DMF0014 (19건)

| 결정 | 검사 규칙 | 대상 | AS-IS → TO-BE · 사유 | 확인 상태 | 출처 |
|---|---|---|---|---|---|
| DD-055 | M1 | Excel Upload 머리글 검사(Division* · Customs Handbook* · DOM/EXP* 필수 머리글 11개 · 「Inval | AS-IS: 첫 머리글 Division* 만 찾고 나머지는 열 순서대로 읽음 · 업로드 설정 8번째 머리글 DOM/EXP* → TO-BE: 머리글 이름으로 열을 찾고 '*' 필수 머리글 11개 모두 필요 · 8번째 Customs Handbook* — 기존 DOM/EXP* 파일 반려 · 앞 13칸이 설정과 다르면 「Invalid Excel Form」 · 사유 처리 상태 제외(처리 내역 없음) — 조치안 ①머리글 별칭 미채택 · 양식 교체 | 확인(원천 제외) | GAP#147 F-02 |
| DD-056 | M1 | Excel Upload DAILY · MONTHLY Measure 수량 적재(입력 불가 주차 0 적재 판정 · DM_MST_CUSTOMER_FC | AS-IS: 일자 · 월 칸 수량 그대로 적재 → TO-BE: 입력 불가 주차 0 적재 판정이 주 시작일(월요일)과 칸 일자 직접 비교 — DAILY 월요일 외 6일 · MONTHLY 1일≠월요일 달 0 적재(유지) · 사유 처리 상태 제외(처리 내역 없음) — I-07 의도적 변경의 부작용을 수정하지 않음 | 확인(원천 제외) | GAP#149 F-04 |
| DD-057 | M1 | Excel Upload 값 대소문자 검사(Division · Sales Site · Plant Site · Customer Project · C | AS-IS: 대소문자 무시(기존 DB 정렬 규칙) — 소문자 · 혼용 입력 통과 → TO-BE: Upload UOM 만 대문자 변환 · 그 밖 식별 칸은 대소문자 구분 → 오류(유지) · 사유 처리 상태 제외(처리 내역 없음) | 확인(원천 제외) | GAP#150 F-05 |
| DD-058 | M1 | Excel Upload 수식 칸 읽기(합계·참조 수식 → 수식 문자열 · 「Invalid Quantity」) | AS-IS: 엑셀 계산 결과 값을 읽음 → TO-BE: 수식 칸은 수식 문자열로 읽어 수량 칸 「Invalid Quantity」 · 식별 칸 기준정보 오류(유지) · 사유 처리 상태 제외(처리 내역 없음) · 해당 파일 비율 추정 | 확인(원천 제외) | GAP#151 F-06 |
| DD-059 | M1;F4 | Excel Upload Division 칸 사업부 이름 입력(10자 초과 → ORA-06502 중단) | AS-IS: Division 칸에 ID 또는 이름(Automotive Battery 등) 허용 → TO-BE: 첫 데이터 행 Division 이 10자를 넘는 이름이면 검증 중 예외(ORA-06502)로 중단(유지) · 사유 처리 상태 제외(처리 내역 없음) | 확인(원천 제외) | GAP#152 F-07 |
| DD-060 | M1;E3 | Excel Upload 빈 식별 칸(Plant Site · DOM_EXP · CUSTOMER_PROJECT_CODE · CUSTOMER_MODE | AS-IS: 40 · 82 의 빈 Plant Site 등은 빈 문자로 적재 → TO-BE: 빈칸이 빈 값(NULL)이 되어 원장 필수 칸 위반(ORA-01400)으로 적재 전체 실패 — 검증은 통과(유지) · 사유 처리 상태 제외(처리 내역 없음) · 현재 82 원장 0행 · 40 원장 38행 모두 Plant Site 값 있음 | 확인(원천 제외) | GAP#153 F-08 |
| DD-061 | F7 | 40 업로드 뒤 MKT FCST 반영 경로(범용 반영 프로시저 ↔ 40 전용 반영 프로시저) | AS-IS: 사업부 판정 값이 늘 비어 40 도 범용 반영 프로시저로 반영 → TO-BE: 40 은 40 전용 반영 프로시저로 반영(유지) · 사유 처리 상태 제외(처리 내역 없음) — 조치안 "40 반영 경로 확정 후 패키지 분기 정리" 미수행 | 확인(원천 제외) | GAP#154 F-09 |
| DD-062 | A2 | 그리드 FCST Type(FCST_TYPE) · Upload UOM(UPLOAD_UOM) 컬럼 표시값(코드 ↔ 이름 · SALES_TYPE_CO | AS-IS: 목록 이름 표시(MPS → Mass · AS → A/S(Chargeable) · PACK → Pack) → TO-BE: 코드 그대로 표시(MPS · PACK) — 유지 · 사유 처리 상태 제외(처리 내역 없음) · 화면 확인 jiwon.park 81 FCST Type MPS · Upload UOM PACK | 확인(원천 제외) | GAP#155 F-10 |
| DD-063 | E2;MS1 | 조회조건 Period(기간) 한도 검사 MSG00164 「조회 기간은 3년 이내로 입력해주세요.」(보정 없이 차단) | AS-IS: MSG00164 안내 후 종료일을 시작일 + 2년으로 보정 → TO-BE: MSG00164 「조회 기간은 3년 이내로 입력해주세요.」 후 차단(보정 없음) — 유지 · 사유 처리 상태 제외(처리 내역 없음) — 조치안 "차단 유지 여부 확인" → 차단 유지 | 확인(원천 제외) | GAP#157 F-12 |
| DD-064 | K4 | Insert · Delete 단추(INSERT · DELETE) 미노출(직접 추가 불가 화면) | AS-IS: Insert 누르면 MSG00380 「직접 추가 불가한 화면이므로, 엑셀 업로드를 이용해 주시기 바랍니다.」 안내 · Delete 는 신규 행만 대상(무동작) → TO-BE: 두 버튼 없음 · 사유 사용자 요구 2026-08-21(화면 소스 기록) · 처리 내역 "직접추가 기능이 없기에, 추가+삭제 버튼 비활성화" · 제외 | 확인(원천 제외) | GAP#160  |
| DD-065 | D1;K4 | 수정 모드 전환(Edit) 없음 — 편집 가능 행의 기간 칸(D_ 칸) 상시 편집 판정 | AS-IS: 조회 후 전체 잠금 · Edit 로 풀어야 수정 → TO-BE: 상시 수정 판정(편집 가능 행의 기간 칸) · Edit 없음 · 사유 TO-BE 화면 표준(MKT FCST 동일) · 화면 대응 기록 2026-07-04 · 처리 내역 "to-be edit 모드 없음" · 제외 | 확인(원천 제외) | GAP#161  |
| DD-066 | G4 | 조회조건 Plant Site(PLANT_SITE) — 40 비활성 · 81 계열 · 82 활성 | AS-IS: 모든 사업부 활성 → TO-BE: 40 비활성(81 계열 · 82 만 활성) · 사유 사용자 요구 2026-07-07(화면 소스 기록) · 제외 | 확인(원천 제외) | GAP#162  |
| DD-067 | D3;B8 | 편집 판정 담당 부서 기준 = 품목-사이트 원장 DEPT_ID(SCM_MST_SITE_ITEM) | AS-IS: 품목 담당자(OWNER 첫 사용자)의 SSO 부서 → TO-BE: 품목-사이트 원장 DEPT_ID · 사유 조회 패키지 2026-04-01 기록(부서 축 = 품목 원장 결정) · 제외 | 확인(원천 제외) | GAP#163  |
| DD-068 | M1;K4 | Excel Form 단추(EXCEL_FORM) — 조회 기간 기준 양식 내려받기(1행 머리글) | AS-IS: Excel Form 없음 → TO-BE: 조회 기간 기준 양식 내려받기(1행 머리글) · 사유 요청 E20260814-EXCELFORM · 제외(업로드 연결 결함은 F-01 별도) | 확인(원천 제외) | GAP#164  |
| DD-069 | M1;MS1 | 공용 업로드 창(Upload) 2단계 업로드 — 파일 선택 즉시 검증 · 오류 있으면 OK 비활성 · MSG00657 | AS-IS: OK 가 오류 있어도 활성 · 반영 프로시저는 오류 시 반영하지 않는데도 MSG00020 「저장 하였습니다.」 표시 → TO-BE: 파일 선택 즉시 검증 · 오류 있으면 OK 비활성(MSG00657) · 사유 사용자 요구 2026-07-10 — 결과(오류 시 반영 없음)는 양쪽 같음 · 제외 | 확인(원천 제외) | GAP#165  |
| DD-070 | M1 | Excel Upload 입력 불가 주차 0 적재(DM_MST_CUSTOMER_FCST 에서 열지 않은 주 · 오류 표시 없음) | AS-IS: 입력값 그대로 적재 → TO-BE: Customer Fcst 기준정보에서 열지 않은 주의 칸은 0 적재(오류 표시 없음) · 사유 사용자 지시 2026-08-23(업로드 패키지 기록) · 제외 | 확인(원천 제외) | GAP#166  |
| DD-071 | M1;E4 | Excel Upload Customs Handbook* 값 검사(DOM_EXP · D · E 만 허용 · 「Invalid Customs Hand | AS-IS: 검사 차단되어 있음(아무 값 적재) → TO-BE: D · E 만 허용 · 그 밖 「Invalid Customs Handbook - 등록되지 않은 Customs Handbook 입니다(D/E). [Customs Handbook*] 확인」 · 사유 요청 E20260915-DMF0014MSTCHK · 제외 | 확인(원천 제외) | GAP#167  |
| DD-072 | M1;E4 | Excel Upload Model 품목 마스터 검사(CUSTOMER_MODEL · Item · 「Invalid Model」) | AS-IS: Model 품목 마스터 검사 없음 → TO-BE: 품목 마스터에 없는 Model 반려(「Invalid Model - 품목 마스터(Item)에 없는 Model 입니다. [Model] 확인」) · 사유 요청 E20260915-DMF0014MSTCHK · 제외 | 확인(원천 제외) | GAP#168  |
| DD-073 | M1 | Excel Upload 오류 사유 표시 — 행의 모든 오류 사유를 ' / ' 로 이어 표시 | AS-IS: 행마다 첫 오류 1개 → TO-BE: 모든 오류 사유를 ' / ' 로 이어 표시 · 사유 요청 E20260911-DMF0014MULTI · 제외 | 확인(원천 제외) | GAP#169  |

### DMF0020 (10건)

| 결정 | 검사 규칙 | 대상 | AS-IS → TO-BE · 사유 | 확인 상태 | 출처 |
|---|---|---|---|---|---|
| DD-074 | M3 | Version 팝업(DMF0073) Monthly Rolling Forecast 칸 편집·Save(DMF0073_SAVE_VERSION_SALE | AS-IS: Version 팝업에서 이번 주 버전(EDITABLE=Y)의 Monthly Rolling Forecast 값 편집·저장(DMF0073_SAVE_VERSION_SALESPRICE) → TO-BE: Version 팝업 조회·선택 전용 — 편집·Save 없음, 저장 프로시저·서버 호출 미등록 · 사유 처리 내역 : 422번 Metal Link Price(DMF0074) 동일 이슈 · Sales Price 에서 수정할 일 없음 → 제외, 추후 공통화 작업 시 처리 | 확인(원천 제외) | GAP#172 F-04 |
| DD-075 | M1;K4 | Excel Upload 검사(PKG_DMF0020 업로드 프로시저 빈 값 비교 — 필수값·모델·숫자·마이너스·0·통화 중복) · Upload 버 | AS-IS: AS-IS 업로드 프로시저(74862~74866·75176·75218~75230행) 빈 문자열 비교로 필수값·모델·숫자·마이너스·0·통화 중복 검사 성립 → TO-BE: 업로드 기능 화면에 없음(81 → DMF0082 이전) · 패키지 빈 값 비교는 2026-09-28 수정 처리 완료 확인 · 사유 처리 내역 「프로시저에 2026-09-28 수정 처리 완료 됨 확인」 · 근거 「81 판가 입력은 DMF0082 로 이전(184·190번), 82 는 AS-IS 에도 업로드 없음」 | 확인(원천 제외) | GAP#180 F-12 |
| DD-076 | C3;D1 | 신규 행 Team(DEPT_ID)·End Customer(END_CUSTOMER) — Sales Site(SCM_SITE_ID) 선택 시 End | AS-IS: Team·End Customer 선택 목록 선택 → Sales Site 목록이 좁혀짐 → TO-BE: Sales Site 선택 시 End Customer 자동, Team 은 Model 팝업 반환값 · 둘 다 직접 입력 불가(FcstPrice MGMT 와 같은 방식) · 사유 근거 「저장 전달값 17개에 Team·End Customer 없음 — 저장 결과 같음」 · 처리 내역 「동일한 결과가 나오니까 문제 없는 부분 → 제외」 | 확인(원천 제외) | GAP#183  |
| DD-077 | K4;M1 | 81 계열 Upload·Excel Form 버튼(DMF0020_EXCEL_UPLOAD · DMF0020_GET_SALES_PRICE_TEMPLA | AS-IS: 81 계열에서만 Upload·Excel Form 버튼 표시(DMF0020_EXCEL_UPLOAD · DMF0020_GET_SALES_PRICE_TEMPLATE) → TO-BE: 버튼 없음 · 업로드 프로시저는 PKG_DMF0020 에 변환만 되고 서버 호출 미등록 · 사유 근거 「81 전용 기능 — 81 판가 입력 이전과 같은 사유」 · 처리 내역 「입력은 DIVISION 82만 가능」 | 확인(원천 제외) | GAP#184  |
| DD-078 | K4;D1 | Edit 버튼 없음 — 편집 모드 없이 LOC 셀(LOC) 바로 입력(TO-BE 공통 그리드) | AS-IS: Edit 버튼으로 편집 모드 진입 후 입력 → TO-BE: 편집 모드 없이 LOC 셀 바로 입력 · 사유 근거 「TO-BE 공통 그리드 방식」 · 처리 내역 「TO-BE에는 EDIT버튼 없음」 | 확인(원천 제외) | GAP#185  |
| DD-079 | E4 | 저장 검사 — ACTIVE_FLAG D 외 행이 영업 사이트(SCM_MST_SITE VALID_YN='Y')·사업부별 품목에 없으면 저장 차단( | AS-IS: 없음(사이트 유효·사업부별 Item 검사 없음) → TO-BE: D 외 행이 영업 사이트(VALID_YN=Y)·사업부별 품목에 없으면 저장 차단 · 사유 근거 「저장 프로시저 개정 주석(V20260708)」 · 처리 내역 「2026년7월8일에 의도적으로 삽입된 validation」 | 확인(원천 제외) | GAP#187  |
| DD-080 | B8 | 조회 결과 Team 컬럼(DEPT_ID) 원천 = 사이트·품목 원장(SCM_MST_SITE_ITEM) 부서 | AS-IS: Owner 첫 사용자의 부서 → TO-BE: 사이트·품목 원장(SCM_MST_SITE_ITEM)의 부서 · 사유 근거 「부서 축을 아이템 원장으로 통일(2026-09-03 조치)」 · 처리 내역 「SCM_MST_SITE 기준이 아니면 문제없음」 | 확인(원천 제외) | GAP#188  |
| DD-081 | K4 | Price Batch Input 버튼(priceBatch) 노출 = 편집 가능 사업부(82)만 | AS-IS: 사업부 무관 표시(40 은 저장 프로시저가 차단) → TO-BE: 편집 가능 사업부(82)에서만 표시 · 사유 근거 「편집 가능 사업부 규칙과 같게 맞춘 것」 · 처리 내역 「PI요청으로 편집 가능한 사업부만 배치버튼 표시하도록 기능 수정」 | 확인(원천 제외) | GAP#189  |
| DD-082 | K4;D3 | 81·81 하위 사업부 편집·Insert·Save·Price Batch Input 없음(DM_UI_EDITABLE_DIVISION DMF0020 | AS-IS: 81 계열 편집 가능(40 만 차단) → TO-BE: 82 만 편집 · 81·81 하위 편집·Insert·Save·Price Batch Input 없음 · 사유 근거 「81 판가 입력을 FcstPrice MGMT(DMF0082)로 이전(2026-08-20 확정) · DM_UI_EDITABLE_DIVISION DMF0020·81=N」 | 확인(원천 제외) | GAP#190  |
| DD-208 | D5 | Project Code(PROJECT_CODE)·Model(ITEM_ID) 입력 셀/조건 FPTextModal 에디터 | AS-IS: Project Code·Model 입력 셀은 텍스트 입력+팝업 선택(FPTextModal 요청 대상) → TO-BE: DMF0020 Project Code·Model 입력 현 구현 유지(변경 없음) · 사유 처리 상태 제외 · 처리 내역 "뭐가안되는거지 / 확인완료" — 현 동작에 문제 없음 확인 후 요청 제외 | 확인(원천 제외) | GAPPI#26  |

### DMF0021 (12건)

| 결정 | 검사 규칙 | 대상 | AS-IS → TO-BE · 사유 | 확인 상태 | 출처 |
|---|---|---|---|---|---|
| DD-083 | E3 | 신규 행 Project(PROJECT_CODE) 필수 검사 · MSG00429 | AS-IS: Project 가 비면 'N' 으로 채워 저장. 필수 검사 대상 아님 → TO-BE: 40 외 사업부 신규 행 Project 필수 검사 → MSG00429 로 저장 차단(Project 칸은 팝업 선택만 가능) · 사유 처리 내역 : Label명에 '*' 붙은 경우 필수 컬럼으로 처리하기로 함(처리 상태 제외) | 확인(원천 제외) | GAP#192 F-04 |
| DD-084 | A7;N1 | 그리드 Text 컬럼(TEXT · ATTRIBUTE9 · REMARK_TEXT) 빈 값 표시 '-' | AS-IS: 빈 Text 는 ISNULL(ATTRIBUTE9,'') 로 실은 뒤 길이 0이면 공백 한 칸 → 빈 칸 → TO-BE: 계획·실적 Text 를 NVL(TRIM(ATTRIBUTE9),'-') 로 실어 '-' 표시(표시식은 NULL 만 공백) — 유지 · 사유 처리 내역 : NOT NULL 컬럼의 경우 Default 값이 '-' 로 설정되어 있어 로직상에서도 동일하게 처리하는 것이 문제 없음(제외) | 확인(원천 제외) | GAP#200 F-14 |
| DD-085 | H10;MS1 | 저장 완료 안내 메시지(Save → MSG00002 / AS-IS MSG00004 · MSG00672 건수 자리) | AS-IS: MSG00004 「{0}개의 데이터가 저장되었습니다.」 — {0} = 저장한 행 수, 확인 창 → TO-BE: MSG00002 「성공적으로 저장되었습니다.」 — 건수 없음, 잠시 뜨고 사라지는 알림(유지) · 사유 처리 내역 : 공통 메시지라 문제 없음(제외) | 확인(원천 제외) | GAP#201 F-16 |
| DD-086 | E4;MS1 | 값 없는 신규 행 저장 검증 메시지(Save → MSG00670 / AS-IS MSG00146 · MSG01164 행 번호 자리) | AS-IS: MSG00146 「라인 [{0}] 날짜(Daily)가 값이 없습니다.」 — {0} = 그리드 행 번호 → TO-BE: MSG00670 「추가된 행에 입력된 수량 또는 가격이 없습니다. 각 행 별로 하루 이상의 일자에 수량 또는 가격이 입력되어야 합니다.」 — 행 번호 자리 없음(유지) · 사유 처리 내역 : TO-BE 기준에 맞는 메시지로 수정된거라 문제 없음(제외) | 확인(원천 제외) | GAP#202 F-17 |
| DD-087 | H10 | 저장 중 DB 오류 안내(Save → 서버 공통 처리 -9994 'Sql Error' · RAISE_APPLICATION_ERROR -20001 | AS-IS: 오류 시 전체 되돌림 후 '[오류 번호]오류 문구' 한 칸을 결과로 반환, 화면이 그 문구를 그대로 표시 → TO-BE: 오류 시 되돌림 후 사용자 정의 오류(-20001)로 올리고 서버 공통 처리가 -9994 · 'Sql Error' 로 일괄 변환(유지) · 사유 처리 내역 : 공통메시지라 보안적으로는 오류내용을 알려주면 안되는 것(제외 · 업무 확인 후 결정) | 확인(원천 제외) | GAP#208 F-25 |
| DD-088 | D4;D5 | 신규 행 FCST Type(FCST_TYPE) 셀 — 선택 목록 0개 · 기본값 ETC 고정 | AS-IS: 이전 화면 신규 행 FCST Type 선택(81 Text 필수는 ETC 행만) → TO-BE: 선택 목록 0개, 기본값 ETC 고정(유지) · 사유 처리 내역 : 신규행은 FCST Type 이 'ETC' 만 입력 맞음(제외) | 확인(원천 제외) | GAP#213 F-30 |
| DD-089 | A3 | 그리드 하단 합계(Sum · Footer Summary) 행 | AS-IS: 그리드 바닥 한 줄에 숨긴 행을 뺀 기간 칸 합계 → TO-BE: 합계 행 없음 · 사유 처리 내역 : 여러개의 measure 가 보이는 화면이라 합계가 의미가 없어 빼기로 함(2026-08-12 사용자 지시 · 제외) | 확인(원천 제외) | GAP#214  |
| DD-090 | G4;H2 | 조회조건 Color 체크박스 제거 · 당월/당주 머리글 강조(header 녹색 굵게 · 당주 왼쪽 세로선) | AS-IS: 체크 시 지난 구간 회색·당월 흰색, 해제 시 당주 녹색 테두리 → TO-BE: 체크 없음. 당월·당주 머리글 녹색 굵게 + 당주 왼쪽 세로선 · 사유 처리 내역 : PI요청으로 Color 체크박스 빼고 항상 초록색선 표시는 되도록 수정완료(제외) | 확인(원천 제외) | GAP#215  |
| DD-091 | K4;D1 | Edit 버튼(EDIT) 없음 — 상시 편집 + 칸별 잠금 규칙(버튼 등록 9개에 EDIT 없음) | AS-IS: Edit 버튼으로 편집 모드 진입 후 편집 → TO-BE: 상시 편집 + 칸별 잠금 규칙(버튼 등록에 EDIT 없음) · 사유 처리 내역 : tobe 는 edit 모드 없음. 상시편집으로 변경(제외) | 확인(원천 제외) | GAP#216  |
| DD-092 | E3 | 81 신규 행 Text(TEXT) 필수 검사 — FCST Type = ETC 행만 | AS-IS: 81 계열 신규 행 Text 항상 필수 → TO-BE: FCST Type = ETC 행만 필수(신규 행은 ETC 만 추가되므로 결과 동일) · 사유 처리 내역 : 행추가시 FCST Type = 'ETC' 기준으로만 추가되고 현재 81 선택 시에 Text 항목 필수체크를 하고 있음(제외) | 확인(원천 제외) | GAP#218  |
| DD-093 | B8 | 그리드 Team(부서 · DEPT_ID · TEAM_NAME) 원천 = SCM_MST_SITE_ITEM.DEPT_ID | AS-IS: 사이트 품목 담당자 → 사용자 부서 → TO-BE: 사이트 품목 원장 DEPT_ID(팀명은 부서 정보 테이블에서 사용자 언어로 표시, 2026-09-21 추가) · 사유 처리 내역 : 부서는 SSPM 기준으로 맞춤(제외) | 확인(원천 제외) | GAP#219  |
| DD-094 | N1 | 저장 키 빈 값 정규화(Plant Site PLANT_SITE_ID · Text TEXT 빈 값 → NOT NULL 컬럼 디폴트 대체값 · TR | AS-IS: 빈 값 그대로 비교 → TO-BE: Plant Site · Text 등 빈 값을 NOT NULL 디폴트 대체값('-' → '/')으로 맞춰 비교, Text 앞뒤 공백 제거 · 사유 처리 내역 : MSSQL 은 빈값이 저장되지만 오라클은 빈값은 없고 NULL 로 관리하기 때문에 로직에서 NOT NULL 컬럼에 한해 디폴트값('-')으로 변환하여 처리(제외) | 확인(원천 제외) | GAP#221  |

### DMF0035 (11건)

| 결정 | 검사 규칙 | 대상 | AS-IS → TO-BE · 사유 | 확인 상태 | 출처 |
|---|---|---|---|---|---|
| DD-095 | A5;K2 | Column Setting 팝업 후보 컬럼 — APPLICATION·CUST_GROUP_DTL·DMS_CUSTOMER·REPORT_GROUP6· | AS-IS: 칸 설정 팝업 후보(표시 여부 Y · 사업부 포함 칸). MKT 40 : Application · Cust Group Dtl · DMS Customer · Report Group6 · Route / MKT 81 계열 : Project Owner · Project Sta → TO-BE: 위 칸이 칸 설정 테이블(SCM_MST_SHEET_COLUMNS, DMF0035)에서 사업부 빈 값 · 표시 여부 N 으로 바뀌어 후보에 없음. 2026-09-16~17 minyonglee1 · admin 변경, 사유 기록 없음 · 사유 처리 상태 제외(담당 이규철 · 구분 업무 확인) — 처리 내역 없음(숨김이 업무 결정인지 확인 요청 상태) | 확인(원천 제외) | GAP#224 F-02 |
| DD-096 | K2 | 사용자별 칸·Measure 설정(SCM_MST_TITLESET_USER PROGRAM_ID DMF0035 · Mkt Fcst Waterfall/ | AS-IS: 사용자별 설정 보유 : MKT(DMF0035) 1,169명 · SALES(DMF0022) 627명 · BIZ(DMF0051) 136명. 최근 1년 변경 사용자 205명 · 109명 · 20명 → TO-BE: DMF0035 기준(세 유형 모두 PROGRAM_ID DMF0035) 8명 223행뿐. 나머지 사용자는 처음 진입 시 기본 칸 · 기본 Measure 로 표시되고 설정을 다시 만들어야 함 · 사유 처리 상태 제외(담당 이규철) — 처리 내역 없음 · 다른 DM 화면과 같은 공통 결함(사용자별 화면 설정 미이관)으로 기록됨 | 확인(원천 제외) | GAP#225 F-03 |
| DD-097 | B5 | Measure 설정 목록 SCM FCST[R+P](SCM_FCST) 사업부 허용(SCM_MST_SHEET_MEASURE DMF0035 DIVIS | AS-IS: 40 전용 Measure(칸 설정 Measure 사업부 40, AS-IS 원문 주석 「SCM_FCST은 40 사업부만 사용」) → TO-BE: 81 계열 Measure 목록에도 표시(Measure 설정 테이블 사업부 2026-09-09 minyonglee1 변경). 81 원장에는 SCM_FCST 없음 · 사유 처리 상태 제외(담당 이규철 · 구분 업무 확인) — 처리 내역 없음(81 계열 사용 계획 확인 요청 상태) | 확인(원천 제외) | GAP#227 F-06 |
| DD-098 | B5 | Measure 설정 목록 SFA(%)(SFA) 사용 여부(SCM_MST_SHEET_MEASURE DMF0035 VALID_YN·DIVISION_ | AS-IS: 사용 안 함(Measure 설정 유효 N) → TO-BE: 81 계열 · 82 Measure 목록에 표시(2026-09-16 minyonglee1 유효 Y · 사업부 82 · 81 계열 변경) · 사유 처리 상태 제외(담당 이규철 · 구분 업무 확인) — 처리 내역 없음(사용 여부 확인 요청 상태) | 확인(원천 제외) | GAP#228 F-07 |
| DD-099 | B5 | MKT FCST Measure 후보 사업부 필터 — Measure 자기 행 DIVISION_ID 로 판정(40 조회에 81 전용 LOC·TMM  | AS-IS: 임의 한 행의 사업부 목록으로 판정해 모든 사업부 Measure 가 조회됨(예 : 40 조회에 81 전용 LOC · TMM 포함) → TO-BE: Measure 자기 행의 사업부로 판정 · 사유 근거 : 프로시저 기록 [E20260916-MEASDIV35] 사용자 지시 2026-09-16 — 제외 | 확인(원천 제외) | GAP#229  |
| DD-100 | B5 | BIZ PLAN Measure KRW·USD(사업부 빈 값 단가 행) 표시 제외(SCM_MST_SHEET_MEASURE VALID_YN N) | AS-IS: 사업부 빈 값인 KRW · USD 가 기본 Measure 로 자동 설정되어 표시(설정 보유 113명 · 112명) → TO-BE: Measure 설정 KRW · USD 유효 N(2026-09-10 minyonglee1), 표시 안 함 · 사유 근거 : 프로시저 기록 「DIVISION_ID 가 빈 값인 Measure 는 제외 — 2026-09-10 사용자 결정」 — 제외 | 확인(원천 제외) | GAP#230  |
| DD-101 | K2 | 칸·Measure 설정 기준 화면 ID — SCM_MST_TITLESET_USER PROGRAM_ID DMF0035 + 시트명(Mkt Fcst  | AS-IS: 화면별 PROGRAM_ID(DMF0035 · DMF0022 · DMF0051) → TO-BE: 세 유형 모두 PROGRAM_ID DMF0035 + AS-IS 시트명 · 사유 근거 : 프로시저 기록 [E20260909-TYPEAXIS] 사용자 지시 2026-09-09 — 제외 | 확인(원천 제외) | GAP#231  |
| DD-102 | B4;B6 | 조회조건 Bucket 콤보 후보 — Daily·Weekly·Monthly(ONLY_WEEKLY 제외) | AS-IS: DAILY · WEEKLY · MONTHLY · ONLY_WEEKLY → TO-BE: Daily · Weekly · Monthly(ONLY_WEEKLY 제외) · 사유 근거 : 화면 기록 [E20260831-NOONLYWEEKLY] 사용자 지시 2026-08-31 — 제외 | 확인(원천 제외) | GAP#232  |
| DD-103 | G4;H2 | 조회조건 Color 체크박스 없음 · 당월·당주 헤더 녹색 항상 · 실적 구간 회색 없음(Bucket·Period 헤더) | AS-IS: Color 체크 시 버전별 실적 구간 회색, 해제 시 당월 · 당주 헤더 녹색 → TO-BE: Color 체크 없음, 당월 · 당주 헤더 녹색 항상 표시, 실적 구간 회색 없음 · 사유 근거 : Color 체크 제거 사용자 지시 2026-08-06 · 실적 구간 회색 미구현 사용자 결정 2026-09-04 — 제외 | 확인(원천 제외) | GAP#233  |
| DD-104 | G6;E3;MS1 | 조회조건 Version(VERSION_NO) 기본값 CURRENT · 세 Plan Type 필수(미선택 시 MSG00283) | AS-IS: 기본 공란, 팝업 선택 필수(MSG00002 「{0} 값은 필수 입력입니다」) → TO-BE: 기본 CURRENT, 세 유형 필수(MSG00283 「버전을 선택하세요.」) · 사유 근거 : 화면 기록 [E20260831-VERREQ] — 제외 | 확인(원천 제외) | GAP#234  |
| DD-105 | J4;G4 | 메뉴 DMF0035 한 화면 통합 · 조회조건 Plan Type(PLAN_TYPE) MKT FCST/SALES PLAN/BIZ PLAN 전환 · | AS-IS: MKT FCST Waterfall(DMF0035) · Sales Plan Waterfall(DMF0022) · Biz Plan Waterfall(DMF0051) 메뉴 3개 → TO-BE: Demand Plan Waterfall(DMF0035) 한 화면, 조회조건 Plan Type 으로 MKT FCST / SALES PLAN / BIZ PLAN 전환. DMF0051 메뉴 사용 안 함, DMF0022 메뉴 별도 유지 · 사유 근거 : 화면 개발 기록 [E20260806-WF] · 메뉴 DMF0035 2026-08-28 변경 — 제외 | 확인(원천 제외) | GAP#235  |

### DMF0040 (7건)

| 결정 | 검사 규칙 | 대상 | AS-IS → TO-BE · 사유 | 확인 상태 | 출처 |
|---|---|---|---|---|---|
| DD-106 | K2;A5 | 사용자별 칸 설정(SCM_MST_TITLESET_USER DMF0040 · Mkt Fcst Waterfall · 유형 C/M) 이관 · 기본 칸 | AS-IS: 사용자별 칸 설정 테이블(SCM_MST_TITLESET_USER, 화면 DMF0040 · 시트 Mkt Fcst Waterfall)에 사용자가 고른 칸으로 조회 · 정렬 · 행 묶음. Version · Measure 칸은 숨김 칸으로 항상 자동 포함 → TO-BE: 103행 · 9명뿐(2026-08-27 이후 TO-BE 에서 새로 생긴 행, 이관분 없음). 설정이 없는 사용자는 첫 조회 때 기본 칸(40 : Div · End Customer · Sales Site · Model · Nick Name · Version · SCP U · 사유 처리 내역 : 개인화 정보는 이관할 필요가 없음 — 제외 | 확인(원천 제외) | GAP#236 G-01 |
| DD-107 | A5;K2 | Version 컬럼(VERSION_NO) 표시 기준 — 사용자 설정 행 보유 계정만 표시 · Column Setting 목록에 Version·M | AS-IS: Version 칸 항상 표시(칸 표시는 사용 여부 VALID_YN 으로만 판정) → TO-BE: 사용자 설정 행에 VERSION_NO 가 있는 계정만 표시. Column Setting 창 목록(Invisible · Visible)에 Version · Measure 가 없어 사용자가 켜고 끌 수 없음 · 사유 처리 내역 : ui category setup에서 유저가 설정해서 보이게 할 수 있음. 결함이 아님 — 제외 | 확인(원천 제외) | GAP#239 G-04 |
| DD-108 | G4 | 조회조건 Plant Site(PLANT_SITE) 활성 여부 — Division 82(ESS) 선택 시 비활성(40 과 같음) | AS-IS: 선택 가능(40 만 비활성) → TO-BE: 82 도 비활성 · 사유 처리 내역 : 2026-09-09 사용자 지정 요건 · PI P59(의도 변경 · 상태 완료 · 4.최종확인 「ESS 사업부 선택 시 Plant Site 조회조건 비활성화」)로 확정된 TO-BE — 제외 | 확인(원천 제외) | GAP#240  |
| DD-109 | G6 | 조회조건 Version(VERSION_NO) 기본값 — 사업부 선택 시 최근 MF_W 버전 자동 입력 없음(팝업 직접 선택) | AS-IS: 사업부 선택 시 최근 MF_W 버전 2개 자동 입력(Current 제외) → TO-BE: 자동 입력 없음, Version 팝업에서 직접 선택 · 사유 처리 내역 : DM 현업이 Version 직접 선택 방식 유지 확인 후 기록 · 근거 2026-09-09 사용자 지정 — 제외 | 확인(원천 제외) | GAP#241  |
| DD-110 | B8 | 조회조건·표시 Team 기준(DEPT_ID) — 모델 원장 SCM_MST_SITE_ITEM 부서 | AS-IS: 모델 담당자(첫 번째)의 부서 → TO-BE: 모델 원장(SCM_MST_SITE_ITEM)의 부서(DEPT_ID) · 사유 처리 내역 : TO-BE는 SSPM기준 맞음 · 근거 2026-09-06 부서 기준 = 모델 원장 결정 — 제외 | 확인(원천 제외) | GAP#242  |
| DD-111 | A9 | Measure 컬럼(MEASURE) 표시값 — 실제 선택 버전 번호(예 MF_W_20260824_V001)·Difference(Version(A | AS-IS: Version(A) · Version(B) · Difference → TO-BE: 실제 선택 버전 번호(예 MF_W_20260824_V001) · Difference. 최신 버전 먼저 정렬은 같음 · 사유 처리 내역 : DM 현업이 Measure 칸 버전 번호 표시 유지 확인 · 기록(엑셀 내려받기 값도 버전 번호) · 근거 사용자 지시 2026-09-09 — 제외 | 확인(원천 제외) | GAP#243  |
| DD-112 | I3 | Team 이름(TEAM_NAME·DEPT_NAME) 표시 언어 — 사용자 언어(KO/EN/CN) 부서명 | AS-IS: 한글 부서명 → TO-BE: 사용자 언어(EN · CN)에 따라 부서명 언어 전환 · 사유 처리 내역 : DM 현업이 언어별 Team 이름 표시(EN 사용자 정렬 순서 차이 포함) 유지 확인 · 기록 · 근거 2026-09-09 변경 기록 — 제외 | 확인(원천 제외) | GAP#244  |

### DMF0042 (9건)

| 결정 | 검사 규칙 | 대상 | AS-IS → TO-BE · 사유 | 확인 상태 | 출처 |
|---|---|---|---|---|---|
| DD-113 | M2;M3 | Replace 「Replace by Cutoff」 창 버전 목록(cutoffVersion · P_DMF0042_GET_DM_PLN_BP_CUTO | AS-IS: 조회 기간(월)에 컷오프 자료가 있는 버전만 목록 표시(40 2026-09~2027-03 : 5개) → TO-BE: 컷오프 일자가 기간 안인 버전을 목록 표시 → 기본 기간 0건, 기간을 과거 컷오프 일자로 바꾸면 표시(자료 없는 버전도 표시) · 사유 처리 내역 : 안나오는게 아니라 기간을 바꾸면 나오긴하는데 이 부분은 조회 날짜만 수정하면 되긴 해서(제외) | 확인(원천 제외) | GAP#248 F-04 |
| DD-114 | D2 | 40 중장기 편집 구간 — LOOKUP DM_LONG_PLAN(SEGMENT1 40 · SEGMENT2 'Biz Plan') ATTRIBUTE2 | AS-IS: 2027-01 ~ 2031-12 월 칸 입력, 2027~2031 연·분기 칸 입력 가능 → TO-BE: 2027-01 ~ 2027-07 월 칸만 입력, 연 칸(2027) 입력 불가 — 기준 코드 DM_LONG_PLAN 값(202707)대로 · 사유 처리 내역 : 사용자가 설정하는 구간, admin 의 lookup 화면에서 바꿀 수 있음. 현재 27년 7월까지로 되어있을 뿐(제외) | 확인(원천 제외) | GAP#249 F-05 |
| DD-115 | G6 | 확장 조회조건 Qty≠0 체크 칸 기본값(해제) — 수량 0 조합 포함 조회 | AS-IS: 조건 칸 없음(화면 소스 칸 숨김·초기값 N). 2026-08-27 기준 AS-IS 산출물은 수량 0 조합 제외 → TO-BE: Qty≠0 체크 칸이 보이고 기본 해제 → 수량 0 조합까지 표시(유지) · 사유 처리 내역 : 이건 에러는 아니고 편의성 영역.. 심지어 이미 체크도 있어서 굳이?(제외) | 확인(원천 제외) | GAP#251 F-07 |
| DD-116 | B8;A7 | 그리드 Team 컬럼(DEPT_ID · TEAM_NAME) 원천 = SCM_MST_SITE_ITEM.DEPT_ID — 팀 빈 사이트 품목은 Te | AS-IS: Team = 사이트 품목 담당자의 소속 부서 → 빈 칸 없음 → TO-BE: Team = 사이트 품목 팀 칸(SCM_MST_SITE_ITEM.DEPT_ID). 팀 칸이 빈 사이트 품목은 Team 빈칸 · 사유 처리 내역 : SCM_MST_SITE 해당 테이블의 DEPT_ID 때문인데 이 값은 일부러 DROP 한게 맞음(제외) | 확인(원천 제외) | GAP#252 F-08 |
| DD-117 | A5;K2 | 사용자별 칸 설정(SCM_MST_TITLESET_USER PROGRAM_ID DMF0042 · 'C') 이관 — Column Setting 표시 | AS-IS: 158명 · 2,221행(칸 표시·순서·폭) → TO-BE: 10명 · 166행(이관 후 새로 만든 것) — 데이터 이관으로 해결 · 사유 처리 내역 : 로직이나 이슈가 아니라 단순히 데이터 이관이 안된 테이블. 데이터 이관하면 해결됨(제외) | 확인(원천 제외) | GAP#254 F-10 |
| DD-118 | K4;D1 | Edit 버튼 없음 — 조회 직후 상시 편집 · 미저장 변경 시 Exchange Rate · Ver. Cutoff · Replace 차단 | AS-IS: Edit 를 눌러야 셀이 열림. 편집 모드 중에는 Exchange Rate · Ver. Cutoff · Replace 차단 → TO-BE: 편집 버튼 없음, 조회 즉시 편집 가능(미저장 변경이 있을 때 위 버튼 차단) · 사유 처리 내역 : 이건 일부러 아닌가? 이게 왜 여기..(제외 — 의도된 상시 편집) | 확인(원천 제외) | GAP#258 F-14 |
| DD-119 | M2 | Replace 2024-12 이전 구간 — 컷오프 자료 DM_PLN_BP_FCST_C.INCOTERMS NULL 행(ORA-01400 추정) · | AS-IS: 2024-12 이전 구간 Replace 가능 → TO-BE: 컷오프 자료 Incoterms NULL 행 → Replace 입력 시 NVL(…,'/') 로 보정(로직 개선, 데이터 보정 없음) · 사유 처리 내역 : DM_PLN_BP_FCST_C 테이블에서 INCOTERMS 컬럼은 NOT NULL 컬럼이 아니기 때문에 NULL 값이 들어 올 수 있다. Replace 시 로직을 개선하면 될 것 같다(제외) | 확인(원천 제외) | GAP#261 F-17 |
| DD-120 | C3;D1 | 40 신규 행 입력 순서 — Sales Site(SCM_SITE_ID) → Model(ITEM_ID) 팝업 선택 시 Team · End Cust | AS-IS: End Customer → Sales Site → Model 순 선택, Team·End Customer 직접 선택 → TO-BE: Sales Site → Model 팝업 선택 시 Team · End Customer 자동 채움, 두 칸 직접 입력 불가 · 사유 근거 : 2026-09-02 고객 회신 · 처리 내역 : 2026-09-03 자동매핑 추가 작업 주석 확인(제외) | 확인(원천 제외) | GAP#264  |
| DD-214 | H10;C4 | 신규 행 있을 때 Bucket 변경 차단(MSG00227) | AS-IS: DMF0042_BizPlan.cs:3026 cboBucketType_Click → MSG00227 후 중단 → TO-BE: 차단 없음(11-04 05:47 실측) · 사유 사용자 결정: AS-IS 기준 적용 — TO-BE 미차단은 오류 | N | GAP#265  |

### DMF0043 (9건)

| 결정 | 검사 규칙 | 대상 | AS-IS → TO-BE · 사유 | 확인 상태 | 출처 |
|---|---|---|---|---|---|
| DD-121 | E4 | 기여율 월 칸(법인 RBU_0001~RBU_0008) 빈 칸 저장 전송 방식 · 저장 전 합계 100 · 빈 칸 검증 | AS-IS: 값이 있는 칸만 전송(빈 칸은 행 미생성). 편집으로 지운 칸은 0 으로 자동 채움 → TO-BE: 값이 하나라도 있는 달은 그 달의 빈 칸 8개 법인 전부 0 으로 채워 전송 → 0 비율 행 생성. 화면 검증상 합계 100 미달·빈칸 있으면 저장 차단이라 빈 칸 전송 불가 · 사유 처리 상태 제외 — 처리 내역 「현재 해당화면에서 100을 맞추지 않거나 빈칸이 있으면 저장할 수 없도록 검증이 걸려있어 빈칸으로 보낼 수가 없음」 | 확인(원천 제외) | GAP#279 GAP-05 |
| DD-122 | A1 | 조회 결과 행 수(2026 · 버전 15 : AS-IS 1,521 ↔ TO-BE 1,525 · 키 DEPARTMENT_ID · DEPT_ID · | AS-IS: 2026 · 버전 15 조회 1,521행 → TO-BE: 1,525행 — 4행 추가(부문·팀 코드만 있고 고객군·판매처·제품군·형태가 빈 키 3행, 형태만 빈 키 1행, 모두 편집 불가). 나머지 1,521행은 키·값·편집 여부 전부 일치 — TO-BE 테스트 데이터 차이로 유지 · 사유 처리 상태 제외 — 처리 내역 「결함이 아니라 TOBE테스트 데이터로 인한 조회 데이터 차이」 | 확인(원천 제외) | GAP#281 GAP-07 |
| DD-123 | E4 | 구분(RBU_0999) 칸 숫자 포함 입력 차단 + 안내 MSG_DIVISION_TEXT_ONLY | AS-IS: 제한 없음 → TO-BE: 구분(RBU_0999) 칸 숫자 포함 입력 폐기 · 안내 MSG_DIVISION_TEXT_ONLY · 사유 처리 상태 제외 — 처리 내역 「PI 요청으로 추가」 · 근거 화면 코드 기록 2026-08-10 · 08-11(사용자 요구) | 확인(원천 제외) | GAP#283  |
| DD-124 | D1;K4 | 툴바 Edit(F2) 버튼 없음 · 편집 가능 여부(EDITABLE 'Y') 행 상시 편집 | AS-IS: Edit 버튼으로 잠금 해제 후 편집 → TO-BE: 행 단위 상시 편집(편집 가능 여부 'Y' 행) — Edit(F2) 잠금 전환 없음 · 사유 처리 상태 제외 — 처리 내역 「TO-BE에서는 EDIT버튼 없음」 · 근거 화면 코드 기록 2026-08-11(사용자 요구) | 확인(원천 제외) | GAP#284  |
| DD-125 | H10 | 기여율 Save 저장 확인창 없음 · 결과 성공 토스트(MSG00002) + 재조회(실패 시에도 재조회) — AS-IS MSG00004 「{0} | AS-IS: MSG00004({0}개의 데이터가 저장되었습니다.) 후 재조회 → TO-BE: 저장 확인창 없이 저장 · 성공 토스트 + 재조회(실패 시에도 재조회) · 사유 처리 상태 제외 — 처리 내역 「결함이 아님」 · 근거 화면 코드 기록 2026-08-23(사용자 지시) | 확인(원천 제외) | GAP#287  |
| DD-126 | C4 | 조회조건 Year(YYYY) 변경 시 그리드·미저장 편집 초기화 · 자동 재조회 없음(Search 로만) | AS-IS: 칸 제목만 재구성 → TO-BE: 그리드 비움(미저장 편집 초기화), Search 로만 재조회 — 자동 재조회 없음 · 사유 처리 상태 제외 — 근거 화면 코드 기록(처리 내역 공란, 담당 박옥주 2026-10-02 제외 처리) | 확인(원천 제외) | GAP#288  |
| DD-127 | A5 | 버전(VER_SEQ) 칸 숨김(SCM_MST_SHEET_COLUMNS VISIBLE_FLAG 'N') | AS-IS: VER_SEQ 칸 표시 → TO-BE: VER_SEQ 칸 숨김(VISIBLE_FLAG 'N') — 칸 설정 변경 2026-08-23 17:37:44 · 사유 처리 상태 제외 — 처리 내역 「UI Category 화면에서 정의한 너비값이 0이면 아예 안보이게 처리해달라는 PI요청이 있었음」 | 확인(원천 제외) | GAP#289  |
| DD-128 | B4 | 형태(DM_BIZ_TYPE) 칸 셀 콤보 SQL ID DmBizType(기준 코드 DM_BIZ_TYPE) — AS-IS DM_Biz_Type | AS-IS: 셀 콤보 SQL ID DM_Biz_Type → TO-BE: DmBizType(기준 코드 DM_BIZ_TYPE, 표시 동일) — 칸 설정 변경 2026-08-11 17:34:29 · 사유 처리 상태 제외 — 처리 내역 「Ui Category 화면에서 "DM_BIZ_TYPE" 항목으로 관리되고 있는 부분 확인 완료 · 콤보SQl_ID : DmBizType 사용」 | 확인(원천 제외) | GAP#290  |
| DD-204 | H12 | 좌측 기준 칸(부문 DEPARTMENT_ID ~ 형태 DM_BIZ_TYPE) 틀 고정 — SCM_MST_SHEET_COLUMNS DMF0043  | AS-IS: 부문~형태(Edit Flag 앞) 칸을 좌측 고정 — 가로 스크롤해도 표시 → TO-BE: 고정 칸 0칸(DMF0043 · ContributeMain 8칸 전부 FIXED_FLAG 'N') — UI Category Setup 에서 DM_BIZ_TYPE FIXED_FLAG 'Y' 설정으로 해결(반영 필요) · 사유 처리 상태 제외 — 처리 내역 「ui category setup에서 fixed flag 설정하면 해결」(메타 설정 사항으로 분류) · 반영 내역 「FIXED_FLAG N → Y 반영 필요」 · 확인사항 「미반영」 | 확인(원천 제외) | GAP#501 GAP-09 |

### DMF0043_01 (10건)

| 결정 | 검사 규칙 | 대상 | AS-IS → TO-BE · 사유 | 확인 상태 | 출처 |
|---|---|---|---|---|---|
| DD-129 | H12 | 그리드 좌측 고정 컬럼(년월 YYYYMM ~ Biz DM_BIZ_TYPE) — SCM_MST_SHEET_COLUMNS DMF0043 Contri | AS-IS: 년월~Biz 기준 칸을 좌측에 고정(가로 스크롤해도 표시) → TO-BE: 고정 칸 없음 — 칸 설정 테이블(SCM_MST_SHEET_COLUMNS DMF0043 · ContributeSalesList) 9칸 FIXED_FLAG 전부 'N'. 화면은 이 값으로 고정 범위를 정함(처리 내역 : DM_BIZ_TYPE FIX_FLAG Y 업데이트 · 사유 처리 내역 : UI Category 화면에서 "DM_BIZ_TYPE" FIX_FLAG 값 Y로 업데이트 · 품질도 동일하게 처리했는데 고정이 안됨 · 컬럼세팅에서 BIZ가 빠져있었음... 추가하니 잘 작동 — 처리  | 확인(원천 제외) | GAP#295 F-04 |
| DD-130 | G4;H8 | 조회조건 M$(millionYn) 체크 노출 · 켬 상태 동적 금액 컬럼 표시 포맷(정수 → 1백만 미만 0·음수 빨간 0) | AS-IS: M$ 체크 칸 숨김(Visible=false) — 항상 원 단위(p_million_yn 'N') → TO-BE: M$ 체크 칸 노출. 켜면 금액 ÷1,000,000 이나 칸 형식이 정수(소수 없음)라 1백만 미만 금액이 0 으로, 음수 소액은 빨간 0 으로 표시 · 사유 처리 내역 : AS-IS도 마찬거지로 M$ 검색조건 표시 — 제외 | 확인(원천 제외) | GAP#297 F-06 |
| DD-131 | C1 | 조회조건 Year 변경 시 하위 조건(Version·Customer Group·Product Group·Biz·M$) 초기화(공통 cascade | AS-IS: Year 를 바꿔도 Version·고객군·제품군·Biz 값 유지 → TO-BE: Year 를 바꾸면 Version · 고객군 · 제품군 · Biz · M$ 를 기본값으로 비움 · 사유 처리 내역 : 공통 cascade라 결함이 아님 — 제외 | 확인(원천 제외) | GAP#298 F-07 |
| DD-132 | K2 | 사용자별 칸 설정(SCM_MST_TITLESET_USER DMF0043 · ContributeSalesList) 이관 — 없는 사용자는 기본 9 | AS-IS: 사용자별 칸 설정(SCM_MST_TITLESET_USER · DMF0043 · ContributeSalesList) 40명 304행 → TO-BE: 6명 54행. 없는 사용자는 첫 조회 때 프로시저가 기본 9칸을 자동 생성 · 사유 처리 내역 : 개인화 정보이기에 이관이 안된건 문제는 아니라 제외 | 확인(원천 제외) | GAP#301 F-10 |
| DD-133 | MS1 | 정합성 체크 메시지 코드 MSG00307(AS-IS) ↔ MSG00631(TO-BE) 「해외법인 기여도 미 맵핑된 마스터가 존재합니다.」 | AS-IS: MSG00307 「해외법인 기여도 미 맵핑된 마스터가 존재합니다.」 → TO-BE: MSG00631 「해외법인 기여도 미 맵핑된 마스터가 존재합니다.」 · 사유 처리 내역 : 메시지코드는 다를 수 있음 · 근거 다국어 재번호. 정합성 체크 칸은 양쪽 모두 화면에 없음 — 제외 | 확인(원천 제외) | GAP#302  |
| DD-134 | K2 | Column Setting 버튼(공용 칸 설정 팝업) 기능 범위 — 칸 표시·순서 + 폭·셀 색·글자 색 | AS-IS: 칸 표시 · 순서 → TO-BE: 칸 표시 · 순서 + 폭 · 셀 색 · 글자 색 · 사유 처리 내역 : TO-BE 공통기준 · 근거 화면 소스 주석(공용 칸 설정 팝업, MKT FCST 선례) — 제외 | 확인(원천 제외) | GAP#303  |
| DD-135 | B8 | 부문·팀(DEPARTMENT_NAME·DEPT_NAME) 결정 기준 — 사이트·품목 원장 SCM_MST_SITE_ITEM.DEPT_ID | AS-IS: 품목 담당자 → SSO 사용자 부서 → TO-BE: 사이트·품목 원장 DEPT_ID · 사유 처리 내역 : TO-BE에서 부서는 SSPM기준 적용이라 맞음 · 근거 프로시저 2026-09-06 주석(부서 축 아이템 원장 통일) — 제외 | 확인(원천 제외) | GAP#304  |
| DD-136 | G8 | 조회조건 고객군(Customer Group, customerGroup) 텍스트 검색 대소문자 무시(UPPER 비교) | AS-IS: 대소문자 무시(MSSQL 정렬 규칙) → TO-BE: UPPER 비교로 대소문자 무시 · 사유 처리 내역 : AS-IS처럼 대소문자를 무시하겠다는데 무슨 문제인가 · 근거 결과 AS-IS 와 같음(im 46행 = 46행) — 제외 | 확인(원천 제외) | GAP#305  |
| DD-137 | B6;G2 | 조회조건 제품군(Product Group PRODUCT_GROUP)·Biz(DM_BIZ_TYPE) 다중 선택(쉼표 연결값 전송) | AS-IS: 단일 선택 → TO-BE: 다중 선택(쉼표 연결값 전송) · 사유 처리 내역 : PI 요청으로 다중선택 처리 · 근거 화면 소스 주석 2026-06-01 사용자 요구 · 결과 754행 = 754행 — 제외 | 확인(원천 제외) | GAP#306  |
| DD-138 | M3;G6 | Version 팝업 열기 — Report Type Sales Plan(REPORT_SP_W) 기본 선택 · 기간 ±3개월 · 자동 조회 | AS-IS: 기간 기본값 ±3개월, 유형 선택 후 조회 → TO-BE: 기간 기본값 ±3개월, Sales Plan 기본 선택 후 자동 조회 · 사유 처리 내역 : AS-IS도 "Sales Plan" 기본 선택이든데 문제없음 — 제외 | 확인(원천 제외) | GAP#307  |

### DMF0044 (7건)

| 결정 | 검사 규칙 | 대상 | AS-IS → TO-BE · 사유 | 확인 상태 | 출처 |
|---|---|---|---|---|---|
| DD-139 | B5;K2 | Measure 선택 팝업 후보 — VMI 2종(VMI_In_Plan · VMI_In_Req) SCM_MST_SHEET_MEASURE VALID_ | AS-IS: Measure 선택 팝업 후보 9개 — VMI 두 Measure 포함(Measure 마스터 사용 Y, 기본 표시 N) → TO-BE: 후보 7개 — Measure 마스터 두 행 사용 N(2026-09-01 16:57 변경) · 사유 처리 내역 : 문제가 아니라 그냥 컬럼세팅에서 두 컬럼 추가하면 끝(제외) | 확인(원천 제외) | GAP#311 F-03 |
| DD-140 | K2 | 사용자별 Measure 설정(SCM_MST_TITLESET_USER PROGRAM_ID DMF0044 · 'M') 이관 — 첫 진입 Measur | AS-IS: 사용자가 골라 둔 Measure 구성 유지(68명 596행) → TO-BE: 사용자별 화면 설정이 이관되지 않아 첫 진입 시 기본 구성으로 생성(8명 88행) — 사용자가 Measure 세팅하면 유지 · 사유 처리 내역 : 이건 에러나 결함이 아니라 그냥 데이터 이관이 덜된 것. 사용자가 메저세팅 한번하면 끝남(제외) | 확인(원천 제외) | GAP#315 F-07 |
| DD-141 | N1;A7 | 그리드 Plant Site(PLANT_SITE_ID) 빈 값 표시 — 원장 대체 문자('-' 이관 · '/' 신규) 그대로 | AS-IS: 빈칸 → TO-BE: '-' 표시(원장 저장 대체 문자 그대로 · 새로 저장되는 행은 '/') · 사유 처리 내역 : 따로 값 처리 X, '/'가 그리드에 보여도 문제되지 않는다고 확인받아 진행(제외 · 2026-10-16) | 확인(원천 제외) | GAP#320 F-12 |
| DD-142 | B4 | ETC 신규 행 End Cust.(Report) 선택 후보(기준 코드 END_CUST_REPORT 923개) | AS-IS: Team 선택 후 후보 = 품목-사이트 기준정보 ATTRIBUTE2 853개 → TO-BE: 기준 코드 END_CUST_REPORT 923개(공통 847 · TO-BE 에만 76 · AS-IS 에만 6 — '0'·'N'·'n.a' 등) · 사유 처리 내역 : 로직은 동일, 데이터차이(제외) | 확인(원천 제외) | GAP#321 F-13 |
| DD-143 | K4 | Column Setting 버튼(COLUMN_SETUP) 숨김(연결 코드 유지) | AS-IS: 칸 설정 팝업 → TO-BE: 버튼 숨김(연결 코드는 유지) · 사유 처리 내역 : AS-IS에서도 개인화 컬럼팝업 버튼은 없었음 · 근거 2026-08-10 사용자 지시(제외) | 확인(원천 제외) | GAP#323  |
| DD-202 | A5 | 그리드 Department Name(DEPARTMENT_NAME) · Team Name(DEPT_NAME) 컬럼 표시 — SCM_MST_SHEE | AS-IS: Department Name · Team Name 칸 표시(칸 설정 VISIBLE_FLAG Y · 폭 160) — 원장에 저장된 부서명·팀명 표시, Department·Team 칸은 코드 → TO-BE: 두 칸 숨김(칸 설정 VISIBLE_FLAG N, 2026-10-01 13:55 qjastar 변경) — UI Category Setup 에서 바꾸면 바로 적용 · 사유 처리 내역 : 결함이 아니라 ui category setup 에서 설정 바꾸면 바로 적용됨(제외 · 2026-10-16) | 확인(원천 제외) | GAP#495 F-15 |
| DD-205 | A5 | 81·82 사업부별 칸 표시·순서 — Sales Site(SCM_SITE_ID) · Project Code(PROJECT_CODE) SCM_MS | AS-IS: 머리글 프로시저 DMF0044_GET_SPREAD_TITLE : 40 VISIBLE_FLAG · 81 ATTRIBUTE4 · 82 ATTRIBUTE5 로 표시, 정렬 40 SORT_ORDER_NO · 81 ATTRIBUTE2 · 82 ATTRIBUTE3 — SCM_SI → TO-BE: 칸 목록 응답(/admin/menu/DMF0044/column) 81·82 모두 SCM_SITE_ID · PROJECT_CODE · DEPARTMENT_NAME · DEPT_NAME 숨김(VISIBLE_FLAG N) — 40 사업부만 사용 · 사유 처리 내역 : 해당 화면은 asis 에서 해당 사업부에서 버전검색하면 안나옴, 40 사업부만 사용(제외 · 2026-10-16) | 확인(원천 제외) | GAP#502 F-16 |

### DMF0048 (4건)

| 결정 | 검사 규칙 | 대상 | AS-IS → TO-BE · 사유 | 확인 상태 | 출처 |
|---|---|---|---|---|---|
| DD-144 | K2 | Column Setting·Measure 설정(SCM_MST_TITLESET_USER PROGRAM_ID DMF0048 C·M) AS-IS 이관 | AS-IS: 210명(2,325행) 사용자별 칸·Measure 설정 보유 → TO-BE: 9명(206행)만 — 나머지는 첫 조회 때 기본 구성 생성(이관 안 함) · 사유 처리 내역 「데이터 이관이슈이나 메저 세팅정도는 그냥 사용자가 한번 하는게 맞음」 | 확인(원천 제외) | GAP#344 F-08 |
| DD-145 | C1 | 조회조건 Team(DEPT_ID) 변경 시 Bucket(Monthly)·Item Type·Biz Type·Plant Site·Project·Mo | AS-IS: Team 변경 시 End Customer·Sales Site 목록만 다시 채움(Bucket·Item Type·Biz Type·Project·Model·Owner 유지) → TO-BE: Team 변경 시 Bucket(Monthly)·Item Type·Biz Type·Plant Site·Project·Model·Owner 까지 초기화 · 사유 처리 내역 「공통으로 되어있는 cascade 조건」 | 확인(원천 제외) | GAP#347 F-11 |
| DD-146 | K2;A5 | Column Setting 선택 불가 고정 칸 14개(DIVISION_ID·SCM_SITE_ID·PROJECT_CODE·ITEM_ID·TEXT· | AS-IS: 칸 설정 팝업에서 모든 칸 숨김 가능(선택 가능 54칸 전부 Y) → TO-BE: 14칸 선택 불가 — 항상 표시 · 사유 처리 내역 「조회 프로시저의 집계 키 전체, 못건드리는게 맞음」 | 확인(원천 제외) | GAP#348 F-12 |
| DD-147 | E2 | 조회 기간(From~To · PERIOD) 3년 초과 입력 시 MSG00164(Please enter a period within 3 years | AS-IS: MSG00164 후 종료일을 시작일+3년으로 자동 보정 → TO-BE: MSG00164 후 조회 중단(보정 없음) · 사유 처리 내역 「이건 결함이 아님」 | 확인(원천 제외) | GAP#351 F-15 |

### DMF0049 (9건)

| 결정 | 검사 규칙 | 대상 | AS-IS → TO-BE · 사유 | 확인 상태 | 출처 |
|---|---|---|---|---|---|
| DD-148 | F6 | 기존 행 저장 시 DEPARTMENT_NAME 보존(저장 전달값 departmentName · departmentEditFlag false ·  | AS-IS: 원장 부서명 유지 — 화면에 보이던 Department Name 을 저장 전달값으로 전송(AS-IS 화면 891행) → TO-BE: 기존 행 저장 후 DEPARTMENT_NAME 빈 값 아님(재현 안 됨 — 조회 결과 DEPARTMENT_NAME 칸 부재로 빈 값 전송된다는 분석은 확인되지 않음) · 사유 처리 내역 「재현 안됨, 수정 후 저장하고 테이블 봤으나 빈값이 아님」 → 제외 | 확인(원천 제외) | GAP#357 G-01 |
| DD-149 | A5;D1 | 81·82 Project Code(PROJECT_CODE)·End Customer(END_CUSTOMER)·Sales Site(SCM_SITE_ | AS-IS: 표시 칸 81 20칸 · 82 16칸 — 사업부별 표시 속성(ATTRIBUTE4·ATTRIBUTE5)으로 Project Code·End Customer·Sales Site(81 은 Incoterms) 표시·신규 행 입력 → TO-BE: 표시 칸 81 12칸 · 82 9칸 — VISIBLE_FLAG 만 판정해 네 칸 숨김·입력 불가(S) · 사유 처리 내역 「해당 화면은 40사업부만 사용」 · 근거 「원장 81·82 행 : AS-IS 개발 0 · ZIOUI1 0」 | 확인(원천 제외) | GAP#359 G-03 |
| DD-150 | D1 | 81·82 신규 행 입력 가능 칸(PLANT_SITE·CELL/CAR·MODULE/CAR·MODEL TYPE·PROJECT_Name · Mode | AS-IS: 편집 차단 — 81 은 Model·Product Gr.·FCST_TYPE·PLANT_SITE·CELL/CAR·MODULE/CAR·MODEL TYPE·Incoterms, 82 는 Model 입력 불가 → TO-BE: 전부 입력 가능(IO) — 5칸은 저장 전달값에 없어 저장되지 않음 · 사유 처리 내역 「40이 아님」(81·82 미사용 · 원장 0행) | 확인(원천 제외) | GAP#361 G-05 |
| DD-151 | D1 | 81·82 기존 행 Department(DEPARTMENT_ID · M)·Team(DEPT_ID · O)·Cust.(Report) 수정 가능 여 | AS-IS: 40 만 기존 행 Department·Team·Cust.(Report) 수정 가능, 81·82 편집 불가 → TO-BE: 입력 구분 M·O 로 전 사업부 기존 행 수정 가능 · 81 정적 칸만 수정 시 MSG00676 · 사유 처리 내역 「40이 아님」 · 원장 81·82 행 0 | 확인(원천 제외) | GAP#362 G-06 |
| DD-152 | D2;B5 | 81 Biz Plan(REPORT_BP_M) 유형·다음 연도 월 칸 편집 — Measure 편집 허용 룩업 DM_SR_ETC_CURRENCY(8 | AS-IS: 전 Measure 편집 가능 — 기준월이 조회 연도에 없으면 월 잠금 없음(AS-IS 화면 499~519행) → TO-BE: 전 월 편집 불가 — DM_SR_ETC_CURRENCY 에 81 행 없음 · 사유 처리 내역 「40이 아님」 · 원장 81 행 0 | 확인(원천 제외) | GAP#363 G-07 |
| DD-153 | C1;C4 | Division(DIVISION_ID) 변경 시 Report Type(REPORT_TYPE)·Year·Plan/Result 조건 초기화(공통 c | AS-IS: 3개 조건 유지 — Report Type · Year · Plan/Result → TO-BE: 3개 조건 초기화 — Sales Plan · Plan · 올해 · 사유 처리 내역 「공통 cascade」 | 확인(원천 제외) | GAP#364 G-08 |
| DD-154 | H10 | 저장 완료 안내 — 하단 토스트 MSG00002 「성공적으로 저장되었습니다.」(건수 없음) | AS-IS: MSG00004 「{0}개의 데이터가 저장되었습니다.」 → TO-BE: 하단 알림 MSG00002 「성공적으로 저장되었습니다.」(건수 없음) · 사유 근거 「공통 규약(CRUD 완료 알림)」 · 처리 내역 「토스트 메세지는 공통 규약」 | 확인(원천 제외) | GAP#374  |
| DD-206 | A5 | 조회 결과 NICK_NAME 컬럼 표시(SCM_MST_SHEET_COLUMNS DMF0049 'MDF Reports' NICK_NAME VISI | AS-IS: 표시(VISIBLE_FLAG Y · 81 ATTRIBUTE4 Y · 82 ATTRIBUTE5 Y), Model 다음 칸 → TO-BE: 숨김(VISIBLE_FLAG N · 2026-08-23 jaehun_cho) · 조회 프로시저는 값 반환 · 사유 처리 내역 「결함이 아니라 ui category setup에서 설정 바꾸면 바로 적용됨」 | 확인(원천 제외) | GAP#503 G-12 |
| DD-207 | K2 | 사용자별 Measure 설정(SCM_MST_TITLESET_USER PROGRAM_ID DMF0049 · USER_INQUIRY_COLUMN_T | AS-IS: AS-IS 개발 49명 131행 보유 → TO-BE: ZIOUI1 8명 24행 — 이관 안 함(사용자 재설정) · 사유 처리 내역 「결함이 아니라 그냥 사용자 세팅 데이터 안넘어온것, 다시 메저세팅하면 됨」 | 확인(원천 제외) | GAP#504 G-13 |

### DMF0053 (2건)

| 결정 | 검사 규칙 | 대상 | AS-IS → TO-BE · 사유 | 확인 상태 | 출처 |
|---|---|---|---|---|---|
| DD-155 | N1 | EDI SEQ NO 컬럼(EDI_IF_SEQ) 빈 값 표시 — EDI 아닌 행(엑셀·RPA 입력분) '-' 노출 | AS-IS: 빈 칸 표시 — EDI 가 아닌 행(엑셀 · RPA 입력분) → TO-BE: 「-」 표시 — 이관 채움값이 그대로 보임 · 사유 처리 내역 : 빈칸 - 표시문제 — 제외(담당 신지민 2026-10-09) | 확인(원천 제외) | GAP#380 F-05 |
| DD-156 | A5;K2 | 컬럼 표시 범위·숨김 가능 여부 — EDI Sender·Cust. Plant·Cust. Unloading Point·Cust. Item ID·P | AS-IS: 숨김 가능 7칸 — EDI Sender · Cust. Plant · Cust. Unloading Point · Cust. Item ID · Plant Site · Exception · Excepted date. End Customer 칸은 40 에서 미표시 → TO-BE: 숨김 가능 0칸 — 위 7칸이 제목 끝 「*」 + 사용자 선택 불가(N)로 바뀜. End Customer 칸은 40 에도 표시되고, Sold to Code 칸에 81 하위 사업부가 추가됨 · 사유 처리 내역 : 의도된 변경 — 제외 | 확인(원천 제외) | GAP#383 F-08 |

### DMF0068 (6건)

| 결정 | 검사 규칙 | 대상 | AS-IS → TO-BE · 사유 | 확인 상태 | 출처 |
|---|---|---|---|---|---|
| DD-157 | H10;MS1 | Save·Delete 완료 안내 — MSG00002 「성공적으로 저장되었습니다.」 1회(건수 안내 MSG00004/MSG00672 없음) | AS-IS: 건수 표시 — MSG00004 「{0}개의 데이터가 저장되었습니다.」로 저장 「ADD / MODIFY : 건수」, 삭제 「삭제 : 건수」 각각 안내 → TO-BE: 건수 없음 — MSG00002 「성공적으로 저장되었습니다.」만 한 번 표시. 저장 프로시저는 건수(EVENT)를 돌려주나 화면이 쓰지 않음 · 사유 처리 내역 : 저장메세지 MSG00002 로 통일 · N건 저장메세지 뜨는화면 존재하지않음. — 제외 | 확인(원천 제외) | GAP#393 F-02 |
| DD-158 | G4 | Version 팝업 Div(Division) 칸 — 40 고정 표시·선택 불가 | AS-IS: 사업부 목록에서 선택 가능(기본 40) → TO-BE: 40 고정 표시, 선택 불가 · 사유 처리 내역 : asis QA 확인결과 똑같이 40 고정. · 근거 화면 상수 기록 「화면이 40 전용이라 선택은 잠그고 표시용」 — 제외 | 확인(원천 제외) | GAP#396  |
| DD-159 | M3;G6 | Version 팝업 유형(Report Type) 기본값 Sales Plan(REPORT_SP_W) · 열자마자 자동 조회(40건) | AS-IS: 유형 목록 선택 필요(Sales Plan / Biz Plan) → TO-BE: Sales Plan(REPORT_SP_W) 기본 선택 — 팝업 열자마자 40건 표시 · 사유 처리 내역 : asis QA 확인결과 asis 도 똑같이 sales plan 기본선택으로 자동조회되고있음. — 제외 | 확인(원천 제외) | GAP#397  |
| DD-160 | D6 | Insert(F8) 신규 2행 1세트 삽입 위치 — 선택 세트 첫 행 바로 위(Project 짝 행 사이 끼지 않음) | AS-IS: 선택 행 위치에 2행 삽입 → TO-BE: 선택 세트의 첫 행 바로 위에 2행 1세트 삽입(짝 행 사이에 끼지 않음) · 사유 처리 내역 : tobe 에 이미 기능이 구현되어있음. · 근거 화면 소스 기록(삽입 기준 세트 규칙) — 제외 | 확인(원천 제외) | GAP#398  |
| DD-161 | D1 | 조회 결과 EDIT_YN 컬럼(행 편집 가능 여부, 화면 미표시) — 사용자·메뉴 편집 권한 연결 | AS-IS: 없음 → TO-BE: 조회 결과에 행 편집 가능 여부 칸 추가(화면 미표시, 편집 판정용) · 사유 처리 내역 : tobe는 edit 모드 없음. · 근거 PKG_DMF0068 조회 본문 — 사용자·메뉴 편집 권한 연결 — 제외 | 확인(원천 제외) | GAP#400  |
| DD-162 | K4;D1 | Edit 모드 전환 버튼(EDIT) 없음 — 조회 직후 바로 편집 가능(서버 등록 EDIT 버튼 미사용) | AS-IS: Edit 버튼으로 편집 모드 전환 후 저장·추가 가능(편집 모드에서 조회조건 잠금) → TO-BE: 조회 직후 바로 편집 가능, Edit 버튼 없음(서버 등록 EDIT 버튼은 미사용) · 사유 처리 내역 : tobe는 edit 모드 없음. · 근거 화면 소스 기록 「TO-BE 표준에 따라 조회 직후부터 편집 가능 — 편집 모드 토글 미이관」 — 제외 | 확인(원천 제외) | GAP#401  |

### DMF0072 (7건)

| 결정 | 검사 규칙 | 대상 | AS-IS → TO-BE · 사유 | 확인 상태 | 출처 |
|---|---|---|---|---|---|
| DD-163 | E3 | 빈 신규 행(ITEM_ID · Valid From · Valid To 모두 빈 행) 저장 처리 — 필수 입력 검사 MSG00610 전체 차단 | AS-IS: MDM CODE · Valid From · Valid To 가 모두 빈 행은 저장 대상에서 빼고 나머지만 저장(저장할 행이 없으면 MSG00017 「변경된 사항이 없습니다.」) → TO-BE: 빈 행이 하나라도 있으면 MSG00610(Valid From, Valid To, Model Code 값은 필수 입력입니다.) 로 전체 저장 차단 · 사유 처리 상태 제외 — 처리 내역 「행이 추가 되면 필수 체크하는게 맞다」 | 확인(원천 제외) | GAP#411 F-10 |
| DD-164 | H10;I1 | 저장 결과 메시지 — 성공 MSG00002 토스트 · 변경 없음 MSG_NO_CHANGE(수정한 내용이 없습니다.) — AS-IS MSG0002 | AS-IS: MSG00020(저장 하였습니다.) 창 · 변경 없음 MSG00017(변경된 사항이 없습니다.) → TO-BE: MSG00002(성공적으로 저장되었습니다.) 토스트 · 변경 없음 MSG_NO_CHANGE(수정한 내용이 없습니다.) — TO-BE 공통 메시지 규약 · 사유 처리 상태 제외 — 처리 내역 「TO-BE 기준 공톧적용」 · 근거 TO-BE 공통 메시지 규약(DMF0004~0007 동일) | 확인(원천 제외) | GAP#415  |
| DD-165 | B8 | Team 조회 기준(TEAM · SCM_MST_SITE_ITEM.DEPT_ID) — AS-IS Site Item Owner 첫 담당자 SSO 부 | AS-IS: Site Item Owner 첫 담당자의 SSO 부서 → TO-BE: Site Item 원장 DEPT_ID(SSPM 기준) — 조회 프로시저 · Team 목록 함께 변경 · 사유 처리 상태 제외 — 처리 내역 「TO-BE에서는 SITE ITEM 원장 기준의 DEPT_ID 사용하는 것으로 변경(SSPM기준)」 · 근거 2026-09-06 부서 축 아이템 원장 통일 | 확인(원천 제외) | GAP#416  |
| DD-166 | C4 | 조회조건 Division(divisionId) 변경 시 신규 Insert 행 초기화 | AS-IS: Division 변경 시 신규 행 유지 → TO-BE: Division 변경 시 신규 행 초기화(화면 소스 정책 주석 · DMF0004~0007 동일 정책) · 사유 처리 상태 제외 — 처리 내역 「TO-BE에서는 DIVISION 변경 시 초기화 하는 것으로 공통 기준 잡음」 | 확인(원천 제외) | GAP#417  |
| DD-167 | F1;F6 | 원장 반영 문장 — 행별 존재 확인 후 UPDATE/INSERT(ACT_TYPE M/I · P_DMF0072_SAVE_NNMASTER_MAPPI | AS-IS: 병합 저장 1문장(M 수정 · I 추가, 일치 조건 END_CUSTOMER 비교 주석) → TO-BE: 행별 존재 확인 후 수정/추가(M 행 UPDATE/INSERT · I 행은 존재 확인 없이 INSERT), 존재 확인에 End Customer 포함 — ORA-38104 로 FOR LOOP 전환, 수정·신규 결과 AS-IS 와 같음 · 사유 처리 상태 제외 — 처리 내역 「센티널처리로 해결」 · 반영 내역 「반영할 것 없음(차이 아님 — 결과 차이는 F-11 에서 처리, F-11 은 2026-10-19 14:03 반영됨)」 | 확인(원천 제외) | GAP#418  |
| DD-168 | D1;K4 | Edit 버튼(EDIT 잠금 전환) 없음 · 항상 편집 가능 · ERP 행(DATA_TYPE_CODE ERP) · SCM 외 행 편집 칸 차단 | AS-IS: 조회 후 Edit 를 눌러야 편집(ERP 행은 계속 잠금) → TO-BE: 항상 편집 가능, ERP 행 · SCM 외 행의 편집 칸 차단 — TO-BE 공통 화면 설계(편집 모드 버튼 없음) · 사유 처리 상태 제외 — 처리 내역 「TO-BE는 Edit모드는 없음」 | 확인(원천 제외) | GAP#420  |
| DD-203 | H12 | 그리드 왼쪽 칸 틀 고정 — SCM_MST_SHEET_COLUMNS DMF0072 · main FIXED_FLAG(DATA_TYPE_CODE · | AS-IS: 4칸 틀 고정 — 칸 설정 FIXED_FLAG 'Y' : DATA_TYPE_CODE · DIVISION_ID · COMPANY_ID · END_CUSTOMER(정렬 10~40) → TO-BE: 틀 고정 없음 — 칸 설정(시트 main) 23칸 모두 FIXED_FLAG 'N' → 고정 0칸. UI Category Setup 에서 FIXED_FLAG 설정으로 해결(4칸 'Y' 반영 필요) · 사유 처리 상태 제외 — 처리 내역 「ui category setup에서 fixed flag 설정하면 해결」(메타 설정 사항으로 분류) · 반영 내역 「FIXED_FLAG N → Y 반영 필요」 · 확인사항 「미반영」 | 확인(원천 제외) | GAP#496 F-13 |

### DMF0074 (4건)

| 결정 | 검사 규칙 | 대상 | AS-IS → TO-BE · 사유 | 확인 상태 | 출처 |
|---|---|---|---|---|---|
| DD-169 | M3 | Version 팝업(Sales Price Version) Edit · Save — Monthly Rolling Forecast(DM_MST_VE | AS-IS: Version 팝업(Sales Price Version)에 Edit · Save 버튼 — 이번 주차 버전만 Monthly Rolling Forecast(Y/N) 입력해 DM_MST_VERSION.ATTRIBUTE7 저장(MSG00004 · 실패 MSG00284 · 변경 → TO-BE: Version 팝업 버튼 Search · OK · Close 뿐, Monthly Rolling Forecast 칸 표시만 · 저장 프로시저 미전환 — 버전 팝업 공통화 시 수정(보류) · 사유 처리 상태 제외 — 처리 내역 「버전 팝업 작업은 추후 공통화시 수정하는 것으로 변경, 일단은 수정 보류」 | 확인(원천 제외) | GAP#422 F-02 |
| DD-170 | C1 | 조회조건 Team(TEAM) 변경 시 cascade — End Customer · Sales Site · Version · Project · M | AS-IS: Team 변경 시 End Customer · Sales Site 만 갱신하고 Version · Project · Model · Plant Site 값은 유지 → TO-BE: Team 변경 시 End Customer · Sales Site 에 더해 Version · Project · Model/Nickname · Plant Site 까지 초기화(공통 cascade) → 곧바로 조회하면 MSG00283 「Please select a versi · 사유 처리 상태 제외 — 처리 내역 「공통 cascade」 | 확인(원천 제외) | GAP#423 F-03 |
| DD-171 | G5;M3 | Version 팝업 기본 조회 기간(startYyyymmdd~) = 메인 조회조건 Plan Date 전달 · 팝업 목록(SP_W VERSION_ | AS-IS: 팝업 기간 기본값 오늘 −3개월 ~ +3개월(버전 일자 기준) → 열자마자 최근 주간 버전 22~36건 표시 → TO-BE: 팝업 기간 기본값 = 메인 조회조건 Plan Date(당월 1일 ~ +6개월 말일) → 과거 버전 제외, 기본 목록 Current 1행(공통 cascade) · 사유 처리 상태 제외 — 처리 내역 「공통 cascade」 | 확인(원천 제외) | GAP#424 F-04 |
| DD-172 | N1 | 빈 Period(Fr)(FROM_PERIOD · FROM_PERIOD_YYYYMM) · Period(To)(TO_PERIOD) · Excepti | AS-IS: Period(Fr) · Period(To) · Exception 이 빈 값인 칸은 빈칸 표시 · Excel 도 빈칸 → TO-BE: 이관 때 빈 문자열을 '-' 로 채운 값이 그대로 표시(12,214행 · 1,113행) · 새로 올리는 빈 기간은 NVL(…,'-') 저장 — 별도 값 처리 없이 진행(그리드에 '/' 표시 허용 확인) · 사유 처리 상태 제외 — 처리 내역 「따로 값 처리 X, /가 그리드에 보여도 문제되지 않는다고 확인받아 진행」 · 반영 내역에는 업로드 3955·3956행 '-'→'/' · 조회 NULLIF 표시 「반영 필요」 남음 | 확인(원천 제외) | GAP#426 F-06 |

### DMF0082 (16건)

| 결정 | 검사 규칙 | 대상 | AS-IS → TO-BE · 사유 | 확인 상태 | 출처 |
|---|---|---|---|---|---|
| DD-173 | J3 | SCM FCST(SCM_FCST) 입력 시간창 · MKT FCST 편집 차단 시간창(GET_ADMIN_GROUP_MEASURE ATTRIBUTE | AS-IS: 월요일 11:00~18:30(기준 코드 ATTRIBUTE2 · 3 = 1100 · 1830)에만 SCM FCST 입력 가능 · 그 시간 MKT FCST 편집 차단 → TO-BE: 월요일 10:00~19:00(1000 · 1900) — 앞 1시간 · 뒤 30분 넓은 시간창 유지 · 사유 처리 상태 제외 — 운영 시간창 기준 코드 값(ZIOUI1 2026-09-17 minyonglee1 변경)을 TO-BE 값으로 유지(처리 내역 없음) | 확인(원천 제외) | GAP#447 F-10 |
| DD-174 | B4 | 조회조건 Sales Site 콤보(SiteByEndCustomer40_DM · SCM_SITE_ID) 후보 집합 — Active 무관 전체(PI | AS-IS: 조회조건 Sales Site 목록 1,294개 — 유효 판매처(VALID_YN = Y)만 → TO-BE: 조회조건 Sales Site 목록 무효 판매처 포함 전체(1,350~1,352개) · 그리드 신규 행 Sales Site 셀 콤보는 validYn=Y 사용 중만(커밋 3e275132) · 사유 PI 211(의도 변경 · 4.최종확인) 조회조건 콤보는 Active 무관 전체 · 그리드 콤보는 사용 중만(2026-10-19 적용 기준) — 반영 내역 "반영할 것 없음" · 수정하지 않음 | 보류 | GAP#449 F-12 |
| DD-175 | E4 | 저장 BOM 존재 검사 「[모델] BOM does not exist !」(P_DMF0082_SAVE_MAIN_DATA · V_BOM_YN) | AS-IS: BOM 검사 문장은 있으나 비교값이 빈 문자열이라 한 번도 걸리지 않음 — BOM 없는 모델도 저장 → TO-BE: 빈 문자열이 빈 값(NULL)으로 바뀌어 비교 성립 — 11주 안 양수 수량에 BOM 없는 모델이면 「[모델] BOM does not exist !」 저장 차단(유지) · 사유 처리 상태 제외 — 조치안 "검사 유지면 의도적 변경으로 기록"에 따라 TO-BE 검사 작동을 확정 동작으로 둠(처리 내역 없음) | 확인(원천 제외) | GAP#450 F-13 |
| DD-176 | K2 | 사용자별 칸 · Measure 설정(SCM_MST_TITLESET_USER · PROGRAM_ID DMF0082) 이관 | AS-IS: 사용자별 칸 · Measure 설정 199명 3,514행 보유 → TO-BE: 20명 425행만 보유 — 나머지 179명은 첫 조회 때 기본값으로 새로 생성(이관 안 함) · 사유 처리 상태 제외(처리 내역 없음) — 개인화 설정 이관을 하지 않는 것으로 확정 | 확인(원천 제외) | GAP#453 F-16 |
| DD-177 | A5 | Column Setting 목록 Project Name 칸(MDM_PROJECT_NAME · SCM_MST_SHEET_COLUMNS FcstNP | AS-IS: 칸 설정 보임 Y — Column Setting 에서 Project Name 을 골라 표시(AS-IS 사용자 5명 사용) → TO-BE: 칸 설정 보임 N — Project Name 선택 불가(유지) · 사유 처리 상태 제외(처리 내역 없음) — 조치안 "필요하면 VISIBLE_FLAG Y" 미채택 | 확인(원천 제외) | GAP#454 F-17 |
| DD-178 | A5 | 81 CUST FCST 하위 Measure 행(EDI · Commercial Agreement 등 · CUST_FCST) | AS-IS: 81 CUST FCST 하위 Measure 없음(81 은 이 화면 대상 아님) → TO-BE: EDI · Commercial Agreement 등 CUST FCST 하위 행 표시(81 계열) · 사유 기능 추가([E20260825-CUSTSUB] · [E20260826-CUSTSUBR]) · 처리 상태 제외 — AS-IS 대조 대상 아님 | 확인(원천 제외) | GAP#456  |
| DD-179 | M1;K4 | Excel Form · Excel Upload 버튼(EXCEL_FORM · UPLOAD) 81 계열 전용 판가 양식 · 타 사업부 MSG0101 | AS-IS: Excel Form · Excel Upload 기능 없음 → TO-BE: 81 계열 전용 판가 양식 내려받기 · 업로드([E20260813-UPLOADSAVE]) · 81 외 사업부 MSG01014 거부 · 사유 기능 추가 · 처리 상태 제외 — AS-IS 대조 대상 아님(TO-BE 확정 기능) | 확인(원천 제외) | GAP#457  |
| DD-180 | G4 | 조회조건 Plant Site(PLANT_SITE) · Project · Owner · Sender Code 추가 — 81 계열 · 82 활성 · | AS-IS: 조회조건 Division · Team · End Customer · Biz Type · Sales Site · 기간 · Bucket · Version · Model · Qty≥0 · Sum → TO-BE: Plant Site · Project · Owner · Sender Code 추가(81 계열 · 82 에서 활성 · 40 비활성) · 사유 기능 추가(패키지 표식 [PLANT_SITE 2026-08-04] · [UICATEGORY 2026-08-07]) · 처리 상태 제외 | 확인(원천 제외) | GAP#458  |
| DD-181 | E3;E4 | 신규 행 필수(MSG00429) · 신규 행끼리 중복(MSG00260) 검사 시점 = Save | AS-IS: 셀 입력 즉시 필수값(MSG00002) · 신규 행끼리 중복(MSG00260) 검사 → TO-BE: 저장 시점에 검사 — MSG00429 「{0} 값은 필수 입력 항목입니다.」 · MSG00260 「중복된 조합이 존재합니다 (Division/Project/Item/일자/Measure).」 · 사유 화면 설계 주석(실시간 중복 검사 → 저장 시점 이동) · 처리 상태 제외 | 확인(원천 제외) | GAP#459  |
| DD-182 | F1 | 저장 전달값 AS FROM SITE(AS_FROM_SITE) 인자 추가(16 → 17개 · 81 계열 · 82 W/S) | AS-IS: 저장 전달값 16개 → TO-BE: AS FROM SITE 1개 추가(81 계열 · 82 W/S) · 사유 동작 변경 [E20260805-AFS] · 처리 상태 제외 | 확인(원천 제외) | GAP#460  |
| DD-183 | E4 | 판가 검사(Unit Price 존재 · Sales Price 삭제 차단) 판정 범위 = 그 주차 기준(PRICEWEEK · SAMESAVEDEL | AS-IS: Unit Price 존재 · Sales Price 삭제 차단을 52주 범위로 판정 → TO-BE: 그 주차 기준으로 판정 · 사유 동작 변경 [E20260916-PRICEWEEK] · [E20260917-SAMESAVEDEL] · 처리 상태 제외 | 확인(원천 제외) | GAP#461  |
| DD-184 | D1;K4 | 편집 모드 없음 — Edit 버튼(EDIT) 미노출 · 편집 가능 칸(노랑) 조회 직후 입력 · MSG00680 | AS-IS: Edit 버튼으로 편집 모드를 켠 뒤 입력 · Insert · Save → TO-BE: 편집 모드 없음 — 편집 가능 칸(노랑)은 조회 직후 바로 입력 · Edit 전용 메시지 대신 MSG00680 · 사유 TO-BE 화면 방식(편집 가능 칸 색 표시) · 처리 상태 제외 | 확인(원천 제외) | GAP#462  |
| DD-185 | J1;K4;J2 | 조회조건 Division 콤보(DIVISION_ID 40 · 81 계열 · 82) · 82 조회 전용(Insert · Delete · Save  | AS-IS: 40 고정(Division 목록 40 한 건 · 조회 · 저장 프로시저 40 상수) → TO-BE: 40 · 81 계열 · 82 선택 — 81 계열 조회 · 편집 · 신규 · 저장, 82 조회 전용(편집 버튼 숨김 · 저장 거부) · 사유 81 입력을 MKT FCST 화면에서 이 화면으로 이전(2026-08-20 확정 · 과제 E20260706-000169) · 82 = DM_UI_EDITABLE_DIVISION N · 처리 상태 제외 | 확인(원천 제외) | GAP#463  |
| DD-186 | B8 | 조회조건 Team(DEPT_ID) 원천 = SCM_MST_SITE_ITEM.DEPT_ID · 81 End Customer(END_CUSTOMER | AS-IS: Team = 품목 OWNER 사용자 부서 · End Customer = PROJECT_CODE → TO-BE: Team = 사이트 품목 부서(SCM_MST_SITE_ITEM.DEPT_ID) · 81 End Customer = 사이트 고객(SCM_MST_SITE.END_CUSTOMER) · 사유 원천 변경 hook#150(2026-09-06) · [E20260908-ENDCUST] · 처리 상태 제외 | 확인(원천 제외) | GAP#464  |
| DD-187 | N1 | 빈 키 값 센티널(SCM_SITE_ID · CELL_PROD_SITE_ID 등 키 칸 '-' · 신규 '/') | AS-IS: 빈 키 값 = 빈 문자열 → TO-BE: 빈 키 값 = '-'(이관 채움 규칙) · 신규 적재 '/'(2026-10-15 지시 · 과도기 둘 다 허용) · 사유 표시 변경 [E20260820-SENTINELDDL] 이관 채움 규칙 · 처리 상태 제외 | 확인(원천 제외) | GAP#465  |
| DD-213 | C1;B4;B5 | 신규 행 FCST Type 편집 후보에서 ETC 제외 | AS-IS: UP_FX_GetCommonDataList_DM FCST_TYPE: DM ADMIN/DM Planner 12종(ETC 포함) · DM Planner (W/S) 4종(WS/WSF/AS/ASF) → TO-BE: 서버 콤보 FcstTypeEditDMF0082(ETC 포함 · 겸직자 14종) ∩ 표시 dataMap FCST_TYPE_NOT_ETC → ETC 제외(Div 40 11종 · 81 W/S 13종) · 사유 FE 표시 콤보 FCST_TYPE_NOT_ETC 가 ETC 를 의도적으로 뺀 것으로 보이나 확정 근거 문서 없음 — 사람 확인 필요 | 보류 | GAPPI#37  |

### SCP0037 (2건)

| 결정 | 검사 규칙 | 대상 | AS-IS → TO-BE · 사유 | 확인 상태 | 출처 |
|---|---|---|---|---|---|
| DD-218 | G5 | 그리드 Material 셀 팝업(ItemByPlantSiteModal) 인자 itemId — AS-IS popItem.Form_Load(fals | AS-IS: AS-IS 는 선택 행의 ITEM_ID(sItemId)를 팝업 _ItemID 인자로 전달 → TO-BE: TO-BE 는 itemId 고정값("")으로 열어 팝업 안에서 검색 — TO-BE 룰에 맞춰 변경 · 사유 사용자 결정 2026-11-06(SCP0037 CheckList 10번 "팝업 인자 itemId 연동 — TO-BE 룰에 맞춰 변경된 항목(사용자 확인 오류 아님)") | 확인(사용자 판정 2026-11-06 SCP0037 10번) | USER#4  |
| DD-219 | H5 | 그리드 ITEM_ID 셀 팝업(TO-BE 메타 팝업) 제목 — AS-IS 팝업 제목 문구 등록 여부 | AS-IS: AS-IS SCM0002_ItembyPlantSitePopup 제목 문구 → TO-BE: TO-BE 메타 팝업 제목 없음('') — TO-BE 룰에 맞춰 변경 · 사유 사용자 결정 2026-11-06(SCP0037 CheckList 11번 "ITEM_ID 셀 팝업 제목 — TO-BE 룰에 맞춰 변경된 항목(사용자 확인 오류 아님)") | 확인(사용자 판정 2026-11-06 SCP0037 11번) | USER#5  |

### SYS0002 (1건)

| 결정 | 검사 규칙 | 대상 | AS-IS → TO-BE · 사유 | 확인 상태 | 출처 |
|---|---|---|---|---|---|
| DD-212 | A5 | User 화면 Group(Default Group) 컬럼 | AS-IS: Group(Default Group) 컬럼 표시 → TO-BE: Group 컬럼 없음(미추가) · 사유 Web 에서는 Default Group 의 개념이 없어 추가하지 않음(DM 단위테스트 C3 action_note · 4.최종확인) | 확인(원천 확정 결정 — DM 단위테스트 C3 「Web에서는 Default Group 의 개념이 없기 때문에 | DM#C3  |

### SYS0014 (13건)

| 결정 | 검사 규칙 | 대상 | AS-IS → TO-BE · 사유 | 확인 상태 | 출처 |
|---|---|---|---|---|---|
| DD-188 | A1 | Group Info 선택 → User Info 사용자 목록 행 수(SCM_ADM_USER_GR_MPG_M 사용자-그룹 매핑 이관 건수) | AS-IS: 사용자-그룹 매핑 13,042행 → TO-BE: 99행(갭 측정 시점) → 2026-10-16 운영 기준 권한 정보 이관 뒤 13,078행 · 사유 처리 내역 "데이터 이관은 로컬,개발은 완료/품질은 할 예정" · 제외 | 확인(원천 제외) | GAP#466 F-01 |
| DD-189 | D1;D4 | Group Info 그리드 Group ID(USER_GR_ID) · Group Name(USER_GR_NM) 칸 조회 전용(INPUT_TP_CD | AS-IS: 해당 없음(AS-IS 이 화면에 그룹 편집 기능 없음) → TO-BE: 그룹 아이디 · 그룹 이름 두 칸 조회 전용 · 그룹 행 추가 · 저장 불가(Group Info 읽기 전용) · 사유 처리 내역 "Group Info : 그룹ID, 그룹 명은 조회만 가능 저장 불가" · 제외 | 확인(원천 제외) | GAP#469 F-04 |
| DD-190 | I3 | User Info 부서 이름 칸(DEPT_NM) 언어 — 한국어 고정 | AS-IS: 조회 프로시저는 사용자 언어별 세 갈래(한국어 · 영어 · 중국어 부서명)이나 AS-IS 화면은 한글명 표시 → TO-BE: 한국어 고정(유지) · 사유 처리 내역 "AS-IS화면도 다국어 설정과 별개로 한글명으로 표시되고 있기 때문에 따로 수정 안해도 됨" · 제외 | 확인(원천 제외) | GAP#471 F-06 |
| DD-191 | A1;N1 | JV Planner 그룹 User Info 사용자 · JV 유형 권한(USER_GR_ID JV Planner · PLANT_ID) | AS-IS: JV Planner 사용자 4명 · JV 유형 권한 6행(공장 값 채워져 있음) → TO-BE: 사용자 3명(이전에 없던 사람) · JV 유형 권한 0행 — JV Planner 미사용 · 사유 처리 내역 "JV Planner는 to-be에서 사용안한다고 함" · 제외 | 확인(원천 제외) | GAP#474 F-09 |
| DD-192 | H10;MS1 | Save 성공 메시지(MSG00002 「성공적으로 저장되었습니다.」 — 저장 건수 미표시) | AS-IS: 저장 건수를 함께 보여 준다 → TO-BE: 건수 없이 성공만 알린다(저장 처리는 건수를 돌려주지만 화면이 쓰지 않음) — 유지 · 사유 처리 내역 "TO-BE 공통 기준에서는 적용이 안됨" · 제외 | 확인(원천 제외) | GAP#478 F-13 |
| DD-193 | A4 | Search 재조회 시 User Info · Division 영역 유지(GroupInfo 조회 조건만 재설정) | AS-IS: 사용자 · 사업부 두 영역을 비우고 고른 값을 지운다 → TO-BE: 그룹 조회 조건만 다시 세운다(두 영역 유지) — 유지 · 사유 처리 내역 "TO-BE 기준이 잘못된건 아니기 때문에 기능 제외" · 제외 | 확인(원천 제외) | GAP#479 F-14 |
| DD-194 | A5 | Division 영역 JV 공장 칸(PLANT_ID · JV 유형) 미표시 · 저장 처리 없음 | AS-IS: JV 유형 권한 줄로 따로 관리하고 공장 아이디를 이어 붙여 저장(이전 실물 6행에 공장 값) → TO-BE: 조회가 JV 공장 값을 빈 값으로 고정 · 읽는 조건 사업부 유형 하나 · JV 공장 칸 미표시 · 저장 처리 없음 · 사유 패키지 본문 주석 2026-09-11 「JV Planner 는 미사용 역할」 · 처리 내역 "PI 확인으로 JV 공장 값 또는 JV Planner 권한을 관리하지 않는다고 함" · 제외 | 확인(원천 제외) | GAP#481  |
| DD-195 | A5 | User Info 기록 칸(CREATED_BY · CREATION_DATE · LAST_UPDATED_BY · LAST_UPDATE_DATE)  | AS-IS: 등록자 아이디 한 칸만 있고 화면에 보이지 않았다 → TO-BE: 최초 등록자 · 일시 · 최종 변경자 · 일시 네 칸 표시 · 사유 항목 설정 · AS-IS 대비 매핑 문서 2026-06-26 · 처리 내역 "추가항목이라 변경이 필요 없음" · 제외 | 확인(원천 제외) | GAP#482  |
| DD-196 | A5;A2 | Division 영역 사업부 칸 구성 — UNIT_ID 칸 하나(AllDivision_SCP 로 「코드 + 이름」 표시) · 부문 이름 칸 없음 | AS-IS: 코드 칸(숨김)과 이름 칸(코드 + 이름) 두 칸 → TO-BE: 이름 칸 자리에 코드(UNIT_ID) 하나 · 부문 이름 칸 없음 → UNIT_ID 칸이 AllDivision_SCP 목록으로 「코드 + 이름」 표시 · 사유 매핑 문서 2026-06-26 · 처리 내역 "이름으로 표시되고 있음" · 제외 | 확인(원천 제외) | GAP#483  |
| DD-197 | F1 | 저장 신규 줄 사용 여부(USE_YN · VALID_YN) 'Y' 적재(SCM_ADM_USER_GR_MPG_M · 항목 설정에서 사용 여부 칸  | AS-IS: 사용 여부 숨김 칸으로 있었다(valid_yn Y 적재) → TO-BE: 항목 설정에서 지웠다 · 저장은 새 줄을 Y 로 넣는다 · 사유 매핑 문서 2026-06-26 · 처리 내역 "저장 시에 사용여부가 Y로 들어가는지 점검 필요 — 로컬DB 반영 PKG_SYS0014 가 엔솔DB(개발,QA) 미적용" · 제외 | 확인(원천 제외) | GAP#484  |
| DD-198 | K4;D1 | 편집 단추(EDIT) 없음 — 칸마다 입력 구분(INPUT_TP_CD) 고정(고칠 수 있는 칸 2개) | AS-IS: 조회 뒤 잠금을 푸는 편집 단추가 있었다 → TO-BE: 없다 · 칸마다 입력 구분으로 고정(고칠 수 있는 칸 2개) · 사유 단추 등록 17행에 편집 없음 · 항목 설정 입력 구분 · 처리 내역 "to-be에는 편집 버튼이 없음" · 제외 | 확인(원천 제외) | GAP#485  |
| DD-199 | K4;D1 | Group Info Insert · Delete 단추(GroupInfo · INSERT · DELETE) 등록은 있으나 Group Info 조회 | AS-IS: 이 화면에 없었다(그룹 관리는 다른 화면 몫) → TO-BE: 단추 등록 2026-06-29 · 저장 처리 3문장이 들어왔으나 Group Info 는 조회만(읽기 전용) · 사유 처리 내역 "테스트 결과 Group Info 는 조회만 됨" · 제외 | 확인(원천 제외) | GAP#486  |
| DD-200 | G4 | Group Info 그룹 검색어 인자(searchText) — 화면 조회조건 없음(늘 빈 값 전송) | AS-IS: 그룹 검색어 없었다 → TO-BE: 검색어 인자가 생겼다(대소문자 무시 부분 일치) · 화면은 늘 빈 값 전송(조회조건 없음) · 사유 패키지 본문 · 처리 내역 "검색조건 없음" · 제외 | 확인(원천 제외) | GAP#487  |

## 3. SP 통합·대체

| 룰 | 화면 | 내용 |
|---|---|---|
| SPR-001 | SCP0016 | AS-IS SP SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL_TITLE_PARAL → TO-BE 호출 main/SEARCH;spreadTitle/SEARCH · AS-IS 2단 조회(TITLE_PARAL 골격 + GET 4개월 병렬)를 TO-BE 는 main GET 1회(행+값) + PKG_COM0000 캘린더(spreadTitle)로 통합 — __asis-mapping__.md D00-4a-002 구현 · 사용자 확인 2026-11-06 오류 아님 |

## 4. 라벨 대응 (AS-IS 문구 ↔ TO-BE 문구)

| 룰 | 범위 | 영역 | AS-IS | TO-BE | 비고 |
|---|---|---|---|---|---|
| CR-092 | SCP;SSP | 조회조건;그리드;팝업 그리드 | Valid | Active | 사용자 지시 2026-10-30: SCP·SSP 컬럼·조회조건 명칭 Valid → Active 일괄. AS-IS 'Valid'(또는 'Valid*') ↔ TO-BE 'Active' 는 오류 아님(PASS). TO-BE 에 'Valid' 가 남아 있으면 Active 로 변경 대상(CR-092 FAIL · 보완 = SHEET_COLUMNS.COLUMN_LABE |

## 5. 생성 단계 허용 차이 (AS-IS 컨트롤·패턴 중 TO-BE 에 옮기지 않는 것)

| 룰 | 종류: 패턴 | 사유 |
|---|---|---|
| AG-001 | control_type: ^(LayoutControlItem¦LayoutControlGroup¦EmptySpaceItem¦UsrLayoutControl¦SplitCont | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 |
| AG-002 | control_type: ^SheetView$ | FpSpread 디자이너 SheetView — DataGrid 1개 + SHEETS enum/activeSheet 상태로 흡수 |
| AG-003 | control_name: ^(btnSearch¦btnFind¦FindButton¦btnQuery¦btnInquiry)$ | SearchArea 내장 조회 버튼으로 흡수 |
| AG-004 | control_name: ^btnExcel(Down¦Download¦Export)?$ | SubTitle 내장 엑셀 다운로드로 흡수 |
| AG-005 | control_name: ^btn(Close¦Cancel¦Exit)$ | CustomDialog 내장 닫기 |
| AG-006 | event: ^this\.components | 디자이너 컴포넌트 컨테이너 |
| AG-007 | event: KeyUp | As-is Ctrl+C/V 복사·붙여넣기 → Wijmo autoClipboard + pastingCell/pastedCell |
| AG-008 | endpoint: _SPREAD_TITLE$ | 그리드 헤더 메타 → /admin/menu/{MENU}/column(SCM_MST_SHEET_COLUMNS) + spreadTitle 시트(동적 헤더 SP) |
| AG-009 | endpoint: ^UP_FX_GetCommonDataList | 공통 콤보 조회 → useTabComboQueries(콤보ID 등록) |
| AG-010 | endpoint: _GET_BUTTON_AUTH$ | 버튼 권한 → useTabBtnPermissions(SYS 권한 메타) |
| AG-011 | property: readOnly 기간 선택 | As-is drpPeriod readOnly 는 To-Be 표준 PeriodField(편집 가능) 로 대체 — 사용자 결정 |
| AG-012 | endpoint: ^biz:CommonData | 공통 데이터(BIZ CommonDataList) → useTabComboQueries / useTabLookupQueries |
| AG-013 | endpoint: _GET_(BUCKET_TYPE_CODE¦BIZ_TYPE_BY_DIVISION¦CODE_LIST¦LOOKUP)$ | 공통코드 콤보 → 등록 콤보ID(useTabComboQueries) |
| AG-014 | event: ^(timer¦tmr)[A-Za-z0-9_]*\s+Tick | 타이머 → React Query refetchInterval / useEffect setInterval |
| AG-015 | control_type: ^(ToolStripMenuItem¦ContextMenuStrip)$ | 그리드 우클릭 메뉴 — To-Be 표준은 SubTitle 버튼/셀 더블클릭. 필요 시 화면별 결정(룰 보완 후보) |
| AG-016 | event: ^backgroundWorker\w*\s+(DoWork¦ProgressChanged¦RunWorkerCompleted) | 백그라운드 작업 → React Query mutation/useStreamProcQuery (진행률은 ProgressIndicator) |
| AG-017 | event: ^this\s+(Resize¦SizeChanged¦Paint) | WinForms 레이아웃 이벤트 — CSS/Wijmo 자동 레이아웃 |
| AG-018 | event: ^splitContainer\w*\s+ | 분할 컨테이너 이벤트 — PanelGroup 레이아웃 |
| AG-019 | endpoint: ^SCM0001_GET_(DIVISION¦LOOKUP_VALUES¦SITE_BY_DIVISION¦TEAM_BY_DIVISION¦CUSTOMER_ | 공통 콤보 SP → 등록 콤보ID(MyDivision/TeambyDivision/SiteByEndCustomer/PlantSitebyEndCustomer/BizTypeByDivision…) useTabComboQueries |
| AG-020 | endpoint: ^PR_SCM_SYS_LOG_BATCH$ | 화면 사용 로그 → BE 공통(Aspect/LogController) — 화면 코드 대응 없음 |
| AG-021 | endpoint: _GET_SEARCH_INFO$¦GetSearchCondition¦SaveSearchCondition¦ResetSearchCondition | 사용자별 조회조건 저장/복원(G1) → /admin/menu/{MENU}/search-conditions (store fetchStaticColumns 내장) |

## 6. 원장 미등록 후보 — 메모리에만 있는 TO-BE 결정 (2건 · 사용자 확인 뒤 CR 로 등록)

- `feedback_static_first_launcher_dynamic_only_20261116.md` — 11-16 목적 = AS-IS→TO-BE 전환 후 기능 100% 오류 없이 동작 · 정적으로 되는 항목은 정적으로 · 런처는 동적으로 필요한 항목만 · TO-BE 룰로 바뀐 부분은 룰 준수만 확인
- `feedback_tobe_rule_slash_sentinel_not_null_20261113.md` — "TO-BE 룰 — NOT NULL 컬럼의 빈 값은 '/' 로 처리(NVL(x,'/') · 컬럼 DEFAULT '/') · 오류로 잡지 않음"
