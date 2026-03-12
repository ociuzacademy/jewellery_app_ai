// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:freezed_annotation/freezed_annotation.dart';
// import 'package:jewellery_app/view/employee_module/employee_login/model/emop_login_model.dart';
// import 'package:jewellery_app/view/employee_module/employee_login/service/emp_login_service.dart';

// part 'employee_login_event.dart';
// part 'employee_login_state.dart';
// part 'employee_login_bloc.freezed.dart';

// class EmployeeLoginBloc extends Bloc<EmployeeLoginEvent, EmployeeLoginState> {
//   EmployeeLoginBloc() : super(_Initial()) {
//     on<_loggedIn>((event, emit) async {
//       emit(EmployeeLoginState.loading());
//       try {
//         final response = await employeeLoginService(email: event.email, password: event.password);
//         emit(EmployeeLoginState.success(response));
//       } catch (e) {
//         emit(EmployeeLoginState.failed(e.toString()));
//       }
//     });
//   }
// }
