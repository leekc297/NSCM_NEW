# Hook — SP EXCEPTION OTHERS 디버그 친화 패턴

> 적용 trigger: T08 (BE/SP) + T10 (DB 오류 진단)
> 신설 일자: 2026-06-10 (DMF0008_GET_SALES_SITE 진단 사고 후)
> 관련 메모리: `feedback_exception_handler_hiding_real_error.md`

---

## §0 사고 사례 (DMF0008, 2026-06-10)

**Symptom**: BE 로그 `ORA-20001: 오류가 발생했습니다. ORA-06512 at line 201`. SP body line 201 은 EXCEPTION 안 RAISE_APPLICATION_ERROR. 진짜 사고 위치는 본문 어디.

**Root cause**:
1. 표준 NextSCM Pilot EXCEPTION 핸들러가 `PR_SCM_SYS_LOG_BATCH` 호출 후 `RAISE_APPLICATION_ERROR(-20001, '오류가 발생했습니다.')` 로 generic raise.
2. **실제 SQLCODE/SQLERRM 손실** — BE 가 generic message 만 받음 → 진단 시 어디서 사고났는지 추적 불가.
3. 로컬 docker DB 에 `SCM_SYS_LOG` 테이블 미존재 → `PR_SCM_SYS_LOG_BATCH` 자체가 raise → cascade fail.

진단 사고 사례 — 진짜 원인 (`ORA-06533 at line 54`) 발견까지 30분 소요.

---

## §1 의무 매트릭스

| 환경 | EXCEPTION 패턴 | 이유 |
|---|---|---|
| **개발/로컬 docker** | RAISE_APPLICATION_ERROR 에 `SQLCODE/SQLERRM/BACKTRACE` 명시 포함 | 진단 / 사고 추적 용이 |
| **운영 (클라우드)** | 표준 generic message + `PR_SCM_SYS_LOG_BATCH` 정상 (SCM_SYS_LOG 존재) | 보안 + UX 일관성 |

⚠️ **로컬 docker 에서 SCM_SYS_LOG 미존재** → `PR_SCM_SYS_LOG_BATCH` 호출 NULL 처리 필수 (cascade fail 방지).

---

## §2 디버그 친화 패턴 (개발 환경 권장)

```sql
EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE   := 'ERROR';
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        -- [DEV] PR_SCM_SYS_LOG_BATCH 호출 비활성화 (SCM_SYS_LOG 미존재 환경)
        -- PR_SCM_SYS_LOG_BATCH(v_program_name, V_LOG_TYPE, ..., V_BACKTRACE);
        RAISE_APPLICATION_ERROR(-20001,
            'SQLCODE=' || V_SQL_CODE ||
            ' SQLERRM=' || V_SQL_ERRMSG ||
            ' BACKTRACE=' || SUBSTR(V_BACKTRACE, 1, 800));
END;
```

→ BE 로그 / FE alert 에 실제 SQLCODE/SQLERRM/BACKTRACE 노출 → 사고 원인 즉시 식별.

---

## §3 표준 운영 패턴 (클라우드)

```sql
EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE   := 'ERROR';
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        PR_SCM_SYS_LOG_BATCH(v_program_name, V_LOG_TYPE, N_LOG_COUNT,
                             V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE,
                             V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE);
        RAISE_APPLICATION_ERROR(-20001, '오류가 발생했습니다.');
END;
```

→ 운영 환경에서 보안 + 일관성. 디버그는 SCM_SYS_LOG 조회.

---

## §4 진단 절차 (사고 발생 시)

**Symptom**: BE 로그 `ORA-20001: 오류가 발생했습니다. ORA-06512 at line N`

**Step 1**: SP body 의 line N 위치 grep:
```sql
SELECT LINE, TEXT FROM ALL_SOURCE
 WHERE OWNER='<owner>' AND NAME='<sp_name>' AND TYPE='PROCEDURE'
   AND LINE BETWEEN N-5 AND N+5
 ORDER BY LINE;
```

**Step 2**: line N 이 EXCEPTION 안 RAISE_APPLICATION_ERROR 라면 (대부분 사고 패턴) → 실제 원인은 다른 곳.

**Step 3**: 임시 patch (디버그 친화 RAISE) 적용:
```sql
CREATE OR REPLACE PROCEDURE <sp_name> AS ... -- 기존 body
EXCEPTION
    WHEN OTHERS THEN ...
    RAISE_APPLICATION_ERROR(-20001,
        'SQLCODE=' || TO_CHAR(SQLCODE) || ' SQLERRM=' || SQLERRM ||
        ' BACKTRACE=' || SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 800));
END;
```

**Step 4**: SP 다시 호출 (BE 통해 또는 anonymous block) → 실제 SQLCODE/SQLERRM 노출 → root cause 파악.

**Step 5**: root cause fix 후 EXCEPTION 핸들러를 운영 표준으로 복원 (또는 SCM_SYS_LOG 미존재 환경은 디버그 친화 유지).

### §4.5 ⭐ `-9994` / `InvocationTargetException: null` 래퍼 벗기기 (2026-07-08 신설 — DMF0014 사고)

BE 응답 `-9994 "Sql Error"` 나 로그의 `InvocationTargetException: null` 은 **실오류를 가린 Java 래퍼**다
(`getMessage()`=null 만 저장됨). **판정 근거로 쓰지 말 것** — 권한(GRANT) 단정 금지.

실오류 확보 경로 (우선순위):

1. **`SCM_COM_SYS_LOG.EXCT_MSG_CTN`** — SystemLog aspect 가 `NCommonDAO.selectList: <전체 ORA 체인>` 을 저장 (SQL 로만 확보 가능, LENA/서버 접근 불필요):
```sql
SELECT TO_CHAR(CREATION_DATE,'HH24:MI:SS') T, MNU_ID, MNU_BTN_CD, SUBSTR(EXCT_MSG_CTN,1,1000) REAL_ERROR
  FROM SCM_COM_SYS_LOG
 WHERE MNU_ID='<MENU>' AND EXCT_MSG_CTN IS NOT NULL AND CREATION_DATE > SYSDATE - 1/24
 ORDER BY CREATION_DATE DESC FETCH FIRST 5 ROWS ONLY;
```
2. BE 콘솔/파일 로그 전체 스택의 **`Caused by:`** 줄 (dev WAS = `/logs001/lena/1.3/nscmwas01-8080/nscm.log`).
3. ⚠️ `SCM_COM_SQL_LOG.EXCEPTION` 은 래퍼 문자열로 잘려 저장 — 이 경로는 실오류 확보 불가.

**격리 판정** (BE 문제 vs SP/DB 문제): 실패 payload 그대로 **anonymous block 으로 SP 직접 호출** —
BE 접속 계정(SCMD_APP)으로도 실행. 직접호출 OK + BE 만 실패 = BE 경유 시에만 달라지는 것(세션 NLS 등,
`oracle-nls-implicit-conversion.md` #109) 의심. 직접호출도 실패 = SQLERRM 그대로 root cause.

---

## §5 자동 검증 grep

```bash
SP_FILE="<sp-body.sql>"

# 1. EXCEPTION OTHERS 안 RAISE_APPLICATION_ERROR 패턴 확인
EX_RAISE=$(grep -cE "RAISE_APPLICATION_ERROR\s*\(\s*-20001" "$SP_FILE")

# 2. SQLERRM 명시 raise 인지 (디버그 친화) 확인
DEBUG_RAISE=$(grep -cE "RAISE_APPLICATION_ERROR.*SQLERRM" "$SP_FILE")

# 3. 운영 표준 generic raise 인지 확인
GENERIC_RAISE=$(grep -cE "RAISE_APPLICATION_ERROR.*오류가 발생했습니다" "$SP_FILE")

if [ "$EX_RAISE" -gt 0 ]; then
  echo "EXCEPTION OTHERS RAISE_APPLICATION_ERROR 패턴 $EX_RAISE 건"
  echo "  - 디버그 친화 (SQLERRM 노출): $DEBUG_RAISE 건"
  echo "  - 운영 표준 (generic): $GENERIC_RAISE 건"
fi

# 4. SCM_SYS_LOG 미존재 환경에서 PR_SCM_SYS_LOG_BATCH 호출 살아있는지
ACTIVE_LOG_CALL=$(grep -cE "^\s*PR_SCM_SYS_LOG_BATCH\(" "$SP_FILE")
COMMENTED_LOG_CALL=$(grep -cE "^\s*--.*PR_SCM_SYS_LOG_BATCH\(" "$SP_FILE")
echo "PR_SCM_SYS_LOG_BATCH: active=$ACTIVE_LOG_CALL / commented=$COMMENTED_LOG_CALL"
```

---

## §6 cross-ref

- 메모리 `feedback_exception_handler_hiding_real_error.md`
- 메모리 `feedback_sp_utl_call_stack_safe_pattern.md` — 본 hook 으로 진단된 사고 원인
- 메모리 `feedback_sp_truncate_gtt_grant.md` — 비슷한 패턴 (TRUNCATE 권한 부족 → -20001 cascade)
- hook `sp-utl-call-stack-safety.md` — 본 hook 의 진단 대상 사고 패턴

---

## §7 변경 이력

| 일자 | 변경 | 이유 |
|---|---|---|
| 2026-06-10 | 신규 | DMF0008_GET_SALES_SITE 진단 사고 30분 소요 — EXCEPTION generic 가림 패턴 정형화 |
