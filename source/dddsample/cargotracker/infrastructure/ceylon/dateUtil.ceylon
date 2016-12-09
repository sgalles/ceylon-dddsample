import java.text {
    SimpleDateFormat
}
import java.util {
    Date
}

shared Date toDate(String date, String time = "00:00.00.000")
    => SimpleDateFormat("yyyy-MM-dd HH:mm")
            .parse(date + " " + time);

shared Date copyDate(Date date) => Date(date.time);
