import jstz from "jstz";
import { setCookie } from "lib/cookie";

const timezone = jstz.determine();
// console.log(timezone.name());

setCookie("browser_time_zone", timezone.name());
