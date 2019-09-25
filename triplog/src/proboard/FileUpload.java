package proboard;

import java.io.File;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

/*
 * 파일업로드를 처리하는 서블릿인 FileUpload 클래스
 * 라이브러리에서 제공하는 DiskFileItemFactory클래스를 이용해
 * 저장 위치와 업로드 가능한 최대 파일 크기를 설정합니다.
 * 그리고 ServletFileUpload클래스를 이용해 파일 업로드 창에서 업로드된 파일과 
 * 매개변구에 대한 정보를 가져와 파일을 업로드 하고 매개변수값을 출력합니다.
 */
@WebServlet("/upload.do")
public class FileUpload extends HttpServlet {

	private static final long serialVersionUID = -7302572258822388072L;

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		doHanble(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		doHanble(req, resp);
	}

	protected void doHanble(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		//클라이언트가 요청한 request객체의 정보 한글 처리
		String encoding ="utf-8";
		request.setCharacterEncoding(encoding);
		
		File currentDirPath = new File("C:\\file_repo");
		
		//업로드할 파일 데이터를 임시로 저장할 객체 메모리 생성
		DiskFileItemFactory factory = new DiskFileItemFactory();
		
		//파일업로드시 사용할 임시 메모리 최대 크기
		factory.setSizeThreshold(1024*1024*1);
		
		//임시 메모리에 파일 업로드시 지정한 1메가 바이트 크기를 넘길경우
		//실제 업로드될 파일 경로를 지정함
		factory.setRepository(currentDirPath);
		
		//참고
		//DiskFileItemFactory클래스는 업로드 파일의 크기가 지정한 크기를 넘기기 전까지는
		//업로드한 파일 데이터를 메모리에 저장하고
		//지정한 크기를 넘길 경우 임시 디렉터리 파일로 저장한다
		
		//파일을 업로드할 메모리를 생성자 쪽으로 전달받아 저장한!! 파일 업로드를 처리할 객체 생성
		ServletFileUpload upload = new ServletFileUpload(factory);
		
		try {
			//업로드할 파일에 대한 요청 정보를 가지고 있는 request객체를 parseRequest()메서드 호출 시
			//인자로 전달하면 request객체에 저장되어 있는 업로드할 파일의 정보들을 피싱해서
			//DiskFileItem객체에 저장한 후
			//DiskFileItem객체를 ArrayList에 추가하여 반환 받음
			List<FileItem> items = upload.parseRequest(request);
			
			//arrtlist 크기만큼 (DiskFileItem객체(업로드할 아이템 하나의 정보)의 갯수 만큼)반복
			for(int i=0; i<items.size(); i++){
				//ArrayList 가변 배열에서.. DiskFileItem객체(업로드할 아이템 하나의 정보)를 얻는다
				FileItem fileItem = items.get(i);
				
				//DiskFileItem객체(업로드 할 아이템 하나의 정보)가 파일 아이템이 아닐 경우
				if(fileItem.isFormField()){
					//업로드 진행X
					System.out.println(fileItem.getFieldName()+" = "+fileItem.getString(encoding));
				}else{
					//DiskFileItem객체가 파일 아이템일 경우
					//업로드 진행!
					System.out.println("파라미터  명: "+fileItem.getFieldName());
					System.out.println("파일 명: "+fileItem.getName());
					System.out.println("파일크기: "+fileItem.getSize()+"bytes");
					
					if(fileItem.getSize()>0){
						//업로드할 파일 명을 얻어 파일명의 뒤에서부터 \\문자열이 들어있는지(lastIndexOf())
						//인덱스 위치를 알려줌. 없으면 1반환
						int idx = fileItem.getName().lastIndexOf("\\");
						
						System.out.println(idx);
						if(idx == -1){
							idx = fileItem.getName().lastIndexOf("/");
							System.out.println("안녕 : "+idx);
						}
						
						//업로드할 파일 명 얻기
						String fileName = fileItem.getName().substring(idx+1);
						
						//업로드할 파일 경로+ 파일명에 대한 객체 생성
						File uploadFile = new File(currentDirPath + "\\"+fileName);
						
						//실제 파일 업로드
						fileItem.write(uploadFile);
					}
				}
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}

}
