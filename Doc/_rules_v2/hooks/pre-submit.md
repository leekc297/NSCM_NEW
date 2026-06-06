# Hook — pre-submit (PR 제출 직전 최종 검증)

> **트리거**: PR 작성 / 제출 직전 (모든 작업 종료 직후)
>
> **목적**: 룰 v2 전체 통합 검증 + 격차 매핑 확인 + AS-IS 4축 cross-check

---

## §0 PR 머지 게이트 체크리스트

### §0.1 신규 화면 작성 시 (필수)

- [ ] **5종 자료 모두 작성** (룰 25 §1.5):
  - [ ] AS-IS `.cs` + `.Designer.cs` 정밀 분석 (`_asis/02_screens/{MENU_ID}/__analysis__.md` 13 category 100% 채움)
  - [ ] xlsx 12 시트 (`_analysis/_screens/{27|28|29|30|31|32}_*/{prefix}{MENU_ID}.xlsx`)
  - [ ] 8 MD 폴더 (`_analysis/domain_{X}/screens/{MENU_ID}/`)
  - [ ] 룰셋 v2 의 적용 룰 진입점 3 파일 모두 read 완료
  - [ ] Hook (pre/post/이 hook) 모두 실행

- [ ] **__asis-mapping__.md 작성** (4축 100% 매핑):
  - [ ] Event 매핑 (모든 cell event / combo event / button click)
  - [ ] API 매핑 (모든 `DataService.*` / `FoxDataClient.*` 호출 → TO-BE `useTabProcQuery` / `useProcMutation`)
  - [ ] Validation 매핑 (모든 `MessageHelper.GMessageBox` → `setAlert` / `setConfirm`)
  - [ ] Expression 매핑 (모든 `LockColumn` / `SetValue` Auto-Sync → column meta / cellEditEnded)
  - [ ] Button 매핑 (모든 CRUD 6대 + Search Aux 4대 → `hotkeyConfig`)

### §0.2 코드 품질

- [ ] **자동 검증 grep 통과** (post-write 의 §0):
  - [ ] FE: 상대 경로 / console.log / inline style / 빈 handler / Box import / FlexGrid 직접 사용 = 0
  - [ ] BE: @Autowired / 직접 ResponseEntity / println / SQL hardcoding / secret = 0
  - [ ] SQL: INSERT ALL / MSSQL 키워드 / UPPR 대문자 / SHT_NM 자유명 = 0

- [ ] **타입 / 빌드**:
  - [ ] FE `pnpm type-check` 통과 (turbo 직접 호출 권장 — pnpm install 금지)
  - [ ] BE `./gradlew compileJava` 통과
  - [ ] Lint `pnpm lint` 또는 `./gradlew spotlessCheck` 통과

### §0.3 메타 SQL (7-BLOCK) 등록

- [ ] **BLOCK 1**: i18n (LBL + MSG) — KO/EN/CN 3 언어 모두
- [ ] **BLOCK 2**: `SCM_ADM_MNU_M` — MNU_ID + MNU_NM + MNU_URL (slug only) + UPPR_MNU_ID (PascalCase) + MNU_TP_CD='SCREEN'
- [ ] **BLOCK 3**: `SCM_ADM_MNU_M_SHEET` — SHT_NM='main' (단일 sheet)
- [ ] **BLOCK 4**: `SCM_ADM_PROC_M` — 모든 SP 의 IN/OUT camelCase 매핑 (sesUserId/sesLangCd/mnuId)
- [ ] **BLOCK 5**: `SCM_ADM_API_M` — API_TP_CD NOT NULL + API_MSG_ID NOT NULL
- [ ] **BLOCK 6**: `SCM_ADM_MNU_M_SHEET_COLUMNS` — 모든 grid column 메타 (`_inputEditType` 등)
- [ ] **BLOCK 7**: 권한 2 테이블 — `USER_GR_MNU_MPG_M` + `USER_GR_MNU_BTN_MPG_M` (5 버튼 모두)

### §0.4 4 파일 SQL 세트

- [ ] `{N}_{MENU_ID}_metadata.sql` (메인)
- [ ] `{N}_{MENU_ID}_metadata_DBeaver.sql` (DBeaver 호환 — `SET/PROMPT/DEFINE/&/`/`` 0건)
- [ ] `{N}_{MENU_ID}_metadata_Verify.sql` (BLOCK 1~7 모두 row > 0 확인)
- [ ] `{N}_{MENU_ID}_metadata_Diagnose.sql` (실패 시)

### §0.5 격차 신규 구현 (Phase 5 후)

- [ ] G1 (검색조건 저장/복원) 활성 (`hotkeyConfig.condition / resetCondition` 자동) — Phase 5 G1 후
- [ ] G2 (BigFilter) 사용 (DM 도메인 — `useBigFilterDM`) — Phase 5 G2 후
- [ ] G3~G10 적용 여부 화면별 결정

### §0.6 룰 위반 검출 (메모리 사고)

- [ ] `pnpm install` / `pnpm dev` / `pnpm type-check` / `pnpm build` 호출 0 건 (메모리 룰)
- [ ] `시크릿 창` 안내 0 건 (메모리 룰 — 보안 정책)
- [ ] PowerShell 한글 UTF-8 깨짐 0 건

---

## §1 통합 검증 명령

```bash
# §0.2 자동 검증 grep — 모든 grep 통과
sh _artifacts/_diagnostics/pre_submit_check.sh "{MENU_ID}"   # exit 0 = PASS

# §0.3 BLOCK 카운트 확인
sqlplus -L "$DB_CONN" @"_artifacts/{N}_{MENU_ID}_metadata_Verify.sql"
# 결과: BLOCK 1~7 모두 row > 0

# §0.4 4 파일 SQL 세트 존재
for suffix in '' '_DBeaver' '_Verify' '_Diagnose'; do
    test -f "_artifacts/{N}_{MENU_ID}_metadata${suffix}.sql" || echo "MISSING: ${suffix}"
done
```

---

## §2 적용 룰 cross-ref

| 항목 | 룰 |
|---|---|
| 5종 자료 | 룰 25 §1.5 (현재 `_dev_rules/25_NEW_SCREEN_MANDATORY_CHECKLIST.md` — Phase 4 archive 후 룰 v2 흡수) |
| 4축 매핑 | `hooks/asis-coverage-check.md` |
| FE 표준 | `_tobe/01~10.md` |
| BE 표준 | `_tobe/11.md` |
| 메타 SQL | `_tobe/12.md` |
| Routing | `_tobe/13.md` |
| 격차 | `_mapping/asis_to_tobe.md` |
