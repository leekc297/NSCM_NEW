# REPAIR SCP0122 — 2026-10-22 02:51:30

## 게이트 0회차 — BLOCK 16 / WARN 0
- ✗ P20 미이식 TODO 잔존 @SCP0122_PKG.sql:91
- ✗ P20 미이식 TODO 잔존 @SCP0122_PKG.sql:96
- ✗ P20 미이식 TODO 잔존 @SCP0122_PKG.sql:99
- ✗ P20 미이식 TODO 잔존 @SCP0122_PKG.sql:101
- ✗ P20 미이식 TODO 잔존 @SCP0122_PKG.sql:102
- ✗ P20 미이식 TODO 잔존 @SCP0122_PKG.sql:103
- ✗ P20 미이식 TODO 잔존 @SCP0122_PKG.sql:393
- ✗ P20 미이식 TODO 잔존 @SCP0122_PKG.sql:495
- ✗ P21 빈 결과셋 스텁 잔존 @SCP0122_PKG.sql:91
- ✗ P21 빈 결과셋 스텁 잔존 @SCP0122_PKG.sql:94
- ✗ P21 빈 결과셋 스텁 잔존 @SCP0122_PKG.sql:97
- ✗ P21 빈 결과셋 스텁 잔존 @SCP0122_PKG.sql:100
- ✗ P21 빈 결과셋 스텁 잔존 @SCP0122_PKG.sql:101
- ✗ P21 빈 결과셋 스텁 잔존 @SCP0122_PKG.sql:103
- ✗ P21 빈 결과셋 스텁 잔존 @SCP0122_PKG.sql:389
- ✗ P00 ASIS 원문 블록 3개 잔존 — 이식 후 삭제 @SCP0122_PKG.sql

## Claude 1회차 (exit 0)
```
려고 I/U/D 실제 저장은 실행하지 않았습니다.

## 남은 항목
1. **게이트 재실행 필요:** `node tools/Harness/check-pkg.js SCP0122`를 직접 실행하거나 실행을 허용해 주세요.
2. **배포 전 결정 필요:** 사내에 ZIONEX 전환본 `PKG_SCP0122`(10-09)가 이미 있습니다. 이 버전의 SAVE는 `^` CLOB 6개를 받고 결과 컬럼이 `RESULT_CODE/RESULT_CNT`입니다. 이번 파일을 적용하면 이것을 덮어써서 시그니처가 바뀝니다. 그래서 `@SCP0122_PKG.sql` 적용과 registration 재실행은 하지 않았습니다.
3. **같은 본문 중복:** `P_SCP0121_GET_SEARCH_INFO`와 같은 본문이 `PKG_SCP0121`에도 있습니다. 둘 다 유지할지 정해야 합니다.
4. **AS-IS와 의도적으로 다르게 한 부분:**
   - 저장 중 오류가 나면 전체를 롤백합니다. AS-IS는 오류 전에 처리한 행이 일부 커밋될 수 있습니다.
   - 결과 커서는 CODE/MSG/EVENT 규약을 따르고, EVENT에 처리 행수를 넣습니다.
   - 이력 SP는 오류를 삼키지 않고 위로 전달합니다.
   - O_RC2와 O_RC3의 `'-'`는 AS-IS가 실제 값으로 쓰는 것이라 그대로 두었습니다(센티널 아님).
5. **FE 저장 미구현:** JSON 키는 컬럼명을 camelCase로 바꿔 `opmzPrsCd`, `preOpmzActvCd` 등으로 가정했습니다. FE를 구현할 때 이 키와 맞춰야 합니다.
6. **임시 파일 3개 삭제 필요:** 삭제 권한이 막혀 남아 있습니다.
   - `_artifacts/_diagnostics/_tmp_SCP0122_PORTCHK.sql`
   - `_artifacts/_diagnostics/_tmp_scp0122_portchk.py`
   - `_artifacts/_diagnostics/_tmp_scp0122_portchk_cmp.py`

상세 내용은 [SCP0122_PKG_NOTES.md](Doc/gen/SCP0122/SCP0122_PKG_NOTES.md)에, 이식본은 [SCP0122_PKG.sql](Doc/gen/SCP0122/SCP0122_PKG.sql)에 있습니다.
Ignoring --allowedTools rule "*)": Wildcard tool name "*)" is not supported in allow rules. An allow pattern must name the scope it widens — globs are permitted only in the tool position after a literal mcp__<server>__ prefix. Deny and ask rules accept wildcards anywhere.
Ignoring --allowedTools rule "*)": Wildcard tool name "*)" is not supported in allow rules. An allow pattern must name the scope it widens — globs are permitted only in the tool position after a literal mcp__<server>__ prefix. Deny and ask rules accept wildcards anywhere.
Ignoring --allowedTools rule "*)": Wildcard tool name "*)" is not supported in allow rules. An allow pattern must name the scope it widens — globs are permitted only in the tool position after a literal mcp__<server>__ prefix. Deny and ask rules accept wildcards anywhere.
Ignoring --allowedTools rule "*)": Wildcard tool name "*)" is not supported in allow rules. An allow pattern must name the scope it widens — globs are permitted only in the tool position after a literal mcp__<server>__ prefix. Deny and ask rules accept wildcards anywhere.
Ignoring --allowedTools rule "*)": Wildcard tool name "*)" is not supported in allow rules. An allow pattern must name the scope it widens — globs are permitted only in the tool position after a literal mcp__<server>__ prefix. Deny and ask rules accept wildcards anywhere.
```

## 게이트 1회차 — BLOCK 0 / WARN 0

**PASS** (WARN 0) — 1회 수선
