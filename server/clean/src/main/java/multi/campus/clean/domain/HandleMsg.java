package multi.campus.clean.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class HandleMsg {
	String type;
	String message;
	String userid;
	String address;
	String garbageList;
	String mode;
	String direction;
	double cap;
}
