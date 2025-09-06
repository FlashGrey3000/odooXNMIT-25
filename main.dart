import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(SynergySphereApp());
}

class SynergySphereApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SynergySphere',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue.shade700,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.blue.shade600,
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/dashboard': (context) => ProjectDashboard(),
        '/profile': (context) => ProfileScreen(),
      },
    );
  }
}

// API Configuration
class ApiConfig {
  static const String baseUrl = 'http://localhost:8000'; // Change this to your FastAPI server URL
  static const Duration timeout = Duration(seconds: 30);
}

// Models with JSON serialization
class User {
  final int id;
  final String name;
  final String email;
  final String? avatar;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['user_id'],
      name: json['name'],
      email: json['email'],
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': id,
      'name': name,
      'email': email,
      if (avatar != null) 'avatar': avatar,
    };
  }
}

class Project {
  final int id;
  final String name;
  final String description;
  final List<int> memberIds;
  final DateTime createdAt;
  final int createdBy;

  Project({
    required this.id,
    required this.name,
    required this.description,
    required this.memberIds,
    required this.createdAt,
    required this.createdBy,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['project_id'],
      name: json['name'],
      description: json['description'] ?? '',
      memberIds: (json['member_ids'] as List<dynamic>?)?.cast<int>() ?? [],
      createdAt: DateTime.parse(json['created_at']),
      createdBy: json['created_by'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'project_id': id,
      'name': name,
      'description': description,
      'member_ids': memberIds,
      'created_at': createdAt.toIso8601String(),
      'created_by': createdBy,
    };
  }

  // For creating new projects (without ID)
  Map<String, dynamic> toCreateJson() {
    return {
      'name': name,
      'description': description,
      'created_by': createdBy,
    };
  }
}

enum TaskStatus { toDo, inProgress, done }

extension TaskStatusExtension on TaskStatus {
  String get dbValue {
    switch (this) {
      case TaskStatus.toDo:
        return 'To-Do';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.done:
        return 'Done';
    }
  }

  static TaskStatus fromDbValue(String value) {
    switch (value) {
      case 'To-Do':
        return TaskStatus.toDo;
      case 'In Progress':
        return TaskStatus.inProgress;
      case 'Done':
        return TaskStatus.done;
      default:
        return TaskStatus.toDo;
    }
  }
}

class Task {
  final int id;
  final String title;
  final String description;
  final int projectId;
  final int? assigneeId;
  final DateTime? dueDate;
  final TaskStatus status;
  final DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.projectId,
    this.assigneeId,
    this.dueDate,
    required this.status,
    required this.createdAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['task_id'],
      title: json['title'],
      description: json['description'] ?? '',
      projectId: json['project_id'],
      assigneeId: json['assignee_id'],
      dueDate: json['due_date'] != null ? DateTime.parse(json['due_date']) : null,
      status: TaskStatusExtension.fromDbValue(json['status']),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'task_id': id,
      'title': title,
      'description': description,
      'project_id': projectId,
      'assignee_id': assigneeId,
      'due_date': dueDate?.toIso8601String().split('T')[0], // Format as YYYY-MM-DD
      'status': status.dbValue,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // For creating new tasks (without ID and created_at)
  Map<String, dynamic> toCreateJson() {
    return {
      'title': title,
      'description': description,
      'project_id': projectId,
      'assignee_id': assigneeId,
      'due_date': dueDate?.toIso8601String().split('T')[0],
      'status': status.dbValue,
    };
  }

  Task copyWith({
    int? id,
    String? title,
    String? description,
    int? projectId,
    int? assigneeId,
    DateTime? dueDate,
    TaskStatus? status,
    DateTime? createdAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      projectId: projectId ?? this.projectId,
      assigneeId: assigneeId ?? this.assigneeId,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class Discussion {
  final int id;
  final int projectId;
  final String title;
  final List<DiscussionMessage> messages;
  final DateTime createdAt;
  final int createdBy;

  Discussion({
    required this.id,
    required this.projectId,
    required this.title,
    required this.messages,
    required this.createdAt,
    required this.createdBy,
  });

  factory Discussion.fromJson(Map<String, dynamic> json) {
    return Discussion(
      id: json['discussion_id'],
      projectId: json['project_id'],
      title: json['title'],
      messages: (json['messages'] as List<dynamic>?)
          ?.map((m) => DiscussionMessage.fromJson(m))
          .toList() ?? [],
      createdAt: DateTime.parse(json['created_at']),
      createdBy: json['created_by'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'discussion_id': id,
      'project_id': projectId,
      'title': title,
      'messages': messages.map((m) => m.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'created_by': createdBy,
    };
  }
}

class DiscussionMessage {
  final int id;
  final int discussionId;
  final String message;
  final int authorId;
  final DateTime timestamp;

  DiscussionMessage({
    required this.id,
    required this.discussionId,
    required this.message,
    required this.authorId,
    required this.timestamp,
  });

  factory DiscussionMessage.fromJson(Map<String, dynamic> json) {
    return DiscussionMessage(
      id: json['message_id'],
      discussionId: json['discussion_id'],
      message: json['message'],
      authorId: json['author_id'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message_id': id,
      'discussion_id': discussionId,
      'message': message,
      'author_id': authorId,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

// HTTP Service for API communication
class ApiService {
  static const String _baseUrl = ApiConfig.baseUrl;
  static String? _authToken;

  static Map<String, String> get _headers {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    return headers;
  }

  static void setAuthToken(String token) {
    _authToken = token;
  }

  static void clearAuthToken() {
    _authToken = null;
  }

  // Generic HTTP methods1
  static Future<http.Response> _get(String endpoint) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    return await http.get(url, headers: _headers).timeout(ApiConfig.timeout);
  }

  static Future<http.Response> _post(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    return await http.post(
      url,
      headers: _headers,
      body: json.encode(data),
    ).timeout(ApiConfig.timeout);
  }

  static Future<http.Response> _put(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    return await http.put(
      url,
      headers: _headers,
      body: json.encode(data),
    ).timeout(ApiConfig.timeout);
  }

  static Future<http.Response> _delete(String endpoint) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    return await http.delete(url, headers: _headers).timeout(ApiConfig.timeout);
  }

  // Handle API response
  static Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      throw Exception('API Error: ${response.statusCode} - ${response.body}');
    }
  }
}

// Database Service with HTTP requests
class DatabaseService {
  // User Management
  static Future<User?> authenticateUser(String email, String password) async {
    try {
      final response = await ApiService._post('/auth/login', {
        'email': email,
        'password': password,
      });

      final data = ApiService._handleResponse(response);

      if (data['access_token'] != null) {
        ApiService.setAuthToken(data['access_token']);
        return User.fromJson(data['user']);
      }
      return null;
    } catch (e) {
      print('Authentication error: $e');
      return null;
    }
  }

  static Future<User> createUser(String name, String email, String password) async {
    try {
      final response = await ApiService._post('/auth/register', {
        'name': name,
        'email': email,
        'password': password,
      });

      final data = ApiService._handleResponse(response);

      if (data['access_token'] != null) {
        ApiService.setAuthToken(data['access_token']);
      }

      return User.fromJson(data['user']);
    } catch (e) {
      print('User creation error: $e');
      rethrow;
    }
  }

  static Future<User?> getCurrentUser() async {
    try {
      final response = await ApiService._get('/users/me');
      final data = ApiService._handleResponse(response);
      return User.fromJson(data);
    } catch (e) {
      print('Get current user error: $e');
      return null;
    }
  }

  static Future<void> logoutUser() async {
    try {
      await ApiService._post('/auth/logout', {});
    } catch (e) {
      print('Logout error: $e');
    } finally {
      ApiService.clearAuthToken();
    }
  }

  // Project Management
  static Future<List<Project>> getUserProjects(int userId) async {
    try {
      final response = await ApiService._get('/projects/user/$userId');
      final data = ApiService._handleResponse(response);

      return (data['projects'] as List)
          .map((project) => Project.fromJson(project))
          .toList();
    } catch (e) {
      print('Get user projects error: $e');
      return [];
    }
  }

  static Future<Project> createProject(Project project) async {
    try {
      final response = await ApiService._post('/projects/', project.toCreateJson());
      final data = ApiService._handleResponse(response);
      return Project.fromJson(data);
    } catch (e) {
      print('Create project error: $e');
      rethrow;
    }
  }

  static Future<Project> getProject(int projectId) async {
    try {
      final response = await ApiService._get('/projects/$projectId');
      final data = ApiService._handleResponse(response);
      return Project.fromJson(data);
    } catch (e) {
      print('Get project error: $e');
      rethrow;
    }
  }

  static Future<List<User>> getProjectMembers(int projectId) async {
    try {
      final response = await ApiService._get('/projects/$projectId/members');
      final data = ApiService._handleResponse(response);

      return (data['members'] as List)
          .map((member) => User.fromJson(member))
          .toList();
    } catch (e) {
      print('Get project members error: $e');
      return [];
    }
  }

  static Future<void> addProjectMember(int projectId, int userId, {String role = 'member'}) async {
    try {
      await ApiService._post('/projects/$projectId/members', {
        'user_id': userId,
        'role': role,
      });
    } catch (e) {
      print('Add project member error: $e');
      rethrow;
    }
  }

  static Future<void> removeProjectMember(int projectId, int userId) async {
    try {
      await ApiService._delete('/projects/$projectId/members/$userId');
    } catch (e) {
      print('Remove project member error: $e');
      rethrow;
    }
  }

  // Task Management
  static Future<List<Task>> getProjectTasks(int projectId) async {
    try {
      final response = await ApiService._get('/projects/$projectId/tasks');
      final data = ApiService._handleResponse(response);

      return (data['tasks'] as List)
          .map((task) => Task.fromJson(task))
          .toList();
    } catch (e) {
      print('Get project tasks error: $e');
      return [];
    }
  }

  static Future<Task> createTask(Task task) async {
    try {
      final response = await ApiService._post('/tasks/', task.toCreateJson());
      final data = ApiService._handleResponse(response);
      return Task.fromJson(data);
    } catch (e) {
      print('Create task error: $e');
      rethrow;
    }
  }

  static Future<Task> updateTask(Task task) async {
    try {
      final response = await ApiService._put('/tasks/${task.id}', task.toJson());
      final data = ApiService._handleResponse(response);
      return Task.fromJson(data);
    } catch (e) {
      print('Update task error: $e');
      rethrow;
    }
  }

  static Future<void> deleteTask(int taskId) async {
    try {
      await ApiService._delete('/tasks/$taskId');
    } catch (e) {
      print('Delete task error: $e');
      rethrow;
    }
  }

  // Discussion Management
  static Future<List<Discussion>> getProjectDiscussions(int projectId) async {
    try {
      final response = await ApiService._get('/projects/$projectId/discussions');
      final data = ApiService._handleResponse(response);

      return (data['discussions'] as List)
          .map((discussion) => Discussion.fromJson(discussion))
          .toList();
    } catch (e) {
      print('Get project discussions error: $e');
      return [];
    }
  }

  static Future<Discussion> createDiscussion(Discussion discussion) async {
    try {
      final response = await ApiService._post('/discussions/', {
        'project_id': discussion.projectId,
        'title': discussion.title,
        'created_by': discussion.createdBy,
      });
      final data = ApiService._handleResponse(response);
      return Discussion.fromJson(data);
    } catch (e) {
      print('Create discussion error: $e');
      rethrow;
    }
  }

  static Future<DiscussionMessage> addDiscussionMessage(DiscussionMessage message) async {
    try {
      final response = await ApiService._post('/discussions/${message.discussionId}/messages', {
        'message': message.message,
        'author_id': message.authorId,
      });
      final data = ApiService._handleResponse(response);
      return DiscussionMessage.fromJson(data);
    } catch (e) {
      print('Add discussion message error: $e');
      rethrow;
    }
  }

  // Utility method to search users by email for adding to projects
  static Future<User?> searchUserByEmail(String email) async {
    try {
      final response = await ApiService._get('/users/search?email=$email');
      final data = ApiService._handleResponse(response);
      return User.fromJson(data);
    } catch (e) {
      print('Search user by email error: $e');
      return null;
    }
  }
}

// Login Screen with HTTP integration
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isSignUp = false;
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 60),
                // Logo
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(60),
                  ),
                  child: Icon(
                    Icons.group_work,
                    size: 60,
                    color: Colors.blue.shade700,
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  'SynergySphere',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
                Text(
                  'Advanced Team Collaboration',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 48),

                if (_isSignUp)
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                if (_isSignUp) SizedBox(height: 16),

                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleSubmit,
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                      _isSignUp ? 'Sign Up' : 'Login',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isSignUp = !_isSignUp;
                    });
                  },
                  child: Text(
                    _isSignUp
                        ? 'Already have an account? Login'
                        : 'Don\'t have an account? Sign Up',
                  ),
                ),
                if (!_isSignUp)
                  TextButton(
                    onPressed: () {
                      // TODO: Implement forgot password
                    },
                    child: Text('Forgot Password?'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        if (_isSignUp) {
          // Sign up user
          await DatabaseService.createUser(
            _nameController.text.trim(),
            _emailController.text.trim(),
            _passwordController.text,
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Account created successfully!')),
          );
        } else {
          // Login user
          final user = await DatabaseService.authenticateUser(
            _emailController.text.trim(),
            _passwordController.text,
          );

          if (user == null) {
            throw Exception('Invalid credentials');
          }
        }

        Navigator.pushReplacementNamed(context, '/dashboard');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Authentication failed: ${e.toString()}')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }
}

// Project Dashboard with HTTP integration
class ProjectDashboard extends StatefulWidget {
  @override
  _ProjectDashboardState createState() => _ProjectDashboardState();
}

class _ProjectDashboardState extends State<ProjectDashboard> {
  List<Project> projects = [];
  bool _isLoading = true;
  User? currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserAndProjects();
  }

  void _loadUserAndProjects() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get current user
      currentUser = await DatabaseService.getCurrentUser();

      if (currentUser != null) {
        // Load user's projects
        final userProjects = await DatabaseService.getUserProjects(currentUser!.id);
        setState(() {
          projects = userProjects;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load projects: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Projects'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : projects.isEmpty
          ? _buildEmptyState()
          : _buildProjectList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateProjectDialog,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open,
            size: 80,
            color: Colors.grey.shade400,
          ),
          SizedBox(height: 16),
          Text(
            'No Projects Yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Create your first project to get started',
            style: TextStyle(color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectList() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: projects.length,
      itemBuilder: (context, index) {
        final project = projects[index];
        return Card(
          margin: EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              child: Icon(
                Icons.work,
                color: Colors.blue.shade700,
              ),
            ),
            title: Text(
              project.name,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4),
                Text(project.description),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.people, size: 16, color: Colors.grey.shade600),
                    SizedBox(width: 4),
                    Text(
                      '${project.memberIds.length} members',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(width: 16),
                    Icon(Icons.access_time, size: 16, color: Colors.grey.shade600),
                    SizedBox(width: 4),
                    Text(
                      _formatDate(project.createdAt),
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProjectDetailScreen(project: project),
                ),
              );
            },
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final difference = DateTime.now().difference(date).inDays;
    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else {
      return '${difference} days ago';
    }
  }

  void _showCreateProjectDialog() {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Create New Project'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Project Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty && currentUser != null) {
                try {
                  final newProject = Project(
                    id: 0, // Will be assigned by backend
                    name: nameController.text.trim(),
                    description: descriptionController.text.trim(),
                    memberIds: [currentUser!.id], // Creator is automatically a member
                    createdAt: DateTime.now(),
                    createdBy: currentUser!.id,
                  );

                  await DatabaseService.createProject(newProject);
                  Navigator.pop(context);
                  _loadUserAndProjects(); // Reload projects
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to create project: ${e.toString()}')),
                  );
                }
              }
            },
            child: Text('Create'),
          ),
        ],
      ),
    );
  }
}

// Project Detail Screen with HTTP integration
class ProjectDetailScreen extends StatefulWidget {
  final Project project;

  ProjectDetailScreen({required this.project});

  @override
  _ProjectDetailScreenState createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Task> tasks = [];
  List<Discussion> discussions = [];
  List<User> members = [];
  bool _isLoading = true;
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // Rebuild FAB when tab changes
    });
    _loadProjectData();
  }

  void _loadProjectData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load all project data concurrently
      final Future<List<Task>> tasksFuture = DatabaseService.getProjectTasks(widget.project.id);
      final Future<List<User>> membersFuture = DatabaseService.getProjectMembers(widget.project.id);
      final Future<List<Discussion>> discussionsFuture = DatabaseService.getProjectDiscussions(widget.project.id);

      final results = await Future.wait([
        tasksFuture,
        membersFuture,
        discussionsFuture,
      ]);

      setState(() {
        tasks = results[0] as List<Task>;
        members = results[1] as List<User>;
        discussions = results[2] as List<Discussion>;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load project data: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.project.name),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Tasks', icon: Icon(Icons.task)),
            Tab(text: 'Team', icon: Icon(Icons.people)),
            Tab(text: 'Chat', icon: Icon(Icons.chat)),
          ],
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : TabBarView(
        controller: _tabController,
        children: [
          _buildTasksTab(),
          _buildTeamTab(),
          _buildChatTab(),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildFloatingActionButton() {
    int currentIndex = _tabController.index;

    switch (currentIndex) {
      case 0: // Tasks tab
        return FloatingActionButton(
          onPressed: () => _showTaskDialog(),
          heroTag: "tasks_fab",
          child: Icon(Icons.add_task),
        );
      case 1: // Team tab
        return FloatingActionButton(
          onPressed: _showAddMemberDialog,
          heroTag: "team_fab",
          child: Icon(Icons.person_add),
        );
      case 2: // Chat tab
        return FloatingActionButton(
          onPressed: _showCreateDiscussionDialog,
          heroTag: "chat_fab",
          child: Icon(Icons.chat),
        );
      default:
        return FloatingActionButton(
          onPressed: () => _showTaskDialog(),
          heroTag: "default_fab",
          child: Icon(Icons.add),
        );
    }
  }

  Widget _buildTasksTab() {
    return Column(
      children: [
        // Task Progress Summary
        Container(
          margin: EdgeInsets.all(16),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatusCount('To Do', tasks.where((t) => t.status == TaskStatus.toDo).length, Colors.grey),
              _buildStatusCount('In Progress', tasks.where((t) => t.status == TaskStatus.inProgress).length, Colors.orange),
              _buildStatusCount('Done', tasks.where((t) => t.status == TaskStatus.done).length, Colors.green),
            ],
          ),
        ),

        // Task List
        Expanded(
          child: tasks.isEmpty
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.assignment, size: 64, color: Colors.grey.shade400),
                SizedBox(height: 16),
                Text('No tasks yet', style: TextStyle(fontSize: 18, color: Colors.grey.shade600)),
                SizedBox(height: 8),
                Text('Add your first task to get started', style: TextStyle(color: Colors.grey.shade500)),
              ],
            ),
          )
              : ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: tasks.length,
            itemBuilder: (context, index) => _buildTaskCard(tasks[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusCount(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildTaskCard(Task task) {
    Color statusColor = task.status == TaskStatus.toDo
        ? Colors.grey
        : task.status == TaskStatus.inProgress
        ? Colors.orange
        : Colors.green;

    // Find assignee from members list
    User? assignee;
    if (task.assigneeId != null) {
      try {
        assignee = members.firstWhere((m) => m.id == task.assigneeId);
      } catch (e) {
        assignee = null;
      }
    }

    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 8,
          height: 40,
          decoration: BoxDecoration(
            color: statusColor,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        title: Text(task.title, style: TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(task.description),
            SizedBox(height: 8),
            Row(
              children: [
                if (assignee != null) ...[
                  CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.blue.shade100,
                    child: Text(
                      assignee.name.isNotEmpty ? assignee.name[0].toUpperCase() : 'U',
                      style: TextStyle(fontSize: 10, color: Colors.blue.shade700),
                    ),
                  ),
                  SizedBox(width: 8),
                ],
                if (task.dueDate != null) ...[
                  Icon(Icons.schedule, size: 14, color: Colors.grey.shade600),
                  SizedBox(width: 4),
                  Text(
                    '${task.dueDate!.day}/${task.dueDate!.month}',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 16),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'status',
              child: Row(
                children: [
                  Icon(Icons.sync, size: 16),
                  SizedBox(width: 8),
                  Text('Change Status'),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            if (value == 'edit') {
              _showTaskDialog(task: task);
            } else if (value == 'status') {
              _showStatusDialog(task);
            }
          },
        ),
        onTap: () => _showTaskDetail(task),
      ),
    );
  }

  Widget _buildTeamTab() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Team Members (${members.length})',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              ElevatedButton.icon(
                onPressed: _showAddMemberDialog,
                icon: Icon(Icons.person_add, size: 16),
                label: Text('Add Member'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: members.length,
            itemBuilder: (context, index) {
              final member = members[index];
              return Card(
                margin: EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade100,
                    child: Text(
                      member.name[0].toUpperCase(),
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(member.name),
                  subtitle: Text(member.email),
                  trailing: PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'remove',
                        child: Row(
                          children: [
                            Icon(Icons.remove_circle, size: 16, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Remove', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) async {
                      if (value == 'remove') {
                        try {
                          await DatabaseService.removeProjectMember(widget.project.id, member.id);
                          _loadProjectData();
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to remove member: ${e.toString()}')),
                          );
                        }
                      }
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildChatTab() {
    return Column(
      children: [
        Expanded(
          child: discussions.isEmpty
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey.shade400),
                SizedBox(height: 16),
                Text('No discussions yet', style: TextStyle(fontSize: 18, color: Colors.grey.shade600)),
                SizedBox(height: 8),
                Text('Start a conversation with your team', style: TextStyle(color: Colors.grey.shade500)),
              ],
            ),
          )
              : ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: discussions.length,
            itemBuilder: (context, index) {
              final discussion = discussions[index];
              return Card(
                margin: EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green.shade100,
                    child: Icon(Icons.chat, color: Colors.green.shade700),
                  ),
                  title: Text(discussion.title),
                  subtitle: Text('${discussion.messages.length} messages'),
                  trailing: Text(
                    '${discussion.createdAt.day}/${discussion.createdAt.month}',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  onTap: () {
                    // TODO: Navigate to discussion detail
                  },
                ),
              );
            },
          ),
        ),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.grey.shade300)),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty) {
                      _sendMessage(value.trim());
                      _messageController.clear();
                    }
                  },
                ),
              ),
              SizedBox(width: 8),
              FloatingActionButton(
                mini: true,
                onPressed: () {
                  if (_messageController.text.trim().isNotEmpty) {
                    _sendMessage(_messageController.text.trim());
                    _messageController.clear();
                  }
                },
                child: Icon(Icons.send, size: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _sendMessage(String message) async {
    try {
      final currentUser = await DatabaseService.getCurrentUser();
      if (currentUser != null && discussions.isNotEmpty) {
        final messageObj = DiscussionMessage(
          id: 0, // Will be assigned by backend
          discussionId: discussions.first.id, // Send to first discussion for simplicity
          message: message,
          authorId: currentUser.id,
          timestamp: DateTime.now(),
        );

        await DatabaseService.addDiscussionMessage(messageObj);
        _loadProjectData(); // Reload to show new message
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send message: ${e.toString()}')),
      );
    }
  }

  void _showCreateDiscussionDialog() {
    final titleController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Start New Discussion'),
        content: TextField(
          controller: titleController,
          decoration: InputDecoration(
            labelText: 'Discussion Topic',
            border: OutlineInputBorder(),
            hintText: 'What would you like to discuss?',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.trim().isNotEmpty) {
                try {
                  final currentUser = await DatabaseService.getCurrentUser();
                  if (currentUser != null) {
                    final discussion = Discussion(
                      id: 0, // Will be assigned by backend
                      projectId: widget.project.id,
                      title: titleController.text.trim(),
                      messages: [],
                      createdAt: DateTime.now(),
                      createdBy: currentUser.id,
                    );

                    await DatabaseService.createDiscussion(discussion);
                    Navigator.pop(context);
                    _loadProjectData();
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to create discussion: ${e.toString()}')),
                  );
                }
              }
            },
            child: Text('Start Discussion'),
          ),
        ],
      ),
    );
  }

  void _showTaskDialog({Task? task}) {
    final titleController = TextEditingController(text: task?.title ?? '');
    final descriptionController = TextEditingController(text: task?.description ?? '');
    int? selectedAssignee = task?.assigneeId;
    DateTime? selectedDate = task?.dueDate;
    TaskStatus selectedStatus = task?.status ?? TaskStatus.toDo;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(task == null ? 'Create Task' : 'Edit Task'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Task Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<int?>(
                  value: selectedAssignee,
                  decoration: InputDecoration(
                    labelText: 'Assignee',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    DropdownMenuItem<int?>(
                      value: null,
                      child: Text('Unassigned'),
                    ),
                    ...members.map((member) => DropdownMenuItem<int?>(
                      value: member.id,
                      child: Text(member.name),
                    )),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedAssignee = value;
                    });
                  },
                ),
                if (task != null) ...[
                  SizedBox(height: 16),
                  DropdownButtonFormField<TaskStatus>(
                    value: selectedStatus,
                    decoration: InputDecoration(
                      labelText: 'Status',
                      border: OutlineInputBorder(),
                    ),
                    items: TaskStatus.values.map((status) {
                      String statusText = status == TaskStatus.toDo
                          ? 'To Do'
                          : status == TaskStatus.inProgress
                          ? 'In Progress'
                          : 'Done';
                      return DropdownMenuItem<TaskStatus>(
                        value: status,
                        child: Text(statusText),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedStatus = value;
                        });
                      }
                    },
                  ),
                ],
                SizedBox(height: 16),
                InkWell(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: selectedDate ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(Duration(days: 365)),
                    );
                    if (date != null) {
                      setState(() {
                        selectedDate = date;
                      });
                    }
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Due Date',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    child: Text(
                      selectedDate != null
                          ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                          : 'Select date',
                      style: TextStyle(
                        color: selectedDate != null ? Colors.black : Colors.grey.shade600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.isNotEmpty) {
                  try {
                    final taskObj = Task(
                      id: task?.id ?? 0,
                      title: titleController.text.trim(),
                      description: descriptionController.text.trim(),
                      projectId: widget.project.id,
                      assigneeId: selectedAssignee,
                      dueDate: selectedDate,
                      status: selectedStatus,
                      createdAt: task?.createdAt ?? DateTime.now(),
                    );

                    if (task == null) {
                      await DatabaseService.createTask(taskObj);
                    } else {
                      await DatabaseService.updateTask(taskObj);
                    }

                    Navigator.pop(context);
                    _loadProjectData();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to save task: ${e.toString()}')),
                    );
                  }
                }
              },
              child: Text(task == null ? 'Create' : 'Update'),
            ),
          ],
        ),
      ),
    );
  }

  void _showStatusDialog(Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Change Task Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: TaskStatus.values.map((status) {
            String statusText = status == TaskStatus.toDo
                ? 'To Do'
                : status == TaskStatus.inProgress
                ? 'In Progress'
                : 'Done';

            return RadioListTile<TaskStatus>(
              title: Text(statusText),
              value: status,
              groupValue: task.status,
              onChanged: (TaskStatus? value) async {
                if (value != null) {
                  try {
                    final updatedTask = task.copyWith(status: value);
                    await DatabaseService.updateTask(updatedTask);
                    Navigator.pop(context);
                    _loadProjectData();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to update task: ${e.toString()}')),
                    );
                  }
                }
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showTaskDetail(Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailScreen(task: task, members: members),
      ),
    );
  }

  void _showAddMemberDialog() {
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Team Member'),
        content: TextField(
          controller: emailController,
          decoration: InputDecoration(
            labelText: 'Email Address',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.email),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (emailController.text.isNotEmpty) {
                try {
                  // First, search for user by email
                  final user = await DatabaseService.searchUserByEmail(emailController.text.trim());

                  if (user != null) {
                    await DatabaseService.addProjectMember(widget.project.id, user.id);
                    Navigator.pop(context);
                    _loadProjectData();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('User not found with this email')),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to add member: ${e.toString()}')),
                  );
                }
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _messageController.dispose();
    super.dispose();
  }
}

// Task Detail Screen with HTTP integration
class TaskDetailScreen extends StatefulWidget {
  final Task task;
  final List<User> members;

  TaskDetailScreen({required this.task, required this.members});

  @override
  _TaskDetailScreenState createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late Task currentTask;

  @override
  void initState() {
    super.initState();
    currentTask = widget.task;
  }

  @override
  Widget build(BuildContext context) {
    final assignee = widget.members.firstWhere(
          (member) => member.id == currentTask.assigneeId,
      orElse: () => User(id: 0, name: 'Unassigned', email: ''),
    );

    Color statusColor = currentTask.status == TaskStatus.toDo
        ? Colors.grey
        : currentTask.status == TaskStatus.inProgress
        ? Colors.orange
        : Colors.green;

    String statusText = currentTask.status == TaskStatus.toDo
        ? 'To Do'
        : currentTask.status == TaskStatus.inProgress
        ? 'In Progress'
        : 'Done';

    return Scaffold(
      appBar: AppBar(
        title: Text('Task Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // TODO: Edit task
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Task Title
            Text(
              currentTask.title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),

            // Status Badge
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: statusColor),
              ),
              child: Text(
                statusText,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 24),

            // Description Section
            _buildSection(
              'Description',
              Icons.description,
              currentTask.description.isNotEmpty
                  ? currentTask.description
                  : 'No description provided',
            ),

            // Assignee Section
            _buildSection(
              'Assignee',
              Icons.person,
              assignee.name,
              trailing: assignee.id != 0
                  ? CircleAvatar(
                backgroundColor: Colors.blue.shade100,
                child: Text(
                  assignee.name[0].toUpperCase(),
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
                  : null,
            ),

            // Due Date Section
            if (currentTask.dueDate != null)
              _buildSection(
                'Due Date',
                Icons.schedule,
                '${currentTask.dueDate!.day}/${currentTask.dueDate!.month}/${currentTask.dueDate!.year}',
              ),

            // Created Info
            _buildSection(
              'Created',
              Icons.info,
              '${currentTask.createdAt.day}/${currentTask.createdAt.month}/${currentTask.createdAt.year}',
            ),

            SizedBox(height: 32),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showStatusChangeDialog(),
                    icon: Icon(Icons.sync),
                    label: Text('Change Status'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _showDeleteConfirmation();
                    },
                    icon: Icon(Icons.delete, color: Colors.red),
                    label: Text('Delete', style: TextStyle(color: Colors.red)),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, String content, {Widget? trailing}) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: Colors.blue.shade700),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue.shade700,
                ),
              ),
              if (trailing != null) ...[
                Spacer(),
                trailing,
              ],
            ],
          ),
          SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  void _showStatusChangeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Change Task Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: TaskStatus.values.map((status) {
            String statusText = status == TaskStatus.toDo
                ? 'To Do'
                : status == TaskStatus.inProgress
                ? 'In Progress'
                : 'Done';

            return RadioListTile<TaskStatus>(
              title: Text(statusText),
              value: status,
              groupValue: currentTask.status,
              onChanged: (TaskStatus? value) {
                if (value != null) {
                  setState(() {
                    currentTask = currentTask.copyWith(status: value);
                  });
                  // TODO: Update task status in database
                  Navigator.pop(context);
                }
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Task'),
        content: Text('Are you sure you want to delete this task? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Delete task from database
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to project detail
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// Profile Screen
class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Mock user data
    final user = User(
      id: 1,
      name: 'John Doe',
      email: 'john.doe@example.com',
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Avatar
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.blue.shade100,
                    child: Text(
                      user.name[0].toUpperCase(),
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    user.name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    user.email,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),

            // Profile Options
            _buildProfileOption(
              icon: Icons.person,
              title: 'Edit Profile',
              onTap: () {
                // TODO: Navigate to edit profile
              },
            ),
            _buildProfileOption(
              icon: Icons.notifications,
              title: 'Notifications',
              onTap: () {
                // TODO: Navigate to notification settings
              },
            ),
            _buildProfileOption(
              icon: Icons.security,
              title: 'Security',
              onTap: () {
                // TODO: Navigate to security settings
              },
            ),
            _buildProfileOption(
              icon: Icons.help,
              title: 'Help & Support',
              onTap: () {
                // TODO: Navigate to help
              },
            ),
            _buildProfileOption(
              icon: Icons.info,
              title: 'About',
              onTap: () {
                _showAboutDialog(context);
              },
            ),
            SizedBox(height: 24),

            // Logout Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showLogoutDialog(context),
                icon: Icon(Icons.logout, color: Colors.red),
                label: Text('Logout', style: TextStyle(color: Colors.red)),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  side: BorderSide(color: Colors.red),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue.shade700),
        title: Text(title),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('About SynergySphere'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('SynergySphere MVP'),
            SizedBox(height: 8),
            Text('Version: 1.0.0'),
            SizedBox(height: 8),
            Text('Advanced Team Collaboration Platform'),
            SizedBox(height: 16),
            Text(
              'Built with Flutter for seamless team collaboration and project management.',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Clear user session
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                    (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }
}
