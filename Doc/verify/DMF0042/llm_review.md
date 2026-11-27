# DMF0042 AI 판정 검토 (2026-11-27 00:25:47)

- 대상 2107행: 검토 289 · 검토 제외 1812 · 미검토 6
- 인용 확인 287행 · 판정 반영 177행 · 엔진 보완 대상 213행 · 룰 등록 후보 26행
- 호출 45회(캐시 0) · 실패 0회 · 비용 49.3810 USD · 출처 Doc/verify/DMF0042/llm_usage.csv

| 행 | 규칙 | 지금 | 분류 | AI 판정 | 인용 | 반영 | 사유 | 근거 | 고칠 곳 |
|---|---|---|---|---|---|---|---|---|---|
| V-64521c1a | A5 | FAIL | 추출오류 | PASS | Y | Y AS-IS 원문 인용 확인 | AS-IS 그리드는 CreateSheetHeaderColumnDtDiv로 만들어지고, 이 메서드는 VALID_YN만 보고 표시 여부를 정하며 VISIBLE_FLAG는 보지 않습니다. MEASURE는 VALID_YN이 Y이고 폭이 80이라 AS-IS에서도 표시되며, 틀 고정도 MEASURE 다음 열에 걸립니다. 추출본 grid_effective.csv가 VISIBLE_FLAG=N만 보고 MEASURE를 숨김으로 적어, TO-BE의 MEASURE 표시를 추가 컬럼으 | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:389 ; GSCM/01.Framework/GSCM.Windows.Forms/Class/S | tools/AsisFacts의 grid_effective 생성기가 CreateSheetHeaderColumnDtDiv 경로(VALID_YN만 반영)에서도 VISIBLE_FLAG=N을 숨김으로 적는다. |
| V-1f2afd11 | F1 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-3ea1f174 | F2 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-9b14a92a | F4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-749baf1a | F5 | FAIL | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | [대표 T-79823b13 와 같은 증거] AS-IS DeleteButton 은 Action 이 I(신규행)가 아니면 바로 끝나서, 기존행은 Delete 로 D 표시가 되지 않습니다. TO-BE handleDelete 도 CRUD_TYPE 이 I 가 아니면 아무것도 하지 않습니다. 따라서 실측 결과(신규행 4행 제거, 기존행은 편집 표시 M 유지)는 AS-IS 와 같습니다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:551 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_B | Doc/e2e/specs/_trace.spec.ts: W4b CRUD 상태 검사가 AS-IS DeleteButton 의 신규행 전용 가드(!= StringI)를 보지 않고 기존행 D 표시를 기대합니다. |
| V-18392b92 | F6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-d3787247 | I4 | FAIL | 실결함 | FAIL | Y | N 판정 같음 | Column 설정 팝업 제목이 LBL00711(Column)을 쓰는데, 같은 문구 Column 이 LBL00309 로 이미 채번되어 있다(KO·EN·CN 모두 Column). CR-032 는 같은 문구의 LBL 코드를 하나만 두고 재사용하도록 정하므로 중복 채번 1건이 남아 있다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.Designer.cs:430 ; nscm-fe/features/demand/src/pages/b |  |
| V-02d642c4 | J2 | FAIL | 확인불가 | FAIL | Y | N 판정 같음 | 버튼 노출 대조는 불일치가 없었다(버튼 권한 기대 불일치 없음). FAIL 은 Division 40 조회 뒤 그리드 DIVISION 값 범위 검사와, 저장 요청 0건으로 전제를 채우지 못한 마커 행 CRUD 왕복에서 나왔다. 권한 없는 Insert·Save·Delete 거부는 재지 못했으므로 원문만으로 PASS 로 바꿀 수 없다. | Doc/e2e/specs/DMF0042.auth.spec.ts:37 ; nscm-fe/features/demand/src/pages/business-plan/BusinessPlan.tsx:518 |  |
| V-06b94720 | F8 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-433bf785 | F7 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-ca74260c | F6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-578b26b3 | F8 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-c2a47db5 | F7 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-0efb902e | K2 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-1a0cfb16 | K2 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-a8211de7 | F5 | 판정필요 | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | AS-IS 는 기존행에서 Delete 를 막기 때문에, 조회된 DIVISION_ID 병합 36행에도 D 표시가 생기지 않습니다. 병합 묶음 전체 삭제(GetCellNumbersByRow)는 신규행(I)에만 적용되고, TO-BE 는 같은 동작을 INSERT_GROUP_ID 묶음 삭제로 합니다. 실측 D 표시 0건은 AS-IS 와 같은 결과입니다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:551 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_B | tools/Harness/verify/db_ref_check.py 가 아닌 Doc/e2e/specs/_trace.spec.ts: 병합 셀 Delete 검사가 신규행 전용 Delete 화면에서도 기존행 병합 D 표시를 기대값으로 씁니다. |
| V-a053e054 | H3 | FAIL | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | AS-IS 는 행 추가 한 번에 Measure 수만큼 행을 넣고 모든 신규 행의 Division 에 같은 값을 넣는다. TO-BE 병합 규칙은 신규 행과 기존 행을 병합하지 않고, 같은 추가 묶음의 신규 행끼리만 병합한다. 검사기는 신규 행의 병합 범위가 2행 이상이면 기존 데이터와 병합됐다고 보므로, 같은 묶음의 신규 행 4개가 병합된 것을 결함으로 적었다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:1220 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_ | tools/E2E/lib/mergecheck.ts: judgeNewRowMerge 가 병합 범위 안에 기존 행이 있는지 보지 않고 범위 행 수만으로 FAIL 을 내므로, 범위 안 행이 모두 같은 추가 묶음의 신규 행이면 제외해야 한다. |
| V-3d56a628 | G6 | 판정필요 | 확인불가 | 판정필요 | N | N 근거 없음 | 조건 1개를 바꾼 뒤 본문 키 18개(deptId, endCustomer, scmSiteId, projectCode, itemId, itemType 등)가 달라졌다는 기록만 있다. 바꾼 조건과 전후 값이 기록되지 않았다. 그래서 AS-IS 의 Division 변경 연쇄 초기화와 같은 동작인지 가릴 수 없다. |  | tools/E2E 연속 조회 본문 검사가 바꾼 조건 이름과 키별 전후 값을 증거에 남기지 않았다. |
| V-bdb9455e | C4 | FAIL | 확인불가 | FAIL | Y | N 판정 같음 | AS-IS 는 신규 행이 있으면 MSG00227 을 띄우고 Bucket 변경을 멈춥니다. TO-BE 도 Bucket 콤보 onChange 에서 신규 행(CRUD_TYPE I)을 확인해 MSG00227 로 막는 코드가 있습니다. 다만 실측 기록에는 insert 단계 직후 신규 행이 0건이었고 Bucket 변경 단계가 끝난 뒤에야 4건으로 잡혀, 변경 시점에 신규 행이 있었는지 원문만으로는 가릴 수 없습니다. 신규 행 4건을 확인한 뒤 Bucket 을 바꾸도록 다시 | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:3030 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_ |  |
| V-eb3408a8 | F1 | FAIL | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | AS-IS DeleteButton 은 Action 이 I 인 신규 행이 아니면 바로 return 하므로, 조회된 기존 행은 Delete 로 지울 수 없고 D 저장 요청도 생기지 않습니다. TO-BE handleDelete 도 CRUD_TYPE 이 I 가 아니면 아무 동작 없이 끝나 AS-IS 와 같고, 자동 시나리오 P06 은 btn_auth DELETE 만 보고 기존 행 D 저장을 기대했습니다. 공통 룰 CR-085(기존 행 D 표시 후 저장 시 삭제)를 기존 | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:551 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_B | tools/Harness/verify/gen_expect.py 가 P06 기존 행 Delete 시나리오를 만들 때 AS-IS DeleteButton 의 신규 행(Action I) 한정 가드를 읽지 않고 btn_auth DELETE 만으로 기대값을 세웠습니다. |
| V-08ebae1c | F3 | 판정필요 | TOBE룰 | NA | Y | Y AS-IS 원문 인용 확인 | AS-IS 는 신규 행 DEPT_ID40(Team)에 콤보를 걸어 직접 고르게 한다. TO-BE 는 DD-120 에 따라 Model 팝업 선택 때 Team 을 자동으로 채우고 직접 입력을 막는다. 같은 편집 막음이 붙여넣기에도 걸려 'ESS.SCM.SCM2팀' 붙여넣기 결과가 빈 값인 것은 등록된 차이다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:1255 ; nscm-fe/features/demand/src/pages/business- |  |
| V-a033d198 | F3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-100cf309 | F3 | FAIL | TOBE룰 | NA | Y | Y AS-IS 원문 인용 확인 | 기존 행에서 복사한 '소형.마케팅.신시장.신시장1팀'을 신규 행 DEPT_ID40 에 붙여넣었는데 빈 값으로 남았다. TO-BE 는 DD-120 에 따라 Div 40 신규 행 Team 을 직접 입력할 수 없게 하고 Model 선택 때 자동으로 채운다. 따라서 붙여넣기가 거부되는 것은 등록된 차이다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:1255 ; nscm-fe/features/demand/src/pages/business- |  |
| V-2dc58ed4 | F3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-df1ed6c9 | F3 | 판정필요 | TOBE룰 | NA | Y | Y AS-IS 원문 인용 확인 | 같은 실행에서 INCOTERMS·CELL_PROD_SITE·SCM_SITE_ID40 붙여넣기는 값이 들어갔으므로 붙여넣기 도구 문제(T169)는 아니다. END_CUSTOMER40 은 TO-BE 가 DD-120 에 따라 직접 입력을 막은 칸이라 후보 값 '-' 붙여넣기가 빈 값으로 남았다. 이는 등록된 차이다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:1261 ; nscm-fe/features/demand/src/pages/business- |  |
| V-dc8d1dcc | F3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-a16cdae2 | F3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-aea62901 | F3 | 판정필요 | TOBE룰 | NA | Y | Y AS-IS 원문 인용 확인 | AS-IS 는 신규 행 END_CUSTOMER40 에 콤보를 걸어 직접 고르게 한다. TO-BE 는 DD-120 에 따라 Model 선택 때 End Customer 를 자동으로 채우고 직접 입력과 붙여넣기를 막는다. 그래서 'NT'가 후보 안인지 밖인지와 상관없이 이 시나리오는 대상이 없다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:1261 ; nscm-fe/features/demand/src/pages/business- |  |
| V-986fd30d | F3 | 판정필요 | 검사기오판 | 판정필요 | Y | N 판정 같음 | 원본 행 r2556 의 SCM_SITE_ID40 값은 'HUAYOU_CN_NJP'인데 복사된 문구가 빈 값('')이었다. 그래서 빈 값을 붙여넣은 셈이고 ''→'' 결과는 후보 밖 값 붙여넣기를 잰 것이 아니다. 화면 동작은 아직 측정되지 않았다. | Doc/verify/DMF0042/e2e_results.json:28107 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:1263 | Doc/e2e/specs/_verify.spec.ts 의 @copy:out 붙여넣기 단계가 복사 문구가 빈 원본 행을 골라 빈 값을 붙여넣었으므로, 복사 문구가 비면 다른 원본 행을 고르거나 측정 실패로 남겨야 한다. |
| V-b7c8119a | F3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-f6de1e1a | F3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-82cd74ba | F3 | 판정필요 | 확인불가 | 판정필요 | Y | N 판정 같음 | AS-IS 는 신규 행 CELL_PROD_SITE 에 유효('Y') 후보만 담은 콤보를 건다(1277행). 후보 밖 문자열을 붙여넣었을 때 FarPoint 가 값을 받는지 거부하는지는 라이브러리 동작이라 원문에 나오지 않는다. TO-BE 는 후보 5건 밖의 '베트남'(A05)을 받지 않고 빈 값으로 두었으므로, AS-IS 화면을 띄워 같은 붙여넣기를 해 봐야 판정할 수 있다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:1277 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_ |  |
| V-b0c413e5 | F3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-73119bd9 | B1 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-d8889660 | E2 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-172013a1 | A5 | 판정필요 | 확인불가 | 판정필요 | Y | N 판정 같음 | AS-IS 헤더 SP는 칸 설정 보유 사용자에게 사용자 SORT_ORDER_NO 순서로 컬럼을 주고, TO-BE도 개인화 순서로 정렬합니다. 메타 기준 순서는 END_CUSTOMER40(40)이 INCOTERMS(200)보다 앞입니다. TO-BE에서 INCOTERMS가 2번째인 원인이 측정 계정의 칸 설정인지는 원문만으로 가릴 수 없습니다. | nscm-fe/features/demand/src/pages/business-plan/useBusinessPlanStore.ts:201 ; Doc/asisfacts/screens/DMF0042/dbmeta_dbo_S |  |
| V-63dcc6c8 | A5 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-7a25c7ad | A5 | ERROR | 검토 제외 |  | N | N 재측정 대상(데이터전제·엔진) — AI 판정 대상 아님 |  |  |  |
| V-d453f65c | A5 | ERROR | 검토 제외 |  | N | N 재측정 대상(데이터전제·엔진) — AI 판정 대상 아님 |  |  |  |
| V-ef57270d | F1 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| V-48f42d7f | F1 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-0bf4f778 | H10 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-6ab5cf1a | H11 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-a84bf383 | F2 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-0c1b97d0 | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-afdc287a | F7 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-6526e039 | F8 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-0fde8c3b | L1 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-18653d31 | H11 | 판정필요 | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | AS-IS 는 조회 중 진행 창을 띄우고 끝나면 닫으며, TO-BE 실측에서도 조회 중 로딩 표시가 6회 관측됐다. 응답 1.5초 뒤 표시가 남았다는 판정은 병렬 조회 호출 중 첫 응답을 기준으로 잰 결과(T98)라 나머지 호출이 진행 중인 상태를 잡은 것이다. SCP0016 사용자 판정과 같은 원인이다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:786 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_B | tools/E2E/lib/formscen.ts: 병렬 조회 호출의 첫 응답이 아니라 마지막 응답 시점을 기준으로 로딩 표시 잔존을 재야 한다. |
| V-81ebcecf | F1 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-be825e76 | F9 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-9d782ebf | A6 | 판정필요 | 검사기오판 | PASS | N | N 인용 미확인 | AS-IS의 ORDER BY USER_ID는 SCM_MST_SSO_USER_INFO를 임시 테이블 #TEMP_SCM_MST_SSO_USER_INFO에 담는 문장의 정렬이고, 그리드 결과 정렬이 아닙니다. AS-IS 그리드 결과는 SCM_MST_SHEET_COLUMNS 또는 개인 컬럼 설정에서 SORT_ORDER_NO 순으로 만든 @GroupList(MEASURE 앞에 SORT_ORDER_NO 삽입)로 정렬합니다. TO-BE도 같은 원천과 같은 순서로 v_Grou | Doc/_legacy_source/DB_DDL/AsIs_LGCE_SCMDEV_SP1_DDL.sql:136332 ; Doc/_legacy_source/DB_DDL/AsIs_LGCE_SCMDEV_SP1_DDL.sql:1 | tools/Harness/verify: A6 정적 추출이 SP 안 첫 ORDER BY(SELECT INTO 임시 테이블 문장)를 결과 정렬로 잡았고, 동적 SQL(@nsql2)의 최종 ORDER BY @GroupList를 기대값으로 쓰지 않았습니다. |
| V-5fbec7ed | A6 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-4b1c5f55 를 검토) |  |  |  |
| V-53438713 | A6 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-4b1c5f55 를 검토) |  |  |  |
| V-609667b4 | A6 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-4b1c5f55 를 검토) |  |  |  |
| V-4b1c5f55 | A6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-804b9d59 | A6 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-45a58e03 를 검토) |  |  |  |
| V-45a58e03 | A6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-bf4ead34 | A6 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-4b1c5f55 를 검토) |  |  |  |
| V-96a8fca2 | A6 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-4b1c5f55 를 검토) |  |  |  |
| V-96c5a722 | A6 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-4b1c5f55 를 검토) |  |  |  |
| V-90f42e1c | A6 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-4b1c5f55 를 검토) |  |  |  |
| V-be1565bd | A6 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-4b1c5f55 를 검토) |  |  |  |
| V-f9c7b841 | A6 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-4b1c5f55 를 검토) |  |  |  |
| V-afa88b17 | A6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-225e13db | A6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-570123cf | A6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-c0ba5e97 | A6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-df100913 | A6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-55aa65b0 | A6 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-0419e1ca 를 검토) |  |  |  |
| V-cc7bb123 | A6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-fc823692 | A6 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-cc7bb123 를 검토) |  |  |  |
| V-3dd9664a | A6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-869712ee | A6 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-3dd9664a 를 검토) |  |  |  |
| V-0419e1ca | A6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-0a5700cf | A6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-ff953806 | A6 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-0a5700cf 를 검토) |  |  |  |
| V-725111a2 | A6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-14582ec9 | A6 | 판정필요 | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | AS-IS DMF0002_GET_TITLESET_POPUP은 Column·Measure의 4개 분기 모두 sort_order_no로 정렬하고, TO-BE PKG_DMF0002.P_DMF0002_GET_TITLESET_POPUP도 4개 분기 모두 B.SORT_ORDER_NO로 정렬해 정렬 키가 같습니다. 검사기는 TO-BE 본문을 P_ 접두사 없는 이름(.DMF0002_GET_TITLESET_POPUP)으로 ALL_SOURCE에서 찾다가 못 찾아 미검증으로 남겼습 | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:2872 ; Doc/_legacy_source/DB_DDL/AsIs_LGCE_SCMDEV_ | tools/Harness/verify: A6 정적 비교에서 TO-BE 본문을 찾을 때 패키지 안의 P_ 접두사 프로시저(PKG_DMF0002.P_DMF0002_GET_TITLESET_POPUP)로 대응시키지 않아 본문 없음으로 기록했습니다. |
| V-4721889b | A6 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-14582ec9 를 검토) |  |  |  |
| V-d97b77fb | A6 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-14582ec9 를 검토) |  |  |  |
| V-c953c81f | A6 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-14582ec9 를 검토) |  |  |  |
| V-a0d08b24 | A7 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| V-05059228 | A7 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| V-9a25c274 | A7 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-ef9ae821 | A7 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-d1a660ed | A7 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-01f9c77d | A7 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-dbd58aa1 | A7 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-d3d8efc4 | A7 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-bdb8225e | A7 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-346d98b4 | A7 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-0a560086 | A7 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| V-3003995f | G1 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-4984f968 | G2 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-96012b16 | H5 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-82cee496 | G1 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-df9a1f34 | G2 | 판정필요 | 확인불가 | 판정필요 | Y | N 판정 같음 | 검사는 Division 40 으로 돌았다. AS-IS 는 Division 40 에서 Project 조건 칸을 끄고, TO-BE 도 같이 끈다. Division 81·82 에서는 Project 조건이 켜지므로 대상이 없다고 볼 수 없고, 그 Division 에서는 재지 않았다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:273 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_B | Doc/e2e/specs/_verify.spec.ts 의 텍스트 조건 검사가 Division 40 한 번만 조회해 Project 칸이 꺼진 상태에서 결과 컬럼을 찾았다. Division 81·82 로 다시 재야 한다. |
| V-5fddf3df | G5 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| V-359ec6f9 | H5 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-b5d5fc5e | G8 | 판정필요 | 실결함 | FAIL | Y | Y AS-IS 원문 인용 확인 | AS-IS는 MSSQL LIKE로 PROJECT_CODE와 PROJECT_NAME을 찾아서 대소문자를 가리지 않는다. TO-BE의 P_DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA는 Oracle LIKE를 UPPER 없이 쓰고, 화면도 입력값을 그대로 넘기므로 Project 조건이 대소문자를 구분한다. 모든 텍스트 조회조건은 대소문자를 무시해야 한다는 CR-025·CR-055를 어긴 것이다. 검사기는 결과 컬럼을 찾지 못해 실행 결과로는 재 | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:808 ; To-be_v2_converted/06_Packages/04_Package_PK |  |
| V-f0b799cd | G9 | 판정필요 | 확인불가 | 판정필요 | Y | N 판정 같음 | AS-IS 조회 SP 는 Project 조건을 콤마로 나눠 PROJECT_CODE·PROJECT_NAME 에 부분 일치로 거르고, TO-BE 도 입력값을 콤마로 이어 그대로 넘긴다. 검사기가 Project 와 같은 이름의 결과 컬럼을 찾지 못해 대조하지 못했으므로 측정 전에는 판정할 수 없다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:273 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_B | tools/E2E/lib/smoke-extra.ts: Project 조건의 결과 컬럼은 Division 81 은 PROJECT_CODE, 82 는 PROJECT_CODE82 이고, Division 40 에서는 Project 조건이 비활성이라 측정 Division 과 대응 컬럼을 함께 정 |
| V-a8d22510 | B7 | 판정필요 | 추출오류 | PASS | Y | Y AS-IS 원문 인용 확인 | [대표 V-2a0a05f2 와 같은 증거] 판정 대기 원인은 SCM_SITE_ID40, SCM_SITE_ID81, SCM_SITE_ID82 콤보의 원천 미확인 3종뿐이다. 원문 1248~1249행에서 원천은 사용자 Sales Site 권한 조회(UserSiteByEndCustomerAuth 또는 UserSiteByEndCustomer)이고, 저장 SP 대상인 DM_PLN_BP_FCST, DM_PLN_BP_FCST_H 와 겹치지 않는다. AS-IS 는 화면을 열  | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:1248 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_ | tools/AsisFacts 의 콤보 원천 추출기가 InsertRow 지역 변수 dtSalesSiteAuth(1248~1249행) 대입을 따라가지 못해 SCM_SITE_ID40/81/82 원천을 미발견으로 남겼다. |
| V-95d4ea5a | G1 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-3df07fc0 | G2 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-e923a2ac | H5 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-f75bbb75 | B4 | 판정필요 | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | AS-IS 초기 Sales Site 는 End Customer 전체 선택값(ALL 을 전체 코드 목록으로 펼친 값)으로 SiteByEndCustomer 를 불러 SSPM 결합 Site 를 넓게 낸다. 검사기는 AS-IS 를 2건만 재현했고 그 2건은 TO-BE 1211건에 모두 있다(AS-IS 에만 0건). 두 DB 에서 같은 유효 Site(1X Technologies_US_PAO 등)가 AS-IS 측정에 빠졌으므로 측정 인자가 원문과 다르다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:310 ; GSCM/01.Framework/GSCM.Windows.Forms/Utility | tools/Harness/verify 의 AS-IS 콤보 재현이 InitControls 310~312행 sEndCustomer(End Customer 전체 코드 목록)를 @Param2 로 넣지 않아 2건만 받았다. |
| V-2a0a05f2 | B7 | 판정필요 | 추출오류 | PASS | Y | Y AS-IS 원문 인용 확인 | 판정 대기 원인은 SCM_SITE_ID40, SCM_SITE_ID81, SCM_SITE_ID82 콤보의 원천 미확인 3종뿐이다. 원문 1248~1249행에서 원천은 사용자 Sales Site 권한 조회(UserSiteByEndCustomerAuth 또는 UserSiteByEndCustomer)이고, 저장 SP 대상인 DM_PLN_BP_FCST, DM_PLN_BP_FCST_H 와 겹치지 않는다. AS-IS 는 화면을 열 때(312행)와 행을 추가할 때 다시 조회하 | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:1248 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_ | tools/AsisFacts 의 콤보 원천 추출기가 InsertRow 지역 변수 dtSalesSiteAuth(1248~1249행) 대입을 따라가지 못해 SCM_SITE_ID40/81/82 원천을 미발견으로 남겼다. |
| V-7c19a4f5 | G1 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| V-2e568cb1 | G1 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-150908f5 | G2 | 판정필요 | 확인불가 | 판정필요 | Y | N 판정 같음 | Model / Nickname 조건은 AS-IS 와 TO-BE 모두 입력 텍스트를 콤마로 나눠 ITEM_ID·NICK_NAME 을 부분일치로 비교한다. 검사기는 기본 조회 96행에서 ITEM_ID40 칸 값을 한 건도 읽지 못해 콤마 다중 입력을 재지 못했다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:809 ; To-be_v2_converted/06_Packages/04_Package_PK | Doc/e2e/specs/_verify.spec.ts 4357행의 columnValues 가 Division 40 기본 조회 96행에서 ITEM_ID40 값을 읽지 못해 재료 없음으로 끝났다. |
| V-c28bd117 | H5 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-be1d74a1 | G8 | 판정필요 | 실결함 | FAIL | Y | Y AS-IS 원문 인용 확인 | AS-IS는 MSSQL LIKE로 ITEM_ID와 NICK_NAME을 찾아서 대소문자를 가리지 않는다. TO-BE 패키지는 ITEM_ID와 NICK_NAME을 Oracle LIKE로 비교하면서 UPPER를 쓰지 않고, 화면도 입력값을 그대로 넘기므로 Model / Nickname 조건이 대소문자를 구분한다. CR-025·CR-055를 어긴 것이다. 검사기는 기본 조회 결과에 ITEM_ID40 값이 없어 실행 결과로는 재지 못했다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:809 ; To-be_v2_converted/06_Packages/04_Package_PK |  |
| V-9d538b2d | G9 | 판정필요 | 확인불가 | 판정필요 | Y | N 판정 같음 | AS-IS 조회 SP 는 Model/Nickname 조건을 콤마로 나눠 ITEM_ID·NICK_NAME 에 부분 일치로 거르고, TO-BE 도 입력값을 콤마로 이어 그대로 넘긴다. 검사기가 기본 조회 결과에서 ITEM_ID40 값을 찾지 못해 시험 값을 만들지 못했으므로 측정 전에는 판정할 수 없다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:809 ; nscm-fe/features/demand/src/pages/business-p | tools/E2E/lib/smoke-extra.ts: Model 시험 값을 ITEM_ID40 컬럼에서만 찾는데, Division 81·82 조회 결과에는 ITEM_ID 컬럼에 값이 있으므로 Division 에 따라 ITEM_ID 또는 ITEM_ID40 을 써야 한다. |
| V-87dcfd74 | B3 | 판정필요 | 검사기오판 | NA | Y | Y AS-IS 원문 인용 확인 | AS-IS Biz.Type 원천 SCM0001_GET_BIZ_TYPE_BY_DIVISION 은 SELECT DISTINCT 만 하고 ORDER BY 가 없어 정해진 원천 정렬이 없다. AS-IS 에서 코드순으로 보인 것은 DB 엔진의 중복 제거 처리 결과일 뿐이라 '원천 정렬' 기대값을 세울 수 없다. 후보 순서 검사는 대상이 없다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:280 ; Doc/_legacy_source/DB_DDL/AsIs_LGCE_SCMDEV_S | tools/Harness/verify 의 B3 순서 비교가 ORDER BY 없는 AS-IS SP 의 실행 순서를 원천 정렬로 삼았으므로, ORDER BY 가 없으면 순서 비교를 빼고 후보 집합만 비교해야 한다. |
| V-3334c9b1 | B4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-a9c13f68 | B7 | 판정필요 | 추출오류 | PASS | Y | Y AS-IS 원문 인용 확인 | [대표 V-2a0a05f2 와 같은 증거] 판정 대기 원인은 SCM_SITE_ID40, SCM_SITE_ID81, SCM_SITE_ID82 콤보의 원천 미확인 3종뿐이다. 원문 1248~1249행에서 원천은 사용자 Sales Site 권한 조회(UserSiteByEndCustomerAuth 또는 UserSiteByEndCustomer)이고, 저장 SP 대상인 DM_PLN_BP_FCST, DM_PLN_BP_FCST_H 와 겹치지 않는다. AS-IS 는 화면을 열  | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:1248 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_ | tools/AsisFacts 의 콤보 원천 추출기가 InsertRow 지역 변수 dtSalesSiteAuth(1248~1249행) 대입을 따라가지 못해 SCM_SITE_ID40/81/82 원천을 미발견으로 남겼다. |
| V-c230410d | B3 | 판정필요 | TOBE룰 | PASS | Y | Y AS-IS 원문 인용 확인 | AS-IS End Customer(40) 원천 EndCustomerByDivision40 은 코드(CODE) 순으로 정렬하고, TO-BE 는 End Customer 드롭다운을 표시명순으로 정렬한다. 조회조건 다중선택 드롭다운을 표시명순으로 두는 것은 2026-08-25·08-28 사용자 확정으로 여러 화면에 함께 적용된 TO-BE 규칙이다. 다만 룰 원장에 번호가 없으므로 등록이 필요하다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:271 ; Doc/_legacy_source/DB_DDL/AsIs_LGCE_SCMDEV_S |  |
| V-b7925626 | B4 | 판정필요 | TOBE룰 | PASS | Y | Y AS-IS 원문 인용 확인 | AS-IS End Customer(Division 40)는 SSPM VALID_YN='Y' 행만 쓰지만, TO-BE 는 CR-059 에 따라 VALID_YN 조건 없이 전체를 후보로 내므로 TO-BE 에만 214건(Acer(개발1)·Amazon(개발) 등)이 더해졌다. AS-IS 에만 있는 '-' 1건은 lookup 분기가 '-' 를 빼므로 SSPM 분기에서 나온 값이고, 이 분기의 부서 결합은 CR-002 로 Owner 부서에서 SSPM.DEPT_ID 로 바뀌 | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:271 ; Doc/_legacy_source/DB_DDL/AsIs_LGCE_SCMDEV_S |  |
| V-5df0464a | B7 | 판정필요 | 추출오류 | PASS | Y | Y AS-IS 원문 인용 확인 | [대표 V-2a0a05f2 와 같은 증거] 판정 대기 원인은 SCM_SITE_ID40, SCM_SITE_ID81, SCM_SITE_ID82 콤보의 원천 미확인 3종뿐이다. 원문 1248~1249행에서 원천은 사용자 Sales Site 권한 조회(UserSiteByEndCustomerAuth 또는 UserSiteByEndCustomer)이고, 저장 SP 대상인 DM_PLN_BP_FCST, DM_PLN_BP_FCST_H 와 겹치지 않는다. AS-IS 는 화면을 열  | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:1248 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_ | tools/AsisFacts 의 콤보 원천 추출기가 InsertRow 지역 변수 dtSalesSiteAuth(1248~1249행) 대입을 따라가지 못해 SCM_SITE_ID40/81/82 원천을 미발견으로 남겼다. |
| V-fb2332bd | G1 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| V-b1993e7e | B3 | 판정필요 | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | AS-IS Team 원천 UP_FX_GetCommonDataList TeambyDivision 은 40·비40 두 분기 모두 부서명(NAME) 순으로 정렬한다. TO-BE 도 Team 드롭다운을 표시명(부서명) 순으로 정렬하므로 정렬 기준이 같다. 검사기는 SCM_MST_SITE.DEPT_ID 가 두 DB 에 함께 없다는 이유로 순서 차이를 설명하지 못했을 뿐이다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:254 ; GSCM/01.Framework/GSCM.Windows.Forms/Class/D | tools/Harness/verify 의 B3 순서 설명이 SCM_MST_SITE.DEPT_ID 대응만 찾다 실패했으므로, AS-IS ORDER BY NAME 을 TO-BE 표시명 정렬과 같은 기준으로 비교해야 한다. |
| V-7110b583 | B4 | 판정필요 | TOBE룰 | PASS | Y | Y AS-IS 원문 인용 확인 | AS-IS 조회조건 Team(Division 40)은 SSPM 품목 Owner 의 SSO 부서를 후보로 내고(60건), TO-BE 는 CR-002 에 따라 SSPM.DEPT_ID 를 선택 Division 으로 좁혀 낸다(16건). 검사기가 대조한 SSPM 168건은 Division 전체 집합이라 화면의 Division 필터와 기준이 다르다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:254 ; Doc/_legacy_source/DB_DDL/AsIs_LGCE_SCMDEV_S |  |
| V-87fd0ceb | B7 | 판정필요 | 추출오류 | PASS | Y | Y AS-IS 원문 인용 확인 | [대표 V-2a0a05f2 와 같은 증거] 판정 대기 원인은 SCM_SITE_ID40, SCM_SITE_ID81, SCM_SITE_ID82 콤보의 원천 미확인 3종뿐이다. 원문 1248~1249행에서 원천은 사용자 Sales Site 권한 조회(UserSiteByEndCustomerAuth 또는 UserSiteByEndCustomer)이고, 저장 SP 대상인 DM_PLN_BP_FCST, DM_PLN_BP_FCST_H 와 겹치지 않는다. AS-IS 는 화면을 열  | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:1248 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_ | tools/AsisFacts 의 콤보 원천 추출기가 InsertRow 지역 변수 dtSalesSiteAuth(1248~1249행) 대입을 따라가지 못해 SCM_SITE_ID40/81/82 원천을 미발견으로 남겼다. |
| V-05dfb57c | G1 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| V-520911bf | G7 | 판정필요 | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | AS-IS clbTeam은 NAME 컬럼을 두 번째 자리로 옮긴 뒤 row[1]을 목록 문구로 넣어 Team 이름을 보여 준다. TO-BE Team 콤보도 buildComboOptions가 NAME을 label로, CODE를 value로 써서 이름만 보여 주므로 코드와 이름이 섞이지 않는다. 검사기는 선택값이 없는(ALL) 초기 상태에서 대조해 후보 60건 중 한 건도 맞추지 못했는데, 이는 표시 형식이 달라서가 아니라 측정에 실패한 것이다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:255 ; GSCM/01.Framework/GSCM.Windows.Forms/Class/C | tools/E2E: G7 조회조건 콤보 검사가 선택값이 없는 초기 상태의 문구를 읽었다. 드롭다운을 열어 옵션 문구를 읽은 뒤 AS-IS 후보의 NAME과 대조하도록 고쳐야 한다. |
| V-9a6b816e | B1 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| V-22af6879 | B2 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-55d28796 | B3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-2fbeec2a | B4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-dc68fe50 | B6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-c84e5035 | B7 | 판정필요 | 추출오류 | PASS | Y | Y AS-IS 원문 인용 확인 | [대표 V-2a0a05f2 와 같은 증거] 판정 대기 원인은 SCM_SITE_ID40, SCM_SITE_ID81, SCM_SITE_ID82 콤보의 원천 미확인 3종뿐이다. 원문 1248~1249행에서 원천은 사용자 Sales Site 권한 조회(UserSiteByEndCustomerAuth 또는 UserSiteByEndCustomer)이고, 저장 SP 대상인 DM_PLN_BP_FCST, DM_PLN_BP_FCST_H 와 겹치지 않는다. AS-IS 는 화면을 열  | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:1248 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_ | tools/AsisFacts 의 콤보 원천 추출기가 InsertRow 지역 변수 dtSalesSiteAuth(1248~1249행) 대입을 따라가지 못해 SCM_SITE_ID40/81/82 원천을 미발견으로 남겼다. |
| V-5de2413f | G1 | ERROR | 검토 제외 |  | N | N 재측정 대상(데이터전제·엔진) — AI 판정 대상 아님 |  |  |  |
| V-a78e15d2 | G7 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-b48b8d8e | H5 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-1af0bde3 | B3 | 판정필요 | TOBE룰 | PASS | Y | Y AS-IS 원문 인용 확인 | AS-IS Item Type 은 SCM0001_GET_LOOKUP_VALUES 의 DISPLAY_SEQ 순서(H·P·Q·R) 그대로 표시하고, TO-BE 는 조회조건 드롭다운을 표시명순(Material·Product·Purchase·Semi Product)으로 다시 정렬한다. 조회조건 다중선택 드롭다운을 표시명순으로 두는 것은 2026-08-28 사용자 확정으로 여러 DM 화면에 함께 적용된 TO-BE 규칙이다. 다만 룰 원장에 번호가 없으므로 등록이 필요하다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:324 ; Doc/_legacy_source/DB_DDL/AsIs_LGCE_SCMDEV_S |  |
| V-6b890d0d | B7 | 판정필요 | 추출오류 | PASS | Y | Y AS-IS 원문 인용 확인 | [대표 V-2a0a05f2 와 같은 증거] 판정 대기 원인은 SCM_SITE_ID40, SCM_SITE_ID81, SCM_SITE_ID82 콤보의 원천 미확인 3종뿐이다. 원문 1248~1249행에서 원천은 사용자 Sales Site 권한 조회(UserSiteByEndCustomerAuth 또는 UserSiteByEndCustomer)이고, 저장 SP 대상인 DM_PLN_BP_FCST, DM_PLN_BP_FCST_H 와 겹치지 않는다. AS-IS 는 화면을 열  | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:1248 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_ | tools/AsisFacts 의 콤보 원천 추출기가 InsertRow 지역 변수 dtSalesSiteAuth(1248~1249행) 대입을 따라가지 못해 SCM_SITE_ID40/81/82 원천을 미발견으로 남겼다. |
| V-d5eb512f | B1 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-708539ce | B2 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-b750d715 | B3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-cae3ba60 | B4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-98d0980b | B6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-d8a4f427 | B7 | 판정필요 | 추출오류 | PASS | Y | Y AS-IS 원문 인용 확인 | [대표 V-2a0a05f2 와 같은 증거] 판정 대기 원인은 SCM_SITE_ID40, SCM_SITE_ID81, SCM_SITE_ID82 콤보의 원천 미확인 3종뿐이다. 원문 1248~1249행에서 원천은 사용자 Sales Site 권한 조회(UserSiteByEndCustomerAuth 또는 UserSiteByEndCustomer)이고, 저장 SP 대상인 DM_PLN_BP_FCST, DM_PLN_BP_FCST_H 와 겹치지 않는다. AS-IS 는 화면을 열  | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:1248 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_ | tools/AsisFacts 의 콤보 원천 추출기가 InsertRow 지역 변수 dtSalesSiteAuth(1248~1249행) 대입을 따라가지 못해 SCM_SITE_ID40/81/82 원천을 미발견으로 남겼다. |
| V-6f361e04 | G7 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-35491d16 | G1 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-5c86805e | G2 | 판정필요 | 확인불가 | 판정필요 | Y | N 판정 같음 | Owner 조건은 AS-IS 와 TO-BE 모두 입력 텍스트를 콤마로 나눠 OWNER·OWNER_NAME·OWNER_NAME_KO 를 부분일치로 비교한다. 검사기는 그리드에서 Owner 머리글을 찾지 못해 결과와 맞대어 보지 못했다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:818 ; To-be_v2_converted/06_Packages/04_Package_PK | Doc/e2e/specs/_verify.spec.ts 4354행이 결과 컬럼을 화면 머리글로만 찾는다. 그런데 Business Plan 의 OWNER 는 기본 화면에 보이지 않는 선택 표시 컬럼이라 대응 컬럼을 못 찾았다. |
| V-a3967a98 | G5 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| V-b2b5c444 | H5 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-eb60bad6 | G8 | 판정필요 | 실결함 | FAIL | Y | Y AS-IS 원문 인용 확인 | AS-IS는 MSSQL LIKE로 OWNER, OWNER_NAME, OWNER_NAME_KO를 찾아서 대소문자를 가리지 않는다. TO-BE 패키지는 세 컬럼을 Oracle LIKE로 비교하면서 UPPER를 쓰지 않고, 화면도 입력값을 그대로 넘기므로 Owner 조건이 대소문자를 구분한다. CR-025·CR-055를 어긴 것이다. 검사기는 Owner 결과 컬럼을 찾지 못해 실행 결과로는 재지 못했다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:818 ; To-be_v2_converted/06_Packages/04_Package_PK |  |
| V-837cc6dc | G9 | 판정필요 | 확인불가 | 판정필요 | Y | N 판정 같음 | AS-IS 조회 SP 는 Owner 조건을 콤마로 나눠 SI.OWNER·OWNER_NAME·OWNER_NAME_KO 에 부분 일치로 거르고, TO-BE 도 Owner 입력값을 콤마로 이어 그대로 넘긴다. 결과 그리드에 Owner 컬럼이 없어 검사기가 결과를 대조하지 못했으므로 실제 화면 측정 전에는 판정할 수 없다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:818 ; nscm-fe/features/demand/src/pages/business-p | tools/E2E/lib/smoke-extra.ts: 결과 그리드에 없는 컬럼(SI.OWNER)으로 거르는 조건이라 같은 이름 컬럼 대조가 불가하므로 단일 값 조회 건수의 합집합과 콤마 조회 건수를 비교하는 방식이 필요하다. |
| V-506251cd | B1 | 판정필요 | 추출오류 | NA | Y | Y AS-IS 원문 인용 확인 | AS-IS 조회조건 Closed(cboClosed)를 담은 lblBucket1 은 InitControls 에서 Visibility=Never 로 숨겨지고 cboClosed 도 Enabled=false 로 막혀 화면에 나타나지 않는다. TO-BE 도 이 조회조건을 두지 않아 검사할 대상이 없다. 추출본 combo_src.csv 가 숨겨진 컨트롤을 조회조건 콤보로 적어 생긴 행이다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.Designer.cs:1457 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan | tools/AsisFacts 조회조건 콤보 추출이 InitControls 의 LayoutControlItem.Visibility=Never·Enabled=false 를 보지 않고 숨겨진 cboClosed 를 SEARCH 행으로 기록한다. |
| V-48b14ca3 | B2 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-4cff7ca0 | B3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-2652e0a2 | B4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-3953fa8b | B6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-93afc672 | B7 | 판정필요 | 추출오류 | PASS | Y | Y AS-IS 원문 인용 확인 | [대표 V-2a0a05f2 와 같은 증거] 판정 대기 원인은 SCM_SITE_ID40, SCM_SITE_ID81, SCM_SITE_ID82 콤보의 원천 미확인 3종뿐이다. 원문 1248~1249행에서 원천은 사용자 Sales Site 권한 조회(UserSiteByEndCustomerAuth 또는 UserSiteByEndCustomer)이고, 저장 SP 대상인 DM_PLN_BP_FCST, DM_PLN_BP_FCST_H 와 겹치지 않는다. AS-IS 는 화면을 열  | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:1248 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_ | tools/AsisFacts 의 콤보 원천 추출기가 InsertRow 지역 변수 dtSalesSiteAuth(1248~1249행) 대입을 따라가지 못해 SCM_SITE_ID40/81/82 원천을 미발견으로 남겼다. |
| V-5fd5e439 | G1 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-4367ce8b | G2 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-766b44bd | G7 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-94997598 | H5 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-47d0fa5c | G1 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-3d45d45e | G2 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-bddc7642 | H5 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-d51669b3 | B1 | 판정필요 | 확인불가 | 판정필요 | Y | N 판정 같음 | AS-IS 는 Division 이 40 이 아닐 때 신규행 Team(DEPT_ID)에 UserTeamByDivisionAuth 결과로 셀 콤보를 붙인다. TO-BE 는 TeambyDivision 콤보를 조회한 뒤 dataMap 으로 붙이는데, 검사기는 dataMap 이 없다고만 기록했고 검사 실행 Division 이 40 이 아닌지도 결과에 없다. 원문만으로는 후보 공백 여부를 가릴 수 없다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:1256 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_ | tools/E2E 그리드 컬럼 프로브가 Division 별로 다른 Team 컬럼(DEPT_ID 는 40 이외)을 구분하지 않고, 콤보 조회 완료 전이나 편집 전 col.dataMap 을 읽어 후보를 재지 못한다. |
| V-e484d215 | B2 | 판정필요 | 확인불가 | 판정필요 | Y | N 판정 같음 | AS-IS는 Division이 40이 아닐 때만 신규행 Team(DEPT_ID)에 dtTeamAuth 콤보를 붙인다. 검사는 Division 40으로만 돌았고, DEPT_ID는 그 그리드에 없어 후보를 재지 못했다. Division 81·82에서는 대상이 있으므로 NA로 낮출 수 없고, 해당 Division에서 다시 재야 한다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:1256 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_ | Doc/e2e/specs/_verify.spec.ts 601행은 컬럼이 그리드에 없을 때도 '셀 콤보 없음'으로 적는다. DEPT_ID 는 Division 81·82 조회 상태에서 B2 를 재야 한다. |
| V-ada13013 | B3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-1654c4da | B4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-2d747c60 | A2 | 판정필요 | 확인불가 | 판정필요 | Y | N 판정 같음 | AS-IS 는 Division 이 40이 아닐 때만 신규행 Team(DEPT_ID)에 권한 팀 콤보를 겁니다. 검사기는 기존행 값이 공란이라 신규행 표시값을 재지 못했고, 측정한 Division 이 40이었다면 DEPT_ID 콤보는 처음부터 대상이 아닙니다. 측정 Division 과 실제 표시값을 원문으로 정할 수 없어 지금 결과를 그대로 둡니다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:1256 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_ | tools/E2E 의 A2 측정이 신규행을 만들지 않고 공란 기존행을 읽었고, DEPT_ID 와 DEPT_ID40 의 Division 분기(40 여부)도 측정 조건에 넣지 않았습니다. |
| V-e56876d0 | B1 | 판정필요 | 확인불가 | 판정필요 | Y | N 판정 같음 | AS-IS 는 Division 이 40 일 때만 신규행 Team(DEPT_ID40)에 UserTeamByDivisionAuth 결과로 셀 콤보를 붙인다. TO-BE 는 TeambyDivision 콤보를 dataMap 으로 붙이는데, 검사기는 dataMap 이 없다고만 기록했고 같은 실행에서 DEPT_ID 도 같은 결과라 검사 Division 에서 이 컬럼이 대상이었는지 알 수 없다. 원문만으로는 후보 공백 여부를 가릴 수 없다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:1254 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_ | tools/E2E 그리드 컬럼 프로브가 Division 40 전용 컬럼(DEPT_ID40)을 다른 Division 실행에서도 재고, 편집 전 col.dataMap 만 읽어 후보를 재지 못한다. |
| V-2f93baa7 | B2 | 판정필요 | 확인불가 | 판정필요 | Y | N 판정 같음 | AS-IS는 Division 40 신규행의 Team(DEPT_ID40)에 dtTeamAuth 콤보를 붙인다. 같은 실행에서 TO-BE 그리드에는 DEPT_ID40 컬럼이 없어 후보를 하나도 재지 못했고, 검사기는 이를 콤보 없음으로 기록했다. 컬럼이 없는 이유가 Division 메타인지 사용자 컬럼 설정인지 소스로 가릴 수 없어 A5 표시 판정과 함께 다시 재야 한다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:1254 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_ | Doc/e2e/specs/_verify.spec.ts 601행은 probe.candidates 가 null 이면 컬럼이 그리드에 없을 때도 '셀 콤보(dataMap) 없음'으로 적는다. 컬럼 부재를 따로 기록하고 DEPT_ID40 이 보이는 상태에서 다시 재야 한다. |
| V-f876020c | B3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-77065082 | B4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-4d43b6e0 | A2 | 판정필요 | 확인불가 | 판정필요 | Y | N 판정 같음 | AS-IS 는 Division 40의 신규행 Team(DEPT_ID40)에 권한 팀 콤보를 겁니다. 검사기는 기존행 값이 공란이라 표시값을 재지 못했습니다. 실제 표시가 Name 인지 원문만으로 정할 수 없어 지금 결과를 그대로 둡니다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:1254 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_ | tools/E2E 의 A2 측정이 Division 40 신규행을 추가해 Team 값을 고르지 않고 공란 기존행만 읽어 측정 대상이 없었습니다. |
| V-82fa7fcd | B1 | 판정필요 | 확인불가 | 판정필요 | Y | N 판정 같음 | AS-IS 는 신규행 End Customer(END_CUSTOMER)에 dtCustomer 로 셀 콤보를 붙인다. TO-BE 는 편집 시작 시 DIVISION_ID·DEPT_ID 로 걸러 dataMap 을 붙이는데, 검사기는 편집기를 열기 전에 dataMap 이 없다고만 기록했다. 원문만으로는 후보에 공백 항목이 있는지 가릴 수 없다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:1259 ; nscm-fe/features/demand/src/pages/business- | tools/E2E 그리드 컬럼 프로브가 편집기를 열기 전 col.dataMap 을 읽어, beginningEdit 에서 콤보를 붙이는 화면(BusinessPlanGrid.tsx:640)의 후보를 재지 못한다. |
| V-630f12f5 | B2 | 판정필요 | 확인불가 | 판정필요 | Y | N 판정 같음 | AS-IS는 End Customer(END_CUSTOMER) 컬럼이 있을 때 신규행에 dtCustomer 콤보를 붙이고, Division 40은 END_CUSTOMER40을 쓴다. 검사는 Division 40으로만 돌았고, END_CUSTOMER는 그 그리드에 없어 후보를 재지 못했다. Division 81 조회 상태에서 다시 재야 판단할 수 있다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:1258 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_ | Doc/e2e/specs/_verify.spec.ts 601행은 컬럼이 그리드에 없을 때도 '셀 콤보 없음'으로 적는다. 81·82 전용 컬럼은 해당 Division 조회 상태에서 B2 를 재야 한다. |
| V-e541dbde | B3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-7b1dc135 | B4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-3ee5d90b | A2 | 판정필요 | 확인불가 | 판정필요 | Y | N 판정 같음 | AS-IS 는 신규행 End Customer(END_CUSTOMER)에 고객 콤보를 겁니다. 검사기는 기존행 값이 공란이라 표시값을 하나도 재지 못했습니다. 실제 표시가 Name 인지 원문만으로 정할 수 없어 지금 결과를 그대로 둡니다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:1259 ; nscm-fe/features/demand/src/pages/business- | tools/E2E 의 A2 측정이 신규행 조건에서 콤보 값을 넣은 행을 만들지 않고 공란 기존행만 읽어 측정 대상이 없었습니다. |
| V-48303ef9 | B3 | 판정필요 | TOBE룰 | NA | Y | Y AS-IS 원문 인용 확인 | AS-IS 는 40 신규행 End Customer 칸에 dtCustomer 콤보를 걸어 직접 고르게 하지만, TO-BE 는 DD-120 에 따라 Model 팝업 선택 시 자동으로 채우고 직접 입력을 막는다. TO-BE 에 고를 후보 목록이 없으므로 후보 순서 검사는 대상이 없다. 같은 묶음의 Sales Site(SCM_SITE_ID40) 신규행은 TO-BE 에서 직접 고르는 칸이고 AS-IS 원천은 1248행 UserSiteByEndCustomerAuth 이다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:1261 ; nscm-fe/features/demand/src/pages/business- |  |
| V-98c561ed | B4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-642dc7a6 | A2 | 판정필요 | 확인불가 | 판정필요 | Y | N 판정 같음 | 검사기는 조회 첫 기존행 하나의 End Customer(END_CUSTOMER40) 값만 읽었고 그 값이 공란이라 코드·이름 표시를 비교하지 못했다. 검사 조건은 신규행인데 측정은 기존행으로 했다. TO-BE 그리드는 콤보 컬럼을 CODE→NAME dataMap으로 만들지만 실제 표시는 화면에서 값이 있는 행으로 확인해야 한다. | Doc/e2e/specs/_verify.spec.ts:867 ; nscm-fe/features/demand/src/pages/business-plan/components/BusinessPlanGrid.tsx:224 | Doc/e2e/specs/_verify.spec.ts 의 A2 측정이 첫 기존행(ex.row) 하나만 읽고 값이 공란이면 멈추므로 값이 있는 다른 행을 찾거나 신규행에 콤보 값을 넣은 뒤 표시를 읽어야 한다. |
| V-8ac0a4dc | B3 | ERROR | 미검토 |  | N | N 대표 V-48303ef9 와 판단이 다름 — 다음 실행에 단독 검토 |  |  |  |
| V-d95983fd | B4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-06fe3474 | A2 | 판정필요 | 확인불가 | 판정필요 | Y | N 판정 같음 | AS-IS 는 신규행의 Sales Site(SCM_SITE_ID40)에 콤보를 걸고, TO-BE 도 CODE→NAME dataMap 을 씁니다. 검사기는 신규행 조건인데 기존행 값이 공란이라 표시값을 하나도 재지 못했습니다. 화면에 실제로 보이는 값이 Name 인지 원문만으로는 정할 수 없어 지금 결과를 그대로 둡니다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:1263 ; nscm-fe/features/demand/src/pages/business- | tools/E2E 의 A2 측정이 신규행 조건에서 행을 추가하고 콤보 값을 고르지 않은 채 공란인 기존행만 읽어 측정 대상이 없었습니다. |
| V-1ed1e67b | B1 | 판정필요 | 확인불가 | 판정필요 | Y | N 판정 같음 | AS-IS 는 신규행 Sales Site(SCM_SITE_ID81)에 UserSiteByEndCustomer 결과로 셀 콤보를 붙인다. TO-BE 는 편집 시작 시점에 dataMap 을 붙이거나 공용 그리드의 행별 재조회 콤보로 붙이는데, 검사기는 편집기를 열기 전에 dataMap 이 없다고만 기록해 후보 목록의 공백 항목 수를 재지 못했다. 원문만으로는 후보에 공백 항목이 있는지 가릴 수 없다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:1265 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_ | tools/E2E 그리드 컬럼 프로브가 편집기를 열기 전 col.dataMap 을 읽어, beginningEdit 에서 콤보를 붙이는 화면(BusinessPlanGrid.tsx:633·640)과 행별 재조회 콤보의 후보를 재지 못한다. |
| V-5fd779d3 | B2 | 판정필요 | 확인불가 | 판정필요 | Y | N 판정 같음 | AS-IS는 Sales Site(SCM_SITE_ID81) 컬럼이 있을 때 신규행에 dtSalesSiteAuth 콤보를 붙이고, 컬럼 구성은 Division별 시트 메타로 정해진다. 검사는 Division 40으로만 돌았고, SCM_SITE_ID81은 그 그리드에 없어 후보를 재지 못했다. Division 81 조회 상태에서 다시 재야 판단할 수 있다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:1264 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_ | Doc/e2e/specs/_verify.spec.ts 601행은 컬럼이 그리드에 없을 때도 '셀 콤보 없음'으로 적는다. 81 전용 컬럼은 Division 81 조회 상태에서 B2 를 재야 한다. |
| V-bcf03eb8 | B3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-0a93c616 | B4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-c5040959 | A2 | 판정필요 | 확인불가 | 판정필요 | Y | N 판정 같음 | 검사기는 조회 첫 기존행 하나의 Sales Site(SCM_SITE_ID81) 값만 읽었고 그 값이 공란이라 코드·이름 표시를 비교하지 못했다. 실제 표시는 값이 있는 행으로 화면에서 확인해야 한다. | Doc/e2e/specs/_verify.spec.ts:867 ; nscm-fe/features/demand/src/pages/business-plan/components/BusinessPlanGrid.tsx:224 | Doc/e2e/specs/_verify.spec.ts 의 A2 측정이 첫 기존행(ex.row) 하나만 읽고 값이 공란이면 멈추므로 값이 있는 다른 행을 찾거나 신규행에 콤보 값을 넣은 뒤 표시를 읽어야 한다. |
| V-c3d65ea6 | E7 | 판정필요 | 확인불가 | 판정필요 | Y | N 판정 같음 | AS-IS 신규행 Model*(ITEM_ID40)은 TextCellType이라 직접 입력할 수 있다. TO-BE에서도 잘못된 값 'ZZ_E2E_BAD_POPUP_KEY'가 칸에 들어갔지만, Save가 End Customer 필수 검사에 먼저 막혀 저장 요청이 나가지 않았다. 그래서 잘못된 Model 값이 저장 단계에서 차단되는지는 이 측정으로 알 수 없다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:1243 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_ | Doc/e2e/specs/_verify.spec.ts TO-BE Division 40 End Customer는 Model 팝업 선택으로만 채워지는데, 검사기가 팝업으로 유효한 Model을 고르지 않고 잘못된 값만 넣어 Save가 End Customer 필수 검사에 먼저 막혔다. 팝업으로 |
| V-006be3f3 | B4 | 판정필요 | 추출오류 | PASS | Y | Y AS-IS 원문 인용 확인 | AS-IS FCST Type 콤보는 시트 메타 DM_LOOKUP_DIV 를 제목 SP 가 넘긴 ATTRIBUTE1(Division)·ATTRIBUTE2(BP_FCST_TYPE)로 조회하므로 Division 40 후보는 AS·ETC·MPS 3건이다. TO-BE 도 같은 인자로 AS·ETC·MPS 3건을 낸다. 추출본이 인자를 빈 값으로 적어 AS-IS 쪽이 0건으로 측정됐다. | GSCM/01.Framework/GSCM.Windows.Forms/Class/SpreadInfo.cs:14099 ; Doc/_legacy_source/DB_DDL/AsIs_LGCE_SCMDEV_SP10_DDL.sql | tools/AsisFacts 콤보 추출기가 SheetMeta 콤보 인자를 CreateSheetHeaderColumnDtDiv 의 ATTRIBUTE1~5(DMF0042_GET_SPREAD_TITLE 이 Division·LOOKUP_TYPE 으로 채움) 대신 빈 값으로 기록한다. |
| V-a7beeb4a | A2 | 판정필요 | 확인불가 | 판정필요 | Y | N 판정 같음 | 검사기는 조회 첫 기존행 하나의 FCST Type(FCST_TYPE) 값만 읽었고 그 값이 공란이라 코드·이름 표시를 비교하지 못했다. TO-BE 는 FCST_TYPE 을 DM_LOOKUP_DIV 콤보 dataMap으로 표시하지만 실제 표시는 값이 있는 행으로 화면에서 확인해야 한다. | Doc/e2e/specs/_verify.spec.ts:867 ; nscm-fe/features/demand/src/pages/business-plan/components/BusinessPlanGrid.tsx:179 | Doc/e2e/specs/_verify.spec.ts 의 A2 측정이 첫 기존행(ex.row) 하나만 읽고 값이 공란이면 멈추므로 값이 있는 다른 행을 찾거나 신규행에 콤보 값을 넣은 뒤 표시를 읽어야 한다. |
| V-407729c3 | B1 | 판정필요 | 확인불가 | 판정필요 | Y | N 판정 같음 | AS-IS InsertRow 는 Plant Site(PLANT_SITE_ID)에 별도 콤보를 붙이지 않고 그리드 메타 콤보를 쓰며, Division 이 81 이 아니면 신규행에서 잠근다. TO-BE 는 편집 시작 시 DIVISION_ID 로 걸러 dataMap 을 바꿔 붙이는데, 검사기는 편집기를 열기 전에 dataMap 이 없다고 기록했다. 검사 실행 Division 에서 이 칸이 잠겼는지도 결과에 없어 후보 공백 여부를 가릴 수 없다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:1322 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_ | tools/E2E 그리드 컬럼 프로브가 신규행 잠금 여부(Division 81 아님)를 먼저 보지 않고 편집 전 col.dataMap 만 읽어, beginningEdit 에서 콤보를 붙이는 화면을 재지 못한다. |
| V-eef03dd4 | B2 | 판정필요 | 확인불가 | 판정필요 | Y | N 판정 같음 | AS-IS는 Division 81이 아니면 신규행 Plant Site(PLANT_SITE_ID)를 잠그고, 이 화면 InsertRow에는 PLANT_SITE_ID 콤보 설정 문장이 없어 후보는 시트 메타에서 온다. 검사는 Division 40으로만 돌았고, PLANT_SITE_ID는 그 그리드에 없어 후보를 재지 못했다. Division 81 조회 상태에서 다시 재야 판단할 수 있다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:1322 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_ | Doc/e2e/specs/_verify.spec.ts 601행은 컬럼이 그리드에 없을 때도 '셀 콤보 없음'으로 적는다. PLANT_SITE_ID 는 Division 81 조회 상태에서 B2 를 재야 한다. |
| V-d9725e22 | B3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-f17636b2 | B4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-e1bfe420 | A2 | 판정필요 | 확인불가 | 판정필요 | Y | N 판정 같음 | 검사기는 조회 첫 기존행 하나의 Plant Site(PLANT_SITE_ID) 값만 읽었고 그 값이 공란이라 코드·이름 표시를 비교하지 못했다. TO-BE 는 PLANT_SITE_ID 를 FromSiteByDivision 콤보로 표시하지만 실제 표시는 값이 있는 행으로 화면에서 확인해야 한다. | Doc/e2e/specs/_verify.spec.ts:867 ; nscm-fe/features/demand/src/pages/business-plan/components/BusinessPlanGrid.tsx:151 | Doc/e2e/specs/_verify.spec.ts 의 A2 측정이 첫 기존행(ex.row) 하나만 읽고 값이 공란이면 멈추므로 값이 있는 다른 행을 찾거나 신규행에 콤보 값을 넣은 뒤 표시를 읽어야 한다. |
| V-736e5e45 | B4 | FAIL | 추출오류 | PASS | Y | Y AS-IS 원문 인용 확인 | AS-IS 신규행 Cell Prod Site 콤보는 GetCellProdSite("DM_CELL_PROD_SITE","Y")로 PARAM1=Y 를 넘겨 VALID_YN='Y' 인 코드만 낸다. TO-BE 편집 콤보 DMF0042CellProdSiteValid 도 VALID_YN='Y' 로 5건을 낸다. 추출본이 PARAM1 을 빈 값으로 적어 AS-IS 쪽에 비활성 Z01·A05 가 더해진 7건이 기대값이 됐다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:1277 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_ | tools/AsisFacts 콤보 추출기가 지역 함수 GetCellProdSite 의 인자 sValidYN("Y")을 PARAM1 로 전달하지 않고 빈 값으로 기록한다. |
| V-92ec43de | A2 | 판정필요 | 확인불가 | 판정필요 | Y | N 판정 같음 | 검사기는 조회 첫 기존행 하나의 Cell Prod Site(CELL_PROD_SITE) 값만 읽었고 그 값이 공란이라 코드·이름 표시를 비교하지 못했다. TO-BE 는 CELL_PROD_SITE 편집 콤보를 CODE→NAME dataMap으로 만들지만 실제 표시는 값이 있는 행으로 화면에서 확인해야 한다. | Doc/e2e/specs/_verify.spec.ts:867 ; nscm-fe/features/demand/src/pages/business-plan/components/BusinessPlanGrid.tsx:267 | Doc/e2e/specs/_verify.spec.ts 의 A2 측정이 첫 기존행(ex.row) 하나만 읽고 값이 공란이면 멈추므로 값이 있는 다른 행을 찾거나 신규행에 콤보 값을 넣은 뒤 표시를 읽어야 한다. |
| V-8bd1e823 | A5 | 판정필요 | 추출오류 | PASS | Y | Y AS-IS 원문 인용 확인 | AS-IS 는 DMF0042_GET_SPREAD_TITLE 이 VISIBLE_FLAG='N'·DEFAULT_FLAG='' 컬럼을 항상 포함하는 고정 컬럼으로 넘기고, CreateSheetHeaderColumnDtDiv 는 표시 여부를 VALID_YN 으로만 정한다. MEASURE 는 VALID_YN='Y' 라서 AS-IS 에서도 Measure 컬럼이 표시되고 InsertRow 도 이 칸에 Measure 이름을 넣는다. TO-BE 표시=Y 는 AS-IS 와 같다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:389 ; GSCM/01.Framework/GSCM.Windows.Forms/Class/S | tools/AsisFacts: grid_effective 가 SHEET_COLUMNS VISIBLE_FLAG='N' 을 숨김으로 옮겼으나 CreateSheetHeaderColumnDtDiv 는 VALID_YN 으로만 표시를 정하고 VISIBLE_FLAG='N' 은 상시 포함 컬럼 표시다 |
| V-97097aec | D1 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-2114039a | H8 | FAIL | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | 기대값 소수 2자리는 Exchange Rate 팝업의 주간 컬럼(AddNumColumn 소수 2)에서 왔고, Biz Plan 메인 그리드의 기준이 아닙니다. 메인 그리드의 월 컬럼은 DMF0042_GET_SPREAD_TITLE 이 FPNumber, 소수 3자리로 내려줍니다. TO-BE 의 n3 표시 '14,689.590' 은 AS-IS 와 같습니다. | GSCM/06.UIL/GSCM.DM.Plan.UIL/POPUP/DMF0042_ExchangeRatePopup.cs:184 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan | tools/AsisFacts: 동적 LOOP 컬럼의 표시 형식 기대값을 다른 시트인 DMF0042_ExchangeRatePopup 의 AddNumColumn 에서 가져왔습니다. Biz Plan 시트는 DMF0042_GET_SPREAD_TITLE 의 DATA_SCALE_NUMBER 를 써 |
| V-6b71bb28 | G1 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-b81f8b88 | G1 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-2a7c6974 | G1 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-dd070f51 | MS1 | 판정필요 | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | AS-IS FindData는 권한 Division 목록(MyDivision)에서 고른 Division 값이 비어 있으면 MSG00097 「권한을 가진 Division이 없습니다.」를 띄우고 조회를 멈춥니다. TO-BE도 Division 값이 비어 있으면 MSG00097 「Division 을 선택하세요.」를 띄우고 멈춥니다. 같은 조건에서 Division이 없다는 뜻으로 쓰여 다른 뜻으로 쓴 경우가 아닙니다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_1_BizPlan/DMF0042_1_BizPlan.cs:236 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF00 | tools/Harness/verify의 MS1 메시지 대응(msgmap)이 글자가 똑같은 코드(MSG00667)만 같은 뜻으로 보고, 같은 분기에서 쓰인 동일 ID의 문구 차이는 결론을 내지 못합니다. |
| V-46b6f2af | MS1 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| V-ba00385d | MS1 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| V-1646da51 | H2 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-13a04bd9 를 검토) |  |  |  |
| V-e326549b | D3 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-1877323e 를 검토) |  |  |  |
| V-6034d283 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-363e14bc | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-fab6bc61 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-92a7fbc9 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-77a5a56b | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-ffa97ddf | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-02c37671 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-44f1ee40 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-d0f1c254 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-399b852b | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-5d7ebf53 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-a8a42c6a | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-e90bf7ea | D3 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-89038ff4 를 검토) |  |  |  |
| V-84cd4e69 | D3 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-4f782b7a 를 검토) |  |  |  |
| V-16b773e6 | G1 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-2e9eedeb | G1 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-0b438463 를 검토) |  |  |  |
| V-74483be0 | MS1 | 판정필요 | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | AS-IS FindData는 조회 기간의 시작일이 종료일보다 늦으면 MSG00108 「시작일자가 종료일자보다 늦을 수 없습니다.」를 띄우고 조회를 멈춥니다. TO-BE도 같은 조건에서 MSG00108 「조회 기간이 잘못되었습니다 (시작일 > 종료일).」를 띄우고 멈춥니다. 문구 표현만 다르고 뜻은 같아, 기대값 '같은 의미의 메시지 사용'을 만족합니다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_1_BizPlan/DMF0042_1_BizPlan.cs:703 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF00 | tools/Harness/verify의 MS1 메시지 대응(msgmap)이 글자가 똑같은 코드(MSG01135)만 같은 뜻으로 보고, 같은 조건에서 같은 뜻으로 쓰인 동일 ID는 결론을 내지 못합니다. |
| V-d5eba555 | G1 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-53ee84c8 를 검토) |  |  |  |
| V-9bc5f9e9 | H2 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-065768b7 를 검토) |  |  |  |
| V-edbdad1a | C2 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-12b2a8fa 를 검토) |  |  |  |
| V-00a512a7 | C2 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-bcf69618 | C2 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-30492e9e 를 검토) |  |  |  |
| V-2b5ecc16 | C2 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-0db507c9 | C2 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-ca1484f6 | C2 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-22c6c547 를 검토) |  |  |  |
| V-0a94fc5c | C2 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-5fd584a1 | C2 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-74649ca6 | C2 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-1d558d3a 를 검토) |  |  |  |
| V-16f24a4c | C2 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-eafb5927 | C2 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-6a338f10 를 검토) |  |  |  |
| V-a6c1f595 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-544ee1e9 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-9331f408 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-9f6dc653 | D3 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-20671d62 를 검토) |  |  |  |
| V-1d51f8e3 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-6d5663da | D3 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-209dc917 를 검토) |  |  |  |
| V-e598ffa6 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-4472d4e5 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-8d22101b | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-2a15cc0b | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-9f5f35bf | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-05cc7b00 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-cb187025 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-e8878792 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-a7ff7075 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-b1da5a43 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-3d74f8e5 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-67dd5ea3 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-9e3e08a6 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-f1cc012a | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-e85aea8e | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-a8015b5a | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-50e61286 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-3d0894f1 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-e1c9e21d | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-1f73066c | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-c9d3ede6 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-2c8afc22 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-bbece189 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-26387f91 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-009626f1 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-acee7688 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-83f1c624 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-ca8d2269 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-e3aad76c | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-9e4f5b6e | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-28c4c136 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-351944d8 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-b869716e | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-0cefb37e | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-94b41182 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-d2a94b62 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-a7668366 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-341fe976 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-e1f381b3 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-10275333 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-b2f12416 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-e3a95858 | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| V-3e41b595 | E4 | FAIL | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | [대표 T-1115bd5d 와 같은 증거] AS-IS SaveData는 Division 40 행에서 End Customer, Sales Site, Model, Currency, FcstType, Incoterms, Cell Prod Site 중 하나라도 비어 있으면 MSG00310을 띄우고 저장을 멈춘다. TO-BE도 Save 때 같은 칸을 필수로 검사해 '{0} 값은 필수 입력 항목입니다.' 알림을 띄우고 저장을 막는다. 같은 화면의 E7 측정에서도 신규행 S | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_1_BizPlan/DMF0042_1_BizPlan.cs:900 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF00 | Doc/e2e/specs/_trace.spec.ts:1534 빈값 위반은 신규행이 처음부터 비어 있어 이미 충족되는데, 대상 칸이 편집 불가라는 이유로 Save 시도 없이 FAIL을 기록한다. |
| V-119e9de9 | E4 | FAIL | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | AS-IS는 Division 81 행에서 Project, Team, Sales Site, Plant Site, Model, End Customer, FcstType, Incoterms, Currency 중 하나라도 비어 있으면 MSG00310으로 저장을 막는다. TO-BE도 Division 81에서 같은 칸을 필수로 검사하고 알림을 띄운 뒤 저장을 멈춘다. Project 칸은 팝업으로만 입력되지만 신규행이 처음부터 비어 있으므로 위반 상태는 이미 만들어져 있다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_1_BizPlan/DMF0042_1_BizPlan.cs:930 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF00 | Doc/e2e/specs/_trace.spec.ts:1534 빈값 위반에서 대상 칸이 편집 불가이면 신규행을 그대로 Save해 확인하지 않고 FAIL을 기록한다. |
| V-a097e1c2 | E4 | FAIL | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | AS-IS는 Division 82 행에서 Team, Currency, Unit Energy 중 하나라도 비어 있으면 MSG00310으로 저장을 막는다. TO-BE도 Division 82에서 Team, Unit Energy, Currency를 필수로 검사해 저장을 막는다. 신규행 Team은 처음부터 비어 있으므로 위반 상태가 이미 만들어져 있는데, 검사기가 칸을 편집하지 못했다는 이유로 FAIL을 남겼다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_1_BizPlan/DMF0042_1_BizPlan.cs:963 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF00 | Doc/e2e/specs/_trace.spec.ts:1534 빈값 위반에서 대상 칸이 편집 불가이면 신규행을 그대로 Save해 확인하지 않고 FAIL을 기록한다. |
| V-9e32aa7e | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| V-f94b3ae0 | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| V-9ac1dcbf | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| V-e02c62bd | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-fa946da2 | M3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-8c22dd59 | G5 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-1dd724bf | H6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-a7450372 | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-fd83fda3 | MS1 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| V-d287ea11 | G5 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-7ef290e8 | H6 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-41d355a1 를 검토) |  |  |  |
| V-61b1b3e0 | M3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-b0b18d13 | G5 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-c02d48d9 | H6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-8f152d01 | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-d9e8d469 | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-1210bb26 | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-675768c9 | M3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-d830ece8 | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-164c2875 | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-ad991fd0 | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-926405f0 | H6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-f32309f8 | M3 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-99d60d99 | H6 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-127be395 를 검토) |  |  |  |
| V-260c75c6 | H6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-eea1d3ba | G5 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-9f2394e9 | H6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-57c69aef | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-c7ef8901 | MS1 | 판정필요 | TOBE룰 | PASS | Y | Y AS-IS 원문 인용 확인 | AS-IS는 Insert 행이 있을 때 Bucket 목록을 누르면 MSG00227 「INSERT 모드에서는 저장 후 Bucket 변경이 가능합니다.」를 띄웁니다. TO-BE는 같은 MSG00227을 「Insert 된 행이 있어 Bucket 을 변경할 수 없습니다.」 차단 문구로 씁니다. 이 차이는 DD-006에 등록되어 있고, DMF0042도 Edit 모드가 없어(DD-118) 같은 사유가 적용됩니다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_1_BizPlan/DMF0042_1_BizPlan.cs:2967 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0 |  |
| V-d9ba3d99 | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-1b89c571 | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-e6f1d35b | G5 | ERROR | 검토 제외 |  | N | N 재측정 대상(재실행·자동) — AI 판정 대상 아님 |  |  |  |
| V-1841845a | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-94591724 | H6 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-0fe103d1 를 검토) |  |  |  |
| V-a1e299fa | M3 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-addb38a8 | H6 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-0fe103d1 를 검토) |  |  |  |
| V-da6826d9 | H6 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-0fe103d1 를 검토) |  |  |  |
| V-5c44599d | H6 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-01698a4b 를 검토) |  |  |  |
| V-9bea4449 | M3 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-a24593e0 | H6 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-01698a4b 를 검토) |  |  |  |
| V-88f0ade7 | H6 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-01698a4b 를 검토) |  |  |  |
| V-b3cdb1c2 | C3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-47393edc | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-53d87686 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-584f49e4 | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-7614fc19 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-98094696 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-7d70355d | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-7f1911d3 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-1d9e1a39 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-c54b23c8 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-c3bbdde2 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-0852f630 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-2658ad65 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-330f2268 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-7077f3fe | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-642d797d | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-5885f41e | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-3dca26aa | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-6df9e6f9 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-dad7414b | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-473071e0 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-694ec72d | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-f6711b82 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-29675b46 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-35b1f359 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-37deac1d | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-fadef0b2 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-160972e4 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-7b2de9cc | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-6ca601d9 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-019de781 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-2406551a | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-1d253b7e | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-cf59e1f5 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-4d7dfec1 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-f908c1b1 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-b05a3528 | C2 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-6b239e3a 를 검토) |  |  |  |
| V-7ce487e9 | C2 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-352cec4e 를 검토) |  |  |  |
| V-2e0bc043 | C2 | ERROR | 검토 제외 |  | N | N 재측정 대상(데이터전제·엔진) — AI 판정 대상 아님 |  |  |  |
| V-af42cc69 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-770aab80 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-354f5a34 | H2 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-13a04bd9 를 검토) |  |  |  |
| V-b5eb95a2 | D3 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-1877323e 를 검토) |  |  |  |
| V-45a867d9 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-7cab4105 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-18ad7fc4 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-9395d93c | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-22b95950 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-3fbfc321 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-7a695f0e | D3 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-4f782b7a 를 검토) |  |  |  |
| V-94f9af94 | G1 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-16b773e6 를 검토) |  |  |  |
| V-d5c81478 | G1 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-0b438463 를 검토) |  |  |  |
| V-e72422d9 | G1 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-53ee84c8 를 검토) |  |  |  |
| V-4dcf777c | H2 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-065768b7 를 검토) |  |  |  |
| V-12b2a8fa | C2 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-0f4cf892 | C2 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-f7d398ae | C2 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-2b5ecc16 를 검토) |  |  |  |
| V-cb714874 | C2 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-1d558d3a | C2 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-989e15cf | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-030af756 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-751c9e1c | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-d0c9b7a4 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-8b4b3e70 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-a7705144 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-6b30d62b | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-362e38a7 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-60014812 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-efd838b0 | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| V-e3630fbf | E4 | FAIL | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | [대표 V-119e9de9 와 같은 증거] AS-IS는 Division 81 행에서 Project, Team, Sales Site, Plant Site, Model, End Customer, FcstType, Incoterms, Currency 중 하나라도 비어 있으면 MSG00310으로 저장을 막는다. TO-BE도 Division 81에서 같은 칸을 필수로 검사하고 알림을 띄운 뒤 저장을 멈춘다. Project 칸은 팝업으로만 입력되지만 신규행이 처음부터 비어 | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_1_BizPlan/DMF0042_1_BizPlan.cs:930 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF00 | Doc/e2e/specs/_trace.spec.ts:1534 빈값 위반에서 대상 칸이 편집 불가이면 신규행을 그대로 Save해 확인하지 않고 FAIL을 기록한다. |
| V-87e8f4da | E4 | FAIL | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | [대표 V-119e9de9 와 같은 증거] AS-IS는 Division 81 행에서 Project, Team, Sales Site, Plant Site, Model, End Customer, FcstType, Incoterms, Currency 중 하나라도 비어 있으면 MSG00310으로 저장을 막는다. TO-BE도 Division 81에서 같은 칸을 필수로 검사하고 알림을 띄운 뒤 저장을 멈춘다. Project 칸은 팝업으로만 입력되지만 신규행이 처음부터 비어 | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_1_BizPlan/DMF0042_1_BizPlan.cs:930 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF00 | Doc/e2e/specs/_trace.spec.ts:1534 빈값 위반에서 대상 칸이 편집 불가이면 신규행을 그대로 Save해 확인하지 않고 FAIL을 기록한다. |
| V-c148f2fc | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| V-0061079c | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| V-c9457d29 | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| V-86dcf637 | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-cb73350f | M3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-1c078df1 | G5 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-538d180a | H6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-e83fd292 | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-b0060baf | G5 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-d7dd8ff5 | H6 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-41d355a1 를 검토) |  |  |  |
| V-d9311d6a | M3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-549f5646 | G5 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-9f2b5927 | H6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-0e2a72bd | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-70c4b471 | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-868f5891 | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-a61baf50 | M3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-1d196413 | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-b38b55d4 | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-12fa1b10 | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-1af3bc3d | H6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-e2d3e239 | M3 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-127be395 | H6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-68a856f1 | H6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-731389b5 | G5 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-8c9c8509 | H6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-034982a8 | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-6bbd9c1f | H6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-6cecd4cf | H6 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-6bbd9c1f 를 검토) |  |  |  |
| V-5448b137 | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-26c433fa | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-7880f905 | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-831155be | H6 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-0fe103d1 를 검토) |  |  |  |
| V-8bcd645c | M3 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-3bf44110 | H6 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-0fe103d1 를 검토) |  |  |  |
| V-14b9b3fb | H6 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-0fe103d1 를 검토) |  |  |  |
| V-46afa1eb | C3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-0a1d518f | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-d23130f7 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-adbaa1ff | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-fb2c9dc5 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-c3cce468 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-29e59967 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-b4166d47 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-1fd7a706 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-041c5afa | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-d2cd269a | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-d7c80802 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-6ac15ddb | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-5ea410a2 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-8e39c458 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-f7feb5f4 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-19289a65 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-73930660 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-14e709cb | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-ee9f83fd | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-b55a59f2 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-c5a505ce | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-f7cc2d95 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-18d92c80 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-74199cad | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-4cba64eb | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-40a8e25b | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-6105b03a | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-7d23ad76 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-65cc0471 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-c095fb25 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-48bb1499 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-2f42a298 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-8942b873 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-5a9af464 | C2 | ERROR | 검토 제외 |  | N | N 재측정 대상(데이터전제·엔진) — AI 판정 대상 아님 |  |  |  |
| V-e316719e | C2 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-6e5a1f04 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(데이터전제·엔진) — AI 판정 대상 아님 |  |  |  |
| V-187364fa | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(데이터전제·엔진) — AI 판정 대상 아님 |  |  |  |
| V-172913c2 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(데이터전제·엔진) — AI 판정 대상 아님 |  |  |  |
| V-dd620832 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(데이터전제·엔진) — AI 판정 대상 아님 |  |  |  |
| V-560baf7f | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(데이터전제·엔진) — AI 판정 대상 아님 |  |  |  |
| V-1b319d46 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(데이터전제·엔진) — AI 판정 대상 아님 |  |  |  |
| V-13a04bd9 | H2 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-1877323e | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-f5ef5906 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-35b9641a | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-a43d2526 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-ecd9625c | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-8cb9df36 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-3d7ded35 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-462f92ad | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-17d057f6 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-41b9e6f8 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-8c87cf7f | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-4f782b7a | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-a9b5158e | G1 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-16b773e6 를 검토) |  |  |  |
| V-48fe12e3 | G1 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-0b438463 를 검토) |  |  |  |
| V-c621a149 | G1 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-53ee84c8 를 검토) |  |  |  |
| V-065768b7 | H2 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-23b2ae22 | C2 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-12b2a8fa 를 검토) |  |  |  |
| V-b9f3c79d | C2 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-00a512a7 를 검토) |  |  |  |
| V-30492e9e | C2 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-67527be1 | C2 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-2b5ecc16 를 검토) |  |  |  |
| V-883d5fc3 | C2 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-0db507c9 를 검토) |  |  |  |
| V-a023207f | C2 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-22c6c547 를 검토) |  |  |  |
| V-8c171624 | C2 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-0a94fc5c 를 검토) |  |  |  |
| V-996ba14d | C2 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-5fd584a1 를 검토) |  |  |  |
| V-9f2c0cc5 | C2 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-1d558d3a 를 검토) |  |  |  |
| V-6a338f10 | C2 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-7bc2022f | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-37dd1366 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-785bc64d | D3 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-20671d62 를 검토) |  |  |  |
| V-0ef8b73e | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-4bf17a94 | D3 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-209dc917 를 검토) |  |  |  |
| V-f0c56291 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-56553955 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-c4b82561 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-e1b4fd41 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-bcef4902 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-c26cf45f | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-3c68f552 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-0099668d | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-0e00d3fa | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-39fa15d9 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-8ab94674 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-cd28df71 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-5daea270 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-3696216c | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-de09a2ea | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-a9cb9213 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-0631b851 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-63cd2b88 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-a0db4200 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-cffefd2b | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-a1f7751a | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-c44471f2 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-ed14de64 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-43855815 | D3 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-1f73066c 를 검토) |  |  |  |
| V-e42a1dc7 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-35849caf | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-d7540b20 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-f191bccd | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-2def49d9 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-0c7d515b | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-964cfe20 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-71d9b608 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-ad5123e2 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-dafde4cc | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-9cdb17e7 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-f7804a04 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-1e7f5552 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-4cb7603b | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-714a9f09 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-74f78bd1 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-d30e9cb3 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-a0084413 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-a622a2a8 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-a5a16a23 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-b76a9bf9 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-66fb1927 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-c48d01f8 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-61b90dcd | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-0cb9d4fa | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| V-d9b2a1c2 | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| V-10fd120c | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| V-bca54e32 | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| V-1e24d9fe | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| V-5b412dc3 | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| V-49247b0f | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| V-82c08dd4 | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-31ccdc9f | M3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-09514ccd | G5 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-38555156 | H6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-76e7b693 | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-efc55908 | G5 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-41d355a1 | H6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-d5b20abe | M3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-8a21db8f | G5 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-03ff3146 | H6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-c7c1bd4d | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-8b285a32 | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-5179558f | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-1b4aec2a | M3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-e3661a2a | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-e9fba552 | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-883a7df0 | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-fc39508c | H6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-02175830 | M3 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-c1eeb83b | H6 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-127be395 를 검토) |  |  |  |
| V-99c4b743 | H6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-546e5d43 | G5 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-b603d031 | H6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-61fabbab | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-25aabeee | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-6d74450e | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-75dbe2b3 | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-0fe103d1 | H6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-55e298ba | M3 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-9cfaf9f4 | H6 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-0fe103d1 를 검토) |  |  |  |
| V-983f0408 | H6 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-0fe103d1 를 검토) |  |  |  |
| V-93cdbd29 | H6 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-01698a4b 를 검토) |  |  |  |
| V-d1823927 | M3 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-01698a4b | H6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-9806662b | H6 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-01698a4b 를 검토) |  |  |  |
| V-288260e0 | C3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-2e038f64 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-cadc2ede | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-b64b7fd8 | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-61e12d37 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-90113d18 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-9c16c17d | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-c365120a | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-661042ac | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-9443bc6e | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-e967da30 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-9728dfd9 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-b3fa48b7 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-ea340dc9 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-059b533a | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-55d99ff9 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-acbc1fe9 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-47aed639 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-046281af | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-fa1dc537 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-554e903c | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-a7af497a | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-d131e2b9 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-de007a20 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-13e5e006 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-553cd448 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-40a7fcd4 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-cefdc65b | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-df828ae0 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-9ae37f47 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-7f10ecf1 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-631f8106 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-88eb7a48 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-0be994b5 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-71cbba48 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-c5cabeaa | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-6b239e3a | C2 | ERROR | 검토 제외 |  | N | N 재측정 대상(데이터전제·엔진) — AI 판정 대상 아님 |  |  |  |
| V-eaed62c2 | C2 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-352cec4e 를 검토) |  |  |  |
| V-8171f79d | C2 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-2e0bc043 를 검토) |  |  |  |
| V-6124c5b9 | H2 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-13a04bd9 를 검토) |  |  |  |
| V-f7af37e1 | D3 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-1877323e 를 검토) |  |  |  |
| V-d327cc68 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-504cddb6 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-c15b5f82 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-67544cbf | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-f54ca620 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-ff842882 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-cd2ca248 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-5b798614 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-89038ff4 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-faea4617 | D3 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-4f782b7a 를 검토) |  |  |  |
| V-30437554 | G1 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-16b773e6 를 검토) |  |  |  |
| V-0b438463 | G1 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-53ee84c8 | G1 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-bd1900e1 | H2 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-065768b7 를 검토) |  |  |  |
| V-7cd3a1cf | C2 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-12b2a8fa 를 검토) |  |  |  |
| V-618f33e6 | C2 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-00a512a7 를 검토) |  |  |  |
| V-96ed3c12 | C2 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-30492e9e 를 검토) |  |  |  |
| V-482c21d4 | C2 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-2b5ecc16 를 검토) |  |  |  |
| V-dfec9ce3 | C2 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-0db507c9 를 검토) |  |  |  |
| V-22c6c547 | C2 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-cc060c9c | C2 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-0a94fc5c 를 검토) |  |  |  |
| V-c9358c4d | C2 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-5fd584a1 를 검토) |  |  |  |
| V-88e25df3 | C2 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-1d558d3a 를 검토) |  |  |  |
| V-bc528860 | C2 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-16f24a4c 를 검토) |  |  |  |
| V-b4a06a5e | C2 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-35c0b257 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-97a51494 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-af524574 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-20671d62 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-ba149f1d | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-fe8e9952 | D3 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-209dc917 를 검토) |  |  |  |
| V-b7995b55 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-8e706c56 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-970b172c | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-d86bfeaf | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-6e9c3a44 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-29035ddb | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-653bb94f | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-fec48d73 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-24717eb6 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-fc49dde8 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-63ee327c | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-8ea76ab5 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-612b6b9f | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-c21d758e | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-8052d91a | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-15665443 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-9dbc3120 | D3 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-1f73066c 를 검토) |  |  |  |
| V-b593741e | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-243b066e | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-f52331b7 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-3a2d9c41 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-627a5b35 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-2a129cf7 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-8b902401 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-89d56c4a | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-0df6c30a | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-f064c63e | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-6d987603 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-99adf32c | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-c3aa5d2c | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-09d17701 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-2cba6272 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-7355779d | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-5d8eb272 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-a9a92c1e | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-910b4706 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-6f4157d9 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-349ba015 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-31ba5170 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-26b2f700 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-5eea7981 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-54761c50 | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| V-05ed2d14 | E4 | FAIL | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | [대표 T-1115bd5d 와 같은 증거] AS-IS SaveData는 Division 40 행에서 End Customer, Sales Site, Model, Currency, FcstType, Incoterms, Cell Prod Site 중 하나라도 비어 있으면 MSG00310을 띄우고 저장을 멈춘다. TO-BE도 Save 때 같은 칸을 필수로 검사해 '{0} 값은 필수 입력 항목입니다.' 알림을 띄우고 저장을 막는다. 같은 화면의 E7 측정에서도 신규행 S | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_1_BizPlan/DMF0042_1_BizPlan.cs:900 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF00 | Doc/e2e/specs/_trace.spec.ts:1534 빈값 위반은 신규행이 처음부터 비어 있어 이미 충족되는데, 대상 칸이 편집 불가라는 이유로 Save 시도 없이 FAIL을 기록한다. |
| V-a8a9ff28 | E4 | FAIL | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | [대표 V-119e9de9 와 같은 증거] AS-IS는 Division 81 행에서 Project, Team, Sales Site, Plant Site, Model, End Customer, FcstType, Incoterms, Currency 중 하나라도 비어 있으면 MSG00310으로 저장을 막는다. TO-BE도 Division 81에서 같은 칸을 필수로 검사하고 알림을 띄운 뒤 저장을 멈춘다. Project 칸은 팝업으로만 입력되지만 신규행이 처음부터 비어 | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_1_BizPlan/DMF0042_1_BizPlan.cs:930 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF00 | Doc/e2e/specs/_trace.spec.ts:1534 빈값 위반에서 대상 칸이 편집 불가이면 신규행을 그대로 Save해 확인하지 않고 FAIL을 기록한다. |
| V-f0299336 | E4 | FAIL | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | [대표 V-a097e1c2 와 같은 증거] AS-IS는 Division 82 행에서 Team, Currency, Unit Energy 중 하나라도 비어 있으면 MSG00310으로 저장을 막는다. TO-BE도 Division 82에서 Team, Unit Energy, Currency를 필수로 검사해 저장을 막는다. 신규행 Team은 처음부터 비어 있으므로 위반 상태가 이미 만들어져 있는데, 검사기가 칸을 편집하지 못했다는 이유로 FAIL을 남겼다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_1_BizPlan/DMF0042_1_BizPlan.cs:963 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF00 | Doc/e2e/specs/_trace.spec.ts:1534 빈값 위반에서 대상 칸이 편집 불가이면 신규행을 그대로 Save해 확인하지 않고 FAIL을 기록한다. |
| V-6b3077b3 | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| V-d536761c | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| V-ba4a4e6b | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| V-aa9f4ac3 | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-084a9f65 | M3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-40972618 | G5 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-f2abcf20 | H6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-7dfd4189 | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-d0b478c2 | G5 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-b56c42ad | H6 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-41d355a1 를 검토) |  |  |  |
| V-47ddfba8 | M3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-1cef95c2 | G5 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-f2c4be03 | H6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-39cdf70a | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-bb1b832d | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-de1d5f8b | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-7189d831 | M3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-8fd84844 | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-07e182b0 | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-5163b15e | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-ad3cf845 | H6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-0679fe5e | M3 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-ac6948f9 | H6 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-127be395 를 검토) |  |  |  |
| V-404870f2 | H6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-5f26da35 | G5 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-e1c57710 | H6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-394a8240 | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-3da3fdc9 | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-10d1a11a | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-9b10cb34 | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-f0013a5a | H6 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-0fe103d1 를 검토) |  |  |  |
| V-1d043b2b | M3 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-a0df5abc | H6 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-0fe103d1 를 검토) |  |  |  |
| V-c9035f1f | H6 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-0fe103d1 를 검토) |  |  |  |
| V-ae045e5c | H6 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-01698a4b 를 검토) |  |  |  |
| V-ac72aa62 | M3 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-24a743ce | H6 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-01698a4b 를 검토) |  |  |  |
| V-24ba7a9a | H6 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-01698a4b 를 검토) |  |  |  |
| V-11d2b717 | C3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-1bf77ea9 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-2399d393 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-b8eeaeb8 | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-4bd8e0bf | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-083eb5a4 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-d50d66de | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-34d893af | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-2ec3951a | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-7a6b582c | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-b3d0c504 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-5d90aae0 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-cc1e2799 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-2200f2f9 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-6881513f | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-ea2ece32 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-0ea8234c | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-9d6199e0 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-7ab7c182 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-d73d2f8b | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-2e69e89c | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-1ba2e0b3 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-2bdba5c7 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-0df0b7a4 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-299ad2ce | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-90e9acc7 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-6fb4bd9f | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-88dabf64 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-0b83abe8 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-4a2bdfba | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-d02ffbd7 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-da7b8e60 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-cfb1baae | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-8da318ca | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-ca792127 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-ef473002 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-b0a7c3a7 | C2 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-6b239e3a 를 검토) |  |  |  |
| V-352cec4e | C2 | ERROR | 검토 제외 |  | N | N 재측정 대상(데이터전제·엔진) — AI 판정 대상 아님 |  |  |  |
| V-b01e8ad8 | C2 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-2e0bc043 를 검토) |  |  |  |
| V-bf6cee0c | H2 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-13a04bd9 를 검토) |  |  |  |
| V-ea268706 | D3 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-1877323e 를 검토) |  |  |  |
| V-c490a7a9 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-ca712f4a | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-c91585f3 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-6131c08d | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-ddec28e1 | G1 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-16b773e6 를 검토) |  |  |  |
| V-50db9387 | G1 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-0b438463 를 검토) |  |  |  |
| V-c6fad0ce | G1 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-53ee84c8 를 검토) |  |  |  |
| V-48e07650 | H2 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-065768b7 를 검토) |  |  |  |
| V-4c266218 | C2 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-12b2a8fa 를 검토) |  |  |  |
| V-71889896 | C2 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-837516a9 | C2 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-2b5ecc16 를 검토) |  |  |  |
| V-ed8628c3 | C2 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-0db507c9 를 검토) |  |  |  |
| V-ca95afc3 | C2 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-22c6c547 를 검토) |  |  |  |
| V-20184eda | C2 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-0a94fc5c 를 검토) |  |  |  |
| V-d7bd3496 | C2 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-5fd584a1 를 검토) |  |  |  |
| V-9eb33426 | C2 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-1d558d3a 를 검토) |  |  |  |
| V-57706630 | C2 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-16f24a4c 를 검토) |  |  |  |
| V-83df1cdf | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-427fc956 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-0cf1835d | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-f9310ca8 | D3 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-20671d62 를 검토) |  |  |  |
| V-05a40d09 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-209dc917 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-6280cccd | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-8d8067ec | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-782bc8b5 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-0bc20709 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-7a4bea94 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-5189ca5e | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-a1af73f4 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-76947a02 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-9687ca5f | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-9a167a98 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-bfb38f64 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-dd6c8aab | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-a1dc0498 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-fd94ec64 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-890aea0a | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-2939924d | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-42141938 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-0e00ba65 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-a8b2ddf3 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-41fb6514 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-57f8e51f | D3 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-1f73066c 를 검토) |  |  |  |
| V-4ab3656e | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-18c12ac8 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-1fa05ae0 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-3184e58e | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-ff9466de | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-dd7349fe | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-c8fd9b5c | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-1f3c1331 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-0f94ad4e | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-570efe83 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-ca2a7a46 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-1f3693ef | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-177dc1f8 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-b317b3cb | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-514d937b | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-fe3265fe | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-eefa930d | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| V-421dc349 | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| V-ead4c1e1 | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| V-8a7111a9 | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| V-64ccae99 | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-9e2dfac9 | M3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-7ca5414e | G5 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-be24c7f2 | H6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-ed525b64 | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-ec8f7299 | G5 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-32aec8b9 | H6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-cf027b3b | H6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-7e9fa75c | M3 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-1dc2dcf5 | H6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-bce797b1 | H6 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-1dc2dcf5 를 검토) |  |  |  |
| V-f6b8b38e | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-e239fb10 | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-816e6798 | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-7b310ef6 | M3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-95e84325 | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-81cfdc94 | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-78ed1abd | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-fecea1f5 | H6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-41d17e31 | M3 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-f42f338b | H6 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-127be395 를 검토) |  |  |  |
| V-6da216e3 | H6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-29f09ecf | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-27143bcc | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-273c7005 | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-3fa3b8d3 | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-27791849 | H6 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-26d4c6d6 를 검토) |  |  |  |
| V-1eb70f98 | M3 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-8435df85 | H6 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-26d4c6d6 를 검토) |  |  |  |
| V-26d4c6d6 | H6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-add7124d | H6 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-01698a4b 를 검토) |  |  |  |
| V-0092a45a | M3 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-37a0d36c | H6 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-01698a4b 를 검토) |  |  |  |
| V-03456d5d | H6 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-01698a4b 를 검토) |  |  |  |
| V-e0b2a706 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-545c61a8 | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-1d844f60 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-dd488d85 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-51cfc3cb | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-2877e7b4 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-2b5b23ae | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-6931a814 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-56b8d905 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-be707f86 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-196afbfd | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-5f0d2805 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-a26ecce8 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-df60eef3 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-31c22614 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-c42f4056 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-d7b22526 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-859503bd | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-547ec5d7 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-7718b4d4 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-ffb147a3 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-ce02db1d | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-68f00b95 | C2 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-0e51f7d4 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-6df9806b | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| V-11ab8740 | E4 | FAIL | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | AS-IS 환율 팝업은 신규행의 Division, Currency, Unit 중 하나라도 비어 있으면 MSG00002를 띄우고 저장을 막는다. TO-BE 환율 모달은 Insert 때 Division을 조회 조건 값으로 미리 채우므로 Division이 빈 상태가 생기지 않고, Currency와 Unit Currency가 비면 필수 알림으로 저장을 막는다. 검사기는 Unit Currency로 위반을 만들 수 있었는데도 편집할 수 없는 Division만 골라 FAIL | GSCM/06.UIL/GSCM.DM.Plan.UIL/POPUP/DMF0042_ExchangeRatePopup.cs:466 ; GSCM/06.UIL/GSCM.DM.Plan.UIL/POPUP/DMF0042_Exchang | Doc/e2e/specs/_trace.spec.ts:1534 위반 대상 칸이 편집 불가이면 같은 조건의 다른 칸(Unit Currency)으로 위반을 만들지 않고 바로 FAIL을 기록한다. |
| V-01895b79 | H2 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-92830b3d | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| V-bde38c44 | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| V-18658557 | A5 | FAIL | 검토 제외 |  | N | N 기준 원장 같은 확인 구성원(C-2acc225fdd 대표를 검토) |  |  |  |
| V-ad2b4dca | K2 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-0fb679eb | B4 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-6d694b03 | C1 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-ca4d1e05 | B8 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-5e5b2509 | G5 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-749650df | K3 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| V-c75a9861 | B2 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-7f8d1385 | B3 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-23380184 | B4 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-aacf8e58 | G2 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-a925c61e | G5 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-2719cbba | G4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-55e6abfd | H6 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-504ff38c | K2 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-996c2e73 | C2 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-34749c17 | G2 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-7215060e | F5 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-ab0669c0 | B4 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-c60845b7 | F1 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-5e38c9e3 | D5 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-1bfbb6e9 | M4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-3b323e85 | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-823c2839 | J1 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-c184d2f3 | F1 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-f1bc5ef6 | F1 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-80450ce5 | F1 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-2894053b | C1 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-c405f453 | B4 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-6027c896 | A7 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-1e5b985e | A6 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-2d1e7d12 | D2 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-a1f074a1 | F4 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-ac2a9771 | M3 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-77a180eb | F1 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-2f607023 | F1 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-9bd31255 | C4 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-51617de2 | F1 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-275afc71 | F4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-8cf879e4 | B8 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-12d6a0a6 | A7 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-f733b941 | A2 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-48fbfcca | A5 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-e2f15ee6 | D1 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-17638b0d | A5 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-d0f92b81 | B4 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-82726bdb | B5 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-f7d29c94 | K3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-ddf703af | B4 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-8a953c1c | C1 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-4e61756a | B2 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-88096b0e | F4 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-0a076bb3 | M3 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-5abc8ea0 | A2 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-7aefffc7 | G4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-a5d1e4a8 | B4 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-5d77228a | C2 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-d780eafc | B2 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-875dfc75 | C2 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-ad7d4fc8 | B4 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-907c9a5b | C1 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-1dcb2db3 | A2 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-02a05f79 | G5 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-a9ca17c4 | B5 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-396299b8 | D3 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-06f2159d | E1 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-f2173d62 | F5 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-0f5915ad | M3 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-b7f2cdaa | M3 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-426f769e | F4 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-a949c4f1 | E1 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-b887d94f | A5 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-4bf617fe | J1 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-49ea4cea | J2 | FAIL | 검토 제외 |  | N | N 기준 원장 같은 확인 구성원(C-7965053a05 대표를 검토) |  |  |  |
| V-1fdfbf66 | B4 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-125dd746 | E1 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-5d578863 | F4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-1581727a | E4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-50b54547 | F5 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-afc361fb | J2 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-9269e3e8 | D2 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-19398f31 | G4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-7f0c3f25 | G1 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-7a3d13a6 | B4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-5635d5f3 | M3 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-91143a59 | B4 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-9bcc6c19 | A5 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-e0170b21 | M3 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-8c711d99 | A5 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-923f1504 | K2 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-87d8282f | A5 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-c539e37f | G1 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-0dda8f98 | G4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-daba2fc0 | A5 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-802a7f44 | B4 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-db961e81 | G1 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-176cf4a7 | B5 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-3754649e | B4 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-21fc3a04 | B4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-f449e654 | F1 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-0ad25a82 | M3 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-759019f0 | F1 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-edb0d40b | A2 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-5159d7d1 | C3 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-3c4615d4 | B5 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-7af105fa | M3 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-812d17d4 | G5 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-2fe31875 | D5 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-df75f153 | B4 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-9c08f11b | B5 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-935e8595 | B4 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-c6513438 | B5 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-1f8bb35e | B4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-be2c6a6d | B7 | ERROR | 검토 제외 |  | N | N 기준 원장 같은 확인 구성원(C-f5318eaa14 대표를 검토) |  |  |  |
| V-03ae47b6 | A5 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-a4bd587c | D5 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-3cd60fca | A7 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-4bf24207 | F1 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-0356df7a | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-bc2afa25 | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-ded5ba0c | B4 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-dac72ce8 | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-b35e535f | G8 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-8f580f7b | B4 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-428e7009 | B4 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-893d4585 | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-8d437008 | M3 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-88553c41 | G2 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-d0a58272 | A2 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-745f1a7c | B4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-a45460de | F1 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-62a93e32 | E3 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-2cd3cd96 | F1 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-0e64b330 | F5 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-f1b3864b | D3 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-3cbc247b | H2 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-4d64bcdb | H5 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-d1e10635 | C2 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-fdc881c0 | B4 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-49e630b1 | B4 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-a1a8b607 | J2 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-9bd9600e | K4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-2ab1b418 | G4 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-f20982dc | J1 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-415ce83f | C3 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-7d2bb726 | M4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-eb4c10e7 | B5 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-3c065a80 | B3 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-62f12bb7 | B4 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-112f3c4a | G5 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-ccb3686a | M4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-fe45b1c5 | M3 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-7af0ebe9 | A5 | FAIL | 검토 제외 |  | N | N 기준 원장 같은 확인 구성원(C-2acc225fdd 대표를 검토) |  |  |  |
| V-8c99003d | A5 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-f5e10c9a | A5 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-199067fd | A5 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-c61c36e6 | B1 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-e72051c7 | B2 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-3c5919ea | B3 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-9d123473 | B4 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-b8077b5d | B4 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-cc1cda2a | B4 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-e90b073f | B5 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-34751a34 | B5 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-48fd3876 | B7 | ERROR | 검토 제외 |  | N | N 기준 원장 같은 확인 구성원(C-928edce48d 대표를 검토) |  |  |  |
| V-9d31e396 | C2 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-87b7289a | C3 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-a66ccece | E1 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-012b89a9 | E4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-71f82c13 | E4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-defba45b | F1 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-8b169d18 | F1 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-a9c95b85 | G1 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-8bfc0848 | G1 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-006265f3 | G8 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-b13d1f65 | G9 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-253ab5a4 | J2 | FAIL | 검토 제외 |  | N | N 기준 원장 같은 확인 구성원(C-7965053a05 대표를 검토) |  |  |  |
| V-c7553b33 | K2 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-6c0249cf | K3 | FAIL | 확인불가 | FAIL | Y | N 판정 같음 | AS-IS DMF0042 에는 Version 팝업이 없고(Item·Project·TitleSet·Owner·ExchangeRate 팝업만 있음), 검사기는 Model/Nickname 팝업으로 바꿔 F5 를 재서 조회 호출 0건을 기록했다. TO-BE 조회는 조건값 기준 캐시를 쓰므로 조건이 바뀌지 않았으면 호출이 0건일 수 있고, 팝업을 닫은 뒤 F5 가 화면에 닿지 않았을 수도 있다. 화면을 실제로 띄워야 가릴 수 있다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:2856 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_ |  |
| V-6f979730 | N1 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-230d60d2 | A5 | FAIL | 검토 제외 |  | N | N 기준 원장 같은 확인 구성원(C-2acc225fdd 대표를 검토) |  |  |  |
| V-3bbec90d | B4 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-39a87d7c | B2 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-9da416a8 | C2 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-91311fde | C2 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-e2d54714 | B8 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-74db9b2c | A5 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-23c7cfe0 | J1 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-03a5290c | G2 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-ceefb23d | M3 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-f71d781f | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-106cb31a | G1 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-580807db | G1 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-3f695b21 | F5 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-4f88b67f | B4 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-a02d5380 | J2 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-21a6d16a | H2 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-f16257fb | A6 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-90070474 | F5 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-23d2f1c9 | F1 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-d9182b88 | E3 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-8a235203 | G5 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-5270da16 | K4 | ERROR | 검토 제외 |  | N | N 스냅샷 승인 대기(snap_validate·snap_approve 경로) |  |  |  |
| V-d40d8a1f | H6 | ERROR | 검토 제외 |  | N | N 스냅샷 승인 대기(snap_validate·snap_approve 경로) |  |  |  |
| AD-5507fe93 | A1 | ERROR | 검토 제외 |  | N | N 재측정 대상(재실행·자동) — AI 판정 대상 아님 |  |  |  |
| AD-4e15ffb8 | A7 | ERROR | 검토 제외 |  | N | N 재측정 대상(재실행·자동) — AI 판정 대상 아님 |  |  |  |
| AD-673a7d1b | A5 | ERROR | 검토 제외 |  | N | N 재측정 대상(재실행·자동) — AI 판정 대상 아님 |  |  |  |
| AD-a9b38f17 | A6 | ERROR | 검토 제외 |  | N | N 재측정 대상(재실행·자동) — AI 판정 대상 아님 |  |  |  |
| AD-6ed785f8 | A5 | FAIL | TOBE룰 | PASS | Y | N TO-BE 룰 예외는 FAIL 근거 룰과 다른 등록 룰 번호 필요 | Division 40 호출에서도 AS-IS 결과 컬럼은 TO-BE 에 모두 있고, TO-BE 에만 사용자·메뉴 편집 권한 칸 EDIT_YN 1개가 더 있습니다. 이 칸은 화면에 표시되지 않는 편집 판정용 칸으로 Edit 버튼이 없는 TO-BE 공통 구조에 따른 것이며, DMF0068 에는 DD-161 로 등록돼 있지만 DMF0042 에는 아직 등록되지 않았습니다. 행 수 차이(AS-IS 25행, TO-BE 19행)와 값 불일치 셀 21개는 CR-105 에 따라  | To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.sql:884 ; To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.sq |  |
| AD-fd92ff76 | A5 | FAIL | TOBE룰 | PASS | Y | Y 등록 룰 DD-118 + 인용 확인 | Division 81, 사용자 minyonglee1 호출에서도 컬럼 집합 차이는 TO-BE 전용 EDIT_YN 하나이고 AS-IS 전용 컬럼은 없다. Edit 버튼을 없앤 TO-BE 의 편집 권한 컬럼이므로 DD-118 에 해당한다. | To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.sql:1093 ; tools/Harness/rules/tobe_rule_registry.csv |  |
| AD-d507cada | A5 | FAIL | TOBE룰 | PASS | Y | Y 등록 룰 CR-103 + 인용 확인 | Division 81_HD 호출에서도 차이는 TO-BE 에만 있는 EDIT_YN 한 칸뿐이다. 이 칸은 Edit 버튼이 없는 TO-BE 가 사용자·메뉴 편집 권한을 받으려고 넣은 칸으로, CR-103·DD-118 의 상시 편집 설계에 따른 차이다. 행 수 차이(AS-IS 24행, TO-BE 12행)는 이 컬럼 집합 행이 판정할 대상이 아니다. | To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.sql:1093 ; To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.s |  |
| AD-5642889c | A5 | FAIL | TOBE룰 | PASS | Y | N TO-BE 룰 예외는 FAIL 근거 룰과 다른 등록 룰 번호 필요 | Division 82 조회에서도 TO-BE PROC 만 EDIT_YN 한 칸을 더 돌려주고, 나머지 결과 컬럼은 AS-IS 와 같다. EDIT_YN 은 화면에 보이지 않는 편집 권한 칸이라 그리드 컬럼 구성은 같다. 전 화면 공통으로 허용할 TO-BE 차이이며(DMF0068 에는 DD-161 로 등록) DMF0042 에는 아직 등록되지 않았다. | To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.sql:1093 ; To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.s |  |
| AD-44a82704 | A5 | FAIL | TOBE룰 | PASS | Y | Y 등록 룰 CR-103 + 인용 확인 | Division 81_HG 조회에서도 TO-BE 에만 있는 칸은 EDIT_YN 하나입니다. 이 칸은 사용자·메뉴 편집 권한으로 편집 가능 여부를 정하는 칸이고 그리드 표시 칸 구성은 바꾸지 않습니다. 행 수 차이(AS-IS 24행, TO-BE 12행)는 CR-105 에 따라 판정에서 뺍니다. | To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.sql:884 ; To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.sq |  |
| AD-340b33ed | A5 | FAIL | TOBE룰 | PASS | Y | N TO-BE 룰 예외는 FAIL 근거 룰과 다른 등록 룰 번호 필요 | AS-IS DMF0042_GET_SPREAD_TITLE 결과는 ATTRIBUTE5 가 마지막 컬럼이고, TO-BE 는 사용자·메뉴 편집 권한(PR_SCM_EDIT_YN)에서 EDIT_YN 컬럼 하나를 더 돌려준다. 이 컬럼은 편집 버튼이 없는 TO-BE 편집 권한 모델(CR-103)에 쓰는 추가 칸이고 화면 헤더 구성에는 쓰이지 않는다. 행 수 차이(24행과 12행)는 CR-105 에 따라 판정에서 뺀다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:2953 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_ |  |
| AD-bf63af82 | A5 | FAIL | TOBE룰 | PASS | Y | Y 등록 룰 CR-103 + 인용 확인 | Division 81_ST 호출에서도 차이는 TO-BE 에만 있는 EDIT_YN 한 칸뿐이다. 이 칸은 Edit 버튼이 없는 TO-BE 가 사용자·메뉴 편집 권한을 받으려고 넣은 칸으로, CR-103·DD-118 의 상시 편집 설계에 따른 차이다. 행 수 차이(AS-IS 24행, TO-BE 12행)는 이 컬럼 집합 행이 판정할 대상이 아니다. | To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.sql:1093 ; To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.s |  |
| AD-418db9b8 | A5 | FAIL | TOBE룰 | PASS | Y | Y 등록 룰 CR-103 + 인용 확인 | Division 81_UC 조회에서도 TO-BE 에만 있는 칸은 EDIT_YN 하나입니다. 이 칸은 사용자·메뉴 편집 권한 함수 PR_SCM_EDIT_YN 에서 오며 화면에 표시되지 않고 편집 판정에만 쓰입니다. 행 수 차이(AS-IS 24행, TO-BE 12행)는 CR-105 에 따라 판정에서 뺍니다. | To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.sql:884 ; To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.sq |  |
| AD-65ce1dee | A5 | FAIL | TOBE룰 | PASS | Y | N TO-BE 룰 예외는 FAIL 근거 룰과 다른 등록 룰 번호 필요 | Division 40 조회에서 컬럼 집합 차이는 TO-BE 의 EDIT_YN 한 칸뿐이다. 이 칸은 화면에 보이지 않는 편집 권한 칸이라 그리드 컬럼 구성은 같다. 공통 7행의 값 불일치 21건과 행 수 차이(25행과 19행)는 CR-105 에 따라 이 판정에서 뺀다. 전 화면 공통으로 허용할 TO-BE 차이이며(DMF0068 에는 DD-161 로 등록) DMF0042 에는 아직 등록되지 않았다. | To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.sql:1093 ; To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.s |  |
| AD-0329b6b1 | A1 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-4c91d45e | A7 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-0630ecbe | A5 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-128bf586 | A6 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-8724abae | A1 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-66be4152 | A7 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-b783eceb | A5 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-d6245301 | A6 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-5d91c7fc | A1 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-e22f0c5c | A7 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-036885fc | A5 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-74b9d02d | A6 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-8626cfc2 | A1 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-de813715 | A7 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-f4c3d4cd | A5 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-6f2e9048 | A6 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-4ff725ea | A5 | FAIL | TOBE룰 | PASS | Y | Y 등록 룰 CR-103 + 인용 확인 | Division 40 조회(bindy122678 계정)에서도 TO-BE 에만 있는 칸은 EDIT_YN 하나입니다. 이 칸은 사용자·메뉴 편집 권한으로 편집 가능 여부를 정하는 칸이고 그리드 표시 칸 구성은 바꾸지 않습니다. 공통 7행의 값 차이 21셀은 CR-105 에 따라 판정에서 뺍니다. | To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.sql:884 ; To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.sq |  |
| AD-3ed60b5f | A5 | FAIL | TOBE룰 | PASS | Y | Y 등록 룰 CR-103 + 인용 확인 | AS-IS DMF0042_GET_SPREAD_TITLE 의 결과 칸은 ATTRIBUTE5 에서 끝납니다. TO-BE 는 Edit 버튼 없이 사용자·메뉴 편집 권한(PR_SCM_EDIT_YN)으로 편집 가능 여부를 정하므로 EDIT_YN 칸 하나를 더 내보냅니다. 이 칸은 그리드에 표시되지 않고 편집 판정에만 쓰입니다. 이는 CR-103 편집 권한 자동 적용 규칙에 따른 차이이며 DMF0068 의 DD-161 과 같은 경우입니다. | To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.sql:884 ; To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.sq |  |
| AD-9c9ba648 | A5 | FAIL | TOBE룰 | PASS | Y | Y 등록 룰 CR-103 + 인용 확인 | AS-IS DMF0042_GET_SPREAD_TITLE 결과는 ATTRIBUTE5 에서 끝나고, TO-BE 는 사용자·메뉴 편집 권한(PR_SCM_EDIT_YN)의 EDIT_YN 칸을 하나 더 돌려준다. TO-BE 는 Edit 버튼이 없어 편집 권한을 조회 결과로 받으므로(CR-103, DD-118) 등록된 차이이고, 이 칸은 헤더 메타의 속성일 뿐 그리드 컬럼을 늘리지 않는다. 같은 방식의 DMF0068 EDIT_YN 은 DD-161 로 등록되어 있으니 DMF | To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.sql:884 ; To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.sq |  |
| AD-9c488d23 | A5 | FAIL | TOBE룰 | PASS | Y | N TO-BE 룰 예외는 FAIL 근거 룰과 다른 등록 룰 번호 필요 | AS-IS DMF0042_GET_SPREAD_TITLE 의 결과 컬럼은 ATTRIBUTE5 에서 끝나고, Division 40 호출에서도 AS-IS 컬럼은 TO-BE 결과에 모두 있습니다. TO-BE 는 사용자·메뉴 편집 권한을 붙이려고 화면에 표시하지 않는 EDIT_YN 컬럼 하나만 더 내보냅니다. AS-IS 컬럼이 모두 있고 화면에 표시하지 않는 편집 권한 칸만 더해진 차이는 오류가 아니며, DMF0068 DD-161 과 같은 차이입니다. | To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.sql:1093 ; To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.s |  |
| AD-9687b699 | A5 | FAIL | TOBE룰 | PASS | Y | N TO-BE 룰 예외는 FAIL 근거 룰과 다른 등록 룰 번호 필요 | AS-IS DMF0042_GET_SPREAD_TITLE 의 결과 컬럼은 ATTRIBUTE5 에서 끝나고, AS-IS 컬럼은 TO-BE 결과에 모두 있습니다. TO-BE 는 사용자·메뉴 편집 권한을 붙이려고 화면에 표시하지 않는 EDIT_YN 컬럼 하나만 더 내보냅니다. AS-IS 컬럼이 모두 있고 화면에 표시하지 않는 편집 권한 칸만 더해진 차이는 오류가 아니며, DMF0068 DD-161 과 같은 차이입니다. | To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.sql:884 ; To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.sq |  |
| AD-1583bc04 | A5 | FAIL | TOBE룰 | PASS | Y | N TO-BE 룰 예외는 FAIL 근거 룰과 다른 등록 룰 번호 필요 | AS-IS DMF0042_GET_SPREAD_TITLE 결과는 ATTRIBUTE5 가 마지막 컬럼이고, TO-BE 는 사용자·메뉴 편집 권한(PR_SCM_EDIT_YN)에서 EDIT_YN 컬럼 하나를 더 돌려준다. 이 컬럼은 편집 버튼이 없는 TO-BE 편집 권한 모델(CR-103)에 쓰는 추가 칸이고 화면 헤더 구성에는 쓰이지 않는다. 행 수 차이(24행과 12행)는 CR-105 에 따라 판정에서 뺀다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:2953 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_ |  |
| AD-b77aebb6 | A5 | FAIL | TOBE룰 | PASS | Y | Y 등록 룰 CR-103 + 인용 확인 | Division 81_HG 호출에서도 차이는 TO-BE 에만 있는 EDIT_YN 한 칸뿐이다. 이 칸은 Edit 버튼이 없는 TO-BE 가 사용자·메뉴 편집 권한을 받으려고 넣은 칸으로, CR-103·DD-118 의 상시 편집 설계에 따른 차이다. 행 수 차이(AS-IS 24행, TO-BE 12행)는 이 컬럼 집합 행이 판정할 대상이 아니다. | To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.sql:1093 ; To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.s |  |
| AD-854e1575 | A5 | FAIL | TOBE룰 | PASS | Y | N TO-BE 룰 예외는 FAIL 근거 룰과 다른 등록 룰 번호 필요 | AS-IS DMF0042_GET_SPREAD_TITLE 결과 컬럼은 TO-BE 에 모두 있고 AS-IS 전용 컬럼은 없습니다. TO-BE 에만 있는 칸은 사용자·메뉴 편집 권한 칸 EDIT_YN 1개이며, 화면에 표시되지 않는 편집 판정용 칸으로 Edit 버튼이 없는 TO-BE 공통 구조에 따른 것입니다. DMF0068 에는 같은 차이가 DD-161 로 등록돼 있지만 DMF0042 와 col_alias.csv 에는 아직 등록되지 않았습니다. | To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.sql:884 ; To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.sq |  |
| AD-68b91a7a | A5 | FAIL | TOBE룰 | PASS | Y | N TO-BE 룰 예외는 FAIL 근거 룰과 다른 등록 룰 번호 필요 | AS-IS DMF0042_GET_SPREAD_TITLE 결과 컬럼은 TO-BE P_DMF0042_GET_SPREAD_TITLE 에 모두 있고 AS-IS 전용 컬럼은 없습니다. 차이는 TO-BE 가 사용자·메뉴 편집 권한(PR_SCM_EDIT_YN)에서 가져와 덧붙인 EDIT_YN 1개입니다. 이 칸은 화면에 표시되지 않는 편집 판정용 칸이며 Edit 버튼이 없는 TO-BE 공통 구조에 따른 것으로, DMF0068 에는 같은 차이가 DD-161 로 등록돼 있지만  | To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.sql:884 ; To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.sq |  |
| AD-68305920 | A5 | FAIL | TOBE룰 | PASS | Y | N TO-BE 룰 예외는 FAIL 근거 룰과 다른 등록 룰 번호 필요 | AS-IS SP 결과에는 EDIT_YN 이 없고, TO-BE PROC 은 사용자·메뉴 편집 권한을 연결해 EDIT_YN 한 칸을 더 돌려준다. 이 칸은 화면에 보이지 않는 편집 권한 칸이라 그리드 컬럼 구성은 같다. 전 화면 공통으로 허용할 TO-BE 차이이며(DMF0068 에는 DD-161 로 등록) DMF0042 에는 아직 등록되지 않았다. | To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.sql:884 ; To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.sq |  |
| AD-8e431cd4 | A5 | FAIL | TOBE룰 | PASS | Y | N TO-BE 룰 예외는 FAIL 근거 룰과 다른 등록 룰 번호 필요 | AS-IS DMF0042_GET_SPREAD_TITLE 의 결과 컬럼은 ATTRIBUTE5 에서 끝나고, AS-IS 컬럼은 TO-BE 결과에 모두 있습니다. TO-BE 는 사용자·메뉴 편집 권한을 붙이려고 화면에 표시하지 않는 EDIT_YN 컬럼 하나만 더 내보냅니다. AS-IS 컬럼이 모두 있고 화면에 표시하지 않는 편집 권한 칸만 더해진 차이는 오류가 아니며, DMF0068 DD-161 과 같은 차이입니다. | To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.sql:884 ; To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.sq |  |
| AD-50d7fe21 | A5 | FAIL | TOBE룰 | PASS | Y | N TO-BE 룰 예외는 FAIL 근거 룰과 다른 등록 룰 번호 필요 | AS-IS DMF0042_GET_SPREAD_TITLE 은 ATTRIBUTE5 까지만 돌려주고, TO-BE P_DMF0042_GET_SPREAD_TITLE 은 사용자·메뉴 편집 권한(PR_SCM_EDIT_YN)을 연결해 EDIT_YN 한 칸을 더 돌려준다. EDIT_YN 은 헤더 메타 행의 속성이라 그리드에 표시되는 컬럼 구성은 바뀌지 않는다. 화면에 보이지 않는 편집 권한 칸을 추가한 것은 전 화면 공통으로 허용할 TO-BE 차이이며 DMF0068 에는 DD- | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:2958 ; To-be_v2_converted/06_Packages/04_Package_P |  |
| AD-13a7af36 | A5 | FAIL | TOBE룰 | PASS | Y | N TO-BE 룰 예외는 FAIL 근거 룰과 다른 등록 룰 번호 필요 | AS-IS DMF0042_GET_SPREAD_TITLE 결과는 ATTRIBUTE5 가 마지막 컬럼이고, TO-BE 는 사용자·메뉴 편집 권한(PR_SCM_EDIT_YN)에서 EDIT_YN 컬럼 하나를 더 돌려준다. 이 컬럼은 편집 버튼이 없는 TO-BE 편집 권한 모델(CR-103)에 쓰는 추가 칸이고 화면 헤더 구성에는 쓰이지 않는다. 행 수 차이(109행과 97행)는 CR-105 에 따라 판정에서 뺀다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:2953 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_ |  |
| AD-9b4946ab | A5 | FAIL | TOBE룰 | PASS | Y | N TO-BE 룰 예외는 FAIL 근거 룰과 다른 등록 룰 번호 필요 | AS-IS DMF0042_GET_SPREAD_TITLE 의 결과 컬럼은 ATTRIBUTE5 에서 끝나고, AS-IS 컬럼은 TO-BE 결과에 모두 있습니다. TO-BE 는 사용자·메뉴 편집 권한을 붙이려고 화면에 표시하지 않는 EDIT_YN 컬럼 하나만 더 내보냅니다. AS-IS 컬럼이 모두 있고 화면에 표시하지 않는 편집 권한 칸만 더해진 차이는 오류가 아니며, DMF0068 DD-161 과 같은 차이입니다. | To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.sql:884 ; To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.sq |  |
| AD-8a20da98 | A5 | FAIL | TOBE룰 | PASS | Y | N TO-BE 룰 예외는 FAIL 근거 룰과 다른 등록 룰 번호 필요 | AS-IS DMF0042_GET_SPREAD_TITLE 결과 컬럼은 TO-BE 에 모두 있고 AS-IS 전용 컬럼은 없습니다. TO-BE 에만 있는 칸은 사용자·메뉴 편집 권한 칸 EDIT_YN 1개이며, 화면에 표시되지 않는 편집 판정용 칸으로 Edit 버튼이 없는 TO-BE 공통 구조에 따른 것입니다. DMF0068 에는 같은 차이가 DD-161 로 등록돼 있지만 DMF0042 와 col_alias.csv 에는 아직 등록되지 않았습니다. | To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.sql:884 ; To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.sq |  |
| AD-e0365fd4 | A5 | FAIL | TOBE룰 | PASS | Y | Y AS-IS 원문 인용 확인 | Division 81_HG 호출에서도 컬럼 집합 차이는 TO-BE 전용 EDIT_YN 하나이고 AS-IS 전용 컬럼은 없다. EDIT_YN 은 Edit 버튼을 없애고 조회할 때 편집 권한으로 편집 여부를 정하는 TO-BE 방식에 쓰는 컬럼이므로 DD-118 에 해당한다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:577 ; To-be_v2_converted/06_Packages/04_Package_PK |  |
| AD-7b7bdbc2 | A5 | FAIL | TOBE룰 | PASS | Y | N TO-BE 룰 예외는 FAIL 근거 룰과 다른 등록 룰 번호 필요 | AS-IS DMF0042_GET_SPREAD_TITLE 결과 컬럼은 TO-BE 에 모두 있고 AS-IS 전용 컬럼은 없습니다. TO-BE 에만 있는 칸은 사용자·메뉴 편집 권한 칸 EDIT_YN 1개이며, 화면에 표시되지 않는 편집 판정용 칸으로 Edit 버튼이 없는 TO-BE 공통 구조에 따른 것입니다. DMF0068 에는 같은 차이가 DD-161 로 등록돼 있지만 DMF0042 와 col_alias.csv 에는 아직 등록되지 않았습니다. | To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.sql:884 ; To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.sq |  |
| AD-92f624d9 | A5 | FAIL | TOBE룰 | PASS | Y | N TO-BE 룰 예외는 FAIL 근거 룰과 다른 등록 룰 번호 필요 | AS-IS DMF0042_GET_SPREAD_TITLE 의 결과 컬럼은 ATTRIBUTE5 에서 끝나고, AS-IS 컬럼은 TO-BE 결과에 모두 있습니다. TO-BE 는 사용자·메뉴 편집 권한을 붙이려고 화면에 표시하지 않는 EDIT_YN 컬럼 하나만 더 내보냅니다. AS-IS 컬럼이 모두 있고 화면에 표시하지 않는 편집 권한 칸만 더해진 차이는 오류가 아니며, DMF0068 DD-161 과 같은 차이입니다. | To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.sql:884 ; To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.sq |  |
| AD-8be6a03d | A5 | FAIL | TOBE룰 | PASS | Y | N TO-BE 룰 예외는 FAIL 근거 룰과 다른 등록 룰 번호 필요 | AS-IS DMF0042_GET_SPREAD_TITLE 의 결과 컬럼은 ATTRIBUTE5 에서 끝나고, AS-IS 컬럼은 TO-BE 결과에 모두 있습니다(AS-IS 전용 컬럼 없음). TO-BE 는 편집 모드 없이 사용자·메뉴 편집 권한(PR_SCM_EDIT_YN)을 붙이려고 화면에 표시하지 않는 EDIT_YN 컬럼 하나만 더 내보냅니다. AS-IS 컬럼이 모두 있고 화면에 표시하지 않는 편집 권한 칸만 더해진 차이는 오류가 아니며, DMF0068 DD-161 | To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.sql:884 ; To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.sq |  |
| AD-ec296b87 | A5 | FAIL | TOBE룰 | PASS | Y | Y 등록 룰 DD-118 + 인용 확인 | Division 81_UC 호출에서도 컬럼 집합 차이는 TO-BE 전용 EDIT_YN 하나이고 AS-IS 전용 컬럼은 없다. Edit 버튼을 없앤 TO-BE 의 편집 권한 컬럼이므로 DD-118 에 해당한다. | To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.sql:989 ; tools/Harness/rules/tobe_rule_registry.csv |  |
| AD-51cf1be3 | A5 | FAIL | TOBE룰 | PASS | Y | N TO-BE 룰 예외는 FAIL 근거 룰과 다른 등록 룰 번호 필요 | AS-IS SP 결과에는 EDIT_YN 이 없고, TO-BE PROC 은 사용자·메뉴 편집 권한을 연결해 EDIT_YN 한 칸을 더 돌려준다. 이 칸은 화면에 보이지 않는 편집 권한 칸이라 그리드 컬럼 구성은 같다. 전 화면 공통으로 허용할 TO-BE 차이이며(DMF0068 에는 DD-161 로 등록) DMF0042 에는 아직 등록되지 않았다. | To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.sql:884 ; To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.sq |  |
| AD-ec0e41af | A5 | FAIL | TOBE룰 | PASS | Y | Y 등록 룰 DD-118 + 인용 확인 | 기간 20211101~20270531, Division 81 호출에서도 컬럼 집합 차이는 TO-BE 전용 EDIT_YN 하나뿐이다. TO-BE 는 UNION 의 모든 분기에 EDIT_YN 을 붙여 조회할 때 편집 권한을 넘기며, 이는 등록 룰 DD-118 의 상시 편집 방식에 따른 차이다. | To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.sql:950 ; tools/Harness/rules/tobe_rule_registry.csv |  |
| AD-7901966d | A5 | FAIL | TOBE룰 | PASS | Y | N TO-BE 룰 예외는 FAIL 근거 룰과 다른 등록 룰 번호 필요 | AS-IS DMF0042_GET_SPREAD_TITLE 결과 컬럼은 TO-BE 에 모두 있고 AS-IS 전용 컬럼은 없습니다. TO-BE 에만 있는 칸은 사용자·메뉴 편집 권한 칸 EDIT_YN 1개이며, 화면에 표시되지 않는 편집 판정용 칸으로 Edit 버튼이 없는 TO-BE 공통 구조에 따른 것입니다. DMF0068 에는 같은 차이가 DD-161 로 등록돼 있지만 DMF0042 와 col_alias.csv 에는 아직 등록되지 않았습니다. | To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.sql:884 ; To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.sq |  |
| AD-4c397b4d | A5 | FAIL | TOBE룰 | PASS | Y | Y 등록 룰 CR-103 + 인용 확인 | Division 81_HD 조회에서도 TO-BE 에만 있는 칸은 EDIT_YN 하나입니다. 이 칸은 사용자·메뉴 편집 권한으로 편집 가능 여부를 정하는 칸이고 그리드 표시 칸 구성은 바꾸지 않습니다. 행 수 차이(AS-IS 24행, TO-BE 12행)는 CR-105 에 따라 판정에서 뺍니다. | To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.sql:884 ; To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.sq |  |
| AD-56095af7 | A5 | FAIL | TOBE룰 | PASS | Y | N TO-BE 룰 예외는 FAIL 근거 룰과 다른 등록 룰 번호 필요 | AS-IS SP 결과에는 EDIT_YN 이 없고, TO-BE PROC 은 모든 UNION 갈래에 EDIT_YN 을 붙여 돌려준다. 이 칸은 화면에 보이지 않는 편집 권한 칸이라 그리드 컬럼 구성은 같다. 전 화면 공통으로 허용할 TO-BE 차이이며(DMF0068 에는 DD-161 로 등록) DMF0042 에는 아직 등록되지 않았다. | To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.sql:1093 ; To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.s |  |
| AD-f16777f1 | A5 | FAIL | TOBE룰 | PASS | Y | Y 등록 룰 DD-118 + 인용 확인 | Division 81_HM 호출에서도 컬럼 집합 차이는 TO-BE 전용 EDIT_YN 하나뿐이다. 사용자·메뉴 편집 권한을 넘기는 TO-BE 상시 편집 방식의 컬럼이므로 DD-118 에 해당한다. | To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.sql:884 ; tools/Harness/rules/tobe_rule_registry.csv |  |
| AD-0a3f2d29 | A5 | FAIL | TOBE룰 | PASS | Y | N TO-BE 룰 예외는 FAIL 근거 룰과 다른 등록 룰 번호 필요 | AS-IS DMF0042_GET_SPREAD_TITLE 결과는 ATTRIBUTE5 가 마지막 컬럼이고, TO-BE PKG_DMF0042.P_DMF0042_GET_SPREAD_TITLE 은 사용자·메뉴 편집 권한(PR_SCM_EDIT_YN)에서 EDIT_YN 컬럼 하나를 더 돌려준다. 이 컬럼은 편집 버튼이 없는 TO-BE 편집 권한 모델(CR-103)에 쓰려고 넣은 추가 칸이고, business-plan 화면은 헤더를 만들 때 EDIT_YN 을 읽지 않으므로 표 | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:2953 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_ |  |
| AD-9e63fcd9 | A5 | FAIL | TOBE룰 | PASS | Y | Y 등록 룰 CR-103 + 인용 확인 | Division 81_UC 호출에서도 차이는 TO-BE 에만 있는 EDIT_YN 한 칸뿐이다. 이 칸은 Edit 버튼이 없는 TO-BE 가 사용자·메뉴 편집 권한을 받으려고 넣은 칸으로, CR-103·DD-118 의 상시 편집 설계에 따른 차이다. 행 수 차이(AS-IS 24행, TO-BE 12행)는 이 컬럼 집합 행이 판정할 대상이 아니다. | To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.sql:1093 ; To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.s |  |
| AD-21577cf9 | A5 | FAIL | TOBE룰 | PASS | Y | N TO-BE 룰 예외는 FAIL 근거 룰과 다른 등록 룰 번호 필요 | 이 행은 결과 컬럼 집합만 본다. TO-BE 에만 있는 컬럼은 사용자·메뉴 편집 권한에서 오는 EDIT_YN 하나이고, 편집 버튼이 없는 TO-BE 편집 권한 모델(CR-103)에 쓰는 추가 칸이며 화면 헤더 구성에는 쓰이지 않는다. 공통 7행에서 다른 칸 21개(FIXED_FLAG, UPPERCASE_APPLY_FLAG, USER_SELECTABLE_FLAG, CELL_COMBO_DATA_TYPE)는 이 행에서 판정하지 않으며 같은 호출의 다른 diff 항목에 | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:2953 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_ |  |
| AD-cc106854 | A5 | FAIL | TOBE룰 | PASS | Y | Y 등록 룰 CR-103 + 인용 확인 | Division 40 bottle 계정 호출에서도 차이는 TO-BE 에만 있는 EDIT_YN 한 칸뿐이다. 이 칸은 Edit 버튼이 없는 TO-BE 가 사용자·메뉴 편집 권한을 받으려고 넣은 칸으로, CR-103·DD-118 의 상시 편집 설계에 따른 차이다. 불일치 셀 21건과 행 수 차이(AS-IS 25행, TO-BE 19행)는 이 컬럼 집합 행이 판정할 대상이 아니다. | To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.sql:884 ; To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.sq |  |
| AD-4aab327f | A5 | FAIL | TOBE룰 | PASS | Y | Y 등록 룰 CR-103 + 인용 확인 | Division 82 조회에서도 TO-BE 에만 있는 칸은 EDIT_YN 하나입니다. 이 칸은 사용자·메뉴 편집 권한으로 편집 가능 여부를 정하는 칸이고 그리드 표시 칸 구성은 바꾸지 않습니다. 행 수 차이(AS-IS 17행, TO-BE 12행)는 CR-105 에 따라 판정에서 뺍니다. | To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.sql:884 ; To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.sq |  |
| AD-d583ad20 | A5 | FAIL | TOBE룰 | PASS | Y | Y AS-IS 원문 인용 확인 | AS-IS DMF0042_GET_SPREAD_TITLE 의 결과는 ATTRIBUTE5 가 마지막 컬럼이고, AS-IS 화면은 Edit 버튼(SwitchLock)으로 편집을 연다. TO-BE 는 Edit 버튼 없이 조회할 때 편집 여부를 정하므로 PR_SCM_EDIT_YN 으로 사용자·메뉴 편집 권한 EDIT_YN 컬럼을 하나 더 내보낸다. AS-IS 전용 컬럼은 없고 TO-BE 전용 EDIT_YN 하나뿐이어서 등록된 TO-BE 룰 DD-118(같은 컬럼 추가는  | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:577 ; To-be_v2_converted/06_Packages/04_Package_PK |  |
| AD-08e8ad26 | A5 | FAIL | TOBE룰 | PASS | Y | Y AS-IS 원문 인용 확인 | AS-IS DMF0042_GET_SPREAD_TITLE 결과는 ATTRIBUTE5 에서 끝나고, TO-BE P_DMF0042_GET_SPREAD_TITLE 은 사용자·메뉴 편집 권한(PR_SCM_EDIT_YN)을 연결한 EDIT_YN 컬럼 하나만 더 내보낸다. TO-BE 는 편집 버튼 없이 조회 때 권한으로 편집 상태를 정하므로 이 컬럼 추가는 등록된 TO-BE 룰(CR-103, DMF0068 의 DD-161 과 같은 형태)이다. AS-IS 17행 대 TO-BE | To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.sql:884 ; To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.sq |  |
| AD-2ba25b2c | A5 | FAIL | TOBE룰 | PASS | Y | N TO-BE 룰 예외는 FAIL 근거 룰과 다른 등록 룰 번호 필요 | 이 행은 결과 컬럼 집합만 본다. TO-BE 에만 있는 컬럼은 사용자·메뉴 편집 권한에서 오는 EDIT_YN 하나이고, 편집 버튼이 없는 TO-BE 편집 권한 모델(CR-103)에 쓰는 추가 칸이며 화면 헤더 구성에는 쓰이지 않는다. 공통 7행에서 다른 칸 21개는 이 행에서 판정하지 않는다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:2953 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_ |  |
| T-8935dd73 | D3 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-6aa8040c | D3 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-454a3418 | D3 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-eb16b9e1 | F4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-fbb62a99 | DB-SYN | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-af492ecc | D4 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-212a5359 | D4 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-dfd4e953 | G1 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-f0114a73 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-f574b22b | X-LOC | ERROR | 검사기오판 | ERROR | Y | N 미검증 행은 NA(대상 없음 근거)만 반영 | [대표 T-c7a5c75c 와 같은 증거] 세 행은 '6. 의도적 편차' 표(편차·근거 열만 있음)와 '0-B' 표의 무변경 확인 행(파일 칸 '—')입니다. 구현 상태를 적는 행이 아니어서 구현 위치 열이 처음부터 없습니다. 저장과 Ver.Cutoff, Replace 구현이 실제로 있는지는 이 검사로 재지 못했으므로 결과는 그대로 둡니다. | nscm-fe/features/demand/src/pages/business-plan/__asis-mapping__.md:122 ; nscm-fe/features/demand/src/pages/business-pla | tools/Harness/verify/mapping_trace.py가 상태 열이 없는 편차 표와 무변경 확인 행까지 X-LOC 대상으로 잡아 구현 위치가 없다고 기록했습니다. |
| T-3c45be92 | G1 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-d1583fc1 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-09dd660e | G4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-97b1b732 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-9d580f4a | G4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-457430c0 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-f055079a | G4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-ac91cb8a | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-e33d557a | G4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-1a268804 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-df466434 | G4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-b2c4c520 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-89bdfdeb | G4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-f80d99f7 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-ec086613 | G4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-c9c90ee1 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-2d47229c | G4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-fee3daeb | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-e4eed2ba | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-36a3f202 | G4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-4a32efe6 | A5 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-a76a5d41 | H2 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-d94bf604 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-5f382ce3 | A6 | 판정필요 | 검사기오판 | PASS | Y | N AS-IS 원문 인용 또는 등록 룰 번호 없음 | 이 행의 판정필요는 drpPeriod 조회가 아니라 같은 묶음의 P_DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA 정렬 대조 FAIL 에서 왔다. AS-IS ORDER BY USER_ID 는 임시 테이블에 넣을 때 쓰는 정렬이고, AS-IS·TO-BE 모두 그리드 결과는 컬럼 메타로 만든 GroupList 로 정렬한다. 정렬 기준은 같다. | _artifacts/_apply_corporate/CELLPROD_SLASH_20261027/sources/PKG_DMF0042.PACKAGE_BODY.sql:2820 | tools/Harness/verify/sort_check.py 가 SELECT INTO 임시 테이블의 ORDER BY 를 결과 정렬 키로 잡고 동적 SQL 의 ORDER BY @GroupList 를 보지 않는다. |
| T-53cddaa1 | F4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-65a6c20d | DB-SYN | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-ec83d766 | G4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-58a47fe5 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-c9b4a0b4 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-690e2a46 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-c03a4035 | G4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-aa5ea293 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-8f9e13bc | G4 | 판정필요 | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | 누락으로 잡힌 '.' 는 cboQty 레이아웃 항목 라벨이며 TextVisible=false 라 AS-IS 화면에 나오지 않습니다. 체크박스 자체 문구 Qty≠0 은 TO-BE 에도 같은 문구로 있습니다. 따라서 라벨 누락은 결함이 아닙니다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.Designer.cs:1478 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan | tools/Harness/verify/e2e_suite_ingest.py: TextVisible=false 인 레이아웃 항목 Text('.')를 표시 라벨 기대값으로 넣었습니다. |
| T-26792624 | A5 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-ac72ef9e | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-1f95d9a6 | G4 | FAIL | 검사기오판 | NA | Y | Y AS-IS 원문 인용 확인 | AS-IS 조회조건 Closed(cboClosed)는 담은 레이아웃 항목 lblBucket1 이 Never 로 숨겨지고 컨트롤도 비활성이라 화면에 나오지 않습니다. TO-BE 도 Closed 조건을 두지 않았으므로 검사 대상이 없습니다. 검사기는 존재하지 않는 DMF0042_2_BizPlan 경로까지 근거로 들었습니다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:335 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_B | tools/Harness/verify/e2e_suite_ingest.py: 조회조건 표시 판정이 레이아웃 항목 Visibility.Never 를 반영하지 않아 숨긴 Closed 를 누락 라벨로 기록했습니다. |
| T-f51b2961 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-f9708dad | G1 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-f77449cb | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-07d9a4aa | D4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-ef217e41 | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-79823b13 | F5 | FAIL | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | AS-IS DeleteButton 은 Action 이 I(신규행)가 아니면 바로 끝나서, 기존행은 Delete 로 D 표시가 되지 않습니다. TO-BE handleDelete 도 CRUD_TYPE 이 I 가 아니면 아무것도 하지 않습니다. 따라서 실측 결과(신규행 4행 제거, 기존행은 편집 표시 M 유지)는 AS-IS 와 같습니다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:551 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_B | Doc/e2e/specs/_trace.spec.ts: W4b CRUD 상태 검사가 AS-IS DeleteButton 의 신규행 전용 가드(!= StringI)를 보지 않고 기존행 D 표시를 기대합니다. |
| T-c045163b | D3 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-153396e2 | G1 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-bc7b0c0a | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-9d5c0702 | M4 | 판정필요 | 확인불가 | 판정필요 | Y | N 판정 같음 | AS-IS btnProject는 Project 팝업(SCM0002)에서 고른 코드를 txtProject에 넣고, Division 40에서는 버튼이 꺼집니다. TO-BE도 Division 40이면 Project 칸을 끄고 팝업에서 고른 값을 조회조건에 넣지만, 값이 실제로 반영되는지는 화면을 띄워 확인해야 합니다. 이 행의 기대값은 btnProject_Click이 아니라 DMF0042_1의 헤더 더블클릭 줄과 실행되지 않는 DMF0042_2 줄에서 왔습니다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:2834 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_ | tools/E2E 시험이 Division 40(Project 비활성) 상태에서 실행되어 팝업을 열지 못했습니다. Division 81·82로 바꾼 뒤 재야 하고, 기대값 근거는 tools/AsisFacts 에서 btnProject_Click(2825~2845행)으로 고쳐야 합니다. |
| T-26d542b1 | M4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-3123dee8 | M4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-0a7ead2f | G1 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-3bf697b3 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-7892d6be | G1 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-7a5f9ae4 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-e92b3f44 | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-121b7ccd | G1 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-5100e13b | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-0823c327 | F4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-cc4bc97d | DB-SYN | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-b05d2110 | G1 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-977d691c | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-b297b625 | X-LOC | ERROR | 검사기오판 | NA | Y | Y AS-IS 원문 인용 확인 · 대상 없음(미검증 → NA) | AS-IS OnShown은 base.OnShown 호출 뒤 지역 변수 sDivision에 값을 읽기만 하고 아무 데도 쓰지 않습니다. 화면 동작이 없으므로 TO-BE에도 구현할 대상이 없고, 대조표도 '미적용 (AS-IS no-op)'으로 적었습니다. 구현 위치를 요구할 행이 아닙니다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:233 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_B | tools/Harness/verify/mapping_trace.py가 TO-BE 구현 칸이 '미적용 (AS-IS no-op)'인 행을 구현 행으로 보고 파일:라인을 요구했습니다. |
| T-659cb8da | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-9cae7d28 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-29f2a52c | D3 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-5214bc7c | H6 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-edee126a | M4 | 판정필요 | 확인불가 | 판정필요 | Y | N 판정 같음 | AS-IS는 Project 팝업에서 코드를 고르면 txtProject에 넣고, Division 40에서는 Project 버튼이 꺼집니다. TO-BE ProjectField도 팝업에서 고른 값을 조회조건 값으로 넣지만, 실제 반영은 Division 81·82에서 화면을 띄워 확인해야 합니다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:2843 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_ | tools/E2E 시험이 Division 40(Project 비활성)에서 실행되어 팝업을 열지 못했습니다. Division을 81·82로 바꾼 뒤 재야 합니다. |
| T-0b049202 | G1 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-c909a19b | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-16b1d582 | C2 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-ac65bed3 | C3 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-53d5d544 | C6 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-596431de | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-4ac39ba3 | M4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-31a755cd | M4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-f3f177fa | M4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-51632e73 | G1 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-512b8cc7 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-13d40a42 | F3 | ERROR | 검토 제외 |  | N | N 재측정 대상(데이터전제·엔진) — AI 판정 대상 아님 |  |  |  |
| T-b188f82d | C3 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-d5cb79f4 | C2 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-662665c9 | C6 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-961ccf8f | D3 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-8f0f2cac | H2 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-6f330af4 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-7a8533f3 | A6 | 판정필요 | 검사기오판 | PASS | Y | N AS-IS 원문 인용 또는 등록 룰 번호 없음 | FindData 조회 결과는 AS-IS 에서 동적 SQL 의 ORDER BY @GroupList 로 정렬되고, ORDER BY USER_ID 는 임시 테이블에 넣을 때 쓰는 정렬이다. TO-BE 도 같은 컬럼 메타로 만든 v_GroupList 로 정렬하므로 정렬 기준이 같다. 검사기가 임시 테이블 정렬을 결과 정렬로 잘못 비교했다. | _artifacts/_apply_corporate/CELLPROD_SLASH_20261027/sources/PKG_DMF0042.PACKAGE_BODY.sql:2819 ; _artifacts/_apply_corpor | tools/Harness/verify/sort_check.py 가 SELECT INTO 임시 테이블의 ORDER BY 를 결과 정렬 키로 잡고 동적 SQL 의 ORDER BY @GroupList 를 보지 않는다. |
| T-dc31a336 | F4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-e8c24f30 | DB-SYN | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-e135f151 | G1 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-0dd9b237 | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-3363600c | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-93a3a995 | G5 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-dbf286e0 | M4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-ccc13662 | D3 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-de000724 | D4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-0d2d9864 | F4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-b943143c | DB-SYN | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-77fc0b76 | G1 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-6d7f11bb | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-2c6b1f77 | E4 | FAIL | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | [대표 T-1115bd5d 와 같은 증거] AS-IS SaveData는 Division 40 행에서 End Customer, Sales Site, Model, Currency, FcstType, Incoterms, Cell Prod Site 중 하나라도 비어 있으면 MSG00310을 띄우고 저장을 멈춘다. TO-BE도 Save 때 같은 칸을 필수로 검사해 '{0} 값은 필수 입력 항목입니다.' 알림을 띄우고 저장을 막는다. 같은 화면의 E7 측정에서도 신규행 S | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_1_BizPlan/DMF0042_1_BizPlan.cs:900 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF00 | Doc/e2e/specs/_trace.spec.ts:1534 빈값 위반은 신규행이 처음부터 비어 있어 이미 충족되는데, 대상 칸이 편집 불가라는 이유로 Save 시도 없이 FAIL을 기록한다. |
| T-4927d0b1 | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-0859aad3 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-339934d7 | A6 | 판정필요 | 검사기오판 | PASS | Y | N AS-IS 원문 인용 또는 등록 룰 번호 없음 | AS-IS DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA 의 ORDER BY USER_ID 는 #TEMP_SCM_MST_SSO_USER_INFO 임시 테이블에 넣을 때 쓰는 정렬이고, 그리드 결과는 SCM_MST_SHEET_COLUMNS·SCM_MST_TITLESET_USER 의 컬럼 순서로 만든 @GroupList 로 정렬한다. TO-BE P_DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA 도 같은 메타로 v_Group | _artifacts/_apply_corporate/CELLPROD_SLASH_20261027/sources/PKG_DMF0042.PACKAGE_BODY.sql:2748 ; _artifacts/_apply_corpor | tools/Harness/verify/sort_check.py 가 SP 안의 첫 ORDER BY(SELECT INTO 임시 테이블 정렬)를 결과 정렬 키로 잡고, 실제 결과를 내는 동적 SQL(@nsql2)의 ORDER BY @GroupList 는 보지 않는다. |
| T-b33d0510 | F4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-04bcce60 | DB-SYN | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-8fe591ff | D3 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-c4b32d94 | G1 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-7040e000 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-c5ba3074 | D3 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-00d9c7f9 | G1 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-97c7fef0 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-6c99950d | D3 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-ad67ada9 | D3 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-6593b550 | H2 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-bd2fb8ba | D3 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-025fc7c5 | H2 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-96b1a679 | D3 | 판정필요 | 검사기오판 | NA | Y | Y AS-IS 원문 인용 확인 | REPORT_GROUP8(비고2)은 팝업 안의 컬럼이 아니라 메인 그리드의 컬럼입니다. InsertRow 는 컬럼이 있는지만 확인하고 신규 행에서 무조건 잠그며, EditButton 은 기존 행의 0~MEASURE 범위를 무조건 잠급니다. 행 값에 따라 잠그는 규칙이 원문에 없어서 D3 대상이 없습니다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:1379 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_ | tools/E2E: 컬럼이 있는지 보는 가드(GetColumnIndex != -1)를 행 값 조건(ROW_COND)으로 보고, 메인 그리드 컬럼을 ITEM_ID·PROJECT_CODE 팝업 내부 컬럼(PCOL)으로 연결했습니다. |
| T-fb3023e7 | H2 | 판정필요 | 검사기오판 | NA | Y | Y AS-IS 원문 인용 확인 | [대표 T-271985b5 와 같은 증거] AS-IS DMF0042 에서 ITEM_ID 칸으로 여는 팝업은 Item 선택 팝업이고, ITEM_ID·PROJECT_CODE 칸으로 여는 Sales Price PopUp 은 없다. CURRENCY_UNITCURRENCY·UNIT_CURRENCY 는 Exchange Rate 버튼으로 여는 환율 팝업의 컬럼이고, REPORT_GROUP8 은 메인 그리드 컬럼이다. 검사기가 없는 팝업 경로로 측정하려다 ITEM_ID 칸을  | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:1739 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_ | tools/Harness/verify/mapping_trace.py: 다른 화면 메타의 Sales Price PopUp 을 DMF0042 환율 팝업 컬럼과 메인 컬럼에 대응시켜 없는 셀 클릭 경로를 만들었다. |
| T-140c6ad5 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-d741cdad | H2 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-6fdd2ed4 | C2 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-881f0af2 | C6 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-f1368f88 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-1d10eafd | A6 | 판정필요 | 검사기오판 | PASS | Y | N AS-IS 원문 인용 또는 등록 룰 번호 없음 | AS-IS 의 ORDER BY USER_ID 는 SSO 사용자 정보를 임시표에 넣는 SELECT INTO 정렬이라 그리드 결과 순서가 아니다. AS-IS 최종 결과는 동적 ORDER BY @GroupList 이고 TO-BE 도 ORDER BY v_GroupList 라서 정렬 기준이 같다. 이 행에 묶인 나머지 3요소는 측정되지 않았다. | Doc/verify/DMF0042/sort_check.csv ; To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.sql:6078 | tools/Harness/verify/sort_check.py: AS-IS SP 의 첫 ORDER BY(임시표 SELECT INTO)를 결과 정렬로 잡았고 최종 동적 ORDER BY @GroupList 를 대조하지 않았다. |
| T-5846effc | F4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-15c6c13e | DB-SYN | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-6cb41a4a | D3 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-b6bdf96a | G1 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-dcc480c9 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-b91cc8ca | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-97969c38 | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-1dbabb7d | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-2f5f9afc | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-e7d5daed | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-e5c8ddbd | C3 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-24cb1f8a | D3 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-654f2369 | G1 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-8f4b6d9d | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-d8569e05 | D3 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-c7a5c75c | X-LOC | ERROR | 검사기오판 | ERROR | Y | N 미검증 행은 NA(대상 없음 근거)만 반영 | 세 행은 '6. 의도적 편차' 표(편차·근거 열만 있음)와 '0-B' 표의 무변경 확인 행(파일 칸 '—')입니다. 구현 상태를 적는 행이 아니어서 구현 위치 열이 처음부터 없습니다. 저장과 Ver.Cutoff, Replace 구현이 실제로 있는지는 이 검사로 재지 못했으므로 결과는 그대로 둡니다. | nscm-fe/features/demand/src/pages/business-plan/__asis-mapping__.md:122 ; nscm-fe/features/demand/src/pages/business-pla | tools/Harness/verify/mapping_trace.py가 상태 열이 없는 편차 표와 무변경 확인 행까지 X-LOC 대상으로 잡아 구현 위치가 없다고 기록했습니다. |
| T-52897c79 | A5 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-834d9e09 | A5 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-bee74527 | H5 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-648db4d9 | H2 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-d176c953 | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-f089a010 | G5 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-6c1e980c | M4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-32a269ff | D3 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-06210b10 | G1 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-f2a05e20 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-e4978dc5 | X-LOC | ERROR | 검사기오판 | ERROR | Y | N 미검증 행은 NA(대상 없음 근거)만 반영 | [대표 T-c7a5c75c 와 같은 증거] 세 행은 '6. 의도적 편차' 표(편차·근거 열만 있음)와 '0-B' 표의 무변경 확인 행(파일 칸 '—')입니다. 구현 상태를 적는 행이 아니어서 구현 위치 열이 처음부터 없습니다. 저장과 Ver.Cutoff, Replace 구현이 실제로 있는지는 이 검사로 재지 못했으므로 결과는 그대로 둡니다. | nscm-fe/features/demand/src/pages/business-plan/__asis-mapping__.md:122 ; nscm-fe/features/demand/src/pages/business-pla | tools/Harness/verify/mapping_trace.py가 상태 열이 없는 편차 표와 무변경 확인 행까지 X-LOC 대상으로 잡아 구현 위치가 없다고 기록했습니다. |
| T-96bc9186 | G1 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-e34b5fe4 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-0caea789 | M3 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-d937601d | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-ac65d2c2 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-ae817bea | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-be213482 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-ccfb23da | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-0a9875a6 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-867da389 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-2e2ac93b | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-c393f0cb | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-edcb0cc0 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-bc25bd85 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-c2600864 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-739ce30c | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-d1658584 | A1 | 판정필요 | 확인불가 | 판정필요 | Y | N 판정 같음 | AS-IS 조회 SP 는 p_dept_id, p_end_customer, p_item_type, p_now_yyyymmdd, p_plant_site_id, p_biztype, p_userinfo, p_qty_yn 을 화면 컨트롤 값으로 넘깁니다. golden 실행은 이 8개 인자 값을 정하지 못해 SKIP(AS-IS -1행, TO-BE -1행)으로 끝났고 TO-BE 호출과 차등 대조는 0건입니다. 결과 컬럼 집합, 정렬 순서, 조건 로직 중 어느 것도 대조하지  | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:800 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_B | golden.py 의 param_defaults.json 이나 golden_cases.csv 에 미정 인자 8개 값을 채우지 않아 AS-IS SP 와 TO-BE PROC 를 실행하지 못했습니다(tools/DbConn 쪽 입력 보완 필요). |
| T-12722e6d | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-408da82c | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-430d62a0 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-73c7cfab | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-5d4e1a66 | DB-SYN | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-9ff2b159 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-b7819e41 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-45d1212f | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-13cbddf1 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-f520d2ca | F4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-dd829879 | DB-SYN | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-9ab38ee2 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-41ae873a | F4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-b8fb4352 | DB-SYN | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-a128611f | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-6d0484f5 | F4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-bf5c6cec | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-6c5e1801 | DB-SYN | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-a34faf7f | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-00e4ca64 | F4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-89b44141 | DB-SYN | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-f7665703 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-abd6bca5 | M3 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-7c7cbbfa | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-1d12f755 | C1 | 판정필요 | 확인불가 | 판정필요 | Y | N 판정 같음 | AS-IS clbTeam_SelectedIndexChanged는 Team을 바꾸면 End Customer와 Sales Site 후보를 다시 채웁니다. TO-BE도 Team 변경 시 End Customer와 Sales Site 선택을 비웁니다. 시험은 Team 옵션을 고르지 못해 상위 변경을 하지 못했으므로 동작은 측정되지 않았습니다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:1581 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_ | Doc/e2e/specs/_trace.spec.ts 의 changeOther 가 부르는 pickComboOption(tools/E2E/lib/smoke-extra.ts)이 Team 다중선택 콤보에서 옵션을 고르지 못했다. 같은 회차 EG-579fb87f 는 Div 81 Team 후보 1 |
| T-fcbf4239 | C1 | 판정필요 | 확인불가 | 판정필요 | Y | N 판정 같음 | AS-IS clbCustomer_SelectedIndexChanged는 End Customer를 바꾸면 Sales Site 후보를 다시 채웁니다. TO-BE도 End Customer 변경 시 Sales Site와 Plant Site 선택을 비웁니다. 시험은 End Customer 옵션을 고르지 못했고 콤보 호출도 0건이어서 동작은 측정되지 않았습니다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:1603 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_ | Doc/e2e/specs/_trace.spec.ts 의 changeOther 가 부르는 pickComboOption(tools/E2E/lib/smoke-extra.ts)이 End Customer 다중선택 콤보에서 옵션을 고르지 못했다(mctx calls 0). |
| T-5a0bf34a | M3 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-d71abf6d | M3 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-aaa58216 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-af274188 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-da349bea | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-2cbcca49 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-6019950f | B1 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-dea84365 | B2 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-08cea7b5 | B4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-529872d2 | B1 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-32bc7ec4 | B2 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-b60756f2 | B4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-2deb2d76 | D5 | FAIL | 추출오류 | PASS | Y | Y AS-IS 원문 인용 확인 | AS-IS 는 Division 40 일 때 InitSpread 에서 CELL_PROD_SITE 컬럼 전체를 콤보로 지정하고, 신규 행에는 유효건(Y)만 담은 콤보를 다시 지정합니다. TO-BE 도 dataMap 이 있는 콤보로 구성되어 에디터 유형이 같습니다. 추출본 cell_rules 가 이 컬럼을 TEXT 로만 적어 FAIL 이 났습니다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:392 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_B | tools/AsisFacts 셀 유형 추출기가 InitSpread 의 SetComboCol(siMain, "CELL_PROD_SITE", dt) 호출을 컬럼 콤보 유형으로 읽지 못해 CELL_PROD_SITE 를 TEXT 로 기록했습니다. |
| T-1c39a660 | C3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-a814a484 | D3 | 판정필요 | 검사기오판 | NA | Y | Y AS-IS 원문 인용 확인 | BIZ_TYPE_NAME82 는 팝업 안의 컬럼이 아니라 메인 그리드의 컬럼입니다. InsertRow 는 컬럼이 있는지만 확인하고 신규 행에서 무조건 잠그며, EditButton 은 기존 행의 0~MEASURE 범위를 무조건 잠급니다. 행 값에 따라 잠그는 규칙이 원문에 없어서 D3 대상이 없습니다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:1308 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_ | tools/E2E: 컬럼이 있는지 보는 가드(GetColumnIndex != -1)를 행 값 조건(ROW_COND)으로 보고, 메인 그리드 컬럼을 ITEM_ID·PROJECT_CODE 팝업 내부 컬럼(PCOL)으로 연결했습니다. |
| T-3fe3ea73 | D3 | 판정필요 | 검사기오판 | NA | Y | Y AS-IS 원문 인용 확인 | REPORT_GROUP7(비고1)은 팝업 안의 컬럼이 아니라 메인 그리드의 컬럼입니다. InsertRow 는 컬럼이 있는지만 확인하고 신규 행에서 무조건 잠그며, EditButton 은 기존 행의 0~MEASURE 범위를 무조건 잠급니다. 행 값에 따라 잠그는 규칙이 원문에 없어서 D3 대상이 없습니다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:1377 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_ | tools/E2E: 컬럼이 있는지 보는 가드(GetColumnIndex != -1)를 행 값 조건(ROW_COND)으로 보고, 메인 그리드 컬럼을 ITEM_ID·PROJECT_CODE 팝업 내부 컬럼(PCOL)으로 연결했습니다. |
| T-f377d869 | C3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-23b45ed6 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-101741b8 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-e82cd81f | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-7cb12780 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-96d95295 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-18ace293 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-3b47af77 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-0adb327f | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-1115bd5d | E4 | FAIL | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | AS-IS SaveData는 Division 40 행에서 End Customer, Sales Site, Model, Currency, FcstType, Incoterms, Cell Prod Site 중 하나라도 비어 있으면 MSG00310을 띄우고 저장을 멈춘다. TO-BE도 Save 때 같은 칸을 필수로 검사해 '{0} 값은 필수 입력 항목입니다.' 알림을 띄우고 저장을 막는다. 같은 화면의 E7 측정에서도 신규행 Save가 'End Customer 값은 필수 | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_1_BizPlan/DMF0042_1_BizPlan.cs:900 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF00 | Doc/e2e/specs/_trace.spec.ts:1534 빈값 위반은 신규행이 처음부터 비어 있어 이미 충족되는데, 대상 칸이 편집 불가라는 이유로 Save 시도 없이 FAIL을 기록한다. |
| T-ab18b973 | E4 | FAIL | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | [대표 T-1115bd5d 와 같은 증거] AS-IS SaveData는 Division 40 행에서 End Customer, Sales Site, Model, Currency, FcstType, Incoterms, Cell Prod Site 중 하나라도 비어 있으면 MSG00310을 띄우고 저장을 멈춘다. TO-BE도 Save 때 같은 칸을 필수로 검사해 '{0} 값은 필수 입력 항목입니다.' 알림을 띄우고 저장을 막는다. 같은 화면의 E7 측정에서도 신규행 S | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_1_BizPlan/DMF0042_1_BizPlan.cs:900 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF00 | Doc/e2e/specs/_trace.spec.ts:1534 빈값 위반은 신규행이 처음부터 비어 있어 이미 충족되는데, 대상 칸이 편집 불가라는 이유로 Save 시도 없이 FAIL을 기록한다. |
| T-7286563e | E4 | FAIL | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | [대표 T-1115bd5d 와 같은 증거] AS-IS SaveData는 Division 40 행에서 End Customer, Sales Site, Model, Currency, FcstType, Incoterms, Cell Prod Site 중 하나라도 비어 있으면 MSG00310을 띄우고 저장을 멈춘다. TO-BE도 Save 때 같은 칸을 필수로 검사해 '{0} 값은 필수 입력 항목입니다.' 알림을 띄우고 저장을 막는다. 같은 화면의 E7 측정에서도 신규행 S | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_1_BizPlan/DMF0042_1_BizPlan.cs:900 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF00 | Doc/e2e/specs/_trace.spec.ts:1534 빈값 위반은 신규행이 처음부터 비어 있어 이미 충족되는데, 대상 칸이 편집 불가라는 이유로 Save 시도 없이 FAIL을 기록한다. |
| T-f4a45dc6 | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-3f1f525c | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-9a6c7a20 | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-d33e1775 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-dd4ddb70 | A5 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-b9ef46dd | H5 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-48ec57da | D5 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-80d5620d | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-0d9a83dd | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-9fb52591 | A5 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-92c54a7b | A5 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-068246b1 | A5 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-a8802210 | A5 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-f95fa19f | H5 | 판정필요 | 추출오류 | NA | Y | Y AS-IS 원문 인용 확인 | COLUMN_NAME 은 그리드 컬럼이 아니라 SP 가 돌려준 제목표(dtTitle)에서 각 컬럼의 이름을 담은 항목입니다. SetSpreadHeaderSpan 은 이 값으로 B_ 컬럼을 숨길지만 정합니다. AS-IS 그리드에 이런 컬럼이 없으므로 라벨 비교 대상이 아닙니다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:427 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_B | tools/AsisFacts: SetSpreadHeaderSpan 안의 dr[DefColumns.X] 처럼 DataRow 항목을 읽는 코드를 그리드 컬럼으로 추출하지 않도록 걸러야 합니다. |
| T-8b2fd543 | H5 | 판정필요 | 추출오류 | NA | Y | Y AS-IS 원문 인용 확인 | COLUMN_LABEL_NAME은 컬럼 정의표 dtTitle의 필드입니다. 그리드 헤더 문구를 채울 때 값으로만 쓰이고, 그리드 컬럼으로 화면에 나오지 않습니다. 라벨을 대조할 그리드 컬럼이 없습니다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:428 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_1 | tools/AsisFacts가 DefColumns 상수 중 헤더 메타 표(dtTitle)의 필드명을 그리드 컬럼으로 추출했습니다. |
| T-36be5d33 | H5 | 판정필요 | 추출오류 | NA | Y | Y AS-IS 원문 인용 확인 | SMALL_CLASS_LABEL_NAME은 SetSpreadHeaderSpan이 받는 컬럼 정의표 dtTitle의 필드입니다. 그리드 헤더 묶음 문구를 만들 때만 읽으며, 그리드 컬럼으로 화면에 나오지 않습니다. 라벨을 대조할 그리드 컬럼이 없습니다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:429 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_1 | tools/AsisFacts가 DefColumns 상수 중 헤더 메타 표(dtTitle)의 필드명을 그리드 컬럼으로 추출했습니다. |
| T-d4512ef1 | H5 | 판정필요 | 추출오류 | NA | Y | Y AS-IS 원문 인용 확인 | LARGE_CLASS_LABEL_NAME 은 그리드 컬럼이 아니라 SP 가 돌려준 제목표(dtTitle)의 항목입니다. SetSpreadHeaderSpan 이 이 값을 읽어 상단 헤더 묶음 문구로만 씁니다. AS-IS 그리드에 이런 컬럼이 없으므로 라벨 비교 대상이 아닙니다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:430 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_B | tools/AsisFacts: SetSpreadHeaderSpan 안의 dr[DefColumns.X] 처럼 DataRow 항목을 읽는 코드를 그리드 컬럼으로 추출하지 않도록 걸러야 합니다. |
| T-5b5ca573 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-31aa9cf7 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-4b527397 | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-2398bde2 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-d20b3346 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-eebcc6e8 | M3 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-7b198add | M3 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-9ede7bcb | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-3ecb744a | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-2dcbf28c | M3 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-8be94e69 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-2dc229d4 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-ba8f2205 | M3 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-5b1cfb97 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-ff6e738f | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-486943f6 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-60f858b4 | M3 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-064aa6ac | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-df075610 | F4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-67f6a91e | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-146eb456 | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-9a44a31d | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-2a949e61 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-bf40a19b | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-7576d722 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-f296a778 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-fccdd277 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-6cf7023a | M4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-7bd581e5 | M4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-22903807 | M4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-9d14bd37 | M4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-1f510aca | M4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-88614ff5 | M4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-ab8d6a98 | M4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-5507047c | M4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-d7fdb419 | M4 | 판정필요 | 추출오류 | NA | Y | Y AS-IS 원문 인용 확인 | DMF0042_1_BizPlan은 사업계획 화면의 다른 폼이고, 이 폼을 팝업으로 여는 코드가 GSCM 어디에도 없습니다. 근거로 든 1600~1608행은 헤더를 더블클릭하면 분기·월 컬럼을 펼치거나 접는 코드이고, 팝업에서 고른 값을 칸에 넣는 동작이 아닙니다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_1_BizPlan/DMF0042_1_BizPlan.cs:1600 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0 | tools/AsisFacts 에서 화면 폼 클래스 이름을 POPUP 요소로 등록하고, 헤더 더블클릭의 컬럼 펼침 분기를 팝업 선택값 반영 근거로 잡았습니다. |
| T-29f3656b | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-a123c4f8 | A5 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-42346f6e | M4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-6b0dc1ce | A5 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-20fa45be | M4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-5356f99e | C3 | 판정필요 | 확인불가 | 판정필요 | Y | N 판정 같음 | AS-IS 는 PROJECT_CODE·PROJECT_CODE82 셀의 Project 팝업에서 고른 값으로 PROJECT_NAME 을 채운다. TO-BE Project 팝업도 선택 시 PROJECT_NAME 을 채운다. 이 행은 검사기가 M4 팝업 선택 반영 검사로 넘기고 재지 못해서, 원문만으로 PASS 라고 할 수 없다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:1806 ; nscm-fe/features/demand/src/pages/business- |  |
| T-b32e08fe | M4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-f154540d | C3 | 판정필요 | 실결함 | FAIL | Y | Y AS-IS 원문 인용 확인 | AS-IS 는 신규 행 Project 셀에서 Project 팝업을 고르면 PROJECT_NAME 과 함께 BIZ_TYPE_NAME81(Biz.Type) 칸에 팝업의 Biz Type 값을 채운다. TO-BE BusinessPlanModals.tsx 의 Project 팝업 반환 처리는 PROJECT_CODE·PROJECT_NAME·ITEM_ID·ITEM_CLASS_NAME 만 세팅하고 팝업이 넘기는 Biz Type 인자를 받지 않는다. business-plan 폴더 | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:1798 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_ |  |
| T-00b208f9 | A5 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-f2794730 | H6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-654339e1 | G5 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-485d2d42 | M4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-ec15d598 | C2 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-b0ecefe6 | C6 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-939ddd09 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-de226687 | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-dd5dd920 | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-07460da5 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-3bd4def9 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-5c9a76d4 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-e9b7b699 | M3 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-4bfc57d4 | X-ROW | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-f4cc02b3 | X-ROW | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-7cc6a23b | X-ROW | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-b120b8ec | X-ROW | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-7caa02ca | X-ROW | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-845a0fe6 | X-ROW | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-b7160d94 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-c9a2fe56 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-9a853a19 | A6 | 판정필요 | 검사기오판 | PASS | Y | N AS-IS 원문 인용 또는 등록 룰 번호 없음 | DMF0042_1_RTF 팝업 행의 판정필요도 같은 P_DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA 정렬 대조 FAIL 을 집계한 것이다. AS-IS ORDER BY USER_ID 는 임시 테이블에 넣을 때 쓰는 정렬이고, AS-IS·TO-BE 모두 그리드 결과는 컬럼 메타로 만든 GroupList 로 정렬한다. 정렬 기준은 같다. | _artifacts/_apply_corporate/CELLPROD_SLASH_20261027/sources/PKG_DMF0042.PACKAGE_BODY.sql:2820 | tools/Harness/verify/sort_check.py 가 SELECT INTO 임시 테이블의 ORDER BY 를 결과 정렬 키로 잡고, 진입점 집계에서 이 FAIL 을 관계없는 팝업 진입점에도 퍼뜨린다. |
| T-8cffdd38 | F4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-f2082546 | DB-SYN | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-3a814a02 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-e9d2454c | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-13f4ea13 | A6 | 판정필요 | 검사기오판 | NA | Y | Y AS-IS 원문 인용 확인 | DMF0042_1_RTF.FindDataMain 은 조회 SP 호출과 siMain.Query 가 모두 주석이라 조회 결과 정렬 대상이 없다. DMF0042_BizPlan.cs 에서 RTF 를 찾았으나 31행 이력 주석 외에는 이 팝업을 여는 코드가 없다. 걸린 FAIL 요소는 메인 SP DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA 정렬 대조인데 이 진입점 경로에 없다. | GSCM/06.UIL/GSCM.DM.Plan.UIL/POPUP/DMF0042_1_RTF.cs:683 ; GSCM/06.UIL/GSCM.DM.Plan.UIL/POPUP/DMF0042_1_RTF.cs:699 ; GSCM | tools/Harness/verify/mapping_trace.py: 메인 SP 정렬 FAIL 요소를 그 SP 를 호출하지 않는 팝업 진입점 집계에도 붙였다. |
| T-e9ecc1f0 | F4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-fcc9ab16 | X-ROW | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-fcb64cd8 | X-ROW | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-150819d4 | F4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-e8f48ab1 | DB-SYN | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-735303b8 | X-ROW | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-441b2fbe | F4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-411870e1 | DB-SYN | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-9d55dd5d | X-ROW | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-10800f7e | X-ROW | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-a61a185f | X-ROW | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-c49e8271 | A5 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-d6dbef5f | H5 | 판정필요 | 추출오류 | NA | Y | Y AS-IS 원문 인용 확인 | 기대 라벨 Project Code 는 DMF0042_1_RTF 팝업의 RTF POPUP 시트에서 왔습니다. GSCM 전체 .cs 파일에서 DMF0042_1_RTF 를 찾으면 자기 파일 두 개에만 나오고, DMF0042 세 폼 어디에서도 이 팝업을 열지 않습니다. 이 화면에 없는 팝업 컬럼이므로 NA 입니다. | GSCM/06.UIL/GSCM.DM.Plan.UIL/POPUP/DMF0042_1_RTF.cs:230 ; GSCM/06.UIL/GSCM.DM.Plan.UIL/POPUP/DMF0042_1_RTF.cs:50 | tools/AsisFacts: 화면 ID 접두가 같다는 이유만으로 호출되지 않는 팝업 파일(DMF0042_1_RTF.cs)을 화면 원천에 넣었습니다. |
| T-f8a6807b | H5 | 판정필요 | 추출오류 | NA | Y | Y AS-IS 원문 인용 확인 | 기대 라벨 Model Code 는 DMF0042_1_RTF 팝업의 RTF POPUP 시트에서 왔습니다. GSCM 전체 .cs 파일에서 DMF0042_1_RTF 를 찾으면 자기 파일 두 개에만 나오고, DMF0042 세 폼 어디에서도 이 팝업을 열지 않습니다. 이 화면에 없는 팝업 컬럼이므로 NA 입니다. | GSCM/06.UIL/GSCM.DM.Plan.UIL/POPUP/DMF0042_1_RTF.cs:232 ; GSCM/06.UIL/GSCM.DM.Plan.UIL/POPUP/DMF0042_1_RTF.cs:50 | tools/AsisFacts: 화면 ID 접두가 같다는 이유만으로 호출되지 않는 팝업 파일(DMF0042_1_RTF.cs)을 화면 원천에 넣었습니다. |
| T-2b97de31 | H5 | 판정필요 | 추출오류 | NA | Y | Y AS-IS 원문 인용 확인 | EXT_INT(외주여부)는 DMF0042_1_RTF 팝업 그리드의 컬럼입니다. GSCM 전체를 DMF0042_1_RTF로 검색해 보니 이 팝업을 여는 코드가 없고, 자기 파일 두 개에만 나옵니다. 따라서 DMF0042 화면에서 열리는 팝업이 아니어서 대조할 대상이 없습니다. | GSCM/06.UIL/GSCM.DM.Plan.UIL/POPUP/DMF0042_1_RTF.cs:237 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_Biz | tools/AsisFacts에서 화면 폼이 호출하지 않는 같은 접두어 팝업(DMF0042_1_RTF)을 이 화면의 팝업 사실로 넣었습니다. |
| T-3b2bdc77 | D5 | 판정필요 | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | AS-IS 본 그리드의 DIVISION_ID 는 콤보 지정 없이 Division 코드 값을 그대로 넣고 신규 행·기존 행 모두 잠급니다. 콤보로 지정된 DIVISION_ID 는 Exchange Rate 팝업 같은 다른 시트의 컬럼입니다. TO-BE 는 편집 불가 칸에 코드 40 을 표시하므로 AS-IS 와 같습니다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:1285 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_ | tools/E2E 트레이스가 DMF0042_1_RTF·DMF0042_ExchangeRatePopup 시트의 DIVISION_ID 콤보 문장을 본 그리드 DIVISION_ID 의 기대값으로 썼으므로, 시트별로 기대값을 나눠야 합니다. |
| T-78c21760 | F4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-f94a2f93 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-47a9f660 | F4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-308a7a54 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-e6222043 | DB-SYN | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-06dbab4e | X-ROW | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-156beb32 | F4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-73a9375c | A1 | 판정필요 | 추출오류 | NA | Y | Y AS-IS 원문 인용 확인 | DMF0003_GET_DM_ANL_MKT_PSI_DPINIT은 DMF0042_1_RTF 팝업에서만 호출됩니다. GSCM 전체 .cs, .xml, .config, .resx 파일에서 DMF0042_1_RTF를 찾아보니 팝업 자체 파일 두 개 말고는 이 팝업을 생성하는 곳이 없었고, DMF0042 화면 폼이 여는 팝업은 ExchangeRatePopup뿐입니다. 이 화면에는 검사할 대상이 없습니다. | GSCM/06.UIL/GSCM.DM.Plan.UIL/POPUP/DMF0042_1_RTF.cs:31 ; GSCM/06.UIL/GSCM.DM.Plan.UIL/POPUP/DMF0042_1_RTF.cs:1036 ; GSCM | tools/AsisFacts의 추적 수집기가 파일 이름 접두어(DMF0042_)만 보고 팝업 SP를 화면에 붙여서, 화면 폼이 생성하지 않는 DMF0042_1_RTF 팝업까지 포함했습니다. |
| T-3c3c6da3 | D3 | 판정필요 | 추출오류 | NA | Y | Y AS-IS 원문 인용 확인 | EDI_QTY 컬럼은 DMF0042_1_RTF 폼에 있는 컬럼입니다. GSCM 전체 소스에서 이 폼을 여는 곳을 찾지 못했고, DMF0042 화면의 ITEM_ID·PROJECT_CODE 셀이 여는 팝업은 다른 폼입니다. 그 폼 안의 잠금도 행 값이 아니라 조회 월 조건으로 컬럼 전체를 잠그는 것이어서, 이 화면에는 D3 대상이 없습니다. | GSCM/06.UIL/GSCM.DM.Plan.UIL/POPUP/DMF0042_1_RTF.cs:1306 ; GSCM/06.UIL/GSCM.DM.Plan.UIL/POPUP/DMF0042_1_RTF.cs:1561 ; GS | tools/AsisFacts: 추출본이 진입점이 연결되지 않은 DMF0042_1_RTF 폼의 LockColumn 을 DMF0042 화면의 팝업 내부 컬럼 규칙으로 넣었습니다. |
| T-423b2d78 | D3 | 판정필요 | 추출오류 | NA | Y | Y AS-IS 원문 인용 확인 | RESULT 컬럼은 DMF0042_1_RTF 폼에 있는 컬럼입니다. GSCM 전체 소스에서 이 폼을 여는 곳을 찾지 못했고, DMF0042 화면의 ITEM_ID·PROJECT_CODE 셀이 여는 팝업은 다른 폼입니다. 그 폼 안의 잠금도 행 값이 아니라 조회 월 조건으로 컬럼 전체를 잠그는 것이어서, 이 화면에는 D3 대상이 없습니다. | GSCM/06.UIL/GSCM.DM.Plan.UIL/POPUP/DMF0042_1_RTF.cs:1307 ; GSCM/06.UIL/GSCM.DM.Plan.UIL/POPUP/DMF0042_1_RTF.cs:1293 ; GS | tools/AsisFacts: 추출본이 진입점이 연결되지 않은 DMF0042_1_RTF 폼의 LockColumn 을 DMF0042 화면의 팝업 내부 컬럼 규칙으로 넣었습니다. |
| T-ec19fb1f | D3 | 판정필요 | 추출오류 | NA | Y | Y AS-IS 원문 인용 확인 | 기대값의 근거인 DMF0042_1_RTF 팝업을 GSCM/06.UIL 전체 *.cs에서 Grep했습니다. 생성자 정의 외에 new DMF0042_1_RTF 호출은 한 곳도 없습니다. 정본 DMF0042_BizPlan.cs도 이 팝업을 열지 않으므로 팝업 안 MKT_FCST 잠금은 이 화면의 대상이 아닙니다. | GSCM/06.UIL/GSCM.DM.Plan.UIL/POPUP/DMF0042_1_RTF.cs:1308 ; GSCM/06.UIL/GSCM.DM.Plan.UIL/POPUP/DMF0042_1_RTF.cs:104 | tools/AsisFacts: 화면 ID 접두만 같고 어디서도 호출하지 않는 팝업 폼(DMF0042_1_RTF)의 LockColumn을 이 화면의 행 조건 잠금으로 추출했습니다. |
| T-165076f8 | D3 | 판정필요 | 추출오류 | NA | Y | Y AS-IS 원문 인용 확인 | GAP 컬럼은 DMF0042_1_RTF 폼에 있는 컬럼입니다. GSCM 전체 소스에서 이 폼을 여는 곳을 찾지 못했고, DMF0042 화면의 ITEM_ID·PROJECT_CODE 셀은 DM0002_ItembyDivisionPopupEx·SCM0002_ProjectbyDivisionPopupEx 팝업을 엽니다. 그 폼 안의 잠금도 행 값이 아니라 조회 월(_YYYYMM)이 현재 월과 같은지에 따라 컬럼 전체를 잠그는 것이어서, 이 화면에는 D3 행 조건 잠금 대상 | GSCM/06.UIL/GSCM.DM.Plan.UIL/POPUP/DMF0042_1_RTF.cs:1293 ; GSCM/06.UIL/GSCM.DM.Plan.UIL/POPUP/DMF0042_1_RTF.cs:1309 ; GS | tools/AsisFacts: 추출본이 진입점이 연결되지 않은 DMF0042_1_RTF 폼의 LockColumn 을 DMF0042 화면의 ITEM_ID·PROJECT_CODE 팝업 내부 컬럼 규칙으로 넣었습니다. |
| T-3d853dd9 | X-ROW | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-dd0458bf | F4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-7d5d2f54 | A1 | 판정필요 | 추출오류 | NA | Y | Y AS-IS 원문 인용 확인 | DMF0003_GET_DM_ANL_MKT_PSI_DPRESULT는 DMF0042_1_RTF 팝업에서만 호출됩니다. GSCM 전체 .cs, .xml, .config, .resx 파일에서 DMF0042_1_RTF를 찾아보니 팝업 자체 파일 두 개 말고는 이 팝업을 생성하는 곳이 없었고, DMF0042 화면 폼이 여는 팝업은 ExchangeRatePopup뿐입니다. 이 화면에는 검사할 대상이 없습니다. | GSCM/06.UIL/GSCM.DM.Plan.UIL/POPUP/DMF0042_1_RTF.cs:31 ; GSCM/06.UIL/GSCM.DM.Plan.UIL/POPUP/DMF0042_1_RTF.cs:1389 ; GSCM | tools/AsisFacts의 추적 수집기가 파일 이름 접두어(DMF0042_)만 보고 팝업 SP를 화면에 붙여서, 화면 폼이 생성하지 않는 DMF0042_1_RTF 팝업까지 포함했습니다. |
| T-75f958aa | X-ROW | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-fa77b1e1 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-e17f6a73 | X-ROW | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-3e47897c | X-ROW | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-c7916301 | A5 | ERROR | 미검토 |  | N | N 대표 T-31b778c5 와 판단이 다름 — 다음 실행에 단독 검토 |  |  |  |
| T-5557d1d2 | A5 | ERROR | 미검토 |  | N | N 대표 T-31b778c5 와 판단이 다름 — 다음 실행에 단독 검토 |  |  |  |
| T-ecc11b18 | C2 | 판정필요 | 추출오류 | NA | Y | Y AS-IS 원문 인용 확인 | VARIATION_FACTOR 후보(차량생산·차량판매·물류이슈 / 시점조정·모델믹스)는 다른 프로젝트의 POPUP/DMF0042_1_RTF.cs 에서 DEMAND_OPERATION 값에 따라 정해진다. 이 화면의 세 폼 소스에는 VARIATION_FACTOR 컬럼이 없다. RTF 팝업을 여는 코드도 없다. | GSCM/06.UIL/GSCM.DM.Plan.UIL/POPUP/DMF0042_1_RTF.cs:1715 ; GSCM/06.UIL/GSCM.DM.Plan.UIL/POPUP/DMF0042_1_RTF.cs:1705 | tools/AsisFacts: 등록 소스 목록 밖의 GSCM.DM.Plan.UIL/POPUP/DMF0042_1_RTF.cs 를 화면 ID 접두어 일치만으로 DMF0042 원천에 넣었다. |
| T-4c8b822f | C2 | 판정필요 | 추출오류 | NA | Y | Y AS-IS 원문 인용 확인 | DEMAND_OPERATION 콤보 후보 규칙은 다른 프로젝트(GSCM.DM.Plan.UIL)의 POPUP/DMF0042_1_RTF.cs 에만 있다. 이 화면의 소스 DMF0042_BizPlan·DMF0042_1_BizPlan·DMF0042_3_BizPlan.cs 에는 DEMAND_OPERATION 컬럼이 없다. 세 폼에서 RTF 팝업을 여는 코드도 Grep 으로 찾지 못했다. 이 화면에 해당하지 않는 규칙이다. | GSCM/06.UIL/GSCM.DM.Plan.UIL/POPUP/DMF0042_1_RTF.cs:1677 ; GSCM/06.UIL/GSCM.DM.Plan.UIL/POPUP/DMF0042_1_RTF.cs:1738 | tools/AsisFacts: 화면 ID 접두어 DMF0042_ 로 파일을 모으면서 등록 소스 목록 밖의 GSCM.DM.Plan.UIL/POPUP/DMF0042_1_RTF.cs 까지 원천으로 묶었다. |
| T-e22b532c | C6 | 판정필요 | 추출오류 | NA | Y | Y AS-IS 원문 인용 확인 | VARIATION_FACTOR 콤보를 다시 설정하는 코드는 DMF0042_1_RTF 팝업에만 있습니다. GSCM 전체를 Grep 하니 이 팝업을 여는 코드가 없었습니다. 따라서 Business Plan 화면에는 이 대상이 없습니다. | GSCM/06.UIL/GSCM.DM.Plan.UIL/POPUP/DMF0042_1_RTF.cs:1715 ; GSCM/06.UIL/GSCM.DM.Plan.UIL/POPUP/DMF0042_1_RTF.cs:31 ; GSCM | tools/AsisFacts 가 어느 폼에서도 열지 않는 DMF0042_1_RTF 팝업을 DMF0042 화면의 팝업 원천으로 넣었습니다. |
| T-c3a574e1 | C6 | 판정필요 | 추출오류 | NA | Y | Y AS-IS 원문 인용 확인 | DEMAND_OPERATION 연쇄는 DMF0042_1_RTF 팝업의 spdMain_ComboCloseUp 에만 있습니다. GSCM 전체를 Grep 하니 DMF0042_1_RTF 를 여는 코드가 없었습니다. 이 화면이 여는 팝업은 Exchange Rate·Version CutOff·Replace 세 개뿐이라 이 컬럼은 Business Plan 화면의 동작이 아닙니다. | GSCM/06.UIL/GSCM.DM.Plan.UIL/POPUP/DMF0042_1_RTF.cs:31 ; GSCM/06.UIL/GSCM.DM.Plan.UIL/POPUP/DMF0042_1_RTF.cs:1699 ; GSCM | tools/AsisFacts 가 어느 폼에서도 열지 않는 DMF0042_1_RTF 팝업을 파일 이름 접두어만 보고 DMF0042 화면의 팝업 원천으로 넣었습니다. |
| T-1547284b | X-ROW | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-d1ea5166 | C2 | 판정필요 | 추출오류 | NA | Y | Y AS-IS 원문 인용 확인 | IMPUTATION_YN 에서 DEMAND_OPERATION 으로 이어지는 콤보 연쇄는 다른 프로젝트의 POPUP/DMF0042_1_RTF.cs 에 있는 규칙이다. 이 화면의 세 폼 소스에는 IMPUTATION_YN 컬럼이 없다. 이 팝업을 여는 코드도 없다. | GSCM/06.UIL/GSCM.DM.Plan.UIL/POPUP/DMF0042_1_RTF.cs:1661 ; GSCM/06.UIL/GSCM.DM.Plan.UIL/POPUP/DMF0042_1_RTF.cs:1667 | tools/AsisFacts: 등록 소스 목록 밖의 GSCM.DM.Plan.UIL/POPUP/DMF0042_1_RTF.cs 를 화면 ID 접두어 일치만으로 DMF0042 원천에 넣었다. |
| T-d4cf1ede | C6 | 판정필요 | 추출오류 | NA | Y | Y AS-IS 원문 인용 확인 | IMPUTATION_YN 연쇄는 DMF0042_1_RTF 팝업 안의 코드입니다. GSCM 전체를 Grep 하니 이 팝업을 여는 코드가 없었습니다. Business Plan 화면이 여는 팝업에는 이 컬럼이 없어 검사 대상이 아닙니다. | GSCM/06.UIL/GSCM.DM.Plan.UIL/POPUP/DMF0042_1_RTF.cs:1661 ; GSCM/06.UIL/GSCM.DM.Plan.UIL/POPUP/DMF0042_1_RTF.cs:31 ; GSCM | tools/AsisFacts 가 어느 폼에서도 열지 않는 DMF0042_1_RTF 팝업을 DMF0042 화면의 팝업 원천으로 넣었습니다. |
| T-77c71bad | A5 | ERROR | 미검토 |  | N | N 대표 T-31b778c5 와 판단이 다름 — 다음 실행에 단독 검토 |  |  |  |
| T-ee990a3d | X-ROW | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-06ce1375 | X-ROW | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-f626fd73 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-b38ac018 | A5 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-3092e290 | H2 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-465f21a5 | H5 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-7523da8a | D5 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-ebec3986 | X-ROW | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-a3bb14d3 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-74d9ddfc | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-88f4ff14 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-09181387 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-144ee1b8 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-27717979 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-498eb975 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-39d9548c | A6 | 판정필요 | 검사기오판 | PASS | Y | N AS-IS 원문 인용 또는 등록 룰 번호 없음 | AS-IS ORDER BY USER_ID 는 #TEMP_SCM_MST_SSO_USER_INFO 임시 테이블에 넣을 때 쓰는 정렬이고, 그리드 결과 정렬은 컬럼 메타로 만든 @GroupList 이다. TO-BE 도 같은 메타로 만든 v_GroupList 로 최종 결과를 정렬하므로 정렬 기준이 같다. 검사기가 임시 테이블 정렬을 결과 정렬로 잘못 비교했다. | _artifacts/_apply_corporate/CELLPROD_SLASH_20261027/sources/PKG_DMF0042.PACKAGE_BODY.sql:2820 | tools/Harness/verify/sort_check.py 가 SELECT INTO 임시 테이블의 ORDER BY 를 결과 정렬 키로 잡고 동적 SQL 의 ORDER BY @GroupList 를 보지 않는다. |
| T-d25ad0ee | F4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-5a3327a0 | G1 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-a9b82e1b | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-75393800 | A6 | 판정필요 | 검사기오판 | PASS | Y | N AS-IS 원문 인용 또는 등록 룰 번호 없음 | AS-IS ORDER BY USER_ID 는 #TEMP_SCM_MST_SSO_USER_INFO 임시 테이블에 넣을 때 쓰는 정렬이고, 그리드 결과 정렬은 컬럼 메타로 만든 @GroupList 이다. TO-BE 도 같은 메타로 만든 v_GroupList 로 최종 결과를 정렬하므로 정렬 기준이 같다. 검사기가 임시 테이블 정렬을 결과 정렬로 잘못 비교했다. | _artifacts/_apply_corporate/CELLPROD_SLASH_20261027/sources/PKG_DMF0042.PACKAGE_BODY.sql:2820 | tools/Harness/verify/sort_check.py 가 SELECT INTO 임시 테이블의 ORDER BY 를 결과 정렬 키로 잡고 동적 SQL 의 ORDER BY @GroupList 를 보지 않는다. |
| T-8d612695 | F4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-463194f4 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-f4a7b362 | DB-SYN | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-c8047470 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-28795515 | B4 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-f5be429d | B3 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-1bd2d6bf | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-43a9d4ea | H2 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-10a7c413 | B4 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-4e5e5640 | B3 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-7bdc60d4 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-4aa91bae | B4 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-48a08924 | B3 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-fd89a75e | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-d8aa6be2 | B4 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-c9534ac8 | B3 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-ba46ab62 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-8df5634e | B4 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-9174a04a | B3 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-2a36cd68 | F4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-dbf6c47c | DB-SYN | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-4410427c | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-e73a34a6 | B4 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-230567b0 | B3 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-477fc542 | F4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-76d5025d | DB-SYN | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-c574db70 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-59e2cdab | B4 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-6526ed9e | B3 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-ae4b8937 | F4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-3272da5a | DB-SYN | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-7ad74fc3 | B4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-c30202b7 | B3 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-1793cdfa | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-bdd05f33 | X-ROW | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-78ccfffb | X-ROW | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-ebb0d065 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-c4a2bf8a | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-4eb04f19 | X-ROW | 판정필요 | 추출오류 | NA | Y | Y AS-IS 원문 인용 확인 | MinColumnChk 는 빌드에서 빠진 DMF0042_2_BizPlan.cs 에만 있습니다. GSCM.DM.Plan.UIL.csproj 에는 DMF0042_1_BizPlan.cs 와 DMF0042_3_BizPlan.cs 만 들어 있고, DMF0042_2 는 어느 프로젝트 파일에도 없습니다. 따라서 DMF0042 화면의 AS-IS 동작이 아닙니다. | GSCM/06.UIL/GSCM.DM.Plan.UIL/GSCM.DM.Plan.UIL.csproj:143 ; GSCM/06.UIL/GSCM.DM.Plan.UIL/GSCM.DM.Plan.UIL.csproj:149 ; GS | tools/AsisFacts 는 폴더의 .cs 를 모두 진입점 대조표에 넣고, csproj Compile 목록에 없는 파일(DMF0042_2_BizPlan.cs)을 걸러내지 않습니다. |
| T-699ce9c3 | X-ROW | 판정필요 | 추출오류 | NA | Y | Y AS-IS 원문 인용 확인 | OnShown 이 있는 DMF0042_2_BizPlan.cs 는 GSCM.DM.Plan.UIL.csproj 의 Compile 목록에 없어 빌드되지 않습니다. 메서드 본문도 base.OnShown 호출 뒤 지역 변수 sDivision 에 값을 넣기만 하고 쓰지 않으므로, 화면에 보이는 동작이 없습니다. | GSCM/06.UIL/GSCM.DM.Plan.UIL/GSCM.DM.Plan.UIL.csproj:149 ; GSCM/06.UIL/GSCM.DM.Plan.UIL/DMF0042_2_BizPlan.cs:194 | tools/AsisFacts 는 폴더의 .cs 를 모두 진입점 대조표에 넣고, csproj Compile 목록에 없는 파일(DMF0042_2_BizPlan.cs)을 걸러내지 않습니다. |
| T-1a8a5152 | X-ROW | 판정필요 | 추출오류 | NA | Y | Y AS-IS 원문 인용 확인 | ParameterString 은 DMF0042_2_BizPlan.cs 에 있는데, 이 파일은 GSCM.DM.Plan.UIL.csproj 의 Compile 목록에 없습니다. 목록에는 DMF0042_1_BizPlan 과 DMF0042_3_BizPlan 만 있고, GSCM 아래 csproj·sln·resx 를 Grep 해도 DMF0042_2 는 0건입니다. 빌드되지 않는 폼이고 DMF0042 화면 원천 12개 파일에도 없으므로 AS-IS 동작이 아닙니다. | GSCM/06.UIL/GSCM.DM.Plan.UIL/GSCM.DM.Plan.UIL.csproj:143 ; GSCM/06.UIL/GSCM.DM.Plan.UIL/GSCM.DM.Plan.UIL.csproj:149 ; GS | tools/AsisFacts 는 폴더의 .cs 를 모두 진입점 대조표에 넣고, csproj Compile 목록에 없는 파일(DMF0042_2_BizPlan.cs)을 걸러내지 않습니다. |
| T-4793d1ae | F4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-0612c3f6 | F4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-7b008706 | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-5c0369a9 | E4 | FAIL | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | [대표 T-1115bd5d 와 같은 증거] AS-IS SaveData는 Division 40 행에서 End Customer, Sales Site, Model, Currency, FcstType, Incoterms, Cell Prod Site 중 하나라도 비어 있으면 MSG00310을 띄우고 저장을 멈춘다. TO-BE도 Save 때 같은 칸을 필수로 검사해 '{0} 값은 필수 입력 항목입니다.' 알림을 띄우고 저장을 막는다. 같은 화면의 E7 측정에서도 신규행 S | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_1_BizPlan/DMF0042_1_BizPlan.cs:900 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF00 | Doc/e2e/specs/_trace.spec.ts:1534 빈값 위반은 신규행이 처음부터 비어 있어 이미 충족되는데, 대상 칸이 편집 불가라는 이유로 Save 시도 없이 FAIL을 기록한다. |
| T-e96fe73c | E4 | FAIL | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | [대표 T-1115bd5d 와 같은 증거] AS-IS SaveData는 Division 40 행에서 End Customer, Sales Site, Model, Currency, FcstType, Incoterms, Cell Prod Site 중 하나라도 비어 있으면 MSG00310을 띄우고 저장을 멈춘다. TO-BE도 Save 때 같은 칸을 필수로 검사해 '{0} 값은 필수 입력 항목입니다.' 알림을 띄우고 저장을 막는다. 같은 화면의 E7 측정에서도 신규행 S | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_1_BizPlan/DMF0042_1_BizPlan.cs:900 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF00 | Doc/e2e/specs/_trace.spec.ts:1534 빈값 위반은 신규행이 처음부터 비어 있어 이미 충족되는데, 대상 칸이 편집 불가라는 이유로 Save 시도 없이 FAIL을 기록한다. |
| T-2bde85df | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-5745662d | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-16a9d578 | DB-SYN | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-521cf169 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-546139c5 | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-eb4e765e | X-ROW | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-46f7143c | H2 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-2d36e162 | C3 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-6ccda6a5 | A5 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-9db3c4f4 | H2 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-248e0623 | H5 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-136e7311 | D5 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-a1e135fb | C3 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-73c48698 | X-ROW | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-9f72ea71 | A5 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-87223742 | H2 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-a918226a | H5 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-2799a696 | D5 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-4df14d7a | C3 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-d268c01e | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-c43fdef5 | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-3bf95965 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-42ed66b3 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-73830019 | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-adcaa8fe | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-eb5cf9bf | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-38800fb8 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-3c700b01 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-088c74bf | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-84a66e14 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-f5a0401b | F4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-f1c9e0ac | DB-SYN | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-fccafcd0 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-0c2c141c | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-4a4be483 | X-ROW | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-0f7cfd8a | C2 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-8322e425 | C3 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-78057e99 | C6 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-8192f4c6 | X-ROW | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-5f45dbc7 | C2 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-e2014ace | C3 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-eb8066bc | C6 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-77ade745 | X-ROW | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-d64e4edd | C2 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-cc5c59c1 | C3 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-30a8d4c6 | C6 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-20ce8859 | X-ROW | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-5b7235e3 | C2 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-15858d2a | C3 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-7ac799d7 | C6 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-0bb596b2 | X-ROW | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-0d98064a | C2 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-70b0db75 | C6 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-6ae411f6 | X-ROW | 판정필요 | 추출오류 | NA | Y | Y AS-IS 원문 인용 확인 | fnValidation 은 빌드에서 빠진 DMF0042_2_BizPlan.cs 의 메서드입니다. GSCM.DM.Plan.UIL.csproj 에는 DMF0042_1_BizPlan 과 DMF0042_3_BizPlan 만 등록되어 있고, DMF0042_2 는 GSCM 아래 프로젝트 파일 어디에도 없습니다. 따라서 DMF0042 화면의 AS-IS 동작이 아닙니다. | GSCM/06.UIL/GSCM.DM.Plan.UIL/GSCM.DM.Plan.UIL.csproj:143 ; GSCM/06.UIL/GSCM.DM.Plan.UIL/GSCM.DM.Plan.UIL.csproj:149 ; GS | tools/AsisFacts 는 폴더의 .cs 를 모두 진입점 대조표에 넣고, csproj Compile 목록에 없는 파일(DMF0042_2_BizPlan.cs)을 걸러내지 않습니다. |
| T-5b3a6c34 | M4 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-31464c91 | M4 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-9b6294f2 | M4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-27da2bc1 | M4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-92ff4066 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-6fba1fe0 | F4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-0e70e01d | DB-SYN | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-a6aae925 | M4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-f3f6566d | M4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-01ea874b | M4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-2fdd4776 | M4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-9c3ac2fb | C3 | 판정필요 | 추출오류 | NA | Y | Y AS-IS 원문 인용 확인 | 기대값 근거 DMF0042_2_BizPlan.cs 는 이 화면 소스가 아닌 다른 폼이다. 이 화면 DMF0042_BizPlan.cs 에서 CELL_PER_PACK 정의는 주석이고, Model 팝업 선택은 ITEM_ID·ITEM_ID40·ITEM_NAME 만 채운다. Cell/Pack 연쇄 채움은 이 화면에 없다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:174 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_B | tools/AsisFacts: 화면 소스 수집이 파일명 접두(DMF0042_)로 GSCM.DM.Plan.UIL/DMF0042_2_BizPlan.cs 까지 끌어와 다른 폼의 대입문을 이 화면 대조표에 넣었다. |
| T-fafa39bd | M4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-f16b1be7 | C3 | 판정필요 | 추출오류 | NA | Y | Y AS-IS 원문 인용 확인 | 기대값 근거인 DMF0042_2_BizPlan.cs 는 GSCM.DM.Plan.UIL 에 있는 별도 폼이고, 이 화면의 소스 목록에 없으며 GSCM 안에서 이 폼을 여는 코드도 없습니다. 이 화면의 DMF0042_BizPlan.cs 에서는 CELL_PER_MODULE 컬럼 정의와 신규 행 잠금이 모두 주석입니다. 남은 코드는 저장 파라미터를 만드는 ParameterString 뿐이고, Model 선택 뒤 Cell/Module 을 연쇄로 채우는 SetText 는  | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:175 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_B | tools/AsisFacts 가 화면 ID 접두어가 같다는 이유로 다른 프로젝트의 DMF0042_2_BizPlan.cs 값 대입 문장을 이 화면의 연쇄 자동 채움 원천으로 넣었습니다. |
| T-643183ef | M4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-4d7afe55 | C3 | 판정필요 | 추출오류 | NA | Y | Y AS-IS 원문 인용 확인 | Model 선택 뒤 MODULE_PER_PACK 을 채우는 1874·1929행은 등록 소스가 아닌 GSCM.DM.Plan.UIL/DMF0042_2_BizPlan.cs 에 있다. 이 화면의 DMF0042_BizPlan·DMF0042_1_BizPlan.cs 에서는 MODULE_PER_PACK 정의가 주석이다. DMF0042_3_BizPlan.cs 는 잠금만 걸고 값을 넣는 문장이 없다. | GSCM/06.UIL/GSCM.DM.Plan.UIL/DMF0042_2_BizPlan.cs:1929 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizP | tools/AsisFacts: 등록 소스 목록 밖의 GSCM.DM.Plan.UIL/DMF0042_2_BizPlan.cs 를 화면 ID 접두어 일치만으로 DMF0042 원천에 넣었다. |
| T-39bd0f78 | M4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-04f45ee3 | M4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-2299b54b | M4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-95cf0e31 | M4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-29050ebe | M4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-e560c235 | C3 | 판정필요 | 추출오류 | NA | Y | Y AS-IS 원문 인용 확인 | 기대값 근거 DMF0042_2_BizPlan.cs 는 이 화면 소스가 아닌 다른 폼이다. 이 화면 DMF0042_BizPlan.cs 의 Project 팝업은 Biz Type 값을 BIZ_TYPE_NAME81 칸에만 넣고 BIZ_TYPE 칸은 쓰지 않는다. BIZ_TYPE 연쇄 채움은 이 화면에 없다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:1806 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_ | tools/AsisFacts: 화면 소스 수집이 파일명 접두(DMF0042_)로 GSCM.DM.Plan.UIL/DMF0042_2_BizPlan.cs 까지 끌어와 다른 폼의 대입문을 이 화면 대조표에 넣었다. |
| T-af79c235 | M4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-93bf9cb3 | C3 | 판정필요 | 추출오류 | NA | Y | Y AS-IS 원문 인용 확인 | 기대값 근거 DMF0042_2_BizPlan.cs 는 GSCM.DM.Plan.UIL 프로젝트의 다른 폼이고 이 화면 AS-IS 소스 목록에 없다. 이 화면 DMF0042_BizPlan.cs 에서 BIZ_TYPE_NAME 정의는 주석이고, Project 팝업은 PROJECT_NAME 과 BIZ_TYPE_NAME81 만 채운다. BIZ_TYPE_NAME 연쇄 채움은 이 화면에 없다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:116 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_B | tools/AsisFacts: 화면 소스 수집이 파일명 접두(DMF0042_)로 GSCM.DM.Plan.UIL/DMF0042_2_BizPlan.cs 까지 끌어와 다른 폼의 대입문을 이 화면 대조표에 넣었다. |
| T-5e4b1dc8 | M4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-a2c8aec3 | C3 | 판정필요 | 추출오류 | NA | Y | Y AS-IS 원문 인용 확인 | 기대값 근거 DMF0042_2_BizPlan.cs 는 이 화면 소스가 아닌 다른 폼이다. 이 화면 DMF0042_BizPlan.cs 의 Project 팝업은 PROJECT_NAME 과 BIZ_TYPE_NAME81 만 채우며, BIZ_UNIT 은 이 화면 소스 어디에도 없다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:1806 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_ | tools/AsisFacts: 화면 소스 수집이 파일명 접두(DMF0042_)로 GSCM.DM.Plan.UIL/DMF0042_2_BizPlan.cs 까지 끌어와 다른 폼의 대입문을 이 화면 대조표에 넣었다. |
| T-5526976e | M4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-2919b343 | C3 | 판정필요 | 추출오류 | NA | Y | Y AS-IS 원문 인용 확인 | PRODUCT_GROUP 자동 채움 근거 2027행은 등록 소스가 아닌 GSCM.DM.Plan.UIL/DMF0042_2_BizPlan.cs 에 있다. 이 화면의 DMF0042_BizPlan·DMF0042_1_BizPlan·DMF0042_3_BizPlan.cs 에는 PRODUCT_GROUP 컬럼 정의가 없다. FORECAST_INFO_PRODUCT_GROUP·PRODUCT_GROUP_NAME 만 있고 이 둘은 잠금만 건다. | GSCM/06.UIL/GSCM.DM.Plan.UIL/DMF0042_2_BizPlan.cs:2027 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizP | tools/AsisFacts: 등록 소스 목록 밖의 GSCM.DM.Plan.UIL/DMF0042_2_BizPlan.cs 를 화면 ID 접두어 일치만으로 DMF0042 원천에 넣었다. |
| T-fed3fcc8 | M4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-e2734e28 | C3 | 판정필요 | 추출오류 | NA | Y | Y AS-IS 원문 인용 확인 | 기대값 근거 DMF0042_2_BizPlan.cs 는 이 화면 소스가 아닌 다른 폼이다. 이 화면 DMF0042_BizPlan.cs 에서 PRODUCT_GROUP_NAME 은 신규 행에서 잠그기만 하고, Project 팝업은 PROJECT_NAME 과 BIZ_TYPE_NAME81 만 채운다. Product Group Name 연쇄 채움은 이 화면에 없다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:1332 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_ | tools/AsisFacts: 화면 소스 수집이 파일명 접두(DMF0042_)로 GSCM.DM.Plan.UIL/DMF0042_2_BizPlan.cs 까지 끌어와 다른 폼의 대입문을 이 화면 대조표에 넣었다. |
| T-eeb7fef3 | C2 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-961adf37 | X-ROW | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-f8ea98d4 | F4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-a8f565e2 | DB-SYN | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-0e23d719 | X-ROW | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-e28a830a | X-ROW | 판정필요 | 추출오류 | NA | Y | Y AS-IS 원문 인용 확인 | spdMain_EditChange 는 빌드되지 않는 DMF0042_2_BizPlan.cs 에 있습니다. 이 파일은 GSCM.DM.Plan.UIL.csproj 의 Compile 목록에 없습니다. 본문도 내부 플래그 bPasteContinue 만 바꾸고 화면에 보이는 동작은 없으므로, DMF0042 화면의 AS-IS 동작이 아닙니다. | GSCM/06.UIL/GSCM.DM.Plan.UIL/GSCM.DM.Plan.UIL.csproj:149 ; GSCM/06.UIL/GSCM.DM.Plan.UIL/DMF0042_2_BizPlan.cs:3201 ; GSCM | tools/AsisFacts 는 폴더의 .cs 를 모두 진입점 대조표에 넣고, csproj Compile 목록에 없는 파일(DMF0042_2_BizPlan.cs)을 걸러내지 않습니다. |
| T-2f9ac831 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-6ef184b8 | M3 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-ef07a211 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-f83a9fae | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-4a43fcb7 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-6fffab92 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-3fe0b471 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-85410454 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-f07af8f0 | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-4ee2cc87 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-dc8e9853 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-a04f8d64 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-b6aadab3 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-b4bb9bd9 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-2c6c36a0 | A6 | 판정필요 | 검사기오판 | NA | Y | Y AS-IS 원문 인용 확인 | DMF0042_3_BizPlan.FindButton 은 FindData 만 부르고 FindData 는 별도 프로그램 DMF0042_3 의 DMF0042_3_Get_BizPlan 을 호출한다. 걸린 FAIL 요소는 DMF0042 메인 SP 정렬 대조라서 이 진입점 경로에 없다. 그 FAIL 요소도 임시표 정렬을 결과 정렬로 잘못 잡은 것이다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_3_BizPlan/DMF0042_3_BizPlan.cs:543 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF00 | tools/Harness/verify/mapping_trace.py: 다른 프로그램(DMF0042_3) 진입점 집계에 DMF0042 메인 SP 정렬 FAIL 요소를 붙였다. |
| T-8240cd98 | F4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-03de7672 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-2373470d | A6 | 판정필요 | 검사기오판 | NA | Y | Y AS-IS 원문 인용 확인 | DMF0042_3_BizPlan.FindData 는 별도 프로그램 DMF0042_3(Biz Plan New)의 조회로 DMF0042_3_Get_BizPlan 을 호출한다. 걸린 FAIL 요소는 DMF0042 메인 SP DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA 정렬 대조라서 이 진입점과 관계가 없다. 그 FAIL 요소도 임시표 정렬을 결과 정렬로 잘못 잡은 것이다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_3_BizPlan/DMF0042_3_BizPlan.cs:765 ; Doc/asisfacts/screens/DMF0042/dbmeta_dbo | tools/Harness/verify/mapping_trace.py: 다른 프로그램(DMF0042_3) 진입점 집계에 DMF0042 메인 SP 정렬 FAIL 요소를 붙였다. |
| T-6332685a | F4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-8fe03ee4 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-26d47acd | DB-SYN | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-80ab9523 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-07365a34 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-98383449 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-5ec27bfd | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-5993070b | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-30d8ea1e | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-731d224a | F4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-ecbb9403 | DB-SYN | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-291eac58 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-448e6bfc | F4 | 판정필요 | 추출오류 | NA | Y | Y AS-IS 원문 인용 확인 | DMF0009_GET_CODE 는 변형 폼 DMF0042_3_BizPlan.cs 의 GetComboData 에서만 호출됩니다. 메뉴 DMF0042 에 등록된 정본 DMF0042_BizPlan.cs 에서는 Grep 결과가 0건이고, Measure 콤보를 Data.Common(DMF0042_BP_Measure)로 받습니다. 이 화면이 부를 대상이 아니므로 호출이 없는 것이 맞습니다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_3_BizPlan/DMF0042_3_BizPlan.cs:2951 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0 | tools/Harness/verify/mapping_trace.py: 등록 정본 DMF0042_BizPlan 밖의 변형 폼(_1·_3) 엔드포인트까지 AS-IS 대조표에 넣습니다. |
| T-9ae65fa3 | DB-SYN | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-8dbbcc2b | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-dc9f51c8 | F4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-5571e6d7 | DB-SYN | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-418143b6 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-1517a9f4 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-8454be85 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-35fe4c02 | F4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-648de487 | DB-SYN | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-a8d97468 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-2056df74 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-3610911d | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-d68d3b1d | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-85e0a1fe | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-0d3d8d8c | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-b10e7121 | D3 | 판정필요 | 추출오류 | NA | Y | Y AS-IS 원문 인용 확인 | 신규 행의 KWH 잠금은 DMF0042_3_BizPlan.cs 1307행에만 있습니다. 정본 DMF0042_BizPlan.cs의 InsertRow에서는 NICK_NAME 잠금(1318행) 바로 다음이 PLANT_SITE_ID 블록(1320행)이고, 파일 전체를 Grep해도 KWH가 없습니다. 이 화면에는 KWH 잠금 규칙이 없습니다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:1318 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_ | tools/AsisFacts: lock_rules 추출기가 같은 화면 ID 접두를 가진 다른 폼(DMF0042_3_BizPlan)의 InsertRow 잠금을 정본 DMF0042_BizPlan 규칙에 합쳐 넣었습니다. |
| T-de2e562a | D3 | 판정필요 | 추출오류 | NA | Y | Y AS-IS 원문 인용 확인 | 신규 행의 CELL_NAME 잠금은 DMF0042_3_BizPlan.cs 1309행에만 있습니다. 정본 DMF0042_BizPlan.cs에서는 NICK_NAME 잠금 다음이 PLANT_SITE_ID 블록이고, 파일 전체를 Grep해도 CELL_NAME이 없습니다. 이 화면에는 CELL_NAME 잠금 규칙이 없습니다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:1318 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_ | tools/AsisFacts: lock_rules 추출기가 DMF0042_3_BizPlan 폼의 InsertRow 잠금을 정본 DMF0042_BizPlan 규칙으로 기록했습니다. |
| T-9d8cbb6a | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-e3bdd8cb | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-129d56fe | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-065f582b | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-d9b455a2 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-2732a63c | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-66167f97 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-df4e32f6 | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-db01f180 | E4 | FAIL | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | [대표 T-1115bd5d 와 같은 증거] AS-IS SaveData는 Division 40 행에서 End Customer, Sales Site, Model, Currency, FcstType, Incoterms, Cell Prod Site 중 하나라도 비어 있으면 MSG00310을 띄우고 저장을 멈춘다. TO-BE도 Save 때 같은 칸을 필수로 검사해 '{0} 값은 필수 입력 항목입니다.' 알림을 띄우고 저장을 막는다. 같은 화면의 E7 측정에서도 신규행 S | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_1_BizPlan/DMF0042_1_BizPlan.cs:900 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF00 | Doc/e2e/specs/_trace.spec.ts:1534 빈값 위반은 신규행이 처음부터 비어 있어 이미 충족되는데, 대상 칸이 편집 불가라는 이유로 Save 시도 없이 FAIL을 기록한다. |
| T-544eb0df | E4 | FAIL | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | [대표 T-1115bd5d 와 같은 증거] AS-IS SaveData는 Division 40 행에서 End Customer, Sales Site, Model, Currency, FcstType, Incoterms, Cell Prod Site 중 하나라도 비어 있으면 MSG00310을 띄우고 저장을 멈춘다. TO-BE도 Save 때 같은 칸을 필수로 검사해 '{0} 값은 필수 입력 항목입니다.' 알림을 띄우고 저장을 막는다. 같은 화면의 E7 측정에서도 신규행 S | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_1_BizPlan/DMF0042_1_BizPlan.cs:900 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF00 | Doc/e2e/specs/_trace.spec.ts:1534 빈값 위반은 신규행이 처음부터 비어 있어 이미 충족되는데, 대상 칸이 편집 불가라는 이유로 Save 시도 없이 FAIL을 기록한다. |
| T-eb828187 | E4 | FAIL | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | [대표 T-1115bd5d 와 같은 증거] AS-IS SaveData는 Division 40 행에서 End Customer, Sales Site, Model, Currency, FcstType, Incoterms, Cell Prod Site 중 하나라도 비어 있으면 MSG00310을 띄우고 저장을 멈춘다. TO-BE도 Save 때 같은 칸을 필수로 검사해 '{0} 값은 필수 입력 항목입니다.' 알림을 띄우고 저장을 막는다. 같은 화면의 E7 측정에서도 신규행 S | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_1_BizPlan/DMF0042_1_BizPlan.cs:900 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF00 | Doc/e2e/specs/_trace.spec.ts:1534 빈값 위반은 신규행이 처음부터 비어 있어 이미 충족되는데, 대상 칸이 편집 불가라는 이유로 Save 시도 없이 FAIL을 기록한다. |
| T-72a7caa4 | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-da0773d5 | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-9b7d6588 | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-bfd34f8f | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-6fa13b3e | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-81c9ec3d | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-4c1ce0ea | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-5e4c8f2f | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-0505ff77 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-edf1f7e1 | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-0bfb307c | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-169a4729 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-130c9b06 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-76034f82 | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-5e5e063d | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-56a6bf81 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-340f6f5d | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-5b25005c | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-ff78cf57 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-78e4c3e7 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-fc528a1e | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-63413ea5 | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-67b7fe0b | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-50b48a70 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-2072f194 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-4ea2782c | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-2848a3a0 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-1134d6f6 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-33a5e3f5 | M4 | 판정필요 | 추출오류 | NA | Y | Y AS-IS 원문 인용 확인 | DMF0042_3_BizPlan은 사업계획 화면의 다른 폼이고, 이 폼을 팝업으로 여는 코드가 GSCM 어디에도 없습니다. 근거로 든 1664~1672행은 헤더를 더블클릭하면 분기·월 컬럼을 펼치거나 접는 코드이고, 팝업에서 고른 값을 칸에 넣는 동작이 아닙니다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_3_BizPlan/DMF0042_3_BizPlan.cs:1664 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0 | tools/AsisFacts 에서 화면 폼 클래스 이름을 POPUP 요소로 등록하고, 헤더 더블클릭의 컬럼 펼침 분기를 팝업 선택값 반영 근거로 잡았습니다. |
| T-62d88703 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-a6cbe159 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-b260dc8a | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-5b7fd13b | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-58a974f6 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-25d627ba | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-bbc1c435 | M3 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-a32887da | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-aee4f3da | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-029f3db4 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-267044bb | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-7ea04ca8 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-d37f1ad4 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-28c32838 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-deb42344 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-dda83ea2 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-3c021586 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-815c01cb | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-d2096440 | A1 | 판정필요 | TOBE룰 | NA | Y | Y 등록 룰 CR-105 + 인용 확인 | AS-IS DMF0042_GET_SPREAD_TITLE 와 TO-BE P_DMF0042_GET_SPREAD_TITLE 는 둘 다 사용자별 컬럼 설정(SCM_MST_TITLESET_USER)을 읽고, Division별 필수 표시와 정렬 분기도 같습니다. 지적된 차이는 AS-IS 25행과 TO-BE 19행의 행 수, 키 집합 차이(공통 7행)뿐이며 CR-105 에 따라 판정에서 뺍니다. 최신 golden 기록은 p_start_yyyymmdd, p_end_yyyymm | To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.sql:817 ; To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.sq |  |
| T-6d5417ad | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-e5209fdc | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-c441b25f | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-7066b7eb | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-6af9775b | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-869648ce | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-60d807e6 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-e2c31343 | F4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-cb4dec24 | DB-SYN | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-4a50b030 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-d7d4e026 | F4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-ae443c36 | DB-SYN | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-22ae8065 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-c70eea41 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-884db370 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-3fc5cd75 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-cfc09fe9 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-e739c0aa | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-d82e4186 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-be84750e | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-0ed3517d | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-335523c6 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-1c18448a | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-452fed72 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-7f887110 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-9ccdd75b | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-504fd6a2 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-49d2566b | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-597c98e8 | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-523d21c7 | E4 | FAIL | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | [대표 T-1115bd5d 와 같은 증거] AS-IS SaveData는 Division 40 행에서 End Customer, Sales Site, Model, Currency, FcstType, Incoterms, Cell Prod Site 중 하나라도 비어 있으면 MSG00310을 띄우고 저장을 멈춘다. TO-BE도 Save 때 같은 칸을 필수로 검사해 '{0} 값은 필수 입력 항목입니다.' 알림을 띄우고 저장을 막는다. 같은 화면의 E7 측정에서도 신규행 S | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_1_BizPlan/DMF0042_1_BizPlan.cs:900 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF00 | Doc/e2e/specs/_trace.spec.ts:1534 빈값 위반은 신규행이 처음부터 비어 있어 이미 충족되는데, 대상 칸이 편집 불가라는 이유로 Save 시도 없이 FAIL을 기록한다. |
| T-a0aeacff | E4 | FAIL | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | [대표 T-1115bd5d 와 같은 증거] AS-IS SaveData는 Division 40 행에서 End Customer, Sales Site, Model, Currency, FcstType, Incoterms, Cell Prod Site 중 하나라도 비어 있으면 MSG00310을 띄우고 저장을 멈춘다. TO-BE도 Save 때 같은 칸을 필수로 검사해 '{0} 값은 필수 입력 항목입니다.' 알림을 띄우고 저장을 막는다. 같은 화면의 E7 측정에서도 신규행 S | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_1_BizPlan/DMF0042_1_BizPlan.cs:900 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF00 | Doc/e2e/specs/_trace.spec.ts:1534 빈값 위반은 신규행이 처음부터 비어 있어 이미 충족되는데, 대상 칸이 편집 불가라는 이유로 Save 시도 없이 FAIL을 기록한다. |
| T-d535e96c | E4 | FAIL | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | [대표 T-1115bd5d 와 같은 증거] AS-IS SaveData는 Division 40 행에서 End Customer, Sales Site, Model, Currency, FcstType, Incoterms, Cell Prod Site 중 하나라도 비어 있으면 MSG00310을 띄우고 저장을 멈춘다. TO-BE도 Save 때 같은 칸을 필수로 검사해 '{0} 값은 필수 입력 항목입니다.' 알림을 띄우고 저장을 막는다. 같은 화면의 E7 측정에서도 신규행 S | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_1_BizPlan/DMF0042_1_BizPlan.cs:900 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF00 | Doc/e2e/specs/_trace.spec.ts:1534 빈값 위반은 신규행이 처음부터 비어 있어 이미 충족되는데, 대상 칸이 편집 불가라는 이유로 Save 시도 없이 FAIL을 기록한다. |
| T-b52ef197 | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-2e9d7587 | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-ddd7cebb | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-d5fd5418 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-b80acad6 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-e21baff2 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-53f16337 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-0062872c | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-6dbe9fd6 | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-214151e6 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-09b0d350 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-4f524406 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-b5128068 | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-09cd1658 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-6312cc3f | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-6e5919af | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-90991c83 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-1d46e528 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-7dca3ea7 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-58e09e28 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-c14cf0ce | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-aa29002f | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-56d9fd77 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-13a85b1e | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-8af8c277 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-681b7af0 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-977947a8 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-2ec65517 | M4 | 판정필요 | 추출오류 | NA | Y | Y AS-IS 원문 인용 확인 | DMF0042_BizPlan은 이 화면의 본 폼입니다. GSCM 전체를 'new DMF0042_' 로 찾아도 이 폼을 팝업으로 여는 코드가 없습니다. 근거로 든 1663~1671행은 헤더를 더블클릭하면 분기·월 컬럼을 펼치거나 접는 코드이고, 그리드의 실제 팝업(Model 팝업 DM0002, Project 팝업 SCM0002)은 ITEM_ID·PROJECT_CODE 행에서 따로 검사합니다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:1663 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_ | tools/AsisFacts 에서 화면 폼 클래스 이름을 POPUP 요소로 등록하고, spdMain_CellDoubleClick 의 헤더 분기(컬럼 펼침)를 팝업 선택값 반영 근거로 잡았습니다. |
| T-2c9c4678 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-42323498 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-9ecb20bc | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-c27db0cf | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-a7aa1c83 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-1d746646 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-fb2a3471 | M3 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-fe41ae68 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-1c5a9493 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-22aca8bd | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-12bd5f94 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-8580cf26 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-41cedb65 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-6ddc58c5 | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-a2302f1c | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-cb0c8208 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-bcb4957f | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-d15a472e | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-bde93180 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-5f9d03fa | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-e2988320 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-52ae0f43 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-0b1f52f7 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-c59bbae3 | F4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-917f39b9 | DB-SYN | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-a9dfba7f | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-582f8a0d | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-505e35d5 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-4fcf7b19 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-1e8de6c3 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-08ef36e8 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-1c5d9e7b | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-c2c86f50 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-474a8b4b | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-94080b54 | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-4870d81a | D3 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-054add7e | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-a125e05b | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-df944add | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-936d89f2 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-21799763 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-622c3b08 | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-a950924d | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-c79fd7af | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-5b3abdd3 | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-f541a107 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-b15b5720 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-fe04d7ad | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-791edaff | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-ec5092cd | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-c284b114 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-f7987240 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-35a70eb0 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-fcdfa0cd | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-67555f4b | M3 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-ba391b15 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-de0ba96d | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-94b50456 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-cca242ac | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-09a21c14 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-3ee71852 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-551c1e93 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-a2b77e07 | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-9be370d3 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-cad765de | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-8db4b5ae | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-a50b302e | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-fab197d9 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-9daa9f2f | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-8aee9ed7 | M4 | 판정필요 | 추출오류 | NA | Y | Y AS-IS 원문 인용 확인 | DMF0042_BizPlan_old.cs는 GSCM.DM.Plan.UIL.csproj의 Compile 목록에 없습니다. 그 csproj에는 DMF0042_BizPlan·_1·_3만 들어 있어 이 파일은 실행되지 않는 코드이고, 이 화면의 원천 소스 목록에도 없습니다. 근거로 든 1299~1307행도 헤더를 더블클릭하면 컬럼을 펼치거나 접는 코드이고 팝업 선택이 아닙니다. | GSCM/06.UIL/GSCM.DM.Plan.UIL/DMF0042_BizPlan_old.cs:1299 ; GSCM/06.UIL/GSCM.DM.Plan.UIL/DMF0042_BizPlan_old.cs:1307 | tools/AsisFacts 에서 csproj에 들어 있지 않은 _old 백업 파일을 사실 원천으로 읽고, 폼 이름을 POPUP 요소로 등록했습니다. |
| T-3219ed91 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-0f9c4fce | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-c79940b4 | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-469c8663 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-2a6ca60c | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-19c45568 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-86d6fdff | X-ROW | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-0b7f9526 | X-ROW | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-f41ea6f2 | X-ROW | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-b80d78b6 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-7230a88a | X-ROW | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-0e966ad0 | D3 | 판정필요 | 추출오류 | NA | Y | Y AS-IS 원문 인용 확인 | Exchange Rate 팝업의 Currency(CURRENCY_UNITCURRENCY) 잠금은 두 가지뿐입니다. EditButton 에서 권한 그룹을 확인한 뒤 컬럼 전체를 잠그고, InsertRow 에서 조회 시작월이 이번 달보다 이전이면 신규 행을 잠급니다. 행의 셀 값에 따라 잠그는 조건은 없고 lock_rules.csv 에도 이 팝업 행이 없어, 행 값 기반 조건부 잠금이라는 대상이 AS-IS 에 없습니다. | GSCM/06.UIL/GSCM.DM.Plan.UIL/POPUP/DMF0042_ExchangeRatePopup.cs:305 ; GSCM/06.UIL/GSCM.DM.Plan.UIL/POPUP/DMF0042_Exchang | tools/Harness/verify 의 trace 생성기가 lock_rules 에 ROW_COND 행이 없는 팝업 컬럼에도 D3(행 값 기반 조건부 잠금) 행을 만들었습니다. |
| T-8ac93363 | X-ROW | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-a2b9559f | X-ROW | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-0c1c838b | A1 | 판정필요 | 확인불가 | 판정필요 | Y | N 판정 같음 | Exchange Rate 버튼으로 여는 환율 팝업은 헤더를 만들 때 DMF0020_GET_EXCHANGE_POPUP_SPREAD_TITLE을 실제로 호출하므로 검사 대상이 맞습니다. 골든 비교 케이스가 없어 AS-IS SP와 TO-BE PROC를 대조하지 못했습니다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:3056 ; GSCM/06.UIL/GSCM.DM.Plan.UIL/POPUP/DMF0042_ | tools/DbConn/gen_golden_cases.py가 팝업 SP 케이스를 만들지 않아 Doc/golden/golden_cases.csv에 DMF0042 환율 팝업 SP 행이 없습니다. FE가 실제로 보내는 인자(p_start_yyyymmdd, p_end_yyyymmdd)로 케이스 |
| T-3dc8915c | A1 | 판정필요 | 확인불가 | 판정필요 | Y | N 판정 같음 | 환율 팝업의 FindData는 DMF0042_GET_SCM_MST_FUTURE_PRICE_POPUP을 호출하고, TO-BE도 이 조회를 futurePrice 시트로 연결해 두었습니다. 골든 비교 케이스가 없어 행 수와 키 집합을 대조하지 못했습니다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:3056 ; GSCM/06.UIL/GSCM.DM.Plan.UIL/POPUP/DMF0042_ | tools/DbConn/gen_golden_cases.py가 팝업 SP 케이스를 만들지 않아 Doc/golden/golden_cases.csv에 이 SP 행이 없습니다. 인자 p_division_id, p_from_yyyymmdd, p_to_yyyymmdd, p_cate=BP로 케이스를 |
| T-783f05b1 | A1 | 판정필요 | 확인불가 | 판정필요 | Y | N 판정 같음 | 환율 팝업의 FindData는 그리드 데이터를 DMF0042_GET_SCM_MST_FUTURE_PRICE_POPUP_DATA로 조회하고, TO-BE도 이 조회를 futurePriceData 시트로 연결해 두었습니다. 골든 비교 케이스가 없어 행 수와 키 집합을 대조하지 못했습니다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:3056 ; GSCM/06.UIL/GSCM.DM.Plan.UIL/POPUP/DMF0042_ | tools/DbConn/gen_golden_cases.py가 팝업 SP 케이스를 만들지 않아 Doc/golden/golden_cases.csv에 이 SP 행이 없습니다. 인자 p_division_id, p_from_yyyymmdd, p_to_yyyymmdd, p_created_by, p |
| T-fac1aec3 | A6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-5a4fc37b | A6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-5f784c33 | A6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-033f3e69 | F4 | 판정필요 | TOBE룰 | PASS | Y | Y AS-IS 원문 인용 확인 | AS-IS 는 Exchange Rate 버튼으로 연 팝업이 그리드 머리를 그릴 때만 DMF0020_GET_EXCHANGE_POPUP_SPREAD_TITLE 을 부릅니다. 화면 진입이나 조회 때는 부르지 않습니다. TO-BE 환율 모달은 futurePriceData(P_CATE='BP') 조회 결과로 월 칸을 만듭니다. _SPREAD_TITLE 헤더 SP 의 대체는 AG-008 로 등록된 차이입니다. | GSCM/06.UIL/GSCM.DM.Plan.UIL/POPUP/DMF0042_ExchangeRatePopup.cs:237 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan |  |
| T-697412fa | F4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-dcdf38c7 | F4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-4c8fcd54 | X-ROW | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-42f92b99 | DB-SYN | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-4206dd21 | X-ROW | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-60e95aa0 | X-ROW | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-232cd38d | X-ROW | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-0b9e5f7a | G6 | 판정필요 | 확인불가 | 판정필요 | Y | N 판정 같음 | AS-IS Exchange Rate 팝업의 Month From 초기값은 메인 조회조건 Period 의 시작월이다. 검사기는 팝업을 열지 않아 TO-BE 초기값을 재지 못했다. | GSCM/06.UIL/GSCM.DM.Plan.UIL/POPUP/DMF0042_ExchangeRatePopup.cs:95 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/ | tools/E2E _trace.spec 이 Exchange Rate 팝업을 열지 않아 팝업 내부 조건을 재지 못했다. 기대값 근거도 InitSpread(224~238행)가 아니라 LoadData 95~96행이어야 한다. |
| T-07e36228 | G6 | 판정필요 | 확인불가 | 판정필요 | Y | N 판정 같음 | AS-IS Exchange Rate 팝업의 Month To 초기값은 메인 조회조건 Period 의 종료월이다. 검사기는 팝업을 열지 않아 TO-BE 초기값을 재지 못했다. | GSCM/06.UIL/GSCM.DM.Plan.UIL/POPUP/DMF0042_ExchangeRatePopup.cs:96 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/ | tools/E2E _trace.spec 이 Exchange Rate 팝업을 열지 않아 팝업 내부 조건을 재지 못했다. 기대값 근거도 InitSpread(224~239행)가 아니라 LoadData 95~96행이어야 한다. |
| T-4c20e2a5 | G4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-f955a57f | G4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-31b778c5 | A5 | 판정필요 | 검사기오판 | 판정필요 | Y | N 판정 같음 | CURRENCY_UNITCURRENCY와 UNIT_CURRENCY는 환율 팝업(Sales Price PopUp)의 컬럼이고, AS-IS는 이 팝업을 btnExchangeRate 버튼으로 엽니다. 검사기는 팝업을 여는 경로를 ITEM_ID 셀로 잡았는데, Div 40 그리드에는 ITEM_ID 대신 ITEM_ID40이 있어 셀을 찾지 못했고 측정하지 못했습니다. 같은 묶음의 VARIATION_FACTOR, IMPUTATION_YN, DEMAND_OPERATION은  | GSCM/06.UIL/GSCM.DM.Plan.UIL/POPUP/DMF0042_ExchangeRatePopup.cs:230 ; GSCM/06.UIL/GSCM.DM.Plan.UIL/POPUP/DMF0042_Exchang | tools/Harness/verify/mapping_trace.py가 Sales Price PopUp 컬럼의 trigger를 ITEM_ID·PROJECT_CODE 셀로 적어, 실제로 팝업을 여는 btnExchangeRate 버튼 경로로 측정하지 않는다. |
| T-86b7cd86 | A5 | ERROR | 미검토 |  | N | N 대표 T-31b778c5 와 판단이 다름 — 다음 실행에 단독 검토 |  |  |  |
| T-271985b5 | H2 | 판정필요 | 검사기오판 | NA | Y | Y AS-IS 원문 인용 확인 | AS-IS DMF0042 에서 ITEM_ID 칸으로 여는 팝업은 Item 선택 팝업이고, ITEM_ID·PROJECT_CODE 칸으로 여는 Sales Price PopUp 은 없다. CURRENCY_UNITCURRENCY·UNIT_CURRENCY 는 Exchange Rate 버튼으로 여는 환율 팝업의 컬럼이고, REPORT_GROUP8 은 메인 그리드 컬럼이다. 검사기가 없는 팝업 경로로 측정하려다 ITEM_ID 칸을 찾지 못한 것이라 이 대상은 해당이 없다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:1739 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_ | tools/Harness/verify/mapping_trace.py: 다른 화면 메타의 Sales Price PopUp 을 DMF0042 환율 팝업 컬럼과 메인 컬럼에 대응시켜 없는 셀 클릭 경로를 만들었다. |
| T-3abd98ea | H2 | 판정필요 | 검사기오판 | NA | Y | Y AS-IS 원문 인용 확인 | [대표 T-271985b5 와 같은 증거] AS-IS DMF0042 에서 ITEM_ID 칸으로 여는 팝업은 Item 선택 팝업이고, ITEM_ID·PROJECT_CODE 칸으로 여는 Sales Price PopUp 은 없다. CURRENCY_UNITCURRENCY·UNIT_CURRENCY 는 Exchange Rate 버튼으로 여는 환율 팝업의 컬럼이고, REPORT_GROUP8 은 메인 그리드 컬럼이다. 검사기가 없는 팝업 경로로 측정하려다 ITEM_ID 칸을  | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:1739 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_ | tools/Harness/verify/mapping_trace.py: 다른 화면 메타의 Sales Price PopUp 을 DMF0042 환율 팝업 컬럼과 메인 컬럼에 대응시켜 없는 셀 클릭 경로를 만들었다. |
| T-b66cf000 | H5 | 판정필요 | 확인불가 | 판정필요 | Y | N 판정 같음 | AS-IS Exchange Rate 팝업에는 usrMonthFrom 조회조건이 있습니다. TO-BE ExchangeRateModal은 이 조건을 공통 PeriodField로 바꿨지만, 표시 라벨은 공통 컴포넌트 기본값이라 원문만으로 확정할 수 없습니다. 검사엔진도 이 조회조건을 판정하지 못했습니다. | GSCM/06.UIL/GSCM.DM.Plan.UIL/POPUP/DMF0042_ExchangeRatePopup.cs:238 ; nscm-fe/features/demand/src/pages/business-plan/co | tools/E2E의 W5 조회조건 라벨 대조가 Exchange Rate 팝업 안의 PeriodField 라벨을 찾지 못해 대상을 판정하지 못했습니다. |
| T-f48d3681 | H5 | ERROR | 미검토 |  | N | N 대표 T-ab7216ed 와 판단이 다름 — 다음 실행에 단독 검토 |  |  |  |
| T-ab7216ed | H5 | 판정필요 | 실결함 | FAIL | Y | Y AS-IS 원문 인용 확인 | AS-IS Exchange Rate 팝업의 UNIT_CURRENCY 컬럼 라벨은 Unit입니다. TO-BE ExchangeRateModal의 라벨은 Unit Currency이고, 이 차이를 허용하는 TO-BE 룰은 원장에 없습니다. 검사기는 이 팝업을 Exchange Rate 버튼이 아니라 ITEM_ID 셀의 Sales Price 팝업으로 열려다 실패했으므로, 이 판정은 원문 대조에 근거합니다. | GSCM/06.UIL/GSCM.DM.Plan.UIL/POPUP/DMF0042_ExchangeRatePopup.cs:229 ; nscm-fe/features/demand/src/pages/business-plan/co | tools/E2E의 W5 팝업 컬럼 대조가 Exchange Rate 버튼 팝업을 ITEM_ID 셀 트리거의 Sales Price PopUp으로 잘못 연결해서 셀 위치를 찾지 못했습니다. |
| T-0a678bbb | D5 | 판정필요 | 검사기오판 | 판정필요 | Y | N 판정 같음 | UNIT_CURRENCY(콤보)와 CURRENCY_UNITCURRENCY(편집 불가 텍스트)는 AS-IS Exchange Rate 팝업에 있는 컬럼이고, 이 팝업은 btnExchangeRate 버튼으로 열립니다. 검사기는 이 팝업을 ITEM_ID 칸에서 열려고 했고 '셀 위치 확인 불가'로 멈춰 에디터 유형을 재지 못했습니다. 대상이 AS-IS 에 있으므로 NA 로 둘 수 없어 결과를 바꾸지 않습니다. | GSCM/06.UIL/GSCM.DM.Plan.UIL/POPUP/DMF0042_ExchangeRatePopup.cs:229 ; GSCM/06.UIL/GSCM.DM.Plan.UIL/POPUP/DMF0042_Exchang | tools/E2E 트레이스가 Sales Price PopUp 시트의 열기 조건을 ITEM_ID·PROJECT_CODE 칸으로 잡았으나, AS-IS 에서 이 팝업은 btnExchangeRate 버튼으로 열리므로 버튼 클릭으로 열도록 고쳐야 합니다. |
| T-bb6befa4 | D5 | 판정필요 | 검사기오판 | 판정필요 | Y | N 판정 같음 | [대표 T-0a678bbb 와 같은 증거] UNIT_CURRENCY(콤보)와 CURRENCY_UNITCURRENCY(편집 불가 텍스트)는 AS-IS Exchange Rate 팝업에 있는 컬럼이고, 이 팝업은 btnExchangeRate 버튼으로 열립니다. 검사기는 이 팝업을 ITEM_ID 칸에서 열려고 했고 '셀 위치 확인 불가'로 멈춰 에디터 유형을 재지 못했습니다. 대상이 AS-IS 에 있으므로 NA 로 둘 수 없어 결과를 바꾸지 않습니다. | GSCM/06.UIL/GSCM.DM.Plan.UIL/POPUP/DMF0042_ExchangeRatePopup.cs:229 ; GSCM/06.UIL/GSCM.DM.Plan.UIL/POPUP/DMF0042_Exchang | tools/E2E 트레이스가 Sales Price PopUp 시트의 열기 조건을 ITEM_ID·PROJECT_CODE 칸으로 잡았으나, AS-IS 에서 이 팝업은 btnExchangeRate 버튼으로 열리므로 버튼 클릭으로 열도록 고쳐야 합니다. |
| T-06f76081 | X-ROW | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-3ea947bc | X-ROW | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-efac1b2e | F4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-6a617756 | DB-SYN | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-84730c8d | X-ROW | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-2caecc88 | X-ROW | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-83a237d8 | X-ROW | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-38f0d5c6 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-2a572fb4 | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-91d9f839 | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-83f88f89 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-457f2fad | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-fe9b6a44 | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-7ffb198c | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| T-3cac1ef4 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-45c7ca09 | X-ROW | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-1418371f | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| EG-c935c87c | H4 | FAIL | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | Column 버튼 팝업은 팝업 본문 세로 스크롤(paperV)과 가로 스크롤(paperH)이 모두 false이고 내용 초과가 0px입니다. 검사기가 잡은 스크롤 _tableScroll(높이 630, 보이는 영역 371)은 컬럼 목록 표 내부 스크롤입니다. AS-IS 팝업도 컬럼 목록을 FpSpread 그리드로 보여 주므로 그리드 내부 스크롤에 해당합니다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:2872 ; GSCM/06.UIL/GSCM.DM.Plan.UIL/POPUP/DM0002_T | Doc/e2e/specs/eg_popup.spec.ts 568행의 본문 스크롤 제외 조건이 wj-와 MuiAutocomplete만 걸러서, HTML 표로 만든 컬럼 목록 그리드(tableScroll)를 본문 스크롤로 셉니다. |
| EG-b5e6085d | A5 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| EG-4ae61724 | D5 | 판정필요 | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | AS-IS의 Model 조회 조건 버튼과 Model 셀은 DM0002_ItembyDivisionPopupEx를 엽니다. TO-BE도 대응표에 있는 공용 모달 ItemByDivisionModal을 엽니다. 모달 제목이 다국어 문구 LBL00343으로 'Model / Nickname'이라 표시되어 제목 단어 [item, division]이 맞지 않았을 뿐이고, 열리는 팝업은 같습니다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:2856 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_ | tools/Harness/verify: CM-019 팝업 정체 검사가 표시된 제목의 단어만으로 공용 모달을 판별해, 다국어 문구로 제목이 바뀐 같은 모달을 다른 모달로 봅니다(T6·T11). |
| EG-480e08d7 | H6 | FAIL | 실결함 | FAIL | Y | N 판정 같음 | CR-005 는 팝업 버튼을 OK 다음 CLOSE 순서로 두라고 정합니다. TO-BE 공용 ItemByDivisionModal 과 OwnerByDivisionModal 은 Close 버튼을 OK 버튼보다 먼저 두고 있고, buttonWrapper CSS 도 순서를 뒤집지 않아 화면에 Close, OK 순서로 나옵니다. Model/Nickname 조회조건 팝업, Owner 조회조건 팝업, ITEM_ID40 셀 팝업이 모두 이 두 컴포넌트를 쓰므로 세 건 모두 결함 | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:2856 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_ |  |
| EG-b5af24ee | G5 | 판정필요 | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | [대표 EG-a139364c 와 같은 증거] AS-IS 품목 팝업은 bCtlEnable 값과 상관없이 두 분기 모두 Division 을 비활성으로 둔다. 그리드 ITEM_ID40 셀(false 호출)과 조회조건 Model 버튼(true 호출) 모두 Division 이 잠긴다. TO-BE 도 Division 40 이 표시되고 disabled=true 라 같다. | GSCM/06.UIL/GSCM.DM.Plan.UIL/POPUP/DM0002_ItembyDivisionPopupEx.cs:307 ; GSCM/06.UIL/GSCM.DM.Plan.UIL/POPUP/DM0002_Itemb | tools/AsisFacts 분기 추출기가 두 분기에서 같은 값을 대입하는 경우를 조건부로 남겨 판정을 미평가로 두었다. |
| EG-06652e2b | G4 | 판정필요 | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | AS-IS Model by Division 팝업은 Division 이 40 이면 Project 조회조건을 숨기고, 그 밖의 Division 에서만 표시합니다. 검사 때 팝업은 Div 40 Mobility & IT Battery 로 열렸으므로 TO-BE 팝업에 Project 가 없는 것이 AS-IS 와 같습니다. 그리드 ITEM_ID40 칸에서 연 팝업도 Division 40 전용 컬럼이라 같은 판단입니다. | GSCM/06.UIL/GSCM.DM.Plan.UIL/POPUP/DM0002_ItembyDivisionPopupEx.cs:278 ; GSCM/06.UIL/GSCM.DM.Plan.UIL/POPUP/DM0002_Itemb | tools/Harness/verify/judge.py: 팝업 조회조건 구성 판정이 InitControls 의 Division 분기에 따른 Visibility.Never 를 평가하지 않고 Designer 라벨 전체를 기대값으로 썼습니다. |
| EG-3da089ff | M3 | FAIL | 추출오류 | NA | Y | Y AS-IS 원문 인용 확인 | AS-IS 의 Measure 버튼은 화면 초기화 때 버튼을 담은 layoutControlItem4 를 Never 로 숨겨 사용자가 누를 수 없다. TO-BE 도 Measure Select 버튼을 노출하지 않으므로 검사할 대상이 없다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.Designer.cs:1262 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan | tools/AsisFacts 팝업 추출이 Click 핸들러만 보고 InitControls 의 layoutControlItem4.Visibility Never 숨김을 반영하지 않음. |
| EG-6891cb81 | H6 | FAIL | 실결함 | FAIL | Y | N 판정 같음 | [대표 EG-480e08d7 와 같은 증거] CR-005 는 팝업 버튼을 OK 다음 CLOSE 순서로 두라고 정합니다. TO-BE 공용 ItemByDivisionModal 과 OwnerByDivisionModal 은 Close 버튼을 OK 버튼보다 먼저 두고 있고, buttonWrapper CSS 도 순서를 뒤집지 않아 화면에 Close, OK 순서로 나옵니다. Model/Nickname 조회조건 팝업, Owner 조회조건 팝업, ITEM_ID40 셀 팝업이 모 | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:2856 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_ |  |
| EG-76fbcb4f | G1 | 판정필요 | 확인불가 | 판정필요 | Y | N 판정 같음 | Owner 팝업에서 고른 값은 괄호 없이 조회 요청에 실렸지만 메인 조회 결과가 0행이었다. AS-IS SP 와 TO-BE 패키지는 모두 OWNER·OWNER_NAME·OWNER_NAME_KO 부분일치로 같은 조건을 쓴다. 그래서 고른 Owner 에 조회 기간 데이터가 없을 수 있다. 다만 대조군 값을 구하지 못해 원문만으로는 가릴 수 없다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:3023 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_ | Doc/e2e/specs/eg_popup.spec.ts 의 PICK_SEARCH 대조군이 그리드 머리글 'Owner' 로만 값을 찾는다. 그런데 Business Plan 그리드의 OWNER 는 기본 화면에 보이지 않는 선택 표시 컬럼이라 대조군 값을 못 구했다. |
| EG-3c664aec | M3 | FAIL | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | 측정 계정의 Division 은 40 이고, AS-IS 는 Division 40 에서 Project 조회 버튼을 비활성으로 둔다. TO-BE 도 Division 40 에서 Project 조회조건을 비활성으로 두므로 클릭 후 팝업이 열리지 않는 것이 AS-IS 와 같은 동작이다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:266 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_B | Doc/e2e/specs/eg_popup.spec.ts 가 Division 40 에서 비활성인 Project 아이콘을 눌러 팝업 미표시를 FAIL 로 기록함 — 비활성 상태를 먼저 확인하거나 Division 81·82 로 바꾼 뒤 측정해야 함. |
| EG-a5542dfc | G5 | FAIL | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | AS-IS 는 Division 40 일 때 Project 버튼(btnProject)을 비활성으로 두어 팝업이 열리지 않는다. 이번 E2E 는 메인 Division 40 으로 실행되었고, TO-BE 도 Division 40 이면 Project 칸을 비활성으로 둔다. 버튼 다섯 곳 클릭에서 팝업이 열리지 않은 것은 AS-IS 와 같은 동작이다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:266 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_B | tools/E2E 의 CORNERS 검사가 비활성 버튼을 결함으로 기록했다. Division 81 또는 82 로 바꿔 측정해야 한다. |
| EG-316b6de4 | G5 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| EG-6f9ef8cb | H6 | FAIL | 실결함 | FAIL | Y | N 판정 같음 | [대표 EG-480e08d7 와 같은 증거] CR-005 는 팝업 버튼을 OK 다음 CLOSE 순서로 두라고 정합니다. TO-BE 공용 ItemByDivisionModal 과 OwnerByDivisionModal 은 Close 버튼을 OK 버튼보다 먼저 두고 있고, buttonWrapper CSS 도 순서를 뒤집지 않아 화면에 Close, OK 순서로 나옵니다. Model/Nickname 조회조건 팝업, Owner 조회조건 팝업, ITEM_ID40 셀 팝업이 모 | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:2856 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_ |  |
| EG-a139364c | G5 | 판정필요 | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | AS-IS 품목 팝업은 bCtlEnable 값과 상관없이 두 분기 모두 Division 을 비활성으로 둔다. 그리드 ITEM_ID40 셀(false 호출)과 조회조건 Model 버튼(true 호출) 모두 Division 이 잠긴다. TO-BE 도 Division 40 이 표시되고 disabled=true 라 같다. | GSCM/06.UIL/GSCM.DM.Plan.UIL/POPUP/DM0002_ItembyDivisionPopupEx.cs:307 ; GSCM/06.UIL/GSCM.DM.Plan.UIL/POPUP/DM0002_Itemb | tools/AsisFacts 분기 추출기가 두 분기에서 같은 값을 대입하는 경우를 조건부로 남겨 판정을 미평가로 두었다. |
| EG-92eb4b1c | G4 | 판정필요 | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | [대표 EG-06652e2b 와 같은 증거] AS-IS Model by Division 팝업은 Division 이 40 이면 Project 조회조건을 숨기고, 그 밖의 Division 에서만 표시합니다. 검사 때 팝업은 Div 40 Mobility & IT Battery 로 열렸으므로 TO-BE 팝업에 Project 가 없는 것이 AS-IS 와 같습니다. 그리드 ITEM_ID40 칸에서 연 팝업도 Division 40 전용 컬럼이라 같은 판단입니다. | GSCM/06.UIL/GSCM.DM.Plan.UIL/POPUP/DM0002_ItembyDivisionPopupEx.cs:278 ; GSCM/06.UIL/GSCM.DM.Plan.UIL/POPUP/DM0002_Itemb | tools/Harness/verify/judge.py: 팝업 조회조건 구성 판정이 InitControls 의 Division 분기에 따른 Visibility.Never 를 평가하지 않고 Designer 라벨 전체를 기대값으로 썼습니다. |
| EG-d9eea198 | D5 | 판정필요 | 확인불가 | 판정필요 | Y | N 판정 같음 | AS-IS는 신규(I) 행의 ITEM_ID40을 더블클릭하면 Model 팝업을 엽니다. TO-BE 코드도 Division 40 신규 행의 ITEM_ID40을 더블클릭하면 ITEM 모달을 엽니다. 다만 검사기는 0행 상태에서 메타 입력 방식만 보고 실제 더블클릭 동작을 재지 못했습니다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:1704 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_ | tools/E2E: 측정 시점에 Division 40 신규 행이 0행이라 더블클릭 팝업을 재지 못했고, 메타 입력 방식 칸만 보고 기대값 FPModal과 비교했습니다(T27). 신규 행을 넣은 뒤 ITEM_ID40을 더블클릭해 모달이 열리는지 재야 합니다. |
| EG-fe492487 | D5 | FAIL | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | AS-IS 는 InsertRow 에서 신규 행의 ITEM_ID40 칸에만 팝업 이미지 셀을 지정하고, 조회된 기존 행에는 아이콘이 없습니다. 검사기는 조회 결과 97행 중 기존 행 0번 칸을 쟀으므로 아이콘 false 는 AS-IS 와 같은 결과입니다. TO-BE 는 Division 40 신규 행의 ITEM_ID40 칸에 popup-icon 아이콘을 붙입니다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:1243 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_ | tools/E2E 팝업 CELL_ICON 검사가 아이콘 규칙이 신규 행(InsertRow) 전용인지 보지 않고 조회된 기존 행 0번에서 쟀으므로, 행 추가 뒤 신규 행에서 재도록 고쳐야 합니다. |
| EG-842c92ee | M3 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| EG-052ce80f | M3 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| EG-dc4ace27 | M3 | FAIL | 추출오류 | NA | Y | Y AS-IS 원문 인용 확인 | DMF0042 화면 소스의 spdMain_CellDoubleClick 은 헤더 펼침과 ITEM_ID 팝업만 처리하고, 화면 폴더 어디에도 DMF0051_1_RTF 호출이 없다. MEASURE 더블클릭 RTF 팝업은 화면 원천 목록에 없는 DMF0042_2_BizPlan.cs 의 동작이라 검사할 대상이 없다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:1661 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_ | tools/AsisFacts 가 화면 원천 목록에 없는 GSCM.DM.Plan.UIL/DMF0042_2_BizPlan.cs 의 CellDoubleClick 팝업을 이 화면 팝업으로 추출함. |
| EG-648ad11f | D5 | 판정필요 | 추출오류 | NA | Y | Y AS-IS 원문 인용 확인 | MEASURE 칸을 더블클릭해 DMF0051_1_RTF를 여는 동작은 구 프로젝트 GSCM.DM.Plan.UIL의 DMF0042_2_BizPlan.cs 1755행에만 있습니다. GSCM/06.UIL 전체를 Grep해도 정본 DMF0042_BizPlan.cs에는 DMF0051_1_RTF 호출이 없습니다. 이 화면의 MEASURE 칸에는 팝업 대상이 없습니다. | GSCM/06.UIL/GSCM.DM.Plan.UIL/DMF0042_2_BizPlan.cs:1747 ; GSCM/06.UIL/GSCM.DM.Plan.UIL/DMF0042_2_BizPlan.cs:1755 | tools/AsisFacts: 화면 원천 목록에 없는 구 폼 DMF0042_2_BizPlan(GSCM.DM.Plan.UIL)의 더블클릭 팝업을 이 화면의 팝업 컬럼 기대값으로 넣었습니다. |
| EG-88f8e26b | M3 | FAIL | 추출오류 | NA | Y | Y AS-IS 원문 인용 확인 | DMF0042 화면 소스에서 btnIncotermsChg_Click 과 DM0002_MatsterChgPopup 호출은 모두 주석 처리되어 있다. 기대값은 화면 소스가 아닌 옛 파일 DMF0042_BizPlan_old.cs 에서 가져온 것이라 검사할 대상이 없다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:2990 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_ | tools/AsisFacts 가 화면 원천 목록에 없는 GSCM.DM.Plan.UIL/DMF0042_BizPlan_old.cs 의 팝업 호출을 이 화면 팝업으로 추출함. |
| EG-3d161d68 | G5 | FAIL | 추출오류 | NA | Y | Y AS-IS 원문 인용 확인 | AS-IS DMF0042_BizPlan.cs 의 btnIncotermsChg_Click 과 DM0002_MatsterChgPopup 호출은 모두 주석이다. DMF0042 폼 3종 Designer 를 btnIncotermsChg 로 검색했지만 버튼 선언이 없었다. AS-IS 에 없는 버튼이므로 검사 대상이 아니다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:2990 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_ | tools/AsisFacts 팝업 추출기가 주석 처리된 btnIncotermsChg_Click 블록을 팝업 연결로 등록했다. |
| EG-8a37bf3a | G4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| EG-6999bb74 | G4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| EG-caf9b3a0 | J2 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| EG-a6f91f13 | J2 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| EG-cc33b2ef | J2 | ERROR | 검토 제외 |  | N | N 재측정 대상(미분류·엔진) — AI 판정 대상 아님 |  |  |  |
| EG-0bf53460 | G4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| EG-6cff526e | G4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| EG-e1156761 | G4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| EG-0d0a9e7c | G4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| EG-a7bf4344 | G4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| EG-a7dc69c5 | G4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| EG-759294a9 | G4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| EG-9b30db9b | G4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| EG-6ab04fb9 | G4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| EG-2307e4a4 | G4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| EG-677a520d | G4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| EG-fccb6697 | G4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| EG-2e3e6a87 | G4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| EG-3c12284e | G4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| EG-94643a36 | A5 | FAIL | 확인불가 | FAIL | Y | N 판정 같음 | AS-IS 헤더 SP(DMF0042_GET_SPREAD_TITLE)는 사용자 칸 설정(SCM_MST_TITLESET_USER)이 있으면 그 사용자의 컬럼만 돌려줍니다. TO-BE도 개인화 목록에 없는 컬럼은 숨깁니다. 81로 바꾼 뒤 PLANT_SITE_ID가 없는 원인이 측정 계정의 칸 설정인지 TO-BE 메타나 로직인지는 원문만으로 가릴 수 없어, 측정 계정의 TITLESET_USER를 확인해야 합니다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:2957 ; nscm-fe/features/demand/src/pages/business- |  |
| EG-fe8f30ae | A5 | 판정필요 | 확인불가 | 판정필요 | Y | N 판정 같음 | DEPT_ID40, ENERGE_WH, ITEM_NAME은 40 DEFAULT 컬럼입니다. 다만 AS-IS와 TO-BE 모두 칸 설정 보유 사용자에게는 그 사용자의 컬럼만 보여 줍니다. 측정 계정의 칸 설정에 이 3개 컬럼이 빠져 있는지는 원문만으로 확인할 수 없어 판정을 보류합니다. | nscm-fe/features/demand/src/pages/business-plan/useBusinessPlanStore.ts:189 |  |
| EG-0f49e9aa | A5 | FAIL | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | AS-IS는 Division 변경 이벤트에서 바로 InitSpread를 호출해 헤더를 다시 만듭니다. TO-BE도 handleDivisionChange에서 fetchStaticColumns로 선택한 Div의 메타를 다시 받아 조회 전에 컬럼을 재구성하고, 측정에서도 이전 Div(40) 전용 컬럼 잔존은 0건이었습니다. FAIL은 조회 뒤에도 없던 PLANT_SITE_ID 1건을 재구성 판정식이 다시 센 중복 기록입니다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:1485 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_ | Doc/e2e/specs/eg_auth.spec.ts 236행 rebuilt 판정이 메타 DEFAULT 전용 컬럼이 모두 보이기를 요구해, 조회 뒤에도 없는 컬럼(EG024 결과)을 조회 전 미재구성으로 한 번 더 기록한다. |
| EG-cded8dc1 | J2 | 판정필요 | 확인불가 | 판정필요 | Y | N 판정 같음 | TO-BE Save 버튼은 메뉴 단위가 아니라 Biz Plan 시트 단위 SAVE 권한이 있을 때만 노출된다. SCP Planner 그룹의 SAVE 권한이 시트 Biz Plan 으로 등록되어 있는지는 권한 데이터에 달려 있어 원문만으로 가릴 수 없다. 시트명 없이 메뉴 단위로만 SAVE 가 등록되어 있다면 숨김이 결함이 된다. | nscm-fe/features/demand/src/pages/business-plan/BusinessPlan.tsx:522 ; nscm-fe/packages/shared/src/hooks/useTabBtnPermis |  |
| EG-085bfd2a | K4 | 판정필요 | 확인불가 | 판정필요 | Y | N 판정 같음 | AS-IS 의 Save 버튼은 SaveData 를 호출하는 실제 기능이고, TO-BE 는 Save 단추를 'Biz Plan' 시트 단위 SAVE 권한이 있을 때만 노출한다. 검사기 기대값은 메뉴 단위 권한 합집합으로 계산되어 있어, SCP Planner 그룹의 SAVE 권한이 Biz Plan 시트에 등록되어 있는지 권한 데이터를 봐야 결함 여부를 가릴 수 있다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:699 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_B |  |
| EG-593acd7e | J1 | 판정필요 | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | AS-IS Division 콤보는 MyDivision 공통코드로 채우고, 그 SP 분기는 SCM_MST_DIVISION 에서 ATTRIBUTE3 <> 'EE' 이고 VALID_YN = 'Y' 인 Division 만 남긴다. 그래서 권한 그룹에 EE 가 있어도 AS-IS 후보에는 EE 가 나오지 않는다. TO-BE 후보 81,81_HD,81_HG,81_HM,81_ST,81_UC 는 AS-IS 와 같다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:250 ; Doc/_legacy_source/DB_DDL/AsIs_LGCE_SCMDEV_S | Doc/e2e/specs/eg_auth.spec.ts: Data.Common(Data.Type.MyDivision) 호출을 UP_FX_GetCommonDataList @Code='MyDivision' 분기의 ATTRIBUTE3 <> 'EE' 필터로 잇지 못해 기대 후보에 EE 를 남겼다 |
| EG-7ec17779 | J1 | 판정필요 | 확인불가 | 판정필요 | Y | N 판정 같음 | TO-BE Division 초기값은 로그인 세션의 Division 이고, 없으면 40 이다. DM Planner (W/S) 81 계정에서 빈값이 보인 것은 세션 Division 이 후보 81 계열 밖이었거나 콤보 로딩 시점 문제일 수 있다. 세션 값은 원문으로 알 수 없어 화면을 실제로 띄워 확인해야 한다. | nscm-fe/features/demand/src/pages/business-plan/useBusinessPlanStore.ts:134 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042 |  |
| EG-ca8f2b97 | E3 | 판정필요 | 검사기오판 | PASS | Y | N AS-IS 원문 인용 또는 등록 룰 번호 없음 | Div 40 설정 창에 없다고 기록된 Project*(PROJECT_NAME)는 DIVISION_ID가 비어 있어 AS-IS SP에서도 Div 40 그리드에 나오지 않습니다. 검사기는 빈 DIVISION_ID를 전 Division으로 보고 Div 40 기대 필수를 10개로 셌습니다. Div 40에 실제로 속하는 필수 컬럼 8개는 모두 설정 창 목록에 있습니다. | Doc/asisfacts/screens/DMF0042/dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv ; Doc/verify/_parallel/E03/facts/DMF0042.json:2227 ;  | Doc/e2e/specs/eg_auth.spec.ts의 listHas가 빈 DIVISION_ID를 전 Division으로 처리해서 Div 40에 없는 PROJECT_NAME과 BIZ_TYPE_NAME81을 기대 집합에 넣습니다. |
| EG-04da3bba | E3 | 판정필요 | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | AS-IS 컬럼 SP DMF0042_GET_SPREAD_TITLE는 선택한 Division이 DIVISION_ID 목록에 있는 컬럼만 내므로, DIVISION_ID가 빈 Biz.Type*(BIZ_TYPE_NAME81)와 Project*(PROJECT_NAME)는 어느 Division에서도 그리드에 나오지 않습니다. 검사기는 빈 DIVISION_ID를 전 Division으로 보고 Div 40 기대값을 10개로 잡았고, Div 40의 다른 컬럼인 Biz.Type(B | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:2958 ; Doc/asisfacts/screens/DMF0042/dbmeta_dbo_SC | Doc/e2e/specs/eg_auth.spec.ts의 listHas가 빈 DIVISION_ID를 전 Division 포함으로 처리하고 라벨만으로 대조해서 BIZ_TYPE_NAME40과 BIZ_TYPE_NAME81을 같은 컬럼으로 봅니다. AS-IS SP처럼 빈 값은 제외하고 COLUM |
| EG-099823bb | E3 | 판정필요 | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | 설정 창에 없다고 기록된 Biz.Type*(BIZ_TYPE_NAME81)와 Project*(PROJECT_NAME)는 DIVISION_ID가 비어 있습니다. AS-IS SP는 DIVISION_ID 목록에 해당 Division이 있는 컬럼만 내므로 이 두 컬럼은 AS-IS에서도 Div 81과 81_HD·81_HG·81_HM·81_ST·81_UC에서 나오지 않습니다. 두 컬럼을 빼면 Div 81 계열 필수는 6개이고, 설정 창 필수 표시 6개와 일치합니다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:389 ; Doc/verify/_parallel/E03/facts/DMF0042.json: | Doc/e2e/specs/eg_auth.spec.ts의 listHas가 빈 DIVISION_ID를 전 Division으로 처리해서 어느 Division에도 속하지 않는 컬럼을 기대 필수 집합에 넣습니다. |
| EG-a1412d3a | E3 | 판정필요 | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | [대표 EG-099823bb 와 같은 증거] 설정 창에 없다고 기록된 Biz.Type*(BIZ_TYPE_NAME81)와 Project*(PROJECT_NAME)는 DIVISION_ID가 비어 있습니다. AS-IS SP는 DIVISION_ID 목록에 해당 Division이 있는 컬럼만 내므로 이 두 컬럼은 AS-IS에서도 Div 81과 81_HD·81_HG·81_HM·81_ST·81_UC에서 나오지 않습니다. 두 컬럼을 빼면 Div 81 계열 필수는 6개이고, 설 | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:389 ; Doc/verify/_parallel/E03/facts/DMF0042.json: | Doc/e2e/specs/eg_auth.spec.ts의 listHas가 빈 DIVISION_ID를 전 Division으로 처리해서 어느 Division에도 속하지 않는 컬럼을 기대 필수 집합에 넣습니다. |
| EG-6e457275 | E3 | 판정필요 | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | [대표 EG-099823bb 와 같은 증거] 설정 창에 없다고 기록된 Biz.Type*(BIZ_TYPE_NAME81)와 Project*(PROJECT_NAME)는 DIVISION_ID가 비어 있습니다. AS-IS SP는 DIVISION_ID 목록에 해당 Division이 있는 컬럼만 내므로 이 두 컬럼은 AS-IS에서도 Div 81과 81_HD·81_HG·81_HM·81_ST·81_UC에서 나오지 않습니다. 두 컬럼을 빼면 Div 81 계열 필수는 6개이고, 설 | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:389 ; Doc/verify/_parallel/E03/facts/DMF0042.json: | Doc/e2e/specs/eg_auth.spec.ts의 listHas가 빈 DIVISION_ID를 전 Division으로 처리해서 어느 Division에도 속하지 않는 컬럼을 기대 필수 집합에 넣습니다. |
| EG-5fc74038 | E3 | 판정필요 | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | [대표 EG-099823bb 와 같은 증거] 설정 창에 없다고 기록된 Biz.Type*(BIZ_TYPE_NAME81)와 Project*(PROJECT_NAME)는 DIVISION_ID가 비어 있습니다. AS-IS SP는 DIVISION_ID 목록에 해당 Division이 있는 컬럼만 내므로 이 두 컬럼은 AS-IS에서도 Div 81과 81_HD·81_HG·81_HM·81_ST·81_UC에서 나오지 않습니다. 두 컬럼을 빼면 Div 81 계열 필수는 6개이고, 설 | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:389 ; Doc/verify/_parallel/E03/facts/DMF0042.json: | Doc/e2e/specs/eg_auth.spec.ts의 listHas가 빈 DIVISION_ID를 전 Division으로 처리해서 어느 Division에도 속하지 않는 컬럼을 기대 필수 집합에 넣습니다. |
| EG-d0672036 | E3 | 판정필요 | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | [대표 EG-099823bb 와 같은 증거] 설정 창에 없다고 기록된 Biz.Type*(BIZ_TYPE_NAME81)와 Project*(PROJECT_NAME)는 DIVISION_ID가 비어 있습니다. AS-IS SP는 DIVISION_ID 목록에 해당 Division이 있는 컬럼만 내므로 이 두 컬럼은 AS-IS에서도 Div 81과 81_HD·81_HG·81_HM·81_ST·81_UC에서 나오지 않습니다. 두 컬럼을 빼면 Div 81 계열 필수는 6개이고, 설 | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:389 ; Doc/verify/_parallel/E03/facts/DMF0042.json: | Doc/e2e/specs/eg_auth.spec.ts의 listHas가 빈 DIVISION_ID를 전 Division으로 처리해서 어느 Division에도 속하지 않는 컬럼을 기대 필수 집합에 넣습니다. |
| EG-629a8042 | E3 | 판정필요 | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | [대표 EG-099823bb 와 같은 증거] 설정 창에 없다고 기록된 Biz.Type*(BIZ_TYPE_NAME81)와 Project*(PROJECT_NAME)는 DIVISION_ID가 비어 있습니다. AS-IS SP는 DIVISION_ID 목록에 해당 Division이 있는 컬럼만 내므로 이 두 컬럼은 AS-IS에서도 Div 81과 81_HD·81_HG·81_HM·81_ST·81_UC에서 나오지 않습니다. 두 컬럼을 빼면 Div 81 계열 필수는 6개이고, 설 | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:389 ; Doc/verify/_parallel/E03/facts/DMF0042.json: | Doc/e2e/specs/eg_auth.spec.ts의 listHas가 빈 DIVISION_ID를 전 Division으로 처리해서 어느 Division에도 속하지 않는 컬럼을 기대 필수 집합에 넣습니다. |
| EG-d8f39d88 | E3 | 판정필요 | 검사기오판 | PASS | Y | N AS-IS 원문 인용 또는 등록 룰 번호 없음 | Div 82 설정 창에 없다고 기록된 Biz.Type*(BIZ_TYPE_NAME81)와 Project*(PROJECT_NAME)는 DIVISION_ID가 비어 있어 AS-IS SP에서도 Div 82 그리드에 나오지 않습니다. 두 컬럼을 빼면 Div 82 필수는 Division·Team·Currency 3개이고, 설정 창 필수 표시 3개와 일치합니다. | Doc/verify/_parallel/E03/facts/DMF0042.json:1675 ; Doc/verify/_parallel/E03/facts/DMF0042.json:2227 ; Doc/e2e/specs/eg_a | Doc/e2e/specs/eg_auth.spec.ts의 listHas가 빈 DIVISION_ID를 전 Division으로 처리해서 Div 82 기대 필수를 5개로 잘못 셉니다. |
| EG-6a4db8e3 | J3 | ERROR | 검토 제외 |  | N | N 재측정 대상(데이터전제·엔진) — AI 판정 대상 아님 |  |  |  |
| EG-e0a2b69b | J3 | ERROR | 검토 제외 |  | N | N 재측정 대상(데이터전제·엔진) — AI 판정 대상 아님 |  |  |  |
| EG-03099a1d | J3 | ERROR | 검토 제외 |  | N | N 재측정 대상(데이터전제·엔진) — AI 판정 대상 아님 |  |  |  |
| EG-8839e012 | J3 | ERROR | 검토 제외 |  | N | N 재측정 대상(데이터전제·엔진) — AI 판정 대상 아님 |  |  |  |
| EG-4291c650 | J3 | ERROR | 검토 제외 |  | N | N 재측정 대상(데이터전제·엔진) — AI 판정 대상 아님 |  |  |  |
| EG-bb7a5e0c | J3 | ERROR | 검토 제외 |  | N | N 재측정 대상(데이터전제·엔진) — AI 판정 대상 아님 |  |  |  |
| EG-e67fc52a | A6 | 판정필요 | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | [대표 EG-90ed2f8e 와 같은 증거] 기대값 ORDER BY SORT_ORDER_NO 는 컬럼셋팅 팝업 목록 정렬(DMF0002_GET_TITLESET_POPUP)인데 검사기는 메인 그리드 행 30건에 적용했다. AS-IS 메인 조회는 그리드 컬럼 순서(@GroupList)로 정렬하고 SORT_ORDER_NO 는 MEASURE 바로 앞 안쪽 키라서 AS-IS 에서도 30행 전체로는 오름차순이 아니다. 실측 10,40,50,70 은 조합 안 Measure  | Doc/_legacy_source/DB_DDL/AsIs_LGCE_SCMDEV_SP1_DDL.sql:22721 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF004 | Doc/e2e/specs/eg_auth.spec.ts: EG032 가 sort_rules.csv 의 팝업 SP 정렬 사실을 그리드 행 키로 골라 썼고, 메인 SP 의 동적 @GroupList 정렬(SORT_ORDER_NO 는 안쪽 키)을 반영하지 않았다. |
| EG-90ed2f8e | A6 | 판정필요 | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | 기대값 ORDER BY SORT_ORDER_NO 는 컬럼셋팅 팝업 목록 정렬(DMF0002_GET_TITLESET_POPUP)인데 검사기는 메인 그리드 행 30건에 적용했다. AS-IS 메인 조회는 그리드 컬럼 순서(@GroupList)로 정렬하고 SORT_ORDER_NO 는 MEASURE 바로 앞 안쪽 키라서 AS-IS 에서도 30행 전체로는 오름차순이 아니다. 실측 10,40,50,70 은 조합 안 Measure 순번으로 AS-IS 정렬과 맞는다. | Doc/_legacy_source/DB_DDL/AsIs_LGCE_SCMDEV_SP1_DDL.sql:22721 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF004 | Doc/e2e/specs/eg_auth.spec.ts: EG032 가 sort_rules.csv 의 팝업 SP 정렬 사실을 그리드 행 키로 골라 썼고, 메인 SP 의 동적 @GroupList 정렬(SORT_ORDER_NO 는 안쪽 키)을 반영하지 않았다. |
| EG-32183477 | A1 | ERROR | 검토 제외 |  | N | N 재측정 대상(계정·사람) — AI 판정 대상 아님 |  |  |  |
| EG-91cc4cbd | A1 | 판정필요 | TOBE룰 | NA | Y | Y AS-IS 원문 인용 확인 | Biz Plan 조회 행 수가 AS-IS 7,564행, TO-BE 96행으로 다르지만 불일치 컬럼은 0개이고 AS-IS 전용 키와 TO-BE 전용 키도 0건입니다. 대응되지 않은 인자 p_created_by와 p_userinfo는 AS-IS SP에서 팀(@v_dept_id)과 ADMIN 그룹(@v_group_id)을 정하는 데만 쓰이고 EDIT_FLAG 값에만 들어가므로, 행을 거르지 않아 행 수 차이의 원인이 아닙니다. CR-105에 따라 행 수와 키 집합 차 | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:814 |  |
| EG-a58497bd | MS1 | 판정필요 | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | AS-IS btnReplace_Click 은 조회 행이 0건이면 등록 코드 없이 고정 한글 '데이터 조회 후 다시 시도해 주시기 바랍니다.'를 띄웁니다. TO-BE Replace 도 같은 조건에서 같은 문구를 그대로 띄우므로 동작이 같습니다. AS-IS 에도 다국어 코드가 없던 문구라 결함으로 볼 수 없습니다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:3496 ; nscm-fe/features/demand/src/pages/business- | tools/Harness/verify/i18n_static.py: AS-IS MessageBox.Show 고정 문구와 글자가 같은 TO-BE 고정 문구를 AS-IS 대조 없이 미등록 문구로 기록했습니다. |
| EG-1ac6e593 | MS1 | 판정필요 | 실결함 | FAIL | Y | Y AS-IS 원문 인용 확인 | AS-IS Exchange Rate 창 Delete 는 선택 행이 없으면 안내 없이 돌아갑니다(DeleteButton 293~297행). TO-BE 는 등록 MSG 코드 없이 고정 한글 '삭제할 행을 선택해 주세요.'를 띄워 언어 설정과 상관없이 한글로 나옵니다. 코드 주석의 사용자 지정 문구라는 메모는 tobe_rule_registry 에 등록된 룰이 아니므로 CR-008 에 따라 MSG 코드로 등록해야 합니다. | nscm-fe/features/demand/src/pages/business-plan/components/modals/ExchangeRateModal.tsx:625 ; GSCM/06.UIL/GSCM.DM.Plan.U |  |
| EG-07d04d5c | MS1 | 판정필요 | 실결함 | FAIL | Y | Y AS-IS 원문 인용 확인 | Exchange Rate 창 Save 의 키 중복 안내가 등록 MSG 코드 없이 한글 문구 '중복된 데이터가 있습니다'로 고정되어 영어·중국어 사용자에게도 한글로 나옵니다. AS-IS DMF0042_ExchangeRatePopup.cs 에는 화면 중복 검사 문구가 없고 안내는 모두 MessageHelper.GMessageBox 등록 코드로 냅니다. 같은 뜻의 MSG00428 이 TO-BE 에 등록되어 있으므로 CR-008·CR-032 에 따라 등록 코드로 바꿔야 | nscm-fe/features/demand/src/pages/business-plan/components/modals/ExchangeRateModal.tsx:666 ; GSCM/06.UIL/GSCM.DM.Plan.U |  |
| EG-15178a36 | MS1 | 판정필요 | 실결함 | FAIL | Y | Y AS-IS 원문 인용 확인 | AS-IS Replace by Cutoff 완료 안내는 등록 코드 MSG00401 「{0}건의 데이터가 대체되었습니다.」에 건수를 넣어 보여 줍니다. TO-BE 는 MSG00002 뒤에 고정 한글 '(N건)'을 붙여 영어·중국어 화면에도 '건'이 그대로 나옵니다. 이 용도로 등록된 MSG00401(KO·EN·CN)을 business-plan 폴더에서 Grep 했으나 쓰는 곳이 없었습니다. | GSCM/06.UIL/GSCM.DM.Plan.UIL/POPUP/ReplaceByCutOffPopUp.cs:511 ; nscm-fe/features/demand/src/pages/business-plan/compone |  |
| EG-b85baf0f | MS1 | 판정필요 | 검사기오판 | NA | Y | Y AS-IS 원문 인용 확인 | '[DMF0042] Ver. Cutoff 실패:'는 개발자 콘솔에만 남는 기록이고 화면에는 나오지 않습니다. 사용자는 다음 줄 알림창에서 프로시저가 돌려준 문구만 봅니다. AS-IS도 Ver. Cutoff를 VersionCutOffPopUp 창에서 처리하며 이 문구는 없어, 메시지 코드로 등록할 화면 문구가 아닙니다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:2915 ; nscm-fe/features/demand/src/pages/business- | tools/Harness/verify/eg_ingest.py의 '화면 고정 한글' 수집이 console.error·console.log 인자 문자열까지 화면 문구로 셉니다. 콘솔 출력 인자는 제외해야 합니다. |
| EG-7fe24589 | MS1 | 판정필요 | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | Save 필수값 안내는 등록 코드 MSG00429(KO·EN·CN 등록)를 t() 로 불러 쓰고, 한글은 코드가 없을 때만 쓰는 기본 문구입니다. 덧붙인 '(행 번호)'에는 한글이 없습니다. AS-IS 도 필수값 결손을 등록 코드(MSG00310)로 안내하므로 등록 코드 사용이라는 점에서 같습니다. | nscm-fe/features/demand/src/pages/business-plan/utils/business-plan.validate.ts:93 ; nscm-fe/features/demand/src/pages/b | tools/Harness/verify/i18n_static.py: t(코드, '기본 문구') 의 둘째 인자를 고정 한글로 잡아 등록 코드 사용을 미등록 문구로 기록했습니다. |
| EG-b0993fb1 | MS1 | 판정필요 | 확인불가 | 판정필요 | Y | N 판정 같음 | AS-IS Replace 프로시저 DMF0042_SAVE_DM_PLN_BP_REPLACE_BY_CUTOFF에는 이 문구도, 빈 버전을 막는 검사도 없습니다. TO-BE 운영 본문에서는 2026-08-27에 추가한 검사가 이 한글 문구를 O_RC1로 돌려주고, 화면은 이 문구를 그대로 알림창에 띄웁니다. To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.sql에는 이 검사가 없어 원장 파일과 운영 본문이 다르고, 프로 | _artifacts/_apply_corporate/CELLPROD_SLASH_20261027/sources/PKG_DMF0042.PACKAGE_BODY.sql:1491 ; _artifacts/_apply_corpor | 검사기는 RAISE와 MSG 변수만 출력 경로로 보고 OPEN O_RC1 FOR SELECT v_log_message 반환을 찾지 못했습니다(tools/Harness/verify/eg_ingest.py:257에서 판정필요로 남김). 또 To-be_v2_converted 파일이 아닌 운영 |
| EG-771f1a11 | MS1 | 판정필요 | 확인불가 | 판정필요 | Y | N 판정 같음 | 이 한글 문구는 지정된 원문 To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.sql 의 P_DMF0042_SAVE_DM_PLN_BP_FCST 에는 없고, _artifacts 쪽 패키지 사본에만 있습니다. 그 사본에서 문구는 O_RESULT_CURSOR 의 EVENT 열로 CODE -1 과 함께 나가며, 화면 Save 오류 안내가 MSG 와 EVENT 중 어느 열을 보여 주는지는 공용 응답 처리에 달려 있어 원문으로 | _artifacts/_apply_corporate/CELLPROD_SLASH_20261027/sources/PKG_DMF0042.PACKAGE_BODY.sql:4018 ; _artifacts/_apply_corpor | tools/Harness/verify/i18n_static.py: O_RESULT_CURSOR EVENT 열로 나가는 경로를 메시지 출력 경로로 인식하지 못하고, 검사한 패키지 원천이 To-be_v2_converted 사본과 달라 판정을 내리지 못했습니다. |
| EG-f3660adc | MS1 | 판정필요 | 실결함 | FAIL | Y | Y AS-IS 원문 인용 확인 | AS-IS Exchange Rate 저장은 Division이 SCM_MST_DIVISION에 없으면 'Division 값이 존재하지 않습니다.'를 결과로 돌려주고, 팝업이 Error! 창으로 보여준 뒤 멈춥니다. TO-BE는 같은 경우 반영을 건너뛰지만, ERR_RTN에서 V_LOG_TYPE을 END로 덮어 이 문구를 V_DESCRIPTION에만 넣습니다. 결과 커서는 항상 CODE '0'과 SUCCESS를 돌려주므로 화면은 저장 성공으로 처리합니다. | GSCM/06.UIL/GSCM.DM.Plan.UIL/POPUP/DMF0042_ExchangeRatePopup.cs:560 ; GSCM/06.UIL/GSCM.DM.Plan.UIL/POPUP/DMF0042_Exchang |  |
| EG-64a74e96 | B5 | FAIL | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | AS-IS 는 InitSpread 에서 CELL_PROD_SITE 컬럼 전체 콤보를 PARAM1 'ALL' 로 채운다. 프로시저는 'ALL' 이면 VALID_YN 으로 거르지 않으므로 기존행에도 비활성 코드 A05, Z01 이 후보에 나온다. 유효건(Y)만 쓰는 콤보는 InsertRow 1277행의 신규행 전용이고, TO-BE 도 신규행에만 유효건 콤보를 쓰고 기존행은 ALL 표시 콤보를 쓰므로 AS-IS 와 같다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:395 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_B | tools/Harness/verify/lookup_check.py 가 신규행 규칙(InsertRow 1277행, 유효건만)을 기존행 대상에 적용했다. 기존행 기대값은 InitSpread 395행의 ALL 콤보로 잡아야 한다. |
| EG-5e2d5c94 | B4 | FAIL | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | TO-BE 조회조건 Sales Site(SiteByEndCustomer)는 화면이 validYn 을 넘기지 않아 VALID_YN 조건이 빠지고 비활성 Site 도 후보에 들어간다(1211건 중 비활성 48건 표시). 원문 조회조건은 선택 Division 과 SSPM PROJECT_CODE 결합 범위 안의 Site 만 낸다. 검사기는 그 범위를 무시하고 SCM_MST_SITE 전체 비활성 349건을 기대값으로 써서 범위 밖 301건을 누락으로 셌다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:312 ; Doc/_legacy_source/DB_DDL/AsIs_LGCE_SCMDEV_S | tools/Harness/verify/active_policy.py master_sets 가 비활성 기대 집합을 마스터 테이블 등호 조건만으로 만들고 콤보 SQL 의 Division·SSPM 결합·권한 범위를 적용하지 않는다. |
| EG-5b7ed08d | B4 | FAIL | 검사기오판 | NA | Y | Y AS-IS 원문 인용 확인 | AS-IS 기존행은 Edit 시 0번 칸부터 MEASURE 칸까지 모두 잠근다. MEASURE 뒤 칸은 모두 연·월 동적 칸이므로 End Customer 칸도 잠김 범위에 든다. TO-BE 도 기존행 정적 칸을 전부 잠가 End Customer 콤보가 열리지 않는다. 검사기가 본 비활성 29건은 기존 값의 이름을 보여 주는 표시용 목록이라 선택 후보 검사 대상이 아니다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:649 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_B | tools/E2E 의 B4 Active 정책 측정이 잠긴 기존행 칸의 표시용 목록(DataMap)을 선택 후보로 읽었으므로, 편집 가능 여부를 먼저 확인하고 열리는 칸만 재야 한다. |
| EG-e7780a9a | I2 | ERROR | 검토 제외 |  | N | N 재측정 대상(데이터전제·엔진) — AI 판정 대상 아님 |  |  |  |
| EG-aeeaa532 | I2 | ERROR | 검토 제외 |  | N | N 재측정 대상(데이터전제·엔진) — AI 판정 대상 아님 |  |  |  |
| EG-dafc4d83 | C1 | 판정필요 | 확인불가 | 판정필요 | Y | N 판정 같음 | Div 81의 End Customer 후보 원천은 AS-IS 283행의 UserEndCustomerByDivisionDept입니다. TO-BE도 Div 40이 아니면 endCustomerByDept 콤보를 써서 분기는 같습니다. TO-BE 표시값 5건(LGESDJ, OM 등)을 코드로 바꾸지 못해 TO-BE 237건과 AS-IS 174건의 집합 비교가 끝나지 않았습니다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:278 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_B | tools/E2E 의 cascade 비교가 TO-BE End Customer 표시값을 AS-IS 코드로 바꾸지 못한 5건 때문에 집합 비교를 멈췄다. |
| EG-23df32c4 | C1 | 판정필요 | 확인불가 | 판정필요 | Y | N 판정 같음 | Div 81의 Sales Site 후보 원천은 AS-IS 312행과 1584행의 UserSiteByEndCustomer입니다. 검사기는 Div 40 분기에서만 쓰는 SiteByEndCustomer40(1591행)을 기대값으로 썼습니다. TO-BE 표시값 82건을 코드로 바꾸지 못해 TO-BE 539건과 AS-IS 453건의 일치 여부는 측정되지 않았습니다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:312 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_B | tools/AsisFacts 의 combo_src 추출이 clbSalesSite 313행 원천에 Div 40 분기 대입(1591·1607)을 섞어 넣었고, tools/E2E 의 cascade 비교가 Sales Site 표시명을 코드로 바꾸지 못해 집합 비교를 하지 못했다. |
| EG-dbb4d0b8 | B7 | 판정필요 | 확인불가 | 판정필요 | Y | N 판정 같음 | [대표 EG-769bc6cb 와 같은 증거] SiteByEndCustomer 콤보는 AS-IS 312행에서 쓰는 대상이라 NA 로 볼 수 없다. 같은 요청에 BE 는 2555건을 돌려줬지만, 검사기가 SQL 원문을 다시 실행하다가 ORA-00911 로 실패해 비교값이 없다. 미치환 키가 없는 요청(divisionId '')도 같은 오류가 나므로 검사기 쪽 재실행 문제다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:312 ; tools/Harness/verify/combo_live_check.py:126 | tools/Harness/verify/combo_live_check.py 의 subst 가 @이름만 바꾼다. BE 가 SCM_ADM_CMBO_SQL_M 원문을 실행 전에 바꾸는 부분을 재현하지 못해, Oracle 이 받지 않는 문자가 남아 ORA-00911 이 난다. |
| EG-a6431ea6 | B7 | 판정필요 | 확인불가 | 판정필요 | Y | N 판정 같음 | Division 40, End Customer ALL 요청에 BE 는 1211건을 돌려줬지만 검사기의 SQL 재실행이 ORA-00911 로 실패했다. 콤보 자체는 AS-IS 312행에서 쓰므로 대상이 없는 행이 아니다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:312 ; tools/Harness/verify/combo_live_check.py:126 | tools/Harness/verify/combo_live_check.py 의 subst 가 BE 의 SQL 전처리를 재현하지 못해 ORA-00911 이 난다. validYn 같은 미전달 키도 BE 와 같은 기본값으로 바꿔야 한다. |
| EG-8dcc9288 | B7 | 판정필요 | 확인불가 | 판정필요 | Y | N 판정 같음 | SiteByEndCustomer 콤보는 AS-IS 312행에서 쓰는 대상이다. BE 응답은 2555건인데 검사기의 SQL 재실행이 ORA-00911 로 실패해 비교하지 못했다. divisionId 미치환과 무관하게 divisionId 를 준 요청도 같은 오류가 난다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:312 ; tools/Harness/verify/combo_live_check.py:126 | tools/Harness/verify/combo_live_check.py 의 subst 가 BE 의 SQL 전처리를 재현하지 못해 ORA-00911 이 나고, 요청 본문에 없는 divisionId 는 빈 문자열로 바꾼다. |
| EG-769bc6cb | B7 | 판정필요 | 확인불가 | 판정필요 | Y | N 판정 같음 | SiteByEndCustomer 콤보는 AS-IS 312행에서 쓰는 대상이라 NA 로 볼 수 없다. 같은 요청에 BE 는 2555건을 돌려줬지만, 검사기가 SQL 원문을 다시 실행하다가 ORA-00911 로 실패해 비교값이 없다. 미치환 키가 없는 요청(divisionId '')도 같은 오류가 나므로 검사기 쪽 재실행 문제다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:312 ; tools/Harness/verify/combo_live_check.py:126 | tools/Harness/verify/combo_live_check.py 의 subst 가 @이름만 바꾼다. BE 가 SCM_ADM_CMBO_SQL_M 원문을 실행 전에 바꾸는 부분을 재현하지 못해, Oracle 이 받지 않는 문자가 남아 ORA-00911 이 난다. |
| EG-96372674 | B7 | 판정필요 | 확인불가 | 판정필요 | Y | N 판정 같음 | [대표 EG-769bc6cb 와 같은 증거] SiteByEndCustomer 콤보는 AS-IS 312행에서 쓰는 대상이라 NA 로 볼 수 없다. 같은 요청에 BE 는 2555건을 돌려줬지만, 검사기가 SQL 원문을 다시 실행하다가 ORA-00911 로 실패해 비교값이 없다. 미치환 키가 없는 요청(divisionId '')도 같은 오류가 나므로 검사기 쪽 재실행 문제다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:312 ; tools/Harness/verify/combo_live_check.py:126 | tools/Harness/verify/combo_live_check.py 의 subst 가 @이름만 바꾼다. BE 가 SCM_ADM_CMBO_SQL_M 원문을 실행 전에 바꾸는 부분을 재현하지 못해, Oracle 이 받지 않는 문자가 남아 ORA-00911 이 난다. |
| EG-9171e2b2 | N1 | 판정필요 | 데이터차이 | 판정필요 | Y | N 판정 같음 | SCM_MST_CITY의 AS-IS 키(COUNTRY/CITY) 89435건 가운데 9건이 TO-BE에 없습니다. 빠진 키는 AA/AATES, AB/ABTES처럼 시험용으로 보이는 코드입니다. 화면 로직 차이가 아니라 기준표 이관 데이터 차이이므로, 이 9건을 일부러 빼고 이관했는지 확인이 필요합니다. | Doc/_legacy_source/DB_DDL/AsIs_LGCE_SCMDEV_Table_DDL.sql:28775 ; Doc/_legacy_source/DB_DDL/AsIs_LGCE_SCMDEV_Table_DDL.sq |  |
| EG-2af5af6c | N1 | 판정필요 | 데이터차이 | 판정필요 | Y | N 판정 같음 | SCM_MST_PROJECT의 AS-IS 키 8468건 가운데 9건이 TO-BE에 없습니다. 빠진 키는 모두 A21JR2003/0000000001 프로젝트의 Division 81 계열(81, 81_HD, 81_HG, 81_HM, 81_ST 등) 행입니다. 화면 로직이 아니라 기준표 이관 건수가 다른 것이므로, 이 9건을 일부러 빼고 이관했는지 데이터 담당자가 확인해야 합니다. | Doc/_legacy_source/DB_DDL/AsIs_LGCE_SCMDEV_Table_DDL.sql:31051 ; Doc/_legacy_source/DB_DDL/AsIs_LGCE_SCMDEV_Table_DDL.sq |  |
| EG-d04f6031 | N1 | 판정필요 | 검사기오판 | NA | Y | Y AS-IS 원문 인용 확인 | AS-IS DMF0042는 Column 설정과 Measure 설정 팝업에서 SCM_MST_TITLESET_USER를 PROGRAM_ID 'DMF0042'로만 읽고 씁니다. 검사기가 없다고 적은 3건은 PROGRAM_ID가 DMF0035(MKT FCST WATERFALL)인 다른 화면의 개인화 행이므로 이 화면의 비교 대상이 아닙니다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:2872 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_ | tools/Harness/verify의 N1 기준정보 범위 산정이 화면 PKG의 조건 값을 잘못 골라 PROGRAM_ID를 DMF0042가 아닌 DMF0035로 잡았습니다(T11). |
| EG-8cc542a3 | F1 | 판정필요 | 검사기오판 | PASS | Y | N AS-IS 원문 인용 또는 등록 룰 번호 없음 | AS-IS DMF0042_SAVE_DM_PLN_BP_FCST 에서 없다고 기록된 조건 값 8개(Business_Plan, LOC, CAR_QTY, MKT_FCST, 81, KRW, USD, SalesAmt_LOC)는 TO-BE PKG_DMF0042.P_DMF0042_SAVE_DM_PLN_BP_FCST 본문에 모두 있습니다(2357, 2416, 2659, 2867, 2871, 2905행). 검사기는 저장 PROC 본문의 리터럴을 비교 대상에 담지 못해 2건만 찾았 | To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.sql:2416 ; To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.s | tools/Harness/verify/sp_branch_check.py 가 사내 DB ALL_SOURCE 에서 꺼낸 P_DMF0042_SAVE_DM_PLN_BP_FCST 본문(proc_body)이 비어 있어도 '없음'으로 기록하므로, 본문을 못 꺼낸 경우는 측정 실패로 남겨야 합니다. |
| EG-ae43a4e3 | F1 | 판정필요 | 검사기오판 | PASS | Y | N AS-IS 원문 인용 또는 등록 룰 번호 없음 | AS-IS DMF0042_SAVE_DM_PLN_BP_FCST_PRICE_CONV 의 조건 값 6개(CALL, Business_Plan, MKT_FCST, LOC, KRW, USD)는 TO-BE P_DMF0042_SAVE_DM_PLN_BP_FCST_PRICE_CONV 본문에 모두 있습니다(3655, 3685, 3622, 3974, 3980행). 저장 PROC 는 2671행에서 이 프로시저를 'CALL' 로 부릅니다. 검사기가 상위 저장 PROC 본문을 읽지 못해  | To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.sql:2671 ; To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.s | tools/Harness/verify/sp_branch_check.py 는 저장 PROC 본문이 빈 값이면 RX_CALL 하위 호출을 따라가지 못하므로, PRICE_CONV 리터럴이 0건이 되는 경우를 측정 실패로 구분해야 합니다. |
| EG-76970384 | F4 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 EG-26a143de 를 검토) |  |  |  |
| EG-26a143de | F4 | 판정필요 | 검사기오판 | PASS | Y | N AS-IS 원문 인용 또는 등록 룰 번호 없음 | P_DMF0042_SAVE_DM_PLN_BP_FCST 의 SELECT INTO V_LOG_MESSAGE 3곳(파일 2694·2719·2745행)은 모두 바로 앞에서 같은 조건으로 COUNT 를 세고, 건수가 0보다 클 때만 실행됩니다. 그래서 대상 행이 없어 ORA-01403 이 나는 경로가 없습니다. AS-IS DMF0042_SAVE_DM_PLN_BP_FCST 도 같은 자리에서 IF EXISTS 로 막은 뒤 TOP 1 로 메시지를 만듭니다. | To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.sql:2691 ; To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.s | tools/Harness/verify/db_ref_check.py: SELECT INTO 앞의 COUNT 가드(IF V_CNT > 0)를 빈 결과 처리로 인정하지 않아, 실행 불가 경로를 ORA-01403 위험으로 기록합니다. |
| EG-c3426286 | G1 | 판정필요 | 검사기오판 | PASS | Y | N AS-IS 원문 인용 또는 등록 룰 번호 없음 | PKG_DMF0042 의 품목 임시 적재에서 ITEM_ID·NICK_NAME 을 가드 없이 LIKE 로 비교하는 구문은 AS-IS SP DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA 에 같은 형태로 있다. 그래서 NULL 칸 행이 빠지는 동작도 AS-IS 와 같다. 검사기가 적은 1978·1979행도 변환본 파일 줄과 맞지 않고, 실제 위치는 5140·5141행이다. | To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.sql:5139 ; To-be_v2_converted/06_Packages/04_Package_PKG_DMF0042.s | tools/Harness/verify/db_ref_check.py 가 TO-BE 패키지의 가드 없는 LIKE 를 AS-IS SP 원문과 맞대어 보지 않고 확인 대상으로 남긴다. |
| ES-74b8b569 | F1 | FAIL | 확인불가 | FAIL | Y | N 판정 같음 | cleanup_spec 에서 DMF0042 가 mode=editonly 로 지정되어 마커 행 저장 시험을 하지 않았습니다(saveCalls=0). 그런데도 mode=insert 판정이 그대로 적용되어 '허용 계정 마커 행 저장'과 '재조회 후 신규 행 존재'가 FAIL 로 기록됐습니다. 남은 실패인 k0101 계정 Division 40 의 '조회 결과 DIVISION 값 = 선택 Division'은 원문만으로 가릴 수 없어 화면을 띄워 확인해야 합니다. | tools/E2E/lib/crud.ts:300 ; tools/E2E/gen-e2e.js:518 ; tools/E2E/gen-e2e.js:505 | tools/E2E/gen-e2e.js 518행은 crudCycle 이 editonly 로 저장 시험을 보류해도 mode=insert 로 saved·found 를 단언하므로, 보류한 경우는 미측정으로 넘겨야 합니다. |
| ES-cc1f107e | F1 | ERROR | 검토 제외 |  | N | N 재측정 대상(저장보류·사람) — AI 판정 대상 아님 |  |  |  |
| ES-ff7ead86 | G4 | 판정필요 | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | 누락으로 잡힌 라벨 2개 중 Closed 는 AS-IS InitControls 에서 레이아웃 항목을 Never 로 숨겨 화면에 나오지 않습니다. 다른 하나인 '.' 는 Qty 체크박스 레이아웃 항목의 라벨인데 TextVisible=false 라 AS-IS 에서도 표시되지 않습니다. 나머지 13개 라벨은 일치하므로 조회조건 라벨은 AS-IS 와 같습니다. | GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs:335 ; GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_B | tools/Harness/verify/e2e_suite_ingest.py: 기대 라벨 목록에 Visibility.Never 로 숨긴 항목과 TextVisible=false 인 레이아웃 라벨을 빼지 않고 넣었습니다. |
