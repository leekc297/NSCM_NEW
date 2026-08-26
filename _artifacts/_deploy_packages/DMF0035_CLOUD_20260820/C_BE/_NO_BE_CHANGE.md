# C_BE — BE 변경 없음 (2026-08-20 실측)

## 결론

**DMF0035 Demand Plan Waterfall 에 귀속되는 BE(Java/MyBatis) 변경분은 0건이다.**
따라서 본 패키지의 `C_BE/` 에는 배포 대상 파일이 없다.

## 실측 근거 (추정 아님)

### 1) git log — `nscm-be` 의 waterfall 관련 커밋

```
git log --oneline -- nscm-be | grep -i "waterfall\|dmf0035\|dmf0022\|dmf0051"
→ 0건
```

### 2) git status — 워킹트리에 남아 있는 `nscm-be` 수정분 4파일

```
 M nscm-be/src/main/java/com/lgcns/nscm/admin/menu/MenuController.java
 M nscm-be/src/main/java/com/lgcns/nscm/admin/menu/MenuService.java
 M nscm-be/src/main/java/com/lgcns/nscm/admin/menu/MenuServiceImpl.java
 M nscm-be/src/main/resources/sql/admin/Menu.xml
```

이 4파일은 **DMF0082 세션의 titleset(컬럼 개인화 조회/저장) 복원분**이다
(`c3669d9` 구세대 덮어쓰기로 소실된 엔드포인트 4개 — 전 화면 Grid Column Setting 모달 공용).
→ 이미 `_artifacts/_deploy_packages/DMF0082_CLOUD_20260820/C_BE/admin-menu/` 로 이관 패키지화되어 있다.
**DMF0035 귀속 아님 — 본 패키지에서 중복 동봉하지 않는다.**

> ⚠ 다만 DMF0035 화면도 `SubTitle` 공용 컴포넌트를 쓰므로, 클라우드에 위 titleset 복원이
> 아직 적용되지 않았다면 **DMF0082 패키지의 C_BE 를 먼저 적용**해야 한다
> (미적용 시 Grid Column Setting 모달이 빈 목록 — DMF0035 고유 결함 아님).

### 3) DMF0035 의 BE 경유 경로 = 전부 기존 공용 배선

| FE 호출 | BE 경로 | 신규 여부 |
|---|---|---|
| `useTabProcQuery` (시트 8종) | generic call-proc (`SCM_ADM_API_M` 메타 기반) | 기존 — 메타만 추가(A_DB/20) |
| `useTabComboQueries` | generic `/admin/combo` (`SCM_ADM_CMBO_SQL_M`) | 기존 — 메타만 추가(A_DB/21) |
| `fetchStaticColumns` → `POST /admin/menu/DMF0035/column` | `MenuController.retrieveGridColumns` → `PKG_NSCM_UI_COM_MENU.PR_GET_SHEET_COLUMN_LIST` | 기존 |

→ Java 신규/수정 코드 없음. **A_DB 메타 + B_FE 만 적용하면 된다.**
