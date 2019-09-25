package promember;

import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;

public class SMTPAuthenticator extends Authenticator {
	protected PasswordAuthentication getPasswordAuthentication() {
		String id = "getinzng";
		String pass = "wuambxizhghmmtca";
		return new PasswordAuthentication(id, pass);
	}
}