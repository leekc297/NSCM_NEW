# DMF0048 (SalesMonitoring / 판매 모니터링) — 클라우드 이관 패키지

> **신규 화면** DMF0048 전체 이관 패키지 (sales-monitoring 폴더 미커밋 = 신규).
- 작성: 2026-07-08
- 화면 ID: **DMF0048** | 도메인: `demand` | slug: `sales-monitoring` | URL: `/demand/sales-monitoring`
- 범위: **FE** (BE Java 무변경 / DB SP·메타는 2026-07-04 배포분 — §4)

## 1. 패키지 구성
```
_dmf0048_artifacts/
├── fe/
│   ├── features/demand/src/pages/sales-monitoring/   (12 파일 — 화면 전용, 신규)
│   └── features/master/src/components/searchFields/   (2 파일 — ⚠️ 공유, §3)
├── common/procedures.d.ts_DMF0048_block.txt           ← procedures.d.ts DMF0048 블록 참조본
├── _COMMON_FILES_GUIDE.md                              ← route-paths / Router / procedures.d.ts 패치
└── _README.md
```

## 2. 주요 조회조건 로직 (이번 세션 반영, 2026-07-07~08)
- **Cascade**: End Customer / Sales Site 옵션에 **Division + Team(DEPT_ID)** 필터. Sales Site 콤보를 `ScmSitebyEndCustomer40`(div40 하드코딩) → **`SalesSite`**(DIVISION_ID/DEPT_ID 반환)로 교체. 상위 변경 시 하위 cascade clear.
- **Division 40 → Project / Plant Site 비활성** (AS-IS `sDivision=="40"` 1:1).
- ⚠️ **Plant Site 의 End Customer cascade 미적용**: 콤보 `SalesPlant`(PlantSitebyDivision)가 END_CUSTOMER 미반환 → Division cascade 만. 필요 시 콤보(SP) 보강 별도.

## 3. ⚠️ 공유 컴포넌트 (features/master/src/components/searchFields)
DMF0048 이 import 하는 카탈로그 필드(`ProjectField`/`ItemField`/`OwnerField`)가 포함됩니다.
- **변경점**: `ProjectField`/`PopupSearchInput` 에 `disabled` optional prop 추가 (additive — DMF0048 Division 40 시 Project 비활성용).
- ⚠️ **전 master 화면 공용** — 덮어쓰기 전 diff 검토 권장 (additive prop 이라 회귀 위험 낮음).
- DMF0048 은 `ColumnSettingModal`(master/components)도 사용 — 해당 컴포넌트가 클라우드에 이미 있어야 함(공용).

## 4. BE / DB
- ❌ BE Java 무변경 (동적 호출).
- ⚠️ DB SP/메타: DMF0048 은 2026-07-04 배포분(`PKG_DMF0048` + PROC_M/API_M/SHEET_COLUMNS + PR_GET_DAY_RANGE 배선) 전제. 이 패키지엔 SQL 미포함(FE 전용). 신규 환경이면 해당 메타/SP 선행 배포 필요.

## 5. 적용
```bash
git checkout -b feat/dmf0048-sales-monitoring
# 화면 전용
cp -r fe/features/demand/src/pages/sales-monitoring \
      nscm-fe/features/demand/src/pages/
# ⚠️ 공유 searchFields — diff 검토 후 반영
cp fe/features/master/src/components/searchFields/SearchFields.tsx        nscm-fe/features/master/src/components/searchFields/
cp fe/features/master/src/components/searchFields/SearchFields.module.scss nscm-fe/features/master/src/components/searchFields/
# 공통 파일 (_COMMON_FILES_GUIDE.md §1~3) 확인/패치
```

## 6. 검증
- 조회조건: Division 40 → Project/Plant Site 비활성 / Team 선택 → End Customer·Sales Site 옵션 필터·clear.
- 그리드 조회 + Excel 다운로드 정상.
