# Hook #114 — msg-id-asis-tobe-conversion (AS-IS MSG_ID 그대로 사용 절대 금지 — 의미 확인 후 TO-BE MSG_ID 변환 의무)

> 작성: 2026-07-16 (**사용자 명시 요구** — "AS-IS 의 MESSAGE_ID 을 그대로 사용하지 않고, 의미를 확인 후 TO-BE 기준의 MESSAGE_ID 로 변환해야 하는 부분도 RULE 로 적용해서 반드시 지켜지도록")
> 상위 룰: `anti-simplification.md`
> 관련: `asis-msg-inventory.md`(#25) / `corp-meta-integrity-and-wiring.md`(#98 §7 채번) / `i18n-ko-en-alignment.md`(#44) / 메모리 `feedback_msg_id_text_reconciliation`
> 근거 데이터(실측): `_artifacts/MESSAGE_ASIS_vs_TOBE_대조.xlsx` (2026-07-15~16, AS-IS `TB_FX_MessageInfo` 475코드 × TO-BE `SCM_ADM_MSG_M` 743코드 사내 실측)

---

## §0. 트리거

- AS-IS `.cs` / 분석서 / validation.md 의 **`MSG#####` ID 를 TO-BE(FE alert·confirm·toast, DB `SCM_ADM_MSG_M`, i18n locales)에 옮기는 모든 작업**
- 화면 신규 생성(T01)·수정(T01M)의 Validation 매핑, 메시지 등록 SQL 생성, `__asis-mapping__.md` Validation 축 작성
- "AS-IS 메시지 이관 / MSG 등록 / 메시지 매핑" 요청

---

## §1. 배경 — 왜 AS-IS MSG_ID 를 그대로 쓰면 사고인가 (실측)

AS-IS 와 TO-BE 는 **같은 MSG_ID 가 완전히 다른 의미로 재배정**되어 있다. 2026-07-15 사내 실측:

| 항목 | 값 |
|---|---|
| AS-IS 코드 수 (`TB_FX_MessageInfo`) | 475 |
| TO-BE 코드 수 (`SCM_ADM_MSG_M`) | 743 |
| 양쪽 공통 코드 | 61 |
| **공통 중 한글명 상이** | **54 (89%)** — 문구 차이가 아니라 **의미 자체가 다른 재배정** |

대표 사례 (그대로 복사하면 사용자에게 **전혀 다른 메시지**가 노출됨):

| MSG_ID | AS-IS 의미 | TO-BE 의미 |
|---|---|---|
| MSG00001 | 모든 항목은 필수 입력입니다. | **저장 하시겠습니까?** |
| MSG00002 | {0} 값은 필수 입력입니다 | **성공적으로 저장되었습니다.** |
| MSG00004 | {0}개의 데이터가 저장되었습니다. | **수정한 내용이 없습니다.** |
| MSG00097 | 권한을 가진 Division이 없습니다. | (다른 문구 — Division 필수) |

**과거 사고**: DMF0003 (2026-06-28) — GSCM-era MSG ID 를 신뢰하고 채번/매핑 → 사내 마스터와 의미 불일치 → 전량 폐기 후 재정합(2026-07-11, 사내 실재 ID EXACT 재사용 + 부재분 MSG00660~666 신규 채번).

---

## §2. 절대 금지 (Hard Rules)

| # | 금지 행위 |
|---:|---|
| 1 | ❌ AS-IS `.cs`/분석서의 `MSG#####` ID 를 **문구 확인 없이** TO-BE 코드·메타·i18n 에 그대로 복사 |
| 2 | ❌ ID 동일 = 의미 동일이라고 **가정**하고 매핑 (공통 61 중 7건만 문구 일치 — 가정 성립률 11%) |
| 3 | ❌ AS-IS 문구를 TO-BE **기존 ID 에 UPDATE(덮어쓰기)** — 그 ID 의미는 이미 타 화면이 사용 중 (전 화면 오염) |
| 4 | ❌ FE fallback 텍스트(`t('MSG#####', '기본문구')`)만 보고 실제 DB 문구 확인 생략 (메모리 `feedback_msg_id_text_reconciliation`) |
| 5 | ❌ 대조표·사내 DB 확인 없이 "적당한 번호" 신규 채번 (중복/충돌) |

---

## §3. 의무 절차 (4단계 — 반드시 순서대로)

### Step 1 — AS-IS 원문 확보
AS-IS `MSG#####` 의 **실제 문구(한글)** 를 확보한다: `TB_FX_MessageInfo`(AS-IS DB) 또는 분석서 validation.md 의 원문. ID 만으로 진행 금지.

### Step 2 — 대조표 확인 (1차 소스)
`_artifacts/MESSAGE_ASIS_vs_TOBE_대조.xlsx` 에서 해당 AS-IS ID 행을 확인:
- **`한글 상이` 컬럼 = Y** → 같은 ID 재사용 즉시 금지.
- **`AS-IS 한글 일치 TO-BE MSG_ID` 컬럼**(2026-07-16 추가, 정규화 일치 실측) 에 값이 있으면 → 그것이 변환 대상 TO-BE ID.

실측 재매핑 확정분 (AS-IS ID → 같은 문구를 가진 TO-BE ID):

| AS-IS | AS-IS 문구 | → TO-BE |
|---|---|---|
| MSG00004 | {0}개의 데이터가 저장되었습니다. | **MSG00672** |
| MSG00006 | 저장에 실패하였습니다. | **MSG00003** |
| MSG00097 | 권한을 가진 Division이 없습니다. | **MSG00667** |
| MSG00133 | 수정한 내용이 없습니다. | **MSG00004** |
| MSG00142 | Edit Mode 에서는 수행할 수 없습니다. | **MSG00668** |
| MSG00155 | 조회 조건이 저장되었습니다. | **MSG00010** |
| MSG00225 | 실적 수량보다 작은 숫자를 넣을 수 없습니다. | **MSG00666** |
| MSG00259 | 조회 후 수정모드로 가능합니다. | **MSG00662** |
| MSG00276 | 조회 기간은 6년 이상 설정 할 수 없습니다. | **MSG00677** |
| MSG00282 | 변경된 환율을 적용하시겠습니까? | **MSG00678** |
| MSG00289 | Business Plan 데이터는 정수로 입력해 주세요 | **MSG00679** |
| MSG00307 | 해외법인 기여도 미 맵핑된 마스터가 존재합니다. | **MSG00631** |
| MSG00397 | 저장된 검색조건을 초기화 하겠습니까? | **MSG00009** |
| MSG00464 | 수정할 수 없는 메져입니다. | **MSG00671** |

> 대조표는 스냅샷(2026-07-16). 신규 채번이 계속 발생하므로 **Step 3 에서 사내 DB 재실측이 최종 판정**.

### Step 3 — 분기 결정 (사내 DB 실측 기준)
사내 `SCM_ADM_MSG_M`(KO) 에서 AS-IS 문구를 검색(공백·개행·선행 `_` 정규화 일치)하여:

| 분기 | 조건 | 조치 |
|---|---|---|
| (a) **EXACT 재사용** | 동일 문구의 TO-BE ID 존재 | 그 **TO-BE MSG_ID 사용** (대조표 매칭 컬럼 = 후보, DB 실측 = 확정) |
| (b) **신규 채번** | 동일 문구 없음 | 사내 `MAX(MSG_ID)` **실측** + 1 채번 (hook #98 §7 — 추측 채번 금지) + KO/EN/CN 3언어 MERGE 등록 + 이관 SQL |
| (c) **동일 유지** | AS-IS ID = TO-BE ID 이고 **문구도 일치** (대조표 `한글 상이` 공란) | 그대로 사용 가능 (61 공통 중 7건뿐 — 반드시 대조표로 확인 후) |

### Step 4 — 검증 (POST-WRITE 게이트)
```bash
# 작성물에서 사용한 MSG ID 전수 추출
grep -roE "MSG[0-9]{5}" {작성 파일들} | sort -u
```
- 추출된 **각 ID 를 사내 `SCM_ADM_MSG_M` 실문구와 대사**하여 "이 화면에서 의도한 의미"와 일치하는지 표로 보고 (ID / 의도 문구 / DB 실문구 / 일치 여부).
- 1건이라도 불일치 = anti-simplification 위반, 수정 후 재검증.
- `__asis-mapping__.md` Validation 축에는 **AS-IS ID → TO-BE ID 변환 관계를 명시** (예: `AS-IS MSG00225 → TO-BE MSG00666`).

---

## §4. 요약 (한 줄 룰)

> **AS-IS 의 MSG_ID 는 "번호"가 아니라 "문구"로 이관한다.** ID 를 복사하지 말고, ① AS-IS 문구 확보 → ② 대조표 매칭 컬럼 확인 → ③ 사내 DB 실측으로 EXACT 재사용/신규 채번/동일 유지 3분기 → ④ 사용 ID 전수 실문구 대사 보고.
