# SCP0028 AI 판정 검토 (2026-11-25 02:09:55)

- 대상 146행: 검토 20 · 검토 제외 126 · 미검토 0
- 인용 확인 20행 · 판정 반영 4행 · 엔진 보완 대상 4행 · 룰 등록 후보 1행
- 호출 3회(캐시 0) · 실패 0회 · 비용 1.9575 USD · 출처 Doc/verify/SCP0028/llm_usage.csv

| 행 | 규칙 | 지금 | 분류 | AI 판정 | 인용 | 반영 | 사유 | 근거 | 고칠 곳 |
|---|---|---|---|---|---|---|---|---|---|
| V-be29b7a4 | F5 | FAIL | 확인불가 | FAIL | Y | N 판정 같음 | T-8e194f95 와 같은 측정 결과를 쓴 행이다. Insert 무동작과 기존행 Delete 무변화는 AS-IS 와 같지만, 기존행 LOT_SIZE 편집 뒤 CRUD_TYPE 빈 값은 원문만으로 결함 여부를 가릴 수 없다. | GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0028_Shipment_Lot_Size/SCP0028_Shipment_Lot_Size.cs:221 ; GSCM/06.UIL/GSCM.SCP. |  |
| V-b685dddf | K2 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-225e806d | H4 | 판정필요 | 확인불가 | 판정필요 | Y | N 판정 같음 | AS-IS 헤더와 칸 폭은 SetSheetHeaderColumn 이 기준정보에서 읽어 오므로 화면 코드만으로는 폭을 알 수 없습니다. TO-BE 헤더 15개 중 OPERATION_GROUP_ID(글자 68px, 칸 59px)와 SPLIT_YN(글자 67px, 칸 59px) 2개가 잘립니다. 같은 경우인 SCP0016 선례(사용자 지시로 판정 필요로 이관)에 따라 칸 폭은 사용자가 판정합니다. | GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0028_Shipment_Lot_Size/SCP0028_Shipment_Lot_Size.cs:186 |  |
| V-ca2072cf | I1 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-1f64fec6 | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-4633ca25 | H11 | 판정필요 | 검사기오판 | PASS | Y | N AS-IS 진행 표시 있음(GSCM/06.UIL/GSCM.SCP.Form | AS-IS SaveData(cs:575~707)에는 ProgressForm이 없습니다. ProgressForm은 조회 FindData(cs:322), FindInput(cs:397), 일괄삭제 FindDelete(cs:464)에만 있고, 저장 요청은 FoxAsyncProxy로 진행 창 없이 보냅니다. TO-BE handleSave도 저장 중 로딩 표시가 없으므로 AS-IS와 같으며, AS-IS 저장에 진행 창이 없던 SCP0084를 사용자가 PASS로 판정한 것 | GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0028_Shipment_Lot_Size/SCP0028_Shipment_Lot_Size.cs:575 ; GSCM/06.UIL/GSCM.SCP. | tools/Harness/verify 시험 검사 CM-003이 AS-IS SaveData에 ProgressForm이 있는지 보지 않고 모든 화면에 저장 중 로딩 표시를 기대값으로 걸었습니다. |
| V-57fd6f09 | E1 | FAIL | 실결함 | FAIL | Y | N 판정 같음 | AS-IS 는 Increment 칸을 최소값 0 인 숫자 칸으로 만들어 음수가 들어가지 않는다. TO-BE 는 칸에 최소값 설정이 없고, 저장 전 검사도 Lot Size 보다 큰지와 0 인지만 본다. 그래서 Increment 에 -1 을 넣으면 그 값이 그대로 저장 요청에 실린다. | GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0028_Shipment_Lot_Size/SCP0028_Shipment_Lot_Size.cs:188 ; GSCM/01.Framework/GSC |  |
| V-b4192f37 | E1 | FAIL | 실결함 | FAIL | Y | N 판정 같음 | AS-IS 는 Lot Size 칸을 최소값 0 인 숫자 칸으로 만들어 음수가 들어가지 않는다. TO-BE 에서 Lot Size 를 -1 로 바꾸면 Increment 도 -1 로 따라 바뀌어 Lot Size 와 Increment 비교 검사와 0 검사를 모두 통과한다. 그래서 -1 이 그대로 저장 요청에 실린다. | GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0028_Shipment_Lot_Size/SCP0028_Shipment_Lot_Size.cs:187 ; GSCM/01.Framework/GSC |  |
| V-6259d313 | E1 | FAIL | 실결함 | FAIL | Y | N 판정 같음 | AS-IS Lot Size 칸은 소수 0자리, 최소 0 인 숫자 칸이다. TO-BE 는 소수와 문자 입력은 막지만 최소값 설정이 없어 -1 이 칸에 들어간다. 음수를 허용하는 TO-BE 룰은 없다. | GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0028_Shipment_Lot_Size/SCP0028_Shipment_Lot_Size.cs:187 ; GSCM/01.Framework/GSC |  |
| V-597f4433 | E1 | FAIL | 실결함 | FAIL | Y | N 판정 같음 | AS-IS Increment 칸은 소수 0자리, 최소 0 인 숫자 칸이다. TO-BE 는 소수와 문자 입력은 막지만 최소값 설정이 없어 -1 이 칸에 들어간다. 음수를 허용하는 TO-BE 룰은 없다. | GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0028_Shipment_Lot_Size/SCP0028_Shipment_Lot_Size.cs:188 ; GSCM/01.Framework/GSC |  |
| V-a89007be | G1 | FAIL | 실결함 | FAIL | Y | N 판정 같음 | AS-IS FindDelete 는 결과값이 S 가 아닐 때 MSG00284 를 띄우고 다시 조회하지 않는다. TO-BE 는 RESULT_CODE 를 보지 않고 HTTP 200 이고 code 가 0 이면 성공으로 보고 '삭제되었습니다.' 를 띄운 뒤 다시 조회한다. 이 차이를 허용하는 TO-BE 룰은 없다. | GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0028_Shipment_Lot_Size/SCP0028_Shipment_Lot_Size.cs:540 ; GSCM/06.UIL/GSCM.SCP. |  |
| V-a99ddb18 | H2 | FAIL | 실결함 | FAIL | Y | N 판정 같음 | AS-IS는 Save를 누를 때 LOT_SIZE와 INCREMENT가 비어 있고 VALID_YN이 Y, SPLIT_YN이 N인 M행을 기본값 회귀행으로 보고, 행 상태 칸의 M 표시를 지운 뒤 LockColor로 칠합니다(cs:594~595). TO-BE handleSave는 이 행을 저장 대상에서만 빼고 CRUD_TYPE은 지우지 않아서 '수정한 내용이 없습니다.' 알림 뒤에도 행 상태가 M으로 남습니다. isDefaultRevertRow는 ShipmentLo | GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0028_Shipment_Lot_Size/SCP0028_Shipment_Lot_Size.cs:594 ; GSCM/06.UIL/GSCM.SCP. |  |
| V-97b0fc4e | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-a9485a6a | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-c4a9dc2c | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-86208af2 | E4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-45ef80f7 | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-0be83995 | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-c145c351 | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-10c70824 | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-2fe30674 | H2 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-6008a294 | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-db0f51c6 | H6 | FAIL | 검토 제외 |  | N | N 스냅샷 승인 대기(snap_validate·snap_approve 경로) |  |  |  |
| AD-1a87a9b8 | A1 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-1eb9cb71 | A7 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-a87e4641 | A5 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-7abe0c89 | A6 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-31891e7c | A1 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-5079c1a8 | A7 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-e4f51c47 | A5 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-244b08bb | A6 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-4ada955f | A1 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-eca4c0ee | A7 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-2d4079e6 | A5 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-d4749e15 | A6 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-89b11727 | A1 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-9e43972e | A7 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-fcd3cf86 | A5 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-a75595d7 | A6 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-cab0d67b | A1 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-88332dd0 | A7 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-886d8c26 | A5 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-afab4d83 | A6 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-d81d48bb | A1 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-7f5c41f3 | A7 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-d7e8e8dc | A5 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-6e5cd70c | A6 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-e6233df3 | A1 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-f377f227 | A7 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-1e8379a1 | A5 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-125dcd3f | A6 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-176ef7aa | A1 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-44898b71 | A7 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-b097262d | A5 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-305c8e11 | A6 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-9ce43e53 | A1 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-51dde9b2 | A7 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-adc62326 | A5 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-f8013ee3 | A6 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-16ed9f6d | A1 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-7031951d | A7 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-0a4372ab | A5 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-36e52665 | A6 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-bd5d241e | A1 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-0d4ddf6c | A7 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-0f45ca72 | A5 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-d1ba0b6b | A6 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-6952e31a | A1 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-42fb59be | A7 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-81f9457d | A5 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-84391a07 | A6 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-2f776860 | A1 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-d8901eb3 | A7 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-f2a6cb89 | A5 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-9d1865fa | A6 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-b36657a8 | A1 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-ce275074 | A7 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-d9428c6a | A5 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-0e7943c1 | A6 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-854fc98d | A1 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-28da6f65 | A7 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-35cdafc7 | A5 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-13db7f49 | A6 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| T-ea1f18e5 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-666b17d1 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-e351edc9 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-0cc9c7d1 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-2907d478 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-023e949d | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-b3755ed5 | A1 | 판정필요 | 실결함 | FAIL | Y | Y AS-IS 원문 인용 확인 | AS-IS 의 Model 조회 팝업(btnItemId)은 SCM0002_GET_ITEM_BY_DIVISION_POPUP 으로 후보를 조회합니다. TO-BE 는 MaterialByDivisionModal(COM0013, P_SCM0002_GET_MATERIAL_BY_DIVISION)로 바꿨습니다. shipment-lot-size 폴더를 P_SCM0002_GET_ITEM_BY_DIVISION_POPUP 으로 찾았으나 주석에만 있어 후보 목록과 팝업 그리드 컬럼이 A | GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0028_Shipment_Lot_Size/SCP0028_Shipment_Lot_Size.cs:246 ; GSCM/06.UIL/GSCM.SCM. |  |
| T-2c20a3fc | A6 | ERROR | 확인불가 | ERROR | Y | N 미검증 행은 NA(대상 없음 근거)만 반영 | AS-IS 의 Item 팝업(btnItemId)은 SCM0002_GET_ITEM_BY_DIVISION_POPUP 을 호출하므로 대상이 AS-IS 에 존재합니다. TO-BE 는 사용자 지시(2026-10-08)로 MaterialByDivisionModal(COM0013)로 교체했기 때문에 이 SP 를 호출하지 않습니다. 이 팝업 교체는 TO-BE 룰 원장에 등록돼 있지 않아 사람의 판정이 필요합니다. | GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0028_Shipment_Lot_Size/SCP0028_Shipment_Lot_Size.cs:246 ; GSCM/06.UIL/GSCM.SCM. | tools/Harness/verify/sort_check.py: 대조표가 TO-BE 짝을 P_SCM0002_GET_ITEM_BY_DIVISION_POPUP 으로 잡았는데, TO-BE 화면은 이 SP 를 호출하지 않아 실행 중 호출이 0건이고 정렬을 재지 못했습니다. |
| T-fad117f6 | F4 | ERROR | 확인불가 | ERROR | Y | N 미검증 행은 NA(대상 없음 근거)만 반영 | AS-IS의 Model 조회조건 팝업은 SCM0002_ItembyDivisionPopup이고, 이 팝업이 P_SCM0002_GET_ITEM_BY_DIVISION_POPUP을 씁니다. TO-BE는 사용자 지시(2026-10-08)에 따라 MaterialByDivisionModal(COM0013, P_SCM0002_GET_MATERIAL_BY_DIVISION)로 바꿔서 이 화면에서는 이 SP를 부르지 않습니다. 이 차이는 TO-BE 룰 원장에 SCP0028 항목으로 | GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0028_Shipment_Lot_Size/SCP0028_Shipment_Lot_Size.cs:246 ; nscm-fe/features/ship | tools/E2E 의 _trace.spec W5 가 TO-BE 화면이 부르지 않는 AS-IS 팝업 SP를 호출 대상으로 기다려서 측정 경로가 생기지 않습니다(T7·T11). |
| T-59af1afb | G1 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-a690e1a4 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-7b306e42 | H2 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-c1421566 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-f4dca6bb | A6 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-98554096 | F4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-f2027c89 | H2 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-916f876d | H2 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-ec3bc4f9 | H2 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-4f008f49 | H2 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-f28a6054 | H2 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-8e194f95 | F5 | FAIL | 확인불가 | FAIL | Y | N 판정 같음 | AS-IS InsertRow 는 본문이 비어 있고 DeleteButton 은 FlagI 신규행만 지우므로 TO-BE Insert 무동작과 기존행 Delete 무변화는 AS-IS 와 같고, 검사기가 누른 Delete 는 툴바가 아니라 일괄삭제 팝업 버튼이었다(팝업 SEARCH actionFlag D 호출 기록). 남은 쟁점은 기존행 LOT_SIZE 편집 뒤 CRUD_TYPE 이 빈 값으로 측정된 점인데, TO-BE 코드상 EditTracker 가 M 을 찍게 되어 | GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0028_Shipment_Lot_Size/SCP0028_Shipment_Lot_Size.cs:571 ; GSCM/06.UIL/GSCM.SCP. |  |
| T-730ab462 | H2 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-81eb0db7 | H2 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-8c1a9dab | G1 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-871717ab | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-14732ce2 | F4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-1417e33a | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-9466f72f | G1 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-0d12e24f | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-85737798 | A1 | 판정필요 | TOBE룰 | NA | Y | Y AS-IS 원문 인용 확인 | PR_GET_MNU_BTN_AUTH 는 TO-BE 버튼 권한 SP 로, AS-IS SP 원문(Doc/_legacy_source/DB_DDL 전체)을 MNU_BTN_AUTH 로 찾았으나 없었고 AS-IS Input 버튼도 ButtonAccessType None 입니다. 대조할 AS-IS SP 가 없으며, 버튼 노출은 CR-116 에 따라 TO-BE 권한 설정을 기준으로 J2·K4 행에서 판정합니다. | GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0028_Shipment_Lot_Size/SCP0028_Shipment_Lot_Size.Designer.cs:372 ; nscm-fe/feat |  |
| T-6c69b6ac | G1 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-b31bbec5 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-3badcc5b | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-505b6f16 | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-5869ab26 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-e57376d2 | A6 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-80e70b77 | F4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-7754adb7 | G1 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-31170afd | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-e8824582 | H2 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-b5cbb882 | G1 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-6797ba6f | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-e3b75e51 | H2 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-fa46d98c | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-f7a95dc6 | F4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-c9e36f25 | G1 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-3ecb1c2d | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-e691090a | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-f658cb62 | A1 | 판정필요 | 확인불가 | 판정필요 | Y | N 판정 같음 | AS-IS 일괄입력·삭제 팝업(SCM0002_ShipmentLotSizePopup)은 Find에서 SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP을 실행하므로 비교할 대상이 있습니다. 그런데 sp_pair.csv에 SCP0028 짝이 조회·입력·저장 3건만 있고 이 팝업 SP는 빠져 있어서, 골든 비교가 실행되지 않았습니다. 비교를 하지 않았으니 지금 결과를 그대로 둡니다. | GSCM/06.UIL/GSCM.SCM.Popup.UIL/SCM0002_ShipmentLotSizePopup.cs:284 ; Doc/asisfacts/db/modules/dbo.SCM0002_GET_SHIPMENT_L | tools/Harness/verify/gen_param_map.py: 화면 폴더 밖 팝업 폼(GSCM.SCM.Popup.UIL/SCM0002_ShipmentLotSizePopup.cs)이 호출하는 SP를 sp_pair.csv 짝으로 만들지 않아서 골든 비교를 건너뛰었습니다. |
| T-c6aefa56 | A6 | 판정필요 | 확인불가 | 판정필요 | Y | N 판정 같음 | AS-IS 팝업 SP는 I 분기와 D 분기 모두 DIVISION_ID, OPERATION_GROUP_ID, from_site, TO_SITE, ITEM_ID 순으로 정렬하고, 팝업 화면은 그리드에 다시 정렬하지 않고 그대로 표시합니다. 이 SP는 sp_pair.csv에 AS-IS 짝이 없어서 정렬 대조를 하지 못했습니다. TO-BE PKG_SCP0028 본문도 To-be_v2_converted/06_Packages에서 찾지 못해 ORDER BY를 직접 대조할 수 | Doc/asisfacts/db/modules/dbo.SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP.sql:61 ; Doc/asisfacts/db/modules/dbo.SCM0002_GET_SHIPM | tools/Harness/verify/sort_check.py: sp_pair.csv에 SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP 짝이 없어서 AS-IS ORDER BY 두 분기를 TO-BE PKG ORDER BY와 대조하지 못했습니다. |
| T-c25bebfb | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-4f69770d | H2 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-0adfea94 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-4677b9e5 | E4 | FAIL | 실결함 | FAIL | Y | N 판정 같음 | AS-IS 일괄 Delete 는 저장 SP 결과 첫 값이 S 가 아니면(예외 때 F) MSG00284 오류를 띄운다. TO-BE 저장 응답에도 O_RESULT_CURSOR 의 RESULT_CODE 가 오지만(Doc/verify/SCP0028/_resume/post/f/save_diff/P_SCP0028_SAVE_SHIPMENT_LOT_SIZE__1.md:9), 화면은 HTTP 상태와 code 만 보고 RESULT_CODE 는 보지 않는다. 그래서 결과가 F 여도 | GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0028_Shipment_Lot_Size/SCP0028_Shipment_Lot_Size.cs:540 ; GSCM/06.UIL/GSCM.SCP. |  |
| T-b2cff1d9 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-2a3f808e | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-22025375 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-0891c714 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-7e1641ba | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-4cec401b | X-ROW | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| EG-2644dff3 | H6 | FAIL | 실결함 | FAIL | Y | N 판정 같음 | Model 조회조건 팝업(TO-BE MaterialByDivisionModal)은 Close 버튼을 OK 버튼보다 먼저 그리고, buttonWrapper 스타일에 순서를 뒤집는 설정이 없어 화면에서도 Close, OK 순서입니다. CR-005 는 모든 팝업 버튼 순서를 OK, CLOSE 로 정하고 있어 오류입니다. | GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0028_Shipment_Lot_Size/SCP0028_Shipment_Lot_Size.cs:246 ; nscm-fe/features/mast |  |
| EG-ac06e957 | G4 | 판정필요 | TOBE룰 | PASS | Y | Y AS-IS 원문 인용 확인 | AS-IS Model 돋보기는 ItembyDivision 팝업(조건 Model, Division, Site, Project)을 열지만, 화면은 Site 와 Project 를 빈 값으로 넘깁니다. TO-BE 는 2026-10-08 사용자 지시로 SCP 공용 Material by Division 팝업(Div, Operation Group, Material)을 쓰며, 화면 소스에 의도된 변경으로 기록되어 있습니다. 일반 규칙: SCP 화면 Model 조회조건 팝업은  | GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0028_Shipment_Lot_Size/SCP0028_Shipment_Lot_Size.cs:248 ; GSCM/06.UIL/GSCM.SCP. |  |
| EG-e15844cc | A1 | 판정필요 | TOBE룰 | NA | Y | Y AS-IS 원문 인용 확인 | AS-IS는 조회 버튼을 누르면 SCP0028_GET_SHIPMENT_LOT_SIZE를 실행합니다. 같은 인자로 돌렸을 때 AS-IS는 1940행, TO-BE는 1990행이 나왔습니다. 차이는 TO-BE에만 있는 키 50행뿐이고, AS-IS에만 있는 키는 0행, 공통 행 3030칸 가운데 값이 다른 칸은 0칸입니다. CR-105에 따라 차등 검증에서 행·키 집합 차이는 판정에서 빼고, 같은 SP의 정렬(A6)과 컬럼 18개(A7)는 원장에서 PASS입니다. | GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0028_Shipment_Lot_Size/SCP0028_Shipment_Lot_Size.cs:349 ; Doc/asisfacts/db/modu |  |
