# 작업 원장 — SCP0020 · 2026-11-14 11:08

> 검사 인스턴스 555건 중 PASS·NA 345건 외 **210건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 이번 범위 밖(DB_ONLY). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W2 | 구현 위치 확인 | 1 | 구현 위치 실존 |
| W3 | 동작 수정 | 20 | 재판정 PASS |
| W7 | 기대값 확정 | 40 | 기대 확정 → PASS/FAIL |
| W9 | 도구 오류 | 149 | 원인 해소 → 재판정 |

- 담당: 하네스·환경 149 · 사람 판정 / AS-IS 원문 확인 → 재판정 38 · 화면 FE 10 · DB 객체 5 · DB 메타 5 · 대조표 3
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 0건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  | 4 |  |  |  | 5 |  | 26 | 대조표 행이 서술한 동작을 화면에서 재현 |
| X-LOC | GEN |  | 1 |  |  |  |  | 21 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| C3 | CASCADE |  |  |  |  |  |  |  |  | 19 | 연쇄 자동 채움 |
| C6 | CASCADE |  |  |  |  |  |  |  |  | 19 | 무변경 편집 종료 시 연쇄 미발동 |
| C2 | CASCADE |  |  |  |  |  |  |  |  | 15 | 그리드 셀 cascade 후보 |
| H2 | DESIGN |  |  |  |  |  |  |  |  | 12 | 배경·글자색 규칙 |
| D1 | EDIT |  |  | 6 |  |  |  |  |  | 5 | 컬럼 편집 가능 여부(신규행·기존행) |
| A1 | GEN |  |  |  |  |  |  | 11 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| E4 | EDIT |  |  | 3 |  |  |  |  |  | 7 | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| F4 | DB |  |  |  |  |  |  |  |  | 9 | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| D4 | EDIT |  |  |  |  |  |  |  |  | 9 | 신규행 기본값·자동세팅·Insert 전제 |
| D3 | EDIT |  |  | 5 |  |  |  |  |  | 2 | 행 값 기반 조건부 잠금 |
| H5 | DESIGN |  |  |  |  |  |  |  |  | 7 | 라벨 명칭 |
| A6 | GEN |  |  |  |  |  |  |  |  | 6 | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| B4 | COMBO |  |  |  |  |  |  |  |  | 3 | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| X-REASON | DESIGN |  |  |  |  |  |  | 2 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| C1 | CASCADE |  |  |  |  |  |  |  |  | 2 | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| F3 | CRUD |  |  |  |  |  |  |  |  | 2 | 붙여넣기 경로 → 값·검증·연쇄·저장 |
| A5 | DESIGN |  |  |  |  |  |  |  |  | 2 | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| F1 | CRUD |  |  | 1 |  |  |  |  |  |  | 저장 후 DB 반영(마커 행) |
| F6 | CRUD |  |  | 1 |  |  |  |  |  |  | 저장 후 값 보존 |
| G03-WIRE | GEN |  |  |  |  |  |  | 1 |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| K4 | COMMON |  |  |  |  |  |  |  |  | 1 | 버튼 구성·조건별 노출 |
| F2 | CRUD |  |  |  |  |  |  |  |  | 1 | 1회 저장(변경 감지) |
| H4 | DESIGN |  |  |  |  |  |  |  |  | 1 | 레이아웃·스크롤·크기 |
| I1 | DESIGN |  |  |  |  |  |  |  |  | 1 | LBL/MSG 언어별 등록 |

## W2 구현 위치 확인 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0020-0001 | X-LOC | 2 조회 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: modals/ItemSearchModal.tsx 없음 |  | 1 (2 조회) |

## W3 동작 수정 (20)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0020-0002 | F1 | SCP0020 화면 | DB 객체(PKG/SP)(적용 예정) | F1 FAIL 수정 — SCP0020 화면: 원장 V-1fe7d7c4 RULE_SCREEN / 원장 V-cbdbcee5 RULE_SCREEN / 원장 V-4c2a83d5 RULE_SCREEN / 원장 V-e0b9a849 RULE_SC |  | 526 (MSG00109/00199/00161/00004/00006/00043 S) |
| WK-SCP0020-0003 | F6 | SCP0020 화면 | DB 객체(PKG/SP)(적용 예정) | F6 FAIL 수정 — SCP0020 화면: 원장 V-d0cdb586 RULE_SCREEN / 원장 V-73e87eda RULE_SCREEN / 원장 V-76797303 RULE_SCREEN / 원장 V-b54abdfd RULE_SC |  | 510 (SCP0020_GET_TACT_TIME / _SAVE_TACT_TIME ) |
| WK-SCP0020-0004 | D1 | DAILY_CAPACITY / Daily Capacity | DB 메타(적용 예정) | D1 FAIL 수정 — DAILY_CAPACITY / Daily Capacity: 원장 V-2cb3d1c8 COLUMN / 원장 V-e1ee70d6 COLUMN / 원장 V-cd782314 COLUMN / 원장 V-b2b749fb C |  | 6 (ACT:SCP0020_TactTime.EditButton ACT:SCP0) |
| WK-SCP0020-0005 | D1 | LINE_ID / Line | DB 메타(적용 예정) | D1 FAIL 수정 — LINE_ID / Line: 원장 V-563f3ee2 COLUMN / 원장 V-ec4b5ef4 COLUMN / 원장 V-06a06639 COLUMN / 원장 V-d38ffb6e COLUMN / 원장 V-ed63 |  | 7 (ACT:SCP0020_TactTime.EditButton ACT:SCP0) |
| WK-SCP0020-0006 | D1 | LockColumn/LockRange (편집잠금 white-list) | DB 메타(적용 예정) | D1 FAIL 수정 — LockColumn/LockRange (편집잠금 white-list): 행 집계 — 대조표 LockColumn/LockRange (편집잠금 white-list) '32' 의 D1 22요소: NA:13 · ERR |  | 1 (LockColumn/LockRange (편집잠금 white-list)) |
| WK-SCP0020-0007 | D1 | OSP_YN | 화면 FE(범위 밖(가이드만)) | D1 FAIL 수정 — OSP_YN: 원장 V-f9568273 COLUMN / 원장 V-925710af COLUMN / 실측[T-2e417e77]: 기존행 r0 OSP_YN 편집=false (AS-IS 편집 가능) / 신규행 r0 O |  | 2 (ACT:SCP0020_TactTime.EditButton:611:27 A) |
| WK-SCP0020-0008 | D1 | SCP0020_TactTime.EditButton | DB 메타(적용 예정) | D1 FAIL 수정 — SCP0020_TactTime.EditButton: 진입점 집계 — 대조표 SCP0020_TactTime.EditButton 의 D1 17요소: NA:8 · ERROR:5 · FAIL:4 · FAIL 요소: L |  | 27 (ACT:SCP0020_TactTime.EditButton:550:1 AC) |
| WK-SCP0020-0009 | D1 | TACT_TIME / Tact Time | DB 메타(적용 예정) | D1 FAIL 수정 — TACT_TIME / Tact Time: 원장 V-b29dac91 COLUMN / 원장 V-354040a3 COLUMN / 원장 V-981382e4 COLUMN / 원장 V-115fb8dc COLUMN / 원장 |  | 9 (ACT:SCP0020_TactTime.EditButton ACT:SCP0) |
| WK-SCP0020-0010 | D3 | DAILY_CAPACITY / Daily Capacity | 화면 FE(범위 밖(가이드만)) | D3 FAIL 수정 — DAILY_CAPACITY / Daily Capacity: 원장 V-eacbd820 ASIS / 원장 V-cd75ee99 ASIS / 실측[T-ebc0db37]: DAILY_CAPACITY: AS-IS 에 행  |  | 6 (ACT:SCP0020_TactTime.EditButton ACT:SCP0) |
| WK-SCP0020-0011 | D3 | DAILY_CAPACITY,UOM_CONVERT_VALUE | 화면 FE(범위 밖(가이드만)) | D3 FAIL 수정 — DAILY_CAPACITY,UOM_CONVERT_VALUE: 원장 V-eacbd820 / 실측[T-b50a34c7]: DAILY_CAPACITY: AS-IS 에 행 조건 잠금(lock_rules ROW_COND |  | 1 (ACT:SCP0020_TactTime.EditButton:577:13) |
| WK-SCP0020-0012 | D3 | LockColumn/LockRange (편집잠금 white-list) | 화면 FE(범위 밖(가이드만)) | D3 FAIL 수정 — LockColumn/LockRange (편집잠금 white-list): 행 집계 — 대조표 LockColumn/LockRange (편집잠금 white-list) '32' 의 D3 36요소: PASS:22 · N |  | 1 (LockColumn/LockRange (편집잠금 white-list)) |
| WK-SCP0020-0013 | D3 | SCP0020_TactTime.EditButton | 화면 FE(범위 밖(가이드만)) | D3 FAIL 수정 — SCP0020_TactTime.EditButton: 원장 V-c52841e9 ASIS / 원장 V-061c7c98 ASIS / 원장 V-d4960312 ASIS / 원장 V-3398bd74 ASIS / 원장 V |  | 27 (ACT:SCP0020_TactTime.EditButton:550:1 AC) |
| WK-SCP0020-0014 | D3 | UOM_CONVERT_VALUE / UOM Convert | 화면 FE(범위 밖(가이드만)) | D3 FAIL 수정 — UOM_CONVERT_VALUE / UOM Convert: 원장 V-eacbd820 ASIS / 실측[T-3d812e45]: UOM_CONVERT_VALUE: AS-IS 에 행 조건 잠금(lock_rules R |  | 2 (ACT:SCP0020_TactTime.EditButton:577:13 A) |
| WK-SCP0020-0015 | E4 | MSG00043 | DB 객체(PKG/SP)(적용 예정) | E4 FAIL 수정 — MSG00043: 원장 V-2cb9b5d9 ASIS / 원장 V-c4c32967 ASIS / 원장 V-00c36130 ASIS / 원장 V-c7a15bd8 ASIS / 실측[T-002b8ffc]: MSG0004 |  | 4 (ACT:SCP0020_TactTime.SaveData_Except:227) |
| WK-SCP0020-0016 | E4 | MSG00043 | DB 객체(PKG/SP)(적용 예정) | E4 FAIL 수정 — MSG00043: 원장 V-00c36130 / 실측[T-7a230d44]: MSG00043: 위반 입력 자동 생성 불가(검사기 한계 — 화면 오류 아님 · 수동 검수 W7) — guard 'if (errCode |  | 1 (ACT:SCP0020_TactTime.SaveData_Main:1844:) |
| WK-SCP0020-0017 | E4 | MSG00043 | DB 객체(PKG/SP)(적용 예정) | E4 FAIL 수정 — MSG00043: 원장 V-c7a15bd8 / 실측[T-e6438da4]: MSG00043: 위반 입력 자동 생성 불가(검사기 한계 — 화면 오류 아님 · 수동 검수 W7) — guard 'if (errCode |  | 1 (ACT:SCP0020_TactTime.SaveData_Packer:160) |
| WK-SCP0020-0018 | X-ROW | SCP0020_TactTime.SaveData_Except | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0020_TactTime.SaveData_Except: 진입점 집계 25검사 — NA:12 · PASS:6 · ERROR:4 · FAIL:3 (FX-SCP0020-042) |  | 1 (ACT:SCP0020_TactTime.SaveData_Except:215) |
| WK-SCP0020-0019 | X-ROW | SCP0020_TactTime.SaveData_Except_Packer | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0020_TactTime.SaveData_Except_Packer: 진입점 집계 25검사 — NA:12 · PASS:6 · ERROR:4 · FAIL:3 (FX-SCP0020-045) |  | 1 (ACT:SCP0020_TactTime.SaveData_Except_Pac) |
| WK-SCP0020-0020 | X-ROW | SCP0020_TactTime.SaveData_Main | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0020_TactTime.SaveData_Main: 진입점 집계 29검사 — NA:10 · PASS:9 · ERROR:6 · FAIL:4 (FX-SCP0020-047) |  | 2 (ACT:SCP0020_TactTime.SaveData_Main:1687:) |
| WK-SCP0020-0021 | X-ROW | SCP0020_TactTime.SaveData_Packer | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0020_TactTime.SaveData_Packer: 진입점 집계 27검사 — PASS:11 · NA:10 · FAIL:4 · ERROR:2 (FX-SCP0020-049) |  | 3 (ACT:SCP0020_TactTime.SaveData_Packer:147) |

## W7 기대값 확정 (40)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0020-0022 | X-REASON | COMMON:UC-03 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-03 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후 재조회 유도  해당없음 — SCP0020 은 SHEET_COLUMNS 메타 구동 정적 |  | 1 (COMMON:UC-03) |
| WK-SCP0020-0023 | X-REASON | COMMON:UC-06 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-06 Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회  해당없음 — SCP0020 조회조건에 자유 텍스트 key-in 필드 없음. txtItemId 는 AS-IS Usr |  | 1 (COMMON:UC-06) |
| WK-SCP0020-0024 | A1 | 2 조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 2 조회: 행 집계 — 대조표 2 조회 'btnItemId / txtItemId' 의 A1 4요소: REVIEW:4 · FAIL 요소: PKG_SCP0020.P_SCP0020_GET_TACT — golden SK |  | 1 (2 조회) |
| WK-SCP0020-0025 | A1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-02: 행 집계 — 대조표 COMMON:UC-02 '데이터 수정 중 다른 데이터 조회 시도 = confirm 프롬프트' 의 A1 4요소: REVIEW:4 · FAIL 요소: PKG_SCP0020 |  | 1 (COMMON:UC-02) |
| WK-SCP0020-0026 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — 대조표 COMMON:UC-07 '필터가 걸린 상태에서 재조회해도 조회되고 필터도 그대로 적용' 의 A1 4요소: REVIEW:4 · FAIL 요소: PKG_SCP0020.P_ |  | 1 (COMMON:UC-07) |
| WK-SCP0020-0027 | A1 | PKG_SCP0020.P_SCP0020_GET_TACT_TIME | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0020.P_SCP0020_GET_TACT_TIME: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0020/SCP0020_GET_TACT_TIME.md —  |  | 47 (SCP0020_GET_TACT_TIME / _SAVE_TACT_TIME ) |
| WK-SCP0020-0028 | A1 | PKG_SCP0020.P_SCP0020_GET_TACT_TIME_EXCE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0020.P_SCP0020_GET_TACT_TIME_EXCEPT_OSP: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0020/SCP0020_GET_TACT |  | 34 (ACT:SCP0020_TactTime.FindData_Except_Pac) |
| WK-SCP0020-0029 | A1 | PKG_SCP0020.P_SCP0020_GET_TACT_TIME_OSP | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0020.P_SCP0020_GET_TACT_TIME_OSP: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0020/SCP0020_GET_TACT_TIME_O |  | 4 (SCP0020_GET_TACT_TIME_OSP / _SAVE_TACT_T) |
| WK-SCP0020-0030 | A1 | SCM0002 Item 팝업 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCM0002 Item 팝업: 행 집계 — 대조표 SCM0002 Item 팝업 '`itemSearch` SEARCH (확인 필요 — 별도 화면 SP)' 의 A1 4요소: REVIEW:4 · FAIL 요소: PKG |  | 1 (SCM0002 Item 팝업) |
| WK-SCP0020-0031 | A1 | SCP0020_GET_TACT_TIME_EXCEPT | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0020_GET_TACT_TIME_EXCEPT: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0020/SCP0020_GET_TACT_TIME_EXCEPT.md —  |  | 35 (SCP0020_GET_TACT_TIME_EXCEPT(_OSP) / _SA) |
| WK-SCP0020-0032 | A1 | SCP0020_TactTime.FindData_Main_MaxValue | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0020_TactTime.FindData_Main_MaxValue: 진입점 집계 — 대조표 SCP0020_TactTime.FindData_Main_MaxValue 의 A1 4요소: REVIEW:4 · FAI |  | 26 (ACT:SCP0020_TactTime.FindData_Main_MaxVa) |
| WK-SCP0020-0033 | A1 | SCP0020_TactTime.FindData_Packer_MaxValu | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0020_TactTime.FindData_Packer_MaxValue: 진입점 집계 — 대조표 SCP0020_TactTime.FindData_Packer_MaxValue 의 A1 4요소: REVIEW:4 · |  | 22 (ACT:SCP0020_TactTime.FindData_Packer_Max) |
| WK-SCP0020-0034 | A1 | btnItemId_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — btnItemId_Click: 행 집계 — 대조표 btnItemId_Click '2541' 의 A1 4요소: REVIEW:4 · FAIL 요소: PKG_SCP0020.P_SCP0020_GET_TACT — gold |  | 1 (btnItemId_Click) |
| WK-SCP0020-0035 | G03-WIRE | SCP0020 화면 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G03-WIRE 기대값 확정 — SCP0020 화면: 게이트 G03 As-is 이벤트 btnItemId.Click → btnItemId_Cl / 게이트 G03 As-is 이벤트 spdMain.EditModeOff → SpdMain_  |  | 18 (ACT:SCP0020_TactTime..ctor ACT:SCP0020_T) |
| WK-SCP0020-0036 | X-LOC | 1 Layout | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 1 Layout: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (1 Layout) |
| WK-SCP0020-0037 | X-LOC | ClbDivision_SelectedIndexChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — ClbDivision_SelectedIndexChanged: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (ClbDivision_SelectedIndexChanged) |
| WK-SCP0020-0038 | X-LOC | ClbPlantSite_SelectedIndexChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — ClbPlantSite_SelectedIndexChanged: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (ClbPlantSite_SelectedIndexChanged) |
| WK-SCP0020-0039 | X-LOC | MSG00002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00002: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00002) |
| WK-SCP0020-0040 | X-LOC | MSG00048 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00048: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00048) |
| WK-SCP0020-0041 | X-LOC | MSG00049 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00049: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00049) |
| WK-SCP0020-0042 | X-LOC | MSG00085 / MSG00072 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00085 / MSG00072: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00085 / MSG00072) |
| WK-SCP0020-0043 | X-LOC | MSG00105 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00105: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00105) |
| WK-SCP0020-0044 | X-LOC | MSG00108 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00108: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00108) |
| WK-SCP0020-0045 | X-LOC | MSG00109/00199/00161/00004/00006/00043 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00109/00199/00161/00004/00006/00043: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00109/00199/00161/00004/00006/00043) |
| WK-SCP0020-0046 | X-LOC | MSG00193 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00193: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00193) |
| WK-SCP0020-0047 | X-LOC | MSG00203 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00203: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00203) |
| WK-SCP0020-0048 | X-LOC | SCM0002 Item 팝업 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SCM0002 Item 팝업: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SCM0002 Item 팝업) |
| WK-SCP0020-0049 | X-LOC | SCP0020_GET_TACT_TIME / _SAVE_TACT_TIME | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SCP0020_GET_TACT_TIME / _SAVE_TACT_TIME: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SCP0020_GET_TACT_TIME / _SAVE_TACT_TIME) |
| WK-SCP0020-0050 | X-LOC | SCP0020_GET_TACT_TIME_EXCEPT(_OSP) / _SA | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SCP0020_GET_TACT_TIME_EXCEPT(_OSP) / _SAVE_TACT_TI: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SCP0020_GET_TACT_TIME_EXCEPT(_OSP) / _SA) |
| WK-SCP0020-0051 | X-LOC | SCP0020_GET_TACT_TIME_OSP / _SAVE_TACT_T | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SCP0020_GET_TACT_TIME_OSP / _SAVE_TACT_TIME_OSP: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SCP0020_GET_TACT_TIME_OSP / _SAVE_TACT_T) |
| WK-SCP0020-0052 | X-LOC | SmartColMerge | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SmartColMerge: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SmartColMerge) |
| WK-SCP0020-0053 | X-LOC | SpdMain_EditChange / EditModeOff | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SpdMain_EditChange / EditModeOff: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SpdMain_EditChange / EditModeOff) |
| WK-SCP0020-0054 | X-LOC | btnItemId_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — btnItemId_Click: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (btnItemId_Click) |
| WK-SCP0020-0055 | X-LOC | spdExcept_EditChange / EditModeOff | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — spdExcept_EditChange / EditModeOff: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (spdExcept_EditChange / EditModeOff) |
| WK-SCP0020-0056 | X-LOC | static 8 (GMessageBoxForException) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — static 8 (GMessageBoxForException): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (static 8 (GMessageBoxForException)) |
| WK-SCP0020-0057 | X-ROW | SCP0020_TactTime.Find_Data | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0020_TactTime.Find_Data: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 7 (ACT:SCP0020_TactTime.Find_Data ACT:SCP00) |
| WK-SCP0020-0058 | X-ROW | SCP0020_TactTime.RefreshLineByOperationO | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0020_TactTime.RefreshLineByOperationOfSpd: 진입점 동작 재현 시나리오 필요 — 문장 종류 DATA_OP/ENTRY/EXPR/LOCAL, 연결된 요소 검사 없음 |  | 8 (ACT:SCP0020_TactTime.RefreshLineByOperat) |
| WK-SCP0020-0059 | X-ROW | SCP0020_TactTime.SpdMain_EditChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0020_TactTime.SpdMain_EditChange: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/FLAG, 연결된 요소 검사 없음 |  | 3 (ACT:SCP0020_TactTime.SpdMain_EditChange ) |
| WK-SCP0020-0060 | X-ROW | SCP0020_TactTime.UnLockOnlyOSP | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0020_TactTime.UnLockOnlyOSP: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/EXPR/GRID_SET/LOCAL, 연결된 요소 검사 없음 |  | 8 (ACT:SCP0020_TactTime.UnLockOnlyOSP ACT:S) |
| WK-SCP0020-0061 | X-ROW | SCP0020_TactTime.spdExcept_EditChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0020_TactTime.spdExcept_EditChange: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/FLAG, 연결된 요소 검사 없음 |  | 3 (ACT:SCP0020_TactTime.spdExcept_EditChang) |

## W9 도구 오류 (149)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0020-0062 | C1 | ClbDivision_SelectedIndexChanged | 하네스·환경 | C1 도구 오류 — 실측[T-65ecd615]: 행 ClbDivision_SelectedIndexChanged() = 조회조건 C1 실측 상속: 상위 'Div' 에서 바꿀 옵션 없음(옵션 1개 또는 ALL 만) → 기계 판정 불가 — |  | 1 (ClbDivision_SelectedIndexChanged) |
| WK-SCP0020-0063 | C1 | cboDivision / Division / Div / Div. | 하네스·환경 | C1 도구 오류 — 원장 V-867ab4b0 SEARCH / 실측[T-64800891]: 상위 'Div' 에서 바꿀 옵션 없음(옵션 1개 또는 ALL 만) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (ACT:SCP0020_TactTime.InitControls:217:4) |
| WK-SCP0020-0064 | C2 | DAILY_CAPACITY / Daily Capacity | 하네스·환경 | C2 도구 오류 — 실측[T-cda99e5b]: DAILY_CAPACITY 연쇄 원천 해석 불가 — AS-IS SpdExcept_Changed:2673 siExcept.GetColumnIndex(DefColumns.DAILY_CAPA |  | 5 (ACT:SCP0020_TactTime.SpdExcept_Changed A) |
| WK-SCP0020-0065 | C2 | JUMBO_MIN / Jumbo / Min | 하네스·환경 | C2 도구 오류 — 실측[T-4a94b860]: JUMBO_MIN 연쇄 원천 해석 불가 — AS-IS SpdMain_Changed:2637 if (tactTime == "" // tactTime == null // lane == "" |  | 4 (ACT:SCP0020_TactTime.SpdMain_Changed ACT) |
| WK-SCP0020-0066 | C2 | LANE_QTY / Slitting Lane | 하네스·환경 | C2 도구 오류 — 실측[T-8d06a3ea]: LANE_QTY 연쇄 원천 해석 불가 — AS-IS SpdMain_Changed:2635 siMain.GetValue(nRow, siMain.GetColumnIndex(DefColumn |  | 3 (ACT:SCP0020_TactTime.SpdMain_Changed ACT) |
| WK-SCP0020-0067 | C2 | LINE_ID | 하네스·환경 | C2 도구 오류 — 원장 V-284d1a95 |  | 1 (ACT:SCP0020_TactTime.EditButton:641:44) |
| WK-SCP0020-0068 | C2 | OPERATION_GROUP_ID | 하네스·환경 | C2 도구 오류 — 실측[T-c0a267e4]: OPERATION_GROUP_ID 연쇄 원천 해석 불가 — AS-IS SpdMain_Changed:2630 siMain.ActiveSheet.GetText(nRow, siMain.Get |  | 3 (ACT:SCP0020_TactTime.SpdMain_Changed ACT) |
| WK-SCP0020-0069 | C2 | SCP0020_TactTime.ClbDivision_SelectedInd | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SCP0020_TactTime.ClbDivision_SelectedIndexChanged 의 C2 8요소: ERROR:8 |  | 3 (ACT:SCP0020_TactTime.ClbDivision_Selecte) |
| WK-SCP0020-0070 | C2 | SCP0020_TactTime.ClbPlantSite_SelectedIn | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SCP0020_TactTime.ClbPlantSite_SelectedIndexChanged 의 C2 8요소: ERROR:8 |  | 3 (ACT:SCP0020_TactTime.ClbPlantSite_Select) |
| WK-SCP0020-0071 | C2 | SCP0020_TactTime.SpdExcept_Changed | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SCP0020_TactTime.SpdExcept_Changed 의 C2 2요소: ERROR:2 |  | 11 (ACT:SCP0020_TactTime.SpdExcept_Changed:2) |
| WK-SCP0020-0072 | C2 | SCP0020_TactTime.SpdMain_ActiveSheetChan | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SCP0020_TactTime.SpdMain_ActiveSheetChanged 의 C2 8요소: ERROR:8 |  | 4 (ACT:SCP0020_TactTime.SpdMain_ActiveSheet) |
| WK-SCP0020-0073 | C2 | SCP0020_TactTime.SpdMain_Changed | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SCP0020_TactTime.SpdMain_Changed 의 C2 4요소: ERROR:4 |  | 11 (ACT:SCP0020_TactTime.SpdMain_Changed:260) |
| WK-SCP0020-0074 | C2 | SpdMain_EditChange / EditModeOff | 하네스·환경 | C2 도구 오류 — 행 집계 — 대조표 SpdMain_EditChange / EditModeOff '2806/2814' 의 C2 8요소: ERROR:8 |  | 1 (SpdMain_EditChange / EditModeOff) |
| WK-SCP0020-0075 | C2 | TACT_TIME / Tact Time | 하네스·환경 | C2 도구 오류 — 실측[T-e8251aa1]: TACT_TIME 연쇄 원천 해석 불가 — AS-IS SpdExcept_Changed:2678 if (dailyCapa == "" // dailyCapa == null) { siExce |  | 10 (MSG00203 ACT:SCP0020_TactTime.SpdExcept_) |
| WK-SCP0020-0076 | C2 | siMain.SetCellTypeCombo | 하네스·환경 | C2 도구 오류 — 원장 V-c0dd2769 |  | 1 (ACT:SCP0020_TactTime.SpdMain_CellClick:2) |
| WK-SCP0020-0077 | C2 | siMain.SetCellTypeCombo | 하네스·환경 | C2 도구 오류 — 원장 V-9df42a61 |  | 1 (ACT:SCP0020_TactTime.SpdMain_ClipboardPa) |
| WK-SCP0020-0078 | C2 | spdExcept_EditChange / EditModeOff | 하네스·환경 | C2 도구 오류 — 행 집계 — 대조표 spdExcept_EditChange / EditModeOff '2827/2835' 의 C2 8요소: ERROR:8 |  | 1 (spdExcept_EditChange / EditModeOff) |
| WK-SCP0020-0079 | C3 | JUMBO_MIN | 하네스·환경 | C3 도구 오류 — 원장 V-96b38348 |  | 1 (ACT:SCP0020_TactTime.SpdMain_Changed:263) |
| WK-SCP0020-0080 | C3 | JUMBO_MIN | 하네스·환경 | C3 도구 오류 — 원장 V-0621b399 |  | 1 (ACT:SCP0020_TactTime.SpdMain_Changed:264) |
| WK-SCP0020-0081 | C3 | JUMBO_MIN / Jumbo / Min | 하네스·환경 | C3 도구 오류 — 원장 V-96b38348 ASIS / 원장 V-0621b399 ASIS / 실측[T-654109e5]: JUMBO_MIN 연쇄 원천 컬럼 해석 불가 — AS-IS SpdMain_Changed:2637 if (tac |  | 4 (ACT:SCP0020_TactTime.SpdMain_Changed ACT) |
| WK-SCP0020-0082 | C3 | LINE_ID / Line | 하네스·환경 | C3 도구 오류 — 원장 V-cbf4495c ASIS / 실측[T-684bf239]: LINE_ID 연쇄 원천 컬럼 해석 불가 — AS-IS InsertButton:923 siExcept.SetValue(siExcept.ActiveR |  | 4 (ACT:SCP0020_TactTime.InsertButton:923:10) |
| WK-SCP0020-0083 | C3 | SCP0020_TactTime.ClbDivision_SelectedInd | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SCP0020_TactTime.ClbDivision_SelectedIndexChanged 의 C3 27요소: ERROR:12 · NA:12 · PASS:3 |  | 3 (ACT:SCP0020_TactTime.ClbDivision_Selecte) |
| WK-SCP0020-0084 | C3 | SCP0020_TactTime.ClbPlantSite_SelectedIn | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SCP0020_TactTime.ClbPlantSite_SelectedIndexChanged 의 C3 27요소: ERROR:12 · NA:12 · PASS:3 |  | 3 (ACT:SCP0020_TactTime.ClbPlantSite_Select) |
| WK-SCP0020-0085 | C3 | SCP0020_TactTime.SpdExcept_Changed | 하네스·환경 | C3 도구 오류 — 원장 V-0f2962f0 ASIS / 원장 V-6d4c6974 ASIS |  | 11 (ACT:SCP0020_TactTime.SpdExcept_Changed:2) |
| WK-SCP0020-0086 | C3 | SCP0020_TactTime.SpdMain_ActiveSheetChan | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SCP0020_TactTime.SpdMain_ActiveSheetChanged 의 C3 27요소: ERROR:12 · NA:12 · PASS:3 |  | 4 (ACT:SCP0020_TactTime.SpdMain_ActiveSheet) |
| WK-SCP0020-0087 | C3 | SCP0020_TactTime.SpdMain_Changed | 하네스·환경 | C3 도구 오류 — 원장 V-96b38348 ASIS / 원장 V-0621b399 ASIS |  | 11 (ACT:SCP0020_TactTime.SpdMain_Changed:260) |
| WK-SCP0020-0088 | C3 | SpdMain_EditChange / EditModeOff | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 SpdMain_EditChange / EditModeOff '2806/2814' 의 C3 27요소: ERROR:12 · NA:12 · PASS:3 |  | 1 (SpdMain_EditChange / EditModeOff) |
| WK-SCP0020-0089 | C3 | TACT_TIME | 하네스·환경 | C3 도구 오류 — 원장 V-0f2962f0 |  | 1 (ACT:SCP0020_TactTime.SpdExcept_Changed:2) |
| WK-SCP0020-0090 | C3 | TACT_TIME | 하네스·환경 | C3 도구 오류 — 원장 V-6d4c6974 |  | 1 (ACT:SCP0020_TactTime.SpdExcept_Changed:2) |
| WK-SCP0020-0091 | C3 | TACT_TIME | 하네스·환경 | C3 도구 오류 — 원장 V-be4eedaa |  | 1 (ACT:SCP0020_TactTime.SpdMain_Changed_Pac) |
| WK-SCP0020-0092 | C3 | TACT_TIME | 하네스·환경 | C3 도구 오류 — 원장 V-998a31e6 |  | 1 (ACT:SCP0020_TactTime.SpdMain_Changed_Pac) |
| WK-SCP0020-0093 | C3 | TACT_TIME / Tact Time | 하네스·환경 | C3 도구 오류 — 원장 V-0f2962f0 ASIS / 원장 V-6d4c6974 ASIS / 원장 V-be4eedaa ASIS / 원장 V-998a31e6 ASIS / 실측[T-b711e794]: TACT_TIME 연쇄 원천 컬럼  |  | 14 (MSG00203 ACT:SCP0020_TactTime.CheckDigit) |
| WK-SCP0020-0094 | C3 | USE_YN / Product YN | 하네스·환경 | C3 도구 오류 — 실측[T-77820910]: USE_YN 연쇄 원천 컬럼 해석 불가 — AS-IS InsertButton:925 siExcept.SetValue(siExcept.ActiveRowIndex, siExcept.GetC |  | 1 (ACT:SCP0020_TactTime.InsertButton:925:10) |
| WK-SCP0020-0095 | C3 | VALID_YN / Valid | 하네스·환경 | C3 도구 오류 — 실측[T-e3deeaf7]: 신규행 VALID_YN='' ↔ AS-IS InsertButton 기본값 "Y" 불일치 (값 대입은 연쇄가 아니라 Insert 기본값 — D4 와 같은 판정) → AS-IS 문장이 시트 |  | 1 (ACT:SCP0020_TactTime.InsertButton:789:26) |
| WK-SCP0020-0096 | C3 | siMain.SetValue | 하네스·환경 | C3 도구 오류 — 원장 V-cbf4495c |  | 1 (ACT:SCP0020_TactTime.SpdMain_ClipboardPa) |
| WK-SCP0020-0097 | C3 | spdExcept_EditChange / EditModeOff | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 spdExcept_EditChange / EditModeOff '2827/2835' 의 C3 27요소: ERROR:12 · NA:12 · PASS:3 |  | 1 (spdExcept_EditChange / EditModeOff) |
| WK-SCP0020-0098 | C6 | DAILY_CAPACITY / Daily Capacity | 하네스·환경 | C6 도구 오류 — 실측[T-aa21edf5]: DAILY_CAPACITY 연쇄 원천 해석 불가 — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미검증]  |  | 5 (ACT:SCP0020_TactTime.SpdExcept_Changed A) |
| WK-SCP0020-0099 | C6 | JUMBO_MIN | 하네스·환경 | C6 도구 오류 — 원장 V-2c7f90fe |  | 1 (ACT:SCP0020_TactTime.SpdMain_Changed:263) |
| WK-SCP0020-0100 | C6 | JUMBO_MIN | 하네스·환경 | C6 도구 오류 — 원장 V-27c27636 |  | 1 (ACT:SCP0020_TactTime.SpdMain_Changed:264) |
| WK-SCP0020-0101 | C6 | JUMBO_MIN / Jumbo / Min | 하네스·환경 | C6 도구 오류 — 원장 V-2c7f90fe ASIS / 원장 V-27c27636 ASIS |  | 4 (ACT:SCP0020_TactTime.SpdMain_Changed ACT) |
| WK-SCP0020-0102 | C6 | LANE_QTY / Slitting Lane | 하네스·환경 | C6 도구 오류 — 실측[T-39411b3e]: LANE_QTY 연쇄 원천 해석 불가 — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미검증] 검사기(_v |  | 3 (ACT:SCP0020_TactTime.SpdMain_Changed ACT) |
| WK-SCP0020-0103 | C6 | OPERATION_GROUP_ID | 하네스·환경 | C6 도구 오류 — 실측[T-d63bcdf7]: OPERATION_GROUP_ID 연쇄 원천 해석 불가 — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미 |  | 3 (ACT:SCP0020_TactTime.SpdMain_Changed ACT) |
| WK-SCP0020-0104 | C6 | SCP0020_TactTime.ClbDivision_SelectedInd | 하네스·환경 | C6 도구 오류 — 진입점 집계 — 대조표 SCP0020_TactTime.ClbDivision_SelectedIndexChanged 의 C6 12요소: ERROR:12 |  | 3 (ACT:SCP0020_TactTime.ClbDivision_Selecte) |
| WK-SCP0020-0105 | C6 | SCP0020_TactTime.ClbPlantSite_SelectedIn | 하네스·환경 | C6 도구 오류 — 진입점 집계 — 대조표 SCP0020_TactTime.ClbPlantSite_SelectedIndexChanged 의 C6 12요소: ERROR:12 |  | 3 (ACT:SCP0020_TactTime.ClbPlantSite_Select) |
| WK-SCP0020-0106 | C6 | SCP0020_TactTime.SpdExcept_Changed | 하네스·환경 | C6 도구 오류 — 원장 V-8fb7b586 ASIS / 원장 V-6fd504bc ASIS |  | 11 (ACT:SCP0020_TactTime.SpdExcept_Changed:2) |
| WK-SCP0020-0107 | C6 | SCP0020_TactTime.SpdMain_ActiveSheetChan | 하네스·환경 | C6 도구 오류 — 진입점 집계 — 대조표 SCP0020_TactTime.SpdMain_ActiveSheetChanged 의 C6 12요소: ERROR:12 |  | 4 (ACT:SCP0020_TactTime.SpdMain_ActiveSheet) |
| WK-SCP0020-0108 | C6 | SCP0020_TactTime.SpdMain_Changed | 하네스·환경 | C6 도구 오류 — 원장 V-2c7f90fe ASIS / 원장 V-27c27636 ASIS |  | 11 (ACT:SCP0020_TactTime.SpdMain_Changed:260) |
| WK-SCP0020-0109 | C6 | SpdMain_EditChange / EditModeOff | 하네스·환경 | C6 도구 오류 — 행 집계 — 대조표 SpdMain_EditChange / EditModeOff '2806/2814' 의 C6 12요소: ERROR:12 |  | 1 (SpdMain_EditChange / EditModeOff) |
| WK-SCP0020-0110 | C6 | TACT_TIME | 하네스·환경 | C6 도구 오류 — 원장 V-8fb7b586 |  | 1 (ACT:SCP0020_TactTime.SpdExcept_Changed:2) |
| WK-SCP0020-0111 | C6 | TACT_TIME | 하네스·환경 | C6 도구 오류 — 원장 V-6fd504bc |  | 1 (ACT:SCP0020_TactTime.SpdExcept_Changed:2) |
| WK-SCP0020-0112 | C6 | TACT_TIME | 하네스·환경 | C6 도구 오류 — 원장 V-75138b7b |  | 1 (ACT:SCP0020_TactTime.SpdMain_Changed_Pac) |
| WK-SCP0020-0113 | C6 | TACT_TIME | 하네스·환경 | C6 도구 오류 — 원장 V-4277e6e9 |  | 1 (ACT:SCP0020_TactTime.SpdMain_Changed_Pac) |
| WK-SCP0020-0114 | C6 | TACT_TIME / Tact Time | 하네스·환경 | C6 도구 오류 — 원장 V-8fb7b586 ASIS / 원장 V-6fd504bc ASIS / 원장 V-75138b7b ASIS / 원장 V-4277e6e9 ASIS |  | 10 (MSG00203 ACT:SCP0020_TactTime.SpdExcept_) |
| WK-SCP0020-0115 | C6 | siMain.SetValue | 하네스·환경 | C6 도구 오류 — 원장 V-03d5a428 |  | 1 (ACT:SCP0020_TactTime.SpdMain_ClipboardPa) |
| WK-SCP0020-0116 | C6 | spdExcept_EditChange / EditModeOff | 하네스·환경 | C6 도구 오류 — 행 집계 — 대조표 spdExcept_EditChange / EditModeOff '2827/2835' 의 C6 12요소: ERROR:12 |  | 1 (spdExcept_EditChange / EditModeOff) |
| WK-SCP0020-0117 | B4 | COMMON:UC-05 | 하네스·환경 | B4 도구 오류 — 행 집계 — 대조표 COMMON:UC-05 'Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력' 의 B4 2요소: ERROR:2 |  | 1 (COMMON:UC-05) |
| WK-SCP0020-0118 | B4 | LINE_ID / Line | 하네스·환경 | B4 도구 오류 — 원장 V-7af924cf COLUMN / 원장 V-46b069bc COLUMN / 원장 V-6fda4be2 COLUMN / 원장 V-aafafcba COLUMN |  | 3 (ACT:SCP0020_TactTime.EditButton:641:44 A) |
| WK-SCP0020-0119 | B4 | cboOperationGroup / Operation Group / Op | 하네스·환경 | B4 도구 오류 — 원장 V-5f2c9d3e SEARCH |  | 0 () |
| WK-SCP0020-0120 | K4 | SCP0020 화면 | 하네스·환경 | K4 도구 오류 — 원장 V-fb6d8961 GENERAL / 원장 V-674e63fe GENERAL / 원장 V-6ead2fdc GENERAL / 원장 V-52bb43e2 GENERAL / 원장 V-746ebc82 GENERAL / |  | 17 (COMMON:UC-01 COMMON:UC-02 COMMON:UC-04 C) |
| WK-SCP0020-0121 | F2 | SCP0020 화면 | 하네스·환경 | F2 도구 오류 — 원장 V-b93c13ca RULE_SCREEN / 원장 V-efe6dfcc RULE_SCREEN / 원장 V-51ff7409 RULE_SCREEN / 원장 V-9c928393 GENERAL / 원장 V-999d26 |  | 511 (MSG00109/00199/00161/00004/00006/00043 S) |
| WK-SCP0020-0122 | F3 | SCP0020 화면 | 하네스·환경 | F3 도구 오류 — 원장 V-16def5e2 RULE_SCREEN / 원장 V-b2a1f314 RULE_SCREEN / 원장 V-9a8e24a0 RULE_SCREEN / 원장 V-a12bffa9 RULE_SCREEN / 원장 V-a4 |  | 28 (ACT:SCP0020_TactTime.SpdMain_ClipboardPa) |
| WK-SCP0020-0123 | F3 | siMain.SetCellTypeCombo | 하네스·환경 | F3 도구 오류 — 원장 V-b0f1f11f / 실측[T-86cddb40]: 붙여넣기 프로브 전제 부족(기존행 true · 신규행 false) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (ACT:SCP0020_TactTime.SpdMain_ClipboardPa) |
| WK-SCP0020-0124 | F4 | PKG_SCP0020.P_SCP0020_GET_TACT_TIME | 하네스·환경 | F4 도구 오류 — 실측[T-dc810292]: PKG_SCP0020.P_SCP0020_GET_TACT_TIME: SCP0020/plant/SEARCH — 화면 진입·조회 중 호출 없음(셀 이벤트·팝업 조회 경로 — 해당 시나리오에서 |  | 184 (SCP0020_GET_TACT_TIME / _SAVE_TACT_TIME ) |
| WK-SCP0020-0125 | F4 | PKG_SCP0020.P_SCP0020_GET_TACT_TIME_EXCE | 하네스·환경 | F4 도구 오류 — 실측[T-b8364860]: PKG_SCP0020.P_SCP0020_GET_TACT_TIME_EXCEPT_OSP: SCP0020/except/SEARCH — 화면 진입·조회 중 호출 없음(셀 이벤트·팝업 조회 경로 |  | 175 (ACT:SCP0020_TactTime.FindData_Except_Pac) |
| WK-SCP0020-0126 | F4 | PKG_SCP0020.P_SCP0020_SAVE_TACT_TIME | 하네스·환경 | F4 도구 오류 — 실측[T-f7f0be28]: [측정 경로 없음] PKG_SCP0020.P_SCP0020_SAVE_TACT_TIME: 이번 Save 는 packer/SAVE 로 저장(정상 호출) — 이 SP 경로 plant/SAVE |  | 138 (ACT:SCP0020_TactTime.SaveButton ACT:SCP0) |
| WK-SCP0020-0127 | F4 | PKG_SCP0020.P_SCP0020_SAVE_TACT_TIME_EXC | 하네스·환경 | F4 도구 오류 — 실측[T-2ccae355]: [측정 경로 없음] PKG_SCP0020.P_SCP0020_SAVE_TACT_TIME_EXCEPT_OSP: 이번 Save 는 packer/SAVE 로 저장(정상 호출) — 이 SP 경로 |  | 142 (ACT:SCP0020_TactTime.SaveButton ACT:SCP0) |
| WK-SCP0020-0128 | F4 | SCM0002 Item 팝업 | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 SCM0002 Item 팝업 '`itemSearch` SEARCH (확인 필요 — 별도 화면 SP)' 의 F4 8요소: ERROR:6 · PASS:2 |  | 1 (SCM0002 Item 팝업) |
| WK-SCP0020-0129 | F4 | SCP0020_GET_TACT_TIME_EXCEPT | 하네스·환경 | F4 도구 오류 — 실측[T-514fa8d9]: SCP0020_GET_TACT_TIME_EXCEPT: SCP0020/except/SEARCH — 화면 진입·조회 중 호출 없음(셀 이벤트·팝업 조회 경로 — 해당 시나리오에서 판정) → |  | 173 (SCP0020_GET_TACT_TIME_EXCEPT(_OSP) / _SA) |
| WK-SCP0020-0130 | F4 | SCP0020_SAVE_TACT_TIME_EXCEPT | 하네스·환경 | F4 도구 오류 — 실측[T-7851fe56]: [측정 경로 없음] SCP0020_SAVE_TACT_TIME_EXCEPT: 이번 Save 는 packer/SAVE 로 저장(정상 호출) — 이 SP 경로 except/SAVE 는 다른  |  | 139 (ACT:SCP0020_TactTime.SaveButton ACT:SCP0) |
| WK-SCP0020-0131 | F4 | SCP0020_TactTime.FindData_Main_MaxValue | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 SCP0020_TactTime.FindData_Main_MaxValue 의 F4 8요소: ERROR:6 · PASS:2 |  | 26 (ACT:SCP0020_TactTime.FindData_Main_MaxVa) |
| WK-SCP0020-0132 | F4 | SCP0020_TactTime.FindData_Packer_MaxValu | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 SCP0020_TactTime.FindData_Packer_MaxValue 의 F4 8요소: ERROR:6 · PASS:2 |  | 22 (ACT:SCP0020_TactTime.FindData_Packer_Max) |
| WK-SCP0020-0133 | A5 | SCP0020_TactTime.CreateSpread | 하네스·환경 | A5 도구 오류 — 실측[T-9ed8bef3]: AS-IS 기본 표시 컬럼 3 ⊆ TO-BE 그리드 14: 누락 ACTUAL_CAPACITY, BIG_LAST_UPDATE_DATE, BIG_TACT_TIME (AS-IS 숨김·코드추가 |  | 10 (ACT:SCP0020_TactTime.CreateSpread:374:1 ) |
| WK-SCP0020-0134 | A5 | SCP0020_TactTime.SetSpreadInit | 하네스·환경 | A5 도구 오류 — 실측[T-5c46be1b]: AS-IS 기본 표시 컬럼 3 ⊆ TO-BE 그리드 14: 누락 ACTUAL_CAPACITY, BIG_LAST_UPDATE_DATE, BIG_TACT_TIME (AS-IS 숨김·코드추가 |  | 10 (ACT:SCP0020_TactTime.SetSpreadInit:433:1) |
| WK-SCP0020-0135 | H2 | 3 그리드 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 3 그리드 'spdExcept' 의 H2 19요소: PASS:7 · NA:6 · ERROR:6 |  | 1 (3 그리드) |
| WK-SCP0020-0136 | H2 | COMMON:UC-01 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 COMMON:UC-01 '필터링 상태에서 신규행 Insert 시 필터를 유지한 채 추가 행이 보이도록 (keepRo' 의 H2 19요소: PASS:7 · NA:6 · ERROR:6 |  | 1 (COMMON:UC-01) |
| WK-SCP0020-0137 | H2 | COMMON:UC-05 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 COMMON:UC-05 'Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력' 의 H2 19요소: PASS:7 · NA:6 · ERROR:6 |  | 1 (COMMON:UC-05) |
| WK-SCP0020-0138 | H2 | COMMON:UC-07 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 COMMON:UC-07 '필터가 걸린 상태에서 재조회해도 조회되고 필터도 그대로 적용' 의 H2 19요소: PASS:7 · NA:6 · ERROR:6 |  | 1 (COMMON:UC-07) |
| WK-SCP0020-0139 | H2 | SCP0020_TactTime.CreateSpread | 하네스·환경 | H2 도구 오류 — 진입점 집계 — 대조표 SCP0020_TactTime.CreateSpread 의 H2 19요소: PASS:7 · NA:6 · ERROR:6 |  | 10 (ACT:SCP0020_TactTime.CreateSpread:374:1 ) |
| WK-SCP0020-0140 | H2 | SmartColMerge | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 SmartColMerge '9' 의 H2 19요소: PASS:7 · NA:6 · ERROR:6 |  | 1 (SmartColMerge) |
| WK-SCP0020-0141 | H2 | siExcept.SetBGColor | 하네스·환경 | H2 도구 오류 — 원장 V-8ebf79bf |  | 1 (ACT:SCP0020_TactTime.checkValidN5:2390:7) |
| WK-SCP0020-0142 | H2 | siExcept.SetBGColor | 하네스·환경 | H2 도구 오류 — 원장 V-f9a5c590 |  | 1 (ACT:SCP0020_TactTime.checkValidN5:2436:4) |
| WK-SCP0020-0143 | H2 | siExcept.SetBGColor | 하네스·환경 | H2 도구 오류 — 원장 V-91c924b3 |  | 1 (ACT:SCP0020_TactTime.checkValidN5:2437:4) |
| WK-SCP0020-0144 | H2 | siExcept.SetBGColor | 하네스·환경 | H2 도구 오류 — 원장 V-96d41ec7 |  | 1 (ACT:SCP0020_TactTime.checkValidN8:2467:7) |
| WK-SCP0020-0145 | H2 | siExcept.SetBGColor | 하네스·환경 | H2 도구 오류 — 원장 V-33614bde |  | 1 (ACT:SCP0020_TactTime.checkValidN8:2482:1) |
| WK-SCP0020-0146 | H2 | siExcept.SetBGColor | 하네스·환경 | H2 도구 오류 — 원장 V-2672ac9c |  | 1 (ACT:SCP0020_TactTime.checkValidN8:2495:2) |
| WK-SCP0020-0147 | H4 | SCP0020 화면 | 하네스·환경 | H4 도구 오류 — 원장 V-7efbfc20 RULE_SCREEN / 원장 V-6bbc1f1f RULE_SCREEN / 원장 V-25a0f3da RULE_SCREEN / 원장 V-b051ba1c RULE_SCREEN / 원장 V-03 |  | 8 (ACT:SCP0020_TactTime.SpdExcept_TopChange) |
| WK-SCP0020-0148 | H5 | 3 그리드 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 3 그리드 'spdExcept' 의 H5 3요소: PASS:2 · ERROR:1 |  | 1 (3 그리드) |
| WK-SCP0020-0149 | H5 | COMMON:UC-01 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 COMMON:UC-01 '필터링 상태에서 신규행 Insert 시 필터를 유지한 채 추가 행이 보이도록 (keepRo' 의 H5 3요소: PASS:2 · ERROR:1 |  | 1 (COMMON:UC-01) |
| WK-SCP0020-0150 | H5 | COMMON:UC-05 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 COMMON:UC-05 'Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력' 의 H5 3요소: PASS:2 · ERROR:1 |  | 1 (COMMON:UC-05) |
| WK-SCP0020-0151 | H5 | COMMON:UC-07 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 COMMON:UC-07 '필터가 걸린 상태에서 재조회해도 조회되고 필터도 그대로 적용' 의 H5 3요소: PASS:2 · ERROR:1 |  | 1 (COMMON:UC-07) |
| WK-SCP0020-0152 | H5 | OPERATION_NAME / Operation | 하네스·환경 | H5 도구 오류 — 실측[T-e065e5cb]: OPERATION_NAME 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 3 (ACT:SCP0020_TactTime.InitSpread ACT:SCP0) |
| WK-SCP0020-0153 | H5 | SCP0020_TactTime.CreateSpread | 하네스·환경 | H5 도구 오류 — 진입점 집계 — 대조표 SCP0020_TactTime.CreateSpread 의 H5 3요소: PASS:2 · ERROR:1 |  | 10 (ACT:SCP0020_TactTime.CreateSpread:374:1 ) |
| WK-SCP0020-0154 | H5 | SmartColMerge | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 SmartColMerge '9' 의 H5 3요소: PASS:2 · ERROR:1 |  | 1 (SmartColMerge) |
| WK-SCP0020-0155 | I1 | SCP0020 화면 | 하네스·환경 | I1 도구 오류 — 원장 V-c13b8fb8 RULE_SCREEN / 원장 V-38a3eb9e RULE_SCREEN / 원장 V-d834b5fe RULE_SCREEN / 원장 V-978d36ad DEFECT / 원장 V-96052c4 |  | 58 (MSG00193 MSG00085 / MSG00072 MSG00002 MS) |
| WK-SCP0020-0156 | D1 | CREATED_BY / Created By | 하네스·환경 | D1 도구 오류 — 원장 V-676ebcdd COLUMN / 원장 V-80443d73 COLUMN / 원장 V-4b7dfa7c COLUMN / 원장 V-80030852 COLUMN / 원장 V-5c4313a8 COLUMN / 원장 V |  | 2 (ACT:SCP0020_TactTime.EditButton:677:60 A) |
| WK-SCP0020-0157 | D1 | DIVISION_ID / Division | 하네스·환경 | D1 도구 오류 — 원장 V-e9c992e1 COLUMN / 원장 V-481edd07 COLUMN / 원장 V-d5427c90 COLUMN / 원장 V-237d8ba4 COLUMN / 원장 V-c525b1e8 COLUMN / 원장 V |  | 9 (ACT:SCP0020_TactTime.EditButton ACT:SCP0) |
| WK-SCP0020-0158 | D1 | LANE_QTY / Slitting Lane | 하네스·환경 | D1 도구 오류 — 원장 V-bc9e4c4c COLUMN / 원장 V-e38156be COLUMN / 원장 V-96fd41b5 COLUMN / 원장 V-6780c43e COLUMN / 실측[T-e5910d5c]: 기존행 r0 LANE |  | 4 (ACT:SCP0020_TactTime.EditButton ACT:SCP0) |
| WK-SCP0020-0159 | D1 | LAST_UPDATE_DATE / Last Update Date | 하네스·환경 | D1 도구 오류 — 원장 V-77ce707f COLUMN / 원장 V-01c6c623 COLUMN / 원장 V-4ef86102 COLUMN / 원장 V-923c0e33 COLUMN / 원장 V-09eef13e COLUMN / 원장 V |  | 2 (ACT:SCP0020_TactTime.EditButton:677:60 A) |
| WK-SCP0020-0160 | D1 | NICK_NAME / Nick Name | 하네스·환경 | D1 도구 오류 — 원장 V-c40f7ed1 COLUMN / 원장 V-2a28d671 COLUMN / 원장 V-1db1c538 COLUMN / 원장 V-91005963 COLUMN / 원장 V-fe44fb3c COLUMN / 원장 V |  | 4 (ACT:SCP0020_TactTime.EditButton:568:9 AC) |
| WK-SCP0020-0161 | D3 | TACT_TIME / Tact Time | 하네스·환경 | D3 도구 오류 — 원장 V-3398bd74 ASIS / 원장 V-29fef4d4 ASIS / 원장 V-ccc2430e ASIS / 실측[T-7d112a78]: TACT_TIME: AS-IS 에 행 조건 잠금(lock_rules RO |  | 9 (ACT:SCP0020_TactTime.EditButton ACT:SCP0) |
| WK-SCP0020-0162 | D3 | TACT_TIME,TACT_TIME | 하네스·환경 | D3 도구 오류 — 원장 V-ccc2430e / 실측[T-a5519709]: TACT_TIME: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:SCP0020_TactTime.EditButton:684:64) |
| WK-SCP0020-0163 | D4 | COMMON:UC-01 | 하네스·환경 | D4 도구 오류 — 행 집계 — 대조표 COMMON:UC-01 '필터링 상태에서 신규행 Insert 시 필터를 유지한 채 추가 행이 보이도록 (keepRo' 의 D4 67요소: PASS:33 · NA:29 · ERROR:5 |  | 1 (COMMON:UC-01) |
| WK-SCP0020-0164 | D4 | LINE_ID | 하네스·환경 | D4 도구 오류 — 원장 V-80f68d85 |  | 1 (ACT:SCP0020_TactTime.InsertButton:864:69) |
| WK-SCP0020-0165 | D4 | LINE_ID | 하네스·환경 | D4 도구 오류 — 원장 V-0f66d40c |  | 1 (ACT:SCP0020_TactTime.InsertButton:923:10) |
| WK-SCP0020-0166 | D4 | LINE_ID / Line | 하네스·환경 | D4 도구 오류 — 원장 V-80f68d85 ASIS / 원장 V-85557f3f ASIS / 원장 V-0f66d40c ASIS / 원장 V-583b7fab ASIS / 실측[T-19fa0dd9]: 신규행 LINE_ID='' — AS |  | 4 (ACT:SCP0020_TactTime.InsertButton:864:69) |
| WK-SCP0020-0167 | D4 | MSG00002 | 하네스·환경 | D4 도구 오류 — 원장 V-85557f3f |  | 1 (ACT:SCP0020_TactTime.InsertButton:910:93) |
| WK-SCP0020-0168 | D4 | MSG00109/00199/00161/00004/00006/00043 | 하네스·환경 | D4 도구 오류 — 행 집계 — 대조표 MSG00109/00199/00161/00004/00006/00043 '읽기전용/작업중/Insert/저장확인·결과' 의 D4 67요소: PASS:33 · NA:29 · ERROR:5 |  | 1 (MSG00109/00199/00161/00004/00006/00043) |
| WK-SCP0020-0169 | D4 | MSG00161 | 하네스·환경 | D4 도구 오류 — 원장 V-ee3d0804 |  | 1 (ACT:SCP0020_TactTime.InsertButton:875:73) |
| WK-SCP0020-0170 | D4 | SetValue Insert 기본값 | 하네스·환경 | D4 도구 오류 — 행 집계 — 대조표 SetValue Insert 기본값 '27' 의 D4 67요소: PASS:33 · NA:29 · ERROR:5 |  | 1 (SetValue Insert 기본값) |
| WK-SCP0020-0171 | D4 | SetValue 파생 Auto-Sync | 하네스·환경 | D4 도구 오류 — 행 집계 — 대조표 SetValue 파생 Auto-Sync '9' 의 D4 67요소: PASS:33 · NA:29 · ERROR:5 |  | 1 (SetValue 파생 Auto-Sync) |
| WK-SCP0020-0172 | E4 | MSG00002 | 하네스·환경 | E4 도구 오류 — 원장 V-ad39058d ASIS / 실측[T-bc32369f]: MSG00002 — InsertButton 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(InsertB |  | 3 (MSG00002 ACT:SCP0020_TactTime.InsertButt) |
| WK-SCP0020-0173 | E4 | MSG00002 | 하네스·환경 | E4 도구 오류 — 원장 V-ad39058d / 실측[T-5a6edfa0]: MSG00002 — InsertButton 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(InsertButton |  | 1 (ACT:SCP0020_TactTime.SaveData_Main:1750:) |
| WK-SCP0020-0174 | E4 | MSG00161 | 하네스·환경 | E4 도구 오류 — 실측[T-342b61d4]: MSG00161 — InsertButton 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(InsertButton)에서 판정 → 기계 판정 불 |  | 1 (ACT:SCP0020_TactTime.InsertButton:875:73) |
| WK-SCP0020-0175 | E4 | MSG00203 | 하네스·환경 | E4 도구 오류 — 원장 V-7d30157b ASIS / 원장 V-9476eb39 ASIS / 실측[T-7290a305]: MSG00203 — CheckDigitValueEntered 경로 메시지(저장 전 검증 아님 · Save 진입 |  | 3 (MSG00203 ACT:SCP0020_TactTime.CheckDigit) |
| WK-SCP0020-0176 | E4 | MSG00203 | 하네스·환경 | E4 도구 오류 — 원장 V-7d30157b / 실측[T-18449119]: MSG00203 — CheckDigitValueEntered 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(Ch |  | 1 (ACT:SCP0020_TactTime.CheckDigitValueEnte) |
| WK-SCP0020-0177 | E4 | MSG00203 | 하네스·환경 | E4 도구 오류 — 원장 V-9476eb39 / 실측[T-5871045e]: MSG00203 — CheckDigitValueEntered 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(Ch |  | 1 (ACT:SCP0020_TactTime.CheckDigitValueEnte) |
| WK-SCP0020-0178 | E4 | TACT_TIME / Tact Time | 하네스·환경 | E4 도구 오류 — 원장 V-7d30157b ASIS / 원장 V-9476eb39 ASIS / 원장 V-475c7546 ASIS / 원장 V-24de3723 ASIS / 원장 V-912534c6 ASIS / 원장 V-090c326a  |  | 4 (MSG00193 MSG00203 ACT:SCP0020_TactTime.C) |
| WK-SCP0020-0179 | A6 | PKG_SCP0020.P_SCP0020_GET_TACT_TIME | 하네스·환경 | A6 도구 오류 — 원장 V-c900de01 SP / 정렬대조 PASS 분기 키 순서 동일 / 실측[T-f62dc96e]: PKG_SCP0020.P_SCP0020_GET_TACT_TIME: 화면 진입·조회 경로에서 이 SP 가 결과를 |  | 47 (SCP0020_GET_TACT_TIME / _SAVE_TACT_TIME ) |
| WK-SCP0020-0180 | A6 | PKG_SCP0020.P_SCP0020_GET_TACT_TIME_EXCE | 하네스·환경 | A6 도구 오류 — 원장 V-ff2c434f SP / 정렬대조 PASS 분기 키 순서 동일 / 실측[T-defcf803]: PKG_SCP0020.P_SCP0020_GET_TACT_TIME_EXCEPT_OSP: 화면 진입·조회 경로에서 |  | 34 (ACT:SCP0020_TactTime.FindData_Except_Pac) |
| WK-SCP0020-0181 | A6 | SCM0002 Item 팝업 | 하네스·환경 | A6 도구 오류 — 행 집계 — 대조표 SCM0002 Item 팝업 '`itemSearch` SEARCH (확인 필요 — 별도 화면 SP)' 의 A6 4요소: ERROR:3 · PASS:1 |  | 1 (SCM0002 Item 팝업) |
| WK-SCP0020-0182 | A6 | SCP0020_GET_TACT_TIME_EXCEPT | 하네스·환경 | A6 도구 오류 — 원장 V-4cc685ab SP / 정렬대조 REVIEW TO-BE 프로시저 배선(PROC_M) 없음 — 대응 프로시저 확인 / 실측[T-e87acdd9]: SCP0020_GET_TACT_TIME_EXCEPT: 화면 |  | 35 (SCP0020_GET_TACT_TIME_EXCEPT(_OSP) / _SA) |
| WK-SCP0020-0183 | A6 | SCP0020_TactTime.FindData_Main_MaxValue | 하네스·환경 | A6 도구 오류 — 진입점 집계 — 대조표 SCP0020_TactTime.FindData_Main_MaxValue 의 A6 4요소: ERROR:3 · PASS:1 |  | 26 (ACT:SCP0020_TactTime.FindData_Main_MaxVa) |
| WK-SCP0020-0184 | A6 | SCP0020_TactTime.FindData_Packer_MaxValu | 하네스·환경 | A6 도구 오류 — 진입점 집계 — 대조표 SCP0020_TactTime.FindData_Packer_MaxValue 의 A6 4요소: ERROR:3 · PASS:1 |  | 22 (ACT:SCP0020_TactTime.FindData_Packer_Max) |
| WK-SCP0020-0185 | X-ROW | SCP0020_TactTime.CheckDigitValueEntered | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 6검사 — ERROR:6 |  | 21 (ACT:SCP0020_TactTime.CheckDigitValueEnte) |
| WK-SCP0020-0186 | X-ROW | SCP0020_TactTime.ClbDivision_SelectedInd | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0020_TactTime.ClbDivision_Selecte) |
| WK-SCP0020-0187 | X-ROW | SCP0020_TactTime.ClbPlantSite_SelectedIn | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0020_TactTime.ClbPlantSite_Select) |
| WK-SCP0020-0188 | X-ROW | SCP0020_TactTime.CreateSpread | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:3 · ERROR:1 |  | 1 (ACT:SCP0020_TactTime.CreateSpread) |
| WK-SCP0020-0189 | X-ROW | SCP0020_TactTime.FindButton | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 6검사 — ERROR:2 · REVIEW:2 · PASS:2 |  | 1 (ACT:SCP0020_TactTime.FindButton) |
| WK-SCP0020-0190 | X-ROW | SCP0020_TactTime.FindData_Except | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 8검사 — ERROR:3 · NA:2 · PASS:2 · REVIEW:1 |  | 7 (ACT:SCP0020_TactTime.FindData_Except ACT) |
| WK-SCP0020-0191 | X-ROW | SCP0020_TactTime.FindData_Except_Packer | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 8검사 — ERROR:3 · PASS:2 · NA:2 · REVIEW:1 |  | 7 (ACT:SCP0020_TactTime.FindData_Except_Pac) |
| WK-SCP0020-0192 | X-ROW | SCP0020_TactTime.FindData_Main | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 15검사 — PASS:6 · NA:5 · ERROR:3 · REVIEW:1 |  | 10 (ACT:SCP0020_TactTime.FindData_Main:1030:) |
| WK-SCP0020-0193 | X-ROW | SCP0020_TactTime.FindData_Main_MaxValue | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 11검사 — ERROR:3 · NA:3 · PASS:3 · REVIEW:1 · NOPATH:1 |  | 4 (ACT:SCP0020_TactTime.FindData_Main_MaxVa) |
| WK-SCP0020-0194 | X-ROW | SCP0020_TactTime.FindData_Packer_MaxValu | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 10검사 — ERROR:3 · NA:3 · PASS:2 · REVIEW:1 · NOPATH:1 |  | 4 (ACT:SCP0020_TactTime.FindData_Packer_Max) |
| WK-SCP0020-0195 | X-ROW | SCP0020_TactTime.Find_Packer | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 8검사 — NA:3 · PASS:3 · REVIEW:1 · ERROR:1 |  | 41 (ACT:SCP0020_TactTime.Find_Packer ACT:SCP) |
| WK-SCP0020-0196 | X-ROW | SCP0020_TactTime.InitControls | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 11검사 — PASS:9 · NA:1 · ERROR:1 |  | 5 (ACT:SCP0020_TactTime.InitControls:215:3 ) |
| WK-SCP0020-0197 | X-ROW | SCP0020_TactTime.InitSpread | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 11검사 — PASS:6 · NA:4 · ERROR:1 |  | 7 (ACT:SCP0020_TactTime.InitSpread ACT:SCP0) |
| WK-SCP0020-0198 | X-ROW | SCP0020_TactTime.SetSpreadInit | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 12검사 — PASS:7 · NA:4 · ERROR:1 |  | 3 (ACT:SCP0020_TactTime.SetSpreadInit:437:4) |
| WK-SCP0020-0199 | X-ROW | SCP0020_TactTime.SpdExcept_Changed | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 13검사 — ERROR:12 · NA:1 |  | 2 (ACT:SCP0020_TactTime.SpdExcept_Changed:2) |
| WK-SCP0020-0200 | X-ROW | SCP0020_TactTime.SpdExcept_TopChange | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 2 (ACT:SCP0020_TactTime.SpdExcept_TopChange) |
| WK-SCP0020-0201 | X-ROW | SCP0020_TactTime.SpdMain_ActiveSheetChan | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0020_TactTime.SpdMain_ActiveSheet) |
| WK-SCP0020-0202 | X-ROW | SCP0020_TactTime.SpdMain_CellClick | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — PASS:3 · ERROR:2 |  | 11 (ACT:SCP0020_TactTime.SpdMain_CellClick A) |
| WK-SCP0020-0203 | X-ROW | SCP0020_TactTime.SpdMain_Changed | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 19검사 — ERROR:17 · NA:2 |  | 2 (ACT:SCP0020_TactTime.SpdMain_Changed:263) |
| WK-SCP0020-0204 | X-ROW | SCP0020_TactTime.SpdMain_Changed_Packer | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — ERROR:5 |  | 16 (ACT:SCP0020_TactTime.SpdMain_Changed_Pac) |
| WK-SCP0020-0205 | X-ROW | SCP0020_TactTime.SpdMain_ClipboardPasted | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 13검사 — NA:7 · ERROR:6 |  | 2 (ACT:SCP0020_TactTime.SpdMain_ClipboardPa) |
| WK-SCP0020-0206 | X-ROW | SCP0020_TactTime.SpdMain_TopChange | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 2 (ACT:SCP0020_TactTime.SpdMain_TopChange A) |
| WK-SCP0020-0207 | X-ROW | SCP0020_TactTime.btnItemId_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 9검사 — PASS:6 · NA:2 · ERROR:1 |  | 5 (ACT:SCP0020_TactTime.btnItemId_Click:255) |
| WK-SCP0020-0208 | X-ROW | SCP0020_TactTime.checkValidN0 | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 8검사 — NA:7 · ERROR:1 |  | 24 (ACT:SCP0020_TactTime.checkValidN0 ACT:SC) |
| WK-SCP0020-0209 | X-ROW | SCP0020_TactTime.checkValidN5 | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 6검사 — ERROR:4 · NA:2 |  | 47 (ACT:SCP0020_TactTime.checkValidN5 ACT:SC) |
| WK-SCP0020-0210 | X-ROW | SCP0020_TactTime.checkValidN8 | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 6검사 — ERROR:4 · NA:2 |  | 25 (ACT:SCP0020_TactTime.checkValidN8 ACT:SC) |
