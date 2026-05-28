# [SCREEN_ID] — To-Be 화면 설계

> **이 파일의 역할**: 클로드 코드가 React Web 화면을 작성할 때 따라야 할 설계 의도와 인터랙션 명세. 라이브러리 미확정 상태에서도 작성 가능하도록 일반 Web 기준으로 기술.

작성일: YYYY-MM-DD | 매핑된 As-Is: [SCREEN_ID]

---

## 1. 설계 원칙

| 항목 | 설계 |
|---|---|
| 화면 크기 | Desktop ≥ 1280px (반응형 여부) |
| 라우팅 경로 | `/<domain>/<screen-name>` (예: `/dm/market-forecast`) |
| 권한 체크 | 라우터 가드에서 사용자 권한 확인 |
| 데이터 소스 | REST API (`/api/v1/<domain>/<endpoint>`) |
| 상태 관리 | (Redux/Zustand/React Query 결정 후 채움) |
| 폼 라이브러리 | (React Hook Form / Formik 결정 후 채움) |

## 2. 레이아웃 (개념도)

```
┌─────────────────────────────────────────────────┐
│ Page Header                                     │
│ (Title · Breadcrumb · Quick Actions)            │
├─────────────────────────────────────────────────┤
│ Filter Bar                                      │
│ (Division ▼) (Period ▼) (Keyword) [Search]     │
├─────────────────────────────────────────────────┤
│ Main Data Grid                                  │
│ (Column groups, frozen columns, row select)     │
├─────────────────────────────────────────────────┤
│ Footer Toolbar                                  │
│ (Total · Status · [Save] [Export])             │
└─────────────────────────────────────────────────┘
```

## 3. 인터랙션 명세

### 3.1 Page Load
1. 라우터 가드: 사용자 권한 확인 → 401 시 로그인 리다이렉트
2. 마스터 데이터 prefetch (사업부, 코드 리스트) — React Query
3. 그리드 헤더만 먼저 그려짐 (스켈레톤)
4. URL 쿼리 파라미터 → Filter 자동 채움 (북마크 지원)

### 3.2 검색
1. 사용자 Filter 입력 → [Search] 클릭 (또는 Enter)
2. 클라이언트 검증: 사업부 필수, 기간 형식
3. 호출: `GET /api/v1/<domain>/<endpoint>?division=A&from=2026-01&to=2026-12`
4. Loading 상태 표시
5. 응답 → 그리드 데이터 바인딩 + 합계 행 계산

### 3.3 그리드 편집
1. 인라인 편집 (셀 더블클릭 또는 Enter)
2. 값 변경 시 행 dirty flag 표시 (왼쪽 컬럼 노란 점)
3. 즉시 검증 (R1~RN 룰 적용 후 빨간 테두리)
4. 합계 행 자동 갱신 (클라이언트 계산)

### 3.4 저장
1. [Save] 클릭
2. dirty 행만 추출 → 검증 통과 행만 전송
3. 호출: `POST /api/v1/<domain>/<endpoint>` body={changes:[...]}
4. 서버 응답: 행별 OK/Err
5. 결과 토스트 + 그리드 dirty flag 클리어

### 3.5 키보드·접근성
- Tab/Shift+Tab: 셀 이동
- Esc: 편집 취소
- Ctrl+S: 저장
- ARIA labels for 스크린 리더

## 4. UI 상태 다이어그램

```
[Idle] --user input--> [Searching] --success--> [Editable]
                              \--error--> [Idle + Error Toast]

[Editable] --cell change--> [Editable + dirty rows]
[Editable + dirty] --Save--> [Saving] --success--> [Editable + clean]
                                     \--partial--> [Editable + Error Per Row]
```

## 5. 데이터 모델 (To-Be 응답 형식)

```jsonc
// GET /api/v1/<domain>/<endpoint>
{
  "items": [
    {
      "id": "...",
      "businessKey": { "division": "A", "period": "2026-01" },
      "values": { "qty": 100, "amount": 50000 },
      "meta": { "lastUpdate": "2026-05-08T10:30:00Z", "updatedBy": "user1" }
    }
  ],
  "summary": { "totalQty": 1000, "totalAmount": 500000 },
  "permissions": { "canEdit": true, "canApprove": false },
  "meta": { "rowCount": 10, "version": "v1" }
}
```

## 6. 검증 룰 (분석.md R1~RN을 To-Be로 옮김)

| ID | 룰 | 시점 | 메시지 |
|---|---|---|---|
| R1 | 사업부 필수 | Search 직전 | "사업부를 선택하세요" |
| R2 | 합계 = 셀 변경 시 자동 | OnCellChange | - |
| R3 | 저장 트랜잭션 | Save 호출 | "일부 행 저장 실패: N건" |
| ... | ... | ... | ... |

## 7. 에러 처리

| 에러 | 사용자 표시 | 로깅 |
|---|---|---|
| 401 권한 없음 | 로그인 페이지로 리다이렉트 | Sentry |
| 422 검증 실패 | 행별 빨간 테두리 + 메시지 | - |
| 500 서버 오류 | 토스트 "잠시 후 다시 시도하세요" + 지원 채널 | Sentry, 운영팀 알림 |
| 네트워크 끊김 | 자동 재시도 (3회) | - |

## 8. 성능 목표

| 항목 | 목표 |
|---|---|
| 첫 페이지 로드 | < 2초 |
| 그리드 1,000행 렌더 | < 500ms |
| 검색 응답 | < 1.5초 (서버 제한 1초 + 네트워크 0.5초) |
| 저장 100행 | < 3초 |

## 9. 미확정 사항 (라이브러리/스택 결정 후 채움)

- [ ] 그리드 라이브러리: (AG-Grid / SpreadJS / Handsontable / MUI DataGrid)
- [ ] 폼 검증: (React Hook Form / Formik)
- [ ] 상태 관리: (Redux Toolkit / Zustand / React Query)
- [ ] 디자인 시스템: (Material UI / Ant Design / Chakra / 자체)
- [ ] 백엔드: (Spring Boot / NestJS / Node.js)
- [ ] 차트: (Recharts / Chart.js / ECharts)

## 10. 참고

- Figma 디자인: [`figma_link.md`](./figma_link.md)
- As-Is 분석: [`analysis.md`](./analysis.md)
- 컴포넌트 매핑: [`web_components.md`](./web_components.md)
- 표준 가이드: [`/Doc/_dev_rules/`](../../../_dev_rules/) (구 `_vibe_coding` 은 `_archive/_vibe_coding/` 로 이관)
