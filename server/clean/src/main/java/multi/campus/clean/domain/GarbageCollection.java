package multi.campus.clean.domain;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class GarbageCollection {
	int collectionNo;
	String userid;
	double cap;
	String address;
	Date emptyDate;
}
