CREATE TABLE users (
         user_id       INT AUTO_INCREMENT,
         name          VARCHAR(100) NOT NULL,
         email         VARCHAR(100) NOT NULL,
         password_hash VARCHAR(255) NOT NULL,
         created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
         CONSTRAINT users_user_id_pk PRIMARY KEY (user_id),
         CONSTRAINT users_email_uk UNIQUE (email)
 );

CREATE TABLE projects (
    project_id INT AUTO_INCREMENT,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    created_by INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    constraint projects_project_id_pk PRIMARY KEY,
    CONSTRAINT projects_created_by_fk FOREIGN KEY (created_by)
        REFERENCES users(user_id)
        ON DELETE CASCADE
);

CREATE TABLE project_members (
    project_id INT NOT NULL,
    user_id INT NOT NULL,
    role ENUM('member','admin','owner') DEFAULT 'member',
    CONSTRAINT project_members_pk PRIMARY KEY (project_id, user_id),
    CONSTRAINT project_members_project_id_fk FOREIGN KEY (project_id)
        REFERENCES projects(project_id)
        ON DELETE CASCADE,
    CONSTRAINT project_members_user_id_fk FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE
);

CREATE TABLE tasks (
    task_id INT AUTO_INCREMENT,
    project_id INT NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    assignee_id INT,
    status ENUM('To-Do','In Progress','Done') DEFAULT 'To-Do',
    due_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT tasks_task_id_pk PRIMARY KEY (task_id),
    CONSTRAINT tasks_project_id_fk FOREIGN KEY (project_id)
        REFERENCES projects(project_id)
        ON DELETE CASCADE,
    CONSTRAINT tasks_assignee_id_fk FOREIGN KEY (assignee_id)
        REFERENCES users(user_id)
        ON DELETE SET NULL
);


