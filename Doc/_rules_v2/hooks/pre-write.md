# Hook — pre-write (파일 작성 직전 자기 점검)

> **트리거**: 모든 `.ts / .tsx / .java / .sql / .md` 파일 작성 직전
>
> **목적**: 사고 사례 + 룰 위반 사전 차단

---

## §0 자기 점검 (10 항목)

### §0.1 모든 파일 공통

- [ ] **anti-simplification**: 단순화 유혹 없는가? 사용자 요구 정확히 충족?
- [ ] **기존 패턴 참조**: reference 화면 (DMF0004~7) 의 패턴 확인했는가?
- [ ] **i18n key**: LBL/MSG 코드가 `LBL` + 5자리 / `MSG` + 5자리 표준인가? 자유 형식 (예: `LBL_DMF0007_CUSTOMER_FCST`) 사용 금지

### §0.2 FE `.ts / .tsx`

- [ ] **import alias**: 상대 경로 (`../../../`) 사용 안 함, alias (`@shared/*` 등) 사용
- [ ] **정확 export 인벤토리** (룰 02 §2.1): `@shared/lges` 에서 `Box` / `Container` / `Dialog` 등 없는 것 import 시도 X
- [ ] **Store selector**: `useStore()` 객체 destructuring 금지 → 개별 selector
- [ ] **hotkeyConfig manual/upload**: 명시 의무 (기본 `false`)
- [ ] **DataGrid wrapper**: FlexGrid 직접 import 금지 → `DataGrid` (`@shared/components`)
- [ ] **EditTracker.storeChange**: cell 변경 시 누락 금지
- [ ] **CRUD_TYPE 가드**: modal cell 더블클릭 시 `CRUD_TYPE.INSERT` 가드 의무

### §0.3 BE `.java`

- [ ] **`@RequiredArgsConstructor` + final 필드**: `@Autowired` 필드 주입 금지
- [ ] **`successResponseEntity`**: `ResponseEntity` 직접 작성 금지
- [ ] **nameSpace 변수**: SQL ID hardcoding 금지
- [ ] **`@LoginUser UserInfo`**: BE 자동 user_id 주입
- [ ] **secret 금지**: AES 키 / DB 비번 hardcoding 절대 금지 (룰 11 §5)

### §0.4 SQL `.sql`

- [ ] **NOT EXISTS 멱등 패턴**: `INSERT ALL` 금지 → `INSERT SELECT FROM (...) WHERE NOT EXISTS (...)`
- [ ] **DBeaver 호환** (`_DBeaver.sql`): `SET/PROMPT/DEFINE/&var/`/`` 0 건 (룰 12 §1.3)
- [ ] **MSSQL 키워드**: `DATEADD/CHARINDEX/STRING_SPLIT/GETDATE/ISNULL/IIF/N'/WITH (NOLOCK)` 사용 금지
- [ ] **UPPR_MNU_ID 대소문자**: `Demand_Master` 표준 (대문자 `DEMAND_MASTER` 금지)
- [ ] **SHT_NM 표준**: 단일 sheet = `'main'`
- [ ] **CMBO `@varName` quote**: `TO_CHAR(@varName)` wrap 의무 (룰 12 §3.3)

---

## §1 작성 직전 grep 명령

```bash
# (FE) 작성 직전 confirm
test ! -d "features/{domain}/src/pages/{screen}/componenets"   # 오타 폴더 신규 생성 금지
grep -E "from '@shared/lges'.*\b(Box|Dialog|Container)\b" {target_file}   # = 0 (사고 패턴)

# (BE) 작성 직전 confirm
grep -E "@Autowired" {target_file}   # = 0

# (SQL) 작성 직전 confirm
grep -E "INSERT ALL" {target_file}   # = 0 (멱등 X)
grep -E "DATEADD|GETDATE\(\)|ISNULL\(" {target_file}   # = 0 (MSSQL)
```

---

## §2 적용 룰 cross-ref

| 항목 | 룰 |
|---|---|
| FE 표준 | `_tobe/01~10.md` |
| BE 표준 | `_tobe/11_be_controller_service.md` |
| SQL 표준 | `_tobe/12_metadata_sql.md` |
| Routing | `_tobe/13_routing_menu.md` |
| anti-simplification | `anti-simplification.md` |
| AS-IS 매핑 | `_mapping/asis_to_tobe.md` |
