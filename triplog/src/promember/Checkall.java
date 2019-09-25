package promember;

import java.io.IOException;
import java.sql.Timestamp;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet({"/checkall/*"})
public class Checkall extends HttpServlet {
	private static final long serialVersionUID = 1L;
	MemberDao dao;

	public void init() throws ServletException {
		this.dao = new MemberDao();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		this.doHandle(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		this.doHandle(request, response);
	}

	protected void doHandle(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("utf-8");
		response.setContentType("text/html; charset=utf-8");
		
		String path = request.getContextPath();
		String nextPage = path + "/index.jsp";
		String action = request.getPathInfo();
		System.out.println(action);
		
		String email;
		String username;
		String referer;
		String pwd;
		if (action.equals("/usernameCheck")) {
			username = request.getParameter("username");
			response.getWriter().print(this.dao.tableCheck("username", username));
			
		} else if (action.equals("/sendEmail")) {
			email = request.getParameter("email");
			boolean val = this.dao.tableCheck("email", email);//있으면 true
			if (val) {
				response.getWriter().print("중복");
			} else {
				response.getWriter().print(this.dao.sendMail(email, "메일 인증"));
			}
		} else if (action.equals("/addMembers")) {
				email = request.getParameter("email");
				pwd = request.getParameter("pwd");
				username = request.getParameter("username");
				String phone = request.getParameter("phone");
				String address = request.getParameter("address");
				String detailAddress = request.getParameter("detailAddress");
				
				int postcode;
				if ( request.getParameter("postcode") == null || request.getParameter("postcode").equals("") ) {
					postcode = 0;
				} else {
					postcode = Integer.parseInt(request.getParameter("postcode"));
				}
				
				System.out.println(postcode);
				MemberDto dto = new MemberDto(email, pwd, username, address, detailAddress, phone, postcode,
						new Timestamp(System.currentTimeMillis()));
				this.dao.addMember(dto);
				nextPage = path + "/member/hello.jsp";
				response.sendRedirect(nextPage);
				
			} else if (action.equals("/login")) {
				
				email = request.getParameter("email");
				pwd = request.getParameter("pwd");
				
				username = this.dao.loginCheck(email, pwd); //username null이면 어쩔?

				referer = request.getParameter("referer");
				if ( username == null || username.equals("")) {
					nextPage = "/member/login.jsp";
					request.setAttribute("login", "no");
					request.setAttribute("re", referer);
				
					RequestDispatcher dispatcher = request.getRequestDispatcher(nextPage);
					dispatcher.forward(request, response);
					
				} else {
					System.out.println("이전 페이지 경로: "+referer);
				
					if (referer == null || referer.contains("/login") || referer.contains("/member/hello.jsp")) {
						nextPage = path+"/index.jsp";
				
					}else{
						nextPage = referer;
					}
					request.getSession().setAttribute("login", username);
					request.getSession().setAttribute("login_e", email);
					response.sendRedirect(nextPage);
				}
			} else if (action.equals("/logout")) {
				request.getSession().removeAttribute("login");
				request.getSession().removeAttribute("login_e");
				response.sendRedirect(nextPage);
				
			}else if(action.equals("/mypage/profile")){
				email = (String) request.getSession().getAttribute("login_e");
				request.setAttribute("dto", dao.getLine("email", email));
				
				nextPage = "/member/profile.jsp";
				RequestDispatcher dispatcher = request.getRequestDispatcher(nextPage);
				dispatcher.forward(request, response);
			}else if(action.equals("/mypage/recheck")){
				pwd = request.getParameter("pwd");
				username = (String) request.getSession().getAttribute("login");
				
				MemberDto dto = dao.getLine("username", username);
				if(pwd.equals(dto.getPwd())){
					if(request.getParameter("f").equals("bye")){
						dao.deleteMember(dto.getEmail());
						
						request.getSession().removeAttribute("login");
						request.getSession().removeAttribute("login_e");
						response.sendRedirect(path+"/index.jsp");
					}else{
						request.setAttribute("check", 1);
						request.setAttribute("dto", dto);
						
						nextPage = "/member/modify.jsp";
						RequestDispatcher dispatcher = request.getRequestDispatcher(nextPage);
						dispatcher.forward(request, response);
					}
				}else{
					referer = request.getHeader("referer");
					if(referer.contains("?recheck=0")) response.sendRedirect(referer);
					else response.sendRedirect(referer+"?recheck=0");
				}
			}else if(action.equals("/mypage/uploadInfo")){
				email = request.getParameter("email");
				username = request.getParameter("username");
				String address = request.getParameter("address");
				String detailAddress = request.getParameter("detailAddress");
				String phone = request.getParameter("phone");
				pwd = request.getParameter("pwd");
				int postcode;
				if(request.getParameter("postcode")==null || request.getParameter("postcode").equals("")){
					postcode=0;
				}else{
					postcode = Integer.parseInt(request.getParameter("postcode"));
				}
				
				MemberDto dto = new MemberDto();
				dto.setPostcode(postcode);
				dto.setPwd(pwd);
				dto.setEmail(email);
				dto.setUsername(username);
				dto.setAddress(address);
				dto.setDetailAddress(detailAddress);
				dto.setPhone(phone);
				
				dao.updateMember(dto);
				
				request.getSession().setAttribute("login", username);
				
				nextPage = path+"/checkall/mypage/profile";
				response.sendRedirect(nextPage);
			}
		}

	
}