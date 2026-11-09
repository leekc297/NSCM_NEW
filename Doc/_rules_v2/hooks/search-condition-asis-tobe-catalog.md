# Hook #112 — search-condition-asis-tobe-catalog (SCP·DM 조회조건 AS-IS↔TO-BE 카탈로그 적용 의무)

> 🅕 T01 / T01M / T03 / T05 · 문서 hook(guide) · 2026-07-13 신설 (사용자 명시)
>
> **트리거**: SCP / DM 도메인 화면의 **신규 생성·수정·조회조건(Form/SearchArea) 작업** 전부.
> 조회조건 코드를 작성/수정하기 **전에** 본 hook + 카탈로그의 해당 화면 표를 필독한다.
>
> **원천**: `Doc/SCP_DM_화면별 조회조건 정리_260122_v0.4.xlsx` `List` 시트 (2026-01-22 v0.4) —
> 사용자 요청(2026-07-13): "SCP, DM 의 조회조건에 대하여 as-is vs to-be 반영 시 적용해야 할
> 명칭·유형·기능·팝업구분·필수값·변경여부·변경내용 정리 — 차후 UI 수정, 개발 시 사용할 수 있도록 rule 화."

---

## §0. 카탈로그 (단일 데이터 소스)

**전수 카탈로그** = [`Doc/_rules_v2/_mapping/search_conditions_scp_dm.md`](../_mapping/search_conditions_scp_dm.md)
— **953행 / 99화면** (SCP 636행·74화면 / DM 317행·25화면), 변경(O) 520 / 유지(X) 433. 병합셀 해제 전수 변환본 (카운트 원본 xlsx 와 1:1 검증 완료).

- 카탈로그 §1 = 화면 인덱스 (도메인/메뉴 경로/화면/행수/변경수) — 대상 화면 탐색 진입점.
- 카탈로그 §2 = 화면별 표: `As-Is 명칭·유형·기능·팝업·필수·비고 → To-Be 명칭·유형·기능·팝업·비고 + 변경여부/변경내용`.
- ⚠️ 카탈로그 파일은 원본 xlsx 의 변환본 — **임의 수정 금지**, 원본 개정 시 재생성.

## §1. 의무 절차 (PRE-WRITE — 조회조건 작성 전)

```
[필수 1] 화면 탐색: 카탈로그 §1 인덱스에서 대상 화면(AS-IS 화면명) Grep.
  - 못 찾으면 유사명(약어/괄호 변형) 재검색. 그래도 없으면 "카탈로그 범위 밖" 명시
    (카탈로그는 SCP·DM 99화면 한정 — Common/SCM/FP/SSP 는 화면별 분석 MD 8종 기준).

[필수 2] 해당 화면 표 "전 행" 대조 — 일부 조건만 보고 진행 금지 (anti-simplification).
  - To-Be 명칭·유형(단일/다중)·기능(검색/팝업/달력)·팝업구분을 그대로 적용. 임의 명칭/유형 결정 금지.
  - As-Is 필수(O) 표기는 필수값 후보로 승계 검토 (To-Be 필수값은 원본 미확정 — §4 한계).

[필수 3] 변경여부 판정:
  - X(유지) = As-Is 스펙 그대로 이관.
  - O(변경) = "변경내용" 유형별 지침(§2) 적용. To-Be 열이 채워져 있으면 To-Be 열이 정답.

[필수 4] To-Be 열 전부 공란인 행 = 조회조건으로 승계하지 않는 행. '변경내용' 으로 처리 분기:
  - "메뉴 Sun-Set"        → 화면(메뉴) 자체 미이관 — 작업 착수 전 사용자 확인 (§2.6).
  - "조회조건 삭제"        → 해당 조건 미구현 (구현하면 위반).
  - "공통기능화 검토"      → 조회조건 아님(버튼/체크박스 등) — 조회조건 영역에 넣지 말 것 (§2.5).

[필수 5] 카운트 일치 보고: 구현한 조회조건 수 = 카탈로그 해당 화면의 To-Be 승계 행수
  (To-Be 명칭 non-empty 행). __asis-mapping__.md 에 "카탈로그 N행 중 승계 M / 삭제 d /
  공통기능화 c / Sun-Set s" 형식으로 대조 결과 기록. 불일치 = 사유 명시 없이는 종료 선언 금지.
```

## §2. 변경내용 유형별 적용 지침 (전수 분포: 명칭 194 / 공통기능화 검토 203 / Sun-Set 48 / 명칭·팝업 27 / 유형 18 / 삭제 11 / 명칭·유형·팝업 10 / 명칭·유형 5 / 팝업 2 / 유형·팝업 1 / 용어 1)

### 2.1 명칭 표준화 (194 + 복합 42) — 카탈로그 실측 공통 rename 표

| As-Is | → To-Be | 건수 | 비고 |
|---|---|---:|---|
| Div | **Div.** | 85 | 마침표 포함이 표준 |
| Model / Model / Nickname / Nick Name | **Model/Nickname** | 49 | 공백 없는 슬래시 병기 통일 |
| Project | **PJT** | 22 | |
| Version / SP Version | **Ver.** / **SP Ver.** | 20 | |
| Valid | **Active** | 14 | Y/N 콤보 |
| Biz Type | **Biz. Type** | 9 | Biz 뒤 마침표 |
| Seq | **Seq.** | 8 | |
| NoName(라벨 없는 조건) | **Operation group** | 5 | |
| Outsourcing | **OSP** | — | Plant Site 등 |
| Bucket Type | **Bucket** | 2 | SCP0013 'bucket'→'Bucket' 대소문자 교정(2026-07-13)과 일관 |
| Day Type | **DOW** | — | Day of the week |
| Result Type | **Type** | — | |

> 위 표에 없는 rename 은 카탈로그 해당 행의 To-Be 명칭이 정답. **신규 유사 조건 작성 시에도 이 표준 준수** (예: 'Div' 라벨 신규 작성 금지 → 'Div.').

### 2.2 유형 변경 (18 + 복합 16) — 지배 패턴

| As-Is | → To-Be | 건수 |
|---|---|---:|
| 텍스트·단일 (직접 입력) | **선택·다중 + 검색 + ALL버튼** | 10 |
| 텍스트·단일 + 팝업 | **텍스트·다중 + 팝업** (다중 선택 팝업) | 10 |
| 텍스트·다중 (구분자 입력) | **선택·다중 + 검색** | 7 |
| 텍스트·단일 | **텍스트·다중 + 팝업** | 6 |

> **To-Be 다중선택 표준 = "검색 가능 + ALL 버튼"** (다중 399행 중 ALL버튼 명시 266). FE 구현은 표준 searchFields 카탈로그 콤보(멀티셀렉트+ALL) 사용 — 임의 자유입력 텍스트로 격하 금지.

### 2.3 팝업 통합 (복합 40)

| As-Is | → To-Be | 건수 | 의미 |
|---|---|---:|---|
| 모1/모2/모3 (Model by DivisionPopup) | **메1** | 22 | Model 팝업 → Material by Division 계열 팝업으로 통합 |
| (팝업 없음) | **메1** | 12 | 텍스트 입력 → Material 팝업 승격 |
| 프1 (Project by Division) | **프2** | 6 | Project 팝업 변형 통일 |

> 팝업 코드 범례는 카탈로그 §0 (모=Model by DivisionPopup / 아=Item / 메=Material / 오=Owner / 프=Project / 버=Version / 버세=VersionBySalesPrice / 세=Sales Report — `팝업 비교` 시트 개수 정합으로 검증). 팝업 구현은 공용 modal 인벤토리(`@master/components` 7종 등) 우선 재사용.

### 2.4 용어 (1) — 소수 케이스, 카탈로그 행 To-Be 열 그대로.

### 2.5 공통기능화 검토 (203 — 최다) ⚠️
As-Is **버튼(102)·체크박스(83)·일부 콤보(15)·텍스트(3)** 가 대상. **조회조건 영역(SearchArea)으로 승계 금지.**
- 처리: 공통버튼(hotkeyConfig)·SubTitle 기능버튼·grid 기능·표시 옵션 등으로 재배치 **검토** 사항이며 확정 스펙 아님 → 해당 행 구현이 필요해지면 **사용자 확인 후 결정** (임의 조회조건화/임의 삭제 모두 금지).
- AS-IS 버튼 10대 매핑은 `asis-button-mapping.md` (hotkeyConfig) 우선 적용.

### 2.6 메뉴 Sun-Set (48행 / 8화면) ⚠️
Demand Grouping · Characteristic Capacity · Outsourcing Capacity · Model Allocation · CAPA PIC (Supply Master) / Plan Management (Supply Plan) / Long-term stock MGMT · Policy-based Inv. Mgmt. (SCM Supply).
→ 해당 화면 작업 요청이 오면 **Sun-Set 대상임을 먼저 보고**하고 진행 여부 확인 (조회조건만의 문제가 아니라 화면 이관 자체 미대상).

### 2.7 조회조건 삭제 (11) — 해당 조건 미구현. 실수로 As-Is 기준 구현했으면 제거.

## §3. 연계 룰 (조회조건 구현 시 동시 적용)

| 룰 | 관계 |
|---|---|
| `_tobe/06_search_area.md` | SearchArea/FormItem/CustomDropdown + **searchFields 카탈로그 13종** — 카탈로그 To-Be 명칭·유형을 이 표준 필드로 구현 |
| hook #94 `search-condition-height-uniformity` | 모든 조회조건 객체 높이 36px + 1단 4개(gridSize) |
| hook #83 `search-area-button-position-and-toggle` | 검색버튼 위치 + 3단↑ 펼침/닫기 토글 |
| `search-area-extra-conditions` | 2단(6필드) 초과 시 extraConditions 분리 |
| `cascade-combo-filter` | Div. 변경 시 하위 'ALL' reset cascade |
| hook #110 `sp-multiselect-filter-and-conversion-pitfalls` | 다중선택 값의 SP 측 처리(GTT+skip) — §2.2 다중화와 짝 |
| 메모리 `feedback_bind_combo_value_quoting` / `feedback_multiselect_search_delim_caret_vs_comma` | 다중선택 값 전달 형식('^'/quoting) |

## §4. 한계 (anti-simplification §2.1 [필수 4])

1. 원본 = **2026-01-22 v0.4 스냅샷** (설계 초기 정리본). 이후 확정 화면설계서·Figma·사용자 지시와 충돌 시 **최신 지시가 우선**하되, 충돌 발견 시 카탈로그 행과 함께 보고.
2. **To-Be 필수값(\*) 미확정** — 원본 시트 To-Be 필수 컬럼 전체 공란 (To-Do 시트에 "필수값 지정" 미완 항목 잔존). As-Is 필수(135건)를 후보로 승계 검토 + 화면별 확정 필요.
3. 팝업 코드(모1/메1 등)의 팝업명 매핑은 List·팝업 비교 시트 **개수 정합 기반 실측** — 원본에 명시적 범례 시트는 없음.
4. 카탈로그는 **SCP·DM 한정**. 조회조건 명칭 표준(§2.1)은 타 도메인 신규 화면에도 준용 권장.

## §4.5 ⭐ TO-BE 판정 룰 — SCP·SSP 조회조건 = 기준표 정의 항목·순서·라벨 (CR-071, 사용자 지시 2026-10-26)

> SCP·SSP 화면은 **조회조건 기준표**(`tools/Harness/rules/search_cond.csv` · `tools/VibeManager/rules/40_SEARCH_COND.md`, 룰 E11)에 `USE` 로 정의된 조건만, `tobe_order` 순서대로, `tobe_name` 라벨로 구현한다.
> 이것은 TO-BE 룰이므로 **기준표 라벨이 AS-IS 명칭과 달라도 정합검증은 PASS** 다(예 Division→Div. · Input Status→Status · Valid→Active). 기준표가 제외·이동(DROP/SUNSET/MERGED/BUTTON_AREA/IN_CALENDAR/COLUMN_PERSONAL/COMMON_BUTTON)한 AS-IS 조건이 조회영역에 없는 것도 결함이 아니다(NA).
> **결함**은 ① 기준표 조건 누락 ② 기준표에 없는 조건 노출 ③ 라벨이 기준표와 다름(AS-IS 명칭 그대로 쓴 경우 포함) ④ EDIT 형태(입력 유형: 선택/텍스트 · 단일/다중 · 검색/달력)가 기준표와 다름 뿐이다.
>
> ⭐ **CR-098 (사용자 지시 2026-11-09 · SCP0084 CheckList 조치 필요 1건 '오류 아닌 정상')**: Excel 조회조건 정리 대조는 **사용여부·EDIT 형태까지만** 판정한다. **조회조건 순서는 판정 대상 제외** — 화면 순서가 Excel List 시트 순서(`tobe_seq`)·정렬원칙 순서(`tobe_order`)·AS-IS 배치 어느 것과 달라도 FAIL·판정필요로 쓰지 않고 NA(실측 순서는 참고 증거로만 보존). 2026-11-06 지시 'Excel 순서와 다르면 FAIL' 은 폐기. 생성(gen.js) 시 기준표 순서 배치는 설계 기본값으로 유지(판정 아님).
> ⚠ 한계(2026-11-09 실측): EDIT 형태의 Excel(`tobe_type1`/`tobe_type2`/`tobe_func`) ↔ 화면 컨트롤 유형 **대조 검사는 엔진에 아직 없다**(judge·smoke 에서 `tobe_type*` 참조 0건). smoke 조건 사이클의 유형 식별(combo/checkbox/radio/popup/text/period)은 동작 시험용이며 Excel 대조 판정이 아니다.

| 하네스 | 판정 |
|---|---|
| `judge.py` STATIC H5(라벨)·G4(순서) | 원장 SEARCH 행 ↔ `search_cond.csv` (`tobe_name`·`tobe_order`). 증거에 AS-IS 명칭 병기(`AS-IS 'Valid' → 기준표 명칭(TO-BE 룰 CR-071)`). **G4 순서 차이 = NA(CR-098)** |
| `judge.py` SC1 (smoke 반입 · `order_rule`) | smoke `order` = NA(참고 실측 보존) · `gone`(기준표 제외 조건 잔존) 만 FAIL — CR-098 |
| `mapping_trace.py` SC1 / `smoke-extra.ts` (기준표 순서) | 순서 항목 verdict = NA(`[판정 제외·참고 CR-098]`) |
| `check.js` SC1·SC2 | SC1 순서 다름 → **참고 WARN(생성본도 BLOCK 아님 · CR-098)** / SC2 기준표 제외 조건 잔존 → 생성본 BLOCK·기존 WARN |
| `mapping_trace.py` `sc_excl` | 기준표가 제외한 AS-IS 조회조건 컨트롤의 COND 검사(G4·G1·G6·SC1·C1·C4·B*) = NA(정적) — 검증 엔진이 '칸 없음' FAIL 로 덮지 않음(judge 보존) |
| `confirmed_requirements.csv` | CR-071 (scope SCP;SSP) |
| `_trace.spec.ts` H5 COL(그리드 헤더) | **그리드 컬럼 라벨 확장(2026-10-27 사용자 의견)**: 조회조건으로도 쓰이는 컬럼의 헤더가 기준표 라벨과 같거나(예 SSP Incoterms), 그 외 컬럼 헤더가 SHEET_COLUMNS 메타 라벨과 같으면 AS-IS 명칭과 달라도 **PASS**(종전 '판정필요' 폐지) |
| DM 화면 | 기준표 대상 아님 — 본 hook §0 카탈로그(v0.4) 그대로 |

## §5. 변경 이력
- **2026-07-13** 신설 — 사용자 요청 "차후 UI 수정, 개발 시 사용할 수 있도록 rule 로 정리". 원본 xlsx List 시트 953행 전수 변환 + 패턴 집계(명칭 rename 13쌍 / 유형 4패턴 / 팝업 3패턴) + 카운트 1:1 검증.
| 2026-11-09 | §4.5 CR-098 — Excel 조회조건 정리 대조 = 사용여부·EDIT 형태까지만, 조회조건 순서는 판정 대상 제외(NA). 사용자 지시(SCP0084 조치 필요 1건 SC1 '오류 아닌 정상'). 하네스: judge order_rule·smoke 반입 · mapping_trace · smoke-extra.ts · check.js SC1 BLOCK→WARN · detect_rules/fix_recipes SC1 정의 갱신 |
| 2026-10-27 | §4.5 확장 — 그리드 컬럼 헤더 라벨 = 기준표/메타 라벨이면 PASS(CR-071 확장, `_trace.spec.ts` H5 COL) |
| 2026-10-26 | §4.5 신설 — SCP·SSP 조회조건 기준표 = TO-BE 판정 룰(CR-071): 기준표 라벨·순서·구성이 AS-IS 와 달라도 PASS · 기준표 제외 조건 NA · 하네스(judge H5/G4 · check.js SC1/SC2 · mapping_trace sc_excl) 등록 |
