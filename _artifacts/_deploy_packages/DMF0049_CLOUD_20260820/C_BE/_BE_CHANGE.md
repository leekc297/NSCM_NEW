# C_BE — DMF0049 이관 시 BE 변경분 (git 실측)

> 결론: **변경 있음.** 화면 전용 BE 도메인 코드는 0건이지만, DMF0049 의 **Column Setting 팝업**이
> 소비하는 **공용 titleSet 엔드포인트 2종이 HEAD 에 없다**(작업 트리 미커밋). 미이관 시 팝업이 404 로 죽는다.

## 1. 실측 근거

```
$ git status --porcelain -- nscm-be
 M nscm-be/src/main/java/com/lgcns/nscm/admin/menu/MenuController.java
 M nscm-be/src/main/java/com/lgcns/nscm/admin/menu/MenuService.java
 M nscm-be/src/main/java/com/lgcns/nscm/admin/menu/MenuServiceImpl.java
 M nscm-be/src/main/resources/sql/admin/Menu.xml

$ git show HEAD:.../MenuController.java | grep -i titleset      → (출력 없음)
$ git show HEAD:.../sql/admin/Menu.xml  | grep -i TITLESET      → (출력 없음)
```

→ `POST /admin/menu/{mnuId}/titleset/search` · `POST /admin/menu/{mnuId}/titleset` 는 **HEAD 에 없다**.

- `nscm-be` 전체에서 `DMF0049` / `etc-sales` / `EtcSales` grep = **0건**
  → DMF0049 **전용** BE 코드는 존재하지 않는다(화면은 generic `call-proc` 경로를 쓴다).
- 따라서 본 폴더의 변경분은 전부 **공용(shared) 축**이다.

## 2. DMF0049 가 이 엔드포인트에 의존하는 경로

```
components/EtcSalesReportsModals.tsx
  └ import { ColumnLayoutModal } from '@shared/components'
      └ packages/shared/src/components/templates/modals/column-layout-modal/ColumnLayoutModal.tsx:17
          └ import { fetchColumnMeta, fetchTitleSet } from '../../../organisms/data-grid/titleSetApi'
              └ titleSetApi.ts:41  POST /admin/menu/${menuId}/titleset/search
                 titleSetApi.ts:85  POST /admin/menu/${menuId}/titleset
```

- 공용 팝업이 **화면별 `{menuId}/titleSet/SEARCH/call-proc` 을 쓰지 않는** 이유가 소스 주석에 남아 있다:
  `SCM_ADM_MNU_BTN_MPG_M` 미등록 화면에서 403 No Permission 이 나기 때문(DMF0042 실측 2026-07-29).
- 반면 DMF0049 자체 `utils/etc-sales-reports.api.ts:26` 의 `saveTitleSet` 은
  `POST /{MENU_ID}/titleSet/SAVE/call-proc` (generic 경로) 를 쓴다 →
  이쪽은 `A_DB/20_MENU_META_SYNC.sql` 의 `DMF0049_titleSet_SAVE` 배선으로 커버된다.
  **두 경로가 공존**하므로 BE 엔드포인트와 메타 배선 **둘 다** 필요하다.

## 3. 동봉 파일

| 경로(패키지 내) | 원본 | 행수 |
|---|---|---:|
| `admin-menu/MenuController.java` | `nscm-be/src/main/java/com/lgcns/nscm/admin/menu/MenuController.java` | 176 |
| `admin-menu/MenuService.java` | 〃 `MenuService.java` | 27 |
| `admin-menu/MenuServiceImpl.java` | 〃 `MenuServiceImpl.java` | 198 |
| `sql-admin/Menu.xml` | `nscm-be/src/main/resources/sql/admin/Menu.xml` | 102 |

DTO 2종(`dto/TitleSetSaveRequest.java` · `dto/TitleSetSearchRequest.java`)은 **HEAD 에 이미 존재**하므로
(git status 미변경) 동봉하지 않는다.

## 4. ⚠ 적용 시 주의

1. **파일 단위 무조건 덮어쓰기 금지** (메모리 `feedback_cloud_shell_generation_mix`).
   `MenuController` / `MenuServiceImpl` / `Menu.xml` 은 **다수 화면이 공유**하는 파일이다.
   클라우드 쪽에 본 작업 트리에 없는 다른 개선분이 들어가 있으면 그 개선이 사라진다.
   → 반드시 **diff 후 titleSet 관련 블록만 병합**할 것.
   실제 회귀 전력: `c3669d9` 에서 BE 구세대 덮어쓰기로 이미지 업로드·유저그룹 기능이 소실됐다.
2. 이 변경분은 **DMF0044 패키지와 동일 파일**이다(형제 화면이 같은 팝업을 쓴다).
   두 패키지 중 한 쪽만 적용해도 무방하며, 둘 다 적용해도 내용이 같다면 무해하다.
3. 호출하는 SP 2본(`DMF0002_GET_TITLESET_POPUP` · `SCM0002_SET_TITLESET_POPUP`)은
   `A_DB/30_GRANT_SYNONYM.sql` 이 GRANT/시노님을 보장한다. 객체 자체의 배포는
   `A_DB/90_VERIFY.sql` V10 으로 확인한다(사내 실측 둘 다 VALID).
