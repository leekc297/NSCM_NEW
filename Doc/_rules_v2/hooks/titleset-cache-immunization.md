# Hook #115 — titleset 'C' 캐시 오염 면역화 (동적 PIVOT V_COLUMN 조립 SP)

> **트리거**: 동적 PIVOT 컬럼목록(V_COLUMN)을 `SCM_MST_TITLESET_USER`(TYPE='C') 캐시로 조립하는 SP 작성/수정 · Column Setting/Measure Setting 모달 작업 · ORA-00918(중복 컬럼)/ORA-00904(미산출 컬럼) 조회 오류
>
> 위반 시: 사용자가 Column Setting 에서 특정 컬럼을 선택·저장하는 순간 메인 조회가 영구 오류 — 캐시 DELETE 로 정정해도 **저장할 때마다 재오염**(두더지잡기).

작성: 2026-07-23 (DMF0003 DEPT_ID/MEASURE 재발 사고 — 일회성 캐시 정정 2회 후 재발 → 구조 면역화)
관련 메모리: `feedback_titleset_cache_immunization.md` / 패키지 정본: `_artifacts/_deploy_packages/DMF0003_TITLESET_IMMUNIZE_20260723`

---

## §0. 사고 구조 (원인 사슬)

| 오염 유형 | 결과 |
|---|---|
| 고정컬럼(DEFAULT_FLAG ' '/'-', 예 MEASURE)이 캐시 유입 | branch②(고정 UNION)와 2회 → **ORA-00918** |
| SP 산출집합(MF_BASE) 미산출 컬럼(예 DEPT_ID/DEPT_NAME) 유입 | 동적 SELECT 참조 실패 → **ORA-00904** |

**재오염 경로**: 모달 후보 SP(DMF0002_GET_TITLESET_POPUP)가 SHEET_COLUMNS VALID='Y' **전체**를 후보로 반환(USER_SELECTABLE 미필터) + 이관 flag 결함(미산출 컬럼 selectable='Y') → 선택·저장 → 캐시 오염.
추가 결함: FE `columnType` 에 시트명 전달 → usr CTE 0행 → **저장해도 재오픈 시 DEFAULT 복원**(저장 미유지) / SHEET_COLUMNS PK 부재 → 중복행 유입 시 모달 중복표시·이동 오동작(itemKey 충돌).

## §1. 3층 방어 (의무)

### §1.1 L1 — SP 읽기측 면역 (최종 방어선)
titleset 'C' → V_COLUMN 조립 커서에 가드 2종:
```sql
AND NVL(C.DEFAULT_FLAG,'N') NOT IN ('-',' ')   -- 고정컬럼 = branch② 전담 (00918 차단)
AND C.VALID_YN = 'Y'
AND U.COLUMN_NAME IN ( /* MF_BASE 산출 whitelist — SP 원문 SELECT 리스트에서 실측 추출 */ )
```
- ⚠️ **`DEFAULT_FLAG='Y'` 필터는 오답** — 'N'-flag 중 다수가 산출되는 정당한 추가선택 컬럼(DMF0003 실측 35/40). 과거 flag 필터 패치가 조회 파손(539→9행).
- whitelist 는 같은 SP 의 MF_BASE SELECT 리스트와 **동기 유지 의무** 주석 명기.

### §1.2 L2 — FE 모달 정합
- ColumnSettingModal `columnType='C'` (TITLESET_USER.USER_INQUIRY_COLUMN_TYPE_CODE — 시트명 전달 금지).
- **COLUMN_NAME dedup**(무조건) + `selectableOnly` opt-in(고정컬럼+USER_SELECTABLE≠'Y' 후보 제외 — shared 기본값 보존).
- MeasureSelectModal colNm dedup 동일 (measure 는 메인 SP 가 SHEET_MEASURE VALID 조인으로 이미 면역).

### §1.3 L3 — 메타 정정
- 산출 불가 컬럼의 `USER_SELECTABLE_FLAG='N'` 정정(명백 결함만 — 고정컬럼 8종 관례는 유지, L2 필터가 담당).
- SHEET_COLUMNS 는 PK/UNIQUE 없음 — 클라우드 중복행은 **사내 정본 전면 DELETE+INSERT 동기**가 정본.

## §2. 검증 규격 (의무)
1. **회귀**: 실측 파라미터로 패치 전후 행수+SHA-256 해시 완전 동일.
2. **면역 테스트**: 테스트 사용자 titleset 에 오염 강제 주입(미산출+고정 컬럼) → 조회 **오류 0 + 기준 해시 동일** → 테스트 데이터 정리.
3. 캐시 정리 SQL 은 전 사용자 + SP 가드와 동일 규칙으로 패키지 동봉.

## §3. Measure 모달 개인화 게이트 (2026-07-23 보강 — SHEET_PRSL_YN)
TO-BE measure 목록 API(`PKG_NSCM_UI_COM_MENU.PR_GET_SHEET_MEASURE_LIST`)는 lookup `SHEET_PRSL_YN`(SEG1=MNU, SEG2=SHEET, SEG3='Y') 게이트로 2경로 분기:
- **등록('Y')** → titleset 'M' LEFT JOIN (DISPLAY_FLAG=사용자 선택, 시드 INSERT 포함) = **AS-IS(SCM0002_GET_TITLESET_POPUP Measure 분기) 동형**
- **미등록** → DISPLAY_FLAG=DEFAULT_FLAG 고정(titleset 무시) → **Measure 선택 저장이 모달 재오픈에 반영되지 않는 결함 경로**

의무: measure 개인화 모달 보유 화면은 `SHEET_PRSL_YN` 행 등록(멱등 INSERT — DMF0082/DMF0003 선례). SP 본문 무수정 — 메타 등록만으로 AS-IS 경로 활성.
검증 표준: titleset 'M' 에 테스트 행 추가→SP DISPLAY_FLAG 'Y' 반영→원복→'N' 복귀 (왕복 테스트). 패키지 `DMF0003_MEASURE_PRSL_FIX_20260723`.
