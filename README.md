## TaskCollab
Demo - [TaskCollab](https://taskcollab.herokuapp.com "TaskCollab")
![taskcollab](https://github.com/demesvardestin/sinatra-sample-app/raw/master/public/images/task_collab_update.png "TaskCollab")

### App Details
This is a simple project collaboration app built with Sinatra, providing the following
features:

- authentication (bcrypt)
- task creation/deletion
- ability to join a task group
- ability to post updates to the group
- ability to privately message collaborators in real-time
- ability to invite potential collaborators via email

The following libraries/extensions were used:

```
ActiveRecord (ORM)
PostgreSQL (production database)
SQLITE (development database)
Pony (email)
Puma (server)
Vanilla CSS/Javascript (no frameworks!)
Nginx (development/test)
```

The app demonstrates key ruby/rails components such as:

- associations (one-to-one, one-to-many, many-to-many)
- crud functionality
- http requests/responses
- sessions/cookies
- flash messages
- basic security
- routing

My primary focus while building TaskCollab was to avoid using major frameworks
such as Bootstrap, React, or Rails in order to demonstrate my understanding
of some the most important lower-level layers of web development platforms/protocols.