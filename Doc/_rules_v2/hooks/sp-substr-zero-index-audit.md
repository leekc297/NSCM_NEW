# Hook — SP body 의 SUBSTR(s, 0, n) 일괄 audit + fix

> ⚠ **^ 구분 bulk SAVE SP 작성/패치 시 의무 hook**
> Oracle `SUBSTR(s, 0, n)` 은 documented `SUBSTR(s, 1, n)` 와 동일 → ^ 구분자 포함된 token 추출 → silent fail.
> NextSCM Pilot 변환기의 광범위 결함. 다른 SAVE SP 도 잠재.

작성: 2026-06-11 (DMF0043 VersionPopup 진단 후)
상위 룰: `anti-simplification.md`
관련 메모리: `feedback_sp_substr_zero_index_pitfall.md`

---

## §0. 적용 시점

| 시점 | 행위 |
|---|---|
| **신규 화면 SAVE SP 등록** | §1 audit SQL 실행 — 해당 SP 의 SUBSTR(s, 0, n) 매치 0 검증 |
| **SAVE SP silent fail 신고** | §1 audit → 매치 시 §2 fix script 적용 |
| **사내 Oracle 전체 sweep** | 분기별 §3 광범위 audit |

---

## §1. Audit SQL — 사내 Oracle 의 모든 SAVE SP

```sql
-- 모든 SP 의 SUBSTR(v_w_*, 0, ...) 패턴 검출
SELECT NAME, COUNT(*) AS MATCHES
  FROM user_source
 WHERE type = 'PROCEDURE'
   AND REGEXP_LIKE(text, 'SUBSTR\s*\(\s*v_w_\w+\s*,\s*0\s*,', 'i')
 GROUP BY NAME
 ORDER BY MATCHES DESC;

-- 일반화 (다른 변수명 prefix)
SELECT NAME, line, text
  FROM user_source
 WHERE type = 'PROCEDURE'
   AND REGEXP_LIKE(text, 'SUBSTR\s*\(\s*\w+\s*,\s*0\s*,', 'i')
 ORDER BY NAME, line;
```

검출되면 silent fail 잠재. 사용자 영향 화면 정찰 후 §2 fix 적용.

---

## §2. Fix script 일반화

기준 파일: `_artifacts/_apply_corporate/08_dmf0043_save_substr_zero_fix.py`

복제 후 `SP_NAMES` list 만 교체:

```python
SP_NAMES = [
    "<SAVE_SP_1>",
    "<SAVE_SP_2>",
]
```

변환 패턴 (regex):
- 검출: `SUBSTR\(\s*(v_w_\w+)\s*,\s*0\s*,\s*(v_index_\w+)\s*\)`
- 치환: `SUBSTR(\1, 1, \2 - 1)`

자동 backup (`_artifacts/_diagnostics/<SP>_substr_zero_before_<ts>.sql`) + STATUS VALID 검증.

실행:
```bash
cd /c/Projects/NSCM/_artifacts/_apply_corporate
python 08_dmf0043_save_substr_zero_fix.py  # 또는 복제본
```

---

## §3. 광범위 sweep

사내 Oracle 의 모든 SAVE SP 일괄 audit:

```sql
SELECT DISTINCT name
  FROM user_source
 WHERE type = 'PROCEDURE'
   AND name LIKE '%SAVE%'
   AND REGEXP_LIKE(text, 'SUBSTR\s*\(\s*v_w_\w+\s*,\s*0\s*,', 'i')
 ORDER BY name;
```

결과 list 를 `SP_NAMES` 에 넣고 fix script 1회 실행. 멱등 (패턴 0건 SP 는 SKIP).

---

## §4. 사고 후 cross-ref

| 진단 결과 | 사고 family |
|---|---|
| FE alert "저장 완료" + DB row 미반영 | SUBSTR(s,0,n) / TRUNCATE GT_*  / mutate array payload |
| BE log o_rc1:null, code:"0", success | SUBSTR(s,0,n) (silent EXCEPTION) |
| ORA-01400 NOT NULL | dropped column NVL 빈 → FE default 채움 누락 |

전부 silent fail family. 진단 시 3 family 모두 cross-check 의무.

---

## §5. Anti-simplification

- audit SQL 의 결과를 1-pass 수동 확인 후 fix 채택 금지 — `SP_NAMES` list 전부 fix script 에 등록 후 일괄 적용
- "1개만 fix 됐으니 끝" 으로 단정 금지 — RATIO SP 처럼 이미 정상 form 인 SP 도 있음 (멱등 0건 = OK)
- backup 디렉토리 자동 보존 — 다음 사고 시 rollback 가능
