# 담당 G 보고 (SCP0005 라운드 3 · B07·B08 15행 · 2026-11-25 03:15 기준)

소유 파일 `tools/Harness/verify/gen_expect.py` 만 고침. 백업 `gen_expect.py.bak_20261125_scp05u3`. 줄바꿈 CRLF 유지(1337/1337).

| result | 행 |
|---|---|
| 보완 | 3 (V-3aecb21a, V-e4a3ef56, V-9beff6f2) |
| 결정 | 9 (B07 전부) |
| 미처리 | 3 (V-1f03b82a, V-2e931168, V-eab82e73) |

## B07 F3 P32 9행 (결정)

위치 구분
- 생성: `gen_expect.py:339` p_combo P32 행(`paste:{col}=@copy:out`)
- 토큰 해석: `Doc/e2e/specs/_verify.spec.ts:2786` resolveTarget `@copy:(in|out)` 분기. 조회 행 최대 30000행에서 이 행 후보 밖 값을 가진 기존 행을 찾고 없으면 '값 토큰 @copy:out 해석 실패(값 없음)'. 후보 건수 표시는 keys.size/2(코드·이름 합친 집합 크기 절반)라 실제 후보 수와 다름(TRANSPORT_MODE 후보 5건이 '4건', Y·N 2건이 '1건'으로 찍힘). V 담당 참고

실측(사내 오라클 조회 2026-11-25 03:0x, tools/DbConn)
- SCP_MST_DISTRIBUTION_ROUTE 8076행. 재검 조회 8076행과 같음(전 행을 읽고도 못 찾음)
- DAYS_MON~SUN 값 Y·N·NULL만(예 DAYS_MON Y 4116, N 2, NULL 3958). VALID_YN Y 8051, N 25. 테이블 CHECK 제약은 NOT NULL 6건뿐
- 후보 원천: AS-IS combo_src.csv DAYS_*·VALID_YN = STATIC YesOrNo [Y,N]. TO-BE combo_sql.csv YesOrNo = `SELECT 'Y'…UNION ALL SELECT 'N' FROM DUAL`
- TRANSPORT_MODE: SCM_ADM_LOOKUP_MASTER_DETAIL TRANSPORT_MODE_CODE 5건(AIR, FRY, RAI, SEA, TRK) 전부 VALID_YN=Y. 데이터 값 5종 전부 후보 안

검사기가 전제를 만들 수 있는지
- 다른 조건·Division 순회: SCP0005 Division 컨트롤 없음, 전 행 조회 결과에 없음 → 순회로 못 찾음
- 비활성 코드 조회: TRANSPORT_MODE_CODE 비활성 코드 0건 → 만들 값 없음
- DB 쓰기로 전제 생성은 금지

결정 후보
- D-G1 (8행 DAYS_*·VALID_YN): 후보가 고정 코드 목록(STATIC)인 콤보에 P32 를 만들지 정함. 권장 = STATIC 원천 콤보는 P32 생성 안 함 + `_gen_report.json` why_not 에 'combo_src STATIC 고정 목록 · 비활성 상태 없음' 기록. 근거 combo_src.csv GRID DAYS_MON·VALID_YN 행, gen_expect.py:331~332 P32 도입 사유(비활성 마스터). DB 에 CHECK 제약이 없어 '생길 수 없음'은 원문으로 증명 안 됨 → 사용자 판정 필요
- D-G2 (1행 TRANSPORT_MODE): 마스터 비활성 코드 0건이고 데이터 밖 값 0건일 때 처리. 권장 = 해석 실패 문구에 '마스터 비활성 0건 · 조회 N행 전부 후보 안'을 남기고 미검증 유지 또는 해당없음 처리 중 택1. 해당없음으로 갈 경우 근거 = 후보 SQL(combo_sql TransportModeCode, VALID_YN='Y')과 원천 마스터 비활성 0건 조회

## B08 6행

### V-e4a3ef56, V-9beff6f2 C3 P24 (보완 · T550)
- 원인: `p_popfill` 이 actions.csv guard 전체에서 `e.Column ==` 칸을 모음. guard 는 조각마다 잘려('…') cs:1158 행 xs = 바깥 if(cs:1112~1116) FROM_CITY·FROM_COUNTRY + 'else of' 조각 FROM_CITY + 안쪽 TO_CITY. 그래서 FROM_CITY·FROM_COUNTRY 팝업 → TO_COUNTRY 행이 생김. TO-BE 측정(FROM_CITY='ADALV', TO_COUNTRY 빈 값)은 AS-IS 와 같음
- 수정: `gen_expect.py:665~720` `_src_inner_if`(AS-IS 소스에서 대입을 직접 감싼 if 조건 원문), `_inner_cols`(없으면 guard 의 마지막 'else of' 아닌 조각). 별칭 제외는 원천 칸 자신과 숫자 접미만 다른 칸(ITEM_ID ↔ ITEM_ID40)
- 단위 확인: SCP0005 cs:1152~1154 원천 [FROM_CITY, FROM_CITY_NAME, FROM_COUNTRY], cs:1158~1160 [TO_CITY, TO_CITY_NAME, TO_COUNTRY]
- 생성 변화(58화면 비교, 파일 쓰기 없음): SCP0005 P24 3행 삭제(FROM_CITY·FROM_COUNTRY·TO_CITY → TO_COUNTRY), 4행 생성(FROM_CITY → FROM_CITY_NAME·FROM_COUNTRY, FROM_COUNTRY → FROM_CITY·FROM_CITY_NAME, TO_CITY → TO_CITY_NAME·TO_COUNTRY, TO_COUNTRY → TO_CITY·TO_CITY_NAME). 다른 57화면 P24 변화 0
- 다음 CheckList(미측정): 두 행은 원장에서 빠지고 새 P24 4행이 실측됨

### V-eab82e73 C3 LT_VOYAGE (미처리)
- 생성기: `gen_expect.py` 아님. 원장 행 = `tools/Harness/verify/ledger.py:728`(ASIS C3, `condition=guard[:600]`), 측정 = `_verify.spec.ts:705~745` C3, 원천 해석 = `_verify.spec.ts:205` resolveSrc
- 원인(실측): actions.csv cs:1027 guard 625자. ledger 가 600자에서 잘라 마지막 조각이 `if (e.Column == siMain.GetColumnInd` 로 끝남 → resolveSrc m1 실패 → m2 가 바깥 if 첫 칸 LT_ARRIVAL_INLAND 를 원천으로 잡음 → 'LT_ARRIVAL_INLAND → LT_VOYAGE' 연쇄로 측정. 원문 cs:1025 `else if (e.Column == …LT_VOYAGE)` 안의 자기 칸 되돌림이므로 T367 규칙(자기 칸 고정 값 + 같은 메서드 메시지 MSG00209 → NA) 대상
- 타 파일 필요
  - L `ledger.py:728` 등 C3·C6 add: `condition=guard[:600]` → 안쪽 조각을 남기도록 `guard if len(guard) <= 600 else '…' + guard[-599:]`
  - 또는 V `_verify.spec.ts:205` resolveSrc: 안쪽 조각에서 칸을 못 읽으면 `ACTS` 에서 asis_ref 줄의 전체 guard 로 다시 해석

### V-3aecb21a F2 P23 (보완 · T551)
- 원인: `p_modins` 필수 칸 = INPUT_TP_CD M/IM 만. SCP0005 편집 칸 31개 전부 O → '필수 0칸'. AS-IS SaveData cs:653 `DataUtil.checkRequiredOfSpread(siMain)` 는 헤더 라벨에 '*' 가 있는 칸을 필수로 봄(DataUtil.cs:43~60)
- 수정: `gen_expect.py:639~657` AS-IS actions 에 VALIDATE `DataUtil.checkRequiredOfSpread` 가 있으면 신규 행 편집 칸 중 편집 행(O/M/IO/IM) 라벨에 '*' 가 있는 칸도 채움. 추가 칸 중 팝업 칸(FPTextModal)은 `popcell:칸=`(팝업 첫 행 선택). 종전 M/IM 칸 입력 방식은 그대로
- SCP0005 결과: 필수 15칸(LT_TYPE, FROM_COUNTRY, FROM_CITY, TRANSPORT_MODE, PRIORITY, D_PORT_NAME, D_COUNTRY, D_PORT_CODE, A_PORT_NAME, A_COUNTRY, A_PORT_CODE, SHIPPING_COMPANY, TO_COUNTRY, TO_CITY, VALID_YN)
- 다른 화면 P23 변화: SCP0007(라벨 '*' 6칸 · 현 원장 FAIL '[Priority] 값은 필수 입력 항목입니다.' 같은 원인), SCP0020(7칸 · 현 ERROR NICK_NAME 입력 실패), SCP0104(1칸 · 현 PASS 정적 판정), SSP0200(1칸 · 현 ERROR TRANSPORT_MODE 입력 실패). checkRequiredOfSpread 가 있는 asisfacts actions.csv 143화면
- 다음 CheckList(미측정): 원장 행 V-3aecb21a 는 AI 검토 PASS 대신 실측(M·I 저장 요청)으로 판정. D_COUNTRY 등 글자 칸에 'E2E_SCN_I' 입력 뒤 TO-BE 검증 문구가 나오면 그 문구로 판정됨

### V-1f03b82a, V-2e931168 C1 P07 (미처리 · T552 선반영)
- 원인(실측): AS-IS 메타 dbmeta_dbo_SCM_MST_SHEET_COLUMNS LT_TYPE·TRANSPORT_MODE CELL_COMBO_DATA_TYPE=LookupCommon, ATTRIBUTE1 LT_TYPE·TRANSPORT_MODE_CODE. TO-BE DB(11-25 조회) CELL_COMBO_DATA_TYPE LtType·TransportModeCode. TO-BE 그리드는 `cellCboDataTp`(TO-BE 메타 값)로 콤보를 부름(nscm-fe/packages/foundation/src/utils/columnMapping.ts:209~211). 재검 수집 combo_live.csv comboId LtType 3건, TransportModeCode 5건 = DB 건수. 시나리오 `@combo:LookupCommon` 은 요청 본문 포함 검사(_verify.spec.ts:2801)라 못 찾음
- AS-IS ID 를 TO-BE ID 로 바꾸는 추정 매핑은 쓰지 않음. TO-BE DB 에 LookupCommon 그대로 쓰는 행 84건(37화면)이 있어 combo_sql.csv 로 고르면 틀림
- 수정: `gen_expect.py:323~330` TO-BE sheet_columns 행에 `cell_combo_data_type` 이 있으면 그 값을 서버 콤보 ID 로 씀. 지금 Doc/tobefacts/db/sheet_columns.csv 에 열이 없어 생성 변화 0(58화면 P07 변화 0 확인). 열 주입 단위 시험: LT_TYPE → `gridcands:LT_TYPE=@combo:LtType`
- 타 파일 필요: `tools/DbConn/export_tobe_meta.py:28~31` sheet_columns SELECT 에 `CELL_COMBO_DATA_TYPE cell_combo_data_type` 추가 후 export 재실행(소유자 표에 없음 → 배정 필요)

## 확인 명령과 결과
- `python -m py_compile tools/Harness/verify/gen_expect.py` OK
- `engine_selfcheck.py --quick` PASS(22.4초, PY_COMPILE 0, PY_UNDEF 0, CTRL_CHARS 0, JS_SYNTAX 0, SPEC_SIZE 0)
- 58화면 p_popfill·p_modins·p_combo 생성 비교(수정 전 백업 vs 수정 후, 메모리 실행 · auto_expect 파일 안 씀): `.tmp_u5/G/dump.py`, `before.json`, `after.json`. 변화 = SCP0005 P24 -3 +4, P23 5화면, P07 0
- gen_expect.py 실행으로 auto_expect 재생성은 하지 않음(다음 CheckList 생성 단계에서 반영)

## 새 결함 유형
- T550 팝업 연쇄 원천 바깥 if 묶음: 더블클릭 팝업 뒤 대입의 원천을 guard 전체 칸으로 잡아 다른 분기 대입과 짝지음. 원천 = 대입을 직접 감싼 if
- T551 라벨 '*' 필수 누락: AS-IS checkRequiredOfSpread 화면에서 INPUT_TP_CD 만으로 필수를 세어 신규 행을 비운 채 저장
- T552 콤보 ID AS-IS/TO-BE 이름 다름: AS-IS LookupCommon+ATTRIBUTE1 이 TO-BE 전용 ID(LtType 등)로 바뀐 칸에서 서버 콤보 응답을 못 찾음
- (V·L 소관) guard 600자 절단: ledger.py 가 안쪽 분기를 잘라 C3 원천을 바깥 if 로 잡음

## 새 도구 파일
- `.tmp_u5/G/dump.py`(작업용 비교 스크립트, 엔진 아님)
