package com.lgcns.nscm.framework.handler;

import static com.lgcns.nscm.framework.base.BaseConstants.DEFAULT_DATA_RESULT;

import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.sql.Blob;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import org.springframework.stereotype.Service;

import com.lgcns.nscm.framework.base.BaseService;
import com.lgcns.nscm.framework.exception.BusinessException;
import com.lgcns.nscm.framework.property.CommonProperties;
import com.lgcns.nscm.framework.utils.NullUtils;

import jakarta.activation.DataSource;
import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.Multipart;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeBodyPart;
import jakarta.mail.internet.MimeMessage;
import jakarta.mail.internet.MimeMultipart;
import jakarta.mail.internet.MimeUtility;
import jakarta.mail.util.ByteArrayDataSource;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequiredArgsConstructor
@Service
public class MailHandler extends BaseService {

    private final CommonProperties commonProperties;


    public void sendEmail(String fromUser , String toUser, String ccUser, String bccUser, String subject, String content, String fileId) {


        Properties props = new Properties();
        props.put("mail.smtp.auth", commonProperties.getMail().getSmtpAuth());
        props.put("mail.smtp.starttls.enable", commonProperties.getMail().getSmtpStarttlsEnable());
        props.put("mail.smtp.host", commonProperties.getMail().getHost());
        props.put("mail.smtp.port", commonProperties.getMail().getPort());

        // create the Session object
        Session session = Session.getInstance(props,
                new Authenticator() {
                    @Override
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication(commonProperties.getMail().getUser(), commonProperties.getMail().getPassword());
                    }
                });

        try {
            // create a MimeMessage object
            Message message = new MimeMessage(session);

            // set From email field
            message.setFrom(new InternetAddress(fromUser));
            // TO: 수신자
            if(NullUtils.isNone(toUser)) throw new BusinessException("Not exist toUser.");
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toUser));
            // CC: 참조
            if(!NullUtils.isNone(ccUser)) message.setRecipients(Message.RecipientType.CC, InternetAddress.parse(ccUser));
            // BCC: 숨은 참조
            if(!NullUtils.isNone(bccUser)) message.setRecipients(Message.RecipientType.BCC, InternetAddress.parse(bccUser));

            // set email subject field
            message.setSubject(MimeUtility.encodeText(subject, "UTF-8", "B"));


            // set the content of the email message
            MimeBodyPart textPart = new MimeBodyPart();
            textPart.setContent(content, "text/html; charset=utf-8");

            MimeBodyPart filePart = new MimeBodyPart();
            if(!NullUtils.isNone(fileId)) {
            	List<Map<String, Object>> fileList = getFileResource(fileId);
				for(Map<String, Object> fileMap:fileList) {
					filePart.setDataHandler(new jakarta.activation.DataHandler((DataSource) fileMap.get("datasource")));
					// 한글 파일명 깨짐 방지 인코딩
					filePart.setFileName(MimeUtility.encodeText((String) fileMap.get("fileName"), "UTF-8", "B"));
				}
            }

            // send the email message
            Multipart multipart = new MimeMultipart();
            if(!NullUtils.isNone(textPart)) multipart.addBodyPart(textPart);
            if(!NullUtils.isNone(filePart)) multipart.addBodyPart(filePart);
            message.setContent(multipart);
            Transport.send(message);
            log.info("email Send Seccess.");

        } catch (MessagingException e) {
            throw new RuntimeException(e);
        } catch (UnsupportedEncodingException e) {
			// 인코딩 에러
        	 throw new RuntimeException(e);
		}
    }

    // 파일정보를 가져오는 함수
    private List<Map<String, Object>> getFileResource(String fileId){
    	List fileList = new ArrayList<HashMap<String, Object>>();

        try  {
        	//	파일정보 조회
        	Map fileMap = new HashMap<String, Object>();
        	fileMap.put("fileId", fileId);
        	List<HashMap<String, Object>> resultList = (List<HashMap<String, Object>>) selectList("admin.file.selectFileInfo", fileMap).get(DEFAULT_DATA_RESULT);



        	// 결과값
            for(HashMap<String, Object> fileObject:resultList) {
                String fileName = (String) fileObject.get("ATCH_FILE_SAVE_NM");
                String mimeType = (String) "application/"+fileObject.get("ATCH_FILE_EFNM_NM"); // ex) application/pdf
                Object blobObj = fileObject.get("ATCH_FILE_CTN");
                if (blobObj instanceof Blob) {
                	Map resultMap = new HashMap<String, Object>();
                	Blob blob = (Blob) blobObj;
                	try (InputStream is = blob.getBinaryStream()) {
                        if (is != null) {
                        	ByteArrayDataSource dataSource = new ByteArrayDataSource(is, mimeType);
                        	resultMap.put("fileName", fileName);
                        	resultMap.put("datasource", dataSource);
                        	fileList.add(resultMap);
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

    	return fileList;
    }

}
