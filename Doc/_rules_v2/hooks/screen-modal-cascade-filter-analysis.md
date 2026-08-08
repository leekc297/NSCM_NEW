# Hook #123 — screen-modal-cascade-filter-analysis (신규화면 Modal AS-IS 기능분석 + Cascade/Filter 상세분석 md 의무)

> **트리거**: 신규 화면 생성(T01) / 기존 UI 보완(T01M)
> **신설**: 2026-08-06 사용자 명시 요구 (룰 3종 원문 그대로 승격)
> ⭐ **상위 우산 룰 (2026-08-07)**: #124 `screen-asis-pre-analysis-mandatory` — UI 생성·보완 시 4영역(디자인·VALIDATION·EVENT·CRUD+종속 모달) AS-IS 선행 분석 md 완비 의무 + **각 모달 = MAIN UI 와 동일한 분석·점검 단위**. 본 hook 은 그중 CRUD/Cascade·Modal 축의 child.
> **선례 정본**: `Doc/화면분석서/DMF0042_BizPlan_Cascade_Filter_전수.md` + `DM_4UI_Cascade_Flow_마인드맵_v2.html` / DMF0003 조회조건·GRID Cascade Flow 4본 (`DMF00{03,20,21,82}_조회조건_GRID_Cascade_Flow_ASIS_v1.0.md`)

---

## §0. 사용자 지시 원문 (2026-08-06)

> - 신규화면 생성 시 화면내 Modal 있으면 as-is 기준의 기능분석 후 기능 구현 요청
> - 신규화면 생성 시 Cascade, Filter 에 대한 상세분석 후 md 파일 생성하고, 분석내용 적용 요청
> - UI 보완 시 Cascade, Filter 에 대한 상세분석 md 파일 없으면, Cascade, Filter 에 대한 상세분석 후 md 파일 생성하고, 분석내용 적용 요청

---

## §1. R1 — 신규 화면의 Modal 은 AS-IS 기능분석 선행 의무

신규 화면(T01)에 Modal/팝업이 있으면 **구현 전에 AS-IS 원소스 기준 기능분석을 먼저 수행**한다.

1. **AS-IS 팝업 클래스 전문 Read** — `GSCM/06.UIL/**/POPUP/*.cs` (호출부 `new XxxPopup()` 전수 추출은 룰 19 §16 의무와 동일). 화면 .cs 의 팝업 오픈 조건·파라미터 전달·반환값 소비까지 포함.
2. **분석 산출**: 팝업별 ①오픈 게이트(권한/상태) ②조회 SP 와 바인딩 ③그리드/필드 구성 ④저장/확정 동작과 후처리(재조회/부모 반영) ⑤MSG 흐름(hook #114 실문구 대사).
3. 분석 결과를 화면 분석 md(§2 파일)에 팝업 섹션으로 기록한 뒤 구현.
4. ⛔ **금지**: AS-IS 미확인 상태로 Figma/추측 기반 팝업 구현 (hook #90 — Figma 는 디자인 참조 only).

> 사고 계보: DMF0042 Ver.Cutoff/Replace 두 모달의 **조회 SP 가 서로 뒤바뀐 오배선**(2026-08-05) — AS-IS 원문 대조로만 발견 가능했음. POPUP As-Is 정밀 분석 메모리(feedback_popup_asis_precision) 동일 계보.

## §2. R2 — 신규 화면은 Cascade/Filter 상세분석 md 생성 + 적용 의무

신규 화면(T01) 생성 시 **조회조건 + Grid 의 Cascade/Filter 를 AS-IS 기준으로 상세분석**하고 md 파일을 생성한 뒤, 그 분석 내용을 TO-BE 구현에 적용한다.

1. **분석 범위 (전수 — anti-simplification)**:
   - 조회조건: 항목별 데이터 원천(BigFilter/CMBO/lookup — hook #117)·cascade 체인(상위 변경→하위 재조회/clear)·활성/비활성 조건·기본값.
   - Grid: 편집 가능 컬럼별 cascade(값 변경→타 컬럼 재세팅/clear — hook #59 §5-G dataMap 스왑)·콤보 필터 조건·팝업 연동 셀.
   - AS-IS 근거 = 화면 .cs 핸들러 전수(`SelectedIndexChanged`/`EditChange`/`LeaveCell` 등) — 라인 인용 명기.
2. **md 파일 생성**: `Doc/화면분석서/{UI_ID}_..._Cascade_Filter_전수.md` (선례 양식 = DMF0042 판: AS-IS 라인 인용 + TO-BE 구현 지점 병기 + 미구현 ❌ 명시). 통합 마인드맵(`DM_*_Cascade_Flow_마인드맵_*.html`)이 있는 도메인이면 탭 추가.
3. **적용**: md 의 판정 결과(구현/보완 필요 목록)를 TO-BE 코드에 반영하고, md 에 반영 여부를 표기. 카운트 일치 의무(분석 항목 수 = 적용+정당 제외 수).

## §3. R3 — UI 보완 시 분석 md 부재면 먼저 생성 후 적용

기존 UI 보완(T01M) 착수 시 해당 화면의 Cascade/Filter 상세분석 md 존재 여부를 **먼저 확인**한다.

1. `Doc/화면분석서/{UI_ID}*Cascade*.md` glob 확인.
2. **없으면**: §2 와 동일한 상세분석을 먼저 수행해 md 를 생성하고, 그 분석 내용 기준으로 보완을 진행한다 (분석 없이 국소 수정 금지 — cascade 누락 보완이 다른 cascade 를 깨는 회귀 방지).
3. **있으면**: md 를 정본으로 갱신하며 작업 (보완 내용을 md 에 반영 — 문서·코드 동기).

## §4. 체크 (PRE-WRITE / Screen Completion Gate 연동)

- [ ] 화면 내 Modal 존재 여부 확인 → 있으면 R1 분석 산출물 확인
- [ ] Cascade/Filter 분석 md 존재 확인 (`Doc/화면분석서/{UI_ID}*Cascade*`) → 없으면 R2/R3 로 생성
- [ ] md 분석 항목 ↔ TO-BE 적용 카운트 일치 보고

관련: #59 §5-G(grid cell cascade 표준) / #90(Figma 참조 only) / #112(조회조건 카탈로그) / #114(MSG 대사) / #117(조회조건 데이터 원천 AS-IS 정합) / screen-completion-gate
