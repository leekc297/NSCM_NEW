# Hook #106 — Oracle 대량 조회/저장 CLOB 버퍼 (VARCHAR2 4000/32767 초과 방지)

> 신설: 2026-07-06 (DMF0014 / DMF0043 / DMF0048 대량 조회·저장 오류 3연발 후)
> 트리거: **동적 PIVOT 조회 SP** 또는 **'^' bulk 저장 SP** 작성/변환/디버깅 시
> 짝: `oracle-save-payload-integrity.md`(#99) / `oracle-db-workflow.md` / db_migration 부록 C
> 증상 코드: **ORA-06502**(character string buffer too small) / **ORA-40478**(output value too large, max 32767) → BE **-9994**

---

## §0. 원칙

대량(넓은 기간 / 다건 행) 처리 SP 는 문자열 변수가 **VARCHAR2(4000) / VARCHAR2(32767) 한도를 런타임에 초과**한다.
컴파일은 VALID 이나 **데이터 규모 의존**으로 폭발 → "소량은 되는데 대량만 실패"가 특징. 아래 3 패턴 변수는 **CLOB** 로 선언.

> ⚠️ **범위 의존 잠복**: 좁은 조회/소량 저장 스모크는 통과하므로 리뷰에서 놓치기 쉽다. 반드시 **넓은 기간(6개월+ WEEKLY/DAILY) / 다건(수백 행) 저장**으로 검증.

---

## §1. 패턴 A — 동적 PIVOT 컬럼 누적 (조회 SP)

동적 기간 컬럼(D_/W_/M_)을 `V_ITERATION := V_ITERATION || V_COLUMN_TEXT` 로 루프 누적 후 `V_SQL_TEXT` 로 조립.

| 변수 | 위험 | 조치 |
|---|---|---|
| `V_ITERATION`(컬럼 누적) | WEEKLY 6개월 ~27컬럼×200자 ≈ 5,400 > 4000 → ORA-06502 | **CLOB** |
| `V_SQL_TEXT`(최종 동적 SQL) | DAILY ~184컬럼 → >32767 | **CLOB** |

- CLOB 호환: `LENGTH/INSTR/SUBSTR/||/REPLACE` 모두 지원. `OPEN cur FOR <clob>` 는 11g+ 지원.
- 금지: `LENGTHB/SUBSTRB/INSTRB`(바이트) 혼재 시 CLOB 부적합 — 사용 여부 grep 확인.
- 사례: `PKG_DMF0014` GET, `PKG_DMF0048` 동일 패턴(잠재).

## §2. 패턴 B — '^' bulk 페이로드 홀더 (저장 SP)

FE 가 17~N 필드를 각각 `'^'` 다건 문자열로 전송 → SP 가 `vp_X := RTRIM(p_X) || '^'` 로 **전체 페이로드 수신** 후 `WHILE LENGTH>0 / INSTR / SUBSTR` 토큰 소비.

| 분류 | 예 | 위험/조치 |
|---|---|---|
| **페이로드 홀더** (전체 '^' 수신, 자기 SUBSTR 축소) | `vp_*` / `V_P_*` / `V_RECV_*` | 다건 시 >4000 → ORA-06502 → **CLOB** |
| **단일 토큰** (split 후 1행값) | `v_*` (`:= SUBSTR(vp_X,1,idx-1)`) | 1값이라 안전 → **VARCHAR2(4000) 유지** |

- 홀더만 CLOB, 단일토큰은 그대로 — **전수 분류 후 홀더만 전환**(무분별 전체 CLOB 화 금지: 토큰루프 CLOB SUBSTR 은 O(N²) 성능저하).
- 사례: `PKG_DMF0014.SAVE`(V_P_* 17+V_RECV 1), `DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO`(vp_* 13).

## §3. 패턴 C — 진단 JSON_OBJECT (전 파라미터 로깅)

예외 로깅용 `v_in_para_data := JSON_OBJECT('p_x' VALUE p_x, ...)` — 대량 '^' 파라미터 13개+ 합치면 JSON > 32767 → **ORA-40478** (BEGIN 직후 즉사, 실제 로직 진입 전).

**⭐ Oracle 23ai 함정**: PL/SQL 대입 `v := JSON_OBJECT(... RETURNING CLOB)` 는 **PLS-00684**(부적합 데이터 유형)로 컴파일 불가. → **SQL 컨텍스트 SELECT INTO** 로 우회:
```sql
SELECT JSON_OBJECT('p_x' VALUE p_x, ... RETURNING CLOB) INTO v_in_para_data FROM DUAL;
```
**추가 필수**: `v_in_para_data`(CLOB)를 로깅 프로시저/RAISE 로 넘기기 전 **VARCHAR2 한도 맞춤 truncate**:
```sql
v_in_para_data := DBMS_LOB.SUBSTR(v_in_para_data, 4000, 1);  -- PR_SCM_SYS_LOG_BATCH.p_in_para_data = VARCHAR2 / RAISE_APPLICATION_ERROR 메시지 대비
```
> ⚠️ 공통 로깅 프로시저 `PR_SCM_SYS_LOG_BATCH.P_IN_PARA_DATA` = **VARCHAR2**. CLOB(>32767) 그대로 전달 시 CLOB→VARCHAR2 변환에서 ORA-06502(로그 호출부·RAISE부). 진단은 앞 4000자면 충분.

## §4. 근본 대안 (truly 대량 — 버퍼 확대 넘어서)

`'^'` VARCHAR2 파라미터는 **PL/SQL/JDBC bind 상 ~32767 상한**(1회 ~2000행 실질 천장) + 구분자 충돌 + O(N²) 성능 문제. 상시 대량이면:
1. **JSON 배열 + JSON_TABLE**(권장): FE 가 행 배열 JSON(CLOB bind) 전송 → SP `JSON_TABLE` set-based 파싱. 상한·충돌·성능 동시 제거.
2. GTT(Global Temp Table) set-based / 3. 컬렉션(VARRAY) 바인딩.
> BE 무변경 원칙과 상충 시 사용자 확인. 상세: 세션 논의 2026-07-06.

## §5. 자기 점검 (SP 작성/변환 직후)

```
[ ] 동적 PIVOT 누적 변수(V_ITERATION/V_SQL_TEXT) = CLOB? (WEEKLY/DAILY 넓은 기간 검증)
[ ] '^' bulk 페이로드 홀더(vp_*/V_P_*/V_RECV_*) = CLOB? 단일토큰 v_* = VARCHAR2 유지?
[ ] 진단 JSON_OBJECT = SELECT ... RETURNING CLOB INTO ... FROM DUAL? (PL/SQL 대입 PLS-00684)
[ ] CLOB 진단 → 로깅/RAISE 전 DBMS_LOB.SUBSTR(.,4000,1) truncate?
[ ] LENGTHB/SUBSTRB 혼재 0건?
[ ] sp-body-minimal-change: GET_DDL 원본 + 선언/해당 줄만 변경(전체 재작성 금지)?
[ ] 재컴파일 VALID + USER_ERRORS 0?
```

## §6. 관련
- 메모리 `feedback_oracle_bulk_clob_buffer.md`
- hook `oracle-save-payload-integrity.md`(#99) / `sp-body-minimal-change.md` / `oracle-sp-perf-anti-patterns.md`
- 사례: DMF0014(조회 ORA-06502 / 저장 vp_ 잠재), DMF0043(저장 ORA-40478+06502), DMF0048(PIVOT 동일 패턴)
