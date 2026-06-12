# Hook — i18n KO=EN 전체 통일 (다국어 영문화 정책)

> ⭐ **사용자 명시 요구 (2026-06-12)**:
> "다국어 전체 영문으로 일괄 적용해주세요" — 한글(KO) 의 **모든 i18n 항목** 을 영문(EN) 과 동일하게 통일.
> 적용 범위 = `MNU_*` / `TITLE_*` / `LBL_*` / `BTN_*` / `MSG_*` / `TOOLTIP_*` / `PLH_*` 전부.
> KO 전용 키 (EN 미존재) 는 그대로 유지.
> **CN(중국어) 는 본 룰 적용 안 함** — 별도 번역 유지.

작성: 2026-06-12 (DMF0020 메뉴/UI "Sales Price" 변경 → 정책 확장 → KO 전체 영문화)
갱신: 2026-06-12 (적용 범위 4종 한정 → 전체 확장)
관련 룰: `Doc/_rules_v2/_tobe/05_constants.md` §LBL 5자리 / `12_metadata_sql.md` §i18n

---

## §0. 적용 범위

| 항목 | KO=EN 통일? | 비고 |
|---|:---:|---|
| **모든 KO i18n 키 (EN 에도 존재)** | ✅ **의무** | KO MSG_NM = EN MSG_NM 정확 동일 |
| KO 전용 키 (EN 미존재) | ⚠ **유지** | EN 추가 후 통일 권장 |
| CN(중국어) | ❌ **별도** | 본 룰 적용 안 함 — 기존 번역 유지 |

> 이전 룰 (2026-06-12 오전): MNU_/TITLE_/LBL_/BTN_ 한정.
> 신규 룰 (2026-06-12 오후): **전체 확장** — 사용자 명시 정책 변경.

---

## §1. PRE-WRITE 체크리스트 (i18n 키 신규 작성 직전)

### 1.1 신규 i18n 키 추가 시

- [ ] KO.json + EN.json 두 파일 **반드시 동시 편집**
- [ ] KO 와 EN 의 값을 **글자/공백까지 정확히 동일**하게 작성
- [ ] CN.json 은 본 정책 적용 안 함 — 기존 번역 또는 영문 fallback

### 1.2 DB SCM_ADM_MSG_M 신규 등록 시

- [ ] KO row 와 EN row 의 `MSG_NM` 동일 의무
- [ ] CN row 는 별도 번역 또는 영문 입력 가능

---

## §2. POST-WRITE 자동 검증

작성 직후 KO/EN 일치 검증:

```bash
# locales 파일 KO/EN 값 비교 (전체)
python -c "
import json
KO = json.load(open('nscm-fe/public/locales/KO.json', encoding='utf-8'))
EN = json.load(open('nscm-fe/public/locales/EN.json', encoding='utf-8'))
mismatch = [(k, KO[k], EN[k]) for k in KO if k in EN and KO[k] != EN[k]]
print(f'KO!=EN: {len(mismatch)}')
for k, ko, en in mismatch[:30]:
    print(f'  {k}: KO=\"{ko}\" vs EN=\"{en}\"')
"
```

⚠ 검출 시 KO 값을 EN 값으로 일괄 통일.

---

## §3. DB i18n 검증/정정 SQL (전체)

```sql
-- KO != EN 검출
SELECT k.MSG_ID, k.MSG_NM AS KO_VAL, e.MSG_NM AS EN_VAL
  FROM SCM_ADM_MSG_M k
  JOIN SCM_ADM_MSG_M e ON k.MSG_ID = e.MSG_ID
 WHERE k.LANG_CD = 'KO' AND e.LANG_CD = 'EN'
   AND k.MSG_NM <> e.MSG_NM;

-- 일괄 정정 (전체) — KO 를 EN 값으로 통일
UPDATE SCM_ADM_MSG_M k
   SET MSG_NM = (SELECT e.MSG_NM FROM SCM_ADM_MSG_M e
                  WHERE e.MSG_ID = k.MSG_ID AND e.LANG_CD = 'EN'),
       LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE
 WHERE k.LANG_CD = 'KO'
   AND EXISTS (SELECT 1 FROM SCM_ADM_MSG_M e
                WHERE e.MSG_ID = k.MSG_ID AND e.LANG_CD = 'EN'
                  AND e.MSG_NM <> k.MSG_NM);
```

---

## §4. 일괄 정정 Python 스크립트 (참고)

```python
import json
with open('nscm-fe/public/locales/KO.json', encoding='utf-8') as f: KO = json.load(f)
with open('nscm-fe/public/locales/EN.json', encoding='utf-8') as f: EN = json.load(f)
changed = 0
for k in KO:
    if k in EN and KO[k] != EN[k]:
        KO[k] = EN[k]
        changed += 1
with open('nscm-fe/public/locales/KO.json', 'w', encoding='utf-8') as f:
    json.dump(KO, f, ensure_ascii=False, indent=2); f.write('\n')
print(f'replaced: {changed}')
```

---

## §5. 적용 사례

### 5.1 DMF0020 메뉴 명칭 (2026-06-12 오전)

- AS-IS: KO="향후 단가 관리" / EN="Sales Future Price" / CN="未来销售单价管理"
- 사용자 명시: 메뉴/UI "Sales Price" 통일
- 조치: DB MNU_M.MNU_DESC + MSG_M(KO/EN) + FE locales KO/EN 모두 "Sales Price". CN 그대로.

### 5.2 다국어 전체 영문화 (2026-06-12 오후)

- 사용자 명시: "다국어 전체 영문으로 일괄 적용"
- 조치:
  - **FE**: `KO.json` 의 89개 키 값 → `EN.json` 동일 값 일괄 덮어쓰기. 18개 KO-only 키 유지.
  - **DB**: `SCM_ADM_MSG_M` KO row 53건 → EN row MSG_NM 일괄 UPDATE.
  - **CN**: 변경 없음 (사용자 별도 지시 없음).
- 룰 확장: 적용 범위 4종 한정 → 전체 확장.

---

## §6. 예외

| 상황 | 처리 |
|---|---|
| 사용자가 한국어 별도 작성 명시 | 본 룰 무시, 사용자 지시 우선 |
| KO 전용 키 (EN 미존재) | 그대로 유지 — EN 등록 후 통일 권장 |
| CN(중국어) | 본 룰 적용 안 함 |

---

## §7. 관련 hook + 룰 cross-ref

- `Doc/_rules_v2/_tobe/05_constants.md` — LBL 5자리 표준 / i18n 키 패턴
- `Doc/_rules_v2/_tobe/12_metadata_sql.md` — DB i18n MSG_M 등록 패턴
- `Doc/_rules_v2/hooks/asis-msg-inventory.md` — AS-IS MSG ID 인벤토리
- `Doc/_rules_v2/anti-simplification.md` — 정책 위반 = 신뢰성 손상

**중요**: 본 hook 위반은 사용자 신뢰성 손상 — anti-simplification 의무 적용.
