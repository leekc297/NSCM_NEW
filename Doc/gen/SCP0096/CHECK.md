# [Harness] SCP0096 shipment-working-day-osp — BLOCK 0 / WARN 15

- WARN AC1 액션 대조표 미처리 139행: AC-ab592920(상태 빈칸 CALL_EXT siMain.ActiveSheet.Columns.Get), AC-33978044(상태 빈칸 MESSAGE MessageHelper.GMessageBox), AC-7936e161(상태 빈칸 RETURN return;), AC-ce477761(상태 빈칸 RETURN return;), AC-02e1befa(상태 빈칸 MESSAGE MessageHelper.GMessageBox), AC-2a8d5188(상태 빈칸 RETURN return;), AC-db5ba668(상태 빈칸 RETURN return;), AC-aa878da9(상태 빈칸 RETURN return;) … @Doc/asisfacts/screens/SCP0096/__asis-actions__.md
- WARN AC2 사전 미등록 외부/상속 호출 의미 미기입 7행(AS-IS 원문 위치를 열어 '의미' 칸에 실제 동작 기입): AC-ab592920(siMain.ActiveSheet.Columns.Get @SCP0096_Shipment_Working_Day_OSP.cs:686), AC-a538041b(spdMain.ActiveSheet.GetModelColumnFromVi @SCP0096_Shipment_Working_Day_OSP.cs:737), AC-e978cb8f(spdMain.ActiveSheet.GetModelColumnFromVi @SCP0096_Shipment_Working_Day_OSP.cs:738), AC-a8e480ad(DateUtil.GetDayRange @SCP0096_Shipment_Working_Day_OSP.cs:843), AC-5a5e6522(row.SetModified @SCP0096_Shipment_Working_Day_OSP.cs:603), AC-22ebf26a(dsInput.GetChanges @SCP0096_Shipment_Working_Day_OSP.cs:609), AC-12c2a484(siMain.SetDblClickColumnShowHide @SCP0096_Shipment_Working_Day_OSP.cs:822) @Doc/asisfacts/screens/SCP0096/__asis-actions__.md
- WARN M07 커밋본에 있던 파일이 삭제됨: __tests__/ShipmentWorkingDayOsp.spec.ts — 골격 재생성으로 기능 유실 의심(git checkout -- 로 복원 후 병합, 저장소 C:\Projects\NSCM) @__tests__/ShipmentWorkingDayOsp.spec.ts
- WARN M07 커밋본에 있던 파일이 삭제됨: hooks/useShipmentWorkingDayOspInputValue.ts — 골격 재생성으로 기능 유실 의심(git checkout -- 로 복원 후 병합, 저장소 C:\Projects\NSCM) @hooks/useShipmentWorkingDayOspInputValue.ts
- WARN M06 대조표 후퇴: 행 80→68 · 구현 53→46 (커밋본 대비) — 기존 대조표를 재생성하지 말고 커밋본 위에 행을 추가 @__asis-mapping__.md
- WARN G02 As-is 엔드포인트 SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP (SCP0096_GET_SHIPMENT_WORKING_DAY_OSP) 매핑표 §4 에 없음
- WARN G02 As-is 엔드포인트 SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN (SCP0009_GET_SHEET_CALENDAR_3SPAN) 매핑표 §4 에 없음
- WARN G03 As-is 이벤트 this.Load → Form_Load 매핑표 §2 에 없음
- WARN VR1 VALIDATION 취합(20261022) 기준 UI 미적용 2건 — 화면 열기(OPEN) SEQ1 [MSG00097] 권한을 가진 Division이 없습 / 조회(SEARCH) SEQ1 [MSG00097] 권한을 가진 Division이 없습 → 이식 또는 __asis-mapping__ 에 제외 근거 @Doc/화면분석서/SCP_화면_VALIDATION_취합_20261022/SCP0096.md
- WARN I18N1 다국어 미적용 — 화면에 '_Invalid input value.' 가 그대로 보임: 코드 MSG00050 가 msg_master 에 없음. 기존 LBL/MSG 재사용(문구로 찾기) 또는 SCM_ADM_MSG_M 신규 등록(KO/EN/CN, LBL01001+/MSG01001+) 후 코드 기입 @ShipmentWorkingDayOsp.tsx:314
- WARN R05 `any` / `as unknown as` 금지 (#73 procedure-dts-ssot) @ShipmentWorkingDayOsp.tsx:82
- WARN R16 진입 Page 425 라인 > 400 — components/ 분리 (#9) @ShipmentWorkingDayOsp.tsx
- WARN B20 __tests__/*.spec.ts 단위 테스트 — 룰 17 9-Step ⑨
- WARN B22 조회 filter 키 = 사내 PROC_M COL_NM (P_SCM0001_GET_SCP_MONTH_PERIOD · 시트 'dayRange') — 누락 planCycle, fromDate, offsetMonth, timeZone — 현재 키: divisionId · BE positional 매핑이라 값이 NULL 로 감
- WARN M08 대조표에 As-is DB루프 컬럼 생성 행 없음: InitSpreadDateColumn:196, InitSpreadDateColumn:203 — '## §6 동적 컬럼' 에 행 추가(요지 'InitSpreadDateColumn / 196 (DB루프 컬럼 생성 ← 타이틀 SP)', 구현 위치 = 동적 컬럼 생성 코드 + 타이틀 시트 조회 위치) @__asis-mapping__.md
