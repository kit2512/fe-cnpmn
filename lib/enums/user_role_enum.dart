enum UserRole {
  employee,
  manager,
}

extension UserRoleExtension on UserRole {
  String get translationName {
    switch(this) {
      case UserRole.employee :
        return 'Employee';
      case UserRole.manager:
        return 'Manager';
    }

  }
}