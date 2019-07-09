package multi.campus.clean.domain;

import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ResultMsg {
	private String result;
	private String message;
	
	public static ResponseEntity<ResultMsg> response(String result, String message) {
		HttpHeaders headers = new HttpHeaders();
		headers.add("Content-type", "application/json; charset=utf-8");
		
		return new ResponseEntity<>(new ResultMsg(result, message), headers, HttpStatus.OK);
	}
}
