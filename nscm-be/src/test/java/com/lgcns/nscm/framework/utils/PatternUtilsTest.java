package com.lgcns.nscm.framework.utils;

import static org.assertj.core.api.Assertions.assertThat;

import java.util.regex.Pattern;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;

class PatternUtilsTest {

    @Nested
    @DisplayName("Wildcard Pattern 테스트")
    class WildcardTest {

        @Test
        @DisplayName("별표(*) 와일드카드가 정상적으로 매칭되어야 한다")
        void compileWildcardPattern_Asterisk() {
            // Given
            String wildcard = "test*.txt";
            Pattern pattern = PatternUtils.compileWildcardPattern(wildcard);

            // Then
            assertThat(PatternUtils.matches(pattern, "test123.txt")).isTrue();
            assertThat(PatternUtils.matches(pattern, "test_file.txt")).isTrue();
            assertThat(PatternUtils.matches(pattern, "testing.txt")).isTrue();
            assertThat(PatternUtils.matches(pattern, "other.txt")).isFalse();
        }

        @Test
        @DisplayName("물음표(?) 와일드카드가 한 글자에 매칭되어야 한다")
        void compileWildcardPattern_QuestionMark() {
            // Given
            String wildcard = "file?.dat";
            Pattern pattern = PatternUtils.compileWildcardPattern(wildcard);

            // Then
            assertThat(PatternUtils.matches(pattern, "file1.dat")).isTrue();
            assertThat(PatternUtils.matches(pattern, "fileA.dat")).isTrue();
            assertThat(PatternUtils.matches(pattern, "file12.dat")).isFalse();
        }

        @Test
        @DisplayName("세미콜론(;)으로 구분된 여러 패턴이 매칭되어야 한다")
        void compileWildcardPattern_Multiple() {
            // Given
            String wildcard = "*.java;*.class";
            Pattern pattern = PatternUtils.compileWildcardPattern(wildcard);

            // Then
            assertThat(PatternUtils.matches(pattern, "Test.java")).isTrue();
            assertThat(PatternUtils.matches(pattern, "Test.class")).isTrue();
            assertThat(PatternUtils.matches(pattern, "Test.txt")).isFalse();
        }
    }

    @Nested
    @DisplayName("Format Value 치환 테스트")
    class ReplaceFormatTest {

        @Test
        @DisplayName("${target} 형태의 포맷이 정상적으로 치환되어야 한다")
        void replaceFormatValue_Success() {
            // Given
            String format = "Hello, ${name}! Welcome to ${place}.";

            // When
            String result = PatternUtils.replaceFormatValue(format, "name", "Gemini");
            result = PatternUtils.replaceFormatValue(result, "place", "Seoul");

            // Then
            assertThat(result).isEqualTo("Hello, Gemini! Welcome to Seoul.");
        }

        @Test
        @DisplayName("일치하는 target이 없으면 원본을 유지해야 한다")
        void replaceFormatValue_NoMatch() {
            String format = "Data: ${value}";
            String result = PatternUtils.replaceFormatValue(format, "key", "123");
            assertThat(result).isEqualTo("Data: ${value}");
        }
    }

    @Nested
    @DisplayName("파일명 유효성 테스트")
    class FileNameTest {

    	@ParameterizedTest
    	@CsvSource(value = {
    	    "validFile.txt,true",
    	    "한글파일.jpg,true",
    	    "12345.dat,true",
    	    ".hidden,false",
    	    " spaceStart,false", // 이제 앞의 공백이 유지됩니다.
    	    "endWithDot.,false"
    	}, ignoreLeadingAndTrailingWhitespace = false) // 공백 유지 설정
    	@DisplayName("파일명 규칙이 정상 작동해야 한다")
        void isAcceptableFileName(String fileName, boolean expected) {
            assertThat(PatternUtils.isAcceptableFileName(fileName)).isEqualTo(expected);
        }
    }

    @Test
    @DisplayName("formatPattern은 숫자의 길이에 맞춰 포맷 문자열을 생성해야 한다")
    void formatPattern_Test() {
        // Given
        String format = "SEQ_";
        int value = 1000; // length is 4

        // When
        String result = PatternUtils.formatPattern(format, value);

        // Then
        assertThat(result).isEqualTo("SEQ_%04d");
    }
}
