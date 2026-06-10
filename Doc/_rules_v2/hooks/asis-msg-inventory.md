# Hook — AS-IS MSG[숫자] 인벤토리 + To-Be 등록 SQL 생성

> 작성: 2026-06-10 (MSG00096 권한 없음 추적 + AS-IS 33 MSG ID 인벤토리 후)
> 상위 룰: `anti-simplification.md`
> 관련 hook: `db-corporate-apply.md` / `db-schema-divergence-check.md`

---

## §0. 트리거

- "AS-IS 메시지 등록 / MSG 코드 인벤토리 / MSG{숫자} 의 To-Be 코드 / 다국어 메시지 추가"
- "MSG[숫자] 의 본문 / 대체 코드"
- AS-IS 의 메시지 ID 에 대한 To-Be 등록 / 매핑 요청

---

## §1. 인벤토리 추출 절차

### 1.1 다중 grep 패턴 (anti-simplification — 단일 패턴 금지)

```bash
# A. __asis-mapping__.md 의 표 본문
grep -hE "MSG[0-9]{4,5}" {features}/__asis-mapping__.md | grep -oE "MSG[0-9]{4,5}" | sort -u

# B. AS-IS C# 코드 직접 grep (소스 보유 시)
grep -rhE "MessageHelper\.GMessageBox.*MSG[0-9]{4,5}" {AS_IS_SOURCE} | grep -oE "MSG[0-9]{4,5}" | sort -u

# C. SQL 파일에서 사용된 MSG ID
grep -rhE "MSG[0-9]{4,5}" {sql_files}/*.sql | grep -oE "MSG[0-9]{4,5}" | sort -u

# D. FE i18n JSON
grep -hE "MSG[0-9]{4,5}" nscm-fe/public/locales/*.json
```

### 1.2 합집합 + To-Be cross-check
1. A∪B∪C∪D 의 unique MSG ID 인벤토리
2. Docker DB SCM_ADM_MSG_M 에서 등록 여부 확인:
   ```sql
   SELECT MSG_ID, LANG_CD, MSG_NM FROM SCM_ADM_MSG_M
    WHERE MSG_ID IN ({inventory});
   ```
3. 미등록 ID 만 신규 등록 대상

### 1.3 본문 추출 시 한계 명시 의무 (anti-simplification)
- `__asis-mapping__.md` 의 표 내용 → "용도 설명" vs "AS-IS 원본 본문" 혼재 가능 — 100% 정확 보장 X
- **AS-IS DB (`165.244.95.223:1433` MSSQL) 의 메시지 카탈로그 직접 query 가 정확 본문 source** — 가능 시 우선
- EN/CN 본문 정확 번역은 사용자/PM 결정 의무 (KO fallback 으로 작성)
- 본문 미상 ID 는 `[TODO] MSG{ID} 본문 결정 필요` placeholder 명시

---

## §2. 등록 SQL 작성 패턴

### 2.1 SCM_ADM_MSG_M INSERT (사내 NOT NULL 보강 의무)
- `db-schema-divergence-check.md` §3.1 패턴 그대로
- MSG_TP_CD: `'MSG'` (validation/일반) / `'MNU'` (메뉴 라벨) / `'API'` (API 메시지) / `'LBL'` (UI 라벨)
- 멱등 NOT EXISTS (MSG_ID + LANG_CD)

### 2.2 4-파일 세트 의무 (메모리 `feedback_sql_dual_output.md`)
1. `{NNN}_AS_IS_MSG_codes_register.sql` (sqlplus + PROMPT/SET 포함)
2. `{NNN}_AS_IS_MSG_codes_register_DBeaver.sql` (DBeaver 호환 — SET/PROMPT 제거)
3. `{NNN}_AS_IS_MSG_codes_register_Verify.sql` (등록 결과 검증)
4. `INVENTORY.md` (출처 매핑 + 한계 명시)

### 2.3 의미 충돌 검증 의무
- Docker 의 동일 MSG ID 본문 vs AS-IS 매핑 본문 차이 확인
- 예: MSG00002 (Docker = "성공적으로 저장되었습니다." / AS-IS = "필수 입력")
- 충돌 시 사용자 결정: (a) Docker 우선 유지 / (b) AS-IS 본문으로 update / (c) 별도 To-Be ID 부여

---

## §3. INVENTORY.md 의무 구성

| 섹션 | 내용 |
|---|---|
| 추출 방법 | grep 패턴 / 출처 파일 / 한계 명시 |
| Docker 등록 (skip) | 이미 있는 ID + 본문 |
| Docker 미등록 (등록 대상) | ID + 출처 화면 + KO 본문 (AS-IS 매핑) |
| 등록 SQL 사양 | 87 row (29 MSG × 3 LANG) 등 |
| 적용 제약 | tablespace 등 인프라 이슈 |
| 사용자 결정 필요 | TODO / EN-CN 검수 / 의미 충돌 |

---

## §4. 적용 + 검증

### 4.1 Docker DB 우선 검증 의무
- 사내 DB 적용 전 **Docker DB 에 먼저 적용** → SQL 정확성 검증
- "X rows created" + Verify count 일치 확인
- 사내 적용 시 tablespace 등 인프라 이슈는 별도 검토

### 4.2 적용 명령 (apply.sh 호환)
```bash
cd /c/Projects/NSCM/_artifacts/_apply_corporate
./apply.sh /c/Projects/NSCM/.../{NNN}_AS_IS_MSG_codes_register.sql LABEL
```

---

## §5. 사고 패턴 (위반 시)

| 안 됨 | 결과 |
|---|---|
| ❌ 단일 grep 패턴만으로 인벤토리 | AS-IS 사용 ID 누락 |
| ❌ Docker / 사내 cross-check 생략 | 중복 INSERT 또는 누락 |
| ❌ EN/CN 본문 임의 작성 | 정확 번역 보장 X — 사용자 검수 의무 |
| ❌ 의미 충돌 무시 | Docker = "성공" vs AS-IS = "필수" 같은 충돌 |
| ❌ Docker DB 검증 생략 + 사내 직접 적용 | tablespace 등 인프라 이슈에 SQL 정확성 묻혀 분리 검증 불가 |
