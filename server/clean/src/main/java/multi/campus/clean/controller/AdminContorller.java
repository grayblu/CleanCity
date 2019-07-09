package multi.campus.clean.controller;

import java.util.List;

import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.Gson;

import lombok.extern.slf4j.Slf4j;
import multi.campus.clean.domain.GarbageCollection;
import multi.campus.clean.domain.HandleMsg;
import multi.campus.clean.domain.PageInfo;
import multi.campus.clean.domain.ResultMsg;
import multi.campus.clean.domain.Search;
import multi.campus.clean.domain.User;
import multi.campus.clean.service.GarbageCollectionService;
import multi.campus.clean.service.UserService;

@Controller
@Slf4j
public class AdminContorller {
	@Autowired
	UserService userService;

	@Autowired
	GarbageCollectionService garbageCollectionService;

	Gson gson = new Gson();

	@GetMapping("/admin")
	public String getAdmin() {
		return "redirect:/admin/list";
	}

	@GetMapping("/admin/list")
	public String getList(@RequestParam(value = "page", defaultValue = "1") int page, Model model) throws Exception {
		PageInfo<User> pi = userService.getPage(page);
		model.addAttribute("pi", pi);

		return "admin/list";
	}

	@GetMapping("/admin/edit/{userid}")
	public String getEdit(@PathVariable String userid, Model model) throws Exception {
		User user = userService.getUser(userid);
		System.out.println("수정할 회원> " + user);
		model.addAttribute("user", user);

		return "admin/edit";
	}

	@PostMapping("/admin/edit/{userid}")
	public String postEdit(@PathVariable String userid, User user, Model model) throws Exception {
		System.out.println("수정할 회원 " + user);

		if (userService.update(user) > 0)
			return "redirect:/admin/list";
		else {
			model.addAttribute("user", user);
			return "admin/edit";
		}
	}

	@GetMapping("/admin/monitor")
	public void getMonitor(Model model) throws Exception {
		List<User> list = userService.getUsers();

		Gson gson = new Gson();
		String gsonList = gson.toJson(list);
		model.addAttribute("userList", gsonList);
	}

	@PostMapping("/admin/capUpdate")
	@ResponseBody
	public ResponseEntity<ResultMsg> checkId(@RequestBody HandleMsg handleMsg) throws Exception {
		String type = handleMsg.getType();
		System.out.println("핸들 메시지 > " + handleMsg);
		User searchedUser = userService.getUser(handleMsg.getUserid());
		
		if(type.equals("binData")) {
			System.out.println("사용자로부터 입력 받은 아이디 " + handleMsg.getUserid() + " 용량 :" + handleMsg.getCap());
			System.out.println("검색된 회원 " + searchedUser);

			if (searchedUser != null) {
				searchedUser.setCap(handleMsg.getCap());
				userService.update(searchedUser);
				return ResultMsg.response("ok", "갱신되었습니다.");
			} else {
				return ResultMsg.response("fail", "잘못된 접근입니다.");
			}
		} else { // 쓰레기 수거 완료
			if (searchedUser != null) {				
				// 쓰레기 수집 테이블에 데이터 추가
				GarbageCollection garbageCollection = new GarbageCollection();
				garbageCollection.setUserid(searchedUser.getUserid());
				garbageCollection.setAddress(searchedUser.getAddress());
				garbageCollection.setCap(searchedUser.getCap());
				garbageCollectionService.create(garbageCollection);
				
				// 쓰레기 용량 비우고 사용자 계정 업데이트
				searchedUser.setCap(0);
				searchedUser.setCondition("waiting");
				userService.update(searchedUser);
				System.out.println("수거 전 " + searchedUser);
				System.out.println("수거 완료함!");
				return ResultMsg.response("ok", "갱신되었습니다.");
			} else {
				return ResultMsg.response("fail", "잘못된 접근입니다.");
			}
		}
	}
	
	
	// 수집 리스트 리턴
	@GetMapping("/admin/collectingList")
	@ResponseBody
	public ResponseEntity<ResultMsg> getCollectingList(Model model) throws Exception {
		List<User> collectingList = userService.getCollectingList();
		Gson gson = new Gson();
		int collectSize = collectingList.size();
		System.out.println("수집중인 리스트 사이즈 >> " + collectSize);
		model.addAttribute("collectSize", collectSize);
		
		if (collectingList.size() > 0) {
			model.addAttribute("collectingList", gson.toJson(collectingList));
						
			return ResultMsg.response("ok", gson.toJson(collectingList));
		} else {
			return ResultMsg.response("fail", gson.toJson(collectingList));
		}
	}

	// 수집 리스트 업데이트 
	@PostMapping("/admin/updateCollectingList")
	@ResponseBody
	public ResponseEntity<ResultMsg> postUpdateCollectingList(@RequestBody User user) throws Exception {
		String updateCondition = user.getCondition();
		User updatedUser = userService.getUser(user.getUserid());
		updatedUser.setCondition(updateCondition);
		int result = userService.update(updatedUser);
		List<User> collectingList = userService.getCollectingList();
		
		if (result > 0) {
			return ResultMsg.response("ok", gson.toJson(collectingList));
		} else
			return ResultMsg.response("fail", gson.toJson(collectingList));
	}

	// 수집 리스트에 데이터 추가
	@PostMapping("/admin/collectedGarbage")
	@ResponseBody
	public ResponseEntity<ResultMsg> postCollectedGarbage(@RequestBody GarbageCollection garbageCollection) throws Exception {
		System.out.println("추가될 데이터 >> " + garbageCollection);
		garbageCollectionService.create(garbageCollection);
		System.out.println(garbageCollectionService.create(garbageCollection));
		
		return ResultMsg.response("ok","");
	}
	
	// 수집 리스트 조회
	@GetMapping("/admin/collection-list")
	public String getCollectionList(@RequestParam(value = "page", defaultValue = "1") int page, Model model,
			Search search) throws Exception {
		PageInfo<GarbageCollection> pi = garbageCollectionService.getPage(page);
		model.addAttribute("pi", pi);

		System.out.println("수집 리스트 사이즈 " + pi);
		return "admin/collection-list";
	}

	@PostMapping("/admin/collection-list")
	public String postCollectionList(@RequestParam(value = "page", defaultValue = "1") int page, @Valid Search search,
			BindingResult result, Model model) throws Exception {
		if (result.hasErrors()) {
			model.addAttribute("fail", "검색 유형을 설정하세요.");
			result.reject("검색 유형을 설정하세요.");
		}
		String type = search.getType();
		String content = search.getContent();		
		
		PageInfo<GarbageCollection> pi;
		System.out.println("검색 내용 >> " + search.getContent() + ", 타입 >> " + type);
		
		if (type.equals("userid")) {
			pi = garbageCollectionService.getUserCollection(page, content);
			System.out.println("pi >> " + pi);
		} else if(type.equals("region")) {
			pi = garbageCollectionService.getRegionCollection(page, content);
			System.out.println("pi >> " + pi);
		} else {
			pi = garbageCollectionService.getPage(page);
		}
		
		model.addAttribute("pi", pi);
		model.addAttribute("type", type);
		
		return "admin/collection-list";
	}
	
}
