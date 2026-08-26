# B_FE — import 폐포 전수 인벤토리 (DMF0049 Etc Sales Reports)

> 축 확정 방식: 페이지 폴더 18파일의 `.ts/.tsx` 를 **주석 제거(LIVE) 후** `from '...'` 전수 grep.
> 상대경로(`./`, `../`)는 폴더 내부이므로 제외하되, 폴더 **밖으로 나가는** 상대경로는 아래 §2 에 별도 표기.

## 1. 동봉 파일 (본 패키지에 실물 포함)

| 경로 | 사유 |
|---|---|
| `etc-sales-reports/**` (18 파일, `index.ts` 포함) | ⭐ **폴더 전체** — `pages/<화면>/index.ts` 가 viewRegistry glob 의 **유일한 등록 키**다. 부분 이관 시 탭 안 `resolveView()` 실패 → "Page Not Found" (2026-08-14 사고). 생성 스크립트에 `index.ts` 존재 ASSERT 를 넣었다. |
| `configs-types/procedures.d.ts` | `MENU_ID` 리터럴 유니온 타입 원천. DMF0049 블록은 L3352~ (5시트 계약). ⚠ **전 화면 공용 파일**이라 타 화면 변경분도 함께 실린다 — 적용 시 diff 병합 권장. |
| `locales/{KO,EN,CN}.json` | LIVE 코드 축 24종 **발췌본**(전체 파일 아님). 원본 키 수 = KO 914 / EN 858 / CN 852. ⛔ 통째 덮어쓰기 금지 — 발췌 키만 머지할 것(`gen:i18n` 목데이터 덮어쓰기 사고 계보). |

## 2. 미동봉 — 이미 배포된 공용 자산 (PREREQ)

DMF0049 페이지 코드가 참조하지만 **이번 작업분에 변경이 없어**(git 실측) 동봉하지 않는다.
클라우드에 없으면 빌드가 깨지므로 존재만 확인할 것.

| 모듈 | 참조 파일 | 비고 |
|---|---|---|
| `@foundation/apis` | `useEtcSalesReportsStore.ts`, `utils/etc-sales-reports.api.ts` | |
| `@foundation/assets` | `EtcSalesReports.tsx` | `IcMeasureSelect` |
| `@foundation/constants` | `components/EtcSalesReportsGrid.tsx` | `CELL_INPUT_EDIT_TYPE` |
| `@foundation/dayjs` | `EtcSalesReportsForm.tsx`, `useEtcSalesReportsStore.ts` | |
| `@foundation/models` | `EtcSalesReports.tsx`, `Grid.tsx`, `store.ts` | `HotkeyConfig` / `PageProps` / `ComboParam` / `RawFlexGridColumnConfig` |
| `@foundation/query-client` | `EtcSalesReports.tsx` | `useQueryClient` |
| `@foundation/styles/common-styles.module.scss` | `EtcSalesReportsForm.tsx` | hook #121 — 폼 레이아웃은 공용 클래스만 |
| `@foundation/utils` | `EtcSalesReports.tsx`, `Grid.tsx` | `EditTracker` |
| `@mescius/wijmo.grid`, `@mescius/wijmo.grid.filter` | 4 파일 | 외부 라이브러리 |
| `@shared/components` | 4 파일 | `MainTitle`/`SubTitle`/`DataGrid`/**`ColumnLayoutModal`**/`ColumnLayoutRow` |
| `@shared/hooks` | 3 파일 | `useTabBtnPermissions`/`useTabComboQueries`/`useTabProcQuery` |
| `@shared/lges` | 2 파일 | `ProgressIndicator`/`FormItem` |
| `@shared/mui` | `EtcSalesReportsForm.tsx` | `Grid` |
| `@shared/stores` | 2 파일 | `useMessageStore`/`useSessionStore`/`createPersistedStoreWithTab` |
| `features/master/src/components` | `EtcSalesReportsForm.tsx`, `EtcSalesReportsModals.tsx` | `DivisionField`/`VersionField`/`ProjectByDivisionModal`/**`MeasureSelectModal`** (hook #132 — master 공용 정본 유일) |
| `../../../components` (= `features/demand/src/components`) | `EtcSalesReportsModals.tsx` | `VersionModal` (공용 United 버전 팝업). **폴더 밖 상대경로** — git 실측 변경 없음 |
| `react` | 3 파일 | |

### ⚠ 판단 필요 — 작업 트리에 변경이 있으나 DMF0049 소관이 아닌 공용 파일

`git status` 실측상 아래 `features/master` 파일들이 수정돼 있으나, **2026-08-20 DMF0049 작업분이 아니다**
(DMF0049 작업 목록에 master 컴포넌트 변경이 없다). 다른 워크스트림(공용 모달 정본화 hook #132 계열)의
산출물로 보이며, 본 패키지에 **의도적으로 넣지 않았다** — 소관 패키지가 이관할 축이다.

```
 M nscm-fe/features/master/src/components/columnLayoutModal/ColumnLayoutModal.tsx      (-464/+8 : shim 화)
 M nscm-fe/features/master/src/components/columnLayoutModal/columnLayoutModal.utils.ts (-224)
 M nscm-fe/features/master/src/components/searchFields/SearchFields.tsx                (±34)
```

→ 이 3본을 **DMF0049 패키지로 함께 이관할지는 사용자/소관 담당 판단** 사항이다.
   DMF0049 는 `@shared/components` 의 `ColumnLayoutModal` 을 쓰므로 (master 것이 아님) 미이관해도
   본 화면 동작에는 영향이 없다. 단 `features/master/src/components` **barrel** 을 import 하므로
   빌드 시 해당 파일들이 컴파일 대상에는 들어간다 → 클라우드 쪽 버전이 자체 정합적이면 문제 없다.

## 3. 2026-08-20 페이지 폴더 변경 요약 (git diff --stat 실측)

```
 EtcSalesReports.tsx                          91 ++--   Report Type·Plan/Result 변경 시 초기화 / 저장 Toast+스피너·연타 차단
 EtcSalesReportsUtils.test.ts                396 ----   (삭제 — 폴더에 존재하지 않음)
 __asis-mapping__.md                          79 ++--   REQ:CHAT-20260820-16/19 반영
 components/EtcSalesReportsForm.tsx           45 ++-    Report Type·Plan/Result 변경 초기화
 components/EtcSalesReportsGrid.tsx           79 ++-    소수점 메타(DATA_SCALE_NUMBER) 구동 3자리 (0 은 빈칸 유지)
 components/EtcSalesReportsModals.tsx         11 +-
 etc-sales-reports.constants.ts               17 +      dataScaleOf() / DEFAULT_DATA_SCALE
 utils/etc-sales-reports.merge.ts             46 ++-    병합 activeSetKey (클릭한 세트만 분리)
 utils/etc-sales-reports.save.ts              41 ++-    staticChanged (정적 컬럼만 수정해도 저장 — MSG00676 오탐 정정)
 ────────────────────────────────────────────────────
 9 files changed, 315 insertions(+), 490 deletions(-)
```

⚠ `EtcSalesReportsUtils.test.ts` 는 **삭제된 파일**이므로 패키지에 없다. 클라우드에 남아 있다면 지울 것
(남겨두면 삭제된 export 를 참조해 타입체크가 깨진다).

## 4. i18n 발췌 키 24종 (LIVE 축)

`LBL00086` `LBL00112` `LBL00712` `LBL00795` `LBL00797` `LBL00798` `LBL00800`
`MNU00002` `MNU00011` `MNU00039`
`MSG00002` `MSG00004` `MSG00096` `MSG00283` `MSG00429` `MSG00618` `MSG00676`
`MSG00682` `MSG00683` `MSG00684` `MSG00685` `MSG00686` `MSG00687` `MSG00688`

- `MNU00039`(DMF0049) / `MNU00011`(Demand_Plan) / `MNU00002`(Demand) = `SCM_ADM_MNU_M.MNU_MSG_ID` 조상 walk-up.
- ⛔ **주석에만 있어 제외**한 코드 (hook #138): `LBL00513` `LBL00605` `LBL00665` `MSG00680`.
- 신규 채번 **0** — 전부 사내 기등록 재사용. DB 쪽 동기화는 `A_DB/23_MSG_LBL_MNU_SYNC.sql`.
