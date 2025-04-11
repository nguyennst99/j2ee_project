package humber.ca.project.utils;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.util.Properties;

public class EmailUtil {
    private static final String PROPERTIES_FILE = "/mail.properties";
    private static Properties mailProperties;
    private static String fromAddress;
    private static String fromName;
    private static boolean propertiesLoaded = false;

    static {
        mailProperties = new Properties();
        try {
            InputStream input = EmailUtil.class.getResourceAsStream(PROPERTIES_FILE);
            if (input == null) {
                System.out.println("Failed to load mail properties file");
            } else {
                mailProperties.load(input);
                fromAddress = mailProperties.getProperty("mail.from.address");
                fromName = mailProperties.getProperty("mail.from.name", "J2EEGroup2");

                if (mailProperties.getProperty("mail.smtp.host") == null ||
                        mailProperties.getProperty("mail.smtp.user") == null ||
                        mailProperties.getProperty("mail.smtp.password") == null) {
                    System.out.println("Missing mail properties");
                } else {
                    propertiesLoaded = true;
                }
            }
        } catch (IOException e) {
            System.out.println("IOException loading mail properties");
        }
    }

    public static boolean sendMail(String toMail, String subject, String htmlBody) {
        if (!propertiesLoaded || fromAddress == null) {
            System.out.println("Mail properties not loaded correctly");
            return false;
        }

        final String username = mailProperties.getProperty("mail.smtp.user");
        final String password = mailProperties.getProperty("mail.smtp.password");

        Authenticator authenticator = null;
        if (mailProperties.getProperty("mail.smtp.auth").equals("true")) {
            authenticator = new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(username, password);
                }
            };
        }

        Session session = Session.getInstance(mailProperties, authenticator);

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromAddress, fromName));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toMail));
            message.setSubject(subject);
            message.setContent(htmlBody, "text/html; charset=utf-8");

            Transport.send(message);

            System.out.println("Email sent successfully to " + toMail + " with subject " + subject);
            return true;
        } catch (MessagingException e) {
            System.out.println("Messaging exception sending email");
        } catch (UnsupportedEncodingException e) {
            System.out.println("Unsupported encoding sending email");
        }
        return false;
    }
}
