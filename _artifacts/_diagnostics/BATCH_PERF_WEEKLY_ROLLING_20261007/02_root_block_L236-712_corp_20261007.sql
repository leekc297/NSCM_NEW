-- 사내 ZIOUI1 ALL_SOURCE (LAST_DDL 2026-10-06 15:38:38) PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING L236~712 — 루트 자체 93초 구간 원문 (참조용, 줄번호 = PROGRAM_LINE# 대조)
 236|               [PJ2025-50188] 기준수요 기반 CUTOFF 기능 추가 (START)
 237|               ----------------------------------------------------------------------------------------------------------*/
 238|             BEGIN
 239|                 /*------------------------------------------------------------------------------------
 240|                   화.00시(MKT_FCST) 일 때는 SCM_FCST Delete ==> Insert 처리
 241|                   화.14시(SCM_FCST) 일 때는 SCM_FCST CUTOFF 처리
 242|                   ------------------------------------------------------------------------------------*/
 243|                 IF ( V_DIVISION_ID = '40' AND P_VER_TYPE = 'MF_W' ) THEN  /* [PJ2025-50188] SF_W CUTOFF 시점에 DM_PLN_CFM_MKT_DEMAND_PLAN (MKT_FCST ==> SCM_FCST 동기화) */
 244|                     /*------------------------------------------------------------------------------------
 245|                       [PJ2025-50188] DM_PLN_MKT_FCST (MKT_FCST ==> SCM_FCST) 동기화
 246|                       [PJ2025-50188] DM_PLN_CFM_MKT_DEMAND_PLAN (MKT_FCST ==> SCM_FCST) 동기화
 247|                       ------------------------------------------------------------------------------------*/
 248|                     DELETE
 249|                       FROM DM_PLN_MKT_FCST
 250|                      WHERE DIVISION_ID = V_DIVISION_ID
 251|                        AND YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')
 252|                        AND MEASURE = 'SCM_FCST';
 253| 
 254|                     INSERT INTO DM_PLN_MKT_FCST
 255|                          ( DIVISION_ID
 256|                          , PROJECT_CODE
 257|                          , SCM_SITE_ID
 258|                          , ITEM_ID
 259|                          , DOM_EXP
 260|                          , FCST_TYPE
 261|                          , INCOTERMS
 262|                          , MEASURE
 263|                          , PLANT_SITE_ID
 264|                          , YYYYMMDD
 265|                          , QTY
 266|                          , CREATED_BY
 267|                          , CREATION_DATE
 268|                          , LAST_UPDATED_BY
 269|                          , LAST_UPDATE_DATE )
 270|                     SELECT A.DIVISION_ID
 271|                          , A.PROJECT_CODE
 272|                          , A.SCM_SITE_ID
 273|                          , A.ITEM_ID
 274|                          , A.DOM_EXP
 275|                          , A.FCST_TYPE
 276|                          , A.INCOTERMS
 277|                          , 'SCM_FCST'
 278|                          , A.PLANT_SITE_ID
 279|                          , A.YYYYMMDD
 280|                          , A.QTY
 281|                          , A.CREATED_BY
 282|                          , A.CREATION_DATE
 283|                          , A.LAST_UPDATED_BY
 284| --                         , A.LAST_UPDATE_DATE
 285|                          , SYSDATE
 286|                       FROM DM_PLN_MKT_FCST A
 287|                      WHERE A.DIVISION_ID = V_DIVISION_ID
 288|                        AND A.MEASURE     = 'MKT_FCST'
 289|                        AND A.YYYYMMDD   >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD');
 290| 
 291|                     DELETE
 292|                       FROM DM_PLN_CFM_MKT_DEMAND_PLAN
 293|                      WHERE DIVISION_ID = V_DIVISION_ID
 294|                        AND YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')
 295|                        AND MEASURE = 'SCM_FCST';
 296| 
 297|                     INSERT INTO DM_PLN_CFM_MKT_DEMAND_PLAN
 298|                          ( DIVISION_ID
 299|                          , PROJECT_CODE
 300|                          , END_CUSTOMER
 301|                          , SCM_SITE_ID
 302|                          , ITEM_ID
 303|                          , DOM_EXP
 304|                          , FCST_TYPE
 305|                          , INCOTERMS
 306|                          , MEASURE
 307|                          , PLANT_SITE_ID
 308|                          , CELL_PROD_SITE_ID
 309|                          , YYYYMMDD
 310|                          , QTY
 311|                          , CREATED_BY
 312|                          , CREATION_DATE
 313|                          , LAST_UPDATED_BY
 314|                          , LAST_UPDATE_DATE )
 315|                     SELECT A.DIVISION_ID
 316|                          , A.PROJECT_CODE
 317|                          , A.END_CUSTOMER
 318|                          , A.SCM_SITE_ID
 319|                          , A.ITEM_ID
 320|                          , A.DOM_EXP
 321|                          , A.FCST_TYPE
 322|                          , A.INCOTERMS
 323|                          , 'SCM_FCST'
 324|                          , A.PLANT_SITE_ID
 325|                          , A.CELL_PROD_SITE_ID
 326|                          , A.YYYYMMDD
 327|                          , A.QTY
 328|                          , A.CREATED_BY
 329|                          , A.CREATION_DATE
 330|                          , A.LAST_UPDATED_BY
 331|                          --, A.LAST_UPDATE_DATE
 332|                          , SYSDATE
 333|                       FROM DM_PLN_CFM_MKT_DEMAND_PLAN A
 334|                      WHERE A.DIVISION_ID = V_DIVISION_ID
 335|                        AND A.MEASURE     = 'MKT_FCST'
 336|                        AND A.YYYYMMDD   >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD');
 337|                     -- AJS 20260902
 338|                 ELSIF ( SUBSTR(V_DIVISION_ID, 1, 2) = '81' AND P_VER_TYPE = 'MF_W' ) THEN  
 339|                     DELETE  
 340|                       FROM DM_PLN_MKT_FCST  
 341|                      WHERE DIVISION_ID = V_DIVISION_ID  
 342|                        AND YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')  
 343|                        AND MEASURE = 'SCM_FCST';  
 344|                     INSERT INTO DM_PLN_MKT_FCST  
 345|                          ( DIVISION_ID  
 346|                          , PROJECT_CODE  
 347|                          , SCM_SITE_ID  
 348|                          , ITEM_ID  
 349|                          , DOM_EXP  
 350|                          , FCST_TYPE  
 351|                          , INCOTERMS  
 352|                          , MEASURE  
 353|                          , PLANT_SITE_ID  
 354|                          , YYYYMMDD  
 355|                          , QTY  
 356|                          , CREATED_BY  
 357|                          , CREATION_DATE  
 358|                          , LAST_UPDATED_BY  
 359|                          , LAST_UPDATE_DATE )  
 360|                     SELECT A.DIVISION_ID  
 361|                          , A.PROJECT_CODE  
 362|                          , A.SCM_SITE_ID  
 363|                          , A.ITEM_ID  
 364|                          , A.DOM_EXP  
 365|                          , A.FCST_TYPE  
 366|                          , A.INCOTERMS  
 367|                          , 'SCM_FCST'  
 368|                          , A.PLANT_SITE_ID  
 369|                          , A.YYYYMMDD  
 370|                          , A.QTY  
 371|                          , A.CREATED_BY  
 372|                          , A.CREATION_DATE  
 373|                          , A.LAST_UPDATED_BY  
 374|                          --, A.LAST_UPDATE_DATE
 375|                          , SYSDATE  
 376|                       FROM DM_PLN_MKT_FCST A  
 377|                      WHERE A.DIVISION_ID = V_DIVISION_ID  
 378|                        AND A.MEASURE     = 'MKT_FCST'  
 379|                        AND A.YYYYMMDD   >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD');  
 380|                 END IF;
 381|             END;
 382|             DBMS_OUTPUT.PUT_LINE('1');
 383|             BEGIN
 384|                 INSERT INTO DM_PLN_MKT_FCST_C
 385|                      ( DIVISION_ID
 386|                      , VERSION_NO
 387|                      , CUTOFF_TYPE
 388|                      , CUTOFF_YYYYMMDD
 389|                      , PROJECT_CODE
 390|                      , SCM_SITE_ID
 391|                      , ITEM_ID
 392|                      , DOM_EXP
 393|                      , FCST_TYPE
 394|                      , INCOTERMS
 395|                      , MEASURE
 396|                      , PLANT_SITE_ID
 397|                      , YYYYMMDD
 398|                      , QTY
 399|                      , CREATED_BY
 400|                      , CREATION_DATE
 401|                      , LAST_UPDATED_BY
 402|                      , LAST_UPDATE_DATE
 403|                      , ATTRIBUTE1
 404|                      , ATTRIBUTE2
 405|                      , ATTRIBUTE3
 406|                      , ATTRIBUTE4
 407|                      , ATTRIBUTE5
 408|                      , ATTRIBUTE6
 409|                      , ATTRIBUTE7
 410|                      , ATTRIBUTE8
 411|                      , ATTRIBUTE9
 412|                      , ATTRIBUTE10 )
 413|                 SELECT V_DIVISION_ID
 414|                      , V_VER_RETURN_NO
 415|                      , V_VER_TYPE
 416|                      , TO_CHAR(SYSDATE, 'YYYYMMDD')
 417|                      , A.PROJECT_CODE
 418|                      , A.SCM_SITE_ID
 419|                      , A.ITEM_ID
 420|                      , A.DOM_EXP
 421|                      , A.FCST_TYPE
 422|                      , A.INCOTERMS
 423|                      , A.MEASURE
 424|                      , A.PLANT_SITE_ID
 425|                      , A.YYYYMMDD
 426|                      , A.QTY
 427|                      , V_CREATED_BY
 428|                      , A.CREATION_DATE
 429|                      , A.LAST_UPDATED_BY
 430|                      --, A.LAST_UPDATE_DATE
 431|                      , SYSDATE
 432|                      , A.ATTRIBUTE1
 433|                      , A.ATTRIBUTE2
 434|                      , A.ATTRIBUTE3
 435|                      , A.ATTRIBUTE4
 436|                      , A.ATTRIBUTE5
 437|                      , A.ATTRIBUTE6
 438|                      , A.ATTRIBUTE7
 439|                      , A.ATTRIBUTE8
 440|                      , A.ATTRIBUTE9
 441|                      , A.ATTRIBUTE10
 442|                   FROM ( SELECT F.DIVISION_ID
 443|                               , F.PROJECT_CODE
 444|                               , F.SCM_SITE_ID
 445|                               , F.ITEM_ID
 446|                               , F.DOM_EXP
 447|                               , F.FCST_TYPE
 448|                               , F.INCOTERMS
 449|                               , F.MEASURE
 450|                               , F.PLANT_SITE_ID
 451|                               , F.YYYYMMDD
 452|                               , F.QTY
 453|                               , F.CREATED_BY
 454|                               , F.CREATION_DATE
 455|                               , F.LAST_UPDATED_BY
 456|                               , F.LAST_UPDATE_DATE
 457|                               , F.ATTRIBUTE1
 458|                               , F.ATTRIBUTE2
 459|                               , F.ATTRIBUTE3
 460|                               , F.ATTRIBUTE4
 461|                               , F.ATTRIBUTE5
 462|                               , F.ATTRIBUTE6
 463|                               , F.ATTRIBUTE7
 464|                               , F.ATTRIBUTE8
 465|                               , F.ATTRIBUTE9
 466|                               , F.ATTRIBUTE10
 467|                            FROM DM_PLN_MKT_FCST     F
 468|                               , SCM_MST_SITE_ITEM   T2   /* 20230410 JHS [E20230403-000148] */
 469|                           WHERE F.DIVISION_ID  = T2.DIVISION_ID
 470|                             AND F.PROJECT_CODE = T2.PROJECT_CODE
 471|                             AND F.SCM_SITE_ID  = T2.SCM_SITE_ID
 472|                             AND F.ITEM_ID      = T2.ITEM_ID
 473|                             AND T2.VALID_YN    = 'Y'
 474|                             AND F.DIVISION_ID  = V_DIVISION_ID
 475|                             AND F.YYYYMMDD    >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')
 476|                             AND F.MEASURE NOT IN ('CUST_FCST_EDI_ORG', 'Immidiate[Org.]', 'Planning_Forecast[Org.]', 'Commercial_Agreement[Org.]', 'Firm_Temp[Org.]', 'Manumacturing_Material_Temp[Org.]', 'Material_Temp[Org.]', 'Backorder[Org.]')
 477|                          UNION ALL
 478|                          SELECT F.DIVISION_ID
 479|                               , F.PROJECT_CODE
 480|                               , F.SCM_SITE_ID
 481|                               , F.ITEM_ID
 482|                               , F.DOM_EXP
 483|                               , F.FCST_TYPE
 484|                               , F.INCOTERMS
 485|                               , F.MEASURE
 486|                               , F.PLANT_SITE_ID
 487|                               , F.YYYYMMDD
 488|                               , F.QTY
 489|                               , F.CREATED_BY
 490|                               , F.CREATION_DATE
 491|                               , F.LAST_UPDATED_BY
 492|                               , F.LAST_UPDATE_DATE
 493|                               , F.ATTRIBUTE1
 494|                               , F.ATTRIBUTE2
 495|                               , F.ATTRIBUTE3
 496|                               , F.ATTRIBUTE4
 497|                               , F.ATTRIBUTE5
 498|                               , F.ATTRIBUTE6
 499|                               , F.ATTRIBUTE7
 500|                               , F.ATTRIBUTE8
 501|                               , F.ATTRIBUTE9
 502|                               , F.ATTRIBUTE10
 503|                            FROM DM_PLN_MKT_FCST     F
 504|                               , SCM_MST_SITE_ITEM   T2   /* 20230410 JHS [E20230403-000148] */
 505|                           WHERE F.DIVISION_ID  = T2.DIVISION_ID
 506|                             AND F.PROJECT_CODE = T2.PROJECT_CODE
 507|                             AND F.SCM_SITE_ID  = T2.SCM_SITE_ID
 508|                             AND F.ITEM_ID      = T2.ITEM_ID
 509|                             AND T2.VALID_YN    = 'Y'
 510|                             AND F.DIVISION_ID  = V_DIVISION_ID
 511|                             AND F.YYYYMMDD    >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7*54, 'YYYYMMDD') /* 최근 1년치 */
 512|                             AND F.MEASURE IN ('CUST_FCST_EDI_ORG', 'Immidiate[Org.]', 'Planning_Forecast[Org.]', 'Commercial_Agreement[Org.]', 'Firm_Temp[Org.]', 'Manumacturing_Material_Temp[Org.]', 'Material_Temp[Org.]', 'Backorder[Org.]')
 513|                        ) A;
 514|             END;
 515|             DBMS_OUTPUT.PUT_LINE('3');
 516|             BEGIN
 517|                 INSERT INTO DM_PLN_MKT_FCST_RESULT_C
 518|                      ( DIVISION_ID
 519|                      , VERSION_NO
 520|                      , CUTOFF_TYPE
 521|                      , CUTOFF_YYYYMMDD
 522|                      , PROJECT_CODE
 523|                      , SCM_SITE_ID
 524|                      , ITEM_ID
 525|                      , DOM_EXP
 526|                      , FCST_TYPE
 527|                      , INCOTERMS
 528|                      , MEASURE
 529|                      , PLANT_SITE_ID
 530|                      , YYYYMMDD
 531|                      , QTY
 532|                      , CREATED_BY
 533|                      , CREATION_DATE
 534|                      , LAST_UPDATED_BY
 535|                      , LAST_UPDATE_DATE
 536|                      , ATTRIBUTE1
 537|                      , ATTRIBUTE2
 538|                      , ATTRIBUTE3
 539|                      , ATTRIBUTE4
 540|                      , ATTRIBUTE5
 541|                      , ATTRIBUTE6
 542|                      , ATTRIBUTE7
 543|                      , ATTRIBUTE8
 544|                      , ATTRIBUTE9
 545|                      , ATTRIBUTE10
 546|                      , CELL_PROD_SITE_ID )   /* [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 */
 547|                 SELECT V_DIVISION_ID
 548|                      , V_VER_RETURN_NO
 549|                      , V_VER_TYPE
 550|                      , TO_CHAR(SYSDATE, 'YYYYMMDD')
 551|                      , A.PROJECT_CODE
 552|                      , A.SCM_SITE_ID
 553|                      , A.ITEM_ID
 554|                      , A.DOM_EXP
 555|                      , A.FCST_TYPE
 556|                      , A.INCOTERMS
 557|                      , A.MEASURE
 558|                      , A.PLANT_SITE_ID
 559|                      , A.YYYYMMDD
 560|                      , A.QTY
 561|                      , A.CREATED_BY
 562|                      , A.CREATION_DATE
 563|                      , A.LAST_UPDATED_BY
 564|                     -- , A.LAST_UPDATE_DATE
 565|                      , SYSDATE
 566|                      , A.ATTRIBUTE1
 567|                      , A.ATTRIBUTE2
 568|                      , A.ATTRIBUTE3
 569|                      , A.ATTRIBUTE4
 570|                      , A.ATTRIBUTE5
 571|                      , A.ATTRIBUTE6
 572|                      , A.ATTRIBUTE7
 573|                      , A.ATTRIBUTE8
 574|                      , A.ATTRIBUTE9
 575|                      , A.ATTRIBUTE10
 576|                      , A.CELL_PROD_SITE_ID   /* [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 */
 577|                   FROM ( SELECT DIVISION_ID
 578|                               , PROJECT_CODE
 579|                               , SCM_SITE_ID
 580|                               , ITEM_ID
 581|                               , DOM_EXP
 582|                               , FCST_TYPE
 583|                               , INCOTERMS
 584|                               , MEASURE
 585|                               , PLANT_SITE_ID
 586|                               , YYYYMMDD
 587|                               , QTY
 588|                               , CREATED_BY
 589|                               , CREATION_DATE
 590|                               , LAST_UPDATED_BY
 591|                               , LAST_UPDATE_DATE
 592|                               , ATTRIBUTE1
 593|                               , ATTRIBUTE2
 594|                               , ATTRIBUTE3
 595|                               , ATTRIBUTE4
 596|                               , ATTRIBUTE5
 597|                               , ATTRIBUTE6
 598|                               , ATTRIBUTE7
 599|                               , ATTRIBUTE8
 600|                               , ATTRIBUTE9
 601|                               , ATTRIBUTE10
 602|                               , CELL_PROD_SITE_ID   /* [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 */
 603|                            FROM DM_PLN_MKT_FCST_RESULT
 604|                           WHERE DIVISION_ID = V_DIVISION_ID
 605|                             AND YYYYMMDD  <  TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')    /* [2018-03-28][추가][금주 월요일 이전] */
 606|                             AND YYYYMMDD  >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7*54, 'YYYYMMDD') /* 최근 1년치 */
 607|                        ) A;
 608|             END;
 609| 
 610|         END;
 611| 
 612|         BEGIN
 613|             /*----------------------------------------------------------------------------------------------------------
 614|               [PJ2025-50188]  DM_PLN_CFM_MKT_DEMAND_PLAN CUTOFF  (START)
 615|               ----------------------------------------------------------------------------------------------------------*/
 616|             DELETE
 617|               FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C
 618|              WHERE DIVISION_ID     = V_DIVISION_ID
 619|                AND VERSION_NO      = V_VER_RETURN_NO
 620|                AND CUTOFF_TYPE     = V_VER_TYPE
 621|                AND CUTOFF_YYYYMMDD = TO_CHAR(SYSDATE, 'YYYYMMDD');
 622| 
 623|             INSERT INTO DM_PLN_CFM_MKT_DEMAND_PLAN_C
 624|                  ( DIVISION_ID
 625|                  , VERSION_NO
 626|                  , CUTOFF_TYPE
 627|                  , CUTOFF_YYYYMMDD
 628|                  , PROJECT_CODE
 629|                  , END_CUSTOMER
 630|                  , SCM_SITE_ID
 631|                  , ITEM_ID
 632|                  , DOM_EXP
 633|                  , FCST_TYPE
 634|                  , INCOTERMS
 635|                  , MEASURE
 636|                  , PLANT_SITE_ID
 637|                  , CELL_PROD_SITE_ID
 638|                  , YYYYMMDD
 639|                  , QTY
 640|                  , CREATED_BY
 641|                  , CREATION_DATE
 642|                  , LAST_UPDATED_BY
 643|                  , LAST_UPDATE_DATE
 644|                  , ATTRIBUTE1        /* [E20260107-001651]_ATTRIBUTE 영역 추가 */
 645|                  , ATTRIBUTE2
 646|                  , ATTRIBUTE3
 647|                  , ATTRIBUTE4
 648|                  , ATTRIBUTE5
 649|                  , ATTRIBUTE6
 650|                  , ATTRIBUTE7
 651|                  , ATTRIBUTE8
 652|                  , ATTRIBUTE9
 653|                  , ATTRIBUTE10 )
 654|             SELECT A.DIVISION_ID
 655|                  , V_VER_RETURN_NO
 656|                  , V_VER_TYPE
 657|                  , TO_CHAR(SYSDATE, 'YYYYMMDD')
 658|                  , A.PROJECT_CODE
 659|                  , A.END_CUSTOMER
 660|                  , A.SCM_SITE_ID
 661|                  , A.ITEM_ID
 662|                  , A.DOM_EXP
 663|                  , A.FCST_TYPE
 664|                  , A.INCOTERMS
 665|                  , A.MEASURE
 666|                  , A.PLANT_SITE_ID
 667|                  , A.CELL_PROD_SITE_ID
 668|                  , A.YYYYMMDD
 669|                  , A.QTY
 670|                  , A.CREATED_BY
 671|                  , A.CREATION_DATE
 672|                  , A.LAST_UPDATED_BY
 673|              --    , A.LAST_UPDATE_DATE
 674|                  , SYSDATE
 675|                  , A.ATTRIBUTE1        /* [E20260107-001651]_ATTRIBUTE 영역 추가 */
 676|                  , A.ATTRIBUTE2
 677|                  , A.ATTRIBUTE3
 678|                  , A.ATTRIBUTE4
 679|                  , A.ATTRIBUTE5
 680|                  , A.ATTRIBUTE6
 681|                  , A.ATTRIBUTE7
 682|                  , A.ATTRIBUTE8
 683|                  , A.ATTRIBUTE9
 684|                  , A.ATTRIBUTE10
 685|               FROM DM_PLN_CFM_MKT_DEMAND_PLAN   A
 686|                  , SCM_MST_SITE_ITEM            B
 687|              WHERE A.DIVISION_ID  = B.DIVISION_ID
 688|                AND A.PROJECT_CODE = B.PROJECT_CODE
 689|                /* 원본: A.END_CUSTOMER = CASE WHEN A.DIVISION_ID='40' THEN B.PROJECT_CODE ELSE '' END (중요: PROJECT_CODE와 END_CUSTOMER)
 690|                   Oracle 은 ''=NULL 이므로 ELSE '' 를 그대로 두면 비40 매칭이 소실됨 → §3.4/H-4 로 END_CUSTOMER 공백은 RTRIM IS NULL 로 변환 */
 691|                AND ( ( A.DIVISION_ID = '40' AND A.END_CUSTOMER = B.PROJECT_CODE )
 692|                   OR ( A.DIVISION_ID <> '40' AND RTRIM(A.END_CUSTOMER) IS NULL ) )
 693|                AND A.SCM_SITE_ID  = B.SCM_SITE_ID
 694|                AND A.ITEM_ID      = B.ITEM_ID
 695|                AND B.VALID_YN     = 'Y'
 696|                AND A.DIVISION_ID  = V_DIVISION_ID
 697|                AND A.YYYYMMDD    >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD');
 698|             /*----------------------------------------------------------------------------------------------------------
 699|               [PJ2025-50188] DM_PLN_CFM_MKT_DEMAND_PLAN CUTOFF (END)
 700|               ----------------------------------------------------------------------------------------------------------*/
 701|         END;
 702| 
 703|         /*--------------------------------------------------------------------------------------------------------------
 704|           [PJ2025-50188] 기준수요 기반 CUTOFF 기능 추가 END
 705|           --------------------------------------------------------------------------------------------------------------
 706|           20180528 KHSONG DW I/F 테이블 생성 Procedure 호출 추가
 707|           EXEC [dbo].PR_DM_TO_XIF_DM_PLN_MKT_FCST_C @p_division_id, @v_ver_return_no
 708|           --------------------------------------------------------------------------------------------------------------*/
 709|         COMMIT;   /* MSSQL COMMIT TRAN */
 710|     /*================================================================================================================
 711|       300 : ERROR TRAP
 712|       ================================================================================================================*/
