# hook #150 §3 정책 전환 — (DIV, SITE) 기준 MAX 단일건 적용 패키지

- 대상 DB: AJS `175.211.29.206:2521` (SCM_MGR)
- 룰: `Doc/_rules_v2/hooks/dept-id-derivation-standard.md` (2026-09-07 §3 개정본)
- 사용자 지시(2026-09-07): "SCM_MST_SITE_ITEM 기준으로 중복 DEPT 발생 가능성이 있었으며, 이때
  **DIVISION_ID + SCM_SITE_ID 를 기준으로 MAX 로 한건만 추출**하는 것으로 RULE 을 변경"
- 사용자 확정 2건(2026-09-07):
  1. **MAX 판정 = 다건이 나는 지점만** — 키가 (DIV,SITE) 로 PK 보다 성긴 곳. PK 4키 지점은 그 행의 DEPT_ID 유지
  2. **적용 범위 = 룰 문서 + 실측 미적용 지점 정정** — 전수 재적용 아님

## 1. 대상 (실측으로 확정)

2026-09-06 적용 10 객체 / 35 지점을 `dept_id_join_grain_scan.py` 로 전수 재판정한 결과,
새 정책에 어긋나는 지점은 **PKG_DMF0020 2곳뿐**이다. 나머지는 PK 4키 또는 등가 grain 이라 값·건수가 바뀌지 않는다.

| 객체 | body LINE | 문제 | 조치 |
|---|---|---|---|
| `PKG_DMF0020` `P_DMF0020_GET_SALES_PRICE_TEMPLATE` | 2753-2755 | `INNER JOIN SCM_MST_SITE_ITEM IM ON DIV+SITE` (MAX/GROUP BY 없음) = 룰 §5-5 위반 | MAX 인라인 뷰로 치환 |
| 〃 (UNION ALL 미러 블록) | 2832-2834 | 동일 | 동일 |

```
python _artifacts/_diagnostics/dept_id_join_grain_scan.py PKG_DMF0020 --violation-only
  VIOLATION  PKG_DMF0020  2753  DIVISION_ID+SCM_SITE_ID  INNER JOIN SCM_MST_SITE_ITEM IM
  VIOLATION  PKG_DMF0020  2832  DIVISION_ID+SCM_SITE_ID  INNER JOIN SCM_MST_SITE_ITEM IM
  G150-3 : FAIL (VIOLATION 2)
```

## 2. 왜 MAX 를 유효부서 집합 '안쪽'에서 취하는가 (룰 §3-4 / G150-7)

이 블록에서 `IM`·`DI` 는 **출력이 아니라 필터**다 (출력 `DEPT_ID` 는 PK grain 의 `TEAM` 에서 나온다).
`DI` 는 `SCM_MST_SSO_DEPT_INFO ... VALID_YN='Y'` INNER 조인이므로,
MAX 를 전체 DEPT_ID 에서 취한 뒤 밖에서 유효성을 요구하면 **대표값이 무효 부서인 키가 통째로 사라진다**.

실측(2026-09-07):
```
(DIV,SITE) 키 2,333 (SCM_MST_SITE.VALID_YN='Y' ⋈ SITE_ITEM)
  AS-IS 통과(유효부서 보유 키)        : 2,197
  단순 MAX 후 유효성 검사 시 통과      : 2,190   ← 7 키 소실
  유효부서 집합 안에서 MAX (본 패키지) : 2,197   ← 통과 집합 보존
```

## 3. 적용 순서

```bash
# 0) 백업 (이미 생성됨 — 적용 직전 USER_SOURCE 원문)
python _artifacts/_apply_corporate/DEPT_ID_RULE150_MAX_20260907/dump_body.py PKG_DMF0020 \
       _artifacts/_apply_corporate/DEPT_ID_RULE150_MAX_20260907/00_BACKUP_ASIS/01_PKG_DMF0020.ASIS.sql

# 1) 패치본 생성 (백업본 → 라인 기반 편집)
python _artifacts/_apply_corporate/DEPT_ID_RULE150_MAX_20260907/apply_edits.py

# 2) BEFORE 건수 실측 (적용 전에 반드시)
python _artifacts/_apply_corporate/DEPT_ID_RULE150_MAX_20260907/90_VERIFY/count_template.py before

# 3) 적용
python _artifacts/_diagnostics/ora.py exec _artifacts/_apply_corporate/DEPT_ID_RULE150_MAX_20260907/01_APPLY/01_PKG_DMF0020.sql
python _artifacts/_diagnostics/ora.py errors PKG_DMF0020     # USER_ERRORS 0
python _artifacts/_diagnostics/ora.py invalid                # 신규 INVALID 0

# 4) AFTER 건수 실측 + 대사
python _artifacts/_apply_corporate/DEPT_ID_RULE150_MAX_20260907/90_VERIFY/count_template.py after

# 5) 게이트 재판정 (G150-3 PASS 여야 함)
python _artifacts/_diagnostics/dept_id_join_grain_scan.py PKG_DMF0020 --violation-only
```

**원복**: `00_BACKUP_ASIS/01_PKG_DMF0020.ASIS.sql` 을 `ora.py exec` 로 동일하게 실행.

## 4. 편집 규약

기존 라인은 삭제하지 않고 `-- [hook#150-MAX 2026-09-07 AJS] AS-IS: ` 접두로 주석 처리하고,
신규 라인에는 `2026-09-07 hook#150 AJS` 마커를 남긴다 (2026-09-06 패키지와 동일 규약).
⚠ 주석은 근거도 적용 대상도 아니다 — **주석 해제로 되살리지 말 것** (hook #138).

## 5. 검증 결과

`90_VERIFY/01_ROWCOUNT_PARITY.md` 참조.
