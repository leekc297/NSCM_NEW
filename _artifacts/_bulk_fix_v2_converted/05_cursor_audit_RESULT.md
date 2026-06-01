# Stage 3e — Cursor OUT 선언 vs OPEN 실제 audit 결과

작성: 2026-06-01
관련 Plan: `C:\Users\ejene\.claude\plans\hashed-fluttering-seahorse.md`

## 결과 (audit only — bulk fix 적용 금지)

| 통계 | 수 |
|---|---:|
| Mismatch procedure | **66** |
| 총 mismatch | **107** |
| 영향 SP 파일 | 25+ |

상세: `05_cursor_audit.txt`

## Mismatch 유형

### A. NOT_OPENED — 선언했으나 OPEN 안 함 (caller FETCH 시 INVALID_CURSOR)

대표:
- `P_DMF0043_GET_MAIN_SPREAD_TITLE`: 선언 `O_RC1, O_RC2, O_RC3` / OPEN `O_RC1, O_RC3` → **O_RC2 미 OPEN**
- `P_DMF0040_GET_MKT_FCST_COMPARISON`: 선언 `O_RC1, O_RESULT_CURSOR` / OPEN `O_RESULT_CURSOR` → **O_RC1 미 OPEN**

이 패턴이 **DMF0043 prior 사고의 동형** — caller 가 O_RC2 fetch → INVALID_CURSOR.

### B. OPEN_UNDECLARED — 선언 안 했는데 OPEN

대표:
- `P_DMF0043_GET_MAIN_VARSION_DATA`: 선언 `O_RC1` / OPEN `O_RC1, O_RC3` → **O_RC3 undeclared**
- `P_DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO`: 선언 `O_RESULT_CURSOR` / OPEN `O_RC1, O_RC3` → **O_RC1, O_RC3 undeclared**

원인 가능성:
1. local cursor variable 을 OUT param 으로 오인 (auditor 의 false positive 가능)
2. AS-IS MSSQL multi-result-set → Oracle 변환 시 OUT param 누락

## ⚠️ Bulk fix 금지

- NOT_OPENED 보강: 누락 OPEN cursor 의 SELECT 본문을 모르므로 자동 작성 불가
- OPEN_UNDECLARED 보강: OUT param 추가 시 BE Mapper 의 signature 변경 동반 — caller impact 사전 확인 필수

## 권고 절차

1. **신규 화면 진입 시** 룰 25 §0.5 hook 이 해당 SP 의 cursor audit 자동 실행
2. **NOT_OPENED 발견 시** 즉시 작업 보류 + 사용자 확인
3. **OPEN_UNDECLARED 발견 시** local cursor 여부 cross-check
4. **DMF0043 의 5건 NOT_OPENED/UNDECLARED** 는 별도 task 로 SP 본문 정밀 점검 (현재 DB 의 BODY 는 이미 prior fix 로 VALID)

## 후속 룰 보강

룰 24 §4 또는 룰 21 §12 에 추가:
> SP `PROCEDURE x(... O_RCn OUT SYS_REFCURSOR ...)` 의 OUT cursor 는 모두 OPEN 의무. 미 OPEN 의 INVALID_CURSOR / OPEN 했는데 OUT 누락의 caller signature 불일치 두 패턴 모두 audit 의무.
