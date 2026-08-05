PROCEDURE           "PR_SCM_SYS_LOG_BATCH"
(
    p_program_name   in varchar2,
    p_log_type       in varchar2,
    p_log_count      in number,
    p_log_message    in varchar2,
    p_description    in varchar2,
    p_event_date     in date     default sysdate,
    p_in_para_data   in varchar2 default null,
    p_sql_err_code   in varchar2 default null,
    p_sql_err_msg    in varchar2 default null,
    p_sql_backtrace  in varchar2 default null
)
IS
/*
 * Program ID   : PR_SCM_SYS_LOG_BATCH
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2026.03.03       jcnam     [PJ20264226] NextSCM Pilot 설계 및 개발
 */
    pragma autonomous_transaction;

    c_prog_name_len  constant pls_integer := 150;
    c_log_type_len   constant pls_integer := 30;
    c_log_msg_len    constant pls_integer := 1000;
    c_desc_len       constant pls_integer := 1000;
    c_in_para_len    constant pls_integer := 2000;
    c_err_code_len   constant pls_integer := 100;
    c_err_msg_len    constant pls_integer := 2000;
    c_backtrace_len  constant pls_integer := 4000;
    c_created_by_len constant pls_integer := 150;

    v_in_para_data varchar2(4000);
    v_sql_code     varchar2(100);
    v_sql_errmsg   varchar2(2000);
    v_backtrace    varchar2(4000);
    v_created_by   varchar2(150) := 'scm_batch';

begin

    -- 정상 흐름
    v_in_para_data := substr(p_in_para_data, 1, c_in_para_len);

    insert into scm_sys_log_batch
    (
        program_name,
        log_type,
        log_count,
        log_message,
        description,
        in_para_data,
        sql_err_code,
        sql_err_msg,
        sql_backtrace,
        event_date,
        creation_date,
        created_by,
        last_update_date,
        last_updated_by
    )
    values
    (
        substr(p_program_name, 1, c_prog_name_len),
        substr(p_log_type,     1, c_log_type_len),
        p_log_count,
        substr(p_log_message,  1, c_log_msg_len),
        substr(p_description,  1, c_desc_len),
        v_in_para_data,
        substr(p_sql_err_code, 1, c_err_code_len),
        substr(p_sql_err_msg,  1, c_err_msg_len),
        substr(p_sql_backtrace,1, c_backtrace_len),
        nvl(p_event_date, sysdate),
        sysdate,
        substr(v_created_by, 1, c_created_by_len),
        sysdate,
        substr(v_created_by, 1, c_created_by_len)
    );

    commit;

exception
    when others then
        rollback;

        -- 예외 시: 프로시저 입력값을 JSON으로 저장
        v_in_para_data :=
            json_object(
                'p_program_name'   value substr(p_program_name, 1, c_prog_name_len),
                'p_log_type'       value substr(p_log_type,     1, c_log_type_len),
                'p_log_count'      value p_log_count,
                'p_log_message'    value substr(p_log_message,  1, c_log_msg_len),
                'p_description'    value substr(p_description,  1, c_desc_len),
                'p_event_date'     value to_char(nvl(p_event_date, sysdate), 'yyyy-mm-dd hh24:mi:ss'),
                'p_in_para_data'   value substr(p_in_para_data, 1, c_in_para_len),
                'p_sql_err_code'   value substr(p_sql_err_code, 1, c_err_code_len),
                'p_sql_err_msg'    value substr(p_sql_err_msg,  1, c_err_msg_len),
                'p_sql_backtrace'  value substr(p_sql_backtrace,1, c_backtrace_len)
                returning varchar2(4000)
            );

        v_sql_code   := substr(to_char(sqlcode), 1, c_err_code_len);
        v_sql_errmsg := substr(sqlerrm,         1, c_err_msg_len);
        v_backtrace  := substr(dbms_utility.format_error_backtrace, 1, c_backtrace_len);

        insert into scm_sys_log_batch
        (
            program_name,
            log_type,
            log_count,
            log_message,
            description,
            in_para_data,
            sql_err_code,
            sql_err_msg,
            sql_backtrace,
            event_date,
            creation_date,
            created_by,
            last_update_date,
            last_updated_by
        )
        values
        (
            substr(p_program_name, 1, c_prog_name_len),
            'error',
            null,
            null,
            null,
            v_in_para_data,
            v_sql_code,
            v_sql_errmsg,
            v_backtrace,
            sysdate,
            sysdate,
            substr(v_created_by, 1, c_created_by_len),
            sysdate,
            substr(v_created_by, 1, c_created_by_len)
        );

        commit;

end pr_scm_sys_log_batch;