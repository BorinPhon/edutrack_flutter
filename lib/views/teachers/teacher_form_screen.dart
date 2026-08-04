import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/teacher_model.dart';
import '../../providers/teacher_provider.dart';

class TeacherFormScreen extends StatefulWidget {
  final TeacherModel? teacher;

  const TeacherFormScreen({super.key, this.teacher});

  @override
  State<TeacherFormScreen> createState() => _TeacherFormScreenState();
}

class _TeacherFormScreenState extends State<TeacherFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _photoController;
  late TextEditingController _positionController;
  late TextEditingController _qualificationController;
  late TextEditingController _salaryController;

  String _selectedGender = 'Male';
  DateTime? _selectedDOB;
  DateTime? _selectedHireDate;
  bool _isActive = true;
  bool _isLoading = false;

  bool get _isEditing => widget.teacher != null;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.teacher?.firstName ?? '');
    _lastNameController = TextEditingController(text: widget.teacher?.lastName ?? '');
    _emailController = TextEditingController(text: widget.teacher?.email ?? '');
    _phoneController = TextEditingController(text: widget.teacher?.phone ?? '');
    _addressController = TextEditingController(text: widget.teacher?.address ?? '');
    _photoController = TextEditingController(text: widget.teacher?.photo ?? '');
    _positionController = TextEditingController(text: widget.teacher?.position ?? '');
    _qualificationController = TextEditingController(text: widget.teacher?.qualification ?? '');
    _salaryController = TextEditingController(
      text: widget.teacher?.salary != null ? widget.teacher!.salary!.toStringAsFixed(2) : '',
    );

    if (_isEditing) {
      _selectedGender = widget.teacher?.gender ?? 'Male';
      _selectedDOB = widget.teacher?.dateOfBirth;
      _selectedHireDate = widget.teacher?.hireDate;
      _isActive = widget.teacher?.isActive ?? true;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _photoController.dispose();
    _positionController.dispose();
    _qualificationController.dispose();
    _salaryController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(bool isDOB) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: isDOB ? (_selectedDOB ?? DateTime(1990, 1, 1)) : (_selectedHireDate ?? DateTime.now()),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        if (isDOB) {
          _selectedDOB = pickedDate;
        } else {
          _selectedHireDate = pickedDate;
        }
      });
    }
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final teacherModel = TeacherModel(
        teacherId: widget.teacher?.teacherId ?? 'TCH_${DateTime.now().millisecondsSinceEpoch}',
        userId: widget.teacher?.userId ?? 'USR_${DateTime.now().millisecondsSinceEpoch}',
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        gender: _selectedGender,
        dateOfBirth: _selectedDOB,
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
        photo: _photoController.text.trim(),
        position: _positionController.text.trim(),
        qualification: _qualificationController.text.trim(),
        hireDate: _selectedHireDate,
        salary: double.tryParse(_salaryController.text.trim()),
        isActive: _isActive,
      );

      final teacherProvider = Provider.of<TeacherProvider>(context, listen: false);

      bool success;
      if (_isEditing) {
        success = await teacherProvider.updateTeacher(teacherModel);
      } else {
        success = await teacherProvider.addTeacher(teacherModel);
      }

      setState(() => _isLoading = false);

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEditing ? 'Teacher updated!' : 'Teacher added!'),
            backgroundColor: const Color(0xFF2E7D32),
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(teacherProvider.errorMessage ?? 'Operation failed'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF2E7D32);

    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9),
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Teacher' : 'Add New Teacher'),
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _firstNameController,
                        decoration: const InputDecoration(labelText: 'First Name *'),
                        validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _lastNameController,
                        decoration: const InputDecoration(labelText: 'Last Name *'),
                        validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email *', prefixIcon: Icon(Icons.email_outlined)),
                  validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Phone', prefixIcon: Icon(Icons.phone_outlined)),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedGender,
                  decoration: const InputDecoration(labelText: 'Gender', prefixIcon: Icon(Icons.person_outline)),
                  items: ['Male', 'Female', 'Other']
                      .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedGender = val);
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _pickDate(true),
                        child: InputDecorator(
                          decoration: const InputDecoration(labelText: 'DOB'),
                          child: Text(_selectedDOB == null ? 'Select' : '${_selectedDOB!.year}-${_selectedDOB!.month}-${_selectedDOB!.day}'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InkWell(
                        onTap: () => _pickDate(false),
                        child: InputDecorator(
                          decoration: const InputDecoration(labelText: 'Hire Date'),
                          child: Text(_selectedHireDate == null ? 'Select' : '${_selectedHireDate!.year}-${_selectedHireDate!.month}-${_selectedHireDate!.day}'),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _positionController,
                  decoration: const InputDecoration(labelText: 'Position', prefixIcon: Icon(Icons.work_outline)),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _qualificationController,
                  decoration: const InputDecoration(labelText: 'Qualification', prefixIcon: Icon(Icons.school_outlined)),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _salaryController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Salary (\$)', prefixIcon: Icon(Icons.attach_money)),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: 'Address', prefixIcon: Icon(Icons.home_outlined)),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _photoController,
                  decoration: const InputDecoration(labelText: 'Photo URL', prefixIcon: Icon(Icons.image_outlined)),
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  title: const Text('Is Active'),
                  activeColor: primaryGreen,
                  value: _isActive,
                  onChanged: (val) => setState(() => _isActive = val),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _saveForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(_isEditing ? 'Save Changes' : 'Create Teacher'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}