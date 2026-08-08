# Hook — Oracle SAVE Payload 무결성 & 서버 검증 대응 (#99)

> **트리거**: Oracle SAVE SP(`*_SAVE_*`, delete-then-insert / ^-delim 배열) 호출 화면의 저장 로직 작성·디버깅.
> (신규/편집 행 저장, "중복 오류"·"동일 통화"·ORA-01400 등 저장 실패 발생 시)
>
> **배경 사고 (2026-07-01~02, DMF0020 Sales Future Price)**: 저장 오류 4연발 —
> ① "동일 기간 두 개 이상 Currency" 오탐 ② MSG00043 중복 오탐 ③ ORA-01400 PLANT_SITE_ID NULL.
> 모두 **FE 저장 payload가 배포 SP의 검증 규칙과 어긋나서** 발생. SP는 무변경으로 해결.
>
> **2026-08-06 SYS0017 근본원인 감사 계기 개정**: §0(저장 대상 행 판정 = `CRUD_TYPE` 전용) + §0.1(감사키 빈값 금지) 신설.

---

## §0. ⭐⭐⭐ 저장 대상 행 판정 = `CRUD_TYPE` **전용** (자체 상태필드 신설 절대 금지) — SYS0017 2026-08-06 감사 계기

저장(dirty) 행 판정의 유일한 출처는 **`CRUD_TYPE`** 이다 — `GridAction.addRow`(INSERT 마킹) / `GridAction.removeRow`(DELETE 마킹) / **EditTracker `storeChange`**(cellEditEnded 시 `'M'` 자동 마킹) 가 이 필드에만 마킹한다.

- ❌ **자체 상태필드(`rowStatus` / `ROW_STATUS` / `actionFlag` / `isNew` 류) 신설 금지** — 값이 I/M/D 로 같아도 **공통버튼(SubTitle INSERT/DELETE)·셀편집(EditTracker) 마킹과 단절**되어 사용자가 아무리 편집해도 자체 필드는 영원히 빈값 → **저장 payload 0건** (SYS0017 실사고: `row.rowStatus` 자체 상수 신설 → Insert/편집 저장 전멸. 주석 *"AS-IS action 컬럼(I/M/D) 대체 (TO-BE 상시 편집 표준)"* 이 표준 준수처럼 위장 — **주석은 준수의 증거가 아니다. 준수 = `CRUD_TYPE`/`GridAction`/`EditTracker` 표준 심볼 사용의 grep 으로 판정**).
- ✅ dirty 판정 = `CRUD_TYPE` marker + CollectionView itemsAdded/Edited/Removed + `EditTracker.getOriginalValues()` 3-union (screen-runtime-pitfalls §2.7 표준).
- ✅ AS-IS 의 action 컬럼(I/M/D)을 TO-BE 로 옮길 때도 **`CRUD_TYPE` 로 매핑**한다 (`@foundation/constants` `CRUD_TYPE.INSERT/MODIFY/DELETE`) — 동명·동값 별도 enum 재정의 금지.
- **POST-WRITE grep (0 hit 의무)** — post-write §0.1 #18 과 동일:
  ```bash
  grep -rnE "rowStatus|ROW_STATUS|actionFlag|isNewRow" features/{domain}/src/pages/{screen}/
  ```

## §0.1. ⭐ '^' bulk 감사키 빈문자열 전송 금지 (SYS0017 2026-08-06 감사 계기)

- ❌ `createdBy: joinBulk(changed.map(() => ''))` 처럼 **감사키를 빈문자열로 채워 전송 금지** — Oracle `''`=NULL → CREATED_BY NOT NULL 컬럼이면 ORA-01400, NVL 처리 SP 면 **silent 로 감사값 소실**.
- ✅ 감사키 = 세션 사용자 (`useSessionStore` userId). call-proc 의 BE 자동 주입 키는 `sesUserId` 뿐 — `createdBy`/`createdByBulk` 류는 **FE 필수 전달** ([[feedback_callproc_audit_keys_fe_mandatory]]).
- **POST-WRITE grep (0 hit 의무)**: `grep -rnE "map\(\(\) *=> *''\)|createdBy: *''" features/{domain}/src/pages/{screen}/`

---

## §1. active_flag = 편집은 `'M'`, 신규는 `'I'` (서버 "존재+'I'" 검증 우회)

배포 SAVE SP(delete-then-insert)는 보통 `active_flag <> 'D'` 행을 **기존 키 DELETE 후 INSERT** 한다.
그런데 **서버측 검증이 `active_flag='I'` 만 대상**으로 "기존 테이블에 같은 키가 있으면 오류"를 내는 경우가 있다
(DMF0020 `[E20241125-000026]` — 통화 비교가 **주석 처리**되어 통화가 같아도 발동).

| 상황 | active_flag | 이유 |
|---|---|---|
| **기존 데이터 편집** (조회→수정) | **`'M'`** | AS-IS 화면도 편집을 'M'으로 저장 → `'I'`-한정 검증을 통과. delete-then-insert는 non-'D' 모두 insert하므로 저장 정상. |
| 진짜 신규 행 | `'I'` | 기존 매칭 없음 → 검증 미발동. |
| 값 0 / 삭제 | `'D'` | 삭제 (AS-IS `sPRICE=='0' → 'D'`). |

- ❌ **금지**: 조회한 기존 데이터를 편집·재저장하면서 `'I'` 전송 → 서버 "기존 존재" 검증 오탐.
- ✅ 배치/일괄 입력처럼 **항상 기존 데이터를 편집**하는 화면은 `batch==='0' ? 'D' : 'M'`.
- ⚠️ **SP를 고치지 말 것** (사내 원본과 정합 유지). AS-IS 동작(‘M’ 우회)을 FE로 재현.

## §2. FE payload dedup 키 = **배포 SP의 GROUP BY 검증 키와 정확히 일치**

서버 중복 검증이 `GROUP BY (...키...) HAVING COUNT(col) > 1` 형태면, **`COUNT(col)`은 통화 종류가 아니라 "그룹 내 행 수"** 를 센다 → **동일 값 중복행에도 발동**(메시지 문구가 오해를 부름).

- FE 저장 전 **payload를 SP GROUP BY 키로 dedup** (같은 그룹 1행만 전송).
- dedup 키는 **SP의 GROUP BY 컬럼과 1:1** (예: `DIVISION|PROJECT|SITE|PLANT|ITEM|YYYYMMDD|DOM_EXP|FCST_TYPE|INCOTERMS|MEASURE`). 한 컬럼이라도 빠지면 SP가 묶는 걸 FE가 못 묶어 오탐.
- SP가 값을 **`TRIM`** 후 GTT 적재하면, FE dedup 키도 **`trim()`** (공백만 다른 행이 SP에선 같은 그룹).
- 사전검증으로 **다른 값 충돌**(예: 같은 키에 통화 2종)은 저장 전에 **원인 행 전수** 안내 후 차단(raw SP 오류 대신).

## §3. 신규 insert — NOT NULL 컬럼 division별 **placeholder 기본값**

신규 행은 사용자가 특정 컬럼을 입력 안 해 **빈값('')** 이 되고, Oracle은 `''=NULL` → **NOT NULL 컬럼 ORA-01400**.
SP가 해당 컬럼을 NVL/기본값 처리하지 않으면 **FE가 기존 데이터와 동일 placeholder를 채워** 보낸다.

- 예: DMF0020 div 82 `PLANT_SITE_ID`는 실데이터 전량 **`'-'`** → `push(toStr(x) || '-')`.
- **기본값은 추측 금지** — `SELECT DISTINCT col ...` 로 해당 division 실사용 placeholder 확인 후 반영.
- 실제값이 있는 division(예 81 plant)은 빈값이 아니라 default 미발동 → 무영향.
- cf. `corporate-schema-dropped-col-save-default`(dropped 컬럼) 와 별개 — 이건 **신규 insert NOT NULL placeholder**.

## §4. 저장 SQL 오류 근본원인 = **배포 SP + BE 로그로 확인 (추측 금지)**

- BE 로그(`nscm-be/logs/nscm.log`)의 **`ORA-xxxxx / SQLERRM / SP 라인` + 전송 payload(^-delim)** 를 먼저 읽는다.
- SP 본문은 **`ora.py` (USER_SOURCE)** 로 확인. ⚠️ **`ALL_SOURCE`는 동명 객체 2개가 섞여 LINE 매핑이 어긋남** → 반드시 **`USER_SOURCE`**(배포 owner) 사용.
- 검증이 payload 기준인지 **기존 테이블(SCM_MST_*) 대조**인지 FROM/EXISTS 절로 구분 (오탐 범위가 다름).
- ❌ 로그·SP 확인 없이 "아마 중복/통화" 추측 금지 (anti-simplification). 실제 원인은 §1~3처럼 전혀 다를 수 있음.

## §5. 행간 중복검증 PK = **전체키 + MEASURE** (PIVOT 다-measure 오탐 방지)

PIVOT/measure 다행 화면은 한 item이 measure 행(RTF/KRW/USD/LOC) 여러 개 → **중복검증 PK에서 MEASURE가 빠지면 같은 item의 서로 다른 measure 행을 "중복"으로 오탐**.

- 중복검증 키 = **AS-IS `fnValidation` 전체키**(division/project/site/plant/item/dom_exp/fcst_type/incoterms/currency/**measure**). 컬럼을 더 넣을수록 완전중복만 검출 → 오탐↓, 실제 중복은 모든 키 동일이라 누락 0.
- 값 `trim()` 정규화. 중복 시 **상대 행번호까지** 표기(`N행 (M행과 중복)` — `seen`을 `Map<key,firstIdx>`).

---

## §6. 안티패턴

| # | 안티패턴 | 결과 |
|---:|---|---|
| 6.1 | 기존 편집 행을 `'I'` 저장 | 서버 "기존 존재+'I'" 검증 오탐 (동일 통화인데 "두 개 이상 Currency") |
| 6.2 | FE dedup 키 ≠ SP GROUP BY 키 (컬럼 누락/미 trim) | 동일값 중복행 미제거 → `COUNT>1` 오탐 |
| 6.3 | 신규 insert NOT NULL 컬럼 빈값 전송 | ORA-01400 |
| 6.4 | placeholder 기본값 추측(예 'ALL') | 잘못된 데이터 저장/불일치 |
| 6.5 | 중복검증 PK에 MEASURE 누락 | measure 다행 오탐(MSG00043) |
| 6.6 | 로그·SP 미확인 채 원인 추측 | 헛수정 반복 (anti-simplification 위반) |
| 6.7 | 오탐 회피하려 SP 수정 | 사내 원본과 divergence — 별도 검증·이관 부담 (FE 우회가 정답) |
| 6.8 | 자체 행상태 필드(rowStatus 류) 신설 (§0) | 공통버튼·EditTracker 마킹과 단절 → 저장 payload 0건 (SYS0017) |
| 6.9 | 감사키 빈문자열 전송 (§0.1) | ORA-01400 또는 감사값 silent 소실 (SYS0017) |

## §7. 적용 이력

| 화면 | 적용 | 적용일 |
|---|---|---|
| DMF0020 (sales-future-price) | §1 배치 active_flag 'M' / §2 payload dedup+사전검증 / §3 PLANT_SITE_ID '-' / §5 중복검증 measure 포함 | 2026-07-01~02 |
| SYS0017 (mail-setup) | §0 자체 rowStatus 제거→CRUD_TYPE 전환 / §0.1 감사키 세션 사용자 전달 (근본원인 감사 → 본 §0/§0.1 신설) | 2026-08-06 |

## Cross-ref
- `oracle-db-workflow.md` (통합 진입 — 저장 SP 디버깅 분기)
- `proc-meta-signature-match.md` (PROC_M positional ↔ SP signature)
- `sp-dual-out-cursor-pattern` / `sp-cursor-name-response-key` (OUT 커서)
- `db-error-asis-cross-check.md` (ORA 오류 AS-IS 대조)
- `screen-runtime-pitfalls-mandatory.md` §2.7 (dirty 3-union 표준 — §0 짝) / `post-write.md` §0.1 #18~#20 + §0.1-B (grep 게이트) / `screen-completion-gate.md` §1-3 (저장 결과 판정 의무)
- 메모리: `feedback_asis_to_tobe_sp_no_omission`, `feedback_corporate_schema_dropped_col_save_default`, `feedback_ddl_grep_before_sql`, `feedback_callproc_audit_keys_fe_mandatory`
