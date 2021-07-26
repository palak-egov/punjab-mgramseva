import 'package:mgramseva/model/changePasswordDetails/changePassword_details.dart';
import 'package:mgramseva/providers/common_provider.dart';
import 'package:mgramseva/services/RequestInfo.dart';
import 'package:mgramseva/services/base_service.dart';
import 'package:mgramseva/services/urls.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:mgramseva/utils/models.dart';
import 'package:provider/provider.dart';

class ChangePasswordRepository extends BaseService {
  Future<ChangePasswordDetails> updatePassword(Map body) async {
    var commonProvider = Provider.of<CommonProvider>(
        navigatorKey.currentContext!,
        listen: false);
    final requestInfo = RequestInfo('ap.public', .01, "", "create", 1, "", "",
        commonProvider.userDetails!.accessToken);
    late ChangePasswordDetails changePasswordDetails;
    var res = await makeRequest(
        url: UserUrl.CHANGE_PASSWORD,
        body: body,
        requestInfo: requestInfo,
        method: RequestType.POST);
    if (res != null) {
      changePasswordDetails = ChangePasswordDetails.fromJson(res);
    }
    return changePasswordDetails;
  }
}