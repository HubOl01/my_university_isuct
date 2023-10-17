// получение get-запроса расписания
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../Pages/schedule/lessonsPage.dart';
import '../components/checkNetwork.dart';
import '../components/weekNumber.dart';
import '../components/writeAndReadJson.dart';
import '../custom/customArg.dart';
import '../model/isuctModel.dart';

var getResISUCT;
bool isDataISUCT = true;
bool isDataISUCTLoading = true;
bool isEmptyData = true;
Future getISUCT() async {
  isDataISUCT = true;
  await checkNetwork();
  if (isNetwork) {
    String url = "${dotenv.env['API']}/isuct/api.php";
    var res = await http.get(Uri.parse(url));
    try {
      if (res.statusCode == 200) {
        if (res.body.isNotEmpty) {
          getResISUCT = ruIsuctFromJson(res.body);
          await writeJson(json.encode(getResISUCT));
          getResISUCT = ruIsuctFromJson(await readJson());
          isEmptyData = false;
          isDataISUCT = false;
          isDataISUCTLoading = false;
          listScheduleToday1 = listlessonsCustom(
            weekNumber(DateTime(DateTime.now().year, DateTime.now().month,
                            DateTime.now().day)) %
                        2 ==
                    0
                ? 1
                : 2,
            1,
          );
          print(
              "Successed write ===>>> getResISUCT > ${getResISUCT.toJson().toString()}");

          print("getISUCT: ${res.statusCode}");
          print("resISUCT: ${getResISUCT.faculties[1].name.toString()}");
        } else {
          isEmptyData = true;
        }
      } else {
        isDataISUCT = true;
        isDataISUCTLoading = true;
        print("Not getISUCT");
      }
    } catch (e) {
      isDataISUCT = true;
      isDataISUCTLoading = true;
      print("excep(getISUCT) = $e");
      print("Recorted(getISUCT): ${res.statusCode}");
    }
  }
  offlineApi();
}
var getResISUCTOffline;
Future offlineApi() async{
   try {

      getResISUCT = ruIsuctFromJson(await readJson());
      getResISUCTOffline = getResISUCT;

      isEmptyData = false;
      isDataISUCT = false;
      isDataISUCTLoading = false;
      print("OFFLINE: ${getResISUCT.toJson().toString()}");

    } catch (e) {
      isDataISUCT = true;
      isDataISUCTLoading = true;
      print("excep Offline (getISUCT) = $e");
    }
  }