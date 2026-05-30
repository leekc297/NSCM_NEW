# Hook — Figma frame ↔ NSCM 화면 ID 매핑 검증

> ⭐ Figma frame name 을 NSCM 화면 ID 로 매핑할 때 **DB cross-check 의무**
> 작성: 2026-05-30 (Stage 1 매핑 사고 후)
> 관련 룰: [31_FIGMA_DESIGN_INTEGRATION.md §6.1](../31_FIGMA_DESIGN_INTEGRATION.md)
> 상위 hook: [anti-simplification.md](anti-simplification.md)

---

## §0. 발동 조건

다음 작업 진행 시 본 hook 자동 적용:
- Figma file 의 frame → NSCM 화면 ID **매핑 표 작성**
- `Doc/_figma/screens/{화면ID}.md` **신규/갱신**
- `_figma_screen_mapping*.csv` **생성/정정**
- `extract-figma-bulk.ps1` 실행 결과 적용

---

## §1. 사고 사례 (반복 금지)

### 사례 1: 단순 token 공유로 false positive (2026-05-30)

| frame name | 잘못 매핑 (fuzzy) | 정확 매핑 | 발견 방법 |
|---|---|---|---|
| `프로시저 세팅` | SYS0010 (lookup) | **SYS0005** (procedure-management) | DB cross-check |
| `Batch Log` | SYS0010 (lookup) | **DB 미매핑** (별도 화면 추정) | DB cross-check |
| `Sales Monitoring` | DMF0004 (sales-site) | DMF0048 (Claude 수동 추론) | frame name 의미 분석 |
| `Customer FCST Waterfall` | DMF0007 (customer-fcst-master) | DMF0053 (Claude 수동 추론) | frame name 의미 분석 |
| `Biz Plan Waterfall` | DMF0022 (sales-plan-waterfall) | DMF0051 (Claude 수동 추론) | frame name 의미 분석 |

**근본 원인**:
- Stage 1 의 자동 fuzzy match 는 단순 token 공유 (예: "Sales" 또는 "Lookup") 만 봄
- HIGH (=100, URL 완벽 일치) 외의 MID/LOW 는 **모두 false positive 가능성** 보유
- Claude 가 frame name 의 의미 (한국어 / 디자인 카테고리) 를 보고 추측해야 정확

---

## §2. 매핑 작업 시 의무 절차 (3단계)

### Step 1. DB ground truth 확인 (필수)

```sql
SELECT M.MNU_ID, NVL(M.MNU_URL,'-') AS MNU_URL,
       NVL(MAX(CASE WHEN MSG.LANG_CD='ko' THEN MSG.MSG_NM END),'-') AS KO,
       NVL(MAX(CASE WHEN MSG.LANG_CD='en' THEN MSG.MSG_NM END),'-') AS EN,
       M.USE_YN
  FROM SCM_MGR.SCM_ADM_MNU_M M
  LEFT JOIN SCM_MGR.SCM_ADM_MSG_M MSG ON MSG.MSG_ID = M.MNU_MSG_ID
 WHERE M.MNU_TP_CD IN ('SCREEN','POPUP')
 GROUP BY M.MNU_ID, M.MNU_URL, M.USE_YN
 ORDER BY M.MNU_ID;
```

이 결과가 NSCM 화면 ID 의 **유일한 진실 source**. 이전 5 화면 삭제 (DMF0008/0020/0043/0043_01/0072) 는 DB 미존재이나 차후 재개발용으로 매핑 가능 (메모리 `feedback_no_5_screen_dev_yet.md` 등 참조).

### Step 2. 매핑 후보 분류

| 신뢰도 | 조건 | 자동 채택 |
|---|---|---|
| **HIGH (=100)** | frame_name (lowercase, token-stripped) ≡ menu URL | ✅ 자동 채택 |
| MID (40~99) | token 일부 공유 | ❌ **모두 사용자 검토** (false positive 매우 많음) |
| LOW (<40) | token 공유 적음 | ❌ 디자인 요소 (Group N, 404 등) — 미매핑 |
| MANUAL | Claude 가 frame name 의미로 추론 | ❌ **사용자 명시 검토 요청** 필수 |

### Step 3. 매핑 결과 검증

매핑 표 작성 후 **반드시** 다음 cross-check 5가지:

1. **DB 존재 확인**: 매핑된 모든 screen_id 가 `SCM_ADM_MNU_M` 에 row 존재
2. **URL 의미 일치**: `MNU_URL` 이 frame name 과 의미적으로 일치 (예: `procedure-management` ↔ "프로시저 세팅") — Claude 가 검토
3. **5 화면 예외**: DMF0008/0020/0043/0043_01/0072 는 DB 미존재 OK (차후 재개발)
4. **USE_YN=N**: DB 매핑은 정확하나 화면 비활성 — 매핑 유지 + 표기
5. **사용자 알림**: 모든 MANUAL 매핑은 사용자에게 표 형식으로 보고 + 검토 요청

---

## §3. Figma fuzzy match 의 한계 (인정 사항)

| 케이스 | fuzzy match 결과 | 정정 방법 |
|---|---|---|
| 한국어 frame (예: "해외법인 기여율 등록") | score=0 (영문 DB 와 매칭 불가) | Claude 수동 매핑 (의미 기반) + 사용자 검토 |
| frame name 이 sub-feature (예: "MKT FCST Waterfall") | 메인 화면명 만으로 매칭 → 정밀도 ↓ | NSCM 화면명/i18n 한글명 함께 사용자에게 제시 |
| Figma 의 "Group N" / "Insert" / "Popup" 같은 디자인 요소 | matched_screen_id = '' | LOW_UNMAPPED 로 표기 + 미매핑 |

---

## §4. PR 머지 게이트 (매핑 변경 시)

매핑 변경 commit 의 PR 에는 다음 표 첨부 의무:

```markdown
## 매핑 정확도 검증 (DB cross-check)

| confidence | 건수 | DB 존재 | URL 의미 일치 | 비고 |
|---|---:|---:|---:|---|
| HIGH_AUTO | N | N | N | URL 완벽 일치 |
| MANUAL | N | N | N (사용자 검토) | Claude 수동 |
| MID_REJECTED | N | - | - | fuzzy 결과 폐기 |
| LOW_UNMAPPED | N | - | - | 디자인 요소 |
```

PR Reject 사유:
- DB 미존재 매핑이 5 화면 예외가 아닌데 존재
- MANUAL 매핑에 사용자 검토 요청 누락
- 매핑 정정 사고 (§1) 의 재발

---

## §5. Cross-Reference

- 룰 31 §6.1 (Frame name → 화면 ID 매핑 사고 패턴)
- 룰 31 §6.2 (Free plan rate limit 정책)
- anti-simplification.md (단순화 절대 금지 — 본 hook 의 상위)
- 메모리 `feedback_figma_mapping_db_crosscheck.md` (의무 절차)
