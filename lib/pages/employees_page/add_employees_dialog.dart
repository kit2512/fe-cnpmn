import 'package:another_flushbar/flushbar.dart';
import 'package:fe_cnpmn/data/models/form/name.dart';
import 'package:fe_cnpmn/data/models/form/password_model.dart';
import 'package:fe_cnpmn/data/repositories/employee_repository.dart';
import 'package:fe_cnpmn/dependency_injection.dart';
import 'package:fe_cnpmn/enums/user_role_enum.dart';
import 'package:fe_cnpmn/pages/employees_page/add_employee_cubit/add_employee_cubit.dart';
import 'package:fe_cnpmn/pages/widgets/name_input.dart';
import 'package:fe_cnpmn/pages/widgets/password_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class AddEmployeeDialog extends StatelessWidget {
  const AddEmployeeDialog({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider<AddEmployeeCubit>(
        create: (context) =>
            AddEmployeeCubit(employeeRepository: getIt<EmployeeRepository>()),
        child: const _AddEmployeeDialogView(),
      );
}

class _AddEmployeeDialogView extends StatelessWidget {
  const _AddEmployeeDialogView();

  @override
  Widget build(BuildContext context) =>
      BlocConsumer<AddEmployeeCubit, AddEmployeeState>(
        listenWhen: (prev, current) =>
            current.creationStatus != prev.creationStatus,
        listener: (context, state) {
          if (state.creationStatus.isFailure) {
            Flushbar<void>(
              backgroundColor: Colors.red,
              title: 'Error',
              message: state.errorMessage,
              duration: const Duration(seconds: 3),
            ).show(context);
          }
          if (state.creationStatus.isSuccess) {
            Navigator.of(context).pop(true);
          }
        },
        builder: (context, state) => AlertDialog(
          title: const Text('Add employee'),
          actionsPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          content: const Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 16.0,
              ),
              _FirstNameField(),
              SizedBox(
                height: 12.0,
              ),
              _LastNameField(),
              SizedBox(
                height: 12.0,
              ),
              _UsernameField(),
              SizedBox(
                height: 12.0,
              ),
              _PasswordField(),
              SizedBox(
                height: 12.0,
              ),
              _SalaryField(),
              SizedBox(
                height: 12.0,
              ),
              _EmailField(),
              SizedBox(
                height: 12.0,
              ),
              _RolePicker(),

            ],
          ),
          actions: [
            TextButton(
              onPressed: state.creationStatus.isInProgress
                  ? null
                  : Navigator.of(context).pop,
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: state.creationStatus.isInProgress || state.isNotValid
                  ? null
                  : context.read<AddEmployeeCubit>().createEmployee,
              child: state.creationStatus.isInProgress
                  ? const CircularProgressIndicator()
                  : const Text('Add'),
            )
          ],
        ),
      );
}

class _FirstNameField extends StatelessWidget {
  const _FirstNameField();

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<AddEmployeeCubit, AddEmployeeState>(
        buildWhen: (prev, current) => prev.firstName != current.firstName,
        builder: (context, state) => NameInput(
          enabled: !state.creationStatus.isInProgress,
          validator: (_) =>
              (state.firstName.isNotValid && state.firstName.error != null)
                  ? Name.getError(state.firstName.error!)
                  : null,
          onChanged: context.read<AddEmployeeCubit>().firstNameChanged,
          labelText: 'First name',
          initialValue: state.firstName.value,
        ),
      );
}

class _LastNameField extends StatelessWidget {
  const _LastNameField();

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<AddEmployeeCubit, AddEmployeeState>(
        buildWhen: (prev, current) =>
            prev.creationStatus != current.creationStatus ||
            prev.lastName != current.lastName,
        builder: (context, state) => NameInput(
          enabled: !state.creationStatus.isInProgress,
          validator: (_) =>
              (state.lastName.isNotValid && state.lastName.error != null)
                  ? Name.getError(state.lastName.error!)
                  : null,
          onChanged: context.read<AddEmployeeCubit>().lastNameChanged,
          labelText: 'Last name',
          initialValue: state.lastName.value,
        ),
      );
}

class _UsernameField extends StatelessWidget {
  const _UsernameField();

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<AddEmployeeCubit, AddEmployeeState>(
        buildWhen: (prev, current) =>
            prev.creationStatus != current.creationStatus ||
            prev.username != current.username,
        builder: (context, state) => NameInput(
          enabled: !state.creationStatus.isInProgress,
          validator: (_) =>
              (state.username.isNotValid && state.username.error != null)
                  ? Name.getError(state.username.error!)
                  : null,
          onChanged: context.read<AddEmployeeCubit>().usernameChanged,
          labelText: 'Username',
          initialValue: state.username.value,
        ),
      );
}


class _EmailField extends StatelessWidget {
  const _EmailField();

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<AddEmployeeCubit, AddEmployeeState>(
        buildWhen: (prev, current) =>
        prev.creationStatus != current.creationStatus ||
            prev.username != current.username,
        builder: (context, state) => NameInput(
          enabled: !state.creationStatus.isInProgress,
          validator: (_) =>
          (state.username.isNotValid && state.username.error != null)
              ? Name.getError(state.username.error!)
              : null,
          onChanged: context.read<AddEmployeeCubit>().usernameChanged,
          labelText: 'Username',
          initialValue: state.username.value,
        ),
      );
}

class _SalaryField extends StatelessWidget {
  const _SalaryField();

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<AddEmployeeCubit, AddEmployeeState>(
        buildWhen: (prev, current) =>
            prev.creationStatus != current.creationStatus ||
            prev.salary != current.salary,
        builder: (context, state) => TextFormField(
          enabled: !state.creationStatus.isInProgress,
          validator: (_) =>
              (state.salary < 0) ? 'Salary must be greater than 0' : null,
          onChanged: (value) {
            context.read<AddEmployeeCubit>().salaryChanged(int.parse(value));
          },
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Salary',
          ),
        ),
      );
}

class _PasswordField extends StatelessWidget {
  const _PasswordField();

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<AddEmployeeCubit, AddEmployeeState>(
        buildWhen: (prev, current) =>
            prev.creationStatus != current.creationStatus ||
            prev.password != current.password,
        builder: (context, state) => PasswordTextFormField(
          enabled: !state.creationStatus.isInProgress,
          validator: (_) =>
              (state.password.isNotValid && state.password.error != null)
                  ? Password.getError(state.password.error!)
                  : null,
          onChanged: context.read<AddEmployeeCubit>().passwordChanged,
          labelText: 'Password',
        ),
      );
}

class _RolePicker extends StatelessWidget {
  const _RolePicker();

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Role'),
          const SizedBox(
            width: 16,
          ),
          BlocBuilder<AddEmployeeCubit, AddEmployeeState>(
            buildWhen: (prev, current) =>
                prev.creationStatus != current.creationStatus ||
                prev.role != current.role,
            builder: (context, state) => DropdownMenu<UserRole>(
              enableSearch: false,
              hintText: 'Choose role',
              initialSelection: state.role,
              onSelected: context.read<AddEmployeeCubit>().roleChanged,
              dropdownMenuEntries: UserRole.values
                  .map(
                    (e) => DropdownMenuEntry<UserRole>(
                      value: e,
                      label: e.translationName,
                    ),
                  )
                  .toList(
                    growable: false,
                  ),
            ),
          ),
        ],
      );
}
