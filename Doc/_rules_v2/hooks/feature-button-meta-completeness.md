# Hook — 기능 버튼 메타 등록 완전성 의무 (2026-06-20)

> 사용자 명시 (2026-06-20, DMF0072 fix 중) — **rule 로 추가**.
> 위반 시: AS-IS 에 실제 기능이 있고 FE handler 도 구현됐는데 버튼이 화면에 표시 안 됨 (useTabBtnPermissions 의 `hasButton()` 가 false 반환).

---

## §0. 배경 — DMF0072 사례 (2026-06-20)

DMF0072 NN Master Mapping 화면:
- AS-IS .cs: `InsertButton()` L270 / `DeleteButton()` L275 / `SaveData()` L604 — **실제 기능 구현 존재**.
- FE: `handleInsert` / `handleDelete` / `handleSave` 함수 구현 완료, hotkeyConfig 에 매핑됨.
- 메타 (`010_DMF0072_meta_full.sql`): `SCM_ADM_MNU_BTN_MPG_M` 에 **SEARCH + SAVE 2 BTN_CD 만 등록** — INSERT/DELETE 누락.

**결과**: 사용자 진입 시 BE `GET /admin/menu/DMF0072/auth` 응답 `mnuBtnAuth=['SEARCH','SAVE']` → `hasButton('INSERT')=false`, `hasButton('DELETE')=false` → 4 버튼 중 2 버튼 (또는 모두) 숨김. **AS-IS 기능 손실**.

이런 사고가 반복되어 사용자가 "rule 로 추가" 요구.

---

## §1. 원칙 — AS-IS 기능 ↔ BTN_MPG_M ↔ FE handler 3 단계 정합

화면의 **모든 실제 기능 (CRUD + 화면 특화 액션)** 은 3 단계 모두 등록 의무:

1. **AS-IS .cs 분석**: `protected override void XxxButton()` 의 body 가 비어있지 않은가? (빈 override 는 의도된 비활성)
2. **FE handler 구현**: `handleXxx` 함수 + hotkeyConfig 매핑
3. **메타 등록** (3 SQL 모두 의무):
   - `SCM_ADM_MNU_BTN_MPG_M` : 메뉴-버튼 매핑 (BTN_CD + API_ID)
   - `SCM_ADM_USER_GR_MNU_BTN_MPG_M` : 권한 그룹 매핑 (GUEST + sister 그룹 + 운영자 USER_GR)
   - (필요 시) `SCM_ADM_API_M` : API endpoint 정의 (BTN_CD 가 BE 호출 시)

---

## §2. PRE-WRITE 점검 (화면 작성 시)

| # | 점검 항목 | 확인 방법 |
|---:|---|---|
| 1 | AS-IS `.cs` 의 protected override 4종 (Insert/Delete/Save + 화면 특화) body 검사 | grep `protected override void [A-Z][a-z]+Button` → 빈 body (`{}`) 는 의도 비활성, 아닌 것은 의무 |
| 2 | FE hotkeyConfig 매핑 누락 0건 | `rg "hotkeyConfig" {screen}.tsx` — search/insert/save/delete 각 키 명시 (또는 의도된 false) |
| 3 | 화면 특화 액션 (Status Update / Excel Export / Refresh 등) FE 구현 → customButtons 매핑 | `customButtons` prop 검토 |
| 4 | BTN_CD 표준 (#표준값 7종): SEARCH / SAVE / INSERT / DELETE / EXCEL / EXECUTE / 화면특화 (예: STATUS_UPDATE) | 비표준 BTN_CD 0건 — DMF0008 145 / DMF0072 080 reference |
| 5 | useTabBtnPermissions 도입 시 모든 hotkeyConfig handler 가 `hasButton(BTN_CD) ? handler : false` 형태 | `rg "hasButton" {screen}.tsx` |

---

## §3. 메타 등록 의무 (3 SQL 모두)

### §3.1 SCM_ADM_MNU_BTN_MPG_M
```sql
INSERT INTO SCM_MGR.SCM_ADM_MNU_BTN_MPG_M
  (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN, ...)
SELECT '{MNU_ID}', 'main', NEW.MNU_BTN_CD, NEW.API_ID, 'Y', ...
  FROM (
    SELECT 'SEARCH' AS MNU_BTN_CD, '{P_API_SEARCH}' AS API_ID FROM DUAL UNION ALL
    SELECT 'INSERT',                NULL                       FROM DUAL UNION ALL  -- FE handler 만 (BE 호출 없음)
    SELECT 'SAVE',                  '{P_API_SAVE}'             FROM DUAL UNION ALL
    SELECT 'DELETE',                NULL                       FROM DUAL
  ) NEW
 WHERE NOT EXISTS (SELECT 1 FROM ... );
```

**핵심 점검**: AS-IS 의 모든 활성 기능에 대해 BTN_CD row INSERT. 누락 = useTabBtnPermissions 가드에서 false → 버튼 숨김.

### §3.2 SCM_ADM_USER_GR_MNU_BTN_MPG_M
```sql
-- GUEST 직접 시드 (필수)
INSERT INTO SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M
  (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN, ...)
SELECT 'GUEST', '{MNU_ID}', NEW.SHT_NM, NEW.MNU_BTN_CD, 'Y', ...
  FROM (
    SELECT 'main' AS SHT_NM, 'SEARCH' AS MNU_BTN_CD FROM DUAL UNION ALL
    SELECT 'main',           'INSERT'              FROM DUAL UNION ALL
    SELECT 'main',           'SAVE'                FROM DUAL UNION ALL
    SELECT 'main',           'DELETE'              FROM DUAL
  ) NEW
 WHERE NOT EXISTS (...);

-- sister 그룹 동적 복사 (자매 화면 권한자 자동 매핑)
INSERT INTO SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M (...)
SELECT DISTINCT u.USER_GR_ID, '{MNU_ID}', 'main', T.MNU_BTN_CD, 'Y', ...
  FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M u
 CROSS JOIN (모든 BTN_CD) T
 WHERE u.MNU_ID IN (sister 화면) AND u.MNU_BTN_CD='SEARCH' AND u.USE_YN='Y'
   AND NOT EXISTS (...);
```

**핵심 점검**: GUEST + sister 자동 복사 둘 다 필요. GUEST 만 시드하면 일반 사용자 환경에서 버튼 안 보임.

### §3.3 SCM_ADM_API_M (BTN_CD → API_ID 가 BE 호출 시)
- SEARCH / SAVE 등 BE 호출이 있는 BTN_CD 만 등록
- INSERT / DELETE 는 FE 만 처리하므로 API_ID = NULL

---

## §4. POST-WRITE 검증 (사내 적용 후)

### §4.1 BE 응답 확인
```bash
# DevTools Network 또는 curl
curl -X GET http://localhost:8080/admin/menu/{MNU_ID}/auth
# 응답: { "result": { "mnuBtnAuth": ["SEARCH","SAVE","INSERT","DELETE",...] } }
# 기대: AS-IS 의 모든 활성 기능 BTN_CD 포함
```

### §4.2 DB 인벤토리
```sql
-- BTN_MPG_M 등록 확인
SELECT SHT_NM, MNU_BTN_CD, API_ID, USE_YN
  FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID='{MNU_ID}' ORDER BY SHT_NM, MNU_BTN_CD;
-- 기대: 모든 활성 기능 row 존재

-- USER_GR 권한 분포 확인
SELECT USER_GR_ID, COUNT(*) AS BTN_CNT
  FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE MNU_ID='{MNU_ID}' AND SHT_NM='main'
 GROUP BY USER_GR_ID ORDER BY 1;
-- 기대: GUEST 포함 / sister 그룹 자동 복사 N개
```

### §4.3 화면 검증
- 화면 진입 시 hotkeyConfig 의 모든 활성 버튼 표시 확인
- console.warn 또는 alert 없음 확인

---

## §5. 적용 표 (점검 인벤토리)

| 화면 | AS-IS Insert/Delete/Save | BTN_MPG_M 등록 | GUEST USER_GR | sister 복사 | 상태 |
|---|:---:|:---:|:---:|:---:|---|
| DMF0008 (erp-edi-master) | Insert ✓ / Save ✓ / Delete (빈 override) | 4 BTN (S/I/S/STATUS_UPDATE) | ✓ | ✓ (DMF0005) | 정상 (delete 의도 비활성) |
| DMF0072 (nn-master-mapping) | Insert ✓ / Delete ✓ / Save ✓ | **신규 보강 (2026-06-20 080)** | ✓ (보강) | ✓ (DMF0004/0005) | 2026-06-20 fix 완료 |
| SYS0011 (auth-request) | Insert/Delete/Save 모두 빈 override (의도 비활성) — 실 활성 = SEARCH/ADD/DELETE/REQUEST 4종 | 실 사용 6 row (`authority.SEARCH` / `division.SEARCH` / `myAuthorityList.SEARCH/SAVE` / `userInfo.SEARCH/SAVE`) — `ADD/DELETE/REQUEST` 는 `TitleArea.rightButtons` + `customButtons` 매핑 (메타 권한 별도 불필요) | ✓ | ✓ (SCM0008 → SYS0011 rename 시 사용자 그룹 복사) | 2026-06-20 audit — 사내 BTN_MPG_M 의 legacy `API_SCM0008_*` 참조 7 row dead cleanup (`19_sys0011_dead_meta_cleanup.py`) |
| 기타 master 도메인 ≥ Insert/Delete | ? | ? | ? | ? | **일괄 점검 대상** |

---

## §6. RULESET_MASTER §3 UI-MANDATORY 통합

PRE-WRITE:
- ✅ AS-IS .cs 의 protected override 4종 body 검사 → 활성 기능 인벤토리
- ✅ hotkeyConfig 모든 BTN handler 명시 (또는 의도된 false)
- ✅ BTN_MPG_M + USER_GR_BTN_MPG_M + API_M 3 SQL 모두 작성

POST-WRITE:
- 사내 DB 적용 후 BE `/auth` endpoint 응답에 모든 BTN_CD 포함 확인
- 화면 진입 시 모든 활성 버튼 표시 확인 (DevTools console 0 warn)

### §6.1 자동 점검 grep
```bash
# AS-IS 활성 기능 추출
grep -nE "protected override void (Insert|Delete|Save)Button" {asis_cs} | grep -v "^[^{]*{\s*}\s*$"
# 결과 = N건 → BTN_MPG_M INSERT 가 N건 의무

# FE hotkeyConfig 매핑 확인
rg -n "hotkeyConfig" features/{domain}/src/pages/{screen}/{Screen}.tsx
# 결과의 search/insert/save/delete 키 명시 확인
```

---

## §7. 짝 hook

- `Doc/_rules_v2/hooks/menu-button-dynamic-fetch.md` (#24 — useTabBtnPermissions 도입 의무)
- `Doc/_rules_v2/hooks/asis-button-mapping.md` (#1 — AS-IS Button 10대 매핑)
- `Doc/_rules_v2/hooks/sheet-columns-meta-completeness.md` (짝 hook — SHEET_COLUMNS 완전성)
