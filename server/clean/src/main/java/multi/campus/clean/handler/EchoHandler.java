package multi.campus.clean.handler;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;

import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import com.google.gson.Gson;

import multi.campus.clean.domain.HandleMsg;

public class EchoHandler extends TextWebSocketHandler {
	Gson gson = new Gson();
	HashMap<String, WebSocketSession> map = new HashMap<>();
	WebSocketSession carSession;
	String carIp;

	public void sendMsgToCar(WebSocketSession session, String sendMsg) throws Exception {
		if (carSession != null && carSession.isOpen()) {
			System.out.println("차에게 다음 메시지를 보냄 > " + sendMsg);
			carSession.sendMessage(new TextMessage(sendMsg));
		} else {
			System.out.println("차에게 다음 메시지를 안!보냄 > " + sendMsg);
			carSession = null;
		}
	}
	
	public void checkWebSocket(ArrayList<String> removeList) throws Exception {
		Iterator<String> keys = map.keySet().iterator();
		while (keys.hasNext()) {
			String key = keys.next();
			WebSocketSession ws = map.get(key);

			// 연결되어 있는 브라우저 소켓
			if (!ws.isOpen()) {
				removeList.add(ws.getId());
			}
		}
	}
	
	public void sendToWebSocket(ArrayList<String> removeList, String sendMsg) throws Exception {
		System.out.println("브라우저로 다음 메시지를 보냄 > " + sendMsg);
		
		Iterator<String> keys = map.keySet().iterator();
		while (keys.hasNext()) {
			String key = keys.next();
			WebSocketSession ws = map.get(key);

			// 연결되어 있는 브라우저 소켓
			if (ws.isOpen()) {
				ws.sendMessage(new TextMessage(sendMsg));
			} else {
				removeList.add(ws.getId());
			}
		}
	}
	
	public void closeWebSocket(ArrayList<String> removeList) throws Exception {
		for (String removeWebSocketId : removeList) {
			System.out.println("소켓을 닫습니다 > " + removeWebSocketId);
			map.remove(removeWebSocketId);
		}
	}
	
	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		super.afterConnectionEstablished(session);
	}

	@Override
	protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
		String rcvMsg = message.getPayload();
		HandleMsg handleMsg = gson.fromJson(rcvMsg, HandleMsg.class);
		String msgType = handleMsg.getType();
		String sendMsg = "";
		
		System.out.println("페이로드 > " + rcvMsg);

		if (msgType.equals("browser")) { // 브라우저와 연결이 되었을 경우
			ArrayList<String> removeList = new ArrayList<>();
			
			checkWebSocket(removeList);
			closeWebSocket(removeList);
			
			if (map.get(session.getId()) == null)
				map.put(session.getId(), session);
		} else if (msgType.equals("initializingCar")) { // 차량과 연결이 되었을 경우
			carSession = session;
			sendMsg = "서버와 연결됨!";
			System.out.println("차량의 정보를 얻습니다 > " + session);
			sendMsgToCar(carSession, sendMsg);
		} else if (msgType.equals("driving")) { // 차량에게 주행 관련 메시지를 보냄
			sendMsg = rcvMsg;
			System.out.println("차량 수동 조작 > " + sendMsg);
			sendMsgToCar(carSession, sendMsg);
		} else if (msgType.equals("binData") || msgType.equals("collectedData")) { // 브라우저로 차량에서 받은 데이터를 전달
			
			ArrayList<String> removeList = new ArrayList<>();
			sendMsg = rcvMsg;
			
			sendToWebSocket(removeList, sendMsg);
			closeWebSocket(removeList);
		} else if (msgType.equals("collectingList")) { // 차량에게 수집 리스트를 보냄
			sendMsg = rcvMsg;
			System.out.println("수집 리스트 > " + sendMsg);
			sendMsgToCar(carSession, sendMsg);
		} else if (msgType.equals("termination")) { // 브라우저와 연결이 끊김
			System.out.println("웹 소켓 종료  초기화합니다.");
		} else if (msgType.equals("state")) { // 차량에게 수동/자동로 전환 메시지 보냄 
			sendMsg = rcvMsg;
			System.out.println("차량 모드를 " + handleMsg.getMode() + "로 전환합니다.");			
			sendMsgToCar(carSession, sendMsg);
		}
	}
}