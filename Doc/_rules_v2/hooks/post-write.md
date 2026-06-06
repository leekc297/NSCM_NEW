# Hook — post-write (파일 작성 직후 검증)

> **트리거**: 모든 `.ts / .tsx / .java / .sql / .md` 파일 작성 / 수정 직후
>
> **목적**: 작성된 파일이 룰 v2 표준 통과하는지 grep 자동 검증

---

## §0 작성 직후 grep 검증

### §0.1 FE `.tsx / .ts`

```bash
F="{written_file}"

# 1. 상대 경로 import
grep -c "from '\(\.\./\)\{3,\}" "$F"   # = 0

# 2. console.log 잔존
grep -c "console\.log" "$F"   # = 0

# 3. inline style
grep -c "style=\{\{" "$F"   # = 0

# 4. () => undefined / () => {} 빈 handler (메모리 사고)
grep -cE "=> undefined|=> \{\s*\}" "$F"   # = 0

# 5. @shared/lges 의 없는 export (Box / Dialog 등)
grep -cE "from '@shared/lges'.*\b(Box|Dialog|Container|Paper|TextField)\b" "$F"   # = 0

# 6. FlexGrid 직접 import (DataGrid wrapper 사용 안 함)
grep -c "from '@mescius/wijmo.react.grid'" "$F"   # = 0

# 7. FlexGridColumnGroup JSX single-child (DMF0043 사고)
awk '/<FlexGridColumnGroup/,/<\/FlexGridColumnGroup>/' "$F" | grep -c "<FlexGridColumn " 
# ≥ 2 또는 그룹 사용 안 함

# 8. NUMBER → String 변환 누락 패턴 (DMF0043 YEAR 사고)
# 수동 검토: <CustomDropdown value={row.COL}> 의 row.COL 이 Oracle NUMBER 컬럼인지

# 9. useMemo preSearchParams (refetch loop)
grep -B 2 "preSearchParams=\{\{ \.\.\." "$F" | grep -c "useMemo"   # ≥ 1 (사용 시)
```

### §0.2 BE `.java`

```bash
F="{written_file}"

# 1. @Autowired 필드 주입
grep -c "@Autowired" "$F"   # = 0

# 2. successResponseEntity 사용
grep -c "ResponseEntity.ok\|new ResponseEntity" "$F"   # = 0 (직접 작성 X)
grep -c "successResponseEntity" "$F"   # ≥ 1 per endpoint

# 3. System.out.println
grep -cE "System.out.println|printStackTrace" "$F"   # = 0

# 4. SQL ID hardcoding
grep -cE 'selectList\("[a-z]' "$F"   # = 0 (nameSpace 변수 사용)

# 5. Hardcoded password / secret
grep -nE "password.*=.*['\"][\w!@#$%^&*]{6,}['\"]" "$F"   # = 0
```

### §0.3 SQL `.sql`

```bash
F="{written_file}"

# 1. INSERT ALL 사용 (멱등 위반)
grep -c "INSERT ALL" "$F"   # = 0

# 2. NOT EXISTS 멱등 패턴
grep -c "WHERE NOT EXISTS" "$F"   # ≥ INSERT 카운트

# 3. MSSQL 키워드
grep -cE "DATEADD\(|CHARINDEX\(|STRING_SPLIT\(|GETDATE\(\)|ISNULL\(|IIF\(|N'" "$F"   # = 0

# 4. DBeaver 호환 (`_DBeaver.sql` 만)
case "$F" in *_DBeaver.sql)
  grep -cE "^SET|^PROMPT|^DEFINE|^&\w|^/$" "$F"   # = 0
  ;;
esac

# 5. UPPR_MNU_ID 대문자 (DMF0020 사고)
grep -cE "UPPR_MNU_ID\s*=\s*'(DEMAND_MASTER|MASTER|DEMAND)'" "$F"   # = 0

# 6. SHT_NM 자유명 (단일 sheet)
grep -cE "SHT_NM\s*=\s*'(futurePrice|salesSite)'" "$F"   # = 0
```

---

## §1 검증 실패 시 처리

- **실패 1 건이라도 발견**: 즉시 fix. 다음 작업 진행 금지.
- **반복 실패**: 룰 v2 의 해당 룰 cross-ref + 메모리 사고 기록 확인.

---

## §2 적용 룰 cross-ref

| grep | 사고 메모리 |
|---|---|
| Box / Dialog import | `feedback_runtime_error_prevention.md` |
| FlexGridColumnGroup single-child | `feedback_wijmo_columngroup_jsx_avoid.md` (룰 07 §3.2) |
| NUMBER → String 누락 | `feedback_no_type_cast_around_runtime.md` (룰 07 §3.6) |
| INSERT ALL | `feedback_sql_idempotent_insert_all.md` (룰 12 §2) |
| DBeaver 호환 | `feedback_dbeaver_sql_mandatory_grep.md` (룰 12 §1.3) |
| UPPR_MNU_ID 대문자 | `feedback_mnu_uppr_case_standard.md` (룰 13 §7.2) |
