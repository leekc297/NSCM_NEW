# stores (27)

사용 수 내림차순. **신규 화면은 여기 있는 것만 쓴다** — 없으면 사전(map_control.csv) 보완 제안이 먼저(룰 23).

## app-shell

| 이름 | import | 사용 | As-is 대응 | 설명 |
|---|---|---|---|---|
| **useMDIStore** | `apps/web/src/mdi (앱 셸 — 화면에서 직접 import 하지 않음)` | 0 |  |  |

## master-common

| 이름 | import | 사용 | As-is 대응 | 설명 |
|---|---|---|---|---|
| **useContributeVersionModalStore** | `features/master/src/components` | 1 |  |  |
| **useCustomerModalStore** | `features/master/src/components` | 1 |  |  |
| **useContributeRateModalStore** | `features/master/src/components` | 0 |  |  |
| **useItemByDivisionModalStore** | `features/master/src/components` | 0 |  |  |
| **useItemByPlantSiteModalStore** | `features/master/src/components` | 0 |  |  |
| **useMaterialByDivisionModalStore** | `features/master/src/components` | 0 |  |  |
| **useModelByDivisionPopupStore** | `features/master/src/components` | 0 |  |  |
| **useOwnerByDivisionModalStore** | `features/master/src/components` | 0 |  |  |
| **useOwnerModalStore** | `features/master/src/components` | 0 |  |  |
| **useProjectByDivisionModalStore** | `features/master/src/components` | 0 |  |  |
| **useProjectByDivisionPopupStore** | `features/master/src/components` | 0 |  |  |
| **useProjectModalStore** | `features/master/src/components` | 0 |  |  |
| **useRegionModalStore** | `features/master/src/components` | 0 |  |  |
| **useSlocModalStore** | `features/master/src/components` | 0 |  |  |
| **useTeamModalStore** | `features/master/src/components` | 0 |  |  |
| **useVersionModalStore** | `features/master/src/components` | 0 |  |  |

## shared

| 이름 | import | 사용 | As-is 대응 | 설명 |
|---|---|---|---|---|
| **useMessageStore** | `@shared/stores` | 283 |  |  |
| **useSessionStore** | `@shared/stores` | 178 |  |  |
| **useUIStore** | `@shared/stores` | 11 |  |  |
| **useDialogStore** | `@shared/stores` | 1 |  | 열려 있는 CustomDialog 스코프 스택을 추적하는 비영속 스토어. 부모 화면과 팝업 각각의 SubTitle 단축키가 "현재 활성 스코프"에서만 동작하도록 게이트하는 데 사용한다. 포커스/모달리스 여부와 무관하게 스택의 top이 활성 스코프를 결 |
| **useAuthStore** | `@shared/stores` | 0 |  |  |
| **useDataGridStore** | `@shared/stores` | 0 |  |  |
| **useMessageModalStore** | `@shared/components` | 0 |  |  |
| **useMotherStore** | `@shared/stores` | 0 |  |  |
| **useSsoDeptModalStore** | `@shared/components` | 0 |  |  |
| **useSsoUserModalStore** | `@shared/components` | 0 |  |  |
