-- =============================================================================
-- C03_SP_STAGE_PROFILE.sql — DMF0082 조회 클라우드 점검 ③ SP 직접 실행 · 문장별 병목 귀속
--   계정: SCM_MGR · SQL Developer 스크립트 실행(F5) 또는 sqlplus @C03_SP_STAGE_PROFILE.sql
--   무엇을 하나: 화면 Search 와 같은 인자로 PKG_DMF0082.P_DMF0082_GET_MAIN_DATA 를 division 별로 N회 실행하고
--     (A) SP 시간 / 결과 커서 6개 fetch 시간·행수
--     (B) 문장별 귀속 — V$SQL 전후 델타(이 PKG 문장 + GT_DMF0082 동적 SQL + 동적 샘플링 재귀 SQL)
--     (C) 내 세션 ASH — SQL_ID × 대기이벤트 (1초 표본, 긴 구간 확인용)
--     (D) 세션 통계 델타 — 논리/물리 IO · 하드파싱 · TEMP 유출 · CPU
--   변경: 영구 테이블 변경 없음 (GTT 만 채움, 매 회 ROLLBACK). 세션 파라미터는 SP 자체가 dynamic_sampling=2 로 설정.
--   ⚠ 측정 중 다른 사람이 DMF0082 를 조회하면 (B) V$SQL 델타가 섞인다 — (C) ASH 는 내 세션만이라 섞이지 않음.
--   ⚠ 1회차 = 하드파싱 포함, 2회차 = 커서 재사용 (화면 BE 커넥션 풀 조건). 2회차 수치로 판단.
--   ⏱ 클라우드 82 가 수 분 걸릴 수 있음 → c_divs 를 '82' 하나로 좁혀 먼저 실행해도 됨.
-- =============================================================================
SET SERVEROUTPUT ON SIZE UNLIMITED FORMAT WRAPPED
SET LINESIZE 400
SET TRIMSPOOL ON
SET FEEDBACK OFF
SPOOL C03_SP_STAGE_PROFILE_OUT.txt

DECLARE
    -- ===== 설정 (필요 시 여기만 수정) =====================================================
    c_divs      CONSTANT VARCHAR2(100) := '40,81,82';     -- 측정 division (쉼표)
    c_repeat    CONSTANT PLS_INTEGER   := 2;              -- division 당 반복 (2회차 = 재사용 조건)
    c_user      CONSTANT VARCHAR2(50)  := 'minyonglee1';  -- p_created_by (화면 로그인 ID)
    c_group     CONSTANT VARCHAR2(50)  := 'ADMIN';        -- p_user_group (C02 [S1] USER_GROUP 값과 동일하게)
    c_version   CONSTANT VARCHAR2(30)  := 'Current';      -- p_version_type
    c_rowstats  CONSTANT VARCHAR2(1)   := 'N';            -- 'Y' = statistics_level=ALL (C04 에서 A-Rows 확인용 · 약간 느려짐)
    c_top       CONSTANT PLS_INTEGER   := 25;             -- 문장별 상위 N
    -- 기간 = FE 기본값 (당월 1일 ~ +6개월 -1일, makeInitSearchParams)
    v_from      VARCHAR2(8) := TO_CHAR(TRUNC(SYSDATE,'MM'),'YYYYMMDD');
    v_to        VARCHAR2(8) := TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE,'MM'),6) - 1,'YYYYMMDD');
    -- ==========================================================================================

    TYPE t_snap IS RECORD (ex NUMBER, el NUMBER, cpu NUMBER, bg NUMBER, dr NUMBER, rp NUMBER,
                           phv NUMBER, line NUMBER, hp NUMBER, txt VARCHAR2(400 CHAR));
    TYPE t_map  IS TABLE OF t_snap INDEX BY VARCHAR2(40);
    TYPE t_dlt  IS RECORD (k VARCHAR2(40), s t_snap);
    TYPE t_dlts IS TABLE OF t_dlt INDEX BY PLS_INTEGER;
    TYPE t_num  IS TABLE OF NUMBER INDEX BY VARCHAR2(64);
    TYPE t_proc IS TABLE OF VARCHAR2(60) INDEX BY PLS_INTEGER;
    TYPE t_cb   IS RECORD (sec NUMBER, bg NUMBER, phv NUMBER);
    TYPE t_cbm  IS TABLE OF t_cb INDEX BY VARCHAR2(40);
    TYPE t_ca   IS TABLE OF VARCHAR2(80) INDEX BY VARCHAR2(10);
    cb          t_cbm;        -- 사내 기준 (div:SQL_ID → 1회 초·BG·PHV)
    ca          t_ca;         -- 사내 기준 (div → SP·fetch 초)

    v_body_id   NUMBER;
    v_sid       NUMBER := SYS_CONTEXT('USERENV','SID');
    v_procs     t_proc;           -- BODY 시작 라인 → 프로시저명
    b_sql       t_map;  a_sql t_map;
    b_st        t_num;  a_st  t_num;
    d           t_dlts;
    v_div       VARCHAR2(10);
    v_rest      VARCHAR2(100);
    rc1 SYS_REFCURSOR; rc2 SYS_REFCURSOR; rc3 SYS_REFCURSOR; rc4 SYS_REFCURSOR; rc5 SYS_REFCURSOR; rcr SYS_REFCURSOR;
    t0 NUMBER; t1 NUMBER; t2 NUMBER;
    v_ts        TIMESTAMP;
    v_rows      VARCHAR2(200);
    v_sum_el    NUMBER;

    PROCEDURE p(s VARCHAR2) IS BEGIN DBMS_OUTPUT.PUT_LINE(s); END;

    PROCEDURE c(k VARCHAR2, sec NUMBER, bg NUMBER, phv NUMBER) IS
    BEGIN cb(k).sec := sec; cb(k).bg := bg; cb(k).phv := phv; END;

    PROCEDURE load_corp IS
    BEGIN
        -- <<CORP_BASELINE>> (_build_c03_baseline.py 가 _corp_C03_out.txt 2회차에서 생성 — 손으로 고치지 말 것)
        ca('40') := 'SP 2.50s + fetch 0.47s = 2.97s  rows=2098,6,1,5,181,1';
        ca('81') := 'SP 3.04s + fetch 0.57s = 3.61s  rows=2394,6,1,5,181,1';
        ca('82') := 'SP 3.54s + fetch 0.74s = 4.28s  rows=2622,6,1,5,181,1';
        c('40:18xg1y5298qgq', 0.536, 24962, 3971101268);
        c('40:fk3tvpkzsq2vx', 0.467, 15805, 360512032);
        c('40:631pzfvq8r0ut', 0.403, 61578, 620290878);
        c('40:20xrvz802rfsy', 0.219, 82339, 1553021311);
        c('40:4svg4dhnqxh8f', 0.166, 32343, 3195295405);
        c('40:f6r0861xjw0h1', 0.129, 24718, 4237537377);
        c('40:9xvpghd3tj06u', 0.120, 18326, 2619118743);
        c('40:0rp3b1v236wwz', 0.113, 33409, 4066606801);
        c('40:70xvv1ktud7js', 0.112, 6532, 1667501949);
        c('40:gkn9tran5v9tb', 0.100, 13064, 633531915);
        c('40:day2h1hdkc8y1', 0.086, 13891, 3484297769);
        c('40:cac9cbukwmudc', 0.083, 13064, 633531915);
        c('40:63ar9rz0axr5p', 0.077, 4765, 2395782385);
        c('40:3gxrkw0pavxxx', 0.073, 12209, 3737877804);
        c('40:3x9ardnmfczp0', 0.072, 7607, 116174995);
        c('40:7mrzdbpupw3b9', 0.051, 10326, 2591175856);
        c('40:9wgfrws532db6', 0.040, 2082, 3069957411);
        c('40:8ngcf5avm1q3q', 0.027, 2166, 3642427876);
        c('40:6jkjp6q7k1aum', 0.018, 6532, 3273597457);
        c('40:ggkupust9vjpj', 0.013, 6532, 422164050);
        c('40:cct9d3wpufmjn', 0.012, 667, 3069957411);
        c('40:67sysamdcxzmj', 0.010, 3161, 2351976090);
        c('40:6800d4bz18558', 0.006, 3161, 2351976090);
        c('40:88z04sh7864v4', 0.005, 799, 1759859575);
        c('40:8zj5nqpk4g3d6', 0.004, 3161, 4271728968);
        c('40:872vsnfnj927p', 0.002, 2301, 1879353244);
        c('40:7jg4wbat2mb66', 0.001, 702, 125332918);
        c('40:9pbzwq00mxuh3', 0.001, 702, 3123668380);
        c('40:13fk7wrwb8w4p', 0.001, 501, 524078883);
        c('40:93cz12p89r4sg', 0.001, 323, 207175028);
        c('40:4qkyq36q41j91', 0.001, 35, 942961353);
        c('40:5d4u7ud9bygrg', 0.001, 16, 2984351546);
        c('40:9p1t8xvr1d9qx', 0.000, 273, 921599326);
        c('40:byyxqu2ba3xmt', 0.000, 0, 1236776825);
        c('40:93djpd4h46mgu', 0.000, 70, 98234997);
        c('40:dn68352qhs5nf', 0.000, 8, 1177924293);
        c('40:fsb8nn1m1g1fs', 0.000, 18, 1907037104);
        c('40:63880yuzqpbpc', 0.000, 62, 172212249);
        c('40:3cz31ama0115w', 0.000, 5, 8458616);
        c('40:8qpqyknx78w7u', 0.000, 18, 3970780877);
        c('40:2nysu9tbng9v4', 0.000, 3, 598563120);
        c('40:1rdd7z94m70kz', 0.000, 18, 3970780877);
        c('40:8yt36mdth1yg6', 0.000, 15, 2471367407);
        c('40:cqcrfmc3a97jk', 0.000, 72, 2855824848);
        c('40:azj7n6mt2jk9s', 0.000, 32, 1111231445);
        c('40:1pp0288p8anr4', 0.000, 16, 1981029842);
        c('40:5hpz69bfv10s6', 0.000, 39, 1395126817);
        c('40:br0qzg41fkcrf', 0.000, 0, 2605627390);
        c('40:f5wdyr7mqhgjy', 0.000, 8, 3016646049);
        c('40:26uzh3hhmd044', 0.000, 4, 1177924293);
        c('40:38gzagpuubjyc', 0.000, 8, 2795996493);
        c('40:8wmdt0qmugzxs', 0.000, 37, 3782043337);
        c('40:a14ad1321btf0', 0.000, 3, 210685758);
        c('40:djmzu8tmxh7qh', 0.000, 3, 208588267);
        c('40:ac8mb4v706ra6', 0.000, 3, 2099092537);
        c('40:c8wu36rxs6xsq', 0.000, 7, 2394831589);
        c('40:3t7p1vubh3fta', 0.000, 4, 1177924293);
        c('40:066y9rj99mbyb', 0.000, 4, 1177924293);
        c('40:9bf71hb6kk7j8', 0.000, 4, 1177924293);
        c('40:3j9d24d9mqt28', 0.000, 4, 1177924293);
        c('40:8vp8vx3rfgus7', 0.000, 4, 1177924293);
        c('40:cq3tcsy8yjzxx', 0.000, 4, 1177924293);
        c('40:0suvfbm1605cc', 0.000, 2, 2704599268);
        c('40:52hzhxgdfvg79', 0.000, 4, 1177924293);
        c('40:4gsksgxj0ft42', 0.000, 0, 89136042);
        c('40:anxpu8mx6yatz', 0.000, 3, 2214029241);
        c('40:fsyuwzqdzkqs6', 0.000, 11, 1572652827);
        c('40:69brgkhvcq70m', 0.000, 13, 1923904587);
        c('40:b9fb415k3cvc7', 0.000, 5, 2523462205);
        c('40:gfhmmyrnrpcgs', 0.000, 2, 746735759);
        c('40:4wwbt94vcjyaz', 0.000, 0, 801820344);
        c('40:7mjh9m5n33tw0', 0.000, 6, 217069969);
        c('40:67ra8fm13mvv1', 0.000, 2, 2704599268);
        c('40:atrzjb810ck0w', 0.000, 3, 269115296);
        c('40:ahfv6gbr1j7c3', 0.000, 7, 3785927868);
        c('40:21awfna4w1hmd', 0.000, 3, 3030856279);
        c('40:2fd5qjnr55tzv', 0.000, 3, 310685974);
        c('40:0znupcj8287zd', 0.000, 0, 1177924293);
        c('40:1gdqs0d2x2fvz', 0.000, 0, 93899575);
        c('40:gy1pp2c4hsp84', 0.000, 2, 746735759);
        c('40:a32vx3j1r906f', 0.000, 3, 839680007);
        c('40:7zwu6ffgx0puc', 0.000, 3, 1757375235);
        c('40:5rharbjrtv9gz', 0.000, 3, 4046683497);
        c('40:gm012424yk5ny', 0.000, 0, 1388734953);
        c('40:dyrs68ndvbmch', 0.000, 0, 1388734953);
        c('81:18xg1y5298qgq', 0.583, 25245, 3971101268);
        c('81:fk3tvpkzsq2vx', 0.568, 16045, 360512032);
        c('81:12v19yag54ut1', 0.504, 83574, 3036190428);
        c('81:9xvpghd3tj06u', 0.349, 53656, 2619118743);
        c('81:20xrvz802rfsy', 0.234, 87559, 1553021311);
        c('81:3d2xnx839ksnt', 0.222, 67749, 1224431149);
        c('81:63ar9rz0axr5p', 0.197, 9764, 2395782385);
        c('81:70xvv1ktud7js', 0.121, 6532, 1667501949);
        c('81:f6r0861xjw0h1', 0.113, 19455, 4237537377);
        c('81:gfjpdh7fc1u59', 0.105, 39647, 982384402);
        c('81:gkn9tran5v9tb', 0.105, 13064, 633531915);
        c('81:0rp3b1v236wwz', 0.096, 31921, 4066606801);
        c('81:cac9cbukwmudc', 0.090, 13064, 633531915);
        c('81:day2h1hdkc8y1', 0.088, 14378, 3484297769);
        c('81:3x9ardnmfczp0', 0.078, 6422, 116174995);
        c('81:4r5kugqqq6cuy', 0.034, 9937, 3995613941);
        c('81:9wgfrws532db6', 0.020, 1178, 3069957411);
        c('81:6jkjp6q7k1aum', 0.018, 6532, 3273597457);
        c('81:ggkupust9vjpj', 0.014, 6532, 422164050);
        c('81:8ngcf5avm1q3q', 0.013, 1030, 3642427876);
        c('81:88z04sh7864v4', 0.010, 1560, 1759859575);
        c('81:67sysamdcxzmj', 0.010, 3209, 2351976090);
        c('81:6800d4bz18558', 0.006, 3209, 2351976090);
        c('81:cct9d3wpufmjn', 0.006, 548, 3069957411);
        c('81:8zj5nqpk4g3d6', 0.004, 3209, 4271728968);
        c('81:9pbzwq00mxuh3', 0.002, 1426, 3123668380);
        c('81:7jg4wbat2mb66', 0.002, 1426, 125332918);
        c('81:13fk7wrwb8w4p', 0.001, 501, 524078883);
        c('81:5d4u7ud9bygrg', 0.001, 16, 2984351546);
        c('81:4qkyq36q41j91', 0.000, 35, 942961353);
        c('81:93cz12p89r4sg', 0.000, 323, 207175028);
        c('81:9p1t8xvr1d9qx', 0.000, 273, 921599326);
        c('81:byyxqu2ba3xmt', 0.000, 0, 1236776825);
        c('81:93djpd4h46mgu', 0.000, 70, 98234997);
        c('81:fsb8nn1m1g1fs', 0.000, 20, 1907037104);
        c('81:dn68352qhs5nf', 0.000, 7, 1177924293);
        c('81:63880yuzqpbpc', 0.000, 67, 172212249);
        c('81:2nysu9tbng9v4', 0.000, 3, 598563120);
        c('81:f5wdyr7mqhgjy', 0.000, 8, 3016646049);
        c('81:3cz31ama0115w', 0.000, 5, 8458616);
        c('81:8qpqyknx78w7u', 0.000, 18, 3970780877);
        c('81:cqcrfmc3a97jk', 0.000, 77, 2855824848);
        c('81:1rdd7z94m70kz', 0.000, 18, 3970780877);
        c('81:8yt36mdth1yg6', 0.000, 12, 2471367407);
        c('81:1pp0288p8anr4', 0.000, 16, 1981029842);
        c('81:5hpz69bfv10s6', 0.000, 39, 1395126817);
        c('81:azj7n6mt2jk9s', 0.000, 32, 1111231445);
        c('81:g2f236ssg1rpu', 0.000, 0, 2456431936);
        c('81:ac8mb4v706ra6', 0.000, 3, 2099092537);
        c('81:djmzu8tmxh7qh', 0.000, 3, 208588267);
        c('81:8wmdt0qmugzxs', 0.000, 37, 3782043337);
        c('81:26uzh3hhmd044', 0.000, 4, 1177924293);
        c('81:a14ad1321btf0', 0.000, 3, 210685758);
        c('81:38gzagpuubjyc', 0.000, 8, 2795996493);
        c('81:c8wu36rxs6xsq', 0.000, 7, 2394831589);
        c('81:52hzhxgdfvg79', 0.000, 4, 1177924293);
        c('81:8kzbu46dc5arm', 0.000, 0, 2112400780);
        c('81:066y9rj99mbyb', 0.000, 4, 1177924293);
        c('81:anxpu8mx6yatz', 0.000, 3, 2214029241);
        c('81:3t7p1vubh3fta', 0.000, 4, 1177924293);
        c('81:3j9d24d9mqt28', 0.000, 4, 1177924293);
        c('81:9bf71hb6kk7j8', 0.000, 4, 1177924293);
        c('81:cq3tcsy8yjzxx', 0.000, 4, 1177924293);
        c('81:0suvfbm1605cc', 0.000, 2, 2704599268);
        c('81:8vp8vx3rfgus7', 0.000, 4, 1177924293);
        c('81:b9fb415k3cvc7', 0.000, 5, 2523462205);
        c('81:69brgkhvcq70m', 0.000, 13, 1923904587);
        c('81:67ra8fm13mvv1', 0.000, 2, 2704599268);
        c('81:atrzjb810ck0w', 0.000, 3, 269115296);
        c('81:7mjh9m5n33tw0', 0.000, 6, 217069969);
        c('81:fsyuwzqdzkqs6', 0.000, 5, 1572652827);
        c('81:4wwbt94vcjyaz', 0.000, 0, 801820344);
        c('81:gfhmmyrnrpcgs', 0.000, 2, 746735759);
        c('81:21awfna4w1hmd', 0.000, 3, 3030856279);
        c('81:1gdqs0d2x2fvz', 0.000, 0, 93899575);
        c('81:2fd5qjnr55tzv', 0.000, 3, 310685974);
        c('81:ahfv6gbr1j7c3', 0.000, 4, 3785927868);
        c('81:7zwu6ffgx0puc', 0.000, 3, 1757375235);
        c('81:0znupcj8287zd', 0.000, 0, 1177924293);
        c('81:a32vx3j1r906f', 0.000, 3, 839680007);
        c('81:5rharbjrtv9gz', 0.000, 3, 4046683497);
        c('81:gm012424yk5ny', 0.000, 0, 1388734953);
        c('81:gy1pp2c4hsp84', 0.000, 2, 746735759);
        c('81:dyrs68ndvbmch', 0.000, 0, 1388734953);
        c('82:18xg1y5298qgq', 0.837, 94788, 3971101268);
        c('82:fk3tvpkzsq2vx', 0.733, 18440, 360512032);
        c('82:12v19yag54ut1', 0.623, 107734, 3036190428);
        c('82:3d2xnx839ksnt', 0.317, 100023, 1224431149);
        c('82:9xvpghd3tj06u', 0.301, 38767, 2619118743);
        c('82:20xrvz802rfsy', 0.251, 86990, 1553021311);
        c('82:63ar9rz0axr5p', 0.211, 9465, 2395782385);
        c('82:70xvv1ktud7js', 0.156, 6605, 1667501949);
        c('82:gkn9tran5v9tb', 0.124, 13210, 633531915);
        c('82:f6r0861xjw0h1', 0.110, 14180, 4237537377);
        c('82:cac9cbukwmudc', 0.106, 13210, 633531915);
        c('82:0rp3b1v236wwz', 0.103, 30931, 4066606801);
        c('82:gfjpdh7fc1u59', 0.101, 39372, 982384402);
        c('82:3x9ardnmfczp0', 0.097, 7378, 116174995);
        c('82:day2h1hdkc8y1', 0.076, 13416, 3484297769);
        c('82:6jkjp6q7k1aum', 0.019, 6605, 3273597457);
        c('82:ggkupust9vjpj', 0.017, 6605, 422164050);
        c('82:4r5kugqqq6cuy', 0.015, 2711, 3995613941);
        c('82:67sysamdcxzmj', 0.012, 3688, 2351976090);
        c('82:88z04sh7864v4', 0.009, 1480, 1759859575);
        c('82:6800d4bz18558', 0.008, 3688, 2351976090);
        c('82:9wgfrws532db6', 0.007, 687, 3069957411);
        c('82:8zj5nqpk4g3d6', 0.005, 3688, 4271728968);
        c('82:8ngcf5avm1q3q', 0.005, 504, 3642427876);
        c('82:7jg4wbat2mb66', 0.004, 1426, 125332918);
        c('82:cct9d3wpufmjn', 0.003, 530, 3069957411);
        c('82:9pbzwq00mxuh3', 0.002, 1426, 3123668380);
        c('82:4ujdrrz9r655m', 0.001, 162, 91901130);
        c('82:13fk7wrwb8w4p', 0.001, 501, 524078883);
        c('82:4qkyq36q41j91', 0.001, 35, 942961353);
        c('82:5d4u7ud9bygrg', 0.001, 16, 2984351546);
        c('82:9p1t8xvr1d9qx', 0.001, 273, 921599326);
        c('82:93cz12p89r4sg', 0.000, 323, 207175028);
        c('82:byyxqu2ba3xmt', 0.000, 0, 1236776825);
        c('82:93djpd4h46mgu', 0.000, 70, 98234997);
        c('82:dn68352qhs5nf', 0.000, 7, 1177924293);
        c('82:63880yuzqpbpc', 0.000, 78, 172212249);
        c('82:cqcrfmc3a97jk', 0.000, 87, 2855824848);
        c('82:2nysu9tbng9v4', 0.000, 3, 598563120);
        c('82:8qpqyknx78w7u', 0.000, 18, 3970780877);
        c('82:1rdd7z94m70kz', 0.000, 18, 3970780877);
        c('82:3cz31ama0115w', 0.000, 5, 8458616);
        c('82:f5wdyr7mqhgjy', 0.000, 8, 3016646049);
        c('82:1pp0288p8anr4', 0.000, 16, 1981029842);
        c('82:azj7n6mt2jk9s', 0.000, 32, 1111231445);
        c('82:g2f236ssg1rpu', 0.000, 0, 2456431936);
        c('82:8wmdt0qmugzxs', 0.000, 37, 3782043337);
        c('82:8yt36mdth1yg6', 0.000, 6, 2471367407);
        c('82:djmzu8tmxh7qh', 0.000, 3, 208588267);
        c('82:26uzh3hhmd044', 0.000, 4, 1177924293);
        c('82:fsb8nn1m1g1fs', 0.000, 5, 1907037104);
        c('82:a14ad1321btf0', 0.000, 3, 210685758);
        c('82:ac8mb4v706ra6', 0.000, 3, 2099092537);
        c('82:38gzagpuubjyc', 0.000, 8, 2795996493);
        c('82:5hpz69bfv10s6', 0.000, 23, 1395126817);
        c('82:066y9rj99mbyb', 0.000, 4, 1177924293);
        c('82:c8wu36rxs6xsq', 0.000, 6, 2394831589);
        c('82:3j9d24d9mqt28', 0.000, 4, 1177924293);
        c('82:cq3tcsy8yjzxx', 0.000, 4, 1177924293);
        c('82:ahfv6gbr1j7c3', 0.000, 9, 3785927868);
        c('82:3t7p1vubh3fta', 0.000, 4, 1177924293);
        c('82:8kzbu46dc5arm', 0.000, 0, 2112400780);
        c('82:52hzhxgdfvg79', 0.000, 4, 1177924293);
        c('82:9bf71hb6kk7j8', 0.000, 4, 1177924293);
        c('82:8vp8vx3rfgus7', 0.000, 4, 1177924293);
        c('82:anxpu8mx6yatz', 0.000, 3, 2214029241);
        c('82:0suvfbm1605cc', 0.000, 2, 2704599268);
        c('82:69brgkhvcq70m', 0.000, 13, 1923904587);
        c('82:fsyuwzqdzkqs6', 0.000, 11, 1572652827);
        c('82:b9fb415k3cvc7', 0.000, 5, 2523462205);
        c('82:67ra8fm13mvv1', 0.000, 2, 2704599268);
        c('82:4wwbt94vcjyaz', 0.000, 0, 801820344);
        c('82:atrzjb810ck0w', 0.000, 3, 269115296);
        c('82:gfhmmyrnrpcgs', 0.000, 2, 746735759);
        c('82:7mjh9m5n33tw0', 0.000, 6, 217069969);
        c('82:1gdqs0d2x2fvz', 0.000, 0, 93899575);
        c('82:2fd5qjnr55tzv', 0.000, 3, 310685974);
        c('82:0znupcj8287zd', 0.000, 0, 1177924293);
        c('82:21awfna4w1hmd', 0.000, 3, 3030856279);
        c('82:a32vx3j1r906f', 0.000, 3, 839680007);
        c('82:7zwu6ffgx0puc', 0.000, 3, 1757375235);
        c('82:5rharbjrtv9gz', 0.000, 3, 4046683497);
        c('82:gm012424yk5ny', 0.000, 0, 1388734953);
        c('82:gy1pp2c4hsp84', 0.000, 2, 746735759);
        c('82:dyrs68ndvbmch', 0.000, 0, 1388734953);
        -- <</CORP_BASELINE>>
    END;

    FUNCTION proc_of(p_line NUMBER) RETURN VARCHAR2 IS
        i PLS_INTEGER; r VARCHAR2(60) := '-';
    BEGIN
        IF p_line IS NULL OR p_line = 0 THEN RETURN '-'; END IF;
        i := v_procs.FIRST;
        WHILE i IS NOT NULL AND i <= p_line LOOP r := v_procs(i); i := v_procs.NEXT(i); END LOOP;
        RETURN REPLACE(r, 'P_DMF0082_', '');
    END;

    PROCEDURE snap_sql(m OUT t_map) IS
    BEGIN
        FOR r IN (SELECT SQL_ID || '/' || CHILD_NUMBER K, EXECUTIONS, ELAPSED_TIME, CPU_TIME, BUFFER_GETS, DISK_READS,
                         ROWS_PROCESSED, PLAN_HASH_VALUE, PROGRAM_LINE#, LOADS,
                         SUBSTR(REGEXP_REPLACE(SQL_TEXT,'\s+',' '),1,100) TXT
                    FROM V$SQL
                   WHERE PROGRAM_ID = v_body_id
                      OR (PARSING_SCHEMA_NAME = USER AND SQL_TEXT LIKE '%GT\_DMF0082%' ESCAPE '\')
                      OR SQL_TEXT LIKE '%OPT\_DYN\_SAMP%' ESCAPE '\') LOOP
            m(r.K).ex := r.EXECUTIONS; m(r.K).el := r.ELAPSED_TIME; m(r.K).cpu := r.CPU_TIME;
            m(r.K).bg := r.BUFFER_GETS; m(r.K).dr := r.DISK_READS; m(r.K).rp := r.ROWS_PROCESSED;
            m(r.K).phv := r.PLAN_HASH_VALUE; m(r.K).line := r.PROGRAM_LINE#; m(r.K).hp := r.LOADS;
            m(r.K).txt := r.TXT;
        END LOOP;
    END;

    PROCEDURE snap_stat(m OUT t_num) IS
    BEGIN
        FOR r IN (SELECT N.NAME, S.VALUE FROM V$MYSTAT S JOIN V$STATNAME N ON N.STATISTIC# = S.STATISTIC#
                   WHERE N.NAME IN ('session logical reads','physical reads','physical reads direct temporary tablespace',
                                    'physical writes direct temporary tablespace','parse count (hard)','parse count (total)',
                                    'parse time elapsed','CPU used by this session','execute count','recursive calls',
                                    'sorts (disk)','sorts (rows)','redo size','user I/O wait time','DB time')) LOOP
            m(r.NAME) := r.VALUE;
        END LOOP;
    END;

    FUNCTION fetch_count(rc IN OUT SYS_REFCURSOR) RETURN NUMBER IS
        c INTEGER; n NUMBER := 0;
    BEGIN
        IF NOT rc%ISOPEN THEN RETURN -1; END IF;
        c := DBMS_SQL.TO_CURSOR_NUMBER(rc);
        WHILE DBMS_SQL.FETCH_ROWS(c) > 0 LOOP n := n + 1; END LOOP;
        DBMS_SQL.CLOSE_CURSOR(c);
        RETURN n;
    EXCEPTION WHEN OTHERS THEN RETURN -2;
    END;

    PROCEDURE report(p_div VARCHAR2, p_run PLS_INTEGER) IS
        k VARCHAR2(40); ks VARCHAR2(64); ck VARCHAR2(40); v_cmp VARCHAR2(200); s t_snap; n PLS_INTEGER := 0; tmp t_dlt; mx PLS_INTEGER;
        v_cat VARCHAR2(10); tot_pkg NUMBER := 0; tot_dyn NUMBER := 0; tot_ds NUMBER := 0; cnt_ds NUMBER := 0;
    BEGIN
        d.DELETE;
        k := a_sql.FIRST;
        WHILE k IS NOT NULL LOOP
            s := a_sql(k);
            IF b_sql.EXISTS(k) THEN
                s.ex := s.ex - b_sql(k).ex; s.el := s.el - b_sql(k).el; s.cpu := s.cpu - b_sql(k).cpu;
                s.bg := s.bg - b_sql(k).bg; s.dr := s.dr - b_sql(k).dr; s.rp := s.rp - b_sql(k).rp;
                s.hp := s.hp - b_sql(k).hp;
            END IF;
            IF s.ex > 0 OR s.el > 0 THEN
                n := n + 1; d(n).k := k; d(n).s := s;
                IF s.txt LIKE '%OPT_DYN_SAMP%' THEN tot_ds := tot_ds + s.el; cnt_ds := cnt_ds + 1;
                ELSIF NVL(s.line,0) > 0 THEN tot_pkg := tot_pkg + s.el;
                ELSE tot_dyn := tot_dyn + s.el; END IF;
            END IF;
            k := a_sql.NEXT(k);
        END LOOP;
        -- 경과시간 내림차순 (선택 정렬 — 수십~수백 건)
        FOR i IN 1 .. LEAST(n, c_top) LOOP
            mx := i;
            FOR j IN i + 1 .. n LOOP IF d(j).s.el > d(mx).s.el THEN mx := j; END IF; END LOOP;
            IF mx <> i THEN tmp := d(i); d(i) := d(mx); d(mx) := tmp; END IF;
        END LOOP;

        p('  (B) 문장별 귀속 — V$SQL 델타 상위 ' || c_top || ' (초 = ELAPSED, BG = buffer gets, DR = disk reads, HP = 하드파싱 로드)');
        p('      ' || RPAD('LINE',6) || RPAD('PROC',22) || LPAD('SEC',8) || LPAD('CPU',8) || LPAD('EXEC',6) || LPAD('BG',12)
          || LPAD('DR',10) || LPAD('ROWS',10) || LPAD('HP',4) || '  ' || RPAD('SQL_ID/CHILD',18) || RPAD('PHV',12)
          || LPAD('사내SEC',8) || LPAD('SEC_X',7) || LPAD('사내BG',10) || '  ' || RPAD('PHV비교',9) || 'TEXT');
        FOR i IN 1 .. LEAST(n, c_top) LOOP
            s := d(i).s;
            ck := p_div || ':' || SUBSTR(d(i).k, 1, INSTR(d(i).k, '/') - 1);
            IF cb.EXISTS(ck) THEN
                v_cmp := LPAD(TO_CHAR(cb(ck).sec,'FM9990.000'),8)
                      || LPAD(CASE WHEN cb(ck).sec > 0 THEN TO_CHAR(s.el/1e6/cb(ck).sec,'FM99990.0') END,7)
                      || LPAD(cb(ck).bg,10) || '  '
                      || RPAD(CASE WHEN cb(ck).phv = s.phv THEN 'same' ELSE '≠ 상이' END, 9);
            ELSE
                v_cmp := LPAD('-',8) || LPAD('-',7) || LPAD('-',10) || '  ' || RPAD('사내없음',9);
            END IF;
            p('      ' || RPAD(NVL(TO_CHAR(NULLIF(s.line,0)),'-'),6) || RPAD(proc_of(s.line),22)
              || LPAD(TO_CHAR(s.el/1e6,'FM9990.000'),8) || LPAD(TO_CHAR(s.cpu/1e6,'FM9990.000'),8) || LPAD(s.ex,6)
              || LPAD(s.bg,12) || LPAD(s.dr,10) || LPAD(s.rp,10) || LPAD(s.hp,4) || '  ' || RPAD(d(i).k,18)
              || RPAD(s.phv,12) || v_cmp || SUBSTR(s.txt,1,80));
        END LOOP;
        p('      합계: PKG 정적문장 ' || TO_CHAR(tot_pkg/1e6,'FM9990.00') || 's · 동적/기타(GT_DMF0082) '
          || TO_CHAR(tot_dyn/1e6,'FM9990.00') || 's · 동적샘플링 재귀 ' || TO_CHAR(tot_ds/1e6,'FM9990.00')
          || 's (' || cnt_ds || '문장)');
        v_sum_el := tot_pkg + tot_dyn + tot_ds;

        p('  (C) 내 세션 ASH — SQL_ID × 이벤트 (샘플 ≈ 초)');
        FOR r IN (SELECT NVL(A.SQL_ID,'(PL/SQL)') SQL_ID, NVL(A.EVENT,'ON CPU') EVT, COUNT(*) N,
                         MAX(A.SQL_PLAN_HASH_VALUE) PHV,
                         MAX(A.SQL_PLAN_OPERATION || ' ' || A.SQL_PLAN_OPTIONS) KEEP (DENSE_RANK LAST ORDER BY A.SAMPLE_ID) OP
                    FROM V$ACTIVE_SESSION_HISTORY A
                   WHERE A.SESSION_ID = v_sid AND A.SAMPLE_TIME >= v_ts
                   GROUP BY NVL(A.SQL_ID,'(PL/SQL)'), NVL(A.EVENT,'ON CPU')
                   ORDER BY 3 DESC FETCH FIRST 12 ROWS ONLY) LOOP
            p('      ' || RPAD(r.SQL_ID,16) || LPAD(r.N,5) || '  ' || RPAD(r.EVT,40) || RPAD(NVL(TO_CHAR(r.PHV),'-'),12) || r.OP);
        END LOOP;

        p('  (D) 세션 통계 델타');
        ks := a_st.FIRST;
        WHILE ks IS NOT NULL LOOP
            IF a_st(ks) - CASE WHEN b_st.EXISTS(ks) THEN b_st(ks) ELSE 0 END <> 0 THEN
                p('      ' || RPAD(ks,48) || LPAD(a_st(ks) - CASE WHEN b_st.EXISTS(ks) THEN b_st(ks) ELSE 0 END, 16));
            END IF;
            ks := a_st.NEXT(ks);
        END LOOP;
    END;
BEGIN
    SELECT OBJECT_ID INTO v_body_id FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0082' AND OBJECT_TYPE = 'PACKAGE BODY';
    FOR r IN (SELECT LINE, REGEXP_SUBSTR(TEXT,'P_\w+') NM FROM USER_SOURCE
               WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY' AND REGEXP_LIKE(TEXT,'^PROCEDURE\s+P_')) LOOP
        v_procs(r.LINE) := r.NM;
    END LOOP;
    IF c_rowstats = 'Y' THEN EXECUTE IMMEDIATE 'ALTER SESSION SET statistics_level = ALL'; END IF;
    load_corp;

    p('================================================================================================');
    p(' DMF0082 SP 프로파일  DB=' || SYS_CONTEXT('USERENV','DB_NAME') || '/' || SYS_CONTEXT('USERENV','CON_NAME')
      || '  HOST=' || SYS_CONTEXT('USERENV','SERVER_HOST') || '  SID=' || v_sid || '  ' || TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS'));
    p(' 인자: user=' || c_user || ' group=' || c_group || ' version=' || c_version || ' 기간 ' || v_from || '~' || v_to
      || ' · 나머지 필터 ALL · itemId NULL · statistics_level=' || CASE c_rowstats WHEN 'Y' THEN 'ALL' ELSE '기본' END);
    p(' 사내SEC/사내BG = 같은 SQL_ID 의 사내 1회 실측 · SEC_X = 클라우드÷사내 · PHV비교 ≠ = 실행계획이 사내와 다름 (최우선 의심)');
    p('================================================================================================');

    v_rest := c_divs || ',';
    WHILE INSTR(v_rest, ',') > 0 LOOP
        v_div  := TRIM(SUBSTR(v_rest, 1, INSTR(v_rest, ',') - 1));
        v_rest := SUBSTR(v_rest, INSTR(v_rest, ',') + 1);
        CONTINUE WHEN v_div IS NULL;
        FOR run IN 1 .. c_repeat LOOP
            b_sql.DELETE; a_sql.DELETE; b_st.DELETE; a_st.DELETE;
            snap_sql(b_sql); snap_stat(b_st);
            v_ts := SYSTIMESTAMP;
            t0 := DBMS_UTILITY.GET_TIME;
            PKG_DMF0082.P_DMF0082_GET_MAIN_DATA(
                p_division_id => v_div, p_team_id => 'ALL', p_customer => 'ALL', p_biz_type => 'ALL',
                p_from_yyyymmdd => v_from, p_to_yyyymmdd => v_to, p_scm_site_id => 'ALL', p_item_id => NULL,
                p_version_type => c_version, p_qty_yn => 'N', p_created_by => c_user, p_user_group => c_group,
                p_plant_site_id => 'ALL', p_project_code => 'ALL', p_owner => 'ALL', p_sender_code => 'ALL',
                O_RC1 => rc1, O_RC2 => rc2, O_RC3 => rc3, O_RC4 => rc4, O_RC5 => rc5, O_RESULT_CURSOR => rcr);
            t1 := DBMS_UTILITY.GET_TIME;
            v_rows := fetch_count(rc1) || ',' || fetch_count(rc2) || ',' || fetch_count(rc3) || ','
                   || fetch_count(rc4) || ',' || fetch_count(rc5) || ',' || fetch_count(rcr);
            t2 := DBMS_UTILITY.GET_TIME;
            snap_sql(a_sql); snap_stat(a_st);
            ROLLBACK;
            p('');
            p('### div=' || v_div || ' run' || run || '  (A) SP ' || TO_CHAR((t1 - t0)/100,'FM99990.00') || 's  + 커서 fetch '
              || TO_CHAR((t2 - t1)/100,'FM99990.00') || 's  = DB 합 ' || TO_CHAR((t2 - t0)/100,'FM99990.00')
              || 's   rows[RC1..5,RESULT]=' || v_rows);
            IF ca.EXISTS(v_div) THEN p('      사내 기준(ZIOUI1 2회차): ' || ca(v_div)); END IF;
            report(v_div, run);
            p('      → 문장 귀속 합 ' || TO_CHAR(v_sum_el/1e6,'FM99990.00') || 's / DB 합 ' || TO_CHAR((t2 - t0)/100,'FM99990.00')
              || 's (차이 = PL/SQL 처리·귀속 밖 재귀SQL)');
        END LOOP;
    END LOOP;
    IF c_rowstats = 'Y' THEN EXECUTE IMMEDIATE 'ALTER SESSION SET statistics_level = TYPICAL'; END IF;
    p('');
    p('완료 — 상위 문장의 SQL_ID 를 C04_PLAN_OF_SQLID.sql 에 넣어 실행계획 확인');
EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    p('!!! 오류: ' || SQLERRM);
    p(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    RAISE;
END;
/

SPOOL OFF
SET FEEDBACK ON
