package promember;

import java.sql.Timestamp;

public class MemberDto {
	private String email;
	private String pwd;
	private String username;
	private String address;
	private String detailAddress;
	private String phone;
	private String photo;
	private int postcode;
	private int step;
	private Timestamp reg_date;

	public MemberDto() {
	}

	public MemberDto(String email, String pwd, String username, String address, String detailAddress, String phone, int postcode,
			Timestamp reg_date) {
		this.detailAddress = detailAddress;
		this.email = email;
		this.pwd = pwd;
		this.username = username;
		this.address = address;
		this.phone = phone;
		this.postcode = postcode;
		this.reg_date = reg_date;
	}
	public MemberDto(String email, String pwd, String username, String address, 
			String detailAddress, String phone, String photo,
			int postcode, int step,
			Timestamp reg_date) {
		this.detailAddress = detailAddress;
		this.step = step;
		this.email = email;
		this.pwd = pwd;
		this.username = username;
		this.address = address;
		this.phone = phone;
		this.postcode = postcode;
		this.reg_date = reg_date;
		this.photo = photo;
	}

	public String getPhoto() {
		return photo;
	}

	public void setPhoto(String photo) {
		this.photo = photo;
	}

	public String getDetailAddress() {
		return detailAddress;
	}

	public void setDetailAddress(String detailAddress) {
		this.detailAddress = detailAddress;
	}

	public String getEmail() {
		return this.email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getPwd() {
		return this.pwd;
	}

	public void setPwd(String pwd) {
		this.pwd = pwd;
	}

	public String getUsername() {
		return this.username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getAddress() {
		return this.address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getPhone() {
		return this.phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public int getPostcode() {
		return this.postcode;
	}

	public void setPostcode(int postcode) {
		this.postcode = postcode;
	}

	public int getStep() {
		return this.step;
	}

	public void setStep(int step) {
		this.step = step;
	}

	public Timestamp getReg_date() {
		return this.reg_date;
	}

	public void setReg_date(Timestamp reg_date) {
		this.reg_date = reg_date;
	}
}