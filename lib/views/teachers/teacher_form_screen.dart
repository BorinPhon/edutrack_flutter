import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../models/teacher/teacher_model.dart';
import '../../models/teacher/teacher_request.dart';
import '../../providers/teacher_provider.dart';
import '../../services/api_service.dart';
import '../../services/upload_api_service.dart';

class TeacherFormScreen extends StatefulWidget {
  final TeacherModel? teacher;

  const TeacherFormScreen({
    super.key,
    this.teacher,
  });

  @override
  State<TeacherFormScreen> createState() =>
      _TeacherFormScreenState();
}

class _TeacherFormScreenState
    extends State<TeacherFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  File? _selectedImage;

  final ImagePicker _picker = ImagePicker();
  final UploadApiService _uploadApiService = UploadApiService();
  String _gender = "Male";

  DateTime? _birthday;
  bool _isUploading = false;
  @override
  void initState() {
    super.initState();

    if (widget.teacher != null) {

      final teacher = widget.teacher!;

      _firstNameController.text =
          teacher.firstName;

      _lastNameController.text =
          teacher.lastName;

      _emailController.text =
          teacher.email ?? "";

      _phoneController.text =
          teacher.phone ?? "";

      _addressController.text =
          teacher.address ?? "";

      _gender =
          teacher.gender ?? "Male";

      _birthday =
          teacher.dateOfBirth;
    }
  }
  Future<void> _pickImage() async {

    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image == null) return;

    setState(() {
      _isUploading = true;
      _selectedImage = File(image.path);
      _isUploading = false;
    });
  }
  @override
  void dispose() {

    _firstNameController.dispose();

    _lastNameController.dispose();

    _emailController.dispose();

    _phoneController.dispose();

    _addressController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final provider =
    context.watch<TeacherProvider>();

    return Scaffold(

      appBar: AppBar(

        title: Text(

          widget.teacher == null
              ? "Add Teacher"
              : "Edit Teacher",

        ),

      ),

      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildPhoto(),
              const SizedBox(height: 20),
              _buildFirstName(),

              const SizedBox(height: 16),

              _buildLastName(),

              const SizedBox(height: 16),

              _buildEmail(),

              const SizedBox(height: 16),

              _buildPhone(),

              const SizedBox(height: 16),

              _buildGender(),

              const SizedBox(height: 16),

              _buildBirthday(),

              const SizedBox(height: 16),

              _buildAddress(),

              const SizedBox(height: 30),

              _buildSaveButton(provider),

            ],
          ),
        ),
      ),

    );

  }
  Widget _buildPhoto() {
    return Center(
      child: GestureDetector(
        onTap: _pickImage,
        child: Stack(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: _selectedImage != null
                  ? FileImage(_selectedImage!)
                  : widget.teacher?.photo != null &&
                  widget.teacher!.photo!.isNotEmpty
                  ? NetworkImage(
                "${ApiService.serverUrl}/image/teachers/${widget.teacher!.photo}",
              )
                  : null,
              child: _selectedImage == null &&
                  (widget.teacher?.photo == null ||
                      widget.teacher!.photo!.isEmpty)
                  ? const Icon(
                Icons.person,
                size: 60,
              )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildFirstName() {
    return TextFormField(
      controller: _firstNameController,
      decoration: const InputDecoration(
        labelText: "First Name",
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.person),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Please enter first name";
        }
        return null;
      },
    );
  }
  Widget _buildLastName() {
    return TextFormField(
      controller: _lastNameController,
      decoration: const InputDecoration(
        labelText: "Last Name",
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.person_outline),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Please enter last name";
        }
        return null;
      },
    );
  }
  Widget _buildEmail() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        labelText: "Email",
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.email),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Please enter email";
        }
        return null;
      },
    );
  }
  Widget _buildPhone() {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      decoration: const InputDecoration(
        labelText: "Phone",
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.phone),
      ),
    );
  }
  Widget _buildGender() {
    return DropdownButtonFormField<String>(
      value: _gender,
      decoration: const InputDecoration(
        labelText: "Gender",
        border: OutlineInputBorder(),
      ),
      items: const [
        DropdownMenuItem(
          value: "Male",
          child: Text("Male"),
        ),
        DropdownMenuItem(
          value: "Female",
          child: Text("Female"),
        ),
      ],
      onChanged: (value) {
        setState(() {
          _gender = value!;
        });
      },
    );
  }
  Widget _buildBirthday() {
    return TextFormField(
      readOnly: true,
      controller: TextEditingController(
        text: _birthday == null
            ? ""
            : "${_birthday!.year}-${_birthday!.month.toString().padLeft(2, '0')}-${_birthday!.day.toString().padLeft(2, '0')}",
      ),
      decoration: const InputDecoration(
        labelText: "Date of Birth",
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.calendar_today),
      ),
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: _birthday ?? DateTime(2000),
          firstDate: DateTime(1950),
          lastDate: DateTime.now(),
        );

        if (date != null) {
          setState(() {
            _birthday = date;
          });
        }
      },
    );
  }
  Widget _buildAddress() {
    return TextFormField(
      controller: _addressController,
      maxLines: 3,
      decoration: const InputDecoration(
        labelText: "Address",
        border: OutlineInputBorder(),
        alignLabelWithHint: true,
        prefixIcon: Icon(Icons.home),
      ),
    );
  }
  Widget _buildSaveButton(TeacherProvider provider) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: provider.isLoading ? null : () => _saveTeacher(provider),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2E7D32),
          foregroundColor: Colors.white,
        ),
        child: provider.isLoading
            ? const CircularProgressIndicator(
          color: Colors.white,
        )
            : Text(
          widget.teacher == null
              ? "Create Teacher"
              : "Update Teacher",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
  Future<void> _saveTeacher(
      TeacherProvider provider,
      ) async {

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_birthday == null) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select date of birth."),
        ),
      );

      return;
    }
    String? photo = widget.teacher?.photo;

    if (_selectedImage != null) {
      photo = await _uploadApiService.uploadImage(
        _selectedImage!,
        "teachers",
      );
    }

    final request = TeacherRequest(
      email: _emailController.text.trim(),
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      gender: _gender,
      dateOfBirth: _birthday!,
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
      photo: photo ?? "",
    );

    bool success;

    if (widget.teacher == null) {

      success = await provider.addTeacher(request);

    } else {

      success = await provider.updateTeacher(
        widget.teacher!.id,
        request,
      );

    }

    if (!mounted) return;

    if (success) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            widget.teacher == null
                ? "Teacher created successfully."
                : "Teacher updated successfully.",
          ),
        ),
      );

      Navigator.pop(context, true);

    } else {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            provider.errorMessage ??
                "Operation failed.",
          ),
        ),
      );

    }

  }

}