import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../models/student/student_model.dart';
import '../../models/student/student_request.dart';
import '../../providers/student_provider.dart';
import '../../services/api_service.dart';
import '../../services/upload_api_service.dart';

class StudentFormScreen extends StatefulWidget {
  final StudentModel? student;

  const StudentFormScreen({
    super.key,
    this.student,
  });

  @override
  State<StudentFormScreen> createState() =>
      _StudentFormScreenState();
}

class _StudentFormScreenState extends State<StudentFormScreen> {

  final _formKey = GlobalKey<FormState>();

  final _dateOfBirthController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  File? _selectedImage;

  final ImagePicker _picker = ImagePicker();
  final UploadApiService _uploadApiService = UploadApiService();

  String _gender = "Male";

  DateTime? _dateOfBirth;

  bool _isLoading = false;
  @override
  void initState() {
    super.initState();

    if (widget.student != null) {
      _firstNameController.text = widget.student!.firstName;
      _lastNameController.text = widget.student!.lastName;
      _emailController.text = widget.student!.email ?? "";
      _phoneController.text = widget.student!.phone ?? "";
      _addressController.text = widget.student!.address ?? "";
      _gender = widget.student!.gender ?? "Male";
      _dateOfBirth = widget.student!.dateOfBirth;
      if (_dateOfBirth != null) {
        _dateOfBirthController.text =
        "${_dateOfBirth!.year}-${_dateOfBirth!.month.toString().padLeft(2, '0')}-${_dateOfBirth!.day.toString().padLeft(2, '0')}";
      }
    }
  }
  Future<void> _pickImage() async {

    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image == null) return;

    setState(() {
      _selectedImage = File(image.path);
    });
  }
  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _dateOfBirthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    const primaryGreen = Color(0xFF2E7D32);

    return Scaffold(

      appBar: AppBar(
        title: Text(
          widget.student == null
              ? "Add Student"
              : "Edit Student",
        ),
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
      ),

      body: SafeArea(

        child: SingleChildScrollView(

          padding: const EdgeInsets.all(20),

          child: Form(

            key: _formKey,

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

                _buildDateOfBirth(),

                const SizedBox(height: 16),

                _buildAddress(),

                const SizedBox(height: 30),

                _buildSaveButton(),

              ],

            ),

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
                  : widget.student?.photo != null &&
                  widget.student!.photo!.isNotEmpty
                  ? NetworkImage(
                "${ApiService.serverUrl}/image/students/${widget.student!.photo}",
              )
                  : null,
              child: _selectedImage == null &&
                  (widget.student?.photo == null ||
                      widget.student!.photo!.isEmpty)
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
        prefixIcon: Icon(Icons.person_outline),
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
        prefixIcon: Icon(Icons.email_outlined),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Please enter email";
        }

        final emailRegex =
        RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,4}$');

        if (!emailRegex.hasMatch(value.trim())) {
          return "Invalid email address";
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
        prefixIcon: Icon(Icons.phone_outlined),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Please enter phone number";
        }
        return null;
      },
    );
  }
  Widget _buildGender() {
    return DropdownButtonFormField<String>(
      value: _gender,
      decoration: const InputDecoration(
        labelText: "Gender",
        prefixIcon: Icon(Icons.people_outline),
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
  Widget _buildDateOfBirth() {
    return TextFormField(
      controller: _dateOfBirthController,
      readOnly: true,
      decoration: const InputDecoration(
        labelText: "Date of Birth",
        prefixIcon: Icon(Icons.calendar_today),
      ),
      validator: (value) {
        if (_dateOfBirth == null) {
          return "Please select date of birth";
        }
        return null;
      },
      onTap: () async {
        FocusScope.of(context).unfocus();

        final picked = await showDatePicker(
          context: context,
          initialDate: _dateOfBirth ?? DateTime(2005),
          firstDate: DateTime(1980),
          lastDate: DateTime.now(),
        );

        if (picked != null) {
          setState(() {
            _dateOfBirth = picked;

            _dateOfBirthController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
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
        prefixIcon: Icon(Icons.home_outlined),
        alignLabelWithHint: true,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Please enter address";
        }
        return null;
      },
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
        onPressed: _isLoading ? null : _saveStudent,
        icon: _isLoading
            ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        )
            : Icon(
          widget.student == null
              ? Icons.save
              : Icons.edit,
        ),
        label: Text(
          _isLoading
              ? (widget.student == null
              ? "Saving..."
              : "Updating...")
              : (widget.student == null
              ? "Save Student"
              : "Update Student"),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2E7D32),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
  Future<void> _saveStudent() async {

    String? photo = widget.student?.photo;

    if (_selectedImage != null) {

      print("========== START UPLOAD ==========");

      photo = await _uploadApiService.uploadImage(
        _selectedImage!,
        "students",
      );

      print("Uploaded File Name = $photo");

    } else {

      print("No image selected");

    }

    print("Photo in Request = $photo");

    final request = StudentRequest(
      email: _emailController.text.trim(),
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      gender: _gender,
      dateOfBirth: _dateOfBirth!,
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
      photo: photo ?? "",
    );

    print(request.toJson());

    final provider = context.read<StudentProvider>();

    bool success;

    if (widget.student == null) {
      // CREATE
      success = await provider.addStudent(request);
    } else {
      // UPDATE
      success = await provider.updateStudent(
        widget.student!.id,
        request,
      );
    }

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Student created successfully."),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            provider.errorMessage ?? "Unable to create student.",
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

}