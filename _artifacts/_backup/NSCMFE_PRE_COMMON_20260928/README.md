# 공통소스 다운로드 회차 보고 — 2026-09-28

- 원천: `https://github.com/eunjoo-hwang/nscm-fe.git` (remote `common`, push URL = `no_push` 유지 — 푸시 없음)
- 기준선: `86aa4eea` (2026-09-23 22:58, 09-23 2차 적용분) → **신규 기준선 `886146083`**
  ("docs(SSP0014): react-gap-audit iter-2 …")
- `86aa4eea` 는 `886146083` 의 조상 — 이번 회차 force-push 재작성 없음
- 공통 신규 커밋 149건 / 전체 변경 3,983파일 중 **4폴더(apps·features·packages·public) + configs 대상 948건**
  (A 906 / M 26 / R 16) — 나머지는 4폴더 밖(`.atlas`·`Doc` 등) → 미반영

## 분류·처리 결과

| 구분 | 건수 | 처리 |
|---|---:|---|
| 신규(A) — 로컬 부재 | 906 | 공통 원문 신규 적용 (로컬 기존 파일 충돌 0) |
| 수정(M) — 로컬 = 기준선(무편집) | 25 | 공통 채택 (locales EN/KO 포함 — 로컬 무편집이라 키 병합 불필요) |
| 이동(R) — 로컬 = 기준선 | 16 | `features/supply/src/pages/distribution-route/` → `features/shipping/src/pages/distribution-route/` 이동 + 구 폴더 삭제. 폴더 밖 import 참조 0건(로컬·공통 모두) 확인 |
| 수정(M) — 3-way | 1 | `configs/types/procedures.d.ts` — 아래 구조 병합 |

### 신규 화면 (주요 — 폴더 기준)
- shipping: shipment-change-request-plan / shipment-plan / shipment-request-semi / shipment-plan-auto-ess / shipment-lot-size /
  shipment-plan-mobility-it / shipment-change-request / shipment-change-history / shipment-change-request-confirm(-ssp0003) /
  shipment-request-pack / shipment-plan-electrode / shipment-plan-confirm-detail / shipment-request-electrode 외
- supply: capa-speed-plan / opt-capa / capa-line-assign / capa-loss-plan / plant-site / workbench / capa-report-small /
  plan-management / capa-lob-report / bod-item / waterfall-shipment-plan-fg / stock-osp / shipment-plan-semi·fg·fix /
  plan-control / capa-teep-report / capa / production-plan-fix / demand-group-master / line-master / integration-psi 외 다수
- demand: `dmf0045` (22본)

### `procedures.d.ts` 병합 (RawProcedureMap 메뉴 키 블록 단위 구조 병합)
줄 단위 `git merge-file` 은 충돌 7건(블록 위치 어긋남 과장) → **메뉴 키 블록 단위 병합으로 대체**.
로컬 d.ts 가 기준선보다 낡은 공통 판본에서 출발한 사실 확인(기준선의 SCP0087 이 로컬에 없음) →
블록마다 **공통 이력 42개 판본 전수 대조**로 "옛 공통본 / 진짜 내 편집" 판정.

| 처리 | 메뉴 키 |
|---|---|
| 공통 신규 추가 (33) | 이번 회차 신규 32 + `SCP0087`(기준선 이전 공통 추가분 — 로컬 누락이었음) |
| 공통 채택 — 공통만 변경 (1) | `SCP0005` |
| 공통 채택 — 로컬 = 옛 공통본 (5) | `DMF0004`(09-09판) · `COM0009`(09-18판) · `DMF0042`(08-25판) · `DMF0053`(09-07판) · `SCP0007`(09-18판) |
| 3-way (base = 로컬 출발 판본) 충돌 0 (2) | `SDM1020`(base 2a5e4b20 08-24) · `SDM5010`(base 064c1637 08-26) |
| 로컬 유지 — 공통 최신 + 내 편집 (9) | DMF0035 · DMF0082 · SYS0016 · SYS0017 · DMF0044 · DMF0049 · SDM1010 · SCM0016 · SCM0002 |
| 로컬 전용 유지 (3) | DMF0013 · DMF0068 · SCP0013 (공통 HEAD·기준선 모두 부재) |

결과: 멤버 93 / 중복 키 0 / 충돌 마커 0 / 파서 왕복(local·base·common) 바이트 일치.

## ⚠️ 미해소 — 신규 화면 d.ts 키 부재 36건 (공통 원본도 0건)
신규 화면 70개 MENU_ID 중 36개(`DMF0045`, `SSP0017/0019/0012/0022/0023/0026/0045/0200/0201/0202`,
`SCP0002/0009/0010/0019/0020/0024/0025/0027/0031/0041/0048/0053/0055/0080/0095/0096/0097/0100/0104/0105/0106/0111/0128/0131/0132`)
와 직전 회차 미해소 `SSP0020/SSP0014/SCP0037` 는 **공통 `procedures.d.ts` 에도 없음** → 병합 누락 아님.
발췌 원본이 없어 임의 작성하지 않음(사용자 결정 대기).

## 범위 밖 — 기존 결정 유지 (이번 회차 미변경)
- 공통 HEAD 와 내용이 다른 파일 25본 (forecast-price Excel Form 3종·spms 테스트·gridAction·OlapPivotGrid 등) —
  공통이 기준선 이후 변경하지 않은 파일 = 과거 회차 로컬유지 결정분. 손대지 않음.
- 공통에 있고 로컬에 없는 6본: `features/report/src/pages/demand-plan-waterfall/components/OlapChartPane*` ·
  `olap-field-rail/*` (공통 09-07 "동기화" 이전 추가분, 로컬 화면 코드에서 참조 0) — 반영 여부 결정 대기.

## 원복 자료
- `local_before/` — 이번 회차에 덮어쓰거나 이동/삭제한 로컬 원본 42본
- `worktree_tracked.patch` — 적용 직전 `nscm-fe` 추적파일 전체 diff (56,969행)
- `git_status_before.txt` — 적용 직전 워킹트리 상태

## 검증
- 적용 947건(d.ts 제외) **공통 원문과 개행 정규화 후 일치 — 불일치 0**, 이동 전 경로 잔존 0
- 충돌 마커 잔존 0건
- 정적검증(type-check/lint) 미수행 — 사용자 지시(2026-09-02) 유지
