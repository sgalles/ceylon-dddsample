import java.text {
	SimpleDateFormat
}
import java.util {
	Date
}
shared Date toDate(String date, String? time = null) 
	=> if(exists time) then SimpleDateFormat("yyyy-MM-dd HH:mm").parse(date + " " + time)
	    			   else toDate(date, "00:00.00.000");

