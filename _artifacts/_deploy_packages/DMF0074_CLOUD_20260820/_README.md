# DMF0074 (Metal Link Price) 클라우드 이관 패키지 — 2026-08-20 취합

> **상태: 취합 완료 / 클라우드 미적용.** 직전 패키지 = `DMF0074_CLOUD_20260819` (rev.6).
> 본 패키지 = 그 이후 delta + **직전 패키지에서 README 파일 목록 누락으로 클라우드 미반영된
> `SearchFields.tsx` 재동봉** (2026-08-20 실사고 2건의 정정 — 아래 배경).

## 배경 — 2026-08-20 클라우드 실사고 2건

| # | 증상 (클라우드) | 원인 | 본 패키지의 정정 |
|---|---|---|---|
| 1 | 조회조건 **Period 가 년월일 달력**으로 표시 (년월이어야 함) | `MetalLinkPriceForm` 은 `PeriodField mode='month'` 를 넘기는데, **`SearchFields.tsx` 신본(month 모드 지원)이 클라우드에 미반영** — 0819 패키지에 파일은 있었으나 README B_FE 목록(16파일)에서 빠져 적용이 누락됨 (0819 README 는 2026-08-20 정정 완료) | `B_FE/shared/searchFields/` 재동봉 + 목적지 경로 명시 |
| 2 | Excel Form 0건 시 **"이번 주 Sales Plan Waterfall 에 MRF 'Y' 버전이 존재하지 않습니다"** 안내가 원인 오지시 | 문구(MSG00656)가 실원인(다운로드 대상 데이터 0건)과 불일치. hook #138 실측 판정: 주석 부활 아님 — GET 쪽 MRF 필터는 AS-IS 주석·TO-BE 도 주석(0818 MRFPARITY), 이 문구는 FE 0건 안내였음 | **MSG01015 신규 채번** ("다운로드할 템플릿 대상 데이터가 없습니다." / EN/CN 번역) — 사내 적용 완료. MSG00656 은 존치(hook #98 §7.1 문구 덮어쓰기 금지), FE 소비처만 전환 |

⚠ 참고: 실제 0건의 데이터 원인(최신 SP_W 버전 원장에 해당 division 행 부재)은 별도 —
0819 패키지의 진단/정정 SQL (`A_DB/91~95_*`) 를 클라우드에서 실행해 확인·조치한다.

## 파일 구성 / 배치 경로 (경로 오적용 주의 — 명시 필수)

```
A_DB/01_MSG01015_TEMPLATE_EMPTY.sql   MSG01015 3언어 멱등 INSERT + 검증 (사내 2026-08-20 적용 완료본과 동일)
B_FE/metal-link-price/                → nscm-fe/features/demand/src/pages/metal-link-price/   (폴더 전체 13파일 — index.ts 포함, 부분 이관 금지)
B_FE/shared/searchFields/             → nscm-fe/features/master/src/components/searchFields/  (⭐ 폴더명은 shared 지만 실제 경로는 features/master 공용)
B_FE/locales/KO·EN·CN.json            → nscm-fe/public/locales/                               (MSG01015 + 기존 LBL/MSG 런타임 원천)
B_FE/configs-types/generated-keys.d.ts → nscm-fe/configs/types/                               (MSG01015 키 유니온 — 빌드 tsc 필수)
```

- PKG_DMF0074 SPEC/BODY: **본 패키지 미포함** — LAST_DDL 2026-08-18 14:06 이후 변경 없음(실측).
  0819 패키지 `A_DB/01~02` 가 최신본이므로 미적용 상태면 그것부터 적용.

## 적용 순서

1. (선행 확인) 0819 패키지 적용 여부 — 특히 `A_DB/02_PKG_DMF0074_BODY.sql`(MRFPARITY·GTTDEL 포함)
2. `A_DB/01_MSG01015_TEMPLATE_EMPTY.sql` — 검증 SELECT 3행 확인
3. B_FE 4축 배치(위 경로 표) → FE 빌드·배포
4. 런타임 스모크:
   ① DMF0074 진입 → **Period 가 년월(월 달력)** 으로 표시되는지
   ② Excel Form 0건 시 안내 문구 = "다운로드할 템플릿 대상 데이터가 없습니다."
   ③ 기존 화면(다른 UI) Period 회귀 없음 — `mode` 미전달 화면은 종전 년월일 유지(기본값 date)

## 검증 쿼리 (클라우드)

```sql
-- MSG01015 (기대 3행)
SELECT MSG_ID, LANG_CD, MSG_NM FROM SCM_MGR.SCM_ADM_MSG_M WHERE MSG_ID='MSG01015' ORDER BY LANG_CD;
```
