import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuario {
  static final PreferenciasUsuario _instancia =
      new PreferenciasUsuario._internal();

  factory PreferenciasUsuario() {
    return _instancia;
  }

  PreferenciasUsuario._internal();
  late SharedPreferences _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  // GET y SET del nombreUsuario
  String get nombreUsuario {
    return _prefs.getString('nombreUsuario') ?? '';
  }

  set nombreUsuario(String value) {
    _prefs.setString('nombreUsuario', value);
  }

  // GET y SET del nombreUsuario
  String get nombreUsuarioDos {
    return _prefs.getString('nombreUsuarioDos') ?? '';
  }

  set nombreUsuarioDos(String value) {
    _prefs.setString('nombreUsuarioDos', value);
  }

  // GET y SET del nombreUsuario
  String get nombreUsuarioFull {
    return _prefs.getString('nombreUsuarioFull') ?? '';
  }

  set nombreUsuarioFull(String value) {
    _prefs.setString('nombreUsuarioFull', value);
  }

  // GET y SET del usuarioId
  int get usuarioId {
    return _prefs.getInt('usuarioId') ?? -1;
  }

  set usuarioId(int value) {
    _prefs.setInt('usuarioId', value);
  }

  // GET y SET del nombreUsuario
  String get emailUsuario {
    return _prefs.getString('emailUsuario') ?? '';
  }

  set emailUsuario(String value) {
    _prefs.setString('emailUsuario', value);
  }

  // GET y SET del nombreUsuario
  String get passwordUsuario {
    return _prefs.getString('passwordUsuario') ?? '';
  }

  set passwordUsuario(String value) {
    _prefs.setString('passwordUsuario', value);
  }

  // GET y SET company Id
  // GET y SET del nombreUsuario
  String get companyId {
    return _prefs.getString('companyId') ?? '';
  }

  set companyId(String value) {
    _prefs.setString('companyId', value);
  }

  // GET y SET de Token Android
  String get tokenAndroid {
    return _prefs.getString('tokenAndroid') ?? '';
  }

  set tokenAndroid(String value) {
    _prefs.setString('tokenAndroid', value);
  }

  // GET y SET version
  String get versionNew {
    return _prefs.getString('versionNew') ?? '';
  }

  set versionNew(String value) {
    _prefs.setString('versionNew', value);
  }

  // GET y SET version
  String get versionOld {
    return _prefs.getString('versionOld') ?? '';
  }

  // GET y SET del tema
  bool get tema {
    return _prefs.getBool('tema') ?? false;
  }

  set tema(bool value) {
    _prefs.setBool('tema', value);
  }

  set versionOld(String value) {
    _prefs.setString('versionOld', value);
  }

  String get tripId {
    return _prefs.getString('tripId') ?? '';
  }

  set tripId(String value) {
    _prefs.setString('tripId', value);
  }

  void removeData() {
    _prefs.clear();
  }

  remove() {
    _prefs.remove('nombreUsuario');
    _prefs.remove('passwordUsuario');
  }
}
