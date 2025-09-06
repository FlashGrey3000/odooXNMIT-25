import 'package:flutter/material.dart';

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

// Models
class User {
  final String id;
  final String name;
  final String email;
  final String? avatar;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
  });
}

class Project {
  final String id;
  final String name;
  final String description;
  final List<String> memberIds;
  final DateTime createdAt;
  final String createdBy;

  Project({
    required this.id,
    required this.name,
    required this.description,
    required this.memberIds,
    required this.createdAt,
    required this.createdBy,
  });
}

enum TaskStatus { toDo, inProgress, done }

class Task {
  final String id;
  final String title;
  final String description;
  final String projectId;
  final String? assigneeId;
  final DateTime? dueDate;
  final TaskStatus status;
  final DateTime createdAt;
  final String createdBy;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.projectId,
    this.assigneeId,
    this.dueDate,
    required this.status,
    required this.createdAt,
    required this.createdBy,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    String? projectId,
    String? assigneeId,
    DateTime? dueDate,
    TaskStatus? status,
    DateTime? createdAt,
    String? createdBy,
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
      createdBy: createdBy ?? this.createdBy,
    );
  }
}

class Discussion {
  final String id;
  final String projectId;
  final String title;
  final List<DiscussionMessage> messages;
  final DateTime createdAt;
  final String createdBy;

  Discussion({
    required this.id,
    required this.projectId,
    required this.title,
    required this.messages,
    required this.createdAt,
    required this.createdBy,
  });
}

class DiscussionMessage {
  final String id;
  final String discussionId;
  final String message;
  final String authorId;
  final DateTime timestamp;

  DiscussionMessage({
    required this.id,
    required this.discussionId,
    required this.message,
    required this.authorId,
    required this.timestamp,
  });
}

// Database Service (Function signatures only)
class DatabaseService {
  // User Management
  static Future<User?> authenticateUser(String email, String password) async {
    // TODO: Implement authentication logic
    throw UnimplementedError();
  }

  static Future<User> createUser(String name, String email, String password) async {
    // TODO: Implement user creation
    throw UnimplementedError();
  }

  static Future<User?> getCurrentUser() async {
    // TODO: Get current logged in user
    throw UnimplementedError();
  }

  static Future<void> logoutUser() async {
    // TODO: Implement logout
    throw UnimplementedError();
  }

  // Project Management
  static Future<List<Project>> getUserProjects(String userId) async {
    // TODO: Get projects for user
    throw UnimplementedError();
  }

  static Future<Project> createProject(Project project) async {
    // TODO: Create new project
    throw UnimplementedError();
  }

  static Future<Project> getProject(String projectId) async {
    // TODO: Get specific project
    throw UnimplementedError();
  }

  static Future<List<User>> getProjectMembers(String projectId) async {
    // TODO: Get project members
    throw UnimplementedError();
  }

  static Future<void> addProjectMember(String projectId, String userId) async {
    // TODO: Add member to project
    throw UnimplementedError();
  }

  // Task Management
  static Future<List<Task>> getProjectTasks(String projectId) async {
    // TODO: Get tasks for project
    throw UnimplementedError();
  }

  static Future<Task> createTask(Task task) async {
    // TODO: Create new task
    throw UnimplementedError();
  }

  static Future<Task> updateTask(Task task) async {
    // TODO: Update existing task
    throw UnimplementedError();
  }

  static Future<void> deleteTask(String taskId) async {
    // TODO: Delete task
    throw UnimplementedError();
  }

  // Discussion Management
  static Future<List<Discussion>> getProjectDiscussions(String projectId) async {
    // TODO: Get discussions for project
    throw UnimplementedError();
  }

  static Future<Discussion> createDiscussion(Discussion discussion) async {
    // TODO: Create new discussion
    throw UnimplementedError();
  }

  static Future<DiscussionMessage> addDiscussionMessage(DiscussionMessage message) async {
    // TODO: Add message to discussion
    throw UnimplementedError();
  }
}

// Login Screen
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
          // TODO: Implement sign up
          await Future.delayed(Duration(seconds: 1)); // Simulate API call
          Navigator.pushReplacementNamed(context, '/dashboard');
        } else {
          // TODO: Implement login
          await Future.delayed(Duration(seconds: 1)); // Simulate API call
          Navigator.pushReplacementNamed(context, '/dashboard');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Authentication failed. Please try again.')),
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

// Project Dashboard
class ProjectDashboard extends StatefulWidget {
  @override
  _ProjectDashboardState createState() => _ProjectDashboardState();
}

class _ProjectDashboardState extends State<ProjectDashboard> {
  List<Project> projects = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  void _loadProjects() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Load projects from database
      await Future.delayed(Duration(seconds: 1)); // Simulate API call

      // Mock data for demonstration
      projects = [
        Project(
          id: '1',
          name: 'Mobile App Development',
          description: 'Building the SynergySphere mobile application',
          memberIds: ['1', '2', '3'],
          createdAt: DateTime.now().subtract(Duration(days: 5)),
          createdBy: '1',
        ),
        Project(
          id: '2',
          name: 'Website Redesign',
          description: 'Redesigning company website with modern UI',
          memberIds: ['1', '4'],
          createdAt: DateTime.now().subtract(Duration(days: 2)),
          createdBy: '1',
        ),
      ];
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load projects')),
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
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                // TODO: Create project in database
                Navigator.pop(context);
                _loadProjects();
              }
            },
            child: Text('Create'),
          ),
        ],
      ),
    );
  }
}

// Project Detail Screen - COMPLETELY REWRITTEN
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
      // TODO: Load data from database
      await Future.delayed(Duration(seconds: 1)); // Simulate API call

      // Mock data
      setState(() {
        tasks = [
          Task(
            id: '1',
            title: 'Design Login Screen',
            description: 'Create wireframes and implement login UI',
            projectId: widget.project.id,
            assigneeId: '1',
            dueDate: DateTime.now().add(Duration(days: 3)),
            status: TaskStatus.inProgress,
            createdAt: DateTime.now().subtract(Duration(days: 1)),
            createdBy: '1',
          ),
          Task(
            id: '2',
            title: 'Set up Database',
            description: 'Configure database and create initial schema',
            projectId: widget.project.id,
            assigneeId: '2',
            dueDate: DateTime.now().add(Duration(days: 5)),
            status: TaskStatus.toDo,
            createdAt: DateTime.now().subtract(Duration(hours: 12)),
            createdBy: '1',
          ),
        ];

        members = [
          User(id: '1', name: 'John Doe', email: 'john@example.com'),
          User(id: '2', name: 'Jane Smith', email: 'jane@example.com'),
        ];

        discussions = [
          Discussion(
            id: '1',
            projectId: widget.project.id,
            title: 'Project Planning',
            messages: [],
            createdAt: DateTime.now().subtract(Duration(days: 2)),
            createdBy: '1',
          ),
        ];
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load project data')),
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
                    onSelected: (value) {
                      if (value == 'remove') {
                        // TODO: Remove member
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

  void _sendMessage(String message) {
    // TODO: Implement send message functionality
    print('Sending message: $message');
    // After implementing, reload discussions
    // _loadProjectData();
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
            onPressed: () {
              if (titleController.text.trim().isNotEmpty) {
                // TODO: Create new discussion
                Navigator.pop(context);
                _loadProjectData();
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
    String? selectedAssignee = task?.assigneeId;
    DateTime? selectedDate = task?.dueDate;

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
                DropdownButtonFormField<String>(
                  value: selectedAssignee,
                  decoration: InputDecoration(
                    labelText: 'Assignee',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    DropdownMenuItem<String>(
                      value: null,
                      child: Text('Unassigned'),
                    ),
                    ...members.map((member) => DropdownMenuItem<String>(
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
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  // TODO: Create/update task in database
                  Navigator.pop(context);
                  _loadProjectData();
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
              onChanged: (TaskStatus? value) {
                if (value != null) {
                  // TODO: Update task status in database
                  Navigator.pop(context);
                  _loadProjectData();
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
            onPressed: () {
              if (emailController.text.isNotEmpty) {
                // TODO: Add member to project
                Navigator.pop(context);
                _loadProjectData();
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

// Task Detail Screen
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
      orElse: () => User(id: '', name: 'Unassigned', email: ''),
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
              trailing: assignee.id.isNotEmpty
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
                      // TODO: Delete task
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
      id: '1',
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
