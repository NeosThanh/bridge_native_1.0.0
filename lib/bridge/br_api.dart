import 'package:pigeon/pigeon.dart';

class Req {
  String? key;
  Map? data;
}

class Res {
  String? key;
  Map? data;
}

@HostApi()
abstract class ReqApi {
  Res request(Req request);
}
