# 작업 원장 — SCP0104 · 2026-11-17 17:27

> 검사 인스턴스 1381건 중 PASS·NA 1277건 외 **104건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 이번 범위 밖(DB_ONLY). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W3 | 동작 수정 | 82 | 재판정 PASS |
| W5 | 검사기 연결 | 3 | 원장 항목/엔진 연결 → 실행 PASS |
| W7 | 기대값 확정 | 8 | 기대 확정 → PASS/FAIL |
| W9 | 도구 오류 | 11 | 원인 해소 → 재판정 |

- 담당: 화면 FE 68 · DB 객체 13 · 하네스·환경 11 · 사람 판정 / AS-IS 원문 확인 → 재판정 8 · 하네스 3 · FE 1
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 0건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  | 24 |  |  |  | 5 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| C6 | CASCADE |  |  | 25 |  |  |  |  |  |  | 무변경 편집 종료 시 연쇄 미발동 |
| C2 | CASCADE |  |  | 20 |  |  |  |  |  |  | 그리드 셀 cascade 후보 |
| F4 | DB |  |  | 13 |  |  |  |  |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| M4 | POPUP |  |  |  |  |  |  | 2 |  | 11 | 팝업 선택값 반영 |
| B4 | COMBO |  |  |  |  | 1 |  |  |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| E5 | EDIT |  |  |  |  | 1 |  |  |  |  | 콤보 셀 후보 외 값 차단 |
| G5 | POPUP |  |  |  |  | 1 |  |  |  |  | 팝업 조건 연동(인자) |
| X-LOC | GEN |  |  |  |  |  |  | 1 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |

## W3 동작 수정 (82)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0104-0001 | C2 | B04~B09 | 화면 FE(범위 밖(가이드만)) | C2 FAIL 수정 — B04~B09: 행 집계 — 대조표 B04~B09 '`_defaultDataModel_Changed` 재진입/타입 가드' 의 C2 19요소: PASS:10 · FAIL:7 · NA:2 · FAIL 요소: ELT |  | 1 (B04~B09) |
| WK-SCP0104-0002 | C2 | ELTR_LN_TP_CD / Equipment Type | 화면 FE(범위 밖(가이드만)) | C2 FAIL 수정 — ELTR_LN_TP_CD / Equipment Type: 실측[T-bc2f6848]: [정적 판정] TO-BE codesOf 가 CODE '-' 를 후보에서 뺌. OperationElectrodeType_SCP |  | 6 (6-10 COMMON:UC-05 ACT:SCP0104_CAPA_Line_) |
| WK-SCP0104-0003 | C2 | FACTORY_ID / Building | 화면 FE(범위 밖(가이드만)) | C2 FAIL 수정 — FACTORY_ID / Building: 실측[T-04e8f5c3]: [정적 판정] AS-IS 는 Building 후보를 행 Company 로도 거르고 Plant 가 DMY_ 코드면 Plant 조건을 뺌. TO |  | 9 (ACT:SCP0104_CAPA_Line_Assign.CheckValidN) |
| WK-SCP0104-0004 | C2 | FACTORY_NAME / Building Name | 화면 FE(범위 밖(가이드만)) | C2 FAIL 수정 — FACTORY_NAME / Building Name: 실측[T-a8dd3fa6]: [정적 판정] AS-IS 는 Building 후보를 행 Company 로도 거르고 Plant 가 DMY_ 코드면 Plant 조건 |  | 6 (ACT:SCP0104_CAPA_Line_Assign.CheckValidN) |
| WK-SCP0104-0005 | C2 | ITEM_ID / Model | 화면 FE(범위 밖(가이드만)) | C2 FAIL 수정 — ITEM_ID / Model: 실측[T-dacd5310]: [정적 판정] 화면 재현(2026-11-16 18:25 · 신규 행 NICK_NAME 칸에 목록에 없는 명칭 입력 → 값이 들어가지 않음 · 후보 3, |  | 2 (ACT:SCP0104_CAPA_Line_Assign._defaultDat) |
| WK-SCP0104-0006 | C2 | LINE_ID / Line | 화면 FE(범위 밖(가이드만)) | C2 FAIL 수정 — LINE_ID / Line: 실측[T-14b55da2]: [정적 판정] AS-IS 는 Line 후보를 행 Plant + Building 으로 거름. TO-BE 는 Division + Building 만 봄. P |  | 9 (ACT:SCP0104_CAPA_Line_Assign.CheckValidN) |
| WK-SCP0104-0007 | C2 | LINE_NAME / Line Name | 화면 FE(범위 밖(가이드만)) | C2 FAIL 수정 — LINE_NAME / Line Name: 실측[T-07f53041]: [정적 판정] AS-IS 는 Line 후보를 행 Plant + Building 으로 거름. TO-BE 는 Division + Building |  | 6 (ACT:SCP0104_CAPA_Line_Assign.CheckValidN) |
| WK-SCP0104-0008 | C2 | NICK_NAME / Nickname | FE(repairScope=DB_ONLY — 이번 범위 밖) | C2 FAIL 수정 — NICK_NAME / Nickname: 실측[T-26160058]: [정적 판정] 화면 재현(2026-11-16 18:25 · 신규 행 NICK_NAME 칸에 목록에 없는 명칭 입력 → 값이 들어가지 않음 ·  |  | 3 (ACT:SCP0104_CAPA_Line_Assign._defaultDat) |
| WK-SCP0104-0009 | C2 | SCP0104_CAPA_Line_Assign._defaultDataMod | 화면 FE(범위 밖(가이드만)) | C2 FAIL 수정 — SCP0104_CAPA_Line_Assign._defaultDataModel_Changed: 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign._defaultDataModel_Changed 의 |  | 31 (ACT:SCP0104_CAPA_Line_Assign._defaultDat) |
| WK-SCP0104-0010 | C2 | SCP0104_CAPA_Line_Assign.cboDivision_Sel | 화면 FE(범위 밖(가이드만)) | C2 FAIL 수정 — SCP0104_CAPA_Line_Assign.cboDivision_SelectedIndexChanged: 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.cboDivision_Selected |  | 6 (ACT:SCP0104_CAPA_Line_Assign.cboDivision) |
| WK-SCP0104-0011 | C2 | SCP0104_CAPA_Line_Assign.cboVersionSeq_S | 화면 FE(범위 밖(가이드만)) | C2 FAIL 수정 — SCP0104_CAPA_Line_Assign.cboVersionSeq_SelectedIndexChanged: 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.cboVersionSeq_Sele |  | 4 (ACT:SCP0104_CAPA_Line_Assign.cboVersionS) |
| WK-SCP0104-0012 | C2 | SCP0104_CAPA_Line_Assign.cboVersion_Sele | 화면 FE(범위 밖(가이드만)) | C2 FAIL 수정 — SCP0104_CAPA_Line_Assign.cboVersion_SelectedIndexChanged: 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.cboVersion_SelectedIn |  | 5 (ACT:SCP0104_CAPA_Line_Assign.cboVersion_) |
| WK-SCP0104-0013 | C2 | SCP0104_CAPA_Line_Assign.clbFactory_Sele | 화면 FE(범위 밖(가이드만)) | C2 FAIL 수정 — SCP0104_CAPA_Line_Assign.clbFactory_SelectedIndexChanged: 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.clbFactory_SelectedIn |  | 3 (ACT:SCP0104_CAPA_Line_Assign.clbFactory_) |
| WK-SCP0104-0014 | C2 | SCP0104_CAPA_Line_Assign.clbLine_Selecte | 화면 FE(범위 밖(가이드만)) | C2 FAIL 수정 — SCP0104_CAPA_Line_Assign.clbLine_SelectedIndexChanged: 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.clbLine_SelectedIndexCha |  | 2 (ACT:SCP0104_CAPA_Line_Assign.clbLine_Sel) |
| WK-SCP0104-0015 | C2 | SCP0104_CAPA_Line_Assign.clbOperation_Se | 화면 FE(범위 밖(가이드만)) | C2 FAIL 수정 — SCP0104_CAPA_Line_Assign.clbOperation_SelectedIndexChanged: 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.clbOperation_Select |  | 1 (ACT:SCP0104_CAPA_Line_Assign.clbOperatio) |
| WK-SCP0104-0016 | C2 | SCP0104_CAPA_Line_Assign.clbPlant_Select | 화면 FE(범위 밖(가이드만)) | C2 FAIL 수정 — SCP0104_CAPA_Line_Assign.clbPlant_SelectedIndexChanged: 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.clbPlant_SelectedIndexC |  | 4 (ACT:SCP0104_CAPA_Line_Assign.clbPlant_Se) |
| WK-SCP0104-0017 | C2 | SCP0104_CAPA_Line_Assign.clbSite_Selecte | 화면 FE(범위 밖(가이드만)) | C2 FAIL 수정 — SCP0104_CAPA_Line_Assign.clbSite_SelectedIndexChanged: 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.clbSite_SelectedIndexCha |  | 5 (ACT:SCP0104_CAPA_Line_Assign.clbSite_Sel) |
| WK-SCP0104-0018 | C2 | SCP0104_CAPA_Line_Assign.rgrpDivisionTyp | 화면 FE(범위 밖(가이드만)) | C2 FAIL 수정 — SCP0104_CAPA_Line_Assign.rgrpDivisionType_SelectedIndexChang: 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.rgrpDivisionType_ |  | 7 (ACT:SCP0104_CAPA_Line_Assign.rgrpDivisio) |
| WK-SCP0104-0019 | C2 | SCP0104_CAPA_Line_Assign.spdAssign_Combo | 화면 FE(범위 밖(가이드만)) | C2 FAIL 수정 — SCP0104_CAPA_Line_Assign.spdAssign_ComboSelChange: 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.spdAssign_ComboSelChange 의 C |  | 8 (ACT:SCP0104_CAPA_Line_Assign.spdAssign_C) |
| WK-SCP0104-0020 | C2 | 코드↔명칭 동기 | 화면 FE(범위 밖(가이드만)) | C2 FAIL 수정 — 코드↔명칭 동기: 행 집계 — 대조표 코드↔명칭 동기 '`CheckValidId`/`CheckValidName`(cs:3160-3699)' 의 C2 19요소: PASS:10 · FAIL:7 · NA:2 · FA |  | 1 (코드↔명칭 동기) |
| WK-SCP0104-0021 | C6 | B04~B09 | 화면 FE(범위 밖(가이드만)) | C6 FAIL 수정 — B04~B09: 행 집계 — 대조표 B04~B09 '`_defaultDataModel_Changed` 재진입/타입 가드' 의 C6 18요소: FAIL:12 · PASS:5 · NA:1 · FAIL 요소: SIT |  | 1 (B04~B09) |
| WK-SCP0104-0022 | C6 | COMPANY_ID / Company | 화면 FE(범위 밖(가이드만)) | C6 FAIL 수정 — COMPANY_ID / Company: 실측[T-9407819e]: [정적 판정] 화면 재현(2026-11-16 18:25 · 신규 행 SITE_ID 칸을 F2 로 열고 Esc·Enter 로 값 변경 없이 종료 |  | 4 (ACT:SCP0104_CAPA_Line_Assign._defaultDat) |
| WK-SCP0104-0023 | C6 | COMPANY_NAME / Company Name | 화면 FE(범위 밖(가이드만)) | C6 FAIL 수정 — COMPANY_NAME / Company Name: 실측[T-5e69f0c0]: [정적 판정] 화면 재현(2026-11-16 18:25 · 신규 행 SITE_ID 칸을 F2 로 열고 Esc·Enter 로 값 변 |  | 3 (ACT:SCP0104_CAPA_Line_Assign._defaultDat) |
| WK-SCP0104-0024 | C6 | FACTORY_ID / Building | 화면 FE(범위 밖(가이드만)) | C6 FAIL 수정 — FACTORY_ID / Building: 실측[T-9669ca5f]: [정적 판정] 화면 재현(2026-11-16 18:25 · 신규 행 SITE_ID 칸을 F2 로 열고 Esc·Enter 로 값 변경 없이 종 |  | 6 (ACT:SCP0104_CAPA_Line_Assign._defaultDat) |
| WK-SCP0104-0025 | C6 | FACTORY_NAME / Building Name | 화면 FE(범위 밖(가이드만)) | C6 FAIL 수정 — FACTORY_NAME / Building Name: 실측[T-932f5b37]: [정적 판정] 화면 재현(2026-11-16 18:25 · 신규 행 SITE_ID 칸을 F2 로 열고 Esc·Enter 로 값  |  | 3 (ACT:SCP0104_CAPA_Line_Assign._defaultDat) |
| WK-SCP0104-0026 | C6 | LINE_ID / Line | 화면 FE(범위 밖(가이드만)) | C6 FAIL 수정 — LINE_ID / Line: 실측[T-fe6c000f]: [정적 판정] 화면 재현(2026-11-16 18:25 · 신규 행 SITE_ID 칸을 F2 로 열고 Esc·Enter 로 값 변경 없이 종료 → COM |  | 6 (ACT:SCP0104_CAPA_Line_Assign._defaultDat) |
| WK-SCP0104-0027 | C6 | LINE_NAME / Line Name | 화면 FE(범위 밖(가이드만)) | C6 FAIL 수정 — LINE_NAME / Line Name: 실측[T-744b42e7]: [정적 판정] 화면 재현(2026-11-16 18:25 · 신규 행 SITE_ID 칸을 F2 로 열고 Esc·Enter 로 값 변경 없이 종 |  | 3 (ACT:SCP0104_CAPA_Line_Assign._defaultDat) |
| WK-SCP0104-0028 | C6 | OPERATION_ID / Operation | 화면 FE(범위 밖(가이드만)) | C6 FAIL 수정 — OPERATION_ID / Operation: 실측[T-e3e85b8a]: [정적 판정] 화면 재현(2026-11-16 18:25 · 신규 행 SITE_ID 칸을 F2 로 열고 Esc·Enter 로 값 변경 없 |  | 8 (ACT:SCP0104_CAPA_Line_Assign._defaultDat) |
| WK-SCP0104-0029 | C6 | OPERATION_NAME / Operation Name | 화면 FE(범위 밖(가이드만)) | C6 FAIL 수정 — OPERATION_NAME / Operation Name: 실측[T-55e5ceee]: [정적 판정] 화면 재현(2026-11-16 18:25 · 신규 행 SITE_ID 칸을 F2 로 열고 Esc·Enter 로 |  | 4 (ACT:SCP0104_CAPA_Line_Assign._defaultDat) |
| WK-SCP0104-0030 | C6 | PLANT_ID / Plant | 화면 FE(범위 밖(가이드만)) | C6 FAIL 수정 — PLANT_ID / Plant: 실측[T-4a361502]: [정적 판정] 화면 재현(2026-11-16 18:25 · 신규 행 SITE_ID 칸을 F2 로 열고 Esc·Enter 로 값 변경 없이 종료 → C |  | 13 (ACT:SCP0104_CAPA_Line_Assign._defaultDat) |
| WK-SCP0104-0031 | C6 | PLANT_NAME / Plant Name | 화면 FE(범위 밖(가이드만)) | C6 FAIL 수정 — PLANT_NAME / Plant Name: 실측[T-a86b60fe]: [정적 판정] 화면 재현(2026-11-16 18:25 · 신규 행 SITE_ID 칸을 F2 로 열고 Esc·Enter 로 값 변경 없이 |  | 3 (ACT:SCP0104_CAPA_Line_Assign._defaultDat) |
| WK-SCP0104-0032 | C6 | SCP0104_CAPA_Line_Assign._defaultDataMod | 화면 FE(범위 밖(가이드만)) | C6 FAIL 수정 — SCP0104_CAPA_Line_Assign._defaultDataModel_Changed: 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign._defaultDataModel_Changed 의 |  | 31 (ACT:SCP0104_CAPA_Line_Assign._defaultDat) |
| WK-SCP0104-0033 | C6 | SCP0104_CAPA_Line_Assign.cboDivision_Sel | 화면 FE(범위 밖(가이드만)) | C6 FAIL 수정 — SCP0104_CAPA_Line_Assign.cboDivision_SelectedIndexChanged: 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.cboDivision_Selected |  | 6 (ACT:SCP0104_CAPA_Line_Assign.cboDivision) |
| WK-SCP0104-0034 | C6 | SCP0104_CAPA_Line_Assign.cboVersionSeq_S | 화면 FE(범위 밖(가이드만)) | C6 FAIL 수정 — SCP0104_CAPA_Line_Assign.cboVersionSeq_SelectedIndexChanged: 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.cboVersionSeq_Sele |  | 4 (ACT:SCP0104_CAPA_Line_Assign.cboVersionS) |
| WK-SCP0104-0035 | C6 | SCP0104_CAPA_Line_Assign.cboVersion_Sele | 화면 FE(범위 밖(가이드만)) | C6 FAIL 수정 — SCP0104_CAPA_Line_Assign.cboVersion_SelectedIndexChanged: 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.cboVersion_SelectedIn |  | 5 (ACT:SCP0104_CAPA_Line_Assign.cboVersion_) |
| WK-SCP0104-0036 | C6 | SCP0104_CAPA_Line_Assign.clbFactory_Sele | 화면 FE(범위 밖(가이드만)) | C6 FAIL 수정 — SCP0104_CAPA_Line_Assign.clbFactory_SelectedIndexChanged: 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.clbFactory_SelectedIn |  | 3 (ACT:SCP0104_CAPA_Line_Assign.clbFactory_) |
| WK-SCP0104-0037 | C6 | SCP0104_CAPA_Line_Assign.clbLine_Selecte | 화면 FE(범위 밖(가이드만)) | C6 FAIL 수정 — SCP0104_CAPA_Line_Assign.clbLine_SelectedIndexChanged: 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.clbLine_SelectedIndexCha |  | 2 (ACT:SCP0104_CAPA_Line_Assign.clbLine_Sel) |
| WK-SCP0104-0038 | C6 | SCP0104_CAPA_Line_Assign.clbOperation_Se | 화면 FE(범위 밖(가이드만)) | C6 FAIL 수정 — SCP0104_CAPA_Line_Assign.clbOperation_SelectedIndexChanged: 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.clbOperation_Select |  | 1 (ACT:SCP0104_CAPA_Line_Assign.clbOperatio) |
| WK-SCP0104-0039 | C6 | SCP0104_CAPA_Line_Assign.clbPlant_Select | 화면 FE(범위 밖(가이드만)) | C6 FAIL 수정 — SCP0104_CAPA_Line_Assign.clbPlant_SelectedIndexChanged: 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.clbPlant_SelectedIndexC |  | 4 (ACT:SCP0104_CAPA_Line_Assign.clbPlant_Se) |
| WK-SCP0104-0040 | C6 | SCP0104_CAPA_Line_Assign.clbSite_Selecte | 화면 FE(범위 밖(가이드만)) | C6 FAIL 수정 — SCP0104_CAPA_Line_Assign.clbSite_SelectedIndexChanged: 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.clbSite_SelectedIndexCha |  | 5 (ACT:SCP0104_CAPA_Line_Assign.clbSite_Sel) |
| WK-SCP0104-0041 | C6 | SCP0104_CAPA_Line_Assign.rgrpDivisionTyp | 화면 FE(범위 밖(가이드만)) | C6 FAIL 수정 — SCP0104_CAPA_Line_Assign.rgrpDivisionType_SelectedIndexChang: 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.rgrpDivisionType_ |  | 7 (ACT:SCP0104_CAPA_Line_Assign.rgrpDivisio) |
| WK-SCP0104-0042 | C6 | SCP0104_CAPA_Line_Assign.spdAssign_Combo | 화면 FE(범위 밖(가이드만)) | C6 FAIL 수정 — SCP0104_CAPA_Line_Assign.spdAssign_ComboSelChange: 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.spdAssign_ComboSelChange 의 C |  | 8 (ACT:SCP0104_CAPA_Line_Assign.spdAssign_C) |
| WK-SCP0104-0043 | C6 | SITE_ID / Site | 화면 FE(범위 밖(가이드만)) | C6 FAIL 수정 — SITE_ID / Site: 실측[T-9f7a81a0]: [정적 판정] 화면 재현(2026-11-16 18:25 · 신규 행 SITE_ID 칸을 F2 로 열고 Esc·Enter 로 값 변경 없이 종료 → COM |  | 16 (ACT:SCP0104_CAPA_Line_Assign._defaultDat) |
| WK-SCP0104-0044 | C6 | SITE_NAME / Site Name | 화면 FE(범위 밖(가이드만)) | C6 FAIL 수정 — SITE_NAME / Site Name: 실측[T-2157e939]: [정적 판정] 화면 재현(2026-11-16 18:25 · 신규 행 SITE_ID 칸을 F2 로 열고 Esc·Enter 로 값 변경 없이 종 |  | 2 (ACT:SCP0104_CAPA_Line_Assign._defaultDat) |
| WK-SCP0104-0045 | C6 | 코드↔명칭 동기 | 화면 FE(범위 밖(가이드만)) | C6 FAIL 수정 — 코드↔명칭 동기: 행 집계 — 대조표 코드↔명칭 동기 '`CheckValidId`/`CheckValidName`(cs:3160-3699)' 의 C6 18요소: FAIL:12 · PASS:5 · NA:1 · FA |  | 1 (코드↔명칭 동기) |
| WK-SCP0104-0046 | F4 | PKG_SCP0104.P_SCP0104_CHECK_NAME_ON_DUMM | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — PKG_SCP0104.P_SCP0104_CHECK_NAME_ON_DUMMY_CODE: 실측[T-228fc738]: [사용자판정] FAIL — 목록 밖 품목명 Dummy 코드 생성 불가 — 오류(사용자 판정 '오 |  | 4 (ACT:SCP0104_CAPA_Line_Assign.CheckNameOn) |
| WK-SCP0104-0047 | F4 | SCP0104_CAPA_Line.FindButton | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — SCP0104_CAPA_Line.FindButton: 진입점 집계 — 대조표 SCP0104_CAPA_Line.FindButton 의 F4 2요소: FAIL:1 · PASS:1 · FAIL 요소: PKG_SCP0 |  | 1 (ACT:SCP0104_CAPA_Line.FindButton) |
| WK-SCP0104-0048 | F4 | SCP0104_CAPA_Line.FindData | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — SCP0104_CAPA_Line.FindData: 진입점 집계 — 대조표 SCP0104_CAPA_Line.FindData 의 F4 2요소: FAIL:1 · PASS:1 · FAIL 요소: PKG_SCP0104. |  | 1 (ACT:SCP0104_CAPA_Line.FindData) |
| WK-SCP0104-0049 | F4 | SCP0104_CAPA_Line_Assign.FindButton | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — SCP0104_CAPA_Line_Assign.FindButton: 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.FindButton 의 F4 2요소: FAIL:1 · PASS:1 · FAI |  | 5 (ACT:SCP0104_CAPA_Line_Assign.FindButton ) |
| WK-SCP0104-0050 | F4 | SCP0104_CAPA_Line_Assign.FindDataAssign | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — SCP0104_CAPA_Line_Assign.FindDataAssign: 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.FindDataAssign 의 F4 2요소: FAIL:1 · PASS |  | 2 (ACT:SCP0104_CAPA_Line_Assign.FindDataAss) |
| WK-SCP0104-0051 | F4 | SCP0104_CAPA_Line_Assign.FindDataSOP | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — SCP0104_CAPA_Line_Assign.FindDataSOP: 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.FindDataSOP 의 F4 2요소: FAIL:1 · PASS:1 · F |  | 2 (ACT:SCP0104_CAPA_Line_Assign.FindDataSOP) |
| WK-SCP0104-0052 | F4 | SCP0104_CAPA_Line_Assign.SaveButton | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — SCP0104_CAPA_Line_Assign.SaveButton: 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.SaveButton 의 F4 2요소: FAIL:1 · PASS:1 · FAI |  | 1 (ACT:SCP0104_CAPA_Line_Assign.SaveButton) |
| WK-SCP0104-0053 | F4 | SCP0104_CAPA_Line_Assign.SaveData | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — SCP0104_CAPA_Line_Assign.SaveData: 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.SaveData 의 F4 2요소: FAIL:1 · PASS:1 · FAIL 요소 |  | 1 (ACT:SCP0104_CAPA_Line_Assign.SaveData) |
| WK-SCP0104-0054 | F4 | SCP0104_CAPA_Line_Assign.SaveDataAssign | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — SCP0104_CAPA_Line_Assign.SaveDataAssign: 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.SaveDataAssign 의 F4 2요소: FAIL:1 · PASS |  | 1 (ACT:SCP0104_CAPA_Line_Assign.SaveDataAss) |
| WK-SCP0104-0055 | F4 | SCP0104_CAPA_Line_Assign.SaveDataSOP | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — SCP0104_CAPA_Line_Assign.SaveDataSOP: 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.SaveDataSOP 의 F4 2요소: FAIL:1 · PASS:1 · F |  | 1 (ACT:SCP0104_CAPA_Line_Assign.SaveDataSOP) |
| WK-SCP0104-0056 | F4 | SCP0104_CAPA_Line_Assign_Model.FindButto | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — SCP0104_CAPA_Line_Assign_Model.FindButton: 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign_Model.FindButton 의 F4 2요소: FAIL:1 ·  |  | 1 (ACT:SCP0104_CAPA_Line_Assign_Model.FindB) |
| WK-SCP0104-0057 | F4 | SCP0104_CAPA_Line_Assign_Model.FindData | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — SCP0104_CAPA_Line_Assign_Model.FindData: 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign_Model.FindData 의 F4 2요소: FAIL:1 · PASS |  | 1 (ACT:SCP0104_CAPA_Line_Assign_Model.FindD) |
| WK-SCP0104-0058 | F4 | 저장 | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — 저장: 행 집계 — 대조표 저장 '`SaveData` `^`/`;` 다발' 의 F4 2요소: FAIL:1 · PASS:1 · FAIL 요소: PKG_SCP0104.P_SCP0104_CHECK_NA — 실측[T- |  | 1 (저장) |
| WK-SCP0104-0059 | X-ROW | SCP0104_CAPA_Line.FindButton | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0104_CAPA_Line.FindButton: 진입점 집계 5검사 — PASS:2 · NA:2 · FAIL:1 (FX-SCP0104-052) |  | 4 (ACT:SCP0104_CAPA_Line.FindButton ACT:SCP) |
| WK-SCP0104-0060 | X-ROW | SCP0104_CAPA_Line.FindData | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0104_CAPA_Line.FindData: 진입점 집계 5검사 — PASS:3 · NA:1 · FAIL:1 (FX-SCP0104-054) |  | 3 (ACT:SCP0104_CAPA_Line.FindData ACT:SCP01) |
| WK-SCP0104-0061 | X-ROW | SCP0104_CAPA_Line_Assign.CheckNameOnDumm | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0104_CAPA_Line_Assign.CheckNameOnDummyCodeDB: 진입점 집계 3검사 — PASS:2 · FAIL:1 (FX-SCP0104-056) |  | 18 (ACT:SCP0104_CAPA_Line_Assign.CheckNameOn) |
| WK-SCP0104-0062 | X-ROW | SCP0104_CAPA_Line_Assign.CheckValidName | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0104_CAPA_Line_Assign.CheckValidName: 진입점 집계 11검사 — PASS:7 · FAIL:4 (FX-SCP0104-058) |  | 101 (ACT:SCP0104_CAPA_Line_Assign.CheckValidN) |
| WK-SCP0104-0063 | X-ROW | SCP0104_CAPA_Line_Assign.Edit_Row_Assign | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0104_CAPA_Line_Assign.Edit_Row_Assign: 실측[T-25489c40]: [사용자판정] FAIL — 추가 행 품목 선택 때 기본값 재설정 없음 — 오류(사용자 판정 '오류로  |  | 21 (ACT:SCP0104_CAPA_Line_Assign.Edit_Row_As) |
| WK-SCP0104-0064 | X-ROW | SCP0104_CAPA_Line_Assign.FindButton | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0104_CAPA_Line_Assign.FindButton: 진입점 집계 5검사 — NA:2 · PASS:2 · FAIL:1 (FX-SCP0104-064) |  | 2 (ACT:SCP0104_CAPA_Line_Assign.FindButton ) |
| WK-SCP0104-0065 | X-ROW | SCP0104_CAPA_Line_Assign.FindDataAssign | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0104_CAPA_Line_Assign.FindDataAssign: 진입점 집계 5검사 — PASS:3 · NA:1 · FAIL:1 (FX-SCP0104-066) |  | 1 (ACT:SCP0104_CAPA_Line_Assign.FindDataAss) |
| WK-SCP0104-0066 | X-ROW | SCP0104_CAPA_Line_Assign.FindDataSOP | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0104_CAPA_Line_Assign.FindDataSOP: 진입점 집계 5검사 — PASS:3 · NA:1 · FAIL:1 (FX-SCP0104-068) |  | 1 (ACT:SCP0104_CAPA_Line_Assign.FindDataSOP) |
| WK-SCP0104-0067 | X-ROW | SCP0104_CAPA_Line_Assign.RefreshSpreadCo | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0104_CAPA_Line_Assign.RefreshSpreadComboAll: 진입점 집계 13검사 — PASS:8 · FAIL:5 (FX-SCP0104-083) |  | 14 (ACT:SCP0104_CAPA_Line_Assign.RefreshSpre) |
| WK-SCP0104-0068 | X-ROW | SCP0104_CAPA_Line_Assign._defaultDataMod | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0104_CAPA_Line_Assign._defaultDataModel_Changed: 진입점 집계 49검사 — FAIL:21 · PASS:19 · NA:9 (FX-SCP0104-103) |  | 13 (ACT:SCP0104_CAPA_Line_Assign._defaultDat) |
| WK-SCP0104-0069 | X-ROW | SCP0104_CAPA_Line_Assign.cboDivision_Sel | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0104_CAPA_Line_Assign.cboDivision_SelectedIndexChanged: 진입점 집계 3검사 — FAIL:2 · PASS:1 (FX-SCP0104-104) |  | 1 (ACT:SCP0104_CAPA_Line_Assign.cboDivision) |
| WK-SCP0104-0070 | X-ROW | SCP0104_CAPA_Line_Assign.cboVersionSeq_S | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0104_CAPA_Line_Assign.cboVersionSeq_SelectedIndexChanged: 진입점 집계 3검사 — FAIL:2 · PASS:1 (FX-SCP0104-107) |  | 1 (ACT:SCP0104_CAPA_Line_Assign.cboVersionS) |
| WK-SCP0104-0071 | X-ROW | SCP0104_CAPA_Line_Assign.cboVersion_Sele | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0104_CAPA_Line_Assign.cboVersion_SelectedIndexChanged: 진입점 집계 3검사 — FAIL:2 · PASS:1 (FX-SCP0104-110) |  | 1 (ACT:SCP0104_CAPA_Line_Assign.cboVersion_) |
| WK-SCP0104-0072 | X-ROW | SCP0104_CAPA_Line_Assign.clbFactory_Sele | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0104_CAPA_Line_Assign.clbFactory_SelectedIndexChanged: 진입점 집계 3검사 — FAIL:2 · PASS:1 (FX-SCP0104-113) |  | 1 (ACT:SCP0104_CAPA_Line_Assign.clbFactory_) |
| WK-SCP0104-0073 | X-ROW | SCP0104_CAPA_Line_Assign.clbLine_Selecte | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0104_CAPA_Line_Assign.clbLine_SelectedIndexChanged: 진입점 집계 3검사 — FAIL:2 · PASS:1 (FX-SCP0104-116) |  | 1 (ACT:SCP0104_CAPA_Line_Assign.clbLine_Sel) |
| WK-SCP0104-0074 | X-ROW | SCP0104_CAPA_Line_Assign.clbOperation_Se | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0104_CAPA_Line_Assign.clbOperation_SelectedIndexChanged: 진입점 집계 3검사 — FAIL:2 · PASS:1 (FX-SCP0104-119) |  | 1 (ACT:SCP0104_CAPA_Line_Assign.clbOperatio) |
| WK-SCP0104-0075 | X-ROW | SCP0104_CAPA_Line_Assign.clbPlant_Select | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0104_CAPA_Line_Assign.clbPlant_SelectedIndexChanged: 진입점 집계 3검사 — FAIL:2 · PASS:1 (FX-SCP0104-122) |  | 1 (ACT:SCP0104_CAPA_Line_Assign.clbPlant_Se) |
| WK-SCP0104-0076 | X-ROW | SCP0104_CAPA_Line_Assign.clbSite_Selecte | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0104_CAPA_Line_Assign.clbSite_SelectedIndexChanged: 진입점 집계 3검사 — FAIL:2 · PASS:1 (FX-SCP0104-125) |  | 1 (ACT:SCP0104_CAPA_Line_Assign.clbSite_Sel) |
| WK-SCP0104-0077 | X-ROW | SCP0104_CAPA_Line_Assign.rgrpDivisionTyp | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0104_CAPA_Line_Assign.rgrpDivisionType_SelectedIndexChang: 진입점 집계 3검사 — FAIL:2 · PASS:1 (FX-SCP0104-183) |  | 1 (ACT:SCP0104_CAPA_Line_Assign.rgrpDivisio) |
| WK-SCP0104-0078 | X-ROW | SCP0104_CAPA_Line_Assign.spdAssign_CellC | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0104_CAPA_Line_Assign.spdAssign_CellClick: 진입점 집계 13검사 — PASS:8 · FAIL:5 (FX-SCP0104-186) |  | 40 (ACT:SCP0104_CAPA_Line_Assign.spdAssign_C) |
| WK-SCP0104-0079 | X-ROW | SCP0104_CAPA_Line_Assign_Model.CheckName | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0104_CAPA_Line_Assign_Model.CheckNameOnDummyCodeDB: 진입점 집계 5검사 — PASS:3 · FAIL:1 · NA:1 (FX-SCP0104-190) |  | 18 (ACT:SCP0104_CAPA_Line_Assign_Model.Check) |
| WK-SCP0104-0080 | X-ROW | SCP0104_CAPA_Line_Assign_Model.FindButto | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0104_CAPA_Line_Assign_Model.FindButton: 진입점 집계 6검사 — NA:3 · PASS:2 · FAIL:1 (FX-SCP0104-191) |  | 4 (ACT:SCP0104_CAPA_Line_Assign_Model.FindB) |
| WK-SCP0104-0081 | X-ROW | SCP0104_CAPA_Line_Assign_Model.FindData | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0104_CAPA_Line_Assign_Model.FindData: 진입점 집계 6검사 — PASS:3 · NA:2 · FAIL:1 (FX-SCP0104-193) |  | 3 (ACT:SCP0104_CAPA_Line_Assign_Model.FindD) |
| WK-SCP0104-0082 | X-ROW | SCP0104_CAPA_Line_Assign_Model.rgrpDivis | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0104_CAPA_Line_Assign_Model.rgrpDivisionType_SelectedInde: 진입점 집계 5검사 — PASS:2 · NA:2 · FAIL:1 (FX-SCP0104-196) |  | 5 (ACT:SCP0104_CAPA_Line_Assign_Model.rgrpD) |

## W5 검사기 연결 (3)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0104-0083 | B4 | clbElectrodeType / Line Type / Electrode | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbElectrodeType / Line Type / Electrode Type | 있음(FE 소스) | 6 (ACT:SCP0104_CAPA_Line_Assign.getElectrod) |
| WK-SCP0104-0084 | E5 | ELTR_LN_TP_CD / Equipment Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL ELTR_LN_TP_CD / Equipment Type | 있음(SHEET_COLUMNS) | 2 (6-10 COMMON:UC-05) |
| WK-SCP0104-0085 | G5 | SCP0104_CAPA_Line_Assign_Model | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 POPUP SCP0104_CAPA_Line_Assign_Model | 판단불가(대상 단위 POPUP) | 2 (MODAL:CapaLineAssignModelModal ACT:SCP01) |

## W7 기대값 확정 (8)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0104-0086 | X-LOC | ~~6-1~~ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — ~~6-1~~: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (~~6-1~~) |
| WK-SCP0104-0087 | X-ROW | SCP0104_CAPA_Line_Assign.RefreshCompanyS | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0104_CAPA_Line_Assign.RefreshCompanySpread: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 5 (ACT:SCP0104_CAPA_Line_Assign.RefreshComp) |
| WK-SCP0104-0088 | X-ROW | SCP0104_CAPA_Line_Assign.RefreshFactoryS | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0104_CAPA_Line_Assign.RefreshFactorySpread: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 5 (ACT:SCP0104_CAPA_Line_Assign.RefreshFact) |
| WK-SCP0104-0089 | X-ROW | SCP0104_CAPA_Line_Assign.RefreshLineSpre | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0104_CAPA_Line_Assign.RefreshLineSpread: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 5 (ACT:SCP0104_CAPA_Line_Assign.RefreshLine) |
| WK-SCP0104-0090 | X-ROW | SCP0104_CAPA_Line_Assign.RefreshPlantSpr | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0104_CAPA_Line_Assign.RefreshPlantSpread: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 5 (ACT:SCP0104_CAPA_Line_Assign.RefreshPlan) |
| WK-SCP0104-0091 | X-ROW | SCP0104_CAPA_Line_Assign.RefreshSiteSpre | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0104_CAPA_Line_Assign.RefreshSiteSpread: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 5 (ACT:SCP0104_CAPA_Line_Assign.RefreshSite) |
| WK-SCP0104-0092 | M4 | ITEM_ID / Model | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — ITEM_ID / Model: 검증 엔진이 실행됐으나 이 대상(COL ITEM_ID)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 13 (K-20-c ACT:SCP0104_CAPA_Line_Assign.spdA) |
| WK-SCP0104-0093 | M4 | NICK_NAME / Nickname | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — NICK_NAME / Nickname: 검증 엔진이 실행됐으나 이 대상(COL NICK_NAME)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 19 (편집잠금 K-20-c 6-6 ACT:SCP0104_CAPA_Line_As) |

## W9 도구 오류 (11)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0104-0094 | M4 | 6-11 | 하네스·환경 | M4 도구 오류 — 행 집계 — 대조표 6-11 'SOP·팝업 2종 그리드가 **3단 헤더로 렌더**된다(설계 C-8 = 1단)' 의 M4 23요소: PASS:17 · NA:4 · NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (6-11) |
| WK-SCP0104-0095 | M4 | B11~B13 | 하네스·환경 | M4 도구 오류 — 행 집계 — 대조표 B11~B13 'Insert 가드' 의 M4 23요소: PASS:17 · NA:4 · NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (B11~B13) |
| WK-SCP0104-0096 | M4 | COMMON:UC-06 | 하네스·환경 | M4 도구 오류 — 행 집계 — 대조표 COMMON:UC-06 'Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회' 의 M4 23요소: PASS:17 · NA:4 · NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0104-0097 | M4 | MODAL:CustomDialog | 하네스·환경 | M4 도구 오류 — 행 집계 — 대조표 MODAL:CustomDialog 'P01 Item 팝업(AS-IS `ShowItem` → `SCM0002_CAPAItemPo' 의 M4 23요소: PASS:17 · NA:4 · NOT_RUN: |  | 1 (MODAL:CustomDialog) |
| WK-SCP0104-0098 | M4 | MODAL:ShowDialog | 하네스·환경 | M4 도구 오류 — 행 집계 — 대조표 MODAL:ShowDialog 'P04 컬럼 표시설정 + alert/toast 계열 범용 다이얼로그' 의 M4 23요소: PASS:17 · NA:4 · NOT_RUN:2 (미실행 요소가 남아 판 |  | 1 (MODAL:ShowDialog) |
| WK-SCP0104-0099 | M4 | SCP0104_CAPA_Line_Assign.spdAssign_CellD | 하네스·환경 | M4 도구 오류 — 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.spdAssign_CellDoubleClick 의 M4 3요소: NOT_RUN:2 · PASS:1 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0104_CAPA_Line_Assign.spdAssign_C) |
| WK-SCP0104-0100 | M4 | ~~6-1~~ | 하네스·환경 | M4 도구 오류 — 행 집계 — 대조표 ~~6-1~~ '~~P01 Item 팝업 다중선택 → 행 추가(A-6)~~' 의 M4 23요소: PASS:17 · NA:4 · NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (~~6-1~~) |
| WK-SCP0104-0101 | M4 | 버튼 노출 | 하네스·환경 | M4 도구 오류 — 행 집계 — 대조표 버튼 노출 '툴바 override 5종(Search/Insert/Edit/Delete/Save)' 의 M4 23요소: PASS:17 · NA:4 · NOT_RUN:2 (미실행 요소가 남아 판정필 |  | 1 (버튼 노출) |
| WK-SCP0104-0102 | M4 | 영역2 조회조건 S01~S15 | 하네스·환경 | M4 도구 오류 — 행 집계 — 대조표 영역2 조회조건 S01~S15 '15' 의 M4 23요소: PASS:17 · NA:4 · NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (영역2 조회조건 S01~S15) |
| WK-SCP0104-0103 | M4 | 팝업 P01~P04 | 하네스·환경 | M4 도구 오류 — 행 집계 — 대조표 팝업 P01~P04 '4' 의 M4 23요소: PASS:17 · NA:4 · NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (팝업 P01~P04) |
| WK-SCP0104-0104 | M4 | 행 추가 | 하네스·환경 | M4 도구 오류 — 행 집계 — 대조표 행 추가 '`Insert_Row_Assign`/`_Line`/`_Sop`' 의 M4 23요소: PASS:17 · NA:4 · NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (행 추가) |
