# DMF0043 GAP 291 (INT-09) — 기여율 버전관리 팝업 버튼 권한 · 사내 ZIOUI1 적용 기록

- 대상 DB: 사내 ZIOUI1 (`59.19.252.148:2521/ZIOUI1`, SCM_MGR) · 일시 2026-10-15 18:2x~18:34
- 마커: `[E20261015-VERPOPAUTH]` / 클라우드 패키지 `[GAP291 2026-10-15]`

## 차이 (AS-IS ↔ TO-BE)
| 구분 | 내용 |
|---|---|
| AS-IS | `GSCM.DM.Plan.UIL/POPUP/DMF0043_ContributeRatePopup.cs` DefineProperty L111~123 — `NowGroupID` 가 ADMIN · DM ADMIN 이 아니면 Edit/Insert/Save/Delete 숨김. 그리드는 기본 잠금, Edit(`SwitchLock`, L174~183)로만 편집 |
| TO-BE (보완 전) | `nscm-fe/features/master/src/components/contributeVersionModal/ContributeVersionModal.tsx` L414~445 Insert/Delete/Save 무조건 렌더 + F8/F9 단축키 무조건 동작 · DB `DMF0043\|version\|SAVE` 를 DM Viewer 도 보유(Y) → 서버도 저장 허용 |
| "보유 그룹 통합 판정(2026-09-21)" | `PKG_NSCM_UI_COM_AUTH.PR_GET_MNU_BTN_AUTH / PR_CHECK_MNU_BTN_AUTH` 가 USER_ID → 보유 그룹 전체 JOIN(합집합). 그룹×버튼 메타로 이관하면 이 요건과 그대로 양립 → "의도적 변경" 정리는 근거가 안 됨 |

## 사내 실행 작업 ↔ 파일
| # | 작업 | 파일 | 결과 |
|---|---|---|---|
| 1 | 사전 조회 (FRESH) | — | version 시트 GR_BTN 8행: SAVE = ADMIN Y · DM ADMIN Y · DM Viewer Y · GUEST N |
| 2 | 적용 | `01_APPLY_DMF0043_version_popup_btn_auth.sql` | MNU_BTN +3(EDIT/INSERT/DELETE) · GR_BTN +6(ADMIN·DM ADMIN) · DM Viewer SAVE → N. (ora.py 분해 시 주석 내 `;` 로 주석 조각 1건 ORA-00900 — DML 무영향, 주석 정정 완료) |
| 3 | 검증 | `02_VERIFY.sql` + 판정 프로시저 실호출 | 아래 표 |
| 4 | 원복(리허설 준비) | `99_ROLLBACK.sql` | 수정 전 8행 그대로 복원 확인 |
| 5 | 클라우드 패키지 리허설 | `_deploy_packages/DMF0043_GAP291_VERPOPAUTH_CLOUD_20261015/` 90→99→00→10→10→90→99→99→10→90 | 전 단계 기대대로. 최종 = 적용 상태. 백업 테이블 `SCM_ADM_MNU_BTN_BAK_GAP291` · `SCM_ADM_GR_BTN_BAK_GAP291` 생성됨(원복 기준, 보존) |

## 판정 프로시저 실호출 (적용 후)
| 사용자 | 보유 그룹 | hasButton 목록(PR_GET_MNU_BTN_AUTH) | 서버 version EDIT/INSERT/DELETE/SAVE |
|---|---|---|---|
| DM_A_TEST | DM ADMIN 단독 | DELETE·EDIT·INSERT·SAVE·SEARCH·VERSION_MGMT·VERSION_MGT | Y/Y/Y/Y |
| ahn.hc | DM ADMIN + DM Viewer 외 (복수) | 동일 | Y/Y/Y/Y |
| candoism | ADMIN + 비DM | 동일 | Y/Y/Y/Y |
| davidyj | DM Viewer·GUEST 계 (ADMIN/DM ADMIN 회수됨) | (없음) | N/N/N/N |
| bonghwan | DM Viewer·GUEST 계 | (없음) | N/N/N/N |

## 남은 것 — FE (직접 수정 안 함, 가이드만) → 패키지 `00_README.md` §FE 가이드
