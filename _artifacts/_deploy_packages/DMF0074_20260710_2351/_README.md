# DMF0074 Metal Link Price — 클라우드 이관 패키지 (2026-07-10 23:51)

> **직전 패키지** `DMF0074_20260710_1709` **적용을 전제**로 하는 후속 델타 패키지입니다.
> 신규 화면 파일(MetalLinkPrice.tsx / Grid / Form / Store / Router / route-paths / 메타 배선 SQL)은
> 직전 패키지에 있으며 여기에는 **포함되지 않습니다.**

---

## 1. 이 패키지가 고치는 것

Excel Upload 가 **저장까지 한 번도 성공하지 못하던 상태**를 정상화합니다.
모두 MSSQL → Oracle 변환 시 **빈 문자열(`''`)·대소문자** 의미 차이에서 발생한 동일 계열 결함입니다.

| # | 계층 | 증상 | 원인 | 수정 |
|---|---|---|---|---|
| 1 | DB 메타 | 광물 42열이 DB 에 아예 안 들어옴 | `HEADER_CONTENT` 가 `Energy` 에서 끊김 | `01_` — 53/55 토큰으로 확장 |
| 2 | FE | 템플릿 2단 병합 헤더 → 이름 매핑 불가 | BE 는 엑셀 1행을 헤더 키로 사용 | `fe/` — 평탄 헤더 1행 export |
| 3 | FE | 다운로드 무반응 | `Workbook.save()` 는 JSZip 2.x 전용 | `fe/` — `saveAsync` 사용 |
| 4 | FE | 숫자 셀 → `40.0` 로 읽혀 검증 탈락 | 서식 미지정 | `fe/` — 전 셀 `format='@'` |
| 5 | SP | 템플릿 행이 업로드 검증에서 전량 탈락 | 템플릿 SP 만 MRF 필터가 주석 처리 | `02_` L613 필터 복원 |
| 6 | SP | 저장 시 광물 행 전멸 (D14=0) | `PROJECT_CODE`(div 40 = `''` → NULL) 를 `=` 로 조인 | `02_` D14 조인 10줄 `NVL` |
| 7 | SP | `ORA-01400` PROJECT_CODE NOT NULL | 동일 NULL 을 그대로 INSERT | `02_` `NVL(B.PROJECT_CODE,'-')` 3곳 |
| 8 | SP | 저장돼도 조회 안 됨 | `'Current' LIKE '%CURRENT%'` = false | `02_` L83 `UPPER()` |

`'-'` 는 같은 테이블의 `DEPT_ID` 가 이미 쓰던 placeholder 관례를 따른 것입니다.

---

## 2. 폴더 구조

```
DMF0074_20260710_2351/
├── fe/
│   ├── packages/foundation/src/utils/gridAction.ts                    ← flatExcelDownload 추가 (기존 함수 무변경)
│   └── features/demand/src/pages/metal-link-price/
│       ├── metal-link-price.constants.ts                              ← UPLOAD_COLUMNS_* (53/55열 매핑)
│       └── components/modals/MetalLinkTemplateModal.tsx               ← 평탄 export + '-' → 빈칸
├── sql/
│   ├── 01_DMF0074_header_content_fix.sql                              ← 메타 (필수)
│   ├── 02_PKG_DMF0074_full.sql                                        ← SP 전문 (필수, 사내 배포본 추출)
│   ├── 03_DMF0074_mrf_flag_div40_OPTIONAL.sql                         ← 업무 데이터 (⚠ 조건부 — §5)
│   └── 99_verify.sql                                                  ← 적용 후 검증 (11 항목)
├── _README.md
└── docs/PATCH_NOTES.md                                                ← SP 변경 4곳 라인 단위 명세
```

---

## 3. 적용 순서

```bash
# 1) 메타 — HEADER_CONTENT 확장
sqlplus SCM_MGR/****@HOST:PORT/SERVICE @sql/01_DMF0074_header_content_fix.sql

# 2) SP — PKG_DMF0074 SPEC + BODY 재배포 ('/' 종결자 포함, Execute script 로 실행)
sqlplus SCM_MGR/****@HOST:PORT/SERVICE @sql/02_PKG_DMF0074_full.sql

# 3) 검증 — 11 항목 전부 RESULT='OK' 여야 함
sqlplus SCM_MGR/****@HOST:PORT/SERVICE @sql/99_verify.sql

# 4) FE — 3 파일 복사 후 빌드
#    nscm-fe/packages/foundation/src/utils/gridAction.ts
#    nscm-fe/features/demand/src/pages/metal-link-price/metal-link-price.constants.ts
#    nscm-fe/features/demand/src/pages/metal-link-price/components/modals/MetalLinkTemplateModal.tsx
```

`02_` 는 `CREATE OR REPLACE` 이므로 **적용 전 대상 DB 의 기존 바디를 반드시 백업**하십시오.

```sql
SELECT TEXT FROM ALL_SOURCE
WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0074' AND TYPE='PACKAGE BODY' ORDER BY LINE;
```

---

## 4. BE 변경 없음

`nscm-be/` 는 한 줄도 바뀌지 않았습니다. 엑셀 파싱은 기존 `ExcelUtils.convertExcelToJson` +
`FileServiceImpl.cvtListUploadJson` 체계를 그대로 쓰고, 메타(`HEADER_CONTENT`)만 확장했습니다.

---

## 5. ⚠️ `03_` 는 환경 의존 — 조건부 적용

`DM_MST_VERSION` 의 MRF 플래그(`ATTRIBUTE7='Y'`)를 현재 SP_W 버전에 부여하는 **업무 데이터 변경**입니다.

- **운영 환경**: 매주 최신 SP_W 가 곧 MRF `'Y'` 이므로 **적용 불필요**. (적용 금지)
- **개발/스냅샷 DB**: `'Y'` 플래그가 과거에 멈춰 있고 그 버전에 워터폴 데이터가 없으면
  템플릿이 0건이 되고 업로드도 불가능합니다. 이 경우에만 적용합니다.

판단 기준 — `99_verify.sql` 의 마지막 항목이 `NG` 면 적용 대상입니다.
스크립트 하단에 원복 SQL 이 주석으로 들어 있습니다. 적용 전 운영 담당자 확인 필수.

---

## 6. 적용 후 동작 확인

1. DMF0074 진입 → Division `40` → **Excel Form** → Search → **Excel Download**
   - 받은 파일이 **1행 헤더 53열**이고 `Plan Date` / 광물 셀이 **빈칸**인지 확인
2. `Plan Date` = `YYYYMM` (당월 이상), 광물 Key = `METAL_KEY_VALUE` 코드 (예: Ni `M035`)
   - Key 를 넣은 광물은 짝 5개(`PeriodFr` > `PeriodTo`, Contract / Change / Index) **전부** 입력
   - Key 가 빈 광물은 짝 5개도 **전부 공백**
3. **Upload**(검증) → 오류 0건 → **OK**(저장)
4. Version = `Current` 로 Search → 저장한 행이 조회되면 정상

> `Period(Fr) > Period(To)` 입니다 (SP: `FROM <= TO` 이면 오류).

---

## 7. 남은 이슈 (본 패키지 미포함)

| 이슈 | 영향 | 비고 |
|---|---|---|
| C19 의 `NVL(CURRENCY,'') = ''` | `CURRENCY` 가 NULL 인 조합은 업로드 영구 불가 (실측 388행 중 69행) | 업무 판단 필요 |
| D6 MERGE 의 동일 NULL 조인 | 재업로드 시 매칭 실패 → 중복 INSERT 가능 | D15 는 이번에 해결 |
| 리포지토리 사본 정합 | `To-be_v2_converted/06_Packages/04_Package_PKG_DMF0074.sql` 이 배포본과 **119 hunk** 상이. `$$PLSQL_UNIT` 을 변수로 선언·대입하여 **그대로는 컴파일 불가** | 재배포 사고 방지를 위해 정합 필요 |

**본 패키지의 정본은 `02_PKG_DMF0074_full.sql`(사내 배포본 추출) 이며, 리포지토리 사본이 아닙니다.**

---

## 8. 검증 기록 (2026-07-10, 사내 DB 실측)

- `99_verify.sql` 11 항목 전부 `OK` (NG 0건)
- 조회 SP 직접 호출: `versionType='Current'` → **5행** / `'SP_W_...'` → 0행(스냅샷 분기, 정상)
- 저장 결과: `DM_BPS_METAL_LINK_PRICE` div 40 / `202607` / **15행** (5조합 × 광물 3종)
- FE: `tsc --noEmit` (foundation / demand) 0, `eslint` 0, `nscm-be/` 변경 0건
