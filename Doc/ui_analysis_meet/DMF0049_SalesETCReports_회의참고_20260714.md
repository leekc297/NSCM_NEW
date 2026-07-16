# DMF0049 ETC Sales Reports — UI 분석 회의 참고 (2026-07-14)

> **출처**: `Doc/ui_analysis_meet/UI_Meet_20260714.txt` (2026-07-14 화 15:36, 55분 20초 — 음성인식 회의록) 중 DMF0049 귀속 단락
> **화면**: DMF0049 / AS-IS `DMF0049_Sales_ETC_Reports` (`GSCM.DM.Plan.UIL`) / TO-BE slug `etc-sales-reports` (**미구현**)
> **업무 성격**: 기타매출(ETC Sales) 리포트 — 리포트에서 컷오프 데이터와 **조인되는 ETC 원천**. [DMF0044 Sales Reports](DMF0044_SalesReports_회의참고_20260714.md) 와 POPUP(`DMF0044_Sales_Version`/`DMF0044_United_Version`) 공유 자매 화면.
> ⚠ 본 회의는 ETC 화면을 **독립 주제로 다루진 않음** — Sales Report 조회의 ETC 조인 맥락으로 언급. 아래는 그 귀속분 + [[DMF0021]] 0709 회의 ETC 연계 규칙.
> 표기 원칙: 음성인식 원문 보존, 해석은 `(추정: …)` 병기.

## ㉮ 확정 사항 · 핵심 규칙

1. **⭐ ETC 데이터 = 리포트 조회 시 컷오프 데이터와 조인되는 별도 원천** — "데이터 타입 올로 하면 **컷오프 데이터와 etc 데이터를 조인**해가지고 조회시켜주는 것". Sales Report 의 Data Type=ALL 조회는 컷오프(확정) + ETC 두 원천의 union/join (00:01 단락)
2. **권한 = Admin 전용** — [DMF0044](DMF0044_SalesReports_회의참고_20260714.md) 와 동일 권한 체계 (자매 화면). [[DMF0021]] 0709 "3개 화면(비즈니스 플랜·세일즈 리포트·ETC 세일즈)을 40 사업부만 씀" (07:58 단락)
3. **ETC = 유일한 Insert 입력 지점** — [[DMF0021]] 0709 45:18: "인서트가 가능한 거는 **FCST Type 이 ETC 인 것만**". 컷오프 데이터는 조회, ETC 는 신규 입력 가능. **프로젝트 코드 입력 시 권한 제약** 존재 ((0709) 45:18)

## ㉯ 업무 규칙 · 도메인 지식

| # | 규칙 | 출처 단락 |
|---|---|---|
| 1 | Data Type = ALL 조회 = 컷오프 + ETC 조인 (조인키·중복 방지 규칙 확인 필요) | 00:01 |
| 2 | ETC 리포트도 SP/BP 리포트 타입 체계·버전별 컷오프 환율 규칙을 [DMF0044](DMF0044_SalesReports_회의참고_20260714.md) 와 공유 `(추정 — 자매 화면·POPUP 공유 근거)` | 00:01/07:58 |
| 3 | FCST Type = ETC 행만 Insert 허용, 프로젝트 코드 입력 권한 제약 | (0709) 45:18 |

## ㉰ 미결 / 후속 (TODO)

- [ ] TO-BE slug 확정 (`etc-sales-reports` 가정 — DMF0044 와 라우트/메뉴 관계 정리, 단독 메뉴 vs 탭)
- [ ] "컷오프 + ETC 조인" 조회 SP·조인키·중복 처리(placeholder/PIVOT 분열 주의 [[feedback_plant_placeholder_pivot_split]]) 식별
- [ ] ETC Insert 가능 컬럼 화이트리스트 + 프로젝트 코드 권한 제약 규칙 상세화
- [ ] DMF0044 와 공유 범위(POPUP·권한·환율) vs ETC 고유 로직 경계 확정

## ㉱ 단락별 원문 요지 (귀속 — Sales Report 단락 내 ETC 언급)

| 시각 | 제목 | 요지 (원문 보존) |
|---|---|---|
| 00:01~07:34 | 세일즈 플랜과 비즈니스 플랜의 기능 | (ETC 귀속) 데이터 타입 ALL = 컷오프 데이터 + **etc 데이터 조인** 조회 |
| 07:58~11:14 | 세일즈 리포트 | (ETC 귀속) 권한 Admin 전용 — 자매 화면 공통 |

## 용어 정정표

| 원문 표기 | 추정 원어 | 확신도 |
|---|---|---|
| etc 데이터 / ETC | ETC (기타매출) 데이터 — FCST Type='ETC' | 확실 |
| 컷오프 데이터 | Cut-off(확정) 데이터 | 확실 |
| 데이터 타입 올 | Data Type = ALL | 확실 |
| 인서트 | Insert (신규 입력) | 확실 |
