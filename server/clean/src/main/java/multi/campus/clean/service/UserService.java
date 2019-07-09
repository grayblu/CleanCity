package multi.campus.clean.service;

import java.util.List;

import multi.campus.clean.domain.PageInfo;
import multi.campus.clean.domain.User;

public interface UserService {
	PageInfo<User> getPage(int page) throws Exception;
	
	// 사용자 계정 조회
	User getUser(String userid) throws Exception;
	
	// 사용자 계정 생성
	int create(User user) throws Exception;
	
	// 사용자 계정 업데이트
	int update(User user) throws Exception;
	
	// 사용자 계정 삭제
	boolean delete(User user) throws Exception;
	
	// 쓰레기통이 설치된 사용자 조회
	List<User> getUsers() throws Exception;
	
	// 수십중인 쓰레기통 조회
	List<User> getCollectingList() throws Exception;
}
