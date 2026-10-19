# DMF0082 Excel Form / Upload — AS-IS DMF0020 파리티 전면 이식 (클라우드 이관)

| 항목 | 값 |
|---|---|
| 패키지 | `DMF0082_XLSFORM_ASIS_CLOUD_20260921` |
| 대상 화면 | **DMF0082 — FCST & PRICE MGMT** (`features/demand/src/pages/forecast-price`) |
| 범위 | ⭐ **DB 전용** (FE 는 사용자 지시로 이관 대상 제외 — 2026-09-21) |
| 사내 적용 | **완료 · 검증 PASS** (222.110.191.243:2521/ZIOUI1 / SCM_MGR, 2026-09-21) |
| 클라우드 | **미적용** |
| 사내 원본 스탬프 | `PKG_DMF0082` BODY `ALL_SOURCE` 재추출 (2026-09-21 적용 후) — SOURCE-FRESH |

---

## 1. 요구 (사용자 지시 2026-09-21)

> "EXCEL FORM, UPLOAD 을 AS-IS DMF0020 의 EXCEL FORM, UPLOAD 와 동일하게 기능 구현하도록 해주세요."
> "EXCEL FORM COLUMN - Div / Team / End Customer / Project Code / Currency / Model / M0 / M1 / .... / M12"
> "to-be 도 m0 - m12 까지는 빈칸으로 해주세요" / "Excel Form 의 M0 - M12 까지는 조회 시 빈칸"
> "DMF0082 EXCEL FORM 변경 후 이양식으로 EXCEL UPLOAD 까지 보완 적용해주세요"

### 사양 원천 (AS-IS 실측)

| 축 | AS-IS 실측 근거 |
|---|---|
| 양식 컬럼 | `SCM_MST_SHEET_COLUMNS` (`DMF0020` / **`Sales Price Template`**) **19행** — AS-IS `DMF0020_SalesPriceTemplatePopup.cs` 가 `DMF0000_GET_COMMON_SPREAD_TITLE` 로 읽어 `CreateSheetHeaderColumn` 하는 메타 ([PJ2024-50611]) |
| 양식 데이터 | `DM.DMF0020_GET_SALES_PRICE_TEMPLATE` → TO-BE 변환본 `PKG_DMF0020.P_DMF0020_GET_SALES_PRICE_TEMPLATE` |
| M0~M12 | AS-IS SP 원문이 `'' AS M0 … '' AS M12` = **전부 빈 문자열** |
| 업로드 헤더 | `SCM_ADM_EXCEL_COLUMNS` (`DMF0020` / `Sales Price`) `HEADER_CONTENT` **19토큰** |
| 업로드 저장 | `PKG_DMF0020.P_DMF0020_EXCEL_UPLOAD` → `SCM_MST_FUTURE_PRICE`(MERGE) + `_H`(INSERT), `ATTRIBUTE8='EXCEL UPLOAD'` |
| division 범위 | AS-IS 도 **81 전용** — `DMF0020_SalesFuturePrice.cs` L203/L2579 `clbDivisions.ControlValues.Substring(0,2)=="81"` 일 때만 버튼 노출 |

---

## 2. 작업 ↔ 파일 대조표

| # | 작업 | 파일 | 성격 |
|---|---|---|---|
| 0 | 클라우드 선판정 (READ-ONLY) | `A_DB/00_PRECHECK_CLOUD.sql` | 조회 |
| 1 | 양식 컬럼 메타 19행 등재 | `A_DB/02_META_SHEET_COLUMNS.sql` | INSERT-only (NOT EXISTS) |
| 2 | 업로드 헤더 토큰 23 → 19 | `A_DB/03_META_EXCEL_COLUMNS.sql` | 조건부 UPDATE (멱등) |
| 3 | PREREQ GTT `GT_F020_*` 6종 자급 | `A_DB/04_PREREQ_GTT_F020.sql` | DDL (ORA-00955 skip) |
| 4 | `PKG_DMF0082` BODY 교체 | `A_DB/05_PKG_DMF0082_BODY.sql` | CREATE OR REPLACE |
| 5 | 적용 후 검증 (값 단언) | `A_DB/90_VERIFY.sql` | 조회 |

### 4번에 포함된 SP 변경 2종

| SP | 변경 |
|---|---|
| `P_DMF0082_GET_EXCEL_FORM_DATA` | 본문을 AS-IS `P_DMF0020_GET_SALES_PRICE_TEMPLATE` 로직으로 **전면 교체**. 출력 = 19컬럼 + `EDIT_YN`. 행 원천 = `DM_PLN_SALES_PLAN_C` ∪ `DM_PLN_SALES_PLAN_RESULT_C` (`MEASURE='RTF_SYS_RP'`, `QTY<>0`, DIV 최신 `SP_W` 버전, 52주 창). **M0~M12 = `''` 빈칸** (구 LOC 단가 프리필 `LP` 조인 제거) |
| `P_DMF0082_EXCEL_UPLOAD` | 본문을 AS-IS `P_DMF0020_EXCEL_UPLOAD` (1,315줄) 로 **전면 교체**. 슬롯 `ATTRIBUTE1` Div / `2` Team / `3` End Customer / `4` Project Code / `5` Currency / `6` Model / `7~19` M0~M12 |

> ⭐ **SPEC·배선 무변경**: 두 SP 의 시그니처가 AS-IS 와 동일(업로드 5-arg / 양식 17IN+2OUT)해
> `PACKAGE SPEC` · `SCM_ADM_PROC_M` · `SCM_ADM_MNU_BTN_MPG_M` · `SCM_ADM_API_M` **재배선 불필요**.
> 이식 원본에 `DMF0020` 리터럴은 주석 1곳뿐이고, `PROGRAM_ID`/`SHEET_NAME` 은 전 지점이
> `P_PROGRAM_ID`/`P_SHEET_NAME` 파라미터 경유라 `DMF0082`/`FcstNPrice` 로 그대로 동작한다(실측).

---

## 3. 적용 순서

```sql
-- 0) 선판정 (READ-ONLY) — 결과를 §5 와 대조
@A_DB/00_PRECHECK_CLOUD.sql

-- 1~4) 적용  ※ 02 와 05 는 반드시 같은 회차에 함께
@A_DB/02_META_SHEET_COLUMNS.sql
@A_DB/03_META_EXCEL_COLUMNS.sql
@A_DB/04_PREREQ_GTT_F020.sql
@A_DB/05_PKG_DMF0082_BODY.sql

-- 5) 검증
@A_DB/90_VERIFY.sql
```

> ⚠️ **03 과 05 는 분리 적용 금지.** `HEADER_CONTENT` 토큰 순서가 곧 `ATTRIBUTE` 슬롯이라
> 한쪽만 적용하면 업로드가 **전 행 탈락**한다.

---

## 4. 멱등성 / 비파괴

| 스크립트 | 재실행 안전 | 방식 |
|---|---|---|
| 02 | O | 19건 전부 `NOT EXISTS` 가드. 이미 있으면 0건 삽입 |
| 03 | O | 목표값과 다를 때만 UPDATE. 이미 19토큰이면 0건 |
| 04 | O | `ORA-00955` skip |
| 05 | O | `CREATE OR REPLACE` |

- **DELETE 0건** — 어떤 스크립트도 기존 행을 지우지 않는다.
- 사내 전값(pre-value) WHERE 절 **없음** — 클라우드 현재값과 무관하게 목표상태로 수렴.
- 감사 컬럼 = `admin` (`CREATED_BY`/`LAST_UPDATED_BY`).

---

## 5. 적용 중단 조건 (PRECHECK 결과 판정)

| PRECHECK | 정상 | 불일치 시 |
|---|---|---|
| **[A]** 시그니처 | FORM_DATA IN 17/OUT 2, UPLOAD IN 4/OUT 1 | **중단.** 클라우드 PKG 세대가 다름 → 세대 대조 선행 |
| **[B]** 배선 | FORM_DATA/UPLOAD/UPLOAD_SAVE 행 존재 | 0행이면 **중단** — 배선 패키지 선행 필요 (이 패키지 범위 밖) |
| **[C]** GTT | 6행 (또는 04 가 채움) | 6행인데 05 컴파일이 `ORA-00904` → 해당 GTT 컬럼 드리프트 → REBUILD 필요 |
| **[D]** 원천 테이블 | 4개 전부 존재 | `MISSING` 있으면 **중단** (조회가 ORA-00942) |
| **[F]** 현재 메타 | 구 23토큰 / Template 0행 | 이미 19토큰·19행이면 **이 패키지 기적용** (멱등이라 재실행 무해) |
| **[G]** 재사용 키 | MSG01014/MSG01023/LBL00674 존재 | 없으면 §6 참조 |
| **[H]** 81 division | 1개 이상 | 0이면 양식이 항상 빈 결과 (기능은 정상) |

---

## 6. MSG / LBL / MNU / BTN 4분류

| 분류 | 신규 채번 | 내용 |
|---|---|---|
| MSG | **0건** | 재사용만 — `MSG01014`(81 외 division 가드) · `MSG01023`(조회 0건) |
| LBL | **0건** | 재사용만 — `LBL00674`(No) |
| MNU | **0건** | 메뉴 변경 없음 |
| BTN | **0건** | 버튼·배선 변경 없음 (시그니처 동일) |

> 신규 채번이 0건이라 hook §1.0-B **B2 채번 충돌 위험 없음**. PRECHECK [G] 는 재사용 키의 **존재 확인** 목적.

---

## 7. 롤백

1. **PKG** — 적용 직전 사내 원본 백업본으로 되돌린다:
   `_artifacts/_apply_corporate/DMF0082_XLSFORM_ASIS_20260921/00_backup/BACKUP_PKG_DMF0082_BODY_pre_xlsform_20260921.sql`
   (사내 live 덤프 16,218줄. 맨 앞에 `CREATE OR REPLACE ` 를 붙여 실행)
2. **메타 B** — `HEADER_CONTENT` 를 구값으로:
   `Div|Project Code|Sales Site|Model|Incoterms|FCST Type|Customs Handbook|Plant Site|Currency|Measure|M0|...|M12`
3. **메타 A** — 되돌릴 필요 없음(가산적). 굳이 지우려면
   `DELETE FROM SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='DMF0082' AND SHEET_NAME='Sales Price Template';`
4. **GTT** — 되돌리지 않는다(다른 화면 공유 자원).

> ⚠️ 1 과 2 는 **함께** 되돌린다(슬롯 정합).

---

## 8. 사내 실측 검증 결과 (이 패키지가 재현해야 할 값)

| 게이트 | 사내 실측 |
|---|---|
| G1 PKG 상태 | PACKAGE / PACKAGE BODY 둘 다 **VALID** |
| G2 컴파일 에러 | **0** |
| G3 토큰 수 / AS-IS 일치 | **19 / ASIS_MATCH=1** |
| G4 HEADER_CONTENT 값 단언 | **PASS** |
| G5 양식 메타 19행 · 라벨=토큰 | **19 / PASS** |
| G6 구 축 잔존 | **0행** |
| G7 이식 마커 | XLSFORMASIS=4, `'' AS M0`=2, 슬롯주석=1 |
| G8 NLS 교정 | EXPLICIT=**3**, IMPLICIT=1(주석 1줄) |
| 런타임 div 81 | **116행 / 20컬럼 / 2.1초**, M0~M12 채워진 셀 **0건** |
| 런타임 div 81_HD | 4행, M 채워짐 0건 |
| 런타임 div 40 | 0행 + `MSG01014` (가드 정상) |

---

## 9. ⚠️ 동반 적출 — 별건 (이 패키지 범위 밖)

**`PKG_DMF0020.P_DMF0020_GET_SALES_PRICE_TEMPLATE` 은 현재 실행 자체가 불가**하다.

```
FN_NEXT_DAY(T_VER.YYYYMMDD, 'MON')     -- VARCHAR2 를 DATE 파라미터에 암묵 전달
  FN_NEXT_DAY(P_DATEVAL DATE, P_WEEK VARCHAR2) RETURN DATE
  세션 NLS_DATE_FORMAT='DD-MON-RR'(BE 기본) → ORA-01861
```

- 2026-09-21 사내에서 원본 SP 직접 호출로 **동일 오류 재현** 확인.
- 본 패키지의 이식본은 `TO_DATE(T_VER.YYYYMMDD,'YYYYMMDD')` 명시 변환(3곳)으로 **해소**했다 (hook #109 NLS 암묵 형변환).
- `PKG_DMF0020` 자체는 **미수정** — 별도 판단 필요.

---

## 10. FE (이관 제외)

사용자 지시(2026-09-21)로 **FE 는 이 패키지에서 제외**한다. 사내/로컬에는 아래 4파일이 적용돼 있으며,
FE 없이 DB 만 적용해도 **업로드 경로는 완전히 동작**한다(업로드는 BE 가 `HEADER_CONTENT` 로 파싱 → SP 적재).

| 파일 | 변경 요지 |
|---|---|
| `features/demand/src/pages/forecast-price/utils/forecast-price.excelForm.ts` | 양식 컬럼 하드코딩 제거 → `buildExcelFormColumns(metaColumns)` 메타 주도 |
| `features/demand/src/pages/forecast-price/useForecastPriceStore.ts` | `templateColumns` + `fetchTemplateColumns` 추가 |
| `features/demand/src/pages/forecast-price/components/modals/ForecastTemplateModal.tsx` | 모달이 메타를 조회해 양식·미리보기 구성 |
| `features/demand/src/pages/forecast-price/utils/forecast-price.excelForm.test.ts` | 단위테스트 11건 갱신 |

> ⭐ FE 미적용 시 클라우드 화면의 **양식 다운로드 컬럼은 구 23축 그대로** 나온다(FE 상수 기준).
> 반면 **업로드 파싱은 새 19축**이 되므로, 그 구 양식으로 업로드하면 헤더 불일치로 실패한다.
> ⇒ **FE 를 함께 올리기 전까지는 클라우드에서 "양식 다운로드 → 업로드" 왕복을 쓰지 말 것.**
> DB 만 먼저 적용할 경우 이 제약을 운영에 공지해야 한다.
