
## Example folder structure

backend/src/Application/Features/Todos/

├── CreateTodo/
│   ├── Command.cs
│   ├── Validator.cs
│   ├── Handler.cs
│   ├── Endpoint.cs
│   └── Response.cs
│
├── GetTodo/
│   ├── Query.cs
│   ├── Handler.cs
│   ├── Endpoint.cs
│   └── Response.cs
│
└── DeleteTodo/
    ├── Command.cs
    ├── Handler.cs
    └── Endpoint.cs

# Example Front End

frontend/src/features/todos/

├── api/
│   ├── createTodo.ts
│   └── getTodos.ts
│
├── components/
│   ├── TodoList.tsx
│   └── TodoItem.tsx
│
├── hooks/
│   └── useTodos.ts
│
├── pages/
│   └── TodosPage.tsx
│
├── types/
│   └── todo.ts
│
└── index.ts