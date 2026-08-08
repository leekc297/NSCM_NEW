# Hook #124 — screen-asis-pre-analysis-mandatory (UI 생성·보완 4영역 AS-IS 선행 분석·md 의무 + 모달=MAIN 동등 점검)

> **트리거**: 신규 화면 생성(T01) / 기존 UI 보완(T01M) — **구현 착수 전**
> **신설**: 2026-08-07 사용자 명시 (지시 원문 3건 그대로 승격)
> **위상**: #123(Modal 기능분석 + Cascade/Filter md) · #105(분석서·설계서 표준) · asis-coverage-check(4축 대사 + CRUD·모달 매트릭스) · #90(디자인 정합) 위에 서는 **선행 분석 우산(entry) 룰** — 기존 hook 을 대체하지 않는다(각 hook 본문이 상세 절차의 단일 소스).

---

## §0. 사용자 지시 원문 (2026-08-07)

> - "UI 생성 시, 먼저 디자인 관련 필요 작업, VALIDATION, EVENT 관련 전체, CRUD 관련 전체 작업에 대해서 상세한 AS-IS 분석과 MD 파일을 생성하고 누락없이 작업을 진행하는 것이 목표 입니다. 보완할 때 도 역시 마찬가지 입니다."
> - "이전 작업 잔여분은 CRUD, 및 메인 종속 MODAL 에 대한 CRUD 도 누락없이 구현되어야 한다는 프롬프트에 대한 작업이였습니다." (CRUD·모달 축 계보 — 2026-08-07 asis_mapping_gate/wiring_chain_check 확장의 지시 원문)
> - "MODAL 의 경우 CRUD 만 CHECK 대상이 아니고 **각 MODAL 별로 MAIN UI 와 동일한 분석과 점검**이 이루어져야 합니다."

---

## §1. 4영역 선행 분석 md 세트 — 구현 착수 전 완비 의무

구현 첫 파일 작성 **전에** 아래 4영역의 AS-IS 상세 분석 md 가 모두 존재해야 한다. 부재분은 **먼저 분석·생성**한다 (원소스 전량 Read — anti-simplification).

| 영역 | 선행 산출 md | 근거 hook·도구 |
|---|---|---|
| ① **디자인** | Figma MD `Doc/_figma/screens/{ID}.md` + 영역 매핑표 (부재 시 Figma 추출 선행 / Figma 자체 부재 시 캡쳐·AS-IS 화면 구성 분석으로 대체 + 사용자에게 디자인 요청) | #90 figma-layout-parity (⚠️ 디자인 참조 only — 정책 판단 금지) + #94(36px)/#93(48px)/#95(3색)/#108(No.코너)/#120(아이콘)/#121(공용 폼 스타일) |
| ② **VALIDATION 전체** | `Doc/화면분석서/{ID}_{화면명}_제약매트릭스_상세.md` — AS-IS `MessageHelper.GMessageBox` 전수(MSG ID + 실문구) + 제약 ID(A/B/C…) 체계 + 권한 게이트 | #105 0단계 선행 산출물 + #114(MSG 실문구 대사) + asis-coverage-check §0.3/§0.5 |
| ③ **EVENT 전체** | `Doc/화면분석서/{ID}_{화면명}_주요이벤트_상세분석.md` — **E번호(E01~) 전수** + 세부 항번(E16-4 등) | #105 0단계 + asis-coverage-check §0.0(공식 원천)/§0.1(EID 1:1 대사표) |
| ④ **CRUD 전체 (+종속 모달 CRUD)** | Cascade/Filter 전수 md `Doc/화면분석서/{UI_ID}_..._Cascade_Filter_전수.md` + Modal AS-IS 기능분석(팝업 .cs) + `__asis-mapping__.md` **CRUD·모달 매트릭스** | #123 R1/R2 + `asis_mapping_gate.py --init`(분석 md 팝업 ∪ FE 실존 `*{Modal,Dialog}*.tsx` 합집합) + asis-coverage-check §0.1 3항 |

**절차 (순서 고정)**:
1. md 세트 존재 확인 (glob: `Doc/_figma/screens/{ID}.md` / `Doc/화면분석서/{ID}*` 4종)
2. 부재분만 선분석·생성 — AS-IS `.cs`/`.Designer.cs`/팝업 `.cs` 전량 Read + 라인 인용 명기
3. `asis_mapping_gate.py --init` 으로 대사표 스켈레톤 생성 (수기 표 금지)
4. 구현 — md 의 항목별 반영 여부를 md 에 표기 + **카운트 일치 의무** (분석 항목 수 = 적용 + 정당 제외 수)
5. 완료 선언 = `asis_mapping_gate.py --check` PASS + `ui_gate_runner.py` 리포트 경로 첨부 (RULESET_MASTER §3.4 — 리포트 없는 완료 보고 = 미완료)

---

## §2. ⭐ 모달 = MAIN UI 와 동등한 분석·점검 단위 (2026-08-07 사용자 명시)

MAIN UI 에 종속된 **각 모달별로** §1 의 4영역 분석·점검을 **MAIN 과 동일하게** 수행한다. CRUD·모달 매트릭스의 `MODAL:{이름}` 행 체크만으로 완료 선언 금지.

| 영역 | 모달별 의무 |
|---|---|
| 디자인 | 모달 레이아웃도 디자인 hook 동일 적용 — #94(조회조건 36px, Popup 포함이 원문) / #108(No. 코너) / #95(3색) / P9(자체 footer) |
| VALIDATION | 모달 자체 MSG·제약 전수 (#114 실문구 대사 포함) |
| EVENT | 모달 `.cs` 핸들러 전수 — 오픈 게이트(권한/상태)·조회 SP 바인딩·저장/확정 후처리·**부모 반영 콜백**까지 E번호 채번 (#123 R1 의 5항목 포함) |
| CRUD | 모달별 CRUD 왕복 검증(screen-completion-gate **G6-6**: 열기→편집→OK→DB 반영) + 배선 체인(wiring_chain_check — 모달 파일 포함 스캔 L2A/L2P) |

- **판정 기준**: `__asis-mapping__.md` 의 `MODAL:{이름}` 행에 **모달별 4영역 분석의 근거 링크**(별도 md 또는 MAIN 분석 md 내 모달 섹션 앵커)를 기입해야 완료. FE 에만 존재하는 모달(분석 md 무근거)은 "분석 근거 확인 필요" 상태로 남기고 AS-IS 원소스 확인 후 판정.
- 사고 계보: DMF0042 Ver.Cutoff/Replace 모달 조회 SP 상호 오배선(2026-08-05) / SYS0017 모달 footer 미렌더 P9 — 모두 "모달을 MAIN 보다 얕게 점검"해서 발생.

---

## §3. 보완(T01M) 동일 적용 + 소급 범위

1. 보완 착수 시 §1 md 세트 존재를 먼저 확인 — **부재분 먼저 분석·생성 후 보완** (분석 없는 국소 수정 금지 — #123 §3 의 4영역 일반화).
2. ⭐ **소급 범위 (2026-08-07 사용자 확정)**: 기존 화면에 대한 **일괄 소급 보완 작업은 진행하지 않는다** (배선 스윕 v2 FAIL 잔여 5화면 — DMF0005/DMF0022/SYS0008/SYS0010/SYS0013 — 포함. 판정표 `Doc/_archive/work_reports/2026-08-07_wiring_chain_sweep.md` 기록 보존). 해당 화면을 **실제 생성·보완하는 시점**에 본 hook 을 적용한다.
3. 기존 구축분(진단 도구 4종·실행 hook 7종·게이트 등재)은 그대로 유지 — 본 hook 은 그 위의 선행 분석 의무만 추가한다.

---

## §4. 체크 (PRE-WRITE / 완료 게이트 연동)

- [ ] 4영역 md 세트 존재 확인 (부재분 선분석·생성) — **구현 첫 파일 작성 전**
- [ ] 모달 인벤토리(분석 md 팝업 ∪ FE 실존) 확정 → **각 모달별 4영역 분석** 적용 (`MODAL:` 행에 근거 링크)
- [ ] `asis_mapping_gate --init`(구현 전) / `--check` PASS(완료 전) + `ui_gate_runner` 리포트 경로 첨부
- [ ] md 분석 항목 ↔ TO-BE 적용 카운트 일치 보고

관련: #123(child — Modal 기능분석·Cascade/Filter) / #105(md 양식·0단계) / asis-coverage-check(§0.0 원천 브리지·§0.1 EID 1:1 + CRUD·모달 매트릭스) / #90(디자인 정합) / #94·#95·#108·P9(모달 디자인 표준) / #114(MSG 대사) / #101(ui-work-entry-playbook) / screen-completion-gate(G6-6·리포트 첨부 의무)
