/// {@category BLOC}
/// Different user types permitted on the platform.
enum UserType {
  /// Game master user type (aka. GM).
  GameMaster,

  /// Group leader user type (aka. GL).
  GroupLeader,

  /// Student user type (aka. Participant).
  Student,

  /// Unknown user type.
  ///
  /// User type may be unknown if user has not been loaded or an error has
  /// occurred.
  Unknown,
}