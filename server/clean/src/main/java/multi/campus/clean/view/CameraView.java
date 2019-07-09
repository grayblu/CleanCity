package multi.campus.clean.view;

import java.util.Map;
import java.util.Observable;
import java.util.Observer;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.LinkedBlockingQueue;

import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import multi.campus.clean.broker.MjpegBroker;

@Component("camera")
@Scope("request")
public class CameraView extends MjpegView implements Observer {
	
	@Autowired
	MjpegBroker broker;

	BlockingQueue<byte[]> queue = new LinkedBlockingQueue<>(5);

	int deviceId;

	@Override
	protected void init(Map<String, Object> model, HttpServletResponse response) throws Exception {
		super.init(model, response);
		deviceId = (int) model.get("deviceId");
		// 브로커에 현재 객체를 등록한다
		broker.addObserver(deviceId, this);
	}

	@Override
	protected byte[] getImage() throws Exception {
		// 블락킹 큐에서 이미지를 추출해서 리턴
		return queue.take();
	}

	@Override
	public void update(Observable o, Object image) {
		try {
			// 블락킹 큐에 이미지를 추가
			queue.put((byte[]) image);
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
	}

	@Override
	public void cleanup() throws Exception {
		super.cleanup();
		queue.clear();
		// 브로커로부터 현재 객체를 제거한다
		broker.deleteObserver(deviceId, this);
	}

}
