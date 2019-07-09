package multi.campus.clean.view;

import java.io.OutputStream;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.view.AbstractView;

abstract public class MjpegView extends AbstractView {
	protected void setHeader(HttpServletResponse response) {
		response.setHeader("Cache-Control", "no-cache, private");
		response.setContentType("multipart/x-mixed-replace;boundary=--boundary");
	}

	public static final String NL = "\r\n";
	public static final String BOUNDARY = "--boundary";
	public static final String HEAD = BOUNDARY + NL + "Content-Type: image/jpeg" + NL + "Content-Length: ";

	public void sendImage(OutputStream os, byte[] image) throws Exception {
		int size = image.length;
		os.write((HEAD + size + NL + NL).getBytes());
		os.write(image);
		os.flush();
		os.write((NL + NL).getBytes());
	}

	protected void init(Map<String, Object> model, HttpServletResponse response) throws Exception {

	}

	protected void cleanup() throws Exception {

	}

	abstract protected byte[] getImage() throws Exception;

	@Override
	protected void renderMergedOutputModel(Map<String, Object> model, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		setHeader(response);
		init(model, response);
		OutputStream os = response.getOutputStream();
		
		try {
			System.out.println("이미지 수신 시작");
			while (true) {
				byte[] image = getImage();
				
				sendImage(os, image);
			}
		} catch (Exception e) {
			cleanup();
		}
	}

}
