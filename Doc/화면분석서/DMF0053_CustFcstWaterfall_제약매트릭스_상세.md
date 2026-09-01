# DMF0053 (Customer FCST Waterfall) — 제약(VALIDATION) 매트릭스 상세

> 작성: 2026-08-27 (T01 — hook #124 ②VALIDATION 영역 / #114 MSG 실문구 대사)
> 원천: `validation.md` **18건** (2026-05-12 v6) ↔ AS-IS 정본 .cs 1,822행 전량 재실측 — 카운트 일치 확인.
> MSG 실문구 = 사내 `SCM_ADM_MSG_M` + `nscm-fe/public/locales/KO.json` **양쪽 실측 일치** (2026-08-27, 신규 채번 0건).

## A. 사용자 통보 검증 (GMessageBox 6건 — validation.md #3~#7 + EditButton)

| V# | 위치(.cs) | 조건 | MSG | TO-BE 실문구(KO, 실측) | TO-BE 판정 |
|---|---|---|---|---|---|
| A-01 | FindData L677~682 | Division 미선택 | MSG00097 | "Division 을 선택하세요." | 구현 — Search 차단 |
| A-02 | FindData L686~690 | Period 시작>종료 | MSG00108 | "조회 기간이 잘못되었습니다 (시작일 > 종료일)." | 구현 — 차단 |
| A-03 | FindData L692~699 | **Period 3년 초과** | MSG00164 | "조회 기간은 3년 이내로 입력해주세요." | 구현 — 알림 + `to = from+3년` 자동 보정 후 중단 (AS-IS L696 파리티). ⭐ 문구·로직 모두 3년 정합 (DMF0040 의 2년 특례와 다름) |
| A-04 | FindData L701~707 | Input Date(CreateDate) 시작>종료 | MSG00108 | 동 A-02 | 구현 — 차단 |
| A-05 | FindData L709~716 | Input Date 3년 초과 | MSG00164 | 동 A-03 | 구현 — 알림 + 보정 후 중단 |
| A-06 | EditButton L587~594 | 편집 시도 (F2) | MSG00109 | "읽기전용 상태입니다." | 제외·해당없음 — TO-BE 는 편집 진입점 자체 미노출(hotkeyConfig insert/delete/save=false)이라 도달 경로 없음. 사유 기재 |

> validation.md #4/#6 의 "MSG00108=조회된 데이터가 없습니다" 기재는 **AS-IS 시점 문구 오기재** — TO-BE 실측 문구는 위와 같음 (#114 재매핑 불요, ID 그대로 의미 일치).

## B. 사업부 분기 (10건 — validation.md #1·#2·#8~#15)

| V# | 위치 | 분기 | 내용 | TO-BE 판정 |
|---|---|---|---|---|
| B-01 | InitControls L286 | `Substring(0,2)=="81" \|\| =="82"` | 초기 적재 시 81*/82 는 Customer(division,team) 경로 | 구현 — Division 초기 cascade |
| B-02 | FindData L677 | `sDivision==""` | 필수값 분기 (A-01 의 전제) | 구현 |
| B-03/04 | cboDivision_Changed L949·951 | null 가드 + 81*/82 판정 | **81*/82: PJT·Plant Site·btnProject Enabled / 40: Disabled** + cascade 경로 분리 | 구현 — `isProjectEnabled = div.startsWith('81') \|\| div==='82'` |
| B-05/06 | clbTeam_Changed L1035·1037 | 동일 | Customer→SalesSite cascade 경로 분리 (81*/82 는 team 미전달) | 구현 |
| B-07/08 | clbCustomer_Changed L1072·1074 | 동일 | SalesSite cascade 경로 분리 | 구현 |
| B-09 | spdMain_ComboSelChange L1150 | Division 컬럼 판정 | 셀 콤보 재설정 분기 | 제외 — dead path (E10, 전열 잠금) |
| B-10 | fnValidation L1462 | 신규 행 중복 검사 (9 컬럼 동치) | 저장 전 dedup | 제외 — dead code (SaveData 주석·저장 경로 없음) |

> ⭐ 81 판정은 **`Substring(0,2)` 접두 판정** — `81_UC`/`81_HM`/`81_ST`/`81_HD`/`81_HG` 포함 (SHEET_COLUMNS DIVISION_ID 토큰 실측과 정합).

## C. 사전검증 분기 (2건 — validation.md #17·#18)

| V# | 위치 | 조건 | TO-BE 판정 |
|---|---|---|---|
| C-01 | GetLastWeekSunDayByDate L1691 | 월요일 도달 시 전일(일요일) 반환 | 제외 — 소비처(실적 회색 L811~903)가 전부 주석 = dead code |
| C-02 | SetAmountCalculating L1744 | `QTY index==0` 이면 원본 복원 | 구현 — QTY=1 선택 시 원값 표시 |

## D. 입력검증 이벤트 (1건 — validation.md #16)

| V# | 위치 | 내용 | TO-BE 판정 |
|---|---|---|---|
| D-01 | txtVersion_KeyDown L1676 | 아무 키 → Version 팝업 | 제외 — Version 조회조건 자체 미구현 (E21/E22 사유: AS-IS btnVersion 숨김 + Figma·#112 카탈로그 부재) |

## 카운트 대사

| 축 | validation.md | 본 문서 | 구현 | 제외(사유 기재) |
|---|---:|---:|---:|---:|
| GMessageBox | 5 (+EditButton 1 = §16 기준 6) | A 6 | 5 | 1 (A-06) |
| 사업부분기 | 10 | B 10 | 8 | 2 (B-09/B-10) |
| 사전검증 | 2 | C 2 | 1 | 1 (C-01) |
| 입력검증 | 1 | D 1 | 0 | 1 (D-01) |
| **합계** | **18** | **19 행 (B-03/04 등 쌍 행 병기로 18 항목)** | **14** | **5** |
