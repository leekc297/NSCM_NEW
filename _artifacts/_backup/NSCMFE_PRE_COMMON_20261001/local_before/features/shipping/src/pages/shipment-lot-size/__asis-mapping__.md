# SCP0028 Shipment Lot Size — AS-IS ↔ TO-BE 매핑 매트릭스

AS-IS: `GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0028_Shipment_Lot_Size/SCP0028_Shipment_Lot_Size.cs`(+`.Designer.cs`)
TO-BE: `nscm-fe/features/shipping/src/pages/shipment-lot-size/` (domain SSP, convert-react 신규 전환)
설계 근거: `.atlas/gscm-design/SCP0028/design/00~03`. DB 실측: `ora.py` 2026-09-26.

## 1. 조회조건 콤보 (design 02, cs:127~171)

| AS-IS (.cs) | TO-BE | 콤보 SQL_ID | 비고 |
|---|---|---|---|
| cboDivision `Data_SCP.Common(Type.Division)` + GetDivisionWithoutEE (cs:40,134) | `ShipmentLotSizeForm` Division select | `Division_SCP` + FE `ATTRIBUTE3<>'EE'` 클라필터 | EE 제외 CMBO WHERE 없음 → FE 재현(SCP0006) |
| cboOperationGroup `LookupCommon("OPERATION_GROUP")` (cs:137) | Operation Group select(+ALL) | `LookupCommon(@lookupType=OPERATION_GROUP)` | P/A/E, division 무관 정적(cascade 아님) |
| cboValid `DataBind(Type.YesOrNo,true)` (cs:135) | Valid select(+ALL) | `YesOrNo` | ALL→SP null |
| clbTransMode `LookupCommon("TRANSPORT_MODE_CODE")` (cs:44,140) | Trans Mode multi(+ALL) | `LookupCommon(@lookupType=TRANSPORT_MODE_CODE)` | extraConditions 분리(7필드>6) |
| clbFromSite `FromSiteByDivision` (cs:166) | From Site multi(+ALL) | `FromSiteByDivision(@divisionId)` | cascade 하위, SITE_TYPE='PLANT' |
| clbToSite `ToSiteByDivision` (cs:169) | To Site multi(+ALL) | `ToSiteByDivision(@divisionId)` | cascade 하위, SITE_TYPE 무필터 |
| txtItemId + btnItemId `SCM0002_ItembyDivisionPopup` (cs:238~257) | Model 텍스트 + Item 팝업 | 공용 `ItemByDivisionModal` | preSearchParams={divisionId} |
| `SetChangedControl` cascade (cs:158~171) | Division 변경 → From/To Site 재조회(divisionId 키) + reset | — | Operation Group 재조회 주석처리(cs:162) 반영(비cascade) |

## 2. 그리드 18컬럼 / 편집·병합·파생 (design 03, cs:187~773)

| AS-IS (.cs / gridSignals) | TO-BE | 근거 |
|---|---|---|
| Query(ds) FindData (cs:368) | `useTabProcQuery` o_rc1 바인딩 | GET SP IN 7 / OUT o_rc1(데이터, PROC_M SORT_ORD 100) |
| SwitchLock (cs:232, gridSignals#4) | **미이식(NSCM 상시편집 표준)** — Edit 토글 state 없음. 편집권한 `canEdit=hasButton('EDIT')` 로드 1회 판정 | iter-2 G1 — memory editbutton-toggle-not-ported / ssp0025-no-edit-toggle-always-editable |
| LockColumn(DIV..TRANS,234)/(audit,235)/(0..max,369) | `canEdit && isLotSizeCellEditable(binding)` beginningEdit cancel | hook #130 — 상수배열 이식 대신 편집 화이트리스트 4컬럼 + 권한 게이트 |
| 편집 4컬럼 LOT_SIZE/INCREMENT/VALID_YN/SPLIT_YN | INPUT_TP_CD='M'(05_register BLOCK 2) + beginningEdit 게이팅 | design 03 §6 B1 |
| SetReNumerCellType(LOT_SIZE/INCREMENT,0) (cs:187,188) | 컬럼 메타 FPNumber + horzAlgnCd='R' + derive 정수 | 정수 셀 |
| SetValue(INCREMENT=LOT_SIZE) (cs:735, gridSignals#16) | `computeIncrementSync` cellEditEnded(LOT_SIZE) | R/§3-16 auto-sync |
| SetValue/BGColor 기본값 회귀 CRUD 해제 (cs:594,595, #13/#14) | `isDefaultRevertRow` — handleSave 에서 M 제외 | §3-13 |
| SmartColMerge (cs:371,438,721, #9/#12/#15) | `CustomMergeManager` allowMerging Cells, MERGE_COLUMNS 6 | §3-9 세로병합, 신규행 'I' 제외 |
| Delete() 신규행만 (cs:213~224, #3) | (아래 §3 버튼 consolidation 참조) | R4 |
| checkValidSize LOT<INC / 0값 (cs:762~773) | `useShipmentLotSizeValidation` | §4.3 저장검증 |
| checkRequiredOfSpread | `useSaveWithValidation`(메타 INPUT_TP_CD='M') | convert-core §2.4 |

## 3. 버튼/이벤트 (design 01 §2, cs:200~314) — iter-2 AS-IS 어포던스 파리티 복원

DB 버튼메타 실측(2026-09-26): main SEARCH/EDIT/SAVE/INSERT/DELETE + popup SEARCH. iter-1 consolidation(INSERT/
DELETE 툴바를 일괄팝업으로 용도변경)은 gap-audit G3/G4 지적 후 **AS-IS 파리티로 복원**: 툴바 Insert/Delete 는
AS-IS 동작(no-op / remove-new) 그대로, 일괄입력/삭제 팝업은 AS-IS 원배치(조회영역 커스텀 버튼)로 이동.

| AS-IS (.cs) | TO-BE | 비고 |
|---|---|---|
| FindButton (cs) | `hotkeyConfig.search` → handleSearch | 명시 Search 게이트 + Division 필수(R9) |
| EditButton SwitchLock (cs:229~236) | **미이식** — `canEdit=hasButton('EDIT')` 로드 1회 판정(상시편집) | iter-2 G1, memory editbutton-toggle-not-ported |
| SaveButton SaveData (cs:606~) | `hotkeyConfig.save` → handleSave | active_flag I/M, CLOB '^'-fold |
| **toolbar InsertButton no-op (cs:200~203, R10)** | `hotkeyConfig.insert = () => undefined` (버튼 노출+무동작) | iter-2 G4 — AS-IS 빈 구현 파리티, skill §3 NO-OP 배선 |
| **toolbar DeleteButton remove-new (cs:213~224, R4)** | `hotkeyConfig.delete → handleDelete` = `GridAction.removeRow(grid, true)` | iter-2 G3 — 신규행('I')만 제거, 기존행 툴바 삭제 불가 |
| btnInput "Input" 일괄입력 팝업 (cs:260~286, R5) | 조회영역 커스텀 버튼(SearchArea extraButtons) → 팝업 → GET_INPUT 후보(상시편집) | design 01 §1 원배치(조회 패널 버튼) |
| btnDelete "Delete" 일괄삭제 팝업 (cs:288~314, R6) | 조회영역 커스텀 버튼 → 팝업 → SAVE active_flag='D'(5키 삭제) | design 01 §1 / SAVE 'D' 5키 실측(§5) |
| btnItemId Item 팝업 (cs:238~257, R7) | `ItemByDivisionModal` | Model 조건 채움 |
| SetDivisionAuthCheck (cs:131~132, R1) | Form `noAuth` 시 조회영역 disable + 안내, handleSearch Division 필수 가드 | iter-2 G6 |

## 4. SP / 메타 (all_arguments + PROC_M 실측 2026-09-26)

| SP | IN | OUT | TO-BE 배선 |
|---|---|---|---|
| P_SCP0028_GET_SHIPMENT_LOT_SIZE | 7 (division/opGroup/from/to/trans/item/valid) | o_rc1(데이터)/O_RESULT_CURSOR | useTabProcQuery main |
| P_SCP0028_SAVE_SHIPMENT_LOT_SIZE | 13 (activeFlag..validYn CLOB, userId/debugMode) | O_RESULT_CURSOR | submitLotSizeSaveRequest '^'-fold |
| P_SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT | 6 (division/opGroup/from/to/item/userId) | o_rc1 | apiClient.post main/INSERT/call-proc |
| P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP | 6 (division/opGroup/from/to/item/actionFlag) | o_rc1 | useTabProcQuery popup |

## 5. 확인 필요 (정직 보고 — convert-core §4.3)

- **일괄삭제 저장키 계약(G5) — 실측 해소**: TO-BE PKG_SCP0028 body(ora.py, 2026-09-26) 정독으로 확정.
  POPUP O_RC1 반환 = DIVISION_ID/OPERATION_GROUP_ID/FROM_SITE/TO_SITE/ITEM_ID(+DESC/NICK). SAVE 'D' 분기 삭제키 =
  DIVISION_ID/OPERATION_GROUP/FROM_SITE/TO_SITE/ITEM_ID **5키**(TRANS_MODE_CODE 미포함). POPUP 이 5키 전건 반환 →
  삭제키 공백 없음. INPUT O_RC1 은 TRANS_MODE_CODE 반환 → 일괄입력 후보 6키 MERGE 정상. **결함 없음**.
- **MSG00099(LOT<INC) i18n(G7) — 미해소(위임)**: TO-BE SCM_ADM_MSG_M 미등재. KO/CN 번역 원천 없음(임의번역 금지)
  → 영문 fallback 유지, admin i18n 등록 위임.
- **브라우저 육안 축(사용자 확인)**: 셀 배경 yellow/병합 시각, 드롭다운 렌더, toast 노출, 조회영역 Input/Delete 버튼
  정렬·재오픈 검색조건 유지·콤마 다중검색, 권한 0건(R1) disable 시각.
