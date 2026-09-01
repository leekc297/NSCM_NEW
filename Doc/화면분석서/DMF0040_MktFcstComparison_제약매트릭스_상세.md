# DMF0040 (MKT FCST Comparison) — 제약(Validation) 매트릭스 상세

> 작성: 2026-08-26 (hook #124 ② VALIDATION 축 / #105 §1-C 0단계 / #114 MSG 실문구 대사)
> AS-IS 정본: `GSCM.DM.Forms.UIL\Plan\DMF0040_MktFcst_Comparison\DMF0040_MktFcst_Comparison.cs` 1,875행 (라인 = 정본 기준)
> 분모: validation.md(v6) **17건** + analysis.md §16 GMessageBox 5건 (17건 안의 GMessageBox 3 + Edit/Version 2 — 합집합 아래 전수)
> MSG 실문구: 사내 `SCM_MGR.SCM_ADM_MSG_M` + `nscm-fe/public/locales` 실측 (2026-08-26 — **5종 전부 기등재·locales 동기, 신규 채번 불요**)

## 1. MSG 실문구 대사 (hook #114)

| MSG | AS-IS 사용처 | TO-BE KO 실측 | TO-BE EN 실측 | 판정 |
|---|---|---|---|---|
| MSG00097 | FindData V1 (L673) | Division 을 선택하세요. | Please select Division. | 재사용 |
| MSG00108 | FindData V2 (L682) | 조회 기간이 잘못되었습니다 (시작일 > 종료일). | Invalid period (start > end). | 재사용 |
| MSG00164 | FindData V3 (L688) | 조회 기간은 3년 이내로 입력해주세요. | Please enter a period within 3 years. | 재사용 ⚠아래 A-03 비고 |
| MSG00109 | EditButton (L591) | 읽기전용 상태입니다. | Read-only mode. | 재사용 |
| MSG00255 | btnVersion_Click (L1657) / 팝업 SetItem | 버전은 최대 2개까지 선택할 수 있습니다. | You can select up to 2 versions. | 재사용 |

> ⚠ **MSG00164 문구-로직 불일치 (발견 2026-08-26)**: AS-IS 로직은 `Value1.AddYears(2) < Value2` = **2년 상한**인데 TO-BE 공용 문구는 "3년 이내".
> AS-IS 원 MSG (TB_FX 계열) 원문 확인 결과 TO-BE 등재 시점의 번역 편차로 추정. **구현은 AS-IS 로직(2년) 파리티** — 문구 정정(2년) 은 공용 MSG 라 타 화면 소비 영향 조사 후 별도 결정 (원장 기록 대상, 사용자 확인 축).

## 2. 제약 전수 매트릭스 (17건 — A/P/D/G 접두 ID 체계)

접두: A=조회 사전검증(Alert 동반) / D=Division 분기(동작 분기 — 메시지 없음) / G=Grid·기타 사전분기 / P=팝업(버전)

### A. 조회 사전검증 (FindData — TO-BE handleSubmit V1~V3)

| ID | 라인 | 조건 | 동작 | MSG | TO-BE 매핑 |
|---|---:|---|---|---|---|
| A-01 | 671~677 | `checkRequiredOfSearch`(Required 3종: Division*/Period*/Version*) 통과 후 `sDivision == ""` | return | MSG00097 | handleSubmit V1 — division 필수 |
| A-02 | 680~685 | `int(sPeriod[0]) > int(sPeriod[1])` 기간 역전 | return | MSG00108 | V2 — from>to 차단 |
| A-03 | 687~695 | `drpPeriod.Value1.AddYears(2) < Value2` (2년 초과) | **Value2 = Value1+2년 자동 보정** 후 return | MSG00164 | V3 — 알림+종료일 자동 보정 (보정까지 파리티) |

### D. Division 분기 (validation.md #1~3·7~13 — 메시지 없는 동작 분기 10건)

| ID | 라인 | 위치 | 분기 | TO-BE 매핑 |
|---|---:|---|---|---|
| D-01 | 293 | InitControls | `sDivision` 비어있지 않을 때만 Customer/BizType 적재 | 초기 cascade 가드 |
| D-02 | 295 | InitControls | `81%` 또는 `82` vs 그외(40): EndCustomer 파라미터 축 상이 (81·82=division+team / 40=division+team[콤보원값]) | CMBO 파라미터 분기 |
| D-03 | 671 | FindData | `sDivision==""` (A-01 의 분기 축) | V1 |
| D-04 | 968 | cboDivision change | **`sDivision=="40"`: lblProject·lblPlantSite·btnProject Disable** (81·82: Enable) | division 반응형 조회조건 disabled |
| D-05 | 1051 | clbTeam change | division prefix 존재 가드 | cascade 가드 |
| D-06 | 1053 | clbTeam change | 81%·82 vs 40: Customer/SalesSite 재적재 파라미터 상이 | CMBO 파라미터 분기 |
| D-07 | 1090 | clbCustomer change | division 존재 가드 | cascade 가드 |
| D-08 | 1092 | clbCustomer change | 81%·82 vs 40: SalesSite 파라미터 상이 | CMBO 파라미터 분기 |
| D-09 | 1164 | spdMain_ComboSelChange | 그리드 Division 셀 변경 시 행 콤보 재적재 | **제외 — Insert 전제 사문** (읽기 전용) |
| D-10 | 1439 | fnValidation | Insert 행 9키 중복 검사 | **제외 — Insert 전제 사문** |

### G. Grid·기타 사전분기 (validation.md #14~17)

| ID | 라인 | 위치 | 조건 | TO-BE 매핑 |
|---|---:|---|---|---|
| G-01 | 1657 (validation.md #14 txtVersion_KeyDown) | txtVersion KeyDown | 키 입력 = 항상 버전 팝업 오픈 (직접 타이핑 차단) | Version 입력 = readOnly + 클릭/키 → 모달 |
| G-02 | 1671 | GetThisWeekMonday | 월요일 도달까지 역산 (실적 경계 산출) | 회색 경계 util (editLock 계열 재사용) |
| G-03 | 1694 | GetLastWeekSunDayByDate | Cutoff 버전 기준 전주 일요일 역산 | 동일 util |
| G-04 | 1748 | SetAmountCalculating | `cboQTY.SelectedIndex==0` 이면 원본 복원 후 종료 | QTY 스케일 전환 가드 |

### P. 버전 선택 제약 (analysis.md §16 잔여 2건)

| ID | 라인 | 위치 | 조건 | MSG | TO-BE 매핑 |
|---|---:|---|---|---|---|
| P-01 | 588~595 | EditButton (F2) | `fps != null` → 읽기전용 통보 | MSG00109 | 편집 버튼 자체 미노출 — 대사표 '제외(사유: 편집 진입점 없음)' 또는 정보성 알림 불요 |
| P-02 | 1652~1660 | btnVersion_Click 반환 검사 | 선택 버전 `Length > 2` | MSG00255 | Version 모달 다중선택 최대 2 (모달 내부 + 반환부 이중) |
| P-03 | 팝업 SetItem (팝업 .cs L318~324) | OK 시 선택 행 수 `iCnt > 2` | MSG00255 | 모달 내부 차단 (선택 초기화) |

## 3. Required 축 (Designer 실측)

| 조회조건 | 라벨 (Designer) | 필수 |
|---|---|---|
| Division | `Division*` (L1266) | ✅ (A-01) |
| Period | `Period*` (L1193) | ✅ (checkRequiredOfSearch) |
| Version | `Version*` (L1153) | ✅ (checkRequiredOfSearch — 기본값 = 최근 MF_W 2개 자동 세팅이라 통상 충족) |
| 나머지 (Team/End Customer/Biz Type/Sales Site/Plant Site/Project/Model·Nickname/Item Type/Owner/Bucket/QTY/Sum/Diff.Only) | 선택 | — |

## 4. 카운트 대사

- validation.md 17건 = D-01~10(10) + A-01~03 중 GMessageBox 3(#4~6) + G-01~04(4) → **17 ✓**
- analysis.md §16 5건(MSG00097/00108/00164/00109/00255) = A-01~03 + P-01 + P-02 → **5 ✓** (17건과 3건 중복 — 합집합 19 제약 = 본 문서 A3+D10+G4+P3 - P3(팝업측 중복 1) = 19행, 대사표 등재 시 P-03 은 MODAL 축)
