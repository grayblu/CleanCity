package multi.campus.clean.broker;

import java.util.Collections;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Observer;

import org.springframework.stereotype.Component;

@Component
public class MjpegBroker {
	Map<Integer, List<Observer>> map = Collections.synchronizedMap(new HashMap<>());
	
	// 디바이스 ID 고유의 리스트를 맵에 추가
	synchronized public void addObserver(int deviceId, Observer observer) {
		List<Observer> list = map.get(deviceId);
		if (list == null) {
			list = new LinkedList<>();
			map.put(deviceId, list);
		}
		list.add(observer);
	}

	// 해당 디바이스를 관찰하고 있는 모든 옵저버에게 데이터 갱신
	synchronized public void update(int deviceId, byte[] image) {
		List<Observer> list = map.get(deviceId);
		if (list != null) {
			for (Observer observer : list) {
				observer.update(null, image);
			}
		}
	}

	// 해당 디바이스에 대한 옵저버 제거
	synchronized public void deleteObserver(int deviceId, Observer observer) {
		List<Observer> list = map.get(deviceId);
		if (list != null) {
			list.remove(observer);
		}
	}
}
