# 두 화면 작업 중 권장안으로 진행한 판단 목록 (완료 후 일괄 확인용)

| 번호 | 일시 | 항목 | 선택 | 근거 | 되돌리는 방법 | 사용자 확인 |
|---|---|---|---|---|---|---|
| 1 | 11-16 09:4x | SSP0020 CHK 컬럼 ↔ 행 머리 선택기 | TO-BE 룰 CR-104 로 인정 | 사용자 답 '룰로 인정' | confirmed_requirements.csv.bak_20261116_cr104 · _trace.spec.ts CR-104 분기 삭제 | 재확인 필요(사용자 11-16: 용어 뜻을 모르고 답함). 완료 후 양쪽 화면 캡처와 함께 다시 질의 |
| 2 | 11-16 09:2x | 차등 검증 값·행 집합 차이 | 판정 제외(해당없음 + 근거), 컬럼 집합·정렬 차이는 FAIL (CR-105) | 사용자 답 '그렇게 판정' | diff_rule_map.csv.bak_20261116_cr105 | 재확인 필요(중간 질문으로 받은 답). 완료 후 실제 차이 사례와 함께 다시 질의 |
| 3 | 11-16 09:2x | CR-105 적용 범위 | 전 화면(룰 파일 공용) | diff_rule_map.csv 가 화면 구분 없음 | 위와 같음 | 미확인 |
| 4 | 11-16 09:1x | SSP0020 SP 짝 4건 | sp_pair.csv 수동 등록 | TO-BE 인자 목록 실측 일치 | sp_pair.csv.bak_20261116_ssp0020 | 미확인 |
| 5 | 11-16 | SSP0020 검증용 위임 행 | 화면 저장으로 생성, 끝에 UnSet. 위임받는 계정 jiangguoping, 기간 검증 당일 | 사용자 답 '그 방식으로 진행' | 화면 UnSet | 확인됨 |

## 일괄 질의 작성 규칙 (사용자 지시 11-16)
- 내부 용어(CHK, 행 선택기, 차등 검증 등)만으로 묻지 않는다. 화면에서 보이는 모습, AS-IS 와 TO-BE 의 차이, 선택별 결과를 적고 양쪽 화면 캡처를 붙인다.
- 중간 질문으로 받은 답은 '재확인 필요'로 두고 마지막에 다시 묻는다.

| 6 | 11-16 10:4x | 잠금 사실 규칙 변경(facts_lockrules.py): 조회 결과 바인딩 블록의 컬럼 범위 잠금 + EditButton 해제 없음 = 기존행 잠금 | 적용(전 화면 공용 규칙) | SSP0020 cs:294·307 · D1 허위 FAIL 8행 | facts_lockrules.py.bak_20261116_searchlock | 미확인. 영향 실측: 27화면 중 SSP0003 54컬럼이 편집 가능 → 잠금으로 바뀜(CHK 제외 전). SSP0003 은 사실 파일을 종전 값으로 되돌려 둠. 그 화면 처리 때 원문 확인 필요 |
| 7 | 11-16 11:1x | 실행으로 재지 못한 행의 처리 방식 | 정적 판정 기록(Doc/verify/<ID>/static_verdicts.csv)을 판정기가 반영. 한 행씩 AS-IS·TO-BE 원문을 대조해 근거(파일:행)를 적은 것만 반영하고 '[정적 판정]'으로 표시 | 사용자 지시 '정적으로 가능한 부분은 정적으로' | static_verdicts.csv 삭제 후 재판정 | 미확인. 완료 후 정적 판정 전체 목록을 보여 드리고 확인받음 |
| 8 | 11-16 11:0x | AS-IS 실구동 건수 ↔ TO-BE 건수 대조에서 조회 SP 인자가 세션·언어뿐인 경우 | 판정 제외(해당없음 + 근거). 로그인 계정이 달라 같은 조건이 아님 | SSP0020 'TO-BE 에 데이터가 없음' 허위 FAIL | asis_live_rows.py 해당 구간 삭제 | 미확인. 11-13 지시(소량 차이 판정필요 · 큰 차이 조치 필요)는 그 밖의 화면에 그대로 적용 |
| 9 | 11-16 14:3x | SSP0020 조회영역의 All 체크박스 | AS-IS 는 Division 목록 옆에 All 체크박스가 따로 있음. TO-BE 는 Division 선택 칸 안의 전체 선택 항목으로 대신함. 같은 기능으로 보고 PASS(정적 판정 + 실행 측정) | AS-IS cs:924~940 · TO-BE DelegateForm.tsx allOption · 시나리오 F08·F09 | static_verdicts.csv 의 T-08875613 행 삭제 | 미확인 |
| 10 | 11-16 12:5x | SSP0020 해제 프로시저의 '위임받은 쪽 해제' 분기 | AS-IS SP 에는 있고 TO-BE PROC 에는 없음. 양쪽 화면 모두 그 경로의 버튼이 숨겨져 있어 화면 동작은 같다고 보고 대상 없음 처리 | AS-IS dbo.SSP0020_SAVE_UNSET.sql:97~123 · cs:240~243 · TO-BE Delegate.tsx:334·412 | static_verdicts.csv 의 EG-9fd40fb0 행 삭제 | 미확인 |
| 11 | 11-16 | 권한 없는 계정이 주소를 직접 입력하면 SSP0020 화면이 열림(EG-f6eeda7b) | 미판정으로 남김(공통 접근 제어 · 기존 기록에 'FAIL 승격 여부는 사용자 결정') | 실측 authorized=true | - | 미확인. 오류로 볼지 결정 필요 → 11-16 23:5x 결정 35 로 대체(FAIL 판정) |
| 12 | 11-16 | 스냅샷 6건(조회조건·버튼·머리글 2·화면 캡처 2) | 승인 대기로 남김 | snap_approve.py 승인은 사용자 절차 | - | 미확인. 캡처를 보고 승인 필요 → 11-16 23:5x 결정 34 로 대체(5건 승격·헤더 2건 FAIL) |
| 13 | 11-16 13:1x | 사용자 찾기 팝업의 필터 적용 조작(EG-153fcc99) | 미검증으로 남김. 첫 컬럼 필터 창은 열리고 두 번째 컬럼은 잡히지 않음 | 진단 실측 | - | 원인 미확인 → 11-16 22:5x 원인 확정: 검사기 결함(필터 목록에 전체 선택 칸이 없어 첫 값을 전체 선택으로 오인 · 적용 직전 1,592/1,592 선택). popupprobe.ts 수정 뒤 PASS(8,612→1→8,612행) · 건수 표시는 NA |
| 14 | 11-16 16:4x | SCP0104 SOP 탭에서 새로 추가한 행의 편집 범위 | AS-IS 는 새 행도 SOP 일자·Active 두 칸만 편집 가능. TO-BE 는 컬럼 설정(메타)에서 '신규 행만 편집'으로 지정한 칸(Div·Plant·Building·Line·Operation·Line Type 등)도 새 행에서 편집 가능. TO-BE 기준으로 판정 | AS-IS SCP0104_CAPA_Line_Assign.cs:4042~4057 · TO-BE capaLineAssign.editLock.ts isSopCellEditable 주석 '사용자 결정 2026-10-28 메타 정본' | Doc/verify/SCP0104/edit_expect_manual.csv 의 SOP 시트 new_row 값을 N 으로 | 미확인. 10-28 결정이 이 범위까지 포함하는지 확인 필요 |
| 15 | 11-16 16:4x | SCP0104 선택 팝업 2종(CAPA Line 찾기 · SOP 모델 찾기) 안 그리드의 '새 행' 검사 | 대상 없음 처리. 팝업 버튼은 Search·OK·Close 뿐이라 새 행이 생기지 않음. 기존 행은 체크 칸만 편집 가능으로 기대 | AS-IS SCP0104_CAPA_Line.cs:799~808 · SCP0104_CAPA_Line_Assign_Model.cs:1057~1066 | edit_expect_manual.csv 의 LINE·SOP_MODEL 행 삭제 | 미확인 |
| 16 | 11-16 16:4x | SCP0104 그리드 편집 기대값 | 자동 해석이 '해석 못 한 잠금'으로 남긴 칸을 AS-IS 잠금 원문을 읽어 139행 수기 사실로 채움(Line Assign: 기존 행 잠금 · 새 행 편집 · Lane 수량과 Active 는 상시 편집 / 전극 새 행 Nickname 잠금) | SCP0104_CAPA_Line_Assign.cs:3949~4060 · 5419~5422 | edit_expect_manual.csv 삭제 · ledger.py.bak_20261116_eemanual | 미확인 |
| 17 | 11-16 16:4x | SCP0104 SOP 탭 검사용 조회 조건 | Division 81_HG 로 조회(SOP 데이터가 81_HG 42행 · 81_ST 22행에만 있음). 새 행 검사는 팝업 안에서 Division 81 후보를 골라 추가(81_HG 후보 27행은 화면 27행과 같아 중복 제외됨) | TO-BE DB 조회 11-16 · 화면 실측 16:5x | sheet_nav.json | 미확인 |
| 18 | 11-16 16:4x | SCP0104 Line Assign 그리드 셀 더블클릭 | 양쪽 모두 더블클릭하면 CAPA Line 찾기 팝업이 열림(Nickname·Model 칸 제외). 검사기는 편집할 때 팝업을 닫고 F2 로 편집 | AS-IS spdAssign_CellDoubleClick · TO-BE CapaLineAssign.tsx:597~604 | nscm.ts.bak_20261116_scp0104p1 | 미확인 |
| 19 | 11-16 18:1x | SCP0104 저장 시험이 남긴 수정자·수정일시 | 되돌리지 않고 둠. 전극 라인 1개(Div 81 · DMY_3801 · APCAN2364C)의 기간 행 29건과 모델 행 1건에 수정자 minyonglee1, 수정일시 11-16 17:19~17:24 가 남음. 수량·우선순위·Active 값은 시험 전과 같음(저장 직전 기록·09-27 백업·9월 마감본과 대조). 자동 복원은 DB 과거 시점 조회 한계(15분)로 실패 | restore_touched 로그 · DB 조회 18:1x | 09-27 백업 표의 수정자·수정일시로 덮어쓰기(그 뒤 변경 여부는 알 수 없음) | 미확인. 수정자·수정일시를 09-27 백업 값으로 되돌릴지 결정 필요 · 추가(11-17 04:5x 대조): 2행 동시 저장 시험이 다른 행(r240)도 저장해 수정자·수정일시만 바뀐 행이 배정 87·모델 3 으로 늘어남. 값 변경 0 · 새 행 0 · 사라진 행 0(보관본 18:38:34 대조) |
| 20 | 11-16 19:0x | SCP0104 대응표(__asis-mapping__.md) 요약 행 3건(콤보 D01~D10 · 그리드 G01~G48 · 버튼 가드 B01~B38) | 대상 없음 처리. 대응표에 ID 별 열거가 없음(D 8개 · G 45개 미열거 · B 는 범위 표기와 건수 불일치). 기능 판정은 검사기가 AS-IS 원문에서 직접 뽑은 컬럼·진입점 행이 가짐 | 조사 결과 Doc/verify/SCP0104/_static_out_doc.csv | static_verdicts.csv 해당 3행 삭제 | 미확인. 대응표 문서를 ID 단위로 보완할지 결정 필요(기능 오류는 아님) |
| 21 | 11-16 19:0x | SCP0104 사용자별 컬럼 숨김의 조회·편집 상태별 폭 처리(대응표 6-14) | 미판정으로 남김. AS-IS 는 사용자가 숨긴 컬럼을 조회 상태에서 폭 0 으로 접고 편집 상태에서 다시 펼침(AS-IS DB 에 해당 설정 6행 · 사용자 2명). TO-BE 는 조회·편집 상태 구분이 없고 해당 설정 값이 비어 있어 동작하지 않음 | AS-IS SCM_MST_TITLESET_USER ATTRIBUTE3 · 대응표 6-14 '사용자 결정 대기' | - | 미확인. TO-BE 에서 이 동작을 구현 대상으로 볼지 결정 필요 |
| 22 | 11-16 19:0x | SCP0104 SOP 그리드 컬럼 순서 메타(대응표 6-7) | 미판정으로 남김. AS-IS 정렬 번호는 Line Type 150 · SOP 일자 190, TO-BE 는 둘 다 200 으로 같음 | TO-BE·AS-IS SCM_MST_SHEET_COLUMNS 조회 11-16 | - | 미확인. 화면 표시 순서 실측(헤더 스냅샷) 뒤 판정 |
| 23 | 11-16 19:2x | SCP0104 CAPA Line 찾기 팝업·SOP 모델 찾기 팝업을 열 때 메인 화면 조회조건 전달 | 오류 후보로 판정(3행). AS-IS 는 메인 화면에서 고른 Site·Plant·Building·Line(SOP 모델은 Operation·Line Type 포함)을 팝업 조건에 채우고 자동 조회. TO-BE 는 Division(SOP 모델은 버전 포함)만 넘기고 나머지는 전체로 시작 | AS-IS SCP0104_CAPA_Line_Assign.cs:5892~5975 · SCP0104_CAPA_Line.cs:405~437 · TO-BE CapaLineAssign.tsx:875~897 · CapaLineModal.tsx:123~126 | static_verdicts.csv 의 V-73037cda·V-e38e474a·T-79cc3699 를 PASS 로 | 미확인. 공용 검색 팝업 규칙(CR-096: 팝업이 받는 인자만 연동)을 이 화면 전용 팝업에도 적용하면 오류 아님. 적용 여부 결정 필요 |
| 24 | 11-16 19:2x | SCP0104 컬럼 설정 팝업의 버튼 구성(2행) | 미판정으로 남김. AS-IS 버튼은 Default·OK·Cancel, TO-BE 공용 컬럼 설정 팝업은 Default·Save 이고 닫기는 제목 줄 아이콘 | AS-IS SCM002_CAPAColumnPopup.designer.cs:256~267 · TO-BE ColumnLayoutModal.tsx:526·552~568 | - | 미확인. 공용 컬럼 설정 팝업의 버튼 구성을 TO-BE 표준으로 볼지 결정 필요(전 화면 공통) |

> 정정(18:26 · date 실측): 19~24번 일시 칸의 시각은 실측값이 아님. 19~24번은 11-16 18:01(SCP0104 2회차 종료)~18:26 사이에 적음.

| 25 | 11-16 21:42 | SCP0104 배정 시트 저장에서 바뀐 행이 0건일 때 TO-BE 만 ORA-01840 으로 저장 실패 | 오류 후보로 판정(F1 V-24aa4bc5 · F2 V-ea2314b3 FAIL 유지). TO-BE 저장 SP 가 끝에서 검사 SP P_SCP0106_CHK_LOSS_ASGN_ELTR 를 조건 없이 부르고, 검사 SP 는 바뀐 행 표가 비면 버전 값이 NULL 인 채 TO_DATE(V_VERSION || '01') 을 실행함. Oracle 은 NULL || '01' = '01' 이라 ORA-01840. AS-IS 는 같은 자리에서 NULL + '01' = NULL 이라 오류 없이 지나감. ASSEMBLY 쪽 P_SCP0106_CHK_LOSS_ASGN_ASM:1796 도 같은 식 | TO-BE PKG_SCP0104 본문 9176(호출) · 3113~3120 · 1796~1797(사내 DB all_source 11-16 21:3x 조회) · AS-IS SCP0104_SAVE_CAPA_LINE_ASSIGN_ELTR:1748 · SCP0106_CHECK_CAPA_LOSS_PLAN_BY_ASSIGN_ELTR:364~365, 1558~1559 · BE 로그 ORA-01840 6회(17:14·17:24·18:57·19:07·20:45·20:57, 월 값이 전부 빈 저장 요청) | 보완 단계에서 PKG_SCP0104 검사 SP 2개에 V_VERSION 이 NULL 이면 날짜 계산을 건너뛰는 처리 추가 | 미확인. AS-IS 화면 실행으로 같은 입력 저장 성공 여부는 미실측(원문 대조만) · 정정(11-17 04:5x): '바뀐 행 0건이면 V_VERSION NULL' 은 원문을 읽고 세운 추정이고 확정 아님. 같은 ORA-01840 이 Lane Number 빈 값 저장(04:51:08 · 바뀐 행 있음)에서도 남 — 결정 37·40 과 같은 오류로 묶어 원인 위치 미확인으로 둠 |

> 11-16 21:41 저장 시험 흔적 대조(보관본 18:38:34 ↔ 현재): 8개 표 새 행 0 · 사라진 행 0 · 값 변경 0 · 수정일시·수정자만 바뀐 행 30(ELTR_LINE_ASSIGN 29 · ELTR_LINE_MDL 1).
| 26 | 11-16 22:3x | SCP0104 저장 전 키 칸 공란 차단 문구에 라벨 대신 컬럼 ID 표시 | 미판정으로 남김. TO-BE 화면 자체 검증(findDroppedRowKey)이 '[COMPANY_ID] 값은 필수 입력 항목입니다.' 처럼 컬럼 ID 를 넣음. 공용 필수 검증(useSaveWithValidation:89)은 라벨을 넣음. AS-IS 에는 이 검증이 없고 저장 SP 가 키 공란 행을 오류 없이 버림 | TO-BE CapaLineAssign.tsx:545~553 · useCapaLineAssignValidation.ts:24~33 · 신규행 시험 로그 11-16 21:50~22:26 | 보완 단계에서 문구에 컬럼 라벨(colLblNm) 사용 | 미확인. TO-BE 가 추가한 검증이라 AS-IS 대조 기준 없음. 문구 표기를 결함으로 볼지 결정 필요 |
| 27 | 11-16 22:4x | SCP0104 상위 메뉴 'Capa Plan' 권한이 ADMIN 그룹에만 있어 다른 그룹은 메뉴 트리에 SCP0104 가 안 보임 | 오류 후보로 판정(EG382 FAIL 유지). TO-BE SCM_ADM_USER_GR_MNU_MPG_M 에 'Capa Plan' 행은 ADMIN 1개. SCP0104 자체 권한은 8개 그룹(ADMIN, CAPA Planner, FP Planner, FP Viewer, SCM PI Admin, SCM Viewer, SCP Planner, SCP Tester)에 있음. 같은 Supply 아래 다른 폴더(Supply_Plan 등)는 그룹 13~15개에 권한이 있음. AS-IS TB_FX_GroupMenuAuth 는 폴더 행 없이 화면 행만으로 트리를 보여 줌. 'Capa Plan' 아래 화면 6개(SCP0104~0108, SCP0114) 모두 해당 | 사내 DB 11-16 22:4x 조회 · eg/auth/e2e.json EG382 8건(ADMIN 만 PASS) | 보완 단계에서 'Capa Plan' 폴더 권한을 SCP0104 권한 보유 그룹에 추가(메타 데이터) | 미확인. 폴더 권한 등록 기준(하위 화면 권한 그룹 합집합)을 정할 필요 |
| 28 | 11-16 22:4x | SCP0104 CAPA Planner 그룹에 EDIT 버튼 권한 행이 없음 | 오류 후보로 판정(측정 계정 없음, 정적 대조). AS-IS TB_FX_GroupMenuAuth CAPA Planner = C·R·U·D 모두 True. TO-BE SCM_ADM_USER_GR_MNU_BTN_MPG_M CAPA Planner = INSERT·SAVE·DELETE·SEARCH Y, EDIT 행 없음. TO-BE 화면은 canEdit = hasButton('EDIT') 이고 Insert 도 canEdit 조건이라 이 그룹은 편집·Insert 불가 | TO-BE CapaLineAssign.tsx:124·571 · 사내 DB 11-16 22:4x 조회 | 보완 단계에서 CAPA Planner EDIT 권한 행 추가(시트 ASSEMBLY·ELTR·SOP_ASSEMBLY·SOP_ELTR) | 미확인. 화면 실측은 CAPA Planner 계정이 명부에 없어 미실행 |
| 29 | 11-16 23:3x | SCP0104 Line Type 후보 정렬 기준이 콤보 SQL 반환 순서에 기댐 | 현재 결과는 AS-IS 와 같아 PASS(V-1d6aa69b). 같은 코드가 순번 2개(예 Div 81 Anode 115001·117401)인데 TO-BE 는 처음 나온 행의 순번을 씀. 콤보 OperationElectrodeType_SCP_ALL 에 ORDER BY 없음 | TO-BE useCapaLineCascade.ts:262~272 · combo_sql.csv · AS-IS cs:1726~1728 | 보완 단계에서 콤보 SQL 에 ORDER BY DISPLAY_SEQ 추가하거나 코드별 최소 순번 사용 | 미확인. 결과가 같은 지금 보완할지 결정 필요 |
| 30 | 11-16 23:4x | SCP0104 ELTR 시트 조회조건 Material 이 NICK_NAME 으로 걸러 Model ID 로 조회하면 0행 | 오류 후보로 판정(G1·G2·G8·G9 4행 FAIL · 정적). AS-IS ELTR 조회 SP 는 ITEM_ID IN(SCP0104_GET_CAPA_LINE_ASSIGN_ELTR:720·802). TO-BE 는 UPPER(NICK_NAME) IN(PKG_SCP0104 6267~6270). ELTR 배정 22,359행 NICK_NAME 전부 '-' | 사내 DB all_source·데이터 11-16 23:4x · AS-IS OBJECT_DEFINITION | 보완 단계에서 ELTR 조회 비교 컬럼을 ITEM_ID 로(대소문자 무시 유지) · 같은 PKG 의 엑셀·제목용 같은 식 함께 | 화면 실측 미실행(5회차 G8·G9 결과로 확인 예정) |
| 31 | 11-16 23:4x | SCP0104 ASSEMBLY 시트 조회조건 Material 이 AS-IS 정확 일치 → TO-BE 부분 일치 | 미판정으로 남김. AS-IS NICK_NAME IN(SCP0104_GET_CAPA_LINE_ASSIGN_ASSEMBLY:405·477). TO-BE UPPER(ITEM_ID) LIKE 또는 UPPER(NICK_NAME) LIKE(PKG_SCP0104 5619~5628 · '2026.10.07 AJS Model/Nickname 검색' 주석). 11-13 기준 'LIKE 는 AS-IS 가 LIKE 일 때만'과 다름 | 사내 DB all_source 11-16 23:4x | 보완 또는 TO-BE 룰 등록 중 결정 필요 | 미확인. 10-07 변경이 요청에 따른 변경인지 확인 필요 |
| 32 | 11-16 23:3x | SCP0104 Dummy 코드 채번에서 대소문자만 다른 이름을 TO-BE 는 새 코드로 만듦 | 오류 후보로 판정(A7 V-65c8f9a7 FAIL · 정적). AS-IS SCP_MST_CAPA_DUMMY_CODE.NAME 정렬 규칙 Latin1_General_CI_AS 라 MERGE 이름 비교가 대소문자 무시. TO-BE NOT EXISTS(A.NAME = V_NAME) 는 대소문자 구분(PKG_SCP0104 4740~4761) | AS-IS 개발 DB 정렬 규칙·사내 DB all_source 11-16 23:3x | 보완 단계에서 이름 비교를 UPPER 양쪽으로, 반환 조회(WHERE NAME = V_NAME)도 같이 | 미확인. AS-IS 운영 DB 정렬 규칙은 개발 DB 로만 확인 |
| 33 | 11-16 23:4x | SCP0104 화면 기능 밖 행 3건을 NA 로 둠 | 'Home / Auth Request 메뉴'(V-fd20668f)·무권한 첫 화면(EG-db0867cb) = 공통 셸 기능, 사용자 칸 설정 이관 건수(EG-fe725c3e) = 이관 데이터(AS-IS 접속이 개발 DB) | static_verdicts.csv 3행 | 공통 기능·이관 검증으로 넘김 | 미확인. 무권한 첫 화면 측정에 GUEST 전용 계정을 만들지 결정 필요 |
| 34 | 11-16 23:5x | SSP0020 스냅샷 골든 승격 5건(조회조건·버튼·팝업·화면샷 2) · 헤더 2건은 FAIL | 헤더 2건은 'Valid' 잔존(CR-092 미반영 · V-d1f0e5dc)과 같은 결함이라 골든으로 올리지 않고 FAIL. 화면샷 기준본에도 Valid 가 찍혀 있어 보완 뒤 화면샷 재승인 필요. 조회조건 'All' 누락 = Division 칸 전체 선택으로 이동(T-08875613), 버튼 USER_CHECK 누락 = 버튼 아님 | snap_validate.csv 11-16 23:5x | 보완 단계에서 메타 VALID 라벨 Active 로 · 화면샷 재승인 | 미확인. 골든 승인은 검증엔진 세션 임시 승인(--no-verdict) |
| 35 | 11-16 23:5x | 메뉴 권한 없는 계정이 URL 로 화면을 열 수 있음(SSP0020 실측, 전 화면 공통) | 오류 후보로 판정(EG-f6eeda7b FAIL · 공통 셸). SSP Viewer 계정 SSP0020 메뉴 권한 없음 → URL 직접 접근 authorized=true. AS-IS 는 메뉴 트리에 있는 화면만 열림 | eg_auth 10회차 실측 · _engine_gap.csv GAPSELF-22·DM-65 | 보완 단계에서 FE 라우트 가드(메뉴 권한 없는 경로 차단) — 공통 기능 | 미확인. 저장 버튼 권한은 BE PR_CHECK_MNU_BTN_AUTH 가 따로 검사함(BE 로그 확인), 조회 차단 여부 결정 필요 |
| 36 | 11-17 00:0x | SSP0020 저장하는 동안 로딩 표시 없음(시험 검사 CM-003) | 판정필요 유지(V-9e99f124). 저장 응답을 1,500ms 늦춘 실측에서 로딩 표시가 보이지 않음. AS-IS 는 저장 동안 진행 창 표시(SSP0020_Delegate.cs:482~483 ProgressForm.Show → 응답 뒤 Close). TO-BE Delegate.tsx 저장은 apiClient.post 직접 호출이고 로딩 상태 처리 없음 | 10회차 폼 저장형 시나리오 F09 · AS-IS·TO-BE 원문 | 보완 단계에서 저장 중 로딩 표시 추가 | 미확인. 시험 검사 CM-003 을 확정 검사로 올릴지(FAIL 승격) 결정 필요 · SCP0104(V-ab913b0f) 도 같은 검사에서 0회. 다만 SCP0104 는 저장 중 ProgressIndicator(CapaLineAssign.tsx:989 open={saving} · MUI CircularProgress role=progressbar)를 띄우는 코드가 있어 검사기 측정 방식 확인 필요(11-17 00:5x) · 정정(11-17 01:2x): SSP0020 11회차에서는 같은 시나리오가 '로딩 표시 보임' PASS(V-9e99f124). 10회차 0회 ↔ 11회차 보임으로 측정이 회차마다 다름 — 'TO-BE 저장 로딩 처리 없음'은 확정 사실 아님(apiClient 공통 로딩 여부 미확인). 결정 내용 = 시험 검사 CM-003 의 측정 안정성 확인 필요 |
| 37 | 11-17 00:3x | SCP0104 기간 값이 모두 빈 ELTR 행에 연도 칸(Y_2031)만 넣고 저장하면 ORA-01840 | 오류 후보로 판정(F1 V-cc74e5aa FAIL). 3·4·5회차 매회 재현(BE 로그 17:24·19:07·20:57·23:4x). 대상 행 = Div 81 · FP_E6M02_A · A7, 기간 행 29개 모두 우선순위 0 · Active N. 원인 위치는 원문 대조로 확정 못 함(연도 행 날짜 계산은 4자리 분기 있음 · STRING_SPLIT 빈 칸 유지 확인) | BE 로그 · 사내 DB 조회 11-17 00:3x | 보완 단계에서 DEBUG 로 SP 단계별 실행해 원인 확정 뒤 수정 | 미확인. AS-IS 에서 같은 입력 저장 결과는 미실측 · 추가(11-17 04:5x): 같은 오류 재현 조건 3가지 = 기간 값 전부 빈 행 수정 저장 · 그 행에 Y_2031 만 입력 · Lane Number 빈 값 저장(결정 40). 0 을 넣은 저장(04:50:42)은 정상 |
| 38 | 11-17 00:3x | SCP0104 Nickname·Model 칸에 목록 밖 이름을 넣어 Dummy 코드를 만드는 기능이 TO-BE 에서 동작하지 않음 | 오류 후보로 판정(T-228fc738 FAIL · 화면 재현). AS-IS 는 목록 밖 이름이면 DMY_ 코드 채번(cs:3658~3688). TO-BE 는 셀 후보 목록 밖 값을 받지 않아 채번 호출 0건. 채번 유틸(capaLineAssign.dummyCode.ts)은 있으나 도달 경로가 막힘 | 화면 재현 11-16 18:25 · BE 로그 호출 0건 | 보완 단계에서 Nickname(ASSEMBLY)·Model(ELTR) 셀이 후보 밖 값을 받도록(DataMap isEditable) | 미확인 |
| 39 | 11-17 00:3x | SCP0104 상위 칸(Site 등) 편집을 값 변경 없이 끝내도 하위 칸이 지워짐 | 오류 후보로 판정(화면 재현). 신규 행 Site 칸 F2 → Esc 또는 Enter → Company~Line 8칸 빈 값. TO-BE CapaLineAssignGrid.tsx:184~195 cellEditEnded 가 변경 여부를 보지 않고 하위 칸 비움. AS-IS 는 값이 바뀔 때만(Change 이벤트) 비움 | 화면 재현 11-16 18:25 · 신규행 시험 22:14 에서도 같은 현상 | 보완 단계에서 값이 바뀐 경우에만 하위 칸 비움 | 미확인 |

| 40 | 11-17 04:5x | SCP0104 ELTR 배정에서 Lane Number 를 빈 칸으로 저장하면 ORA-01840 | 오류 후보로 판정(F6 빈값 저장 V-34ccc111 FAIL · 실측). 04:51:08 저장 요청 p_lane_qty '' → RESULT_CODE F · ORA-01840. 같은 행에 0 을 넣은 저장(04:50:42)은 정상. AS-IS 결과는 미실측 | BE 로그 SCM_COM_SQL_LOG 04:51:08 · 저장 세부 단독 실행 04:41~04:54 | 결정 25·37 과 같은 오류 — 보완 단계에서 DEBUG 로 원인 확정 | 미확인. AS-IS 빈 값 저장 결과 미실측 |
## 사용자 확정 (11-17 07:56)
일괄 질의(Doc/verify/_TWO_SCREENS_QUESTIONS.html) 28문항에 사용자 답 '권장안대로 확정'(11-17 07:39 수신).
| 문항 | 결정 번호 | 확정 내용 | 반영 |
|---|---|---|---|
| Q1·Q2·Q3 | 1·9·10 | 같은 기능 인정 · 대상 없음 인정 | 판정 변경 없음 |
| Q4 | 35 | 주소 직접 접근 = 오류 | FAIL 유지 · 보완 단계 |
| Q5 | 36 | 검사 보완 뒤 판정 | _verify.spec.ts 저장 로딩 검사의 보이는 요소 판정을 offsetParent → 크기·visibility·opacity + MutationObserver 로 변경. 07:47 단독 실행에서 SCP0104 로딩 표시 34회 관측 → V-ab913b0f PASS |
| Q6 | 14 | 메타 기준 유지 | 판정 변경 없음 |
| Q7 | 19 | 수정자·수정일시 그대로 둠 | 데이터 변경 없음 |
| Q8 | 21 | 구현 대상 아님 | TO-BE 룰 CR-107 등록 · T-a8e20ad5 NA |
| Q9·Q10·Q12~Q16·Q18~Q24·Q26 | 22·23·26~30·32·38·39·25·37·40·2, T-9f1114a7, T-4ae38c68, T-750f3c40 | 오류로 판정 · 보완 대상 | FAIL 유지 · 보완 단계 |
| Q11 | 24 | TO-BE 표준 인정 | TO-BE 룰 CR-106 등록 |
| Q25 | T-fbb27c4d | TO-BE 동작 인정 | TO-BE 룰 CR-108 등록 · PASS |
| Q17 | 31 | 권장안이 '확인 필요'(10-07 변경이 요청에 따른 것인지) | 11-17 08:22 사용자 답 '요청 변경 인정' → TO-BE 룰 CR-109 등록(ASSEMBLY 시트 부분 일치 · 11-13 LIKE 기준의 예외). CR-109 확정 행 V-6a37ba39 PASS. V-a09892ce 는 ELTR 근거(결정 30)로 FAIL 유지 |
| Q27 | 33 | GUEST 측정 계정 생성 | 미실행 · 계정 생성은 비밀번호 설정이 필요해 사용자 작업 |
| Q28 | 6·7·8·15~18·20 | 검증 규칙 그대로 인정 | 판정 변경 없음 |
static_verdicts.csv 의 '[권장안 적용' 8행 문구를 '[사용자 확정 11-17 · 권장안' 으로 바꿈. 백업 static_verdicts.csv.bak_20261117_confirm · confirmed_requirements.csv.bak_20261117_cr106.

## 사용자의견 반영 (11-17 10:17)
SCP0104 CheckList v22 사용자의견 12건, SSP0020 3번 사용자 확인.
| 행 | 사용자의견 | 처리 |
|---|---|---|
| SCP0104 1 V-e44a626b | 폭 0 은 미표시, 오류 아님 | PASS. _trace.spec.ts A5 가 AS-IS 메타 COLUMN_WIDTH 0 을 숨김으로 봄 |
| SCP0104 2 V-8c0651f6 외 3행 | ORA-01840 오류 맞음, DB 수정 | PKG_SCP0104 보완 09:44·09:47(Loss Plan 빈 버전 · SPLIT_CLOB 빈 값). 직접 호출 4건 F → S |
| SCP0104 4 V-cc74e5aa | 확인 필요 | 불일치 1건 = Y_2031 저장 ORA-01840(결정 37). 같은 보완 대상. 증거 문장이 900자에서 잘려 불일치 항목을 앞에 오게 수정 |
| SCP0104 6 V-65c8f9a7 | 대소문자 무시는 TO-BE 룰, 필요하면 DB 수정 | P_SCP0104_CHECK_NAME_ON_DUMMY_CODE UPPER 비교 2곳 |
| SCP0104 7 V-f5a0b46a | AS-IS·TO-BE 같게 나옴, 오류면 조건 명시 | FAIL 유지. 조건: Operation group = Electrode, Div 81, Plant 후보 AS-IS 7건 / TO-BE 8건(MI03 추가). Cell·Module/Pack 은 7/7 같음 |
| SCP0104 8 V-8fba19fc | 오류 맞음, DB 수정 | ELTR Material ITEM_ID 비교 2곳 |
| SCP0104 9·10 | 어느 팝업인지 | 9 = Line Assign 탭 CAPA Line 선택 팝업(ShowLine), 10 = SOP 탭 New 모델 배정 팝업(ShowSopAssignModel). 설명 정리 파일에 위치 기재 |
| SCP0104 11 V-c55acf31 | 총 건수는 TO-BE 일반과 같으면 오류 아님 | TO-BE 룰 CR-110 등록, _trace.spec.ts 가 공용 건수 영역(Total N rows) 확인 |
| SCP0104 12 V-24ff60ab | TO-BE 설정 권한과 일치하면 오류 아님 | Capa Plan 폴더 권한 7행 추가 뒤 메뉴 트리 9건 PASS. CAPA Planner EDIT 는 TO-BE 설정과 동작 일치 → PASS. 결정 28(Q14 오류) 은 이 의견으로 대체 |
| SCP0104 14·15 | 오류 맞음, DB 수정 | 품목 팝업 다중 선택은 화면(FE) 동작이라 DB 객체로 고칠 수 없음. FE 가이드로 남김 |
| SSP0020 3 EG-f6eeda7b | 권한 없는 사용자 URL 진입 시 화면 안 열림 | PASS. 새 세션 실측 10:02 /view/home · 그리드 0. 11-16 FAIL 은 계정 순회가 앞 계정 탭 목록(MDI-store)을 물려받은 검사기 오판. 결정 35(Q4 오류) 대체 |

## 칸 설정 자동 생성 (11-17 13:03)
| 항목 | 사용자 답 | 처리 |
|---|---|---|
| SCP0104 첫 진입 때 SCM_MST_TITLESET_USER 87행 자동 생성 | TO-BE 동작 인정 | TO-BE 룰 CR-111 등록. CheckList 비PASS 행 중 해당 행 0건이라 판정 변경 없음. 시험으로 생긴 261행 삭제는 그대로 둠 |

## 클라우드 반영 (2026-11-17 13:07)
- SCP0104_USERFIX_CLOUD_20261117 사용자 적용 완료 보고. 클라우드 검증 결과 미확인.

## SCP0104 v27 조치 필요 사용자의견 처리 (11-17 13:5x)
| 조치 No | 검증 ID | 사용자의견 | 처리 |
|---|---|---|---|
| 1 | V-73037cda | AS-IS 도 동일 · 오류 아님 | FAIL 유지. AS-IS 런처 실측 13:39: 메인 Site ALL 79행, A001 선택 17행. TO-BE 팝업은 항상 ALL 시작. 메인 조건 ALL 일 때만 같음 → 재확인 요청 |
| 2 | V-e38e474a | AS-IS 도 동일 · 오류 아님 | FAIL 유지. AS-IS 런처 실측: 메인 Site ALL 50행, A001 선택 2행 → 재확인 요청 |
| 3 | T-f3de1469 | 오류 맞음 | 유지 |
| 4 | T-bc2f6848 | DB 객체에서 '-' 누락 사유 찾아 보완 | DB 원천에는 '-' 있음. FE 코드가 제외(gridCombos.ts:51 외 4곳) → DB 보완 불가, FE 가이드 |
| 5 | T-750f3c40 | TO-BE 도 확인창 동작 | 검사기 결함: 대조표 '미구현' 기록만 봄. judge.py UC02_CODE_PASS 추가(공용 SearchArea.tsx:205, SubTitle.tsx:267 확인창 실재 확인) → PASS. 정적 판정 행 삭제 |
| 6 | T-6c0c417e | 붙여넣기 잘 됨 | FAIL 유지. TO-BE 실측: Site Name 직접 입력 → Site 코드 채움, 붙여넣기 → 빈 값. 값 자체는 들어감 → 재확인 요청 |
| 7 | T-228fc738 | 이해 안 됨 | 설명 다시 작성(등록 전 모델명 직접 입력 → AS-IS 임시 코드 생성) |
| 8, 9, 12, 13 | | 의견 없음 | 유지 |
| 10 | T-25489c40 | 동일 동작으로 보임 | FAIL 유지. 추가 행 기간 칸, Active 를 먼저 바꾼 뒤 품목 선택할 때만 다름 → 재확인 요청 |
| 11 | T-261e9e8e | 이해 안 됨 | 설명 다시 작성(Site Name 후보 순서 예시) |
| 14 | T-dba78bc7 | AS-IS 도 동일 · 오류 아님 | 검사기 결함: AS-IS 가 콤보 아닌 화면에 '내 Division 콤보'(D00-3-009) 기대 적용. _trace.spec.ts 에서 AS-IS 콤보 선언 화면만 적용 → PASS |
| SOP 탭 | | 오류 내역 없음 질문 | 측정 못 함. ensureRows 가 Division 앞 3개만 시도해 81_ST, 81_HG 미도달. smoke-extra.ts 전 후보 순회로 보완 후 재검증 |
설명 첫 줄 오류명 앞 '○ '(make_verify_docs.py, plain_detail.py).
설명 첫 줄 형식 '[위치 / 성격 / 수정 대상] 오류명'(11-17 사용자 지시). 위치 = 조회조건, 그리드 컬럼, 팝업, 버튼, 저장, 메뉴·권한, 화면 공통. 성격 = 후보값, CASCADE, 기본값, 입력 제어, 로직, 순서, 표시, 성능, DB 객체. 수정 대상 = FE, DB, FE+DB, 공통 FE, 확인 필요. 정리 파일 tag 칸 우선, 없으면 make_verify_docs._tag_auto(규칙·대상·증거).
조치 필요 나열 순서(11-17 사용자 지시) = 화면 배치 위 → 아래, 왼쪽 → 오른쪽: 메뉴·권한 → 조회조건(화면 순) → 버튼 → 그리드 컬럼(탭 순 → 컬럼 SORT_ORDER_NO 순) → 팝업 → 저장 → 화면 공통. DB-SYN(테스트 차단)은 1번 유지. make_verify_docs._screen_key. 'SQL 오류 맨 뒤' 지시는 사용자가 철회.
action_summary.csv 쉼표 미인용으로 칸 밀림 7행(11-17 오전 v27 설명에 영향) → 9칸으로 다시 작성.
| 7(재) | T-228fc738, T-dacd5310 | 11-17 15:5x '오류로 판정' | FAIL 확정. AS-IS 입력 즉시 DMY_ 코드 생성 + Dummy=Y 저장, TO-BE 목록 밖 입력 차단(실측 15:27) |
| 6(재) | 붙여넣기 묶음 10행 | 11-17 '오류 아님' 2회 | PASS. 범위 붙여넣기 실측 정상, 1칸 명칭 붙여넣기 코드 빈 값은 사용자 판단으로 오류 아님 |
| 10(재) | T-25489c40 | 11-17 16:1x '오류로 판정' | FAIL 확정(_user_verdicts_direct.csv). regress.py 가 직접 판정을 CheckList 옛 의견보다 우선하도록 보완 |

## SOP 탭 실측 (11-17 19:36 v46)
- 데이터 조건(sheet_data_cond.json 15:53): SOP_ASSEMBLY 81_HG 27·81_ST 12, SOP_ELTR 81_HG 6·81_ST 6, 그 밖 Division 0. 새 행 조건 Div 81(SOP 행 0, 팝업 미배정 모델 ELTR 50·ASSEMBLY 168) → sheet_nav.json new_row_cond.
- 검사기 보완: 시나리오 근거 시트로 이동(_verify.spec.ts) · Insert 선택 팝업 확정(첫·마지막·가운데) · 신규 행 미생성 시 측정 경로 없음 · 새 행 조건 시 ensureRows 생략 · 감사 컬럼 날짜 칸 제외(gen_expect.py) · 달력 입력 단계 차단 = 기대 충족(scenario.ts).
- 결과: V-120002fd·V-aa928a0d·V-18b4a0c6 PASS(Div 81 새 행 실측), V-912ca6bd PASS(입력 단계 차단), V-e3504cd4 정적 PASS(데이터 조건상 재현 불가 · V-120002fd 연결), V-cc6cf8fa NA.
- 미해결: --only 실행 뒤 ASIS_DIFF 180행 원장 소실(원인 미확인) → --only 뒤 --skip-e2e 재판정으로 복원.
- AS-IS 런처 SOP 실측(11-17 19:48~19:50, asis_live_scen_run.py --division sheet:SOP_ELTR,sheet:SOP_ASSEMBLY): SOP_ELTR 81_ST AS-IS 6 = TO-BE 6. SOP_ASSEMBLY 81_HG AS-IS 36, TO-BE 27 → 차이 9행 = Line Type '-' 행(AS-IS SP 에서 '-' 빼면 27). 조치 필요 2번(T-bc2f6848) 영향으로 설명 추가.
- 부분 실행 ASIS_DIFF 소실은 v36 1회만(이후 --only 4회 정상, 180~184행). 원인 미확인.

## SSP0020 시험 잔존 위임 행 삭제 (11-17 21:37, 사용자 승인 '백업 후 삭제')
- TO-BE 사내 SSP_MST_DELEGATE: CREATED_BY·USER_ID minyonglee1, VALID_YN N, DELEGATEE_ID jiangguoping·jinqianhuanj, CREATION_DATE ≥ 11-10 → 535행 삭제(1,234 → 699행). 백업 Doc/verify/SSP0020/applied/SSP_MST_DELEGATE_test_residue_deleted_20261117_213753.csv.
- 원인: SSP0020 저장 시험(실행 1회 26행)이 위임 생성 뒤 해제(N)만 하고 행을 지우지 않음 — 시험 정리 단계(restore_touched) 결함, 미보완.
- SSP0020 v40(21:32): FAIL 7 · 판정필요 1(V-22b7adc8 로딩 표시 시험 검사) · 미검증 1(V-7c0fa6e6 LAST_UPDATED_BY 폭 메타 100 / 화면 150, 사람 판정 대상).

## 2026-11-18 08:14 SSP0020 v51 (I2 재측정 · K3 연결 허위 FAIL 보완)
- I2 언어 전환 EG-0e8e3e72·EG-152a8aa6: 다른 화면 E2E 잠금이 빈 뒤 `--only I2` 재측정(08:08) → PASS(KO 10건·EN 11건 일치).
- K3 4행(V-edf7d866·V-b7b32337·V-de1d21a6·V-e04faf92) 허위 FAIL: judge.py K3 '미포함 항목' 연결(11-18 추가분)이 정적 판정 반영 전 원 판정(EG-5f17da99 FAIL, eg 팝업 GRID_FILTER_COUNT FAIL)을 읽음. 연결 대상 판정을 static_verdicts 반영값으로 읽도록 judge.py `_k3_eff`·`_k3_pop_fail` 추가 → 4행 PASS.
- 결과 v51: FAIL 7(MSG00219 3, Valid 라벨 2, 집계 2) · 판정필요 1(V-9e99f124 H11 시험 검사) · 미검증 0 · regress 위반 0.

## 2026-11-18 09:08 SSP0020 v52 (H11 사용자 판정 FAIL)
- V-9e99f124 저장 중 로딩 표시 없음: 사용자 판정 '오류로 판정해주세요' → `_user_verdicts_direct.csv` FAIL 기록. 근거 AS-IS SaveData ProgressForm(cs:482~483·517·524), UnSet(cs:582·586), TO-BE Delegate.tsx 249·343 저장·해제 호출에 로딩 표시 없음.
- FE 가이드 `Doc/verify/SSP0020/FE_GUIDE_20261118_0910.md`(DB MODE · FE 미수정).
- 결과 v52: FAIL 8 · 판정필요 0 · 미검증 0 · regress 위반 0.

## 2026-11-18 09:55 SSP0020 v53 (헤더 Valid FAIL 해소 · MSG00219 FE 가이드)
- V-db5fae91·V-52d828e2: 11-16 23:00 수신본 'Valid' 기준 정적 FAIL 이 남아 있었음. 11-17 22:46 수신본 헤더 2건 'Active', snap_validate 11-18 OK → static_verdicts PASS 로 갱신(백업 .bak_20261118_a5) · 헤더 골든 2건 임시 승인(--no-verdict, 결정 34 '보완 뒤 승인' 이행). 화면샷 골든(11-17 00:57)은 재승인 안 함, 비교 PASS 유지.
- MSG00219 3행: 사내 SCM_ADM_MSG_M 에 MSG00219 없음(09:45 조회). AS-IS MSG00219 문구 = TO-BE MSG01230 문구. 메시지 표 규칙(같은 문구 코드 재사용)에 따라 DB 신규 등록 안 함 → FE 가이드 G2(PERIOD_REVERSED MSG00219 → MSG01230).
- 결과 v53: FAIL 6(H11 1 · MSG00219 3 · 집계 2, 전부 FE 수정 대상) · 판정필요 0 · 미검증 0 · regress 위반 0.

## 2026-11-18 10:30 SCP0104 보완 단계 (DB 보완 대상 없음 · FE 가이드 13항목)
- FAIL 195 = 조치 필요 묶음 10건 + 연결 109 + 집계 55 + 같은 결함 다른 칸 13. DB 원인 ORA-01840(V-8c0651f6)은 11-17 보완 뒤 PASS. 남은 원인 전부 FE → DB MODE 라 `Doc/verify/SCP0104/FE_GUIDE_20261118_1030.md`(G1~G10 수정, G11~G13 원장 PASS 라 수정 안 함 · 문장 규칙 위반 0).
- 사용자 재확인 필요 2건: G1 조회조건 Plant(V-f5a0b46a 사용자 PASS ↔ 그리드 T-96d7cbbb FAIL, Electrode·Div 81·MI03 조건에서 AS-IS 7 / TO-BE 8), G10 팝업 메인 조건 전달(V-e38e474a·V-73037cda 사용자 PASS ↔ T-79cc3699 FAIL).

## 2026-11-18 11:01 SCP0104 v50 (G1·G10 사용자 판정 FAIL)
- 사용자 답 '둘 다 오류' → _user_verdicts_direct.csv FAIL 3행(V-f5a0b46a, V-e38e474a, V-73037cda). 집계 행 12건이 따라 FAIL.
- 10:24 재판정에서 H4 T-333db77e 가 '검사 조건 바뀐 뒤 미재실행' ERROR(다른 세션의 검사 변경) → `--only H4`(10:32~10:49) 재측정 PASS → `--skip-e2e`(10:49~11:01).
- 결과 v50: 3,342행 · FAIL 210 · 판정필요 0 · 미검증 0 · regress 위반 0. v47 대비 NA 행 5 줄고 NA→PASS 48(다른 세션 엔진 변경분, 원인 행별 미대조).
- FE 가이드 G1·G10 원장 상태 문구 갱신(문장 규칙 위반 0).

## 2026-11-18 11:3x CheckList '미검증' 시트 행(보류)
- 원장 ERROR·판정필요 0 이지만 CheckList '미검증' 시트에 NA 이면서 직접 실측 없는 행이 SCP0104 v50 467건(직접 실측 없음 367 · 대상 일치 요소 없음 50 · 기타 50), SSP0020 v53 401건(직접 실측 없음 371). 앞선 '미검증 0' 보고 정정.
- 사용자 답 '지금은 두기' → 재분류(측정 대상 ↔ 근거 있는 NA) 미착수.

## 2026-11-18 11:52 용어 '대조표' → 'GAP' · SSP0020 CheckList 문구 정리 · 테스트 Excel 재생성
- 사용자: '대조표' 는 일반 사용자에게 낯섦 → AS-IS↔TO-BE 대조 의미라 'GAP'. 문서 저장 직전 정리(tools/Docs/doc_style.py PLAIN_TERMS · clean_workbook)와 테스트 Excel 생성기(make_ui_test_sheet.py _AREA_PLAIN)에서 바꿈. 원장·검사 엔진 원문은 그대로. 따옴표 안 인용은 그대로.
- SSP0020 Doc/verify/SSP0020/action_summary.csv 신설(SCP0104 형식, 2묶음 4행) → CheckList v55 조치 필요 2건 '[위치 / 성격 / 수정 대상] 오류명' 형식. '대조표' 잔존 0.
- 테스트 Excel 재생성: SCP0104 11행(11:41), SSP0020 2행(11:52 · 이전 파일 18행은 ui_test_backup/…_20261118_115220_재생성전.xlsx).

## 2026-11-25 02:2x SCP0028 미검증 해소 라운드 1 권장안 진행
| 항목 | 선택 | 근거 | 되돌리는 방법 | 사용자 확인 |
|---|---|---|---|---|
| 계정 지정 시나리오의 언어 전환 대기 범위(T530) | 같은 계정으로 로그인한 다른 실행이 있을 때만 대기. 언어를 바꾸는 동안 같은 계정 로그인은 최대 180초 기다림 | 언어 설정은 SCM_ADM_USER_M.LANG_CD 계정별 값(tools/E2E/lib/langacct.ts:3) | tools/E2E/lib/langacct.ts, nscm.ts, Doc/e2e/specs/_verify.spec.ts 의 .bak_20261125_scp28u8 로 되돌림 | 미확인 |
| 팝업 클래스 경유 AS-IS SP 를 차등 짝·정렬 규칙 대상에 넣음(T529) | 화면 본체가 new 로 연 06.UIL 클래스 원문에 FoxDataRequest 가 있는 SP 만 | GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0028_Shipment_Lot_Size/SCP0028_Shipment_Lot_Size.cs:270, GSCM/06.UIL/GSCM.SCM.Popup.UIL/SCM0002_ShipmentLotSizePopup.cs:284 | gen_param_map.py, facts_sortrules.py 의 .bak_20261125_scp28u8 | 미확인 |

## 2026-11-25 02:5x SSP0014 미검증 해소 라운드 1 권장안 진행
| 항목 | 선택 | 근거 | 되돌리는 방법 | 사용자 확인 |
|---|---|---|---|---|
| PKG 본문 선언부 Program ID 를 차등 짝 근거로 씀(T532) | PROCEDURE 의 IS ~ 첫 BEGIN 사이 머리말만. PROC 이름과 같은 AS-IS SP 가 있으면 버림 | PKG_SSP0014 본문 127·429행. 전 PKG 144개 대조에서 기존 짝과 다른 짝 0 | pkg_asis_map.py 의 T532 블록 삭제 · sp_pair.csv.bak_20261125_ssp14u 복원 | 미확인 |
| 차등 ORDER 를 정적 정렬 검사 NA 에 맞춤(T533) | 양쪽 ORDER BY 없음 + sort_check NA 면 순서 대조 NA(근거 문구) | CR-075 ③ · dbo.SSP0014_GET_USER_ID_CHECK.sql:22~28 | diff_ingest.py order_na 호출 삭제 | 미확인 |
| 저장 시험 행 식별에서 연동 이름 칸 제외(T534) | '<칸>_*' 와 '<칸 줄기>_NAME·_NM·_DESC' | results.json USER_NAME '이련'→'육평' | rowlink.ts 사용 3곳을 [b] 로 되돌림 | 미확인 |
| user_id 인자가 LIKE 검색어면 같은 사용자 재실행 NA(T536) | TITLESET_USER 참조 없음 + 선언·빈 값·LIKE 사용만 | dbo.SSP0014_GET_SHIPMENT_MODEL_PIC.sql:86~88 | a1_live.py srch 분기 삭제 | 미확인 |
| 하드코딩 콤보 항목 철자 차이 대응(T537) | 2자 이내·4자 이상·유일할 때만 같은 코드 | SSP0014_ShipmentModelPIC.cs:183~187 | combo_oracle.py T537 블록 삭제 | 미확인 |

## 2026-11-25 06:1x SCP0005 미검증 해소 라운드 4 권장안 진행
| 항목 | 선택 | 근거 | 되돌리는 방법 | 사용자 확인 |
|---|---|---|---|---|
| 후보 밖 붙여넣기 전제 없음(T562) | 칸 전체 후보 밖 값 또는 합성 토큰을 붙여넣고 TO-BE 결과만 기록, 판정은 ERROR 유지 | 8076행 중 후보 밖 값 행 0 · SpreadInfo.cs:521 · 화면 cs 붙여넣기 처리 0건 | _verify.spec.ts T562 블록 되돌림(.bak_20261125_scp05u4) | 미확인 |
| 원복 실패 칸 DB 복원 위임(T556) | touched_rows 기록 + ID 칸 있으면 다음 칸 계속, 그 행 시험 대상 제외 | restore_touched.py 기록 순서 복원 · DB 05:45 ROUTE_ID 3764 복원 확인 | saveprobe.ts T556 블록 되돌림 | 미확인 |
| 정렬 키 NULL 위치 = 데이터 실측 PASS(T546) | UPPER 원문 증명은 NA, NULL 0행 실측은 PASS(실측 명시) | Table_DDL:48168~48187 NULL 허용 · 05:49 NULL 0행 | sort_ci_check.py moot 분기 삭제 | 미확인 |
| 원장 행 ID 30개 변경(T579-a) | 셀 규칙 (시트, 칸) 조회 유지 | 근거 줄 팝업 cs:141~145 → 본 화면 cs:251~255 | ledger.py:501~506 되돌림 | 미확인 |
| I3 상향 제한(T585) | 측정 실패·기대값 미정 ERROR 는 i18n 데이터 PASS 로 올리지 않음 | 측정 실패를 PASS 로 바꾸지 않는 원칙 | judge.py T585 두 줄 삭제 | 미확인 |
| 나머지 결정 R4-D1~D14 | Doc/verify/SCP0005/_unverified_decisions.md | 행별 근거 경로:줄 | - | 미확인 |

## 2026-11-25 08:1x SCP0005 미검증 해소 라운드 5 권장안 진행
| 항목 | 선택 | 근거 | 되돌리는 방법 | 사용자 확인 |
|---|---|---|---|---|
| 화면 알림은 화면 안에 보이는 것만 셈(T590) | 공용 적용 | 닫힌 토스트가 DOM 에 남아 화면 밖에 있음 | _trace.spec.ts shownMsgs 를 종전 innerText 수집으로 되돌림(.bak_20261125_scp05u5) | 미확인 |
| 0 값·빈값 저장 PASS 에 문구 대조 추가(T596) | 적용 | TB_FX_MessageInfo.csv · cs:1293~1297 | _verify.spec.ts 저장 세부 T596 블록 삭제 | 미확인 |
| Excel 빈 업로드 기대 상태에 덮어쓰기 문구 포함(T601) | 적용 | ExcelUploadForm2.cs:964, 1112, 1140 | excelcheck.ts overwriteChain 사용 삭제 | 미확인 |
| AS-IS 검색 단추가 조건 아이콘으로 바뀐 경우 조건 아이콘 측정으로 갈음(T600) | 적용 | 라운드 2 T458 과 같은 기준 | popk3run.ts T600 블록 삭제 | 미확인 |
| 팝업·셀 이벤트 조회 정렬 = 정적 정렬 + 골든 순서 둘 다 있을 때만 PASS(T605) | 적용 | judge.py:383 | judge.py a6_offpath_verdict 호출 삭제 | 미확인 |

## 2026-11-25 14:1x DMF0045 클라우드 조회 지연 점검 권장안 진행
| 항목 | 선택 | 근거 | 되돌리는 방법 | 사용자 확인 |
|---|---|---|---|---|
| PKG_DMF0045 클라우드 반영 방식 (14:35 변경) | 클라우드 원문은 그대로 두고 보완 17줄 구간만 교체하는 전용 스크립트 | 클라우드 본 2436줄은 사내 2399줄과 달라 전체 교체 시 클라우드 쪽 차이가 사라짐. 클라우드 본에 사내 11-13 보완(STORAGE_ID 빈 문자열 비교) 미반영 확인 | 99_ROLLBACK_PKG_DMF0045.sql | 미확인 |
| W/H BOH 82 사업부 수정 방향 | 재고 뷰 SSP_DNM_ESS_PACKER_STOCK_V 를 1번만 읽고 일자 최대값은 같은 읽기 안에서 구함(힌트 없음) | 클라우드 1261줄 1회 960.18초, 처리 행 0, 실행계획에서 뷰 2번 읽기 | 수정 전 PKG 원문 재컴파일 | 미확인 |
| DMF0082 단가 월 SUM 칸, 그 달에 수량이 없는 경우(11-26 13:3x) | 종전처럼 그 달 단가 전체 평균을 표시. Monthly 조회에서는 이 칸이 단가 입력 칸이라 빈칸으로 두면 수량 없는 달의 단가가 안 보임 | 사용자 요청은 '수량 없으면 평균 대상에서 제외'. 15행 기대값 798.260 은 수량 있는 달 사례 | PKG_DMF0082 M_ 단가 식에서 ELSE 를 NULL 로 바꾸면 빈칸 | 미확인 |
| DMF0082 단가 주(W_) SUM 칸 | 바꾸지 않음. Weekly 조회에서 W_ 칸이 단가 입력 칸이고, SP 는 조회 Bucket 값을 받지 않아 Daily 조회 때만 다르게 계산할 수 없음 | P_DMF0082_GET_MAIN_DATA 인자 16개에 Bucket 없음 | W_ 단가 식도 M_ 과 같은 CASE 로 바꿈 | 미확인 |
| DMF0082 평균 판단에 쓰는 수량 메저 | MKT_FCST, MKT_FCST_PP, MKT_FCST_RP_CAR, MKT_FCST_RP_CELL, SCM_FCST, RTF_SYS_RP, RTF_SYS_RP_CAR, RTF_SYS_RP_CELL, RTF_SCP, TMM_FCST(값 0 제외). Cust. FCST, Balance, In-Transit, VMI, AS, Fcst Gap, Amt 는 넣지 않음 | 사용자 예시 'MKT_FCST, SCM_FCST, RTF 등' · SCM_MST_SHEET_MEASURE DMF0082 26행 | PKG QW_ 목록 수정 | 미확인 |
