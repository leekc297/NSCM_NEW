# 공통소스 자체 불일치로 컴파일을 막던 테스트 3본 (2026-08-23 격리)

`eunjoo-hwang/nscm-fe` main(f9409878) 에서 그대로 내려온 파일인데, **같은 저장소의 구현과 API 가 어긋나** 있다.
우리 로컬 변경과 무관하며 클라우드에서도 동일하게 type-check 를 깨뜨린다 → 원천 저장소에 정정 필요.

| 파일 | 테스트가 요구 | 구현의 실제 export |
|---|---|---|
| `sales-reports.editLock.test.ts` | `currentYyyymm`, `existingStaticEditable`, `insertStaticEditable` | `dynKindOf`, `evalSalesReportCell`, `staticEditableByMeta` |
| `sales-reports.save.test.ts` | `buildEtcInsertRows({measures, divisionId, groupId})` | `buildEtcSaveRows({targets, versionNo, monthBindings})` — 시그니처 자체가 다름(단순 개명 아님) |
| `lookup.utils.test.ts` | `toDetailSaveRow` | 없음 (`sanitizeDetailRow` 만 존재) |

같은 계열 중 **고칠 수 있었던 것은 고쳤다** — `sales-reports.api.ts` 의 `callProc` 은 테스트가 직접 검증하는데
비공개라 TS2459 였고, `export` 를 붙여 해소했다(구현 변경 없음).

되돌리려면 각 파일을 원래 경로로 옮기면 된다. 구현에 맞춰 테스트를 다시 쓰는 것이 정석이나,
남의 화면(DMF0044 / admin lookup) 의도를 추정해 재작성하는 것은 위험해 보류했다.
