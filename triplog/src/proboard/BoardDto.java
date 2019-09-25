package proboard;

import java.sql.Timestamp;

public class BoardDto {
	private int num;
	private int count;
	private int pos;
	private int depth;
	private String title;
	private String content;
	private String username;
	private String cate;
	private String ip;
	private String email;
	private String imgPaths;
	private String filePaths;
	private Timestamp reg_date;
	private Timestamp change_date;

	public BoardDto() {}

	public BoardDto(int num, int count, int pos, int depth, String cate, String title, String content, String username,
			Timestamp reg_date) {
		this.cate = cate;
		this.num = num;
		this.count = count;
		this.pos = pos;
		this.depth = depth;
		this.title = title;
		this.content = content;
		this.username = username;
		this.reg_date = reg_date;
	}

	public BoardDto(String cate, String title, String content, 
			String username, String ip, String imgPaths, String filePaths,
			Timestamp reg_date) {
		this.imgPaths = imgPaths;
		this.filePaths = filePaths;
		this.ip = ip;
		this.cate = cate;
		this.title = title;
		this.content = content;
		this.username = username;
		this.reg_date = reg_date;
	}
	public String getImgPaths() {
		return imgPaths;
	}

	public void setImgPaths(String imgPaths) {
		this.imgPaths = imgPaths;
	}

	public String getFilePaths() {
		return filePaths;
	}

	public void setFilePaths(String filePaths) {
		this.filePaths = filePaths;
	}

	public Timestamp getChange_date() {
		return change_date;
	}
	
	public void setChange_date(Timestamp change_date) {
		this.change_date = change_date;
	}

	public String getEmail() {
		return email;
	}
	
	public void setEmail(String email) {
		this.email = email;
	}
	public String getIp() {
		return this.ip;
	}

	public void setIp(String ip) {
		this.ip = ip;
	}

	public String getCate() {
		return this.cate;
	}

	public void setCate(String cate) {
		this.cate = cate;
	}

	public int getNum() {
		return this.num;
	}

	public void setNum(int num) {
		this.num = num;
	}

	public int getCount() {
		return this.count;
	}

	public void setCount(int count) {
		this.count = count;
	}

	public int getPos() {
		return this.pos;
	}

	public void setPos(int pos) {
		this.pos = pos;
	}

	public int getDepth() {
		return this.depth;
	}

	public void setDepth(int depth) {
		this.depth = depth;
	}

	public String getTitle() {
		return this.title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getContent() {
		return this.content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public String getUsername() {
		return this.username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public Timestamp getReg_date() {
		return this.reg_date;
	}

	public void setReg_date(Timestamp reg_date) {
		this.reg_date = reg_date;
	}
}