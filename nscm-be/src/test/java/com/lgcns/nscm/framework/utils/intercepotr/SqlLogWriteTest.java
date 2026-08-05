package com.lgcns.nscm.framework.interceptor;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;

import javax.sql.DataSource;

import org.junit.jupiter.api.Test;
import org.mockito.Mockito;

class SqlLogWriterTest {

    private SqlLogRecord record(String id) {
        return new SqlLogRecord(id, "SELECT", "select 1", 1,
                LocalDateTime.of(2026, 7, 14, 0, 0), "GUEST", null, 1, null);
    }

    @Test
    void offer_dropsOldest_whenQueueFull() {
        DataSource ds = Mockito.mock(DataSource.class);
        // capacity 2
        SqlLogWriter writer = new SqlLogWriter(ds, 2, 500, 1000);

        writer.offer(record("a"));
        writer.offer(record("b"));
        writer.offer(record("c")); // "a" 가 밀려남

        assertThat(writer.queueSize()).isEqualTo(2);
        assertThat(writer.getDroppedCount()).isEqualTo(1);
    }

    @Test
    void flush_insertsBatch_andCommits() throws Exception {
        DataSource ds = Mockito.mock(DataSource.class);
        Connection conn = Mockito.mock(Connection.class);
        PreparedStatement ps = Mockito.mock(PreparedStatement.class);
        when(ds.getConnection()).thenReturn(conn);
        when(conn.prepareStatement(SqlLogWriter.INSERT_SQL)).thenReturn(ps);

        SqlLogWriter writer = new SqlLogWriter(ds, 100, 500, 1000);
        writer.flush(List.of(record("a"), record("b")));

        verify(ps, times(2)).addBatch();
        verify(ps).executeBatch();
        verify(conn).commit();
    }

    @Test
    void flush_swallowsException_whenConnectionFails() throws Exception {
        DataSource ds = Mockito.mock(DataSource.class);
        when(ds.getConnection()).thenThrow(new SQLException("pool exhausted"));

        SqlLogWriter writer = new SqlLogWriter(ds, 100, 500, 1000);
        // 예외가 전파되지 않아야 한다
        writer.flush(List.of(record("a")));
    }

    @Test
    void close_flushesRemainingQueue() throws Exception {
        DataSource ds = Mockito.mock(DataSource.class);
        Connection conn = Mockito.mock(Connection.class);
        PreparedStatement ps = Mockito.mock(PreparedStatement.class);
        when(ds.getConnection()).thenReturn(conn);
        when(conn.prepareStatement(SqlLogWriter.INSERT_SQL)).thenReturn(ps);

        // 워커를 start 하지 않고 큐에 직접 적재 → close 가 남은 것을 flush 하는지 검증
        SqlLogWriter writer = new SqlLogWriter(ds, 100, 500, 1000);
        writer.offer(record("a"));
        writer.offer(record("b"));

        writer.close();

        // 남은 2건이 insert 되어야 한다
        verify(ps, times(2)).addBatch();
        verify(ps).executeBatch();
        assertThat(writer.queueSize()).isZero();
    }
}
